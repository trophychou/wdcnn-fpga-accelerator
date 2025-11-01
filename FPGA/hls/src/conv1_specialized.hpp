#ifndef CONV1_SPECIALIZED_HPP
#define CONV1_SPECIALIZED_HPP

#include <ap_int.h>
#include <hls_stream.h>
#include "activation_utils.hpp"

template <
    unsigned IN_ELEMS,
    unsigned OUT_W,
    unsigned OUT_CH,
    unsigned KW,
    unsigned SW,
    unsigned PW,
    unsigned A_BIT,
    unsigned W_BIT,
    unsigned INC_BIT,
    unsigned B_BIT,
    unsigned ACC_BIT,
    unsigned MUL_BIT,
    unsigned SIMD,
    int SHIFT,
    unsigned ACT_TYPE
>
void conv1_accelerator_specialized(
    hls::stream<ap_uint<SIMD * A_BIT>>& in,
    hls::stream<ap_uint<W_BIT>>& w_s,
    hls::stream<ap_uint<INC_BIT>>& inc_s,
    hls::stream<ap_uint<B_BIT>>& b_s,
    hls::stream<ap_uint<A_BIT>>& out,
    const unsigned reps,
    bool load_weights
) {
#pragma HLS INLINE OFF

    static ap_int<W_BIT> w_cache[OUT_CH][KW];
#pragma HLS ARRAY_PARTITION variable=w_cache complete dim=1

    static ap_int<INC_BIT> inc_cache[OUT_CH];
#pragma HLS ARRAY_PARTITION variable=inc_cache complete dim=1

    static ap_int<B_BIT> bias_cache[OUT_CH];
#pragma HLS ARRAY_PARTITION variable=bias_cache complete dim=1

    static ap_int<A_BIT> input_buf[IN_ELEMS];

    if (load_weights) {
        for (int oc = 0; oc < OUT_CH; oc++) {
#pragma HLS PIPELINE II=1
            inc_cache[oc] = (ap_int<INC_BIT>)inc_s.read();
        }

        for (int oc = 0; oc < OUT_CH; oc++) {
#pragma HLS PIPELINE II=1
            bias_cache[oc] = (ap_int<B_BIT>)b_s.read();
        }

        for (int oc = 0; oc < OUT_CH; oc++) {
            for (int k = 0; k < KW; k++) {
#pragma HLS PIPELINE II=1
                w_cache[oc][k] = (ap_int<W_BIT>)w_s.read();
            }
        }
    }

    if (reps == 0) return;

    for (unsigned r = 0; r < reps; r++) {
        for (int i = 0; i < IN_ELEMS; i++) {
#pragma HLS PIPELINE II=1
            input_buf[i] = (ap_int<A_BIT>)in.read();
        }

        for (int ow = 0; ow < OUT_W; ow++) {
            ap_int<ACC_BIT> acc[OUT_CH];
#pragma HLS ARRAY_PARTITION variable=acc complete dim=1

            for (int oc = 0; oc < OUT_CH; oc++) {
#pragma HLS UNROLL
                acc[oc] = 0;
            }

            for (int k = 0; k < KW; k++) {
#pragma HLS PIPELINE II=1
                int in_idx = ow * SW + k - PW;

                ap_int<A_BIT> x = 0;
                if (in_idx >= 0 && in_idx < (int)IN_ELEMS) {
                    x = input_buf[in_idx];
                }

                for (int oc = 0; oc < OUT_CH; oc++) {
#pragma HLS UNROLL
                    acc[oc] += (ap_int<ACC_BIT>)x * (ap_int<ACC_BIT>)w_cache[oc][k];
                }
            }

            for (int oc = 0; oc < OUT_CH; oc++) {
#pragma HLS PIPELINE II=1
                ap_int<MUL_BIT> mult_res = (ap_int<MUL_BIT>)acc[oc] * (ap_int<MUL_BIT>)inc_cache[oc];
                ap_int<MUL_BIT> shifted = mult_res >> SHIFT;
                ap_int<MUL_BIT> biased = shifted + (ap_int<MUL_BIT>)bias_cache[oc];

                ap_int<A_BIT> out_val = apply_activation<ACT_TYPE, MUL_BIT, A_BIT>(biased);
                out.write((ap_uint<A_BIT>)out_val);
            }
        }
    }
}

#endif
