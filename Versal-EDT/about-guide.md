# About the Guide

 This document provides an introduction for using the Xilinx&reg; Vivado&reg;
 Design Suite flow for a Versal&trade; VMK180/VCK190 evaluation board. The tools used
 are Vivado Design Suite and the Vitis&trade; unified software platform,
 version 2020.2. To install the Vitis unified software platform, see *Vitis Unified Software Platform Documentation: Embedded Software Development* ([UG1400](https://www.xilinx.com/cgi-bin/docs/rdoc?v=latest%3Bd%3Dug1400-vitis-embedded.pdf)).

>**Note:** *In this tutorial, the instructions for booting Linux on
 the hardware is specific to the PetaLinux tools released for 2020.2,
 which must be installed on a Linux host machine for exercising the
 Linux portions of this document.*

 >**IMPORTANT!** *The VCK190/VMK180 Evaluation kit has a Silicon Labs
 CP210x VCP USB-UART Bridge. Ensure that these drivers are installed.
 See the Silicon Labs CP210x USB-to-UART Installation Guide
 ([UG1033](https://www.xilinx.com/cgi-bin/docs/bkdoc?k=install%3Bd%3Dug1033-cp210x-usb-uart-install.pdf))
 for more information.*

 The examples in this document are created using the Xilinx tools
 running on a Windows 10, 64-bit operating system, Vitis software
 platform and PetaLinux on a Linux 64-bit operating system. Other
 versions of the tools running on other Windows installs might provide
 varied results. These examples focus on introducing you to the following aspects of
 embedded design.

- **[Versal ACAP CIPS and NoC (DDR) IP Core Configuration](../Versal-EDT/docs/2-cips-noc-ip-config.md):** Describes creation
     of a design with Versal&trade; ACAP Control, Interfaces, and Processing
     System (CIPS) IP core and an NoC and running a simple "Hello
     World" application on Arm&reg; Cortex&trade;-A72, and Cortex&trade;-R5F
     processors. This chapter is an introduction to the hardware and
     software tools using a simple design as the example.

- **[Debugging Using the Vitis Software Platform](../Versal-EDT/docs/3-debugging.md):** Introduces debugging features of the
     Xilinx Vitis software platform. This chapter uses the previous
     design and runs the software on bare metal (without an OS) to show
     the debugging features of the Vitis IDE. This chapter also lists
     debug configurations for Versal ACAP.

- **[Boot and Configuration](../Versal-EDT/docs/4-boot-and-config.md):** Shows
     integration of components to configure and create boot images for
     Versal ACAP. The purpose of this chapter is to understand how to
     integrate and load boot loaders.

- **[System Design Example using Scalar Engine and Adaptable Engine](../Versal-EDT/docs/5-system-design-example.md):** Describes building a system on
     Versal ACAP using available tools and supported software blocks.
     This chapter demonstrates how to use the Vivado tool to create an
     embedded design using PL AXI GPIO. It also demonstrates the steps
     to configure and build the Linux operating system for an Arm
     Cortex-A72 core- based APU on a Versal device.

 This design tutorial requires use of a number of files provided by
 Xilinx. These are contained in a ZIP file that can be downloaded from
 the Xilinx web site. (See [Getting Started](../Versal-EDT/docs/1-getting-started.md)). The tutorial assumes the contents of
 the ZIP file are extracted to `C:\edt`.

 ## Navigating Content by Design Process

 Xilinx&reg; documentation is organized around a set of standard design processes to help you find
relevant content for your current development task. This document covers the following design
processes:

* **System and Solution Planning**: Identifying the components, performance, I/O, and data transfer requirements at a system level. Includes application mapping for the solution to PS, PL, and AI Engine.

  * [Configuring the NoC IP Core in an Existing Project](/Versal-EDT/docs/2-cips-noc-ip-config.md#configuring-the-noc-ip-core-in-an-existing-project)
  * [System Design Example using Scalar Engine and Adaptable Engine](..Versal-EDT/docs/5-system-design-example.md)

* **Embedded Software Development**: Creating the software platform from the hardware
platform and developing the application code using the embedded CPU. Also covers XRT and Graph APIs.

  * [Running a Bare-Metal Hello World Application](../Versal-EDT/docs/2-cips-noc-ip-config.md#running-a-bare-metal-hello-world-application)
  * [Running Applications in the JTAG Mode using the System Debugger in the Vitis Software Platform](../Versal-EDT/docs/2-cips-noc-ip-config.md#running-applications-in-the-jtag-mode-using-the-system-debugger-in-the-vitis-software-platform)
  * [Running a Bare-Metal Hello World Application on DDR Memory](../Versal-EDT/docs/2-cips-noc-ip-config.md#running-a-bare-metal-hello-world-application-on-ddr-memory)

* **Hardware, IP, and Platform Development**: Creating the PL IP blocks for the hardware platform, creating PL kernels, subsystem functional simulation, and evaluating the Vivado® timing, resource use, and power closure. Also involves developing the hardware platform for system integration. Topics in this document that apply to this design process include:

  * [CIPS IP Core Configuration](../Versal-EDT/docs/2-cips-noc-ip-config.md#cips-ip-core-configuration)
  * [NoC (and DDR) IP Core Configuration](../Versal-EDT/docs/2-cips-noc-ip-config.md#noc-and-ddr-ip-core-configuration)
  * [Design Example: Using AXI GPIO](../Versal-EDT/docs/5-system-design-example.md#design-example-using-axi-gpio)

* **System Integration and Validation**: Integrating and validating the system functional performance, including timing, resource use, and power closure. Topics in this document that apply to this design process include:

  * [Boot and Configuration](../Versal-EDT/docs/4-boot-and-config.md)
  * [Example Project: FreeRTOS GPIO Application Project With RPU](../Versal-EDT/docs/5-system-design-example.md#example-project-freertos-gpio-application-project-with-rpu)
  * [Example Project: Creating Linux Images Using PetaLinux](../Versal-EDT/docs/5-system-design-example.md#example-project-creating-linux-images-using-petalinux)
