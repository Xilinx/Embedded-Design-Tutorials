# Copyright (C) 2026, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#*****************************************************************************************

# Open existing project or create from scratch
if { [file exists myproj/project_1.xpr] } {
   open_project myproj/project_1.xpr
} else {
   # Create project and block design
   source ../../edt_zcu102.tcl

   # Generate block design
   generate_target all [get_files -norecurse *.bd]

   # Create top
   add_files -norecurse [make_wrapper -files [get_files -norecurse *.bd] -top]
   update_compile_order -fileset sources_1

   set_property generate_synth_checkpoint true [get_files -norecurse *.bd]
}

# Upgrade any IPs that are outdated for the current Vivado version
set ips_to_upgrade [get_ips -all -quiet]
if { [llength $ips_to_upgrade] > 0 } {
   upgrade_ip $ips_to_upgrade
}

# Reset any failed or stale OOC synthesis runs before launching
foreach run [get_runs -filter {IS_SYNTHESIS == 1 && (STATUS == "Failed" || STATUS == "Running")}] {
   puts "Resetting run: $run"
   reset_run $run
}

# Run implementation (will synthesise any pending/reset runs first)
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1

if {[get_property PROGRESS [get_runs impl_1]] != "100%"} {
   error "impl_1 failed"
}

# Export
write_hw_platform -fixed -include_bit -force ./edt_zcu102_wrapper.xsa
