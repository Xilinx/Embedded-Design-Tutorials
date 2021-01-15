<!-- Contents moved from 3-system-configruation.md -->
### Isolation Configuration

 This section is for reference only. It explains the importance of
 Isolation Configuration settings for different use-cases. Different
 use-cases may need to establish Isolation Configurations on a need
 basis. Isolation configuration is optional and you can set it as per
 your system requirement. Safety/Security critical use cases typically
 require isolation between safe/non-safe or secure/ non-secure portions
 of the design. This requires a safe/secure region that contains a
 master (such as the RPU) along with its slaves (memory regions and
 peripherals) to be isolated from non-safe or non-secure portions of
 the design. In such cases, the TrustZone attribute can be applied to
 the dedicated peripherals or memory locations. In this way only a
 valid and trusted master can access the secure slaves. Another
 use-case requiring Isolation is for Platform and Power management. In
 this case, independent subsystems can be created with masters and
 slaves. This is used to
 identify dependencies during run-time power management or warm restart
 for upgrade or recovery. An example of this use-case can be found on
 the [Zynq UltraScale+ Restart solution
 wiki page](httpsisolation://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841820/Zynq%2BUltraScale%2BPlus%2BRestart%2Bsolution).
 The Xilinx Memory Protection Unit (XMPU) and Xilinx Peripheral
 Protection Unit (XPPU) in Zynq UltraScale+ provide hardware protection
 for memory and peripherals. These protection units complement the
 isolation provided by TrustZone and the Zynq UltraScale+ MPSoC SMMU.

 The XMPU and XPPU in Zynq UltraScale+ allow the isolation of resources
 at the SoC level. Arm MMU and TrustZone enable isolation within Arm
 Cortex-A53 core APU. Hypervisor and SMMU allow setting isolation
 between Cortex-A53 cores. From a tools standpoint, these protection
 units can be configured using Isolation Configuration in Zynq
 UltraScale+ PS IP wizard. The isolation settings are exported as an
 initialization file which is loaded as a part of the bootloader,
 which, in this case, is the First Stage Boot Loader (FSBL). For more
 details, see the *Zynq UltraScale Device Technical Reference Manual*
 ([UG1085](https://www.xilinx.com/cgi-bin/docs/ndoc?t=user_guides;d=ug1085-zynq-ultrascale-trm.pdf)).

1. Double-click **Zynq UltraScale+ Processing System** in the block
     diagram window, if it is not open.

2. Select **Switch To Advanced Mode**.

    Notice the protection elements indicated by red blocks in the wizard.

    ![](./media/image16.jpeg)

3. To create an isolation setup, click **Isolation Configuration**.

    This tutorial does not use Isolation Configuration and hence, no
    Isolation related settings are requested.

4. Click **OK** to close the Re-customize IP wizard.

    >***Note*:** For detailed steps to create isolation configuration, see
    *Isolation Methods in Zynq UltraScale+ MPSoC*
    ([XAPP1320](https://www.xilinx.com/support/documentation/application_notes/xapp1320-isolation-methods.pdf)).
