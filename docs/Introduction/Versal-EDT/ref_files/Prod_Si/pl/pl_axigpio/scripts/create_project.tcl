# global variables
set ::platform "edt"
set ::silicon "e-S"

# local variables
set project_dir "project"
set constrs_dir "constrs"
set scripts_dir "scripts"

# set variable names
set part "xcvc1902-vsva2197-2MP-${::silicon}"
set design_name "${::platform}_versal"
puts "INFO: Target part selected: '$part'"

# set up project
create_project $design_name $project_dir -part $part -force
set_property BOARD_PART xilinx.com:vck190:part0:2.0 [current_project]

# set up IP repo
update_ip_catalog -rebuild

# set up bd design
create_bd_design $design_name
source $scripts_dir/edt_versal_bd.tcl
validate_bd_design
regenerate_bd_layout -layout_file $scripts_dir/bd_layout.tcl
save_bd_design

# add hdl sources to project
make_wrapper -files [get_files ./$project_dir/edt_versal.srcs/sources_1/bd/edt_versal/edt_versal.bd] -top

add_files -norecurse ./$project_dir/edt_versal.srcs/sources_1/bd/edt_versal/hdl/edt_versal_wrapper.v
add_files -fileset constrs_1 -norecurse $constrs_dir/gpio.xdc
set_property used_in_synthesis false [get_files  $constrs_dir/gpio.xdc]
update_compile_order -fileset sources_1

update_compile_order -fileset sources_1
update_compile_order -fileset sources_1
validate_bd_design
save_bd_design
update_compile_order -fileset sources_1
regenerate_bd_layout
save_bd_design
