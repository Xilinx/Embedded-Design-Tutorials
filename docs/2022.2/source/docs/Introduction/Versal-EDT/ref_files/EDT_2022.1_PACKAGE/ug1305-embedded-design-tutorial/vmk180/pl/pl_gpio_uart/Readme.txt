 *************************************************************************
   ____  ____ 
  /   /\/   / 
 /___/  \  /   
 \   \   \/    © Copyright 2022 Xilinx, Inc. All rights reserved.
  \   \        This file contains confidential and proprietary 
  /   /        information of Xilinx, Inc. and is protected under U.S. 
 /___/   /\    and international copyright and other intellectual 
 \   \  /  \   property laws. 
  \___\/\___\ 
 
*************************************************************************
Hardware project creation and device image generation 
	- Set vivado tool version to 2022.1
	- Open Vivado tool
        - Browse to ug1305-embedded-design-tutorial folder. Go to the vmk180/pl/pl_gpio_uart folder.
	- In the Tcl Console, type the following command
			/> source ./scripts/create_project.tcl
	- Vivado® tool will open the design, loads the block diagram, and adds the required top file and XDC file to the project
	- In the Flow Navigator pane on the left-hand side under Program and Debug, click Generate Device Image.
