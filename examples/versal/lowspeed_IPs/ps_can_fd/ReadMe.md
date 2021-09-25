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
	can6 Link encap:UNSPEC HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  → ff060000.can/   ==> PS-CANFD0
	can7 Link encap:UNSPEC HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  → ff070000.can/   ==> PS-CANFD1

 #### PS-CANFD LOOP BACK
 
  a. This test case done on PS_CANFD0(CAN6) uses internal loopback mode available in the software configuration register no external loop back b/w TX and RX.
  
   Log:

	root@VCK_190_2021_1:~# ip -d -s link show can6
	9: can6: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT group default qlen 10
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can state STOPPED (berr-counter tx 0 rx 0) restart-ms 0
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 49999999
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    0          0        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    0          0        0       0       0       0
	root@VCK_190_2021_1:~# ip link set can6 type can bitrate 1000000 dbitrate 6000000 fd on loopback on
	[   35.812073] xilinx_can ff060000.can can6: bitrate error 0.0%
	[   35.817762] xilinx_can ff060000.can can6: bitrate error 4.1%
	root@VCK_190_2021_1:~# ip link set can6 type can bitrate 1000000 dbitrate 6500000 fd on loopback on
	[   45.944091] xilinx_can ff060000.can can6: bitrate error 0.0%
	[   45.949776] xilinx_can ff060000.can can6: bitrate error 3.8%
	root@VCK_190_2021_1:~# ip link set can6 up
	[   65.464129] IPv6: ADDRCONF(NETDEV_CHANGE): can6: link becomes ready
	root@VCK_190_2021_1:~# ip -d -s link show can6
	9: can6: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 10
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <LOOPBACK,FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 999999 sample-point 0.720
		  tq 40 prop-seg 8 phase-seg1 9 phase-seg2 7 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  dbitrate 6249999 dsample-point 0.750
		  dtq 40 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 49999999
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    0          0        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    0          0        0       0       0       0
	root@VCK_190_2021_1:~# cansend can6 123#112233
	root@VCK_190_2021_1:~# ip -d -s link show can6
	9: can6: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 10
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <LOOPBACK,FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 999999 sample-point 0.720
		  tq 40 prop-seg 8 phase-seg1 9 phase-seg2 7 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  dbitrate 6249999 dsample-point 0.750
		  dtq 40 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 49999999
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    3          1        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    3          1        0       0       0       0
	root@VCK_190_2021_1:~# cansend can6 12345678#F112233445566778899AABBCCDDEEFF
	root@VCK_190_2021_1:~# ip -d -s link show can6
	9: can6: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 10
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <LOOPBACK,FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 999999 sample-point 0.720
		  tq 40 prop-seg 8 phase-seg1 9 phase-seg2 7 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  dbitrate 6249999 dsample-point 0.750
		  dtq 40 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 49999999
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    11         2        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    11         2        0       0       0       0

	
#### PS-CANFD NORMAL MODE 

 a. PS-CANFD_0(CAN6) and PS_CANFD_1(CAN7) are connected  node to node on the bus to prove the communication b/w the nodes in normal mode.

  Log

	root@VCK_190_2021_1:~# ip -d -s link show can6
	9: can6: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT group default qlen 10
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can state STOPPED (berr-counter tx 0 rx 0) restart-ms 0
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 49999999
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    0          0        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    0          0        0       0       0       0
	root@VCK_190_2021_1:~# ip -d -s link show can7
	10: can7: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT group default qlen 10
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can state STOPPED (berr-counter tx 0 rx 0) restart-ms 0
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 49999999
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    0          0        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    0          0        0       0       0       0
	root@VCK_190_2021_1:~# ip link set can6 type can bitrate 100000 dbitrate 4000000 fd on
	[   50.280489] xilinx_can ff060000.can can6: bitrate error 0.0%
	[   50.286182] xilinx_can ff060000.can can6: bitrate error 4.1%
	root@VCK_190_2021_1:~# ip link set can7 type can bitrate 100000 dbitrate 4000000 fd on
	[   57.592433] xilinx_can ff070000.can can7: bitrate error 0.0%
	[   57.598117] xilinx_can ff070000.can can7: bitrate error 4.1%
	root@VCK_190_2021_1:~# ifconfig can6 txqueuelen 1000
	root@VCK_190_2021_1:~# ifconfig can7 txqueuelen 1000
	root@VCK_190_2021_1:~# ip link set can6 up
	[   92.992484] IPv6: ADDRCONF(NETDEV_CHANGE): can6: link becomes ready
	root@VCK_190_2021_1:~# ip link set can7 up
	[   98.712429] IPv6: ADDRCONF(NETDEV_CHANGE): can7: link becomes ready
	root@VCK_190_2021_1:~# ip -d -s link show can6
	9: can6: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 99999 sample-point 0.872
		  tq 80 prop-seg 54 phase-seg1 54 phase-seg2 16 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  dbitrate 4166666 dsample-point 0.750
		  dtq 60 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 49999999
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    0          0        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    0          0        0       0       0       0
	root@VCK_190_2021_1:~# ip -d -s link show can7
	10: can7: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 99999 sample-point 0.872
		  tq 80 prop-seg 54 phase-seg1 54 phase-seg2 16 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  dbitrate 4166666 dsample-point 0.750
		  dtq 60 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 49999999
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    0          0        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    0          0        0       0       0       0
	root@VCK_190_2021_1:~# cansend can6 123#1122334455
	root@VCK_190_2021_1:~# ip -d -s link show can6
	9: can6: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 99999 sample-point 0.872
		  tq 80 prop-seg 54 phase-seg1 54 phase-seg2 16 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  dbitrate 4166666 dsample-point 0.750
		  dtq 60 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 49999999
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    0          0        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    5          1        0       0       0       0
	root@VCK_190_2021_1:~# ip -d -s link show can7
	10: can7: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 99999 sample-point 0.872
		  tq 80 prop-seg 54 phase-seg1 54 phase-seg2 16 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  dbitrate 4166666 dsample-point 0.750
		  dtq 60 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 49999999
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    5          1        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    0          0        0       0       0       0
	root@VCK_190_2021_1:~# cansend can6 12345678##9112233445566778899
	root@VCK_190_2021_1:~# ip -d -s link show can6
	9: can6: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 99999 sample-point 0.872
		  tq 80 prop-seg 54 phase-seg1 54 phase-seg2 16 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  dbitrate 4166666 dsample-point 0.750
		  dtq 60 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 49999999
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    0          0        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    17         2        0       0       0       0
	root@VCK_190_2021_1:~# ip -d -s link show can7
	10: can7: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 99999 sample-point 0.872
		  tq 80 prop-seg 54 phase-seg1 54 phase-seg2 16 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  dbitrate 4166666 dsample-point 0.750
		  dtq 60 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 49999999
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    17         2        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    0          0        0       0       0       0
	root@VCK_190_2021_1:~# cansend can7 12345678##A112233445566778899AA
	root@VCK_190_2021_1:~# ip -d -s link show can6
	9: can6: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 99999 sample-point 0.872
		  tq 80 prop-seg 54 phase-seg1 54 phase-seg2 16 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  dbitrate 4166666 dsample-point 0.750
		  dtq 60 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 49999999
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    12         1        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    17         2        0       0       0       0
	root@VCK_190_2021_1:~# ip -d -s link show can7
	10: can7: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 99999 sample-point 0.872
		  tq 80 prop-seg 54 phase-seg1 54 phase-seg2 16 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  dbitrate 4166666 dsample-point 0.750
		  dtq 60 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 49999999
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    17         2        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    12         1        0       0       0       0
	root@VCK_190_2021_1:~# ip link set can7 down
	root@VCK_190_2021_1:~# ip link set can7 type can bitrate 100000 dbitrate 5000000 fd on
	[  252.480508] xilinx_can ff070000.can can7: bitrate error 0.0%
	[  252.486190] xilinx_can ff070000.can can7: bitrate error 0.0%
	root@VCK_190_2021_1:~# ip link set can7 up
	root@VCK_190_2021_1:~# ip -d -s link show can7
	10: can7: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 99999 sample-point 0.872
		  tq 80 prop-seg 54 phase-seg1 54 phase-seg2 16 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  dbitrate 4999999 dsample-point 0.600
		  dtq 40 dprop-seg 1 dphase-seg1 1 dphase-seg2 2 dsjw 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 49999999
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    17         2        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    12         1        0       0       0       0
	root@VCK_190_2021_1:~# cansend can7 12345678##A112233445566778899AA
	root@VCK_190_2021_1:~#  ip -d -s link show can7
	10: can7: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 99999 sample-point 0.872
		  tq 80 prop-seg 54 phase-seg1 54 phase-seg2 16 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  dbitrate 4999999 dsample-point 0.600
		  dtq 40 dprop-seg 1 dphase-seg1 1 dphase-seg2 2 dsjw 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 49999999
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    17         2        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    24         2        0       0       0       0
	root@VCK_190_2021_1:~# ip link set can7 down
	root@VCK_190_2021_1:~# ip link set can7 type can bitrate 100000 dbitrate 6000000 fd on
	[  313.360387] xilinx_can ff070000.can can7: bitrate error 0.0%
	[  313.366068] xilinx_can ff070000.can can7: bitrate error 4.1%
	root@VCK_190_2021_1:~#  ip link set can7 up
	root@VCK_190_2021_1:~# cansend can7 12345678##A112233445566778899AA
	root@VCK_190_2021_1:~# ip -d -s link show can7
	10: can7: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
	    link/can  promiscuity 0 minmtu 0 maxmtu 0
	    can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
		  bitrate 99999 sample-point 0.872
		  tq 80 prop-seg 54 phase-seg1 54 phase-seg2 16 sjw 1
		  xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
		  dbitrate 6249999 dsample-point 0.750
		  dtq 40 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
		  xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
		  clock 49999999
		  re-started bus-errors arbit-lost error-warn error-pass bus-off
		  0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
	    RX: bytes  packets  errors  dropped overrun mcast
	    17         2        0       0       0       0
	    TX: bytes  packets  errors  dropped carrier collsns
	    36         3        0       0       0       0
	root@VCK_190_2021_1:~#

  

### Vitis:

#### PS-CANFD polled mode example

a. Loop back mode
Test case to prove loopback mode of PS-CANFD IP(CANFD0 is used for testing)

Log:

	[0.010]PMC_GLOBAL_PMC_ERR1_STATUS: 0x0F000000
	[0.081]PMC_GLOBAL_PMC_ERR2_STATUS: 0x01800000
	[4.180]PLM Initialization Time
	[4.243]***********Boot PDI Load: Started***********
	[4.320]Loading PDI from JTAG
	[4.381]Monolithic/Master Device
	[4.499]0.146 ms: PDI initialization time
	[4.573]+++Loading Image#: 0x1, Name: lpd, Id: 0x04210002
	[4.659]---Loading Partition#: 0x1, Id: 0xC
	[36.007]****************************************
	[40.250]Xilinx Versal Platform Loader and Manager
	[44.662]Release 2021.1   Jul 26 2021  -  04:09:34
	[48.989]Platform Version: v2.0 PMC: v2.0, PS: v2.0
	[53.400]BOOTMODE: 0x0, MULTIBOOT: 0x0
	[56.708]****************************************
	[60.991] 56.222 ms for Partition#: 0x1, Size: 2512 Bytes
	[65.873]---Loading Partition#: 0x2, Id: 0xB
	[70.241] 0.517 ms for Partition#: 0x2, Size: 48 Bytes
	[74.356]---Loading Partition#: 0x3, Id: 0xB
	[116.671] 38.461 ms for Partition#: 0x3, Size: 60592 Bytes
	[118.992]---Loading Partition#: 0x4, Id: 0xB
	[122.947] 0.019 ms for Partition#: 0x4, Size: 5968 Bytes
	[127.817]---Loading Partition#: 0x5, Id: 0xB
	[131.760] 0.007 ms for Partition#: 0x5, Size: 80 Bytes
	[136.534]+++Loading Image#: 0x2, Name: pl_cfi, Id: 0x18700000
	[141.818]---Loading Partition#: 0x6, Id: 0x3
	[1012.008] 866.250 ms for Partition#: 0x6, Size: 1272512 Bytes
	[1014.671]---Loading Partition#: 0x7, Id: 0x5
	[1302.394] 283.696 ms for Partition#: 0x7, Size: 441248 Bytes
	[1305.011]+++Loading Image#: 0x3, Name: fpd, Id: 0x0420C003
	[1310.147]---Loading Partition#: 0x8, Id: 0x8
	[1314.596] 0.429 ms for Partition#: 0x8, Size: 1104 Bytes
	[1319.207]***********Boot PDI Load: Done***********
	[1323.676]3775.522 ms: ROM Time
	[1326.440]Total PLM Boot Time
	Successfully ran XCanFd Polled Mode example



#### PS-CANFD Interrupt mode example

a. Loop back mode
Test case to prove loopback mode of PS-CANFD IP(CANFD0 is used for testing)

Log:

	[0.010]PMC_GLOBAL_PMC_ERR1_STATUS: 0x0F000000
	[0.081]PMC_GLOBAL_PMC_ERR2_STATUS: 0x01800000
	[4.180]PLM Initialization Time
	[4.243]***********Boot PDI Load: Started***********
	[4.320]Loading PDI from JTAG
	[4.381]Monolithic/Master Device
	[4.498]0.145 ms: PDI initialization time
	[4.572]+++Loading Image#: 0x1, Name: lpd, Id: 0x04210002
	[4.658]---Loading Partition#: 0x1, Id: 0xC
	[35.998]****************************************
	[40.240]Xilinx Versal Platform Loader and Manager
	[44.652]Release 2021.1   Jul 26 2021  -  04:09:34
	[48.981]Platform Version: v2.0 PMC: v2.0, PS: v2.0
	[53.393]BOOTMODE: 0x0, MULTIBOOT: 0x0
	[56.702]****************************************
	[60.985] 56.217 ms for Partition#: 0x1, Size: 2512 Bytes
	[65.867]---Loading Partition#: 0x2, Id: 0xB
	[70.238] 0.517 ms for Partition#: 0x2, Size: 48 Bytes
	[74.354]---Loading Partition#: 0x3, Id: 0xB
	[113.133] 34.926 ms for Partition#: 0x3, Size: 60592 Bytes
	[115.455]---Loading Partition#: 0x4, Id: 0xB
	[119.409] 0.019 ms for Partition#: 0x4, Size: 5968 Bytes
	[124.280]---Loading Partition#: 0x5, Id: 0xB
	[128.222] 0.007 ms for Partition#: 0x5, Size: 80 Bytes
	[132.996]+++Loading Image#: 0x2, Name: pl_cfi, Id: 0x18700000
	[138.278]---Loading Partition#: 0x6, Id: 0x3
	[1007.363] 865.146 ms for Partition#: 0x6, Size: 1272512 Bytes
	[1010.026]---Loading Partition#: 0x7, Id: 0x5
	[1297.397] 283.347 ms for Partition#: 0x7, Size: 441248 Bytes
	[1300.018]+++Loading Image#: 0x3, Name: fpd, Id: 0x0420C003
	[1305.155]---Loading Partition#: 0x8, Id: 0x8
	[1309.607] 0.429 ms for Partition#: 0x8, Size: 1104 Bytes
	[1314.220]***********Boot PDI Load: Done***********
	[1318.693]3770.922 ms: ROM Time
	[1321.456]Total PLM Boot Time
	Successfully ran XCanFd Interrupt Mode example



## Known Issues

The bare-metal test cases are similar to AXI_CANFD requesting to refer the follwoing link https://gitenterprise.xilinx.com/Xilinx-Wiki-Projects/VCK190_LowSpeed_IPs/tree/master/axi_can_fd/software/vitis 

With minimum changes in the examples user can use the same for PS-CANFD Normal mode.


Copyright 2020 Xilinx Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

