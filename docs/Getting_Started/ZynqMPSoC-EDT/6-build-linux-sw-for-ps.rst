..
==========================================
Building and Debugging Linux Applications
==========================================

The earlier examples highlighted the creation of bootloader images and bare-metal applications for APU, RPU, and PMU using the Vitis |trade| IDE. This chapter demonstrates how to develop Linux applications.

Example 8: Creating Linux Images and Applications using PetaLinux
-------------------------------------------------------------------

In this example, you will configure and build a Linux operating system platform for an Arm |trade| Cortex-A53 core based APU on a Zynq |reg| UltraScale+ |trade| MPSoC. You can configure and build Linux images using the PetaLinux tool flow, along with the board-specific BSP. The Linux application is developed in the Vitis IDE.

Input and Output Files
~~~~~~~~~~~~~~~~~~~~~~

-  Input:

   -  Hardware XSA (`edt_zcu102_wrapper.xsa` generated in Example 1)
   -  `ZCU102 PetaLinux
      BSP <https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-design-tools.html>`_

-  Output:

   -  PetaLinux boot images (`BOOT.BIN`, `image.ub`)
   -  PetaLinux application (hello_linux)

.. important::

   1. This example requires a Linux host machine with PetaLinux installed. Refer to the *PetaLinux Tools Documentation: Reference Guide* (`UG1144 <https://www.xilinx.com/cgi-bin/docs/rdoc?v=latest;d=ug1144-petalinux-tools-reference-guide.pdf>`_) for information about dependencies for PetaLinux.

   2. This example uses the `ZCU102 PetaLinux BSP <https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-design-tools.html>`_ to create a PetaLinux project. Ensure that you have downloaded the ZCU102 BSP for PetaLinux as instructed on the `PetaLinux Tools download page <https://www.xilinx.com/member/forms/download/xef.html?filename=xilinx-zcu102-v2022.2-final.bsp>`_.

.. _creating-a-petalinux-image:

Creating a PetaLinux Image
~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Create a PetaLinux project using the following command:

   .. code:: bash

      petalinux-create -t project -s <path to the xilinx-zcu102-v2024.2-final.bsp>

   .. note:: ``xilinx-zcu102-v2024.2-final.bsp`` is the PetaLinux BSP for the ZCU102 Production Silicon Rev 1.0 Board.

   This creates a PetaLinux project directory, ``xilinx-zcu102-2024.2``.

2. Reconfigure the project with `edt_zcu102_wrapper.xsa`:

   -  The created PetaLinux project uses the default hardware setup in the ZCU102 Linux BSP. In this example, you will reconfigure the
      PetaLinux project based on the Zynq UltraScale+ hardware platform that you configured using the Vivado |reg| Design Suite in :doc:`Zynq
      UltraScale+ MPSoC Processing System Configuration <3-system-configuration>`.
      

   .. note:: There are petalinux flows for both XSA and SDT. BSPs built using the System Device Tree (SDT) flow are recommended for new designs. BSPs listed with 'XSCT' are for the legacy XSA flow for users who are upgrading existing projects and do not wish to change generation methods. In this tutorial we will follow the XSA flow.

   -  Copy the hardware platform `edt_zcu102_wrapper.xsa` to the Linux host machine.

   -  Reconfigure the project using the following command:

      .. code:: bash

         cd xilinx-zcu102-2024.2
         petalinux-config --get-hw-description=<path containing edt_zcu102_wrapper.xsa>

   This command opens the PetaLinux Configuration window. You can review these settings. If required, make changes in the configuration. For this example, the default settings from the BSP are sufficient to generate the required boot images.

   If you would prefer to skip the configuration window and keep the default settings, run the following command:

   .. code:: bash

      petalinux-config --get-hw-description=<path containing edt_zcu102_wrapper.xsa> --silentconfig

   .. note:: The above command will not work with the petalinux SDT flow. For the SDT flow please point the '--get-hw-description' to your SDT directory.

   .. code:: bash

      cd xilinx-zcu102-2024.2
      petalinux-config --get-hw-description=<path to SDT directory>

   `Generate the SDT with the SDT Generator Tool <https://github.com/Xilinx/system-device-tree-xlnx/blob/master/README.md>`_. The System Device Tree Generator (SDTGen) Tool is a package containing TCL scripts and Hardware HSI API's to extract hardware information from the XSA file into a System Device Tree (SDT) format. 

3. Build the PetaLinux project:

   1. In the ``<PetaLinux-project>`` directory, for example, ``xilinx-zcu102-2024.2``, build the Linux images using the
      following command:

      .. code:: bash

         petalinux-build

   2. After the above statement executes successfully, verify the images and the timestamp in the images directory in the PetaLinux project folder using the following commands:

      .. code:: bash

         cd images/linux
         ls -al

4. Generate the boot image using the following command:

   .. code:: bash

      petalinux-package --boot --fsbl zynqmp_fsbl.elf --u-boot

   This creates a ``BOOT.BIN`` image file in the ``<petalinux-project>/images/linux/`` directory.

   The logs indicate that the above command includes PMU_FW and Trusted Firmware-A (TF-A) in ``BOOT.BIN``. You can also add ``--pmufw <PMUFW_ELF>`` and
   ``--atf <ATF_ELF>`` in the above command if you would prefer to use custom firmware images. Refer to ``petalinux-package --boot --help`` for more details about the boot image package command.

   .. note:: 
   
      The option to add bitstream, ``--fpga``, is missing from the above command intentionally because so far the hardware configuration is based only on a PS with no design in the PL. If a bitstream is present in the design, ``--fpga`` can be added in the ``petalinux-package`` command as shown below:

      .. code:: bash

         petalinux-package --boot --fsbl zynqmp_fsbl.elf --fpga system.bit --pmufw pmufw.elf --atf bl31.elf --u-boot u-boot.elf

.. _verifying-the-image-on-the-zcu102-board:

Verifying the Image on the ZCU102 Board
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To verify the image, follow these steps:

1. Copy the ``BOOT.BIN``, ``image.ub``, and ``boot.scr`` files to the SD card. Here, ``boot.scr`` is read by U-Boot to load the kernel and
   rootfs.

2. Load the SD card into the ZCU102 board, in the J100 connector.

3. Connect a micro USB cable from the ZCU102 board USB UART port (J83) to the USB port on the host machine.

4. Configure the board to boot in SD boot mode by setting switch SW6 as shown in the following figure.

   .. image:: ./media/image43.jpeg

5. Connect 12V power to the ZCU102 6-pin Molex connector.

6. Start a serial terminal session using Tera Term or Minicom depending on the host machine being used. set the COM port and baud rate for
   your system as shown in the following figure.

   .. figure:: ./media/image44.png

      Tera Term Connection

7. For port settings, verify the COM port in the device manager and select the COM port with interface-0.

8. Turn on the ZCU102 board using SW1, and wait until Linux loads on the board.

Creating Linux Applications in the Vitis IDE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Create a Linux domain:

   1. Open the vitis-comp.json from settings in the zcu102 platform to open platform configurations.

   2. Click the **+** button to add a domain.

   3. Input the following domain parameters:

      1. Name: linux
      2. OS: linux
      3. Keep the other options as-is and click OK.

   4. Review the Linux domain configuration details.

   5. Build the platform project by clicking the build button under the flow section.

      .. figure:: media/linux_domain_details.png

         Linux domain configuration details

2. Create a Linux application:

   1. Click **File → New Example → Linux Hello World**.
   2. Click **Create Application Component from Template**.
   3. Enter the application project name, linux_hello_world.
   4. Select platform: zcu102_edt. Click Next.
   5. Keep the default domain: linux.
   6. Keep the SYSROOT empty, and click Next then Finish.
   Note

   If you input an extracted SYSROOT directory, Vitis can find include files and libraries in SYSROOT. SYSROOT is generated by the PetaLinux project petalinux-build --sdk. Refer to the PetaLinux Tools Documentation: Reference Guide (UG1144) for more information about SYSROOT generation.

   Note

   If you input a rootfs and kernel image, Vitis can help to generate the SD_card.img when building the Linux system project.

3. Build the hello_linux application.

   1. Select linux_hello_world.
   2. Click the build button under the flow tab to build the application.

.. _preparing-the-linux-agent-for-remote-connection:

Preparing the Linux Agent for Remote Connection
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The Vitis IDE needs a channel to download the application to the running target. When the target runs Linux, it uses TCF Agent running on Linux. TCF Agent is added to the Linux rootfs from the PetaLinux configuration by default. When Linux boots up, it launches TCF Agent automatically. The Vitis IDE talks to TCF Agent on the board using an Ethernet connection.

1. Prepare for running the Linux application on the ZCU102 board. Vitis can download the Linux application to the board, which runs Linux through a network connection. It is important to ensure that the connection between the host machine and the board works well.

   1. Make sure the USB UART cable is still connected with the ZCU102 board. Turn on your serial console and connect to the UART port.
   2. Connect an Ethernet cable between the host and the ZCU102 board.

      - It can be a direct connection from the host to the ZCU102 board.
      - You can also connect the host and the ZCU102 board using a router.

   3. Power on the board and let Linux run on ZCU102 (see :ref:`verifying-the-image-on-the-zcu102-board`).

   4. Set up a networking software environment.

      1. If the host and the board are connected directly, run ``ifconfig end0 192.168.1.1`` to setup an IP address on the board. 
      2. Go to **Control Panel → Network and Internet → Network and Sharing Center**, and click **Change Adapter Settings**. 
      3. Find your Ethernet adapter, then right-click and select **Properties**. 
      4. Double-click **Internet Protocol Version 4 (TCP/IPv4)**, and select **Use the following IP address**. 
      5. Input the IP address **192.168.1.2** and click **OK**.
   
         - If the host and the board are connected through a router, they should be able to get an IP address from the router. If the Ethernet cable is plugged in after the board boots up, you can get the IP address manually by running the ``udhcpc eth0`` command, which returns the board IP address.
         - Have the host and the ZCU102 board ping each other to make sure the network is set up correctly.

2. Set up the Linux agent in the Vitis IDE.

   1. Click **Vitis → Target Connections** icon on the toolbar.

      .. figure:: media/vitis_launch_target_connections.png
         :alt: Vitis Show View search for Target Connections

         Vitis Show View search for Target Connections

   2. In the Target Connections window, double-click **Linux TCF Agent → Linux Agent[default]**.
   3. Input the IP address of your board.
   4. Click **Test Connection**.

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

   1. Select linux_hello_world, and click Open Settings button beside it to open the launch.json file.

   2. Select Application Debug.

   3. Review the configurations:

      1. Target Setup Mode: Application Debug
      2. Target Connection: Linux Agent

   4. Click Run.

      .. figure:: media/vitis_linux_run_configurations.png
         :alt: Vitis Linux Run Configurations

      The console should print **Hello World**.

      .. figure:: media/linux_hello_world.png
         :alt: Linux Hello World run result

2. Disconnect the connection:

   -  Click the **Terminate** button on the toolbar or press **Ctrl+F2**.
   -  Click the **Disconnect** button on the toolbar.

Debugging a Linux Application from the Vitis IDE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Debugging Linux applications requires the Linux agent to be set up properly. Refer to :ref:`preparing-the-linux-agent-for-remote-connection` for detailed steps.

1. Debug the Linux application:

   1. Select **hello_linux**, and click the **Open Settings** button beside it to open the ``launch.json`` file.
   2. Select Application Debug.
   3. Review the configurations:

      1. Target Setup Mode: Application Debug
      2. Target Connection: Linux Agent
       
   4. Click Debug.

   The debug configuration has identical options to the run configuration. The difference between debugging and running is that debugging stops at the main() function.

2. Try the debugging features:

   Hello World is a simple application. It does not contain much to debug, but you can try the following to explore the Vitis debugger:

   -  Review the tabs on the upper right corner: Variables, Breakpoints, Expressions, and the rest.
   -  Review the call stack on the left.
   -  The next line to execute has a green background.
   -  Step over by clicking the icon on the toolbar or pressing **F6** on the keyboard. The printed string will be shown on the Console
      panel.

   .. image:: ./media/vitis_debugger_hello_linux.png

3. Disconnect the connection:

   -  Click the **Terminate button** on the toolbar or press **Ctrl+F2**.
   -  Click the **Disconnect** button on the toolbar.

Summary
-------

In this chapter, you learned how to:

-  Create a Linux boot image with PetaLinux.
-  Create simple Linux applications with the Vitis IDE.
-  Run and debug using the Vitis IDE.

In the :doc:`next chapter <./7-design1-using-gpio-timer-interrupts>`, you will connect all points previously introduced and create a system design.

.. |trade|  unicode:: U+02122 .. TRADEMARK SIGN
   :ltrim:
.. |reg|    unicode:: U+000AE .. REGISTERED TRADEMARK SIGN
   :ltrim:

.. Copyright © 2016–2025 Advanced Micro Devices, Inc
.. `Terms and Conditions <https://www.amd.com/en/corporate/copyright>`_.
