/*
    Copyright (C) 2017 Amazon.com, Inc. or its affiliates.  All Rights Reserved.
    Copyright (c) 2012 - 2021 Xilinx, Inc. All Rights Reserved.
        SPDX-License-Identifier: MIT


    http://www.FreeRTOS.org
    http://aws.amazon.com/freertos


    1 tab == 4 spaces!
*/

#include "pm_api_sys.h"
#include "pm_init.h"

XStatus PmInit(XScuGic *const GicInst, XIpiPsu *const IpiInst)
{
	xil_printf("%s Started\r\n", __func__);
        int Status;
#if 1
	/* GIC Initialize */
	if (NULL != GicInst) {
		Status = GicSetupInterruptSystem(GicInst);
		if (Status != XST_SUCCESS) {
			xil_printf("GicSetupInterruptSystem() failed with error: %d\r\n", Status);
			goto done;
		}
	}

	/* IPI Initialize */
        Status = IpiInit(GicInst, IpiInst);
        if (XST_SUCCESS != Status) {
                xil_printf("IpiInit() failed with error: %d\r\n", Status);
                goto done;
        }

	/* XilPM Initialize */
        Status = XPm_InitXilpm(IpiInst);
        if (XST_SUCCESS != Status) {
                xil_printf("XPm_InitXilpm() failed with error: %d\r\n", Status);
                goto done;
        }

#endif
	/* TTC is required for sleep functionality */
	Status = XPm_RequestNode(PM_DEV_TTC_FOR_TIMER, PM_CAP_ACCESS, 0, 0);
	if (XST_SUCCESS != Status) {
		xil_printf("XPm_RequestNode of TTC is failed with error: %d\r\n", Status);
		goto done;
	}


	/* Finalize Initialization */
        Status = XPm_InitFinalize();
        if (XST_SUCCESS != Status) {
                xil_printf("XPm_initfinalize() failed\r\n");
                goto done;
        }

done:

	xil_printf("%s Ended\r\n", __func__);
        return Status;
}
