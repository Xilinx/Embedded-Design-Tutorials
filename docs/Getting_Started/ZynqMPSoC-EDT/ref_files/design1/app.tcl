# Copyright (C) 2025, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#*****************************************************************************************

setws [pwd]/build/ws

# set XSA 

# Vitis Platform Creation
platform create -name {edt_zcu102} -hw {./build/vivado/edt_zcu102_wrapper.xsa} -proc {psu_cortexa53} -os {linux} -arch {64-bit} -no-boot-bsp -fsbl-target {psu_cortexa53_0} ;platform write
domain create -name {standalone_r5} -os {standalone} -proc {psu_cortexr5_0} -arch {32-bit} -display-name {standalone_r5} -desc {} -runtime {cpp}
platform write
# platform generate -quick
platform generate
platform active edt_zcu102


# Vitis app Creation
app create -name tmr_psled_r5 -domain standalone_r5 -template "Empty Application(C)"
# It creates sysproj tmr_psled_r5_system by default
importsources -name tmr_psled_r5 -path ./timer_psled_r5.c
# update link script with sed. Only tested in Linux
exec sed -i {s/psu_r5_ddr_0_MEM_0 : ORIGIN.*/psu_r5_ddr_0_MEM_0 : ORIGIN = 0x70000000, LENGTH = 0x10000000/g} build/ws/tmr_psled_r5/src/lscript.ld
# Set UART1 as default stdio
domain active standalone_r5
bsp config stdin psu_uart_1
bsp config stdout psu_uart_1

app build tmr_psled_r5

# Linux app
domain active linux_domain
app create -name ps_pl_linux_app -domain linux_domain -template "Linux Empty Application"
importsources -name ps_pl_linux_app -path ./ps_pl_linux_app.c
app config -name ps_pl_linux_app libraries pthread
app build ps_pl_linux_app
