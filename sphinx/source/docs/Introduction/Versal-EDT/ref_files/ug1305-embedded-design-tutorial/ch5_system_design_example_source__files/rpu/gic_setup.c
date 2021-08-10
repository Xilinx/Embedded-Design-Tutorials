/*
    Copyright (C) 2017 Amazon.com, Inc. or its affiliates.  All Rights Reserved.
    Copyright (c) 2012 - 2021 Xilinx, Inc. All Rights Reserved.
        SPDX-License-Identifier: MIT


    http://www.FreeRTOS.org
    http://aws.amazon.com/freertos


    1 tab == 4 spaces!
*/


#include "gic_setup.h"
#include "pm_client.h"
#include <xscugic_hw.h>

#define INTC_DEVICE_ID		XPAR_SCUGIC_SINGLE_DEVICE_ID

typedef struct {
	void *CallBackRef;
	u8 Enabled;
} GicIrqEntry;

static GicIrqEntry GicIrqTable[XSCUGIC_MAX_NUM_INTR_INPUTS];

s32 GicSetupInterruptSystem(XScuGic *GicInst)
{
	s32 Status;

	XScuGic_Config *GicCfgPtr = XScuGic_LookupConfig(INTC_DEVICE_ID);
	if (NULL == GicCfgPtr) {
		xil_printf("XScuGic_LookupConfig() failed\r\n");
		goto done;
	}

	Status = XScuGic_CfgInitialize(GicInst, GicCfgPtr, GicCfgPtr->CpuBaseAddress);
	if (XST_SUCCESS != Status) {
		xil_printf("XScuGic_CfgInitialize() failed with error: %d\r\n", Status);
		goto done;
	}

	/*
	 * Connect the interrupt controller interrupt Handler to the
	 * hardware interrupt handling logic in the processor.
	 */
#if defined (__aarch64__)
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_FIQ_INT,
#elif defined (__arm__)
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_IRQ_INT,
#endif
				     (Xil_ExceptionHandler)XScuGic_InterruptHandler,
				     GicInst);
	Xil_ExceptionEnable();

done:
	return Status;
}

s32 GicResume(XScuGic *GicInst)
{
	s32 Status;
	u32 i;

	GicInst->IsReady = 0U;

#if defined (GICv3)
	XScuGic_MarkCoreAwake(GicInst);
#endif

	XScuGic_Config *GicCfgPtr = XScuGic_LookupConfig(INTC_DEVICE_ID);
	if (NULL == GicCfgPtr) {
		xil_printf("XScuGic_LookupConfig() failed\r\n");
		goto done;
	}

	Status = XScuGic_CfgInitialize(GicInst, GicCfgPtr, GicCfgPtr->CpuBaseAddress);
	if (XST_SUCCESS != Status) {
		xil_printf("XScuGic_CfgInitialize() failed with error: %d\r\n", Status);
		goto done;
	}

	/* Restore handler pointers and enable interrupt if it was enabled */
	for (i = 0U; i < XSCUGIC_MAX_NUM_INTR_INPUTS; i++) {
		GicInst->Config->HandlerTable[i].CallBackRef = GicIrqTable[i].CallBackRef;

		if (GicIrqTable[i].Enabled){
			XScuGic_Enable(GicInst, i);
		}
	}

	Xil_ExceptionEnable();

done:
	return Status;

}

void GicSuspend(XScuGic *const GicInst)
{
	u32 i;

	for (i = 0U; i < XSCUGIC_MAX_NUM_INTR_INPUTS; i++) {
		u32 Mask, Reg;

		GicIrqTable[i].CallBackRef = GicInst->Config->HandlerTable[i].CallBackRef;

		Mask = 0x00000001U << (i % 32U);
		Reg = XScuGic_DistReadReg(GicInst, XSCUGIC_ENABLE_SET_OFFSET +
					  ((i / 32U) * 4U));
		if (Mask & Reg)
			GicIrqTable[i].Enabled = 1U;
		else
			GicIrqTable[i].Enabled = 0U;
	}

#if defined (GICv3)
	XScuGic_MarkCoreAsleep(GicInst);
#endif
}
