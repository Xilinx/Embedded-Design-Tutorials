# System Design Example for SmartLynq+ HSDP

## Introduction
This chapter guides you through building a system based on Versal devices that utilizes both the SmartLynq+ Module and High-Speed Debug Port (HSDP).  It also demonstrates the steps to setup the SmartLynq+ Module and download a Linux image using either JTAG or High-Speed Debug Port. 

> **Important:** This tutorial requires a SmartLynq+ Module.

## Design Example: Enabling High-Speed Debug Port (HSDP)
To use High-Speed Debug Port, the design must be modified to include HSDP support.  This section will modify the project built in the prior chapter to enable the High-Speed Debug Port interface.  

### Modifying the Chapter 5 design to enable High-Speed Debug Port (HSDP)

This design uses the project built in chapter 5 and enables the High-Speed Debug Port (HSDP) interface.  You can do this using the Vivado IP Integrator.  
1. Open the Vivado project you created in [Chapter 5: System Design Example using Scalar Engine and Adaptable Engine](#chapter-5).

    `C:/edt/edt_versal/edt_versal.xpr`

2. In the Flow Navigator, under **IP Integrator**, click **Open Block
     Design**.

    ![](./media/image5.png)

1. Double-click the Versal ACAP CIPS IP core and click **Debug -> Debug Configuration**.
    ![](./media/ch6-image1.png)

1. Under **High-Speed Debug Port (HSDP)** select **AURORA** as the **Pathway to/from Debug Packet Controller (DPC)**.   ![](./media/ch6-image2.png)

1. Set the following options:
   - **GT Selection** to **HSDP1 GT**
   - **GT Refclk Selection** to **REFCLK1** 
   - **GT Refclk Freq (MHz)** to **156.25**  
   **Note:** _Line rate will be fixed at **10.0 Gbps**._
<!-- 1. When finished the High-Speed Debug Port menu should contain the following settings:
     ![](./media/ch6-image3.png) -->

1. Click **OK** to save the changes.  Two ports will be created on the CIPS IP `gt_refclk1` and `HSDP1_GT`.

1. In the **IP Integrator** canvas, right click on `gt_refclk1` and select **Make External**.  Do the same for **HSDP1\_GT**.
    ![](./media/ch6-image4.png)
    ![](./media/ch6-image5.png)

1. Click **Validate Design**, then **Save**.

### Synthesizing, Implementing, and Generating the Device Image

1. In the Flow Navigator, under **Programming and Debug**, click **Generate Device Image** to launch implementation.
  _Note: when the device image generation completes, the device image generation completed dialog box opens._
    ![](./media/ch6-image9.png)

### Exporting Hardware (XSA)

1.  From the Vivado tool-bar, select **File → Export → Export Hardware**.  The Export Hardware Dialog Box will open.
    ![](./media/ch6-image10.png)

1.  Choose **Fixed** and click **Next**.

1.  Choose **Include Device Image** and click **Next**.

1.  Provide the name for your exported file (example: `edt_versal_wrapper_with_hsdp`).  Click **Next**.

1.  Click **Finish**.

## Creating the HSDP Enabled Linux Image Using Petalinux

This example re-builds the PetaLinux project using the HSDP enabled XSA that was built in the prior step.  The assumption is that the PetaLinux project has been created as per the instructions in [Chapter 5](5-system-design-example.md).

> **Important:** If you are building this tutorial without having created a PetaLinux project in the prior chapter, you can follow steps 1 through 12 in the section [Example Project: Creating Linux Images Using PetaLinux](5-system-design-example.md#example-project-creating-linux-images-using-petalinux) to create a new PetaLinux project.

This example needs a Linux host machine. Refer to the [PetaLinux Tools Documentation Reference Guide (UG1144)](https://www.xilinx.com/member/versal_tools_ea.html#embedded) for information on dependencies and installation procedure for the PetaLinux tool.


1. Change to the PetaLinux project directory that was created in [Chapter 5](5-system-design-example.md#example-project-creating-linux-images-using-petalinux) using the following command.

    `$ cd led_example`

1. Copy the new hardware platform project XSA to the Linux host machine.

    >***Note*:** Ensure you are using the updated the XSA file which you generated in the prior step.

1. Build the Linux images using the following command.

    `$ petalinux-build`

1.  Once the build completes, package the boot images with the following command:
    
    `$ petalinux-package --force --boot --atf --u-boot` 

    > **Note:** The packaged linux boot images will be placed in the `images/linux` directory in the PetaLinux build root.  Make a note of this directory location as it will be used in the next steps.  If you intend to use a different machine than the one that was used to build PetaLinux or a Windows based PC to download the Linux boot images using SmartLynq+ the contents of this directory should be transferred to that machine before proceeding to the next steps.
    
## Setting Up The SmartLynq+ Module

Once the Linux images have been built and packaged, they can be loaded onto the VCK190 or VMK180 board using either JTAG or HSDP.  This section will guide you through the basic steps required to setup the SmartLynq+ module for connectivity using HSDP.

1.  Connect the USB-C cable between the VCK190 USB-C connector found on the  and the SmartLynq+ Module.
1.  Connect the SmartLynq+ to either Ethernet or USB.
    * **Using Ethernet:** Connect an Ethernet cable between Ethernet port on the SmartLynq+ and your local area network.
    * **Using USB:** Connect the provided USB cable between the USB port on the SmartLynq+ and your PC.
1.  Connect the SmartLynq+'s provided power adapter to the SmartLynq+ and power on the VCK190/VMK180 board.
1.  Once the SmartLynq+ finishes booting up an IP address will appear on the screen under either `eth0` or `usb0`.  This will be the IP address used to connect to the SmartLynq+ in both the Ethernet and USB use case.
    > **Note:** If using Ethernet the SmartLynq+ will acquire an IP address from a DHCP server found on the network.  If using USB the USB port will have a fixed IP of `10.0.0.2`. 
1.  Copy the Linux download scripts from the design package `<design-package>/smartlynq_plus/xsdb`.

### Using The SmartLynq+ as a Serial Terminal

The SmartLynq+ can also be used as a serial terminal to remotely view UART output from the VCK190.  This feature can be useful when physical access to the remote setup is not available.  The SmartLynq+ module has the minicom application pre-installed, which can be used to connect directly to the UART on the VCK190.

1.  Using an SSH client such as `PuTTY` on Windows or `ssh` on Unix based systems, connect using SSH to the IP address shown on the SmartLynq+ display.  
    * Username: `xilinx`
    * Password: `xilinx`
    > For example, if your SmartLynq+ displays IP address `192.168.0.10`, you should issue the following command: `ssh xilinx@192.168.0.10`.

1.  By default, the minicom application will use hardware flow control. To successfully connect to the UART on Xilinx boards, hardware flow control should be disabled as it is not used on the VCK190 UART.  This can be done by entering the minicom setup mode by issuing `sudo minicom -s` and disabling the feature or by issuing the following command as root to modify the minicom default configuration:
    `echo "pu rtscts No" | sudo tee -a /etc/minicom/minirc.dfl`

1.  Finally, to connect to the VCK190/VMK180 serial terminal output do the following:
    * `sudo minicom --device /dev/ttyUSB1`

1.  Leave this terminal open and proceed to the next section.
    ![](./media/ch6-image15.png)

### Booting Linux Images over JTAG or HSDP

SmartLynq+ can be used to download linux images directly to the VCK190/VMK180 without using an SD Card.  Linux images can be loaded using JTAG or HSDP.

The design package included with this tutorial contains a script that will download the Linux images created in the prior steps using the SmartLynq+ Module.  The script can use either JTAG or HSDP.  

1.  On the machine with access to the SmartLynq+ Module, open the Vivado tcl shell.
1.  Change the working directory to the petalinux build root if working on the machine used to build petalinux, or the location where the `images/linux` directory was transfered to the local machine in the [prior step]().
1.  At the Vivado tcl shell, issue the following to download the images using HSDP:
    * `xsdb linux_download.tcl <smartlynq+ ip> images/linux HSDP`.  
        * This will first load `BOOT.BIN` using JTAG after which an HSDP link will be auto-negotiated and the rest of the boot images will be loaded using HSDP, offering a substantial speed increase compared to JTAG.
    ![](./media/ch6-image16.png)
    > **Note:** It is also possible to download the Linux images using JTAG by changing the scripts last argument to `FTDI-JTAG` `xsdb linux-download <smartlynq+ ip> images/linux FTDI-JTAG`. This will use JTAG to program all of the Linux boot images.  Take note of the difference in download speed when using HSDP.
1.  Returning to the terminal opened in the prior section, Versal boot messages can be viewed from the VCK190 UART:
    ![](./media/ch6-image17.png)
1.  Once Linux has completed booting using either JTAG or HSDP, you will be presented with the following login screen:
    ![](./media/ch6-image18.png)




