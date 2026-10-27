#ifndef __POOL_ACCELERATOR_HPP__
#define __POOL_ACCELERATOR_HPP__

#include <ap_int.h>
#include <hls_stream.h>

template <unsigned IN_H, unsigned IN_W, unsigned IN_CH, unsigned BIT,
          unsigned KH, unsigned KW, unsigned SH, unsigned SW,
          bool IS_MAX, bool SIGNED_COMPARE>
void pool_accelerator(
    hls::stream<ap_uint<BIT>>& in,
    hls::stream<ap_uint<BIT>>& out,
    const unsigned reps
) {
    const unsigned LB_ROWS = (KH > 1) ? (KH - 1) : 1;
    const unsigned LB_DEPTH = (IN_H > 1) ? IN_W : 1;

    static ap_uint<BIT> line_buf[LB_ROWS][LB_DEPTH][IN_CH];
#pragma HLS ARRAY_PARTITION variable=line_buf complete dim=1

    static ap_uint<BIT> window[KH][KW][IN_CH];
#pragma HLS ARRAY_PARTITION variable=window complete dim=1
#pragma HLS ARRAY_PARTITION variable=window complete dim=2

    for (unsigned rep = 0; rep < reps; ++rep) {
        for (unsigned r = 0; r < IN_H; ++r) {
            for (unsigned c = 0; c < IN_W; ++c) {
                for (unsigned ch = 0; ch < IN_CH; ++ch) {
#pragma HLS PIPELINE II=1

                    ap_uint<BIT> val_in = in.read();

                    if (IN_H == 1) {
                        for (int j = 0; j < KW - 1; ++j) {
                            window[0][j][ch] = window[0][j + 1][ch];
                        }
                        window[0][KW - 1][ch] = val_in;
                    } else {
                        ap_uint<BIT> col[KH];
#pragma HLS ARRAY_PARTITION variable=col complete

                        if (KH > 1) {
                            unsigned c_idx = c % LB_DEPTH;

                            for (int k = 0; k < KH - 1; ++k) {
                                col[k] = line_buf[k][c_idx][ch];
                            }

                            for (int k = 0; k < KH - 2; ++k) {
                                line_buf[k][c_idx][ch] = line_buf[k + 1][c_idx][ch];
                            }

                            line_buf[KH - 2][c_idx][ch] = val_in;
                        }

                        col[KH - 1] = val_in;

                        for (int i = 0; i < KH; ++i) {
                            for (int j = 0; j < KW - 1; ++j) {
                                window[i][j][ch] = window[i][j + 1][ch];
                            }
                            window[i][KW - 1][ch] = col[i];
                        }
                    }

                    bool valid_r = (r >= KH - 1) && ((r - (KH - 1)) % SH == 0);
                    bool valid_c = (c >= KW - 1) && ((c - (KW - 1)) % SW == 0);

                    if (valid_r && valid_c) {
                        ap_uint<BIT> res_u = window[0][0][ch];
                        ap_int<BIT>  res_s = (ap_int<BIT>)res_u;

                        for (int i = 0; i < KH; ++i) {
                            for (int j = 0; j < KW; ++j) {
                                ap_uint<BIT> v_u = window[i][j][ch];
                                ap_int<BIT>  v_s = (ap_int<BIT>)v_u;

                                if (IS_MAX) {
                                    if (SIGNED_COMPARE) {
                                        if (v_s > res_s) {
                                            res_s = v_s;
                                            res_u = v_u;
                                        }
                                    } else {
                                        if (v_u > res_u) {
                                            res_u = v_u;
                                            res_s = v_s;
                                        }
                                    }
                                } else {
                                    if (i == 0 && j == 0) {
                                        res_u = v_u;
                                        res_s = v_s;
                                    } else {
                                        res_u += v_u;
                                        res_s = (ap_int<BIT>)res_u;
                                    }
                                }
                            }
                        }

                        if (!IS_MAX) {
                            res_u = res_u / (KH * KW);
                        }

                        out.write(res_u);
                    }
                }
            }
        }
    }
}

#endif