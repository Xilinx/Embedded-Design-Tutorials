<p align="right">
            Read this page in other languages:<a href="../docs-jp/6-linux-booting-debug.md">日本語</a>    <table style="width:100%"><table style="width:100%">
  <tr>

<th width="100%" colspan="6"><img src="https://www.xilinx.com/content/dam/xilinx/imgs/press/media-kits/corporate/xilinx-logo.png" width="30%"/><h1>Zynq-7000 SoC Embedded Design Tutorial 2020.2 (UG1165)</h1>
</th>

  </tr>
  <tr>
    <td width="33%" align="center"><a href="../README.md">1. Introduction</a></td>
    <td width="33%" align="center"><a href="2-using-zynq.md">2. Using the Zynq SoC Processing System</a></td>
    <td width="33%" align="center"><a href="3-using-gp-port-zynq.md">3. Using the GP Port in Zynq Devices</a></td>
</tr>
<tr><td width="33%" align="center"><a href="4-debugging-vitis.md">4. Debugging with the Vitis Software Platform</a></td>
    <td width="33%" align="center"><a href="5-using-hp-port.md">5. Using the HP Slave Port with AXI CDMA IP</a></td>
    <td width="33%" align="center">6. Linux Booting and Debug in the Vitis Software Platform</td>
  </tr>
  <tr>
      <td width="33%" align="center"><a href="7-custom-ip-driver-linux.md">7. Creating Custom IP and Device Driver for Linux
  </a></td>
      <td width="33%" align="center"><a href="8-sw-profiling.md">8. Software Profiling Using the Vitis Software Platform</a></td>    
      <td width="33%" align="center"><a href="9-linux-aware-debugging.md">9. Linux Aware Debugging</a></td>    
    </tr>
</table>

# Linux Booting and Debug in the Vitis Software Platform

This chapter describes the steps to configure and build the Linux OS
for a Zynq&reg;-7000 SoC board with PetaLinux Tools. It also provides
information about downloading images precompiled by Linux on the
target memory using a JTAG interface.

The later part of this chapter covers programming the following
non-volatile memory with the precompiled images, which are used for
automatic Linux booting after switching on the board:

-   On-board QSPI Flash

-   SD card

This chapter also describes using the remote debugging feature in the
Xilinx&reg; Vitis unified software platform to debug Linux applications
running on the target board. The Vitis software platform runs on the
Windows host machine. For application debugging, the platform
establishes an Ethernet connection to the target board that is already
running the Linux OS.

## Requirements

In this chapter, the target platform refers to a Zynq SoC board. The
host platform refers to a Windows machine that is running the Vivado&reg;
tools and PetaLinux installed on a Linux machine (either physical or
virtual).

***Note*:** The Das U-Boot universal bootloader is required for the
tutorials in this chapter. It is included in the precompiled images
that you will download next.

From the Xilinx documentation website, download the ZIP file that
accompanies this guide. See [Design Files for This Tutorial](2-using-zynq.md#design-files-for-this-tutorial). It includes the following files:

-   **BOOT.bin:** Binary image containing the FSBL and U-Boot images
    produced by bootgen.

-   **cdma_app.c:** Standalone Application software for the system you
    will create in this chapter.

-   **helloworld.c:** Standalone Application software for the system you
    created in [Using the GP Port in Zynq
    Devices](3-using-gp-port-zynq.md).

-   **linux_cdma_app:** Linux OS based Application software for the
    system you will create in this chapter.

-   **README.txt:** Copyright and release information pertaining to the
    ZIP file.

-   **u-boot.elf:** U-Boot file used to create the BOOT.BIN image.

-   **Image.ub:** PetaLinux build image (with kernel image,
    ramdisk, and dtb)

-   **fsbl.elf:** FSBL image used to create BOOT.BIN image.

## Booting Linux on a Zynq SoC Board

This section covers the flow for booting Linux on the target board
using the precompiled images that you downloaded in
[Requirements](#requirements).

***Note*:** The compilations of the different images like Kernel
image, U-Boot, Device tree, and root file system is beyond the scope
of this guide.

### Boot Methods

The following boot methods are available:

-   Master Boot Method

-   Slave Boot Method

#### *Master Boot Method*

In the master boot method, different kinds of non-volatile memories
such as QSPI, NAND, NOR flash, and SD cards are used to store boot
images. In this method, the CPU loads and executes the external boot
images from non-volatile memory into the Processor System (PS). The
master boot method is further divided into Secure and Non Secure
modes. Refer to the *Zynq-7000 SoC Technical Reference Manual*
([UG585](https://www.xilinx.com/cgi-bin/docs/ndoc?t=user_guides%3Bd%3Dug585-Zynq-7000-TRM.pdf)) for more detail.

The boot process is initiated by one of the Arm&reg; Cortex&trade;-A9 CPUs in
the processing system (PS) and it executes on-chip ROM code. The
on-chip ROM code is responsible for loading the first stage boot
loader (FSBL). The FSBL does the following:

-   Configures the FPGA with the hardware bitstream (if it exists)

-   Configures the MIO interface

-   Initializes the DDR controller

-   Initializes the clock PLL

-   Loads and executes the Linux U-Boot image from non-volatile memory
    to DDR

The U-Boot loads and starts the execution of the kernel image, the
root file system, and the device tree from non-volatile RAM to DDR. It
finishes booting Linux on the target platform.

#### *Slave Boot Method*

JTAG can only be used in slave boot mode. An external host computer
acts as the master to load the boot image into the OCM using a JTAG
connection.

***Note*:** The PS CPU remains in idle mode while the boot image
loads. The slave boot method is always a non-secure mode of booting.

In JTAG boot mode, the CPU enters halt mode immediately after it
disables access to all security related items and enables the JTAG
port. You must download the boot images into the DDR memory before
restarting the CPU for execution.

### Booting Linux from JTAG

The flow chart in the following figure describes the process used to
boot Linux on the target platform.

 ![](./media/X24074-Page-1.png)

### Preparing the PetaLinux Build for Debugging

To debug Linux applications (using tcf-agent), you must manually
enable tcf-agent in PetaLinux RootFS.

Ensure that dropbear-openssh-sftp server is disabled in PetaLinux
RootFS.

***Note*:** The Vitis debugger supports Linux Application Debug using
tcf-agent (TCF - Target Communication Framework). TCF agent is
provided as a part of PetaLinux roofts packages, but needs to be
enabled when required.

Detailed information on enabling these components in the *PetaLinux
Tools Documentation: Reference Guide*
([UG1144](https://www.xilinx.com/cgi-bin/docs/rdoc?v=2020.1%3Bd%3Dug1144-petalinux-tools-reference-guide.pdf)),
section \"Debugging Applications with TCF Agent.\"

### Booting Linux Using JTAG Mode

1.  Check the following board connections and settings for Linux booting
    using JTAG mode:

    a.  Ensure that the settings of Jumpers J27 and J28 are set as
        described in [Creating a Platform Project in the Vitis
        Software Platform with an XSA from
        Vivado](2-using-zynq.md#creating-a-platform-project-in-the-vitis-software-platform-with-an-xsa-from-vivado).

    b.  Ensure that the SW16 switch is set as shown in the following
        figure.

    c.  Connect an Ethernet cable from the Zynq-7000 SoC board to your
        network or directly to your host machine.

    d.  Connect the Windows Host machine to your network.

    e.  Connect the power cable to the board.

        ![](./media/image67.jpeg)        

2.  Connect a USB Micro cable between the Windows host machine and the
    target board with the following SW10 switch settings, as shown in
    the following figure.

    -   Bit-1 is 0

    -   Bit-2 is 1

    ***Note*:** 0 = switch is open. 1 = switch is closed. The correct JTAG
    mode has to be selected, according to the user interface. The JTAG
    mode is controlled by switch SW10 on the zc702 and SW4 on the zc706.

    ![](./media/image68.jpeg)

3.  Connect a USB cable to connector J17 on the target board with the
    Windows Host machine. This is used for USB to serial transfer.

4.  Change Ethernet Jumper J30 and J43 as shown in the following figure.

    ![](./media/image69.jpeg)    

5.  Power on the target board.

6.  Launch the Vitis software platform and open same workspace you used
    in [Using the Zynq SoC Processing System](2-using-zynq.md)
    and [Using the GP Port in Zynq Devices](3-using-gp-port-zynq.md).

7.  If the serial terminal is not open, connect the serial communication
    utility with the baud rate set to **115200**.

    ***Note*:** This is the baud rate that the UART is programmed to on
    Zynq devices.

8.  Download the bitstream by selecting **Xilinx → Program FPGA**, then
    clicking **Program**.

9.  Open the Xilinx System Debugger (XSCT) tool by selecting **Xilinx →
    XSCT Console**.

10. At the XSCT prompt, do the following:

    a.  Type connect to connect with the PS section.

    b.  Type targets to get the list of target processors.

    c.  Type ta 2 to select the processor CPU1.

        ```
        xsct% targets
        1 APU
        2 Arm Cortex-A9 MPCore #0 (Running)
        3 Arm Cortex-A9 MPCore #1 (Running)
        4 xc7z020
        xsct% ta 2
        xsct% targets
        1 APU
        2* Arm Cortex-A9 MPCore #0 (Running)
        3 Arm Cortex-A9 MPCore #1 (Running)
        4 xc7z02022
        ```

    d.  Type dow \<tutorial_download_path\>zynq_fsbl.elf to download
        PetaLinux FSBL.

    e.  Type con to start execution of FSBL and then type stop to stop
        it.

    f.  Type dow \<tutorial_download_path\>/u-boot.elf to download
        PetaLinux U- Boot.elf.

    g.  Type con to start execution of U-Boot. On the serial terminal, the autoboot countdown message appears: ``Hit any key to stop autoboot: 3``.

    h.  Press Enter.Automatic booting from U-Boot stops and a command prompt appears on the serial terminal.

    i.  At the XSCT Prompt, type stop. The U-Boot execution stops.

    j.  Type dow -data image.ub 0x30000000 to download the Linux Kernel
        image at location \<tutorial_download_path\>/image.ub.

    k.  Type con to start executing U-Boot.

11. At the command prompt of the serial terminal, type bootm 0x30000000.
    The Linux OS boots.

12. If required, provide the Zynq login as root and the password as root
    on the serial terminal to complete booting the processor.

    After booting completes, \# prompt appears on the serial terminal.

13. At the root\@xilinx-zc702-2020.1:\~\# prompt, make sure that the
    board Ethernet connection is configured:

    a.  Check the IP address of the board by typing the following
        command at the Zynq prompt: ``ifconfig eth0``.

        This command displays all the details of the currently active
        interface. In the message that displays, the inet addr value denotes
        the IP address that is assigned to the Zynq SoC board.

    b.  If inetaddr and netmask values do not exist, you can assign them using the following commands:

        ```
        root@xilinx-zc702-2020.1:~# ifconfig eth0 inet 192.168.1.10
        root@xilinx-zc702-2020.1:~# ifconfig eth0 netmask 255.255.255.0
        ```

        **IMPORTANT!** *If the target and host are connected back-to-back, you
        must set up the IP address. If the target and host are connected over
        a LAN , DHCP will get the IP address for the target; use the ifconfig
        eth0 to display the IP address.*

        ![](./media/image31.png)

        Next, confirm that the IP address settings on the Windows machine match the board settings. Adjust the local area connection properties by opening your network connections.

          i.  Right-click the local area connection that is linked to the XC702
              board and select Properties.

          ii. With the Local Area Connection properties window open, select
              **Internet Protocol Version 4 (TCP/IPv4)** from the item list and
              select **Properties**.

          iii. Select **Use the following IP address** and set the values as
               follows (also shown in the following figure):

               -   IP address: 192.168.1.11 (target and host must be in the same
                   subnet if connected back- to-back)

               -   Subnet mask: 255.255.255.0

              ![](./media/image79.png)

    c.  Click **OK** to accept the values and close the window.

14. In the Windows machine command prompt, check the connection with the
    board by typing ping followed by the board IP address. The ping response displays in a loop. This response means that the connection between the Windows host machine and the target board is established.

15. Press **Ctrl+C** to stop displaying the ping response on windows
    host machine command prompt. Linux booting completes on the target board and the connection between the host machine and the target board is complete. The next example design describes using the Vitis software platform to debug the Linux application.

### Example Design: Debugging the Linux Application Using the Vitis Software Platform

In this section, you will create a default Linux Hello World
application and practice the steps for debugging the Linux application
from the Windows host machine.

1.  Open the Vitis software platform.

2.  Select **File → New → Application Project**. The New Application
    Project wizard opens.

3.  Use the information in the following table to make your selections
    in the wizard screens.

    <table>
    <thead>
    <tr class="header">
    <th><blockquote>
    <p><strong>Wizard Screen</strong></p>
    </blockquote></th>
    <th><blockquote>
    <p><strong>System Property</strong></p>
    </blockquote></th>
    <th><blockquote>
    <p><strong>Setting or Command to Use</strong></p>
    </blockquote></th>
    </tr>
    </thead>
    <tbody>
    <tr class="odd">
    <td>Platform</td>
    <td>Select a platform from repository</td>
    <td>Click <strong>hw_platform [custom]</strong>.</td>
    </tr>
    <tr class="even">
    <td>Application Project Details</td>
    <td>Application project name</td>
    <td>Enter HelloLinux</td>
    </tr>
    <tr class="odd">
    <td></td>
    <td>Select target processor for the Application project</td>
    <td>Select <strong>ps7_cort exa9 SMP</strong>.</td>
    </tr>
    <tr class="even">
    <td>Domain</td>
    <td>Select a domain</td>
    <td>Click <strong>linux_application_domain</strong>.</td>
    </tr>
    <tr class="odd">
    <td></td>
    <td>Application settings</td>
    <td>If known, enter the sysroot, root FS, and kernel image paths. Otherwise, leave these options blank.</td>
    </tr>
    <tr class="even">
    <td>Templates</td>
    <td>Available Templates</td>
    <td>Linux Hello World</td>
    </tr>
    </tbody>
    </table>

4.  Click **Finish**.

    The New Application Project wizard closes and the Vitis software
    platform creates the HelloLinux project under the Explorer view. Build
    the application project either by clicking the hammer button or by
    right-clicking on the linux_cdma_app project and selecting **Build
    Project**. Binary file linux_cdma_app.elf gets generated.

5.  Right-click **HelloLinux** and select **Debug as→ Debug
    Configurations** to open the Debug Configurations dialog box.

6.  Select **Linux Application Debug** as the **Debug Type**, as shown in the following figure.

    ![](./media/image80.jpeg)    

7.  In the Main tab, Connection field, click **New**.

8.  In the Target Connection Details dialog box (shown in the following
    figure):

    a.  Specify the **Target Name** of your choice.

    b.  In the **Host** field, use the target IP address.

    c.  In the **Port** field, specify 1534.

        ![](./media/image81.png)

9.  Set the application configuration details, as described below (and
    shown in the following figure).

    a.  Select the **Application** tab.

    b.  Set the **Remote File Path**, for example /tmp/hellolinux.elf, and click **Apply**.

    ![](./media/image82.jpeg)        

10. Click **Debug**. The Debug perspective opens.

    From this you can:

    -   Observe that execution stopped at the main() function.

    -   See disassembly points to the address.

    -   Setup break points by right clicking the function on the left side
        of the editor pane (showing the helloworld.c).

    -   Once a breakpoint is set, it appears in the break point list. You
        can observe and modify register contents. Notice that the PC
        register address in the **Breakpoint** view and the address shown
        in the **Disassembly** view are the same (see the following
        figure).

    -   Use **step-into** (F5), **step-return** (F7), **step-over** (F6),
        **Resume** (F8) and **continue debugging** outlined in green in the following figure.

        ![](./media/image84.png)

        **TIP:** *The Linux application output
        displays in the Vitis software platform console, not the Terminal
        window used for running Linux.*

11. After you finish debugging the Linux application, close the Vitis
    IDE.

### Example Project: Booting Linux from QSPI Flash

This example project covers the following steps:

1.  Create the First Stage Boot Loader Executable File.

2.  Make a Linux-bootable image for QSPI flash.

    ![](./media/image85.png)

    PetaLinux must be configured for QSPI
    flash boot mode and rebuilt. By default, the Boot option is SD boot.

    **TIP:** *The ZIP file that accompanies this document contains the
    prebuilt images. If you prefer, you can use these and skip to either*
    [*Booting Linux from QSPI Flash*](#booting-linux-from-qspi-flash) *or
    [Booting Linux from the SD Card](#booting-linux-from-the-sd-card), as
    appropriate to your design.*

3.  Run the following steps on a Linux machine to change the boot mode
    to QSPI flash.

    a.  Change to the root directory of your PetaLinux project:

        ``\$ cd \<plnx-proj-root\>``

    b.  Launch the top-level system configuration menu:

        ``\$ petalinux-config``

    c.  Select Subsystem AUTO Hardware Settings.

    d.  Select Advanced Bootable Images Storage Settings.

        i.  Select **boot image settings**.

        ii. Select **Image Storage Media**.

        iii. Select boot device as **primary flash**.

    e.  Under the **Advanced Bootable Images Storage Settings** sub-menu:

        i.  Select **kernel image settings**.

        ii. Select **Image Storage Media**.

        iii. Select the storage device as **primary flash**.

    f.  Save the configuration settings and exit the configuration wizard.

    g.  Rebuild using the petalinux-build command.

        ***Note*:** For more information, refer to the *PetaLinux Tools
        Documentation: Reference Guide*
        ([UG1144](https://www.xilinx.com/cgi-bin/docs/rdoc?v=2020.1%3Bd%3Dug1144-petalinux-tools-reference-guide.pdf)).

4.  Program QSPI flash with the Boot Image Using JTAG and U-Boot
    Command.

5.  Boot Linux from QSPI flash.

#### Create the First Stage Boot Loader Executable File

1.  Open the Vitis software platform.

2.  Check that the Target Communication Frame (TCF) (hw_server.exe)
    agent is running on your Windows machine. If it is not, in the
    Vitis software platform, select **Xilinx → XSCT Console**.

3.  In the XSCT Console view, type Connect. A message appears, stating that the hw_server application started, or, if it is already running, you will see tcfchan\#, as shown in the following figure.

    ![](./media/image65.jpeg)    

4.  In the Vitis software platform, select **File → New → Application
    Project**. The New Application Project wizard opens.

5.  Use the information the following table to make your selections in
    the wizard screens.

    <table>
    <thead>
    <tr class="header">
    <th><blockquote>
    <p><strong>Wizard Screen</strong></p>
    </blockquote></th>
    <th><blockquote>
    <p><strong>System Property</strong></p>
    </blockquote></th>
    <th><blockquote>
    <p><strong>Setting or Command to Use</strong></p>
    </blockquote></th>
    </tr>
    </thead>
    <tbody>
    <tr class="odd">
    <td><blockquote>
    <p>Platform</p>
    </blockquote></td>
    <td><blockquote>
    <p>Select a platform from repository</p>
    </blockquote></td>
    <td><blockquote>
    <p>Click <strong>hw_platform [custom]</strong>.</p>
    </blockquote></td>
    </tr>
    <tr class="even">
    <td><blockquote>
    <p>Application Project Details</p>
    </blockquote></td>
    <td><blockquote>
    <p>Application project name</p>
    </blockquote></td>
    <td><blockquote>
    <p>Enter fsbl</p>
    </blockquote></td>
    </tr>
    <tr class="odd">
    <td></td>
    <td><blockquote>
    <p>Select target processor for the Application project</p>
    </blockquote></td>
    <td><blockquote>
    <p>Select <strong>ps7_cortexa9_0</strong>.</p>
    </blockquote></td>
    </tr>
    </tbody>
    </table>

    <table>
    <thead>
    <tr class="header">
    <th><blockquote>
    <p><strong>Wizard Screen</strong></p>
    </blockquote></th>
    <th><blockquote>
    <p><strong>System Property</strong></p>
    </blockquote></th>
    <th><blockquote>
    <p><strong>Setting or Command to Use</strong></p>
    </blockquote></th>
    </tr>
    </thead>
    <tbody>
    <tr class="odd">
    <td>Domain</td>
    <td>Select a domain</td>
    <td>Click <strong>standalone on ps7_cortexa9_0</strong>.</td>
    </tr>
    <tr class="even">
    <td>Templates</td>
    <td>Available Templates</td>
    <td>Zynq FSBL</td>
    </tr>
    </tbody>
    </table>

6.  Click **Finish**. If a pop up message comes up that states \"This
    application required xilffs library in Board Support Package\",
    add the xilffs library to the BSP and then and repeat the above
    steps to create an FSBL standalone application.

    The New Application Project wizard closes. The Vitis software platform
    creates the fsbl application project under the Explorer view. For
    generating fsbl.elf build the project by right-clicking on the FSBL
    project and selecting **Build Project**.

#### *Make a Linux Bootable Image for QSPI Flash*

1.  In the Vitis software platform, select **Xilinx → Create Boot Image** to open the Create Boot Image wizard.

    ![](./media/image86.jpeg)    

2.  From the **Architecture** drop-down list, select **Zynq**.

3.  Click **Browse** next to the **Output BIF file path** field, and
    navigate to your output.bif file.

4.  Click **Browse** next to the **Output path** field, and navigate to
    your BOOT.bin file.

    ***Note*:** The QSPI Boot file, BOOT.bin, is available in the ZIP file
    that accompanies this guide. See [Design Files for This
    Tutorial](2-using-zynq.md#design-files-for-this-tutorial).

5.  Click **Add** to add the following boot image partitions:

    -   fsbl.elf (bootloader).

    ***Note*:** You can find fsbl.elf in \<project dir\>/fsbl/Debug.
    Alternatively, you can use fsbl.elf from the file you downloaded in
    [Requirements](#requirements).

      -   Add Bitstream file tutorial_bd_wrapper.bit.

      -   Add U-Boot image u-boot.elf.

      -   Add the PetaLinux output image, image.ub, and provide the offset
          0x520000 (image.ub: PetaLinux image consists of kernel image,
          device tree blob and minimal rootfs).

6.  Click **Create Image** to create the BOOT.bin file in the specified
    output path folder.

#### *Program QSPI Flash with the Boot Image Using JTAG*

You can program QSPI Flash with the boot image using JTAG.

1.  Power on the ZC702 Board.

2.  If a serial terminal is not already open, connect the serial
    terminal with the baud rate set to 115200.

    ***Note*:** This is the baud rate that the UART is programmed to on
    Zynq devices.

3.  Select **Xilinx → XSCT Console** to open the XSCT tool.

4.  From the XSCT prompt, do the following:

    a.  Type connect to connect with the PS section.

    b.  Type targets to get the list of target processors.

    c.  Type ta 2 to select the processor CPU1.

    d.  Type dow fsbl.elf to download the FSBL image.

    e.  Type con and then stop.

    f.  Type dow u-boot.elf to download the Linux U-Boot.

    g.  Type dow -data BOOT.bin 0x08000000 to download the Linux
        bootable image to the target memory at location 0x08000000.

        You just downloaded the binary executable to DDR memory. You can
        download the binary executable to any address in DDR memory.

    h.  Type con to start execution of U-Boot. U-Boot begins booting. On the serial terminal, the autoboot countdown message appears:

        ``Hit any key to stop autoboot: 3``

5.  Press Enter. Automatic booting from U-Boot stops and the U-Boot command prompt appears on the serial terminal.

6.  Do the following steps to program U-Boot with the bootable image:

    a.  At the prompt, type sf probe 0 0 0 to select the QSPI Flash.

    b.  Type sf erase 0 0x01000000 to erase the Flash data.This command completely erases 16 MB of on-board QSPI Flash memory.

    c.  Type sf write 0x08000000 0 0xffffff to write the boot image on the
    QSPI Flash.

    Note that you already copied the bootable image at DDR location
    0x08000000. This command copied the data, of the size equivalent to
    the bootable image size, from DDR to QSPI location 0x0.

    For this example, because you have 16 MB of Flash memory, you copied
    16 MB of data. You can change the argument to adjust the bootable
    image size.

7.  Power off the board and follow the booting steps described in the
    following section.

#### Program QSPI Flash with the Flash Programming Tool

Following the steps below, you can program QSPI Flash with the flash
programming tool in the Vitis software platform:

1.  Power on the ZC702 Board.

2.  If a serial terminal is not open, connect the serial terminal with
    the baud rate set to 115200.

***Note*:** This is the baud rate to which the UART is programmed on
Zynq devices.

3.  Select **Xilinx → Program Flash**.

4.  Select the BOOT.bin file to flash and select **Program** (see the following figure).

      ![](./media/image87.png)    

On successful programming, a message appears in the console window
saying Flash Operation Successful.

5.  Power off the board and follow the booting steps in [Booting Linux
    from QSPI Flash](#booting-linux-from-qspi-flash) or [Booting Linux
    from the SD Card](#booting-linux-from-the-sd-card), as appropriate
    to your design.

#### *Booting Linux from QSPI Flash*

1.  After you program the QSPI Flash, set the SW16 switch on your board as shown in the following figure.

    ![](./media/image88.jpeg)    

2.  Connect the Serial terminal using an 115200 baud rate setting.

    ***Note*:** This is the baud rate that the UART is programmed to on
    Zynq devices.

3.  Switch on the board power.

    A Linux booting message appears on the serial terminal. After booting
    finishes, the root\@xilinx-zc702-2020_1:\~\# prompt appears. Enter the
    login and password as root when prompted.

4.  Check the Board IP address connectivity as described in [Booting Linux Using JTAG Mode](#booting-linux-using-jtag-mode).

    For Linux Application creation and debugging, refer to [Example Design: Debugging the Linux Application Using the Vitis Software Platform](#example-design-debugging-the-linux-application-using-the-vitis-software-platform).

#### Booting Linux from the SD Card

1.  Change the SW16 switch setting as shown in the following figure.

    ![](./media/image89.jpeg)

2.  Make the board settings as described in [Booting Linux Using JTAG
    Mode](#booting-linux-using-jtag-mode).

3.  Create a first stage bootloader (FSBL) for your design as described
    in [Create the First Stage Boot Loader Executable
    File](#create-the-first-stage-boot-loader-executable-file).

    ***Note*:** If you do not need to change the default FSBL image, you
    can use the fsbl.elf file that you downloaded as part of the ZIP file
    for this guide. See [Design Files for This
    Tutorial](2-using-zynq.md#design-files-for-this-tutorial).

4.  In the Vitis IDE, select **Xilinx → Create Boot Image** to open the
    Create Boot Image wizard.

5.  Add fsbl.elf, bit file (if any), and u-boot.elf.

6.  Provide the output folder path in the Output folder field.

7.  Click **Create Image**. The Vitis software platform generates the
    BOOT.bin file in the specified folder.

    ![](./media/image90.jpeg)

8.  Copy BOOT.bin and image.ub to the SD card.

    ![](./media/image91.png)    

    **IMPORTANT!** *Do not change the file names. U-Boot searches for
    these file names in the SD card while booting the system.*

9.  Turn on the power to the board and check the messages on the Serial
    terminal. The root\@plnx_arm:\~\# prompt appears after Linux booting is complete on the target board.

10. Set the board IP address and check the connectivity as described in
    [Booting Linux Using JTAG Mode](#booting-linux-using-jtag-mode).

For Linux application creation and debugging, see [Example Design: Debugging the Linux Application Using the Vitis Software Platform](#example-design-debugging-the-linux-application-using-the-vitis-software-platform).

© Copyright 2015–2020 Xilinx, Inc.
