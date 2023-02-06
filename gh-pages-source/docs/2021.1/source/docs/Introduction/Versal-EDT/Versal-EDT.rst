#####################################################
Versal ACAP Embedded Design Tutorial
#####################################################


.. toctree::
   :maxdepth: 3
   :caption: Versal ACAP Embedded Design Tutorial
   :hidden:

   Getting Started <docs/1-getting-started>
   Versal ACAP CIPS and NoC (DDR) IP Core Configuration <docs/2-cips-noc-ip-config>
   Boot and Configuration <docs/4-boot-and-config>
   Debugging Using the Vitis Software Platform <docs/3-debugging>
   System Design Example using Scalar Engine and Adaptable Engine <docs/5-system-design-example>
   System Design Example for High-Speed Debug Port (HSDP) with SmartLynq+ Module <docs/6-system-design-example-HSDP>
   Appendix: Creating the PLM <docs/A-creating-plm>




This document provides an introduction for using the Xilinx |reg| Vivado |reg| Design Suite flow for a VCK190/VMK180 evaluation board. The tools used are Vivado Design Suite and the Vitis |trade| unified software platform, version 2021.1. To install the Vitis unified software platform, see *Vitis Unified Software Platform Documentation: Embedded Software Development* `[UG1400] <https://www.xilinx.com/cgi-bin/docs/rdoc?v=2021.1;d=ug1400-vitis-embedded.pdf>`__.

.. note:: 
   In this tutorial, the instructions for booting Linux on the hardware is specific to the PetaLinux tools released for 2021.1, which must be installed on a Linux host machine for exercising the Linux portions of this document.

.. important:: 
   
   The VCK190/VMK180 Evaluation kit has a Silicon Labs CP210x VCP USB-UART Bridge. Ensure that these drivers are installed. See the *Silicon Labs CP210x USB-to-UART Installation Guide* (`[UG1033] <https://www.xilinx.com/cgi-bin/docs/bkdoc?k=install;v=latest;d=ug1033-cp210x-usb-uart-install.pdf>`_) for more information.
 
The examples in this document are created using the Xilinx tools running on a Windows 10, 64-bit operating system, Vitis software platform and PetaLinux on a Linux 64-bit operating system. Other versions of the tools running on other Windows installs might provide varied results. These examples focus on introducing you to the following aspects of embedded design.

- `Versal ACAP CIPS and NoC (DDR) IP Core Configuration <../Versal-EDT/docs/2-cips-noc-ip-config.rst>`__: Describes creation of a design with Versal |trade| ACAP Control, Interfaces, and Processing System (CIPS) IP core and an NoC and running a simple "Hello World" application on Arm |reg| Cortex |trade|-A72, and Cortex-R5F processors. This chapter is an introduction to the hardware and software tools using a simple design as the example.

- `Boot and Configuration <../Versal-EDT/docs/4-boot-and-config.rst>`__: Shows  integration of components to configure and create boot images for Versal ACAP. The purpose of this chapter is to understand how to integrate and load boot loaders.

- `Debugging Using the Vitis Software Platform <../Versal-EDT/docs/3-debugging.rst>`__: Introduces debugging features of the Xilinx Vitis software platform. This chapter uses the previous design and runs the software on bare metal (without an OS) to show the debugging features of the Vitis IDE. This chapter also lists debug configurations for Versal ACAP.

- `System Design Example using Scalar Engine and Adaptable Engine <../Versal-EDT/docs/5-system-design-example.rst>`__: Describes building a system on Versal ACAP using available tools and supported software blocks. This chapter demonstrates how to use the Vivado tool to create an embedded design using PL AXI GPIO. It also demonstrates the steps to configure and build the Linux operating system for an Arm Cortex-A72 core-based APU on a Versal device.
  
- `System Design Example for High-Speed Debug Port (HSDP) with SmartLynq+ Module <../Versal-EDT/docs/6-system-design-example-HSDP.rst>`__: Describes building a system on Versal ACAP that utilizes the High-Speed Debug Port (HSDP). This chapter demonstrates how to use the Vivado tool to create an embedded design that utilizes HSDP and uses the SmartLynq+ module for downloading Linux images.

This design tutorial requires use of a number of files provided by Xilinx. These are contained in a ZIP file that can be downloaded from the Xilinx web site. (See `Getting Started <../Versal-EDT/docs/1-getting-started.rst>`__). The tutorial assumes the contents of the ZIP file are extracted to `C:\edt`.

******************************************************
Navigating Content by Design Process
******************************************************

Xilinx documentation is organized around a set of standard design processes to help you find relevant content for your current development task. This document covers the following design processes:

* **System and Solution Planning**: Identifying the components, performance, I/O, and data transfer requirements at a system level. Includes application mapping for the solution to PS, PL, and AI Engine.
  
  * `Configuring the NoC IP Core in an Existing Project <../Versal-EDT/docs/2-cips-noc-ip-config.rst#configuring-the-noc-ip-core-in-an-existing-project>`__
  * `System Design Example using Scalar Engine and Adaptable Engine <../Versal-EDT/docs/5-system-design-example.rst>`__

* **Embedded Software Development**: Creating the software platform from the hardware platform and developing the application code using the embedded CPU. Also covers XRT and Graph APIs.

  * `Running a Bare-Metal Hello World Application <../Versal-EDT/docs/2-cips-noc-ip-config.rst#running-a-bare-metal-hello-world-application>`__
  * `Running Applications in the JTAG Mode using the System Debugger in the Vitis Software Platform <../Versal-EDT/docs/2-cips-noc-ip-config.rst#running-applications-in-the-jtag-mode-using-the-system-debugger-in-the-vitis-software-platform>`__
  * `Running a Bare-Metal Hello World Application on DDR Memory <../Versal-EDT/docs/2-cips-noc-ip-config.rst#running-a-bare-metal-hello-world-application-on-ddr-memory>`__

* **Hardware, IP, and Platform Development**: Creating the PL IP blocks for the hardware platform, creating PL kernels, subsystem functional simulation, and evaluating the Vivado timing, resource use, and power closure. Also involves developing the hardware platform for system integration. Topics in this document that apply to this design process include:
  
  * `CIPS IP Core Configuration <../Versal-EDT/docs/2-cips-noc-ip-config.rst#cips-ip-core-configuration>`__
  * `NoC (and DDR) IP Core Configuration <../Versal-EDT/docs/2-cips-noc-ip-config.rst#noc-and-ddr-ip-core-configuration>`__
  * `Design Example: Using AXI GPIO <../Versal-EDT/docs/5-system-design-example.rst#design-example-using-axi-gpio>`__

* **System Integration and Validation**: Integrating and validating the system functional performance, including timing, resource use, and power closure. Topics in this document that apply to this design process include:
  
  * `Boot and Configuration <../Versal-EDT/docs/4-boot-and-config.rst>`__
  * `Example Project: FreeRTOS GPIO Application Project With RPU <../Versal-EDT/docs/5-system-design-example.rst#example-project-freertos-axi-uartlite-application-project-with-rpu>`__
  * `Example Project: Creating Linux Images Using PetaLinux <../Versal-EDT/docs/5-system-design-example.rst#example-project-creating-linux-images-using-petalinux>`__





.. |trade|  unicode:: U+02122 .. TRADEMARK SIGN
   :ltrim:
.. |reg|    unicode:: U+000AE .. REGISTERED TRADEMARK SIGN
   :ltrim:

© Copyright 2020-2021 Xilinx, Inc.

*Licensed under the Apache License, Version 2.0 (the “License”); you may not use this file except in compliance with the License. You may obtain a copy of the License at [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0).*

*Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.*

