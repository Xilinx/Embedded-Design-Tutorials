# How Zynq UltraScale+ Devices Offer a Single Chip Solution

 Zynq® UltraScale+™ MPSoC, the next generation Zynq device, is designed
 with the idea of using the right engine for the right task. The Zynq
 UltraScale+ MPSoC comes with a versatile processing system (PS) integrated
 with a highly flexible and high-performance programmable logic (PL)
 section, all on a single system-on-a-chip (SoC). The Zynq UltraScale+
 MPSoC PS block includes engines such as the following:

- Quad-core Arm&reg; Cortex&trade;-A53-based Application Processing Unit (APU)

- Dual-core Arm Cortex-R5F-based Real-Time Processing Unit (RPU)

- Arm Mali&trade;-400 MP2 based Graphics Processing Unit (GPU)

- Dedicated Platform Management Unit (PMU) and Configuration Security
    Unit (CSU)

- List of high-speed peripherals, including display port and SATA

 >***Note*:** The Cortex-R5F processor is a Cortex-R5 processor that
 includes the optional Floating Point Unit (FPU) extension.

 The programmable logic section, in addition to the programmable logic
 cells, also comes integrated with a few high-performance peripherals,
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
 offers the Vivado&reg; Design Suite, the Vitis™ unified software platform, and
 PetaLinux tools for Linux. This set of tools provides you with
 everything you need to simplify embedded system design for a device
 that merges an SoC with an FPGA. This combination of tools enables
 hardware and software application design, code execution and debug,
 and transfer of the design onto actual boards for verification and
 validation.

## Vitis Integrated Design Environment

 The Vitis unified software platform is an integrated development
 environment (IDE) for the development of embedded software
 applications targeted towards Xilinx embedded processors. The Vitis
 software platform works with hardware designs created with the Vivado
 Design Suite. The Vitis software platform is based on the Eclipse open
 source standard. Xilinx has added many features for software
 developers, including the following features:

- Feature-rich C/C++ code editor and compilation environment

- Project management

- Application build configuration and automatic Makefile generation

- Error navigation

- Integrated environment for seamless debugging and profiling of
     embedded targets.

- Source code version control

- System-level performance analysis

- Focused special tools to configure FPGAs

- Bootable image creation

- Flash programming

- Script-based command-line tool (XSCT)

 For more information about the Vitis unified software platform, see
 _Vitis Unified Software Platform Documentation: Embedded Software
 Development_ ([UG1400](https://www.xilinx.com/cgi-bin/docs/rdoc?v=latest;d=ug1400-vitis-embedded.pdf)).

 Other components include:

- Drivers and libraries for embedded software development

- Linaro GCC toolchain for C/C++ software development targeting the Arm Cortex-A53 and Arm Cortex-R5F MPCore processors in the Zynq UltraScale+ processing system.

## Vivado Design Suite

 The Vivado Design Suite offers a broad range of development system
 tools for FPGA implementation. It can be installed as a standalone
 tool when software programming is not required. It is also a part of
 the Vitis IDE installation. Various Vivado Design Suite editions can
 be used for embedded system development. In this guide, the System
 Edition installed with the Vitis IDE is used.

## PetaLinux Tools

 The PetaLinux toolset is an embedded Linux system development kit. It
 offers a multi-faceted Linux tool flow, which enables complete
 configuration, build, and deploy environment for Linux OS for the
 Xilinx Zynq devices, including Zynq UltraScale+ devices.

 For more information, see the _PetaLinux Tools Documentation:
 Reference Guide_ ([UG1144](https://www.xilinx.com/cgi-bin/docs/rdoc?v=latest;d=ug1144-petalinux-tools-reference-guide.pdf)).

## How the Xilinx Design Tools Expedite the Design

 You can use the Vivado Design Suite tools to add design sources to
 your hardware. These include the IP integrator, which simplifies the
 process of adding IP to your existing project and creating connections
 for ports (such as clock and reset).

 You can accomplish all your hardware system development using the
 Vivado tools along with the IP integrator. This includes specifying
 the Zynq UltraScale+ processing system, peripherals, and the
 interconnection of these components, along with their respective
 detailed configuration. The Vitis IDE can be used for software
 development, hardware acceleration, and platform development. It can also
 be used to debug software applications.

 The Zynq UltraScale+ PS can be booted and run without programming the PL. However, to
 use any soft IP in the fabric, or to bond out PS peripherals using
 EMIO, you must program the PL using the Vitis IDE or the Vivado
 hardware manager.

 For more information on the embedded design process, refer to the _Vivado Design Suite Tutorial: Embedded Processor Hardware Design_ ([UG940](https://www.xilinx.com/cgi-bin/docs/rdoc?v=latest;d=ug940-vivado-tutorial-embedded-design.pdf)).

 For more information about the Zynq UltraScale+ processing system,
 refer to the _Zynq UltraScale + MPSoC Processing System LogiCORE IP Product Guide_
 ([PG201](https://www.xilinx.com/cgi-bin/docs/ipdoc?c=zynq_ultra_ps_e;v=latest;d=pg201-zynq-ultrascale-plus-processing-system.pdf)).

 In the [next chapter](./2-getting-started.md), we will get started.

 © Copyright 2017-2021 Xilinx, Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
