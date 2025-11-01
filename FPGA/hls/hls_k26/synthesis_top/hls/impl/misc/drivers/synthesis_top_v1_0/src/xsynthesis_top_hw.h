// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2 (64-bit)
// Tool Version Limit: 2025.11
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
// control
// 0x00 : Control signals
//        bit 0  - ap_start (Read/Write/COH)
//        bit 1  - ap_done (Read/COR)
//        bit 2  - ap_idle (Read)
//        bit 3  - ap_ready (Read/COR)
//        bit 7  - auto_restart (Read/Write)
//        bit 9  - interrupt (Read)
//        others - reserved
// 0x04 : Global Interrupt Enable Register
//        bit 0  - Global Interrupt Enable (Read/Write)
//        others - reserved
// 0x08 : IP Interrupt Enable Register (Read/Write)
//        bit 0 - enable ap_done interrupt (Read/Write)
//        bit 1 - enable ap_ready interrupt (Read/Write)
//        others - reserved
// 0x0c : IP Interrupt Status Register (Read/TOW)
//        bit 0 - ap_done (Read/TOW)
//        bit 1 - ap_ready (Read/TOW)
//        others - reserved
// 0x10 : Data signal of num_samples
//        bit 31~0 - num_samples[31:0] (Read/Write)
// 0x14 : reserved
// 0x18 : Data signal of reload_weights
//        bit 0  - reload_weights[0] (Read/Write)
//        others - reserved
// 0x1c : reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define XSYNTHESIS_TOP_CONTROL_ADDR_AP_CTRL             0x00
#define XSYNTHESIS_TOP_CONTROL_ADDR_GIE                 0x04
#define XSYNTHESIS_TOP_CONTROL_ADDR_IER                 0x08
#define XSYNTHESIS_TOP_CONTROL_ADDR_ISR                 0x0c
#define XSYNTHESIS_TOP_CONTROL_ADDR_NUM_SAMPLES_DATA    0x10
#define XSYNTHESIS_TOP_CONTROL_BITS_NUM_SAMPLES_DATA    32
#define XSYNTHESIS_TOP_CONTROL_ADDR_RELOAD_WEIGHTS_DATA 0x18
#define XSYNTHESIS_TOP_CONTROL_BITS_RELOAD_WEIGHTS_DATA 1

// control_r
// 0x000 : reserved
// 0x004 : reserved
// 0x008 : reserved
// 0x00c : reserved
// 0x010 : Data signal of w1
//         bit 31~0 - w1[31:0] (Read/Write)
// 0x014 : Data signal of w1
//         bit 31~0 - w1[63:32] (Read/Write)
// 0x018 : reserved
// 0x01c : Data signal of inc1
//         bit 31~0 - inc1[31:0] (Read/Write)
// 0x020 : Data signal of inc1
//         bit 31~0 - inc1[63:32] (Read/Write)
// 0x024 : reserved
// 0x028 : Data signal of b1
//         bit 31~0 - b1[31:0] (Read/Write)
// 0x02c : Data signal of b1
//         bit 31~0 - b1[63:32] (Read/Write)
// 0x030 : reserved
// 0x034 : Data signal of w2
//         bit 31~0 - w2[31:0] (Read/Write)
// 0x038 : Data signal of w2
//         bit 31~0 - w2[63:32] (Read/Write)
// 0x03c : reserved
// 0x040 : Data signal of inc2
//         bit 31~0 - inc2[31:0] (Read/Write)
// 0x044 : Data signal of inc2
//         bit 31~0 - inc2[63:32] (Read/Write)
// 0x048 : reserved
// 0x04c : Data signal of b2
//         bit 31~0 - b2[31:0] (Read/Write)
// 0x050 : Data signal of b2
//         bit 31~0 - b2[63:32] (Read/Write)
// 0x054 : reserved
// 0x058 : Data signal of w3
//         bit 31~0 - w3[31:0] (Read/Write)
// 0x05c : Data signal of w3
//         bit 31~0 - w3[63:32] (Read/Write)
// 0x060 : reserved
// 0x064 : Data signal of inc3
//         bit 31~0 - inc3[31:0] (Read/Write)
// 0x068 : Data signal of inc3
//         bit 31~0 - inc3[63:32] (Read/Write)
// 0x06c : reserved
// 0x070 : Data signal of b3
//         bit 31~0 - b3[31:0] (Read/Write)
// 0x074 : Data signal of b3
//         bit 31~0 - b3[63:32] (Read/Write)
// 0x078 : reserved
// 0x07c : Data signal of w4
//         bit 31~0 - w4[31:0] (Read/Write)
// 0x080 : Data signal of w4
//         bit 31~0 - w4[63:32] (Read/Write)
// 0x084 : reserved
// 0x088 : Data signal of inc4
//         bit 31~0 - inc4[31:0] (Read/Write)
// 0x08c : Data signal of inc4
//         bit 31~0 - inc4[63:32] (Read/Write)
// 0x090 : reserved
// 0x094 : Data signal of b4
//         bit 31~0 - b4[31:0] (Read/Write)
// 0x098 : Data signal of b4
//         bit 31~0 - b4[63:32] (Read/Write)
// 0x09c : reserved
// 0x0a0 : Data signal of w5
//         bit 31~0 - w5[31:0] (Read/Write)
// 0x0a4 : Data signal of w5
//         bit 31~0 - w5[63:32] (Read/Write)
// 0x0a8 : reserved
// 0x0ac : Data signal of inc5
//         bit 31~0 - inc5[31:0] (Read/Write)
// 0x0b0 : Data signal of inc5
//         bit 31~0 - inc5[63:32] (Read/Write)
// 0x0b4 : reserved
// 0x0b8 : Data signal of b5
//         bit 31~0 - b5[31:0] (Read/Write)
// 0x0bc : Data signal of b5
//         bit 31~0 - b5[63:32] (Read/Write)
// 0x0c0 : reserved
// 0x0c4 : Data signal of w6
//         bit 31~0 - w6[31:0] (Read/Write)
// 0x0c8 : Data signal of w6
//         bit 31~0 - w6[63:32] (Read/Write)
// 0x0cc : reserved
// 0x0d0 : Data signal of inc6
//         bit 31~0 - inc6[31:0] (Read/Write)
// 0x0d4 : Data signal of inc6
//         bit 31~0 - inc6[63:32] (Read/Write)
// 0x0d8 : reserved
// 0x0dc : Data signal of b6
//         bit 31~0 - b6[31:0] (Read/Write)
// 0x0e0 : Data signal of b6
//         bit 31~0 - b6[63:32] (Read/Write)
// 0x0e4 : reserved
// 0x0e8 : Data signal of w7
//         bit 31~0 - w7[31:0] (Read/Write)
// 0x0ec : Data signal of w7
//         bit 31~0 - w7[63:32] (Read/Write)
// 0x0f0 : reserved
// 0x0f4 : Data signal of inc7
//         bit 31~0 - inc7[31:0] (Read/Write)
// 0x0f8 : Data signal of inc7
//         bit 31~0 - inc7[63:32] (Read/Write)
// 0x0fc : reserved
// 0x100 : Data signal of b7
//         bit 31~0 - b7[31:0] (Read/Write)
// 0x104 : Data signal of b7
//         bit 31~0 - b7[63:32] (Read/Write)
// 0x108 : reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define XSYNTHESIS_TOP_CONTROL_R_ADDR_W1_DATA   0x010
#define XSYNTHESIS_TOP_CONTROL_R_BITS_W1_DATA   64
#define XSYNTHESIS_TOP_CONTROL_R_ADDR_INC1_DATA 0x01c
#define XSYNTHESIS_TOP_CONTROL_R_BITS_INC1_DATA 64
#define XSYNTHESIS_TOP_CONTROL_R_ADDR_B1_DATA   0x028
#define XSYNTHESIS_TOP_CONTROL_R_BITS_B1_DATA   64
#define XSYNTHESIS_TOP_CONTROL_R_ADDR_W2_DATA   0x034
#define XSYNTHESIS_TOP_CONTROL_R_BITS_W2_DATA   64
#define XSYNTHESIS_TOP_CONTROL_R_ADDR_INC2_DATA 0x040
#define XSYNTHESIS_TOP_CONTROL_R_BITS_INC2_DATA 64
#define XSYNTHESIS_TOP_CONTROL_R_ADDR_B2_DATA   0x04c
#define XSYNTHESIS_TOP_CONTROL_R_BITS_B2_DATA   64
#define XSYNTHESIS_TOP_CONTROL_R_ADDR_W3_DATA   0x058
#define XSYNTHESIS_TOP_CONTROL_R_BITS_W3_DATA   64
#define XSYNTHESIS_TOP_CONTROL_R_ADDR_INC3_DATA 0x064
#define XSYNTHESIS_TOP_CONTROL_R_BITS_INC3_DATA 64
#define XSYNTHESIS_TOP_CONTROL_R_ADDR_B3_DATA   0x070
#define XSYNTHESIS_TOP_CONTROL_R_BITS_B3_DATA   64
#define XSYNTHESIS_TOP_CONTROL_R_ADDR_W4_DATA   0x07c
#define XSYNTHESIS_TOP_CONTROL_R_BITS_W4_DATA   64
#define XSYNTHESIS_TOP_CONTROL_R_ADDR_INC4_DATA 0x088
#define XSYNTHESIS_TOP_CONTROL_R_BITS_INC4_DATA 64
#define XSYNTHESIS_TOP_CONTROL_R_ADDR_B4_DATA   0x094
#define XSYNTHESIS_TOP_CONTROL_R_BITS_B4_DATA   64
#define XSYNTHESIS_TOP_CONTROL_R_ADDR_W5_DATA   0x0a0
#define XSYNTHESIS_TOP_CONTROL_R_BITS_W5_DATA   64
#define XSYNTHESIS_TOP_CONTROL_R_ADDR_INC5_DATA 0x0ac
#define XSYNTHESIS_TOP_CONTROL_R_BITS_INC5_DATA 64
#define XSYNTHESIS_TOP_CONTROL_R_ADDR_B5_DATA   0x0b8
#define XSYNTHESIS_TOP_CONTROL_R_BITS_B5_DATA   64
#define XSYNTHESIS_TOP_CONTROL_R_ADDR_W6_DATA   0x0c4
#define XSYNTHESIS_TOP_CONTROL_R_BITS_W6_DATA   64
#define XSYNTHESIS_TOP_CONTROL_R_ADDR_INC6_DATA 0x0d0
#define XSYNTHESIS_TOP_CONTROL_R_BITS_INC6_DATA 64
#define XSYNTHESIS_TOP_CONTROL_R_ADDR_B6_DATA   0x0dc
#define XSYNTHESIS_TOP_CONTROL_R_BITS_B6_DATA   64
#define XSYNTHESIS_TOP_CONTROL_R_ADDR_W7_DATA   0x0e8
#define XSYNTHESIS_TOP_CONTROL_R_BITS_W7_DATA   64
#define XSYNTHESIS_TOP_CONTROL_R_ADDR_INC7_DATA 0x0f4
#define XSYNTHESIS_TOP_CONTROL_R_BITS_INC7_DATA 64
#define XSYNTHESIS_TOP_CONTROL_R_ADDR_B7_DATA   0x100
#define XSYNTHESIS_TOP_CONTROL_R_BITS_B7_DATA   64

