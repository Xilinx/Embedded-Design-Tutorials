<table class="sphinxhide">
 <tr>
   <td align="center"><img src="https://www.xilinx.com/content/dam/xilinx/imgs/press/media-kits/corporate/xilinx-logo.png" width="30%"/><h1>Xilinx Embedded Design Tutorials</h1></a>
   </td>
 </tr>
 <tr>
 <td align=center><h2>Versal&trade; Adaptive Compute Acceleration Platform
 </td>
 </tr>
</table>

 This document provides an introduction for using the Xilinx&reg; Vivado&reg;
 Design Suite flow for a VMK180/VCK190 evaluation board. The tools used
 are Vivado Design Suite and the Vitis&trade; unified software platform,
 version 2020.2. To install the Vitis unified software platform, see *Vitis Unified Software Platform Documentation: Embedded Software Development* ([UG1400](https://www.xilinx.com/cgi-bin/docs/rdoc?v=latest%3Bd%3Dug1400-vitis-embedded.pdf)).

>***Note*:** In this tutorial, the instructions for booting Linux on
 the hardware is specific to the PetaLinux tools released for 2020.2,
 which must be installed on a Linux host machine for exercising the
 Linux portions of this document.

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

- **[Versal ACAP CIPS and NoC (DDR) IP Core Configuration](2-cips-noc-ip-config.md):** Describes creation
     of a design with Versal&trade; ACAP Control, Interfaces, and Processing
     System (CIPS) IP core and an NoC and running a simple "Hello
     World" application on Arm&reg; Cortex&trade;-A72, and Cortex&trade;-R5F
     processors. This chapter is an introduction to the hardware and
     software tools using a simple design as the example.

- **[Debugging Using the Vitis Software Platform](3-debugging.md):** Introduces debugging features of the
     Xilinx Vitis software platform. This chapter uses the previous
     design and runs the software on bare metal (without an OS) to show
     the debugging features of the Vitis IDE. This chapter also lists
     debug configurations for Versal ACAP.

- **[Boot and Configuration](4-boot-and-config.md):** Shows
     integration of components to configure and create boot images for
     Versal ACAP. The purpose of this chapter is to understand how to
     integrate and load boot loaders.

- **[System Design Example using Scalar Engine and Adaptable Engine](5-system-design-example.md):** Describes building a system on
     Versal ACAP using available tools and supported software blocks.
     This chapter demonstrates how to use the Vivado tool to create an
     embedded design using PL AXI GPIO. It also demonstrates the steps
     to configure and build the Linux operating system for an Arm
     Cortex-A72 core- based APU on a Versal device.

 This design tutorial requires use of a number of files provided by
 Xilinx. These are contained in a ZIP file that can be downloaded from
 the Xilinx web site. (See [Getting Started](1-getting-started.md)). The tutorial assumes the contents of
 the ZIP file are extracted to `C:\edt`.
