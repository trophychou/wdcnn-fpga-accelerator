// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2 (64-bit)
// Tool Version Limit: 2025.11
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xsynthesis_top.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XSynthesis_top_CfgInitialize(XSynthesis_top *InstancePtr, XSynthesis_top_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->Control_r_BaseAddress = ConfigPtr->Control_r_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XSynthesis_top_Start(XSynthesis_top *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSynthesis_top_ReadReg(InstancePtr->Control_BaseAddress, XSYNTHESIS_TOP_CONTROL_ADDR_AP_CTRL) & 0x80;
    XSynthesis_top_WriteReg(InstancePtr->Control_BaseAddress, XSYNTHESIS_TOP_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XSynthesis_top_IsDone(XSynthesis_top *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSynthesis_top_ReadReg(InstancePtr->Control_BaseAddress, XSYNTHESIS_TOP_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XSynthesis_top_IsIdle(XSynthesis_top *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSynthesis_top_ReadReg(InstancePtr->Control_BaseAddress, XSYNTHESIS_TOP_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XSynthesis_top_IsReady(XSynthesis_top *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSynthesis_top_ReadReg(InstancePtr->Control_BaseAddress, XSYNTHESIS_TOP_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XSynthesis_top_EnableAutoRestart(XSynthesis_top *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSynthesis_top_WriteReg(InstancePtr->Control_BaseAddress, XSYNTHESIS_TOP_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XSynthesis_top_DisableAutoRestart(XSynthesis_top *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSynthesis_top_WriteReg(InstancePtr->Control_BaseAddress, XSYNTHESIS_TOP_CONTROL_ADDR_AP_CTRL, 0);
}

void XSynthesis_top_Set_num_samples(XSynthesis_top *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSynthesis_top_WriteReg(InstancePtr->Control_BaseAddress, XSYNTHESIS_TOP_CONTROL_ADDR_NUM_SAMPLES_DATA, Data);
}

u32 XSynthesis_top_Get_num_samples(XSynthesis_top *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSynthesis_top_ReadReg(InstancePtr->Control_BaseAddress, XSYNTHESIS_TOP_CONTROL_ADDR_NUM_SAMPLES_DATA);
    return Data;
}

void XSynthesis_top_Set_reload_weights(XSynthesis_top *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSynthesis_top_WriteReg(InstancePtr->Control_BaseAddress, XSYNTHESIS_TOP_CONTROL_ADDR_RELOAD_WEIGHTS_DATA, Data);
}

u32 XSynthesis_top_Get_reload_weights(XSynthesis_top *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSynthesis_top_ReadReg(InstancePtr->Control_BaseAddress, XSYNTHESIS_TOP_CONTROL_ADDR_RELOAD_WEIGHTS_DATA);
    return Data;
}

void XSynthesis_top_Set_w1(XSynthesis_top *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_W1_DATA, (u32)(Data));
    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_W1_DATA + 4, (u32)(Data >> 32));
}

u64 XSynthesis_top_Get_w1(XSynthesis_top *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_W1_DATA);
    Data += (u64)XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_W1_DATA + 4) << 32;
    return Data;
}

void XSynthesis_top_Set_inc1(XSynthesis_top *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_INC1_DATA, (u32)(Data));
    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_INC1_DATA + 4, (u32)(Data >> 32));
}

u64 XSynthesis_top_Get_inc1(XSynthesis_top *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_INC1_DATA);
    Data += (u64)XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_INC1_DATA + 4) << 32;
    return Data;
}

void XSynthesis_top_Set_b1(XSynthesis_top *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_B1_DATA, (u32)(Data));
    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_B1_DATA + 4, (u32)(Data >> 32));
}

u64 XSynthesis_top_Get_b1(XSynthesis_top *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_B1_DATA);
    Data += (u64)XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_B1_DATA + 4) << 32;
    return Data;
}

void XSynthesis_top_Set_w2(XSynthesis_top *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_W2_DATA, (u32)(Data));
    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_W2_DATA + 4, (u32)(Data >> 32));
}

u64 XSynthesis_top_Get_w2(XSynthesis_top *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_W2_DATA);
    Data += (u64)XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_W2_DATA + 4) << 32;
    return Data;
}

void XSynthesis_top_Set_inc2(XSynthesis_top *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_INC2_DATA, (u32)(Data));
    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_INC2_DATA + 4, (u32)(Data >> 32));
}

u64 XSynthesis_top_Get_inc2(XSynthesis_top *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_INC2_DATA);
    Data += (u64)XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_INC2_DATA + 4) << 32;
    return Data;
}

void XSynthesis_top_Set_b2(XSynthesis_top *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_B2_DATA, (u32)(Data));
    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_B2_DATA + 4, (u32)(Data >> 32));
}

u64 XSynthesis_top_Get_b2(XSynthesis_top *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_B2_DATA);
    Data += (u64)XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_B2_DATA + 4) << 32;
    return Data;
}

void XSynthesis_top_Set_w3(XSynthesis_top *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_W3_DATA, (u32)(Data));
    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_W3_DATA + 4, (u32)(Data >> 32));
}

u64 XSynthesis_top_Get_w3(XSynthesis_top *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_W3_DATA);
    Data += (u64)XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_W3_DATA + 4) << 32;
    return Data;
}

void XSynthesis_top_Set_inc3(XSynthesis_top *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_INC3_DATA, (u32)(Data));
    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_INC3_DATA + 4, (u32)(Data >> 32));
}

u64 XSynthesis_top_Get_inc3(XSynthesis_top *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_INC3_DATA);
    Data += (u64)XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_INC3_DATA + 4) << 32;
    return Data;
}

void XSynthesis_top_Set_b3(XSynthesis_top *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_B3_DATA, (u32)(Data));
    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_B3_DATA + 4, (u32)(Data >> 32));
}

u64 XSynthesis_top_Get_b3(XSynthesis_top *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_B3_DATA);
    Data += (u64)XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_B3_DATA + 4) << 32;
    return Data;
}

void XSynthesis_top_Set_w4(XSynthesis_top *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_W4_DATA, (u32)(Data));
    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_W4_DATA + 4, (u32)(Data >> 32));
}

u64 XSynthesis_top_Get_w4(XSynthesis_top *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_W4_DATA);
    Data += (u64)XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_W4_DATA + 4) << 32;
    return Data;
}

void XSynthesis_top_Set_inc4(XSynthesis_top *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_INC4_DATA, (u32)(Data));
    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_INC4_DATA + 4, (u32)(Data >> 32));
}

u64 XSynthesis_top_Get_inc4(XSynthesis_top *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_INC4_DATA);
    Data += (u64)XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_INC4_DATA + 4) << 32;
    return Data;
}

void XSynthesis_top_Set_b4(XSynthesis_top *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_B4_DATA, (u32)(Data));
    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_B4_DATA + 4, (u32)(Data >> 32));
}

u64 XSynthesis_top_Get_b4(XSynthesis_top *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_B4_DATA);
    Data += (u64)XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_B4_DATA + 4) << 32;
    return Data;
}

void XSynthesis_top_Set_w5(XSynthesis_top *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_W5_DATA, (u32)(Data));
    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_W5_DATA + 4, (u32)(Data >> 32));
}

u64 XSynthesis_top_Get_w5(XSynthesis_top *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_W5_DATA);
    Data += (u64)XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_W5_DATA + 4) << 32;
    return Data;
}

void XSynthesis_top_Set_inc5(XSynthesis_top *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_INC5_DATA, (u32)(Data));
    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_INC5_DATA + 4, (u32)(Data >> 32));
}

u64 XSynthesis_top_Get_inc5(XSynthesis_top *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_INC5_DATA);
    Data += (u64)XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_INC5_DATA + 4) << 32;
    return Data;
}

void XSynthesis_top_Set_b5(XSynthesis_top *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_B5_DATA, (u32)(Data));
    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_B5_DATA + 4, (u32)(Data >> 32));
}

u64 XSynthesis_top_Get_b5(XSynthesis_top *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_B5_DATA);
    Data += (u64)XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_B5_DATA + 4) << 32;
    return Data;
}

void XSynthesis_top_Set_w6(XSynthesis_top *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_W6_DATA, (u32)(Data));
    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_W6_DATA + 4, (u32)(Data >> 32));
}

u64 XSynthesis_top_Get_w6(XSynthesis_top *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_W6_DATA);
    Data += (u64)XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_W6_DATA + 4) << 32;
    return Data;
}

void XSynthesis_top_Set_inc6(XSynthesis_top *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_INC6_DATA, (u32)(Data));
    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_INC6_DATA + 4, (u32)(Data >> 32));
}

u64 XSynthesis_top_Get_inc6(XSynthesis_top *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_INC6_DATA);
    Data += (u64)XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_INC6_DATA + 4) << 32;
    return Data;
}

void XSynthesis_top_Set_b6(XSynthesis_top *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_B6_DATA, (u32)(Data));
    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_B6_DATA + 4, (u32)(Data >> 32));
}

u64 XSynthesis_top_Get_b6(XSynthesis_top *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_B6_DATA);
    Data += (u64)XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_B6_DATA + 4) << 32;
    return Data;
}

void XSynthesis_top_Set_w7(XSynthesis_top *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_W7_DATA, (u32)(Data));
    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_W7_DATA + 4, (u32)(Data >> 32));
}

u64 XSynthesis_top_Get_w7(XSynthesis_top *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_W7_DATA);
    Data += (u64)XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_W7_DATA + 4) << 32;
    return Data;
}

void XSynthesis_top_Set_inc7(XSynthesis_top *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_INC7_DATA, (u32)(Data));
    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_INC7_DATA + 4, (u32)(Data >> 32));
}

u64 XSynthesis_top_Get_inc7(XSynthesis_top *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_INC7_DATA);
    Data += (u64)XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_INC7_DATA + 4) << 32;
    return Data;
}

void XSynthesis_top_Set_b7(XSynthesis_top *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_B7_DATA, (u32)(Data));
    XSynthesis_top_WriteReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_B7_DATA + 4, (u32)(Data >> 32));
}

u64 XSynthesis_top_Get_b7(XSynthesis_top *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_B7_DATA);
    Data += (u64)XSynthesis_top_ReadReg(InstancePtr->Control_r_BaseAddress, XSYNTHESIS_TOP_CONTROL_R_ADDR_B7_DATA + 4) << 32;
    return Data;
}

void XSynthesis_top_InterruptGlobalEnable(XSynthesis_top *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSynthesis_top_WriteReg(InstancePtr->Control_BaseAddress, XSYNTHESIS_TOP_CONTROL_ADDR_GIE, 1);
}

void XSynthesis_top_InterruptGlobalDisable(XSynthesis_top *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSynthesis_top_WriteReg(InstancePtr->Control_BaseAddress, XSYNTHESIS_TOP_CONTROL_ADDR_GIE, 0);
}

void XSynthesis_top_InterruptEnable(XSynthesis_top *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XSynthesis_top_ReadReg(InstancePtr->Control_BaseAddress, XSYNTHESIS_TOP_CONTROL_ADDR_IER);
    XSynthesis_top_WriteReg(InstancePtr->Control_BaseAddress, XSYNTHESIS_TOP_CONTROL_ADDR_IER, Register | Mask);
}

void XSynthesis_top_InterruptDisable(XSynthesis_top *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XSynthesis_top_ReadReg(InstancePtr->Control_BaseAddress, XSYNTHESIS_TOP_CONTROL_ADDR_IER);
    XSynthesis_top_WriteReg(InstancePtr->Control_BaseAddress, XSYNTHESIS_TOP_CONTROL_ADDR_IER, Register & (~Mask));
}

void XSynthesis_top_InterruptClear(XSynthesis_top *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XSynthesis_top_WriteReg(InstancePtr->Control_BaseAddress, XSYNTHESIS_TOP_CONTROL_ADDR_ISR, Mask);
}

u32 XSynthesis_top_InterruptGetEnabled(XSynthesis_top *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XSynthesis_top_ReadReg(InstancePtr->Control_BaseAddress, XSYNTHESIS_TOP_CONTROL_ADDR_IER);
}

u32 XSynthesis_top_InterruptGetStatus(XSynthesis_top *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XSynthesis_top_ReadReg(InstancePtr->Control_BaseAddress, XSYNTHESIS_TOP_CONTROL_ADDR_ISR);
}

