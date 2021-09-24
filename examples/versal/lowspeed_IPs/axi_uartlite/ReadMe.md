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

	[5.639706]****************************************
	[7.279325]Xilinx Versal Platform Loader and Manager
	[11.898643]Release 2020.2 Nov 18 2020 - 14:54:52
	[16.518146]Platform Version: v2.0 PMC: v2.0, PS: v2.0
	[21.221343]BOOTMODE: 0, MULTIBOOT: 0x0
	[24.642531]****************************************
	[29.198750] 24.855628 ms for PrtnNum: 1, Size: 2368 Bytes
	[34.224584]-------Loading Prtn No: 0x2
	[38.185012] 0.521871 ms for PrtnNum: 2, Size: 48 Bytes
	[42.436659]-------Loading Prtn No: 0x3
	[79.566918] 33.686375 ms for PrtnNum: 3, Size: 57168 Bytes
	[81.891478]-------Loading Prtn No: 0x4
	[85.342206] 0.012528 ms for PrtnNum: 4, Size: 2512 Bytes
	[90.277568]-------Loading Prtn No: 0x5
	[93.730615] 0.014315 ms for PrtnNum: 5, Size: 3424 Bytes
	[98.663865]-------Loading Prtn No: 0x6
	[102.108581] 0.007784 ms for PrtnNum: 6, Size: 80 Bytes
	[107.011084]+++++++Loading Image No: 0x2, Name: pl_cfi, Id: 0x18700000
	[113.120468]-------Loading Prtn No: 0x7
	[990.977650] 874.327690 ms for PrtnNum: 7, Size: 1320080 Bytes
	[993.646071]-------Loading Prtn No: 0x8
	[1259.698453] 262.521565 ms for PrtnNum: 8, Size: 385488 Bytes
	[1262.398821]+++++++Loading Image No: 0x3, Name: fpd, Id: 0x0420C003
	[1268.352465]-------Loading Prtn No: 0x9
	[1272.125481] 0.163828 ms for PrtnNum: 9, Size: 1008 Bytes
	[1277.128406]***********Boot PDI Load: Done*************
	[1282.053956]3508.417287 ms: ROM Time
	[1285.374046]Total PLM Boot Time
	Successfully ran Uartlite interrupt tapp Example
	
####  AXI-UARTLite example in polled mode

Log:

	[5.571103]****************************************
	[7.209787]Xilinx Versal Platform Loader and Manager
	[11.826212]Release 2020.2 Nov 18 2020 - 14:54:52
	[16.443446]Platform Version: v2.0 PMC: v2.0, PS: v2.0
	[21.145887]BOOTMODE: 0, MULTIBOOT: 0x0
	[24.566228]****************************************
	[29.121275] 24.778253 ms for PrtnNum: 1, Size: 2368 Bytes
	[34.144590]-------Loading Prtn No: 0x2
	[38.103871] 0.521596 ms for PrtnNum: 2, Size: 48 Bytes
	[42.352409]-------Loading Prtn No: 0x3
	[79.397821] 33.605043 ms for PrtnNum: 3, Size: 57168 Bytes
	[81.721487]-------Loading Prtn No: 0x4
	[85.169043] 0.012528 ms for PrtnNum: 4, Size: 2512 Bytes
	[90.100025]-------Loading Prtn No: 0x5
	[93.549950] 0.014315 ms for PrtnNum: 5, Size: 3424 Bytes
	[98.479784]-------Loading Prtn No: 0x6
	[101.923812] 0.007784 ms for PrtnNum: 6, Size: 80 Bytes
	[106.825206]+++++++Loading Image No: 0x2, Name: pl_cfi, Id: 0x18700000
	[112.933012]-------Loading Prtn No: 0x7
	[996.490415] 880.028609 ms for PrtnNum: 7, Size: 1320080 Bytes
	[999.155925]-------Loading Prtn No: 0x8
	[1273.071912] 270.388625 ms for PrtnNum: 8, Size: 385488 Bytes
	[1275.770700]+++++++Loading Image No: 0x3, Name: fpd, Id: 0x0420C003
	[1281.721221]-------Loading Prtn No: 0x9
	[1285.492378] 0.163862 ms for PrtnNum: 9, Size: 1008 Bytes
	[1290.491865]***********Boot PDI Load: Done*************
	[1295.414975]3567.806246 ms: ROM Time
	[1298.732437]Total PLM Boot Time
	Successfully ran Uartlite polled Example

## Known Issues
In this section, list any known issues with the design, or any warning messages that might appear which can be safely ignored by the customer.

Copyright 2020 Xilinx Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


