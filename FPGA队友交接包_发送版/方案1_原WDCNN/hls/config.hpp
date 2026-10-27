#pragma once
#include <ap_int.h>
#include "activation_utils.hpp"

// =========================================================
// TARGET_PLATFORM | FPGA
// Utilization-Driven Pipeline Balance
// =========================================================

const float    S_IN_SCALE   = 5.0873f;
const unsigned  AXI_WIDTH_IN = 512;
const unsigned  AXI_WIDTH_OUT= 32;
const unsigned  INPUT_ELEMS  = 5120;

// Global quantization / accumulation precision
const unsigned Q_INC_BIT   = 16;
const unsigned Q_B_BIT     = 32;
const unsigned Q_ACC_BIT   = 32;
const unsigned Q_MUL_BIT   = 64;

// L1: Conv1 | cycles=46336 | MAC~99% | stream_risk=0.85
const unsigned L1_IN_H      = 1;
const unsigned L1_IN_W      = 5120;
const unsigned L1_IN_CH     = 1;
const unsigned L1_KH        = 1;
const unsigned L1_KW        = 64;
const unsigned L1_SH        = 1;
const unsigned L1_SW        = 7;
const unsigned L1_PH        = 0;
const unsigned L1_PW        = 1;
const unsigned L1_ACT_TYPE  = ACT_RELU;
const unsigned L1_OUT_CH    = 16;
const unsigned L1_CONV_OUT_H= 1;
const unsigned L1_CONV_OUT_W= 723;
const unsigned L1_POOL_COUNT = 1;
const bool L1_POOL_IS_MAX = true;
const bool L1_POOL_SIGNED_COMPARE = false;
const unsigned L1_P1_IN_H = 1;
const unsigned L1_P1_IN_W = 723;
const unsigned L1_P1_OUT_H = 1;
const unsigned L1_P1_OUT_W = 361;
const unsigned L1_P1_KH = 1;
const unsigned L1_P1_KW = 2;
const unsigned L1_P1_SH = 1;
const unsigned L1_P1_SW = 2;
const unsigned L1_POOL_OUT_H= 1;
const unsigned L1_POOL_OUT_W= 361;
const unsigned L1_OUT_ELEMS = 5776;
const unsigned L1_PE        = 16;
const unsigned L1_SIMD      = 1;
const int      L1_SHIFT     = 17;
const int      L1_INC       = 363;
const unsigned L1_W_BIT     = 8;
const unsigned L1_A_BIT     = 8;

// L2: Conv2 | cycles=69324 | MAC~99% | stream_risk=0.45
const unsigned L2_IN_H      = 1;
const unsigned L2_IN_W      = 361;
const unsigned L2_IN_CH     = 16;
const unsigned L2_KH        = 1;
const unsigned L2_KW        = 3;
const unsigned L2_SH        = 1;
const unsigned L2_SW        = 1;
const unsigned L2_PH        = 0;
const unsigned L2_PW        = 1;
const unsigned L2_ACT_TYPE  = ACT_RELU;
const unsigned L2_OUT_CH    = 32;
const unsigned L2_CONV_OUT_H= 1;
const unsigned L2_CONV_OUT_W= 361;
const unsigned L2_POOL_COUNT = 1;
const bool L2_POOL_IS_MAX = true;
const bool L2_POOL_SIGNED_COMPARE = false;
const unsigned L2_P1_IN_H = 1;
const unsigned L2_P1_IN_W = 361;
const unsigned L2_P1_OUT_H = 1;
const unsigned L2_P1_OUT_W = 180;
const unsigned L2_P1_KH = 1;
const unsigned L2_P1_KW = 2;
const unsigned L2_P1_SH = 1;
const unsigned L2_P1_SW = 2;
const unsigned L2_POOL_OUT_H= 1;
const unsigned L2_POOL_OUT_W= 180;
const unsigned L2_OUT_ELEMS = 5760;
const unsigned L2_PE        = 2;
const unsigned L2_SIMD      = 4;
const int      L2_SHIFT     = 15;
const int      L2_INC       = 155;
const unsigned L2_W_BIT     = 8;
const unsigned L2_A_BIT     = 8;

// L3: Conv3 | cycles=69144 | MAC~99% | stream_risk=0.45
const unsigned L3_IN_H      = 1;
const unsigned L3_IN_W      = 180;
const unsigned L3_IN_CH     = 32;
const unsigned L3_KH        = 1;
const unsigned L3_KW        = 3;
const unsigned L3_SH        = 1;
const unsigned L3_SW        = 1;
const unsigned L3_PH        = 0;
const unsigned L3_PW        = 1;
const unsigned L3_ACT_TYPE  = ACT_RELU;
const unsigned L3_OUT_CH    = 64;
const unsigned L3_CONV_OUT_H= 1;
const unsigned L3_CONV_OUT_W= 180;
const unsigned L3_POOL_COUNT = 1;
const bool L3_POOL_IS_MAX = true;
const bool L3_POOL_SIGNED_COMPARE = false;
const unsigned L3_P1_IN_H = 1;
const unsigned L3_P1_IN_W = 180;
const unsigned L3_P1_OUT_H = 1;
const unsigned L3_P1_OUT_W = 90;
const unsigned L3_P1_KH = 1;
const unsigned L3_P1_KW = 2;
const unsigned L3_P1_SH = 1;
const unsigned L3_P1_SW = 2;
const unsigned L3_POOL_OUT_H= 1;
const unsigned L3_POOL_OUT_W= 90;
const unsigned L3_OUT_ELEMS = 5760;
const unsigned L3_PE        = 4;
const unsigned L3_SIMD      = 4;
const int      L3_SHIFT     = 17;
const int      L3_INC       = 421;
const unsigned L3_W_BIT     = 8;
const unsigned L3_A_BIT     = 8;

// L4: Conv4 | cycles=69168 | MAC~99% | stream_risk=0.42
const unsigned L4_IN_H      = 1;
const unsigned L4_IN_W      = 90;
const unsigned L4_IN_CH     = 64;
const unsigned L4_KH        = 1;
const unsigned L4_KW        = 3;
const unsigned L4_SH        = 1;
const unsigned L4_SW        = 1;
const unsigned L4_PH        = 0;
const unsigned L4_PW        = 1;
const unsigned L4_ACT_TYPE  = ACT_RELU;
const unsigned L4_OUT_CH    = 64;
const unsigned L4_CONV_OUT_H= 1;
const unsigned L4_CONV_OUT_W= 90;
const unsigned L4_POOL_COUNT = 1;
const bool L4_POOL_IS_MAX = true;
const bool L4_POOL_SIGNED_COMPARE = false;
const unsigned L4_P1_IN_H = 1;
const unsigned L4_P1_IN_W = 90;
const unsigned L4_P1_OUT_H = 1;
const unsigned L4_P1_OUT_W = 45;
const unsigned L4_P1_KH = 1;
const unsigned L4_P1_KW = 2;
const unsigned L4_P1_SH = 1;
const unsigned L4_P1_SW = 2;
const unsigned L4_POOL_OUT_H= 1;
const unsigned L4_POOL_OUT_W= 45;
const unsigned L4_OUT_ELEMS = 2880;
const unsigned L4_PE        = 4;
const unsigned L4_SIMD      = 4;
const int      L4_SHIFT     = 16;
const int      L4_INC       = 223;
const unsigned L4_W_BIT     = 8;
const unsigned L4_A_BIT     = 8;

// L5: Conv5 | cycles=66144 | MAC~99% | stream_risk=0.42
const unsigned L5_IN_H      = 1;
const unsigned L5_IN_W      = 45;
const unsigned L5_IN_CH     = 64;
const unsigned L5_KH        = 1;
const unsigned L5_KW        = 3;
const unsigned L5_SH        = 1;
const unsigned L5_SW        = 1;
const unsigned L5_PH        = 0;
const unsigned L5_PW        = 0;
const unsigned L5_ACT_TYPE  = ACT_RELU;
const unsigned L5_OUT_CH    = 64;
const unsigned L5_CONV_OUT_H= 1;
const unsigned L5_CONV_OUT_W= 43;
const unsigned L5_POOL_COUNT = 1;
const bool L5_POOL_IS_MAX = true;
const bool L5_POOL_SIGNED_COMPARE = false;
const unsigned L5_P1_IN_H = 1;
const unsigned L5_P1_IN_W = 43;
const unsigned L5_P1_OUT_H = 1;
const unsigned L5_P1_OUT_W = 21;
const unsigned L5_P1_KH = 1;
const unsigned L5_P1_KW = 2;
const unsigned L5_P1_SH = 1;
const unsigned L5_P1_SW = 2;
const unsigned L5_POOL_OUT_H= 1;
const unsigned L5_POOL_OUT_W= 21;
const unsigned L5_OUT_ELEMS = 1344;
const unsigned L5_PE        = 4;
const unsigned L5_SIMD      = 2;
const int      L5_SHIFT     = 16;
const int      L5_INC       = 211;
const unsigned L5_W_BIT     = 8;
const unsigned L5_A_BIT     = 8;

// L6: FC1 | cycles=68544 | MAC~98% | stream_risk=0.00
const unsigned L6_IN_H      = 1;
const unsigned L6_IN_W      = 1;
const unsigned L6_IN_CH     = 1344;
const unsigned L6_KH        = 1;
const unsigned L6_KW        = 1;
const unsigned L6_SH        = 1;
const unsigned L6_SW        = 1;
const unsigned L6_PH        = 0;
const unsigned L6_PW        = 0;
const unsigned L6_ACT_TYPE  = ACT_RELU;
const unsigned L6_OUT_CH    = 100;
const unsigned L6_CONV_OUT_H= 1;
const unsigned L6_CONV_OUT_W= 1;
const unsigned L6_POOL_OUT_H= 1;
const unsigned L6_POOL_OUT_W= 1;
const unsigned L6_OUT_ELEMS = 100;
const unsigned L6_PE        = 2;
const unsigned L6_SIMD      = 1;
const int      L6_SHIFT     = 17;
const int      L6_INC       = 25;
const unsigned L6_W_BIT     = 8;
const unsigned L6_A_BIT     = 8;

// L7: FC2 | cycles=500 | MAC~80% | stream_risk=0.05
const unsigned L7_IN_H      = 1;
const unsigned L7_IN_W      = 1;
const unsigned L7_IN_CH     = 100;
const unsigned L7_KH        = 1;
const unsigned L7_KW        = 1;
const unsigned L7_SH        = 1;
const unsigned L7_SW        = 1;
const unsigned L7_PH        = 0;
const unsigned L7_PW        = 0;
const unsigned L7_ACT_TYPE  = ACT_NONE;
const unsigned L7_OUT_CH    = 4;
const unsigned L7_CONV_OUT_H= 1;
const unsigned L7_CONV_OUT_W= 1;
const unsigned L7_POOL_OUT_H= 1;
const unsigned L7_POOL_OUT_W= 1;
const unsigned L7_OUT_ELEMS = 4;
const unsigned L7_PE        = 1;
const unsigned L7_SIMD      = 1;
const int      L7_SHIFT     = 15;
const int      L7_INC       = 41;
const unsigned L7_W_BIT     = 8;
const unsigned L7_A_BIT     = 8;

