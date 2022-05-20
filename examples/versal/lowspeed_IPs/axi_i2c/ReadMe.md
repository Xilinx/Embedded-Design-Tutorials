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

1. Add the .xdc file to constraints in Vivado source from the ./hardware/constraints directory.

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

1. Vitis offers few AXI-I2C based example application projects. These can be selected on the second page of the New Application Project dialogue.

  ## Validation
Here you will place example validation that you've done that the customer can repeat. This improves confidence in the design, and gives a good test for the customer to run initially. Shown below are Linux and Vitis examples:

  ### Linux:

Log:

	/* 16-bytes read operation from 0x0000 location of EEPROM connected to AXI I2C with address 0x50 */
	root@VCK_190_2021_1:~# i2ctransfer -f -y 1 w2@0x50 0x00 0x00 r16@0x50
	0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff

	/*16-bytes write operation from 0x0000 location of EEPROM connected to AXI I2C with address 0x50 */
	root@VCK_190_2021_1:~# i2ctransfer -f -y 1 w18@0x50 0x00 0x00 0x00 0x01 0x02 0x03 0x04 0x05 0x06 0x07 0x08 0x09 0x0A 0x0B 0x0C 0x0D 0x0E 0x0F

	/*16-bytes read operation to verify the previous written data from 0x0000 location of EEPROM connected to AXI IIC with address 0x50*/
	root@VCK_190_2021_1:~# i2ctransfer -f -y 1 w2@0x50 0x00 0x00 r16@0x50
	0x00 0x01 0x02 0x03 0x04 0x05 0x06 0x07 0x08 0x09 0x0a 0x0b 0x0c 0x0d 0x0e 0x0f

	/*16-bytes write operation from 0x1ff0 location of EEPROM connected to AXI I2C with address 0x50 */
	root@VCK_190_2021_1:~# i2ctransfer -f -y 1 w18@0x50 0x1f 0xf0 0x10 0x11 0x12 0x13 0x14 0x15 0x16 0x17 0x18 0x19 0x1A 0x1B 0x1C 0x1D 0x1E 0x1F

	/*16-bytes read operation from 0x1ff0 location of EEPROM connected to AXI I2C with address 0x50 */
	root@VCK_190_2021_1:~# i2ctransfer -f -y 1 w2@0x50 0x1f 0xf0 r16@0x50
	0x10 0x11 0x12 0x13 0x14 0x15 0x16 0x17 0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x1e 0x1f

	/*Single Byte write operation at 0x00f0 location of EEPROM connected to AXI I2C with address 0x50 */
	root@VCK_190_2021_1:~# i2ctransfer -f -y 1 w3@0x50 0x00 0xf0 0xAB

	/*Single Byte read operation at 0x00f0 location of EEPROM connected to AXI I2C with address 0x50 */
	root@VCK_190_2021_1:~# i2ctransfer -f -y 1 w2@0x50 0x00 0xf0 r1@0x50
	0xab

	root@VCK_190_2021_1:~#


### Vitis:

#### AXI-I2C Interrupt mode example

Log:

	[0.010]PMC_GLOBAL_PMC_ERR1_STATUS: 0x0F000000
	[0.081]PMC_GLOBAL_PMC_ERR2_STATUS: 0x01800000
	[4.180]PLM Initialization Time
	[4.243]***********Boot PDI Load: Started***********
	[4.321]Loading PDI from JTAG
	[4.381]Monolithic/Master Device
	[4.500]0.146 ms: PDI initialization time
	[4.573]+++Loading Image#: 0x1, Name: lpd, Id: 0x04210002
	[4.659]---Loading Partition#: 0x1, Id: 0xC
	[35.985]****************************************
	[40.227]Xilinx Versal Platform Loader and Manager
	[44.638]Release 2021.1   Jul 26 2021  -  04:09:34
	[48.965]Platform Version: v2.0 PMC: v2.0, PS: v2.0
	[53.376]BOOTMODE: 0x0, MULTIBOOT: 0x0
	[56.685]****************************************
	[60.966] 56.197 ms for Partition#: 0x1, Size: 2512 Bytes
	[65.847]---Loading Partition#: 0x2, Id: 0xB
	[70.215] 0.517 ms for Partition#: 0x2, Size: 48 Bytes
	[74.331]---Loading Partition#: 0x3, Id: 0xB
	[116.336] 38.152 ms for Partition#: 0x3, Size: 60592 Bytes
	[118.657]---Loading Partition#: 0x4, Id: 0xB
	[122.610] 0.019 ms for Partition#: 0x4, Size: 5968 Bytes
	[127.479]---Loading Partition#: 0x5, Id: 0xB
	[131.420] 0.007 ms for Partition#: 0x5, Size: 80 Bytes
	[136.192]+++Loading Image#: 0x2, Name: pl_cfi, Id: 0x18700000
	[141.475]---Loading Partition#: 0x6, Id: 0x3
	[1000.781] 855.366 ms for Partition#: 0x6, Size: 1272512 Bytes
	[1003.442]---Loading Partition#: 0x7, Id: 0x5
	[1290.549] 283.085 ms for Partition#: 0x7, Size: 441248 Bytes
	[1293.165]+++Loading Image#: 0x3, Name: fpd, Id: 0x0420C003
	[1298.298]---Loading Partition#: 0x8, Id: 0x8
	[1302.744] 0.429 ms for Partition#: 0x8, Size: 1104 Bytes
	[1307.352]***********Boot PDI Load: Done***********
	[1311.820]3772.590 ms: ROM Time
	[1314.580]Total PLM Boot Time
	Successfully ran AXI IIC eeprom Example


## Known Issues
In this section, list any known issues with the design, or any warning messages that might appear which can be safely ignored by the customer.

Copyright 2020 Xilinx Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

