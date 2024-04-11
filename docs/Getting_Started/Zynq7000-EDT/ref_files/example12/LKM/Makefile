/*
******************************************************************************
# Copyright (C) 2022-2024, Advanced Micro Devices, Inc. All rights reserved. 
# SPDX-License-Identifier: MIT
******************************************************************************
*/


export ARCH:=arm
export CROSS_COMPILE:= arm-linux-gnueabihf-

CC=$(CROSS_COMPILE)gcc

obj-m += blink.o

#KVERSION=/tmp/custom_plnx-2023.12.11-16.49.24-zA6/work/zynq_generic_7z020-xilinx-linux-gnueabi/linux-xlnx/6.1.30-xilinx-v2023.2+gitAUTOINC+a19da02cf5-r0/linux-zynq_generic_7z020-standard-build/

PWD := $(shell pwd)

all:
	make -C $(KVERSION) M=$(PWD) modules
 
clean:
	make -C $(KVERSION) M=$(PWD) clean

deploy:
	scp -P 1540 blink.ko petalinux@localhost:/home/petalinux
