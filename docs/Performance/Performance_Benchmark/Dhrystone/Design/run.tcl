# ############################################################################
# Copyright (C) 2022-2023, Advanced Micro Devices, Inc. All rights reserved. 
# SPDX-License-Identifier: MIT
#
# This is a generated script based on design: edt_versal
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
# ############################################################################

################################################################################
### Script sets up unique directory with timestamp and generates tutorial design

set epoch [clock seconds]
set proj_dir ./runs/dperf_${epoch}

###Creating VCK190 project
create_project -name dhrystone_tutorial -dir "$proj_dir" -part xcvc1902-vsva2197-2MP-e-S
set_property board_part xilinx.com:vck190:part0:2.2 [current_project]

### Creating block design and wrapper
source ./design.tcl

### Generate pdi 
launch_runs impl_1 -to_step write_device_image

wait_on_run impl_1
open_run impl_1

### Create XSA
write_hw_platform -fixed -force  -include_bit -file dhrystone_tutorial.xsa
