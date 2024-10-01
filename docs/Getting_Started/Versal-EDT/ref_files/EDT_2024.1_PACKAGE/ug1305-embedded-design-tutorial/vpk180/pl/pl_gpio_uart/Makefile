# (C) Copyright 2020 - 2021 Xilinx, Inc.
# Copyright (C) 2022 -2024, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
CWD=$(shell pwd)
RM = rm -rf
VIVADO = $(XILINX_VIVADO)/bin/vivado
JOBS ?= 8

proj_name ?= edt_versal
proj_dir ?= project_1

VIV_SCRIPTS_DIR = scripts

VIVADO_XSA = $(CWD)/outputs/$(proj_name).xsa
VIV_SRC = $(VIV_SCRIPTS_DIR)/create_project.tcl

.PHONY: help
help:
	@echo 'Usage:'
	@echo ''
	@echo '  make xsa'
	@echo '    Generate xsa '
	@echo ''

.PHONY: all
all: xsa

xsa: $(VIVADO_XSA)
$(VIVADO_XSA): $(VIV_SRC)
	$(VIVADO) -mode batch -notrace -source $(VIV_SRC) -tclargs -jobs $(JOBS) -journal ${proj_name}.jou -log ${proj_name}.log

.PHONY: clean
clean:
	$(RM) $(CWD) ${proj_name}.jou log ${proj_name}.log .crashReporter/ .Xil

