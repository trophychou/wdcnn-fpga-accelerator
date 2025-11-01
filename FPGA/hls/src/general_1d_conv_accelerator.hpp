#ifndef GENERAL_1D_CONV_ACCELERATOR_HPP
#define GENERAL_1D_CONV_ACCELERATOR_HPP

#include <ap_int.h>
#include <hls_stream.h>
#include "activation_utils.hpp"

template <
    unsigned IH, unsigned IW,
    unsigned KH, unsigned KW,
    unsigned SH, unsigned SW,
    unsigned PH, unsigned PW,
    unsigned IC, unsigned SIMD,
    unsigned BIT
>
void sliding_window_1d_general(
    hls::stream<ap_uint<SIMD * BIT>>& in,
    hls::stream<ap_uint<SIMD * BIT>>& out,
    const unsigned reps
) {
#pragma HLS INLINE OFF

    const unsigned LB_ROWS = (KH > 1) ? (KH - 1) : 1;
    const unsigned LB_DEPTH = (IH > 1) ? (IW + 2 * PW) : 1;

    static ap_uint<SIMD * BIT> line_buf[LB_ROWS][LB_DEPTH][IC / SIMD];
#pragma HLS ARRAY_PARTITION variable=line_buf complete dim=1

    static ap_uint<SIMD * BIT> window[KH][KW][IC / SIMD];
#pragma HLS ARRAY_PARTITION variable=window complete dim=1
#pragma HLS ARRAY_PARTITION variable=window complete dim=2

    for (unsigned rep = 0; rep < reps; ++rep) {
        for (unsigned h = 0; h < IH + 2 * PH; ++h) {
            for (unsigned w = 0; w < IW + 2 * PW; ++w) {
                bool padding = (h < PH) || (h >= IH + PH) ||
                               (w < PW) || (w >= IW + PW);

                for (unsigned c = 0; c < IC / SIMD; ++c) {
#pragma HLS PIPELINE II=1
                    ap_uint<SIMD * BIT> val_in = 0;
                    if (!padding) {
                        val_in = in.read();
                    }

                    ap_uint<SIMD * BIT> col_vec[KH];
#pragma HLS ARRAY_PARTITION variable=col_vec complete

                    if (IH == 1) {
                        col_vec[0] = val_in;
                    } else {
                        unsigned w_idx = w % LB_DEPTH;
                        if (KH > 1) {
                            for (unsigned k = 0; k < KH - 1; ++k) {
                                col_vec[k] = line_buf[k][w_idx][c];
                            }
                            for (unsigned k = 0; k < KH - 2; ++k) {
                                line_buf[k][w_idx][c] = line_buf[k + 1][w_idx][c];
                            }
                            line_buf[KH - 2][w_idx][c] = val_in;
                        }
                        col_vec[KH - 1] = val_in;
                    }

                    for (unsigned i = 0; i < KH; ++i) {
                        for (unsigned j = 0; j < KW - 1; ++j) {
                            window[i][j][c] = window[i][j + 1][c];
                        }
                        window[i][KW - 1][c] = col_vec[i];
                    }

                    bool valid_h = (h >= KH - 1) && ((h - (KH - 1)) % SH == 0);
                    bool valid_w = (w >= KW - 1) && ((w - (KW - 1)) % SW == 0);

                    if (valid_h && valid_w) {
                        for (unsigned i = 0; i < KH; ++i) {
                            for (unsigned j = 0; j < KW; ++j) {
                                out.write(window[i][j][c]);
                            }
                        }
                    }
                }
            }
        }
    }
}

template <
    unsigned OH, unsigned OW,
    unsigned KH, unsigned KW,
    unsigned IC, unsigned OC,
    unsigned W_BIT,
    unsigned I_BIT,
    unsigned ACC_BIT,
    unsigned INC_BIT,
    unsigned B_BIT,
    unsigned O_BIT,
    unsigned MUL_BIT,
    unsigned SIMD,
    unsigned PE,
    int SHIFT,
    unsigned ACT_TYPE
>
void compute_unit_1d_emitlast_general(
    hls::stream<ap_uint<SIMD * I_BIT>>& in,
    hls::stream<ap_uint<W_BIT>>& w_s,
    hls::stream<ap_uint<INC_BIT>>& inc_s,
    hls::stream<ap_uint<B_BIT>>& b_s,
    hls::stream<ap_uint<PE * O_BIT>>& out_vec,
    const unsigned reps,
    bool load_weights
) {
#pragma HLS INLINE OFF

    static const unsigned IK = (IC / SIMD) * (KH * KW);
    static const unsigned OB = OC / PE;

    static ap_uint<SIMD * W_BIT> w_cache[PE][OB][IK];
#pragma HLS ARRAY_PARTITION variable=w_cache complete dim=1

    static ap_int<ACC_BIT> acc[PE][OB];
#pragma HLS ARRAY_PARTITION variable=acc complete dim=1

    static ap_int<INC_BIT> inc_cache[PE][OC / PE];
#pragma HLS ARRAY_PARTITION variable=inc_cache complete dim=1

    static ap_int<B_BIT> bias_cache[PE][OC / PE];
#pragma HLS ARRAY_PARTITION variable=bias_cache complete dim=1

    if (load_weights) {
        for (int o = 0; o < OC / PE; ++o) {
            for (int p = 0; p < PE; ++p) {
#pragma HLS PIPELINE II=1
                inc_cache[p][o] = (ap_int<INC_BIT>)inc_s.read();
            }
        }

        for (int o = 0; o < OC / PE; ++o) {
            for (int p = 0; p < PE; ++p) {
#pragma HLS PIPELINE II=1
                bias_cache[p][o] = (ap_int<B_BIT>)b_s.read();
            }
        }

        for (int o = 0; o < OB; ++o) {
            for (int p = 0; p < PE; ++p) {
                for (int ik = 0; ik < IK; ++ik) {
#pragma HLS PIPELINE II=SIMD
                    ap_uint<SIMD * W_BIT> packed_w = 0;
                    for (int s = 0; s < SIMD; ++s) {
                        packed_w.range((s + 1) * W_BIT - 1, s * W_BIT) = w_s.read();
                    }
                    w_cache[p][o][ik] = packed_w;
                }
            }
        }
    }

    if (reps == 0) return;

    for (unsigned r = 0; r < reps; ++r) {
        for (unsigned h = 0; h < OH; ++h) {
            for (unsigned w = 0; w < OW; ++w) {
                ap_uint<SIMD * I_BIT> data = 0;

                for (unsigned iko = 0; iko < IK * OB; ++iko) {
#pragma HLS PIPELINE II=1
                    unsigned ik = iko / OB;
                    unsigned o = iko % OB;

                    if (o == 0) {
                        data = in.read();
                    }

                    ap_uint<PE * O_BIT> packed_out = 0;
                    const bool emit_now = (ik == IK - 1);

                    for (unsigned p = 0; p < PE; ++p) {
#pragma HLS UNROLL
                        ap_uint<SIMD * W_BIT> packed_w = w_cache[p][o][ik];
                        ap_int<ACC_BIT> tmp = (ik == 0) ? (ap_int<ACC_BIT>)0 : acc[p][o];

                        for (unsigned s = 0; s < SIMD; ++s) {
#pragma HLS UNROLL
                            ap_int<W_BIT> wt = (ap_int<W_BIT>)packed_w.range((s + 1) * W_BIT - 1, s * W_BIT);
                            ap_int<I_BIT> d = (ap_int<I_BIT>)data.range((s + 1) * I_BIT - 1, s * I_BIT);
                            tmp += (ap_int<ACC_BIT>)wt * (ap_int<ACC_BIT>)d;
                        }

                        acc[p][o] = tmp;

                        if (emit_now) {
                            ap_int<MUL_BIT> mult = (ap_int<MUL_BIT>)tmp * (ap_int<MUL_BIT>)inc_cache[p][o];
                            ap_int<MUL_BIT> shifted = mult >> SHIFT;
                            ap_int<MUL_BIT> biased = shifted + (ap_int<MUL_BIT>)bias_cache[p][o];

                            ap_int<O_BIT> out_val = apply_activation<ACT_TYPE, MUL_BIT, O_BIT>(biased);
                            packed_out.range((p + 1) * O_BIT - 1, p * O_BIT) = (ap_uint<O_BIT>)out_val;
                        }
                    }

                    if (emit_now) {
                        out_vec.write(packed_out);
                    }
                }
            }
        }
    }
}

template <
    unsigned OH, unsigned OW,
    unsigned OC,
    unsigned O_BIT,
    unsigned PE
>
void serialize_packed_outputs_1d_general(
    hls::stream<ap_uint<PE * O_BIT>>& in_vec,
    hls::stream<ap_uint<O_BIT>>& out,
    const unsigned reps
) {
#pragma HLS INLINE OFF

    for (unsigned r = 0; r < reps; ++r) {
        for (unsigned h = 0; h < OH; ++h) {
            for (unsigned w = 0; w < OW; ++w) {
                for (unsigned o = 0; o < OC / PE; ++o) {
                    ap_uint<PE * O_BIT> packed = in_vec.read();

                    for (unsigned p = 0; p < PE; ++p) {
#pragma HLS PIPELINE II=1
                        out.write((ap_uint<O_BIT>)packed.range((p + 1) * O_BIT - 1, p * O_BIT));
                    }
                }
            }
        }
    }
}

template <
    unsigned IH, unsigned IW, unsigned IC, unsigned IB,
    unsigned KH, unsigned KW, unsigned SH, unsigned SW,
    unsigned PH, unsigned PW,
    unsigned OC, unsigned OB,
    unsigned WB, unsigned ACCB, unsigned INCB, unsigned BB, unsigned MULB,
    unsigned PE, unsigned SIMD, unsigned LS,
    unsigned ACT_TYPE
>
void general_1d_conv_accelerator(
    hls::stream<ap_uint<SIMD * IB>>& in,
    hls::stream<ap_uint<WB>>& w,
    hls::stream<ap_uint<INCB>>& inc,
    hls::stream<ap_uint<BB>>& b,
    hls::stream<ap_uint<OB>>& out,
    const unsigned reps,
    bool load
) {
#pragma HLS DATAFLOW

    const unsigned OH = (IH + 2 * PH - KH) / SH + 1;
    const unsigned OW = (IW + 2 * PW - KW) / SW + 1;

    static hls::stream<ap_uint<SIMD * IB>> win_s;
#pragma HLS STREAM variable=win_s depth=512

    static hls::stream<ap_uint<PE * OB>> out_vec_s;
#pragma HLS STREAM variable=out_vec_s depth=128

    sliding_window_1d_general<IH, IW, KH, KW, SH, SW, PH, PW, IC, SIMD, IB>(
        in, win_s, reps
    );

    compute_unit_1d_emitlast_general<
        OH, OW, KH, KW, IC, OC,
        WB, IB, ACCB, INCB, BB, OB, MULB,
        SIMD, PE, LS, ACT_TYPE
    >(win_s, w, inc, b, out_vec_s, reps, load);

    serialize_packed_outputs_1d_general<OH, OW, OC, OB, PE>(
        out_vec_s, out, reps
    );
}

#endif
