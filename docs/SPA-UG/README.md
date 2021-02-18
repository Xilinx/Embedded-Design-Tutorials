
<table class="sphinxhide">
 <tr>
   <td align="center"><img src="https://www.xilinx.com/content/dam/xilinx/imgs/press/media-kits/corporate/xilinx-logo.png" width="30%"/><h1>Xilinx Embedded Design Tutorials</h1></a>
   </td>
 </tr>
 <tr>
 <td align=center><h2> Xilinx Vitis Unified Software Platform User Guide
 <p>System Performance Analysis (UG1145)</p>
 </td>
 </tr>
</table>

This guide describes the technical details of this performance analysis toolbox, as well as a methodology explaining its usefulness and depth. Note that this toolbox informs you as much about the capabilities of the target platform as it does about the particulars of a design. Consequently, this guide is intended to highlight various features of the Zynq-7000 SoC, as well as how the Vitis software platform can assist you in maximizing its capabilities. After reading this guide, you should be able to:

- Use the SPM design to analyze a software application and model hardware traffic
- Better understand the Zynq-7000 SoC platform and its proficiency.
- Recognize the uses and capabilities of the PS-PL interfaces on the Zynq-7000 SoC.
- Leverage the memory hierarchy (including the L1 and L2 data caches and DDR) to achieve the best system performance.
- Model a design using SPM and follow up with performance validation of the actual design.

Specific examples are used to provide detailed results and analysis. This guide also describes how you can obtain similar results in the Vitis software platform. The goals of this guide are such that you can extrapolate these techniques to model and analyze your own designs.

The next four chapters provide an overview of the SPA toolbox:

- [Chapter 1: Introduction](docs/1-introduction.md) outlines system performance and defines why it is important.
- [Chapter 2: System Performance Modeling Project](docs/2-system-performance-modeling-project.md) describes the contents of the SPM project.
- [Chapter 3: Monitor Framework](docs/3-monitor-framework.md) defines the monitoring infrastructure used by the Vitis software platform tool.
- [Chapter 4: Getting Started with SPM](4-getting-started-with-SPM.md) provides the necessary steps to get up and running with the SPM design.

The next set of chapters provides in-depth exploration into using the SPM design:

- [Chapter 5: Evaluating Software Performance](docs/5-evaluating-software-performance.md) begins by running a software executable that comes with the SPM project.
- [Chapter 6: Evaluating High-Performance Ports](docs/6-evaluating-high-performance-ports.md) then introduces traffic on the High- Performance (HP) ports while running the same software.
- [Chapter 7: Evaluating DDR Controller Settings](docs/7-evaluating-DDR-controller-settings.md) describes how to change DDR controller (DDRC) settings and analyze their impact on the HP port traffic.
- [Chapter 8: Evaluating Memory Hierarchy and the ACP](docs/8-evaluating-memory-hierarchy-ACP.md) evaluates bandwidth and latency from the memory hierarchy, and then introduces traffic on the Accelerator Coherency Port (ACP) to investigate its impact on that performance.
- [Chapter 9: Working with a Custom Target](docs/9-working-with-custom-target.md) defines some steps and requirements to instrumenting and monitoring your design.
- [Chapter 10: End-To-End Performance Analysis](docs/10-end-to-end-performance-analysis.md) describes the full cycle of performance analysis.

Finally, the key performance recommendations mentioned throughout this guide are summarized in [Appendix A: Performance Checklist](docs/A-performance-checklist.md).

## Requirements

 If you would like to reproduce any of the results shown and discussed
 in this guide, the requirements include the following:

- Software:

  - Vitis unified software platform
  - Optional: USB-UART drivers from [Silicon Labs](http://www.silabs.com/Support%20Documents/Software/CP210x_VCP_Windows.zip)

- Hardware:

  - Xilinx [ZC702 evaluation board](https://www.xilinx.com/products/boards-and-kits/EK-Z7-ZC702-G.htm) with the XC7Z020 CLG484-1 part
  - AC power adapter (12 VDC)
  - Xilinx programming cable; either platform cable or Digilent USB cable
  - Optional: USB Type-A to USB Mini-B cable (for UART communications)
