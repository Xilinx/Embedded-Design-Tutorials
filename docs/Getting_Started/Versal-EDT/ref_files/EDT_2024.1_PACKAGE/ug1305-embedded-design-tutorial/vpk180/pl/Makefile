# (C) Copyright 2020 - 2021 Xilinx, Inc.
# Copyright (C) 2023-2024, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11

CWD=$(shell pwd)
JOBS ?= 8

design ?= pl_gpio_uart
proj_name ?= edt_versal
proj_dir ?= project_1


VIV_DIR = $(CWD)/$(design)
VIV_XSA = $(VIV_DIR)/outputs/$(proj_name).xsa

.PHONY: help
help:
	@echo 'Usage:'
	@echo ''
	@echo '  make design_xsa design=pl_gpio_uart JOBS=8'
	@echo '    Generate Vivado xsa '
	@echo ''

.PHONY: all
all: design_xsa

.PHONY: design_xsa
design_xsa: $(VIV_XSA)
$(VIV_XSA):
	make -C $(VIV_DIR) xsa JOBS=$(JOBS)
	
.PHONY: clean
clean:
	make -C $(VIV_DIR) clean

