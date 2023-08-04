**************************************************************
System Design Example using Scalar Engine and Adaptable Engine
**************************************************************

This chapter guides you through building a system based on Versal |trade| devices using available tools and supported software blocks. This chapter demonstrates how to use the AMD Vivado |trade| Design Suite to create an embedded design using PL AXI GPIO and PL AXI UART. It also describes how to configure and build the Linux operating system for an Arm |reg| Cortex |trade|-A72 core-based APU on a Versal device.

Examples using the PetaLinux tool are provided in this chapter.

.. note:: The design files for this chapter have been validated with Vivado Design Suite 2022.1.

.. _5-using-axi-gpio:

==============================
Design Example: Using AXI GPIO
==============================

The Linux application uses a PL-based AXI GPIO interface to monitor the DIP switch of the board and accordingly control the LEDs on the board. The LED application can run on VCK190 and VMK180 boards.

The RPU application uses the PL-based AXI UART lite to print the debug messages on the AXI UART console instead of using the PS UART console. The PL UART application can run on VCK190 and VMK180 boards.

Configuring Hardware
~~~~~~~~~~~~~~~~~~~~

The first step in this design is to configure the PS and PL sections. You can do this using the Vivado IP integrator. Start with adding the required IPs from the Vivado IP catalog and then connect the components to blocks in the PS subsystem. To configure the hardware, follow these steps:

.. note:: If the Vivado Design Suite is open already, jump to step 3.

1. Open the Vivado project you created in :doc:`../docs/2-cips-noc-ip-config`.

   `C:/edt/edt_versal/edt_versal.xpr`

2. In the Flow Navigator, under **IP Integrator**, click **Open Block Design**.

   .. image:: ./media/image5.png

3. Right-click the block diagram and select **Add IP**.

Connecting IP Blocks to Create a Complete System
------------------------------------------------

To connect IP blocks to create a system, follow these steps.

1. Double-click the Versal CIPS IP core.

2. Click **PS-PMC→ PS-PL Interfaces**.

3. Enable the M_AXI_FPD interface and set the **Number of PL Resets** to 1, as shown in the Image.

   .. image:: ./media/PS_PL_Interfaces.png
	
4. Click **Clocking**, and then click on the Output Clocks tab.

5. Expand PMC Domain Clocks. Then expand PL Fabric Clocks. Configure the PL0_REF_CLK to 300 MHz as shown in the following figure:

   .. image:: ./media/clocking_ps_PMC.png

6. Click **Finish** and **OK** to complete the configuration and return to the block diagram.

Adding and Configuring IP Addresses
-----------------------------------

To add and configure IP addresses, follow these steps.

1. Right-click the block diagram and select **Add IP** from the IP catalog.

2. Search for AXI GPIO and double-click the **AXI GPIO IP** to add it to your design.

3. Add another instance of the AXI GPIO IP into the design.

4. Search for **AXI Uartlite** in the IP catalog and add it into the design.

5. Click **Run Connection Automation** in the Block Design view.
    
   .. image:: ./media/image62.png

   The Run Connection Automation dialog box opens.

6. In the Run Connection Automation dialog box, select the All Automation check box.

   .. image:: ./media/image63.png

   This checks the automation for all the ports of the AXI GPIO IP.

7. Click **GPIO** of `axi_gpio_0` and set the Select Board Part Interface to **Custom** as shown below.

   .. image:: ./media/image64.jpg

8. Click **S_AXI** of `axi_gpio_0`. Set the configurations as shown in the following figure:

   .. image:: ./media/gpio_config0.png
   
9. Do Repeat previous step 7 and Step 8 for `axi_gpio_1`.

10. Click **S_AXI** of `axi_uartlite_0`. Set the configurations as shown in the following figure:

    .. image:: media/s-axi-uartlite.png

11. This configuration sets the following connections:

    - Connects the `S_AXI of AXI_GPIO` and AXI Uartlite to `M_AXI_FPD` of CIPS with SmartConnect as a bridge IP between CIPS and AXI GPIO IPs.
    - Enables the processor system reset IP.
    - Connects the `pl0_ref_clk` to the processor system reset, AXI GPIO, and the SmartConnect IP clocks.
    - Connects the reset of the SmartConnect and AXI GPIO to the `peripheral_aresetn` of the processor system reset IP.

12. Click **UART** of `axi_uartlite_0`. Set the configurations as shown in the following figure:

    .. image:: media/uart.png

13. Click **OK**.

14. Click **Run Connection Automation** in the block design window and select the All Automation check box.

15. Click **ext_reset_in** and configure the setting as shown below.

    .. image:: ./media/image66.jpg

    This connects the `ext_reset_in` of the processor system reset IP to the `pl_resetn` of the CIPS.

16. Click **OK**.

17. Disconnect the `aresetn` of SmartConnect IP from `peripheral_aresetn` of processor system reset IP.

18. Connect the `aresetn` of SmartConnect IP to `interconnect_aresetn` of processor system reset IP.

    .. image:: ./media/image67.jpeg

19. Double-click the axi_gpio_0 IP to open it.

20. Go to the IP Configuration tab and configure the settings as shown in the following figure.

    .. image:: ./media/image68.png

21. Make the same setting for axi_gpio_1.

22. Add four more instances of Slice IP.

23. Delete the external pins of the AXI GPIO IP and expand the interfaces.

24. Connect the output pin gpio_io_0 of axi_gpio_0 to slice 0 and slice 1.

25. Similarly, connect the output pin gpio_io_0 of axi_gpio_1 to slice 2 and slice 3.

26. Make the output of Slice IP as External.

27. Configure each Slice IP as shown below.

    .. image:: ./media/image69.png

    .. image:: ./media/image70.png

    .. image:: ./media/image71.png

    .. image:: ./media/image72.png

28. Double-click **axi_uartlite_0** to open the IP.

29. In the Board tab, set Board interface as shown below:

    .. image:: media/board-interface.png
    
30. Go to the IP Configuration tab and configure the settings as shown in the following figure.

    .. image:: media/configure-ip-settings.png

31. Add **Clock Wizard IP**. Double-click to open the IP.

32. Go to Clocking Features tab and set the configuration as shown below:

    .. image:: media/clocking-features.png

33. Make sure the Source option in **Input Clock Information** is set to **Global buffer**.
    
34. Go to Output clocks tab and configure as follows:

    .. image:: media/output-clocks-tab.png

35. Right-click `pl0_ref_clk` of CIPS and click **Disconnect Pin**.

36. Connect the `pl0_ref_clk` from CIPS to input `clk_in1` of the Clocking wizard.

37. Connect the output of clocking wizard to `slowest_sync_clock` of Processor System Reset IP.

    This will help in avoiding timing failure. 

The overall block design is shown in the following figure:

.. image:: media/image73.png

Validating the Design and Generating the Output
-----------------------------------------------

To validate the design and to generate the output product, follow these steps:

1. Return to the block design view and save your block design (press **Ctrl+S**).

2. Right-click in the white space of the Block Diagram view and select **Validate Design**. Alternatively, you can press the F6 key. A message dialog box opens as shown below.
   
   The Vivado tool will prompt you to map the IPs in the design to an address. Click **Yes**.

   .. image:: media/assign-address.png

   .. note:: The number of address segments may vary depending on the number of memory mapped IPs in the design.

   Once the validation is complete, A message dialog box opens as shown below:

   .. image:: media/validation_message.PNG

3. Click **OK** to close the message.

4. Click the **Sources** window.

   1. Expand Constraints.

   2. Right-click on **constrs_1-> ADD Sources**.

      The Add Sources window opens.

   3. Choose **Add or Create Constraints** option and click **Next**.

   4. Choose the .xdc file to be added.

      .. note:: The constraints file is provided as part of the package in the `pl_gpio_uart/constrs` folder.
    
   5. Click **Finish**.

5. Click **Hierarchy**.

6. In the Sources window, under Design Sources, expand **edt_versal_wrapper**.

7. Right-click the top-level block design, edt_versal_i : edt_versal (`edt_versal.bd`), and select **Generate Output Products**.

   .. image:: ./media/GOP.png

8. Click **Generate**.

9. When the Generate Output Products process completes, click **OK**.

10. In the Sources window, click the **IP Sources** view. Here, you can see the output products that you just generated, as shown in the following figure.

    .. image:: ./media/ip-sources-ch5-final.png

Synthesizing, Implementing, and Generating the Device Image
-----------------------------------------------------------

Follow these steps to generate a device image for the design.

1. Go to **Flow Navigator→ Program and Debug**, click **Generate Device Image** and click **OK**.

2. A No Implementation Results Available menu appears. Click **Yes**.

3. A Launch Run menu appears. Click **OK**.

   When the Device Image Generation completes, the Device Image Generation Completed dialog box opens.

4. Click **Cancel** to close the window.

5. Export hardware after you generate the Device Image.

   .. note:: The following steps are optional and you can skip these and go to the :ref:`exporting-hardware-5` section. These steps provide the detailed flow for generating the device image by running synthesis and implementation before generating device image. If you need to understand the flow for generating the device image, follow the steps provided below.

   1. Go to **Flow Navigator→ Synthesis** and click **Run Synthesis**.

      .. image:: media/image17.png

   2. If Vivado prompts you to save your project before launching synthesis, click **Save**.

      While synthesis is running, a status bar is displayed in the upper right-hand window. This status bar spools for various reasons throughout the design process. The status bar signifies that a process is working in the background. When synthesis is complete, the Synthesis Completed dialog box opens.

   3. Select **Run Implementation** and click **OK**.

      When implementation completes, the Implementation Completed dialog box opens.

   4. Select **Generate Device Image** and click **OK**.

      When Device Image Generation completes, the Device Image Generation Completed dialog box opens.

   5.  Click **Cancel** to close the window.

       Export hardware, after you generate Device Image.

.. _exporting-hardware-5:

Exporting Hardware
------------------

1. From the Vivado main menu, select **File→ Export → Export Hardware**. The Export Hardware dialog box opens.

2. Choose **Include bitstream** and click **Next**.

3. Provide a name for your exported file (or use the default provided) and choose the location. Click **Next**.

   A warning message appears if a hardware module has already been exported. Click **Yes** to overwrite the existing XSA file, if the overwrite message is displayed.

4. Click **Finish**.

.. _freertos-axi-uartlite-application-project:

====================================================================
Example Project: FreeRTOS AXI UARTLITE Application Project with RPU
====================================================================

This section explains how to configure and build the FreeRTOS application for an Arm Cortex-R5F core based RPU on a Versal device.

The following steps demonstrate the procedure to create a FreeRTOS Application from Arm Cortex-R5F:

1. Start the AMD Vitis |trade| IDE and create a new workspace, for example, ``c:/edt/freertos``.
   
2. Select **File→ New → Application Project**. The **Creating a New Application Project** wizard opens. If this is the first time that you have launched the Vitis IDE, you can select **Create Application Project** on the Welcome screen as shown in the following figure.

   .. image:: ./media/image75.jpeg

   .. note:: Optionally, you can check the box next to **Skip welcome page next time** to skip seeing the welcome page every time.

3. There are four components of an application project in the Vitis IDE: a target platform, a system project, a domain and a template. To create a new application project in the Vitis IDE, follow these steps:

   1. A target platform is composed of a base hardware design and the meta-data used in attaching accelerators to declared interfaces. Choose a platform or create a platform project from the XSA that you exported from the Vivado Design Suite.
   2. Put the application project in a system project, and associate it with a processor.
   3. The domain defines the processor and operating system used for running the host program on the target platform.
   4. Choose a template for the application, to quick start development. Use the following information to make your selections in the wizard screens.

      *Table 9:* **Wizard Information**

      +---------------+-------------------------+---------------------------+
      | Wizard Screen | System Properties       | Setting or Command to Use |
      +===============+=========================+===========================+
      | Platform      | Create a new platform   | Click Browse to add your  |
      |               | from hardware (XSA)     | XSA file                  |
      +---------------+-------------------------+---------------------------+
      |               | Platform Name           | vck190_platform           |
      +---------------+-------------------------+---------------------------+
      | Application   | Application project     | freertos_gpio_test        |
      | Project       | name                    |                           |
      | Detail        |                         |                           |
      +---------------+-------------------------+---------------------------+
      |               | Select a system project | +Create New               |
      +---------------+-------------------------+---------------------------+
      |               | System project name     | freertos_gpio_test_system |
      +---------------+-------------------------+---------------------------+
      |               | Processor               | versal_cips               |
      |               |                         | _0_pspmc_0_psv_cortexr5_0 |
      +---------------+-------------------------+---------------------------+
      | Dom           | Select a domain         | +Create New               |
      +---------------+-------------------------+---------------------------+
      |               | Name                    | The default name assigned |
      +---------------+-------------------------+---------------------------+
      |               | Display Name            | The default name assigned |
      +---------------+-------------------------+---------------------------+
      |               | Operating System        | freertos10_xilinx         |
      +---------------+-------------------------+---------------------------+
      |               | Processor               | versal_cips               |
      |               |                         | _0_pspmc_0_psv_cortexr5_0 |
      +---------------+-------------------------+---------------------------+
      | Templates     | Available               | Empty                     |
      +---------------+-------------------------+---------------------------+
      |               | Templates               | Application (C)           |
      +---------------+-------------------------+---------------------------+
 
   The Vitis software platform creates the board support package for the Platform project (**vck190_platform**) and the system project (**freertos_gpio_test_system**) containing an application project named **freertos_gpio_test** under the Explorer view after performing the preceding steps.
  
4. Delete the source files under `src/` directory and Copy the freertos source code files from the FreeRTOS project path, ``<design-package>/ch5_system_design_example_source__files/rpu/`` to the ``src/`` directory.

5. Configure the Vitis IDE to enable AXI UARTLITE for RPU application debug console under the FreeRTOS Board Support Package.

   Navigate to `platform.spr` under vck190_platform project, and then select **Modify BSP** settings under Board support package, and modify stdin and stdout to **axi_uarlite_0** by pressing <Y> option as shown in the figure.

   .. image:: media/vitis_uartlite_enable.JPG

6. Click **<OK>** to save the above configuration and exit the configuration wizard.
   
7. Right-click **freertos_gpio_test_system** and select **Build Project**. Alternatively, you can click |build|.

   For building the Linux images and incorporating the FreeRTOS elf into the image, see :ref:`creating-linux-images-using-petalinux`.

8. On PL AXI UART Serial Console, RPU debug logs will be printed as below:

   .. code-block::
   
      Gpio Initialization started
      Counter 0
      Counter 1
      Counter 2
      Counter 3
      Counter 4
      Counter 5

.. _creating-linux-images-using-petalinux:

======================================================
Example Project: Creating Linux Images Using PetaLinux
======================================================

This section explains how to configure and build the Linux operating system for an Arm Cortex-A72 core-based APU on a Versal device. You can use the PetaLinux tool with the board-specific BSP to configure and build Linux images.

This example needs a Linux host machine. Refer to the PetaLinux Tools Documentation Reference Guide `[UG1144] <https://www.xilinx.com/cgi-bin/docs/rdoc?v=latest;d=ug1144-petalinux-tools-reference-guide.pdf>`__ for information on dependencies and installation procedure for the PetaLinux tool.

.. important:: 

   This example uses the VCK190 PetaLinux BSP to create a PetaLinux project. Ensure that you have downloaded the respective BSP for PetaLinux (VCK190/VMK180/VPK180).

   .. list-table::
      :widths: 25 25 25 25
      :header-rows: 1

      * - Board
        - QSPI/SD
        - OSPI
        - eMMC

      * - VCK190 Production Board
        - `xilinx-vck190-v2022.2-final.bsp <https://www.xilinx.com/member/vck190_headstart.html>`__
        - `xilinx-vck190-ospi-v2022.2-final.bsp <https://www.xilinx.com/member/vck190_headstart.html>`__
        - `xilinx-vck190-emmc-v2022.2-final.bsp <https://www.xilinx.com/member/vck190_headstart.html>`__
      
      * - VMK180 Production Board
        - `xilinx-vmk180-v2022.2-final.bsp <https://www.xilinx.com/member/vmk180_headstart.html>`__
        - `xilinx-vmk180-ospi-v2022.2-final.bsp <https://www.xilinx.com/member/vmk180_headstart.html>`__
        - `xilinx-vmk180-emmc-v2022.2-final.bsp <https://www.xilinx.com/member/vmk180_headstart.html>`__

      * - VPK180 Production Board
        - `xilinx-vpk180-v2023.1-final.bsp <https://www.xilinx.com/member/vpk180_headstart.html>`__
        - N/A 
        - N/A

    

1. Copy the respective board's PetaLinux BSP to the current directory.
   
2. Set up the PetaLinux environment
   
   .. code-block::

        $ source <petalinux-tools-path>/settings.csh

3. Create a PetaLinux project using the following command.
   
   .. code-block::
   
        $ petalinux-create -t project -s xilinx-vck190-vxxyy.z-final.bsp -n led_example

   .. note:: For the VMK180 board, use `xilinx-vmk180-vxxyy.z-final.bsp` after the `-s` option in the command.


4. Change to the PetaLinux project directory using the following command.

   .. code-block::
    
        $cd led_example

5. Copy the hardware platform project XSA to the Linux host machine.

   .. note:: For the VMK180 board, use the XSA file that you generated in the :ref:`5-using-axi-gpio`.

6. Reconfigure the BSP using the following commands.

   .. code-block::

        $ petalinux-config --get-hw-description=<path till the directory containing the respective xsa file>

   This command opens the PetaLinux Configuration window. For this example, no need to change anything in this window.

7. Click **<Save>** to save the above configuration and then **<Exit>** to exit the configuration wizard.

8. Create a Linux application named gpiotest within the PetaLinux project using the following command.

   .. code-block::

        $petalinux-create -t apps --template install --name gpiotest --enable

9. Copy application files from ``<design-package>/<vck190 or vmk180>/linux/bootimages`` to the project using the following commands.

   .. code-block::
    
        $cp <design-package>/ch5_system_design_example_source__files/apu/gpiotest_app/gpiotest/files/* <plnxproj-root>/project-spec/meta-user/recipes-apps/gpiotest/files/
        $cp <design-package>/ch5_system_design_example_source__files/apu/gpiotest_app/gpiotest/gpiotest.bb <plnx-proj-root>/project-spec/meta-user/recipes-apps/gpiotest/gpiotest.bb
        $cp <design-package>/ch5_system_design_example_source__files/apu/device_tree/system-user.dtsi <plnx-proj-root>/project-spec/meta-user/recipes-bsp/device-tree/files/system-user.dtsi

10. Enable GPIO support within kernel configuration.

    .. code-block::
        
        $petalinux-config -c kernel

    .. note:: This command opens the kernel configuration wizard for the PetaLinux project.

11. Navigate to **Device drivers→ GPIO Support** and enable it by pressing the **<Y>** key. Press **Enter** and enable the Debug GPIO calls and ``/sys/class/gpio/...(sysfs interface)`` entries by pressing the **<Y>** key as shown in the following figure.

    .. image:: ./media/versal_2021_gpio_debug.png

12. Navigate to **Memory mapped GPIO drivers** and enable GPIO support and Zynq GPIO support by pressing **<Y>** key as shown in the following figure.

    .. image:: ./media/versal_2021_gpio_xilinx.png

13. Click **<Save>** to save the above configuration and then **<Exit>** option to exit the configuration wizard.

14. Configure ROOTFS to disable the AIE, STDC++, and Tcl options to reduce the rootfs size to fit into both SD and OSPI/QSPI Flash partitions. 
 
    .. code-block::
   
       petalinux-config -c rootfs

15. Navigate to User Packages and disable aie-notebooks, openamp-demo-notebooks, packagegroup-petalinux-jupyter, pm-notebooks, python3-ipywidgets support by pressing <Y> key as shown in the following figure.

    .. image:: media/rootfs_config_aie.JPG

16. Navigate to **Filesystem Packages → misc → gcc-runtime** and disable **libstdc++ support** by pressing <Y> key as shown in the following figure.

    .. image:: media/rootfs_config_stdc++.JPG

17. Navigate to **Filesystem Packages → devel → tcltk → tcl** and disable **tcl support** by pressing <Y> key as shown in the following figure. 

    .. image:: media/rootfs_config_tcl.JPG

18. Click **<Save>** to save the above configuration and then click **<Exit>** to exit the configuration wizard.

    .. note:: OSPI and eMMC boot modes will work only on VCK190/VMK180 REVB Production boards.

19. Build the Linux images using the following command.

    .. code-block::
       
        $ petalinux-build

Combining FreeRTOS and APU Images using a BIF File
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Open the XSCT console in your Vitis IDE workspace.

2. Navigate to the ``images/linux`` directory of your PetaLinux project:

   .. code-block::

        $ cd <petalinux-project>/images/linux/

3. Freertos elf file is supported only for QSPI/SD boot images. Copy the `freertos_gpio_test.elf` from ``<design-package>/vck190/freertos/bootimages/freertos_gpio_test.elf`` to the `images/linux` directory.

   .. code-block::
        
        $ cp <design-package>/vck190/ready_to_test/qspi_images/freertos/freertos_gpio_test.elf .

4. Copy the `bootgen.bif` file from ``<design-package>/`` to the ``images/linux`` directory.

   .. code-block::

        $ cp <design-package>/vck190/ready_to_test/qspi_images/linux/bootgen.bif .

5. Run the following command to create `BOOT.BIN`.

   .. code-block::

        $ bootgen -image bootgen.bif -arch versal -o BOOT.BIN -w

   This creates a `BOOT.BIN` image file in the ``<petalinux-project>/images/linux/`` directory.

.. note:: To run the images using SD boot mode, see :ref:`boot-sequence-sd-boot-mode`.


.. |build|  image:: ./media/image29.png

.. |trade|  unicode:: U+02122 .. TRADEMARK SIGN
   :ltrim:
.. |reg|    unicode:: U+000AE .. REGISTERED TRADEMARK SIGN
   :ltrim:


.. Copyright © 2020–2023 Advanced Micro Devices, Inc
.. `Terms and Conditions <https://www.amd.com/en/corporate/copyright>`_.