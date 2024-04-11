/*
******************************************************************************
# Copyright (C) 2022-2024, Advanced Micro Devices, Inc. All rights reserved. 
# SPDX-License-Identifier: MIT
******************************************************************************
*/

/*
* blink.h - the header file with the ioctl definitions.
*
* The declarations here have to be in a header file, because
* they need to be known both to the kernel module
* (in chardev.c) and the process calling ioctl (ioctl.c)
*/
#ifndef BLINK_H
#define BLINK_H
#include <linux/ioctl.h>
/*
* The major device number. We can't rely on dynamic
* registration any more, because ioctls need to know
* it.
*/
#define MAGIC_NUM 100
/*
* TURN ON LED ioctl
*/
#define IOCTL_ON_LED _IOR(MAGIC_NUM, 0, char *)
/*
* _IOR means that we're creating an ioctl command
* number for passing information from a user process
* to the kernel module.
*
* The first arguments, MAGIC_NUM, is the major device
* number we're using.
*
* The second argument is the number of the command
* (there could be several with different meanings).
*
* The third argument is the type we want to get from
* the process to the kernel.
*/
/*
* STOP LED BLINK ioctl
*/
#define IOCTL_STOP_LED _IOR(MAGIC_NUM, 1, char *)

#define DEBUG

#define DEVICE_FILE_NAME "/dev/blink_Dev"
#endif
