************************************************************************

Vendor: Xilinx 
Current readme.txt Version: 3.2
Date Created: 29June2021

Associated Filename: ug1305-embedded-design-tutorial.zip
Associated Document: ug1305-Versal ACAP Embedded Design Tutorial
Supported Device(s): Versal ACAP
   
*************************************************************************

Disclaimer: 

      This disclaimer is not a license and does not grant any rights to 
      the materials distributed herewith. Except as otherwise provided in 
      a valid license issued to you by Xilinx, and to the maximum extent 
      permitted by applicable law: (1) THESE MATERIALS ARE MADE AVAILABLE 
      "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL 
      WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, 
      INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, 
      NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and 
      (2) Xilinx shall not be liable (whether in contract or tort, 
      including negligence, or under any other theory of liability) for 
      any loss or damage of any kind or nature related to, arising under 
      or in connection with these materials, including for any direct, or 
      any indirect, special, incidental, or consequential loss or damage 
      (including loss of data, profits, goodwill, or any type of loss or 
      damage suffered as a result of any action brought by a third party) 
      even if such damage or loss was reasonably foreseeable or Xilinx 
      had been advised of the possibility of the same.

Critical Applications:

      Xilinx products are not designed or intended to be fail-safe, or 
      for use in any application requiring fail-safe performance, such as 
      life-support or safety devices or systems, Class III medical 
      devices, nuclear facilities, applications related to the deployment 
      of airbags, or any other applications that could lead to death, 
      personal injury, or severe property or environmental damage 
      (individually and collectively, "Critical Applications"). Customer 
      assumes the sole risk and liability of any use of Xilinx products 
      in Critical Applications, subject only to applicable laws and 
      regulations governing limitations on product liability.

THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS 
FILE AT ALL TIMES.

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
 |-- \vck190
 |	\ready_to_test
 |		\qspi_images
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
 |
 |-- \vmk180
 |	\ready_to_test
 |		\qspi_images
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
 |-- \pl
 |	\pl_helloworld
 |        Contains files to build Vivado project for helloworld application
 |        \Readme
 |        Contains steps to build Vivado project
 |	\pl_gpio_uart
 |	  Contains files to build Vivado project for GPIO application
 |	  \Readme
 |   	  Contains steps to build Vivado project
 |-- \Readme
		

3. INSTALLATION AND OPERATING INSTRUCTIONS 

Hardware project creation and device image generation 
	- Set vivado tool version to 2021.1
	- Open Vivado tool
        - Browse to ug1305-embedded-design-tutorial folder. Go to the pl folder.Go to pl_helloworld/pl_gpio_uart folder.
	- In the Tcl Console, type the following command
			/> source ./scripts/create_project.tcl
	- Vivado® tool will open the design, loads the block diagram, and adds the required top file and XDC file to the project
	- In the Flow Navigator pane on the left-hand side under Program and Debug, click Generate Device Image.

4. SUPPORT

To obtain technical support for this reference design, go to 
www.xilinx.com/support to locate answers to known issues in the Xilinx
Answers Database.  
