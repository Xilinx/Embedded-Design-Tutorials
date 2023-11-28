******************************************************************************
#--Copyright (C) 2020 - 2021, Xilinx, Inc. All rights reserved.
#--Copyright (C) 2022 -2023, Advanced Micro Devices, Inc. All rights reserved.
#--SPDX-License-Identifier: MIT
******************************************************************************

Hardware project creation and device image generation 
	- Set vivado tool version to 2022.1
	- Open Vivado tool
        - Browse to ug1305-embedded-design-tutorial folder. Go to the pl folder.Go to pl_gpio_uart folder.
	- In the Tcl Console, type the following command
			/> source ./scripts/create_project.tcl
	- Vivado™ tool will open the design, loads the block diagram, and adds the required top file and XDC file to the project
	- In the Flow Navigator pane on the left-hand side under Program and Debug, click Generate Device Image.
Note: The user needs to download the ES1 board files from web or use the tcl command enable_beta_device after opening vivado to gt ES1 boards.