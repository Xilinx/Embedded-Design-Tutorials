# Copyright (C) 2025, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#*****************************************************************************************

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