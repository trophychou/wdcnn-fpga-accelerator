#include "wdcnn_dual_top.h"

#ifdef __SYNTHESIS__
#include <ap_int.h>
#endif

namespace {
const int IN_LEN = 5120;
const int B_COUNTS[7] = {16,32,64,64,64,100,3};
const int B_OFF[7] = {0,16,48,112,176,240,340};

struct Workspace {
    int8_t a[64*361],b[64*180],c[64*90],d[64*45],e[64*21],f[100];
    int8_t conv[64*723];
};

template<int INPUT_CH>
int weight_offset(int layer) {
    const int first = INPUT_CH*16*64;
    switch (layer) {
        case 0: return 0;
        case 1: return first;
        case 2: return first+1536;
        case 3: return first+7680;
        case 4: return first+19968;
        case 5: return first+32256;
        default: return first+166656;
    }
}

inline int8_t requantize(int32_t acc, int32_t multiplier, int32_t shift, bool relu) {
    int64_t product = (int64_t)acc * (int64_t)multiplier;
    uint64_t mag = product < 0 ? (uint64_t)(-product) : (uint64_t)product;
    uint64_t rounded = (mag + (uint64_t(1) << (shift - 1))) >> shift;
    int64_t q = product < 0 ? -(int64_t)rounded : (int64_t)rounded;
    const int lo = relu ? 0 : -127;
    if (q < lo) q = lo;
    if (q > 127) q = 127;
    return (int8_t)q;
}

void conv_pool(const int8_t* in, int in_ch, int in_len,
               const int8_t* w, const int32_t* b, const int32_t* m, const int32_t* s,
               int out_ch, int kernel, int stride, int pad,
               int8_t* conv, int8_t* out, int& out_len) {
    const int conv_len = (in_len + 2*pad - kernel) / stride + 1;
    for (int oc=0; oc<out_ch; ++oc) {
        for (int t=0; t<conv_len; ++t) {
            int32_t acc = b[oc];
            for (int ic=0; ic<in_ch; ++ic) {
                for (int k=0; k<kernel; ++k) {
#pragma HLS PIPELINE II=1
                    const int x = t*stride + k - pad;
                    if (x >= 0 && x < in_len) {
                        const int wi = oc*in_ch*kernel + ic*kernel + k;
                        acc += (int32_t)in[ic*in_len+x] * (int32_t)w[wi];
                    }
                }
            }
            conv[oc*conv_len+t] = requantize(acc,m[oc],s[oc],true);
        }
    }
    out_len = conv_len/2;
    for (int oc=0; oc<out_ch; ++oc)
        for (int t=0; t<out_len; ++t) {
            const int a = conv[oc*conv_len+2*t];
            const int c = conv[oc*conv_len+2*t+1];
            out[oc*out_len+t] = (int8_t)(a > c ? a : c);
        }
}

void linear(const int8_t* in, int in_n, const int8_t* w,
            const int32_t* b,const int32_t* m,const int32_t* s,
            int out_n,bool relu,int8_t* out) {
    for (int o=0;o<out_n;++o) {
        int32_t acc=b[o];
        for (int i=0;i<in_n;++i) {
#pragma HLS PIPELINE II=1
            acc += (int32_t)in[i]*(int32_t)w[o*in_n+i];
        }
        out[o]=requantize(acc,m[o],s[o],relu);
    }
}

template<int INPUT_CH>
void infer(const int8_t* input,const int8_t* weights,const int32_t* biases,
           const int32_t* multipliers,const int32_t* shifts,int8_t* logits,Workspace& work) {
    int len=0;
    conv_pool(input,INPUT_CH,IN_LEN,weights+weight_offset<INPUT_CH>(0),biases+B_OFF[0],multipliers+B_OFF[0],shifts+B_OFF[0],16,64,7,1,work.conv,work.a,len);
    conv_pool(work.a,16,len,weights+weight_offset<INPUT_CH>(1),biases+B_OFF[1],multipliers+B_OFF[1],shifts+B_OFF[1],32,3,1,1,work.conv,work.b,len);
    conv_pool(work.b,32,len,weights+weight_offset<INPUT_CH>(2),biases+B_OFF[2],multipliers+B_OFF[2],shifts+B_OFF[2],64,3,1,1,work.conv,work.c,len);
    conv_pool(work.c,64,len,weights+weight_offset<INPUT_CH>(3),biases+B_OFF[3],multipliers+B_OFF[3],shifts+B_OFF[3],64,3,1,1,work.conv,work.d,len);
    conv_pool(work.d,64,len,weights+weight_offset<INPUT_CH>(4),biases+B_OFF[4],multipliers+B_OFF[4],shifts+B_OFF[4],64,3,1,0,work.conv,work.e,len);
    linear(work.e,64*21,weights+weight_offset<INPUT_CH>(5),biases+B_OFF[5],multipliers+B_OFF[5],shifts+B_OFF[5],100,true,work.f);
    linear(work.f,100,weights+weight_offset<INPUT_CH>(6),biases+B_OFF[6],multipliers+B_OFF[6],shifts+B_OFF[6],3,false,logits);
}
}

extern "C" void wdcnn_dual_top(
    const int8_t* vibration_input, const int8_t* current_input,
    const int8_t* vibration_weights, const int32_t* vibration_biases,
    const int32_t* vibration_multipliers, const int32_t* vibration_shifts,
    const int8_t* current_weights, const int32_t* current_biases,
    const int32_t* current_multipliers, const int32_t* current_shifts,
    int8_t* vibration_logits, int8_t* current_logits, bool reload_weights) {
#pragma HLS INTERFACE m_axi port=vibration_input offset=slave bundle=gmem depth=25600
#pragma HLS INTERFACE m_axi port=current_input offset=slave bundle=gmem depth=10240
#pragma HLS INTERFACE m_axi port=vibration_weights offset=slave bundle=gmem depth=172076
#pragma HLS INTERFACE m_axi port=vibration_biases offset=slave bundle=gmem depth=343
#pragma HLS INTERFACE m_axi port=vibration_multipliers offset=slave bundle=gmem depth=343
#pragma HLS INTERFACE m_axi port=vibration_shifts offset=slave bundle=gmem depth=343
#pragma HLS INTERFACE m_axi port=current_weights offset=slave bundle=gmem depth=169004
#pragma HLS INTERFACE m_axi port=current_biases offset=slave bundle=gmem depth=343
#pragma HLS INTERFACE m_axi port=current_multipliers offset=slave bundle=gmem depth=343
#pragma HLS INTERFACE m_axi port=current_shifts offset=slave bundle=gmem depth=343
#pragma HLS INTERFACE m_axi port=vibration_logits offset=slave bundle=gmem depth=3
#pragma HLS INTERFACE m_axi port=current_logits offset=slave bundle=gmem depth=3
#pragma HLS INTERFACE s_axilite port=return bundle=control
#pragma HLS INTERFACE s_axilite port=vibration_input bundle=control
#pragma HLS INTERFACE s_axilite port=current_input bundle=control
#pragma HLS INTERFACE s_axilite port=vibration_weights bundle=control
#pragma HLS INTERFACE s_axilite port=vibration_biases bundle=control
#pragma HLS INTERFACE s_axilite port=vibration_multipliers bundle=control
#pragma HLS INTERFACE s_axilite port=vibration_shifts bundle=control
#pragma HLS INTERFACE s_axilite port=current_weights bundle=control
#pragma HLS INTERFACE s_axilite port=current_biases bundle=control
#pragma HLS INTERFACE s_axilite port=current_multipliers bundle=control
#pragma HLS INTERFACE s_axilite port=current_shifts bundle=control
#pragma HLS INTERFACE s_axilite port=vibration_logits bundle=control
#pragma HLS INTERFACE s_axilite port=current_logits bundle=control
#pragma HLS INTERFACE s_axilite port=reload_weights bundle=control
    static int8_t vw_local[172076],cw_local[169004];
    static int32_t vb_local[343],vm_local[343],vs_local[343];
    static int32_t cb_local[343],cm_local[343],cs_local[343];
    static Workspace work;
    static bool weights_loaded=false;
#pragma HLS BIND_STORAGE variable=vw_local type=ram_1p impl=bram
#pragma HLS BIND_STORAGE variable=cw_local type=ram_1p impl=bram
#pragma HLS BIND_STORAGE variable=vb_local type=ram_1p impl=bram
#pragma HLS BIND_STORAGE variable=vm_local type=ram_1p impl=bram
#pragma HLS BIND_STORAGE variable=vs_local type=ram_1p impl=bram
#pragma HLS BIND_STORAGE variable=cb_local type=ram_1p impl=bram
#pragma HLS BIND_STORAGE variable=cm_local type=ram_1p impl=bram
#pragma HLS BIND_STORAGE variable=cs_local type=ram_1p impl=bram
    if (reload_weights || !weights_loaded) {
    for (int i=0;i<172076;++i) {
#pragma HLS PIPELINE II=1
        vw_local[i]=vibration_weights[i];
    }
    for (int i=0;i<169004;++i) {
#pragma HLS PIPELINE II=1
        cw_local[i]=current_weights[i];
    }
    for (int i=0;i<343;++i) {
#pragma HLS PIPELINE II=1
        vb_local[i]=vibration_biases[i]; vm_local[i]=vibration_multipliers[i]; vs_local[i]=vibration_shifts[i];
        cb_local[i]=current_biases[i]; cm_local[i]=current_multipliers[i]; cs_local[i]=current_shifts[i];
    }
    weights_loaded=true;
    }
    infer<5>(vibration_input,vw_local,vb_local,vm_local,vs_local,vibration_logits,work);
    infer<2>(current_input,cw_local,cb_local,cm_local,cs_local,current_logits,work);
}
