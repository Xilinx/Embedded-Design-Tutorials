/******************************************************************************
 *
 * Copyright (C) 2019 Xilinx, Inc.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Use of the Software is limited solely to applications:
 * (a) running on a Xilinx device, or
 * (b) that interact with a Xilinx device through a bus or interconnect.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
 * OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 * Except as contained in this notice, the name of the Xilinx shall not be used
 * in advertising or otherwise to promote the sale, use or other dealings in
 * this Software without prior written authorization from Xilinx.
 *
 ******************************************************************************/
#ifndef SRC_GPIO_
#define SRC_GPIO_

#include "common.h"

#define GPIO_PATH "/sys/class/gpio/"
#define GPIO_EXPORT "/sys/class/gpio/export"
#define GPIO_REL "/sys/class/gpio/unexport"

/****************************************************************************/
/**
*
* This function releases the specified GPIO.
*
* @param	GPIO number
*
* @return	SUCCESS/FAILURE.
*
* @note		None.
*
******************************************************************************/
int disable_gpio(int gpio);
/****************************************************************************/
/**
*
* This function exports the specified GPIO.
*
* @param	GPIO number
*
* @return	SUCCESS/FAILURE.
*
* @note		None.
*
******************************************************************************/
int enable_gpio(int gpio);

/****************************************************************************/
/**
*
* This function configures GPIO as output.
*
* @param	GPIO number
*
* @return	SUCCESS/FAILURE.
*
* @note		None.
*
******************************************************************************/
int config_gpio_op(int gpio);
/****************************************************************************/
/**
*
* This function sets the GPIO with the specified value.
*
* @param	GPIO number
*
* @return	SUCCESS/FAILURE.
*
* @note		None.
*
******************************************************************************/
int set_gpio(int gpio, int value);

#endif /* SRC_GPIO_ */
