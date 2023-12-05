# 
# Copyright (C) 2022 -2023, Advanced Micro Devices, Inc. All rights reserved. 
# SPDX-License-Identifier: MIT
#
# This file is the gpiotest recipe.
#

SUMMARY = "Simple gpiotest application"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://gpiotest.c \
		file://Makefile \
	    file://gpio.c \
		file://gpio.h \
		file://common.c \
		file://common.h \
		  "

S = "${WORKDIR}"

do_compile() {
	     oe_runmake
}

do_install() {
	     install -d ${D}${bindir}
	     install -m 0755 gpiotest ${D}${bindir}
}
