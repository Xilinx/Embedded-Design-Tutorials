# © Copyright 2019 – 2020 Xilinx, Inc.
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
