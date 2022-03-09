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

![SS0_LINUX_LOG](https://user-images.githubusercontent.com/74894579/157438774-d6b97f18-0ad1-4b97-82f5-0f2d874960f5.JPG)

ILA Scopshots:
![SS0_LINUX](https://user-images.githubusercontent.com/74894579/157438969-fdcd67e1-0837-4a9b-be1f-8d6cb9a9d376.JPG)
	
### Vitis:

       
 #### PS-SPI polled mode example

Log:
[0.015]****************************************
[0.072]Xilinx Versal Platform Loader and Manager
[0.130]Release 2021.2   Mar  7 2022  -  19:27:19
[0.189]Platform Version: v2.0 PMC: v2.0, PS: v2.0
[0.255]BOOTMODE: 0x0, MULTIBOOT: 0x0
[0.309]****************************************
[0.518]Non Secure Boot
[3.739]PLM Initialization Time
[3.790]***********Boot PDI Load: Started***********
[3.852]Loading PDI from SBI
[3.900]Monolithic/Master Device
[3.995]0.117 ms: PDI initialization time
[4.054]+++Loading Image#: 0x1, Name: lpd, Id: 0x04210002
[4.122]---Loading Partition#: 0x1, Id: 0xC
[53.639] 49.429 ms for Partition#: 0x1, Size: 2416 Bytes
[58.465]---Loading Partition#: 0x2, Id: 0xB
[62.818] 0.513 ms for Partition#: 0x2, Size: 48 Bytes
[66.940]---Loading Partition#: 0x3, Id: 0xB
[108.396] 37.613 ms for Partition#: 0x3, Size: 61312 Bytes
[110.707]---Loading Partition#: 0x4, Id: 0xB
[115.509] 0.875 ms for Partition#: 0x4, Size: 5968 Bytes
[119.524]---Loading Partition#: 0x5, Id: 0xB
[123.454] 0.004 ms for Partition#: 0x5, Size: 80 Bytes
[128.224]+++Loading Image#: 0x2, Name: pl_cfi, Id: 0x18700000
[133.511]---Loading Partition#: 0x6, Id: 0x3
[1294.287] 1156.848 ms for Partition#: 0x6, Size: 910544 Bytes
[1296.940]---Loading Partition#: 0x7, Id: 0x5
[2599.145] 1298.192 ms for Partition#: 0x7, Size: 435840 Bytes
[2601.831]+++Loading Image#: 0x3, Name: fpd, Id: 0x0420C003
[2606.971]---Loading Partition#: 0x8, Id: 0x8
[2611.384] 0.401 ms for Partition#: 0x8, Size: 1104 Bytes
[2616.015]***********Boot PDI Load: Done***********
[2620.483]8775.101 ms: ROM Time
[2623.249]Total PLM Boot Time
[11400.008]XPlm_KeepAliveTask ERROR: PSM is not alive
[11401.904]PLM Error Status: 0x02080000
SPI EEPROM Polled Mode Example Test
Successfully ran SPI EEPROM Polled Mode Example Test

ILA Scopeshots:
![SS0_BM](https://user-images.githubusercontent.com/74894579/157439090-aecb3ed8-153c-457c-b5d8-0c6d139b2399.JPG)

## Note
Since there is no slave device over the VCK190 card IOs are routed through EMIO b/w both the controllers to check the clock, ss, data over MOSI.
Please find the corresponding ILA scope shots in the log.


## Known Issues
In this section, list any known issues with the design, or any warning messages that might appear which can be safely ignored by the customer


Copyright 2020 Xilinx Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.



