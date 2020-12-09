<p align="right">
            Read this page in other languages:<a href="../docs-jp/8-debugging-problems-with-secure-boot.md">日本語</a>    <table style="width:100%"><table style="width:100%">
  <tr>

<th width="100%" colspan="6"><img src="https://www.xilinx.com/content/dam/xilinx/imgs/press/media-kits/corporate/xilinx-logo.png" width="30%"/><h1>Zync UltraScale+ MPSoC Embedded Design Tutorial 2020.2 (UG1209)</h1>
</th>

  </tr>
  <tr>
    <td width="17%" align="center"><a href="../README.md">1. Introduction</a></td>
    <td width="16%" align="center"><a href="2-getting-started.md">2. Getting Started</a></td>
    <td width="17%" align="center"><a href="3-system-configuration.md">3. Zynq UltraScale+ MPSoC System Configuration</a></td>
    <td width="17%" align="center"><a href="4-build-sw-for-ps-subsystems.md">4. Build Software for PS Subsystems</a></td>
</tr>
<tr>
    <td width="17%" align="center"><a href="5-debugging-with-vitis-debugger.md">5. Debugging with the Vitis Debugger</a></td>
    <td width="16%" align="center"><a href="6-boot-and-configuration.md">6. Boot and Configuration</a></td>
    <td width="17%" align="center"><a href="7-system-design-examples.md">7. System Design Examples</a></td>
    <td width="17%" align="center">8. Debugging Problems with Secure Boot</td>    
  </tr>
</table>

# Debugging Problems with Secure Boot

 This appendix describes how to debug security failures. One procedure
 determines if PUF registration has been run on the device. A second
 procedure checks the value of the Boot Header in the boot image.

## Determine if PUF Registration is Running

 The following steps can be used to verify if the PUF registration
 software has been run on the device:

1. In the Vitis IDE, select **Xilinx → XSCT Console**.

2. Enter the following commands at the prompt:

    ```
    xsct% connect
    xsct% targets
    xsct% targets -set -filter {name =~ "Cortex-A53 #0"}
    xsct% rst -processor
    xsct% mrd -force 0xFFCC1050 (0xFFCC1054)
    ```

3. This location contains the CHASH and AUX values. If non-zero, PUF
     registration software has been run on the device.

## Read the Boot Image

 You can use the Bootgen Utility to verify the header values and the
 partition data used in the Boot Image.

1. Change to the directory containing BOOT.bin.

2. From an XSCT prompt, run the following command.

    `bootgen_utility --bin BOOT.bin --out myfile --arch zynqmp`

3. Look for "BH" in myfile.

© Copyright 2017-2020 Xilinx, Inc.
