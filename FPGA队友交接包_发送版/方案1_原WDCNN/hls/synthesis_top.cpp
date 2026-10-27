#include "activation_utils.hpp"
#include "pool_accelerator.hpp"
#include "stream_utils.hpp"
#include "config.hpp"
#include "conv1_specialized.hpp"
#include "general_1d_conv_accelerator.hpp"

template <int W_WIDTH, int I_WIDTH, int B_WIDTH>
void layer_loader(
    const ap_int<W_WIDTH>* w, const ap_int<I_WIDTH>* inc,
    const ap_int<B_WIDTH>* b,
    hls::stream<ap_uint<W_WIDTH>>& s_w,
    hls::stream<ap_uint<I_WIDTH>>& s_i,
    hls::stream<ap_uint<B_WIDTH>>& s_b,
    int nw, int ni, int nb, bool enable)
{
#pragma HLS INLINE OFF
    if (!enable) return;
    for (int i=0; i<ni; ++i) {
#pragma HLS PIPELINE II=1
        s_i.write((ap_uint<I_WIDTH>)inc[i]);
    }
    for (int i=0; i<nb; ++i) {
#pragma HLS PIPELINE II=1
        s_b.write((ap_uint<B_WIDTH>)b[i]);
    }
    for (int i=0; i<nw; ++i) {
#pragma HLS PIPELINE II=1
        s_w.write((ap_uint<W_WIDTH>)w[i]);
    }
}

void load_weights_wrapper(
    const ap_int<L1_W_BIT>* w1, const ap_int<Q_INC_BIT>* inc1, const ap_int<Q_B_BIT>* b1,
    const ap_int<L2_W_BIT>* w2, const ap_int<Q_INC_BIT>* inc2, const ap_int<Q_B_BIT>* b2,
    const ap_int<L3_W_BIT>* w3, const ap_int<Q_INC_BIT>* inc3, const ap_int<Q_B_BIT>* b3,
    const ap_int<L4_W_BIT>* w4, const ap_int<Q_INC_BIT>* inc4, const ap_int<Q_B_BIT>* b4,
    const ap_int<L5_W_BIT>* w5, const ap_int<Q_INC_BIT>* inc5, const ap_int<Q_B_BIT>* b5,
    const ap_int<L6_W_BIT>* w6, const ap_int<Q_INC_BIT>* inc6, const ap_int<Q_B_BIT>* b6,
    const ap_int<L7_W_BIT>* w7, const ap_int<Q_INC_BIT>* inc7, const ap_int<Q_B_BIT>* b7,
    hls::stream<ap_uint<L1_W_BIT>>& s_w1, hls::stream<ap_uint<Q_INC_BIT>>& s_i1, hls::stream<ap_uint<Q_B_BIT>>& s_b1,
    hls::stream<ap_uint<L2_W_BIT>>& s_w2, hls::stream<ap_uint<Q_INC_BIT>>& s_i2, hls::stream<ap_uint<Q_B_BIT>>& s_b2,
    hls::stream<ap_uint<L3_W_BIT>>& s_w3, hls::stream<ap_uint<Q_INC_BIT>>& s_i3, hls::stream<ap_uint<Q_B_BIT>>& s_b3,
    hls::stream<ap_uint<L4_W_BIT>>& s_w4, hls::stream<ap_uint<Q_INC_BIT>>& s_i4, hls::stream<ap_uint<Q_B_BIT>>& s_b4,
    hls::stream<ap_uint<L5_W_BIT>>& s_w5, hls::stream<ap_uint<Q_INC_BIT>>& s_i5, hls::stream<ap_uint<Q_B_BIT>>& s_b5,
    hls::stream<ap_uint<L6_W_BIT>>& s_w6, hls::stream<ap_uint<Q_INC_BIT>>& s_i6, hls::stream<ap_uint<Q_B_BIT>>& s_b6,
    hls::stream<ap_uint<L7_W_BIT>>& s_w7, hls::stream<ap_uint<Q_INC_BIT>>& s_i7, hls::stream<ap_uint<Q_B_BIT>>& s_b7,
    bool reload
) {
    layer_loader(w1, inc1, b1, s_w1, s_i1, s_b1, 1024, 16, 16, reload);
    layer_loader(w2, inc2, b2, s_w2, s_i2, s_b2, 1536, 32, 32, reload);
    layer_loader(w3, inc3, b3, s_w3, s_i3, s_b3, 6144, 64, 64, reload);
    layer_loader(w4, inc4, b4, s_w4, s_i4, s_b4, 12288, 64, 64, reload);
    layer_loader(w5, inc5, b5, s_w5, s_i5, s_b5, 12288, 64, 64, reload);
    layer_loader(w6, inc6, b6, s_w6, s_i6, s_b6, 134400, 100, 100, reload);
    layer_loader(w7, inc7, b7, s_w7, s_i7, s_b7, 400, 4, 4, reload);
}

void compute_engine(
    hls::stream<ap_axiu<AXI_WIDTH_IN,0,0,0>>& in,
    hls::stream<ap_axiu<AXI_WIDTH_OUT,0,0,0>>& out,
    hls::stream<ap_uint<L1_W_BIT>>& s_w1, hls::stream<ap_uint<Q_INC_BIT>>& s_i1, hls::stream<ap_uint<Q_B_BIT>>& s_b1,
    hls::stream<ap_uint<L2_W_BIT>>& s_w2, hls::stream<ap_uint<Q_INC_BIT>>& s_i2, hls::stream<ap_uint<Q_B_BIT>>& s_b2,
    hls::stream<ap_uint<L3_W_BIT>>& s_w3, hls::stream<ap_uint<Q_INC_BIT>>& s_i3, hls::stream<ap_uint<Q_B_BIT>>& s_b3,
    hls::stream<ap_uint<L4_W_BIT>>& s_w4, hls::stream<ap_uint<Q_INC_BIT>>& s_i4, hls::stream<ap_uint<Q_B_BIT>>& s_b4,
    hls::stream<ap_uint<L5_W_BIT>>& s_w5, hls::stream<ap_uint<Q_INC_BIT>>& s_i5, hls::stream<ap_uint<Q_B_BIT>>& s_b5,
    hls::stream<ap_uint<L6_W_BIT>>& s_w6, hls::stream<ap_uint<Q_INC_BIT>>& s_i6, hls::stream<ap_uint<Q_B_BIT>>& s_b6,
    hls::stream<ap_uint<L7_W_BIT>>& s_w7, hls::stream<ap_uint<Q_INC_BIT>>& s_i7, hls::stream<ap_uint<Q_B_BIT>>& s_b7,
    unsigned int num_samples, bool load_weights)
{
#pragma HLS INLINE OFF
#pragma HLS DATAFLOW

    hls::stream<ap_uint<L1_SIMD*L1_A_BIT>> s_l1_in;
#pragma HLS STREAM variable=s_l1_in depth=64
    hls::stream<ap_uint<L1_A_BIT>> s_l1_conv;
#pragma HLS STREAM variable=s_l1_conv depth=64
    hls::stream<ap_uint<L1_A_BIT>> s_l1_pool1;
#pragma HLS STREAM variable=s_l1_pool1 depth=64
    hls::stream<ap_uint<L2_SIMD*L2_A_BIT>> s_l2_in;
#pragma HLS STREAM variable=s_l2_in depth=128
    hls::stream<ap_uint<L2_A_BIT>> s_l2_conv;
#pragma HLS STREAM variable=s_l2_conv depth=64
    hls::stream<ap_uint<L2_A_BIT>> s_l2_pool1;
#pragma HLS STREAM variable=s_l2_pool1 depth=64
    hls::stream<ap_uint<L3_SIMD*L3_A_BIT>> s_l3_in;
#pragma HLS STREAM variable=s_l3_in depth=32
    hls::stream<ap_uint<L3_A_BIT>> s_l3_conv;
#pragma HLS STREAM variable=s_l3_conv depth=64
    hls::stream<ap_uint<L3_A_BIT>> s_l3_pool1;
#pragma HLS STREAM variable=s_l3_pool1 depth=64
    hls::stream<ap_uint<L4_SIMD*L4_A_BIT>> s_l4_in;
#pragma HLS STREAM variable=s_l4_in depth=16
    hls::stream<ap_uint<L4_A_BIT>> s_l4_conv;
#pragma HLS STREAM variable=s_l4_conv depth=32
    hls::stream<ap_uint<L4_A_BIT>> s_l4_pool1;
#pragma HLS STREAM variable=s_l4_pool1 depth=32
    hls::stream<ap_uint<L5_SIMD*L5_A_BIT>> s_l5_in;
#pragma HLS STREAM variable=s_l5_in depth=16
    hls::stream<ap_uint<L5_A_BIT>> s_l5_conv;
#pragma HLS STREAM variable=s_l5_conv depth=32
    hls::stream<ap_uint<L5_A_BIT>> s_l5_pool1;
#pragma HLS STREAM variable=s_l5_pool1 depth=32
    hls::stream<ap_uint<L6_SIMD*L6_A_BIT>> s_l6_in;
#pragma HLS STREAM variable=s_l6_in depth=16
    hls::stream<ap_uint<L6_A_BIT>> s_l6_conv;
#pragma HLS STREAM variable=s_l6_conv depth=16
    hls::stream<ap_uint<L7_SIMD*L7_A_BIT>> s_l7_in;
#pragma HLS STREAM variable=s_l7_in depth=16
    hls::stream<ap_uint<L7_A_BIT>> s_l7_conv;
#pragma HLS STREAM variable=s_l7_conv depth=16
    hls::stream<ap_uint<32>> s_out_packed;
#pragma HLS STREAM variable=s_out_packed depth=16
    hls::stream<ap_uint<L1_A_BIT>> s_raw_in;
#pragma HLS STREAM variable=s_raw_in depth=64

    axis_512_to_hls_stream_8<INPUT_ELEMS>(in, s_raw_in, num_samples);
    stream_width_adjust_flex<L1_A_BIT, L1_SIMD*L1_A_BIT, INPUT_ELEMS>(s_raw_in, s_l1_in, num_samples);

    conv1_accelerator_specialized<
        INPUT_ELEMS,
        L1_CONV_OUT_W,
        L1_OUT_CH,
        L1_KW,
        L1_SW,
        L1_PW,
        L1_A_BIT,
        L1_W_BIT,
        Q_INC_BIT,
        Q_B_BIT,
        Q_ACC_BIT,
        Q_MUL_BIT,
        L1_SIMD,
        L1_SHIFT,
        L1_ACT_TYPE
    >(s_l1_in, s_w1, s_i1, s_b1, s_l1_conv, num_samples, load_weights);
    pool_accelerator<L1_P1_IN_H,L1_P1_IN_W,L1_OUT_CH,L1_A_BIT,L1_P1_KH,L1_P1_KW,L1_P1_SH,L1_P1_SW,L1_POOL_IS_MAX,L1_POOL_SIGNED_COMPARE>(s_l1_conv,s_l1_pool1,num_samples);
    stream_width_adjust_flex<L1_A_BIT,L2_SIMD*L2_A_BIT,L1_OUT_ELEMS>(s_l1_pool1,s_l2_in,num_samples);

    general_1d_conv_accelerator<
        L2_IN_H, L2_IN_W, L2_IN_CH, L2_A_BIT,
        L2_KH, L2_KW, L2_SH, L2_SW,
        L2_PH, L2_PW,
        L2_OUT_CH, L2_A_BIT,
        L2_W_BIT, Q_ACC_BIT, Q_INC_BIT, Q_B_BIT, Q_MUL_BIT,
        L2_PE, L2_SIMD, L2_SHIFT,
        L2_ACT_TYPE
    >(s_l2_in, s_w2, s_i2, s_b2, s_l2_conv, num_samples, load_weights);
    pool_accelerator<L2_P1_IN_H,L2_P1_IN_W,L2_OUT_CH,L2_A_BIT,L2_P1_KH,L2_P1_KW,L2_P1_SH,L2_P1_SW,L2_POOL_IS_MAX,L2_POOL_SIGNED_COMPARE>(s_l2_conv,s_l2_pool1,num_samples);
    stream_width_adjust_flex<L2_A_BIT,L3_SIMD*L3_A_BIT,L2_OUT_ELEMS>(s_l2_pool1,s_l3_in,num_samples);

    general_1d_conv_accelerator<
        L3_IN_H, L3_IN_W, L3_IN_CH, L3_A_BIT,
        L3_KH, L3_KW, L3_SH, L3_SW,
        L3_PH, L3_PW,
        L3_OUT_CH, L3_A_BIT,
        L3_W_BIT, Q_ACC_BIT, Q_INC_BIT, Q_B_BIT, Q_MUL_BIT,
        L3_PE, L3_SIMD, L3_SHIFT,
        L3_ACT_TYPE
    >(s_l3_in, s_w3, s_i3, s_b3, s_l3_conv, num_samples, load_weights);
    pool_accelerator<L3_P1_IN_H,L3_P1_IN_W,L3_OUT_CH,L3_A_BIT,L3_P1_KH,L3_P1_KW,L3_P1_SH,L3_P1_SW,L3_POOL_IS_MAX,L3_POOL_SIGNED_COMPARE>(s_l3_conv,s_l3_pool1,num_samples);
    stream_width_adjust_flex<L3_A_BIT,L4_SIMD*L4_A_BIT,L3_OUT_ELEMS>(s_l3_pool1,s_l4_in,num_samples);

    general_1d_conv_accelerator<
        L4_IN_H, L4_IN_W, L4_IN_CH, L4_A_BIT,
        L4_KH, L4_KW, L4_SH, L4_SW,
        L4_PH, L4_PW,
        L4_OUT_CH, L4_A_BIT,
        L4_W_BIT, Q_ACC_BIT, Q_INC_BIT, Q_B_BIT, Q_MUL_BIT,
        L4_PE, L4_SIMD, L4_SHIFT,
        L4_ACT_TYPE
    >(s_l4_in, s_w4, s_i4, s_b4, s_l4_conv, num_samples, load_weights);
    pool_accelerator<L4_P1_IN_H,L4_P1_IN_W,L4_OUT_CH,L4_A_BIT,L4_P1_KH,L4_P1_KW,L4_P1_SH,L4_P1_SW,L4_POOL_IS_MAX,L4_POOL_SIGNED_COMPARE>(s_l4_conv,s_l4_pool1,num_samples);
    stream_width_adjust_flex<L4_A_BIT,L5_SIMD*L5_A_BIT,L4_OUT_ELEMS>(s_l4_pool1,s_l5_in,num_samples);

    general_1d_conv_accelerator<
        L5_IN_H, L5_IN_W, L5_IN_CH, L5_A_BIT,
        L5_KH, L5_KW, L5_SH, L5_SW,
        L5_PH, L5_PW,
        L5_OUT_CH, L5_A_BIT,
        L5_W_BIT, Q_ACC_BIT, Q_INC_BIT, Q_B_BIT, Q_MUL_BIT,
        L5_PE, L5_SIMD, L5_SHIFT,
        L5_ACT_TYPE
    >(s_l5_in, s_w5, s_i5, s_b5, s_l5_conv, num_samples, load_weights);
    pool_accelerator<L5_P1_IN_H,L5_P1_IN_W,L5_OUT_CH,L5_A_BIT,L5_P1_KH,L5_P1_KW,L5_P1_SH,L5_P1_SW,L5_POOL_IS_MAX,L5_POOL_SIGNED_COMPARE>(s_l5_conv,s_l5_pool1,num_samples);
    stream_width_adjust_flex<L5_A_BIT,L6_SIMD*L6_A_BIT,L5_OUT_ELEMS>(s_l5_pool1,s_l6_in,num_samples);

    general_1d_conv_accelerator<
        L6_IN_H, L6_IN_W, L6_IN_CH, L6_A_BIT,
        L6_KH, L6_KW, L6_SH, L6_SW,
        L6_PH, L6_PW,
        L6_OUT_CH, L6_A_BIT,
        L6_W_BIT, Q_ACC_BIT, Q_INC_BIT, Q_B_BIT, Q_MUL_BIT,
        L6_PE, L6_SIMD, L6_SHIFT,
        L6_ACT_TYPE
    >(s_l6_in, s_w6, s_i6, s_b6, s_l6_conv, num_samples, load_weights);
    stream_width_adjust_flex<L6_A_BIT,L7_SIMD*L7_A_BIT,L6_OUT_ELEMS>(s_l6_conv,s_l7_in,num_samples);

    general_1d_conv_accelerator<
        L7_IN_H, L7_IN_W, L7_IN_CH, L7_A_BIT,
        L7_KH, L7_KW, L7_SH, L7_SW,
        L7_PH, L7_PW,
        L7_OUT_CH, L7_A_BIT,
        L7_W_BIT, Q_ACC_BIT, Q_INC_BIT, Q_B_BIT, Q_MUL_BIT,
        L7_PE, L7_SIMD, L7_SHIFT,
        L7_ACT_TYPE
    >(s_l7_in, s_w7, s_i7, s_b7, s_l7_conv, num_samples, load_weights);
    stream_width_adjust_flex<L7_A_BIT,32,L7_OUT_ELEMS>(s_l7_conv,s_out_packed,num_samples);
    hls_stream_to_axis<32,1>(s_out_packed,out,num_samples);
}

void synthesis_top(
    hls::stream<ap_axiu<AXI_WIDTH_IN,0,0,0>>& in,
    hls::stream<ap_axiu<AXI_WIDTH_OUT,0,0,0>>& out,
    const ap_int<L1_W_BIT>* w1, const ap_int<Q_INC_BIT>* inc1, const ap_int<Q_B_BIT>* b1,
    const ap_int<L2_W_BIT>* w2, const ap_int<Q_INC_BIT>* inc2, const ap_int<Q_B_BIT>* b2,
    const ap_int<L3_W_BIT>* w3, const ap_int<Q_INC_BIT>* inc3, const ap_int<Q_B_BIT>* b3,
    const ap_int<L4_W_BIT>* w4, const ap_int<Q_INC_BIT>* inc4, const ap_int<Q_B_BIT>* b4,
    const ap_int<L5_W_BIT>* w5, const ap_int<Q_INC_BIT>* inc5, const ap_int<Q_B_BIT>* b5,
    const ap_int<L6_W_BIT>* w6, const ap_int<Q_INC_BIT>* inc6, const ap_int<Q_B_BIT>* b6,
    const ap_int<L7_W_BIT>* w7, const ap_int<Q_INC_BIT>* inc7, const ap_int<Q_B_BIT>* b7,
    unsigned int num_samples, bool reload_weights)
{
#pragma HLS INTERFACE axis port=in
#pragma HLS INTERFACE axis port=out
#pragma HLS INTERFACE m_axi port=w1   offset=slave bundle=gmem depth=1024
#pragma HLS INTERFACE m_axi port=inc1 offset=slave bundle=gmem depth=16
#pragma HLS INTERFACE m_axi port=b1   offset=slave bundle=gmem depth=16
#pragma HLS INTERFACE m_axi port=w2   offset=slave bundle=gmem depth=1536
#pragma HLS INTERFACE m_axi port=inc2 offset=slave bundle=gmem depth=32
#pragma HLS INTERFACE m_axi port=b2   offset=slave bundle=gmem depth=32
#pragma HLS INTERFACE m_axi port=w3   offset=slave bundle=gmem depth=6144
#pragma HLS INTERFACE m_axi port=inc3 offset=slave bundle=gmem depth=64
#pragma HLS INTERFACE m_axi port=b3   offset=slave bundle=gmem depth=64
#pragma HLS INTERFACE m_axi port=w4   offset=slave bundle=gmem depth=12288
#pragma HLS INTERFACE m_axi port=inc4 offset=slave bundle=gmem depth=64
#pragma HLS INTERFACE m_axi port=b4   offset=slave bundle=gmem depth=64
#pragma HLS INTERFACE m_axi port=w5   offset=slave bundle=gmem depth=12288
#pragma HLS INTERFACE m_axi port=inc5 offset=slave bundle=gmem depth=64
#pragma HLS INTERFACE m_axi port=b5   offset=slave bundle=gmem depth=64
#pragma HLS INTERFACE m_axi port=w6   offset=slave bundle=gmem depth=134400
#pragma HLS INTERFACE m_axi port=inc6 offset=slave bundle=gmem depth=100
#pragma HLS INTERFACE m_axi port=b6   offset=slave bundle=gmem depth=100
#pragma HLS INTERFACE m_axi port=w7   offset=slave bundle=gmem depth=400
#pragma HLS INTERFACE m_axi port=inc7 offset=slave bundle=gmem depth=4
#pragma HLS INTERFACE m_axi port=b7   offset=slave bundle=gmem depth=4
#pragma HLS INTERFACE s_axilite port=num_samples    bundle=control
#pragma HLS INTERFACE s_axilite port=reload_weights bundle=control
#pragma HLS INTERFACE s_axilite port=return          bundle=control
#pragma HLS DATAFLOW

    hls::stream<ap_uint<L1_W_BIT>> s_w1;
#pragma HLS STREAM variable=s_w1 depth=2
    hls::stream<ap_uint<Q_INC_BIT>> s_i1;
#pragma HLS STREAM variable=s_i1 depth=2
    hls::stream<ap_uint<Q_B_BIT>> s_b1;
#pragma HLS STREAM variable=s_b1 depth=2
    hls::stream<ap_uint<L2_W_BIT>> s_w2;
#pragma HLS STREAM variable=s_w2 depth=2
    hls::stream<ap_uint<Q_INC_BIT>> s_i2;
#pragma HLS STREAM variable=s_i2 depth=2
    hls::stream<ap_uint<Q_B_BIT>> s_b2;
#pragma HLS STREAM variable=s_b2 depth=2
    hls::stream<ap_uint<L3_W_BIT>> s_w3;
#pragma HLS STREAM variable=s_w3 depth=2
    hls::stream<ap_uint<Q_INC_BIT>> s_i3;
#pragma HLS STREAM variable=s_i3 depth=2
    hls::stream<ap_uint<Q_B_BIT>> s_b3;
#pragma HLS STREAM variable=s_b3 depth=2
    hls::stream<ap_uint<L4_W_BIT>> s_w4;
#pragma HLS STREAM variable=s_w4 depth=2
    hls::stream<ap_uint<Q_INC_BIT>> s_i4;
#pragma HLS STREAM variable=s_i4 depth=2
    hls::stream<ap_uint<Q_B_BIT>> s_b4;
#pragma HLS STREAM variable=s_b4 depth=2
    hls::stream<ap_uint<L5_W_BIT>> s_w5;
#pragma HLS STREAM variable=s_w5 depth=2
    hls::stream<ap_uint<Q_INC_BIT>> s_i5;
#pragma HLS STREAM variable=s_i5 depth=2
    hls::stream<ap_uint<Q_B_BIT>> s_b5;
#pragma HLS STREAM variable=s_b5 depth=2
    hls::stream<ap_uint<L6_W_BIT>> s_w6;
#pragma HLS STREAM variable=s_w6 depth=2
    hls::stream<ap_uint<Q_INC_BIT>> s_i6;
#pragma HLS STREAM variable=s_i6 depth=2
    hls::stream<ap_uint<Q_B_BIT>> s_b6;
#pragma HLS STREAM variable=s_b6 depth=2
    hls::stream<ap_uint<L7_W_BIT>> s_w7;
#pragma HLS STREAM variable=s_w7 depth=2
    hls::stream<ap_uint<Q_INC_BIT>> s_i7;
#pragma HLS STREAM variable=s_i7 depth=2
    hls::stream<ap_uint<Q_B_BIT>> s_b7;
#pragma HLS STREAM variable=s_b7 depth=2

    load_weights_wrapper(w1, inc1, b1, w2, inc2, b2, w3, inc3, b3, w4, inc4, b4, w5, inc5, b5, w6, inc6, b6, w7, inc7, b7, s_w1, s_i1, s_b1, s_w2, s_i2, s_b2, s_w3, s_i3, s_b3, s_w4, s_i4, s_b4, s_w5, s_i5, s_b5, s_w6, s_i6, s_b6, s_w7, s_i7, s_b7, reload_weights);
    compute_engine(in, out, s_w1, s_i1, s_b1, s_w2, s_i2, s_b2, s_w3, s_i3, s_b3, s_w4, s_i4, s_b4, s_w5, s_i5, s_b5, s_w6, s_i6, s_b6, s_w7, s_i7, s_b7, num_samples, reload_weights);
}
