/******************************************************************************
 *
 * Copyright (C) 2019 Xilinx, Inc.	All rights reserved.
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

/***************************** Include Files *********************************/

#include "gpio.h"

/**************************** Type Definitions *******************************/

/***************** Macros (Inline Functions) Definitions *********************/

/************************** Variable Definitions *****************************/
/************************** Function Definitions *****************************/
int disable_gpio(int gpio) {
  int ret;

  ret = write_to_file(GPIO_REL, gpio);
  if (ret != SUCCESS) {
    printf("Unable to disable GPIO : %d\n", gpio);
    return FAIL;
  }

  return SUCCESS;
}

int enable_gpio(int gpio) {
  int ret;

  ret = write_to_file(GPIO_EXPORT, gpio);
  if (ret != SUCCESS) {
    printf("Unable to enable GPIO : %d\n", gpio);
    return FAIL;
  }

  return SUCCESS;
}

int set_gpio(int gpio, int value) {
  int ret;
  char path[255];

  sprintf(path, "%sgpio%d/value", GPIO_PATH, gpio);
  ret = write_to_file(path, value);
  if (ret != SUCCESS) {
    printf("Unable to set GPIO : %s\n", path);
    return FAIL;
  }

  return SUCCESS;
}

int config_gpio_op(int gpio) {
  int ret;
  FILE *fp;
  char path[255];

  sprintf(path, "%sgpio%d/direction", GPIO_PATH, gpio);
  fp = fopen(path, "w");
  if (fp == NULL) {
    ret = FAIL;
    printf("Cannot open file %s \n", path);
    return FAIL;
  }

  ret = fprintf(fp, "%s", "out");
  if (ret <= 0) {
    ret = FAIL;
    printf("Unable to configure GPIO\n");
    fclose(fp);
    return FAIL;
  }

  fclose(fp);

  return SUCCESS;
}
