<p align="right">
            Read this page in other languages:<a href="../docs-jp/9-linux-aware-debugging.md">日本語</a>    <table style="width:100%"><table style="width:100%">
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
    <td width="33%" align="center"><a href="6-linux-booting-debug.md">6. Linux Booting and Debug in the Vitis Software Platform</a></td>
  </tr>
  <tr>
      <td width="33%" align="center"><a href="7-custom-ip-driver-linux.md">7. Creating Custom IP and Device Driver for Linux
  </a></td>
      <td width="33%" align="center"><a href="8-sw-profiling.md">8. Software Profiling Using the Vitis Software Platform</a></td>    
      <td width="33%" align="center">9. Linux Aware Debugging</td>    
    </tr>
</table>

# Linux OS Aware Debugging Using the Vitis Software Platform

OS-aware debugging helps you to visualize OS-specific information such
as task lists, processes/ threads that are currently running,
process/thread-specific stack trace, registers, and variables view.

To support this, the debugger needs to be aware of the operating
system used on the target and know about the intrinsic nature of the
OS.

With OS-aware debugging, you can debug the OS running on the processor
cores and the processes/threads running on the OS simultaneously.

The Vitis unified software platform supports the OS-aware debug
feature for Linux OS running on Zynq&reg;-7000 SoC devices.

## Setting Up Linux OS Aware Debugging

This section describes setting up OS aware debug for a Zynq board
running Linux OS.

### Configure the Linux Kernel

To be able to read the process list or to allow process or module
debugging, the Linux awareness accesses the internal kernel structures
using the kernel symbols. Therefore the kernel symbols must be
available; otherwise Linux aware debugging is not possible. The
vmlinux file must be compiled with debugging information enabled as
shown in [Configure the Linux Kernel](#configure-the-linux-kernel).

***Note*:** The vmlinux file is a statically linked executable file
that contains the Linux kernel along with corresponding debug
information.

In PetaLinux, enable the below configuration options before compiling
the Linux Kernel using the PetaLinux Tools build configuration
command:

``CONFIG_DEBUG_KERNEL=y``
``CONFIG_DEBUG_INFO=y``

Follow the below steps to configure the Linux kernel to build with the
debug information.

1.  In the Linux machine terminal window, go to the directory of your
    PetaLinux project.

    ``\$ cd \<plnx-proj-root\>``

2.  Launch the configuration menu to configure the Linux kernel.

    ``\$ petalinux-config -c kernel``

3.  Select **Kernel hacking**.

    -   Select Compile-time checks and compiler options.

    -   Select Compile the kernel with debug info.

    ![](./media/image106.png)

4.  Save configuration. This sets the Linux Kernel configuration file
    options to the following settings. You can verify that these
    options are enabled by looking in the configuration file:

5.  Launch the configuration menu to configure the system-level options:

    ``\$ petalinux-config``

    a.  Select **Image Packaging Configuration**.

    b.  Select INITRD for **Root filesystem type**.

    c.  Save configuration.

6.  Build the PetaLinux using the PetaLinux build command
    petalinux-build.

7.  After PetaLinux builds successfully, copy the vmlinux file to your
    host machine. This file is needed for the debugger to refer all
    Linux kernel symbols. Vmlinux generates under \<petalinux project file\>/images/linux/vmlinux.

8.  Copy Vmlinux to the host machine to use with the Vitis software
    platform for debugging the Linux Kernel.

9.  Copy the Linux kernel source code to the host machine for debugging.
    The Linux kernel is present in
    \<petalinux-project\>/build/tmp/work-shared/zc702-zynq7/
    kernel-source.

***Note*:** This document is composed and exercised using the Windows
host machine, so it needs to copy the Linux source code to a location
that is accessible for the Vitis tool running locally on Windows host
machine.

### Creating the Hello World Linux Application to Exercise the OS Aware Debugging Feature

1.  Open the Vitis software platform.

2.  Select **File → New → Application Project**. The New Application
    Project wizard opens.

3.  Use the information below to make your selections in the wizard
    screens.

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
    <td>Enter linux_hello</td>
    </tr>
    <tr class="odd">
    <td></td>
    <td>Select target processor for the Application project</td>
    <td>Select <strong>ps7_cortexa9 SMP</strong>.</td>
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
    <td>Linux Empty Application</td>
    </tr>
    </tbody>
    </table>

4.  Click **Finish**.

5.  In the Explorer view, expand the linux_hello project, right-click
    the src directory, and select **Import** to open the Import view.

6.  Expand **General** in the Import view and select **File System**.

7.  Click **Next**.

8.  Select **Browse**.

9.  Navigate to your design files folder and select the OSA folder and
    click **OK**.

    ***Note*:** For more information about downloading the design files
    for this tutorial, see [Design Files for this Tutorial](2-using-zynq.md#design-files-for-this-tutorial).

10. Add the linux_hello.c file and click **Finish**.

    The Vitis software platform automatically builds the application and
    displays the status in the console window.

11. Copy linux_hello.elf to an SD card.

### Debugging Linux Processes and Threads Using OS Aware Debug

1.  Boot Linux as described in [Booting Linux from the SD
    Card](6-linux-booting-debug.md#booting-linux-from-the-sd-card).

2.  Create a Debug configuration.

3.  Right-click **linux_hello** and select **Debug as→ Debug
    Configurations**.

    The Debug Configurations wizard opens, as shown in the following
    figure.

    ![](./media/image107.jpeg)

4.  In Main window, from the **Debug Type** drop-down list, select
    **Attach to running target**.

5.  From the **Connection** drop-down list, select **Local**.

6.  Click **Debug**.

7.  If the Confirm Perspective Switch dialog box appears, click **Yes**. Debugger_linux_hello-Default opens in the Debug view, as shown in the
following figure.

    ![](./media/image108.png)

8.  Set up the Linux kernel symbol file and enable the Linux OS
    awareness in the debug configuration.

    There are multiple options provided by the Vitis software platform to
    enable Linux OS awareness feature enablement and debugging the
    applications. The following options are listed in the Symbol File
    dialog box.

    -   **Enable Linux OS Awareness:** This option enables the OS awareness.

    -   Auto refresh on exec:

          When this option is selected, all running processes are refreshed and
          displayed in the Debug view.

          When this option is disabled, the new processes are not displayed in
          the Debug view.

    -  Auto refresh on suspend:

          When this option is selected, all processes will be re-synced whenever the processor suspends.

          When this option is disabled, only the current process will be
          re-synced.

9.  In the Debug view, right-click **Debugger_linux_hello-Debug
    (Local)** and select **Edit Debugger_linux_hello-Default
    (Local)**.

10. Click the **Symbol Files** tab.

11. Select **/APU/Arm_Cortex_A9MPCore \#0** from the Debug context
    drop-down menu and click **Add**. The Symbol File dialog box opens.

12. Click the browse button ![](./media/image109.png).

13. Provide the path of the vmlinux file that you saved locally on the
    Windows host machine in the previous section, and check the box
    for **Enable OS awareness- the file is an OS kernel**, **Auto
    refresh on exec**, and **Auto refresh on suspend** as shown in the
    following figure.

    ![](./media/image110.png)

14. Click **OK**.

    The Symbol File window closes.

15. Click **Continue** and then click **Save** for saving the
    configuration changes. The Debug view opens, as shown in the
    following figure.

    ![](./media/image111.png)

    You can see the Linux Kernel and list of processes running on the
    target.

    ***Note*:** Because the Linux Kernel is built on a different system
    (Linux Machine) than the host machine (Windows Machine) on which we
    are exercising the Linux OS aware application debug, symbol files path
    mapping information should be added.

    Path mapping will enable you to get source-level debugging and see
    stack trace, variables, setting up source level breakpoints, and so
    on.

    The debugger uses the Path Map setting to search and load symbols
    files for all executable files and shared libraries in the system.

    ![](./media/image112.jpeg)

16. Set up the Path Map.

    a.  Click the **Path Map** tab.

    b.  Click **Add**.

    c.  The source path for the kernel is the compilation directory path
        from the Linux machine as shown in the previous figure. For
        example, \<petalinux-project\>/build/tmp/
        work-shared/zc702-zynq7/kernel-source.

        The destination path is the host location where you copied kernel in the earlier step. For example, \<local directory\>/linux-xlnx.

    d.  Click **Apply** to apply the changes.

    e.  Click **Continue** to debug.

        ![](./media/image113.jpeg)

17. Debug a Linux Process or thread.

As shown in Debugging Linux Processes and Threads Using OS Aware
Debug](#debugging-linux-processes-and-threads-using-os-aware-debug) ,
the list of processes running on the target is displayed. You can
right-click any process and click **Suspend**. Using this method, you
can exercise debugging features such as watch stack trace, registers,
adding break points, and so on.

In the following figure, the suspended process is named 1 init.

![](./media/image114.jpeg)

***Note*:** The addresses shown on this page might differ slightly
from the addresses shown on your system.

### Debugging the linux_hello Application with OS Aware Debug

1.  Mount an SD card using mount /dev/mmcblk0p1 /mnt.

2.  Run the /mnt/linux_hello.elf application from the terminal as shown in the following figure.

    ![](./media/image115.png)   

3.  To debug the linux_hello application you created in the previous
    section using OS aware debug, follow the steps described in
    [Debugging Linux Processes and Threads Using OS Aware Debug](#debugging-linux-processes-and-threads-using-os-aware-debug), and in addition, add the path mappings for the linux_hello application as given in the following figure.

    The source path is /linux_hello.elf. The destination path is \<vitis-
    workspace\>linux_hello/Debug/linux_hello.elf.

    ![](./media/image116.jpeg)

4.  In the Debug view, right-click on **Debugger_linux_hello-Default
    (Local)** and select **Relaunch**.

5.  In the Vitis debugger, do the following:

    a.  Observe the running application as one of the processes/threads
        in kernel.

    b.  Right-click on the linux_hello.elf thread and click **Suspend**
        to suspend application.

    c.  Add a breakpoint.

These actions are shown in the following figure.

![](./media/image117.jpeg)

When the control hits the breakpoint, the Debug view updates with the
information of the linux_hello.elf process.

The Debug View also shows the file, function, and the line information
of the breakpoint hit. A thread label includes the name of a CPU core,
if the thread is currently running on a core.

You can perform source-level debugging, such as stepping in, stepping
out, watching variables, stack trace, and registers.

You can perform process/thread level debugging, including insert
breakpoints, step in, step out, watch variables, stack trace, and so
on.

***Note*:** One limitation with this process is that the target side
path for a binary file does not include a mount point path. For
example, when the linux_hello process is located on an SD card, which
is mounted at / mnt, the debugger shows the file as /linux_hello.elf
instead of /mnt/linux_hello.elf.

***Note*:** There is an additional way to Enable Linux OS Awareness in
the Vitis software platform using an XSCT command line command. For
information about this command, refer to the osa command help in
[Xilinx Software Command-Line
Tool](https://www.xilinx.com/cgi-bin/docs/rdoc?t=vitis%2Bdoc%3Bv%3D2020.1%3Bd%3Dupu1569395223804.html)
in the Embedded Software Development flow of the *Vitis Unified
Software Platform Documentation* (UG1416).

© Copyright 2015–2020 Xilinx, Inc.
