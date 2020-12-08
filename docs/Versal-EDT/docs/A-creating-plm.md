# Appendix: Creating the PLM

Following are the steps to create a platform loader and manager (PLM)
 elf file in the Vitis™ software platform. In Versal™ devices, the PLM
 executes in the PMC, and is used to bootstrap the APU and RPU.

1. Select **File → New → Application Project**. The New Application
     Project wizard opens.

2. Use the following information in the table to make your selections
     in the wizard screens.

    *Table 10:* **System Property Settings**

   |  Wizard Screen       |  System Properties          |  Setting or Command to Use       |
   |----------------------|-----------------------------|----------------------------------|
   | Platform             | Create a new platform from hardware (XSA)          | Click the **Browse** button to add your XSA file. |
   |                      | Platform name               | plm_platform         |
   | Application Project Details  | Application project name | plm             |
   |                      | Select a system project     | +Create New          |
   |                      | System project name         | plm_system           |
   |                      | Target processor     		| psv_pmc_0            |
   | Domain               | Select a domain      		| +Create New          |
   |                      | Name                		| The default name assigned    |
   |                      | Display Name        		| The default name assigned    |
   |                      | Operating System    		| standalone           |
   |                      | Processor            | psv_pmc_0   <br> ***Note:*** If the psv_pmc_0 option is not visible under the list of processors, check the box next to Show all processors in the hardware specification option to view all the available target processors for the application project.       |
   |                      | Architecture        	    | 32-bit               |
   | Templates            | Available Templates 	    | Versal PLM           |

 The Vitis&trade; software platform creates the plm application project and
 edt_versal_wrapper platform under the Explorer view. Right-click the
 platform project and select **Build Project**. After building the
 platform project, right-click the plm_system project and click on
 **Build Project**. This generates the plm.elf file within the Debug
 folder of the application project. After building the project, build
 the platform as well.

 © Copyright 2020 Xilinx, Inc.
