// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2 (64-bit)
// Tool Version Limit: 2025.11
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XSYNTHESIS_TOP_H
#define XSYNTHESIS_TOP_H

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/
#ifndef __linux__
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xil_io.h"
#else
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>
#endif
#include "xsynthesis_top_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
#else
typedef struct {
#ifdef SDT
    char *Name;
#else
    u16 DeviceId;
#endif
    u64 Control_BaseAddress;
    u64 Control_r_BaseAddress;
} XSynthesis_top_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u64 Control_r_BaseAddress;
    u32 IsReady;
} XSynthesis_top;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XSynthesis_top_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XSynthesis_top_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XSynthesis_top_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XSynthesis_top_ReadReg(BaseAddress, RegOffset) \
    *(volatile u32*)((BaseAddress) + (RegOffset))

#define Xil_AssertVoid(expr)    assert(expr)
#define Xil_AssertNonvoid(expr) assert(expr)

#define XST_SUCCESS             0
#define XST_DEVICE_NOT_FOUND    2
#define XST_OPEN_DEVICE_FAILED  3
#define XIL_COMPONENT_IS_READY  1
#endif

/************************** Function Prototypes *****************************/
#ifndef __linux__
#ifdef SDT
int XSynthesis_top_Initialize(XSynthesis_top *InstancePtr, UINTPTR BaseAddress);
XSynthesis_top_Config* XSynthesis_top_LookupConfig(UINTPTR BaseAddress);
#else
int XSynthesis_top_Initialize(XSynthesis_top *InstancePtr, u16 DeviceId);
XSynthesis_top_Config* XSynthesis_top_LookupConfig(u16 DeviceId);
#endif
int XSynthesis_top_CfgInitialize(XSynthesis_top *InstancePtr, XSynthesis_top_Config *ConfigPtr);
#else
int XSynthesis_top_Initialize(XSynthesis_top *InstancePtr, const char* InstanceName);
int XSynthesis_top_Release(XSynthesis_top *InstancePtr);
#endif

void XSynthesis_top_Start(XSynthesis_top *InstancePtr);
u32 XSynthesis_top_IsDone(XSynthesis_top *InstancePtr);
u32 XSynthesis_top_IsIdle(XSynthesis_top *InstancePtr);
u32 XSynthesis_top_IsReady(XSynthesis_top *InstancePtr);
void XSynthesis_top_EnableAutoRestart(XSynthesis_top *InstancePtr);
void XSynthesis_top_DisableAutoRestart(XSynthesis_top *InstancePtr);

void XSynthesis_top_Set_num_samples(XSynthesis_top *InstancePtr, u32 Data);
u32 XSynthesis_top_Get_num_samples(XSynthesis_top *InstancePtr);
void XSynthesis_top_Set_reload_weights(XSynthesis_top *InstancePtr, u32 Data);
u32 XSynthesis_top_Get_reload_weights(XSynthesis_top *InstancePtr);
void XSynthesis_top_Set_w1(XSynthesis_top *InstancePtr, u64 Data);
u64 XSynthesis_top_Get_w1(XSynthesis_top *InstancePtr);
void XSynthesis_top_Set_inc1(XSynthesis_top *InstancePtr, u64 Data);
u64 XSynthesis_top_Get_inc1(XSynthesis_top *InstancePtr);
void XSynthesis_top_Set_b1(XSynthesis_top *InstancePtr, u64 Data);
u64 XSynthesis_top_Get_b1(XSynthesis_top *InstancePtr);
void XSynthesis_top_Set_w2(XSynthesis_top *InstancePtr, u64 Data);
u64 XSynthesis_top_Get_w2(XSynthesis_top *InstancePtr);
void XSynthesis_top_Set_inc2(XSynthesis_top *InstancePtr, u64 Data);
u64 XSynthesis_top_Get_inc2(XSynthesis_top *InstancePtr);
void XSynthesis_top_Set_b2(XSynthesis_top *InstancePtr, u64 Data);
u64 XSynthesis_top_Get_b2(XSynthesis_top *InstancePtr);
void XSynthesis_top_Set_w3(XSynthesis_top *InstancePtr, u64 Data);
u64 XSynthesis_top_Get_w3(XSynthesis_top *InstancePtr);
void XSynthesis_top_Set_inc3(XSynthesis_top *InstancePtr, u64 Data);
u64 XSynthesis_top_Get_inc3(XSynthesis_top *InstancePtr);
void XSynthesis_top_Set_b3(XSynthesis_top *InstancePtr, u64 Data);
u64 XSynthesis_top_Get_b3(XSynthesis_top *InstancePtr);
void XSynthesis_top_Set_w4(XSynthesis_top *InstancePtr, u64 Data);
u64 XSynthesis_top_Get_w4(XSynthesis_top *InstancePtr);
void XSynthesis_top_Set_inc4(XSynthesis_top *InstancePtr, u64 Data);
u64 XSynthesis_top_Get_inc4(XSynthesis_top *InstancePtr);
void XSynthesis_top_Set_b4(XSynthesis_top *InstancePtr, u64 Data);
u64 XSynthesis_top_Get_b4(XSynthesis_top *InstancePtr);
void XSynthesis_top_Set_w5(XSynthesis_top *InstancePtr, u64 Data);
u64 XSynthesis_top_Get_w5(XSynthesis_top *InstancePtr);
void XSynthesis_top_Set_inc5(XSynthesis_top *InstancePtr, u64 Data);
u64 XSynthesis_top_Get_inc5(XSynthesis_top *InstancePtr);
void XSynthesis_top_Set_b5(XSynthesis_top *InstancePtr, u64 Data);
u64 XSynthesis_top_Get_b5(XSynthesis_top *InstancePtr);
void XSynthesis_top_Set_w6(XSynthesis_top *InstancePtr, u64 Data);
u64 XSynthesis_top_Get_w6(XSynthesis_top *InstancePtr);
void XSynthesis_top_Set_inc6(XSynthesis_top *InstancePtr, u64 Data);
u64 XSynthesis_top_Get_inc6(XSynthesis_top *InstancePtr);
void XSynthesis_top_Set_b6(XSynthesis_top *InstancePtr, u64 Data);
u64 XSynthesis_top_Get_b6(XSynthesis_top *InstancePtr);
void XSynthesis_top_Set_w7(XSynthesis_top *InstancePtr, u64 Data);
u64 XSynthesis_top_Get_w7(XSynthesis_top *InstancePtr);
void XSynthesis_top_Set_inc7(XSynthesis_top *InstancePtr, u64 Data);
u64 XSynthesis_top_Get_inc7(XSynthesis_top *InstancePtr);
void XSynthesis_top_Set_b7(XSynthesis_top *InstancePtr, u64 Data);
u64 XSynthesis_top_Get_b7(XSynthesis_top *InstancePtr);

void XSynthesis_top_InterruptGlobalEnable(XSynthesis_top *InstancePtr);
void XSynthesis_top_InterruptGlobalDisable(XSynthesis_top *InstancePtr);
void XSynthesis_top_InterruptEnable(XSynthesis_top *InstancePtr, u32 Mask);
void XSynthesis_top_InterruptDisable(XSynthesis_top *InstancePtr, u32 Mask);
void XSynthesis_top_InterruptClear(XSynthesis_top *InstancePtr, u32 Mask);
u32 XSynthesis_top_InterruptGetEnabled(XSynthesis_top *InstancePtr);
u32 XSynthesis_top_InterruptGetStatus(XSynthesis_top *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
