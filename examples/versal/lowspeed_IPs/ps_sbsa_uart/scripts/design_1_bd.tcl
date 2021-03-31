
################################################################
/* # Copyright 2020 Xilinx Inc.
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
# limitations under the License. */
################################################################

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
set scripts_vivado_version 2020.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvc1902-vsva2197-2MP-e-S
   set_property BOARD_PART xilinx.com:vck190:part0:2.0 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name design_1

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
  set ddr4_dimm1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 ddr4_dimm1 ]

  set ddr4_dimm1_sma_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 ddr4_dimm1_sma_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200000000} \
   ] $ddr4_dimm1_sma_clk

  set iic_rtl [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_rtl ]


  # Create ports

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [ list \
   CONFIG.C_INTERRUPT_PRESENT {1} \
   CONFIG.C_IS_DUAL {1} \
 ] $axi_gpio_0

  # Create instance: axi_iic_0, and set properties
  set axi_iic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_0 ]

  # Create instance: axi_noc_0, and set properties
  set axi_noc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_0 ]
  set_property -dict [ list \
   CONFIG.CH0_DDR4_0_BOARD_INTERFACE {ddr4_dimm1} \
   CONFIG.LOGO_FILE {data/noc_mc.png} \
   CONFIG.MC0_CONFIG_NUM {config17} \
   CONFIG.MC1_CONFIG_NUM {config17} \
   CONFIG.MC2_CONFIG_NUM {config17} \
   CONFIG.MC3_CONFIG_NUM {config17} \
   CONFIG.MC_BOARD_INTRF_EN {true} \
   CONFIG.MC_CASLATENCY {22} \
   CONFIG.MC_CHAN_REGION1 {DDR_LOW1} \
   CONFIG.MC_CONFIG_NUM {config17} \
   CONFIG.MC_DDR4_2T {Disable} \
   CONFIG.MC_F1_LPDDR4_MR1 {0x0000} \
   CONFIG.MC_F1_LPDDR4_MR2 {0x0000} \
   CONFIG.MC_F1_LPDDR4_MR3 {0x0000} \
   CONFIG.MC_F1_LPDDR4_MR11 {0x0000} \
   CONFIG.MC_F1_LPDDR4_MR13 {0x0000} \
   CONFIG.MC_F1_LPDDR4_MR22 {0x0000} \
   CONFIG.MC_F1_TRCD {13750} \
   CONFIG.MC_F1_TRCDMIN {13750} \
   CONFIG.MC_INPUTCLK0_PERIOD {5000} \
   CONFIG.MC_INPUT_FREQUENCY0 {200.000} \
   CONFIG.MC_MEMORY_DEVICETYPE {UDIMMs} \
   CONFIG.MC_MEMORY_SPEEDGRADE {DDR4-3200AA(22-22-22)} \
   CONFIG.MC_TRC {45750} \
   CONFIG.MC_TRCD {13750} \
   CONFIG.MC_TRCDMIN {13750} \
   CONFIG.MC_TRCMIN {45750} \
   CONFIG.MC_TRP {13750} \
   CONFIG.MC_TRPMIN {13750} \
   CONFIG.NUM_CLKS {10} \
   CONFIG.NUM_MC {1} \
   CONFIG.NUM_MCP {4} \
   CONFIG.NUM_MI {0} \
   CONFIG.NUM_SI {8} \
   CONFIG.sys_clk0_BOARD_INTERFACE {ddr4_dimm1_sma_clk} \
 ] $axi_noc_0

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S00_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_1 { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S01_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_2 { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S02_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_3 { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S03_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.DEST_IDS {M00_AXI:0x40:M01_AXI:0x0} \
   CONFIG.CATEGORY {ps_nci} \
 ] [get_bd_intf_pins /axi_noc_0/S04_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_1 { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {ps_nci} \
 ] [get_bd_intf_pins /axi_noc_0/S05_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_2 { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {ps_rpu} \
 ] [get_bd_intf_pins /axi_noc_0/S06_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_3 { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} } \
   CONFIG.CATEGORY {ps_pmc} \
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
   CONFIG.ASSOCIATED_BUSIF {S06_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk5]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S05_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk6]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S07_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk7]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {} \
 ] [get_bd_pins /axi_noc_0/aclk8]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {} \
 ] [get_bd_pins /axi_noc_0/aclk9]

  # Create instance: axi_uartlite_0, and set properties
  set axi_uartlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {115200} \
   CONFIG.UARTLITE_BOARD_INTERFACE {Custom} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $axi_uartlite_0

  # Create instance: axi_uartlite_1, and set properties
  set axi_uartlite_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_1 ]

  # Create instance: axi_uartlite_2, and set properties
  set axi_uartlite_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_2 ]

  # Create instance: axis_ila_0, and set properties
  set axis_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_ila:1.1 axis_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_BRAM_CNT {4} \
   CONFIG.C_DATA_DEPTH {16384} \
   CONFIG.C_NUM_OF_PROBES {8} \
 ] $axis_ila_0

  # Create instance: can_0, and set properties
  set can_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:can:5.0 can_0 ]

  # Create instance: can_1, and set properties
  set can_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:can:5.0 can_1 ]

  # Create instance: can_2, and set properties
  set can_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:can:5.0 can_2 ]

  # Create instance: canfd_0, and set properties
  set canfd_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:canfd:3.0 canfd_0 ]
  set_property -dict [ list \
   CONFIG.C_EN_APB {0} \
 ] $canfd_0

  # Create instance: canfd_1, and set properties
  set canfd_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:canfd:3.0 canfd_1 ]
  set_property -dict [ list \
   CONFIG.C_EN_APB {0} \
 ] $canfd_1

  # Create instance: canfd_2, and set properties
  set canfd_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:canfd:3.0 canfd_2 ]
  set_property -dict [ list \
   CONFIG.C_EN_APB {0} \
 ] $canfd_2

  # Create instance: clk_wizard_0, and set properties
  set clk_wizard_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wizard:1.0 clk_wizard_0 ]
  set_property -dict [ list \
   CONFIG.CLKFBOUT_MULT {288.000000} \
   CONFIG.CLKOUT1_DIVIDE {120.000000} \
   CONFIG.CLKOUT2_DIVIDE {18.000000} \
   CONFIG.CLKOUT3_DIVIDE {36.000000} \
   CONFIG.CLKOUT_DRIVES {BUFG,BUFG,BUFG,BUFG,BUFG,BUFG,BUFG} \
   CONFIG.CLKOUT_DYN_PS {None,None,None,None,None,None,None} \
   CONFIG.CLKOUT_GROUPING {Auto,Auto,Auto,Auto,Auto,Auto,Auto} \
   CONFIG.CLKOUT_MATCHED_ROUTING {false,false,false,false,false,false,false} \
   CONFIG.CLKOUT_PORT {clk_out1,clk_out2,clk_out3,clk_out4,clk_out5,clk_out6,clk_out7} \
   CONFIG.CLKOUT_REQUESTED_DUTY_CYCLE {50.000,50.000,50.000,50.000,50.000,50.000,50.000} \
   CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY {24,160,80,100.000,100.000,100.000,100.000} \
   CONFIG.CLKOUT_REQUESTED_PHASE {0.000,0.000,0.000,0.000,0.000,0.000,0.000} \
   CONFIG.CLKOUT_USED {true,true,true,false,false,false,false} \
   CONFIG.DIVCLK_DIVIDE {25} \
 ] $clk_wizard_0

  # Create instance: rst_versal_cips_0_249M, and set properties
  set rst_versal_cips_0_249M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_versal_cips_0_249M ]

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {11} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_0

  # Create instance: util_reduced_logic_0, and set properties
  set util_reduced_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {2} \
 ] $util_reduced_logic_0

  # Create instance: util_reduced_logic_1, and set properties
  set util_reduced_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_1 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {2} \
 ] $util_reduced_logic_1

  # Create instance: util_reduced_logic_2, and set properties
  set util_reduced_logic_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 util_reduced_logic_2 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {2} \
 ] $util_reduced_logic_2

  # Create instance: versal_cips_0, and set properties
  set versal_cips_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:versal_cips:2.1 versal_cips_0 ]
  set_property -dict [ list \
   CONFIG.CPM_AUX0_REF_CTRL_ACT_FREQMHZ {899.999939} \
   CONFIG.CPM_AUX1_REF_CTRL_ACT_FREQMHZ {899.999939} \
   CONFIG.CPM_CORE_REF_CTRL_ACT_FREQMHZ {899.999939} \
   CONFIG.CPM_DBG_REF_CTRL_ACT_FREQMHZ {299.999969} \
   CONFIG.CPM_DMA_CREDIT_INIT_DEMUX {0} \
   CONFIG.CPM_LSBUS_REF_CTRL_ACT_FREQMHZ {149.999985} \
   CONFIG.CPM_PCIE0_PF0_SUB_CLASS_INTF_MENU {Other_memory_controller} \
   CONFIG.CPM_PCIE0_PF0_USE_CLASS_CODE_LOOKUP_ASSISTANT {0} \
   CONFIG.CPM_PCIE0_PF1_BASE_CLASS_VALUE {05} \
   CONFIG.CPM_PCIE0_PF1_INTERFACE_VALUE {00} \
   CONFIG.CPM_PCIE0_PF1_SUB_CLASS_INTF_MENU {Other_memory_controller} \
   CONFIG.CPM_PCIE0_PF1_SUB_CLASS_VALUE {80} \
   CONFIG.CPM_PCIE0_PF1_USE_CLASS_CODE_LOOKUP_ASSISTANT {1} \
   CONFIG.CPM_PCIE0_PF2_BASE_CLASS_VALUE {05} \
   CONFIG.CPM_PCIE0_PF2_INTERFACE_VALUE {00} \
   CONFIG.CPM_PCIE0_PF2_SUB_CLASS_INTF_MENU {Other_memory_controller} \
   CONFIG.CPM_PCIE0_PF2_SUB_CLASS_VALUE {80} \
   CONFIG.CPM_PCIE0_PF2_USE_CLASS_CODE_LOOKUP_ASSISTANT {1} \
   CONFIG.CPM_PCIE0_PF3_BASE_CLASS_VALUE {05} \
   CONFIG.CPM_PCIE0_PF3_INTERFACE_VALUE {00} \
   CONFIG.CPM_PCIE0_PF3_SUB_CLASS_INTF_MENU {Other_memory_controller} \
   CONFIG.CPM_PCIE0_PF3_SUB_CLASS_VALUE {80} \
   CONFIG.CPM_PCIE0_PF3_USE_CLASS_CODE_LOOKUP_ASSISTANT {1} \
   CONFIG.CPM_PCIE1_PF0_CLASS_CODE {0} \
   CONFIG.CPM_PCIE1_PF0_SUB_CLASS_INTF_MENU {Other_memory_controller} \
   CONFIG.CPM_PCIE1_PF0_USE_CLASS_CODE_LOOKUP_ASSISTANT {0} \
   CONFIG.CPM_PCIE1_PF1_BASE_CLASS_VALUE {05} \
   CONFIG.CPM_PCIE1_PF1_INTERFACE_VALUE {00} \
   CONFIG.CPM_PCIE1_PF1_SUB_CLASS_INTF_MENU {Other_memory_controller} \
   CONFIG.CPM_PCIE1_PF1_SUB_CLASS_VALUE {80} \
   CONFIG.CPM_PCIE1_PF1_USE_CLASS_CODE_LOOKUP_ASSISTANT {1} \
   CONFIG.CPM_PCIE1_PF2_BASE_CLASS_VALUE {05} \
   CONFIG.CPM_PCIE1_PF2_INTERFACE_VALUE {00} \
   CONFIG.CPM_PCIE1_PF2_SUB_CLASS_INTF_MENU {Other_memory_controller} \
   CONFIG.CPM_PCIE1_PF2_SUB_CLASS_VALUE {80} \
   CONFIG.CPM_PCIE1_PF2_USE_CLASS_CODE_LOOKUP_ASSISTANT {1} \
   CONFIG.CPM_PCIE1_PF3_BASE_CLASS_VALUE {05} \
   CONFIG.CPM_PCIE1_PF3_INTERFACE_VALUE {00} \
   CONFIG.CPM_PCIE1_PF3_SUB_CLASS_INTF_MENU {Other_memory_controller} \
   CONFIG.CPM_PCIE1_PF3_SUB_CLASS_VALUE {80} \
   CONFIG.CPM_PCIE1_PF3_USE_CLASS_CODE_LOOKUP_ASSISTANT {1} \
   CONFIG.PMC_CRP_CFU_REF_CTRL_ACT_FREQMHZ {394.444427} \
   CONFIG.PMC_CRP_HSM0_REF_CTRL_ACT_FREQMHZ {32.870369} \
   CONFIG.PMC_CRP_HSM1_REF_CTRL_ACT_FREQMHZ {131.481476} \
   CONFIG.PMC_CRP_I2C_REF_CTRL_ACT_FREQMHZ {99.999992} \
   CONFIG.PMC_CRP_I2C_REF_CTRL_DIVISOR0 {10} \
   CONFIG.PMC_CRP_I2C_REF_CTRL_SRCSEL {NPLL} \
   CONFIG.PMC_CRP_LSBUS_REF_CTRL_ACT_FREQMHZ {147.916656} \
   CONFIG.PMC_CRP_NOC_REF_CTRL_ACT_FREQMHZ {999.999939} \
   CONFIG.PMC_CRP_NPI_REF_CTRL_ACT_FREQMHZ {295.833313} \
   CONFIG.PMC_CRP_PL0_REF_CTRL_ACT_FREQMHZ {249.999985} \
   CONFIG.PMC_CRP_PL0_REF_CTRL_DIVISOR0 {4} \
   CONFIG.PMC_CRP_PL0_REF_CTRL_FREQMHZ {250} \
   CONFIG.PMC_CRP_PPLL_CTRL_FBDIV {71} \
   CONFIG.PMC_CRP_QSPI_REF_CTRL_ACT_FREQMHZ {295.833313} \
   CONFIG.PMC_CRP_SDIO1_REF_CTRL_ACT_FREQMHZ {199.999985} \
   CONFIG.PMC_CRP_SDIO1_REF_CTRL_DIVISOR0 {5} \
   CONFIG.PMC_CRP_SDIO1_REF_CTRL_SRCSEL {NPLL} \
   CONFIG.PMC_CRP_SD_DLL_REF_CTRL_ACT_FREQMHZ {1183.333252} \
   CONFIG.PMC_CRP_SYSMON_REF_CTRL_ACT_FREQMHZ {295.833313} \
   CONFIG.PMC_CRP_SYSMON_REF_CTRL_FREQMHZ {295.833313} \
   CONFIG.PMC_GPIO0_MIO_PERIPHERAL_ENABLE {1} \
   CONFIG.PMC_GPIO1_MIO_PERIPHERAL_ENABLE {1} \
   CONFIG.PMC_I2CPMC_PERIPHERAL_ENABLE {1} \
   CONFIG.PMC_I2CPMC_PERIPHERAL_IO {PMC_MIO 46 .. 47} \
   CONFIG.PMC_MIO_0_DIRECTION {out} \
   CONFIG.PMC_MIO_0_SCHMITT {1} \
   CONFIG.PMC_MIO_10_DIRECTION {inout} \
   CONFIG.PMC_MIO_11_DIRECTION {inout} \
   CONFIG.PMC_MIO_12_DIRECTION {out} \
   CONFIG.PMC_MIO_12_SCHMITT {1} \
   CONFIG.PMC_MIO_13_DIRECTION {out} \
   CONFIG.PMC_MIO_13_SCHMITT {1} \
   CONFIG.PMC_MIO_14_DIRECTION {inout} \
   CONFIG.PMC_MIO_15_DIRECTION {inout} \
   CONFIG.PMC_MIO_16_DIRECTION {inout} \
   CONFIG.PMC_MIO_17_DIRECTION {inout} \
   CONFIG.PMC_MIO_19_DIRECTION {inout} \
   CONFIG.PMC_MIO_1_DIRECTION {inout} \
   CONFIG.PMC_MIO_20_DIRECTION {inout} \
   CONFIG.PMC_MIO_21_DIRECTION {inout} \
   CONFIG.PMC_MIO_22_DIRECTION {inout} \
   CONFIG.PMC_MIO_24_DIRECTION {out} \
   CONFIG.PMC_MIO_24_SCHMITT {1} \
   CONFIG.PMC_MIO_26_DIRECTION {inout} \
   CONFIG.PMC_MIO_27_DIRECTION {inout} \
   CONFIG.PMC_MIO_29_DIRECTION {inout} \
   CONFIG.PMC_MIO_2_DIRECTION {inout} \
   CONFIG.PMC_MIO_30_DIRECTION {inout} \
   CONFIG.PMC_MIO_31_DIRECTION {inout} \
   CONFIG.PMC_MIO_32_DIRECTION {inout} \
   CONFIG.PMC_MIO_33_DIRECTION {inout} \
   CONFIG.PMC_MIO_34_DIRECTION {inout} \
   CONFIG.PMC_MIO_35_DIRECTION {inout} \
   CONFIG.PMC_MIO_36_DIRECTION {inout} \
   CONFIG.PMC_MIO_37_DIRECTION {out} \
   CONFIG.PMC_MIO_37_OUTPUT_DATA {high} \
   CONFIG.PMC_MIO_37_USAGE {GPIO} \
   CONFIG.PMC_MIO_3_DIRECTION {inout} \
   CONFIG.PMC_MIO_40_DIRECTION {out} \
   CONFIG.PMC_MIO_40_SCHMITT {0} \
   CONFIG.PMC_MIO_43_DIRECTION {out} \
   CONFIG.PMC_MIO_43_SCHMITT {1} \
   CONFIG.PMC_MIO_44_DIRECTION {inout} \
   CONFIG.PMC_MIO_45_DIRECTION {inout} \
   CONFIG.PMC_MIO_46_DIRECTION {inout} \
   CONFIG.PMC_MIO_47_DIRECTION {inout} \
   CONFIG.PMC_MIO_4_DIRECTION {inout} \
   CONFIG.PMC_MIO_51_DIRECTION {out} \
   CONFIG.PMC_MIO_51_SCHMITT {1} \
   CONFIG.PMC_MIO_5_DIRECTION {out} \
   CONFIG.PMC_MIO_5_SCHMITT {1} \
   CONFIG.PMC_MIO_6_DIRECTION {out} \
   CONFIG.PMC_MIO_6_SCHMITT {1} \
   CONFIG.PMC_MIO_7_DIRECTION {out} \
   CONFIG.PMC_MIO_7_SCHMITT {1} \
   CONFIG.PMC_MIO_8_DIRECTION {inout} \
   CONFIG.PMC_MIO_9_DIRECTION {inout} \
   CONFIG.PMC_MIO_TREE_PERIPHERALS { \
     0#Enet 0 \
     0#Enet 0 \
     0#Enet 0 \
     0#Enet 0 \
     0#Enet 0 \
     0#Enet 0 \
     0#Enet 0 \
     0#SD1/eMMC1#SD1/eMMC1#SD1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#GPIO 1#####UART \
     0#UART 0#I2C \
     0#USB 0#USB \
     0#USB 0#USB \
     0#USB 0#USB \
     0#USB 0#USB \
     0#USB 0#USB \
     0#USB 0#USB \
     1#Enet 1#Enet \
     1#Enet 1#Enet \
     1#Enet 1#Enet \
     1#Enet 1#Enet \
     1#Enet 1#Enet \
     1#Enet 1#Enet \
     1#I2C 1#i2c_pmc#i2c_pmc####SD1/eMMC1#Enet \
     QSPI#QSPI#QSPI#QSPI#QSPI#QSPI#Loopback Clk#QSPI#QSPI#QSPI#QSPI#QSPI#QSPI#USB \
   } \
   CONFIG.PMC_MIO_TREE_SIGNALS {qspi0_clk#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]#qspi0_io[0]#qspi0_cs_b#qspi_lpbk#qspi1_cs_b#qspi1_io[0]#qspi1_io[1]#qspi1_io[2]#qspi1_io[3]#qspi1_clk#usb2phy_reset#ulpi_tx_data[0]#ulpi_tx_data[1]#ulpi_tx_data[2]#ulpi_tx_data[3]#ulpi_clk#ulpi_tx_data[4]#ulpi_tx_data[5]#ulpi_tx_data[6]#ulpi_tx_data[7]#ulpi_dir#ulpi_stp#ulpi_nxt#clk#dir1/data[7]#detect#cmd#data[0]#data[1]#data[2]#data[3]#sel/data[4]#dir_cmd/data[5]#dir0/data[6]#gpio_1_pin[37]#####rxd#txd#scl#sda#scl#sda####buspwr/rst#rgmii_tx_clk#rgmii_txd[0]#rgmii_txd[1]#rgmii_txd[2]#rgmii_txd[3]#rgmii_tx_ctl#rgmii_rx_clk#rgmii_rxd[0]#rgmii_rxd[1]#rgmii_rxd[2]#rgmii_rxd[3]#rgmii_rx_ctl#rgmii_tx_clk#rgmii_txd[0]#rgmii_txd[1]#rgmii_txd[2]#rgmii_txd[3]#rgmii_tx_ctl#rgmii_rx_clk#rgmii_rxd[0]#rgmii_rxd[1]#rgmii_rxd[2]#rgmii_rxd[3]#rgmii_rx_ctl#gem0_mdc#gem0_mdio} \
   CONFIG.PMC_QSPI_GRP_FBCLK_ENABLE {1} \
   CONFIG.PMC_QSPI_PERIPHERAL_DATA_MODE {x4} \
   CONFIG.PMC_QSPI_PERIPHERAL_ENABLE {1} \
   CONFIG.PMC_QSPI_PERIPHERAL_MODE {Dual Parallel} \
   CONFIG.PMC_REF_CLK_FREQMHZ {33.333333} \
   CONFIG.PMC_SD1_DATA_TRANSFER_MODE {8Bit} \
   CONFIG.PMC_SD1_GRP_CD_ENABLE {1} \
   CONFIG.PMC_SD1_GRP_CD_IO {PMC_MIO 28} \
   CONFIG.PMC_SD1_GRP_POW_ENABLE {1} \
   CONFIG.PMC_SD1_GRP_POW_IO {PMC_MIO 51} \
   CONFIG.PMC_SD1_PERIPHERAL_ENABLE {1} \
   CONFIG.PMC_SD1_PERIPHERAL_IO {PMC_MIO 26 .. 36} \
   CONFIG.PMC_SD1_SLOT_TYPE {SD 3.0} \
   CONFIG.PMC_SD1_SPEED_MODE {high speed} \
   CONFIG.PMC_USE_PMC_NOC_AXI0 {1} \
   CONFIG.PS_BOARD_INTERFACE {cips_fixed_io} \
   CONFIG.PS_CAN0_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_CAN0_PERIPHERAL_IO {EMIO} \
   CONFIG.PS_CAN1_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_CAN1_PERIPHERAL_IO {EMIO} \
   CONFIG.PS_CRF_ACPU_CTRL_ACT_FREQMHZ {1350.000000} \
   CONFIG.PS_CRF_DBG_FPD_CTRL_ACT_FREQMHZ {394.444427} \
   CONFIG.PS_CRF_FPD_LSBUS_CTRL_ACT_FREQMHZ {150.000000} \
   CONFIG.PS_CRF_FPD_LSBUS_CTRL_DIVISOR0 {9} \
   CONFIG.PS_CRF_FPD_LSBUS_CTRL_SRCSEL {APLL} \
   CONFIG.PS_CRF_FPD_TOP_SWITCH_CTRL_ACT_FREQMHZ {775.000000} \
   CONFIG.PS_CRL_CAN0_REF_CTRL_ACT_FREQMHZ {99.999992} \
   CONFIG.PS_CRL_CAN0_REF_CTRL_DIVISOR0 {10} \
   CONFIG.PS_CRL_CAN0_REF_CTRL_SRCSEL {NPLL} \
   CONFIG.PS_CRL_CAN1_REF_CTRL_ACT_FREQMHZ {99.999992} \
   CONFIG.PS_CRL_CAN1_REF_CTRL_DIVISOR0 {10} \
   CONFIG.PS_CRL_CAN1_REF_CTRL_SRCSEL {NPLL} \
   CONFIG.PS_CRL_CPM_TOPSW_REF_CTRL_ACT_FREQMHZ {775.000000} \
   CONFIG.PS_CRL_CPM_TOPSW_REF_CTRL_FREQMHZ {775} \
   CONFIG.PS_CRL_CPU_R5_CTRL_ACT_FREQMHZ {591.666626} \
   CONFIG.PS_CRL_DBG_LPD_CTRL_ACT_FREQMHZ {394.444427} \
   CONFIG.PS_CRL_DBG_TSTMP_CTRL_ACT_FREQMHZ {394.444427} \
   CONFIG.PS_CRL_GEM0_REF_CTRL_ACT_FREQMHZ {124.999992} \
   CONFIG.PS_CRL_GEM0_REF_CTRL_DIVISOR0 {8} \
   CONFIG.PS_CRL_GEM1_REF_CTRL_ACT_FREQMHZ {124.999992} \
   CONFIG.PS_CRL_GEM1_REF_CTRL_DIVISOR0 {8} \
   CONFIG.PS_CRL_GEM_TSU_REF_CTRL_ACT_FREQMHZ {249.999985} \
   CONFIG.PS_CRL_GEM_TSU_REF_CTRL_DIVISOR0 {4} \
   CONFIG.PS_CRL_I2C1_REF_CTRL_ACT_FREQMHZ {99.999992} \
   CONFIG.PS_CRL_I2C1_REF_CTRL_DIVISOR0 {10} \
   CONFIG.PS_CRL_I2C1_REF_CTRL_SRCSEL {NPLL} \
   CONFIG.PS_CRL_IOU_SWITCH_CTRL_ACT_FREQMHZ {249.999985} \
   CONFIG.PS_CRL_LPD_LSBUS_CTRL_ACT_FREQMHZ {147.916656} \
   CONFIG.PS_CRL_LPD_LSBUS_CTRL_DIVISOR0 {8} \
   CONFIG.PS_CRL_LPD_LSBUS_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRL_LPD_TOP_SWITCH_CTRL_ACT_FREQMHZ {591.666626} \
   CONFIG.PS_CRL_PSM_REF_CTRL_ACT_FREQMHZ {394.444427} \
   CONFIG.PS_CRL_RPLL_CTRL_FBDIV {93} \
   CONFIG.PS_CRL_SPI0_REF_CTRL_ACT_FREQMHZ {199.999985} \
   CONFIG.PS_CRL_SPI0_REF_CTRL_DIVISOR0 {5} \
   CONFIG.PS_CRL_SPI0_REF_CTRL_SRCSEL {NPLL} \
   CONFIG.PS_CRL_SPI1_REF_CTRL_ACT_FREQMHZ {199.999985} \
   CONFIG.PS_CRL_SPI1_REF_CTRL_DIVISOR0 {5} \
   CONFIG.PS_CRL_SPI1_REF_CTRL_SRCSEL {NPLL} \
   CONFIG.PS_CRL_TIMESTAMP_REF_CTRL_ACT_FREQMHZ {99.999992} \
   CONFIG.PS_CRL_TIMESTAMP_REF_CTRL_DIVISOR0 {10} \
   CONFIG.PS_CRL_TIMESTAMP_REF_CTRL_SRCSEL {NPLL} \
   CONFIG.PS_CRL_UART0_REF_CTRL_ACT_FREQMHZ {99.999992} \
   CONFIG.PS_CRL_UART0_REF_CTRL_DIVISOR0 {10} \
   CONFIG.PS_CRL_UART0_REF_CTRL_SRCSEL {NPLL} \
   CONFIG.PS_CRL_UART1_REF_CTRL_ACT_FREQMHZ {99.999992} \
   CONFIG.PS_CRL_UART1_REF_CTRL_DIVISOR0 {10} \
   CONFIG.PS_CRL_UART1_REF_CTRL_SRCSEL {NPLL} \
   CONFIG.PS_CRL_USB0_BUS_REF_CTRL_ACT_FREQMHZ {19.999998} \
   CONFIG.PS_CRL_USB0_BUS_REF_CTRL_DIVISOR0 {50} \
   CONFIG.PS_CRL_USB0_BUS_REF_CTRL_SRCSEL {NPLL} \
   CONFIG.PS_CRL_USB3_DUAL_REF_CTRL_FREQMHZ {100} \
   CONFIG.PS_ENET0_GRP_MDIO_ENABLE {1} \
   CONFIG.PS_ENET0_GRP_MDIO_IO {PS_MIO 24 .. 25} \
   CONFIG.PS_ENET0_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_ENET0_PERIPHERAL_IO {PS_MIO 0 .. 11} \
   CONFIG.PS_ENET1_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_ENET1_PERIPHERAL_IO {PS_MIO 12 .. 23} \
   CONFIG.PS_GEN_IPI_0_ENABLE {1} \
   CONFIG.PS_GEN_IPI_1_ENABLE {1} \
   CONFIG.PS_GEN_IPI_2_ENABLE {1} \
   CONFIG.PS_GEN_IPI_3_ENABLE {1} \
   CONFIG.PS_GEN_IPI_4_ENABLE {1} \
   CONFIG.PS_GEN_IPI_5_ENABLE {1} \
   CONFIG.PS_GEN_IPI_6_ENABLE {1} \
   CONFIG.PS_I2C1_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_I2C1_PERIPHERAL_IO {PMC_MIO 44 .. 45} \
   CONFIG.PS_MIO_0_DIRECTION {out} \
   CONFIG.PS_MIO_0_SCHMITT {1} \
   CONFIG.PS_MIO_12_DIRECTION {out} \
   CONFIG.PS_MIO_12_SCHMITT {1} \
   CONFIG.PS_MIO_13_DIRECTION {out} \
   CONFIG.PS_MIO_13_SCHMITT {1} \
   CONFIG.PS_MIO_14_DIRECTION {out} \
   CONFIG.PS_MIO_14_SCHMITT {1} \
   CONFIG.PS_MIO_15_DIRECTION {out} \
   CONFIG.PS_MIO_15_SCHMITT {1} \
   CONFIG.PS_MIO_16_DIRECTION {out} \
   CONFIG.PS_MIO_16_SCHMITT {1} \
   CONFIG.PS_MIO_17_DIRECTION {out} \
   CONFIG.PS_MIO_17_SCHMITT {1} \
   CONFIG.PS_MIO_19_PULL {disable} \
   CONFIG.PS_MIO_1_DIRECTION {out} \
   CONFIG.PS_MIO_1_SCHMITT {1} \
   CONFIG.PS_MIO_21_PULL {disable} \
   CONFIG.PS_MIO_24_DIRECTION {out} \
   CONFIG.PS_MIO_24_SCHMITT {1} \
   CONFIG.PS_MIO_25_DIRECTION {inout} \
   CONFIG.PS_MIO_2_DIRECTION {out} \
   CONFIG.PS_MIO_2_SCHMITT {1} \
   CONFIG.PS_MIO_3_DIRECTION {out} \
   CONFIG.PS_MIO_3_SCHMITT {1} \
   CONFIG.PS_MIO_4_DIRECTION {out} \
   CONFIG.PS_MIO_4_SCHMITT {1} \
   CONFIG.PS_MIO_5_DIRECTION {out} \
   CONFIG.PS_MIO_5_SCHMITT {1} \
   CONFIG.PS_MIO_7_PULL {disable} \
   CONFIG.PS_MIO_9_PULL {disable} \
   CONFIG.PS_NUM_FABRIC_RESETS {1} \
   CONFIG.PS_PCIE_RESET_ENABLE {1} \
   CONFIG.PS_PMC_CONFIG_APPLIED {1} \
   CONFIG.PS_SPI0_GRP_SS0_ENABLE {1} \
   CONFIG.PS_SPI0_GRP_SS0_IO {EMIO} \
   CONFIG.PS_SPI0_GRP_SS1_ENABLE {1} \
   CONFIG.PS_SPI0_GRP_SS1_IO {EMIO} \
   CONFIG.PS_SPI0_GRP_SS2_ENABLE {1} \
   CONFIG.PS_SPI0_GRP_SS2_IO {EMIO} \
   CONFIG.PS_SPI0_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_SPI0_PERIPHERAL_IO {EMIO} \
   CONFIG.PS_SPI1_GRP_SS0_ENABLE {1} \
   CONFIG.PS_SPI1_GRP_SS0_IO {EMIO} \
   CONFIG.PS_SPI1_GRP_SS1_ENABLE {1} \
   CONFIG.PS_SPI1_GRP_SS1_IO {EMIO} \
   CONFIG.PS_SPI1_GRP_SS2_ENABLE {1} \
   CONFIG.PS_SPI1_GRP_SS2_IO {EMIO} \
   CONFIG.PS_SPI1_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_SPI1_PERIPHERAL_IO {EMIO} \
   CONFIG.PS_UART0_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_UART0_PERIPHERAL_IO {PMC_MIO 42 .. 43} \
   CONFIG.PS_UART1_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_UART1_PERIPHERAL_IO {EMIO} \
   CONFIG.PS_USB3_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_USE_IRQ_0 {1} \
   CONFIG.PS_USE_IRQ_1 {1} \
   CONFIG.PS_USE_IRQ_2 {1} \
   CONFIG.PS_USE_IRQ_3 {1} \
   CONFIG.PS_USE_IRQ_4 {1} \
   CONFIG.PS_USE_IRQ_5 {1} \
   CONFIG.PS_USE_IRQ_6 {1} \
   CONFIG.PS_USE_IRQ_7 {1} \
   CONFIG.PS_USE_IRQ_8 {1} \
   CONFIG.PS_USE_IRQ_9 {1} \
   CONFIG.PS_USE_IRQ_10 {1} \
   CONFIG.PS_USE_M_AXI_GP0 {1} \
   CONFIG.PS_USE_PMCPL_CLK0 {1} \
   CONFIG.PS_USE_PS_NOC_CCI {1} \
   CONFIG.PS_USE_PS_NOC_NCI_0 {1} \
   CONFIG.PS_USE_PS_NOC_NCI_1 {1} \
   CONFIG.PS_USE_PS_NOC_RPU_0 {1} \
 ] $versal_cips_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {2} \
 ] $xlconcat_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {1} \
 ] $xlconcat_1

  # Create instance: xlconcat_2, and set properties
  set xlconcat_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_2 ]

  # Create instance: xlconcat_3, and set properties
  set xlconcat_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_3 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {1} \
 ] $xlconcat_3

  # Create instance: xlconcat_5, and set properties
  set xlconcat_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_5 ]

  # Create instance: xlconcat_6, and set properties
  set xlconcat_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_6 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {1} \
 ] $xlconcat_6

  # Create instance: xlconcat_7, and set properties
  set xlconcat_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_7 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {1} \
 ] $xlconcat_7

  # Create instance: xlconcat_8, and set properties
  set xlconcat_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_8 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {1} \
 ] $xlconcat_8

  # Create instance: xlconcat_9, and set properties
  set xlconcat_9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_9 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {1} \
 ] $xlconcat_9

  # Create interface connections
  connect_bd_intf_net -intf_net axi_iic_0_IIC [get_bd_intf_ports iic_rtl] [get_bd_intf_pins axi_iic_0/IIC]
  connect_bd_intf_net -intf_net axi_noc_0_CH0_DDR4_0 [get_bd_intf_ports ddr4_dimm1] [get_bd_intf_pins axi_noc_0/CH0_DDR4_0]
  connect_bd_intf_net -intf_net ddr4_dimm1_sma_clk_1 [get_bd_intf_ports ddr4_dimm1_sma_clk] [get_bd_intf_pins axi_noc_0/sys_clk0]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins axi_iic_0/S_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins can_0/CAN_S_AXI_LITE] [get_bd_intf_pins smartconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI [get_bd_intf_pins can_1/CAN_S_AXI_LITE] [get_bd_intf_pins smartconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M03_AXI [get_bd_intf_pins can_2/CAN_S_AXI_LITE] [get_bd_intf_pins smartconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M04_AXI [get_bd_intf_pins canfd_1/CAN_S_AXI_LITE] [get_bd_intf_pins smartconnect_0/M04_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M05_AXI [get_bd_intf_pins canfd_2/CAN_S_AXI_LITE] [get_bd_intf_pins smartconnect_0/M05_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M06_AXI [get_bd_intf_pins canfd_0/CAN_S_AXI_LITE] [get_bd_intf_pins smartconnect_0/M06_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M07_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins smartconnect_0/M07_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M08_AXI [get_bd_intf_pins axi_uartlite_0/S_AXI] [get_bd_intf_pins smartconnect_0/M08_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M09_AXI [get_bd_intf_pins axi_uartlite_1/S_AXI] [get_bd_intf_pins smartconnect_0/M09_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M10_AXI [get_bd_intf_pins axi_uartlite_2/S_AXI] [get_bd_intf_pins smartconnect_0/M10_AXI]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_AXI_NOC_0 [get_bd_intf_pins axi_noc_0/S04_AXI] [get_bd_intf_pins versal_cips_0/FPD_AXI_NOC_0]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_AXI_NOC_1 [get_bd_intf_pins axi_noc_0/S05_AXI] [get_bd_intf_pins versal_cips_0/FPD_AXI_NOC_1]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_0 [get_bd_intf_pins axi_noc_0/S00_AXI] [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_0]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_1 [get_bd_intf_pins axi_noc_0/S01_AXI] [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_1]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_2 [get_bd_intf_pins axi_noc_0/S02_AXI] [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_2]
  connect_bd_intf_net -intf_net versal_cips_0_FPD_CCI_NOC_3 [get_bd_intf_pins axi_noc_0/S03_AXI] [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_3]
  connect_bd_intf_net -intf_net versal_cips_0_M_AXI_FPD [get_bd_intf_pins smartconnect_0/S00_AXI] [get_bd_intf_pins versal_cips_0/M_AXI_FPD]
  connect_bd_intf_net -intf_net versal_cips_0_NOC_LPD_AXI_0 [get_bd_intf_pins axi_noc_0/S06_AXI] [get_bd_intf_pins versal_cips_0/NOC_LPD_AXI_0]
  connect_bd_intf_net -intf_net versal_cips_0_PMC_NOC_AXI_0 [get_bd_intf_pins axi_noc_0/S07_AXI] [get_bd_intf_pins versal_cips_0/PMC_NOC_AXI_0]

  # Create port connections
  connect_bd_net -net Net [get_bd_pins axi_noc_0/aclk9] [get_bd_pins axis_ila_0/clk] [get_bd_pins can_0/can_clk] [get_bd_pins can_1/can_clk] [get_bd_pins can_2/can_clk] [get_bd_pins clk_wizard_0/clk_out1]
  connect_bd_net -net Net1 [get_bd_pins canfd_1/can_phy_rx] [get_bd_pins canfd_2/can_phy_rx] [get_bd_pins util_reduced_logic_2/Res]
  connect_bd_net -net axi_gpio_0_gpio2_io_o [get_bd_pins axi_gpio_0/gpio2_io_o] [get_bd_pins axi_gpio_0/gpio_io_i]
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_pins axi_gpio_0/gpio2_io_i] [get_bd_pins axi_gpio_0/gpio_io_o]
  connect_bd_net -net axi_gpio_0_ip2intc_irpt [get_bd_pins axi_gpio_0/ip2intc_irpt] [get_bd_pins versal_cips_0/pl_ps_irq7]
  connect_bd_net -net axi_iic_0_iic2intc_irpt [get_bd_pins axi_iic_0/iic2intc_irpt] [get_bd_pins versal_cips_0/pl_ps_irq0]
  connect_bd_net -net axi_uartlite_0_interrupt [get_bd_pins axi_uartlite_0/interrupt] [get_bd_pins versal_cips_0/pl_ps_irq8]
  connect_bd_net -net axi_uartlite_0_tx [get_bd_pins axi_uartlite_0/tx] [get_bd_pins xlconcat_9/In0]
  connect_bd_net -net axi_uartlite_1_interrupt [get_bd_pins axi_uartlite_1/interrupt] [get_bd_pins versal_cips_0/pl_ps_irq9]
  connect_bd_net -net axi_uartlite_1_tx [get_bd_pins axi_uartlite_1/tx] [get_bd_pins xlconcat_7/In0]
  connect_bd_net -net axi_uartlite_2_interrupt [get_bd_pins axi_uartlite_2/interrupt] [get_bd_pins versal_cips_0/pl_ps_irq10]
  connect_bd_net -net axi_uartlite_2_tx [get_bd_pins axi_uartlite_2/tx] [get_bd_pins xlconcat_6/In0]
  connect_bd_net -net can_0_can_phy_tx [get_bd_pins can_0/can_phy_tx] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net can_0_ip2bus_intrevent [get_bd_pins can_0/ip2bus_intrevent] [get_bd_pins versal_cips_0/pl_ps_irq1]
  connect_bd_net -net can_1_can_phy_tx [get_bd_pins can_1/can_phy_tx] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net can_1_ip2bus_intrevent [get_bd_pins can_1/ip2bus_intrevent] [get_bd_pins versal_cips_0/pl_ps_irq2]
  connect_bd_net -net can_2_can_phy_tx [get_bd_pins can_2/can_phy_tx] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net can_2_ip2bus_intrevent [get_bd_pins can_2/ip2bus_intrevent] [get_bd_pins versal_cips_0/pl_ps_irq3]
  connect_bd_net -net canfd_0_can_phy_tx [get_bd_pins canfd_0/can_phy_tx] [get_bd_pins xlconcat_3/In0]
  connect_bd_net -net canfd_0_ip2bus_intrevent [get_bd_pins canfd_0/ip2bus_intrevent] [get_bd_pins versal_cips_0/pl_ps_irq6]
  connect_bd_net -net canfd_1_can_phy_tx [get_bd_pins canfd_1/can_phy_tx] [get_bd_pins xlconcat_2/In1]
  connect_bd_net -net canfd_1_ip2bus_intrevent [get_bd_pins canfd_1/ip2bus_intrevent] [get_bd_pins versal_cips_0/pl_ps_irq5]
  connect_bd_net -net canfd_2_can_phy_tx [get_bd_pins canfd_2/can_phy_tx] [get_bd_pins xlconcat_2/In0]
  connect_bd_net -net canfd_2_ip2bus_intrevent [get_bd_pins canfd_2/ip2bus_intrevent] [get_bd_pins versal_cips_0/pl_ps_irq4]
  connect_bd_net -net clk_wizard_0_clk_out2 [get_bd_pins canfd_0/can_clk_x2] [get_bd_pins canfd_1/can_clk_x2] [get_bd_pins canfd_2/can_clk_x2] [get_bd_pins clk_wizard_0/clk_out2]
  connect_bd_net -net clk_wizard_0_clk_out3 [get_bd_pins canfd_0/can_clk] [get_bd_pins canfd_1/can_clk] [get_bd_pins canfd_2/can_clk] [get_bd_pins clk_wizard_0/clk_out3]
  connect_bd_net -net rst_versal_cips_0_249M_interconnect_aresetn [get_bd_pins rst_versal_cips_0_249M/interconnect_aresetn] [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net rst_versal_cips_0_249M_peripheral_aresetn [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_iic_0/s_axi_aresetn] [get_bd_pins axi_uartlite_0/s_axi_aresetn] [get_bd_pins axi_uartlite_1/s_axi_aresetn] [get_bd_pins axi_uartlite_2/s_axi_aresetn] [get_bd_pins can_0/s_axi_aresetn] [get_bd_pins can_1/s_axi_aresetn] [get_bd_pins can_2/s_axi_aresetn] [get_bd_pins canfd_0/s_axi_aresetn] [get_bd_pins canfd_1/s_axi_aresetn] [get_bd_pins canfd_2/s_axi_aresetn] [get_bd_pins rst_versal_cips_0_249M/peripheral_aresetn]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins util_reduced_logic_0/Res] [get_bd_pins versal_cips_0/canfd0_phy_rx] [get_bd_pins versal_cips_0/canfd1_phy_rx]
  connect_bd_net -net util_reduced_logic_1_Res [get_bd_pins can_1/can_phy_rx] [get_bd_pins can_2/can_phy_rx] [get_bd_pins util_reduced_logic_1/Res]
  connect_bd_net -net versal_cips_0_canfd0_phy_tx [get_bd_pins versal_cips_0/canfd0_phy_tx] [get_bd_pins xlconcat_5/In0]
  connect_bd_net -net versal_cips_0_canfd1_phy_tx [get_bd_pins versal_cips_0/canfd1_phy_tx] [get_bd_pins xlconcat_5/In1]
  connect_bd_net -net versal_cips_0_fpd_axi_noc_axi0_clk [get_bd_pins axi_noc_0/aclk4] [get_bd_pins versal_cips_0/fpd_axi_noc_axi0_clk]
  connect_bd_net -net versal_cips_0_fpd_axi_noc_axi1_clk [get_bd_pins axi_noc_0/aclk6] [get_bd_pins versal_cips_0/fpd_axi_noc_axi1_clk]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi0_clk [get_bd_pins axi_noc_0/aclk0] [get_bd_pins versal_cips_0/fpd_cci_noc_axi0_clk]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi1_clk [get_bd_pins axi_noc_0/aclk1] [get_bd_pins versal_cips_0/fpd_cci_noc_axi1_clk]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi2_clk [get_bd_pins axi_noc_0/aclk2] [get_bd_pins versal_cips_0/fpd_cci_noc_axi2_clk]
  connect_bd_net -net versal_cips_0_fpd_cci_noc_axi3_clk [get_bd_pins axi_noc_0/aclk3] [get_bd_pins versal_cips_0/fpd_cci_noc_axi3_clk]
  connect_bd_net -net versal_cips_0_lpd_axi_noc_clk [get_bd_pins axi_noc_0/aclk5] [get_bd_pins versal_cips_0/lpd_axi_noc_clk]
  connect_bd_net -net versal_cips_0_pl0_ref_clk [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_iic_0/s_axi_aclk] [get_bd_pins axi_noc_0/aclk8] [get_bd_pins axi_uartlite_0/s_axi_aclk] [get_bd_pins axi_uartlite_1/s_axi_aclk] [get_bd_pins axi_uartlite_2/s_axi_aclk] [get_bd_pins can_0/s_axi_aclk] [get_bd_pins can_1/s_axi_aclk] [get_bd_pins can_2/s_axi_aclk] [get_bd_pins canfd_0/s_axi_aclk] [get_bd_pins canfd_1/s_axi_aclk] [get_bd_pins canfd_2/s_axi_aclk] [get_bd_pins clk_wizard_0/clk_in1] [get_bd_pins rst_versal_cips_0_249M/slowest_sync_clk] [get_bd_pins smartconnect_0/aclk] [get_bd_pins versal_cips_0/m_axi_fpd_aclk] [get_bd_pins versal_cips_0/pl0_ref_clk]
  connect_bd_net -net versal_cips_0_pl0_resetn [get_bd_pins rst_versal_cips_0_249M/ext_reset_in] [get_bd_pins versal_cips_0/pl0_resetn]
  connect_bd_net -net versal_cips_0_pmc_axi_noc_axi0_clk [get_bd_pins axi_noc_0/aclk7] [get_bd_pins versal_cips_0/pmc_axi_noc_axi0_clk]
  connect_bd_net -net versal_cips_0_spi0_m_o [get_bd_pins axis_ila_0/probe2] [get_bd_pins versal_cips_0/spi0_m_o] [get_bd_pins versal_cips_0/spi1_s_i]
  connect_bd_net -net versal_cips_0_spi0_s_o [get_bd_pins axis_ila_0/probe6] [get_bd_pins versal_cips_0/spi0_s_o] [get_bd_pins versal_cips_0/spi1_m_i]
  connect_bd_net -net versal_cips_0_spi0_sclk_o [get_bd_pins axis_ila_0/probe0] [get_bd_pins versal_cips_0/spi0_sclk_o] [get_bd_pins versal_cips_0/spi1_sclk_i]
  connect_bd_net -net versal_cips_0_spi0_ss_o_n [get_bd_pins axis_ila_0/probe4] [get_bd_pins versal_cips_0/spi0_ss_o_n] [get_bd_pins versal_cips_0/spi1_ss_i_n]
  connect_bd_net -net versal_cips_0_spi1_m_o [get_bd_pins axis_ila_0/probe3] [get_bd_pins versal_cips_0/spi0_s_i] [get_bd_pins versal_cips_0/spi1_m_o]
  connect_bd_net -net versal_cips_0_spi1_s_o [get_bd_pins axis_ila_0/probe1] [get_bd_pins versal_cips_0/spi0_m_i] [get_bd_pins versal_cips_0/spi1_s_o]
  connect_bd_net -net versal_cips_0_spi1_sclk_o [get_bd_pins axis_ila_0/probe7] [get_bd_pins versal_cips_0/spi0_sclk_i] [get_bd_pins versal_cips_0/spi1_sclk_o]
  connect_bd_net -net versal_cips_0_spi1_ss_o_n [get_bd_pins axis_ila_0/probe5] [get_bd_pins versal_cips_0/spi0_ss_i_n] [get_bd_pins versal_cips_0/spi1_ss_o_n]
  connect_bd_net -net versal_cips_0_uart1_txd [get_bd_pins versal_cips_0/uart1_txd] [get_bd_pins xlconcat_8/In0]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins util_reduced_logic_1/Op1] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins can_0/can_phy_rx] [get_bd_pins xlconcat_1/dout]
  connect_bd_net -net xlconcat_2_dout [get_bd_pins util_reduced_logic_2/Op1] [get_bd_pins xlconcat_2/dout]
  connect_bd_net -net xlconcat_3_dout [get_bd_pins canfd_0/can_phy_rx] [get_bd_pins xlconcat_3/dout]
  connect_bd_net -net xlconcat_5_dout [get_bd_pins util_reduced_logic_0/Op1] [get_bd_pins xlconcat_5/dout]
  connect_bd_net -net xlconcat_6_dout [get_bd_pins axi_uartlite_1/rx] [get_bd_pins xlconcat_6/dout]
  connect_bd_net -net xlconcat_7_dout [get_bd_pins axi_uartlite_2/rx] [get_bd_pins xlconcat_7/dout]
  connect_bd_net -net xlconcat_8_dout [get_bd_pins axi_uartlite_0/rx] [get_bd_pins xlconcat_8/dout]
  connect_bd_net -net xlconcat_9_dout [get_bd_pins versal_cips_0/uart1_rxd] [get_bd_pins xlconcat_9/dout]

  # Create address segments
  assign_bd_address -offset 0x0404A0000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/Data1] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0xA4000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/Data1] [get_bd_addr_segs axi_iic_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_NCI0] [get_bd_addr_segs axi_noc_0/S04_AXI/C0_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs axi_noc_0/S00_AXI/C0_DDR_LOW0] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_NCI0] [get_bd_addr_segs axi_noc_0/S04_AXI/C0_DDR_LOW1] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI0] [get_bd_addr_segs axi_noc_0/S00_AXI/C0_DDR_LOW1] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_NCI1] [get_bd_addr_segs axi_noc_0/S05_AXI/C1_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs axi_noc_0/S01_AXI/C1_DDR_LOW0] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI1] [get_bd_addr_segs axi_noc_0/S01_AXI/C1_DDR_LOW1] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_NCI1] [get_bd_addr_segs axi_noc_0/S05_AXI/C1_DDR_LOW1] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_RPU0] [get_bd_addr_segs axi_noc_0/S06_AXI/C2_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI2] [get_bd_addr_segs axi_noc_0/S02_AXI/C2_DDR_LOW0] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_RPU0] [get_bd_addr_segs axi_noc_0/S06_AXI/C2_DDR_LOW1] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI2] [get_bd_addr_segs axi_noc_0/S02_AXI/C2_DDR_LOW1] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI3] [get_bd_addr_segs axi_noc_0/S03_AXI/C3_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_PMC] [get_bd_addr_segs axi_noc_0/S07_AXI/C3_DDR_LOW0] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_CCI3] [get_bd_addr_segs axi_noc_0/S03_AXI/C3_DDR_LOW1] -force
  assign_bd_address -offset 0x000800000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces versal_cips_0/DATA_PMC] [get_bd_addr_segs axi_noc_0/S07_AXI/C3_DDR_LOW1] -force
  assign_bd_address -offset 0xA4070000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/Data1] [get_bd_addr_segs axi_uartlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0xA4080000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/Data1] [get_bd_addr_segs axi_uartlite_1/S_AXI/Reg] -force
  assign_bd_address -offset 0xA4090000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/Data1] [get_bd_addr_segs axi_uartlite_2/S_AXI/Reg] -force
  assign_bd_address -offset 0xA4010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/Data1] [get_bd_addr_segs can_0/CAN_S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA4020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/Data1] [get_bd_addr_segs can_1/CAN_S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA4030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/Data1] [get_bd_addr_segs can_2/CAN_S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA4040000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/Data1] [get_bd_addr_segs canfd_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA4050000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/Data1] [get_bd_addr_segs canfd_1/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA4060000 -range 0x00010000 -target_address_space [get_bd_addr_spaces versal_cips_0/Data1] [get_bd_addr_segs canfd_2/S_AXI_LITE/Reg] -force


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


