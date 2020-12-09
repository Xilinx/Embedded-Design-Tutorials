<p align="right">
            Read this page in other languages:<a href="../docs-jp/4-debugging-vitis.md">日本語</a>    <table style="width:100%"><table style="width:100%">
  <tr>

<th width="100%" colspan="6"><img src="https://www.xilinx.com/content/dam/xilinx/imgs/press/media-kits/corporate/xilinx-logo.png" width="30%"/><h1>Zynq-7000 SoC Embedded Design Tutorial 2020.2 (UG1165)</h1>
</th>

  </tr>
  <tr>
    <td width="33%" align="center"><a href="../README.md">1. Introduction</a></td>
    <td width="33%" align="center"><a href="2-using-zynq.md">2. Using the Zynq SoC Processing System</a></td>
    <td width="33%" align="center"><a href="3-using-gp-port-zynq.md">3. Using the GP Port in Zynq Devices</a></td>
</tr>
<tr><td width="33%" align="center">4. Debugging with the Vitis Software Platform</td>
    <td width="33%" align="center"><a href="5-using-hp-port.md">5. Using the HP Slave Port with AXI CDMA IP</a></td>
    <td width="33%" align="center"><a href="6-linux-booting-debug.md">6. Linux Booting and Debug in the Vitis Software Platform</a></td>
  </tr>
  <tr>
      <td width="33%" align="center"><a href="7-custom-ip-driver-linux.md">7. Creating Custom IP and Device Driver for Linux
  </a></td>
      <td width="33%" align="center"><a href="8-sw-profiling.md">8. Software Profiling Using the Vitis Software Platform</a></td>    
      <td width="33%" align="center"><a href="9-linux-aware-debugging.md">9. Linux Aware Debugging</a></td>    
    </tr>
</table>

# Debugging with the Vitis Software Platform

This chapter describes debug possibilities with the design flow you
have already been working with. The first option is debugging with
software using the Xilinx&reg; Vitis&trade; unified software platform.

The Vitis software platform debugger provides the following debug
capabilities:

-   Supports debugging of programs on MicroBlaze&trade; and Arm Cortex&trade;-A9
    processor architectures (heterogeneous multi-processor hardware
    system debugging)

-   Supports debugging of programs on hardware boards

-   Supports debugging on remote hardware systems

-   Provides a feature-rich integrated design environment (IDE) to debug
    programs

-   Provides a Tool Command Language (Tcl) interface for running test
    scripts and automation

The Vitis debugger enables you to see what is happening to a program
while it executes. You can set breakpoints or watchpoints to stop the
processor, step through program execution, view the program variables
and stack, and view the contents of the memory in the system.

The Vitis software platform supports debugging through Xilinx System
Debugger and GNU Debugger (GDB).

***Note*:** The GDB flow is deprecated and will not be available for
future devices.

## Xilinx System Debugger

The Xilinx System Debugger uses the Xilinx hw_server as the underlying
debug engine. The Vitis software platform translates each user
interface action into a sequence of Target Communication Framework
(TCF) commands. It then processes the output from System Debugger to
display the current state of the program being debugged. It
communicates to the processor on the hardware using Xilinx hw_server.

The debug workflow is described in the following figure.

![](./media/Drawing1.png)

The workflow is made up of the following components:

-   **Executable ELF File:** To debug your application, you must use an
    Executable and Linkable Format (ELF) file compiled for debugging.
    The debug ELF file contains additional debug information for the
    debugger to make direct associations between the source code and
    the binaries generated from that original source. To manage the
    build configurations, right-click the software application and
    select **Build Configurations → Manage**.

-   **Debug Configuration:** To launch the debug session, you must
    create a debug configuration in the Vitis software platform. This
    configuration captures options required to start a debug session,
    including the executable name, processor target to debug, and
    other information. To create a debug configuration, right-click
    your software application and select **Debug As→ Debug
    Configurations**.

-   **Debug Perspective:** Using the Debug perspective, you can manage
    the debugging or running of a program in the Workbench. You can
    control the execution of your program by setting breakpoints,
    suspending launched programs, stepping through your code, and
    examining the contents of variables. To view the Debug
    perspective, select **Window → Open Perspective → Debug**.

You can repeat the cycle of modifying the code, building the
executable, and debugging the program in the Vitis software platform.

***Note*:** If you edit the source after compiling, the line numbering
will be out of step because the debug information is tied directly to
the source. Similarly, debugging optimized binaries can also cause
unexpected jumps in the execution trace.

## Debugging Software Using the Vitis Software Platform

In this example, you will walk through debugging a Hello World
application.

If you modified the Hello World application in the prior chapter, you
will need to create a new Hello World application prior to debugging.
Follow the steps in [Creating a Platform Project in the Vitis Software Platform with an XSA from Vivado](2-using-zynq.md#creating-a-platform-project-in-the-vitis-software-platform-with-an-xsa-from-vivado) to create a new Hello World application.

After you create the Hello World application, work through below
example to debug the software using the Vitis software platform.

1.  In the C/C++ perspective, right-click the Hello_world project and
    select **Debug As→ Debug Configurations**.

    In Target Setup tab, fill the Hardware Platform field with the one
    exported by the Vivado&reg; Design Suite, and click the **Debug** button.

    The Debug perspective opens.

    ![](./media/image58.jpeg)

    ***Note*:** If the Debug Perspective window does not automatically
    open, select **Window → Open perspective** and select **Debug** in the
    Open Perspective dialog box.

    ![](./media/image59.jpeg)

    ***Note*:** The addresses shown on this page might slightly differ
    from the addresses shown on your system.

    The processor is currently sitting at the beginning of main() with
    program execution suspended at line 0x0010058c. You can confirm this
    information in the Disassembly view, which shows the assembly-level
    program execution also suspended at 0x0010058c.

    ***Note*:** If the Disassembly view is not visible, select **Window →
    Show view**, select **Disassembly** under **Debug**, and click **Open**.

2.  The helloworld.c window also shows execution suspended at the first
    executable line of C code. Select the Registers view to confirm
    that the program counter, pc register, contains 0x0010058c.

    ***Note*:** If the Registers view is not visible, select **Window→
    Show view→ Debug→ Registers**.

3.  Double-click in the margin of the helloworld.c window next to the
    line of code that reads init_platform() and print(). This sets the
    breakpoints at init_platform() and print(). To confirm the
    breakpoints, review the Breakpoints view.

    ***Note*:** If the Breakpoints view is not visible, select **Window→
    Show view→ Debug→ Breakpoints**.

4.  Select **Run → Step Into** to step into the init_platform() routine.

    Program execution suspends at location 0x001005fc. The call stack is
    now two levels deep.

5.  Select **Run → Resume** to continue running the program to the
    breakpoint.

    Program execution stops at the line of code that includes the print
    command. The Disassembly and Debug views both show program execution
    stopped at 0x00100590.

    ***Note*:** The execution address in your debugging window might
    differ if you modified the hello world source code in any way.

6.  Select **Run → Resume** to run the program to conclusion.

    When the program completes, the Terminal view shows the Hello World
    print and the Debug view shows that the program is suspended in a
    routine called exit. This happens when you are running under control
    of the debugger.

7.  Rerun your code several times. Experiment with single-stepping, examining memory, breakpoints, modifying code, and adding print statements. Try adding and moving views.

    ![](./media/image60.png)    

    **TIP:** *You can use Vitis tool debugging shortcuts for step-into
    (F5), step-return (F7), step-over (F6), and resume (F8).*

8.  Exit the Vitis software platform.

© Copyright 2015–2020 Xilinx, Inc.
