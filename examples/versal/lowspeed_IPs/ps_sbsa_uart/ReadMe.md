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

 

### Vitis:

#### PS-SBSA UART example in interrupt mode 

Log:

	[0.010]PMC_GLOBAL_PMC_ERR1_STATUS: 0x0F000000
	[0.081]PMC_GLOBAL_PMC_ERR2_STATUS: 0x01800000
	[4.180]PLM Initialization Time
	[4.243]***********Boot PDI Load: Started***********
	[4.321]Loading PDI from JTAG
	[4.382]Monolithic/Master Device
	[4.499]0.146 ms: PDI initialization time
	[4.573]+++Loading Image#: 0x1, Name: lpd, Id: 0x04210002
	[4.659]---Loading Partition#: 0x1, Id: 0xC
	[35.992]****************************************
	[40.235]Xilinx Versal Platform Loader and Manager
	[44.646]Release 2021.1   Jul 26 2021  -  04:09:34
	[48.974]Platform Version: v2.0 PMC: v2.0, PS: v2.0
	[53.385]BOOTMODE: 0x0, MULTIBOOT: 0x0
	[56.693]****************************************
	[60.975] 56.206 ms for Partition#: 0x1, Size: 2512 Bytes
	[65.855]---Loading Partition#: 0x2, Id: 0xB
	[70.223] 0.517 ms for Partition#: 0x2, Size: 48 Bytes
	[74.337]---Loading Partition#: 0x3, Id: 0xB
	[114.779] 36.589 ms for Partition#: 0x3, Size: 60592 Bytes
	[117.098]---Loading Partition#: 0x4, Id: 0xB
	[121.049] 0.019 ms for Partition#: 0x4, Size: 5968 Bytes
	[125.917]---Loading Partition#: 0x5, Id: 0xB
	[129.858] 0.007 ms for Partition#: 0x5, Size: 80 Bytes
	[134.628]+++Loading Image#: 0x2, Name: pl_cfi, Id: 0x18700000
	[139.908]---Loading Partition#: 0x6, Id: 0x3
	[997.650] 853.804 ms for Partition#: 0x6, Size: 1272512 Bytes
	[1000.229]---Loading Partition#: 0x7, Id: 0x5
	[1288.889] 284.639 ms for Partition#: 0x7, Size: 441248 Bytes
	[1291.507]+++Loading Image#: 0x3, Name: fpd, Id: 0x0420C003
	[1296.643]---Loading Partition#: 0x8, Id: 0x8
	[1301.093] 0.429 ms for Partition#: 0x8, Size: 1104 Bytes
	[1305.705]***********Boot PDI Load: Done***********
	[1310.175]3761.786 ms: ROM Time
	[1312.938]Total PLM Boot Time
	abcdefghABCDEFGH012345677654321ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGH
	Please enter 4 characters from console //Entered characters will not display here


	You have entered following 4 characters from console

	1234
	Successfully ran UartPsv Interrupt Example Test



#### PS-SBSA UART example in polled mode 

Log:

       
	[0.010]PMC_GLOBAL_PMC_ERR1_STATUS: 0x0F000000
	[0.081]PMC_GLOBAL_PMC_ERR2_STATUS: 0x01800000
	[4.180]PLM Initialization Time
	[4.243]***********Boot PDI Load: Started***********
	[4.320]Loading PDI from JTAG
	[4.381]Monolithic/Master Device
	[4.500]0.146 ms: PDI initialization time
	[4.574]+++Loading Image#: 0x1, Name: lpd, Id: 0x04210002
	[4.659]---Loading Partition#: 0x1, Id: 0xC
	[35.977]****************************************
	[40.219]Xilinx Versal Platform Loader and Manager
	[44.630]Release 2021.1   Jul 26 2021  -  04:09:34
	[48.956]Platform Version: v2.0 PMC: v2.0, PS: v2.0
	[53.366]BOOTMODE: 0x0, MULTIBOOT: 0x0
	[56.673]****************************************
	[60.954] 56.185 ms for Partition#: 0x1, Size: 2512 Bytes
	[65.832]---Loading Partition#: 0x2, Id: 0xB
	[70.198] 0.517 ms for Partition#: 0x2, Size: 48 Bytes
	[74.312]---Loading Partition#: 0x3, Id: 0xB
	[114.340] 36.176 ms for Partition#: 0x3, Size: 60592 Bytes
	[116.660]---Loading Partition#: 0x4, Id: 0xB
	[120.613] 0.019 ms for Partition#: 0x4, Size: 5968 Bytes
	[125.481]---Loading Partition#: 0x5, Id: 0xB
	[129.422] 0.007 ms for Partition#: 0x5, Size: 80 Bytes
	[134.195]+++Loading Image#: 0x2, Name: pl_cfi, Id: 0x18700000
	[139.476]---Loading Partition#: 0x6, Id: 0x3
	[996.884] 853.470 ms for Partition#: 0x6, Size: 1272512 Bytes
	[999.461]---Loading Partition#: 0x7, Id: 0x5
	[1285.873] 282.478 ms for Partition#: 0x7, Size: 441248 Bytes
	[1288.490]+++Loading Image#: 0x3, Name: fpd, Id: 0x0420C003
	[1293.621]---Loading Partition#: 0x8, Id: 0x8
	[1298.068] 0.429 ms for Partition#: 0x8, Size: 1104 Bytes
	[1302.675]***********Boot PDI Load: Done***********
	[1307.139]3765.045 ms: ROM Time
	[1309.900]Total PLM Boot Time
	abcdefghABCDEFGH012345677654321ABCDEFGHIJ
	UartPsv Polling Example self test pass

	Please enter 4 characters from console // Entered characters will not display here

	You have entered the following characters
	1234
	Successfully ran UartPsv Polling Example Test

        
## Known issues
If we have more than one UARTLite serial ports in the design please configured the following parameter accordingly in kernel configuration.
	SERIAL_UARTLITE_NR_UARTS = [X]   here 'X' --> Number of Uartlite serial ports in the design

Copyright 2020 Xilinx Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.




