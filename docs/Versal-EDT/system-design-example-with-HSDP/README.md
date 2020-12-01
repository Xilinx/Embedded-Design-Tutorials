# System Design Example for SmartLynq+ HSDP

## Introduction
This chapter guides you through building a system based on Versal devices that utilizes the High-Speed Debug Port (HSDP).

## Design Example: Enabling High-Speed Debug Port (HSDP)

### Configuring Hardware

The first step in this design is to enable the HSDP interface.  You can do this using the Vivado IP Integrator.  

1. Open the project you created in Chapter 5.
1. In the Flow Navigator, under **IP Integrator**, click **Open Block Design**.
1. Double-click the Versal ACAP CIPS IP core and click **Debug -> Debug Configuration**.
1. Under **High-Speed Debug Port (HSDP)** select **AURORA** as the **Pathway to/from Debug Packet Controller (DPC)**.  
1. Set the following options:
   - **GT Selection** to **HSDP1 GT**
   - **GT Refclk Selection** to **REFCLK1** 
   - **GT Refclk Freq (MHz)** to **156.25**  
   **Note:** _Line rate will be fixed at **10.0 Gbps**._
1. Click **OK** to save the changes.  Two ports will be created on the CIPS IP `gt_refclk1` and `HSDP1_GT`.  
1. In the **IP Integrator** canvas, right click on `gt_refclk1` and select **Make External**.  Do the same for **HSDP1\_GT**.
1. In the **IP Integrator** canvas, right click on `HSDP1_GT` and select **Make External**. 
1. Click **Validate Design**, then **Save**.
1. In the Flow Navigator, under **Programming and Debug**, click **Generate Device Image** to launch implementation.
1. Once implemenation completes
 





   
