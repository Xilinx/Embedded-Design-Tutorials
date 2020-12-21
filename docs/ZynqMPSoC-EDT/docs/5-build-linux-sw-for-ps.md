<p align="right">
            Read this page in other languages:<a href="../docs-jp/4-build-sw-for-ps-subsystems.md">日本語</a>    <table style="width:100%"><table style="width:100%">
  <tr>

<th width="100%" colspan="6"><img src="https://www.xilinx.com/content/dam/xilinx/imgs/press/media-kits/corporate/xilinx-logo.png" width="30%"/><h1>Zync UltraScale+ MPSoC Embedded Design Tutorial 2020.2 (UG1209)</h1>
</th>

  </tr>
  <tr>
    <td width="17%" align="center"><a href="../README.md">1. Introduction</a></td>
    <td width="16%" align="center"><a href="2-getting-started.md">2. Getting Started</a></td>
    <td width="17%" align="center"><a href="3-system-configuration.md">3. Zynq UltraScale+ MPSoC System Configuration</a></td>
    <td width="17%" align="center">4. Build Software for PS Subsystems</td>
</tr>
<tr>
    <td width="17%" align="center">5. Building Linux Applications for PS</td>
    <td width="16%" align="center"><a href="6-debugging-with-vitis-debugger.md">6. Debugging Standalone Applications</a></td>
    <td width="17%" align="center"><a href="7-debugging-linux-app.md">7. Debugging Linux Applications</a></td>
    <td width="17%" align="center"><a href="8-boot-and-configuration.md">8. Boot and Configuration</a></td>    
  </tr>
</table>

## Example Project 3: Create Linux Images using PetaLinux

 The earlier example highlighted creation of the bootloader images and
 bare-metal applications for APU, RPU, and PMU using the Vitis IDE. In
 this example, you will configure and build Linux Operating System
 Platform for Arm Cortex-A53 core based APU on Zynq UltraScale+. You
 can configure and build Linux images using the PetaLinux tool flow,
 along with the board-specific BSP.

 >**IMPORTANT!**
    >1.  This example needs a Linux Host
     machine. *PetaLinux Tools Documentation: Reference Guide* ([UG1144](https://www.xilinx.com/cgi-bin/docs/rdoc?v=latest%3Bd%3Dug1144-petalinux-tools-reference-guide.pdf))
 for information about dependencies for PetaLinux 2020.2.
    >1.  This example uses the ZCU102 PetaLinux BSP to create a PetaLinux
     project. Ensure that you have downloaded the ZCU102 BSP for
     PetaLinux as instructed in [PetaLinux Tools](#petalinux-tools-1).

1. Create a PetaLinux project using the following command:

    This creates a PetaLinux project directory, for example,
    xilinx-zcu102-2020.2.

    >***Note*:** xilinx-zcu102-v2020.2-final.bsp is the PetaLinux BSP for
    ZCU102 Production Silicon Rev1.0 Board. Use
    xilinx-zcu102-ZU9-ES2-Rev1.0-v2020.2-final.bsp, if you are using ES2
    Silicon on Rev 1.0 board.

2. Change to the PetaLinux project directory using the following
     command:

    `$ cd xilinx-zcu102-2020.2`

    The ZCU102 PetaLinux-BSP is the default ZCU102 Linux BSP. For this
    example, you reconfigure the PetaLinux Project based on theZynq
    UltraScale+ hardware platform that you configured using Vivado Design
    Suite in [Zynq UltraScale+ MPSoC Processing System Configuration](3-system-configuration.md).

3. Copy the hardware platform edt_zcu102_wrapper.xsa to the Linux Host
     machine.

4. Reconfigure the project using the following command:

    This command opens the PetaLinux Configuration window. If required,
    make changes in the configuration. For this example, the default
    settings from the BSP are sufficient to generate required boot images.

    The following steps will verify if PetaLinux is configured to create
    Linux and boot images for SD Boot.

5. Select Subsystem AUTO Hardware Settings.

6. Under Advanced Bootable Images Storage Settings submenu, do the
     following:

    a.  Select **boot image settings**.

    b.  Select **Image Storage Media**.

    c.  Select **primary sd** as the boot device.

7. Under the Advanced Bootable Images Storage Settings submenu, do the
     following:

    a.  Select **kernel image settings**.

    b.  Select **Image Storage Media**.

    c.  Select **primary sd** as the storage device.

8. Under Subsystem AUTO Hardware Settings, select **Memory Settings**
     and set the System Memory Size to `0x6FFFFFFF`.

9. Return to the main menu. In Image Packaging Configuration, set the
     root file system type to INITRAMFS.

10. Save the configuration settings and exit the Configuration wizard.

11. Wait until PetaLinux reconfigures the project.

    The following steps will build the Linux images, verify them, and
    generate the boot image.

12. Modify the device tree to disable Heartbeat LED and SW19 push button
     from the device tree, so that the RPU R5-0 can use the PS LED and
     the SW19 switch for other designs in this tutorial. To do so, add
     the following to the `system-user.dtsi` file:

    ```
    /include/ "system-conf.dtsi"
    / {
        gpio-keys { 
            sw19 {
                status = "disabled";
            };
        };
    };
    
    &uart1 {
        status = "disabled";
    };
    ````

    The `system-user.dtsi` is located at
    `<PetaLinux-project>/project-spec/meta-user/recipes-bsp/device-tree/files/system-user.dtsi`.

13. In `<PetaLinux-project>`, build the Linux images using the following
     command:

    `$ petalinux-build`

14. After the above statement executes successfully, verify the images
     and the timestamp in the images directory in the PetaLinux project
     folder using the following commands:

    ``` bash
    $ cd images/linux/
    $ ls -al
    ```

15. Generate the Boot image using the following command:

    `$ petalinux-package --boot --fsbl zynqmp_fsbl.elf --u-boot`

    This creates a `BOOT.BIN` image file in the following directory:

    `<petalinux-project>/images/linux/BOOT.BIN`

    The logs indicate that the above command includes PMU_FW and ATF in
    BOOT.BIN. You can also add `--pmufw <PMUFW_ELF>` and `--atf <ATF_ELF>` in the above command. Refer `$ petalinux-package --boot
    --help` for more details.

    >***Note*:** The option to add bitstream, that is `--fpga`, is missing
    from the above command intentionally because so far the hardware
    configuration is based pnly on PS with no design in PL. If a bitstream
    is present in the design, `--fpga` can be added in the
    petalinux-package command as shown below:
    >    ```
    >    petalinux-package --boot --fsbl zynqmp_fsbl.elf --fpga system.bit --pmufw pmufw.elf --atf bl31.elf --u-boot u-boot.elf
    >    ```

### Verify the Image on the ZCU102 Board

 To verify the image, follow these steps:

1. Copy `BOOT.BIN`, `image.ub`, and `boot.scr` files to the SD card. Here
     `boot.scr` is read by U-Boot to load kernel and rootfs.

2. Load the SD card into the ZCU102 board, in the J100 connector.

3. Connect a Micro USB cable from ZCU102 Board USB UART port (J83), to
     USB port on the host Machine.

4. Configure the Board to Boot in SD-Boot mode by setting switch SW6 as
     shown in the following figure.

    ![](./media/image43.jpeg)

5. Connect 12V Power to the ZCU102 6-Pin Molex connector.

6. Start a terminal session, using Tera
     Term or Minicom depending on the host machine being used. set the
     COM port and baud rate for your system, as shown in the following
     figure.
     ![](./media/image44.png)

7. For port settings, verify COM port in the device manager and select
     the COM port with interface-0.

8. Turn on the ZCU102 Board using SW1, and wait until Linux loads on
     the board.

### Create Linux Images Using PetaLinux for QSPI Flash

 The earlier example highlighted creation of the Linux Images and Boot
 images to boot from an SD card. This section explains the
 configuration of PetaLinux to generate Linux images for QSPI flash.
 For more information about the dependencies for PetaLinux 2020.2, see
 the *PetaLinux Tools Documentation: Reference Guide*
 ([UG1144](https://www.xilinx.com/cgi-bin/docs/rdoc?v=latest%3Bd%3Dug1144-petalinux-tools-reference-guide.pdf)).

1. Before starting this example, create a backup of the boot images
     created for SD card setup using the following commands:

    ``` shell
    $ cd <Petalinux-project-path>/xilinx-zcu102-2020.2/images/linux/
    $ mkdir sd_boot
    $ cp image.ub sd_boot/
    $ cp u-boot.elf sd_boot/
    $ cp BOOT.BIN sd_boot/
    ```

2. Change the directory to the PetaLinux Project root directory:

    `$ cd \<Petalinux-project-path\/xilinx-zcu102-2020.2`

3. Launch the top level system configuration menu:

    `$ petalinux-config`

    The Configuration wizard opens.

4. Select Subsystem AUTO Hardware Settings.

5. Under the Advanced bootable images storage Settings, do the
     following.

    a.  Select **boot image settings**.

    b.  Select **image storage media**.

    c.  Select **primary flash** as the boot device.

6. Under the Advanced bootable images storage Settings submenu, do the
     following:

    a.  Select **kernel image settings**.

    b.  Select **image storage media**.

    c.  Select **primary flash** as the storage device.

7. One level above, that is, under Subsystem AUTO Hardware Settings, do
     the following:

    a.  Select **Flash Settings** and notice the entries listed in the
         partition table.

    >***Note*:** Some memory (0x1E00000 + 0x40000) is set aside for initial
    Boot partitions and U-Boot settings. These values can be modified on
    need basis.

    b.  Based on this, the offset for Linux Images is calculated as
        0x1E40000 in QSPI Flash device. This will be used in [Boot and Configuration](6-boot-and-configuration.md), while creating Boot image
        for QSPI Boot-mode.

    The following steps will set the Linux System Memory Size to about
    1.79 GB.

8. Under Subsystem AUTO Hardware Settings, do the following:

    a.  Select **Memory Settings**.

    b.  Set **System Memory Size** to `0x6FFFFFFF`.

9. Save the configuration settings and exit the Configuration wizard.

10. Rebuild using the `petalinux-build` command.

11. Take a backup of u-boot.elf and the other images. These will be used
     in [Boot and Configuration](6-boot-and-configuration.md).

 ***Note*:** For more information, refer to the *PetaLinux Tools
 Documentation: Reference Guide*
 ([UG1144](https://www.xilinx.com/cgi-bin/docs/rdoc?v=latest%3Bd%3Dug1144-petalinux-tools-reference-guide.pdf)).

 In this chapter, you learned how to configure and compile software
 blocks for Zynq UltraScale+ devices using Xilinx tools. You will use
 these images in [System Design Examples](7-system-design-examples.md) to
 create Boot images for a specific design example.

 Next, you will debug software for Zynq UltraScale+ devices using the
 Vitis IDE in [Debugging with the Vitis
 Debugger](5-debugging-with-vitis-debugger.md).