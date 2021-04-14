# About this Guide

This guide describes the performance analysis toolbox which can be used for early exploration of hardware and software systems. The performance analysis toolbox can be used for early exploration of hardware and software systems. It informs you about the capabilities of the target platform with user configurable settings in a visual way. This guide highlights various features of the performance anslysis toolbox with examples for the Zynq® SoC series, including Zynq® UltraScale+™ MPSoC and Zynq-7000 SoC platforms, as well as how the Vitis software platform can assist you in maximizing the capabilities of these SoC products.After reading this guide, you should be able to:

- Use the System Performance Modeling (SPM) design to analyze a software application and model hardware traffic
- Understand the proficiency of the Zynq UltraScale+ MPSoC and Zynq-7000 SoC platforms.
- Recognize the uses and capabilities of the PS-PL interfaces.
- Leverage the memory hierarchy (including the L1 and L2 data caches and DDR) to achieve the best system performance.
- Model a design using SPM and follow up with performance validation of the actual design.

Specific examples are used to provide detailed results and analysis. This guide also describes how you can obtain similar results in the Vitis software platform. The goals of this guide are such that you can extrapolate these techniques to model and analyze your own designs.

The next four chapters provide an overview of the SPA toolbox:

- [Chapter 1: Introduction](docs/1-introduction.md) outlines system performance and defines why it is important.
- [Chapter 2: System Performance Modeling Project](docs/2-system-performance-modeling-project.md) describes the contents of the SPM project.
- [Chapter 3: Monitor Framework](docs/3-monitor-framework.md) defines the monitoring infrastructure used by the Vitis software platform tool.
- [Chapter 4: Getting Started with SPM](docs/4-getting-started-with-SPM.md) provides the necessary steps to get up and running with the SPM design.

The next set of chapters provides in-depth exploration into using the SPM design:

- [Chapter 5: Evaluating Software Performance](docs/5-evaluating-software-performance.md) begins by running a software executable that comes with the SPM project.
- [Chapter 6: Evaluating High-Performance Ports](docs/6-evaluating-high-performance-ports.md) then introduces traffic on the High- Performance (HP) ports while running the same software.
- [Chapter 7: Evaluating DDR Controller Settings](docs/7-evaluating-DDR-controller-settings.md) describes how to change DDR controller (DDRC) settings and analyze their impact on the HP port traffic.
- [Chapter 8: Evaluating Memory Hierarchy and the ACP](docs/8-evaluating-memory-hierarchy-ACP.md) evaluates bandwidth and latency from the memory hierarchy, and then introduces traffic on the Accelerator Coherency Port (ACP) to investigate its impact on that performance.
- [Chapter 9: Using SPA with a Custom Target](docs/9-using-spa-with-custom-target.md) defines some steps and requirements to instrumenting and monitoring your design.
- [Chapter 10: End-To-End Performance Analysis](docs/10-end-to-end-performance-analysis.md) describes the full cycle of performance analysis.

Finally, the key performance recommendations mentioned throughout this guide are summarized in [Appendix A: Performance Checklist](../docs/A-performance-checklist.md).

## Requirements

 If you would like to reproduce any of the results shown and discussed in this guide, the requirements include the following:

- Software:

  - Vitis unified software platform
  - Optional: USB-UART drivers from [Silicon Labs](http://www.silabs.com/Support%20Documents/Software/CP210x_VCP_Windows.zip)

- Hardware:

  - Xilinx evaluation boards for SPM projects, like [ZCU102](https://www.xilinx.com/products/boards-and-kits/ek-u1-zcu102-g.html) or [ZC702](https://www.xilinx.com/products/boards-and-kits/EK-Z7-ZC702-G.htm)
  - Any Zynq UltraScale+ MPSoC or Zynq-7000 SoC based boards for [SPA features with custom target](./docs/9-using-spa-with-custom-target.md).
  - AC power adapter for the evaluation boards
  - Xilinx programming cable; either platform cable or Digilent USB cable
  - UART cable for the evaluation board.
