# Example Design Template

## Design Summary
This project is a template for creating example design repositories targeting VCK190 ACAP devices.

NOTE: the build instructions are universal if you use this template, so you don't have to edit that section.


## Required Hardware
Here is a list of the required hardware to run the example design:

  1. VCK190 ES1 Eval Board
  1. A host machine that VCK190 is connected to through the cable

## Build Instructions
 ### Vivado:
1. Launch Vivado tool 

1. Select target device as VCK190 ES1 evaluation board and create a project.

1. Enter the Scripts directory. From the tcl console run the following block design tcl script:

		source *bd.tcl

1. The Vivado project will be built.

1. Create your own toplevel hdl(.v/.vhd) wrapper (or) use the one available in Github directory.


 ### PetaLinux:
1. Enter the `hardware` directory and use the XSA to create petalinux workspace. Follow the commands for the following:

   To create Petalinux project, run the following 
	 
		petalinux-create --type project --template versal --name <name_of_project> 
		cd <name_of_project>
	
	 To export XSA and do configuration
	    
		petalinux-config --get-hw-description=<PATH TO XSA>
   
	 To build the PetaLinux project, run the following from the directory:
		
		petalinux-build

1. Once complete, the built images can be found in the plnx/images/linux/ directory. To package these images for SD boot, run the following from the plnx directory:

		petalinux-package --boot 

1. Once packaged, the BOOT.bin and image.ub files (in the plnx/images/linux directory) can be copied to an SD card, and used to boot.

  ### Vitis:
1. To build the Baremetal Example Applications for this project, create a new Vitis workspace in the Software/Vitis directory. Once created, build a new platform project targeting the xsa file from Software/Vitis folder.

1. You can now create a new application project. Select File > New > New Application Project

1. Vitis offers few AXI-uartlite based example application projects. These can be selected on the second page of the New Application Project dialogue.

  ## Validation
Here you will place example validation that you've done that the customer can repeat. This improves confidence in the design, and gives a good test for the customer to run initially. Shown below are Linux and Vitis examples:

  ### Linux:

  Log:
  
       /* Please check available UARTs in the design using dmesg | grep tty */    
	root@xilinx-vck190-2021_2:~# dmesg | grep tty
	[    0.000000] Kernel command line: console=ttyAMA0  earlycon=pl011,mmio32,0xFF000000,115200n8 clk_ignore_unused init_fatal_sh=1
	[    2.647304] a4080000.serial: ttyUL1 at MMIO 0xa4080000 (irq = 41, base_baud = 0) is a uartlite
	[    2.656174] a4090000.serial: ttyUL2 at MMIO 0xa4090000 (irq = 42, base_baud = 0) is a uartlite
	[    2.665021] a40a0000.serial: ttyUL3 at MMIO 0xa40a0000 (irq = 43, base_baud = 0) is a uartlite
	[    3.102121] ff000000.serial: ttyAMA0 at MMIO 0xff000000 (irq = 31, base_baud = 0) is a SBSA
	[    3.110561] printk: console [ttyAMA0] enabled
	[    3.128774] ff010000.serial: ttyAMA1 at MMIO 0xff010000 (irq = 32, base_baud = 0) is a SBSA
	
	 /*AXI-uart lite 2 & 3 are looped back in the design to prove the communication b/w controllers*/
	root@xilinx-vck190-2021_2:~# cat /dev/ttyUL2 &
	[1] 854
	root@xilinx-vck190-2021_2:~# echo Hello_world > /dev/ttyUL3
	Hello_world

	root@xilinx-vck190-2021_2:~# kill 854
	root@xilinx-vck190-2021_2:~# cat /dev/ttyUL3 &
	[2] 856
	[1]   Terminated              cat /dev/ttyUL2
	root@xilinx-vck190-2021_2:~# echo Hello_world > /dev/ttyUL2
	Hello_world

	root@xilinx-vck190-2021_2:~#


### Vitis:

#### AXI-UARTLite example in Interrupt mode

Log:

	[0.010]PMC_GLOBAL_PMC_ERR1_STATUS: 0x0F000000
	[0.081]PMC_GLOBAL_PMC_ERR2_STATUS: 0x01800000
	[4.180]PLM Initialization Time
	[4.243]***********Boot PDI Load: Started***********
	[4.320]Loading PDI from JTAG
	[4.381]Monolithic/Master Device
	[4.500]0.146 ms: PDI initialization time
	[4.573]+++Loading Image#: 0x1, Name: lpd, Id: 0x04210002
	[4.658]---Loading Partition#: 0x1, Id: 0xC
	[35.976]****************************************
	[40.215]Xilinx Versal Platform Loader and Manager
	[44.625]Release 2021.1   Jul 26 2021  -  04:09:34
	[48.950]Platform Version: v2.0 PMC: v2.0, PS: v2.0
	[53.359]BOOTMODE: 0x0, MULTIBOOT: 0x0
	[56.666]****************************************
	[60.947] 56.180 ms for Partition#: 0x1, Size: 2512 Bytes
	[65.825]---Loading Partition#: 0x2, Id: 0xB
	[70.191] 0.517 ms for Partition#: 0x2, Size: 48 Bytes
	[74.304]---Loading Partition#: 0x3, Id: 0xB
	[115.948] 37.793 ms for Partition#: 0x3, Size: 60592 Bytes
	[118.267]---Loading Partition#: 0x4, Id: 0xB
	[122.217] 0.019 ms for Partition#: 0x4, Size: 5968 Bytes
	[127.083]---Loading Partition#: 0x5, Id: 0xB
	[131.022] 0.007 ms for Partition#: 0x5, Size: 80 Bytes
	[135.793]+++Loading Image#: 0x2, Name: pl_cfi, Id: 0x18700000
	[141.072]---Loading Partition#: 0x6, Id: 0x3
	[1003.651] 858.642 ms for Partition#: 0x6, Size: 1272512 Bytes
	[1006.311]---Loading Partition#: 0x7, Id: 0x5
	[1292.949] 282.619 ms for Partition#: 0x7, Size: 441248 Bytes
	[1295.565]+++Loading Image#: 0x3, Name: fpd, Id: 0x0420C003
	[1300.697]---Loading Partition#: 0x8, Id: 0x8
	[1305.145] 0.429 ms for Partition#: 0x8, Size: 1104 Bytes
	[1309.753]***********Boot PDI Load: Done***********
	[1314.219]3433.662 ms: ROM Time
	[1316.979]Total PLM Boot Time
	Successfully ran Uartlite interrupt tapp Example

	
####  AXI-UARTLite example in polled mode

Log:

	[4.243]***********Boot PDI Load: Started***********
	[4.320]Loading PDI from JTAG
	[4.381]Monolithic/Master Device
	[4.500]0.147 ms: PDI initialization time
	[4.573]+++Loading Image#: 0x1, Name: lpd, Id: 0x04210002
	[4.659]---Loading Partition#: 0x1, Id: 0xC
	[35.980]****************************************
	[40.222]Xilinx Versal Platform Loader and Manager
	[44.631]Release 2021.1   Jul 26 2021  -  04:09:34
	[48.956]Platform Version: v2.0 PMC: v2.0, PS: v2.0
	[53.364]BOOTMODE: 0x0, MULTIBOOT: 0x0
	[56.671]****************************************
	[60.951] 56.183 ms for Partition#: 0x1, Size: 2512 Bytes
	[65.829]---Loading Partition#: 0x2, Id: 0xB
	[70.195] 0.517 ms for Partition#: 0x2, Size: 48 Bytes
	[74.308]---Loading Partition#: 0x3, Id: 0xB
	[113.970] 35.812 ms for Partition#: 0x3, Size: 60592 Bytes
	[116.290]---Loading Partition#: 0x4, Id: 0xB
	[120.241] 0.019 ms for Partition#: 0x4, Size: 5968 Bytes
	[125.109]---Loading Partition#: 0x5, Id: 0xB
	[129.050] 0.007 ms for Partition#: 0x5, Size: 80 Bytes
	[133.820]+++Loading Image#: 0x2, Name: pl_cfi, Id: 0x18700000
	[139.098]---Loading Partition#: 0x6, Id: 0x3
	[995.162] 852.127 ms for Partition#: 0x6, Size: 1272512 Bytes
	[997.738]---Loading Partition#: 0x7, Id: 0x5
	[1285.563] 283.890 ms for Partition#: 0x7, Size: 441248 Bytes
	[1288.179]+++Loading Image#: 0x3, Name: fpd, Id: 0x0420C003
	[1293.310]---Loading Partition#: 0x8, Id: 0x8
	[1297.757] 0.429 ms for Partition#: 0x8, Size: 1104 Bytes
	[1302.363]***********Boot PDI Load: Done***********
	[1306.828]3411.205 ms: ROM Time
	[1309.589]Total PLM Boot Time
	Successfully ran Uartlite polled Example


## Known Issues
In this section, list any known issues with the design, or any warning messages that might appear which can be safely ignored by the customer.

Copyright 2020 Xilinx Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


