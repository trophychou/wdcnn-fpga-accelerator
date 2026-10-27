#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <sstream>
#include <cmath>
#include <map>
#include <set>
#include <algorithm>
#include <ap_int.h>
#include <hls_stream.h>
#include <ap_axi_sdata.h>
#include "config.hpp"

using namespace std;

string find_path(const string& b) {
    const char* ps[] = {
        "",
        "../",
        "../../",
        "../../../",
        "../../../../",
        "../../../../../",
        "../../../../../../"
    };
    for (int i = 0; i < 7; i++) {
        string cand = string(ps[i]) + b;
        ifstream t(cand);
        if (t.good()) return cand;
    }
    return "";
}

template<typename T>
void load_flat(const string& fn, T* arr, int s) {
    string p = find_path(fn);
    if (p.empty()) {
        cout << "[Error] CSV missing: " << fn << endl;
        return;
    }
    ifstream f(p); string l, v; int i = 0;
    while (getline(f, l)) {
        stringstream ss(l);
        while (getline(ss, v, ',')) {
            if (i < s) arr[i++] = (T)stof(v);
        }
    }
}

struct TestData {
    vector<vector<float>> inputs;
    vector<int> labels;
};

TestData load_dataset(const string& p, int total) {
    TestData db;
    string rp = find_path(p);
    if (rp.empty()) {
        cout << "[Fatal] Dataset missing: " << p << endl;
        return db;
    }

    vector<vector<float>> all_inputs;
    vector<int> all_labels;
    vector<vector<int>> class_indices(4);

    ifstream f(rp);
    string l;
    int row_id = 0;
    while (getline(f, l)) {
        stringstream ss(l);
        string v;
        vector<float> r;
        while (getline(ss, v, ',')) r.push_back(stof(v));
        if ((int)r.size() < INPUT_ELEMS + 1) continue;
        int label = (int)r.back();
        if (label < 0 || label >= 4) continue;
        all_inputs.push_back(vector<float>(r.begin(), r.begin() + INPUT_ELEMS));
        all_labels.push_back(label);
        class_indices[label].push_back(row_id);
        row_id++;
    }

    if ((int)all_inputs.size() == 0) {
        cout << "[Fatal] No valid sample found in dataset." << endl;
        return db;
    }

    const string policy = "balanced";
    vector<int> selected_ids;
    vector<int> cursor(4, 0);
    vector<char> used(all_inputs.size(), 0);

    if (policy == "balanced") {
        bool progressed = true;
        while ((int)selected_ids.size() < total && progressed) {
            progressed = false;
            for (int c = 0; c < 4; c++) {
                if ((int)selected_ids.size() >= total) break;
                if (cursor[c] < (int)class_indices[c].size()) {
                    int rid = class_indices[c][cursor[c]++];
                    if (!used[rid]) {
                        selected_ids.push_back(rid);
                        used[rid] = 1;
                        progressed = true;
                    }
                }
            }
        }

        if ((int)selected_ids.size() < total) {
            cout << "[Warning] Balanced policy could not fully satisfy requested sample count."
                 << " Fallback to sequential fill for the remaining slots." << endl;
            for (int i = 0; i < (int)all_inputs.size() && (int)selected_ids.size() < total; i++) {
                if (!used[i]) {
                    selected_ids.push_back(i);
                    used[i] = 1;
                }
            }
        }
    } else {
        for (int i = 0; i < (int)all_inputs.size() && (int)selected_ids.size() < total; i++) {
            selected_ids.push_back(i);
        }
    }

    for (int id : selected_ids) {
        db.inputs.push_back(all_inputs[id]);
        db.labels.push_back(all_labels[id]);
    }

    cout << "[Dataset] policy=" << policy
         << ", requested=" << total
         << ", loaded=" << db.inputs.size() << endl;
    map<int, int> stat;
    for (int y : db.labels) stat[y]++;
    cout << "[Dataset] label histogram:";
    for (auto &kv : stat) cout << " class" << kv.first << "=" << kv.second;
    cout << endl;

    return db;
}

void push_samples(
    hls::stream<ap_axiu<AXI_WIDTH_IN,0,0,0>>& in,
    const TestData& db,
    int start,
    int count
) {
    const int loaded = (int)db.inputs.size();
    for (int n = 0; n < count; n++) {
        const vector<float>& x = db.inputs[(start + n) % loaded];

        for (int base = 0; base < INPUT_ELEMS; base += 64) {
            ap_axiu<AXI_WIDTH_IN,0,0,0> pkt;
            ap_uint<AXI_WIDTH_IN> word = 0;

            for (int j = 0; j < 64; j++) {
                int idx = base + j;
                ap_int<8> q = 0;
                if (idx < INPUT_ELEMS) {
                    float scaled = x[idx] * S_IN_SCALE;
                    int qi = (int)std::round(scaled);
                    if (qi > 127) qi = 127;
                    if (qi < -128) qi = -128;
                    q = (ap_int<8>)qi;
                }
                word.range((j+1)*8-1, j*8) = (ap_uint<8>)q;
            }

            pkt.data = word;
            pkt.keep = -1;
            pkt.strb = -1;
            pkt.user = 0;
            pkt.id = 0;
            pkt.dest = 0;
            pkt.last = ((n == count - 1) && (base + 64 >= INPUT_ELEMS));
            in.write(pkt);
        }
    }
}

int decode_output(hls::stream<ap_axiu<AXI_WIDTH_OUT,0,0,0>>& out_s) {
    int max_s = -999999;
    int pred = 0;
    for (int ow = 0; ow < 1; ow++) {
        ap_axiu<32,0,0,0> p = out_s.read();
        for (int k = 0; k < 4; k++) {
            int c = ow * 4 + k;
            if (c >= 4) break;
            int s = (int)((int8_t)p.data.range((k+1)*8-1, k*8));
            if (s > max_s) { max_s = s; pred = c; }
        }
    }
    return pred;
}

void synthesis_top(
    hls::stream<ap_axiu<AXI_WIDTH_IN,0,0,0>>& in,
    hls::stream<ap_axiu<AXI_WIDTH_OUT,0,0,0>>& out,
    const ap_int<L1_W_BIT>* w1, const ap_int<16>* i1, const ap_int<32>* b1, const ap_int<L2_W_BIT>* w2, const ap_int<16>* i2, const ap_int<32>* b2, const ap_int<L3_W_BIT>* w3, const ap_int<16>* i3, const ap_int<32>* b3, const ap_int<L4_W_BIT>* w4, const ap_int<16>* i4, const ap_int<32>* b4, const ap_int<L5_W_BIT>* w5, const ap_int<16>* i5, const ap_int<32>* b5, const ap_int<L6_W_BIT>* w6, const ap_int<16>* i6, const ap_int<32>* b6, const ap_int<L7_W_BIT>* w7, const ap_int<16>* i7, const ap_int<32>* b7,
    unsigned int n, bool r);

int main() {
    cout << "=============================================" << endl;
    cout << " AnyBit V20 | Cold/Steady Split Testbench" << endl;
    cout << "=============================================" << endl;

    static ap_int<L1_W_BIT> w1[1024];
    static ap_int<16> i1[16];
    static ap_int<32> b1[16];
    static ap_int<L2_W_BIT> w2[1536];
    static ap_int<16> i2[32];
    static ap_int<32> b2[32];
    static ap_int<L3_W_BIT> w3[6144];
    static ap_int<16> i3[64];
    static ap_int<32> b3[64];
    static ap_int<L4_W_BIT> w4[12288];
    static ap_int<16> i4[64];
    static ap_int<32> b4[64];
    static ap_int<L5_W_BIT> w5[12288];
    static ap_int<16> i5[64];
    static ap_int<32> b5[64];
    static ap_int<L6_W_BIT> w6[134400];
    static ap_int<16> i6[100];
    static ap_int<32> b6[100];
    static ap_int<L7_W_BIT> w7[400];
    static ap_int<16> i7[4];
    static ap_int<32> b7[4];

    const string wp = "weights_csv/";
    load_flat(wp+"01_Conv1_w.csv", w1, 1024);
    load_flat(wp+"01_Conv1_b.csv", b1, 16);
    for (int k = 0; k < 16; k++) i1[k] = L1_INC;
    load_flat(wp+"02_Conv2_w.csv", w2, 1536);
    load_flat(wp+"02_Conv2_b.csv", b2, 32);
    for (int k = 0; k < 32; k++) i2[k] = L2_INC;
    load_flat(wp+"03_Conv3_w.csv", w3, 6144);
    load_flat(wp+"03_Conv3_b.csv", b3, 64);
    for (int k = 0; k < 64; k++) i3[k] = L3_INC;
    load_flat(wp+"04_Conv4_w.csv", w4, 12288);
    load_flat(wp+"04_Conv4_b.csv", b4, 64);
    for (int k = 0; k < 64; k++) i4[k] = L4_INC;
    load_flat(wp+"05_Conv5_w.csv", w5, 12288);
    load_flat(wp+"05_Conv5_b.csv", b5, 64);
    for (int k = 0; k < 64; k++) i5[k] = L5_INC;
    load_flat(wp+"06_FC1_w.csv", w6, 134400);
    load_flat(wp+"06_FC1_b.csv", b6, 100);
    for (int k = 0; k < 100; k++) i6[k] = L6_INC;
    load_flat(wp+"07_FC2_w.csv", w7, 400);
    load_flat(wp+"07_FC2_b.csv", b7, 4);
    for (int k = 0; k < 4; k++) i7[k] = L7_INC;

    TestData db = load_dataset("data/XJTY_test_amp.csv", 240);
    int loaded_N = (int)db.inputs.size();
    int N = 240;
    if (loaded_N == 0) {
        cout << "[Fatal] No data loaded." << endl;
        return 1;
    }

    cout << "\n[Cold Start] Running 1 sample with weight reload..." << endl;
    {
        hls::stream<ap_axiu<AXI_WIDTH_IN,0,0,0>> cs_in;
        hls::stream<ap_axiu<AXI_WIDTH_OUT,0,0,0>> cs_out;
        push_samples(cs_in, db, 0, 1);
        synthesis_top(cs_in, cs_out, w1, i1, b1, w2, i2, b2, w3, i3, b3, w4, i4, b4, w5, i5, b5, w6, i6, b6, w7, i7, b7, 1, true);
        int pred = decode_output(cs_out);
        cout << "[Cold Start] Sample0: True=" << db.labels[0]
             << " Pred=" << pred
             << (pred == db.labels[0] ? " [OK]" : " [FAIL]") << endl;
        cout << "[Cold Start] Done. (This latency includes weight loading)" << endl;
    }

    cout << "\n[Steady State] Running " << N << " samples (no reload)..." << endl;
    {
        hls::stream<ap_axiu<AXI_WIDTH_IN,0,0,0>> ss_in;
        hls::stream<ap_axiu<AXI_WIDTH_OUT,0,0,0>> ss_out;
        push_samples(ss_in, db, 0, N);
        synthesis_top(ss_in, ss_out, w1, i1, b1, w2, i2, b2, w3, i3, b3, w4, i4, b4, w5, i5, b5, w6, i6, b6, w7, i7, b7, N, false);
        int ok = 0;
        for (int step = 0; step < N; step++) {
            int pred = decode_output(ss_out);
            if (pred == db.labels[step % loaded_N]) ok++;
            cout << "Sample " << step
                 << ": True=" << db.labels[step % loaded_N]
                 << " Pred=" << pred
                 << (pred == db.labels[step % loaded_N] ? " [OK]" : " [FAIL]") << endl;
        }
        cout << "\n[Steady State] Accuracy: " << ok << "/" << N << endl;
        cout << "[Steady State] Throughput metric: " << N << " samples processed." << endl;
        cout << "[Note] Divide total cycles by N to get per-sample steady cycles." << endl;
    }

    return 0;
}
