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

1. Change to the directory containing `BOOT.bin`.

2. From an XSCT prompt, run the following command.

    ```
	bootgen_utility --bin BOOT.bin --out myfile --arch zynqmp
	```

3. Look for "BH" in myfile.

<aside class="note">
	<p><strong>NOTE!</strong> This appendix describes how to debug security failures. One procedure
 determines if PUF registration has been run on the device. A second
 procedure checks the value of the Boot Header in the boot image.</p>
</div>
