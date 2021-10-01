..
   Copyright 2000-2021 Xilinx, Inc.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

***************
Getting Started
***************

=====================================
Navigating Content by Design Process
=====================================

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



Ensure that the required tools are installed properly and your environments match the requirements.

=====================
Hardware Requirements
=====================

This tutorial targets the Versal |trade| ACAP VCK190 and VMK180 evaluation boards. The examples in this tutorial were tested using the VCK190 ES1 board. To use this guide, you need the following hardware items. These are included with the evaluation board.

- VCK190/VMK180 ES1/Production board
- AC power adapter (12 VDC)
- USB Type-A to USB Micro cable (for UART communications)
- USB Micro cable for programming and debugging via USB-Micro JTAG connection
- SD-MMC flash card for Linux booting
- QSPI daughter card X_EBM-01, REV_A01
- OSPI daughter card X-EBM-03 REV_A02
- eMMC daughter card X-EBM-02 REV_A02

.. note:: OSPI and eMMC boot modes are only supported on the VCK190 and VMK180 RevB production boards.

=========================
Installation Requirements
=========================

Vitis Integrated Design Environment and Vivado Design Suite
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ensure that you have the Vitis |trade| 2021.1 software development platform installed. The Vitis IDE is a Xilinx |reg| unified tool which comes with all the hardware and software as a package. If you install the Vitis IDE, you will automatically get both the Vivado |reg| Design Suite and the Vitis development tools. You do not have to make any extra selections in the installer.

.. note:: Visit `https://www.xilinx.com/support/download.html <https://www.xilinx.com/support/download.html>`__ to confirm that you have the latest tools version.

For more information on installing the Vivado Design Suite, refer to the *Vitis Unified Software Platform Documentation: Embedded Software Development* (`UG1400 <https://www.xilinx.com/support/documentation/sw_manuals/xilinx2021_1/ug1400-vitis-embedded.pdf>`__).

PetaLinux Tools
~~~~~~~~~~~~~~~

Install the PetaLinux tools to run through the Linux portion of this tutorial. PetaLinux tools run under the Linux host system running one of the following:

- Red Hat Enterprise Workstation/Server 7.4, 7.5, 7.6, 7.7, 7.8 (64-bit)
- CentOS Workstation/Server 7.4, 7.5, 7.6, 7.7, 7.8 (64-bit)
- Ubuntu Linux Workstation/Server 16.04.5, 16.04.6, 18.04.1, 18.04.02, 18.04.3, 18.04.4 (64-bit)

This can use either a dedicated Linux host system or a virtual machine running one of these Linux operating systems on your Windows development platform.

When you install PetaLinux tools on your system of choice, you must do the following:

- Download PetaLinux 2021.1 software from the Xilinx website.

- Download the respective BSP as described in `Example Project: Creating Linux Images Using PetaLinux <../docs/5-system-design-example.rst#example-project-creating-linux-images-using-petalinux>`__.

- Add common system packages and libraries to the workstation or virtual machine. For more information, see the Installation Requirements from the *PetaLinux Tools Documentation: Reference Guide* (`UG1144 <https://www.xilinx.com/support/documentation/sw_manuals/xilinx2021_1/ug1144-petalinux-tools-reference-guide.pdf>`__) and the `PetaLinux Release Notes 2021.1 <https://www.xilinx.com/support/answers/75775.html>`__.

=============
Prerequisites
=============

- 8 GB RAM (recommended minimum for Xilinx tools)
- 2 GHz CPU clock or equivalent (minimum of eight cores)
- 100 GB free HDD space

Extracting the PetaLinux Package
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

By default, the PetaLinux tools are installed into the current working directory. Alternatively, you can specify an installation path.

For example, to install PetaLinux tools under `/opt/pkg/petalinux/<petalinux-version>`:

.. code-block:: bash

    $ mkdir -p /opt/pkg/petalinux/<petalinux-version>
    $ ./petalinux-v<petalinux-version>-final-installer.run --dir /opt/pkg/petalinux/<petalinux-version>

.. note:: Do not change the install directory permissions to CHMOD 775 as it might cause BitBake errors. This installs the PetaLinux tool into the `/opt/pkg/petalinux/<petalinux-version>` directory.

For more information, see *PetaLinux Tools Documentation: Reference Guide* (`UG1144 <https://www.xilinx.com/cgi-bin/docs/rdoc?d=xilinx2021_1/ug1144-petalinux-tools-reference-guide.pdf>`__).

==================
Software Licensing
==================

Xilinx software uses FLEXnet licensing. When the software is first run, it performs a license verification process. If the license verification does not find a valid license, the license wizard guides you through the process of obtaining a license and ensuring that the license can be used with the tools installed. If you do not need the full version of the software, you can use an evaluation license. For installation instructions and information, see the *Vivado Design Suite User Guide: Release Notes, Installation, and Licensing* (`UG973 <https://www.xilinx.com/support/documentation/sw_manuals/xilinx2021_1/ug973-vivado-release-notes-install-license.pdf>`__).

=====================
Tutorial Design Files
=====================

The reference design files for Production Silicon are provided in the `ref_files <https://github.com/Xilinx/Embedded-Design-Tutorials/tree/master/docs/Introduction/Versal-EDT/ref_files>`__ directory.

Design files for ES1 are available on the lounge.

.. |trade|  unicode:: U+02122 .. TRADEMARK SIGN
   :ltrim:
.. |reg|    unicode:: U+000AE .. REGISTERED TRADEMARK SIGN
   :ltrim:
   

