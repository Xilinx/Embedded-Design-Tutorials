# Getting Started

## Hardware Requirements

 This tutorial targets the Zynq® UltraScale+™ ZCU102 evaluation board.
 The examples in this tutorial were tested using the ZCU102 Rev 1
 board. To use this guide, you need the following hardware items, which
 are included with the evaluation board:

- ZCU102 Rev1 evaluation board

- AC power adapter (12 VDC)

- USB Type-A to USB Micro cable (for UART communications)

- USB micro cable for programming and debugging via USB-Micro JTAG
     connection

- SD-MMC flash card for Linux booting

- Ethernet cable to connect target board with host machine

- Monitor with DisplayPort (DP) capability and at least 1080P
    resolution

- DP cable to connect the display output from the ZCU102 board to a DP
    monitor

## Installation Requirements

### Vitis Integrated Design Environment and Vivado Design Suite

Ensure that you have the Vitis™ 2021.1 unified software development platform
installed. The Vitis software platform comes with all
the hardware and software as a package. If you install the Vitis IDE,
you will automatically get both the Vivado Design Suite and the Vitis
IDE. You do not have to make any extra selections in the installer.

***Note***: Visit https://www.xilinx.com/support/download.html to
confirm that you have the latest tools version.

Vitis embedded software development supports the following operating systems:

- RHEL/CentOS 7.4, 7.5, 7.6, 7.7, 7.8, 8.1, 8.2
- RHEL 8.3
- Ubuntu 16.04.5, 16.04.6, 18.04.1, 18.04.2, 18.04.3, 18.04.4, 20.04, 20.04.1 LTS
- Amazon Linux 2 AL2 LTS
- SUSE Enterprise Linux 12.4
- Windows 10 64-bit Professional and Enterprise versions 1809, 1903, 1909, and 2004

For more information on installing the Vitis Software Development Platform, refer to
the Installation section of [UG1400](https://www.xilinx.com/html_docs/xilinx2021_1/vitis_doc/vitis_embedded_installation.html#tlp1602134446371).

### PetaLinux Tools

 Install the PetaLinux tools to run through the Linux portion of this
 tutorial. PetaLinux tools run under the Linux host system running one
 of the following:

- Red Hat Enterprise Workstation/Server 7.4, 7.5, 7.6, 7.7, 7.8 (64-bit)
- CentOS Workstation/Server 7.4, 7.5, 7.6, 7.7, 7.8 (64-bit)
- Ubuntu Linux Workstation/Server 16.04.5, 16.04.6, 18.04.1, 18.04.2, 18.04.3, 18.04.4(64-bit)

 This can use either a dedicated Linux host system or a virtual machine
 running one of these Linux operating systems on your Windows
 development platform.

 When you install PetaLinux tools on your system of choice, you must do
 the following:

- Download the [PetaLinux 2021.1](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-design-tools.html) software from the Xilinx website.

- Download the ZCU102 PetaLinux BSP (ZCU102 BSP (prod-silicon)) from
     the 2021.1 downloads page.

- Add common system packages and libraries to the workstation or
     virtual machine. For more information, see the Installation
     Requirements from the _PetaLinux Tools Documentation: Reference
     Guide_
     ([UG1144](https://www.xilinx.com/cgi-bin/docs/rdoc?v=2021.1;d=ug1144-petalinux-tools-reference-guide.pdf)).

#### Prerequisites

- 16 GB RAM (recommended minimum for Xilinx tools)

- 100 GB free HDD space

#### Extracting the PetaLinux Package

 PetaLinux tools installation is straight-forward. Without any options,
 the PetaLinux tools are installed into the current working directory.
 Alternatively, an installation path may be specified.

 For example, to install PetaLinux tools under
 `/opt/pkg/petalinux/2021.1`:

 For more information, see the _PetaLinux Tools Documentation: Reference
 Guide_ ([UG1144](https://www.xilinx.com/cgi-bin/docs/rdoc?v=latest;d=ug1144-petalinux-tools-reference-guide.pdf)).

### Software Licensing

 Xilinx software uses FLEXnet licensing. When the software is first
 run, it performs a license verification process. If the license
 verification does not find a valid license, the license wizard guides
 you through the process of obtaining a license and ensuring that the
 license can be used with the tools installed. If you do not need the
 full version of the software, you can use an evaluation license. For
 installation instructions and information, see the _Vivado Design
 Suite User Guide: Release Notes, Installation, and Licensing_
 ([UG973](https://www.xilinx.com/cgi-bin/docs/rdoc?v=latest;t=vivado+install+guide)).

### Tutorial Design Files

The reference design files for this tutorial are provided in the [ref_files](https://github.com/Xilinx/Embedded-Design-Tutorials/tree/master/docs/Introduction/ZynqMPSoC-EDT/ref_files) directory, organized with design number or chapter name. Chapters that need to use reference files will point to the specific ``ref_files`` subdirectory.

The [next chapter](./3-system-configuration.md) details the configuration of a Zynq UltraScale+ MPSoC PS with the Vivado IDE.

 © Copyright 2017-2021 Xilinx, Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
