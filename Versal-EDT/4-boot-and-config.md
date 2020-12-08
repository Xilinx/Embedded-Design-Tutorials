# Boot and Configuration

 The purpose of this chapter is to show how to integrate and load boot
 loaders, bare-metal applications (For APU/RPU), and the Linux Operating
 System for a Versal&trade; ACAP. This chapter discusses the following
 topics:

- System software: PLM, Arm&reg; trusted firmware (ATF), U-Boot

- Steps to generate boot image for standalone application.

- Boot sequences for SD-boot, and QSPI and OSPI boot modes.

 You can achieve these configurations using a the Xilinx&reg; Vitis&trade;
 software platform and PetaLinux Tool flow. While [Chapter 2: Versal
 ACAP CIPS and NoC (DDR) IP Core Configuration](#chapter-2) focused
 only on creating software blocks for each processing unit in the PS,
 this chapter explains how these blocks can be loaded as a part of a
 bigger system.

## System Software

 The following system software blocks cover most of the boot and
 configuration for this chapter.

### Platform Loader and Manager

 The platform loader and manager (PLM) is software that runs on one of the dedicated processors in the Platform Management Controller (PMC) block of the Versal ACAP. It is responsible for boot and run time management, including platform management, error management, partial
 reconfiguration, and subsystem restart of the device. PLM can reload
 images, and load partial PDIs and service interrupts. The PLM reads
 the programmable device image from the boot source and the PLM
 software configures the components of the system including the NoC
 initialization, DDR memory initialization, programmable logic, and
 processing system, and then completes the device boot.

### U-Boot

 U-Boot acts as a secondary boot loader. After the PLM handoff, U-Boot
 loads Linux onto the Arm A72 APU and configures the rest of the
 peripherals in the processing system based on the board configuration.
 U-Boot can fetch images from different memory sources like eMMC, SATA,
 TFTP, SD, and QSPI. U-Boot can be configured and built using the
 PetaLinux tool flow.

### Arm Trusted Firmware

 The Arm Trusted Firmware (ATF) is a transparent bare-metal application
 layer executed in Exception Level 3 (EL3) on the APU. The ATF includes
 a Secure Monitor layer for switching between the secure and the
 non-secure world. The Secure Monitor calls and implementation of
 Trusted Board Boot Requirements (TBBR) makes the ATF layer a mandatory
 requirement to load Linux on the APU on Versal ACAP. The PLM loads
 the ATF to be executed by the APU, which keeps running in EL3 awaiting
 a service request. The PLM also loads U-Boot into DDR to be executed
 by the APU, which loads Linux OS in SMP mode on the APU. The ATF
 (`bl31.elf`) is built by default in PetaLinux and can be found in the
 PetaLinux Project images directory.

## Generating Boot Image for Standalone Application

 The Vitis software platform does not support automatic boot image
 creation for Versal architecture. To generate a bootable image, use
 Bootgen, which is a command line utility which is part of the Vitis
 software platform package. The principle function of Bootgen is to
 integrate the various partitions of the bootable image. Bootgen uses a
 Bootgen Image Format (BIF) file as an input and generates a single
 file image in binary BIN or PDI format. It outputs a single file image
 which can be loaded into non-volatile memory (NVM) (QSPI or SD Card). Use the following
 steps to generate a PDI/BIN file:

1. Open the XSCT Console view in the Vitis IDE, if not already open, by
     clicking on **Window → Show View**. Type `xsct console` within the
     search bar of the Show View wizard. Click **Open** to open the
     console.

    ![](./media/image49.png)

2. Create a folder where you want to generate the boot image by typing the following command in the XSCT Console:

     ```
     mkdir bootimages
     cd bootimages/
     ```

3. Copy the sd_boot.bif file present within the
     `<design-package>/standalone/helloworld_images_cips_only` or
     `<design-package>/standalone/helloworld_images_cips_ddr`
     directory, the PDI file present within `<Vitis platform project>/hw/<.pdi-file>`, and the application elf files present within the `<Vitis application-project>/Debug` folder to the folder created in step 2.

   >***Note*:** If needed, open the `sd_boot.bif` file in a text editor of
     your choice and modify the name of the PDI or elfs as per your Vitis
     projects.

4. Run the following command in the XSCT Console view.

    `bootgen -image <bif filename>.bif -arch versal -o BOOT.BIN`

    The following log is displayed in the XSCT Console view.

    ![](./media/image51.jpeg)

## Boot Sequence for SD-Boot Mode

 The following steps demonstrate the boot sequence for the SD-boot
 mode.

1. To verify the image, copy the required images to the SD card:

    - For standalone, copy the `BOOT.BIN` to the SD card.

    - For Linux images, navigate to the `<plnx-proj-root>/images/linux` and copy `BOOT.BIN`, `image.ub`, and `boot.scr` to the SD card.

    >***Note*:** You can either boot the VCK190 board using the
    ready-to-test images as part of the released package path,
    `<design-package>/GPIO/bootimages`, or refer to [Example Project:
    Creating Linux Images Using
    PetaLinux](#example-project-creating-linux-images-using-petalinux) to
    build your own set of Linux images using the PetaLinux tool.

2. Load the SD card into the VMK180/VCK190 board, in the J302 connector.

3. Connect the Micro USB cable into the VMK180/VCK190 Board Micro USB
     port (J207), and the other end into an open USB port on the host
     machine.

4. Configure the board to boot in SD-Boot mode by setting switch SW1 as
     shown in the following figure.

    ![](./media/image52.png)

5. Connect 12V power to the VMK180/VCK190 6-Pin Molex connector.

6. Start a terminal session, using Tera
     Term or Minicom depending on the host machine being used. Set the
     COM port and baud rate for your system, as shown in the following
     figure.

     ![](./media/image46.png)

7. For port settings, verify COM Port in the device manager and select
     the com port with interface-0.

8. Turn on the VMK180/VCK190 board using the power switch (SW13).

     >***Note*:** For standalone images, the respective logs are displayed
    on the terminal. For Linux images, you can log in using user: root and
    pw: root after the boot-up sequence on the terminal. After that, run
    gpiotest on the terminal. You will see logs as shown in the following
    figure.

    ![](./media/led_example_console_prints.PNG)

## Boot Sequence for QSPI Boot Mode

 This section demonstrates the boot sequence for the QSPI boot mode.
 For this, you need to connect a QSPI daughter card (part number
 X_EBM-01, REV_A01) as shown in the following figure:

 *Figure 2:* **Daughter Card on VCK190**

![QSPI-boot-halfform-factor-module](./media/image54.jpeg)

>***Note*:** For standalone, copy the BOOT.BIN to the SD card. For Linux images, you can either boot the VCK190 board using the ready-to-test images as part of the released package path, `<designpackage>/GPIO/bootimages`, or refer to [Example Project: Creating Linux Images Using PetaLinux](./Versal-EDT/5-system-design-example.md#example-project-creating-linux-images-using-petalinux) to build your own set of Linux images using the PetaLinux tool.

 You need to flash the images to the daughter card, using the following
 steps:

1. With the card powered off, install the daughter card.

2. Set the boot mode switch SW1 to ON-OFF-OFF-OFF
     as shown in the following figure.
     
     ![](./media/image55.jpeg)

3. Insert the SD card in the SD card slot on the board, as follows:

    ![](./media/image56.jpeg)

4. Power on the board. At the U-Boot stage, when the message *\"Hit any
     key to stop autoboot:\"* appears, hit any key, then run the
     following commands to flash the images on the QSPI daughter card:

    ```
    sf probe 0 0 0
    sf erase 0x0 0x10000000
    fatload mmc 0 0x80000 boot.bin
    sf write 0x80000 0x0 ${filesize}
    fatload mmc 0 0x80000 image.ub
    sf write 0x80000 0xF00000 0x6400000
    fatload mmc 0 0x80000 boot.scr
    sf write 0x80000 0x7F80000 0x999
    ```

5. After flashing the images, turn off the power switch on the board,
     and change the boot mode pin settings to QSPI mode, that is
     ON-OFF-ON-ON as follows:

    ![](./media/image52.png)

6. Power cycle the board. The board now boots up using the images in
     the QSPI flash.

 © Copyright 2020 Xilinx, Inc.
