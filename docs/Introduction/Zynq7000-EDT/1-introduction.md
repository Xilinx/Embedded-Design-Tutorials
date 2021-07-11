# Getting Started

## How Zynq Devices Offer a Single Chip Solution

The Zynq SoC comes with a versatile processing system (PS) integrated with a highly flexible and high-performance programmable logic (PL) section, all on a single system-on-a-chip (SoC).

The PS and the PL in Zynq UltraScale+ devices can be tightly or loosely coupled with a variety of high-performance and high-bandwidth PS-PL interfaces.

## How Xilinx Software Simplifies Embedded Processor Designs

Embedded systems with a processing system and FPGA designs can be complex. Hardware and software portions of an embedded design are projects in themselves. Merging the two design components so that they function as one system creates additional challenges. Add an FPGA design project to the mix, and your design has the potential to become complicated.

The Zynq SoC solution reduces this complexity by offering an Arm&reg; Cortex&trade;-A9 dual core, along with programmable logic, all within a single SoC. To simplify the design process, Xilinx offers the Vitis software platform. This set of tools provides you with everything you need to simplify embedded system design for a device that merges an SoC with an FPGA. This combination of tools offers hardware and software application design, debugging capability, code execution, and transfer of the design onto actual boards for verification and validation.

## Vitis Unified Software Platform

The Vitis&trade; software platform includes all the tools that you need to develop, debug and deploy your embedded applications.

It includes the Vivado Design Suite, that can create hardware designs for SoC. The hardware design includes the PL logic design, the configuration of PS and the connection between PS and PL.

The Vitis IDE and the utilities it provides can develop, debug and create deployment images for embedded application designs.

The Vitis installer also includes PetaLinux. PetaLinux can help to build the embedded Linux environment for Xilinx SoC.

### Vivado&reg; Design Suite

The Vivado Design Suite provides full features of Xilinx FPGA and SoC hardware design, including code editing, synthesis, implementation, simulation and binary generation. It also provides the PS configuration and initialization code generation features.

Vivado Design Suite [editions][2] has several editions. The major differences between editions are supported [device architectures][3]. The board ZC702 that we use in the examples has a XC7Z020 device. It's supported by all Vivado editions. If you are using other devices, please check the [device architecture page][3] to choose your Vivado edition. 

[2]:https://www.xilinx.com/products/design-tools/vivado/vivado-ml.html#licensing
[3]:https://www.xilinx.com/products/design-tools/vivado/vivado-ml.html#architecture


### Vitis IDE and XSCT (Xilinx Software Command Tool)

Vitis software platform provides an IDE (Integrated Design Environment) and a command line interface (XSCT) to help users to design and debug the embedded software application, and generate the deployment images.



### PetaLinux Tools

The PetaLinux tools offer everything necessary to customize, build, and deploy embedded Linux solutions on Xilinx processing systems. For more information, see the [Embedded Design Tools](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-design-tools.html) web page.

The PetaLinux Tools design hub provides information and links to documentation specific to the PetaLinux Tools. For more information, see [Embedded Design Hub - PetaLinux Tools](https://www.xilinx.com/cgi-bin/docs/ndoc?t=design%2Bhubs%3Bd%3Ddh0016-petalinux-tools-hub.html).


## How the Xilinx Design Tools Expedite the Design Process

You can use the Vivado Design Suite tools to add design sources to your hardware. These include the IP integrator, which simplifies the process of adding IP to your existing project and creating connections for ports (such as clock and reset).

You can accomplish all your hardware system development using the Vivado tools along with IP integrator. This includes specification of the microprocessor, peripherals, and the interconnection of these components, along with their respective detailed configuration.

The Vitis software platform is used for software development, and can be installed and used without any other Xilinx tools installed on the machine on which it is loaded. The Vitis software platform can also be used to debug software applications.

The Zynq SoC Processing System (PS) can be booted and made to run without programming the FPGA (programmable logic or PL). However, in order to use any soft IP in the fabric, or to bond out PS peripherals using EMIO, programming of the PL is required. You can program the PL in the Vitis software platform.

For more information on the embedded design process, see the *Vivado Design Suite Tutorial: Embedded Processor Hardware Design* ([UG940](https://www.xilinx.com/cgi-bin/docs/rdoc?v=2021.1%3Bd%3Dug940-vivado-tutorial-embedded-design.pdf)).

## Hardware Requirements for this Guide

This tutorial targets the Zynq ZC702 Rev 1.0 evaluation board, and can also be used for Rev 1.0 boards. To use this guide, you need the following hardware items, which are included with the evaluation board:

-   The ZC702 evaluation board
-   AC power adapter (12 VDC)
-   USB Type-A to USB Mini-B cable (for UART communications)
-   USB Type-A to USB Micro cable for programming and debugging via USB-Micro JTAG connection
-   SD-MMC flash card for Linux booting
-   Ethernet cable to connect target board with host machine

## Installation Requirements

### Vitis Software Platform and Vivado Design Suite

Visit the [Xilinx Download Center](https://www.xilinx.com/support/download.html) to download the Vitis Software Platform. This tutorial is verified with 2021.1. If you're using other Vitis versions, some features or screenshots may have some differences.

Vitis software platform supports Windows and Linux. To install the Vitis software platform, follow the instructions in the [Installation section][1] of the
*Vitis Unified Software Platform Documentation: Embedded Software Development* ([UG1400](https://www.xilinx.com/html_docs/xilinx2021_1/vitis_doc/hly1569525384514.html)). When you install the Vitis software platform, the Vivado Design Suite is installed automatically.

You will use Vivado to do hardware design and Vitis to do standalone software application development and Linux application development.

[1]:https://www.xilinx.com/html_docs/xilinx2021_1/vitis_doc/vitis_embedded_installation.html#tlp1602134446371

### PetaLinux Tools

The PetaLinux tool offers a full Linux distribution building system which includes the Linux OS as well as a complete configuration, build, and deploy environment for Xilinx silicon.

Install the PetaLinux Tools to run through the embedded Linux portion of this tutorial.

PetaLinux tools run under the Linux host system only. Please refer to the [PetaLinux Document UG1144](https://www.xilinx.com/cgi-bin/docs/rdoc?v=2021.1%3Bd%3Dug1144-petalinux-tools-reference-guide.pdf), chapter *Setting Up Your Environment* for the supported Operating System and the installation instructions. This can use either a dedicated Linux host system or a virtual machine running one of these Linux operating systems on your Windows development platform.

PetaLinux can be installed from its own installer or from Vitis installer.

### Software Licensing

Xilinx software uses FLEXnet licensing. When the software is first run, it performs a license verification process. If the license verification does not find a valid license, the license wizard guides you through the process of obtaining a license and ensuring that the license can be used with the tools installed. If you do not need the full version of the software, you can use an evaluation license.For installation instructions and information, see the *Vivado Design Suite User Guide: Release Notes, Installation, and Licensing* ([UG973](https://www.xilinx.com/cgi-bin/docs/rdoc?v=2021.1%3Bt%3Dvivado%2Binstall%2Bguide)).

## Design Files for this Tutorial

The reference design files for this tutorial are provided in the [ref_files](https://github.com/Xilinx/Embedded-Design-Tutorials/tree/master/docs/Introduction/Zynq7000-EDT/ref_files) directory, organized with design number or chapter name. Chapters that need to use reference files will point to the specific **ref_files** subdirectory.


Start with the first examples in the [next chapter](./2-using-zynq.md).

------

© Copyright 2015–2021 Xilinx, Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
