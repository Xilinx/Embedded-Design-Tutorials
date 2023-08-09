******************************************************************************
# Copyright (C) 2022 - 2023, Advanced Micro Devices, Inc. All rights reserved. 
# SPDX-License-Identifier: MIT
******************************************************************************

Vendor: Advanced Micro Devices, Inc
Current readme.txt Version: 3.5
Date Created: 23JAN2023

Associated Filename: ug1305-embedded-design-tutorial.zip
Associated Document: UG1305 Versal Adaptive SoC Embedded Design Tutorial
Supported Device(s): Versal Adaptive SoC
   
*************************************************************************


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
22APR2022          3.4 	       UPDATED VCK190,VMK180 PRODUCTION SILICON BOARD FILES
			       AND APPLICATION BINARIES for 2022.1 release	
23JAN2023          3.5	       UPDATED VPK180 PRODUCTION SILICON BOARD FILES
			       AND APPLICATION BINARIES for 2022.2 release
10JUN2023	   3.6			   UPDATED VPK180 PRODUCTION SILICON BOARD FILES
                   AND APPLICATION BINARIES for 2023.1 release				   
========================================================================


2. DESIGN FILE HIERARCHY

The directory structure underneath this top-level folder is described 
below:

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
 |		\sd_qspi_images
 |			\linux
 |				 Contains binaries for the linux application to toggle GPIO
 |	
 |			\standalone
 |				\cips
 |					\apu
 |						Contains binaries for the baremetal APU application
 |					\rpu
 |						Contains binaries for the baremetal RPU application
 |				\cips_noc 
 |					\apu
 |						Contains binaries for the baremetal APU application
 |					\rpu
 |						Contains binaries for the baremetal RPU application
 |			\freertos
 |				Contains bif file and binaries for freertos GPIO application.
 |		\ospi_images
 |			\linux
 |				 Contains binaries for the linux application to toggle GPIO
 |		\emmc_images
 |			\linux
 |				 Contains binaries for the linux application to toggle GPIO
 |	\pl
 |		\pl_helloworld
 |        		Contains files to build Vivado project for helloworld application
 |        	\Readme
 |        		Contains steps to build Vivado project
 |		\pl_gpio_uart
 |	  		Contains files to build Vivado project for PL AXI GPIO and PL AXI UART application
 |	  	\Readme
 |   	  		Contains steps to build Vivado project
 |-- \vmk180
 |	\ready_to_test
 |		\sd_qspi_images
 |			\linux
 |				 Contains binaries for the linux application to toggle GPIO
 |	
 |			\standalone
 |				\cips
 |					\apu
 |						Contains binaries for the baremetal APU application
 |					\rpu
 |						Contains binaries for the baremetal RPU application
 |				\cips_noc 
 |					\apu
 |						Contains binaries for the baremetal APU application
 |					\rpu
 |						Contains binaries for the baremetal RPU application
 |			\freertos
 |				Contains bif file and binaries for freertos GPIO application.
 |		\ospi_images
 |			\linux
 |				 Contains binaries for the linux application to toggle GPIO
 |		\emmc_images
 |			\linux
 |				 Contains binaries for the linux application to toggle GPIO
 |	\pl
 |		\pl_helloworld
 |        		Contains files to build Vivado project for helloworld application
 |        	\Readme
 |        		Contains steps to build Vivado project
 |		\pl_gpio_uart
 |	  		Contains files to build Vivado project for PL AXI GPIO and PL AXI UART application
 |	  	\Readme
 |   	  		Contains steps to build Vivado project
 |-- \vpk180
 |	\ready_to_test
 |		\sd_qspi_images
 |			\linux
 |				 Contains binaries for the linux application to toggle GPIO of all 4 LEDs connected to all Slave SLR
 |	
 |			\standalone
 |				\cips
 |					\apu
 |						Contains binaries for the baremetal APU application
 |					\rpu
 |						Contains binaries for the baremetal RPU application
 |				\cips_noc 
 |					\apu
 |						Contains binaries for the baremetal APU application
 |					\rpu
 |						Contains binaries for the baremetal RPU application
 |			\freertos
 |				Contains bif file and binaries for freertos GPIO application.
 |
 |	\pl
 |		\pl_gpio_uart
 |	  		Contains files to build Vivado project for PL AXI GPIO and PL AXI UART application
 |	  	\Readme
 |   	  		Contains steps to build Vivado project
 |-- \Readme
		

3. INSTALLATION AND OPERATING INSTRUCTIONS 

Hardware project creation and device image generation 
	- Set vivado tool version to 2023.1
	- Open Vivado tool
        - Browse to ug1305-embedded-design-tutorial folder. Go to the pl folder.Go to pl_helloworld/pl_gpio_uart folder.
	- In the Tcl Console, type the following command
			/> source ./scripts/create_project.tcl
	- Vivado™ tool will open the design, loads the block diagram, and adds the required top file and XDC file to the project
	- In the Flow Navigator pane on the left-hand side under Program and Debug, click Generate Device Image.

4. SUPPORT

To obtain technical support for this reference design, go to 
www.xilinx.com/support to locate answers to known issues in the Xilinx
Answers Database.  