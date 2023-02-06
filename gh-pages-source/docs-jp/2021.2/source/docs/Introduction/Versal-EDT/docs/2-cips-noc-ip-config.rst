..
   Copyright 2000-2021 Xilinx, Inc.

   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


****************************************************
Versal ACAP CIPS and NoC (DDR) IP Core Configuration
****************************************************

The Versal |reg| ACAP CIPS IP core allows you to configure the processing system and the PMC block, including boot mode, peripherals, clocks, interfaces, and interrupts, among other things.

This chapter describes how to perform the following tasks:

- Creating a Vivado |reg| project for the Versal ACAP  to select the appropriate boot devices and peripherals by configuring the CIPS IP core.
- Creating and running a Hello World software application on the On-chip-memory (OCM) of Arm |reg| Cortex |trade|-A72.
- Creating and running a Hello World software application on the Tightly-coupled-memory (TCM) of Arm Cortex-R5F.
  
The NoC IP core configures the DDR memory and data path across the DDR memory and processing engines in the system (Scalar Engines, Adaptable Engines, and AI Engines).

- Creating and running a Hello World software application on Arm Cortex-A72 using DDR as memory.
- Creating and running a Hello World software application on Arm Cortex-R5F using DDR as memory.

=============
Prerequisites
=============

To create and run Hello World applications discussed in this chapter, install the Vitis |trade| unified software platform. For installation procedures, see *Vitis Unified Software Platform Documentation: Embedded Software Development* (`UG1400 <https://www.xilinx.com/cgi-bin/docs/rdoc?v=2021.1;d=ug1400-vitis-embedded.pdf>`__).

.. _cips-ip-core-configuration:

==========================
CIPS IP Core Configuration
==========================

Creating a Versal ACAP system design involves configuring the CIPS IP core to select the appropriate boot devices and peripherals. To start with, if the CIPS IP core peripherals and available multiplexed I/O (MIO) connections meet the requirements, no PL component is required. This chapter guides you through creating a simple CIPS IP core-based design.

Creating a New Embedded Project with the Versal ACAP
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For this example, launch the Vivado Design Suite and create a project with an embedded processor system as the top level.

Starting Your Design
--------------------

1. Start the Vivado Design Suite.
2. Optional: This step is required only if you have an ES1 board. In the Tcl Console, type the following command to enable ES1 boards:

   .. code-block::

        enable_beta_device

   Press **Enter**.

   .. note:: You have to add ``enable_beta_device`` in the ``~/.Xilinx/Vivado/Vivado_init.tcl`` (Linux host) too.

3. In the Vivado Quick Start page, click **Create Project** to open the New Project wizard.

4. Use the following information in the table to make selections in each of the wizard screens.

   *Table 1:* **System Property Settings**

   +----------+--------------------------+--------------------------------+
   | Wizard   | System Property          | Setting or Command to Use      |
   | Screen   |                          |                                |
   | System   |                          |                                |
   +==========+==========================+================================+
   | Project  | Project Name             | edt_versal                     |
   | Name     |                          |                                |
   +----------+--------------------------+--------------------------------+
   |          | Project Location         | C:/edt                         |
   +----------+--------------------------+--------------------------------+
   |          | Create Project           | Leave this checked             |
   |          | Subdirectory             |                                |
   +----------+--------------------------+--------------------------------+
   | Project  | Specify the type of      | RTL Project                    |
   | Type     | project to create. You   |                                |
   |          | can start with RTL or a  |                                |
   |          | synthesized EDIF         |                                |
   +----------+--------------------------+--------------------------------+
   |          | Do not specify sources   | Leave this unchecked           |
   |          | at this time check box   |                                |
   +----------+--------------------------+--------------------------------+
   |          | Project is an extensible | Leave this unchecked           |
   |          | Vitis platform checkbox  |                                |
   +----------+--------------------------+--------------------------------+
   | Add      | Do not make any changes  |                                |
   | Sources  | to this screen           |                                |
   +----------+--------------------------+--------------------------------+
   | Add      | Do not make any changes  |                                |
   | Con      | to this screen           |                                |
   | straints |                          |                                |
   +----------+--------------------------+--------------------------------+
   | Default  | Select                   | **Boards**                     |
   | Part     |                          |                                |
   +----------+--------------------------+--------------------------------+
   |          | Display Name             | Versal VMK180/VCK190           |
   |          |                          | Evaluation Platform            |
   +----------+--------------------------+--------------------------------+
   | Project  | Project Summary          | Review the project summary     |
   | Summary  |                          |                                |
   +----------+--------------------------+--------------------------------+

5. Click **Finish**. The New Project wizard closes and the project you just created opens in the Vivado design tool.

   .. note:: Check the version number while choosing a board. For ES1 silicon, the board version is 1.3. For production silicon, the board version is 2.2. Select the version based on the silicon on the board.

Creating an Embedded Processor Project
--------------------------------------

To create an embedded processor project:

1. In the Flow Navigator, under IP integrator, click **Create Block Design**.
   
   .. image:: media/image5.png
   
   The Create Block Design wizard opens.

2. Use the following information to make selections in the Create Block Design wizard.

   +-------------------+---------------------+------------------------+
   | Wizard Screen     | System Property     | Setting or Command to  |
   |                   |                     | Use                    |
   +===================+=====================+========================+
   | Create Block      | Design Name         | edt_versal             |
   | Design            |                     |                        |
   +-------------------+---------------------+------------------------+
   |                   | Directory           | ``<Local to Project>`` |
   +-------------------+---------------------+------------------------+
   |                   | Specify Source Set  | Design Sources         |
   +-------------------+---------------------+------------------------+

3. Click **OK**.

   The diagram window view opens with a message that states that this design is empty. To get started, add an IP from the IP catalog.

4. Click the **Add IP** button |add_ip|.

5. In the search box, type CIPS to find the Control, Interfaces and Processing System.

6. Double-click the **Control, Interface & Processing System IP** to add it to the block design. The CIPS IP core appears in the diagram view, as shown in the following figure:

   .. image:: media/image7.png
      :width: 600

Managing the Versal ACAP CIPS IP Core in the Vivado Design Suite
----------------------------------------------------------------

Now that you have added the processor system for Versal ACAP to the design, you can begin managing the available options.

1. Click **Run Block Automation**.

2. Configure the run block settings as shown in the following figure:

   .. image:: media/run-automation-1.png
      :width: 600

3. Double-click **versal_cips_0** in the Block Diagram window.

4. Ensure that all the settings for **Design Flow** and **Presets** are as shown in the following figure.

   You may have to change the Board Interface from **ps pmc fixed IO** to **Custom**. While doing so, click **Yes** if you get a Apply Preset pop-up.
   
   .. image:: media/4-full-system.png
      :width: 600

5. Click **Next**, then click **PS PMC**.

   .. image:: media/ps-pmc.png
      :width: 600

6. Go to Peripherals and enable the peripherals as shown in figure below:

   .. image:: media/peripherals.png
      :width: 600

7. Click **IO** and set the I/O configurations as shown below:

   .. image:: media/io.png
      :width: 600

   .. note:: VCK190 preset values will set QSPI and SD as the default boot modes. No changes are required.

8. Click **Interrupts** and configure settings as shown in figure below:

   .. image:: media/interrupts.png
      :width: 600

9.  Click **Finish** and **Finish** to close the CIPS GUI.

Validating the Design and Generating the Output
-----------------------------------------------

To validate the design and to generate the output products, follow these steps:

1. Right-click in the white space of the Block Diagram view and select **Validate Design**. Alternatively, you can press the F6 key. A message dialog box opens as shown below.

   Once the validation is complete, A message dialog box opens as shown below:

   .. image:: media/validation_message.PNG

2. Click **Hierarchy**.
   
3. Under Design Sources, right-click **edt_versal** and select **Create HDL Wrapper**.

   The Create HDL Wrapper dialog box opens. Use this dialog box to create an HDL wrapper file for the processor subsystem.

   .. tip:: The HDL wrapper is a top-level entity required by the design tools.

4. Select **Let Vivado manage wrapper and auto-update** and click **OK**.

5. In the Block Design Sources window, under Design Sources, expand   **edt_versal_wrapper**.

6. Right-click the top-level block diagram, titled edt_versal_i: edt_versal (edt_versal.bd) and select **Generate Output Products**.

   The Generate Output Products dialog box opens, as shown in the following figure.

   .. image:: media/image15.png

   .. note:: If you are running the Vivado |reg| Design Suite on a Windows machine, you might see different options under Run Settings. In this case, continue with the default settings.

7. Click **Generate**.

   This step builds all the required output products for the selected source. You do not need to manually create constraints for the IP processor system. The Vivado Design Suite automatically generates the XDC file for the processor subsystem when you select **Generate Output Products**.

8. In the Block Design Sources window, click the **IP Sources** tab. Here you can see the output products that you just generated, as shown in the following figure.

   .. image:: media/image16.png

Synthesizing, Implementing, and Generating the Device Image
-----------------------------------------------------------

Follow these steps to generate a device image for the design.

1. Go to **Flow Navigator→ Program and Debug** and click **Generate Device Image**.

2. A No Implementation Results Available menu appears. Click **Yes**.

3. A Launch Run menu appears. Click **OK**.

   When the Device Image Generation completes, the Device Image Generation Completed dialog box opens.

4. Click **Cancel** to close the window.

5. Export hardware after you generate the Device Image.

.. note:: The following steps are optional and you can skip these and go to the :ref:`exporting-hardware-2` section. These steps provide the detailed flow for generating the device image by running synthesis and implementation before generating the device image. To understand the flow for generating the device image, follow these steps.

   1. Go to **Flow Navigator→ Synthesis**, click **Run Synthesis** and click **OK**.

      .. image:: media/image17.png

   2. If Vivado prompts you to save your project before launching synthesis, click **Save**.

      While synthesis is running, a status bar is displayed in the upper right-hand window. This status bar spools for various reasons throughout the design process. The status bar signifies that a process is working in the background. When synthesis is complete, the Synthesis Completed dialog box opens.

   3. Select **Run Implementation** and click **OK**.

      When implementation completes, the Implementation Completed dialog box opens.

   4. Select **Generate Device Image** and click **OK**.

      The Device Image Generation Completed dialog box opens.

   5. Click **Cancel** to close the window.

      Export the hardware after you generate the device image.

.. _exporting-hardware-2:

Exporting Hardware
------------------

1. From the Vivado toolbar, select **File → Export→ Export Hardware**.

   The Export Hardware dialog box opens.

2. Choose **Include device image** and click **Next**.

3. Provide a name for your exported file (or use the default provided) and choose the location. Click **Next**.

   A warning message appears if a Hardware Module has already been exported. Click **Yes** to overwrite the existing XSA file, if the overwrite message is displayed.

4. Click **Finish**.


.. _running-bare-metal-hello-world-application:

Running a Bare-Metal Hello World Application
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In this example, you will learn how to manage the board settings, make cable connections, connect to the board through your system, and run a Hello World software application from Arm Cortex-A72 on On-chip-memory (OCM) and Arm Cortex- R5F on Tightly-coupled-memory (TCM) on the Vitis software platform.

The following steps demonstrate the procedure to make the required cable connections, connect the board through your system, and launch the Vitis software platform.

1. Connect the power cable to the board.

2. Connect a USB Micro cable between the Windows host machine and USB JTAG connector on the target board. This cable is used for USB to serial transfer.

   .. note:: Ensure that the SW1 switch is set to JTAG boot mode as shown in the following figure.

   .. image:: media/image19.jpeg

3. Power on the VMK180/VCK190 board using the power switch as shown in the following figure.

   .. image:: media/vck190_production_board.jpg

   .. note:: If the Vitis software platform is already running, jump to step 6.

4. Launch the Vitis software platform by selecting **Tools → Launch Vitis IDE from Vivado** and set the workspace path, which in this example is ``c:\edt\edt_vck190``.

   Alternatively, you can open the Vitis software platform with a default workspace and later switch it to the correct workspace by selecting **File → Switch Workspace** and then selecting the workspace.

5. Open a serial communication utility for the COM port assigned to your system. The Vitis software platform provides a serial terminal utility, which is used throughout the tutorial. Select **Window → Show View → Xilinx → Vitis Serial Terminal** to open it.

   .. image:: media/image21.jpeg

6. Click the **Connect to a serial port** button in the Vitis terminal context to set the serial configuration and connect it.

7. Verify the port details in the Windows device manager.

   UART-0 terminal corresponds to Com-Port with Interface-0. For this example, UART-0 terminal is set by default, so for the Com-Port, select the port with interface-0. The following figure shows the standard configuration for the Versal ACAP processing system.

   .. image:: media/image23.png

.. note:: You can use external terminal Serial Port Consoles like Tera Term or Putty. You can find the relevant COM port information from the Device Manager menu in Control Panel.

Creating a Hello World Application for the Arm Cortex-A72 on OCM
----------------------------------------------------------------

The following steps demonstrate the procedure to create a Hello World application from Arm Cortex-A72 on OCM.

1. Select **File→ New → Application Project**. Creating a New Application Project wizard opens. If this is the first time the Vitis IDE has been launched, you can select Create Application Project on the Welcome screen, as shown in the following figure.

   .. note:: Optionally, you can check the box next to "Skip welcome page next time" to skip seeing the welcome page every time.

2. Use the following information to make your selections on the wizard screens.

   *Table 3:* **System Property Settings**

   +----------------+---------------------+-----------------------------------------+
   | Wizard Screen  | System Properties   | Setting or Command to Use               |
   +================+=====================+=========================================+
   | Platform       | Create a new        | Click the Browse button to              |
   |                | platform from       | add your XSA file.                      |
   |                | hardware (XSA)      |                                         |
   +----------------+---------------------+-----------------------------------------+
   |                | Platform Name       | vck190_platform                         |
   +----------------+---------------------+-----------------------------------------+
   | Application    | Application project | helloworld_a72                          |
   | Project        | name                |                                         |
   | Details        |                     |                                         |
   +----------------+---------------------+-----------------------------------------+
   |                | Select a system     | +Create New                             |
   |                | project             |                                         |
   +----------------+---------------------+-----------------------------------------+
   |                | System project name | helloworld_system                       |
   +----------------+---------------------+-----------------------------------------+
   |                | Processor           | versal_cips_0_pspmc_0_psv_cortexa72_0   |
   +----------------+---------------------+-----------------------------------------+
   | Domain         | Select a domain     | +Create New                             |
   +----------------+---------------------+-----------------------------------------+
   |                | Name                | The default name assigned               |
   +----------------+---------------------+-----------------------------------------+
   |                | Display Name        | The default name assigned               |
   +----------------+---------------------+-----------------------------------------+
   |                | Operating System    | Standalone                              |
   +----------------+---------------------+-----------------------------------------+
   |                | Processor           | versal_cips_0_pspmc_0_psv_cortexa72_0   |
   +----------------+---------------------+-----------------------------------------+
   |                | Architecture        | 64-bit                                  |
   +----------------+---------------------+-----------------------------------------+
   | Templates      | Available Templates | Hello World                             |
   +----------------+---------------------+-----------------------------------------+

   The Vitis software platform creates the board support package for the Platform project (vck190_platform) and the system project (helloworld_system) containing an application project named helloworld_a72 under the Explorer view after performing the above steps.

3. Right-click **vck190_platform** and select **Build Project**. Alternatively, you can also click |build|.

   .. note:: If you cannot see the project explorer, click the restore icon |restore| on the left panel, then follow step 3.

Modifying the helloworld_a72 Application Source Code
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Double-click **helloworld_a72**, then double-click **src** and select **helloworld.c**.

   This opens the `helloworld.c` source file for the helloworld_a72 application.

2. Modify the arguments in the print commands:

   .. code-block::

        sleep(1);
        print("Hello World from APU\n\r");
        print("Successfully ran Hello World application from APU\n\r");

   .. image:: media/image28.jpg

3. Click |build| to build the project.

Adding a New RPU Domain to the Platform Project
-----------------------------------------------

The following steps demonstrate the procedure to create a bare-metal Hello World application for the Arm Cortex-R5F on TCM. The application needs to be linked to a domain. Before creating the application project, make sure that the target domain software environment is available. If not, add the required domain to your platform using the following steps.

1. Double-click the `platform.spr` file in the Vitis Explorer view. (In this example, **vck190_platform → platform.spr**).

2. Click the |image30| button in the Main view.

3. Use the following information to make your selections in the Domain wizard screen.

   *Table 4:* **New  Domain Settings**  

   +------------------+------------------+----------------------------------------+
   | Wizard Screen    | Fields           | Setting or Command to Use              |
   +==================+==================+========================================+
   | Domain           | Name             | r5_domain                              |
   +------------------+------------------+----------------------------------------+
   |                  | Display Name     | autogenerated                          |
   +------------------+------------------+----------------------------------------+
   |                  | OS               | standalone                             |
   +------------------+------------------+----------------------------------------+
   |                  | Processor        | versal_cips_0_pspmc_0_psv_cortexr5_0   |
   +------------------+------------------+----------------------------------------+
   |                  | Supported        | C/C++                                  |
   |                  | Runtimes         |                                        |
   +------------------+------------------+----------------------------------------+
   |                  | Architecture     | 32-bit                                 |
   +------------------+------------------+----------------------------------------+

4. Click **OK**. The newly generated r5_domain is configured.

   .. note:: At this point, you will notice an Out-of-date decorator next to the platform in the Explorer view.

5. Click the |build| icon to build the platform. The Explorer view shows the generated image files in the platform project.

Creating the Standalone Application Project for the Arm Cortex-R5F
------------------------------------------------------------------

The following steps demonstrate the procedure to create a Hello World application from Arm Cortex-R5F.

1. Select **File → New → Application Project**. Creating a New Application Project wizard opens. If this is the first time the Vitis IDE has been launched, you can select Create Application Project on the Welcome screen.

   .. note:: Optionally, you can check the box next to "Skip welcome page next time" to skip seeing the welcome page every time.

2. Use the following information to make your selections in the wizard screens.

   *Table 5:* **System Property Settings**

   +----------------------+----------------------+----------------------------------------+
   | Wizard Screen        | System Properties    | Setting or Command to Use              |
   +======================+======================+========================================+
   | Platform             | Select a platform    | Select                                 |
   |                      | from repository      | **vck190_platform**                    |
   +----------------------+----------------------+----------------------------------------+
   | Application Project  | Application project  | helloworld_r5                          |
   | Details              | name                 |                                        |
   +----------------------+----------------------+----------------------------------------+
   |                      | Select a system      | helloworld_system                      |
   |                      | project              |                                        |
   +----------------------+----------------------+----------------------------------------+
   |                      | System project name  | helloworld_system                      |
   +----------------------+----------------------+----------------------------------------+
   |                      | Target processor     | versal_cips_0_pspmc_0_psv_cortexa72_0  |
   +----------------------+----------------------+----------------------------------------+
   | Domain               | Select a domain      | r5_domain                              |
   +----------------------+----------------------+----------------------------------------+
   |                      | Name                 | r5_domain                              |
   +----------------------+----------------------+----------------------------------------+
   |                      | Display Name         | r5_domain                              |
   +----------------------+----------------------+----------------------------------------+
   |                      | Operating System     | standalone                             |
   +----------------------+----------------------+----------------------------------------+
   |                      | Processor            | versal_cips_0_pspmc_0_psv_cortexa72_0  |
   +----------------------+----------------------+----------------------------------------+
   | Templates            | Available Templates  | Hello World                            |
   +----------------------+----------------------+----------------------------------------+

   .. note:: The standalone application helloworld_r5 is generated within the existing system project helloworld_system.

3. Right-click **vck190_platform** and select **Build Project**. Alternatively, you can also click |build| to build the project.

Modifying the helloworld_r5 Application Source Code
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Expand **helloworld_r5** and double-click **src** and select **helloworld.c** to open the `helloworld.c` source file for the helloworld_r5 application.

2. Modify the arguments in the print commands:

   .. code-block::

        print("Hello World from RPU\n\r");
        print("Successfully ran Hello World application from RPU\n\r");

   .. image:: ./media/image31.jpg

3. Click |build| to build the project.

Modifying the Application Linker Script for the Application Project helloworld_r5
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following steps demonstrate the procedure to modify the application linker script for the application project helloworld_r5.

.. note:: The Vitis software platform provides a linker script generator to simplify the task of creating a linker script for GCC. The linker script generator GUI examines the target hardware platform and determines the available memory sections. All you need to do is assign the different code and data sections in the ELF file to different memory regions.

1. Select the application project (helloworld_r5) in the Vitis Explorer view.

   .. note:: The linker will use the DDR memory if it exists on the platform. Otherwise, it will default to the on-chip memory (OCM).

2. In the `src` directory, delete the default ``lscript.ld`` file.

3. Right-click **helloworld_r5** and click **Generate Linker Script**. Alternatively, you can select **Xilinx → Generate Linker Script**.

   .. image:: ./media/image32.png

   .. note:: In the Generate linker script dialog box, the left side is read-only, except for the Output Script name and project build settings in the Modify project build settings as follows field. On the right side, you have two options to allocate memory: The Basic tab and the Advanced tab. Both perform the same tasks; however, the Basic tab is less granular and treats all types of data as "data" and all types of instructions as "code." This is often sufficient to accomplish most tasks. Use the Advanced tab for precise allocation of software blocks into various types of memory.

4. Under the Basic tab, select **versal_cips_0_pspmc_0_psv_r5_0_atcm_MEM_0** in the drop-down menu for all the three sections, then click **Generate**.

   .. image:: ./media/r5_atcm_capture.jpg

   .. note:: A new linker script (``lscript.ld``) will be generated in the src folder within the application project.

5. Right-click **helloworld_system** and select **Build Project** or |build|. This generates the project elf files within the Debug folder of the helloworld_r5 project.

.. _running-applications-in-jtag-mode:

Running Applications in the JTAG Mode using the System Debugger in the Vitis Software Platform
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To run an application, you must create a **Run configuration** that captures the settings for executing the application. You can either create a Run configuration for the whole system project or independent applications.

Creating a Run Configuration for the System Project
---------------------------------------------------

1. Right-click on the system project **helloworld_system** and select **Run As → Run Configurations**. The Run Configuration dialog box opens.

2. Double-click **System Project Debug** to create a Run Configuration.

   The Vitis software platform creates a new run configuration with the name: SystemDebugger_helloworld_system. For the remaining options, refer to the following table.

   *Table 6:* **Create, Manage, and Run Configurations Settings**

   +-----------------------+-----------------------+-----------------------+
   | Wizard Tab            | System Properties     | Setting or Command to |
   |                       |                       | Use                   |
   +=======================+=======================+=======================+
   | Main                  | Project               | helloworld_system     |
   +-----------------------+-----------------------+-----------------------+
   |                       | Target → Hardware     | Attach to the running |
   |                       | Server                | target (local). If    |
   |                       |                       | not already added,    |
   |                       |                       | add using the New     |
   |                       |                       | button.               |
   +-----------------------+-----------------------+-----------------------+

3. Click **Run**.

   .. note:: If there is an existing launch configuration, a dialog box appears asking whether you want to terminate the process. Click **Yes**. The following logs are displayed on the terminal.

   .. code-block::

      [0.015]****************************************
      [0.072]Xilinx Versal Platform Loader and Manager
      [0.130]Release 2021.2   Sep  5 2021  -  16:41:46
      [0.190]Platform Version: v2.0 PMC: v2.0, PS: v2.0
      [0.256]BOOTMODE: 0x0, MULTIBOOT: 0x0
      [0.309]****************************************
      [1.539]Non Secure Boot
      [4.769]PLM Initialization Time
      [4.820]***********Boot PDI Load: Started***********
      [4.882]Loading PDI from SBI
      [4.931]Monolithic/Master Device
      [5.026]0.117 ms: PDI initialization time
      [5.084]+++Loading Image#: 0x1, Name: lpd, Id: 0x04210002
      [5.152]---Loading Partition#: 0x1, Id: 0xC
      [55.043] 49.802 ms for Partition#: 0x1, Size: 2368 Bytes
      [59.918]---Loading Partition#: 0x2, Id: 0xB
      [64.300] 0.510 ms for Partition#: 0x2, Size: 48 Bytes
      [68.461]---Loading Partition#: 0x3, Id: 0xB
      [112.274] 39.941 ms for Partition#: 0x3, Size: 60464 Bytes
      [114.603]---Loading Partition#: 0x4, Id: 0xB
      [118.575] 0.016 ms for Partition#: 0x4, Size: 5968 Bytes
      [123.490]---Loading Partition#: 0x5, Id: 0xB
      [127.450] 0.004 ms for Partition#: 0x5, Size: 80 Bytes
      [132.257]+++Loading Image#: 0x2, Name: pl_cfi, Id: 0x18700000
      [137.586]---Loading Partition#: 0x6, Id: 0x3
      [662.873] 521.328 ms for Partition#: 0x6, Size: 759264 Bytes
      [665.374]---Loading Partition#: 0x7, Id: 0x5
      [957.988] 288.656 ms for Partition#: 0x7, Size: 444000 Bytes
      [960.522]+++Loading Image#: 0x3, Name: fpd, Id: 0x0420C003
      [965.616]---Loading Partition#: 0x8, Id: 0x8
      [969.969] 0.397 ms for Partition#: 0x8, Size: 1040 Bytes
      [974.555]***********Boot PDI Load: Done***********
      [978.973]3504.403 ms: ROM Time
      [981.678]Total PLM Boot Time
      Hello World
      Successfully ran Hello World application from APU
      Hello World
      Successfully ran Hello World application from RPU

Creating a Run Configuration for a Single Application within a System Project
------------------------------------------------------------------------------

You can create a run configuration for a single application within a system project in two ways:

Method I
^^^^^^^^

1. Right-click on the system project **helloworld_system** and select **Run As → Run Configurations**. The Run configuration dialog box opens.

2. Double-click **System Project Debug** to create a run configuration.

   The Vitis software platform creates a new run configuration with the name: SystemDebugger_helloworld_system_1. Rename this to SystemDebugger_helloworld_system_A72. For the remaining options, refer to the following table.

   *Table 7:* **Create, Manage, and Run Configurations Settings**

   +-----------------+-----------------------+---------------------------+
   | Wizard Tab      | System Properties     | Setting or Command to Use |
   +=================+=======================+===========================+
   | Main            | Project               | helloworld_system         |
   +-----------------+-----------------------+---------------------------+
   |                 | Debug only selected   | Check this box            |
   |                 | applications          |                           |
   +-----------------+-----------------------+---------------------------+
   |                 | Selected Applications | Click the **Edit** button |
   |                 |                       | and check helloworld_a72  |
   +-----------------+-----------------------+---------------------------+
   |                 | Target → Hardware     | Attach to the running     |
   |                 | Server                | target (local). If not    |
   |                 |                       | already added, add using  |
   |                 |                       | the New button.           |
   +-----------------+-----------------------+---------------------------+

3. Click **Apply**.

4. Click **Run**.

   .. note:: If there is an existing run configuration, a dialog box appears asking whether you want to terminate the process. Click **Yes**. The following logs are displayed on the terminal.

   .. code-block::

      [0.015]****************************************
      [0.071]Xilinx Versal Platform Loader and Manager
      [0.130]Release 2021.2   Oct 25 2021  -  04:39:13
      [0.189]Platform Version: v2.0 PMC: v2.0, PS: v2.0
      [0.255]BOOTMODE: 0x0, MULTIBOOT: 0x0
      [0.309]****************************************
      [0.517]Non Secure Boot
      [3.731]PLM Initialization Time
      [3.782]***********Boot PDI Load: Started***********
      [3.844]Loading PDI from SBI
      [3.892]Monolithic/Master Device
      [3.987]0.117 ms: PDI initialization time
      [4.046]+++Loading Image#: 0x1, Name: lpd, Id: 0x04210002
      [4.114]---Loading Partition#: 0x1, Id: 0xC
      [53.498] 49.296 ms for Partition#: 0x1, Size: 2384 Bytes
      [58.310]---Loading Partition#: 0x2, Id: 0xB
      [62.645] 0.505 ms for Partition#: 0x2, Size: 48 Bytes
      [66.764]---Loading Partition#: 0x3, Id: 0xB
      [103.214] 32.618 ms for Partition#: 0x3, Size: 61312 Bytes
      [105.518]---Loading Partition#: 0x4, Id: 0xB
      [110.047] 0.613 ms for Partition#: 0x4, Size: 5968 Bytes
      [114.310]---Loading Partition#: 0x5, Id: 0xB
      [118.228] 0.004 ms for Partition#: 0x5, Size: 80 Bytes
      [122.984]+++Loading Image#: 0x2, Name: pl_cfi, Id: 0x18700000
      [128.256]---Loading Partition#: 0x6, Id: 0x3
      [650.405] 518.232 ms for Partition#: 0x6, Size: 759840 Bytes
      [652.881]---Loading Partition#: 0x7, Id: 0x5
      [953.328] 296.531 ms for Partition#: 0x7, Size: 444016 Bytes
      [955.836]+++Loading Image#: 0x3, Name: fpd, Id: 0x0420C003
      [960.876]---Loading Partition#: 0x8, Id: 0x8
      [965.184] 0.393 ms for Partition#: 0x8, Size: 1040 Bytes
      [969.722]***********Boot PDI Load: Done***********
      [974.092]3681.202 ms: ROM Time
      [976.768]Total PLM Boot Time
      Hello World from APU
      Successfully ran Hello World application from APU

.. note:: Both the APU and RPU applications print on the same console as both applications are using UART0 for these applications. The application software sends the hello world strings for both APU and RPU to the UART0 peripheral of the PS section. From UART0, the hello world string goes byte-by-byte to the serial terminal application running on the host machine, which displays it as a string.

Method II
^^^^^^^^^

1. Right-click on the application project hello_world_r5 and select **Run As → Run Configurations**. The Run Configuration dialog box opens.

2. Double-click **Single Project Debug** to create a run configuration.

   The Vitis software platform creates a new run configuration with the name: Debugger_helloworld_r5-Default. For the remaining options, refer to the following table.

   *Table 8:*  **Create, Manage, and Run Configurations Settings**

   +-------------+---------------------+---------------------------------+
   | Wizard Tab  | System Properties   | Setting or Command to Use       |
   +=============+=====================+=================================+
   | Main        | Debug Type          | Standalone Application Debug    |
   +-------------+---------------------+---------------------------------+
   |             | Connection          | Connect to the board. If        |
   |             |                     | connected already, select the   |
   |             |                     | connection here.                |
   +-------------+---------------------+---------------------------------+
   |             | Project             | helloworld_r5                   |
   +-------------+---------------------+---------------------------------+
   |             | Configuration       | Debug                           |
   +-------------+---------------------+---------------------------------+

3. Click **Apply**.

4. Click **Run**.

   .. note:: If there is an existing run configuration, a dialog box appears asking whether you want to terminate the process. Click **Yes**. The following logs are displayed on the terminal.

   .. code-block::

      [0.015]****************************************
      [0.071]Xilinx Versal Platform Loader and Manager
      [0.130]Release 2021.2   Oct 25 2021  -  04:39:13
      [0.189]Platform Version: v2.0 PMC: v2.0, PS: v2.0
      [0.255]BOOTMODE: 0x0, MULTIBOOT: 0x0
      [0.309]****************************************
      [0.517]Non Secure Boot
      [3.731]PLM Initialization Time
      [3.782]***********Boot PDI Load: Started***********
      [3.844]Loading PDI from SBI
      [3.892]Monolithic/Master Device
      [3.987]0.117 ms: PDI initialization time
      [4.046]+++Loading Image#: 0x1, Name: lpd, Id: 0x04210002
      [4.114]---Loading Partition#: 0x1, Id: 0xC
      [53.498] 49.296 ms for Partition#: 0x1, Size: 2384 Bytes
      [58.310]---Loading Partition#: 0x2, Id: 0xB
      [62.645] 0.505 ms for Partition#: 0x2, Size: 48 Bytes
      [66.764]---Loading Partition#: 0x3, Id: 0xB
      [103.214] 32.618 ms for Partition#: 0x3, Size: 61312 Bytes
      [105.518]---Loading Partition#: 0x4, Id: 0xB
      [110.047] 0.613 ms for Partition#: 0x4, Size: 5968 Bytes
      [114.310]---Loading Partition#: 0x5, Id: 0xB
      [118.228] 0.004 ms for Partition#: 0x5, Size: 80 Bytes
      [122.984]+++Loading Image#: 0x2, Name: pl_cfi, Id: 0x18700000
      [128.256]---Loading Partition#: 0x6, Id: 0x3
      [650.405] 518.232 ms for Partition#: 0x6, Size: 759840 Bytes
      [652.881]---Loading Partition#: 0x7, Id: 0x5
      [953.328] 296.531 ms for Partition#: 0x7, Size: 444016 Bytes
      [955.836]+++Loading Image#: 0x3, Name: fpd, Id: 0x0420C003
      [960.876]---Loading Partition#: 0x8, Id: 0x8
      [965.184] 0.393 ms for Partition#: 0x8, Size: 1040 Bytes
      [969.722]***********Boot PDI Load: Done***********
      [974.092]3681.202 ms: ROM Time
      [976.768]Total PLM Boot Time
      Hello World from RPU
      Successfully ran Hello World application from RPU

.. _noc-ip-core-configuration:

===================================
NoC (and DDR) IP Core Configuration
===================================

This section describes the NoC (and DDR) configuration and related connections required for use with the CIPS configured earlier in this chapter. The Versal ACAP CIPS IP core allows you to configure two superscalar, multi-core Arm Cortex-A72 based APUs, two Arm Cortex-R5F RPUs, a platform management controller (PMC), and a CCIX PCIe |reg| module (CPM). The NoC IP core allows configuring the NoC and enabling the DDR memory controllers.

Configuring the NoC IP Core in an Existing Project
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For this example, launch the Vivado Design Suite and the project with basic CIPS configuration as shown in `Creating a New Embedded Project with the Versal ACAP <#creating-a-new-embedded-project-with-the-versal-acap>`__.

Configuring Your Design
-----------------------

To configure your design, follow these steps:

1. Open the design created in `Creating a New Embedded Project with the Versal ACAP <#creating-a-new-embedded-project-with-the-versal-acap>`__, ``edt_versal.xpr``.

2. Open the block design, ``edt_versal.bd``.
   
3. Add **AXI NoC IP** from the IP catalog.

4. Click **Run Block Automation**.

5. Make the run block settings as shown in the following figure:

   .. image:: ./media/block-auto1.png
      :width: 600

6. Open **CIPS → PS-PMC**.
   
7. Click **NoC**. Enable the NoC Coherent Interfaces PS to NoC Interface 0/1 as shown below.

   .. image:: media/noc-interface.png
      :width: 600

8. Double-click the **NoC IP**. From the General Tab, set **Number of AXI Slav interfaces** and **AXI Clocks** to 8:

   .. image:: media/noc-settings.png
      :width: 600

9. From the Inputs tab, configure the following settings for S06 AXI and S07 AXI:

   .. image:: media/noc-axi.png
      :width: 600

10. Configure the following settings from the Connectivity tab:

    .. image:: media/noc-connectivity.png
      :width: 600

11. Click **OK**.

12. Make connections between CIPS and NoC as shown below

    .. image:: media/noc-ip-1.png
       :width: 600

    This adds the AXI NoC IP for DDR access.

    .. image:: media/noc-ip.png
       :width: 600
 
Validating the Design and Generating the Output
-----------------------------------------------

To validate the design and generate the output, follow these steps:

1. Right-click in the white space of the Block Diagram view and select **Validate Design**. Alternatively, you can press the F6 key. A message dialog box opens as shown below.
   
   The Vivado tool will prompt you to map the IPs in the design to an address. Click **Yes**.

   .. image:: media/assign-address.png

   .. note:: The number of address segments may vary depending on the number of memory mapped IPs in the design.

   Once the validation is complete, A message dialog box opens as shown below:

   .. image:: media/validation_message.PNG

2. Click **OK** to close the message.

3. In the Block Design Sources window, under Design Sources, expand **edt_versal_wrapper**.

4. Right-click the top-level block diagram, titled edt_versal_i: edt_versal (``edt_versal.bd``) and select **Generate Output Products**.

   The Generate Output Products dialog box opens, as shown in the following figure.

   .. image:: ./media/image15.png

   .. note:: If you are running the Vivado Design Suite on a Windows machine, you might see different options under Run Settings. In this case, continue with the default settings.

5. Click **Generate**.

   This step builds all required output products for the selected source. You do not need to manually create constraints for the IP processor system. The Vivado Design Suite automatically generates the XDC file for the processor subsystem when you select **Generate Output Products**.

6. When the Generate Output Products process completes, click **OK**. Click the **Design Runs** window on the bottom window to see OOC Module Runs/Synthesis/Implementation runs.

7. In the Sources window, click the **IP Sources** view. Here you can see the output products that you just generated, as shown in the following figure.

   .. image:: ./media/image39.png

Synthesizing, Implementing, and Generating the Device Image
-----------------------------------------------------------

Follow these steps to generate a device image for the design.

1. Go to **Flow Navigator→ Program and Debug** and click **Generate Device Image**.

2. A No Implementation Results Available menu appears. Click **Yes**.

3. A Launch Run menu appears. Click **OK**.

   When the Device Image Generation completes, the Device Image Generation Completed dialog box opens.

4. Click **Cancel** to close the window.

5. Export hardware after you generate the Device Image and click **OK**.
   
.. note:: The following steps are optional and you can skip these and go to the :ref:`exporting-hardware-1` section. These steps provide the detailed flow for generating the device image by running synthesis and implementation before generating device image. To understand the flow for generating the device image, follow the steps provided below.

   1. Go to **Flow Navigator → Synthesis** and click **Run Synthesis**.

      .. image:: media/image17.png

   2. If Vivado prompts you to save your project before launching synthesis, click **Save**.

      While synthesis is running, a status bar is displayed in the upper right-hand window. This status bar spools for various reasons throughout the design process. The status bar signifies that a process is working in the background. When synthesis is complete, the Synthesis Completed dialog box opens.

   3. Select **Run Implementation** and click **OK**.

      When implementation completes, the Implementation Completed dialog box opens.

   4. Select **Generate Device Image** and click **OK**.

      When Device Image Generation completes, the Device Image Generation Completed dialog box opens.

   5.  Click **Cancel** to close the window.

       Export hardware, after you generate Device Image.

.. _exporting-hardware-1: 

Exporting Hardware
------------------

1. From the Vivado main menu, select **File→ Export → Export Hardware**. The Export Hardware dialog box opens.

2. Choose **Include device image** and click **Next**.

3. Provide a name for your exported file (or use the default provided) and choose the location. Click **Next**.

   A warning message appears if a hardware module has already been exported. Click **Yes** to overwrite the existing XSA file, if the overwrite message is displayed.

4. Click **Finish**.

.. _bare-metal-hello-world-on-ddr:

Running a Bare-Metal Hello World Application on DDR Memory
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In this example, you will learn how to manage the board settings, make cable connections, connect to the board through your PC, and run a Hello World software application from Arm Cortex-A72 and Arm Cortex-R5F on DDR memory in the Xilinx Vitis software platform.

You will create a new Vitis project, similar to the one in `Running a Bare-Metal Hello World Application <#running-a-bare-metal-hello-world-application>`__, except that it will use the default linker scripts, which will reference the DDR memory.

1. Manage board settings, make cable connections, and connect to the board through your system and launch the Vitis software platform as discussed in steps 1 through 7 in `Running a Bare-Metal Hello World Application <#running-a-bare-metal-hello-world-application>`__.

   .. note:: 
    
       Create a new Vitis workspace for this. Do not use the workspace created in `Running a Bare-Metal Hello World Application <#running-a-bare-metal-hello-world-application>`__.

2. Create a bare-metal Hello World system project with an application running on Arm Cortex-A72 and modify its source code as discussed in steps 1 through 3 of `Creating a Hello World Application for the Arm Cortex-A72 on OCM <#creating-a-hello-world-application-for-the-arm-cortex-a72-on-ocm>`__ and steps 1 through 3 of `Modifying the helloworld_a72 Application Source Code <#modifying-the-helloworld-a72-application-source-code>`__.

3. Right-click **helloworld_system** and select **Build Project** or click |build| to generate the project elf files within the Debug folder of the application project.
        
4. Create an additional RPU domain for your platform (created in Step 2) as discussed in `Adding a New RPU Domain to the Platform Project <#adding-a-new-rpu-domain-to-the-platform-project>`__.
        
5. Create a bare-metal Hello World application running on Arm Cortex-R5F within the existing system project (Step 2) and modify its source code as discussed in steps 1 through 3 of `Creating the Standalone Application Project for the Arm Cortex-R5F <#creating-the-standalone-application-project-for-the-arm-cortex-r5f>`__ and steps 1 through 3 of `Modifying the helloworld_r5 Application Source Code <#modifying-the-helloworld-r5-application-source-code>`__.

6. Right-click **helloworld_system** and select Build Project or click |build| to generate the project elf files within the Debug folder of the application project.

Refer to `Running Applications in the JTAG Mode using the System Debugger in the Vitis Software Platform <#running-applications-in-the-jtag-mode-using-the-system-debugger-in-the-vitis-software-platform>`__ for running the applications built above in JTAG mode using system debugger in the Vitis software platform and to :ref:`generating-boot-image-for-standalone-application` for generating boot images for standalone applications.

===============
OSPI Boot Mode
===============

.. note:: Skip this section if you do not have the OSPI module, X-EBM-03-revA.

.. important:: OSPI configuration is only supported for VCK190/VMK180 rev B production boards.

To boot check the OSPI boot mode, follow these steps:

1. Open the design created in `Creating a New Embedded Project with the Versal ACAP <#creating-a-new-embedded-project-with-the-versal-acap>`__, ``edt_versal.xpr``.

2. Double-click the **Versal CIPS IP**.

3. Click **Next** and choose **PS PMC**.

4. In the Boot Mode settings, click **OSPI** and check if the configurations are set as shown in the following figure:

   .. image:: ./media/ospi-boot1.png
      :width: 600

5. Click **Finish**.

This configures the design in OSPI boot mode.

================
eMMC Boot Mode
================

.. note:: Skip this section if you do not have the eMMC module, X-EBM-02-revA.

.. important:: eMMC configuration is only supported for VCK190/VMK180 rev B production boards.

To boot check the eMMC boot mode, follow these steps:

1. Open the design created in `Creating a New Embedded Project with the Versal ACAP <#creating-a-new-embedded-project-with-the-versal-acap>`__, ``edt_versal.xpr``.

2. Double-click the **Versal CIPS IP**.

3. Click **Next** and choose **PS PMC**.

4. In the Boot Mode settings, click **SD1/eMMC** and check if the configurations are set as shown in the following figure:

   .. image:: ./media/emmc-sd1.png
      :width: 600
   
5. Click **Finish**.

This configures the design in eMMC boot mode.



.. |trade|  unicode:: U+02122 .. TRADEMARK SIGN
   :ltrim:
.. |reg|    unicode:: U+000AE .. REGISTERED TRADEMARK SIGN
   :ltrim:
.. |add_ip| image:: media/image6.png
.. |restore| image:: media/image27.png
.. |validation_message| image:: ./media/validation_message.PNG
.. |build| image:: ./media/image29.png
.. |image30| image:: ./media/image30.png


