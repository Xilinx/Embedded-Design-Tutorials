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

1. Vitis offers few CANFD-based example application projects. These can be selected on the second page of the New Application Project dialogue.

  ## Validation
Here you will place example validation that you've done that the customer can repeat. This improves confidence in the design, and gives a good test for the customer to run initially. Shown below are Linux and Vitis examples:

  ### Linux:

After login to root run the follwoing commands to get bus information

	root@VCK_190_2021_1:~# /sys/class/net/can0/device/driver/
	a4000000.can/   a4010000.can/   a4020000.can/   a4030000.canfd/ a4040000.canfd/ a4050000.canfd/ ff060000.can/   ff070000.can/
	root@VCK_190_2021_1:~# ifconfig -a | grep can
	can3 Link encap:UNSPEC HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  → a4040000.can/   ==> AXI-CANFD0
	can4 Link encap:UNSPEC HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  → a4050000.can/   ==> AXI-CANFD1
	can5 Link encap:UNSPEC HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  → a4060000.can/   ==> AXI-CANFD2

 #### AXI-CANFD LOOP BACK
 
  a. TX and RX of the AXI CANFD IP are shorted to prove the loopback externally user can enable loopback mode also through the register to prove loopback mode.
  
 #### CAN packet
 
 Log:

	root@VCK_190_2021_1:~# ip -d -s link show can3
	5: can3: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT group default qlen 10
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can state STOPPED (berr-counter tx 0 rx 0) restart-ms 0
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 80000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    0          0        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    0          0        0       0       0       0
	root@VCK_190_2021_1:~# ip link set can3 type can bitrate 1000000 loopback on
	root@VCK_190_2021_1:~# ifconfig can3 txqueuelen 1000
	root@VCK_190_2021_1:~# ip link set can3 up
	[  916.261585] IPv6: ADDRCONF(NETDEV_CHANGE): can3: link becomes ready
	root@VCK_190_2021_1:~# ip -d -s link show can3
	5: can3: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <LOOPBACK> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 1000000 sample-point 0.750
		  tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 80000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    0          0        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    0          0        0       0       0       0
	root@VCK_190_2021_1:~# cansend can3 123#1122334455
	root@VCK_190_2021_1:~# ip -d -s link show can3
	5: can3: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <LOOPBACK> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 1000000 sample-point 0.750
		  tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 80000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    5          1        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    5          1        0       0       0       0
	root@VCK_190_2021_1:~# cansend can3 223#11223344556677
	root@VCK_190_2021_1:~# ip -d -s link show can3
	5: can3: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <LOOPBACK> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 1000000 sample-point 0.750
		  tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 80000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    12         2        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    12         2        0       0       0       0
	root@VCK_190_2021_1:~#

 
 
                  
#### CANFD packet

Log:

	root@VCK_190_2021_1:~# ip link set can3 down
	root@VCK_190_2021_1:~# ip link set can3 type can bitrate 1000000 dbitrate 4000000 fd on loopback on
	root@VCK_190_2021_1:~# ip link set can3 up
	root@VCK_190_2021_1:~# ip -d -s link show can3
	5: can3: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <LOOPBACK,FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 1000000 sample-point 0.750
		  tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  dbitrate 4000000 dsample-point 0.750
		  dtq 62 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 80000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    12         2        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    12         2        0       0       0       0
	root@VCK_190_2021_1:~# cansend can3 123#112233
	root@VCK_190_2021_1:~# ip -d -s link show can3
	5: can3: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <LOOPBACK,FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 1000000 sample-point 0.750
		  tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  dbitrate 4000000 dsample-point 0.750
		  dtq 62 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 80000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    15         3        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    15         3        0       0       0       0
	root@VCK_190_2021_1:~# cansend can3 12345678##9112233445566778899
	root@VCK_190_2021_1:~# ip -d -s link show can3
	5: can3: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <LOOPBACK,FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 1000000 sample-point 0.750
		  tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  dbitrate 4000000 dsample-point 0.750
		  dtq 62 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 80000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    27         4        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    27         4        0       0       0       0
	root@VCK_190_2021_1:~# cansend can3 12345678##D112233445566778899AABBCCDD
	root@VCK_190_2021_1:~# ip -d -s link show can3
	5: can3: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <LOOPBACK,FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 1000000 sample-point 0.750
		  tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  dbitrate 4000000 dsample-point 0.750
		  dtq 62 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 80000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    43         5        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    43         5        0       0       0       0
	root@VCK_190_2021_1:~#

	
	
#### AXI-CANFD NORMAL MODE 

a. AXI-CANFD_1(CAN4) and AXI_CANFD_2(CAN5) are connect to node to node to form the bus to prove the communication b/w the nodes in normal mode.

 Log:

	root@VCK_190_2021_1:~# ip link set can4 type can bitrate 1000000 dbitrate 4000000
	RTNETLINK answers: Operation not supported
	root@VCK_190_2021_1:~# ip link set can4 type can bitrate 1000000 dbitrate 4000000 fd on
	root@VCK_190_2021_1:~# ip link set can5 type can bitrate 1000000 dbitrate 4000000 fd on
	root@VCK_190_2021_1:~# ifconfig can4 txqueuelen 1000
	root@VCK_190_2021_1:~# ifconfig can5 txqueuelen 1000
	root@VCK_190_2021_1:~# ip link set can4 up
	[   69.363107] IPv6: ADDRCONF(NETDEV_CHANGE): can4: link becomes ready
	root@VCK_190_2021_1:~# ip link set can5 up
	[   77.023118] IPv6: ADDRCONF(NETDEV_CHANGE): can5: link becomes ready
	root@VCK_190_2021_1:~# ip -d -s link show can4
	6: can4: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 1000000 sample-point 0.750
		  tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  dbitrate 4000000 dsample-point 0.750
		  dtq 62 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 80000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    0          0        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    0          0        0       0       0       0
	root@VCK_190_2021_1:~# ip -d -s link show can5
	7: can5: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 1000000 sample-point 0.750
		  tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  dbitrate 4000000 dsample-point 0.750
		  dtq 62 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 80000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    0          0        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    0          0        0       0       0       0
	root@VCK_190_2021_1:~# cansend can4 223#11223344
	root@VCK_190_2021_1:~# ip -d -s link show can4
	6: can4: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 1000000 sample-point 0.750
		  tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  dbitrate 4000000 dsample-point 0.750
		  dtq 62 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 80000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    0          0        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    4          1        0       0       0       0
	root@VCK_190_2021_1:~# ip -d -s link show can5
	7: can5: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 1000000 sample-point 0.750
		  tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  dbitrate 4000000 dsample-point 0.750
		  dtq 62 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 80000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    4          1        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    0          0        0       0       0       0
	root@VCK_190_2021_1:~# cansend can4 12345678##1212345678910111213141516171819202122
	root@VCK_190_2021_1:~# ip -d -s link show can5
	7: can5: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 1000000 sample-point 0.750
		  tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  dbitrate 4000000 dsample-point 0.750
		  dtq 62 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 80000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    24         2        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    0          0        0       0       0       0
	root@VCK_190_2021_1:~# cansend can5 12345678##1212345678910111213141516171819202122
	root@VCK_190_2021_1:~# ip -d -s link show can5
	7: can5: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 1000000 sample-point 0.750
		  tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  dbitrate 4000000 dsample-point 0.750
		  dtq 62 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 80000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    24         2        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    20         1        0       0       0       0
	root@VCK_190_2021_1:~# ip -d -s link show can4
	6: can4: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 1000000 sample-point 0.750
		  tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  dbitrate 4000000 dsample-point 0.750
		  dtq 62 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 80000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    20         1        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    24         2        0       0       0       0
	root@VCK_190_2021_1:~# ip link set can5 down
	root@VCK_190_2021_1:~# ip link set can4 down
	root@VCK_190_2021_1:~#  ip link set can5 type can bitrate 1000000 dbitrate 6000000 fd on
	[  318.443106] xilinx_can a4050000.canfd can5: bitrate error 4.7%
	root@VCK_190_2021_1:~# ip link set can4 type can bitrate 1000000 dbitrate 6000000 fd on
	[  328.683179] xilinx_can a4040000.canfd can4: bitrate error 4.7%
	root@VCK_190_2021_1:~# ip link set can4 up
	root@VCK_190_2021_1:~# ip link set can5 up
	root@VCK_190_2021_1:~# ip -d -s link show can4
	6: can4: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 1000000 sample-point 0.750
		  tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  dbitrate 5714285 dsample-point 0.714
		  dtq 25 dprop-seg 2 dphase-seg1 2 dphase-seg2 2 dsjw 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 80000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    20         1        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    24         2        0       0       0       0
	root@VCK_190_2021_1:~# cansend can5 12345678##1212345678910111213141516171819202122
	root@VCK_190_2021_1:~# ip -d -s link show can4
	6: can4: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 1000000 sample-point 0.750
		  tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  dbitrate 5714285 dsample-point 0.714
		  dtq 25 dprop-seg 2 dphase-seg1 2 dphase-seg2 2 dsjw 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 80000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    40         2        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    24         2        0       0       0       0
	root@VCK_190_2021_1:~# cansend can4 12345678##1212345678910111213141516171819202122
	root@VCK_190_2021_1:~# ip -d -s link show can5
	7: can5: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 1000000 sample-point 0.750
		  tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  dbitrate 5714285 dsample-point 0.714
		  dtq 25 dprop-seg 2 dphase-seg1 2 dphase-seg2 2 dsjw 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 80000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    44         3        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    40         2        0       0       0       0
	root@VCK_190_2021_1:~#  ip link set can4 down
	root@VCK_190_2021_1:~#  ip link set can5 down
	root@VCK_190_2021_1:~# ip link set can4 type can bitrate 1000000 dbitrate 7000000 fd on
	[  420.203117] xilinx_can a4040000.canfd can4: bitrate error 4.7%
	root@VCK_190_2021_1:~# ip link set can5 type can bitrate 1000000 dbitrate 7000000 fd on
	[  427.799119] xilinx_can a4050000.canfd can5: bitrate error 4.7%
	root@VCK_190_2021_1:~# ip link set can4 up
	root@VCK_190_2021_1:~# ip link set can5 up
	root@VCK_190_2021_1:~# ip -d -s link show can5
	7: can5: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 1000000 sample-point 0.750
		  tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  dbitrate 6666666 dsample-point 0.750
		  dtq 37 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 80000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    44         3        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    40         2        0       0       0       0
	root@VCK_190_2021_1:~# cansend can4 12345678##13AA12345678910111213141516171819202122
	root@VCK_190_2021_1:~# cansend can5 12345678##11345678910111213141516171819202122
	root@VCK_190_2021_1:~# ip -d -s link show can4
	6: can4: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 1000000 sample-point 0.750
		  tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  dbitrate 6666666 dsample-point 0.750
		  dtq 37 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 80000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    60         3        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    64         4        0       0       0       0
	root@VCK_190_2021_1:~# ip -d -s link show can5
	7: can5: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 1000000 sample-point 0.750
		  tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  dbitrate 6666666 dsample-point 0.750
		  dtq 37 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 80000000
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    64         4        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    60         3        0       0       0       0
	root@VCK_190_2021_1:~#


### Vitis:

#### AXI-CANFD polled mode example

a. Loop back mode
Test case to prove loopback mode of AXI-CANFD IP(CANFD0 is used for testing)

Log:

	[0.010]PMC_GLOBAL_PMC_ERR1_STATUS: 0x0F000000
	[0.081]PMC_GLOBAL_PMC_ERR2_STATUS: 0x01800000
	[4.180]PLM Initialization Time
	[4.243]***********Boot PDI Load: Started***********
	[4.320]Loading PDI from JTAG
	[4.382]Monolithic/Master Device
	[4.501]0.147 ms: PDI initialization time
	[4.574]+++Loading Image#: 0x1, Name: lpd, Id: 0x04210002
	[4.660]---Loading Partition#: 0x1, Id: 0xC
	[35.996]****************************************
	[40.237]Xilinx Versal Platform Loader and Manager
	[44.647]Release 2021.1   Jul 26 2021  -  04:09:34
	[48.973]Platform Version: v2.0 PMC: v2.0, PS: v2.0
	[53.384]BOOTMODE: 0x0, MULTIBOOT: 0x0
	[56.692]****************************************
	[60.975] 56.205 ms for Partition#: 0x1, Size: 2512 Bytes
	[65.855]---Loading Partition#: 0x2, Id: 0xB
	[70.223] 0.517 ms for Partition#: 0x2, Size: 48 Bytes
	[74.338]---Loading Partition#: 0x3, Id: 0xB
	[113.944] 35.753 ms for Partition#: 0x3, Size: 60592 Bytes
	[116.263]---Loading Partition#: 0x4, Id: 0xB
	[120.214] 0.019 ms for Partition#: 0x4, Size: 5968 Bytes
	[125.083]---Loading Partition#: 0x5, Id: 0xB
	[129.023] 0.007 ms for Partition#: 0x5, Size: 80 Bytes
	[133.794]+++Loading Image#: 0x2, Name: pl_cfi, Id: 0x18700000
	[139.075]---Loading Partition#: 0x6, Id: 0x3
	[1006.475] 863.462 ms for Partition#: 0x6, Size: 1272512 Bytes
	[1009.138]---Loading Partition#: 0x7, Id: 0x5
	[1297.175] 284.017 ms for Partition#: 0x7, Size: 441248 Bytes
	[1299.792]+++Loading Image#: 0x3, Name: fpd, Id: 0x0420C003
	[1304.925]---Loading Partition#: 0x8, Id: 0x8
	[1309.374] 0.429 ms for Partition#: 0x8, Size: 1104 Bytes
	[1313.982]***********Boot PDI Load: Done***********
	[1318.448]3782.388 ms: ROM Time
	[1321.209]Total PLM Boot Time
	Successfully ran XCanFd Polled Mode example


b. Normal mode
Test case to prove normal mode of AXI CANFD IP with external loopback(CANFD1 and CANFD2 are connected to form CAN bus for testing)


      583200]****************************************
      [7.222640]Xilinx Versal Platform Loader and Manager
      [11.840903]Release 2020.2 Nov 18 2020 - 14:54:52
      [16.458481]Platform Version: v2.0 PMC: v2.0, PS: v2.0
      [21.161568]BOOTMODE: 0, MULTIBOOT: 0x0
      [24.581768]****************************************
      [29.134796] 24.791675 ms for PrtnNum: 1, Size: 2368 Bytes
      [34.156231]-------Loading Prtn No: 0x2
      [38.115268] 0.521596 ms for PrtnNum: 2, Size: 48 Bytes
      [42.363721]-------Loading Prtn No: 0x3
      [80.684134] 34.879815 ms for PrtnNum: 3, Size: 57168 Bytes
      [83.008090]-------Loading Prtn No: 0x4
      [86.457653] 0.012528 ms for PrtnNum: 4, Size: 2512 Bytes
      [91.389390]-------Loading Prtn No: 0x5
      [94.839456] 0.014315 ms for PrtnNum: 5, Size: 3424 Bytes
      [99.768843]-------Loading Prtn No: 0x6
      [103.211203] 0.007784 ms for PrtnNum: 6, Size: 80 Bytes
      [108.110071]+++++++Loading Image No: 0x2, Name: pl_cfi, Id: 0x18700000
      [114.214762]-------Loading Prtn No: 0x7
      [997.576312] 879.835006 ms for PrtnNum: 7, Size: 1320080 Bytes
      [1000.242037]-------Loading Prtn No: 0x8
      [1265.305581] 261.451315 ms for PrtnNum: 8, Size: 385488 Bytes
      [1268.006193]+++++++Loading Image No: 0x3, Name: fpd, Id: 0x0420C003
      [1273.959959]-------Loading Prtn No: 0x9
      [1277.732025] 0.163903 ms for PrtnNum: 9, Size: 1008 Bytes
      [1282.733853]***********Boot PDI Load: Done*************
      [1287.657368]3520.849246 ms: ROM Time
      [1290.976134]Total PLM Boot Time
      Successfully ran AXI-XCanFd Polled Mode example with external loopback



#### AXI-CANFD Interrupt mode example

a. Loop back mode
Test case to prove loopback mode of AXI-CANFD IP(CANFD0 is used for testing)

Log:

	[0.010]PMC_GLOBAL_PMC_ERR1_STATUS: 0x0F000000
	[0.081]PMC_GLOBAL_PMC_ERR2_STATUS: 0x01800000
	[4.180]PLM Initialization Time
	[4.242]***********Boot PDI Load: Started***********
	[4.320]Loading PDI from JTAG
	[4.381]Monolithic/Master Device
	[4.499]0.146 ms: PDI initialization time
	[4.573]+++Loading Image#: 0x1, Name: lpd, Id: 0x04210002
	[4.659]---Loading Partition#: 0x1, Id: 0xC
	[35.991]****************************************
	[40.233]Xilinx Versal Platform Loader and Manager
	[44.642]Release 2021.1   Jul 26 2021  -  04:09:34
	[48.969]Platform Version: v2.0 PMC: v2.0, PS: v2.0
	[53.379]BOOTMODE: 0x0, MULTIBOOT: 0x0
	[56.688]****************************************
	[60.969] 56.200 ms for Partition#: 0x1, Size: 2512 Bytes
	[65.849]---Loading Partition#: 0x2, Id: 0xB
	[70.217] 0.517 ms for Partition#: 0x2, Size: 48 Bytes
	[74.332]---Loading Partition#: 0x3, Id: 0xB
	[114.722] 36.539 ms for Partition#: 0x3, Size: 60592 Bytes
	[117.042]---Loading Partition#: 0x4, Id: 0xB
	[120.995] 0.019 ms for Partition#: 0x4, Size: 5968 Bytes
	[125.863]---Loading Partition#: 0x5, Id: 0xB
	[129.804] 0.007 ms for Partition#: 0x5, Size: 80 Bytes
	[134.576]+++Loading Image#: 0x2, Name: pl_cfi, Id: 0x18700000
	[139.858]---Loading Partition#: 0x6, Id: 0x3
	[997.258] 853.460 ms for Partition#: 0x6, Size: 1272512 Bytes
	[999.833]---Loading Partition#: 0x7, Id: 0x5
	[1286.442] 282.673 ms for Partition#: 0x7, Size: 441248 Bytes
	[1289.061]+++Loading Image#: 0x3, Name: fpd, Id: 0x0420C003
	[1294.199]---Loading Partition#: 0x8, Id: 0x8
	[1298.650] 0.429 ms for Partition#: 0x8, Size: 1104 Bytes
	[1303.262]***********Boot PDI Load: Done***********
	[1307.732]3443.483 ms: ROM Time
	[1310.496]Total PLM Boot Time
	Successfully ran XCanFd Interrupt Mode example


b. Normal mode
Test case to prove normal mode of AXI CANFD IP with external loopback(CANFD1 and CANFD2 are connected to form CAN bus for testing)

Log:

	[0.010]PMC_GLOBAL_PMC_ERR1_STATUS: 0x0F000000
	[0.081]PMC_GLOBAL_PMC_ERR2_STATUS: 0x01800000
	[4.180]PLM Initialization Time
	[4.243]***********Boot PDI Load: Started***********
	[4.320]Loading PDI from JTAG
	[4.381]Monolithic/Master Device
	[4.500]0.147 ms: PDI initialization time
	[4.573]+++Loading Image#: 0x1, Name: lpd, Id: 0x04210002
	[4.659]---Loading Partition#: 0x1, Id: 0xC
	[35.994]****************************************
	[40.238]Xilinx Versal Platform Loader and Manager
	[44.650]Release 2021.1   Jul 26 2021  -  04:09:34
	[48.977]Platform Version: v2.0 PMC: v2.0, PS: v2.0
	[53.388]BOOTMODE: 0x0, MULTIBOOT: 0x0
	[56.697]****************************************
	[60.980] 56.211 ms for Partition#: 0x1, Size: 2512 Bytes
	[65.860]---Loading Partition#: 0x2, Id: 0xB
	[70.228] 0.517 ms for Partition#: 0x2, Size: 48 Bytes
	[74.342]---Loading Partition#: 0x3, Id: 0xB
	[113.600] 35.405 ms for Partition#: 0x3, Size: 60592 Bytes
	[115.921]---Loading Partition#: 0x4, Id: 0xB
	[119.874] 0.019 ms for Partition#: 0x4, Size: 5968 Bytes
	[124.744]---Loading Partition#: 0x5, Id: 0xB
	[128.686] 0.007 ms for Partition#: 0x5, Size: 80 Bytes
	[133.460]+++Loading Image#: 0x2, Name: pl_cfi, Id: 0x18700000
	[138.744]---Loading Partition#: 0x6, Id: 0x3
	[1009.879] 867.197 ms for Partition#: 0x6, Size: 1272512 Bytes
	[1012.542]---Loading Partition#: 0x7, Id: 0x5
	[1301.374] 284.810 ms for Partition#: 0x7, Size: 441248 Bytes
	[1303.991]+++Loading Image#: 0x3, Name: fpd, Id: 0x0420C003
	[1309.124]---Loading Partition#: 0x8, Id: 0x8
	[1313.572] 0.429 ms for Partition#: 0x8, Size: 1104 Bytes
	[1318.181]***********Boot PDI Load: Done***********
	[1322.649]3771.757 ms: ROM Time
	[1325.411]Total PLM Boot Time
	Successfully ran PS-XCanFd Interrupt Mode example with external loopback


## Known Issues
In this section, list any known issues with the design, or any warning messages that might appear which can be safely ignored by the customer.

Copyright 2020 Xilinx Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
