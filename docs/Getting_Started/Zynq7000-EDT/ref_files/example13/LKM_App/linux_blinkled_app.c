/*
******************************************************************************
# Copyright (C) 2022-2024, Advanced Micro Devices, Inc. All rights reserved. 
# SPDX-License-Identifier: MIT
******************************************************************************
*/

/*
* ioctl.c - the process to use ioctl's to control the kernel module
*
* Until now we could have used cat for input and output. But now
* we need to do ioctl's, which require writing our own process.
*/
/*
* device specifics, such as ioctl numbers and the
* major device file.
*/
#include "blink.h"
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h> /* open */
#include <unistd.h> /* exit */
#include <sys/ioctl.h> /* ioctl */
/*
* Functions for the ioctl calls
*/
void ioctl_ON_LED(int file_desc)
{
	int ret_val;
	ret_val = ioctl(file_desc, IOCTL_ON_LED, NULL);
	if (ret_val < 0)
	{
		printf("ioctl_ON_LED failed:%d\n", ret_val);
		exit(-1);
	}
}
void ioctl_OFF_LED(int file_desc)
{
	int ret_val;
	ret_val = ioctl(file_desc, IOCTL_STOP_LED,NULL);
	if (ret_val < 0)
	{
		printf("ioctl_OFF_LED failed:%d\n", ret_val);
		exit(-1);
	}
}
/*
* Main - Call the ioctl functions
*/
int main()
{
	int Choice;
	int exitflag=1;
	int file_desc;


	printf("################################ \n\r");
	printf("      Blink LED Application  \n\r");
	printf("################################ \n\r");
	file_desc = open(DEVICE_FILE_NAME, O_RDWR | O_SYNC);
	if (file_desc < 0) 
	{
		printf("Can't open device file: %s\n", DEVICE_FILE_NAME);
		exit(-1);
	}
	while (exitflag)
	{
		printf("************************************************ \n\r");
		printf("Press '1' to Start Blink LED TEST \n\r");
		printf("Press '0' to Stop Blink LED TEST \n\r");
		printf("************************************************ \n\r");
		scanf("%d",&Choice);
		printf("Choice  :: %d \n\r",Choice);
		if(Choice == 1)
		{
			ioctl_ON_LED(file_desc);
			exitflag	= 1;
		}
		else if (0 == Choice )
		{
			ioctl_OFF_LED(file_desc);
			exitflag	= 1;
		}
		else
		{
			exitflag	= 0;

		}
	}

	close(file_desc);
	printf("################################ \n\r");
	printf("      Bye Blink LED Application  \n\r");
	printf("################################ \n\r");
	return 0;
}

