<p align="right">
            Read this page in other languages:<a href="../docs-jp/6-boot-and-configuration.md">日本語</a>    <table style="width:100%"><table style="width:100%">
  <tr>

<th width="100%" colspan="6"><img src="https://www.xilinx.com/content/dam/xilinx/imgs/press/media-kits/corporate/xilinx-logo.png" width="30%"/><h1>Zync UltraScale+ MPSoC Embedded Design Tutorial 2020.2 (UG1209)</h1>
</th>

  </tr>
  <tr>
    <td width="17%" align="center"><a href="../README.md">1. Introduction</a></td>
    <td width="16%" align="center"><a href="2-getting-started.md">2. Getting Started</a></td>
    <td width="17%" align="center"><a href="3-system-configuration.md">3. Zynq UltraScale+ MPSoC System Configuration</a></td>
    <td width="17%" align="center"><a href="4-build-sw-for-ps-subsystems.md">4. Build Software for PS Subsystems</a></td>
</tr>
<tr>
    <td width="17%" align="center"><a href="5-build-linux-sw-for-ps.md">5. Building Linux Applications for PS</a></td>
    <td width="16%" align="center"><a href="6-debugging-with-vitis-debugger.md">6. Debugging Standalone Applications</a></td>
    <td width="17%" align="center"><a href="7-debugging-linux-app.md">7. Debugging Linux Applications</a></td>
    <td width="17%" align="center"><a href="8-boot-and-configuration.md">8. Boot and Configuration</a></td>    
  </tr>
</table>

- [Boot and Configuration](#boot-and-configuration)
  - [System Software](#system-software)
    - [First Stage Boot Loader](#first-stage-boot-loader)
    - [Platform Management Unit Firmware](#platform-management-unit-firmware)
    - [U-Boot](#u-boot)
    - [Arm Trusted Firmware](#arm-trusted-firmware)
  - [Linux on APU and Bare-Metal on RPU](#linux-on-apu-and-bare-metal-on-rpu)
  - [Boot Sequence for SD-Boot](#boot-sequence-for-sd-boot)
    - [Running the Image on the ZCU102 Board](#running-the-image-on-the-zcu102-board)
  - [Boot Sequence for QSPI Boot Mode](#boot-sequence-for-qspi-boot-mode)
    - [Running the Image in QSPI Boot Mode on ZCU102 Board](#running-the-image-in-qspi-boot-mode-on-zcu102-board)
      - [Set Up the ZCU102 Board](#set-up-the-zcu102-board)
  - [Boot Sequence for QSPI-Boot Mode Using JTAG](#boot-sequence-for-qspi-boot-mode-using-jtag)
    - [Setting Up the Target](#setting-up-the-target)
    - [Load U-Boot Using XSCT/XSDB](#load-u-boot-using-xsctxsdb)
    - [Load Boot.bin in DDR Using XSDB](#load-bootbin-in-ddr-using-xsdb)
    - [Load the Boot.bin Image in QSPI Using U-Boot](#load-the-bootbin-image-in-qspi-using-u-boot)
  - [Boot Sequence for USB Boot Mode](#boot-sequence-for-usb-boot-mode)
    - [Configure FSBL to Enable USB Boot Mode](#configure-fsbl-to-enable-usb-boot-mode)
      - [Create First Stage Boot Loader for USB Boot](#create-first-stage-boot-loader-for-usb-boot)
    - [Creating Boot Images for USB Boot](#creating-boot-images-for-usb-boot)
      - [Modifying PetaLinux U-Boot](#modifying-petalinux-u-boot)
    - [Boot using USB Boot](#boot-using-usb-boot)
      - [Boot Commands for Linux Host Machine](#boot-commands-for-linux-host-machine)
      - [Boot Commands for Windows Host Machine](#boot-commands-for-windows-host-machine)

# Boot and Configuration

This chapter shows integration of components to create a Zynq&reg;
 UltraScale+&trade; system. The purpose of this chapter is to understand how
 to integrate and load boot loaders, bare-metal applications (for
 APU/RPU), and Linux Operating System for a Zynq UltraScale+ system.

 The following important points are covered in this chapter:

-  System Software: FSBL, U-Boot, Arm&reg; trusted firmware (ATF)

-  Application Processing Unit (APU): Configure SMP Linux for APU

-   Real-time Processing Unit (RPU): Configure Bare-metal for RPU in
     Lock-step

- Create Boot Image for the following boot sequence:

  1. APU

  2. RPU Lock-step

-  Create and load Secure Boot Image

 >***Note*:** For more information on RPU Lock-step, see *Zynq
 UltraScale+ Device Technical Reference Manual* ([UG1085](https://www.xilinx.com/cgi-bin/docs/ndoc?t=user_guides%3Bd%3Dug1085-zynq-ultrascale-trm.pdf)).

 This boot sequence also includes loading the PMU Firmware for the
 Platform Management Unit (PMU). The Vitis IDE and PetaLinux can be
 used to create boot images to fulfill different boot requirements.
 While [Build Software for PS Subsystems](4-build-sw-for-ps-subsystems.md)
 focused only on creating software blocks for each processing unit in
 the PS, this chapter explains how these blocks can be loaded as a part
 of a bigger system.

 To create a boot image, use the Create Boot Image wizard (Bootgen
 command line tool). The principle function of the Create Boot Image
 wizard or Bootgen is to integrate the partitions (hardware-bitstream
 and software) and allow you to specify the security options in the
 design. It can also create cryptographic keys. Functionally, Bootgen
 uses a Bootgen Image Format (BIF) file as an input, and generates a
 single file image in binary BIN or MCS format. Bootgen outputs a
 single file image which is loaded into NVM (QSPI, SD Card). The
 Bootgen GUI facilitates the creation of the BIF input file.

 This chapter makes use of a processing system block. [Design Example 1: Using GPIOs, Timers, and Interrupts](7-system-design-examples.md#design-example-1-using-gpios-timers-and-interrupts)
 covers boot image which will include the PS partitions used in this
 chapter and a bitstream targeted for PL fabric.

## System Software

 The following system software blocks cover most of the Boot and
 Configuration for this chapter. For detailed boot flow and various
 Boot sequences, refer to the "System Boot and Configuration" chapter
 in the *Zynq UltraScale+ MPSoC: Software Developers Guide*
 ([UG1137](https://www.xilinx.com/cgi-bin/docs/rdoc?v=latest%3Bd%3Dug1137-zynq-ultrascale-mpsoc-swdev.pdf)).

### First Stage Boot Loader

 In non-secure boot mode, the platform management unit (PMU) releases
 the reset of the configuration security unit, and enters the PMU
 server mode to monitor power. At this stage the configuration security
 unit loads the first stage boot loader (FSBL) into on-chip memory
 (OCM). The FSBL can be run from either APU A53_0 or RPU R5_0 or RPU
 R5_lockstep. In this example, the FSBL is targeted for APU Cortex&trade;-A53
 Core 0. The last 512 bytes of this region is used by FSBL to share the
 hand-off parameters corresponding to applications which ATF hands off.

 The First Stage Boot Loader initializes important blocks in the
 processing subsystem. This includes clearing the reset of the
 processors, initializing clocks, memory, UART, and so on before
 handing over the control of the next partition in DDR, to either RPU
 or APU. In this example, the FSBL loads bare-metal application in DDR
 and hands off to RPU Cortex-R5F in Lockstep mode, and similarly loads
 U-Boot to be executed by APU Cortex-A53 Core-0. For more information,
 see the *Zynq UltraScale+ MPSoC: Software Developers Guide*
 ([UG1137](https://www.xilinx.com/cgi-bin/docs/rdoc?v=latest%3Bd%3Dug1137-zynq-ultrascale-mpsoc-swdev.pdf)).

 For this chapter, you can use the FSBL executable that you created in
 [Build Software for PS Subsystems](4-build-sw-for-ps-subsystems.md). In FSBL application, the
 xfsbl_translation_table.S differs from translation_table.S (of
 Cortex-A53) in only one aspect, to mark DDR region as reserved. This
 is to avoid speculative access to DDR before it is initialized. Once
 the DDR initialization is done in FSBL, memory attributes for DDR
 region is changed to "Memory" so that it is cacheable.

### Platform Management Unit Firmware

 The platform management unit (PMU) and the configuration security unit
 manage and perform the multi-staged booting process. The PMU primarily
 controls the pre-configuration stage that executes PMU ROM to set up
 the system. The PMU handles all of the processes related to reset and
 wake-up. The Vitis IDE provides PMU Firmware that can be built to run
 on the PMU. For more details on the Platform Management and PMU
 Firmware, see the *Zynq UltraScale+ MPSoC: Software Developers Guide*
 ([UG1137](https://www.xilinx.com/cgi-bin/docs/rdoc?v=latest%3Bd%3Dug1137-zynq-ultrascale-mpsoc-swdev.pdf)).

 The PMU Firmware can be loaded in the following ways:

1. Using BootROM to load PMU Firmware, as described in [Boot Sequence for SD-Boot](#boot-sequence-for-sd-boot).

2. Using FSBL to load PMU Firmware, as described in [Boot Sequence for QSPI Boot Mode](#boot-sequence-for-qspi-boot-mode).

3. Loading PMU Firmware in JTAG boot mode, as described in [Boot Sequence for QSPI-Boot Mode Using JTAG](#boot-sequence-for-qspi-boot-mode-using-jtag).

 For more information, see the [PMU Firmware Xilinx
 Wiki](http://www.wiki.xilinx.com/PMU%2BFirmware).

### U-Boot

 The U-Boot acts as a secondary boot loader. After the FSBL handoff,
 the U-Boot loads Linux on Arm&reg; Cortex-A53 APU. After FSBL, the U-Boot
 configures the rest of the peripherals in the processing system based
 on board configuration. U-Boot can fetch images from different memory
 sources like eMMC, SATA, TFTP, SD, and QSPI. For this example, U-Boot
 and all other images are loaded from the SD card. Therefore, for this
 example, the board will be set to SD-boot mode.

 U-Boot can be configured and built using the PetaLinux tool flow. For
 this example, you can use the U-Boot image that you created in
 [Build Software for PS Subsystems](4-build-sw-for-ps-subsystems.md) or from the
 design files shared with this document. See [Design Files for This Tutorial](2-getting-started.md#design-files-for-this-tutorial) for information about
 downloading the design files for this tutorial.

### Arm Trusted Firmware

 The Arm Trusted Firmware (ATF) is a transparent bare-metal application
 layer executed in Exception Level 3 (EL3) on APU. The ATF includes a
 Secure Monitor layer for switching between secure and non-secure
 world. The Secure Monitor calls and implementation of Trusted Board
 Boot Requirements (TBBR) makes the ATF layer a mandatory requirement
 to load Linux on APU on Zynq UltraScale+.

 The FSBL loads ATF to be executed by APU, which keeps running in EL3
 awaiting a service request. The ATF starts at 0xFFFEA000. The FSBL
 also loads U-Boot in DDR to be executed by APU, which loads Linux OS
 in SMP mode on APU. It is important to note that the PL bitstream
 should be loaded before ATF is loaded. The reason is FSBL uses the OCM
 region which is reserved for ATF for holding a temporary buffer in the
 case where bitstream is present in .BIN file. Because of this, if
 bitstream is loaded after ATF, FSBL will overwrite the ATF image with
 its temporary buffer, corrupting ATF image. Hence, bitstream should be
 positioned in .BIF before ATF and preferably immediately after FSBL
 and PMU Firmware.

 The ATF (`bl31.elf`) is built by default in PetaLinux and can be found
 in the PetaLinux Project images directory.

 For more details on ATF, refer to the "Arm Trusted Firmware" section
 in the "Security" chapter of the *Zynq UltraScale+ MPSoC: Software
 Developers Guide*
 ([UG1137](https://www.xilinx.com/cgi-bin/docs/rdoc?v=latest%3Bd%3Dug1137-zynq-ultrascale-mpsoc-swdev.pdf)).

## Linux on APU and Bare-Metal on RPU

 Now that the system software is configured, create Linux Images using
 PetaLinux tool flow. You already created the PetaLinux images in
 [Build Software for PS Subsystems](4-build-sw-for-ps-subsystems.md). For this
 example, the PetaLinux is configured to build images for SD-boot. This
 is the default boot setting in PetaLinux.

 The images can be found in the `$<PetaLinux_Project>/images/linux/` directory. For loading Linux on APU, the following images will be used from PetaLinux:

- ATF - `bl31.elf`

- U-Boot - `u-boot.elf`

-  Linux images - `image.ub`, which contains:

    - Kernel image

    - Device Tree `system.dtb`

    - File system `rootfs.cpio.gz.u-boot`

 In addition to Linux on APU, this example also loads a bare-metal
 Application on RPU Cortex- R5F in Lockstep mode.

 For this example, refer the testapp_r5 application that you created in
 [Create Custom Bare-Metal Application for Arm Cortex-R5 based RPU](4-build-sw-for-ps-subsystems.md#create-custom-bare-metal-application-for-arm-cortex-r5-based-rpu).

 Alternatively, you can also find the testapp_r5.elf executable in the
 design files that accompany this tutorial. See [Design Files for This Tutorial](2-getting-started.md#design-files-for-this-tutorial) for information about
 downloading the design files for this tutorial.

## Boot Sequence for SD-Boot

 Now that all the individual images are ready, create the boot image to
 load all of these components on Zynq UltraScale+. This can be done
 using the Create Boot Image wizard in the Vitis IDE, using the
 following steps:

1. In the Vitis IDE, select **Xilinx → Create Boot Image**.

2. Select all the partitions referred in earlier sections in this
     chapter, and set them as shown in the following figure.

    ![](./media/image55.png)

3. First, add the FSBL partition.

   1. In the Create Boot Image wizard, click **Add** to open the Add partition view.
   2. In the Add Partition view, click **Browse** to select the FSBL executable.
   3. For FSBL, ensure that the partition type is selected as boot loader and the correct destination CPU is selected by the tool. The tool is configured to make this selection based on the FSBL executable.

    >    ***Note*:** Ignore the Exception Level drop down, as FSBL is set to
        EL3 by default. Also, leave the TrustZone setting unselected for this
        example.

    ![](./media/image56.png)

    4. Click **OK** to select FSBL and go back to Create Boot Image wizard.

4. Next, add the PMU and ATF firmware partitions.

    1. Click **Add** to open the Add Partition view, shown in the
         following figure.

        ![](./media/image57.png)

    2. Add the PMU firmware partition.

        1. Browse to and select the **PMU Firmware executable**.

        2. For this partition, select **pmu** as the partition type.

    3. Leave the Exception Level and TrustZone settings unselected.

    4. Click **OK**.

    5. Click **Add** to open Add Partition view.

    6. Add the ATF firmware `bl31.elf` partition.

        > ***Note*:** ATF Firmware (`bl31.elf`) can be found in `<PetaLinux
            Project>/image/linux/`. Alternatively, you can also use `bl31.elf` from
            [Design Files for This Tutorial](2-getting-started.md#design-files-for-this-tutorial).

        1. For this partition, select **datafile** as the partition type.
        2. Set the Destination Device as **PS**.
        3. Set the Destination CPU as **A53 0**.
        4. Set the Exception Level to EL3 and select **Enable TrustZone**.

        ![](./media/image58.png)

    7. Click **OK**.

3. Next, add the R5 executable and enable it in lockstep mode.

    1. Click **Add** to add the Cortex-R5F bare-metal executable.

        ![](./media/image59.png)

    2. Set the Destination Device as **PS**.

    3. Set the Destination CPU as **R5 Lockstep**. This sets the RPU R5 cores to run in Lockstep mode.

    4. Leave Exception Level and TrustZone unselected.

    5. Click **OK**.

4. Now, add the U-Boot partition. You can find `u-boot.elf` for sd_boot mode in `<PetaLinux_project>/images/linux/sd_boot`.

    1. Click **Add** to add the u-boot.elf partition.

    2. For U-Boot, select the Destination Device as **PS**.

    3. Select the Destination CPU as **A53 0**.

    4. Set the Exception Level to **EL2**.

        ![](./media/image60.png)

    5. Click **OK** to return to the Create Boot Image wizard.

    6. Click **Create Image** to close the wizard and create the boot
        image.

 You can also create `BOOT.bin` images using the BIF attributes and the
 Bootgen command. For this configuration, the BIF file contains
 following attributes:

 ```
 //arch = zynqmp; split = false; format = BIN
 the_ROM_image:
 {
 [bootloader, destination_cpu = a53-0]C:\edt\fsbl_a53\Debug\fsbl_a53.elf
 [pmufw_image]C:\edt\edt_zcu102_wrapper\export\edt_zcu102_wrapper\sw\edt_zcu102_wrapper\boot\pmufw.elf
 [destination_cpu = a53-0, exception_level = el-3, trustzone]C:\edt\sd_boot\bl31.elf
 [destination_cpu = r5-lockstep]C:\edt\testapp_r5\Debug\testapp_r5.elf
 [destination_cpu = a53-0, exception_level = el-2]C:\edt\sd_boot\u-boot.elf
 }
 ```

 The Vitis IDE calls the following Bootgen command to generate the
 BOOT.bin image for this configuration:

 `bootgen -image sd_boot.bif -arch zynqmp -o C:\edt\sd_boot\BOOT.bi`n

### Running the Image on the ZCU102 Board

1. Copy the `BOOT.bin`, `image.ub`, and `boot.scr` to the SD card. Here
     `boot.scr` is read by U-Boot to load kernel and the root file
     system.

2. Load the SD card into the ZCU102 board, in the J100 connector.

3. Connect a micro USB cable from ZCU102 board USB UART port (J83) to
     the USB port on the host machine.

4. Configure the board to boot in the
     SD-boot mode by setting switch SW6 to 1-ON, 2-OFF, 3- OFF, and
     4-OFF, as shown in following figure.

    ![](./media/image43.jpeg)

5. Connect 12V Power to the ZCU102 6-Pin Molex connector.

6. Start a terminal session, using Tera Term or Minicom depending on
     the host machine being used, as well as the COM port and baud rate
     for your system, as shown in following figure.

    ![](./media/image44.png)

7. For port settings, verify COM port in device manager. There are four
     USB-UART interfaces exposed by the ZCU102 board.

8. Select the COM port associated with the interface with the lowest
     number. In this case, for UART-0, select the COM port with
     interface-0.

9. Similarly, for UART-1, select COM port with interface-1. Remember
     that the R5 BSP has been configured to use UART-1, and so R5
     application messages appear on the COM port with the UART-1
     terminal.

10. Turn on the ZCU102 Board using SW1, and wait until Linux loads on
     the board. At this point, you can see the initial boot sequence
     messages on your terminal screen representing UART-0.

    You can see that the terminal screen configured for UART-1 also prints
    a message. This is the print message from the R5 bare-metal
    application running on RPU, configured to use UART-1 interface. This
    application is loaded by the FSBL onto RPU.

    The bare-metal application has been modified to include the UART
    interrupt example. This application now waits in the waiting for
    interrupt (WFI) state until a user input is encountered from the
    keyboard in UART-1 terminal.

    ![](./media/image61.png)

    Meanwhile, the boot sequence continues on APU and the images loaded
    can be understood from the messages appearing on the UART-0 terminal.
    The messages are highlighted in the following figure.

    The U-Boot then loads Linux kernel and other images on Arm Cortex-A53
    APU in SMP mode. The terminal messages indicate when the U-Boot loads
    the kernel image and the kernel start up to getting a user interface
    prompt in Target Linux OS. The kernel loading and starting sequence
    can be seen in the following figure.

    ![](./media/image63.png)

## Boot Sequence for QSPI Boot Mode

 The ZCU102 board also comes with dual parallel QSPI flashes adding up
 to 128 MB size. In this example, you will create a boot image and load
 the images on Zynq UltraScale+ in QSPI boot mode. The images can be
 configured using the Create Boot Image wizard in the Vitis IDE. This
 can be done by doing the following steps.

 >***Note*:** This section assumes that you have created PetaLinux
 Images for QSPI Boot mode by following steps from [Create Linux Images
 Using PetaLinux for QSPI Flash](4-build-sw-for-ps-subsystems.md#create-linux-images-using-petalinux-for-qspi-flash).

1. If the Vitis IDE is not already running, start it and set the
     workspace as indicated in [Build Software for PS Subsystems](4-build-sw-for-ps-subsystems.md).

2. Select **Xilinx → Create Boot Image**.

3. Select **Zynq MP** as the Architecture.

4. Select the **Create new BIF** file option.

5. Ensure that the Output format is set to BIN.

6. In the Basic page, browse to and
     select the **Output BIF** file path and output path.

     ![](./media/image64.png)

7. Next, add boot partitions using the following steps:

    1. Click **Add** to open the Add Partition view.

    2. In the Add Partition view, click the **Browse** button to select
         the **FSBL executable**.

        1. For FSBL, ensure that the
             Partition type is selected as boot loader and the correct
             destination CPU is selected by the tool. The tool is
             configured to make this selection based on the FSBL
             executable.

             ![](./media/image65.jpeg)

        2. Ignore the Exception Level, as FSBL is set to EL3 by
             default. Also, leave the TrustZone setting unselected for
             this example.

        3. Click **OK** to select the FSBL and go back to the Create
              Boot Image wizard.

    3. Click **Add** to open the Add Partition window to add the next
         partition.

    4. The next partition is the PMU firmware for the Platform
         Management Unit.

        1.  Select the Partition type as **datafile** and the
             Destination Device as **PS**.

        2. Select **PMU** for Destination CPU.

        3. Click **OK**.

            ![](./media/image66.png)

    5. The next partition to be added is the ATF firmware. For this, set
     the Partition type to datafile.

       1.  The ATF executable bl31.elf can be found in the PetaLinux images
            folder
           `<PetaLinux_project\/images/linux/`.

       2. Select the Destination Device as **PS** and the Destination CPU as
           A53 0.

       3. Set the Exception Level to EL3 and
           select Enable TrustZone.

           ![](./media/image67.png)

       4. Click **OK**.

    6. Click **Add** to add the R5 bare-metal executable.

        1. Add the R5 executable and enable it in lockstep mode, as shown
            in the following image.

        2. Click **OK**.

            ![](./media/image68.jpeg)

    7. Click **Add** to add the U-Boot partition. u-boot.elf can be found in `<PetaLinux_Project>/images/linux/`.

        1. For U-Boot, make the following selections:

            - Set the Partition Type to **datafile**.

            - Set the Destination Device to **PS**.

            - Set the Destination CPU to **A53 0**.

            - Set the Exception Level to **EL2**.

            ![](./media/image69.png)

        2. Click **OK**.

    8. Click **Add** to add the image.ub Linux image file.

        1.  The image.ub image file can be found in PetaLinux project in the
            `images/Linux` directory.

        2. For image.ub, make the following selections:

           - Set Partition Type to **datafile**.

           - Set the Destination Device to **PS**.

           - Set the Destination CPU to **A53 0**.

        3. Enter `0xF00000` as the offset.

        4. Leave Exception Level and TrustZone unselected.

        ***Note*:** See [Create Linux Images Using PetaLinux for QSPI Flash](4-build-sw-for-ps-subsystems.md#create-linux-images-using-petalinux-for-qspi-flash), to
        understand the offset value.

   9. Click **Add** to add the `boot.scr` script file.

        1. The `boot.scr` file is located in the images/linux directory of
            the PetaLinux project.

        2. For `boot.scr`, select the following:

            - Set partition type to **datafile**.

            - Set the Destination Device to **PS**.

            - Set the Destination CPU to **A53 0**.

        3. Enter 0x3e80000 as the offset.

        4. Leave Exception Level and TrustZone unselected.

        ![](./media/image70.png)

8. Click **OK** to go back to Create Boot Image wizard.

9. Click **Create Image** to create the `qspi_BOOT.bin` image.

 You can also create qspi_BOOT.bin images using the BIF attributes and
 the Bootgen command. You can view the BIF attributes for this
 configuration by clicking **Preview BIF Changes**. For this
 configuration, the BIF file contains following attributes:

 ```
 //arch = zynqmp; split = false; format = BIN
 the_ROM_image:
 {
 [bootloader, destination_cpu = a53-0]C:\edt\fsbl_a53\Debug\fsbl_a53.elf
 [destination_cpu = pmu]C:\edt\edt_zcu102_wrapper\export\edt_zcu102_wrapper\sw\edt_zcu102_wrapper\boot\pmufw.elf
 [destination_cpu = a53-0, exception_level = el-3, trustzone]C:\edt\qspi_boot\bl31.elf
 [destination_cpu = r5-lockstep]C:\edt\testapp_r5\Debug\testapp_r5.elf
 [destination_cpu = a53-0, exception_level = el-2]C:\edt\qspi_boot\u-boot.elf
 [offset = 0xF00000, destination_cpu = a53-0]C:\edt\qspi_boot\image.ub
 [offset = 0x3e80000, destination_cpu = a53-0]C:\edt\qspi_boot\boot.scr
 }
 ```

 The Vitis IDE calls the following Bootgen command to generate the
 qspi_BOOT.bin image for this configuration.

 `bootgen -image qspi_boot.bif -arch zynqmp -o C:\edt\qspi_BOOT.bin`

 >***Note*:** In this boot sequence, the First Stage Boot Loader (FSBL)
 loads PMU firmware. This is because the PMU firmware was added as a
 datafile partition type. Ideally, the Boot ROM code can load the PMU
 Firmware for PMU as witnessed in the earlier section. For more details
 on PMU Firmware, refer to the "Platform Management" chapter in the
 *Zynq UltraScale+ MPSoC: Software Developers Guide*
 ([UG1137](https://www.xilinx.com/cgi-bin/docs/rdoc?v=latest%3Bd%3Dug1137-zynq-ultrascale-mpsoc-swdev.pdf)).

### Running the Image in QSPI Boot Mode on ZCU102 Board

 To test the image in this example, you will load the Boot image
 (qspi_BOOT.bin) onto QSPI on the ZCU102 board using the Program Flash
 utility in the Vitis IDE. Alternately, you can use the XSDB debugger.

1. In the Vitis IDE, select **Xilinx → Program Flash**.

2. In the Program Flash wizard, browse to and select the `qspi_BOOT.bin`
     image file that was created as a part of this example.

3. Select **qspi-x8-dual_parallel** as the Flash type.

4. Set the Offset as **0** and select the **FSBL ELF file (fsbl_a53.elf)**

5. Ensure that a USB cable is connected between the USB-JTAG connector on ZCU102 target and the USB port on the host machine using the following steps.

    1. Set the SW6 Boot mode switch as shown in the following figure.

    2. Turn on the board.

     ![](./media/image26.jpeg)

6. Click **Program** to start the process of programming the QSPI Flash
     with the qspi_BOOT.bin

    ![](./media/image71.jpeg)

    Wait until you see the message "Flash Operation Successful" in the
    console, as shown in the following image.

    ![](./media/image72.png)

#### Set Up the ZCU102 Board

1. Connect Board USB-UART on Board to Host machine. Connect the Micro
     USB cable into the ZCU102 Board Micro USB port J83, and the other
     end into an open USB port on the host machine.

2. Configure the Board to Boot in QSPI-Boot mode by switching SW6 as
     shown in following figure.

    ![](./media/image73.jpeg)

3. Connect 12V Power to the ZCU102 6-Pin Molex connector.

4. Start a terminal session, using Tera Term or Mini com, depending on
     the host machine being used, and the COM port and baud rate as
     shown in the following figure.

5. For port settings, verify the COM port in the device manager. There
     are four USB UART interfaces exposed by the ZCU102.

6. Select the COM port associated with the interface with the lowest
     number. In this case, for UART-0, select the COM port with
     interface-0.

7. Similarly, for UART-1, select COM port with interface-1.

    Remember, R5 BSP has been configured to use UART-1, so R5 application
    messages will appear on the COM port with UART-1 terminal.

    ![](./media/image44.png)

8. Turn on the ZCU102 Board using SW1.

    At this point, you can see initial Boot sequence messages on your
    Terminal Screen representing UART-0.

    You can see that the terminal screen configured for UART-1 also prints
    a message. This is the print message from the R-5 bare-metal
    Application running on RPU, configured to use

    UART-1 interface. This application is loaded by the FSBL onto RPU.

    The bare-metal application has been modified to include the UART
    interrupt example. This application now waits in the WFI state until a
    user input is encountered from the keyboard in UART-1 terminal.

    ![](./media/image61.png)

    Meanwhile, the boot sequence continues on APU and the images loaded
    can be understood from the messages appearing on the UART-0 terminal.
    The messages are highlighted in the following figure.

    ![](./media/image74.png)

    The U-Boot then loads Linux Kernel and other images on Arm Cortex-A53
    APU in SMP mode. The terminal messages indicate when U-Boot loads
    Kernel image and the kernel start up to getting a user interface
    prompt in Linux Kernel. The Kernel loading and starting sequence can
    be seen in following figure.

    ![](./media/image63.png)

## Boot Sequence for QSPI-Boot Mode Using JTAG

 Zynq UltraScale+ MPSoC supports many methods to load the boot image.
 One way is using the JTAG interface. This example XSCT session
 demonstrates how to download a boot image file (`qspi_BOOT.bin`) in QSPI
 using the XSDB debugger. After the QSPI is loaded, the `qspi_BOOT.bin`
 image executes in the same way as QSPI boot mode in Zynq UltraScale+ MPSoC. You can use the same XSCT session or the System Debugger for debugging similar boot flows.

 The following sections demonstrate the basic steps involved in this
 boot mode.

### Setting Up the Target

1. Connect a USB cable between the USB-JTAG J2 connector on the target
     and the USB port on the host machine.

2. Set the board to JTAG Boot mode by setting the SW6 switch, as shown in the following figure.

	 ![](./media/image26.jpeg)

3. Power on the board using switch SW1. Open the XSCT console in the
     Vitis IDE by clicking the XSCT button. Alternatively, you can also
     open the XSCT console by selecting **Xilinx → XSCT Console**.

4. In the XSCT console, connect to the target over JTAG using the
     connect command:

    `xsct% connect`

    The connect command returns the channel ID of the connection.

5. The targets command lists the available targets and allows you to
     select a target using its ID. The targets are assigned IDs as they
     are discovered on the JTAG chain, so the IDs can change from
     session to session.

    >***Note*:** For non-interactive usage such as scripting, you can use
    the -filter option to select a target instead of selecting the target
    using its ID.

    `xsct% targets`

    The targets are listed as shown in the following figure.

    ![](./media/image75.png)

### Load U-Boot Using XSCT/XSDB

1. Download the U-Boot application on Cortex-A53 \#0 using the
     following commands:

    By default, JTAG Security gates are enabled. Disable the security
    gates for DAP, PL TAP, and PMU (this will make PMU MB target visible
    to Debugger).

    ```
    xsct% targets -set -filter {name =~ "PSU"}
    xsct% mwr 0xffca0038 0x1ff
    xsct% targets
    ```

    Verify if the PMU MB target is listed under the PMU device. Now, load
    and run PMU Firmware.

    Now, reset APU Cortex-A53 Core 0 to load and run FSBL.

    ```
    xsct% targets -set -filter {name =~ "Cortex-A53 #0"}
    xsct% rst -processor
    ```

    >***Note*:** `rst -processor` clears the reset on an individual processor
    core.

    This step is important, because when Zynq UltraScale+ MPSoC boots up
    in JTAG boot mode, all the APU and RPU cores are held in reset. You
    must clear resets on each core before performing debugging on these
    cores. You can use therst command in XSCT to clear the resets.

    >***Note*:** `rst -cores` clears resets on all the processor cores in the
    group (such as APU or RPU) of which the current target is a child. For
    example, when A53 #0 is the current target, `rst -cores` clears resets
    on all the Cortex-A53 cores in APU.

    Load and run FSBL.

    ```
    xsct% dow {C:\edt\fsbl_a53\Debug\fsbl_a53.elf}
    xsct% con
    ```

    Verify FSBL messages on Serial Terminal and stop FSBL after couple of
    seconds.

    `xsct% stop`

    Load and run ATF.

    ```
    xsct% dow {C:\edt\qspi_boot\bl31.elf}
    xsct% con
    xsct% stop
    ```

2. Configure a serial terminal (Tera Term, Mini com, or the Serial
     Terminal interface for UART-0 USB-serial connection).

3. For serial terminal settings, see the following figure.

	 ![](./media/image76.png)

4. Load and run U-Boot.

    `xsct% dow {C:\edt\qspi_boot\u-boot.elf}`

5. Run U-Boot, using the con command in XSDB.

    `xsct% con`

6. In the target serial terminal, press any key to stop the U-Boot auto boot.

7. Stop the core using the stop command in XSDB.

    `xsct% stop`

### Load Boot.bin in DDR Using XSDB

1. Download the Boot.bin binary into DDR on ZCU102. Use the same
     Boot.bin created for QSPI boot mode.

    `xsct% dow -data {C:\edt\qspi_boot\qspi_BOOT.bin} 0x2000000`

2. Now continue the U-Boot again, using the con command in XSDB.

    `xsct% con`

### Load the Boot.bin Image in QSPI Using U-Boot

1. Execute the following commands in the U-Boot console on the target
     terminal. These commands erase QSPI and then write the Boot.bin
     image from DDR to QSPI.

    ```
    ZynqMP> sf probe 0 0 0
    ZynqMP> sf erase 0 0x4000000
    ZynqMP> sf write 0x2000000 0 0x4000000
    ```

2. After successfully writing the image to QSPI, turn off the board and
     set up the ZCU102 board as described in [Set Up the ZCU102 Board](#set-up-the-zcu102-board).

    You can see Linux loading on the UART-0 terminal and the R5
    application executing in the UART-1 terminal.

    This chapter focused mostly on system boot and different components
    related to system boot. In the next chapter, you will focus on
    applications, Linux, and Standalone (bare-metal) applications which
    will make use of PS peripherals, PL IPs, and processing power of APU
    Cores and RPU cores.

## Boot Sequence for USB Boot Mode

 Zynq UltraScale+ MPSoC also supports USB Slave Boot Mode. This is
 using the USB DFU Device Firmware Upgrade (DFU) Device Class
 Specification of USB. Using a standard update utility such as
 [OpenMoko\'s DFU-Util](http://dfu-util.sourceforge.net/releases/), you
 will be able to load the newly created image on

 Zynq UltraScale+ MPSoC using the USB Port. The following steps list
 the required configuration to load boot images using this boot mode.
 The DFU Utility is also shipped with the Vitis unified software
 platform and PetaLinux.

### Configure FSBL to Enable USB Boot Mode

 There are few changes required in FSBL to enable USB Boot Mode. USB
 boot mode support increases the footprint of FSBL (by approximately 10
 KB). Because it is intended mostly during the initial development
 phase, its support is disabled by default to conserve OCM space. In
 this section, you will modify the FSBL to enable the USB Boot Mode.
 Considering the FSBL project is used extensively throughout this
 tutorial, do not modify the existing FSBL project. Instead, this
 section will make use of new FSBL project.

#### Create First Stage Boot Loader for USB Boot

1. In the Vitis IDE, select **File→ New → Application Project** to open
     the New Project wizard.

2. Use the information in the table below to make your selections in
     the wizard.

    *Table 9:*  **Wizard Properties and Commands**

   |  Wizard Screen       |    System Properties   |  Settings       |
   |----------------------|------------------------|----------------------|
   |  Platform            |  Select platform from repository      |  edt_zcu102_wrapper |
   |  Application project details        |  Application project name       |  fsbl_usb_boot      |
   |                      |  System project name    |  fsbl_usb_boot_system                    |
   |                      |  Target processor   |  psu_cortexa53_0    |
   |  Domain             |  Domain             |  standalone on psu_cortexa53_0     |
   |  Templates          |  Available templates         |  Zynq MP FSBL       |

3. Click **Finish**.

4. In the Explorer view, expand the fsbl_usb_boot project and open
     `xfsbl_config.h` from **fsbl_usb_boot→ src→xfsbl_config.h**.

5. In `xfsbl_config.h` change or set following settings:

    ```
    #define FSBL_QSPI_EXCLUDE_VAL (1U)
    #define FSBL_SD_EXCLUDE_VAL (1U)
    #define FSBL_USB_EXCLUDE_VAL (0U)
    ```

6. Use **CTRL + S** to save these changes.

7. Build FSBL (fsbl_usb_boot).

### Creating Boot Images for USB Boot

 In this section, you will create the Boot Images to be loaded, via USB
 using DFU utility. Device firmware upgrade (DFU) is intended to
 download and upload firmware to/from devices connected over USB. In
 this boot mode, the boot loader (FSBL) and the PMU firmware which are
 loaded by bootROM are copied to Zynq UltraScale+ on-chip memory (OCM)
 from the host machine USB port using DFU Utility. The size of OCM (256
 KB) limits the size of boot image downloaded by bootROM in USB boot
 mode. Considering this, and subject to size requirement being met,
 only FSBL and PMU firmware are stitched into the first boot.bin, which
 is copied to OCM. The remaining boot partitions will be stitched in
 another boot image and copied to DDR to be loaded by the FSBL which is
 already loaded and running at this stage. Follow these steps to create
 boot images for this boot mode.

1. In the Vitis IDE, select **Xilinx → Create Boot Image**.

2. Select `fsbl_usb_boot.elf` and
     `pmufw.elf` partitions and set them as shown in the following
     figure.

     ![](./media/image77.png)

3. Ensure that PMU partition is set to be loaded by bootROM.

4. Click **Create Image** to generate BOOT.bin.

#### Modifying PetaLinux U-Boot

 Modify PetaLinux U-Boot so that it can load the image.ub image. The
 device tree needs to be modified to set USB in the Peripheral mode.
 The default PetaLinux configuration is set for the USB in host mode.
 Follow these steps to modify `system-user.dtsi` in the PetaLinux project

 `<PetaLinux-project>/project-spec/meta-user/recipes-bsp/device-tree/
 files/system-user.dtsi`.

1. Add the following to system-user.dtsi, so that it looks like:

    ```
    /include/ "system-conf.dtsi"
    / {
    gpio-keys { sw19 {
    status = "disabled";
    };
    };
    };
    &uart1
    {
    status = "disabled";
    };
    &dwc3_0 {
    dr_mode = "peripheral"; maximum-speed = "super-speed";
    };
    ```

    The modified system-user.dtsi file can be found in `<Design Files>/usb_boot` released with the tutorial.

2. Build PetaLinux with the following changes.

    `$ petalinux-build`

The following steps describe how to create a `usb_boot.bin` comprising rest of the partitions.

>***Note*:** Copy the newly generated U-Boot to `C:\edt\usb_boot\`. The `u-boot.elf` is also available in [Design Files for This Tutorial](2-getting-started.md#design-files-for-this-tutorial).

1. In the Vitis IDE, select **Xilinx → Create Boot Image**.

2. Select **FSBL** and rest of the partitions and set them as shown in
     the following figure. You can also choose to import the BIF file
     from the SD boot sequence.

     ![](./media/image78.png)

    >***Note*:** Ensure that you have set the correct exception levels for
    ATF (EL-3, TrustZone) and U-Boot (EL-2) partitions. These settings can
    be ignored for other partitions.

     The PMU firmware partition is not required in this image, as
     it will be loaded by the bootROM before this image (`usb_boot.bin`)
     is loaded.

3. Click on **Create Image** to generate `usb_boot.bin`.

    >***Note*:** In addition to `BOOT.bin` and `usb_boot.bin`, the Linux image
    like image.ub is required to boot till Linux. This `image.ub` is loaded by the DFU utility separately.

### Boot using USB Boot

 In this section you will load the boot images on ZCU102 target using
 DFU utility. Before you start, set the board connections as shown
 below:

1. Set ZCU102 for USB Boot mode by
    setting SW6 (1-OFF, 2-OFF, 3-OFF, and 4-ON), as shown below:

    ![](./media/image79.jpeg)

2. Connect a USB 3.0 Cable to J96 USB 3 ULPI Connector, and the other
     end of the Cable to USB port on the host machine.

3. Connect a USB Micro cable between USB-UART port on Board (J83) and
     the host machine.

4. Start a terminal session, using Tera Term or Minicom depending on
     the host machine being used, as well as the COM port and baud rate
     for your system.

5. Power ON the board.

 The following steps will load the boot images via USB using DFU
 utility, which can be found in `VITIS\2019.1\tps\lnx64\dfu-util-0.9`.

 Alternatively you can also install DFU utility on the Linux using
 Package Manager supported by Linux Distribution.

#### Boot Commands for Linux Host Machine

1. Check if the DFU can detect the USB target.

    `$ sudo dfu-util -l`

    The USB device should be enumerated with VendorId: ProductId which is
    `03fd:0050`. You should see something like the following message:

    ```Found DFU: [03fd:0050] ver=0100, devnum=30, cfg=1, intf=0, alt=0,
    name="Xilinx DFU Downloader", serial="2A49876D9CC1AA4"
    ```

    >***Note*:** If you do not see the 'Found DFU' message, verify the
    connection and retry.

2. Now download the BOOT.bin that was created in [Creating Boot Images
     for USB Boot](#creating-boot-images-for-usb-boot).

    `$ sudo dfu-util -d 03fd:0050 -D <USB_Boot_Image_Path>/Boot.bin`

    Verify from Serial Terminal if the FSBL is loaded successfully.

3. Now download the usb_boot.bin. Before this, start another terminal
     session for UART-1 serial console.

    `$ sudo dfu-util -d 03fd:0050 -D <USB_Boot_Image_Path>/usb_boot.bin`

    Check UART 0 terminal and wait until U-Boot loads.

4. On U-Boot prompt, type **Enter** to terminate autoboot. Verify from
     the UART1 console that the R5 application is also loaded
     successfully.

5. Run the following commands to setup the dfu environment in the
     U-Boot command line:

    ```
    $ setenv loadaddr 0x10000000
    $ setenv kernel_addr 0x10000000
    $ setenv kernel_size 0x1e00000
    $ setenv dfu_ram_info "setenv dfu_alt_info image.ub ram $kernel_addr
    $kernel_size"
    ```

6. In U-Boot console start DFU_RAM to enable downloading Linux Images

    `U-boot\ run dfu_ram`

7. Download the Linux image Image.ub using the following command from
     the host machine terminal:

    `$ sudo dfu-util -d 03fd:0300 -D <PetaLinux_project>/images/linux/image.ub -a 0`

8. Now execute **CTRL+C** on U-Boot console to stop dfu_ram.

9. Run bootm command from the U-Boot console.

    `U-boot\ bootm`

10. Verify that Linux loads successfully on the target.

 >***Note*:** In this example, image.ub is copied to DDR location based
 on \#define DFU_ALT_INFO_RAM settings in U-Boot configuration. The
 same can be modified to copy other image files to DDR location. Then,
 if required, these images can be copied to QSPI using U-Boot commands
 listed in [Boot Sequence for QSPI-Boot Mode Using JTAG](#boot-sequence-for-qspi-boot-mode-using-jtag).

#### Boot Commands for Windows Host Machine

1. In the Vitis IDE, Select **Xilinx → Launch Shell**.

2. In shell, check if the DFU can detect the USB target:

    `> dfu-util.exe -l`

    >***Note*:** `dfu-util.exe` can be found in `<VITIS_Installation_path>\VITIS\2020.1\tps\Win64\dfu-util-0.9\dfu-util.exe`

3. The USB device should be enumerated with VendorId: ProductId which
     is `03fd:0050`.

    >***Note*:** If you do not see the message starting with "Found DFU",
    download and install "zadig" software. Open the software and click
    **Options** and select **List all devices**. Select device **Xilinx
    Dfu Downloader** and click **Install driver**.

4. Now download the Boot.bin that was created in [Creating Boot Images for USB Boot](#creating-boot-images-for-usb-boot).

    `$ dfu-util.exe -d 03fd:0050 -D BOOT.bin`

5. Verify from Serial Terminal (UART 0) that FSBL is loaded
     successfully.

6. Now download the usb_boot.bin. Before this start another terminal
     session for UART-1 serial console.

    `$ dfu-util.exe -d 03fd:0050 -D usb_boot.bin`

7. On U-Boot prompt type Enter to terminate auto-boot. Verify from
     UART1 console that the R5 application is also loaded successfully.

    >***Note*:** At this point, use Zadig utility to install drivers for
    "USB download gadget" with device ID 03fd:0300. Without this, zadig
    software does not show "Xilinx DFU Downloader" after booting U-Boot
    on target.

8. Run the following commands to setup the dfu environment in U-Boot
     command line:

    ```
    $ setenv loadaddr 0x10000000
    $ setenv kernel_addr 0x10000000
    $ setenv kernel_size 0x1e00000
    $ setenv dfu_ram_info "setenv dfu_alt_info image.ub ram $kernel_addr $kernel_size"
    ```

9. In U-Boot console, start DFU_RAM to enable downloading Linux Images:

    `U-boot\ run dfu_ram`

10. Download Linux image image.ub using the following command from the
     host machine terminal:

    `$ dfu-util.exe -d 03fd:0300 -D image.ub -a 0`

11. Run bootm command from the U-Boot console.

    `U-boot\ bootm`

12. Verify that Linux loads successfully on the target.





© Copyright 2017-2020 Xilinx, Inc.
