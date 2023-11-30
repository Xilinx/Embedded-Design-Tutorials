
# ########################################################################
# Copyright (C) 2019, Xilinx Inc - All rights reserved

# Licensed under the Apache License, Version 2.0 (the "License"). You may
# not use this file except in compliance with the License. A copy of the
# License is located at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
# ########################################################################

set design_name dhrystone_perf
create_bd_design "$design_name"
proc create_root_design { parentCell} {
  
puts "create_root_design"

 #Create NoC IP
 create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_0
set_property -dict [list CONFIG.NUM_SI {8} CONFIG.NUM_MI {0} CONFIG.NUM_CLKS {8}] [get_bd_cells axi_noc_0]
set_property -dict [list CONFIG.CATEGORY {ps_cci}] [get_bd_intf_pins /axi_noc_0/S00_AXI]
set_property -dict [list CONFIG.CATEGORY {ps_cci}] [get_bd_intf_pins /axi_noc_0/S01_AXI]
set_property -dict [list CONFIG.CATEGORY {ps_cci}] [get_bd_intf_pins /axi_noc_0/S02_AXI]
set_property -dict [list CONFIG.CATEGORY {ps_cci}] [get_bd_intf_pins /axi_noc_0/S03_AXI]
set_property -dict [list CONFIG.CATEGORY {ps_nci}] [get_bd_intf_pins /axi_noc_0/S04_AXI]
set_property -dict [list CONFIG.CATEGORY {ps_nci}] [get_bd_intf_pins /axi_noc_0/S05_AXI]
set_property -dict [list CONFIG.CATEGORY {ps_pmc}] [get_bd_intf_pins /axi_noc_0/S06_AXI]
set_property -dict [list CONFIG.CATEGORY {ps_rpu}] [get_bd_intf_pins /axi_noc_0/S07_AXI]
set_property -dict [list CONFIG.ASSOCIATED_BUSIF {S00_AXI}] [get_bd_pins /axi_noc_0/aclk0]
set_property -dict [list CONFIG.ASSOCIATED_BUSIF {S01_AXI}] [get_bd_pins /axi_noc_0/aclk1]
set_property -dict [list CONFIG.ASSOCIATED_BUSIF {S02_AXI}] [get_bd_pins /axi_noc_0/aclk2]
set_property -dict [list CONFIG.ASSOCIATED_BUSIF {S03_AXI}] [get_bd_pins /axi_noc_0/aclk3]
set_property -dict [list CONFIG.ASSOCIATED_BUSIF {S04_AXI}] [get_bd_pins /axi_noc_0/aclk4]
set_property -dict [list CONFIG.ASSOCIATED_BUSIF {S05_AXI}] [get_bd_pins /axi_noc_0/aclk5]
set_property -dict [list CONFIG.ASSOCIATED_BUSIF {S06_AXI}] [get_bd_pins /axi_noc_0/aclk6]
set_property -dict [list CONFIG.ASSOCIATED_BUSIF {S07_AXI}] [get_bd_pins /axi_noc_0/aclk7]

 set_property -dict [list CONFIG.NUM_MC {1} CONFIG.NUM_MCP {1} CONFIG.MC_BOARD_INTRF_EN {true} CONFIG.MC0_CONFIG_NUM {config17} CONFIG.MC1_CONFIG_NUM {config17} CONFIG.MC2_CONFIG_NUM {config17} CONFIG.MC3_CONFIG_NUM {config17} CONFIG.CH0_DDR4_0_BOARD_INTERFACE {ddr4_dimm1} CONFIG.LOGO_FILE {data/noc_mc.png} CONFIG.MC_INPUT_FREQUENCY0 {200.000} CONFIG.MC_INPUTCLK0_PERIOD {5000} CONFIG.MC_MEMORY_DEVICETYPE {UDIMMs} CONFIG.MC_MEMORY_SPEEDGRADE {DDR4-3200AA(22-22-22)} CONFIG.MC_TRCD {13750} CONFIG.MC_TRP {13750} CONFIG.MC_DDR4_2T {Disable} CONFIG.MC_CASLATENCY {22} CONFIG.MC_TRC {45750} CONFIG.MC_TRPMIN {13750} CONFIG.MC_CONFIG_NUM {config17} CONFIG.MC_F1_TRCD {13750} CONFIG.MC_F1_TRCDMIN {13750} CONFIG.MC_F1_LPDDR4_MR1 {0x000} CONFIG.MC_F1_LPDDR4_MR2 {0x000} CONFIG.MC_F1_LPDDR4_MR3 {0x000} CONFIG.MC_F1_LPDDR4_MR11 {0x000} CONFIG.MC_F1_LPDDR4_MR13 {0x000} CONFIG.MC_F1_LPDDR4_MR22 {0x000}] [get_bd_cells axi_noc_0]
	apply_bd_automation -rule xilinx.com:bd_rule:board -config { Board_Interface {ddr4_dimm1 ( DDR4 DIMM1 ) } Manual_Source {Auto}}  [get_bd_intf_pins axi_noc_0/CH0_DDR4_0]
	apply_bd_automation -rule xilinx.com:bd_rule:board -config { Board_Interface {ddr4_dimm1_sma_clk ( DDR4 DIMM1 SMA Clock ) } Manual_Source {Auto}}  [get_bd_intf_pins axi_noc_0/sys_clk0]

  # Create instance: versal_cips_0, and set properties
  set versal_cips_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:versal_cips versal_cips_0 ]
  set_property -dict [list \
   CONFIG.CPM_CONFIG [dict create \
      CPM_PCIE0_ARI_CAP_ENABLED {0} \
      CPM_PCIE0_MODE0_FOR_POWER {NONE} \
      CPM_PCIE1_ARI_CAP_ENABLED {0} \
      CPM_PCIE1_FUNCTIONAL_MODE {None} \
      CPM_PCIE1_MODE1_FOR_POWER {NONE} \
    ] \
   CONFIG.PS_PMC_CONFIG [dict create \
      PMC_EXTERNAL_TAMPER {{IO NONE}} \
      PMC_I2CPMC_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 46 .. 47}}} \
      PMC_MIO0 {{DIRECTION out} {SCHMITT 1}} \
      PMC_MIO10 {{DIRECTION inout}} \
      PMC_MIO11 {{DIRECTION inout}} \
      PMC_MIO12 {{DIRECTION out} {SCHMITT 1}} \
      PMC_MIO13 {{DIRECTION out} {SCHMITT 1}} \
      PMC_MIO14 {{DIRECTION inout}} \
      PMC_MIO15 {{DIRECTION inout}} \
      PMC_MIO16 {{DIRECTION inout}} \
      PMC_MIO17 {{DIRECTION inout}} \
      PMC_MIO19 {{DIRECTION inout}} \
      PMC_MIO1 {{DIRECTION inout}} \
      PMC_MIO20 {{DIRECTION inout}} \
      PMC_MIO21 {{DIRECTION inout}} \
      PMC_MIO22 {{DIRECTION inout}} \
      PMC_MIO24 {{DIRECTION out} {SCHMITT 1}} \
      PMC_MIO26 {{DIRECTION inout}} \
      PMC_MIO27 {{DIRECTION inout}} \
      PMC_MIO29 {{DIRECTION inout}} \
      PMC_MIO2 {{DIRECTION inout}} \
      PMC_MIO30 {{DIRECTION inout}} \
      PMC_MIO31 {{DIRECTION inout}} \
      PMC_MIO32 {{DIRECTION inout}} \
      PMC_MIO33 {{DIRECTION inout}} \
      PMC_MIO34 {{DIRECTION inout}} \
      PMC_MIO35 {{DIRECTION inout}} \
      PMC_MIO36 {{DIRECTION inout}} \
      PMC_MIO37 {{OUTPUT_DATA high} {USAGE GPIO}} \
      PMC_MIO3 {{DIRECTION inout}} \
      PMC_MIO40 {{DIRECTION out} {SCHMITT 1}} \
      PMC_MIO43 {{DIRECTION out} {SCHMITT 1}} \
      PMC_MIO44 {{DIRECTION inout}} \
      PMC_MIO45 {{DIRECTION inout}} \
      PMC_MIO46 {{DIRECTION inout} {SCHMITT 1}} \
      PMC_MIO47 {{DIRECTION inout}} \
      PMC_MIO48 {{USAGE GPIO}} \
      PMC_MIO49 {{DIRECTION out} {USAGE GPIO}} \
      PMC_MIO4 {{DIRECTION inout}} \
      PMC_MIO51 {{DIRECTION out} {SCHMITT 1}} \
      PMC_MIO5 {{DIRECTION out} {SCHMITT 1}} \
      PMC_MIO6 {{DIRECTION out} {SCHMITT 1}} \
      PMC_MIO7 {{DIRECTION out} {SCHMITT 1}} \
      PMC_MIO8 {{DIRECTION inout}} \
      PMC_MIO9 {{DIRECTION inout}} \
      PMC_MIO_TREE_PERIPHERALS {QSPI#QSPI#QSPI#QSPI#QSPI#QSPI#Loopback Clk#QSPI#QSPI#QSPI#QSPI#QSPI#QSPI#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#SD1/eMMC1#SD1/eMMC1#SD1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#external_tamper###CAN 1#CAN 1#UART 0#UART 0#I2C 1#I2C 1#i2c_pmc#i2c_pmc#GPIO 1#GPIO 1#SD1#SD1/eMMC1#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 1#Enet 1#Enet 1#Enet 1#Enet 1#Enet 1#Enet 1#Enet 1#Enet 1#Enet 1#Enet 1#Enet 1#Enet 0#Enet 0} \
      PMC_MIO_TREE_SIGNALS {qspi0_clk#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]#qspi0_io[0]#qspi0_cs_b#qspi_lpbk#qspi1_cs_b#qspi1_io[0]#qspi1_io[1]#qspi1_io[2]#qspi1_io[3]#qspi1_clk#usb2phy_reset#ulpi_tx_data[0]#ulpi_tx_data[1]#ulpi_tx_data[2]#ulpi_tx_data[3]#ulpi_clk#ulpi_tx_data[4]#ulpi_tx_data[5]#ulpi_tx_data[6]#ulpi_tx_data[7]#ulpi_dir#ulpi_stp#ulpi_nxt#clk#dir1/data[7]#detect#cmd#data[0]#data[1]#data[2]#data[3]#sel/data[4]#dir_cmd/data[5]#dir0/data[6]#ext_tamper_trig###phy_tx#phy_rx#rxd#txd#scl#sda#scl#sda#gpio_1_pin[48]#gpio_1_pin[49]#wp#buspwr/rst#rgmii_tx_clk#rgmii_txd[0]#rgmii_txd[1]#rgmii_txd[2]#rgmii_txd[3]#rgmii_tx_ctl#rgmii_rx_clk#rgmii_rxd[0]#rgmii_rxd[1]#rgmii_rxd[2]#rgmii_rxd[3]#rgmii_rx_ctl#rgmii_tx_clk#rgmii_txd[0]#rgmii_txd[1]#rgmii_txd[2]#rgmii_txd[3]#rgmii_tx_ctl#rgmii_rx_clk#rgmii_rxd[0]#rgmii_rxd[1]#rgmii_rxd[2]#rgmii_rxd[3]#rgmii_rx_ctl#gem0_mdc#gem0_mdio} \
      PMC_QSPI_FBCLK {{ENABLE 1}} \
      PMC_QSPI_PERIPHERAL_DATA_MODE {x4} \
      PMC_QSPI_PERIPHERAL_ENABLE {1} \
      PMC_QSPI_PERIPHERAL_MODE {Dual Parallel} \
      PMC_SD1_DATA_TRANSFER_MODE {8Bit} \
      PMC_SD1 {{CD_ENABLE 1} {CD_IO {PMC_MIO 28}} {POW_ENABLE 1} {POW_IO {PMC_MIO 51}} {WP_ENABLE 1} {WP_IO {PMC_MIO 50}}} \
      PMC_SD1_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 26 .. 36}}} \
      PMC_SD1_SLOT_TYPE {SD 3.0} \
      PMC_SD1_SPEED_MODE {high speed} \
      PMC_USE_PMC_NOC_AXI0 {1} \
      PS_CAN1_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 40 .. 41}}} \
      PS_ENET0_MDIO {{ENABLE 1} {IO {PS_MIO 24 .. 25}}} \
      PS_ENET0_PERIPHERAL {{ENABLE 1} {IO {PS_MIO 0 .. 11}}} \
      PS_ENET1_PERIPHERAL {{ENABLE 1} {IO {PS_MIO 12 .. 23}}} \
      PS_GEN_IPI0_ENABLE {1} \
      PS_GEN_IPI1_ENABLE {1} \
      PS_GEN_IPI2_ENABLE {1} \
      PS_GEN_IPI3_ENABLE {1} \
      PS_GEN_IPI4_ENABLE {1} \
      PS_GEN_IPI5_ENABLE {1} \
      PS_GEN_IPI6_ENABLE {1} \
      PS_I2C1_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 44 .. 45}}} \
      PS_MIO0 {{DIRECTION out} {SCHMITT 1}} \
      PS_MIO12 {{DIRECTION out} {SCHMITT 1}} \
      PS_MIO13 {{DIRECTION out} {SCHMITT 1}} \
      PS_MIO14 {{DIRECTION out} {SCHMITT 1}} \
      PS_MIO15 {{DIRECTION out} {SCHMITT 1}} \
      PS_MIO16 {{DIRECTION out} {SCHMITT 1}} \
      PS_MIO17 {{DIRECTION out} {SCHMITT 1}} \
      PS_MIO1 {{DIRECTION out} {SCHMITT 1}} \
      PS_MIO24 {{DIRECTION out} {SCHMITT 1}} \
      PS_MIO25 {{DIRECTION inout}} \
      PS_MIO2 {{DIRECTION out} {SCHMITT 1}} \
      PS_MIO3 {{DIRECTION out} {SCHMITT 1}} \
      PS_MIO4 {{DIRECTION out} {SCHMITT 1}} \
      PS_MIO5 {{DIRECTION out} {SCHMITT 1}} \
      PS_NUM_FABRIC_RESETS {0} \
      PS_UART0_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 42 .. 43}}} \
      PS_UART1_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 4 .. 5}}} \
      PS_USB3_PERIPHERAL {{ENABLE 1}} \
      PS_USE_M_AXI_FPD {0} \
      PS_USE_M_AXI_LPD {0} \
      PS_USE_NOC_FPD_CCI0 {0} \
      PS_USE_NOC_FPD_CCI1 {0} \
      PS_USE_PMCPL_CLK0 {0} \
      PS_USE_FPD_CCI_NOC {1} \
      PS_USE_FPD_AXI_NOC0 {1} \
      PS_USE_FPD_AXI_NOC1 {1} \
      PS_USE_NOC_LPD_AXI0 {1} \
      SMON_ALARMS {Set_Alarms_On} \
      SMON_MEAS37 {{ENABLE 1}} \
      SMON_MEAS40 {{ENABLE 1}} \
      SMON_MEAS41 {{ENABLE 1}} \
      SMON_MEAS42 {{ENABLE 1}} \
      SMON_MEAS61 {{ENABLE 1}} \
      SMON_MEAS62 {{ENABLE 1}} \
      SMON_MEAS63 {{ENABLE 1}} \
      SMON_MEAS64 {{ENABLE 1}} \
      SMON_MEAS65 {{ENABLE 1}} \
      SMON_MEAS66 {{ENABLE 1}} \
      SMON_OT {{THRESHOLD_LOWER -50} {THRESHOLD_UPPER 100}} \
      SMON_USER_TEMP {{THRESHOLD_LOWER -50} {THRESHOLD_UPPER 100}} \
    ] \
  ] $versal_cips_0

##Customize NoC 
set_property -dict [list CONFIG.NUM_MCP {4}] [get_bd_cells axi_noc_0]
set_property -dict [list CONFIG.CONNECTIONS {MC_3 { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} }] [get_bd_intf_pins /axi_noc_0/S00_AXI]
set_property -dict [list CONFIG.CONNECTIONS {MC_2 { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} }] [get_bd_intf_pins /axi_noc_0/S01_AXI]
set_property -dict [list CONFIG.CONNECTIONS {MC_0 { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} }] [get_bd_intf_pins /axi_noc_0/S02_AXI]
set_property -dict [list CONFIG.CONNECTIONS {MC_1 { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} }] [get_bd_intf_pins /axi_noc_0/S03_AXI]
set_property -dict [list CONFIG.CONNECTIONS {MC_1 { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} }] [get_bd_intf_pins /axi_noc_0/S04_AXI]
set_property -dict [list CONFIG.CONNECTIONS {MC_0 { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} }] [get_bd_intf_pins /axi_noc_0/S05_AXI]
set_property -dict [list CONFIG.CONNECTIONS {MC_2 { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} }] [get_bd_intf_pins /axi_noc_0/S06_AXI]
set_property -dict [list CONFIG.CONNECTIONS {MC_3 { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} }] [get_bd_intf_pins /axi_noc_0/S07_AXI]

#Creating interface connections
connect_bd_intf_net [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_0] [get_bd_intf_pins axi_noc_0/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_1] [get_bd_intf_pins axi_noc_0/S01_AXI]
connect_bd_intf_net [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_2] [get_bd_intf_pins axi_noc_0/S02_AXI]
connect_bd_intf_net [get_bd_intf_pins versal_cips_0/FPD_CCI_NOC_3] [get_bd_intf_pins axi_noc_0/S03_AXI]
connect_bd_intf_net [get_bd_intf_pins versal_cips_0/FPD_AXI_NOC_0] [get_bd_intf_pins axi_noc_0/S04_AXI]
connect_bd_intf_net [get_bd_intf_pins versal_cips_0/FPD_AXI_NOC_1] [get_bd_intf_pins axi_noc_0/S05_AXI]
connect_bd_intf_net [get_bd_intf_pins versal_cips_0/PMC_NOC_AXI_0] [get_bd_intf_pins axi_noc_0/S06_AXI]
connect_bd_intf_net [get_bd_intf_pins versal_cips_0/LPD_AXI_NOC_0] [get_bd_intf_pins axi_noc_0/S07_AXI]

#Create port connections
connect_bd_net [get_bd_pins versal_cips_0/fpd_cci_noc_axi0_clk] [get_bd_pins axi_noc_0/aclk0]
connect_bd_net [get_bd_pins versal_cips_0/fpd_cci_noc_axi1_clk] [get_bd_pins axi_noc_0/aclk1]
connect_bd_net [get_bd_pins versal_cips_0/fpd_cci_noc_axi2_clk] [get_bd_pins axi_noc_0/aclk2]
connect_bd_net [get_bd_pins versal_cips_0/fpd_cci_noc_axi3_clk] [get_bd_pins axi_noc_0/aclk3]
connect_bd_net [get_bd_pins versal_cips_0/fpd_axi_noc_axi0_clk] [get_bd_pins axi_noc_0/aclk4]
connect_bd_net [get_bd_pins versal_cips_0/fpd_axi_noc_axi1_clk] [get_bd_pins axi_noc_0/aclk5]
connect_bd_net [get_bd_pins versal_cips_0/lpd_axi_noc_clk] [get_bd_pins axi_noc_0/aclk7]
connect_bd_net [get_bd_pins versal_cips_0/pmc_axi_noc_axi0_clk] [get_bd_pins axi_noc_0/aclk6]


  assign_bd_address

  regenerate_bd_layout
  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################
create_root_design ""
open_bd_design [get_bd_files $design_name]
make_wrapper -files [get_files $design_name.bd] -top -import


