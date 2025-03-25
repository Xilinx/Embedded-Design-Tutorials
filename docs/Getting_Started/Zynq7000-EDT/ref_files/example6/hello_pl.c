/*
******************************************************************************
# Copyright (C) 2022-2025, Advanced Micro Devices, Inc. All rights reserved. 
# SPDX-License-Identifier: MIT
******************************************************************************
*/

#include <stdio.h>
#include "xil_types.h"
#include "xgpio.h"
#include "xtmrctr.h"
#include "xparameters.h"
#include "xgpiops.h"
#include "xil_io.h"
#include "xil_exception.h"
#include "xscugic.h"
#ifdef SDT
#include "xinterrupt_wrap.h"
#endif
static XGpioPs psGpioInstancePtr;
extern XGpioPs_Config XGpioPs_ConfigTable[XPAR_XGPIOPS_NUM_INSTANCES];
static int iPinNumber = 10;
XScuGic InterruptController; /* Instance of the Interrupt Controller */
static int InterruptFlag;
//void print(char *str);
extern char inbyte(void);
#define TIMER_CNTR_0	 0
void Timer_InterruptHandler(void *data, u8 TmrCtrNumber)
{
	print("\r\n");
	print("\r\n");
	print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\r\n");
	print(" Inside Timer ISR \n \r ");
	XTmrCtr_Stop(data,TmrCtrNumber);
	// PS GPIO Writting
	print("LED 'DS23' Turned ON \r\n");
	XGpioPs_WritePin(&psGpioInstancePtr,iPinNumber,1);
	XTmrCtr_Reset(data,TmrCtrNumber);
	print(" Timer ISR Exit\n \n \r");
	print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\r\n");
	print("\r\n");
	print("\r\n");
	InterruptFlag = 1;
}

int SetUpInterruptSystem(XScuGic *XScuGicInstancePtr)
{
	/*
	* Connect the interrupt controller interrupt handler to the hardware
	* interrupt handling logic in the Arm processor.
	*/
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
	(Xil_ExceptionHandler) XScuGic_InterruptHandler,
	XScuGicInstancePtr);
	/*
	* Enable interrupts in the Arm
	*/
	Xil_ExceptionEnable();
	
	return XST_SUCCESS;
}

int ScuGicInterrupt_Init(u16 DeviceId,XTmrCtr *TimerInstancePtr)
{
	int Status;
	
	XScuGic_Config *GicConfig;

	GicConfig = XScuGic_LookupConfig(DeviceId);
	if (NULL == GicConfig) {
		return XST_FAILURE;
	}
	
	Status = XScuGic_CfgInitialize(&InterruptController, GicConfig,
	GicConfig->CpuBaseAddress);
	
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	
	Status = SetUpInterruptSystem(&InterruptController);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	
	Status = XScuGic_Connect(&InterruptController,
	XPAR_AXI_TIMER_0_INTERRUPTS,
	(Xil_ExceptionHandler)XTmrCtr_InterruptHandler,
	(void *)TimerInstancePtr);
	
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	


	XScuGic_Enable(&InterruptController, XPAR_AXI_TIMER_0_INTERRUPTS);
	
	return XST_SUCCESS;
}

int main()
{
u8 TmrCtrNumber = TIMER_CNTR_0;
static XGpio GPIOInstance_Ptr;
XGpioPs_Config*GpioConfigPtr;
XTmrCtr TimerInstancePtr;
int xStatus;
u32 Readstatus=0,OldReadStatus=0;
//u32 EffectiveAdress = 0xE000A000;
int iPinNumberEMIO = 54;
u32 uPinDirectionEMIO = 0x0;
// Input Pin
// Pin direction
u32 uPinDirection = 0x1;
int exit_flag,choice,internal_choice;

/* data = *(u32 *)(0x42800004);
print("OK \n");
data = *(u32 *)(0x41200004);
print("OK-1 \n");
*/
print("##### Application Starts #####\n\r");
print("\r\n");
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Step-1 :AXI GPIO Initialization
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#ifndef SDT
	xStatus = XGpio_Initialize(&GPIOInstance_Ptr, XPAR_AXI_GPIO_0_DEVICE_ID);
#else
	xStatus = XGpio_Initialize(&GPIOInstance_Ptr, XPAR_AXI_GPIO_0_BASEADDR);
#endif
if(XST_SUCCESS != xStatus)
print("GPIO INIT FAILED\n\r");
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Step-2 :AXI GPIO Set the Direction
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
XGpio_SetDataDirection(&GPIOInstance_Ptr, 1,1);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Step-3 :AXI Timer Initialization
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#ifndef SDT
	xStatus = XTmrCtr_Initialize(&TimerInstancePtr, XPAR_AXI_TIMER_0_DEVICE_ID);
#else
	xStatus = XTmrCtr_Initialize(&TimerInstancePtr, XPAR_AXI_TIMER_0_BASEADDR);
#endif
if(XST_SUCCESS != xStatus)
print("TIMER INIT FAILED \n\r");
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Step-4 :Set Timer Handler
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
XTmrCtr_SetHandler(&TimerInstancePtr,
Timer_InterruptHandler,
&TimerInstancePtr);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Step-5 :Setting timer Reset Value
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
XTmrCtr_SetResetValue(&TimerInstancePtr,
0, //Change with generic value
0xf0000000);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Step-6 :Setting timer Option (Interrupt Mode And Auto Reload )
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
XTmrCtr_SetOptions(&TimerInstancePtr,
TmrCtrNumber,
(XTC_INT_MODE_OPTION | XTC_AUTO_RELOAD_OPTION ));
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Step-7 :PS GPIO Intialization
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#ifndef SDT
	GpioConfigPtr = XGpioPs_LookupConfig(XPAR_PS7_GPIO_0_DEVICE_ID);
#else
	GpioConfigPtr = XGpioPs_LookupConfig(XPAR_XGPIOPS_0_BASEADDR);
#endif
if(GpioConfigPtr == NULL)
return XST_FAILURE;
xStatus = XGpioPs_CfgInitialize(&psGpioInstancePtr, GpioConfigPtr,GpioConfigPtr->BaseAddr);
if(XST_SUCCESS != xStatus) {
    print(" PS GPIO INIT FAILED \n\r");
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Step-8 :PS GPIO pin setting to Output
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
XGpioPs_SetDirectionPin(&psGpioInstancePtr, iPinNumber,uPinDirection);
XGpioPs_SetOutputEnablePin(&psGpioInstancePtr, iPinNumber,1);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Step-9 :EMIO PIN Setting to Input port
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
XGpioPs_SetDirectionPin(&psGpioInstancePtr,
iPinNumberEMIO,uPinDirectionEMIO);
XGpioPs_SetOutputEnablePin(&psGpioInstancePtr, iPinNumberEMIO,0);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Step-10 : SCUGIC interrupt controller Intialization
//Registration of the Timer ISR
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#ifdef SDT
	XGpio_Config *ConfigPtr;

	ConfigPtr = XGpio_LookupConfig(XPAR_AXI_GPIO_0_BASEADDR);
#endif

#ifndef SDT
	xStatus= ScuGicInterrupt_Init(XPAR_PS7_SCUGIC_0_DEVICE_ID,&TimerInstancePtr);
#else
	xStatus = XSetupInterruptSystem(&TimerInstancePtr, &Timer_InterruptHandler,
				       ConfigPtr->IntrId,
				       ConfigPtr->IntrParent,
				       XINTERRUPT_DEFAULT_PRIORITY);
#endif

if(XST_SUCCESS != xStatus)
print(" :( SCUGIC INIT FAILED \n\r");
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Step-11 :User selection procedure to select and execute tests
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
exit_flag = 0;
while(exit_flag != 1)
{
print(" SELECT the Operation from the Below Menu \r\n");
print("###################### Menu Starts ########################\r\n");
print("Press '1' to use NORMAL GPIO as an input (SW5 switch)\r\n");
print("Press '2' to use EMIO as an input (SW7 switch)\r\n");
print("Press any other key to Exit\r\n");
print(" ##################### Menu Ends #########################\r\n");
choice = inbyte();
printf("Selection : %c \r\n",choice);
internal_choice = 1;
switch(choice)
{
//~~~~~~~~~~~~~~~~~~~~~~~
// Use case for AXI GPIO
//~~~~~~~~~~~~~~~~~~~~~~~~
case '1':
exit_flag = 0;
print("Press Switch 'SW5' push button on board \r\n");
print(" \r\n");
while(internal_choice != '0')
{
Readstatus = XGpio_DiscreteRead(&GPIOInstance_Ptr, 1);
if(1== Readstatus && 0 == OldReadStatus )
{
print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\r\n");
print("SW5 PUSH Button pressed \n\r");
print("LED 'DS23' Turned OFF \r\n");
XGpioPs_WritePin(&psGpioInstancePtr,iPinNumber,0);
//Start Timer
XTmrCtr_Start(&TimerInstancePtr,0);
print("timer start \n\r");
//Wait For interrupt;
print("Wait for the Timer interrupt to tigger \r\n");
print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\r\n");
print(" \r\n");
while(InterruptFlag != 1);
InterruptFlag = 0;
print(" ###########################################\r\n ");
print("Press '0' to go to Main Menu \n\r ");
print("Press any other key to remain in AXI GPIO Test \n\r ");
print(" ###########################################\r\n ");
internal_choice = inbyte();
printf("Select = %c \r\n",internal_choice);
if(internal_choice != '0')
{
print("Press Switch 'SW5' push button on board \r\n");
}
}
OldReadStatus = Readstatus;
}
print(" \r\n");
print(" \r\n");
break;
case '2' :
	//~~~~~~~~~~~~~~~~~~~~~~~
	//Usecase for PS GPIO
	//~~~~~~~~~~~~~~~~~~~~~~~~
	exit_flag = 0;
	print("Press Switch 'SW7' push button on board \r\n");
	print(" \r\n");
	while(internal_choice != '0')
	{
	Readstatus = XGpioPs_ReadPin(&psGpioInstancePtr,
	iPinNumberEMIO);
	if(1== Readstatus && 0 == OldReadStatus )
	{
	print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\r\n");
	print("SW7 PUSH Button pressed \n\r");
	print("LED 'DS23' Turned OFF \r\n");
	XGpioPs_WritePin(&psGpioInstancePtr,iPinNumber,0);
	//Start Timer
	XTmrCtr_Start(&TimerInstancePtr,0);
	print("timer start \n\r");
	//Wait For interrupt;
	print("Wait for the Timer interrupt to tigger \r\n");
	print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\r\n");
	print(" \r\n");
	while(InterruptFlag != 1);
	InterruptFlag = 0;
	print(" ###########################################\r\n ");
	print("Press '0' to go to Main Menu \n\r ");
	print("Press any other key to remain in EMIO Test \n\r ");
	print(" ###########################################\r\n ");
	internal_choice = inbyte();
	printf("Select = %c \r\n",internal_choice);
	if(internal_choice != '0')
	{
	print("Press Switch 'SW7' push button on board \r\n");
	}
	}
	OldReadStatus = Readstatus;
	}
	print(" \r\n");
	print(" \r\n");
	break;
	default :
	exit_flag = 1;
	break;
	}
	}
	print("\r\n");
	print("***********\r\n");
	print("BYE \r\n");
	print("***********\r\n");
	return 0;
	}

