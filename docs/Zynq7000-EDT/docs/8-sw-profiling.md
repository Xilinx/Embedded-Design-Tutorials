<p align="right">
            Read this page in other languages:<a href="../docs-jp/8-sw-profiling.md">日本語</a>    <table style="width:100%"><table style="width:100%">
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
      <td width="33%" align="center">8. Software Profiling Using the Vitis Software Platform</td>    
      <td width="33%" align="center"><a href="9-linux-aware-debugging.md">9. Linux Aware Debugging</a></td>    
    </tr>
</table>

- [Software Profiling Using the Vitis Software Platform](#software-profiling-using-the-vitis-software-platform)
  - [Profiling an Application in the Vitis Software Platform with System Debugger](#profiling-an-application-in-the-vitis-software-platform-with-system-debugger)
  - [Additional Design Support Options](#additional-design-support-options)
    - [The System Performance Analysis (SPA) Toolbox](#the-system-performance-analysis-spa-toolbox)

# Software Profiling Using the Vitis Software Platform

In this chapter, you will enable profiling features for the standalone
domain or board support package (BSP) and the application related to
AXI CDMA, which you created in [Linux Booting
and Debug in the Vitis Software Platform](6-linux-booting-debug.md).

## Profiling an Application in the Vitis Software Platform with System Debugger

Profiling is a method by which the software execution time of each
routine is determined. You can use this information to determine
critical pieces of code and optimal code placement in a design.
Routines that are frequently called are best suited for placement in
fast memories, such as cache memory. You can also use profiling
information to determine whether a piece of code can be placed in
hardware, thereby improving overall performance.

You can use the system debugger in the Vitis unified software platform
to profile your application.

1.  Select the application you want to profile.

2.  Right-click the application and select **Debug As → Launch on Hardware (Single Application Debug)**.

If the Confirm Perspective Switch popup window appears, click **Yes**.
The Debug perspective opens.

3.  When the application stops at main, open the TCF Profiler view by
    selecting **Window→ Show view→ Debug→ TCF Profiler**.

    ![](./media/image101.png)

4.  Click the **Start** button to begin
    profiling. Select the **Aggregate Per Function** option in the
    Profiler Configuration dialog box. Adjust the **View update
    interval** according to your required profile sample time. The
    minimum time is 100 ms.

    ![](./media/image102.jpeg)    

5.  Click the **Resume** button to continue running the
    application.

    To view the profile data in the TCF Profiler view (shown in the
    following figure), you must add an exit breakpoint for the application
    to stop.

    ![](./media/image105.jpeg)

## Additional Design Support Options

To assist in your design goals, you might want to learn about the
System Performance Analysis (SPA) toolbox.

### The System Performance Analysis (SPA) Toolbox

To address the need for performance analysis and benchmarking, the
Vitis software platform has a System Performance Analysis (SPA)
toolbox to provide early exploration of hardware and software systems.
You can use this common toolbox for performance validation to ensure
consistent and expected performance throughout the design process.

For more information on exploring and exercising the SPA toolbox using
the Vitis software platform, refer to the following documentation:

-   *Vitis Unified Software Platform Documentation: Embedded Software
    Development*
    ([UG1400](https://www.xilinx.com/cgi-bin/docs/rdoc?v=2020.1%3Bd%3Dug1400-vitis-embedded.pdf))

-   *System Performance Analysis of an SoC*
    ([XAPP1219](https://www.xilinx.com/support/documentation/application_notes/xapp1219-system-performance-modeling.pdf))

    © Copyright 2015–2020 Xilinx, Inc.
