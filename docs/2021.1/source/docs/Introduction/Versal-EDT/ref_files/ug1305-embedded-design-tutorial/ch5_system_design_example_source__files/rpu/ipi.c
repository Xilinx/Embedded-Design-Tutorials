/*
    Copyright (C) 2017 Amazon.com, Inc. or its affiliates.  All Rights Reserved.
    Copyright (c) 2012 - 2021 Xilinx, Inc. All Rights Reserved.
        SPDX-License-Identifier: MIT


    http://www.FreeRTOS.org
    http://aws.amazon.com/freertos


    1 tab == 4 spaces!
*/


#include "pm_api_sys.h"
#include "ipi.h"
#include "gic_setup.h"
#include <unistd.h>
#include <xipipsu_hw.h>
#include <xipipsu.h>
#include "xparameters.h"

#define IPI_INT_ID      (XPAR_VERSAL_CIPS_0_PSPMC_0_PSV_RCPU_GIC_DEVICE_ID )
#define TEST_CHANNEL_ID XPAR_XIPIPSU_0_DEVICE_ID

/* Allocate one callback pointer for each bit in the register */
static IpiCallback IpiCallbacks[11];

static ssize_t ipimask2idx(u32 m)
{
	return __builtin_ctz(m);
}

/**
 * IpiIrqHandler() - Interrupt handler of IPI peripheral
 * @InstancePtr	Pointer to the IPI data structure
 */
static void IpiIrqHandler(XIpiPsu *InstancePtr)
{
	u32 Mask;

	/* NOTE: Add this delay to avoid print mixup with other PUs.*/
	usleep(100);
	xil_printf("%s IPI interrupt received\r\n", __func__);
	/* Read status to determine the source CPU (who generated IPI) */
	Mask = XIpiPsu_GetInterruptStatus(InstancePtr);

	/* Handle all IPIs whose bits are set in the mask */
	while (Mask) {
		u32 IpiMask = Mask & (-Mask);
		ssize_t idx = ipimask2idx(IpiMask);

		xil_printf("%s IPI interrupt mask = %x\r\n", __func__, IpiMask);
		/* If the callback for this IPI is registered execute it */
		if (idx >= 0 && IpiCallbacks[idx])
			IpiCallbacks[idx](InstancePtr);

		/* Clear the interrupt status of this IPI source */
		XIpiPsu_ClearInterruptStatus(InstancePtr, IpiMask);

		/* Clear this IPI in the Mask */
		Mask &= ~IpiMask;
	}
}

XStatus IpiRegisterCallback(XIpiPsu *const IpiInst, const u32 SrcMask,
			    IpiCallback Callback)
{
	ssize_t idx;

	if (!Callback)
		return XST_INVALID_PARAM;

	/* Get index into IpiChannels array */
	idx = ipimask2idx(SrcMask);
	if (idx < 0)
		return XST_INVALID_PARAM;

	/* Check if callback is already registered, return failure if it is */
	if (IpiCallbacks[idx])
		return XST_FAILURE;

	/* Entry is free, register callback */
	IpiCallbacks[idx] = Callback;

	/* Enable reception of IPI from the SrcMask/CPU */
	XIpiPsu_InterruptEnable(IpiInst, SrcMask);

	return XST_SUCCESS;
}

static XStatus IpiConfigure(XScuGic *const GicInst, XIpiPsu *const IpiInst)
{
	int Status = XST_FAILURE;
	XIpiPsu_Config *IpiCfgPtr;

	if (NULL == IpiInst) {
		goto done;
	}
	/* Look Up the config data */
	IpiCfgPtr = XIpiPsu_LookupConfig(TEST_CHANNEL_ID);
	if (NULL == IpiCfgPtr) {
		Status = XST_FAILURE;
		xil_printf("%s ERROR in getting CfgPtr\n", __func__);
		goto done;
	}

	/* Init with the Cfg Data */
	Status = XIpiPsu_CfgInitialize(IpiInst, IpiCfgPtr, IpiCfgPtr->BaseAddress);
	if (XST_SUCCESS != Status) {
		xil_printf("%s ERROR #%d in configuring IPI\n", __func__, Status);
		goto done;
	}

	/* Clear Any existing Interrupts */
	XIpiPsu_ClearInterruptStatus(IpiInst, XIPIPSU_ALL_MASK);

	if (NULL == GicInst) {
		goto done;
	}
	Status = XScuGic_Connect(GicInst, IPI_INT_ID, (Xil_ExceptionHandler)IpiIrqHandler, IpiInst);
	if (XST_SUCCESS != Status) {
		xil_printf("%s ERROR #%d in GIC connect\n", __func__, Status);
		goto done;
	}
	/* Enable IPI interrupt at GIC */
	XScuGic_Enable(GicInst, IPI_INT_ID);

done:
	return Status;
}

XStatus IpiInit(XScuGic *const GicInst, XIpiPsu *const InstancePtr)
{
	int Status;

	Status = IpiConfigure(GicInst, InstancePtr);
	if (XST_SUCCESS != Status) {
		xil_printf("IpiConfigure() failed with error: %d\r\n", Status);
		goto done;
	}

	/* FIXME: Enable reception of IPI from the SrcMask/CPU */
	XIpiPsu_InterruptEnable(InstancePtr, XIPIPSU_ALL_MASK);

done:

	return Status;
}

