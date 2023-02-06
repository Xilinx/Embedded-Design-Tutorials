..
   Copyright 2000-2021 Xilinx, Inc.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

**********************************************************************
System Design Example for High-Speed Debug Port with SmartLynq+ Module
**********************************************************************

============
Introduction
============

This chapter demonstrates how to build a Versal |trade|-based system that utilizes both the SmartLynq+ module and the High-Speed Debug Port (HSDP). You will also learn to set up the SmartLynq+ module and download a Linux image using either JTAG or the HSDP.

.. important:: This tutorial requires a SmartLynq+ module, a VCK190 or VMK180 evaluation board, and a Linux host machine.

=================================
Design Example: Enabling the HSDP
=================================

To enable the HSDP, start with the VCK190 or VMK180 project that you built in the preceding chapter and modify the project to include HSDP support.  It is also possible to start this chapter standalone by sourcing the included block design Tcl to create the HSDP capable design. See `Prod_Si/smartlynq_plus/bd_tcl`.

Modifying the Design to Enable the HSDP
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This design uses the project built in `System Design Example using Scalar Engine and Adaptable Engine <../docs/5-system-design-example.rst>`__ and enables the HSDP interface. You can do this using the Vivado |trade| IP integrator.

1. Open the Vivado project you created in `System Design Example using Scalar Engine and Adaptable Engine <../docs/5-system-design-example.rst>`__.

   `C:/edt/edt_versal/edt_versal.xpr`

2. In the Flow Navigator, under **IP Integrator**, click **Open Block Design**.

   .. image:: ./media/image5.png

3. Double-click the Versal ACAP CIPS IP core to recustomize the IP. Click the **Next** button and click on the blue box labeled **PS PMC** to customize the Processing System (PS) and the Platform Management Controller (PMC). On the left pane, select  click **Debug** then click on the **HSDP** tab.
   
   .. image:: ./media/ch6-image1.png

4. Under **High-Speed Debug Port (HSDP)**, select **AURORA** as the **Pathway to/from Debug Packet Controller (DPC)**.

   .. image:: ./media/ch6-image2.png

5. Set the following options:
   - **GT Selection** to **HSDP1 GT**
   - **GT Refclk Selection** to **REFCLK1**
   - **GT Refclk Freq (MHz)** to **156.25**

   .. note:: Line rate is fixed at 10.0 Gb/s.

6. Click **OK** to save the changes. Two ports, `gt_refclk1` and `HSDP1_GT`, are created on the CIPS IP.

7. On the **IP Integrator** page, right-click `gt_refclk1` and select **Make External**. Do the same for **HSDP1_GT**.

   .. image:: ./media/ch6-image4.png

   .. image:: ./media/ch6-image5.png

8. Click **Validate Design**, then **Save**.

Synthesizing, Implementing, and Generating the Device Image
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. In the Flow Navigator, under **Programming and Debug**, click **Generate Device Image** to launch implementation.
  
   When the device image generation completes, the Device Image Generation Completed dialog box opens.

   .. image:: ./media/ch6-image9.png

Exporting Hardware (XSA)
~~~~~~~~~~~~~~~~~~~~~~~~

1. Select **File → Export → Export Hardware** from the Vivado toolbar. The Export Hardware dialog box opens.

   .. image:: ./media/ch6-image10.png

2. Choose **Fixed**, then click **Next**.

3. Choose **Include Device Image**, then click **Next**.

4. Provide the name for your exported file (example: `edt_versal_wrapper_with_hsdp`). Click **Next**.

5. Click **Finish**.

=====================================================
Creating the HSDP-enabled Linux Image Using PetaLinux
=====================================================

This example rebuilds the PetaLinux project using the HSDP-enabled XSA that was built in the preceding step. The assumption is that the PetaLinux project has been created as per the instructions in `System Design Example using Scalar Engine and Adaptable Engine <../docs/5-system-design-example.rst>`__.

.. important:: If you are building this tutorial without having created a PetaLinux project in the preceding chapter, follow steps 1 through 12 in the `Example Project: Creating Linux Images Using PetaLinux <../docs/5-system-design-example.rst#example-project-creating-Linux-images-using-petalinux>`__ section to create a new PetaLinux project.

This example needs a Linux host machine. Refer to the *PetaLinux Tools Documentation Reference Guide* `[UG1144] <https://www.xilinx.com/cgi-bin/docs/rdoc?v=latest;d=ug1144-petalinux-tools-reference-guide.pdf>`__ for information on dependencies and installation procedure for the PetaLinux tool.

1. Change to the PetaLinux project directory that was created in `Example Project: Creating Linux Images Using PetaLinux <../docs/5-system-design-example.rst#example-project-creating-Linux-images-using-petalinux>`__ using the following command.

   .. code-block::

        $ cd led_example

2. Copy the new hardware platform project XSA to the Linux host machine one directory above the PetaLinux build root.

   .. note:: Make sure that you are using the updated the XSA file which you generated in the prior step.

3. Reconfigure the BSP using the following commands.

   .. code-block::
        
        $ petalinux-config --get-hw-description=<path till the directory containing the respective xsa file>

4. Build the Linux images using the following command.

   .. code-block::
    
        $ petalinux-build

5. Once the build completes, package the boot images with the following command:

   .. code-block::

        $ petalinux-package --force --boot --atf --u-boot

   .. note:: The packaged Linux boot images are placed in the `<petaLinux-project>/images/Linux/` directory in the PetaLinux build root. Make a note of this directory location as it will be used in the following steps. If you intend to use a different machine than the one that was used to build PetaLinux (for example, a Windows Based PC) to download the Linux boot images using SmartLynq+, the contents of this directory should be transferred to that machine before proceeding with this tutorial.

================================
Setting Up the SmartLynq+ Module
================================

Once the Linux images have been built and packaged, they can be loaded onto the VCK190 or VMK180 board using either JTAG or HSDP. To set up the SmartLynq+ module for connectivity using HSDP, follow these steps:

1. Connect the USB-C cable between the VCK190 USB-C connector and the SmartLynq+ module.

   .. image:: ./media/ch6-slp1.png

2. Connect the SmartLynq+ to either Ethernet or USB.

    *  **Using Ethernet:** Connect an Ethernet cable between Ethernet port on the SmartLynq+ and your local area network.
    *  **Using USB:** Connect the provided USB cable between the USB port on the SmartLynq+ and your PC.

3. Connect the power adapter to the SmartLynq+ and power on the VCK190/VMK180 board.

   .. note:: Connect the Ethernet cable to the target device before booting the board.

4. Once the SmartLynq+ finishes booting up, an IP address appears on the screen under either `eth0` or `usb0`. Make note of this IP address as this is the IP address used to connect to the SmartLynq+ in both the Ethernet and USB use case.

   .. image:: ./media/ch6-image23.jpg

   .. note:: If using Ethernet, the SmartLynq+ acquires an IP address from a DHCP server found on the network. If using USB, the USB port has a fixed IP address of `10.0.0.2`.

5. Copy the Linux download scripts from the design package `<design-package>/smartlynq_plus/xsdb`.

Using the SmartLynq+ as a Serial Terminal
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The SmartLynq+ can also be used as a serial terminal to remotely view the UART output from the VCK190. This feature is useful when physical access to the remote setup is not available. The SmartLynq+ module has the minicom application pre-installed, which can be used to connect directly to the UART on the VCK190.

1. Using an SSH client such as `PuTTY` on Windows or `ssh` on Unix-based systems, connect using SSH to the IP address shown on the SmartLynq+ display.

   * Username: `xilinx`
   * Password: `xilinx`

   For example, if your SmartLynq+ displays an IP address `192.168.0.10`, you should issue the following command: `ssh xilinx@192.168.0.10`.

2. By default, the minicom application uses the hardware flow control. To successfully connect to the UART on Xilinx boards, hardware flow control should be disabled as it is not used on the VCK190 UART. To do this, enter the minicom setup mode by issuing `sudo minicom -s` and disabling the feature. Alternatively, issue the following command as root to modify the minicom default configuration:

   .. code-block::

        echo "pu rtscts No" | sudo tee -a /etc/minicom/minirc.dfl

3. Finally, to connect to the VCK190/VMK180 serial terminal output do the following:

   .. code-block::
        
        sudo minicom --device /dev/ttyUSB1

4. Leave this terminal open and proceed to the next section.

   .. image:: ./media/ch6-image15.png

Booting Linux Images over JTAG or HSDP
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SmartLynq+ can be used to download Linux images directly to the VCK190/VMK180 without using an SD Card. Linux images can be loaded using JTAG or HSDP.

The design package included with this tutorial contains a script that downloads the Linux images created in the prior steps using the SmartLynq+ module. The script can use either JTAG or HSDP.  

1. On the machine with access to the SmartLynq+ module, open the Vivado tcl shell.

   .. image:: ./media/ch6-image24.png

2. Change the working directory to the PetaLinux build root, if working on the machine used to build PetaLinux, or change to the location where the `images/linux` directory was transferred to the local machine in the preceding steps.

3. At the Vivado tcl shell, issue the following command to download the images using HSDP:

   .. code-block::
    
        xsdb linux_download.tcl <smartlynq+ ip> images/linux HSDP

   This loads `BOOT.BIN` using JTAG, following which an HSDP link is auto-negotiated and the rest of the boot images are loaded using HSDP. This increases the speed substantially compared to JTAG.

   .. image:: ./media/ch6-image16.png

   .. note:: You can also download Linux images using JTAG by changing the last argument of the script to `FTDI-JTAG` as shown: `xsdb linux-download <smartlynq+ ip> images/linux FTDI-JTAG`. This uses the JTAG to program all of the Linux boot images. Note the difference in download speed when using HSDP.

4. Versal boot messages can be viewed from the VCK190 UART on the terminal opened in the preceding section:

   .. image:: ./media/ch6-image17.png

5. Once Linux has completed booting using either JTAG or HSDP, you will be presented with the following login screen:

   .. image:: ./media/ch6-image18.png

============
Useful Links
============

* For more information on using PL hardware debug cores such as the AXIS-ILA, AXIS-VIO, PCIe |trade| Debugger, and/or DDRMC Calibration Interfaces refer to the *Vivado Design Suite User Guide Programming and Debugging* `[UG908] <https://www.xilinx.com/support/documentation/sw_manuals/xilinx2020_2/ug908-vivado-programming-debugging.pdf>`__.

* For more information on the SmartLynq+ Module, refer to `SmartLynq+ Module User Guide <https://www.xilinx.com/support/documentation/boards_and_kits/smartlynq/ug1258-smartlynq-cable.pdf>`__.

=======
Summary
=======

In this section you have built a design that uses the HSDP, connected the SmartLynq+ module, configured the SmartLynq+ for remote UART access, and used the HSDP to download Linux images onto your board.

.. |trade|  unicode:: U+02122 .. TRADEMARK SIGN
   :ltrim:
.. |reg|    unicode:: U+000AE .. REGISTERED TRADEMARK SIGN
   :ltrim:


