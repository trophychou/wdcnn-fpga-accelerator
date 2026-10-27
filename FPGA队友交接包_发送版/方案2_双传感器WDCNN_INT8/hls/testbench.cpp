#include "wdcnn_dual_top.h"
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

static std::vector<uint8_t> read_bytes(const std::string& path) {
    std::ifstream f(path.c_str(), std::ios::binary);
    if (!f) throw std::runtime_error("cannot open " + path);
    f.seekg(0, std::ios::end);
    const std::streamoff n = f.tellg();
    f.seekg(0, std::ios::beg);
    std::vector<uint8_t> data((size_t)n);
    if (n && !f.read((char*)data.data(), n)) throw std::runtime_error("cannot read " + path);
    return data;
}

static std::vector<int8_t> read_i8(const std::string& path) {
    std::vector<uint8_t> raw = read_bytes(path);
    std::vector<int8_t> out(raw.size());
    for (size_t i=0;i<raw.size();++i) out[i]=(int8_t)raw[i];
    return out;
}

static std::vector<int32_t> read_i32le(const std::string& path) {
    std::vector<uint8_t> raw = read_bytes(path);
    if (raw.size()%4) throw std::runtime_error("bad int32 byte count: " + path);
    std::vector<int32_t> out(raw.size()/4);
    for (size_t i=0;i<out.size();++i) {
        uint32_t u=(uint32_t)raw[4*i] | ((uint32_t)raw[4*i+1]<<8) |
                   ((uint32_t)raw[4*i+2]<<16) | ((uint32_t)raw[4*i+3]<<24);
        int64_t s=(u & 0x80000000u) ? (int64_t)u-0x100000000LL : (int64_t)u;
        out[i]=(int32_t)s;
    }
    return out;
}

static void check_size(const std::string& name, size_t got, size_t expected) {
    if (got!=expected) throw std::runtime_error(name + " has wrong element count");
}

int main(int argc,char** argv) {
    try {
        if (argc<2) throw std::runtime_error("usage: testbench <prototype_fold01_directory>");
        const std::string root=argv[1];
        const std::string vib=root+"/vibration/fpga_binary/";
        const std::string cur=root+"/current/fpga_binary/";
        std::vector<int8_t> vi=read_i8(vib+"input_int8.bin"), ci=read_i8(cur+"input_int8.bin");
        std::vector<int8_t> vw=read_i8(vib+"weights_int8.bin"), cw=read_i8(cur+"weights_int8.bin");
        std::vector<int8_t> ve=read_i8(vib+"fc2_output_int8.bin"), ce=read_i8(cur+"fc2_output_int8.bin");
        std::vector<int32_t> vb=read_i32le(vib+"biases_int32_le.bin"), vm=read_i32le(vib+"multipliers_int32_le.bin"), vs=read_i32le(vib+"shifts_int32_le.bin");
        std::vector<int32_t> cb=read_i32le(cur+"biases_int32_le.bin"), cm=read_i32le(cur+"multipliers_int32_le.bin"), cs=read_i32le(cur+"shifts_int32_le.bin");
        check_size("vibration inputs",vi.size(),4u*5u*5120u); check_size("current inputs",ci.size(),4u*2u*5120u);
        check_size("vibration weights",vw.size(),172076u); check_size("current weights",cw.size(),169004u);
        check_size("vibration expected logits",ve.size(),12u); check_size("current expected logits",ce.size(),12u);
        check_size("vibration biases",vb.size(),343u); check_size("current biases",cb.size(),343u);
        check_size("vibration multipliers",vm.size(),343u); check_size("current multipliers",cm.size(),343u);
        check_size("vibration shifts",vs.size(),343u); check_size("current shifts",cs.size(),343u);
        int failures=0;
        for (int n=0;n<4;++n) {
            int8_t vo[3]={0,0,0},co[3]={0,0,0};
            wdcnn_dual_top(vi.data()+n*5*5120,ci.data()+n*2*5120,
                vw.data(),vb.data(),vm.data(),vs.data(),cw.data(),cb.data(),cm.data(),cs.data(),vo,co,n==0);
            for (int k=0;k<3;++k) {
                if (vo[k]!=ve[n*3+k]) { std::cerr<<"vibration mismatch sample="<<n<<" class="<<k<<" got="<<(int)vo[k]<<" expected="<<(int)ve[n*3+k]<<"\n"; ++failures; }
                if (co[k]!=ce[n*3+k]) { std::cerr<<"current mismatch sample="<<n<<" class="<<k<<" got="<<(int)co[k]<<" expected="<<(int)ce[n*3+k]<<"\n"; ++failures; }
            }
        }
        if (failures) { std::cerr<<"FAIL: "<<failures<<" logit mismatches\n"; return 1; }
        std::cout<<"PASS: 4 vibration + 4 current vectors; all 24 INT8 logits match bit-exactly.\n";
        return 0;
    } catch (const std::exception& e) {
        std::cerr<<"FAIL: "<<e.what()<<"\n";
        return 2;
    }
}
