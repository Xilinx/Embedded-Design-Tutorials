<p align="right">
            Read this page in other languages:<a href="../docs-jp/readme.md">日本語</a>    <table style="width:100%"><table style="width:100%">
  <tr>

<th width="100%" colspan="6"><img src="https://www.xilinx.com/content/dam/xilinx/imgs/press/media-kits/corporate/xilinx-logo.png" width="30%"/><h1>Zynq UltraScale+ MPSoC Embedded Design Tutorial 2020.2 (UG1209)</h1>
</th>

  </tr>
</table>

## Chapter Descriptions

 This document provides an introduction to using the Vivado&reg; Design
 Suite flow for the Xilinx&reg; Zynq&reg; UltraScale+&trade; MPSoC ZCU102 Rev 1.0 and
 Rev 1.1 evaluation boards. The tool used is the Vitis&trade; unified
 software platform.

1. [Introduction](./1-introduction.md)

2. [Getting Started](./2-getting-started.md)

3. [Zynq UltraScale+ MPSoC System Configuration](./3-system-configuration.md)

    This chapter describes the creation of a system with the
 Zynq UltraScale+ MPSoC Processing System (PS) and the creation of a
 hardware platform for Zynq UltraScale+ MPSoC. This chapter is an
 introduction to the hardware and software tools using a simple design
 as the example.

4. [Build Software for PS Subsystems](./4-build-sw-for-ps-subsystems.md)

    This chapter describes the steps to configure and build software for processing blocks in the
 processing system, including application processing unit (APU),
 real-time processing unit (RPU). Steps to create bare metal
 applications targeting on APU and RPU
 and conducting a review of boot components in hardware platform is
 also included.

5. [Building Linux Applications for PS](./5-build-linux-sw-for-ps.md)

6. [Debugging Standalone Applications](./6-debugging-with-vitis-debugger.md)

    This chapter provides an
 introduction to debugging software using the debug features of the
 Vitis IDE. This chapter uses the previous design and runs the software
 bare metal (without an OS) to demonstrate the debugging process. This
 chapter also lists the debug configurations for Zynq UltraScale+
 MPSoC.

7. [Debugging Linux Applications](./7-debugging-linux-app.md)

8. [System Design Example: Using GPIO, Timer and Interrupts](./design1-using-gpio-timer-interrupts.md)

    This chapter highlights how you can use the software blocks you configured in previous chapters to create a complex Zynq UltraScale+ system.

9. [Boot and Configuration](./8-boot-and-configuration.md)

    This chapter shows integration of components to configure and create boot images for a Zynq UltraScale+ system. The purpose of this chapter is to understand how to integrate and load boot loaders.

## Example Project

The best way to learn a tool is to use it. This guide provides
opportunities for you to work with the tools under discussion.
Specifications for sample projects are given in the example sections,
along with an explanation of what is happening behind the scenes. Each
chapter and examples are meant to showcase different aspects of
embedded design. The example takes you through the entire flow to
complete the learning and then moves on to another topic.

The examples in this document were created using Xilinx tools running
on Windows 10, 64-bit operating system, and PetaLinux on Linux 64-bit
operating system. Other versions of the tools running on other Window
installations might provide varied results. These examples focus on
introducing you to the following aspects of embedded design.

 >**Note**: The sequence mentioned in the tutorial steps for booting
 Linux on the hardware is specific to 2020.2, which must be installed
 on the Linux host machine to execute the Linux portions of this document.

© Copyright 2017-2020 Xilinx, Inc.
