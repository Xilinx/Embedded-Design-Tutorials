<p align="right">
            Read this page in other languages:<a href="../docs-jp/readme.md">日本語</a>    <table style="width:100%"><table style="width:100%">
  <tr>

<th width="100%" colspan="6"><img src="https://www.xilinx.com/content/dam/xilinx/imgs/press/media-kits/corporate/xilinx-logo.png" width="30%"/><h1>Zynq UltraScale+ MPSoC Embedded Design Tutorial 2020.2 (UG1209)</h1>
</th>

  </tr>
  <tr>
    <td width="17%" align="center">1. Introduction</td>
    <td width="16%" align="center"><a href="./docs/2-getting-started.md">2. Getting Started</a></td>
    <td width="17%" align="center"><a href="./docs/3-system-configuration.md">3. Zynq UltraScale+ MPSoC System Configuration</a></td>
    <td width="17%" align="center"><a href="./docs/4-build-sw-for-ps-subsystems.md">4. Build Software for PS Subsystems</a></td>
</tr>
<tr>
    <td width="17%" align="center"><a href="5-build-linux-sw-for-ps.md">5. Building Linux Applications for PS</a></td>
    <td width="16%" align="center"><a href="6-debugging-with-vitis-debugger.md">6. Debugging Standalone Applications</a></td>
    <td width="17%" align="center"><a href="7-debugging-linux-app.md">7. Debugging Linux Applications</a></td>
    <td width="17%" align="center"><a href="8-boot-and-configuration.md">8. Boot and Configuration</a></td>    
  </tr>
</table>

- [Introduction](#introduction)
  - [Example Project](#example-project)
  - [How Zynq UltraScale+ Devices Offer a Single Chip Solution](#how-zynq-ultrascale-devices-offer-a-single-chip-solution)
    - [Vitis Integrated Design Environment](#vitis-integrated-design-environment)
    - [Vivado Design Suite](#vivado-design-suite)
    - [PetaLinux Tools](#petalinux-tools)
  - [How the Xilinx Design Tools Expedite the Design](#how-the-xilinx-design-tools-expedite-the-design)

# Introduction

 This document provides an introduction to using the Vivado&reg; Design
 Suite flow for the Xilinx&reg; Zynq&reg; UltraScale+&trade; MPSoC ZCU102 Rev 1.0 and
 Rev 1.1 evaluation boards. The tool used is the Vitis&trade; unified
 software platform.

 The examples in this document were created using Xilinx tools running
  on Windows 10, 64-bit operating system, and PetaLinux on Linux 64-bit
 operating system. Other versions of the tools running on other Window
 installations might provide varied results. These examples focus on
 introducing you to the following aspects of embedded design.

 >**Note**: The sequence mentioned in the tutorial steps for booting
 Linux on the hardware is specific to 2020.1, which must be installed
 on the Linux host machine to execute the Linux portions of this document.

 [Zynq UltraScale+ MPSoC Processing System
 Configuration](./docs/3-system-configuration.md) describes the creation of a system with the
 Zynq UltraScale+ MPSoC Processing System (PS) and the creation of a
 hardware platform for Zynq UltraScale+ MPSoC. This chapter is an
 introduction to the hardware and software tools using a simple design
 as the example.

 [Build Software for PS Subsystems](./docs/4-build-sw-for-ps-subsystems.md) describes
 the steps to configure and build software for processing blocks in
 processing system, including application processing unit (APU),
 real-time processing unit (RPU). Steps to create bare metal
 applications targeting on application processing unit (APU) and RPU
 and conducting a review of boot components in hardware platform is
 also included.

 [Debugging with the Vitis Debugger](./docs/5-debugging-with-vitis-debugger.md) provides an
 introduction to debugging software using the debug features of the
 Vitis IDE. This chapter uses the previous design and runs the software
 bare metal (without an OS) to demonstrate the debugging process. This
 chapter also lists the debug configurations for Zynq UltraScale+
 MPSoC.

 [Boot and Configuration](./docs/6-boot-and-configuration.md) shows integration of
 components to configure and create boot images for a Zynq UltraScale+
 system. The purpose of this chapter is to understand how to integrate
 and load boot loaders.

 [System Design Examples](./docs/7-system-design-examples.md) highlights how you
 can use the software blocks you configured in [Build
 Software for PS Subsystems](./docs/4-build-sw-for-ps-subsystems.md) to create a Zynq UltraScale+ system.

## Example Project

 The best way to learn a tool is to use it. This guide provides
 opportunities for you to work with the tools under discussion.
 Specifications for sample projects are given in the example sections,
 along with an explanation of what is happening behind the scenes. Each
 chapter and examples are meant to showcase different aspects of
 embedded design. The example takes you through the entire flow to
 complete the learning and then moves on to another topic.

## How Zynq UltraScale+ Devices Offer a Single Chip Solution

 Zynq UltraScale+ MPSoC, the next generation Zynq device, is designed
 with the idea of using the right engine for the right task. The Zynq
 UltraScale+ comes with a versatile Processing System (PS) integrated
 with a highly flexible and high-performance Programmable Logic (PL)
 section, all on a single system-on-a-chip (SoC). The Zynq UltraScale+
 MPSoC PS block includes engines such as the following:

- Quad-core Arm&reg; Cortex&trade;-A53-based Application Processing Unit (APU)

- Dual-core Arm Cortex-R5F-based Real-Time Processing Unit (RPU)

- Arm Mali&trade;-400 MP2 based Graphics Processing Unit (GPU)

- Dedicated Platform Management Unit (PMU) and Configuration Security
    Unit (CSU)

- List of high speed peripherals, including display port and SATA

 >***Note*:** The Cortex-R5F processor is a Cortex-R5 processor that
 includes the optional Floating Point Unit (FPU) extension.

 The Programmable Logic section, in addition to the programmable logic
 cells, also comes integrated with a few high performance peripherals,
 including the following:

- Integrated block for PCI Express&reg;

- Integrated block for Interlaken

- Integrated block for 100G Ethernet

- System monitor

- Video codec unit

 The PS and the PL in Zynq UltraScale+ devices can be tightly or
 loosely coupled with a variety of high-performance and high-bandwidth
 PS-PL interfaces.

 To simplify the design process for such sophisticated devices, Xilinx
 offers the Vivado&reg; Design Suite, Vitis software platform, and
 PetaLinux tools for Linux. This set of tools provides you with
 everything you need to simplify embedded system design for a device
 that merges an SoC with an FPGA. This combination of tools enables
 hardware and software application design, code execution and debug,
 and transfer of the design onto actual boards for verification and
 validation.

### Vitis Integrated Design Environment

 The Vitis unified software platform is an integrated development
 environment (IDE) for the development of embedded software
 applications targeted towards Xilinx embedded processors. The Vitis
 software platform works with hardware designs created with the Vivado
 Design Suite. The Vitis software platform is based on the Eclipse open
 source standard. Xilinx has added many features for software
 developers, including the following features:

- Feature-rich C/C++ code editor and compilation environment.

- Project management.

- Application build configuration and automatic Makefile generation.

- Error navigation.

- Integrated environment for seamless debugging and profiling of
     embedded targets.

- Source code version control.

- System-level performance analysis.

- Focused special tools to configure FPGAs.

- Bootable image creation.

- Flash programming.

- Script-based command-line tool (XSCT).

 For more information about the Vitis unified software platform, see
 *Vitis Unified Software Platform Documentation: Embedded Software
 Development*
 ([UG1400](https://www.xilinx.com/cgi-bin/docs/rdoc?v=latest%3Bd%3Dug1400-vitis-embedded.pdf)).

 Other components include:

- Drivers and libraries for embedded software development

- Linaro GCC compiler for C/C++ software development targeting the Arm
     Cortex-A53 and Arm Cortex-R5F MPCore processors in the Zynq
     UltraScale+ Processing System.

### Vivado Design Suite

 The Vivado Design Suite offers a broad range of development system
 tools for FPGA implementation. It can be installed as a standalone
 tool when software programming is not required. It is also a part of
 the Vitis IDE installation. Various Vivado Design Suite editions can
 be used for embedded system development. In this guide, the System
 Edition installed with the Vitis IDE is used. The Vivado Design Suite
 editions are shown in the following figure.

 *Figure 1:* **Vivado Design Suite Editions**

![](./media/image5.png)

### PetaLinux Tools

 The PetaLinux toolset is an embedded Linux system development kit. It
 offers a multi-faceted Linux tool flow, which enables complete
 configuration, build, and deploy environment for Linux OS for the
 Xilinx Zynq devices, including Zynq UltraScale+ devices.

 For more information, see the *PetaLinux Tools Documentation:
 Reference Guide*
 ([UG1144](https://www.xilinx.com/cgi-bin/docs/rdoc?v=latest%3Bd%3Dug1144-petalinux-tools-reference-guide.pdf)).

 The PetaLinux tools design hub provides information and links to
 documentation specific to PetaLinux tools. For more information, see
 [Documentation Navigator and Design
 Hubs](#documentation-navigator-and-design-hubs).

## How the Xilinx Design Tools Expedite the Design

 You can use the Vivado Design Suite tools to add design sources to
 your hardware. These include the IP integrator, which simplifies the
 process of adding IP to your existing project and creating connections
 for ports (such as clock and reset).

 You can accomplish all your hardware system development using the
 Vivado tools along with the IP integrator. This includes specifying
 the Zynq UltraScale+ Processing System, peripherals, and the
 interconnection of these components, along with their respective
 detailed configuration. The Vitis IDE can be used for software
 development, hardware acceleration, and platform development. It also
 be used to debug software applications.

 The Zynq UltraScale+ Processing System (PS) can be booted and run
 without programming the FPGA (programmable logic or PL). However, to
 use any soft IP in the fabric, or to bond out PS peripherals using
 EMIO, you must program the PL using the Vitis IDE or the Vivado
 hardware manager.

 For more information on the embedded design process, refer to the
 *Vivado Design Suite Tutorial: Embedded Processor Hardware Design*
 ([UG940](https://www.xilinx.com/cgi-bin/docs/rdoc?v=latest%3Bd%3Dug940-vivado-tutorial-embedded-design.pdf)).

 For more information about the Zynq UltraScale+ Processing System,
 refer to the *Zynq UltraScale + MPSoC Processing System LogiCORE IP Product Guide*
 ([PG201](https://www.xilinx.com/cgi-bin/docs/ipdoc?c=zynq_ultra_ps_e%3Bv%3Dlatest%3Bd%3Dpg201-zynq-ultrascale-plus-processing-system.pdf)).

 © Copyright 2017-2020 Xilinx, Inc.
