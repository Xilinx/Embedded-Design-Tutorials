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

1. Vitis offers few PS-SBSA uart based example application projects. These can be selected on the second page of the New Application Project dialogue.

  ## Validation
Here you will place example validation that you've done that the customer can repeat. This improves confidence in the design, and gives a good test for the customer to run initially. Shown below are Linux and Vitis examples:

  ### Linux:

Log:

        /*Please check available UARTs in the design using dmesg | grep tty*/

       
       
       
       
	root@xilinx-vck190-2021_2:~# dmesg | grep tty
	[    0.000000] Kernel command line: console=ttyAMA0  earlycon=pl011,mmio32,0xFF000000,115200n8 clk_ignore_unused init_fatal_sh=1
	[    2.588986] a4080000.serial: ttyUL1 at MMIO 0xa4080000 (irq = 41, base_baud = 0) is a uartlite
	[    2.597851] a4090000.serial: ttyUL2 at MMIO 0xa4090000 (irq = 42, base_baud = 0) is a uartlite
	[    2.606699] a40a0000.serial: ttyUL3 at MMIO 0xa40a0000 (irq = 43, base_baud = 0) is a uartlite
	[    3.043735] ff000000.serial: ttyAMA0 at MMIO 0xff000000 (irq = 31, base_baud = 0) is a SBSA
	[    3.052175] printk: console [ttyAMA0] enabled
	[    3.070376] ff010000.serial: ttyAMA1 at MMIO 0xff010000 (irq = 32, base_baud = 0) is a SBSA
	
	/*PS-SBSA Uart and AXI-uart lite are looped back in the design to prove the communication b/w different controllers*/
	root@xilinx-vck190-2021_2:~# cat /dev/ttyUL1 &
	[1] 855
	root@xilinx-vck190-2021_2:~# echo Hello_world > /dev/ttyAMA4
	root@xilinx-vck190-2021_2:~# kill 855
	root@xilinx-vck190-2021_2:~# cat /dev/ttyAMA4 &
	[2] 856
	[1]   Terminated              cat /dev/ttyUL1
	Hello_world
	root@xilinx-vck190-2021_2:~# echo Hello_world > /dev/ttyUL1
	[2]+  Done                    cat /dev/ttyAMA4
	root@xilinx-vck190-2021_2:~# kill 856
	-sh: kill: (856) - No such process
	
	/*Self testing of console PS-SBSA UART0*/
	root@xilinx-vck190-2021_2:~# echo Hello_world > /dev/ttyAMA0
	Hello_world
	root@xilinx-vck190-2021_2:~#

       
       
       
       
       vck_190_lowspeed_all login: root
        Password:
        root@vck_190_lowspeed_all:~# dmesg | grep tty
        [ 0.000000] Kernel command line: console=ttyAMA0 earlycon=pl011,mmio32,0xFF000000,9600n8 clk_ignore_unused root=/dev/ram0 rw
        [ 2.929867] a4070000.serial: ttyUL1 at MMIO 0xa4070000 (irq = 34, base_baud = 0) is a uartlite
        [ 2.938718] a4080000.serial: ttyUL2 at MMIO 0xa4080000 (irq = 35, base_baud = 0) is a uartlite
        [ 2.947563] a4090000.serial: ttyUL3 at MMIO 0xa4090000 (irq = 36, base_baud = 0) is a uartlite
        [ 3.393395] ff000000.serial: ttyAMA0 at MMIO 0xff000000 (irq = 24, base_baud = 0) is a SBSA
        [ 3.401826] printk: console [ttyAMA0] enabled
        [ 3.419905] ff010000.serial: ttyAMA4 at MMIO 0xff010000 (irq = 25, base_baud = 0) is a SBSA
        /*PS-SBSA Uart and AXI-uart lite are looped back in the design to prove the communication b/w different controllers*/

	root@xilinx-vck190-2021_2:~# echo Hello_world > /dev/ttyAMA1
	root@xilinx-vck190-2021_2:~# cat /dev/ttyUL1 &
	[1] 853
	root@xilinx-vck190-2021_2:~# echo Hello_world_from_ps > /dev/ttyAMA1
	Hello_world_from_ps

	root@xilinx-vck190-2021_2:~# kill 853
	root@xilinx-vck190-2021_2:~# echo Hello_world_from_pl > /dev/ttyUL1
	[1]+  Terminated              cat /dev/ttyUL1
	root@xilinx-vck190-2021_2:~# cat /dev/ttyAMA1 &
	[1] 855
	root@xilinx-vck190-2021_2:~# echo Hello_world_from_pl > /dev/ttyUL1
	Hello_world_from_pl

	root@xilinx-vck190-2021_2:~#

### Vitis:

#### PS-SBSA UART example in interrupt mode 

Log:

        [6.521553]****************************************
        [8.156987]Xilinx Versal Platform Loader and Manager
        [12.765537]Release 2020.2 Nov 18 2020 - 14:54:52
        [17.375037]Platform Version: v2.0 PMC: v2.0, PS: v2.0
        [22.070206]BOOTMODE: 0, MULTIBOOT: 0x0
        [25.484662]****************************************
        [30.032171] 25.688412 ms for PrtnNum: 1, Size: 2368 Bytes
        [35.046365]-------Loading Prtn No: 0x2
        [38.998809] 0.520703 ms for PrtnNum: 2, Size: 48 Bytes
        [43.240281]-------Loading Prtn No: 0x3
        [81.260568] 34.584671 ms for PrtnNum: 3, Size: 57168 Bytes
        [83.579318]-------Loading Prtn No: 0x4
        [87.019731] 0.012528 ms for PrtnNum: 4, Size: 2512 Bytes
        [91.940490]-------Loading Prtn No: 0x5
        [95.382971] 0.014315 ms for PrtnNum: 5, Size: 3424 Bytes
        [100.302100]-------Loading Prtn No: 0x6
        [103.823696] 0.007784 ms for PrtnNum: 6, Size: 80 Bytes
        [108.712696]+++++++Loading Image No: 0x2, Name: pl_cfi, Id: 0x18700000
        [114.804487]-------Loading Prtn No: 0x7
        [988.681403] 870.358103 ms for PrtnNum: 7, Size: 1320080 Bytes
        [991.344587]-------Loading Prtn No: 0x8
        [1292.963709] 298.094487 ms for PrtnNum: 8, Size: 385488 Bytes
        [1295.661446]+++++++Loading Image No: 0x3, Name: fpd, Id: 0x0420C003
        [1301.610412]-------Loading Prtn No: 0x9
        [1305.647225] 0.431234 ms for PrtnNum: 9, Size: 1008 Bytes
        [1310.376468]***********Boot PDI Load: Done*************
        [1315.295812]3518.971143 ms: ROM Time
        [1318.610971]Total PLM Boot Time
        abcdefghABCDEFGH012345677654321
        UartPsv Interrupt Example self test pass
 
        Please enter 4 characters from console   // entered characters will not displayed here

        You have entered following 4 characters from console
        abcd
        Successfully ran UartPsv Interrupt Example Test


#### PS-SBSA UART example in polled mode 

Log:

        .726068]****************************************
        [7.363112]Xilinx Versal Platform Loader and Manager
        [11.975159]Release 2020.2 Nov 18 2020 - 14:54:52
        [16.588706]Platform Version: v2.0 PMC: v2.0, PS: v2.0
        [21.286606]BOOTMODE: 0, MULTIBOOT: 0x0
        [24.703803]****************************************
        [29.256021] 24.913312 ms for PrtnNum: 1, Size: 2368 Bytes
        [34.275762]-------Loading Prtn No: 0x2
        [38.233759] 0.521528 ms for PrtnNum: 2, Size: 48 Bytes
        [42.481803]-------Loading Prtn No: 0x3
        [79.713521] 33.791493 ms for PrtnNum: 3, Size: 57168 Bytes
        [82.034971]-------Loading Prtn No: 0x4
        [85.478731] 0.012528 ms for PrtnNum: 4, Size: 2512 Bytes
        [90.405265]-------Loading Prtn No: 0x5
        [93.853153] 0.014315 ms for PrtnNum: 5, Size: 3424 Bytes
        [98.777487]-------Loading Prtn No: 0x6
        [102.217231] 0.007784 ms for PrtnNum: 6, Size: 80 Bytes
        [107.113090]+++++++Loading Image No: 0x2, Name: pl_cfi, Id: 0x18700000
        [113.214287]-------Loading Prtn No: 0x7
        [985.594128] 868.855156 ms for PrtnNum: 7, Size: 1320080 Bytes
        [988.258303]-------Loading Prtn No: 0x8
        [1253.612418] 261.829831 ms for PrtnNum: 8, Size: 385488 Bytes
        [1256.308681]+++++++Loading Image No: 0x3, Name: fpd, Id: 0x0420C003
        [1262.252134]-------Loading Prtn No: 0x9
        [1266.019268] 0.163903 ms for PrtnNum: 9, Size: 1008 Bytes
        [1271.014456]***********Boot PDI Load: Done*************
        [1275.932087]3491.637081 ms: ROM Time
        [1279.245915]Total PLM Boot Time
        abcdefghABCDEFGH012345677654321
 
        UartPsv Polling Example self test pass

        Please enter 4 characters from console  // entered characters will not displayed here
        You have entered the following characters
        ABCD
        Successfully ran UartPsv Polling Example Test
        
## Known Issues
In this section, list any known issues with the design, or any warning messages that might appear which can be safely ignored by the customer.

Copyright 2020 Xilinx Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.




