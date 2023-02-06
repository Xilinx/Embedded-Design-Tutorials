..
   Copyright 2015-2021 Xilinx, Inc.

   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0.

   Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


===============
Getting Started
===============

How Zynq Devices Offer a Single Chip Solution
---------------------------------------------

The Zynq |reg|-7000 SoC comes with a versatile processing system (PS) integrated with a highly flexible and high-performance programmable logic (PL) section, all on a single system-on-a-chip (SoC).

The PS and the PL in Zynq UltraScale+ devices can be tightly or loosely coupled with a variety of high-performance and high-bandwidth PS-PL interfaces.

How Xilinx Software Simplifies Embedded Processor Designs
---------------------------------------------------------

Embedded systems with a processing system and FPGA designs can be complex. Hardware and software portions of an embedded design are projects in themselves. Merging the two design components so that they function as one system creates additional challenges. Add an FPGA design project to the mix, and your design has the potential to become complicated.

The Zynq SoC solution reduces this complexity by offering an Arm |reg| Cortex |trade|-A9 dual core, along with programmable logic, all within a single SoC. To simplify the design process, Xilinx offers the Vitis software platform. This set of tools provides you with everything you need to simplify embedded system design for a device that merges an SoC with an FPGA. This combination of tools offers hardware and software application design, debugging capability, code execution, and transfer of the design onto actual boards for verification and validation.

Vitis Unified Software Platform
-------------------------------

The Vitis |trade| software platform includes all the tools that you need to develop, debug and deploy your embedded applications.

It includes the Vivado Design Suite, that can create hardware designs for SoC. The hardware design includes the PL logic design, the configuration of PS and the connection between PS and PL.

The Vitis IDE and the utilities it provides can develop, debug and create deployment images for embedded application designs.

The Vitis installer also includes PetaLinux. PetaLinux can help to build the embedded Linux environment for Xilinx SoC.

Vivado Design Suite
~~~~~~~~~~~~~~~~~~~

The Vivado |reg| Design Suite provides full features of Xilinx FPGA and SoC hardware design, including code editing, synthesis, implementation, simulation and binary generation. It also provides PS configuration and initialization code generation features.

The Vivado Design Suite has several `editions <https://www.xilinx.com/products/design-tools/vivado/vivado-ml.html#licensing>`_.
The major differences between editions are supported `device architectures <https://www.xilinx.com/products/design-tools/vivado/vivado-ml.html#architecture>`_.
The ZC702 board used in the examples has a XC7Z020 device. It is supported by all Vivado editions. If you are using other devices, check the `device architecture
page <https://www.xilinx.com/products/design-tools/vivado/vivado-ml.html#architecture>`_ to choose your Vivado edition.

XSCT (Xilinx Software Command Tool)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The Vitis software platform provides an IDE (integrated design environment) and a command line interface (XSCT) to help you design and debug embedded software applications and generate deployment images.

PetaLinux Tools
~~~~~~~~~~~~~~~

The PetaLinux tools offer everything necessary to customize, build, and deploy embedded Linux solutions on Xilinx processing systems. For more
information, see the `Embedded Design Tools <https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-design-tools.html>`_
web page.

The PetaLinux Tools design hub provides information and links to documentation specific to the PetaLinux Tools. For more information, see `Embedded Design Hub - PetaLinux Tools <https://www.xilinx.com/cgi-bin/docs/ndoc?t=design%2Bhubs%3Bd%3Ddh0016-petalinux-tools-hub.html>`_.

How the Xilinx Design Tools Expedite the Design Process
-------------------------------------------------------

You can use the Vivado Design Suite tools to add design sources to your hardware. These include the IP integrator, which simplifies the process of adding IP to your existing project and creating connections for ports (such as clock and reset).

You can accomplish all your hardware system development using the Vivado tools along with IP integrator. This includes specification of the microprocessor, peripherals, and the interconnection of these components, along with their respective detailed configuration.

The Vitis software platform is used for software development, and can be installed and used without any other Xilinx tools installed on the machine on which it is loaded. The Vitis software platform can also be used to debug software applications.

The Zynq SoC Processing System (PS) can be booted and made to run without programming the FPGA (programmable logic or PL). However, in order to use any soft IP in the fabric, or to bond out PS peripherals using EMIO, programming of the PL is required. You can program the PL in the Vitis software platform.

For more information on the embedded design process, see the *Vivado Design Suite Tutorial: Embedded Processor Hardware Design* (`UG940 <https://www.xilinx.com/content/dam/xilinx/support/documentation/sw_manuals/xilinx2021_2/ug940-vivado-tutorial-embedded-design.pdf>`_).

Hardware Requirements for this Guide
------------------------------------

This tutorial targets the Zynq ZC702 Rev 1.0 evaluation board, and can also be used for Rev 1.0 boards. To use this guide, you need the following hardware items, which are included with the evaluation board:

-  The ZC702 evaluation board
-  AC power adapter (12 VDC)
-  USB type-A to USB mini-B cable (for UART communications)
-  USB type-A to USB micro cable for programming and debugging using a
   USB-micro JTAG connection
-  SD-MMC flash card for Linux booting
-  Ethernet cable to connect target board with host machine

Installation Requirements
-------------------------

Vitis Software Platform and Vivado Design Suite
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Visit the `Xilinx Download Center <https://www.xilinx.com/support/download.html>`_ to download the Vitis software platform. This tutorial is verified with 2021.2. If you are using other Vitis versions, some features or screenshots might differ.

The Vitis software platform supports Windows and Linux. To install the Vitis software platform, follow the instructions in the `Installation section <https://docs.xilinx.com/r/en-US/ug1400-vitis-embedded/Getting-Started-with-Vitis>`_ of the *Vitis Unified Software Platform Documentation: Embedded Software Development* (`UG1400 <https://docs.xilinx.com/r/en-US/ug1400-vitis-embedded/Getting-Started-with-Vitis>`_). When you install the Vitis software platform, the Vivado Design Suite is installed automatically.

You will use Vivado for hardware design, and you will use Vitis for the development of both Linux applications and standalone software applicationss.

PetaLinux Tools
~~~~~~~~~~~~~~~

The PetaLinux tool offers a full Linux distribution building system which includes the Linux OS as well as a complete configuration, build, and deploy environment for Xilinx silicon.

Install the PetaLinux Tools to run through the embedded Linux portion of this tutorial.

PetaLinux tools run under the Linux host system only. Refer to the “Setting Up Your Environment” chapter in the *PetaLinux Tools Reference Guide* (`UG1144 <https://www.xilinx.com/content/dam/xilinx/support/documentation/sw_manuals/xilinx2021_2/ug1144-petalinux-tools-reference-guide.pdf>`_) for supported operating systems and installation instructions. You can use either a dedicated Linux host system or a virtual machine running one of these Linux operating systems on your Windows development platform.

PetaLinux can be installed from its own installer or from Vitis installer.

Software Licensing
~~~~~~~~~~~~~~~~~~

Xilinx software uses FLEXnet licensing. When the software is first run, it performs a license verification process. If the license verification does not find a valid license, the license wizard guides you through the
process of obtaining a license and ensuring that the license can be used with the tools installed. If you do not need the full version of the software, you can use an evaluation license. For installation instructions and information, see the *Vivado Design Suite User Guide: Release Notes, Installation, and Licensing Guide*
(`UG973 <https://www.xilinx.com/content/dam/xilinx/support/documentation/sw_manuals/xilinx2021_2/ug973-vivado-release-notes-install-license.pdf>`_).

.. _design-files-for-this-tutorial:

Design Files for this Tutorial
------------------------------

The reference design files for this tutorial are provided in the `ref_files <https://github.com/Xilinx/Embedded-Design-Tutorials/tree/master/docs/Introduction/Zynq7000-EDT/ref_files>`_ directory, organized with design number or chapter name. Chapters that need to use reference files will point to the specific `ref_files` subdirectory.

Start with the first examples in the :doc:`next chapter <./2-using-zynq>`.

.. |trade|  unicode:: U+02122 .. TRADEMARK SIGN
   :ltrim:
.. |reg|    unicode:: U+000AE .. REGISTERED TRADEMARK SIGN
   :ltrim:

