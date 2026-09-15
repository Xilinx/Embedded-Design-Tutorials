*************************************************************************
     
 © Copyright 2026 Advanced Micro Devices, Inc. All rights reserved.
 This file contains confidential and proprietary information of 
 Advanced Micro Devices, Inc. and is protected under U.S. and 
 international copyright and other intellectual property laws. 

 
*************************************************************************

Vendor: AMD 
Current readme.txt Version: 1.0
Date Last Modified: 28AUG2026
Date Created: 09JUL2026

Associated Filename: ug1305-embedded-design-tutorial.zip
Associated Document: UG1305 Versal Adaptive SoC Embedded Design Tutorial 

Supported Device(s): Versal Adaptive SoC
  
*************************************************************************

Disclaimer: 

      This disclaimer is not a license and does not grant any rights to 
      the materials distributed herewith. Except as otherwise provided in 
      a valid license issued to you by AMD, and to the maximum extent 
      permitted by applicable law: (1) THESE MATERIALS ARE MADE AVAILABLE 
      "AS IS" AND WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL 
      WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, 
      INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, 
      NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and 
      (2) AMD shall not be liable (whether in contract or tort, 
      including negligence, or under any other theory of liability) for 
      any loss or damage of any kind or nature related to, arising under 
      or in connection with these materials, including for any direct, or 
      any indirect, special, incidental, or consequential loss or damage 
      (including loss of data, profits, goodwill, or any type of loss or 
      damage suffered as a result of any action brought by a third party) 
      even if such damage or loss was reasonably foreseeable or AMD 
      had been advised of the possibility of the same.

Critical Applications:

      AMD products are not designed or intended to be fail-safe, or 
      for use in any application requiring fail-safe performance, such as 
      life-support or safety devices or systems, Class III medical 
      devices, nuclear facilities, applications related to the deployment 
      of airbags, or any other applications that could lead to death, 
      personal injury, or severe property or environmental damage 
      (individually and collectively, "Critical Applications"). Customer 
      assumes the sole risk and liability of any use of AMD products 
      in Critical Applications, subject only to applicable laws and 
      regulations governing limitations on product liability.

THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS 
FILE AT ALL TIMES.

******************************************************************************** 



This readme file contains these sections:

1. REVISION HISTORY
2. DESIGN FILE HIERARCHY
3. INSTALLATION AND OPERATING INSTRUCTIONS
4. SUPPORT



1. REVISION HISTORY 

                 Readme  
Date             Version      Revision Description
========================================================================
07November2019     1.0         INITIAL RELEASE
03JUNE2020	   2.0         AXI GPIO UPDATE WITH BOARD FILES
24NOV2020	   3.0         AXI GPIO and FREERTOS APPLICATION UPDATE
23FEB2021	   3.1         UPDATED BOOTGEN.BIF AND FREERTOS BINARIES
22JUNE2021	   3.2         UPDATED VCK190,VMK180 PRODUCTION SILICON BOARD FILES
			       AND APPLICATION BINARIES FOR OSPI, EMMC
28Oct2021	   3.3         UPDATED VCK190,VMK180 PRODUCTION SILICON BOARD FILES
			       AND APPLICATION BINARIES for 2021.2 release
22APR2022      3.4 	       UPDATED VCK190,VMK180 PRODUCTION SILICON BOARD FILES
			       AND APPLICATION BINARIES for 2022.1 release	
23JAN2023      3.5	       UPDATED VPK180 PRODUCTION SILICON BOARD FILES
			       AND APPLICATION BINARIES for 2022.2 release
10JUN2023	   3.6			   UPDATED VPK180 PRODUCTION SILICON BOARD FILES
                   AND APPLICATION BINARIES for 2023.1 release			
01OCT2024	   3.7		   	   UPDATED VPK180 PRODUCTION SILICON BOARD FILES
                   AND APPLICATION BINARIES for 2024.1 release
				   
28AUG2026      3.8       Updated CED design methodology and design files for the 
						2026.1 release on VCK190, VMK180, and VPK180 evaluation platforms
						AND APPLICATION BINARIES for 2026.1 release
========================================================================


2. DESIGN FILE HIERARCHY

The directory structure underneath this top-level folder is described below:

\ug1305-embedded-design-tutorial
 |-- \ch5_system_design_example_source__files
 |	\apu
 |		\device_tree
 |			Contains system_user.dtsi for APU
 |
 |		\gpiotest_app
 |			Contains gpio test application source files.
 |
 |		\bootgen.bif
 |			Contains bif file for generating BOOT.BIN consits of both Petalinux APU 
 |			and FreeRTOS RPU images.
 |	\rpu
 |		contains source files for FreeRTOS RPU application for AXI UART	
 |-- \ch7_system_design_example_source__files
 |	\apu
 |		\device_tree
 |			Contains system_user.dtsi for APU
 |
 |		\gpiotest_app
 |			Contains gpio test application source files.
 |
 |		\bootgen.bif
 |			Contains bif file for generating BOOT.BIN consits of Petalinux APU images.
 |	\rpu
 |		contains source files for FreeRTOS RPU application for AXI UART	
 |-- \vck190
 |	\ready_to_test
 |			\linux
 |				 Contains binaries for the linux application
 |	
 |			\standalone
 |					\apu
 |						Contains binaries for the baremetal APU application
 |					\rpu
 |						Contains binaries for the baremetal RPU application
 |			\freertos
 |				\apu
 |					Contains bif file and binaries for freertos APU application.
 |				\rpu
 |					Contains bif file and binaries for freertos RPU application.
 |			\prebuild_xsa
 |				Contains .xsa file generated from Vivado
 |				 
 |       
 |	\edt_versal.tcl            -Script file which creates the reference design design for vck190 platform.
 |	\edf_base_pl_wrapper.v     -Design source file used by edt_versal.tcl .
 |	\edf_base_pl_wrapper.dcp   -design checkpoint file used by edt_versal.tcl
 |	These files are required to recreate and build the Vivado project for the VCK190 evaluation platform.
 
 |-- \vmk180
 |	\ready_to_test
 |			\linux
 |				 Contains binaries for the linux application
 |	
 |			\standalone
 |					\apu
 |						Contains binaries for the baremetal APU application
 |					\rpu
 |						Contains binaries for the baremetal RPU application
 |			\freertos
 |				\apu
 |					Contains binaries bif file and binaries for freertos APU application.
 |				\rpu
 |					Contains binaries bif file and binaries for freertos RPU application.
 |						
 |			\prebuild_xsa
 |				Contains .xsa file generated from Vivado
 |
 |
 |
 |	\edt_versal.tcl            -Script file which creates the reference design design for vmk180 platform.
 |	\edf_base_pl_wrapper.v     -Design source file used by edt_versal.tcl .
 |	\edf_base_pl_wrapper.dcp   -design checkpoint file used by edt_versal.tcl
 |	These files are required to recreate and build the Vivado project for the VMK180 evaluation platform.
 |
 |
 |-- \vpk180
 |	\ready_to_test
 |		\linux
 |			 Contains binaries for the linux application
 |		\standalone
 |				\apu
 |					Contains binaries for the baremetal APU application
 |				\rpu
 |					Contains binaries for the baremetal RPU application
 |		\freertos
 |			\apu
 |					Contains binaries bif file and binaries for freertos APU application.
 |				\rpu
 |					Contains binaries bif file and binaries for freertos RPU application.
 | 		\prebuild_xsa
 | 			Contains .xsa file generated from Vivado
 |
 |
 |	\edt_versal.tcl            -Script file which creates the reference design design for vpk180 platform.
 |	\edf_base_pl_wrapper.v     -Design source file used by edt_versal.tcl .
 |	\edf_base_pl_wrapper.dcp   -design checkpoint file used by edt_versal.tcl
 |	These files are required to recreate and build the Vivado project for the VPK180 evaluation platform.
 | 			
 |
 |	
 |-- 
		
		
3. INSTALLATION AND OPERATING INSTRUCTIONS 

Hardware project creation and device image generation for vck190 Platform
	- Set vivado tool version to 2026.1
	- Open the Vivado software,Click Run TCL Console under the Window Tab
    - In the Tcl Console,change to the vck190 folder with the change directory command
	- Execute the following command:
		vivado -mode batch -source edt_versal.tcl 
    - The edt_versal folder is created with all the reference design files.
	- In the Flow Navigator pane on the left-hand side under Program and Debug, click Generate Device Image.

Hardware project creation and device image generation for vmk180 Platform
	- Set vivado tool version to 2026.1
	- Open the Vivado software,Click Run TCL Console under the Window Tab
    - In the Tcl Console,change to the vmk180 folder with the change directory command
	- Execute the following command:
		vivado -mode batch -source edt_versal.tcl 
    - The edt_versal folder is created with all the reference design files.
	- In the Flow Navigator pane on the left-hand side under Program and Debug, click Generate Device Image.

Hardware project creation and device image generation for vpk180 Platform
	- Set vivado tool version to 2026.1
	- Open the Vivado software,Click Run TCL Console under the Window Tab
    - In the Tcl Console,change to the vpk180 folder with the change directory command
	- Execute the following command:
		vivado -mode batch -source edt_versal.tcl 
    - The edt_versal folder is created with all the reference design files.
	- In the Flow Navigator pane on the left-hand side under Program and Debug, click Generate Device Image.



4. SUPPORT

To obtain technical support for this reference design, go to 
www.xilinx.com/support to locate answers to known issues in the Answers Database.  



