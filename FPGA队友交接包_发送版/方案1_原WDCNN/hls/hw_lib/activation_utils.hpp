#ifndef __ACTIVATION_UTILS_HPP__
#define __ACTIVATION_UTILS_HPP__

#include <ap_int.h>

const unsigned ACT_NONE = 0;
const unsigned ACT_RELU = 1;
const unsigned ACT_TANH = 2;

template <int IN_BIT, int OUT_BIT>
ap_int<OUT_BIT> saturate_int8_act(ap_int<IN_BIT> x) {
#pragma HLS INLINE

    if (x > 127) {
        return 127;
    }
    if (x < -128) {
        return -128;
    }
    return (ap_int<OUT_BIT>)x;
}

template <int IN_BIT, int OUT_BIT>
ap_int<OUT_BIT> relu_act(ap_int<IN_BIT> x) {
#pragma HLS INLINE

    if (x < 0) {
        return 0;
    }
    if (x > 127) {
        return 127;
    }
    return (ap_int<OUT_BIT>)x;
}

template <int IN_BIT, int OUT_BIT>
ap_int<OUT_BIT> tanh_pwl_act(ap_int<IN_BIT> x) {
#pragma HLS INLINE

    const int TANH_IN_SCALE = 64;

    ap_int<IN_BIT> ax = (x < 0) ? (ap_int<IN_BIT>)(-x) : x;
    ap_int<OUT_BIT> y;

    if (ax >= 3 * TANH_IN_SCALE) {
        y = 127;
    } else if (ax >= 2 * TANH_IN_SCALE) {
        y = 121 + ((ax - 2 * TANH_IN_SCALE) >> 4);
    } else if (ax >= 1 * TANH_IN_SCALE) {
        y = 95 + ((ax - 1 * TANH_IN_SCALE) >> 2);
    } else {
        y = (ax * 3) >> 1;
    }

    if (y > 127) {
        y = 127;
    }

    if (x < 0) {
        y = -y;
    }

    return y;
}

template <unsigned ACT_TYPE, int IN_BIT, int OUT_BIT>
ap_int<OUT_BIT> apply_activation(ap_int<IN_BIT> x) {
#pragma HLS INLINE

    if (ACT_TYPE == ACT_RELU) {
        return relu_act<IN_BIT, OUT_BIT>(x);
    }

    if (ACT_TYPE == ACT_TANH) {
        return tanh_pwl_act<IN_BIT, OUT_BIT>(x);
    }

    return saturate_int8_act<IN_BIT, OUT_BIT>(x);
}

#endif