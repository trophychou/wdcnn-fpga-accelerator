// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2 (64-bit)
// Tool Version Limit: 2025.11
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#ifdef SDT
#include "xparameters.h"
#endif
#include "xsynthesis_top.h"

extern XSynthesis_top_Config XSynthesis_top_ConfigTable[];

#ifdef SDT
XSynthesis_top_Config *XSynthesis_top_LookupConfig(UINTPTR BaseAddress) {
	XSynthesis_top_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XSynthesis_top_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XSynthesis_top_ConfigTable[Index].Control_BaseAddress == BaseAddress) {
			ConfigPtr = &XSynthesis_top_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XSynthesis_top_Initialize(XSynthesis_top *InstancePtr, UINTPTR BaseAddress) {
	XSynthesis_top_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XSynthesis_top_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XSynthesis_top_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XSynthesis_top_Config *XSynthesis_top_LookupConfig(u16 DeviceId) {
	XSynthesis_top_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XSYNTHESIS_TOP_NUM_INSTANCES; Index++) {
		if (XSynthesis_top_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XSynthesis_top_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XSynthesis_top_Initialize(XSynthesis_top *InstancePtr, u16 DeviceId) {
	XSynthesis_top_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XSynthesis_top_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XSynthesis_top_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif

