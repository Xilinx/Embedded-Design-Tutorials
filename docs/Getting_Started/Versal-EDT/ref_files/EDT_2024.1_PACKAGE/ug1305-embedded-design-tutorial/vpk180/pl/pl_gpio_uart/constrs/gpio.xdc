# Misc
#GPIO_LED_0_LS
set_property PACKAGE_PIN BA49 [get_ports Dout_0]
set_property IOSTANDARD LVCMOS15 [get_ports {Dout_0}]
#GPIO_LED_1_LS
set_property PACKAGE_PIN AY50 [get_ports Dout_1]
set_property IOSTANDARD LVCMOS15 [get_ports {Dout_1}]
#GPIO_LED_2_LS
set_property PACKAGE_PIN BA48 [get_ports Dout_2]
set_property IOSTANDARD LVCMOS15 [get_ports {Dout_2}]
#GPIO_LED_3_LS
set_property PACKAGE_PIN AY49 [get_ports Dout_3]
set_property IOSTANDARD LVCMOS15 [get_ports {Dout_3}]

set_property USER_SLR_ASSIGNMENT SLR1 [get_cells {edt_versal_i/axi_register_slice_1_s2}]

set_property USER_SLR_ASSIGNMENT SLR2 [get_cells {edt_versal_i/axi_register_slice_2_s2}]

set_property USER_SLR_ASSIGNMENT SLR3 [get_cells {edt_versal_i/axi_register_slice_3_s2}]
