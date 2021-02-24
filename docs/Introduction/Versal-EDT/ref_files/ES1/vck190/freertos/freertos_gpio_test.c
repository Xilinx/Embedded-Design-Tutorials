/*
    Copyright (C) 2017 Amazon.com, Inc. or its affiliates.  All Rights Reserved.
    Copyright (c) 2012 - 2020 Xilinx, Inc. All Rights Reserved.
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
#include "xparameters.h"
#include "xgpio.h"

/*
 * The following constants map to the XPAR parameters created in the
 * xparameters.h file. They are defined here such that a user can easily
 * change all the needed parameters in one place.
 */
#define GPIO_EXAMPLE_DEVICE_ID  XPAR_GPIO_0_DEVICE_ID

#define LED_0 0x1  /* Assumes bit 0 of GPIO is connected to an LED  */
#define LED_1 0x2   /* Assumes bit 1 of GPIO is connected to an LED  */
#define DELAY_2_SECOND		2000UL

/*
 * The following constant is used to determine which channel of the GPIO is
 * used for the LED if there are 2 channels supported.
 */
#define LED_CHANNEL 1

/*-----------------------------------------------------------*/

/* The Tx and Rx tasks as described at the top of this file. */
static void prvLedTask( void *pvParameters );
static void prvSetupHardware( void );
/*-----------------------------------------------------------*/

static TaskHandle_t xLedTask;

XGpio Gpio; /* The Instance of the GPIO Driver */

int main( void )
{

	prvSetupHardware();

	/* Create the two tasks.  The Tx task is given a lower priority than the
	Rx task, so the Rx task will leave the Blocked state and pre-empt the Tx
	task as soon as the Tx task places an item in the queue. */
	xTaskCreate( 	prvLedTask, 					/* The function that implements the task. */
					( const char * ) "LedBlink", 		/* Text name for the task, provided to assist debugging only. */
					configMINIMAL_STACK_SIZE, 	/* The stack allocated to the task. */
					NULL, 						/* The task parameter is not used, so set to NULL. */
					tskIDLE_PRIORITY,			/* The task runs at the idle priority. */
					&xLedTask );

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
static void prvSetupHardware( void )
{
	portBASE_TYPE xStatus;

    	/* Initialize the GPIO driver */
	xStatus = XGpio_Initialize(&Gpio, GPIO_EXAMPLE_DEVICE_ID);
     	if (xStatus != XST_SUCCESS) {
        	xil_printf("Gpio Initialization Failed\r\n");
             	return XST_FAILURE;
     	}

     	/* Set the direction for GPIO 0 and GPIO 1 signals as LED output */
     	XGpio_SetDataDirection(&Gpio, LED_CHANNEL, ~(LED_0 | LED_1));

}

/*-----------------------------------------------------------*/
static void prvLedTask( void *pvParameters )
{

	const TickType_t x2second = pdMS_TO_TICKS( DELAY_2_SECOND );

	for( ;; )
	{
		/* Set the LED to High */
		XGpio_DiscreteWrite(&Gpio, LED_CHANNEL, LED_0 | LED_1);

	    /* Delay for 2 second. */
		vTaskDelay(x2second);

	}
}
