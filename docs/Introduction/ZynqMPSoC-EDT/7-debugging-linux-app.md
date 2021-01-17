<p align="right">
            Read this page in other languages:<a href="">日本語</a>    <table style="width:100%"><table style="width:100%">
  <tr>

<th width="100%" colspan="6"><img src="https://www.xilinx.com/content/dam/xilinx/imgs/press/media-kits/corporate/xilinx-logo.png" width="30%"/><h1>Zync UltraScale+ MPSoC Embedded Design Tutorial 2020.2 (UG1209)</h1>
</th>

  </tr>

</table>

# Debugging Linux Applications with Vitis Debugger

Vitis Debugger can debug standalone applications and Linux applications. In this chapter, we will introduce how to use it to debug Linux applications.

## Example 9: Debugging Linux Applications with Vitis Debugger

In this example, we will use Vitis Debugger to debug the Linux application we created in the Example 6. 

>***Note*:** If you have not created the hello world application for Linux, please create it with instructions [of the Example 6](./5-build-linux-sw-for-ps.md#example-6-create-linux-images-and-applications-using-petalinux).

### Board Setup

Board setup is the same as the Example 6. It needs these physical connections and setups:

- USB UART connection
- Ethernet cable connection
- Boot mode = SD Boot

