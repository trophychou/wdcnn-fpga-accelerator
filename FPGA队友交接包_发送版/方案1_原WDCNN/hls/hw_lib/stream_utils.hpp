#ifndef __STREAM_UTILS_HPP__
#define __STREAM_UTILS_HPP__
#include <ap_int.h>
#include <hls_stream.h>
#include <ap_axi_sdata.h>

// 1. AXI 512 -> Stream 8
template <int TOTAL_BYTES>
void axis_512_to_hls_stream_8(
    hls::stream<ap_axiu<512, 0, 0, 0>>& in_axi,
    hls::stream<ap_uint<8>>& out_hls,
    const unsigned reps
) {
    #pragma HLS INLINE OFF
    // 每次处理 64 字节 (512 bit)
    const int NUM_PACKETS = TOTAL_BYTES / 64; 
    for (unsigned r = 0; r < reps; ++r) {
        for (int i = 0; i < NUM_PACKETS; i++) {
            ap_axiu<512, 0, 0, 0> packet = in_axi.read();
            for (int j = 0; j < 64; j++) {
                #pragma HLS PIPELINE II=1
                out_hls.write(packet.data.range((j + 1) * 8 - 1, j * 8));
            }
        }
    }
}

// 2. Stream 8 -> AXI 
template <int W_IN, int NUM_WORDS>
void hls_stream_to_axis(
    hls::stream<ap_uint<W_IN>>& in_hls,
    hls::stream<ap_axiu<W_IN, 0, 0, 0>>& out_axi,
    const unsigned reps
) {
    #pragma HLS INLINE OFF
    for (unsigned r = 0; r < reps; ++r) {
        for (int i = 0; i < NUM_WORDS; i++) {
            #pragma HLS PIPELINE II=1
            ap_axiu<W_IN, 0, 0, 0> packet;
            packet.data = in_hls.read();
            packet.keep = -1; packet.strb = -1; packet.id = 0; packet.dest = 0; packet.user = 0;
//          packet.last = (i == NUM_WORDS - 1) ? 1 : 0;
            packet.last = ((r == reps - 1) && (i == NUM_WORDS - 1)) ? 1 : 0;
	    out_axi.write(packet);
        }
    }
}

// 3. Width Adjuster (通用位宽转换)
template <int W_IN, int W_OUT, int NUM_IN_WORDS>
void stream_width_adjust(
    hls::stream<ap_uint<W_IN>>& in,
    hls::stream<ap_uint<W_OUT>>& out,
    const unsigned reps
) {
    #pragma HLS INLINE OFF
    if (reps == 0) return;

    if (W_IN == W_OUT) {
        for (unsigned r = 0; r < reps; ++r) {
            for (int i = 0; i < NUM_IN_WORDS; i++) {
#pragma HLS PIPELINE II=1
                out.write(in.read());
            }
        }
    } else if (W_OUT > W_IN) {
        // Upsize (e.g. 8 -> 32)
        // 假设 W_OUT 是 W_IN 的整数倍
        const int RATIO = W_OUT / W_IN;
        const int OUT_WORDS = NUM_IN_WORDS / RATIO;
        
        for (unsigned r = 0; r < reps; ++r) {
            for (int i = 0; i < OUT_WORDS; i++) {
#pragma HLS PIPELINE II=RATIO
                ap_uint<W_OUT> wide_data = 0;
                for (int j = 0; j < RATIO; j++) {
                    wide_data.range((j + 1) * W_IN - 1, j * W_IN) = in.read();
                }
                out.write(wide_data);
            }
        }
    } else {
        // Downsize (e.g. 32 -> 8)
        const int RATIO = W_IN / W_OUT;
        for (unsigned r = 0; r < reps; ++r) {
            for (int i = 0; i < NUM_IN_WORDS; i++) {
#pragma HLS PIPELINE II=RATIO
                ap_uint<W_IN> wide_data = in.read();
                for (int j = 0; j < RATIO; j++) {
                    out.write(wide_data.range((j + 1) * W_OUT - 1, j * W_OUT));
                }
            }
        }
    }
}

// 4. Flexible width adjust.
// Fast paths preserve the original efficient behavior for divisible ratios.
// The fallback supports arbitrary bit packing/unpacking with zero padding.
template <int W_IN, int W_OUT, int NUM_IN_WORDS>
void stream_width_adjust_flex(
    hls::stream<ap_uint<W_IN>>& in,
    hls::stream<ap_uint<W_OUT>>& out,
    const unsigned reps
) {
#pragma HLS INLINE OFF
    if (reps == 0) return;

    if (W_IN == W_OUT) {
        for (unsigned r = 0; r < reps; ++r) {
            for (int i = 0; i < NUM_IN_WORDS; i++) {
#pragma HLS PIPELINE II=1
                out.write(in.read());
            }
        }
    } else if ((W_OUT > W_IN) && (W_OUT % W_IN == 0) && (NUM_IN_WORDS % (W_OUT / W_IN) == 0)) {
        const int RATIO = W_OUT / W_IN;
        const int OUT_WORDS = NUM_IN_WORDS / RATIO;

        for (unsigned r = 0; r < reps; ++r) {
            for (int i = 0; i < OUT_WORDS; i++) {
#pragma HLS PIPELINE II=RATIO
                ap_uint<W_OUT> wide_data = 0;
                for (int j = 0; j < RATIO; j++) {
                    wide_data.range((j + 1) * W_IN - 1, j * W_IN) = in.read();
                }
                out.write(wide_data);
            }
        }
    } else if ((W_IN > W_OUT) && (W_IN % W_OUT == 0)) {
        const int RATIO = W_IN / W_OUT;

        for (unsigned r = 0; r < reps; ++r) {
            for (int i = 0; i < NUM_IN_WORDS; i++) {
#pragma HLS PIPELINE II=RATIO
                ap_uint<W_IN> wide_data = in.read();
                for (int j = 0; j < RATIO; j++) {
                    out.write(wide_data.range((j + 1) * W_OUT - 1, j * W_OUT));
                }
            }
        }
    } else {
        const int TOTAL_BITS = NUM_IN_WORDS * W_IN;
        const int NUM_OUT_WORDS = (TOTAL_BITS + W_OUT - 1) / W_OUT;
        const int ACC_WIDTH = W_IN + W_OUT;
        const int TOTAL_STEPS = NUM_IN_WORDS + NUM_OUT_WORDS;

        for (unsigned r = 0; r < reps; ++r) {
            ap_uint<ACC_WIDTH> acc = 0;
            int valid_bits = 0;
            int in_count = 0;
            int out_count = 0;

            for (int step = 0; step < TOTAL_STEPS; ++step) {
#pragma HLS PIPELINE II=1
                bool need_write = (valid_bits >= W_OUT) ||
                                  ((in_count == NUM_IN_WORDS) && (out_count < NUM_OUT_WORDS));

                if (need_write) {
                    ap_uint<W_OUT> y = acc.range(W_OUT - 1, 0);
                    out.write(y);

                    acc >>= W_OUT;
                    valid_bits = (valid_bits > W_OUT) ? (valid_bits - W_OUT) : 0;
                    out_count++;
                } else {
                    ap_uint<W_IN> x = in.read();
                    acc |= ((ap_uint<ACC_WIDTH>)x << valid_bits);
                    valid_bits += W_IN;
                    in_count++;
                }
            }
        }
    }
}

#endif
