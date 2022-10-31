# Copyright 2021 Xilinx Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ROOT_DIR=$(realpath $(dir $(lastword $(MAKEFILE_LIST))))
ABS_BUILD_PATH=$(ROOT_DIR)/build
ABS_HW_PATH=$(ABS_BUILD_PATH)/vivado
PETALINUX_PROJ_NAME = xilinx-zcu102-2022.2

PETALINUX_BSP=~/Downloads/xilinx-zcu102-v2022.2-final.bsp
ABS_SW_PATH=$(ABS_BUILD_PATH)/$(PETALINUX_PROJ_NAME)
BD_TCL=hw.tcl
ABS_BD_TCL=$(ROOT_DIR)/$(BD_TCL)
PETALINUX_DIR=$(ABS_SW_PATH)
PETALINUX_CONFIG=$(PETALINUX_DIR)/project-spec/configs/config
ABS_XSA=$(ABS_HW_PATH)/edt_zcu102_wrapper.xsa


.PHONY: all petalinux hw xsa

all: hw petalinux

check:
	ls -l $(ABS_XSA)
	ls -l $(ABS_BD_TCL)
	ls -l $(PETALINUX_BSP)

xsa: $(ABS_XSA)

hw: $(ABS_XSA)

$(ABS_XSA):
	mkdir -p $(ABS_HW_PATH)
	cd $(ABS_HW_PATH); vivado -mode batch -notrace -source $(ABS_BD_TCL)

petalinux: $(ABS_SW_PATH)/images/linux

$(ABS_SW_PATH)/images/linux: $(ABS_XSA)
# Create PetaLinux project
	cd $(ABS_BUILD_PATH); petalinux-create -t project -s $(PETALINUX_BSP)
# Import XSA  
	echo "CONFIG_YOCTO_BUILDTOOLS_EXTENDED=y" >> $(PETALINUX_CONFIG)
	cd $(ABS_SW_PATH);      petalinux-config --get-hw-description=$(ABS_HW_PATH) --silentconfig
# Update configuration
#	echo "CONFIG_YOCTO_BUILDTOOLS_EXTENDED=y" >> $(PETALINUX_CONFIG)
#	petalinux-config --silentconfig -p $(ABS_SW_PATH)
# Build
	petalinux-build -p $(ABS_SW_PATH) && \
	petalinux-package --boot --u-boot -p $(ABS_SW_PATH)

vitis_apps: 
	xsct app.tcl
	echo "These applications are created:"
	find $(ABS_BUILD_PATH)/ws -name "*.elf"


clean:
	$(RM) -r $(ABS_BUILD_PATH) vivado*.log vivado*.jou 