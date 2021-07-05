/*
    Copyright (C) 2017 Amazon.com, Inc. or its affiliates.  All Rights Reserved.
    Copyright (c) 2012 - 2021 Xilinx, Inc. All Rights Reserved.
        SPDX-License-Identifier: MIT


    http://www.FreeRTOS.org
    http://aws.amazon.com/freertos


    1 tab == 4 spaces!
*/


#ifndef LIBESWPM_PM_IPI_H_
#define LIBESWPM_PM_IPI_H_

#include <xstatus.h>
#include <xscugic.h>
#include <xipipsu.h>

typedef void (*IpiCallback)(XIpiPsu *const InstancePtr);

XStatus IpiInit(XScuGic *const GicInst, XIpiPsu *const InstancePtr);
XStatus IpiRegisterCallback(XIpiPsu *const IpiInst, const u32 SrcMask,
			    IpiCallback Callback);

#endif


