# Copyright 2020 Xilinx Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set project_name "project_1"
set proj_dir ../Hardware/${project_name}_hw
create_project -name ${project_name} -force -dir ${proj_dir} -part xczu9eg-ffvb1156-2-e
set_property board_part xilinx.com:zcu102:part0:3.4 [current_project]
set_property target_language VHDL [current_project]
create_bd_design "mpsoc_preset" -mode batch
instantiate_example_design -template xilinx.com:design:mpsoc_preset:1.0 -design mpsoc_preset -options { Preset.VALUE MPSoC_PL}
update_compile_order -fileset sources_1
launch_runs impl_1 -to_step write_bitstream
										