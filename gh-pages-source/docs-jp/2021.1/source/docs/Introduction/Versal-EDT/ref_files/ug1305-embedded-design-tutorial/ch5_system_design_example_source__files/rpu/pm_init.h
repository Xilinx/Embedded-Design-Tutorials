/*
    Copyright (C) 2017 Amazon.com, Inc. or its affiliates.  All Rights Reserved.
    Copyright (c) 2012 - 2021 Xilinx, Inc. All Rights Reserved.
        SPDX-License-Identifier: MIT


    http://www.FreeRTOS.org
    http://aws.amazon.com/freertos


    1 tab == 4 spaces!
*/


#ifndef _PM_INIT_H_
#define _PM_INIT_H_

#include "ipi.h"
#include "gic_setup.h"


/* GGS2 use to sync between target and host application/os */
#define GGS		0xF1110038
#define GGS_VALUE	0x01

/* Subsystem definitions */
#define PM_SUBSYS_DEFAULT                       (0x1c000000U)
#define PM_SUBSYS_PMC                           (0x1c000001U)
#define PM_SUBSYS_PSM                           (0x1c000002U)
#define PM_SUBSYS_APU                           (0x1c000003U)
#define PM_SUBSYS_RPU0_LOCK                     (0x1c000004U)
#define PM_SUBSYS_RPU0_0                        (0x1c000005U)
#define PM_SUBSYS_RPU0_1                        (0x1c000006U)
#define PM_SUBSYS_DDR0                          (0x1c000007U)
#define PM_SUBSYS_ME                            (0x1c000008U)
#define PM_SUBSYS_PL                            (0x1c000009U)

#define PM_DEV_TTC_FOR_TIMER PM_DEV_TTC_0

/* Select TTC for timer based on xparameters.h */
#if (SLEEP_TIMER_BASEADDR == 0XFF0E0000U)
	#define PM_DEV_TTC_FOR_TIMER PM_DEV_TTC_0
#elif (SLEEP_TIMER_BASEADDR  == 0XFF0F0000U)
	#define PM_DEV_TTC_FOR_TIMER PM_DEV_TTC_1
#elif (SLEEP_TIMER_BASEADDR  == 0XFF100000U)
	#define PM_DEV_TTC_FOR_TIMER PM_DEV_TTC_2
#elif (SLEEP_TIMER_BASEADDR  == 0XFF110000U)
	#define PM_DEV_TTC_FOR_TIMER PM_DEV_TTC_3
#endif


XStatus PmInit(XScuGic *const GicInst, XIpiPsu *const IpiInst);

#endif
