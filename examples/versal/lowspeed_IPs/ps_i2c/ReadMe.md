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

1. Vitis offers few PS-I2C based example application projects. These can be selected on the second page of the New Application Project dialogue.

  ## Validation
Here you will place example validation that you've done that the customer can repeat. This improves confidence in the design, and gives a good test for the customer to run initially. Shown below are Linux and Vitis examples:

  ### Linux:

Log:

	/*Command to list the i2c controllers in the design*/
	root@VCK_190_2021_1:~# i2cdetect -l
	i2c-1   i2c             xiic-i2c                                I2C adapter
	i2c-0   i2c             Cadence I2C at ff030000                 I2C adapter

	/* EEPROM connected to PS-I2C1 through channel 1 of MUX with address 0x74 so enable the MUX Channel */
	root@VCK_190_2021_1:~# i2ctransfer -f -y 0 w2@0x74 0x00 0x01


	/* 16-bytes Read operation from 0x0000 location of EEPROM address 0x54 */
	root@VCK_190_2021_1:~# i2ctransfer -f -y 0 w2@0x54 0x00 0x00 r16@0x54
	0x0a 0x0b 0x0c 0x0d 0x0e 0x0f 0x10 0x11 0x12 0x13 0x14 0x15 0x16 0x17 0x18 0x19

	/* 16-bytes Write operation from 0x0000 location of EEPROM address 0x54 */
	root@VCK_190_2021_1:~# i2ctransfer -f -y 0 w18@0x54 0x00 0x00 0x00 0x01 0x02 0x03 0x04 0x05 0x06 0x07 0x08 0x09 0x0A 0x0B 0x0C 0x0D 0x0E 0x0F

	/* 16-bytes Read operation to verify previous write operation from 0x0000 location of EEPROM address 0x54 */
	root@VCK_190_2021_1:~# i2ctransfer -f -y 0 w2@0x54 0x00 0x00 r16@0x54
	0x00 0x01 0x02 0x03 0x04 0x05 0x06 0x07 0x08 0x09 0x0a 0x0b 0x0c 0x0d 0x0e 0x0f

	/* 16-bytes Read operation from 0x1ff0 location of EEPROM address 0x54 */
	root@VCK_190_2021_1:~# i2ctransfer -f -y 0 w2@0x54 0x1f 0xf0 r16@0x54
	0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff

	/* 16-bytes write operation from 0x1ff0 location of EEPROM address 0x54 */
	root@VCK_190_2021_1:~# i2ctransfer -f -y 0 w18@0x54 0x1f 0xf0 0x10 0x11 0x12 0x13 0x14 0x15 0x16 0x17 0x18 0x19 0x1A 0x1B 0x1C 0x1D 0x1E 0x1F

	/* 16-bytes Read operation from 0x0000 location of EEPROM address 0x54 */
	root@VCK_190_2021_1:~# i2ctransfer -f -y 0 w2@0x54 0x1f 0xf0 r16@0x54
	0x10 0x11 0x12 0x13 0x14 0x15 0x16 0x17 0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x1e 0x1f

	/* Single byte Read operation from random location of EEPROM address 0x54 */
	root@VCK_190_2021_1:~# i2ctransfer -f -y 0 w2@0x54 0x00 0xf0 r1@0x54
	0xf2

	/* Single byte write operation from random location of EEPROM address 0x54 */
	root@VCK_190_2021_1:~# i2ctransfer -f -y 0 w3@0x54 0x00 0xf0 0xAB

	/* Single byte read to verify previously written operation from random location of EEPROM address 0x54 */
	root@VCK_190_2021_1:~# i2ctransfer -f -y 0 w2@0x54 0x00 0xf0 r1@0x54
	0xab

	root@VCK_190_2021_1:~#

### Vitis:

#### PS-I2C Interrupt mode example

Log:

              0121]****************************************
        [7.069187]Xilinx Versal Platform Loader and Manager
        [11.686725]Release 2020.2 Nov 4 2020 - 15:31:40
        [16.304371]Platform Version: v2.0 PMC: v2.0, PS: v2.0
        [21.006371]BOOTMODE: 0, MULTIBOOT: 0x0
        [24.426696]****************************************
        [28.981884] 24.647850 ms for PrtnNum: 1, Size: 2192 Bytes
        [34.004462]-------Loading Prtn No: 0x2
        [37.963734] 0.521859 ms for PrtnNum: 2, Size: 48 Bytes
        [42.214453]-------Loading Prtn No: 0x3
        [79.016190] 33.359462 ms for PrtnNum: 3, Size: 57136 Bytes
        [81.339931]-------Loading Prtn No: 0x4
        [84.788037] 0.012521 ms for PrtnNum: 4, Size: 2512 Bytes
        [89.719068]-------Loading Prtn No: 0x5
        [93.168540] 0.014309 ms for PrtnNum: 5, Size: 3424 Bytes
        [98.097196]-------Loading Prtn No: 0x6
        [101.539993] 0.007778 ms for PrtnNum: 6, Size: 80 Bytes
        [106.440065]+++++++Loading Image No: 0x2, Name: pl_cfi, Id: 0x18700000
        [112.545893]-------Loading Prtn No: 0x7
        [636.093303] 520.020565 ms for PrtnNum: 7, Size: 767712 Bytes
        [638.674965]-------Loading Prtn No: 0x8
        [737.232784] 95.029318 ms for PrtnNum: 8, Size: 149936 Bytes
        [739.762328]+++++++Loading Image No: 0x3, Name: fpd, Id: 0x0420C003
        [745.632537]-------Loading Prtn No: 0x9
        [749.322215] 0.163725 ms for PrtnNum: 9, Size: 1008 Bytes
        [754.241087]***********Boot PDI Load: Done*************
        [759.083046]3773.220896 ms: ROM Time
        [762.318040]Total PLM Boot Time
        IIC EEPROM Interrupt Example Test
        Page size 64
        Successfully ran IIC EEPROM Interrupt Example Test
        
 #### PS-I2C polled mode example

Log:

        423700]****************************************
        [7.062093]Xilinx Versal Platform Loader and Manager
        [11.678637]Release 2020.2 Nov 4 2020 - 15:31:40
        [16.296090]Platform Version: v2.0 PMC: v2.0, PS: v2.0
        [20.998587]BOOTMODE: 0, MULTIBOOT: 0x0
        [24.419584]****************************************
        [28.975918] 24.642096 ms for PrtnNum: 1, Size: 2192 Bytes
        [33.998778]-------Loading Prtn No: 0x2
        [37.958487] 0.521653 ms for PrtnNum: 2, Size: 48 Bytes
        [42.209012]-------Loading Prtn No: 0x3
        [79.468743] 33.816306 ms for PrtnNum: 3, Size: 57136 Bytes
        [81.792931]-------Loading Prtn No: 0x4
        [85.242909] 0.012521 ms for PrtnNum: 4, Size: 2512 Bytes
        [90.178056]-------Loading Prtn No: 0x5
        [93.629903] 0.014309 ms for PrtnNum: 5, Size: 3424 Bytes
        [98.560812]-------Loading Prtn No: 0x6
        [102.003750] 0.007778 ms for PrtnNum: 6, Size: 80 Bytes
        [106.904553]+++++++Loading Image No: 0x2, Name: pl_cfi, Id: 0x18700000
        [113.011981]-------Loading Prtn No: 0x7
        [633.900000] 517.359431 ms for PrtnNum: 7, Size: 767712 Bytes
        [636.480625]-------Loading Prtn No: 0x8
        [736.175746] 96.168334 ms for PrtnNum: 8, Size: 149936 Bytes
        [738.705150]+++++++Loading Image No: 0x3, Name: fpd, Id: 0x0420C003
        [744.575471]-------Loading Prtn No: 0x9
        [748.264493] 0.163596 ms for PrtnNum: 9, Size: 1008 Bytes
        [753.184971]***********Boot PDI Load: Done*************
        [758.027659]3718.868496 ms: ROM Time
        [761.262900]Total PLM Boot Time
        IIC EEPROM Polled Mode Example Test
        Page size 64
        Successfully ran IIC EEPROM Polled Mode Example Test

## Known Issues
In this section, list any known issues with the design, or any warning messages that might appear which can be safely ignored by the customer.

Copyright 2020 Xilinx Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


