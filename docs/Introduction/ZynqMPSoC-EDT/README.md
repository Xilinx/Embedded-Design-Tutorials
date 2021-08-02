# Introduction

This document provides an introduction to using the Vivado&reg; Design
 Suite flow for the Xilinx&reg; Zynq&reg; UltraScale+&trade; MPSoC ZCU102 Rev 1.0 and
 Rev 1.1 evaluation boards. The tool used is the Vitis&trade; unified
 software platform.

1. [Introduction](./1-introduction.md)

2. [Getting Started](./2-getting-started.md)

3. [Zynq UltraScale+ MPSoC System Configuration with Vivado](./3-system-configuration.md)

    This chapter describes the creation of a system with the
 Zynq UltraScale+ MPSoC Processing System (PS) and the creation of a
 hardware platform for Zynq UltraScale+ MPSoC. This chapter is an
 introduction to the hardware and software tools using a simple design
 as the example.

4. [Building Software for PS Subsystems](./4-build-sw-for-ps-subsystems.md)

    This chapter describes the steps to configure and build software for processing blocks in the
 processing system, including the application processing unit (APU) and
real-time processing unit (RPU). It also covers the creation of bare-metal
 applications targeting the APU and RPU and how to conduct a review of the boot components in a hardware platform.

5. [Debugging Standalone Applications with the Vitis Debugger](./5-debugging-with-vitis-debugger.md)

      This chapter provides an introduction to debugging software using the debug features of the
   Vitis IDE. This chapter uses the previous design and runs the software
   bare metal (without an OS) to demonstrate the debugging process. This
   chapter also lists the debug configurations for Zynq UltraScale+
   MPSoC.

6. [Building and Debugging Linux Applications](./6-build-linux-sw-for-ps.md)

   This chapter creates a Linux image with PetaLinux and creates a "Hello World" Linux application with the Vitis IDE. It also shows how to debug Linux applications with the Vitis IDE.

7. [System Design Example: Using GPIO, Timer and Interrupts](./7-design1-using-gpio-timer-interrupts.md)

    This chapter added some IPs in the PL. It demonstrates how you can use the software blocks you configured in previous chapters to create a complex Zynq UltraScale+ system.

8. [Boot and Configuration](./8-boot-and-configuration.md)

    This chapter shows the integration of components to configure and create boot images for a Zynq UltraScale+ system. The purpose of this chapter is to understand how to integrate and load boot loaders.

9. [Secure Boot](./9-secure-boot.md)

    This is an optional chapter that introduces the steps to build the Hardware Root of Trust and encryption for your design.


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
operating system. Other versions of the tools running on other Windows
installations might provide varied results. These examples focus on
introducing you to the following aspects of embedded design.

 >**Note**: The sequence mentioned in the tutorial steps for booting
 Linux on the hardware is specific to 2021.1, which must be installed
 on the Linux host machine to execute the Linux portions of this document.

------

© Copyright 2017-2021 Xilinx, Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
