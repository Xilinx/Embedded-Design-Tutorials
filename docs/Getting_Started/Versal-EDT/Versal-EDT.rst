#####################################################
Versal Adaptive SoC Embedded Design Tutorial
#####################################################


.. toctree::
   :maxdepth: 3
   :caption: Versal Adaptive SoC Embedded Design Tutorial
   :hidden:

   Getting Started <docs/1-getting-started.rst>
   Versal ACAP CIPS and NoC (DDR) IP Core Configuration <docs/2-cips-noc-ip-config.rst>
   Boot and Configuration <docs/4-boot-and-config.rst>
   Debugging Using the Vitis Software Platform <docs/3-debugging.rst>
   System Design Example using Scalar Engine and Adaptable Engine <docs/5-system-design-example.rst>
   System Design Example for High-Speed Debug Port (HSDP) with SmartLynq+ Module <docs/6-system-design-example-HSDP.rst>
   System Design Example for SSI Devices <docs/7-system-design-example-ssit-device.rst>
   Appendix: Creating the PLM <docs/A-creating-plm.rst>



This document provides an introduction for using the AMD Vivado |trade| Design Suite flow for a VCK190/VMK180/VPK180 evaluation board. The tools used are Vivado Design Suite and the AMD Vitis |trade| unified software platform, version 2024.1. To install the Vitis unified software platform, see *Vitis Unified Software Platform Documentation: Embedded Software Development* `[UG1400] <https://docs.amd.com/access/sources/dita/map?Doc_Version=2024.1%20English&url=ug1400-vitis-embedded>`__.

.. note:: In this tutorial, the instructions for booting Linux on the hardware is specific to the PetaLinux tools released for 2024.1, which must be installed on a Linux host machine for exercising the Linux portions of this document.

.. important:: 
   
   The VCK190/VMK180 Evaluation kit has a Silicon Labs CP210x VCP USB-UART Bridge. Ensure that these drivers are installed. See the *Silicon Labs CP210x USB-to-UART Installation Guide* (`UG1033 <https://docs.amd.com/go/en-US/ug1033-cp210x-usb-uart-install>`_) for more information.
 
The examples in this document are created using the Xilinx tools running on a Windows 10, 64-bit operating system, Vitis software platform and PetaLinux on a Linux 64-bit operating system. Other versions of the tools running on other Windows installs might provide varied results. These examples focus on introducing you to the following aspects of embedded design.

- :doc:`./docs/2-cips-noc-ip-config`: Describes creation of a design with AMD Versal |trade| Adaptive SoC Control, Interfaces, and Processing System (CIPS) IP core and an NoC and running a simple "Hello World" application on Arm |reg| Cortex |trade|-A72, and Cortex-R5F processors. This chapter is an introduction to the hardware and software tools using a simple design as the example.

- :doc:`./docs/4-boot-and-config`: Shows integration of components to configure and create boot images for Versal devices. The purpose of this chapter is to understand how to integrate and load boot loaders.

- :doc:`./docs/3-debugging`: Introduces debugging features of the Vitis software platform. This chapter uses the previous design and runs the software on bare metal (without an OS) to show the debugging features of the Vitis IDE. This chapter also lists debug configurations for Versal devices.

- :doc:`./docs/5-system-design-example`: Describes building a system on a Versal device using available tools and supported software blocks. This chapter demonstrates how to use the Vivado tool to create an embedded design using PL AXI GPIO. It also demonstrates the steps to configure and build the Linux operating system for an Arm Cortex-A72 core-based APU on a Versal device.
  
- :doc:`./docs/6-system-design-example-HSDP`: Describes building a system on a Versal device that utilizes the High-Speed Debug Port (HSDP). This chapter demonstrates how to use the Vivado tool to create an embedded design that utilizes HSDP and uses the SmartLynq+ module for downloading Linux images.

- :doc:`./docs/7-system-design-example-ssit-device`: Describes building a system based on Versal devices using available tools and supported software blocks for Stacked Silicon Interconnect (SSI) devices.

This design tutorial requires use of a number of files provided by AMD. These are contained in a ZIP file that can be downloaded from the web site. (See :doc:`./docs/1-getting-started`). The tutorial assumes the contents of the ZIP file are extracted to ``C:\edt``.


.. |trade|  unicode:: U+02122 .. TRADEMARK SIGN
   :ltrim:
.. |reg|    unicode:: U+000AE .. REGISTERED TRADEMARK SIGN
   :ltrim:



.. Copyright © 2019-2024 Advanced Micro Devices, Inc

.. `Terms and Conditions <https://www.amd.com/en/corporate/copyright>`_.
