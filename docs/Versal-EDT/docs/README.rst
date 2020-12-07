.. 
   

.. meta::
   :keywords: embedded, tutorials, core, development, versal-acap
   :description: Learn how to use the Xilinx® Vivado® Design Suite flow for a VMK180/VCK190 evaluation board.
   :xlnxdocumentclass: Document
   :xlnxdocumenttype: Tutorials
   

   

Overview
###########


.. _Embedded Design Tutorials:


Embedded Design Tutorials
=========================

.. toctree::
   :maxdepth: 5
   :caption: Versal Embedded Design Tutorial
   :hidden:

   ../Versal-EDT/about-guide
   ../Versal-EDT/1-getting-started
   ../Versal-EDT/2-cips-noc-ip-config
   ../Versal-EDT/3-debugging
   ../Versal-EDT/4-boot-and-config
   ../Versal-EDT/5-system-design-example
   ../Versal-EDT/A-creating-plm
   

.. list-table:: 
   :widths: 30 20 50
   :header-rows: 1
   
   * - Tutorial
     - Board
     - Description
	 
   * - Versal Embedded Design Tutorial (UG1305)
     - Versal VMK180/VCK190
     - Provides an introduction for using the Xilinx® Vivado® Design Suite flow and the Vitis™ unified software platform for embedded development on a Versal™ VMK180/VCK190 evaluation board.

   * - Zynq UltraScale+ MPSoC Embedded Design Tutorial (UG1209)
     - ZCU102 Rev 1.0/1.1
     - Provides an introduction to using the Xilinx Vivado Design Suite flow and the Vitis unified software platform for embedded development on a Zynq UltraScale+ MPSoC device. **Note:** This document is not yet available on GitHub. See the latest version `here <https://www.xilinx.com/support/documentation/sw_manuals/xilinx2020_2/ug1209-embedded-design-tutorial.pdf>`__.

   * - Zynq-7000 Embedded Design Tutorial (UG1165)
     - ZC702 Rev 1.0
     - Provides an introduction to using the Xilinx Vivado Design Suite flow and the Vitis unified software platform for embedded development on a Zynq-7000 SoC device. **Note:** This document is not yet available on GitHub. See the latest version `here <https://www.xilinx.com/support/documentation/sw_manuals/xilinx2020_2/ug1165-zynq-embedded-design-tutorial.pdf>`__.
                 
 
.. _Versal Embedded Design Tutorial:

Versal Embedded Design Tutorial
===============================

.. list-table:: 
   :widths: 30 70
   :header-rows: 1

   * - Tutorial
     - Description
	 
   * - `Creating a New Embedded Project with the Versal ACAP <./2-cips-noc-ip-config.html>`__
     - This tutorial demonstrates how to create a project with an embedded processor system as the top level.

   * - `Running a Bare-Metal Hello World Application <./2-cips-noc-ip-config.html#running-a-bare-metal-hello-world-application>`__
     - This tutorial demonstrates how to run a hello world software application from Arm Cortex-A72 on OCM and Arm Cortex-R5F on TCM in the Xilinx Vitis software platform.

   * - `Running Applications in the JTAG Mode using the System Debugger <./2-cips-noc-ip-config.html#running-applications-in-the-jtag-mode-using-the-system-debugger-in-the-vitis-software-platform>`__
     - This tutorial demonstrates how to create a ‘Run configuration’ that captures the settings for executing the application.

   * - `Running a Bare-Metal Hello World Application on DDR Memory <2-cips-noc-ip-config.html#running-a-bare-metal-hello-world-application-on-ddr-memory>`__
     - This tutorial demonstrates how to run a hello world software application from Arm Cortex-A72 and Arm Cortex-R5F on DDR memory in the Vitis software platform. 

   * - `FreeRTOS GPIO Application Project With RPU <5-system-design-example.html#example-project-freertos-gpio-application-project-with-rpu>`__
     - This tutorial demonstrates how to configure and build the FreeRTOS application for an Arm® Cortex™- R5F core based RPU on a Versal™ device.

   * - `Creating Linux Images Using PetaLinux <5-system-design-example.html#example-project-creating-linux-images-using-petalinux>`__
     - This tutorial demonstrates how to configure and build the Linux operating system for an Arm® Cortex™-A72 core- based APU on a Versal™ device.
	 
	 
.. toctree::
   :maxdepth: 5
   :caption: Versal test
   :hidden:

   Versal-EDT/about-guide.html
   Versal-EDT/1-getting-started.html


   

.. _Versions:

.. toctree::
   :maxdepth: 2
   :caption: Versions
   :hidden:


   Master <https://github.com/Xilinx/Embedded-Design-Tutorials/tree/master>
      
	 


   