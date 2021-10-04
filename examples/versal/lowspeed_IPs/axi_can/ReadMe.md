# Example Design Template

## Design Summary
This project is a template for creating example design repositories targeting VCK190 ACAP devices.

NOTE: the build instructions are universal if you use this template, so you don't have to edit that section.


## Required Hardware
Here is a list of the required hardware to run the example design:

  1. VCK190 ES1 Eval Board
  1. A host machine that VCK190 is connected to through the cable

## Build Instructions
 ### Vivado:
1. Launch Vivado tool 

1. Select target device as VCK190 ES1 evaluation board and create a project.

1. Enter the Scripts directory. From the tcl console run the following block design tcl script:

		source *bd.tcl

1. The Vivado project will be built.

1. Create your own toplevel hdl(.v/.vhd) wrapper (or) use the one available in Github directory.

 ### PetaLinux:
1. Enter the `hardware` directory and use the XSA to create petalinux workspace. Follow the commands for the following:

   To create Petalinux project, run the following 
	 
		petalinux-create --type project --template versal --name <name_of_project> 
		cd <name_of_project>
	
	 To export XSA and do configuration
	    
		petalinux-config --get-hw-description=<PATH TO XSA>
   
	 To build the PetaLinux project, run the following from the directory:
		
		petalinux-build

1. Once complete, the built images can be found in the plnx/images/linux/ directory. To package these images for SD boot, run the following from the plnx directory:

		petalinux-package --boot 

1. Once packaged, the BOOT.bin and image.ub files (in the plnx/images/linux directory) can be copied to an SD card, and used to boot.

  ### Vitis:
1. To build the Baremetal Example Applications for this project, create a new Vitis workspace in the Software/Vitis directory. Once created, build a new platform project targeting the xsa file from Software/Vitis folder.

1. You can now create a new application project. Select File > New > New Application Project

1. Vitis offers few CAN-based example application projects. These can be selected on the second page of the New Application Project dialogue.

  ## Validation
Here you will place example validation that you've done that the customer can repeat. This improves confidence in the design, and gives a good test for the customer to run initially. Shown below are Linux and Vitis examples:

  ### Linux:

After login to root run the follwoing commands to get bus information

	root@VCK_190_2021_1:~# /sys/class/net/can0/device/driver/
	a4000000.can/   a4010000.can/   a4020000.can/   a4030000.canfd/ a4040000.canfd/ a4050000.canfd/ ff060000.can/   ff070000.can/
	root@VCK_190_2021_1:~# ifconfig -a | grep can
        can0 Link encap:UNSPEC HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  → a4010000.can/   ==> AXI-CAN0
        can1 Link encap:UNSPEC HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  → a4020000.can/   ==> AXI-CAN1
        can2 Link encap:UNSPEC HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  → a4030000.can/   ==> AXI-CAN2

 #### AXI-CAN LOOP BACK

a. TX and RX of the AXI CAN IP are shorted to prove the loopback externally user can enable loopback mode also through the register to prove loopback mode.

 Log:
	
	
	root@VCK_190_2021_1:~# ip -d -s link show can0
	2: can0: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT group default qlen 10
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can state STOPPED (berr-counter tx 0 rx 0) restart-ms 0
		  xilinx_can: tseg1 1..16 tseg2 1..8 sjw 1..4 brp 1..256 brp-inc 1
		  clock 24000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    0          0        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    0          0        0       0       0       0
	root@VCK_190_2021_1:~# ip link set can0 type can bitrate 100000
	root@VCK_190_2021_1:~# ifconfig can0 txqueuelen 1000
	root@VCK_190_2021_1:~# ip link set can0 type can bitrate 100000 loopback on
	root@VCK_190_2021_1:~# ip link set can0 up
	[   65.941657] IPv6: ADDRCONF(NETDEV_CHANGE): can0: link becomes ready
	root@VCK_190_2021_1:~# ip -d -s link show can0
	2: can0: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <LOOPBACK> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 100000 sample-point 0.875
		  tq 625 prop-seg 6 phase-seg1 7 phase-seg2 2 sjw 1
		  xilinx_can: tseg1 1..16 tseg2 1..8 sjw 1..4 brp 1..256 brp-inc 1
		  clock 24000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    0          0        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    0          0        0       0       0       0
	root@VCK_190_2021_1:~# cansend can0 123#1122334455667788
	root@VCK_190_2021_1:~# ip -d -s link show can0
	2: can0: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <LOOPBACK> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 100000 sample-point 0.875
		  tq 625 prop-seg 6 phase-seg1 7 phase-seg2 2 sjw 1
		  xilinx_can: tseg1 1..16 tseg2 1..8 sjw 1..4 brp 1..256 brp-inc 1
		  clock 24000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    8          1        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    8          1        0       0       0       0
	root@VCK_190_2021_1:~# cansend can0 111#112233445566
	root@VCK_190_2021_1:~# ip -d -s link show can0
	2: can0: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <LOOPBACK> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 100000 sample-point 0.875
		  tq 625 prop-seg 6 phase-seg1 7 phase-seg2 2 sjw 1
		  xilinx_can: tseg1 1..16 tseg2 1..8 sjw 1..4 brp 1..256 brp-inc 1
		  clock 24000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    14         2        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    14         2        0       0       0       0
	root@VCK_190_2021_1:~# ip link set can0 down
	root@VCK_190_2021_1:~# ip link set can0 type can bitrate 5000000 loopback on
	[  121.573633] xilinx_can a4000000.can can0: bitrate error 4.0%
	root@VCK_190_2021_1:~# ip link set can0 up
	root@VCK_190_2021_1:~# ip -d -s link show can0
	2: can0: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <LOOPBACK> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 4800000 sample-point 0.600
		  tq 41 prop-seg 1 phase-seg1 1 phase-seg2 2 sjw 1
		  xilinx_can: tseg1 1..16 tseg2 1..8 sjw 1..4 brp 1..256 brp-inc 1
		  clock 24000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    14         2        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    14         2        0       0       0       0
	root@VCK_190_2021_1:~# cansend can0 222#1122334455
	root@VCK_190_2021_1:~# ip -d -s link show can0
	2: can0: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <LOOPBACK> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 4800000 sample-point 0.600
		  tq 41 prop-seg 1 phase-seg1 1 phase-seg2 2 sjw 1
		  xilinx_can: tseg1 1..16 tseg2 1..8 sjw 1..4 brp 1..256 brp-inc 1
		  clock 24000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    19         3        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    19         3        0       0       0       0
	root@VCK_190_2021_1:~# cansend can0 333#112233
	root@VCK_190_2021_1:~# ip -d -s link show can0
	2: can0: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <LOOPBACK> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 4800000 sample-point 0.600
		  tq 41 prop-seg 1 phase-seg1 1 phase-seg2 2 sjw 1
		  xilinx_can: tseg1 1..16 tseg2 1..8 sjw 1..4 brp 1..256 brp-inc 1
		  clock 24000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    22         4        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    22         4        0       0       0       0
	root@VCK_190_2021_1:~#

	
	
#### AXI-CAN NORMAL MODE 
 a. AXI-CAN_1 and AXI_CAN_2 are connect to node to node to form the bus to prove the communication b/w the nodes in normal mode.

 Log:

	root@VCK_190_2021_1:~# ip -d -s link show can1
	3: can1: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT group default qlen 10
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can state STOPPED (berr-counter tx 0 rx 0) restart-ms 0
		  xilinx_can: tseg1 1..16 tseg2 1..8 sjw 1..4 brp 1..256 brp-inc 1
		  clock 24000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    0          0        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    0          0        0       0       0       0
	root@VCK_190_2021_1:~# ip -d -s link show can2
	4: can2: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT group default qlen 10
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can state STOPPED (berr-counter tx 0 rx 0) restart-ms 0
		  xilinx_can: tseg1 1..16 tseg2 1..8 sjw 1..4 brp 1..256 brp-inc 1
		  clock 24000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    0          0        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    0          0        0       0       0       0
	root@VCK_190_2021_1:~# ip link set can1 type can bitrate 1000000
	root@VCK_190_2021_1:~# ip link set can2 type can bitrate 1000000
	root@VCK_190_2021_1:~# ifconfig can1 txqueuelen 1000
	root@VCK_190_2021_1:~# ifconfig can2 txqueuelen 1000
	root@VCK_190_2021_1:~# ip link set can1 up
	[  453.201673] IPv6: ADDRCONF(NETDEV_CHANGE): can1: link becomes ready
	root@VCK_190_2021_1:~# ip link set can2 up
	[  458.401603] IPv6: ADDRCONF(NETDEV_CHANGE): can2: link becomes ready
	root@VCK_190_2021_1:~# ip -d -s link show can1
	3: can1: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 1000000 sample-point 0.750
		  tq 83 prop-seg 4 phase-seg1 4 phase-seg2 3 sjw 1
		  xilinx_can: tseg1 1..16 tseg2 1..8 sjw 1..4 brp 1..256 brp-inc 1
		  clock 24000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    0          0        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    0          0        0       0       0       0
	root@VCK_190_2021_1:~# ip -d -s link show can2
	4: can2: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 1000000 sample-point 0.750
		  tq 83 prop-seg 4 phase-seg1 4 phase-seg2 3 sjw 1
		  xilinx_can: tseg1 1..16 tseg2 1..8 sjw 1..4 brp 1..256 brp-inc 1
		  clock 24000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    0          0        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    0          0        0       0       0       0
	root@VCK_190_2021_1:~# cansend can1 333#112233
	root@VCK_190_2021_1:~# cansend can2 222#112233445566
	root@VCK_190_2021_1:~# ip -d -s link show can1
	3: can1: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 1000000 sample-point 0.750
		  tq 83 prop-seg 4 phase-seg1 4 phase-seg2 3 sjw 1
		  xilinx_can: tseg1 1..16 tseg2 1..8 sjw 1..4 brp 1..256 brp-inc 1
		  clock 24000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    6          1        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    3          1        0       0       0       0
	root@VCK_190_2021_1:~# ip -d -s link show can2
	4: can2: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 1000000 sample-point 0.750
		  tq 83 prop-seg 4 phase-seg1 4 phase-seg2 3 sjw 1
		  xilinx_can: tseg1 1..16 tseg2 1..8 sjw 1..4 brp 1..256 brp-inc 1
		  clock 24000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    3          1        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    6          1        0       0       0       0
	root@VCK_190_2021_1:~# cansend can1 444#AABB
	root@VCK_190_2021_1:~# cansend can2 199#AABBCC
	root@VCK_190_2021_1:~# ip -d -s link show can1
	3: can1: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 1000000 sample-point 0.750
		  tq 83 prop-seg 4 phase-seg1 4 phase-seg2 3 sjw 1
		  xilinx_can: tseg1 1..16 tseg2 1..8 sjw 1..4 brp 1..256 brp-inc 1
		  clock 24000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    9          2        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    5          2        0       0       0       0
	root@VCK_190_2021_1:~# ip -d -s link show can2
	4: can2: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 1000000 sample-point 0.750
		  tq 83 prop-seg 4 phase-seg1 4 phase-seg2 3 sjw 1
		  xilinx_can: tseg1 1..16 tseg2 1..8 sjw 1..4 brp 1..256 brp-inc 1
		  clock 24000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    5          2        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    9          2        0       0       0       0
	root@VCK_190_2021_1:~#

### Vitis:

#### AXI-CAN polled mode example

a. Loop back mode
Test case to prove loopback mode of AXI-CAN IP(CAN0 is used for testing)

Log:

	[0.010]PMC_GLOBAL_PMC_ERR1_STATUS: 0x0F000000
	[0.081]PMC_GLOBAL_PMC_ERR2_STATUS: 0x01800000
	[4.180]PLM Initialization Time
	[4.243]***********Boot PDI Load: Started***********
	[4.321]Loading PDI from JTAG
	[4.382]Monolithic/Master Device
	[4.500]0.146 ms: PDI initialization time
	[4.573]+++Loading Image#: 0x1, Name: lpd, Id: 0x04210002
	[4.659]---Loading Partition#: 0x1, Id: 0xC
	[36.008]****************************************
	[40.253]Xilinx Versal Platform Loader and Manager
	[44.667]Release 2021.1   Jul 26 2021  -  04:09:34
	[48.995]Platform Version: v2.0 PMC: v2.0, PS: v2.0
	[53.409]BOOTMODE: 0x0, MULTIBOOT: 0x0
	[56.719]****************************************
	[61.004] 56.236 ms for Partition#: 0x1, Size: 2512 Bytes
	[65.887]---Loading Partition#: 0x2, Id: 0xB
	[70.256] 0.517 ms for Partition#: 0x2, Size: 48 Bytes
	[74.373]---Loading Partition#: 0x3, Id: 0xB
	[115.861] 37.633 ms for Partition#: 0x3, Size: 60592 Bytes
	[118.184]---Loading Partition#: 0x4, Id: 0xB
	[122.141] 0.019 ms for Partition#: 0x4, Size: 5968 Bytes
	[127.017]---Loading Partition#: 0x5, Id: 0xB
	[130.963] 0.007 ms for Partition#: 0x5, Size: 80 Bytes
	[135.742]+++Loading Image#: 0x2, Name: pl_cfi, Id: 0x18700000
	[141.029]---Loading Partition#: 0x6, Id: 0x3
	[1002.963] 857.991 ms for Partition#: 0x6, Size: 1272512 Bytes
	[1005.627]---Loading Partition#: 0x7, Id: 0x5
	[1292.411] 282.759 ms for Partition#: 0x7, Size: 441248 Bytes
	[1295.030]+++Loading Image#: 0x3, Name: fpd, Id: 0x0420C003
	[1300.169]---Loading Partition#: 0x8, Id: 0x8
	[1304.622] 0.429 ms for Partition#: 0x8, Size: 1104 Bytes
	[1309.236]***********Boot PDI Load: Done***********
	[1313.705]3768.637 ms: ROM Time
	[1316.468]Total PLM Boot Time
	Successfully ran Can polled Example


b. Normal mode
Test case to prove normal mode of AXI CAN IP with external loopback(CAN1 and CAN2 are connected to form CAN bus for testing)

 Log:

	[0.010]PMC_GLOBAL_PMC_ERR1_STATUS: 0x0F000000
	[0.081]PMC_GLOBAL_PMC_ERR2_STATUS: 0x01800000
	[4.180]PLM Initialization Time
	[4.243]***********Boot PDI Load: Started***********
	[4.320]Loading PDI from JTAG
	[4.381]Monolithic/Master Device
	[4.499]0.146 ms: PDI initialization time
	[4.573]+++Loading Image#: 0x1, Name: lpd, Id: 0x04210002
	[4.658]---Loading Partition#: 0x1, Id: 0xC
	[36.007]****************************************
	[40.252]Xilinx Versal Platform Loader and Manager
	[44.665]Release 2021.1   Jul 26 2021  -  04:09:34
	[48.993]Platform Version: v2.0 PMC: v2.0, PS: v2.0
	[53.405]BOOTMODE: 0x0, MULTIBOOT: 0x0
	[56.715]****************************************
	[60.998] 56.230 ms for Partition#: 0x1, Size: 2512 Bytes
	[65.879]---Loading Partition#: 0x2, Id: 0xB
	[70.248] 0.517 ms for Partition#: 0x2, Size: 48 Bytes
	[74.366]---Loading Partition#: 0x3, Id: 0xB
	[115.175] 36.954 ms for Partition#: 0x3, Size: 60592 Bytes
	[117.496]---Loading Partition#: 0x4, Id: 0xB
	[121.451] 0.019 ms for Partition#: 0x4, Size: 5968 Bytes
	[126.322]---Loading Partition#: 0x5, Id: 0xB
	[130.266] 0.007 ms for Partition#: 0x5, Size: 80 Bytes
	[135.041]+++Loading Image#: 0x2, Name: pl_cfi, Id: 0x18700000
	[140.324]---Loading Partition#: 0x6, Id: 0x3
	[1008.283] 864.020 ms for Partition#: 0x6, Size: 1272512 Bytes
	[1010.946]---Loading Partition#: 0x7, Id: 0x5
	[1298.289] 283.320 ms for Partition#: 0x7, Size: 441248 Bytes
	[1300.906]+++Loading Image#: 0x3, Name: fpd, Id: 0x0420C003
	[1306.042]---Loading Partition#: 0x8, Id: 0x8
	[1310.492] 0.429 ms for Partition#: 0x8, Size: 1104 Bytes
	[1315.103]***********Boot PDI Load: Done***********
	[1319.571]3794.343 ms: ROM Time
	[1322.335]Total PLM Boot Time
	Successfully ran Can polled Example with external loop back

        
#### AXI-CAN Interrupt mode example

a. Loop back mode
Test case to prove loopback mode of AXI-CAN IP(CAN0 is used for testing)

 Log:

	[0.010]PMC_GLOBAL_PMC_ERR1_STATUS: 0x0F000000
	[0.081]PMC_GLOBAL_PMC_ERR2_STATUS: 0x01800000
	[4.179]PLM Initialization Time
	[4.242]***********Boot PDI Load: Started***********
	[4.320]Loading PDI from JTAG
	[4.381]Monolithic/Master Device
	[4.500]0.147 ms: PDI initialization time
	[4.573]+++Loading Image#: 0x1, Name: lpd, Id: 0x04210002
	[4.659]---Loading Partition#: 0x1, Id: 0xC
	[36.024]****************************************
	[40.271]Xilinx Versal Platform Loader and Manager
	[44.687]Release 2021.1   Jul 26 2021  -  04:09:34
	[49.019]Platform Version: v2.0 PMC: v2.0, PS: v2.0
	[53.436]BOOTMODE: 0x0, MULTIBOOT: 0x0
	[56.749]****************************************
	[61.037] 56.268 ms for Partition#: 0x1, Size: 2512 Bytes
	[65.924]---Loading Partition#: 0x2, Id: 0xB
	[70.297] 0.518 ms for Partition#: 0x2, Size: 48 Bytes
	[74.417]---Loading Partition#: 0x3, Id: 0xB
	[114.462] 36.188 ms for Partition#: 0x3, Size: 60592 Bytes
	[116.786]---Loading Partition#: 0x4, Id: 0xB
	[120.744] 0.019 ms for Partition#: 0x4, Size: 5968 Bytes
	[125.619]---Loading Partition#: 0x5, Id: 0xB
	[129.567] 0.007 ms for Partition#: 0x5, Size: 80 Bytes
	[134.345]+++Loading Image#: 0x2, Name: pl_cfi, Id: 0x18700000
	[139.636]---Loading Partition#: 0x6, Id: 0x3
	[1009.127] 865.547 ms for Partition#: 0x6, Size: 1272512 Bytes
	[1011.793]---Loading Partition#: 0x7, Id: 0x5
	[1300.640] 284.819 ms for Partition#: 0x7, Size: 441248 Bytes
	[1303.260]+++Loading Image#: 0x3, Name: fpd, Id: 0x0420C003
	[1308.400]---Loading Partition#: 0x8, Id: 0x8
	[1312.854] 0.429 ms for Partition#: 0x8, Size: 1104 Bytes
	[1317.471]***********Boot PDI Load: Done***********
	[1321.943]3800.036 ms: ROM Time
	[1324.709]Total PLM Boot Time
	Successfully ran Can Interrupt Example


b. Normal mode
Test case to prove normal mode of AXI CAN IP with external loopback(CAN1 and CAN2 are connected to form CAN bus for testing)

 Log:

	[0.010]PMC_GLOBAL_PMC_ERR1_STATUS: 0x0F000000
	[0.081]PMC_GLOBAL_PMC_ERR2_STATUS: 0x01800000
	[4.180]PLM Initialization Time
	[4.243]***********Boot PDI Load: Started***********
	[4.320]Loading PDI from JTAG
	[4.381]Monolithic/Master Device
	[4.498]0.146 ms: PDI initialization time
	[4.573]+++Loading Image#: 0x1, Name: lpd, Id: 0x04210002
	[4.658]---Loading Partition#: 0x1, Id: 0xC
	[36.015]****************************************
	[40.261]Xilinx Versal Platform Loader and Manager
	[44.676]Release 2021.1   Jul 26 2021  -  04:09:34
	[49.007]Platform Version: v2.0 PMC: v2.0, PS: v2.0
	[53.424]BOOTMODE: 0x0, MULTIBOOT: 0x0
	[56.735]****************************************
	[61.021] 56.253 ms for Partition#: 0x1, Size: 2512 Bytes
	[65.905]---Loading Partition#: 0x2, Id: 0xB
	[70.276] 0.518 ms for Partition#: 0x2, Size: 48 Bytes
	[74.392]---Loading Partition#: 0x3, Id: 0xB
	[114.551] 36.305 ms for Partition#: 0x3, Size: 60592 Bytes
	[116.873]---Loading Partition#: 0x4, Id: 0xB
	[120.828] 0.019 ms for Partition#: 0x4, Size: 5968 Bytes
	[125.699]---Loading Partition#: 0x5, Id: 0xB
	[129.643] 0.007 ms for Partition#: 0x5, Size: 80 Bytes
	[134.418]+++Loading Image#: 0x2, Name: pl_cfi, Id: 0x18700000
	[139.702]---Loading Partition#: 0x6, Id: 0x3
	[1007.639] 863.997 ms for Partition#: 0x6, Size: 1272512 Bytes
	[1010.302]---Loading Partition#: 0x7, Id: 0x5
	[1299.392] 285.066 ms for Partition#: 0x7, Size: 441248 Bytes
	[1302.010]+++Loading Image#: 0x3, Name: fpd, Id: 0x0420C003
	[1307.146]---Loading Partition#: 0x8, Id: 0x8
	[1311.597] 0.429 ms for Partition#: 0x8, Size: 1104 Bytes
	[1316.207]***********Boot PDI Load: Done***********
	[1320.676]3765.444 ms: ROM Time
	[1323.439]Total PLM Boot Time
	Successfully ran Can Interrupt Example with external loopback


## Known Issues
In this section, list any known issues with the design, or any warning messages that might appear which can be safely ignored by the customer.

Copyright 2020 Xilinx Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
