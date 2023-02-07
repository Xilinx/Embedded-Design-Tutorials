# global variables
set ::platform "edt"
set ::silicon "e-S-es1"

# local variables
set project_dir "project"
set scripts_dir "scripts"

# set variable names
set part "xcvc1902-vsva2197-2MP-${::silicon}"
set design_name "${::platform}_versal"
puts "INFO: Target part selected: '$part'"

# set up project
set_param board.repoPaths ./board_files
create_project $design_name $project_dir -part $part -force
#set_property BOARD_PART xilinx.com:tenzing_es_se1:part0:1.0 [current_project]
#set_property BOARD_PART xilinx.com:vck190_es:part0:1.0 [current_project]
#set_property board_part xilinx.com:zcu111:part0:1.1 [current_project]
set_property BOARD_PART xilinx.com:vck190_es:part0:1.0 [current_project]

# set up IP repo
#set_property ip_repo_paths $ip_dir [current_fileset]
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
update_compile_order -fileset sources_1
# set_property STEPS.SYNTH_DESIGN.ARGS.FANOUT_LIMIT 100 [get_runs synth_1]
# set_property STEPS.SYNTH_DESIGN.ARGS.RETIMING true [get_runs synth_1]
# set_property strategy Performance_ExplorePostRoutePhysOpt [get_runs impl_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sources_1
validate_bd_design
save_bd_design
update_compile_order -fileset sources_1
regenerate_bd_layout
save_bd_design
