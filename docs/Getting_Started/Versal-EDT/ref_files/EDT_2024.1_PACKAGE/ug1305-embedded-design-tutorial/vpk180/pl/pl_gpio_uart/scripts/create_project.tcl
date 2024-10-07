enable_beta_device *  

xhub::refresh_catalog [xhub::get_xstores xilinx_board_store]
#xhub::install [xhub::get_xitems xilinx.com:xilinx_board_store:vpk180:*] -quiet


# local variables
set proj_name "edt_versal"
set proj_dir "project_1"
set output_dir "outputs"
set scripts_dir "scripts"
set constrs_dir "constrs"

variable design_name
set design_name $proj_name

# set up project
# set_param board.repoPaths ./board_files
# set_param board.repoPaths {./board_file_repo/1.0} 
set proj_board [get_board_parts "*:vpk180:*" -latest_file_version]
create_project -name project_1 -force -dir ./project_1 -part [get_property PART_NAME [get_board_parts $proj_board]]

set_property board_part $proj_board [current_project]


# set up bd design
create_bd_design $design_name
source $scripts_dir/edt_versal_bd.tcl


# add hdl sources to project
make_wrapper -files [get_files ./${proj_dir}/${proj_dir}.srcs/sources_1/bd/${proj_name}/${proj_name}.bd] -top
add_files -norecurse ./${proj_dir}/${proj_dir}.gen/sources_1/bd/${proj_name}/hdl/${proj_name}_wrapper.v
set_property top ${proj_name}_wrapper [current_fileset]

add_files -fileset constrs_1 -norecurse $constrs_dir/gpio.xdc
update_compile_order -fileset sources_1


validate_bd_design
save_bd_design
update_compile_order -fileset sources_1
regenerate_bd_layout
save_bd_design

set_property synth_checkpoint_mode Hierarchical [get_files ./${proj_dir}/${proj_dir}.srcs/sources_1/bd/$proj_name/${proj_name}.bd]

reset_run synth_1
launch_runs synth_1 -jobs 8
wait_on_run synth_1
if {[get_property PROGRESS [get_runs synth_1]] != "100%"} {   
   puts "ERROR: Synthesis failed"   
} else { puts "PASS_MSG: Synthesis finished Successfully" }

launch_runs impl_1 -to_step write_device_image -jobs 8

wait_on_run impl_1

cd ./${proj_dir}/${proj_dir}.runs/impl_1
exec mv ./${proj_name}_wrapper.pdi ./${proj_name}_wrapper.pdi.orig
exec [exec which bootgen] -arch versal -image ./${proj_name}_wrapper.bif -w -o ./${proj_name}_wrapper.pdi -overlay_cdo ../../../secio-sysmon.v3.cdo   
cd ../../..

file mkdir ./$output_dir
open_run impl_1        
write_hw_platform -fixed -force -include_bit -file ./$output_dir/${proj_name}.xsa
validate_hw_platform -verbose ./$output_dir/${proj_name}.xsa
            
exit
