#####################################################
Zynq-7000 Embedded Design Tutorial
#####################################################



This document provides an introduction to using the Xilinx |reg| Vitis |trade| unified software platform with the Zynq |reg|-7000 SoC device. The examples are targeted for the Xilinx ZC702 rev 1.0 evaluation board and the tools used are the Vivado |reg| Design Suite, the Vitis software platform, and PetaLinux.

The examples in this document were created using the Xilinx tools running on a Windows 10 64-bit operating system, and PetaLinux on Linux 64-bit operating system. These examples focus on introducing you to the following aspects of embedded design.


.. toctree::
   :maxdepth: 3
   :caption: Zynq-7000 Embedded Design Tutorial
   :hidden:

   Getting Started <./1-introduction>
   Using the Zynq SoC Processing System <./2-using-zynq>
   Debugging Standalone Applications with the Vitis Software Platform <./3-debugging-vitis>
   Building and Debugging Linux Applications for Zynq-7000 SoCs <./4-linux-for-zynq>
   Using the GP Port in Zynq Devices <./5-using-gp-port-zynq>
   Using the HP Slave Port with AXI CDMA IP <./6-using-hp-port>
   Linux Boot Image Configuration <./7-linux-booting-debug>
   Creating Custom IP and Device Drivers for Linux <./8-custom-ip-driver-linux>


The best way to learn a tool is to use it. This guide provides opportunities for you to work with the tools under discussion. Specifications for sample projects are given in the example sections, along with an explanation of what is happening behind the scenes. The chapter and examples are intended to showcase different aspects of embedded design. The examples takes you through the entire flow to complete the learning and then moves on to another topic.


When reading this tutorial and running the examples, you might find the following references useful:


- `Vitis Embedded Software Development Flow Documentation <https://docs.xilinx.com/r/en-US/ug1400-vitis-embedded>`_
- :doc:`Vitis Embedded Software Debugging <../../Vitis-Embedded-Software-Debugging/Debugging>`

.. |trade|  unicode:: U+02122 .. TRADEMARK SIGN
   :ltrim:
.. |reg|    unicode:: U+000AE .. REGISTERED TRADEMARK SIGN
   :ltrim:
