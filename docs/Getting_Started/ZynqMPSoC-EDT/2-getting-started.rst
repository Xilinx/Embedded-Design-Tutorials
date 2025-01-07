..

***************
Getting Started
***************

Hardware Requirements
---------------------

This tutorial targets the Zynq UltraScale+ ZCU102 evaluation board. The examples in this tutorial were tested using the ZCU102 Rev 1 board. To use this guide, you need the following hardware items, which are
included with the evaluation board:

-  ZCU102 Rev1 evaluation board

-  AC power adapter (12 VDC)

-  USB Type-A to USB Micro cable (for UART communications)

-  USB micro cable for programming and debugging via USB-Micro JTAG connection

-  SD-MMC flash card for Linux booting

-  Ethernet cable to connect target board with host machine

-  Monitor with DisplayPort (DP) capability and at least 1080P resolution

-  DP cable to connect the display output from the ZCU102 board to a DP monitor

Installation Requirements
-------------------------

Vitis Integrated Design Environment and Vivado Design Suite
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ensure that you have the Vitis |trade| 2024.1 unified software development platform is installed. The Vitis software platform comes with all the hardware and software as a package. If you install the Vitis IDE, you will automatically get both the Vivado Design Suite and the Vitis IDE. You do not have to make any extra selections in the installer.

Visit this `web page <https://www.xilinx.com/support/download.html>`_ to download the required Vitis tool installer.

Make sure your operating system is supported by the `Vitis embedded software development flow <https://docs.xilinx.com/r/en-US/ug1400-vitis-embedded/Installation-Requirements>`_. For more information on installing the Vitis unified software platform, refer to the Installation section of the Vitis embedded software development flow documentation (`UG1400 <https://docs.xilinx.com/r/en-US/ug1400-vitis-embedded/Installation>`_).

PetaLinux Tools
~~~~~~~~~~~~~~~

Install the PetaLinux tools to run through the Linux portion of this tutorial. PetaLinux tools run under the Linux host system. The supported operation systems can be checked from the PetaLinux Tools Documentation: Reference Guide (`UG1144 <https://docs.amd.com/r/en-US/ug1144-petalinux-tools-reference-guide/Installation-Requirements>`_).

This can use either a dedicated Linux host system or a virtual machine running one of these Linux operating systems on your Windows development platform.

When you install PetaLinux tools on your system of choice, you must do the following:

-  Download the `PetaLinux <https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-design-tools.html>`_ software from the AMD website.

-  Download the ZCU102 PetaLinux BSP (ZCU102 BSP (prod-silicon)) from the downloads page.

-  Read and follow the installation instructions in the PetaLinux Tools Documentation: Reference Guide (`UG1144 <https://docs.xilinx.com/r/en-US/ug1144-petalinux-tools-reference-guide/Setting-Up-Your-Environment>`_).

Tutorial Design Files
~~~~~~~~~~~~~~~~~~~~~

The reference design files for this tutorial are provided in the `ref_files` directory, organized with design number or chapter name. Chapters that need to use reference files will point to the specific ``ref_files`` subdirectory.

-  If the examples are GUI based, the ``ref_files`` directory provides the source files for the examples.
-  If the examples can be run in script mode, the ``ref_files`` directory contains the Makefile to help you run through the flow easily. Run ``make`` in this directory to run through the implementation flow.

Next Chapter
~~~~~~~~~~~~

The :doc:`next chapter <./3-system-configuration>` details the configuration of a Zynq UltraScale+ MPSoC PS with the Vivado IDE.

.. |trade|  unicode:: U+02122 .. TRADEMARK SIGN
   :ltrim:
.. |reg|    unicode:: U+000AE .. REGISTERED TRADEMARK SIGN
   :ltrim:
