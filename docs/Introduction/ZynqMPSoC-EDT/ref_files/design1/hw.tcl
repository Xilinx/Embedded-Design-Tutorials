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

# Create project and block design
source ../../edt_zcu102.tcl

# Generate block design
generate_target all [get_files -norecurse *.bd]

# Create top
add_files -norecurse [make_wrapper -files [get_files -norecurse *.bd] -top]
update_compile_order -fileset sources_1

# Run implementation
set_property generate_synth_checkpoint true [get_files -norecurse *.bd]
launch_runs impl_1 -to_step write_bitstream -jobs 16
wait_on_run impl_1

# Export
write_hw_platform -fixed -include_bit -force ./edt_zcu102_wrapper.xsa