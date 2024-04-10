============================================================
Building and Debugging Linux Applications for Zynq 7000 SoCs
============================================================

This chapter demonstrates how to develop and debug Linux applications.

-  :ref:`example-4-creating-linux-images` introduces how to create a Linux image with PetaLinux.
-  :ref:`example-5-creating-a-hello-world-application-for-linux-in-the-vitis-ide` creates a Linux application in the Vitis IDE with the Linux image created in Example 4.

.. _example-4-creating-linux-images:

Example 4: Creating Linux Images
--------------------------------

In this example, you will configure and build a Linux operating system platform for an Arm |trade| Cortex-A9 core based APU on a Zynq |trade| 7000 device. You can configure and build Linux images using the PetaLinux tool flow, along with the board-specific BSP. The Linux application is developed in the Vitis IDE.

Input and Output Files
~~~~~~~~~~~~~~~~~~~~~~

-  Input:

   -  Hardware XSA (``system_wrapper.xsa`` generated in :ref:`example-1-creating-a-new-embedded-project-with-zynq-soc`)
   -  `PetaLinux ZC702 BSP <https://www.xilinx.com/member/forms/download/xef.html?filename=xilinx-zc702-v2023.2-final.bsp>`__

-  Output:

   -  PetaLinux boot images (``BOOT.BIN``, ``image.ub``)
   -  PetaLinux application (hello_linux)

.. important::

   1. This example requires a Linux host machine with PetaLinux installed. Refer to the *PetaLinux Tools Documentation: Reference Guide* (`UG1144 <https://www.xilinx.com/cgi-bin/docs/rdoc?v=latest;d=ug1144-petalinux-tools-reference-guide.pdf>`_) for information about dependencies for PetaLinux.

   2. This example uses the `PetaLinux ZC702 BSP <https://www.xilinx.com/member/forms/download/xef.html?filename=xilinx-zc702-v2023.2-final.bsp>`__ to create a PetaLinux project. Ensure that you have downloaded the ZC702 BSP for PetaLinux as instructed on the `PetaLinux Tools download page <https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-design-tools.html>`_.

Creating a PetaLinux Image
~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Create a PetaLinux project using the following command:

   There are two ways to generate a petalinux project. Either using the BSP for a development board such as the ZC702, or if users have a custom board, users can use the template.



   .. code:: bash

      # Using the BSP
      petalinux-create -t project -s <path to the xilinx-zc702-v2023.2-final.bsp>
      # Using the template for custom boards
      petalinux-create -t project --template zynq -n xilinx-zc702-2023.2

   .. note:: **xilinx-zc702-v2023.2-final.bsp** is the PetaLinux BSP for the ZC702 Production Silicon Rev 1.0 board.

   This creates a PetaLinux project directory, **xilinx-zc702-2023.2**.

2. Reconfigure the project with **system_wrapper.xsa**:

   -  The created PetaLinux project uses the default hardware setup in the ZC702 Linux BSP. In this example, you will reconfigure the PetaLinux project based on the Zynq design that you configured using the Vivado |trade| Design Suite in :ref:`example-1-creating-a-new-embedded-project-with-zynq-soc`.

   -  Copy the hardware platform ``system_wrapper.xsa`` to the Linux host machine.

   -  Reconfigure the project using the following command:

      .. code:: bash

         cd xilinx-zc702-2023.2
         petalinux-config --get-hw-description=<path that contains system_wrapper.xsa>

   This command opens the PetaLinux Configuration window. You can review these settings. If required, make changes in the configuration. For this example, the default settings from the BSP are sufficient to generate the required boot images. Select **Exit** and press **Enter** to exit the configuration window.

   If you would prefer to skip the configuration window and keep the default settings, run the following command instead:

   .. code:: bash

      petalinux-config --get-hw-description=<path containing system_wrapper.xsa> --silentconfig

3. Build the PetaLinux project:

   -  In the ``<PetaLinux-project>`` directory (for example, ``xilinx-zc702-2023.2``), build the Linux images using the following command:

      .. code:: bash

         petalinux-build

   -  After the above statement executes successfully, verify the images and the timestamp in the images directory in the PetaLinux project folder using the following commands:

      .. code:: bash

         cd images/linux
         ls -al

   -  ``boot.scr`` is the script that U-Boot reads during boot time to load the kernel and rootfs.
   -  ``image.ub`` contains kernel image, device tree, and rootfs.

4. Generate the boot image using the following command:

   .. code:: bash

      petalinux-package --boot --fsbl zynq_fsbl.elf --u-boot

   This creates a ``BOOT.BIN`` image file in the ``<petalinux-project>/images/linux/`` directory.

   .. note:: The option to add bitstream, ``--fpga``, is missing from the above command intentionally because so far the hardware configuration is based only on a PS with no design in the PL. If a bitstream is present in the design, ``--fpga`` can be added in the ``petalinux-package`` command as shown below:

   .. code:: bash

      petalinux-package --boot --fsbl zynq_fsbl.elf --fpga system.bit --u-boot u-boot.elf

   Refer to ``petalinux-package --boot --help`` for more details about the boot image package command.

5. Generate the sysroot required for generating a linux application using the following command:

   .. code:: bash

      petalinux-build --sdk
      petalinux-package --sysroot

Booting Linux on the ZC702
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can boot on a physical ZC702 board, or if it is not available, use QEMU. Both flows are detailed in the following section.


Boot on Physical ZC702 
~~~~~~~~~~~~~~~~~~~~~~~

You will now boot Linux on the Zynq |trade| 7000 SoC ZC702 target board using the JTAG mode.

.. note:: Additional boot options are explained in :doc:`Linux Booting and Debug in the Software Platform <./7-linux-booting-debug>`.

1. Copy the ``BOOT.BIN``, ``image.ub``, and ``boot.scr`` files to the SD card.

2. Set up the board as described in :ref:`setting-up-the-board`.

3. Change the boot mode to SD boot.

   -  Change **SW16[5:1]** to **01100**

   .. figure:: media/image89.jpeg
      :alt: SD Boot Mode Setup for SW16

      SD Boot Mode Setup for SW16

4. Make sure Ethernet Jumper J30 and J43 are as shown in the following figure.

   .. figure:: ./media/image69.jpeg
      :alt: Ethernet Jumper

      Ethernet Jumper

   Ethernet is optional in this example. It is required in Example 5.

5. Launch the Vitis software platform and open the same workspace you used in :doc:`Using the Zynq SoC Processing System <2-using-zynq>`.

6. If the serial terminal is not open, connect the serial communication utility with the baud rate set to **115200**.

   .. note:: This is the baud rate that the UART is programmed to on Zynq devices.

7. Power on the target board.

8. The Linux login prompt will appear. Use user name ``petalinux`` and create a new password and login.

.. note:: Use ``sudo -i`` to assign privileges.

Boot on QEMU 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1. Change directory to the petalinux project, and use the petalinux-boot command to boot linux on an Emulated system

   .. code:: bash

      petalinux-boot --qemu --kernel --qemu-args "-net nic,netdev=gem0 -netdev user,id=gem0,hostfwd=tcp:127.0.0.1:1540-10.0.2.15:1534 -net nic"

2. Launch the Vitis software platform and open the same workspace you used in :doc:`Using the Zynq SoC Processing System <2-using-zynq>`.

3. The Linux login prompt will appear. Use user name ``petalinux`` and create a new password and login.

.. note:: Use ``sudo -i`` to assign privileges.

.. _example-5-creating-a-hello-world-application-for-linux-in-the-vitis-ide:

Example 5: Creating a Hello World Application for Linux in the Vitis IDE
------------------------------------------------------------------------

In this example, you will use the Vitis IDE to create a Linux application that runs on the embedded Linux environment.

Creating Linux Platform Component
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Initially, create a Linux Platform Component in the Vitis Unified IDE. The Linux Platform Component contains a domain with the information required by the Linux application.

Create a Linux Platform Component using the following steps:

1. Go to **File → New Component → Platform**.

2. Enter the details in the Create Platform Component window.

3. Component Name: **zc702_platform**. Click **Next**.

4. Select the **Hardware Design**, and browse to the XSA file.

5. Select the Operating System: **Linux**. 

6. Select the Processor: **ps7_cortexa9_0**.

7. Enable **Generate Boot artifacts**, click **Next** and **Finish**.

8. Build the platform Component:

   -  Highlight the **zc702_platform** under **Vitis Components** view, and then under **FLOW**, Click the hammer button.


Creating Linux Application Component in the Vitis IDE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Create a Linux application component:

There are two ways to generate the application component in Vitis Unified IDE. Either from the **File → New Component → Application**, or from the **Examples** on the left hand side of the IDE. The following steps describe the generation of application component using **Examples**.

   1. Select the **Linux Hello World** template, click **Create Application Component from Template**.

   2. Give the application a name, **hello_linux**, and click **Next**.

   3. Select the **zc702_platform** generated in the preceding step, and click **Next**.

   4. Choose the default domain generated in the Platform, and click **Next**.

   5. Browse the sysroot generated in the petalinux project. Click on the **update Workspace Preference** checkbox to save the sysroot path for future applications. Click **Next**, and **Finish**.

2. Build the hello_linux application.

   -  Select **hello_linux**.
   -  Click the hammer button to build the application.


.. _preparing-the-linux-agent-for-remote-connection:   

Preparing the Linux Agent for Remote Connection
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The Vitis IDE needs a channel to download the application to the running target for debugging. When the target runs Linux, it uses TCF Agent running on the target. TCF Agent is added to the Linux rootfs from the PetaLinux configuration by default. When Linux boots up, it launches TCF Agent automatically. The Vitis IDE talks to TCF Agent on the board using an Ethernet connection.

Setup the Ethernet Connection between Host and Physical Board
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you are using the QEMU, please skip the following steps.

1. Prepare for running the Linux application on the ZC702 board. Vitis can download the Linux application to the board, which runs Linux through a network connection. It is important to ensure that the connection between the host machine and the board works well.

   -  Make sure the USB UART cable is still connected with the ZC702 board. Turn on your serial console and connect to the UART port.
   -  Connect an Ethernet cable between the host and the ZC702 board.

      -  It can be a direct connection from the host to the ZC702 board.
      -  You can also connect the host and the ZC702 board using a router.

   -  Power on the board and let Linux run on ZC702.
   -  Set up a networking software environment.

      -  If the host and the board are connected directly, run ``ifconfig eth0 192.168.1.1`` to set up an IP address on the board. Go to **Control Panel → Network and Internet → Network and Sharing Center**, and click **Change Adapter Settings**. Find your Ethernet adapter, then right-click and select **Properties**. Double-click **Internet Protocol Version 4 (TCP/IPv4)**, and select **Use the following IP address**. Input the IP address **192.168.1.2**. Click **OK**.
      -  If the host and the board are connected through a router, they should be able to get an IP address from the router. If the Ethernet cable is plugged in after the board boots up, you can get the IP address manually by running the ``udhcpc eth0`` command, which returns the board IP address.
      -  Have the host and the zc702 board ping each other to make sure the network is set up correctly.



2. Set up the Linux agent in the Vitis IDE.

   1. Go to **Vitis → Target Connections**.

   2. In the Target Connections window, right-click **Linux TCF Agent** and select **New Target**.
   
   3. Enter the IP address of your board. The IP address for QEMU is **127.0.0.1**.

   4. Enter the Port number, for QEMU use **1540**. Otherwise, leave as default.
   
   5. Click **Test Connection**.

      .. figure:: media/vitis_target_connection_details.png
         :alt: Vitis test connection details

         Vitis test connection details

      Vitis should return a pop-up confirmation for success.

      .. figure:: media/vitis_test_connection_success.png
         :alt: Vitis test connection success

         Vitis test connection success

Running the Linux Application from the Vitis IDE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Run the Linux application:

   -  Highlight the **linux_hello** application, and under **FLOW**, click **Run** icon. Click **Open Settings** to create a new **Launch Configuration**.
   -  Make sure that the **Target Connection** is set to the target connection created in the previous section.
   -  Set the **Work Directory** to a valid location on your linux filesystem. A typical example is **/home/petalinux**, which is the destination for copying the ELF file.

   .. figure:: media/vitis_linux_run_configurations.png
      :alt: Vitis Linux Run Configurations

   - Click **Run**.

   -  The console should print **Hello World**.

   .. figure:: media/linux_hello_world.png
      :alt: Linux Hello World run result

      Linux Hello World run result

2. Disconnect the connection:

   -  Click the **Stop** button on the Debug toolbar.

Debugging a Linux Application from the Vitis IDE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Debugging Linux applications requires the Linux agent to be set up properly. Refer to :ref:`preparing-the-linux-agent-for-remote-connection` for detailed steps.

1. Debug the Linux application:

   -  Highlight the **linux_hello** application, and under **FLOW**, select **Debug** icon and click **Open Settings**. It creates a new **Launch Configuration**.
   -  Make sure that the **Target Connection** is set to the target connection created in the previous section.
   -  Set the **Work Directory** to a valid location on your linux filesystem. A typical example is **/home/petalinux**, which is the destination for copying the ELF file.

   .. figure:: media/vitis_linux_run_configurations.png
      :alt: Vitis Linux Run Configurations

- Click **Run** icon.

   The debug configuration has identical options to the run configuration. The difference between debugging and running is that debugging stops at the ``main()`` function.

2. Try the debugging features:

   Hello World is a simple application. It does not contain much to debug, but you can try the following to explore the Vitis debugger:

   -  Review the Debug Features on the Left Hand side of the IDE: Variables, Breakpoints, Expressions, and the rest.
   -  If these are not visible, you can add these via **View → Select Feature** 
   -  Review the call stack on the left.
   -  The next line to execute has a green background.
   -  Debug through the code using the debug toolbar, such as **Continue**, **Step Into**, **Step Out**.

   .. figure:: ./media/vitis_debugger_hello_linux_zynq.png
      :alt: Debug window

      Debug window

3. Disconnect the connection:

   -  Click the **Stop** button on the Debug toolbar.

Summary
-------

In this chapter, you learned how to:

-  Create a Linux boot image with PetaLinux.
-  Create simple Linux applications with the Vitis IDE.
-  Run and debug using the Vitis IDE.

Up until now, all your development and debugging activities have been running on the processing system. In the :doc:`next chapter <./5-using-gp-port-zynq>`, you will start to add components to the PL (programmable logic). First, you will see how to use the GP port in Zynq devices.



.. include:: ../docs/substitutions.txt

.. Copyright © 2020–2024 Advanced Micro Devices, Inc

.. `Terms and Conditions <https://www.amd.com/en/corporate/copyright>`_.