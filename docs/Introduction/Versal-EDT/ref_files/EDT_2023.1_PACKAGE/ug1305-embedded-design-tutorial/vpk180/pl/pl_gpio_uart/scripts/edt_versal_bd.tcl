
#############################################################################
# Copyright (C) 2022 -2023, Advanced Micro Devices, Inc. All rights reserved. 
# SPDX-License-Identifier: MIT
#
# This is a generated script based on design: edt_versal
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
#############################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2022.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   common::send_gid_msg -ssname BD::TCL -id 2040 -severity "WARNING" "This script was generated using Vivado <$scripts_vivado_version> without IP versions in the create_bd_cell commands, but is now being run in <$current_vivado_version> of Vivado. There may have been major IP version changes between Vivado <$scripts_vivado_version> and <$current_vivado_version>, which could impact the parameter settings of the IPs."

}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source edt_versal_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvp1802-lsvc4072-2MP-e-S
   set_property BOARD_PART xilinx.com:vpk180:part0:1.0 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name edt_versal

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set ch0_lpddr4_trip1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 ch0_lpddr4_trip1 ]

  set ch0_lpddr4_trip2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 ch0_lpddr4_trip2 ]

  set ch1_lpddr4_trip1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 ch1_lpddr4_trip1 ]

  set ch1_lpddr4_trip2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 ch1_lpddr4_trip2 ]

  set lpddr4_clk1 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 lpddr4_clk1 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200000000} \
   ] $lpddr4_clk1

  set lpddr4_clk2 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 lpddr4_clk2 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200000000} \
   ] $lpddr4_clk2

  set uart2_bank712 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 uart2_bank712 ]


  # Create ports
  set Dout_0 [ create_bd_port -dir O -from 0 -to 0 Dout_0 ]
  set Dout_1 [ create_bd_port -dir O -from 0 -to 0 Dout_1 ]
  set Dout_2 [ create_bd_port -dir O -from 0 -to 0 Dout_2 ]
  set Dout_3 [ create_bd_port -dir O -from 0 -to 0 Dout_3 ]

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio axi_gpio_0 ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {1} \
    CONFIG.GPIO_BOARD_INTERFACE {Custom} \
    CONFIG.USE_BOARD_FLOW {true} \
  ] $axi_gpio_0


  # Create instance: axi_gpio_1, and set properties
  set axi_gpio_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio axi_gpio_1 ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {1} \
    CONFIG.GPIO_BOARD_INTERFACE {Custom} \
    CONFIG.USE_BOARD_FLOW {true} \
  ] $axi_gpio_1


  # Create instance: axi_gpio_2, and set properties
  set axi_gpio_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio axi_gpio_2 ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {1} \
    CONFIG.GPIO_BOARD_INTERFACE {Custom} \
    CONFIG.USE_BOARD_FLOW {true} \
  ] $axi_gpio_2


  # Create instance: axi_gpio_3, and set properties
  set axi_gpio_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio axi_gpio_3 ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {1} \
    CONFIG.GPIO_BOARD_INTERFACE {Custom} \
    CONFIG.USE_BOARD_FLOW {true} \
  ] $axi_gpio_3


  # Create instance: axi_noc_0, and set properties
  set axi_noc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc axi_noc_0 ]
  set_property -dict [list \
    CONFIG.CH0_LPDDR4_0_BOARD_INTERFACE {ch0_lpddr4_trip1} \
    CONFIG.CH0_LPDDR4_1_BOARD_INTERFACE {ch0_lpddr4_trip2} \
    CONFIG.CH1_LPDDR4_0_BOARD_INTERFACE {ch1_lpddr4_trip1} \
    CONFIG.CH1_LPDDR4_1_BOARD_INTERFACE {ch1_lpddr4_trip2} \
    CONFIG.MC_CHAN_REGION1 {DDR_LOW1} \
    CONFIG.MC_DM_WIDTH {4} \
    CONFIG.MC_DQS_WIDTH {4} \
    CONFIG.MC_DQ_WIDTH {32} \
    CONFIG.MC_INTERLEAVE_SIZE {256} \
    CONFIG.MC_SYSTEM_CLOCK {Differential} \
    CONFIG.NUM_CLKS {8} \
    CONFIG.NUM_MC {2} \
    CONFIG.NUM_MCP {4} \
    CONFIG.NUM_MI {0} \
    CONFIG.NUM_NMI {5} \
    CONFIG.NUM_SI {8} \
    CONFIG.sys_clk0_BOARD_INTERFACE {lpddr4_clk1} \
    CONFIG.sys_clk1_BOARD_INTERFACE {lpddr4_clk2} \
  ] $axi_noc_0


  set_property -dict [ list \
   CONFIG.W_TRAFFIC_CLASS {BEST_EFFORT} \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {M02_INI {read_bw {1720} write_bw {1720}} MC_0 {read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M01_INI {read_bw {1720} write_bw {1720}} M03_INI {read_bw {1720} write_bw {1720}} M04_INI {read_bw {1720} write_bw {1720}}} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S00_AXI]

  set_property -dict [ list \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {M02_INI {read_bw {1720} write_bw {1720}} M01_INI {read_bw {1720} write_bw {1720}} M03_INI {read_bw {1720} write_bw {1720}} M04_INI {read_bw {1720} write_bw {1720}} MC_1 {read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S01_AXI]

  set_property -dict [ list \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_2 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S02_AXI]

  set_property -dict [ list \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_3 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S03_AXI]

  set_property -dict [ list \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {MC_2 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_rpu} \
 ] [get_bd_intf_pins /axi_noc_0/S04_AXI]

  set_property -dict [ list \
   CONFIG.REGION {0} \
   CONFIG.CONNECTIONS {M00_INI { read_bw {1720} write_bw {1720}} MC_3 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_pmc} \
 ] [get_bd_intf_pins /axi_noc_0/S05_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {M02_INI {read_bw {1720} write_bw {1720}} MC_0 {read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M01_INI {read_bw {1720} write_bw {1720}} M03_INI {read_bw {1720} write_bw {1720}} M04_INI {read_bw {1720} write_bw {1720}}} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_nci} \
 ] [get_bd_intf_pins /axi_noc_0/S06_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {M02_INI {read_bw {1720} write_bw {1720}} M01_INI {read_bw {1720} write_bw {1720}} M03_INI {read_bw {1720} write_bw {1720}} M04_INI {read_bw {1720} write_bw {1720}} MC_1 {read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_nci} \
 ] [get_bd_intf_pins /axi_noc_0/S07_AXI]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S00_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk0]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S01_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk1]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S02_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk2]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S03_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk3]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S04_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk4]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S05_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk5]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S06_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk6]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S07_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk7]

  # Create instance: axi_noc_1, and set properties
  set axi_noc_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc axi_noc_1 ]
  set_property -dict [list \
    CONFIG.NUM_CLKS {7} \
    CONFIG.NUM_MI {4} \
    CONFIG.NUM_NSI {5} \
    CONFIG.NUM_SI {3} \
  ] $axi_noc_1


  set_property -dict [ list \
   CONFIG.CATEGORY {ps_pmc} \
 ] [get_bd_intf_pins /axi_noc_1/M00_AXI]

  set_property -dict [ list \
   CONFIG.CATEGORY {ps_pmc} \
 ] [get_bd_intf_pins /axi_noc_1/M01_AXI]

  set_property -dict [ list \
   CONFIG.CATEGORY {ps_pmc} \
 ] [get_bd_intf_pins /axi_noc_1/M02_AXI]

  set_property -dict [ list \
   CONFIG.CATEGORY {ps_pmc} \
 ] [get_bd_intf_pins /axi_noc_1/M03_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {M03_AXI {read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M01_AXI {read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M02_AXI {read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M00_AXI {read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.DEST_IDS {M03_AXI:0xc01:M01_AXI:0x401:M02_AXI:0x801:M00_AXI:0x1} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_pmc} \
 ] [get_bd_intf_pins /axi_noc_1/S00_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {M03_AXI {read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M01_AXI {read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M02_AXI {read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M00_AXI {read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}}} \
 ] [get_bd_intf_pins /axi_noc_1/S00_INI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {M03_AXI {read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M01_AXI {read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M02_AXI {read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M00_AXI {read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.DEST_IDS {M03_AXI:0xc01:M01_AXI:0x401:M02_AXI:0x801:M00_AXI:0x1} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_pmc} \
 ] [get_bd_intf_pins /axi_noc_1/S01_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {M00_AXI { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}}} \
 ] [get_bd_intf_pins /axi_noc_1/S01_INI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {M03_AXI {read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M01_AXI {read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M02_AXI {read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M00_AXI {read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.DEST_IDS {M03_AXI:0xc01:M01_AXI:0x401:M02_AXI:0x801:M00_AXI:0x1} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_pmc} \
 ] [get_bd_intf_pins /axi_noc_1/S02_AXI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {M01_AXI { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}}} \
 ] [get_bd_intf_pins /axi_noc_1/S02_INI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {M02_AXI { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}}} \
 ] [get_bd_intf_pins /axi_noc_1/S03_INI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {M03_AXI { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}}} \
 ] [get_bd_intf_pins /axi_noc_1/S04_INI]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M00_AXI} \
 ] [get_bd_pins /axi_noc_1/aclk0]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S00_AXI} \
 ] [get_bd_pins /axi_noc_1/aclk1]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M01_AXI} \
 ] [get_bd_pins /axi_noc_1/aclk2]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S01_AXI} \
 ] [get_bd_pins /axi_noc_1/aclk3]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M02_AXI} \
 ] [get_bd_pins /axi_noc_1/aclk4]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S02_AXI} \
 ] [get_bd_pins /axi_noc_1/aclk5]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M03_AXI} \
 ] [get_bd_pins /axi_noc_1/aclk6]

  # Create instance: axi_register_slice_1_s1, and set properties
  set axi_register_slice_1_s1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice axi_register_slice_1_s1 ]
  set_property -dict [list \
    CONFIG.REG_AR {10} \
    CONFIG.REG_AW {10} \
    CONFIG.REG_B {10} \
    CONFIG.REG_R {10} \
    CONFIG.REG_W {10} \
  ] $axi_register_slice_1_s1


  # Create instance: axi_register_slice_1_s2, and set properties
  set axi_register_slice_1_s2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice axi_register_slice_1_s2 ]
  set_property -dict [list \
    CONFIG.REG_R {7} \
    CONFIG.REG_W {7} \
  ] $axi_register_slice_1_s2


  # Create instance: axi_register_slice_1_s3, and set properties
  set axi_register_slice_1_s3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice axi_register_slice_1_s3 ]
  set_property -dict [list \
    CONFIG.REG_AR {10} \
    CONFIG.REG_AW {10} \
    CONFIG.REG_B {10} \
    CONFIG.REG_R {10} \
    CONFIG.REG_W {10} \
  ] $axi_register_slice_1_s3


  # Create instance: axi_register_slice_2_s1, and set properties
  set axi_register_slice_2_s1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice axi_register_slice_2_s1 ]
  set_property -dict [list \
    CONFIG.NUM_SLR_CROSSINGS {2} \
    CONFIG.REG_AR {15} \
    CONFIG.REG_AW {15} \
    CONFIG.REG_B {15} \
    CONFIG.REG_R {15} \
    CONFIG.REG_W {15} \
  ] $axi_register_slice_2_s1


  # Create instance: axi_register_slice_2_s2, and set properties
  set axi_register_slice_2_s2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice axi_register_slice_2_s2 ]
  set_property -dict [list \
    CONFIG.REG_R {7} \
    CONFIG.REG_W {7} \
  ] $axi_register_slice_2_s2


  # Create instance: axi_register_slice_2_s3, and set properties
  set axi_register_slice_2_s3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice axi_register_slice_2_s3 ]
  set_property -dict [list \
    CONFIG.NUM_SLR_CROSSINGS {2} \
    CONFIG.REG_AR {15} \
    CONFIG.REG_AW {15} \
    CONFIG.REG_B {15} \
    CONFIG.REG_R {15} \
    CONFIG.REG_W {15} \
  ] $axi_register_slice_2_s3


  # Create instance: axi_register_slice_3_s1, and set properties
  set axi_register_slice_3_s1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice axi_register_slice_3_s1 ]

  # Create instance: axi_register_slice_3_s2, and set properties
  set axi_register_slice_3_s2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice axi_register_slice_3_s2 ]
  set_property -dict [list \
    CONFIG.REG_R {7} \
    CONFIG.REG_W {7} \
  ] $axi_register_slice_3_s2


  # Create instance: axi_register_slice_3_s3, and set properties
  set axi_register_slice_3_s3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice axi_register_slice_3_s3 ]
  set_property -dict [list \
    CONFIG.NUM_SLR_CROSSINGS {3} \
    CONFIG.REG_AR {15} \
    CONFIG.REG_AW {15} \
    CONFIG.REG_B {15} \
    CONFIG.REG_R {15} \
    CONFIG.REG_W {15} \
  ] $axi_register_slice_3_s3


  # Create instance: axi_smc, and set properties
  set axi_smc [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect axi_smc ]
  set_property -dict [list \
    CONFIG.NUM_MI {5} \
    CONFIG.NUM_SI {1} \
  ] $axi_smc


  # Create instance: axi_uartlite_0, and set properties
  set axi_uartlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite axi_uartlite_0 ]
  set_property -dict [list \
    CONFIG.C_BAUDRATE {115200} \
    CONFIG.UARTLITE_BOARD_INTERFACE {uart2_bank712} \
    CONFIG.USE_BOARD_FLOW {true} \
  ] $axi_uartlite_0


  # Create instance: clk_wizard_0, and set properties
  set clk_wizard_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wizard clk_wizard_0 ]
  set_property -dict [list \
    CONFIG.CLKOUT_DRIVES {BUFG,BUFG,BUFG,BUFG,BUFG,BUFG,BUFG} \
    CONFIG.CLKOUT_DYN_PS {None,None,None,None,None,None,None} \
    CONFIG.CLKOUT_GROUPING {Auto,Auto,Auto,Auto,Auto,Auto,Auto} \
    CONFIG.CLKOUT_MATCHED_ROUTING {false,false,false,false,false,false,false} \
    CONFIG.CLKOUT_PORT {clk_out1,clk_out2,clk_out3,clk_out4,clk_out5,clk_out6,clk_out7} \
    CONFIG.CLKOUT_REQUESTED_DUTY_CYCLE {50.000,50.000,50.000,50.000,50.000,50.000,50.000} \
    CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY {250.000,100.000,100.000,100.000,100.000,100.000,100.000} \
    CONFIG.CLKOUT_REQUESTED_PHASE {0.000,0.000,0.000,0.000,0.000,0.000,0.000} \
    CONFIG.CLKOUT_USED {true,false,false,false,false,false,false} \
  ] $clk_wizard_0


  # Create instance: rst_versal_cips_0_333M, and set properties
  set rst_versal_cips_0_333M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset rst_versal_cips_0_333M ]

  # Create instance: versal_cips_0, and set properties
  set versal_cips_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:versal_cips versal_cips_0 ]
  set_property -dict [list \
    CONFIG.DDR_MEMORY_MODE {Custom} \
    CONFIG.DEBUG_MODE {JTAG} \
    CONFIG.DESIGN_MODE {1} \
    CONFIG.PS_BOARD_INTERFACE {ps_pmc_fixed_io} \
    CONFIG.PS_PL_CONNECTIVITY_MODE {Custom} \
    CONFIG.PS_PMC_CONFIG { \
      DDR_MEMORY_MODE {Connectivity to DDR via NOC} \
      DEBUG_MODE {JTAG} \
      DESIGN_MODE {1} \
      DEVICE_INTEGRITY_MODE {Sysmon temperature voltage and external IO monitoring} \
      PMC_GPIO0_MIO_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 0 .. 25}}} \
      PMC_GPIO1_MIO_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 26 .. 51}}} \
      PMC_MIO37 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA high} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_QSPI_FBCLK {{ENABLE 1} {IO {PMC_MIO 6}}} \
      PMC_QSPI_PERIPHERAL_DATA_MODE {x4} \
      PMC_QSPI_PERIPHERAL_ENABLE {1} \
      PMC_QSPI_PERIPHERAL_MODE {Dual Parallel} \
      PMC_REF_CLK_FREQMHZ {33.3333} \
      PMC_SD1 {{CD_ENABLE 1} {CD_IO {PMC_MIO 28}} {POW_ENABLE 1} {POW_IO {PMC_MIO 51}} {RESET_ENABLE 0} {RESET_IO {PMC_MIO 12}} {WP_ENABLE 0} {WP_IO {PMC_MIO 1}}} \
      PMC_SD1_PERIPHERAL {{CLK_100_SDR_OTAP_DLY 0x3} {CLK_200_SDR_OTAP_DLY 0x2} {CLK_50_DDR_ITAP_DLY 0x2A} {CLK_50_DDR_OTAP_DLY 0x3} {CLK_50_SDR_ITAP_DLY 0x25} {CLK_50_SDR_OTAP_DLY 0x4} {ENABLE 1} {IO\
{PMC_MIO 26 .. 36}}} \
      PMC_SD1_SLOT_TYPE {SD 3.0 AUTODIR} \
      PMC_USE_NOC_PMC_AXI0 {1} \
      PMC_USE_NOC_PMC_AXI1 {1} \
      PMC_USE_NOC_PMC_AXI2 {1} \
      PMC_USE_NOC_PMC_AXI3 {1} \
      PMC_USE_PMC_NOC_AXI0 {1} \
      PMC_USE_PMC_NOC_AXI1 {1} \
      PMC_USE_PMC_NOC_AXI2 {1} \
      PMC_USE_PMC_NOC_AXI3 {1} \
      PS_BOARD_INTERFACE {ps_pmc_fixed_io} \
      PS_ENET0_MDIO {{ENABLE 1} {IO {PS_MIO 24 .. 25}}} \
      PS_ENET0_PERIPHERAL {{ENABLE 1} {IO {PS_MIO 0 .. 11}}} \
      PS_GEM0_ROUTE_THROUGH_FPD {1} \
      PS_GEM1_ROUTE_THROUGH_FPD {0} \
      PS_GEN_IPI0_ENABLE {1} \
      PS_GEN_IPI0_MASTER {A72} \
      PS_GEN_IPI1_ENABLE {1} \
      PS_GEN_IPI1_MASTER {R5_0} \
      PS_GEN_IPI2_ENABLE {1} \
      PS_GEN_IPI2_MASTER {R5_1} \
      PS_GEN_IPI3_ENABLE {1} \
      PS_GEN_IPI3_MASTER {A72} \
      PS_GEN_IPI4_ENABLE {1} \
      PS_GEN_IPI4_MASTER {A72} \
      PS_GEN_IPI5_ENABLE {1} \
      PS_GEN_IPI5_MASTER {A72} \
      PS_GEN_IPI6_ENABLE {1} \
      PS_GEN_IPI6_MASTER {A72} \
      PS_GEN_IPI_PMCNOBUF_ENABLE {1} \
      PS_GEN_IPI_PMC_ENABLE {1} \
      PS_GEN_IPI_PSM_ENABLE {1} \
      PS_HSDP_EGRESS_TRAFFIC {JTAG} \
      PS_HSDP_INGRESS_TRAFFIC {JTAG} \
      PS_HSDP_MODE {None} \
      PS_I2C0_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 46 .. 47}}} \
      PS_I2C1_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 44 .. 45}}} \
      PS_I2CSYSMON_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 39 .. 40}}} \
      PS_LPDMA0_ROUTE_THROUGH_FPD {1} \
      PS_LPDMA1_ROUTE_THROUGH_FPD {1} \
      PS_LPDMA2_ROUTE_THROUGH_FPD {1} \
      PS_LPDMA3_ROUTE_THROUGH_FPD {1} \
      PS_LPDMA4_ROUTE_THROUGH_FPD {1} \
      PS_LPDMA5_ROUTE_THROUGH_FPD {1} \
      PS_LPDMA6_ROUTE_THROUGH_FPD {1} \
      PS_LPDMA7_ROUTE_THROUGH_FPD {1} \
      PS_MIO7 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL disable} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO9 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL disable} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_NUM_FABRIC_RESETS {1} \
      PS_PCIE_RESET {{ENABLE 1}} \
      PS_PL_CONNECTIVITY_MODE {Custom} \
      PS_TTC0_PERIPHERAL_ENABLE {1} \
      PS_TTC1_PERIPHERAL_ENABLE {1} \
      PS_TTC2_PERIPHERAL_ENABLE {1} \
      PS_TTC3_PERIPHERAL_ENABLE {1} \
      PS_UART0_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 42 .. 43}}} \
      PS_USB3_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 13 .. 25}}} \
      PS_USB_ROUTE_THROUGH_FPD {1} \
      PS_USE_FPD_AXI_NOC0 {1} \
      PS_USE_FPD_AXI_NOC1 {1} \
      PS_USE_FPD_CCI_NOC {1} \
      PS_USE_FPD_CCI_NOC0 {1} \
      PS_USE_M_AXI_FPD {1} \
      PS_USE_NOC_LPD_AXI0 {1} \
      PS_USE_PMCPL_CLK0 {1} \
      PS_USE_PMCPL_CLK1 {0} \
      PS_USE_PMCPL_CLK2 {0} \
      PS_USE_PMCPL_CLK3 {0} \
      PS_WWDT0_CLK {{ENABLE 1} {IO APB}} \
      PS_WWDT0_PERIPHERAL {{ENABLE 1} {IO EMIO}} \
      SMON_ALARMS {Set_Alarms_On} \
      SMON_ENABLE_TEMP_AVERAGING {0} \
      SMON_INTERFACE_TO_USE {I2C} \
      SMON_MEAS126 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {2 V unipolar}} {NAME VCCAUX} {SUPPLY_NUM 0}} \
      SMON_MEAS127 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {2 V unipolar}} {NAME VCCAUX_PMC} {SUPPLY_NUM 1}} \
      SMON_MEAS148 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {2 V unipolar}} {NAME VCC_PMC} {SUPPLY_NUM 2}} \
      SMON_MEAS149 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {2 V unipolar}} {NAME VCC_PSFP} {SUPPLY_NUM 3}} \
      SMON_MEAS150 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {2 V unipolar}} {NAME VCC_PSLP} {SUPPLY_NUM 4}} \
      SMON_MEAS152 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {2 V unipolar}} {NAME VCC_SOC} {SUPPLY_NUM 5}} \
      SMON_MEAS153 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {2 V unipolar}} {NAME VP_VN} {SUPPLY_NUM 6}} \
      SMON_MEAS35 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {2 V unipolar}} {NAME GTM_AVCC_109} {SUPPLY_NUM 15}} \
      SMON_MEAS39 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {2 V unipolar}} {NAME GTM_AVCC_115} {SUPPLY_NUM 7}} \
      SMON_MEAS43 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {2 V unipolar}} {NAME GTM_AVCC_121} {SUPPLY_NUM 8}} \
      SMON_PMBUS_ADDRESS {0x18} \
      SMON_TEMP_AVERAGING_SAMPLES {0} \
    } \
  ] $versal_cips_0


  # Create interface connections
  connect_bd_intf_net -intf_net axi_noc_0_CH0_LPDDR4_0 [get_bd_intf_ports ch0_lpddr4_trip1] [get_bd_intf_pins axi_noc_0/CH0_LPDDR4_0]
  connect_bd_intf_net -intf_net axi_noc_0_CH0_LPDDR4_1 [get_bd_intf_ports ch0_lpddr4_trip2] [get_bd_intf_pins axi_noc_0/CH0_LPDDR4_1]
  connect_bd_intf_net -intf_net axi_noc_0_CH1_LPDDR4_0 [get_bd_intf_ports ch1_lpddr4_trip1] [get_bd_intf_pins axi_noc_0/CH1_LPDDR4_0]
  connect_bd_intf_net -intf_net axi_noc_0_CH1_LPDDR4_1 [get_bd_intf_ports ch1_lpddr4_trip2] [get_bd_intf_pins axi_noc_0/CH1_LPDDR4_1]
  connect_bd_intf_net -intf_net axi_noc_0_M00_INI [get_bd_intf_pins axi_noc_0/M00_INI] [get_bd_intf_pins axi_noc_1/S00_INI]
  connect_bd_intf_net -intf_net axi_noc_0_M01_INI [get_bd_intf_pins axi_noc_0/M01_INI] [get_bd_intf_pins axi_noc_1/S01_INI]
  connect_bd_intf_net -intf_net axi_noc_0_M02_INI [get_bd_intf_pins axi_noc_0/M02_INI] [get_bd_intf_pins axi_noc_1/S02_INI]
  connect_bd_intf_net -intf_net axi_noc_0_M03_INI [get_bd_intf_pins axi_noc_0/M03_INI] [get_bd_intf_pins axi_noc_1/S03_INI]
  connect_bd_intf_net -intf_net axi_noc_0_M04_INI [get_bd_intf_pins axi_noc_0/M04_INI] [get_bd_intf_pins axi_noc_1/S04_INI]
  connect_bd_intf_net -intf_net axi_noc_1_M00_AXI [get_bd_intf_pins axi_noc_1/M00_AXI] [get_bd_intf_pins versal_cips_0/NOC_PMC_AXI_0]
  connect_bd_intf_net -intf_net axi_noc_1_M01_AXI [get_bd_intf_pins axi_noc_1/M01_AXI] [get_bd_intf_pins versal_cips_0/NOC_PMC_AXI_1]
  connect_bd_intf_net -intf_net axi_noc_1_M02_AXI [get_bd_intf_pins axi_noc_1/M02_AXI] [get_bd_intf_pins versal_cips_0/NOC_PMC_AXI_2]
  connect_bd_intf_net -intf_net axi_noc_1_M03_AXI [get_bd_intf_pins axi_noc_1/M03_AXI] [get_bd_intf_pins versal_cips_0/NOC_PMC_AXI_3]
  connect_bd_intf_net -intf_net axi_register_slice_1_s1_M_AXI [get_bd_intf_pins axi_register_slice_1_s1/M_AXI] [get_bd_intf_pins axi_register_slice_1_s2/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_s2_M_AXI [get_bd_intf_pins axi_register_slice_1_s2/M_AXI] [get_bd_intf_pins axi_register_slice_1_s3/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_s3_M_AXI [get_bd_intf_pins axi_gpio_1/S_AXI] [get_bd_intf_pins axi_register_slice_1_s3/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_2_s1_M_AXI [get_bd_intf_pins axi_register_slice_2_s1/M_AXI] [get_bd_intf_pins axi_register_slice_2_s2/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_2_s2_M_AXI [get_bd_intf_pins axi_register_slice_2_s2/M_AXI] [get_bd_intf_pins axi_register_slice_2_s3/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_2_s3_M_AXI [get_bd_intf_pins axi_gpio_2/S_AXI] [get_bd_intf_pins axi_register_slice_2_s3/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_3_s1_M_AXI [get_bd_intf_pins axi_register_slice_3_s1/M_AXI] [get_bd_intf_pins axi_register_slice_3_s2/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_3_s2_M_AXI [get_bd_intf_pins axi_register_slice_3_s2/M_AXI] [get_bd_intf_pins axi_register_slice_3_s3/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_3_s3_M_AXI [get_bd_intf_pins axi_gpio_3/S_AXI] [get_bd_intf_pins axi_register_slice_3_s3/M_AXI]
  connect_bd_intf_net -intf_net axi_smc_M00_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins axi_smc/M00_AXI]
  connect_bd_intf_net -intf_net axi_smc_M01_AXI [get_bd_intf_pins axi_register_slice_1_s1/S_AXI] [get_bd_intf_pins axi_smc/M01_AXI]
  connect_bd_intf_net -intf_net axi_smc_M02_AXI [get_bd_intf_pins axi_register_slice_2_s1/S_AXI] [get_bd_intf_pins axi_smc/M02_AXI]
  connect_bd_intf_net -intf_net axi_smc_M03_AXI [get_bd_intf_pins axi_register_slice_3_s1/S_AXI] [get_bd_intf_pins axi_smc/M03_AXI]
  connect_bd_intf_net -intf_net axi_smc_M04_AXI [get_bd_intf_pins axi_smc/M04_AXI] [get_bd_intf_pins axi_uartlite_0/S_AXI]
  connect_bd_intf_net -intf_net axi_uartlite_0_UART [get_bd_intf_ports uart2_bank712] [get_bd_intf_pins axi_uartlite_0/UART]
  connect_bd_intf_net -intf_net lpddr4_clk1_1 [get_bd_intf_ports lpddr4_clk1] [get_bd_intf_pins axi_noc_0/sys_clk0]
  connect_bd_intf_net -intf_net lpddr4_clk2_1 [get_bd_intf_ports lpddr4_clk2] [get_bd_intf_pins axi_noc_0/sys_clk1]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_AXI_NOC_0 [get_bd_intf_pins axi_noc_0/S06_AXI] [get_bd_intf_pins versal_cips_0/FPD_AXI_NOC_0]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_AXI_NOC_1 [get_bd_intf_pins axi_noc_0/S07_AXI] [get_bd_intf_pins versal_cips_0/FPD_AXI_NOC_1]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_0 [get_bd_intf_pins axi_noc_0/S00_AXI] [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_0]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_1 [get_bd_intf_pins axi_noc_0/S01_AXI] [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_1]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_2 [get_bd_intf_pins axi_noc_0/S02_AXI] [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_2]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_3 [get_bd_intf_pins axi_noc_0/S03_AXI] [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_3]
  connect_bd_intf_net -intf_net versal_cips_0_LPD_AXI_NOC_0 [get_bd_intf_pins axi_noc_0/S04_AXI] [get_bd_intf_pins versal_cips_0/LPD_AXI_NOC_0]
  connect_bd_intf_net -intf_net versal_cips_0_M_AXI_FPD [get_bd_intf_pins axi_smc/S00_AXI] [get_bd_intf_pins versal_cips_0/M_AXI_FPD]
  connect_bd_intf_net -intf_net versal_cips_0_PMC_NOC_AXI_0 [get_bd_intf_pins axi_noc_0/S05_AXI] [get_bd_intf_pins versal_cips_0/PMC_NOC_AXI_0]
  connect_bd_intf_net -intf_net versal_cips_0_PMC_NOC_AXI_1 [get_bd_intf_pins axi_noc_1/S00_AXI] [get_bd_intf_pins versal_cips_0/PMC_NOC_AXI_1]
  connect_bd_intf_net -intf_net versal_cips_0_PMC_NOC_AXI_2 [get_bd_intf_pins axi_noc_1/S01_AXI] [get_bd_intf_pins versal_cips_0/PMC_NOC_AXI_2]
  connect_bd_intf_net -intf_net versal_cips_0_PMC_NOC_AXI_3 [get_bd_intf_pins axi_noc_1/S02_AXI] [get_bd_intf_pins versal_cips_0/PMC_NOC_AXI_3]

  # Create port connections
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_ports Dout_0] [get_bd_pins axi_gpio_0/gpio_io_o]
  connect_bd_net -net axi_gpio_1_gpio_io_o [get_bd_ports Dout_1] [get_bd_pins axi_gpio_1/gpio_io_o]
  connect_bd_net -net axi_gpio_2_gpio_io_o [get_bd_ports Dout_2] [get_bd_pins axi_gpio_2/gpio_io_o]
  connect_bd_net -net axi_gpio_3_gpio_io_o [get_bd_ports Dout_3] [get_bd_pins axi_gpio_3/gpio_io_o]
  connect_bd_net -net clk_wizard_0_clk_out1 [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_gpio_1/s_axi_aclk] [get_bd_pins axi_gpio_2/s_axi_aclk] [get_bd_pins axi_gpio_3/s_axi_aclk] [get_bd_pins axi_register_slice_1_s1/aclk] [get_bd_pins axi_register_slice_1_s2/aclk] [get_bd_pins axi_register_slice_1_s3/aclk] [get_bd_pins axi_register_slice_2_s1/aclk] [get_bd_pins axi_register_slice_2_s2/aclk] [get_bd_pins axi_register_slice_2_s3/aclk] [get_bd_pins axi_register_slice_3_s1/aclk] [get_bd_pins axi_register_slice_3_s2/aclk] [get_bd_pins axi_register_slice_3_s3/aclk] [get_bd_pins axi_smc/aclk] [get_bd_pins axi_uartlite_0/s_axi_aclk] [get_bd_pins clk_wizard_0/clk_out1] [get_bd_pins rst_versal_cips_0_333M/slowest_sync_clk] [get_bd_pins versal_cips_0/m_axi_fpd_aclk]
  connect_bd_net -net rst_versal_cips_0_333M_interconnect_aresetn [get_bd_pins axi_smc/aresetn] [get_bd_pins rst_versal_cips_0_333M/interconnect_aresetn]
  connect_bd_net -net rst_versal_cips_0_333M_peripheral_aresetn [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_gpio_1/s_axi_aresetn] [get_bd_pins axi_gpio_2/s_axi_aresetn] [get_bd_pins axi_gpio_3/s_axi_aresetn] [get_bd_pins axi_register_slice_1_s1/aresetn] [get_bd_pins axi_register_slice_1_s2/aresetn] [get_bd_pins axi_register_slice_1_s3/aresetn] [get_bd_pins axi_register_slice_2_s1/aresetn] [get_bd_pins axi_register_slice_2_s2/aresetn] [get_bd_pins axi_register_slice_2_s3/aresetn] [get_bd_pins axi_register_slice_3_s1/aresetn] [get_bd_pins axi_register_slice_3_s2/aresetn] [get_bd_pins axi_register_slice_3_s3/aresetn] [get_bd_pins axi_uartlite_0/s_axi_aresetn] [get_bd_pins rst_versal_cips_0_333M/peripheral_aresetn]
  connect_bd_net -net versal_cips_0_fpd_axi_noc_axi0_clk [get_bd_pins axi_noc_0/aclk6] [get_bd_pins versal_cips_0/fpd_axi_noc_axi0_clk]
  connect_bd_net -net versal_cips_0_fpd_axi_noc_axi1_clk [get_bd_pins axi_noc_0/aclk7] [get_bd_pins versal_cips_0/fpd_axi_noc_axi1_clk]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi0_clk [get_bd_pins axi_noc_0/aclk0] [get_bd_pins versal_cips_0/fpd_cci_noc_axi0_clk]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi1_clk [get_bd_pins axi_noc_0/aclk1] [get_bd_pins versal_cips_0/fpd_cci_noc_axi1_clk]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi2_clk [get_bd_pins axi_noc_0/aclk2] [get_bd_pins versal_cips_0/fpd_cci_noc_axi2_clk]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi3_clk [get_bd_pins axi_noc_0/aclk3] [get_bd_pins versal_cips_0/fpd_cci_noc_axi3_clk]
  connect_bd_net -net versal_cips_0_lpd_axi_noc_clk [get_bd_pins axi_noc_0/aclk4] [get_bd_pins versal_cips_0/lpd_axi_noc_clk]
  connect_bd_net -net versal_cips_0_noc_pmc_axi_axi0_clk [get_bd_pins axi_noc_1/aclk0] [get_bd_pins versal_cips_0/noc_pmc_axi_axi0_clk]
  connect_bd_net -net versal_cips_0_noc_pmc_axi_axi1_clk [get_bd_pins axi_noc_1/aclk2] [get_bd_pins versal_cips_0/noc_pmc_axi_axi1_clk]
  connect_bd_net -net versal_cips_0_noc_pmc_axi_axi2_clk [get_bd_pins axi_noc_1/aclk4] [get_bd_pins versal_cips_0/noc_pmc_axi_axi2_clk]
  connect_bd_net -net versal_cips_0_noc_pmc_axi_axi3_clk [get_bd_pins axi_noc_1/aclk6] [get_bd_pins versal_cips_0/noc_pmc_axi_axi3_clk]
  connect_bd_net -net versal_cips_0_pl0_ref_clk1 [get_bd_pins clk_wizard_0/clk_in1] [get_bd_pins versal_cips_0/pl0_ref_clk]
  connect_bd_net -net versal_cips_0_pl0_resetn [get_bd_pins rst_versal_cips_0_333M/ext_reset_in] [get_bd_pins versal_cips_0/pl0_resetn]
  connect_bd_net -net versal_cips_0_pmc_axi_noc_axi0_clk [get_bd_pins axi_noc_0/aclk5] [get_bd_pins versal_cips_0/pmc_axi_noc_axi0_clk]
  connect_bd_net -net versal_cips_0_pmc_axi_noc_axi1_clk [get_bd_pins axi_noc_1/aclk1] [get_bd_pins versal_cips_0/pmc_axi_noc_axi1_clk]
  connect_bd_net -net versal_cips_0_pmc_axi_noc_axi2_clk [get_bd_pins axi_noc_1/aclk3] [get_bd_pins versal_cips_0/pmc_axi_noc_axi2_clk]
  connect_bd_net -net versal_cips_0_pmc_axi_noc_axi3_clk [get_bd_pins axi_noc_1/aclk5] [get_bd_pins versal_cips_0/pmc_axi_noc_axi3_clk]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs axi_noc_0/S06_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs axi_noc_0/S06_AXI/C0_DDR_LOW1x2] -force
  assign_bd_address -offset 0x000100800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_0] -force
  assign_bd_address -offset 0x000100D10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_cti] -force
  assign_bd_address -offset 0x000100D00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_dbg] -force
  assign_bd_address -offset 0x000100D30000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_etm] -force
  assign_bd_address -offset 0x000100D20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_pmu] -force
  assign_bd_address -offset 0x000100D50000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_cti] -force
  assign_bd_address -offset 0x000100D40000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_dbg] -force
  assign_bd_address -offset 0x000100D70000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_etm] -force
  assign_bd_address -offset 0x000100D60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_pmu] -force
  assign_bd_address -offset 0x000100CA0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_cti] -force
  assign_bd_address -offset 0x000100C60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_ela] -force
  assign_bd_address -offset 0x000100C30000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_etf] -force
  assign_bd_address -offset 0x000100C20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_fun] -force
  assign_bd_address -offset 0x000100F80000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_atm] -force
  assign_bd_address -offset 0x000100FA0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_cti2a] -force
  assign_bd_address -offset 0x000100FD0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_cti2d] -force
  assign_bd_address -offset 0x000100F40000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2a] -force
  assign_bd_address -offset 0x000100F50000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2b] -force
  assign_bd_address -offset 0x000100F60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2c] -force
  assign_bd_address -offset 0x000100F70000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2d] -force
  assign_bd_address -offset 0x000100F20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_fun] -force
  assign_bd_address -offset 0x000100F00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_rom] -force
  assign_bd_address -offset 0x000100B80000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_fpd_atm] -force
  assign_bd_address -offset 0x000100B70000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_fpd_stm] -force
  assign_bd_address -offset 0x000100980000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_lpd_atm] -force
  assign_bd_address -offset 0x000101260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_crp_0] -force
  assign_bd_address -offset 0x0001011E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001011F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001012D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001012B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001011C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001011D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000101250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000101240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000101110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000101020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_gpio_0] -force
  assign_bd_address -offset 0x000100280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000100310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x000101030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_qspi_0] -force
  assign_bd_address -offset 0x000102000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram] -force
  assign_bd_address -offset 0x000100240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000100200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x000106000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000101200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001012A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000101050000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_sd_1] -force
  assign_bd_address -offset 0x000101210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_sha] -force
  assign_bd_address -offset 0x000101220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x000102100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000101270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000100083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000100283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000101230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001012F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000101310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000101300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_xppu_npi_0] -force
  assign_bd_address -offset 0x000108800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_coresight_0] -force
  assign_bd_address -offset 0x000109260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_crp_0] -force
  assign_bd_address -offset 0x0001091E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001091F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001092D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001092B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001091C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001091D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000109250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000109240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000109110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000108280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000108310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x00010A000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram] -force
  assign_bd_address -offset 0x000108240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000108200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x00010E000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000109200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001092A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000109210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_sha] -force
  assign_bd_address -offset 0x000109220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x00010A100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000109270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000108083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000108283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000109230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001092F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000109310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000109300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_xppu_npi_0] -force
  assign_bd_address -offset 0x000110800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_coresight_0] -force
  assign_bd_address -offset 0x000111260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_crp_0] -force
  assign_bd_address -offset 0x0001111E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001111F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001112D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001112B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001111C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001111D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000111250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000111240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000111110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000110280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000110310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x000112000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram] -force
  assign_bd_address -offset 0x000110240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000110200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x000116000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000111200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001112A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000111210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_sha] -force
  assign_bd_address -offset 0x000111220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x000112100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000111270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000110083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000110283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000111230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001112F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000111310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000111300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_xppu_npi_0] -force
  assign_bd_address -offset 0x000118800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_coresight_0] -force
  assign_bd_address -offset 0x000119260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_crp_0] -force
  assign_bd_address -offset 0x0001191E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001191F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001192D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001192B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001191C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001191D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000119250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000119240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000119110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000118280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000118310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x00011A000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram] -force
  assign_bd_address -offset 0x000118240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000118200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x00011E000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000119200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001192A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000119210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_sha] -force
  assign_bd_address -offset 0x000119220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x00011A100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000119270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000118083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000118283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000119230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001192F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000119310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000119300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_xppu_npi_0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs axi_noc_0/S07_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs axi_noc_0/S07_AXI/C1_DDR_LOW1x2] -force
  assign_bd_address -offset 0x000100800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_0] -force
  assign_bd_address -offset 0x000100D10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_cti] -force
  assign_bd_address -offset 0x000100D00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_dbg] -force
  assign_bd_address -offset 0x000100D30000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_etm] -force
  assign_bd_address -offset 0x000100D20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_pmu] -force
  assign_bd_address -offset 0x000100D50000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_cti] -force
  assign_bd_address -offset 0x000100D40000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_dbg] -force
  assign_bd_address -offset 0x000100D70000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_etm] -force
  assign_bd_address -offset 0x000100D60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_pmu] -force
  assign_bd_address -offset 0x000100CA0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_cti] -force
  assign_bd_address -offset 0x000100C60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_ela] -force
  assign_bd_address -offset 0x000100C30000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_etf] -force
  assign_bd_address -offset 0x000100C20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_fun] -force
  assign_bd_address -offset 0x000100F80000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_atm] -force
  assign_bd_address -offset 0x000100FA0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_cti2a] -force
  assign_bd_address -offset 0x000100FD0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_cti2d] -force
  assign_bd_address -offset 0x000100F40000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2a] -force
  assign_bd_address -offset 0x000100F50000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2b] -force
  assign_bd_address -offset 0x000100F60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2c] -force
  assign_bd_address -offset 0x000100F70000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2d] -force
  assign_bd_address -offset 0x000100F20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_fun] -force
  assign_bd_address -offset 0x000100F00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_rom] -force
  assign_bd_address -offset 0x000100B80000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_fpd_atm] -force
  assign_bd_address -offset 0x000100B70000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_fpd_stm] -force
  assign_bd_address -offset 0x000100980000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_lpd_atm] -force
  assign_bd_address -offset 0x000101260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_crp_0] -force
  assign_bd_address -offset 0x0001011E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001011F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001012D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001012B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001011C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001011D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000101250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000101240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000101110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000101020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_gpio_0] -force
  assign_bd_address -offset 0x000100280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000100310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x000101030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_qspi_0] -force
  assign_bd_address -offset 0x000102000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram] -force
  assign_bd_address -offset 0x000100240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000100200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x000106000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000101200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001012A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000101050000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_sd_1] -force
  assign_bd_address -offset 0x000101210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_sha] -force
  assign_bd_address -offset 0x000101220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x000102100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000101270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000100083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000100283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000101230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001012F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000101310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000101300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_xppu_npi_0] -force
  assign_bd_address -offset 0x000108800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_coresight_0] -force
  assign_bd_address -offset 0x000109260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_crp_0] -force
  assign_bd_address -offset 0x0001091E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001091F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001092D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001092B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001091C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001091D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000109250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000109240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000109110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000108280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000108310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x00010A000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram] -force
  assign_bd_address -offset 0x000108240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000108200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x00010E000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000109200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001092A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000109210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_sha] -force
  assign_bd_address -offset 0x000109220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x00010A100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000109270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000108083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000108283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000109230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001092F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000109310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000109300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_xppu_npi_0] -force
  assign_bd_address -offset 0x000110800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_coresight_0] -force
  assign_bd_address -offset 0x000111260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_crp_0] -force
  assign_bd_address -offset 0x0001111E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001111F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001112D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001112B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001111C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001111D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000111250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000111240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000111110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000110280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000110310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x000112000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram] -force
  assign_bd_address -offset 0x000110240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000110200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x000116000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000111200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001112A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000111210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_sha] -force
  assign_bd_address -offset 0x000111220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x000112100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000111270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000110083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000110283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000111230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001112F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000111310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000111300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_xppu_npi_0] -force
  assign_bd_address -offset 0x000118800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_coresight_0] -force
  assign_bd_address -offset 0x000119260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_crp_0] -force
  assign_bd_address -offset 0x0001191E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001191F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001192D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001192B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001191C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001191D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000119250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000119240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000119110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000118280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000118310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x00011A000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram] -force
  assign_bd_address -offset 0x000118240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000118200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x00011E000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000119200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001192A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000119210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_sha] -force
  assign_bd_address -offset 0x000119220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x00011A100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000119270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000118083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000118283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000119230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001192F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000119310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000119300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_xppu_npi_0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs axi_noc_0/S00_AXI/C0_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs axi_noc_0/S00_AXI/C0_DDR_LOW1x2] -force
  assign_bd_address -offset 0x000100800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_0] -force
  assign_bd_address -offset 0x000100D10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_cti] -force
  assign_bd_address -offset 0x000100D00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_dbg] -force
  assign_bd_address -offset 0x000100D30000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_etm] -force
  assign_bd_address -offset 0x000100D20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_pmu] -force
  assign_bd_address -offset 0x000100D50000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_cti] -force
  assign_bd_address -offset 0x000100D40000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_dbg] -force
  assign_bd_address -offset 0x000100D70000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_etm] -force
  assign_bd_address -offset 0x000100D60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_pmu] -force
  assign_bd_address -offset 0x000100CA0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_cti] -force
  assign_bd_address -offset 0x000100C60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_ela] -force
  assign_bd_address -offset 0x000100C30000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_etf] -force
  assign_bd_address -offset 0x000100C20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_fun] -force
  assign_bd_address -offset 0x000100F80000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_atm] -force
  assign_bd_address -offset 0x000100FA0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_cti2a] -force
  assign_bd_address -offset 0x000100FD0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_cti2d] -force
  assign_bd_address -offset 0x000100F40000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2a] -force
  assign_bd_address -offset 0x000100F50000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2b] -force
  assign_bd_address -offset 0x000100F60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2c] -force
  assign_bd_address -offset 0x000100F70000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2d] -force
  assign_bd_address -offset 0x000100F20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_fun] -force
  assign_bd_address -offset 0x000100F00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_rom] -force
  assign_bd_address -offset 0x000100B80000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_fpd_atm] -force
  assign_bd_address -offset 0x000100B70000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_fpd_stm] -force
  assign_bd_address -offset 0x000100980000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_lpd_atm] -force
  assign_bd_address -offset 0x000101260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_crp_0] -force
  assign_bd_address -offset 0x0001011E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001011F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001012D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001012B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001011C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001011D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000101250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000101240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000101110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000101020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_gpio_0] -force
  assign_bd_address -offset 0x000100280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000100310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x000101030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_qspi_0] -force
  assign_bd_address -offset 0x000102000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram] -force
  assign_bd_address -offset 0x000100240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000100200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x000106000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000101200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001012A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000101050000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_sd_1] -force
  assign_bd_address -offset 0x000101210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_sha] -force
  assign_bd_address -offset 0x000101220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x000102100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000101270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000100083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000100283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000101230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001012F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000101310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000101300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_xppu_npi_0] -force
  assign_bd_address -offset 0x000108800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_coresight_0] -force
  assign_bd_address -offset 0x000109260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_crp_0] -force
  assign_bd_address -offset 0x0001091E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001091F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001092D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001092B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001091C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001091D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000109250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000109240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000109110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000108280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000108310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x00010A000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram] -force
  assign_bd_address -offset 0x000108240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000108200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x00010E000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000109200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001092A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000109210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_sha] -force
  assign_bd_address -offset 0x000109220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x00010A100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000109270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000108083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000108283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000109230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001092F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000109310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000109300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_xppu_npi_0] -force
  assign_bd_address -offset 0x000110800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_coresight_0] -force
  assign_bd_address -offset 0x000111260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_crp_0] -force
  assign_bd_address -offset 0x0001111E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001111F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001112D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001112B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001111C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001111D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000111250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000111240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000111110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000110280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000110310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x000112000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram] -force
  assign_bd_address -offset 0x000110240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000110200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x000116000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000111200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001112A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000111210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_sha] -force
  assign_bd_address -offset 0x000111220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x000112100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000111270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000110083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000110283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000111230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001112F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000111310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000111300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_xppu_npi_0] -force
  assign_bd_address -offset 0x000118800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_coresight_0] -force
  assign_bd_address -offset 0x000119260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_crp_0] -force
  assign_bd_address -offset 0x0001191E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001191F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001192D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001192B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001191C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001191D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000119250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000119240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000119110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000118280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000118310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x00011A000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram] -force
  assign_bd_address -offset 0x000118240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000118200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x00011E000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000119200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001192A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000119210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_sha] -force
  assign_bd_address -offset 0x000119220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x00011A100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000119270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000118083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000118283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000119230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001192F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000119310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000119300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_xppu_npi_0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs axi_noc_0/S01_AXI/C1_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs axi_noc_0/S01_AXI/C1_DDR_LOW1x2] -force
  assign_bd_address -offset 0x000100800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_0] -force
  assign_bd_address -offset 0x000100D10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_cti] -force
  assign_bd_address -offset 0x000100D00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_dbg] -force
  assign_bd_address -offset 0x000100D30000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_etm] -force
  assign_bd_address -offset 0x000100D20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_pmu] -force
  assign_bd_address -offset 0x000100D50000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_cti] -force
  assign_bd_address -offset 0x000100D40000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_dbg] -force
  assign_bd_address -offset 0x000100D70000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_etm] -force
  assign_bd_address -offset 0x000100D60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_pmu] -force
  assign_bd_address -offset 0x000100CA0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_cti] -force
  assign_bd_address -offset 0x000100C60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_ela] -force
  assign_bd_address -offset 0x000100C30000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_etf] -force
  assign_bd_address -offset 0x000100C20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_fun] -force
  assign_bd_address -offset 0x000100F80000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_atm] -force
  assign_bd_address -offset 0x000100FA0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_cti2a] -force
  assign_bd_address -offset 0x000100FD0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_cti2d] -force
  assign_bd_address -offset 0x000100F40000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2a] -force
  assign_bd_address -offset 0x000100F50000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2b] -force
  assign_bd_address -offset 0x000100F60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2c] -force
  assign_bd_address -offset 0x000100F70000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2d] -force
  assign_bd_address -offset 0x000100F20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_fun] -force
  assign_bd_address -offset 0x000100F00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_rom] -force
  assign_bd_address -offset 0x000100B80000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_fpd_atm] -force
  assign_bd_address -offset 0x000100B70000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_fpd_stm] -force
  assign_bd_address -offset 0x000100980000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_lpd_atm] -force
  assign_bd_address -offset 0x000101260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_crp_0] -force
  assign_bd_address -offset 0x0001011E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001011F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001012D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001012B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001011C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001011D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000101250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000101240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000101110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000101020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_gpio_0] -force
  assign_bd_address -offset 0x000100280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000100310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x000101030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_qspi_0] -force
  assign_bd_address -offset 0x000102000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram] -force
  assign_bd_address -offset 0x000100240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000100200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x000106000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000101200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001012A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000101050000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_sd_1] -force
  assign_bd_address -offset 0x000101210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_sha] -force
  assign_bd_address -offset 0x000101220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x000102100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000101270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000100083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000100283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000101230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001012F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000101310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000101300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_xppu_npi_0] -force
  assign_bd_address -offset 0x000108800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_coresight_0] -force
  assign_bd_address -offset 0x000109260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_crp_0] -force
  assign_bd_address -offset 0x0001091E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001091F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001092D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001092B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001091C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001091D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000109250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000109240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000109110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000108280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000108310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x00010A000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram] -force
  assign_bd_address -offset 0x000108240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000108200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x00010E000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000109200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001092A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000109210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_sha] -force
  assign_bd_address -offset 0x000109220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x00010A100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000109270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000108083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000108283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000109230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001092F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000109310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000109300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_xppu_npi_0] -force
  assign_bd_address -offset 0x000110800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_coresight_0] -force
  assign_bd_address -offset 0x000111260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_crp_0] -force
  assign_bd_address -offset 0x0001111E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001111F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001112D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001112B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001111C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001111D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000111250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000111240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000111110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000110280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000110310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x000112000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram] -force
  assign_bd_address -offset 0x000110240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000110200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x000116000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000111200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001112A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000111210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_sha] -force
  assign_bd_address -offset 0x000111220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x000112100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000111270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000110083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000110283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000111230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001112F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000111310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000111300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_xppu_npi_0] -force
  assign_bd_address -offset 0x000118800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_coresight_0] -force
  assign_bd_address -offset 0x000119260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_crp_0] -force
  assign_bd_address -offset 0x0001191E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001191F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001192D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001192B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001191C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001191D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000119250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000119240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000119110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000118280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000118310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x00011A000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram] -force
  assign_bd_address -offset 0x000118240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000118200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x00011E000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000119200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001192A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000119210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_sha] -force
  assign_bd_address -offset 0x000119220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x00011A100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000119270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000118083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000118283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000119230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001192F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000119310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000119300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_xppu_npi_0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_2] [get_bd_addr_segs axi_noc_0/S02_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_2] [get_bd_addr_segs axi_noc_0/S02_AXI/C2_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_3] [get_bd_addr_segs axi_noc_0/S03_AXI/C3_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_3] [get_bd_addr_segs axi_noc_0/S03_AXI/C3_DDR_LOW1x2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/LPD_AXI_NOC_0] [get_bd_addr_segs axi_noc_0/S04_AXI/C2_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces versal_cips_0/LPD_AXI_NOC_0] [get_bd_addr_segs axi_noc_0/S04_AXI/C2_DDR_LOW1x2] -force
  assign_bd_address -offset 0xA4000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0xA4010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs axi_gpio_1/S_AXI/Reg] -force
  assign_bd_address -offset 0xA4020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs axi_gpio_2/S_AXI/Reg] -force
  assign_bd_address -offset 0xA4030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs axi_gpio_3/S_AXI/Reg] -force
  assign_bd_address -offset 0xA4040000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/M_AXI_FPD] [get_bd_addr_segs axi_uartlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs axi_noc_0/S05_AXI/C3_DDR_LOW0x2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs axi_noc_0/S05_AXI/C3_DDR_LOW1x2] -force
  assign_bd_address -offset 0x000100800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_0] -force
  assign_bd_address -offset 0x000100D10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_cti] -force
  assign_bd_address -offset 0x000100D00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_dbg] -force
  assign_bd_address -offset 0x000100D30000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_etm] -force
  assign_bd_address -offset 0x000100D20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_pmu] -force
  assign_bd_address -offset 0x000100D50000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_cti] -force
  assign_bd_address -offset 0x000100D40000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_dbg] -force
  assign_bd_address -offset 0x000100D70000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_etm] -force
  assign_bd_address -offset 0x000100D60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_pmu] -force
  assign_bd_address -offset 0x000100CA0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_cti] -force
  assign_bd_address -offset 0x000100C60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_ela] -force
  assign_bd_address -offset 0x000100C30000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_etf] -force
  assign_bd_address -offset 0x000100C20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_fun] -force
  assign_bd_address -offset 0x000100F80000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_atm] -force
  assign_bd_address -offset 0x000100FA0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_cti2a] -force
  assign_bd_address -offset 0x000100FD0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_cti2d] -force
  assign_bd_address -offset 0x000100F40000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2a] -force
  assign_bd_address -offset 0x000100F50000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2b] -force
  assign_bd_address -offset 0x000100F60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2c] -force
  assign_bd_address -offset 0x000100F70000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2d] -force
  assign_bd_address -offset 0x000100F20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_fun] -force
  assign_bd_address -offset 0x000100F00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_rom] -force
  assign_bd_address -offset 0x000100B80000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_fpd_atm] -force
  assign_bd_address -offset 0x000100B70000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_fpd_stm] -force
  assign_bd_address -offset 0x000100980000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_lpd_atm] -force
  assign_bd_address -offset 0x000101260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_crp_0] -force
  assign_bd_address -offset 0x0001011E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001011F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001012D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001012B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001011C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001011D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000101250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000101240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000101110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000101020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_gpio_0] -force
  assign_bd_address -offset 0x000100280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000100310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x000101030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_qspi_0] -force
  assign_bd_address -offset 0x000102000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram] -force
  assign_bd_address -offset 0x000100240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000100200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x000106000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000101200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001012A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000101050000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_sd_1] -force
  assign_bd_address -offset 0x000101210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_sha] -force
  assign_bd_address -offset 0x000101220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x000102100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000101270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000100083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000100283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000101230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001012F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000101310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000101300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_xppu_npi_0] -force
  assign_bd_address -offset 0x000108800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_coresight_0] -force
  assign_bd_address -offset 0x000109260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_crp_0] -force
  assign_bd_address -offset 0x0001091E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001091F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001092D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001092B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001091C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001091D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000109250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000109240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000109110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000108280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000108310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x00010A000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram] -force
  assign_bd_address -offset 0x000108240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000108200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x00010E000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000109200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001092A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000109210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_sha] -force
  assign_bd_address -offset 0x000109220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x00010A100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000109270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000108083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000108283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000109230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001092F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000109310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000109300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_xppu_npi_0] -force
  assign_bd_address -offset 0x000110800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_coresight_0] -force
  assign_bd_address -offset 0x000111260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_crp_0] -force
  assign_bd_address -offset 0x0001111E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001111F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001112D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001112B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001111C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001111D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000111250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000111240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000111110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000110280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000110310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x000112000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram] -force
  assign_bd_address -offset 0x000110240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000110200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x000116000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000111200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001112A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000111210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_sha] -force
  assign_bd_address -offset 0x000111220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x000112100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000111270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000110083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000110283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000111230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001112F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000111310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000111300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_xppu_npi_0] -force
  assign_bd_address -offset 0x000118800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_coresight_0] -force
  assign_bd_address -offset 0x000119260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_crp_0] -force
  assign_bd_address -offset 0x0001191E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001191F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001192D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001192B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001191C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001191D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000119250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000119240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000119110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000118280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000118310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x00011A000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram] -force
  assign_bd_address -offset 0x000118240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000118200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x00011E000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000119200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001192A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000119210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_sha] -force
  assign_bd_address -offset 0x000119220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x00011A100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000119270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000118083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000118283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000119230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001192F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000119310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000119300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_xppu_npi_0] -force
  assign_bd_address -offset 0xFFA80000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_0] -force
  assign_bd_address -offset 0xFFA90000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_1] -force
  assign_bd_address -offset 0xFFAA0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_2] -force
  assign_bd_address -offset 0xFFAB0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_3] -force
  assign_bd_address -offset 0xFFAC0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_4] -force
  assign_bd_address -offset 0xFFAD0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_5] -force
  assign_bd_address -offset 0xFFAE0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_6] -force
  assign_bd_address -offset 0xFFAF0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_7] -force
  assign_bd_address -offset 0x000100800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_0] -force
  assign_bd_address -offset 0x000100D10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_cti] -force
  assign_bd_address -offset 0x000100D00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_dbg] -force
  assign_bd_address -offset 0x000100D30000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_etm] -force
  assign_bd_address -offset 0x000100D20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_pmu] -force
  assign_bd_address -offset 0x000100D50000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_cti] -force
  assign_bd_address -offset 0x000100D40000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_dbg] -force
  assign_bd_address -offset 0x000100D70000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_etm] -force
  assign_bd_address -offset 0x000100D60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_pmu] -force
  assign_bd_address -offset 0x000100CA0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_cti] -force
  assign_bd_address -offset 0x000100C60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_ela] -force
  assign_bd_address -offset 0x000100C30000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_etf] -force
  assign_bd_address -offset 0x000100C20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_fun] -force
  assign_bd_address -offset 0x000100F80000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_atm] -force
  assign_bd_address -offset 0x000100FA0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_cti2a] -force
  assign_bd_address -offset 0x000100FD0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_cti2d] -force
  assign_bd_address -offset 0x000100F40000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2a] -force
  assign_bd_address -offset 0x000100F50000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2b] -force
  assign_bd_address -offset 0x000100F60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2c] -force
  assign_bd_address -offset 0x000100F70000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2d] -force
  assign_bd_address -offset 0x000100F20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_fun] -force
  assign_bd_address -offset 0x000100F00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_rom] -force
  assign_bd_address -offset 0x000100B80000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_fpd_atm] -force
  assign_bd_address -offset 0x000100B70000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_fpd_stm] -force
  assign_bd_address -offset 0x000100980000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_lpd_atm] -force
  assign_bd_address -offset 0xFC000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_cpm] -force
  assign_bd_address -offset 0xFF5E0000 -range 0x00300000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_crl_0] -force
  assign_bd_address -offset 0x000101260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_crp_0] -force
  assign_bd_address -offset 0xFF0C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ethernet_0] -force
  assign_bd_address -offset 0xFF020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_i2c_0] -force
  assign_bd_address -offset 0xFF030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_i2c_1] -force
  assign_bd_address -offset 0xFF330000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_0] -force
  assign_bd_address -offset 0xFF340000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_1] -force
  assign_bd_address -offset 0xFF350000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_2] -force
  assign_bd_address -offset 0xFF360000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_3] -force
  assign_bd_address -offset 0xFF370000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_4] -force
  assign_bd_address -offset 0xFF380000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_5] -force
  assign_bd_address -offset 0xFF3A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_6] -force
  assign_bd_address -offset 0xFF320000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_pmc] -force
  assign_bd_address -offset 0xFF390000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_pmc_nobuf] -force
  assign_bd_address -offset 0xFF310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_psm] -force
  assign_bd_address -offset 0xFF9B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_afi_0] -force
  assign_bd_address -offset 0xFF0A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_iou_secure_slcr_0] -force
  assign_bd_address -offset 0xFF080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_iou_slcr_0] -force
  assign_bd_address -offset 0xFF410000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_slcr_0] -force
  assign_bd_address -offset 0xFF510000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_slcr_secure_0] -force
  assign_bd_address -offset 0xFF990000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_xppu_0] -force
  assign_bd_address -offset 0xFF960000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ocm_ctrl] -force
  assign_bd_address -offset 0xFFFC0000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ocm_ram_0] -force
  assign_bd_address -offset 0xFF980000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ocm_xmpu_0] -force
  assign_bd_address -offset 0x0001011E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001011F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001012D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001012B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001011C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001011D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000101250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000101240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000101110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000101020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_gpio_0] -force
  assign_bd_address -offset 0x000100280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000100310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x000101030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_qspi_0] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_qspi_ospi_flash_0] -force
  assign_bd_address -offset 0x000102000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram] -force
  assign_bd_address -offset 0x000100240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000100200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x000106000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000101200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001012A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000101050000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_sd_1] -force
  assign_bd_address -offset 0x000101210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_sha] -force
  assign_bd_address -offset 0x000101220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x000102100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000101270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000100083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000100283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000101230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001012F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000101310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000101300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_xppu_npi_0] -force
  assign_bd_address -offset 0xFFC90000 -range 0x0000F000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_psm_global_reg] -force
  assign_bd_address -offset 0xFFE90000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_r5_1_atcm_global] -force
  assign_bd_address -offset 0xFFEB0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_r5_1_btcm_global] -force
  assign_bd_address -offset 0xFFE00000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_r5_tcm_ram_global] -force
  assign_bd_address -offset 0xFF9A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_rpu_0] -force
  assign_bd_address -offset 0xFF000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_sbsauart_0] -force
  assign_bd_address -offset 0xFF130000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_scntr_0] -force
  assign_bd_address -offset 0xFF140000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_scntrs_0] -force
  assign_bd_address -offset 0xFF0E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_0] -force
  assign_bd_address -offset 0xFF0F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_1] -force
  assign_bd_address -offset 0xFF100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_2] -force
  assign_bd_address -offset 0xFF110000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_3] -force
  assign_bd_address -offset 0xFF9D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_usb_0] -force
  assign_bd_address -offset 0xFE200000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_usb_xhci_0] -force
  assign_bd_address -offset 0xFF120000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_wwdt_0] -force
  assign_bd_address -offset 0x000108800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_coresight_0] -force
  assign_bd_address -offset 0x000109260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_crp_0] -force
  assign_bd_address -offset 0x0001091E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001091F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001092D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001092B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001091C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001091D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000109250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000109240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000109110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000108280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000108310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x00010A000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram] -force
  assign_bd_address -offset 0x000108240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000108200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x00010E000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000109200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001092A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000109210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_sha] -force
  assign_bd_address -offset 0x000109220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x00010A100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000109270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000108083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000108283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000109230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001092F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000109310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000109300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_xppu_npi_0] -force
  assign_bd_address -offset 0x000110800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_coresight_0] -force
  assign_bd_address -offset 0x000111260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_crp_0] -force
  assign_bd_address -offset 0x0001111E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001111F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001112D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001112B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001111C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001111D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000111250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000111240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000111110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000110280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000110310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x000112000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram] -force
  assign_bd_address -offset 0x000110240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000110200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x000116000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000111200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001112A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000111210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_sha] -force
  assign_bd_address -offset 0x000111220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x000112100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000111270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000110083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000110283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000111230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001112F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000111310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000111300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_xppu_npi_0] -force
  assign_bd_address -offset 0x000118800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_coresight_0] -force
  assign_bd_address -offset 0x000119260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_crp_0] -force
  assign_bd_address -offset 0x0001191E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001191F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001192D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001192B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001191C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001191D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000119250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000119240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000119110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000118280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000118310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x00011A000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram] -force
  assign_bd_address -offset 0x000118240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000118200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x00011E000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000119200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001192A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000119210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_sha] -force
  assign_bd_address -offset 0x000119220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x00011A100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000119270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000118083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000118283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000119230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001192F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000119310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000119300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_xppu_npi_0] -force
  assign_bd_address -offset 0xFFA80000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_0] -force
  assign_bd_address -offset 0xFFA90000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_1] -force
  assign_bd_address -offset 0xFFAA0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_2] -force
  assign_bd_address -offset 0xFFAB0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_3] -force
  assign_bd_address -offset 0xFFAC0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_4] -force
  assign_bd_address -offset 0xFFAD0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_5] -force
  assign_bd_address -offset 0xFFAE0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_6] -force
  assign_bd_address -offset 0xFFAF0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_7] -force
  assign_bd_address -offset 0x000100800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_0] -force
  assign_bd_address -offset 0x000100D10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_cti] -force
  assign_bd_address -offset 0x000100D00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_dbg] -force
  assign_bd_address -offset 0x000100D30000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_etm] -force
  assign_bd_address -offset 0x000100D20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_pmu] -force
  assign_bd_address -offset 0x000100D50000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_cti] -force
  assign_bd_address -offset 0x000100D40000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_dbg] -force
  assign_bd_address -offset 0x000100D70000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_etm] -force
  assign_bd_address -offset 0x000100D60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_pmu] -force
  assign_bd_address -offset 0x000100CA0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_cti] -force
  assign_bd_address -offset 0x000100C60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_ela] -force
  assign_bd_address -offset 0x000100C30000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_etf] -force
  assign_bd_address -offset 0x000100C20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_fun] -force
  assign_bd_address -offset 0x000100F80000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_atm] -force
  assign_bd_address -offset 0x000100FA0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_cti2a] -force
  assign_bd_address -offset 0x000100FD0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_cti2d] -force
  assign_bd_address -offset 0x000100F40000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2a] -force
  assign_bd_address -offset 0x000100F50000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2b] -force
  assign_bd_address -offset 0x000100F60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2c] -force
  assign_bd_address -offset 0x000100F70000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2d] -force
  assign_bd_address -offset 0x000100F20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_fun] -force
  assign_bd_address -offset 0x000100F00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_rom] -force
  assign_bd_address -offset 0x000100B80000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_fpd_atm] -force
  assign_bd_address -offset 0x000100B70000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_fpd_stm] -force
  assign_bd_address -offset 0x000100980000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_lpd_atm] -force
  assign_bd_address -offset 0xFC000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_cpm] -force
  assign_bd_address -offset 0xFF5E0000 -range 0x00300000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_crl_0] -force
  assign_bd_address -offset 0x000101260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_crp_0] -force
  assign_bd_address -offset 0xFF0C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ethernet_0] -force
  assign_bd_address -offset 0xFF020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_i2c_0] -force
  assign_bd_address -offset 0xFF030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_i2c_1] -force
  assign_bd_address -offset 0xFF330000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_0] -force
  assign_bd_address -offset 0xFF340000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_1] -force
  assign_bd_address -offset 0xFF350000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_2] -force
  assign_bd_address -offset 0xFF360000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_3] -force
  assign_bd_address -offset 0xFF370000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_4] -force
  assign_bd_address -offset 0xFF380000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_5] -force
  assign_bd_address -offset 0xFF3A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_6] -force
  assign_bd_address -offset 0xFF320000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_pmc] -force
  assign_bd_address -offset 0xFF390000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_pmc_nobuf] -force
  assign_bd_address -offset 0xFF310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_psm] -force
  assign_bd_address -offset 0xFF9B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_afi_0] -force
  assign_bd_address -offset 0xFF0A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_iou_secure_slcr_0] -force
  assign_bd_address -offset 0xFF080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_iou_slcr_0] -force
  assign_bd_address -offset 0xFF410000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_slcr_0] -force
  assign_bd_address -offset 0xFF510000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_slcr_secure_0] -force
  assign_bd_address -offset 0xFF990000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_xppu_0] -force
  assign_bd_address -offset 0xFF960000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ocm_ctrl] -force
  assign_bd_address -offset 0xFFFC0000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ocm_ram_0] -force
  assign_bd_address -offset 0xFF980000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ocm_xmpu_0] -force
  assign_bd_address -offset 0x0001011E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001011F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001012D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001012B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001011C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001011D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000101250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000101240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000101110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000101020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_gpio_0] -force
  assign_bd_address -offset 0x000100280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000100310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x000101030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_qspi_0] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_qspi_ospi_flash_0] -force
  assign_bd_address -offset 0x000102000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram] -force
  assign_bd_address -offset 0x000100240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000100200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x000106000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000101200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001012A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000101050000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_sd_1] -force
  assign_bd_address -offset 0x000101210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_sha] -force
  assign_bd_address -offset 0x000101220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x000102100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000101270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000100083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000100283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000101230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001012F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000101310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000101300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_xppu_npi_0] -force
  assign_bd_address -offset 0xFFC90000 -range 0x0000F000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_psm_global_reg] -force
  assign_bd_address -offset 0xFFE90000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_r5_1_atcm_global] -force
  assign_bd_address -offset 0xFFEB0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_r5_1_btcm_global] -force
  assign_bd_address -offset 0xFFE00000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_r5_tcm_ram_global] -force
  assign_bd_address -offset 0xFF9A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_rpu_0] -force
  assign_bd_address -offset 0xFF000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_sbsauart_0] -force
  assign_bd_address -offset 0xFF130000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_scntr_0] -force
  assign_bd_address -offset 0xFF140000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_scntrs_0] -force
  assign_bd_address -offset 0xFF0E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_0] -force
  assign_bd_address -offset 0xFF0F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_1] -force
  assign_bd_address -offset 0xFF100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_2] -force
  assign_bd_address -offset 0xFF110000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_3] -force
  assign_bd_address -offset 0xFF9D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_usb_0] -force
  assign_bd_address -offset 0xFE200000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_usb_xhci_0] -force
  assign_bd_address -offset 0xFF120000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_wwdt_0] -force
  assign_bd_address -offset 0x000108800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_coresight_0] -force
  assign_bd_address -offset 0x000109260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_crp_0] -force
  assign_bd_address -offset 0x0001091E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001091F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001092D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001092B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001091C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001091D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000109250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000109240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000109110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000108280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000108310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x00010A000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram] -force
  assign_bd_address -offset 0x000108240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000108200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x00010E000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000109200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001092A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000109210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_sha] -force
  assign_bd_address -offset 0x000109220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x00010A100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000109270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000108083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000108283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000109230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001092F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000109310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000109300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_xppu_npi_0] -force
  assign_bd_address -offset 0x000110800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_coresight_0] -force
  assign_bd_address -offset 0x000111260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_crp_0] -force
  assign_bd_address -offset 0x0001111E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001111F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001112D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001112B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001111C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001111D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000111250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000111240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000111110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000110280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000110310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x000112000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram] -force
  assign_bd_address -offset 0x000110240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000110200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x000116000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000111200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001112A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000111210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_sha] -force
  assign_bd_address -offset 0x000111220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x000112100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000111270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000110083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000110283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000111230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001112F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000111310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000111300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_xppu_npi_0] -force
  assign_bd_address -offset 0x000118800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_coresight_0] -force
  assign_bd_address -offset 0x000119260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_crp_0] -force
  assign_bd_address -offset 0x0001191E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001191F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001192D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001192B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001191C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001191D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000119250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000119240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000119110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000118280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000118310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x00011A000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram] -force
  assign_bd_address -offset 0x000118240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000118200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x00011E000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000119200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001192A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000119210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_sha] -force
  assign_bd_address -offset 0x000119220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x00011A100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000119270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000118083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000118283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000119230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001192F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000119310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000119300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_xppu_npi_0] -force
  assign_bd_address -offset 0xFFA80000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_0] -force
  assign_bd_address -offset 0xFFA90000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_1] -force
  assign_bd_address -offset 0xFFAA0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_2] -force
  assign_bd_address -offset 0xFFAB0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_3] -force
  assign_bd_address -offset 0xFFAC0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_4] -force
  assign_bd_address -offset 0xFFAD0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_5] -force
  assign_bd_address -offset 0xFFAE0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_6] -force
  assign_bd_address -offset 0xFFAF0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_7] -force
  assign_bd_address -offset 0x000100800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_0] -force
  assign_bd_address -offset 0x000100D10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_cti] -force
  assign_bd_address -offset 0x000100D00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_dbg] -force
  assign_bd_address -offset 0x000100D30000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_etm] -force
  assign_bd_address -offset 0x000100D20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a720_pmu] -force
  assign_bd_address -offset 0x000100D50000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_cti] -force
  assign_bd_address -offset 0x000100D40000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_dbg] -force
  assign_bd_address -offset 0x000100D70000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_etm] -force
  assign_bd_address -offset 0x000100D60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_a721_pmu] -force
  assign_bd_address -offset 0x000100CA0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_cti] -force
  assign_bd_address -offset 0x000100C60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_ela] -force
  assign_bd_address -offset 0x000100C30000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_etf] -force
  assign_bd_address -offset 0x000100C20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_apu_fun] -force
  assign_bd_address -offset 0x000100F80000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_atm] -force
  assign_bd_address -offset 0x000100FA0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_cti2a] -force
  assign_bd_address -offset 0x000100FD0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_cti2d] -force
  assign_bd_address -offset 0x000100F40000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2a] -force
  assign_bd_address -offset 0x000100F50000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2b] -force
  assign_bd_address -offset 0x000100F60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2c] -force
  assign_bd_address -offset 0x000100F70000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_ela2d] -force
  assign_bd_address -offset 0x000100F20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_fun] -force
  assign_bd_address -offset 0x000100F00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_cpm_rom] -force
  assign_bd_address -offset 0x000100B80000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_fpd_atm] -force
  assign_bd_address -offset 0x000100B70000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_fpd_stm] -force
  assign_bd_address -offset 0x000100980000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_coresight_lpd_atm] -force
  assign_bd_address -offset 0xFC000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_cpm] -force
  assign_bd_address -offset 0xFF5E0000 -range 0x00300000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_crl_0] -force
  assign_bd_address -offset 0x000101260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_crp_0] -force
  assign_bd_address -offset 0xFF0C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ethernet_0] -force
  assign_bd_address -offset 0xFF020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_i2c_0] -force
  assign_bd_address -offset 0xFF030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_i2c_1] -force
  assign_bd_address -offset 0xFF330000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_0] -force
  assign_bd_address -offset 0xFF340000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_1] -force
  assign_bd_address -offset 0xFF350000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_2] -force
  assign_bd_address -offset 0xFF360000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_3] -force
  assign_bd_address -offset 0xFF370000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_4] -force
  assign_bd_address -offset 0xFF380000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_5] -force
  assign_bd_address -offset 0xFF3A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_6] -force
  assign_bd_address -offset 0xFF320000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_pmc] -force
  assign_bd_address -offset 0xFF390000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_pmc_nobuf] -force
  assign_bd_address -offset 0xFF310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_psm] -force
  assign_bd_address -offset 0xFF9B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_afi_0] -force
  assign_bd_address -offset 0xFF0A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_iou_secure_slcr_0] -force
  assign_bd_address -offset 0xFF080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_iou_slcr_0] -force
  assign_bd_address -offset 0xFF410000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_slcr_0] -force
  assign_bd_address -offset 0xFF510000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_slcr_secure_0] -force
  assign_bd_address -offset 0xFF990000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_xppu_0] -force
  assign_bd_address -offset 0xFF960000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ocm_ctrl] -force
  assign_bd_address -offset 0xFFFC0000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ocm_ram_0] -force
  assign_bd_address -offset 0xFF980000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ocm_xmpu_0] -force
  assign_bd_address -offset 0x0001011E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001011F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001012D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001012B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001011C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001011D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000101250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000101240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000101110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000101020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_gpio_0] -force
  assign_bd_address -offset 0x000100280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000100310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x000101030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_qspi_0] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_qspi_ospi_flash_0] -force
  assign_bd_address -offset 0x000102000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram] -force
  assign_bd_address -offset 0x000100240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000100200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x000106000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000101200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001012A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000101050000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_sd_1] -force
  assign_bd_address -offset 0x000101210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_sha] -force
  assign_bd_address -offset 0x000101220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x000102100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000101270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000100083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000100283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000101230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001012F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000101310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000101300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_xppu_npi_0] -force
  assign_bd_address -offset 0xFFC90000 -range 0x0000F000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_psm_global_reg] -force
  assign_bd_address -offset 0xFFE90000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_r5_1_atcm_global] -force
  assign_bd_address -offset 0xFFEB0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_r5_1_btcm_global] -force
  assign_bd_address -offset 0xFFE00000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_r5_tcm_ram_global] -force
  assign_bd_address -offset 0xFF9A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_rpu_0] -force
  assign_bd_address -offset 0xFF000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_sbsauart_0] -force
  assign_bd_address -offset 0xFF130000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_scntr_0] -force
  assign_bd_address -offset 0xFF140000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_scntrs_0] -force
  assign_bd_address -offset 0xFF0E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_0] -force
  assign_bd_address -offset 0xFF0F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_1] -force
  assign_bd_address -offset 0xFF100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_2] -force
  assign_bd_address -offset 0xFF110000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_3] -force
  assign_bd_address -offset 0xFF9D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_usb_0] -force
  assign_bd_address -offset 0xFE200000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_usb_xhci_0] -force
  assign_bd_address -offset 0xFF120000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_wwdt_0] -force
  assign_bd_address -offset 0x000108800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_coresight_0] -force
  assign_bd_address -offset 0x000109260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_crp_0] -force
  assign_bd_address -offset 0x0001091E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001091F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001092D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001092B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001091C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001091D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000109250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000109240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000109110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000108280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000108310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x00010A000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram] -force
  assign_bd_address -offset 0x000108240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000108200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x00010E000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000109200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001092A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000109210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_sha] -force
  assign_bd_address -offset 0x000109220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x00010A100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000109270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000108083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000108283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000109230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001092F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000109310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000109300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_1/pspmc_0_slv1_psv_pmc_xppu_npi_0] -force
  assign_bd_address -offset 0x000110800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_coresight_0] -force
  assign_bd_address -offset 0x000111260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_crp_0] -force
  assign_bd_address -offset 0x0001111E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001111F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001112D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001112B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001111C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001111D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000111250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000111240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000111110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000110280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000110310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x000112000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram] -force
  assign_bd_address -offset 0x000110240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000110200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x000116000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000111200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001112A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000111210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_sha] -force
  assign_bd_address -offset 0x000111220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x000112100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000111270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000110083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000110283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000111230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001112F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000111310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000111300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_2/pspmc_0_slv2_psv_pmc_xppu_npi_0] -force
  assign_bd_address -offset 0x000118800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_coresight_0] -force
  assign_bd_address -offset 0x000119260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_crp_0] -force
  assign_bd_address -offset 0x0001191E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_aes] -force
  assign_bd_address -offset 0x0001191F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_bbram_ctrl] -force
  assign_bd_address -offset 0x0001192D0000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_cfi_cframe_0] -force
  assign_bd_address -offset 0x0001192B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_cfu_apb_0] -force
  assign_bd_address -offset 0x0001191C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_dma_0] -force
  assign_bd_address -offset 0x0001191D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_dma_1] -force
  assign_bd_address -offset 0x000119250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_efuse_cache] -force
  assign_bd_address -offset 0x000119240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_efuse_ctrl] -force
  assign_bd_address -offset 0x000119110000 -range 0x00050000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_global_0] -force
  assign_bd_address -offset 0x000118280000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_iomodule_0] -force
  assign_bd_address -offset 0x000118310000 -range 0x00008000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ppu1_mdm_0] -force
  assign_bd_address -offset 0x00011A000000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram] -force
  assign_bd_address -offset 0x000118240000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram_data_cntlr] -force
  assign_bd_address -offset 0x000118200000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram_instr_cntlr] -force
  assign_bd_address -offset 0x00011E000000 -range 0x02000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_ram_npi] -force
  assign_bd_address -offset 0x000119200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_rsa] -force
  assign_bd_address -offset 0x0001192A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_rtc_0] -force
  assign_bd_address -offset 0x000119210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_sha] -force
  assign_bd_address -offset 0x000119220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_slave_boot] -force
  assign_bd_address -offset 0x00011A100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_slave_boot_stream] -force
  assign_bd_address -offset 0x000119270000 -range 0x00030000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_sysmon_0] -force
  assign_bd_address -offset 0x000118083000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_tmr_inject_0] -force
  assign_bd_address -offset 0x000118283000 -range 0x00001000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_tmr_manager_0] -force
  assign_bd_address -offset 0x000119230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_trng] -force
  assign_bd_address -offset 0x0001192F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_xmpu_0] -force
  assign_bd_address -offset 0x000119310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_xppu_0] -force
  assign_bd_address -offset 0x000119300000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_3/pspmc_0_slv3_psv_pmc_xppu_npi_0] -force

  # Exclude Address Segments
  exclude_bd_addr_seg -offset 0xFFA80000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_0]
  exclude_bd_addr_seg -offset 0xFFA90000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_1]
  exclude_bd_addr_seg -offset 0xFFAA0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_2]
  exclude_bd_addr_seg -offset 0xFFAB0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_3]
  exclude_bd_addr_seg -offset 0xFFAC0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_4]
  exclude_bd_addr_seg -offset 0xFFAD0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_5]
  exclude_bd_addr_seg -offset 0xFFAE0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_6]
  exclude_bd_addr_seg -offset 0xFFAF0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_7]
  exclude_bd_addr_seg -offset 0xFD5C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_apu_0]
  exclude_bd_addr_seg -offset 0xFC000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_cpm]
  exclude_bd_addr_seg -offset 0xFD1A0000 -range 0x00140000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_crf_0]
  exclude_bd_addr_seg -offset 0xFF5E0000 -range 0x00300000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_crl_0]
  exclude_bd_addr_seg -offset 0xFF0C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ethernet_0]
  exclude_bd_addr_seg -offset 0xFD360000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_afi_0]
  exclude_bd_addr_seg -offset 0xFD380000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_afi_2]
  exclude_bd_addr_seg -offset 0xFD5E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_cci_0]
  exclude_bd_addr_seg -offset 0xFD700000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_gpv_0]
  exclude_bd_addr_seg -offset 0xFD000000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_maincci_0]
  exclude_bd_addr_seg -offset 0xFD390000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_slave_xmpu_0]
  exclude_bd_addr_seg -offset 0xFD610000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_slcr_0]
  exclude_bd_addr_seg -offset 0xFD690000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_slcr_secure_0]
  exclude_bd_addr_seg -offset 0xFD5F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_smmu_0]
  exclude_bd_addr_seg -offset 0xFD800000 -range 0x00800000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_smmutcu_0]
  exclude_bd_addr_seg -offset 0xFF020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_i2c_0]
  exclude_bd_addr_seg -offset 0xFF030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_i2c_1]
  exclude_bd_addr_seg -offset 0xFF330000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_0]
  exclude_bd_addr_seg -offset 0xFF340000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_1]
  exclude_bd_addr_seg -offset 0xFF350000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_2]
  exclude_bd_addr_seg -offset 0xFF360000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_3]
  exclude_bd_addr_seg -offset 0xFF370000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_4]
  exclude_bd_addr_seg -offset 0xFF380000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_5]
  exclude_bd_addr_seg -offset 0xFF3A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_6]
  exclude_bd_addr_seg -offset 0xFF320000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_pmc]
  exclude_bd_addr_seg -offset 0xFF390000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_pmc_nobuf]
  exclude_bd_addr_seg -offset 0xFF310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_psm]
  exclude_bd_addr_seg -offset 0xFF9B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_afi_0]
  exclude_bd_addr_seg -offset 0xFF0A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_iou_secure_slcr_0]
  exclude_bd_addr_seg -offset 0xFF080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_iou_slcr_0]
  exclude_bd_addr_seg -offset 0xFF410000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_slcr_0]
  exclude_bd_addr_seg -offset 0xFF510000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_slcr_secure_0]
  exclude_bd_addr_seg -offset 0xFF990000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_xppu_0]
  exclude_bd_addr_seg -offset 0xFF960000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ocm_ctrl]
  exclude_bd_addr_seg -offset 0xFFFC0000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ocm_ram_0]
  exclude_bd_addr_seg -offset 0xFF980000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ocm_xmpu_0]
  exclude_bd_addr_seg -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_qspi_ospi_flash_0]
  exclude_bd_addr_seg -offset 0xFFC90000 -range 0x0000F000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_psm_global_reg]
  exclude_bd_addr_seg -offset 0xFFE90000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_r5_1_atcm_global]
  exclude_bd_addr_seg -offset 0xFFEB0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_r5_1_btcm_global]
  exclude_bd_addr_seg -offset 0xFFE00000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_r5_tcm_ram_global]
  exclude_bd_addr_seg -offset 0xFF9A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_rpu_0]
  exclude_bd_addr_seg -offset 0xFF000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_sbsauart_0]
  exclude_bd_addr_seg -offset 0xFF130000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_scntr_0]
  exclude_bd_addr_seg -offset 0xFF140000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_scntrs_0]
  exclude_bd_addr_seg -offset 0xFF0E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_0]
  exclude_bd_addr_seg -offset 0xFF0F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_1]
  exclude_bd_addr_seg -offset 0xFF100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_2]
  exclude_bd_addr_seg -offset 0xFF110000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_3]
  exclude_bd_addr_seg -offset 0xFF9D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_usb_0]
  exclude_bd_addr_seg -offset 0xFE200000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_usb_xhci_0]
  exclude_bd_addr_seg -offset 0xFF120000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_wwdt_0]
  exclude_bd_addr_seg -offset 0xFFA80000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_0]
  exclude_bd_addr_seg -offset 0xFFA90000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_1]
  exclude_bd_addr_seg -offset 0xFFAA0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_2]
  exclude_bd_addr_seg -offset 0xFFAB0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_3]
  exclude_bd_addr_seg -offset 0xFFAC0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_4]
  exclude_bd_addr_seg -offset 0xFFAD0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_5]
  exclude_bd_addr_seg -offset 0xFFAE0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_6]
  exclude_bd_addr_seg -offset 0xFFAF0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_7]
  exclude_bd_addr_seg -offset 0xFD5C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_apu_0]
  exclude_bd_addr_seg -offset 0xFC000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_cpm]
  exclude_bd_addr_seg -offset 0xFD1A0000 -range 0x00140000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_crf_0]
  exclude_bd_addr_seg -offset 0xFF5E0000 -range 0x00300000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_crl_0]
  exclude_bd_addr_seg -offset 0xFF0C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ethernet_0]
  exclude_bd_addr_seg -offset 0xFD360000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_afi_0]
  exclude_bd_addr_seg -offset 0xFD380000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_afi_2]
  exclude_bd_addr_seg -offset 0xFD5E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_cci_0]
  exclude_bd_addr_seg -offset 0xFD700000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_gpv_0]
  exclude_bd_addr_seg -offset 0xFD000000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_maincci_0]
  exclude_bd_addr_seg -offset 0xFD390000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_slave_xmpu_0]
  exclude_bd_addr_seg -offset 0xFD610000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_slcr_0]
  exclude_bd_addr_seg -offset 0xFD690000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_slcr_secure_0]
  exclude_bd_addr_seg -offset 0xFD5F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_smmu_0]
  exclude_bd_addr_seg -offset 0xFD800000 -range 0x00800000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_smmutcu_0]
  exclude_bd_addr_seg -offset 0xFF020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_i2c_0]
  exclude_bd_addr_seg -offset 0xFF030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_i2c_1]
  exclude_bd_addr_seg -offset 0xFF330000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_0]
  exclude_bd_addr_seg -offset 0xFF340000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_1]
  exclude_bd_addr_seg -offset 0xFF350000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_2]
  exclude_bd_addr_seg -offset 0xFF360000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_3]
  exclude_bd_addr_seg -offset 0xFF370000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_4]
  exclude_bd_addr_seg -offset 0xFF380000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_5]
  exclude_bd_addr_seg -offset 0xFF3A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_6]
  exclude_bd_addr_seg -offset 0xFF320000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_pmc]
  exclude_bd_addr_seg -offset 0xFF390000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_pmc_nobuf]
  exclude_bd_addr_seg -offset 0xFF310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_psm]
  exclude_bd_addr_seg -offset 0xFF9B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_afi_0]
  exclude_bd_addr_seg -offset 0xFF0A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_iou_secure_slcr_0]
  exclude_bd_addr_seg -offset 0xFF080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_iou_slcr_0]
  exclude_bd_addr_seg -offset 0xFF410000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_slcr_0]
  exclude_bd_addr_seg -offset 0xFF510000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_slcr_secure_0]
  exclude_bd_addr_seg -offset 0xFF990000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_xppu_0]
  exclude_bd_addr_seg -offset 0xFF960000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ocm_ctrl]
  exclude_bd_addr_seg -offset 0xFFFC0000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ocm_ram_0]
  exclude_bd_addr_seg -offset 0xFF980000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ocm_xmpu_0]
  exclude_bd_addr_seg -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_qspi_ospi_flash_0]
  exclude_bd_addr_seg -offset 0xFFC90000 -range 0x0000F000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_psm_global_reg]
  exclude_bd_addr_seg -offset 0xFFE90000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_r5_1_atcm_global]
  exclude_bd_addr_seg -offset 0xFFEB0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_r5_1_btcm_global]
  exclude_bd_addr_seg -offset 0xFFE00000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_r5_tcm_ram_global]
  exclude_bd_addr_seg -offset 0xFF9A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_rpu_0]
  exclude_bd_addr_seg -offset 0xFF000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_sbsauart_0]
  exclude_bd_addr_seg -offset 0xFF130000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_scntr_0]
  exclude_bd_addr_seg -offset 0xFF140000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_scntrs_0]
  exclude_bd_addr_seg -offset 0xFF0E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_0]
  exclude_bd_addr_seg -offset 0xFF0F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_1]
  exclude_bd_addr_seg -offset 0xFF100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_2]
  exclude_bd_addr_seg -offset 0xFF110000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_3]
  exclude_bd_addr_seg -offset 0xFF9D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_usb_0]
  exclude_bd_addr_seg -offset 0xFE200000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_usb_xhci_0]
  exclude_bd_addr_seg -offset 0xFF120000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_AXI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_wwdt_0]
  exclude_bd_addr_seg -offset 0xFFA80000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_0]
  exclude_bd_addr_seg -offset 0xFFA90000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_1]
  exclude_bd_addr_seg -offset 0xFFAA0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_2]
  exclude_bd_addr_seg -offset 0xFFAB0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_3]
  exclude_bd_addr_seg -offset 0xFFAC0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_4]
  exclude_bd_addr_seg -offset 0xFFAD0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_5]
  exclude_bd_addr_seg -offset 0xFFAE0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_6]
  exclude_bd_addr_seg -offset 0xFFAF0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_7]
  exclude_bd_addr_seg -offset 0xFD5C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_apu_0]
  exclude_bd_addr_seg -offset 0xFC000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_cpm]
  exclude_bd_addr_seg -offset 0xFD1A0000 -range 0x00140000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_crf_0]
  exclude_bd_addr_seg -offset 0xFF5E0000 -range 0x00300000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_crl_0]
  exclude_bd_addr_seg -offset 0xFF0C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ethernet_0]
  exclude_bd_addr_seg -offset 0xFD360000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_afi_0]
  exclude_bd_addr_seg -offset 0xFD380000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_afi_2]
  exclude_bd_addr_seg -offset 0xFD5E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_cci_0]
  exclude_bd_addr_seg -offset 0xFD700000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_gpv_0]
  exclude_bd_addr_seg -offset 0xFD000000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_maincci_0]
  exclude_bd_addr_seg -offset 0xFD390000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_slave_xmpu_0]
  exclude_bd_addr_seg -offset 0xFD610000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_slcr_0]
  exclude_bd_addr_seg -offset 0xFD690000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_slcr_secure_0]
  exclude_bd_addr_seg -offset 0xFD5F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_smmu_0]
  exclude_bd_addr_seg -offset 0xFD800000 -range 0x00800000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_smmutcu_0]
  exclude_bd_addr_seg -offset 0xFF020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_i2c_0]
  exclude_bd_addr_seg -offset 0xFF030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_i2c_1]
  exclude_bd_addr_seg -offset 0xFF330000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_0]
  exclude_bd_addr_seg -offset 0xFF340000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_1]
  exclude_bd_addr_seg -offset 0xFF350000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_2]
  exclude_bd_addr_seg -offset 0xFF360000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_3]
  exclude_bd_addr_seg -offset 0xFF370000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_4]
  exclude_bd_addr_seg -offset 0xFF380000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_5]
  exclude_bd_addr_seg -offset 0xFF3A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_6]
  exclude_bd_addr_seg -offset 0xFF320000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_pmc]
  exclude_bd_addr_seg -offset 0xFF390000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_pmc_nobuf]
  exclude_bd_addr_seg -offset 0xFF310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_psm]
  exclude_bd_addr_seg -offset 0xFF9B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_afi_0]
  exclude_bd_addr_seg -offset 0xFF0A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_iou_secure_slcr_0]
  exclude_bd_addr_seg -offset 0xFF080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_iou_slcr_0]
  exclude_bd_addr_seg -offset 0xFF410000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_slcr_0]
  exclude_bd_addr_seg -offset 0xFF510000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_slcr_secure_0]
  exclude_bd_addr_seg -offset 0xFF990000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_xppu_0]
  exclude_bd_addr_seg -offset 0xFF960000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ocm_ctrl]
  exclude_bd_addr_seg -offset 0xFFFC0000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ocm_ram_0]
  exclude_bd_addr_seg -offset 0xFF980000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ocm_xmpu_0]
  exclude_bd_addr_seg -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_qspi_ospi_flash_0]
  exclude_bd_addr_seg -offset 0xFFC90000 -range 0x0000F000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_psm_global_reg]
  exclude_bd_addr_seg -offset 0xFFE90000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_r5_1_atcm_global]
  exclude_bd_addr_seg -offset 0xFFEB0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_r5_1_btcm_global]
  exclude_bd_addr_seg -offset 0xFFE00000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_r5_tcm_ram_global]
  exclude_bd_addr_seg -offset 0xFF9A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_rpu_0]
  exclude_bd_addr_seg -offset 0xFF000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_sbsauart_0]
  exclude_bd_addr_seg -offset 0xFF130000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_scntr_0]
  exclude_bd_addr_seg -offset 0xFF140000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_scntrs_0]
  exclude_bd_addr_seg -offset 0xFF0E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_0]
  exclude_bd_addr_seg -offset 0xFF0F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_1]
  exclude_bd_addr_seg -offset 0xFF100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_2]
  exclude_bd_addr_seg -offset 0xFF110000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_3]
  exclude_bd_addr_seg -offset 0xFF9D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_usb_0]
  exclude_bd_addr_seg -offset 0xFE200000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_usb_xhci_0]
  exclude_bd_addr_seg -offset 0xFF120000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_wwdt_0]
  exclude_bd_addr_seg -offset 0xFFA80000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_0]
  exclude_bd_addr_seg -offset 0xFFA90000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_1]
  exclude_bd_addr_seg -offset 0xFFAA0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_2]
  exclude_bd_addr_seg -offset 0xFFAB0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_3]
  exclude_bd_addr_seg -offset 0xFFAC0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_4]
  exclude_bd_addr_seg -offset 0xFFAD0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_5]
  exclude_bd_addr_seg -offset 0xFFAE0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_6]
  exclude_bd_addr_seg -offset 0xFFAF0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_7]
  exclude_bd_addr_seg -offset 0xFD5C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_apu_0]
  exclude_bd_addr_seg -offset 0xFC000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_cpm]
  exclude_bd_addr_seg -offset 0xFD1A0000 -range 0x00140000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_crf_0]
  exclude_bd_addr_seg -offset 0xFF5E0000 -range 0x00300000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_crl_0]
  exclude_bd_addr_seg -offset 0xFF0C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ethernet_0]
  exclude_bd_addr_seg -offset 0xFD360000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_afi_0]
  exclude_bd_addr_seg -offset 0xFD380000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_afi_2]
  exclude_bd_addr_seg -offset 0xFD5E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_cci_0]
  exclude_bd_addr_seg -offset 0xFD700000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_gpv_0]
  exclude_bd_addr_seg -offset 0xFD000000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_maincci_0]
  exclude_bd_addr_seg -offset 0xFD390000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_slave_xmpu_0]
  exclude_bd_addr_seg -offset 0xFD610000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_slcr_0]
  exclude_bd_addr_seg -offset 0xFD690000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_slcr_secure_0]
  exclude_bd_addr_seg -offset 0xFD5F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_smmu_0]
  exclude_bd_addr_seg -offset 0xFD800000 -range 0x00800000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_smmutcu_0]
  exclude_bd_addr_seg -offset 0xFF020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_i2c_0]
  exclude_bd_addr_seg -offset 0xFF030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_i2c_1]
  exclude_bd_addr_seg -offset 0xFF330000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_0]
  exclude_bd_addr_seg -offset 0xFF340000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_1]
  exclude_bd_addr_seg -offset 0xFF350000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_2]
  exclude_bd_addr_seg -offset 0xFF360000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_3]
  exclude_bd_addr_seg -offset 0xFF370000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_4]
  exclude_bd_addr_seg -offset 0xFF380000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_5]
  exclude_bd_addr_seg -offset 0xFF3A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_6]
  exclude_bd_addr_seg -offset 0xFF320000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_pmc]
  exclude_bd_addr_seg -offset 0xFF390000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_pmc_nobuf]
  exclude_bd_addr_seg -offset 0xFF310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_psm]
  exclude_bd_addr_seg -offset 0xFF9B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_afi_0]
  exclude_bd_addr_seg -offset 0xFF0A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_iou_secure_slcr_0]
  exclude_bd_addr_seg -offset 0xFF080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_iou_slcr_0]
  exclude_bd_addr_seg -offset 0xFF410000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_slcr_0]
  exclude_bd_addr_seg -offset 0xFF510000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_slcr_secure_0]
  exclude_bd_addr_seg -offset 0xFF990000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_xppu_0]
  exclude_bd_addr_seg -offset 0xFF960000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ocm_ctrl]
  exclude_bd_addr_seg -offset 0xFFFC0000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ocm_ram_0]
  exclude_bd_addr_seg -offset 0xFF980000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ocm_xmpu_0]
  exclude_bd_addr_seg -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_qspi_ospi_flash_0]
  exclude_bd_addr_seg -offset 0xFFC90000 -range 0x0000F000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_psm_global_reg]
  exclude_bd_addr_seg -offset 0xFFE90000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_r5_1_atcm_global]
  exclude_bd_addr_seg -offset 0xFFEB0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_r5_1_btcm_global]
  exclude_bd_addr_seg -offset 0xFFE00000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_r5_tcm_ram_global]
  exclude_bd_addr_seg -offset 0xFF9A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_rpu_0]
  exclude_bd_addr_seg -offset 0xFF000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_sbsauart_0]
  exclude_bd_addr_seg -offset 0xFF130000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_scntr_0]
  exclude_bd_addr_seg -offset 0xFF140000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_scntrs_0]
  exclude_bd_addr_seg -offset 0xFF0E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_0]
  exclude_bd_addr_seg -offset 0xFF0F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_1]
  exclude_bd_addr_seg -offset 0xFF100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_2]
  exclude_bd_addr_seg -offset 0xFF110000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_3]
  exclude_bd_addr_seg -offset 0xFF9D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_usb_0]
  exclude_bd_addr_seg -offset 0xFE200000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_usb_xhci_0]
  exclude_bd_addr_seg -offset 0xFF120000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/FPD_CCI_NOC_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_wwdt_0]
  exclude_bd_addr_seg -offset 0xFFA80000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_0]
  exclude_bd_addr_seg -offset 0xFFA90000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_1]
  exclude_bd_addr_seg -offset 0xFFAA0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_2]
  exclude_bd_addr_seg -offset 0xFFAB0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_3]
  exclude_bd_addr_seg -offset 0xFFAC0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_4]
  exclude_bd_addr_seg -offset 0xFFAD0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_5]
  exclude_bd_addr_seg -offset 0xFFAE0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_6]
  exclude_bd_addr_seg -offset 0xFFAF0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_adma_7]
  exclude_bd_addr_seg -offset 0xFD5C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_apu_0]
  exclude_bd_addr_seg -offset 0xFC000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_cpm]
  exclude_bd_addr_seg -offset 0xFD1A0000 -range 0x00140000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_crf_0]
  exclude_bd_addr_seg -offset 0xFF5E0000 -range 0x00300000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_crl_0]
  exclude_bd_addr_seg -offset 0xFF0C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ethernet_0]
  exclude_bd_addr_seg -offset 0xFD360000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_afi_0]
  exclude_bd_addr_seg -offset 0xFD380000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_afi_2]
  exclude_bd_addr_seg -offset 0xFD5E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_cci_0]
  exclude_bd_addr_seg -offset 0xFD700000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_gpv_0]
  exclude_bd_addr_seg -offset 0xFD000000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_maincci_0]
  exclude_bd_addr_seg -offset 0xFD390000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_slave_xmpu_0]
  exclude_bd_addr_seg -offset 0xFD610000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_slcr_0]
  exclude_bd_addr_seg -offset 0xFD690000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_slcr_secure_0]
  exclude_bd_addr_seg -offset 0xFD5F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_smmu_0]
  exclude_bd_addr_seg -offset 0xFD800000 -range 0x00800000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_smmutcu_0]
  exclude_bd_addr_seg -offset 0xFF020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_i2c_0]
  exclude_bd_addr_seg -offset 0xFF030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_i2c_1]
  exclude_bd_addr_seg -offset 0xFF330000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_0]
  exclude_bd_addr_seg -offset 0xFF340000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_1]
  exclude_bd_addr_seg -offset 0xFF350000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_2]
  exclude_bd_addr_seg -offset 0xFF360000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_3]
  exclude_bd_addr_seg -offset 0xFF370000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_4]
  exclude_bd_addr_seg -offset 0xFF380000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_5]
  exclude_bd_addr_seg -offset 0xFF3A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_6]
  exclude_bd_addr_seg -offset 0xFF320000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_pmc]
  exclude_bd_addr_seg -offset 0xFF390000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_pmc_nobuf]
  exclude_bd_addr_seg -offset 0xFF310000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ipi_psm]
  exclude_bd_addr_seg -offset 0xFF9B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_afi_0]
  exclude_bd_addr_seg -offset 0xFF0A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_iou_secure_slcr_0]
  exclude_bd_addr_seg -offset 0xFF080000 -range 0x00020000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_iou_slcr_0]
  exclude_bd_addr_seg -offset 0xFF410000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_slcr_0]
  exclude_bd_addr_seg -offset 0xFF510000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_slcr_secure_0]
  exclude_bd_addr_seg -offset 0xFF990000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_lpd_xppu_0]
  exclude_bd_addr_seg -offset 0xFF960000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ocm_ctrl]
  exclude_bd_addr_seg -offset 0xFFFC0000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ocm_ram_0]
  exclude_bd_addr_seg -offset 0xFF980000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ocm_xmpu_0]
  exclude_bd_addr_seg -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_pmc_qspi_ospi_flash_0]
  exclude_bd_addr_seg -offset 0xFFC90000 -range 0x0000F000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_psm_global_reg]
  exclude_bd_addr_seg -offset 0xFFE90000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_r5_1_atcm_global]
  exclude_bd_addr_seg -offset 0xFFEB0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_r5_1_btcm_global]
  exclude_bd_addr_seg -offset 0xFFE00000 -range 0x00040000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_r5_tcm_ram_global]
  exclude_bd_addr_seg -offset 0xFF9A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_rpu_0]
  exclude_bd_addr_seg -offset 0xFF000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_sbsauart_0]
  exclude_bd_addr_seg -offset 0xFF130000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_scntr_0]
  exclude_bd_addr_seg -offset 0xFF140000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_scntrs_0]
  exclude_bd_addr_seg -offset 0xFF0E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_0]
  exclude_bd_addr_seg -offset 0xFF0F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_1]
  exclude_bd_addr_seg -offset 0xFF100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_2]
  exclude_bd_addr_seg -offset 0xFF110000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_ttc_3]
  exclude_bd_addr_seg -offset 0xFF9D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_usb_0]
  exclude_bd_addr_seg -offset 0xFE200000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_usb_xhci_0]
  exclude_bd_addr_seg -offset 0xFF120000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_0] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_wwdt_0]
  exclude_bd_addr_seg -offset 0xFD5C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_apu_0]
  exclude_bd_addr_seg -offset 0xFD1A0000 -range 0x00140000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_crf_0]
  exclude_bd_addr_seg -offset 0xFD360000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_afi_0]
  exclude_bd_addr_seg -offset 0xFD380000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_afi_2]
  exclude_bd_addr_seg -offset 0xFD5E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_cci_0]
  exclude_bd_addr_seg -offset 0xFD700000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_gpv_0]
  exclude_bd_addr_seg -offset 0xFD000000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_maincci_0]
  exclude_bd_addr_seg -offset 0xFD390000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_slave_xmpu_0]
  exclude_bd_addr_seg -offset 0xFD610000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_slcr_0]
  exclude_bd_addr_seg -offset 0xFD690000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_slcr_secure_0]
  exclude_bd_addr_seg -offset 0xFD5F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_smmu_0]
  exclude_bd_addr_seg -offset 0xFD800000 -range 0x00800000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_1] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_smmutcu_0]
  exclude_bd_addr_seg -offset 0xFD5C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_apu_0]
  exclude_bd_addr_seg -offset 0xFD1A0000 -range 0x00140000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_crf_0]
  exclude_bd_addr_seg -offset 0xFD360000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_afi_0]
  exclude_bd_addr_seg -offset 0xFD380000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_afi_2]
  exclude_bd_addr_seg -offset 0xFD5E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_cci_0]
  exclude_bd_addr_seg -offset 0xFD700000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_gpv_0]
  exclude_bd_addr_seg -offset 0xFD000000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_maincci_0]
  exclude_bd_addr_seg -offset 0xFD390000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_slave_xmpu_0]
  exclude_bd_addr_seg -offset 0xFD610000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_slcr_0]
  exclude_bd_addr_seg -offset 0xFD690000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_slcr_secure_0]
  exclude_bd_addr_seg -offset 0xFD5F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_smmu_0]
  exclude_bd_addr_seg -offset 0xFD800000 -range 0x00800000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_2] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_smmutcu_0]
  exclude_bd_addr_seg -offset 0xFD5C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_apu_0]
  exclude_bd_addr_seg -offset 0xFD1A0000 -range 0x00140000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_crf_0]
  exclude_bd_addr_seg -offset 0xFD360000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_afi_0]
  exclude_bd_addr_seg -offset 0xFD380000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_afi_2]
  exclude_bd_addr_seg -offset 0xFD5E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_cci_0]
  exclude_bd_addr_seg -offset 0xFD700000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_gpv_0]
  exclude_bd_addr_seg -offset 0xFD000000 -range 0x00100000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_maincci_0]
  exclude_bd_addr_seg -offset 0xFD390000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_slave_xmpu_0]
  exclude_bd_addr_seg -offset 0xFD610000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_slcr_0]
  exclude_bd_addr_seg -offset 0xFD690000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_slcr_secure_0]
  exclude_bd_addr_seg -offset 0xFD5F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_smmu_0]
  exclude_bd_addr_seg -offset 0xFD800000 -range 0x00800000 -target_address_space [get_bd_addr_spaces versal_cips_0/PMC_NOC_AXI_3] [get_bd_addr_segs versal_cips_0/NOC_PMC_AXI_0/pspmc_0_psv_fpd_smmutcu_0]


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


