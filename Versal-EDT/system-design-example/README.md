# System Design Example using Scalar Engine and Adaptable Engine

 This chapter guides you through building a system based on Versal™
 devices using available tools and supported software blocks. This
 chapter demonstrates how to use the Vivado® tool to create an embedded
 design using PL AXI GPIO. It also demonstrates the steps to configure
 and build the Linux operating system for an Arm® Cortex™-A72
 core-based APU on a Versal device.

 Examples using the PetaLinux tool are also provided in this chapter.

## Design Example: Using AXI GPIO

 The Linux application uses a PL-based AXI GPIO interface to monitor
 the DIP switch of the board and accordingly control the board\'s LEDs.
 The LED application can run on both the VMK180/ VCK190.

### Configuring Hardware

 The first step in this design is to configure the PS and PL sections.
 You can do this using the Vivado® IP integrator. You start with adding
 the required IPs from the Vivado IP catalog and then connect the
 components to blocks in the PS subsystem. To configure the hardware,
 follow these steps:

  ***Note*:** If the Vivado® Design Suite is open already, jump to step 3.

1. Open the Vivado project you created in [Chapter 2: Versal ACAP CIPS
     and NoC (DDR) IP Core Configuration](#chapter-2) and [NoC (and
     DDR) IP Core Configuration](#noc-and-ddr-ip-core-configuration).

    `C:/edt/edt_versal/edt_versal.xpr`

2. In the Flow Navigator, under **IP Integrator**, click **Open Block
     Design**.

    ![](./media/image5.png)

3. Right-click the block diagram and select **Add IP**.

#### *Connecting IP Blocks to Create a Complete System*

To connect IP blocks to create a system, follow these steps.

1. Double-click the Versal™ ACAP CIPS IP core.

2. Click **PS-PMC→ PL-PS Interfaces**.

    ![](./media/image60.png)

3. Enable the M_AXI_FPD interface, and set the Number of PL Resets to
     1, as shown in the previous figure.

4. Click **Clock Configuration**, and then click on the Output Clocks
     tab.

5. Expand PMC Domain Clocks. Then expand PL Fabric Clocks. Configure
     the PL0_REF_CLK clock as shown in the following figures:

    ![](./media/image61.jpeg)

6. Click **OK** to complete the configuration and return to the block
     diagram.

#### Adding and Configuring IP Addresses

To add and configure IP addresses, follow these steps.

1. Right-click the block diagram and select **Add IP**.

2. Search for AXI GPIO and double-click the **AXI GPIO IP** to add it
     to your design.

3. Click **Run Connection Automation** in the block
     design window.
     ![](./media/image62.png)

    The Run Connection Automation dialog box opens.

4. In the Run Connection Automation dialog box, select the All
     Automation check box.

    ![](./media/image63.png)

    This checks the automation for all the ports of the AXI GPIO IP.

5. Click **GPIO** and set the Select
     Board Part Interface to **Custom** as shown below.
     
     ![](./media/image64.png)

6. Click **S_AXI**. Set the configurations as shown below.

    ![](./media/image65.jpeg)

    This configuration sets the following connections:

    - Connects the S_AXI of AXI_GPIO to M_AXI_FPD of CIPS with
        SmartConnect as a bridge IP between CIPS and AXI GPIO IPs.

    - Enables the processor system reset IP.

    - Connects the pl0_ref_clk to the processor system reset, AXI GPIO,
        and the SmartConnect IP clocks.

    - Connects the reset of the SmartConnect and AXI GPIO to the
        peripheral_aresetn of the processor system reset IP.

7. Click **OK**.

8. Click **Run Connection Automation** in the block design window and
     select the All Automation check box.

9. Click **ext_reset_in** and configure the setting as shown below.

    ![](./media/image66.jpeg)

    This connects the ext_reset_in of the processor system reset IP to the
    pl_resetn of the CIPS.

10. Click **OK**.

11. Disconnect the aresetn of SmartConnect IP from peripheral_aresetn of
     processor system reset IP.

12. Connect the aresetn of SmartConnect
     IP to interconnect_aresetn of processor system reset IP.

     ![](./media/image67.jpeg)

13. Double-click the AXI GPIO IP to open it.

14. Go to the IP Configuration tab and configure the settings as shown
     in the following figure.

     ![](./media/image68.png)

15. Click **OK**.

16. Right-click the block diagram and select **Add IP**.

17. Add the **Slice IP** and connect the AXI GPIO output
     gpio_io_o\[4:0\] to the Din\[3:0\] pin of slice IP.

18. Add three more instances of Slice IP and connect each input to AXI
     GPIO output gpio_io_o\[4:0\].

19. Make the output of Slice IP as External.

20. Configure each Slice IP as shown below.

    ![](./media/image69.png)

    ![](./media/image70.png)

    ![](./media/image71.png)

    ![](./media/image72.png)

The overall block design is shown in the following figure:

![](./media/image73.jpeg)

#### Validating the Design and Generating the Output

To validate the design and to generate the output product, follow
 these steps:

1. Return to the block design view and save your block design (press
     **Ctrl+S**).

2. Right-click the white space of the block diagram view, and select
     **Validate Design**. Alternatively, you can press the **F6** key.

    A dialog box with the following message opens:

    `Validation successful. There are no errors or critical warnings in this
design.`

3. Click **OK** to close the message.

4. Click the **Sources** window.

5. Add the constraints file under Constraints.

    >***Note*:** The constraints file is provided as part of the package in
    the pl_axigpio/constrs folder.

6. Click **Hierarchy**.

7. In the Sources window, under Design Sources, expand
     **edt_versal_wrapper**.

8. Right-click the top-level block design, edt_versal_i : edt_versal
     (`edt_versal.bd`), and select **Generate Output Products**.

    ![](./media/image15.png)

9. Click **Generate**.

10. When the Generate Output Products process completes, click **OK**.

11. In the Sources window, click the **IP Sources** view. Here you can
     see the output products that you just generated, as shown in the
     following figure.

    ![](./media/image74.png)

#### Synthesizing, Implementing, and Generating the Device Image

Follow these steps to generate a device image for the design.

1. Go to **Flow Navigator→ Synthesis** and click **PROGRAM AND DEBUG**.

2. Click **Generate Device Image** and click **OK**.

    When the Device Image Generation completes, the Device Image
    Generation Completed dialog box opens.

3. Click **Cancel** to close the window.

4. Export hardware after you generate the Device Image.

#### Exporting Hardware

1. From the Vivado toolbar, select **File→ Export → Export Hardware**.
     The Export Hardware dialog box opens.

2. Choose **Fixed** and click **Next**.

3. Choose **Include device image** and click **Next**.

4. Provide the name for your exported file and choose the location.
     Click **Next**.

    A warning message appears if a Hardware Module has already been
    exported. Click **Yes** to overwrite the existing XSA file, if the
    overwrite message is displayed.

5. Click **Finish**.

## Example Project: FreeRTOS GPIO Application Project With RPU

 This section explains how to configure and build the FreeRTOS
 application for an Arm&reg; Cortex&trade;- R5F core based RPU on a Versal&trade;
 device.

 The following steps demonstrate the procedure to create a FreeRTOS
 Application from Arm Cortex-R5F:

1. Select **File→ New → Application Project**. The **Creating a New
     Application Project** wizard opens. If this is the first time that
     you have launched the Vitis™ IDE, you can select **Create
     Application Project** on the Welcome screen as shown in the
     following figure.

    ![](./media/image75.jpeg)

    >***Note*:** Optionally, you can check the box next to **Skip welcome
    page next time** to skip seeing the welcome page every time.

2. There are four components of an application project in the Vitis
     IDE: a target platform, a system project, a domain and a template.To create a new application project in the Vitis IDE, follow these steps:

   1. A target platform is composed of a base hardware design and the
     meta-data used in attaching accelerators to declared interfaces.
     Choose a platform or create a platform project from the XSA that
     you exported from the Vivado® Design Suite.

   2. Put the application project in a system project, and associate it
     with a processor.

   3. The domain defines the processor and operating system used for
     running the host program on the target platform.

   4. Choose a template for the application, to quick start development.
     Use the following information to make your selections in the
     wizard screens.

	*Table 9:* **Wizard Information**

   |  Wizard Screen  |  System Properties        |  Setting or Command to Use  |
   |-----------------|---------------------------|----------------------------------------|
   | Platform        | Create a new platform from hardware (XSA)        | Click Browse to add your XSA file  |
   |                      |  Platform Name      |  vck190_platform    |
   | Application Project Detail       |  Application project name       |  freertos_gpio_test |
   |                      |  Select a system project   |  +Create New        |
   |                      |  System project name       |  freertos_gpio_test_system              |
   |                      |  Processor                 |  psv_cortexr5_0     |
   |  Domain              |  Select a domain           |  +Create New        |
   |                      |  Name                      |  The default name assigned  |
   |                      |  Display Name              |  The default name assigned  |
   |                      |  Operating System          |  freertos10_xilinx  |
   |                      |  Processor                 |  psv_cortexr5_0     |
   |  Templates           |  Available                 |  Freertos Hello     |
   |                      |  Templates                 |  world              |

   The Vitis software platform creates the board support package for the
   Platform project (**vck190_platform**) and the system project
   (**freertos_gpio_test_system**) containing an application project
   named **freertos_gpio_test** under the Explorer view after performing
   the preceding steps.

3. Right click the `freertos_hello_world.c` file under `src/` and rename
     the `freertos_hello_world.c` file to `freertos_gpio_test.c`. Copy the
     `freertos_gpio_test.c` file from the FreeRTOS project path to
     `freertos_gpio_test.c` under `src/`.

4. Right-click **vck190_platform**and select **Build Project**. Alternatively, you can click
    ![](./media/image77.jpeg).

    >***Note*:** If you cannot see the project explorer, click the restore
    icon on the left panel and then perform this step.

## Example Project: Creating Linux Images Using PetaLinux

 The previous examples demonstrated the creation, compilation, and
 downloading of bare metal applications for the APU and RPU using the
 Xilinx® Vitis™ software platform. This section explains how to
 configure and build the Linux operating system for an Arm® Cortex™-A72
 core- based APU on a Versal™ device. You can use the PetaLinux tool
 with the board-specific BSP to configure and build Linux images.

 This example needs a Linux host machine. Refer to the [PetaLinux Tools
 Documentation:](https://www.xilinx.com/member/versal_tools_ea.html#embedded)
 [Reference Guide
 (UG1144)](https://www.xilinx.com/member/versal_tools_ea.html#embedded)
 for information on dependencies and installation procedure for the
 PetaLinux tool.

>**IMPORTANT!** *This example uses the VCK190 PetaLinux BSP to create a
 PetaLinux project. Ensure that you have downloaded the respective BSP
 for PetaLinux (vck190/vmk180).*
>
>- If you are using the VCK190 board, download the xilinx-vck190-v2020.1-final.bsp file from
     <https://www.xilinx.com/member/vck190_headstart.html.
>
>- If you are using the VMK180 board, download the VMK180 PetaLinux
     2020.1 BSP (xilinx- vmk180-v2020.1-final.bsp) from
     <https://www.xilinx.com/member/vmk180_headstart.html.

1. Copy the respective board\'s PetaLinux BSP to the current directory.

2. Create a PetaLinux project using the following command.

    >***Note*:** For VMK180 board, use `xilinx-vmk180-vxxyy.z-final.bsp`
    after the `-s` option in the command.

3. Change to the PetaLinux project directory using the following command.

    `\$cd led_example`

4. Copy the hardware platform project XSA to the Linux host machine.

    >***Note*:** For VMK180 board, use the XSA file which you generated in
    the [Design Example: Using AXI](#design-example-using-axi-gpio)
    [GPIO](#design-example-using-axi-gpio) section.

5. Reconfigure the BSP using the following commands.

    This command opens the PetaLinux Configuration window. For this
    example, no need to change anything in this window.

6. Select **<Save>** to save the above configuration and then
     **<Exit>** to exit the configuration wizard.

7. Create a Linux application named gpiotest within the PetaLinux
     project using the following command.

    `\$petalinux-create -t apps \--template install \--name gpiotest\--enable`

8. Copy application files from `<design-package>/GPIO/bootimages` to
     the project using the following commands.

     ```
     $cp <design-package>/GPIO/design_files/files/* project-spec/meta-user/recipes-apps/gpiotest/files/
     $cp <design-package>/GPIO/design_files/gpiotest.bb project-spec/metauser/recipes-apps/gpiotest/gpiotest.bb
    ```

9. Enable GPIO support within kernel configuration.

    `\$petalinux-config -c kernel`

    >***Note*:** This command opens the kernel configuration wizard for the
    PetaLinux project.

10. Navigate to **Device drivers→ GPIO
     Support** and enable it by pressing the **<Y>** key. Press
     **Enter** and enable the Debug GPIO calls and `/sys/class/gpio/...
     (sysfs interface)` entries by pressing the **<Y>** key as shown
     in the following figure.
     
     ![](./media/image79.jpeg)

11. Navigate to **Memory mapped GPIO drivers** and enable Xilinx GPIO
     support and Xilinx Zynq GPIO support by pressing **<Y>** key as
     shown in the following figure.

    ![](./media/image80.jpeg)

12. Click **<Save>** to save the above configuration and then
     **<Exit>** option to exit the configuration wizard.

13. Build the Linux images using the following command.

    `\$petalinux-build`

### Combining FreeRTOS and APU Images using a BIF File

1. Open the XSCT console in your Vitis IDE workspace.

2. Navigate to the `images/linux` directory of your PetaLinux project:

    `$cd <petalinux-project>/images/linux/`

3. Copy the `bootgen.bif` file from `<design-package>/path` to the
     `images/linux` directory.

    `$cp <design-package>/path/bootgen.bif`

4. Run the following command to create `BOOT.BIN`.

    `$bootgen -image bootgen.bif -arch versal -o BOOT.BIN -w`

    This creates a `BOOT.BIN` image file in the `<petalinux-project>/images/linux/` directory.

>***Note*:** To run the images using SD boot mode, see [Boot Sequence
 for SD-Boot Mode](#boot-sequence-for-sd-boot-mode).
