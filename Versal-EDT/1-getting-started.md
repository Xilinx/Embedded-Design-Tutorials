# Getting Started

 Ensure that the required tools are installed properly and your environments match the requirements.

## Hardware Requirements

 This tutorial targets the Versal ACAP VCK190 and VMK 180 evaluation boards.
 The examples in this tutorial were tested using the VCK190 ES1
 board. To use this guide, you need the following hardware items, which
 are included with the evaluation board:

- VCK 190/VMK 180 ES1 board
- AC power adapter (12 VDC)
- USB Type-A to USB Micro cable (for UART communications)
- USB Micro cable for programming and debugging via USB-Micro JTAG connection
- SD-MMC flash card for Linux booting
- QSPI daughter card X_EBM-01, REV_A01
- OSPI daughter card X-EBM-03 REV_A02

## Installation Requirements

### Vitis Integrated Design Environment and Vivado Design Suite

 Ensure that you have the Vitis 2020.2 software development platform
 installed. The Vitis IDE is a Xilinx unified tool which comes with all
 the hardware and software as a package. If you install the Vitis IDE,
 you will automatically get both the Vivado Design Suite and the Vitis
 IDE. You do not have to make any extra selections in the installer.

 >***Note*:** Visit <https://www.xilinx.com/support/download.html> to
 confirm that you have the latest tools version.

 For more information on installing the Vivado Design Suite, refer to
 the *Vitis Unified Software Platform Documentation: Embedded Software
 Development*
 ([UG1400](https://www.xilinx.com/cgi-bin/docs/rdoc?v=latest%3Bd%3Dug1400-vitis-embedded.pdf)).

### PetaLinux Tools

 Install the PetaLinux tools to run through the Linux portion of this
 tutorial. PetaLinux tools run under the Linux host system running one
 of the following:

- Red Hat Enterprise Workstation/Server 7.4, 7.5, 7.6, 7.7, 7.8 (64-bit)
- CentOS Workstation/Server 7.4, 7.5, 7.6, 7.7, 7.8 (64-bit)
- Ubuntu Linux Workstation/Server 16.04.5, 16.04.6, 18.04.1, 18.04.02, 18.04.3, 18.04.4 (64-bit)

 This can use either a dedicated Linux host system or a virtual machine
 running one of these Linux operating systems on your Windows
 development platform.

 When you install PetaLinux tools on your system of choice, you must do
 the following:

- Download PetaLinux 2020.2 software from the Xilinx website.

- Download the respective BSP as described in [Example Project: Creating Linux Images Using PetaLinux](#example-project-creating-linux-images-using-petalinux).

- Add common system packages and libraries to the workstation or
     virtual machine. For more information, see the Installation
     Requirements from the *PetaLinux Tools Documentation: Reference
     Guide*
     ([UG1144](https://www.xilinx.com/cgi-bin/docs/rdoc?v=latest%3Bd%3Dug1144-petalinux-tools-reference-guide.pdf)) and the [PetaLinux Release Notes 2020.2](https://xilinx.sharepoint.com/sites/XKB/SitePages/Articleviewer.aspx?ArticleNumber=75775).

## Prerequisites

- 8 GB RAM (recommended minimum for Xilinx tools)
- 2 GHz CPU clock or equivalent (minimum of eight cores)
- 100 GB free HDD space

### Extracting the PetaLinux Package

 PetaLinux tools installation is straight-forward. Without any options,
 the PetaLinux tools are installed into the current working directory.
 Alternatively, an installation path may be specified.

 For example, to install PetaLinux tools under `/opt/pkg/petalinux/<petalinux-version>`:

```
$ mkdir -p /opt/pkg/petalinux/<petalinux-version>
$ ./petalinux-v<petalinux-version>-final-installer.run --dir /opt/pkg/petalinux/<petalinux-version>
```

>***Note*:** Do not change the install directory permissions to CHMOD 775 as it might cause BitBake errors.
This installs the PetaLinux tool into the `/opt/pkg/petalinux/<petalinux-version>` directory.

 For more information, see *PetaLinux Tools Documentation: Reference Guide*
 ([UG1144](https://www.xilinx.com/cgi-bin/docs/rdoc?v=latest%3Bd%3Dug1144-petalinux-tools-reference-guide.pdf)).

#### Software Licensing

 Xilinx software uses FLEXnet licensing. When the software is first
 run, it performs a license verification process. If the license
 verification does not find a valid license, the license wizard guides
 you through the process of obtaining a license and ensuring that the
 license can be used with the tools installed. If you do not need the
 full version of the software, you can use an evaluation license. For
 installation instructions and information, see the *Vivado Design
 Suite User Guide: Release Notes, Installation, and Licensing*
 ([UG973](https://www.xilinx.com/cgi-bin/docs/rdoc?v=latest%3Bt%3Dvivado%2Binstall%2Bguide)).

#### Tutorial Design Files

1. Download the [reference design files](https://www.xilinx.com/cgi-bin/docs/ctdoc?cid=12516610-29d7-4627-bd77-dbfaa3a50ef0;d=ug1305-versal-embedded-tutorial.zip) from the Xilinx website.

2. Extract the ZIP file contents into any write-accessible location.

 To view the contents of the ZIP file, download and extract the
 contents from the ZIP file to `C:\edt`. The design files contain the
 XSA files, source code and prebuilt images for all the sections.

 
 © Copyright 2020 Xilinx, Inc.
