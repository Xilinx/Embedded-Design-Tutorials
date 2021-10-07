/*
    Copyright (C) 2017 Amazon.com, Inc. or its affiliates.  All Rights Reserved.
    Copyright (c) 2012 - 2021 Xilinx, Inc. All Rights Reserved.
        SPDX-License-Identifier: MIT


    http://www.FreeRTOS.org
    http://aws.amazon.com/freertos


    1 tab == 4 spaces!
*/


#ifndef LIBESWPM_GIC_SETUP_H_
#define LIBESWPM_GIC_SETUP_H_

#include <xscugic.h>

s32 GicSetupInterruptSystem(XScuGic *GicInst);
s32 GicResume(XScuGic *GicInst);
void GicSuspend(XScuGic *const GicInst);

#endif

