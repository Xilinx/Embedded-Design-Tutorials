# Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#*****************************************************************************************
# Vivado (TM) v2023.2 (64-bit)
#
# lab.tcl: Tcl script for re-creating project 'microblaze_system'
#
# Generated by Vivado on Tue Nov 27 17:44:51 -0700 2023
# IP Build 4028589 on Sat Oct 14 00:45:43 MDT 2023
#
# This file contains the Vivado Tcl commands for re-creating the project to the state*
# when this script was generated. In order to re-create the project, please source this
# file in the Vivado Tcl Shell.
#
#*****************************************************************************************
create_project microblaze_system C:/Projects/UG940_Lab3/microblaze_system -part xc7s100fgga676-2
set_property board_part xilinx.com:sp701:part0:1.1 [current_project]
create_bd_design "mb_subsystem"
update_compile_order -fileset sources_1
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:4.2 mig_7series_0
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:mig_7series -config {Board_Interface "ddr3_sdram" }  [get_bd_cells mig_7series_0]
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0
apply_board_connection -board_interface "rs232_uart" -ip_intf "axi_uartlite_0/UART" -diagram "mb_subsystem" 
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
apply_board_connection -board_interface "led_8bits" -ip_intf "axi_gpio_0/GPIO" -diagram "mb_subsystem"
endgroup
apply_board_connection -board_interface "reset" -ip_intf "mig_7series_0/SYSTEM_RESET" -diagram "mb_subsystem" 
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:microblaze -config { axi_intc {0} axi_periph {Enabled} cache {32KB} clk {/mig_7series_0/ui_addn_clk_0 (100 MHz)} cores {1} debug_module {Extended Debug} ecc {None} local_mem {64KB} preset {None}}  [get_bd_cells microblaze_0]
startgroup
apply_bd_automation -rule xilinx.com:bd_rule:bram_cntlr -config {BRAM "Auto" }  [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA]
apply_bd_automation -rule xilinx.com:bd_rule:bram_cntlr -config {BRAM "Auto" }  [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTB]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/mig_7series_0/ui_addn_clk_0 (100 MHz)} Clk_slave {Auto} Clk_xbar {Auto} Master {/microblaze_0 (Cached)} Slave {/axi_bram_ctrl_0/S_AXI} ddr_seg {Auto} intc_ip {New AXI SmartConnect} master_apm {0}}  [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/mig_7series_0/ui_addn_clk_0 (100 MHz)} Clk_slave {Auto} Clk_xbar {Auto} Master {/microblaze_0 (Periph)} Slave {/axi_gpio_0/S_AXI} ddr_seg {Auto} intc_ip {New AXI Interconnect} master_apm {0}}  [get_bd_intf_pins axi_gpio_0/S_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/mig_7series_0/ui_addn_clk_0 (100 MHz)} Clk_slave {Auto} Clk_xbar {Auto} Master {/microblaze_0 (Periph)} Slave {/axi_uartlite_0/S_AXI} ddr_seg {Auto} intc_ip {New AXI Interconnect} master_apm {0}}  [get_bd_intf_pins axi_uartlite_0/S_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:trigger -config {ila_conn "Auto" }  [get_bd_intf_pins mdm_1/TRIG_IN_0]
apply_bd_automation -rule xilinx.com:bd_rule:trigger -config {ila_conn "Auto" }  [get_bd_intf_pins mdm_1/TRIG_OUT_0]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/mig_7series_0/ui_addn_clk_0 (100 MHz)} Clk_slave {/mig_7series_0/ui_clk (100 MHz)} Clk_xbar {Auto} Master {/microblaze_0 (Cached)} Slave {/mig_7series_0/S_AXI} ddr_seg {Auto} intc_ip {New AXI SmartConnect} master_apm {0}}  [get_bd_intf_pins mig_7series_0/S_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Board_Interface {reset ( FPGA Reset ) } Manual_Source {Auto}}  [get_bd_pins rst_mig_7series_0_100M/ext_reset_in]
endgroup
set_property HDL_ATTRIBUTE.DEBUG true [get_bd_intf_nets {microblaze_0_axi_periph_M00_AXI}]
apply_bd_automation -rule xilinx.com:bd_rule:debug -dict [list \
                                                          [get_bd_intf_nets microblaze_0_axi_periph_M00_AXI] {AXI_R_ADDRESS "Data and Trigger" AXI_R_DATA "Data and Trigger" AXI_W_ADDRESS "Data and Trigger" AXI_W_DATA "Data and Trigger" AXI_W_RESPONSE "Data and Trigger" CLK_SRC "/mig_7series_0/ui_addn_clk_0" SYSTEM_ILA "Auto" APC_EN "0" } \
                                                         ]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/mig_7series_0/ui_addn_clk_0 (100 MHz)} Clk_slave {/mig_7series_0/ui_addn_clk_0 (100 MHz)} Clk_xbar {/mig_7series_0/ui_addn_clk_0 (100 MHz)} Master {/mdm_1/M_AXI} Slave {/axi_bram_ctrl_0/S_AXI} ddr_seg {Auto} intc_ip {/axi_smc} master_apm {0}}  [get_bd_intf_pins mdm_1/M_AXI]
regenerate_bd_layout
validate_bd_design
generate_target all [get_files  C:/Projects/UG940_Lab3/microblaze_system/microblaze_system.srcs/sources_1/bd/mb_subsystem/mb_subsystem.bd]
catch { config_ip_cache -export [get_ips -all mb_subsystem_microblaze_0_0] }
catch { config_ip_cache -export [get_ips -all mb_subsystem_axi_uartlite_0_0] }
catch { config_ip_cache -export [get_ips -all mb_subsystem_axi_gpio_0_0] }
catch { config_ip_cache -export [get_ips -all mb_subsystem_axi_bram_ctrl_0_0] }
catch { config_ip_cache -export [get_ips -all mb_subsystem_dlmb_v10_0] }
catch { config_ip_cache -export [get_ips -all mb_subsystem_ilmb_v10_0] }
catch { config_ip_cache -export [get_ips -all mb_subsystem_dlmb_bram_if_cntlr_0] }
catch { config_ip_cache -export [get_ips -all mb_subsystem_ilmb_bram_if_cntlr_0] }
catch { config_ip_cache -export [get_ips -all mb_subsystem_lmb_bram_0] }
catch { config_ip_cache -export [get_ips -all mb_subsystem_lmb_v10_0] }
catch { config_ip_cache -export [get_ips -all mb_subsystem_mdm_1_0] }
catch { config_ip_cache -export [get_ips -all mb_subsystem_rst_mig_7series_0_100M_0] }
catch { config_ip_cache -export [get_ips -all mb_subsystem_axi_bram_ctrl_0_bram_0] }
catch { config_ip_cache -export [get_ips -all mb_subsystem_axi_smc_0] }
catch { config_ip_cache -export [get_ips -all mb_subsystem_xbar_0] }
catch { config_ip_cache -export [get_ips -all mb_subsystem_system_ila_0] }
export_ip_user_files -of_objects [get_files C:/Projects/UG940_Lab3/microblaze_system/microblaze_system.srcs/sources_1/bd/mb_subsystem/mb_subsystem.bd] -no_script -sync -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] C:/Projects/UG940_Lab3/microblaze_system/microblaze_system.srcs/sources_1/bd/mb_subsystem/mb_subsystem.bd]
launch_runs mb_subsystem_mig_7series_0_0_synth_1 mb_subsystem_microblaze_0_0_synth_1 mb_subsystem_axi_uartlite_0_0_synth_1 mb_subsystem_axi_gpio_0_0_synth_1 mb_subsystem_axi_bram_ctrl_0_0_synth_1 mb_subsystem_dlmb_v10_0_synth_1 mb_subsystem_ilmb_v10_0_synth_1 mb_subsystem_dlmb_bram_if_cntlr_0_synth_1 mb_subsystem_ilmb_bram_if_cntlr_0_synth_1 mb_subsystem_lmb_bram_0_synth_1 mb_subsystem_lmb_v10_0_synth_1 mb_subsystem_mdm_1_0_synth_1 mb_subsystem_rst_mig_7series_0_100M_0_synth_1 mb_subsystem_axi_bram_ctrl_0_bram_0_synth_1 mb_subsystem_axi_smc_0_synth_1 mb_subsystem_xbar_0_synth_1 mb_subsystem_system_ila_0_synth_1 -jobs 8
export_simulation -of_objects [get_files C:/Projects/UG940_Lab3/microblaze_system/microblaze_system.srcs/sources_1/bd/mb_subsystem/mb_subsystem.bd] -directory C:/Projects/UG940_Lab3/microblaze_system/microblaze_system.ip_user_files/sim_scripts -ip_user_files_dir C:/Projects/UG940_Lab3/microblaze_system/microblaze_system.ip_user_files -ipstatic_source_dir C:/Projects/UG940_Lab3/microblaze_system/microblaze_system.ip_user_files/ipstatic -lib_map_path [list {modelsim=C:/Projects/UG940_Lab3/microblaze_system/microblaze_system.cache/compile_simlib/modelsim} {questa=C:/Projects/UG940_Lab3/microblaze_system/microblaze_system.cache/compile_simlib/questa} {riviera=C:/Projects/UG940_Lab3/microblaze_system/microblaze_system.cache/compile_simlib/riviera} {activehdl=C:/Projects/UG940_Lab3/microblaze_system/microblaze_system.cache/compile_simlib/activehdl}] -use_ip_compiled_libs -force -quiet
make_wrapper -files [get_files C:/Projects/UG940_Lab3/microblaze_system/microblaze_system.srcs/sources_1/bd/mb_subsystem/mb_subsystem.bd] -top
add_files -norecurse c:/Projects/UG940_Lab3/microblaze_system/microblaze_system.gen/sources_1/bd/mb_subsystem/hdl/mb_subsystem_wrapper.v
update_compile_order -fileset sources_1
launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1
write_hw_platform -fixed -include_bit -force -file C:/Projects/UG940_Lab3/microblaze_system/mb_subsystem_wrapper.xsa