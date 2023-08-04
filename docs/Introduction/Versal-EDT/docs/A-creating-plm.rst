..
   Copyright 2023 Advanced Micro Devices, Inc. All rights reserved. Xilinx, the Xilinx logo, AMD, the AMD Arrow logo, Alveo, Artix, Kintex, Kria, Spartan, Versal, Vitis, Virtex, Vivado, Zynq, and other designated brands included herein are trademarks of Advanced Micro Devices, Inc. Other product names used in this publication are for identification purposes only and may be trademarks of their respective companies.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and
   limitations under the License.


**************************
Appendix: Creating the PLM
**************************

Following are the steps to create a platform loader and manager (PLM) elf file in the AMD Vitis |trade| software platform. In Versal |reg| devices, the PLM executes in the PMC, and is used to bootstrap the APU and RPU.

1. Select **File → New → Application Project**. The New Application Project wizard opens.

2. Use the following information in the table to make your selections in the wizard screens.

   *Table 10:* **System Property Settings**

   +-----------------+-----------------------+---------------------------+
   | Wizard Screen   | System Properties     | Setting or Command to Use |
   +=================+=======================+===========================+
   | Platform        | Create a new platform | Click the **Browse**      |
   |                 | from hardware (XSA)   | button to add your XSA    |
   |                 |                       | file.                     |
   +-----------------+-----------------------+---------------------------+
   |                 | Platform name         | plm_platform              |
   +-----------------+-----------------------+---------------------------+
   | Application     | Application project   | plm                       |
   | Project Details | name                  |                           |
   +-----------------+-----------------------+---------------------------+
   |                 | Select a system       | +Create New               |
   |                 | project               |                           |
   +-----------------+-----------------------+---------------------------+
   |                 | System project name   | plm_system                |
   +-----------------+-----------------------+---------------------------+
   |                 | Target processor      | psv_pmc_0                 |
   +-----------------+-----------------------+---------------------------+
   | Domain          | Select a domain       | +Create New               |
   +-----------------+-----------------------+---------------------------+
   |                 | Name                  | The default name assigned |
   +-----------------+-----------------------+---------------------------+
   |                 | Display Name          | The default name assigned |
   +-----------------+-----------------------+---------------------------+
   |                 | Operating System      | standalone                |
   +-----------------+-----------------------+---------------------------+
   |                 | Processor             | psv_pmc_0                 |
   |                 |                       |                           |
   |                 |                       | .. note::                 |
   |                 |                       |   If the psv_pmc_0 option | 
   |                 |                       |   is not visible under the|
   |                 |                       |   list of processors,     |
   |                 |                       |   check the box next to   |
   |                 |                       |   Show All processors in  |
   |                 |                       |   the hardware            |
   |                 |                       |   specification option to |
   |                 |                       |   view all the available  |
   |                 |                       |   target processors for   |
   |                 |                       |   the application project.|
   +-----------------+-----------------------+---------------------------+
   |                 | Architecture          | 32-bit                    |
   +-----------------+-----------------------+---------------------------+
   | Templates       | Available Templates   | Versal PLM                |
   +-----------------+-----------------------+---------------------------+

The Vitis software platform creates the PLM application project and edt_versal_wrapper platform under the Explorer view. Right-click the platform project and select **Build Project**. After building the platform project, right-click the plm_system project and click on **Build Project**. This generates the `plm.elf` file within the Debug folder of the application project. After building the project, build the platform as well.

.. |trade|  unicode:: U+02122 .. TRADEMARK SIGN
   :ltrim:
.. |reg|    unicode:: U+000AE .. REGISTERED TRADEMARK SIGN
   :ltrim:
 

