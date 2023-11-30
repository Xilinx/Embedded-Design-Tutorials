############################################################
System Performance Analysis
############################################################

.. toctree::
   :maxdepth: 3
   :caption: Introduction
   :hidden:

   Introduction <docs/1-introduction>
   System Performance Modeling Project <docs/2-system-performance-modeling-project>
   Monitor Framework <docs/3-monitor-framework>
   Getting Started with SPM <docs/4-getting-started-with-SPM>
   Evaluating Software Performance <docs/5-evaluating-software-performance>
   Evaluating High-Performance Ports <docs/6-evaluating-high-performance-ports>
   Evaluating DDR Controller Settings <docs/7-evaluating-DDR-controller-settings>
   Evaluating Memory Hierarchy and the ACP <docs/8-evaluating-memory-hierarchy-ACP>
   Using SPA with a Custom Target <docs/9-using-spa-with-custom-target>
   End-To-End Performance Analysis <docs/10-end-to-end-performance-analysis>
   Appendix: Performance Checklist <docs/A-performance-checklist>


This guide describes the performance analysis toolbox which can be used for early exploration of hardware and software systems. The performance analysis toolbox can be used for early exploration of hardware and software systems. It informs you about the capabilities of the target platform with user configurable settings in a visual way. This guide highlights various features of the performance anslysis toolbox with examples for the Zynq® SoC series, including Zynq® UltraScale+™ MPSoC and Zynq-7000 SoC platforms, as well as how the Vitis software platform can assist you in maximizing the capabilities of these SoC products.After reading this guide, you should be able to:

- Use the System Performance Modeling (SPM) design to analyze a software application and model hardware traffic
- Understand the proficiency of the Zynq UltraScale+ MPSoC and Zynq-7000 SoC platforms.
- Recognize the uses and capabilities of the PS-PL interfaces.
- Leverage the memory hierarchy (including the L1 and L2 data caches and DDR) to achieve the best system performance.
- Model a design using SPM and follow up with performance validation of the actual design.

Specific examples are used to provide detailed results and analysis. This guide also describes how you can obtain similar results in the Vitis software platform. The goals of this guide are such that you can extrapolate these techniques to model and analyze your own designs.

The first four topics provide an overview of the SPA toolbox:

.. list-table:: 
   :widths: 20 80
   :header-rows: 1
   
   * - Tutorial
     - Description
	 
   * - :doc:`Introduction <docs/1-introduction>`
     - Outlines system performance and defines why it is important.
	 
   * - :doc:`System Performance Modeling Project <docs/2-system-performance-modeling-project>`
     - Describes the contents of the SPM project.
	 
   * - :doc:`Monitor Framework <docs/3-monitor-framework>`
     - Defines the monitoring infrastructure used by the Vitis software platform tool.
	 
   * - :doc:`Getting Started with SPM <docs/4-getting-started-with-SPM>`
     - Provides the necessary steps to get up and running with the SPM design.



The next set of chapters provides in-depth exploration into using the SPM design:

.. list-table:: 
   :widths: 20 80
   :header-rows: 1
   
   * - Tutorial
     - Description
	 
   * - :doc:`Evaluating Software Performance <docs/5-evaluating-software-performance>`
     - Begins by running a software executable that comes with the SPM project.
	 
   * - :doc:`Evaluating High-Performance Ports <docs/6-evaluating-high-performance-ports>`
     - Introduces traffic on the High- Performance (HP) ports while running the same software.
	 
   * - :doc:`Evaluating DDR Controller Settings <docs/7-evaluating-DDR-controller-settings>`
     - Describes how to change DDR controller (DDRC) settings and analyze their impact on the HP port traffic.
	 
   * - :doc:`Evaluating Memory Hierarchy and the ACP <docs/8-evaluating-memory-hierarchy-ACP>`
     - Evaluates bandwidth and latency from the memory hierarchy, and then introduces traffic on the Accelerator Coherency Port (ACP) to investigate its impact on that performance.
	 
   * - :doc:`Using SPA with a Custom Target <docs/9-using-spa-with-custom-target>`
     - Defines some steps and requirements to instrumenting and monitoring your design.
	 
   * - :doc:`End-To-End Performance Analysis <docs/10-end-to-end-performance-analysis>`
     - Describes the full cycle of performance analysis.
	 
   * - :doc:`Performance Checklist <docs/A-performance-checklist>`
     - Summarizes the key performance recommendations mentioned throughout this guide.


============================
Requirements
============================

 If you would like to reproduce any of the results shown and discussed in this guide, the requirements include the following:

- Software:

  - Vitis unified software platform
  - Optional: USB-UART drivers from `Silicon Labs <http://www.silabs.com/Support%20Documents/Software/CP210x_VCP_Windows.zip>`

- Hardware:

  - Xilinx evaluation boards for SPM projects, like `ZCU102 <https://www.xilinx.com/products/boards-and-kits/ek-u1-zcu102-g.html>` or `ZC702 <https://www.xilinx.com/products/boards-and-kits/EK-Z7-ZC702-G.htm>`
  - Any Zynq UltraScale+ MPSoC or Zynq-7000 SoC based boards for :doc:`Using SPA with a Custom Target <docs/9-using-spa-with-custom-target>`.
  - AC power adapter for the evaluation boards
  - Xilinx programming cable; either platform cable or Digilent USB cable
  - UART cable for the evaluation board.
