<p align="right">
            Read this page in other languages:<a href="../docs-jp/4-debugging-vitis.md">日本語</a>    <table style="width:100%"><table style="width:100%">
  <tr>

<th width="100%" colspan="6"><img src="https://www.xilinx.com/content/dam/xilinx/imgs/press/media-kits/corporate/xilinx-logo.png" width="30%"/><h1>Zynq-7000 SoC Embedded Design Tutorial 2020.2 (UG1165)</h1>
</th>

  </tr>

</table>

# Building and Debugging Linux Applications

The earlier examples highlighted the creation of bootloader images and bare-metal applications for APU, RPU, and PMU using the Vitis™ IDE. This chapter demonstrates how to develop Linux applications.

## Example 3: Creating Linux Images and Applications using PetaLinux

In this example, you will configure and build a Linux operating system platform for an Arm™ Cortex-A9 core based APU on a Zynq® 7000. You can configure and build Linux images using the PetaLinux tool flow, along with the board-specific BSP. The Linux application is developed in the Vitis IDE.

### Input and Output Files

- Input:
  - Hardware XSA (``system_wrapper.xsa`` generated in Example 1)
  - [PetaLinux ZC702 BSP](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-design-tools.html)

- Output:
  - PetaLinux boot images (``BOOT.BIN``, ``image.ub``)
  - PetaLinux application (hello_linux)

 **IMPORTANT!:**

> 1. This example requires a Linux host machine with PetaLinux installed. Refer to the _PetaLinux Tools Documentation: Reference Guide_ ([UG1144](https://www.xilinx.com/cgi-bin/docs/rdoc?v=latest;d=ug1144-petalinux-tools-reference-guide.pdf)) for information about dependencies for PetaLinux 2020.2.

> 2. This example uses the [PetaLinux ZC702 BSP](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-design-tools.html) to create a PetaLinux project. Ensure that you have downloaded the zc702 BSP for PetaLinux as instructed on the [PetaLinux Tools download page](https://www.xilinx.com/member/forms/download/xef.html?filename=xilinx-zc702-v2020.2-final.bsp).

### Creating a PetaLinux Image

1. Create a PetaLinux project using the following command:

    ```bash
    petalinux-create -t project -s <path to the xilinx-zc702-v2020.2-final.bsp>
    ```

    **Note:** ``xilinx-zc702-v2020.2-final.bsp`` is the PetaLinux BSP for the zc702 Production Silicon Rev 1.0 Board.

    This creates a PetaLinux project directory, ``xilinx-zc702-2020.2``.

2. Reconfigure the project with ``system_wrapper.xsa``:

   - The created PetaLinux project uses the default hardware setup in the ZC702 Linux BSP. In this example, you will reconfigure the PetaLinux project based on the Zynq design that you configured using the Vivado® Design Suite in [Example 1](./2-using-zynq.md#example-1-creating-a-new-embedded-project-with-zynq-soc).

   - Copy the hardware platform ``system_wrapper.xsa`` to the Linux host machine.

   - Reconfigure the project using the following command:

   ```bash
   cd xilinx-zc702-2020.2
   petalinux-config --get-hw-description=<path containing system_wrapper.xsa>
   ```

    This command opens the PetaLinux Configuration window. You can review these settings. If required, make changes in the configuration. For this example, the default settings from the BSP are sufficient to generate the required boot images.

    If you would prefer to skip the configuration window and keep the default settings, run the following command:

    ```
    petalinux-config --get-hw-description=<path containing system_wrapper.xsa> --silentconfig
    ```

3.  Build the PetaLinux project:

    - In the `<PetaLinux-project>` directory, e.g. ``xilinx-zc702-2020.2``, build the Linux images using the following command:

    ```bash
    petalinux-build
    ```

    After the above statement executes successfully, verify the images
     and the timestamp in the images directory in the PetaLinux project
     folder using the following commands:

    ``` bash
    cd images/linux
    ls -al
    ```

4.  Generate the boot image using the following command:

    ```bash
    petalinux-package --boot --fsbl zynqmp_fsbl.elf --u-boot
    ```

    This creates a ``BOOT.BIN`` image file in the ``<petalinux-project>/images/linux/`` directory.

    The logs indicate that the above command includes PMU_FW and ATF in ``BOOT.BIN``. You can also add `--pmufw <PMUFW_ELF>` and `--atf <ATF_ELF>` in the above command if you would prefer to use custom firmware images. Refer to `petalinux-package --boot --help` for more details about the boot image package command.

    **Note:** The option to add bitstream, `--fpga`, is missing
    from the above command intentionally because so far the hardware
    configuration is based only on a PS with no design in the PL. If a bitstream
    is present in the design, `--fpga` can be added in the
    ``petalinux-package`` command as shown below:

    ```bash
    petalinux-package --boot --fsbl zynqmp_fsbl.elf --fpga system.bit --pmufw pmufw.elf --atf bl31.elf --u-boot u-boot.elf
    ```

### Verifyìng the Image on the ZC702 Board

 To verify the image, follow these steps:

1. Copy the `BOOT.BIN`, `image.ub`, and `boot.scr` files to the SD card. Here, `boot.scr` is read by U-Boot to load the kernel and rootfs.

2. Load the SD card into the zc702 board, in the J100 connector.
<!--TODO: update SW number for SD Boot-->
3. Configure the board to boot in SD boot mode by setting switch SW6 as
     shown in the following figure.

    ![](./media/image43.jpeg)

5. Connect 12V power to the zc702 6-pin Molex connector.

6. Start a serial terminal session using Tera Term or Minicom depending on the host machine being used. set the COM port and baud rate for your system as shown in the following figure.

     ![Tera Term Connection](./media/image44.png)

7. For port settings, verify the COM port in the device manager and select the COM port with interface-0.

8. Turn on the ZC702 board using SW1, and wait until Linux loads on the board.


<!--Merge with the next chapter-->
### Linux Domain Creation for Linux Applications

Now that Linux is running on the board, you can create a Linux domain
followed by a Linux application. The steps to create a Linux domain
are given below:

1.  Go to the Explorer view in the Vitis software platform and expand
    the **hw_platform** platform project.

2.  Open the hardware by double clicking **platform.spr**.

3.  The platform view opens. Click the **+** button in the right corner
    to add a domain, as shown in the following figure.

    ![](./media/image73.jpeg)

4.  When the New Domain dialog box opens, enter the details as given
    below:

    | Option             | Value                    |
    | ------------------ | ------------------------ |
    | Name               | linux_domain             |
    | Display Name       | linux_application_domain |
    | OS                 | Linux                    |
    | Processor          | ps7_cortexa9             |
    | Supported Runtimes | C/C++                    |

    - Select **Use pre-built software components**

    - Create one boot directory in the C:\designs folder, then copy the
    boot components into it (FSBL, PMUFW from the Vitis software
    platform, ATF, u-boot.elf and image.ub from PetaLinux).

    - Create one BIF file as below.

    ![](./media/image74.png)   

    - Click **OK** to finish and observe
    that the Linux domain has been added to the hw_platform as shown
    below.

    ![](./media/image75.jpeg)    

    Now you are ready with Linux domain to create Linux applications.


### Creating Linux Applications in the Vitis IDE

1. Create a Linux domain:

   - Double-click **platform.spr** in the zc702_edt platform to open platform configurations.
   - Click the **+** button to add a domain.
   - Input the following domain parameters:
       - Name: **linux**
       - OS: **linux**
       - Keep the other options as-is and click **OK**.
   - Review the Linux domain configuration details.
   - Build the platform project by clicking the hammer icon.

   ![Linux domain configuration details](media/linux_domain_details.png)

2. Create a Linux application:

   - Click **File → New → Application Project**.
   - Click **Next** on the welcome page.
   - Select platform: **zc702_edt**. Click **Next**.
   - Enter the application project name, **hello_linux**, and the target processor, **psu_cortexa53 SMP**.
   - Keep the default domain: **linux**.
   - Keep the SYSROOT, rootfs, and kernel image empty, and click **Next**.
   - Select the **Linux Hello World** template. Click **Finish**.

   **Note:** If you input an extracted SYSROOT directory, Vitis can find include files and libraries in SYSROOT. SYSROOT is generated by the PetaLinux project `petalinux-build --sdk`. Refer to the _PetaLinux Tools Documentation: Reference Guide_ ([UG1144](https://www.xilinx.com/cgi-bin/docs/rdoc?v=2020.2;d=ug1144-petalinux-tools-reference-guide.pdf)) for more information about SYSROOT generation.

   **Note:** If you input a rootfs and kernel image, Vitis can help to generate the ``SD_card.img`` when building the Linux system project.

3. Build the hello_linux application.

   - Select **hello_linux**.
   - Click the hammer button to build the application.

### Preparing the Linux Agent for Remote Connection

The Vitis IDE needs a channel to download the application to the running target. When the target runs Linux, it uses TCF Agent running on Linux. TCF Agent is added to the Linux rootfs from the PetaLinux configuration by default. When Linux boots up, it launches TCF Agent automatically. The Vitis IDE talks to TCF Agent on the board using an Ethernet connection.

1. Prepare for running the Linux application on the zc702 board. Vitis can download the Linux application to the board, which runs Linux through a network connection. It is important to ensure that the connection between the host machine and the board works well.

   - Make sure the USB UART cable is still connected with the zc702 board. Turn on your serial console and connect to the UART port.
   - Connect an Ethernet cable between the host and the zc702 board.
       - It can be a direct connection from the host to the zc702 board.
       - You can also connect the host and the zc702 board using a router.
   - Power on the board and let Linux run on zc702 (see [Verifying the Image on the zc702 Board](#verify-the-image-on-the-zc702-board)).
   - Set up a networking software environment.
       - If the host and the board are connected directly, run `ifconfig eth0 192.168.1.1` to setup an IP address on the board. Go to **Control Panel → Network and Internet → Network and Sharing Center**, and click **Change Adapter Settings**. Find your Ethernet adapter, then right-click and select **Properties**. Double-click **Internet Protocol Version 4 (TCP/IPv4)**, and select **Use the following IP address**. Input the IP address **192.168.1.2**. Click **OK**.
       - If the host and the board are connected through a router, they should be able to get an IP address from the router. If the Ethernet cable is plugged in after the board boots up, you can get the IP address manually by running the `udhcpc eth0` command, which returns the board IP address.
       - Have the host and the zc702 board ping each other to make sure the network is set up correctly.

2. Set up the Linux agent in the Vitis IDE.

   - Click the **Target Connections** icon on the toolbar.
   - It can also be launched by going to **Window → Show View...** and then looking for the target.

   ![Vitis Show View search for Target Connections](media/vitis_launch_target_connections.png)

   - In the Target Connections window, double-click **Linux TCF Agent → Linux Agent[default]**.
   - Input the IP address of your board.
   - Click **Test Connection**.

   ![Vitis test connection details](media/vitis_target_connection_details.png)

   - Vitis should return a pop-up confirmation for success.

   ![Vitis test connection success](media/vitis_test_connection_success.png)

### Running the Linux Application from the Vitis IDE

1. Run the Linux application:

   - Right-click **hello_linux**, and select **Run As → Run Configurations**.
   - Expand **Single Application Debug** and select **Debugger_hello_linux-Default**.
   - Review the configurations:
       - Debug type: **Linux Application Debug**
       - Connection: **Linux Agent**
   - Click **Run**.

   ![Vitis Linux Run Configurations](media/vitis_linux_run_configurations.png)

   - The console should print **Hello World**.

    ![Linux Hello World run result](media/linux_hello_world.png)


2. Disconnect the connection:

   - Click the **Terminate** button on the toolbar or press **Ctrl+F2**.
   - Click the **Disconnect** button on the toolbar.

### Debugging a Linux Application from the Vitis IDE

Debugging Linux applications requires the Linux agent to be set up properly. Refer to [Preparing the Linux Agent for Remote Connection](#prepare-linux-agent-for-remote-connection) for detailed steps.

1. Debug the Linux application:

   - Right-click **hello_linux**, then select **Debug As → Debug Configurations**.
   - Expand **Single Application Debug** and select **Debugger_hello_linux-Default**.
   - Review the configurations:
     - Debug type: **Linux Application Debug**
     - Connection: **Linux Agent**
   - Click **Debug**.

    The debug configuration has identical options to the run configuration. The difference between debugging and running is that debugging stops at the `main()` function.

2. Try the debugging features:

    Hello World is a simple application. It does not contain much to debug, but you can try the following to explore the Vitis debugger:

    - Review the tabs on the upper right corner: Variables, Breakpoints, Expressions, and the rest.
    - Review the call stack on the left.
    - The next line to execute has a green background.
    - Step over by clicking the icon on the toolbar or pressing **F6** on the keyboard. The printed string will be shown on the Console panel.

    ![](./media/vitis_debugger_hello_linux.png)

3. Disconnect the connection:

   - Click the **Terminate button** on the toolbar or press **Ctrl+F2**.
   - Click the **Disconnect** button on the toolbar.

## Summary

In this chapter, you learned how to:

- Create a Linux boot image with PetaLinux.
- Create simple Linux applications with the Vitis IDE.
- Run and debug using the Vitis IDE.

In the [next chapter](./7-design1-using-gpio-timer-interrupts.md), we will connect all points previously introduced and create a system design.

© Copyright 2017-2021 Xilinx, Inc.


<!--TODO merge it-->
### Booting Linux on the Target Board

You will now boot Linux on the Zynq-7000 SoC ZC702 target board using
JTAG mode.

***Note*:** Additional boot options will be explained in [Linux Booting and Debug in the Software
Platform](6-linux-booting-debug.md).

1.  Check the following Board Connection and Setting for Linux booting
    using JTAG mode:

    a.  Ensure that the settings of Jumpers J27 and J28 are set as
        described in [Creating a Platform Project in the Vitis Software Platform with an XSA from Vivado](2-using-zynq.md#creating-a-platform-project-in-the-vitis-software-platform-with-an-xsa-from-vivado).

    b.  Ensure that the SW16 switch is set as shown in the following
        figure.

    c.  Connect an Ethernet cable from the Zynq SoC board to your
        network.

    d.  Connect the Windows Host machine to your network.

    e.  Connect the power cable to the board.

        ![](./media/image67.jpeg)

2.  Connect a micro USB cable between the Windows host machine and the
    target board with the following SW10 switch settings, as shown in
    [Booting Linux on the Target Board](6-linux-booting-debug.md#booting-linux-on-the-target-board).

    -   Bit-1 is 0

    -   Bit-2 is 1

    ***Note*:** 0 = switch is open. 1 = switch is closed. The correct JTAG
    mode has to be selected, according to the user interface. The JTAG
    mode is controlled by switch SW10 on the ZC702 and SW4 on the ZC706.

    ![](./media/image68.jpeg)

3.  Connect a USB cable to connector J17 on the target board with the
    Windows Host machine. This is used for USB to serial transfer.

4.  Change Ethernet Jumper J30 and J43 as shown in the following figure.

    ![](./media/image69.jpeg)    

5.  Power on the target board.

6.  Launch the Vitis software platform and open the same workspace you
    used in [Using the Zynq SoC Processing System](2-using-zynq.md) and [Using the GP Port in Zynq Devices](3-using-gp-port-zynq.md).

7.  If the serial terminal is not open, connect the serial communication
    utility with the baud rate set to **115200**.

    ***Note*:** This is the baud rate that the UART is programmed to on
    Zynq devices.