<p align="right">
            Read this page in other languages:<a href="../docs-jp/using-zynq.md">日本語</a>    <table style="width:100%"><table style="width:100%">
  <tr>

<th width="100%" colspan="6"><img src="https://www.xilinx.com/content/dam/xilinx/imgs/press/media-kits/corporate/xilinx-logo.png" width="30%"/><h1>Zynq-7000 SoC Embedded Design Tutorial 2020.2 (UG1165)</h1>
</th>

  </tr>
  <tr>
    <td width="33%" align="center"><a href="../README.md">1. Introduction</a></td>
    <td width="33%" align="center">2. Using the Zynq SoC Processing System</td>
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
      <td width="33%" align="center"><a href="9-linux-aware-debugging.md">9. Linux Aware Debugging</a></td>    
    </tr>
</table>

- [Using the Zynq SoC Processing System](#using-the-zynq-soc-processing-system)
  - [Design Files for this Tutorial](#design-files-for-this-tutorial)
  - [Embedded System Configuration](#embedded-system-configuration)
  - [Example Project: Creating a New Embedded Project with Zynq SoC](#example-project-creating-a-new-embedded-project-with-zynq-soc)
    - [Starting Your Design](#starting-your-design)
    - [Creating an Embedded Processor Project](#creating-an-embedded-processor-project)
    - [Managing the Zynq7 Processing System in Vivado](#managing-the-zynq7-processing-system-in-vivado)
    - [Validating the Design and Connecting Ports](#validating-the-design-and-connecting-ports)
    - [Synthesizing the Design, Running Implementation, and Generating the Bitstream](#synthesizing-the-design-running-implementation-and-generating-the-bitstream)
    - [Exporting a Hardware Platform](#exporting-a-hardware-platform)
      - [What Just Happened?](#what-just-happened)
      - [What's Next?](#whats-next)
    - [Creating a Platform Project in the Vitis Software Platform with an XSA from Vivado](#creating-a-platform-project-in-the-vitis-software-platform-with-an-xsa-from-vivado)
      - [What Just Happened?](#what-just-happened-1)
  - [Example Project: Running the \"Hello World\" Application](#example-project-running-the-hello-world-application)
    - [What Just Happened?](#what-just-happened-2)
  - [Additional Information](#additional-information)
    - [Domain or Board Support Package](#domain-or-board-support-package)
    - [Standalone OS](#standalone-os)

# Using the Zynq SoC Processing System

## Design Files for this Tutorial

The ZIP file associated with this document contains the design files for the tutorial. You can download this file from <a href="https://www.xilinx.com/cgi-bin/docs/ctdoc?cid=584abf8e-7c05-471e-ab16-6135205cfbd9;d=ug1165-zynq-embedded-design-tutorial.zip">this link</a>.

Design files contain the HDF files for each section, and the source code and pre-built images forall the sections.

Now that you have been introduced to the Xilinx&reg; Vivado&reg; Design Suite, you will begin looking at how to use it to develop an embedded system using the Zynq&reg;-7000 SoC processing system (PS).

The Zynq SoC consists of Arm&reg; Cortex&trade;-A9 cores, many hard intellectual property components (IPs), and programmable logic (PL). This offering can be used in two ways:

-   The Zynq SoC PS can be used in a standalone mode, without attaching
    any additional fabric IP.

-   IP cores can be instantiated in fabric and attached to the Zynq PS
    as a PS+PL combination.

## Embedded System Configuration

Creation of a Zynq device system design involves configuring the PS to
select the appropriate boot devices and peripherals. To start with, as
long as the PS peripherals and available MIO connections meet the
design requirements, no bitstream is required. This chapter guides you
through creating a simple PS-based design that does not require a
bitstream.

## Example Project: Creating a New Embedded Project with Zynq SoC

For this example, you will launch the Vivado Design Suite and create a
project with an embedded processor system as the top level.

### Starting Your Design

1.  Start the 2020.1 Vivado Design Suite.

2.  In the Vivado Quick Start page, click **Create Project** to open the New Project wizard.

3.  Use the information in the table below to make selections in each of the wizard screens.

<table>
<thead>
<tr class="header">
<th><blockquote>
<p><strong>Screen</strong></p>
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
<td>Project Name</td>
<td>Project name</td>
<td>edt_tutorial</td>
</tr>
<tr class="even">
<td></td>
<td>Project Location</td>
<td>C:/designs</td>
</tr>
<tr class="odd">
<td></td>
<td>Create Project Subdirectory</td>
<td>Leave this checked</td>
</tr>
<tr class="even">
<td>Project Type</td>
<td>Specify the type of sources for your design. You can start with RTL or a synthesized EDIF.</td>
<td><strong>RTL Project</strong></td>
</tr>
<tr class="odd">
<td></td>
<td><p><strong>Do not specify sources at this time</strong></p>
<p>check box</p></td>
<td>Leave this unchecked.</td>
</tr>
<tr class="even">
<td>Add Sources</td>
<td>Do not make any changes to this page.</td>
<td></td>
</tr>
<tr class="odd">
<td>Add Constraints</td>
<td>Do not make any changes to this page.</td>
<td></td>
</tr>
<tr class="even">
<td>Default Part</td>
<td>Select</td>
<td><strong>Boards</strong></td>
</tr>
<tr class="odd">
<td></td>
<td>Board</td>
<td><strong>ZYNQ-7 ZC702 Evaluation Board</strong></td>
</tr>
<tr class="even">
<td>New Project Summary</td>
<td>Project Summary</td>
<td>Review the project summary.</td>
</tr>
</tbody>
</table>

4.  Click **Finish**. The New Project wizard closes and the project you just created opens in the Vivado design tool.

### Creating an Embedded Processor Project

Perform the following steps to create an embedded processor project.

1. In the Flow Navigator, under **IP Integrator**, click **Create Block Design**.  

  ![](./media/image7.png)

The Create Block Design dialog box opens.

2.  Use the following information to make selections in the Create Block
    Design dialog box.

    <table>
    <thead>
    <tr class="header">
    <th><blockquote>
    <p><strong>Screen</strong></p>
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
    <td>Create Block Design</td>
    <td>Design name</td>
    <td>tutorial_bd</td>
    </tr>
    <tr class="even">
    <td></td>
    <td>Directory</td>
    <td>&lt;Local to Project&gt;</td>
    </tr>
    <tr class="odd">
    <td></td>
    <td>Specify source set</td>
    <td><strong>Design Sources</strong></td>
    </tr>
    </tbody>
    </table>

3.  Click **OK**.

The Diagram window opens with a message that states that this design
is empty. To get started, you will next add some IP from the catalog.

4.  Click the **Add IP** button.

  ![](./media/image8.png)

5.  In the search box, type zynq to find the Zynq device IP options.

6.  Double-click the **ZYNQ7 Processing System** IP to add it to the
    block design.

    ![](./media/image9.png)

The Zynq SoC processing system IP block appears in the Diagram view, as shown in the following figure.

### Managing the Zynq7 Processing System in Vivado

Now that you have added the processor system for the Zynq SoC to the
design, you can begin managing the available options.

1.  Double-click the **ZYNQ7 Processing System** block in the Block
    Diagram window.

    The Re-customize IP dialog box opens, as shown in the following
    figure. Notice that by default, the processor system does not have any
    peripherals connected.

    ![](./media/image10.jpeg)

2.  You will use a preset template created for the ZC702 board. In the
    Re-customize IP dialog box, click the **Presets** button and
    select **ZC702**.

    This enables many peripherals in the processing system with some
    multiplexed I/O (MIO) pins assigned to them as per the board layout of
    the ZC702 board. For example, UART1 is enabled and UART0 is disabled.
    This is because UART1 is connected to the USB-UART connector through
    UART to the USB converter chip on the ZC702 board.

    Note the check marks that appear next to each peripheral name in the
    Zynq device block diagram that signify the I/O peripherals that are
    active.

    ![](./media/image11.png)

3.  In the block diagram, click one of the green I/O Peripherals. The
    MIO Configuration page opens for the selected peripheral.

    ![](./media/image12.jpeg)

4.  Click **OK** to close the Re-customize IP dialog box. Vivado
    implements the changes that you made to apply the ZC702 board
    presets.

    In the Block Diagram window, notice the message stating that Designer assistance is available, as shown in the following figure.

    ![](./media/image13.png)

5.  Click the **Run Block Automation** link. The Run Block Automation
    view opens.

    Note that Cross Trigger In and Cross Trigger Out are disabled. For a
    detailed tutorial with information about cross trigger set-up, refer
    to the *Vivado Design Suite Tutorial: Embedded Processor Hardware Design* ([UG940](https://www.xilinx.com/cgi-bin/docs/rdoc?v=2020.1%3Bd%3Dug940-vivado-tutorial-embedded-design.pdf)).

6.  Click **OK** to accept the default processor system options and make
    default pin connections.

### Validating the Design and Connecting Ports

Now, validate the design.

1.  Right-click in the white space of the Diagram window and select
    **Validate Design**. Alternatively, you can press the F6 key.

2.  A critical error message appears, indicating that the M_AXI_GP0_ACLK
    must be connected.

    ![](./media/image14.jpeg)

3.  Click **OK** to clear the message.

4.  In the Diagram window of the ZYNQ7 Processing System, locate the
    M_AXI_GP0_ACLK port. Hover your mouse over the connector port until the pencil button appears.

5.  Click the **M_AXI_GP0_ACLK** port and drag to the **FCLK_CLK0**
    input port to make a connection between the two ports.

    ![](./media/image15.png)

6.  Validate the design again to ensure there are no other errors. To do
    this, right-click in the white space of the Diagram window and
    select **Validate Design**.

    A dialog box with the following message opens:

    ``Validation successful. There are no errors or critical warnings in this design.``

7.  Click **OK** to close the message.

8.  Click the **Sources** window.

9.  Click **Hierarchy**.

10. Under **Design Sources**, right-click **tutorial_bd** and select
    **Create HDL Wrapper**.

    ![](./media/image16.png)

    The Create HDL Wrapper view opens. You will use this view to create an HDL wrapper file for the processor subsystem.

    **TIP:** *The HDL wrapper is a top-level entity required by the design
    tools.*

11. Select **Let Vivado manage wrapper and auto-update** and click
    **OK**.

12. In the Sources window, under Design Sources, expand
    **tutorial_bd_wrapper**.

13. Right-click the top-level block diagram, titled **tutorial_bd_i :
    tutorial_bd (tutorial_bd.bd)** and select **Generate Output
    Products**.

    The Generate Output Products view opens, as shown in the following figure.

    ![](./media/image17.png)

    If you are running the Vivado Design Suite on a Linux host machine, you might see additional options under Run Settings. In this case, continue with the default settings.

14. Click **Generate**.

    This step builds all required output products for the selected source. For example, constraints do not need to be manually created for the IP processor system. The Vivado tools automatically generate the XDC file for the processor subsystem when **Generate Output Products** is selected.

15. When the Generate Output Products process completes, click **OK**.

16. In the Sources window, click the **IP Sources** view. Here you can
    see the output products that you just generated, as shown in the
    following figure.

    ![](./media/image18.jpeg)

### Synthesizing the Design, Running Implementation, and Generating the Bitstream

1.  You can now synthesize the design.

    ![](./media/image19.jpeg)

    In the Flow Navigator pane, under **Synthesis**, click **Run Synthesis**.

2.  If Vivado prompts you to save your project before launching
    synthesis, click **Save**.

    While synthesis is running, a status circle displays in the upper
    right-hand window. This status circle spools for various reasons
    throughout the design process. The status circle signifies that a
    process is working in the background.

    ![](./media/image20.png)

    When synthesis completes, the Synthesis Completed view opens.

3.  Select **Run Implementation** and click **OK**.

    Again, notice that the status bar describes the process running in the
    background. When implementation completes, the Implementation
    Completed view opens.

4.  Select **Generate Bitstream** and click **OK**.

    When bitstream generation completes, the Bitstream Generation
    Completed view opens.

5.  Click **Cancel** to close the window.

6.  After the bitstream generation completes, export the hardware and
    launch the Vitis unified software platform.

### Exporting a Hardware Platform

1.  From the Vivado main menu, select **File→ Export → Export
    Hardware**. The Export Hardware Platform wizard opens.

2.  Use the information in the following table to make selections in
    each of the wizard screens. Click **Next** wherever necessary.

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
    <td><blockquote>
    <p>Export Hardware Platform</p>
    </blockquote></td>
    <td><blockquote>
    <p>Platform type</p>
    </blockquote></td>
    <td><blockquote>
    <p>Fixed</p>
    </blockquote></td>
    </tr>
    <tr class="even">
    <td><blockquote>
    <p>Output</p>
    </blockquote></td>
    <td></td>
    <td><blockquote>
    <p>Pre-synthesis</p>
    </blockquote></td>
    </tr>
    <tr class="odd">
    <td><blockquote>
    <p>Files</p>
    </blockquote></td>
    <td><blockquote>
    <p>XSA file name</p>
    </blockquote></td>
    <td><blockquote>
    <p>Leave as tutorial_bd_wrapper</p>
    </blockquote></td>
    </tr>
    <tr class="even">
    <td></td>
    <td><blockquote>
    <p>Export to</p>
    </blockquote></td>
    <td><blockquote>
    <p>Leave as C:/designs/ edt_tutorial</p>
    </blockquote></td>
    </tr>
    </tbody>
    </table>

3.  Click **Finish**.

  ![](./media/image22.png)

    **TIP:** *The hardware is exported in a ZIP file (\<project
    wrapper\>.xsa).*

#### What Just Happened?

Vivado has exported the hardware design to the hardware specification
file (XSA).

#### What's Next?

Now you can start developing the software for your project using the
Vitis software platform. The next sections help you create a software
application for your hardware platform.

### Creating a Platform Project in the Vitis Software Platform with an XSA from Vivado

1.  Launch the Vitis IDE by using the desktop shortcut or by
    double-clicking the C:\\Xilinx\\Vitis\\2020.1\\bin\\vitis.bat file. The Eclipse Launcher view opens.

2.  Select the workspace location as C:\\designs\\workspace or any given    location path. The tool creates the workspace folder if it is not already   created.

    ![](./media/image23.png)

3.  Click **Launch**. The Vitis integrated design environment (IDE)
    opens. Click **File → New → Platform Project** to create platform
    project from the output of Vivado Xilinx Shell Archive (XSA).

    ![](./media/image24.jpeg)

4.  When the New Platform Project wizard opens, enter the platform
    project name as hw_platform, as shown in following figure. Click **Next**.

    ![](./media/image25.jpeg)

5.  In the **Platform** page, click the **Create a new platform from hardware (XSA)** page. Under **Hardware Specification**, browse to the hardware specification file and select the XSA file C:\\designs\\edt_tutorial\\tutorial_bd_wrapper.xsa. When the XSA file is selected, the Software Specification fields (Operating system and Processor) are updated to standalone and ps7_cortexa9_0 respectively. Keep the **Generate boot components** option selected, as shown in the following figure. Click **Finish**.

    ![](./media/image26.png)    

6.  The platform project is created. In the **Explorer** view,
    double-click **hw_platform → platform.spr** to view the platform
    view as shown in the following figure.

    ![](./media/image27.jpeg)

7.  In the **Explorer** view, expand **export → hw_platform** to find the
    exported Hardware Specification file, tutorial_bd_wrapper.xsa
    (under the hw folder), and the top-level platform XML file,
    hw_platform.xpfm. Double-click on the XSA file to see the address
    map for the entire processing system, as shown in the following
    figure.

    ![](./media/image28.jpeg)

8.  Build the platform project either by clicking the hammer button or
    by right-clicking on the platform project and selecting **Build
    Project** as shown in following figure.

    ![](./media/image29.png)

9.  As the project builds, you can see the output in the console window. When the build completes, the Build Finished log appears in the Console view as shown in the following figure. The standalone BSP is built and the hw_platform.xpfm file is updated with this build.

    ![](./media/image30.jpeg)   

10. Close the Vitis IDE using the **File → Exit**.

#### What Just Happened?

Using the Vitis IDE, you have created a platform project and exported
the XSA file to the workspace in C:\\designs\\workspace. The export
operation generated a standalone domain with a ps7_cortexa9_0
processor and an FSBL application project. You have built a platform
project, and the generated Xilinx platform definition file
(hw_platform.xpfm) can be used as a platform for the applications that
you create in the Vitis IDE.

## Example Project: Running the \"Hello World\" Application

In this example, you will learn how to manage the board settings, make
cable connections, connect to the board through your PC, and run a
simple \"Hello World\" software application in JTAG mode using System
Debugger in the Vitis IDE.

***Note*:** If you already set up the board, skip to step 5.

1.  Connect the power cable to the board.

2.  Connect a USB Micro cable between the Windows Host machine and the
    Target board with the following SW10 switch settings:

    -   Bit-1 is 0

    -   Bit-2 is 1

***Note*:** 0 = switch is open. 1 = switch is closed.

3.  Connect a USB cable to connector **J17** on the target board with
    the Windows Host machine. This is used for USB to serial transfer.

4.  Power on the ZC702 board using the switch indicated in the figure below.

    ![](./media/image31.png)    

    **IMPORTANT!** *Ensure that jumpers J27 and J28 are placed on the side
    farther from the SD card slot and change the SW16 switch setting as
    shown in the following figure.*

    ![](./media/image32.jpeg)

5.  Open the Vitis software platform and set the workspace path to your
    project file, which in this example is C:\\designs\\workspace.

    Alternatively, you can open the Vitis software platform with a default
    workspace and later switch it to the correct workspace by selecting
    **File→ Switch Workspace** and then selecting the workspace.

6.  Open a serial communication utility
    for the COM port assigned on your system. The Vitis software
    platform provides a serial terminal utility, which will be used
    throughout the tutorial. To open this utility, select **Window →
    Show view**, and in the Show View dialog box, select **Terminal**
    under the Terminal folder and click **Open**.

    ![](./media/image33.png)    

7.  Click the **Launch Terminal** button to open the Launch Terminal view.

    Select **Serial Terminal** for Choose Terminal, add terminal settings,
    and click **OK**. The following figure shows the standard
    configuration for the Zynq SoC processing system.

    ![](./media/image35.png)

8.  Select **File → New → Application Project**.

    The New Application Project wizard opens. Enable the option **Skip
    welcome page next time** and click **Next**.

9.  Use the information in the following table to make your selections
    in the wizard screens.

    <table>
    <thead>
    <tr class="header">
    <th><blockquote>
    <p><strong>Wizard Screen</strong></p>
    </blockquote></th>
    <th><blockquote>
    <p><strong>System Properties</strong></p>
    </blockquote></th>
    <th><blockquote>
    <p><strong>Setting or Command to Use</strong></p>
    </blockquote></th>
    </tr>
    </thead>
    <tbody>
    <tr class="odd">
    <td><blockquote>
    <p>Platform</p>
    </blockquote></td>
    <td><blockquote>
    <p>Select a platform from repository</p>
    </blockquote></td>
    <td><blockquote>
    <p>Click <strong>hw_platform [custom]</strong>. The path should be C:\designs\workspace\hw_platform</p>
    <p>\export\hw_platform\hw_platform.xpfm.</p>
    </blockquote></td>
    </tr>
    <tr class="even">
    <td><blockquote>
    <p>Application Project Details</p>
    </blockquote></td>
    <td><blockquote>
    <p>Application project name</p>
    </blockquote></td>
    <td><blockquote>
    <p>Enter hello_world</p>
    </blockquote></td>
    </tr>
    <tr class="odd">
    <td><blockquote>
    <p>Domain</p>
    </blockquote></td>
    <td><blockquote>
    <p>Select a domain</p>
    </blockquote></td>
    <td><blockquote>
    <p>Click <strong>standalone on ps7_cortex9_0</strong>.</p>
    </blockquote></td>
    </tr>
    <tr class="even">
    <td><blockquote>
    <p>Templates</p>
    </blockquote></td>
    <td><blockquote>
    <p>Available Templates</p>
    </blockquote></td>
    <td><blockquote>
    <p>Hello World</p>
    </blockquote></td>
    </tr>
    </tbody>
    </table>

    The Vitis software platform creates the hello_world application
    project in the Explorer view.

10. Right-click on the **hello_world** standalone application and select
    **Build Project** to generate the hello_world.elf binary file.

11. Right-click **hello_world** and select **Run as → Run
    Configurations**.

12. Right-click **Single Application Debug** and click **New
    Configuration**. The Vitis software platform creates the new run
    configuration, named Debugger_hello_world-Default.

    The configurations associated with the application are pre-populated
    in the Main tab of the Run Configurations dialog box.

13. Click the **Target Setup** page and review the settings. The default
    choice is the Tcl script.

14. Click **Run**.

    \"Hello World\" appears on the serial communication utility in the
    Terminal view, as shown in the following figure.

    ![](./media/image36.jpeg)

    ***Note*:** There was no bitstream download required for the above
    software application to be executed on the Zynq SoC evaluation board.
    The Arm Cortex-A9 dual core is already present on the board. Basic
    initialization of this system to run a simple application is done by
    the device initialization Tcl script.

### What Just Happened?

The application software sent the \"Hello World\" string to the UART1
peripheral of the PS section.

From UART1, the \"Hello World\" string goes byte-by-byte to the serial
terminal application running on the host machine, which displays it as
a string.

## Additional Information

### Domain or Board Support Package

A domain or board support package (BSP) is a collection of software
drivers and, optionally, the operating system on which to build your
application. It is the support code for a given hardware platform or
board that helps in basic initialization at power up and helps
software applications to be run on top of it. You can create multiple
applications to run on the domain. A domain is tied to a single
processor in the platform.

### Standalone OS

Standalone is a simple, low-level software layer. It provides access to basic processor features such as caches, interrupts, and exceptions, as well as the basic processor features of a hosted environment. These basic features include
standard input/output, profiling, abort, and exit. It is a single
threaded semi-hosted environment.

![](./media/image37.png)

**IMPORTANT!** *The application you ran in this chapter was created on
top of the standalone OS. The domain/BSP that your software
application targets is selected during the New Platform Project
creation process.*

© Copyright 2015–2020 Xilinx, Inc.
