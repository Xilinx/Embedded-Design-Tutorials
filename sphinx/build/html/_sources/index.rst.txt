############################################################
Embedded Designs 
############################################################

.. toctree::
   :maxdepth: 2
   :caption: 简体中文
   :hidden:

   Master <https://xilinx.github.io/Embedded-Design-Tutorials/master/docs-cn/index.html>

.. toctree::
   :maxdepth: 2
   :caption: 日本語
   :hidden:

   Master <https://xilinx.github.io/Embedded-Design-Tutorials/master/docs-jp/index.html>



Xilinx and its Ecosystem Partners deliver embedded tools and runtime environments designed to enable you to efficiently and quickly move from concept to release. We provide you with all the components needed to create your embedded system using Xilinx Zynq® SoC and Zynq UltraScale+ MPSoC devices, MicroBlaze™ processor cores, and Arm Cortex-M1/M3 micro controllers including open source operating systems and bare metal drivers, multiple runtimes and Multi-OS environments, sophisticated Integrated Development Environments, and compilers, debuggers, and profiling tools.






.. sidebar:: More Information

   For more information about embedded tools, see `Xilinx Embedded Software Infrastructure <https://www.xilinx.com/products/design-tools/embedded-software.html>`_.



.. figure:: /docs/images/embedded-tutorials-landing.png





This repository provides information about creating embedded designs. The following documents are available.



*************************
Introduction
*************************


.. toctree::
   :maxdepth: 3
   :caption: Introduction
   :hidden:

   docs/Introduction/Versal-EDT/Versal-EDT
   docs/Introduction/ZynqMPSoC-EDT/ZynqMPSoC-EDT
   docs/Introduction/Zynq7000-EDT/Zynq7000-EDT



.. list-table:: 
   :widths: 20 15 65
   :header-rows: 1
   
   * - Tutorial
     - Board
     - Description
	 
   * - :doc:`Versal ACAP Embedded Design Tutorial <docs/Introduction/Versal-EDT/Versal-EDT>`
     - Versal VMK180/VCK190
     - Provides an introduction for using the Xilinx® Vivado® Design Suite flow and the Vitis™ unified software platform for embedded development on a Versal™ VMK180/VCK190 evaluation board.

   * - :doc:`Zynq UltraScale+ MPSoC Embedded Design Tutorial <docs/Introduction/ZynqMPSoC-EDT/ZynqMPSoC-EDT>`
     - ZCU102 Rev 1.0/1.1
     - Provides an introduction to using the Xilinx Vivado Design Suite flow and the Vitis unified software platform for embedded development on a Zynq UltraScale+ MPSoC device. 

   * - :doc:`Zynq-7000 Embedded Design Tutorial <docs/Introduction/Zynq7000-EDT/Zynq7000-EDT>`
     - ZC702 Rev 1.0
     - Provides an introduction to using the Xilinx Vivado Design Suite flow and the Vitis unified software platform for embedded development on a Zynq-7000 SoC device. 



*************************
Feature Tutorials
*************************


.. toctree::
   :maxdepth: 3
   :caption: Feature Tutorials
   :hidden:

   First Stage Boot Loader (FSBL) <docs/Feature_Tutorials/debuggable-fsbl/debuggable-fsbl>
   Profiling Applications with System Debugger <docs/Feature_Tutorials/sw-profiling/sw-profiling>



.. list-table:: 
   :widths: 20 80
   :header-rows: 1
   
   * - Tutorial
     - Description
	 
   * - :doc:`First Stage Boot Loader (FSBL) <docs/Feature_Tutorials/debuggable-fsbl/debuggable-fsbl>`
     - First Stage Boot Loader (FSBL) can initialize the SoC device, load the required application or data to memory, and launch applications on the target CPU core. An FSBL is provided in the Vitis platform project (if you enabled creating boot components while creating the platform project), but you are free to create additional FSBL applications as general applications for further modification or debugging purposes.

   * - :doc:`Profiling Applications with System Debugger <docs/Feature_Tutorials/sw-profiling/sw-profiling>`
     - Enable profiling features for the standalone domain or board support package (BSP) and the application related to AXI CDMA, which you created in :doc:`Linux Booting and Debug in the Vitis Software Platform <docs\Introduction\Zynq7000-EDT\7-linux-booting-debug>`.


*************************
Debugging
*************************


.. toctree::
   :maxdepth: 3
   :caption: Debugging
   :hidden:

   docs/Vitis-Embedded-Software-Debugging/Debugging



.. list-table:: 
   :widths: 20 80
   :header-rows: 1
   
   * - Tutorial
     - Description
	 
   * - :doc:`Vitis Embedded Software Debugging Guide <docs/Vitis-Embedded-Software-Debugging/Debugging>`
     - Provides specific examples of embedded software debug situations and explains how the various Xilinx debug features can help.





*************************
User Guides
*************************


.. toctree::
   :maxdepth: 3
   :caption: User Guides
   :hidden:

   System Performance Analysis <docs/User_Guides/SPA-UG/SPA-UG>
   Versal Dhrystone Benchmark <docs/User_Guides/Performance_Benchmark/Dhrystone/README>



.. list-table:: 
   :widths: 20 80
   :header-rows: 1
   
   * - Tutorial
     - Description
	 
   * - :doc:`Vitis Unified Software Platform User Guide: System Performance Analysis <docs/User_Guides/SPA-UG/SPA-UG>`
     - Describes the technical details of the performance analysis toolbox, as well as a methodology explaining its usefulness and depth.
	 
   * - :doc:`Versal Dhrystone Benchmark <docs/User_Guides/Performance_Benchmark/Dhrystone/README>`
     - Provides step-by-step instructions for generating a reference design for the Dhrystone benchmark and building and running the Dhrystone application.


