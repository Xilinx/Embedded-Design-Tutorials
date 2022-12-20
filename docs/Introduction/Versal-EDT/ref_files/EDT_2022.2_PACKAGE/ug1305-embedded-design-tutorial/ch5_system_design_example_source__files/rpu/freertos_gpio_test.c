/*
    Copyright (C) 2017 Amazon.com, Inc. or its affiliates.  All Rights Reserved.
    Copyright (c) 2012 - 2021 Xilinx, Inc. All Rights Reserved.
	SPDX-License-Identifier: MIT


    http://www.FreeRTOS.org
    http://aws.amazon.com/freertos


    1 tab == 4 spaces!
*/

/* FreeRTOS includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"
#include "timers.h"
/* Xilinx includes. */
#include "xil_printf.h"
//#include "xpm_nodeid.h"
#include "xstatus.h"
#include "xparameters.h"
//#include "pm_api_sys.h"
#include "sleep.h"
//#include "xpm_defs.h"
//#include "gic_setup.h"
//#include "ipi.h"
//#include "pm_init.h"


#define DELAY_1_SECOND          1000UL

/* The Tx and Rx tasks as described at the top of this file. */
static void prvCntTask( void *pvParameters );

/*-----------------------------------------------------------*/

static TaskHandle_t xCntTask;
//static XIpiPsu IpiInst;


int main( void )
{
	int Status = 0;

#if 0
	Status = PmInit(NULL, &IpiInst);
		if (XST_SUCCESS != Status) {
			xil_printf("PmInit() failed with error: %d\r\n", Status);
	//		goto done;
	}
#endif

	xil_printf("Gpio Initialization started\r\n");

	/* Create the two tasks.  The Tx task is given a lower priority than the
	Rx task, so the Rx task will leave the Blocked state and pre-empt the Tx
	task as soon as the Tx task places an item in the queue. */
	xTaskCreate( 	prvCntTask, 					/* The function that implements the task. */
					( const char * ) "CntTask", 		/* Text name for the task, provided to assist debugging only. */
					configMINIMAL_STACK_SIZE, 	/* The stack allocated to the task. */
					NULL, 						/* The task parameter is not used, so set to NULL. */
					tskIDLE_PRIORITY,			/* The task runs at the idle priority. */
					&xCntTask );

	/* Start the tasks and timer running. */
	vTaskStartScheduler();

	/* If all is well, the scheduler will now be running, and the following line
will never be reached.  If the following line does execute, then there was
	insufficient FreeRTOS heap memory available for the idle and/or timer tasks
	to be created.  See the memory management section on the FreeRTOS web site
	for more details. */
	for( ;; );
}


/*-----------------------------------------------------------*/
static void prvCntTask( void *pvParameters )
{

	u32 cnt_val = 0;
	const TickType_t x1second = pdMS_TO_TICKS( DELAY_1_SECOND );


	for( ;; )
	{

		xil_printf("Counter %d\r\n", cnt_val);

		if(cnt_val > 10000)
			cnt_val = 0;
		else
			cnt_val++;

		/* Delay for 2 second. */
		vTaskDelay(x1second);

	}
}
