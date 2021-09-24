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

      root@vck_190_lowspeed:~# ip link set can3 down
      root@vck_190_lowspeed:~# ip link set can3 type can bitrate 1000000 dbitrate 4000000 fd on loopback on
      root@vck_190_lowspeed:~# ip link set can3 up
      root@vck_190_lowspeed:~# ip -d -s link show can3
      5: can3: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
      link/can promiscuity 0 minmtu 0 maxmtu 0
      can <LOOPBACK,FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
      bitrate 1000000 sample-point 0.750
      tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
      xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
      dbitrate 4000000 dsample-point 0.750
      dtq 62 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
      xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
      clock 80000000
      re-started bus-errors arbit-lost error-warn error-pass bus-off
      0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
      RX: bytes packets errors dropped overrun mcast
      12 2 0 0 0 0
      TX: bytes packets errors dropped carrier collsns
      12 2 0 0 0 0
      root@vck_190_lowspeed:~# cansend can3 123#112233
      root@vck_190_lowspeed:~# ip -d -s link show can3
      5: can3: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
      link/can promiscuity 0 minmtu 0 maxmtu 0
      can <LOOPBACK,FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
      bitrate 1000000 sample-point 0.750
      tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
      xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
      dbitrate 4000000 dsample-point 0.750
      dtq 62 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
      xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
      clock 80000000
      re-started bus-errors arbit-lost error-warn error-pass bus-off
      0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
      RX: bytes packets errors dropped overrun mcast
      15 3 0 0 0 0
      TX: bytes packets errors dropped carrier collsns
      15 3 0 0 0 0
      root@vck_190_lowspeed:~# cansend can3 12345678##9112233445566778899
      root@vck_190_lowspeed:~# ip -d -s link show can3
      5: can3: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
      link/can promiscuity 0 minmtu 0 maxmtu 0
      can <LOOPBACK,FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
      bitrate 1000000 sample-point 0.750
      tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
      xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
      dbitrate 4000000 dsample-point 0.750
      dtq 62 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
      xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
      clock 80000000
      re-started bus-errors arbit-lost error-warn error-pass bus-off
      0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
      RX: bytes packets errors dropped overrun mcast
      27 4 0 0 0 0
      TX: bytes packets errors dropped carrier collsns
      27 4 0 0 0 0
      root@vck_190_lowspeed:~# cansend can3 12345678##D112233445566778899AABBCCDD
      root@vck_190_lowspeed:~# ip -d -s link show can3
      5: can3: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
      link/can promiscuity 0 minmtu 0 maxmtu 0
      can <LOOPBACK,FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
      bitrate 1000000 sample-point 0.750
      tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
      xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
      dbitrate 4000000 dsample-point 0.750
      dtq 62 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
      xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
      clock 80000000
      re-started bus-errors arbit-lost error-warn error-pass bus-off
      0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
      RX: bytes packets errors dropped overrun mcast
      43 5 0 0 0 0
      TX: bytes packets errors dropped carrier collsns
      43 5 0 0 0 0
      root@vck_190_lowspeed:~#
	
	
#### AXI-CANFD NORMAL MODE 

a. AXI-CANFD_1(CAN4) and AXI_CANFD_2(CAN5) are connect to node to node to form the bus to prove the communication b/w the nodes in normal mode.

 Log:

        root@vck_190_lowspeed:~# ip link set can4 type can bitrate 1000000 dbitrate 4000000
        RTNETLINK answers: Operation not supported
        root@vck_190_lowspeed:~# ip link set can4 type can bitrate 1000000 dbitrate 4000000 fd on
        root@vck_190_lowspeed:~# ip link set can5 type can bitrate 1000000 dbitrate 4000000 fd on
        root@vck_190_lowspeed:~# ifconfig can4 txqueuelen 1000
        root@vck_190_lowspeed:~# ifconfig can5 txqueuelen 1000
        root@vck_190_lowspeed:~# ip link set can4 up
        [ 3795.951103] IPv6: ADDRCONF(NETDEV_CHANGE): can4: link becomes ready
        root@vck_190_lowspeed:~# ip link set can5 up
        [ 3802.735033] IPv6: ADDRCONF(NETDEV_CHANGE): can5: link becomes ready
        root@vck_190_lowspeed:~# ip -d -s link show can4
        6: can4: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
        link/can promiscuity 0 minmtu 0 maxmtu 0
        can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
        bitrate 1000000 sample-point 0.750
        tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
        xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
        dbitrate 4000000 dsample-point 0.750
        dtq 62 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
        xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
        clock 80000000
        re-started bus-errors arbit-lost error-warn error-pass bus-off
        0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
        RX: bytes packets errors dropped overrun mcast
        0 0 0 0 0 0
        TX: bytes packets errors dropped carrier collsns
        0 0 0 0 0 0
        root@vck_190_lowspeed:~# ip -d -s link show can5
        7: can5: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
        link/can promiscuity 0 minmtu 0 maxmtu 0
        can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
        bitrate 1000000 sample-point 0.750
        tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
        xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
        dbitrate 4000000 dsample-point 0.750
        dtq 62 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
        xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
        clock 80000000
        re-started bus-errors arbit-lost error-warn error-pass bus-off
        0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
        RX: bytes packets errors dropped overrun mcast
        0 0 0 0 0 0
        TX: bytes packets errors dropped carrier collsns
        0 0 0 0 0 0
        root@vck_190_lowspeed:~# ip -d -s link show can5
        7: can5: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
        link/can promiscuity 0 minmtu 0 maxmtu 0
        can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
        bitrate 1000000 sample-point 0.750
        tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
        xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
        dbitrate 4000000 dsample-point 0.750
        dtq 62 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
        xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
        clock 80000000
        re-started bus-errors arbit-lost error-warn error-pass bus-off
        0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
        RX: bytes packets errors dropped overrun mcast
        4 1 0 0 0 0
        TX: bytes packets errors dropped carrier collsns
        0 0 0 0 0 0
        root@vck_190_lowspeed:~# cansend can4 12345678##1212345678910111213141516171819202122
        root@vck_190_lowspeed:~# ip -d -s link show can5
        7: can5: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
        link/can promiscuity 0 minmtu 0 maxmtu 0
        can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
        bitrate 1000000 sample-point 0.750
        tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
        xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
        dbitrate 4000000 dsample-point 0.750
        dtq 62 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
        xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
        clock 80000000
        re-started bus-errors arbit-lost error-warn error-pass bus-off
        0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
        RX: bytes packets errors dropped overrun mcast
        24 2 0 0 0 0
        TX: bytes packets errors dropped carrier collsns
        0 0 0 0 0 0
        root@vck_190_lowspeed:~# cansend can5 12345678##1212345678910111213141516171819202122
        root@vck_190_lowspeed:~# ip -d -s link show can5
        7: can5: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
        link/can promiscuity 0 minmtu 0 maxmtu 0
        can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
        bitrate 1000000 sample-point 0.750
        tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
        xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
        dbitrate 4000000 dsample-point 0.750
        dtq 62 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
        xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
        clock 80000000
        re-started bus-errors arbit-lost error-warn error-pass bus-off
        0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
        RX: bytes packets errors dropped overrun mcast
        24 2 0 0 0 0
        TX: bytes packets errors dropped carrier collsns
        20 1 0 0 0 0
        root@vck_190_lowspeed:~# ip -d -s link show can4
        6: can4: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
        link/can promiscuity 0 minmtu 0 maxmtu 0
        can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
        bitrate 1000000 sample-point 0.750
        tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
        xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
        dbitrate 4000000 dsample-point 0.750
        dtq 62 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
        xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
        clock 80000000
        re-started bus-errors arbit-lost error-warn error-pass bus-off
        0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
        RX: bytes packets errors dropped overrun mcast
        20 1 0 0 0 0
        TX: bytes packets errors dropped carrier collsns
        24 2 0 0 0 0
        root@vck_190_lowspeed:~# ip link set can5 down
        root@vck_190_lowspeed:~# ip link set can4 down
        root@vck_190_lowspeed:~# ip link set can5 type can bitrate 1000000 dbitrate 6000000 fd on
        [ 4825.707085] xilinx_can a4060000.canfd can5: bitrate error 4.7%
        root@vck_190_lowspeed:~# ip link set can4 type can bitrate 1000000 dbitrate 6000000 fd on
        [ 4836.583092] xilinx_can a4050000.canfd can4: bitrate error 4.7%
        root@vck_190_lowspeed:~# ip link set can4 up
        root@vck_190_lowspeed:~# ip link set can5 up
        root@vck_190_lowspeed:~# ip -d -s link show can4
        6: can4: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
        link/can promiscuity 0 minmtu 0 maxmtu 0
        can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
        bitrate 1000000 sample-point 0.750
        tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
        xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
        dbitrate 5714285 dsample-point 0.714
        dtq 25 dprop-seg 2 dphase-seg1 2 dphase-seg2 2 dsjw 1
        xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
        clock 80000000
        re-started bus-errors arbit-lost error-warn error-pass bus-off
        0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
        RX: bytes packets errors dropped overrun mcast
        20 1 0 0 0 0
        TX: bytes packets errors dropped carrier collsns
        24 2 0 0 0 0
        root@vck_190_lowspeed:~# cansend can5 12345678##1212345678910111213141516171819202122
        root@vck_190_lowspeed:~# ip -d -s link show can4
        6: can4: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
        link/can promiscuity 0 minmtu 0 maxmtu 0
        can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
        bitrate 1000000 sample-point 0.750
        tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
        xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
        dbitrate 5714285 dsample-point 0.714
        dtq 25 dprop-seg 2 dphase-seg1 2 dphase-seg2 2 dsjw 1
        xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
        clock 80000000
        re-started bus-errors arbit-lost error-warn error-pass bus-off
        0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
        RX: bytes packets errors dropped overrun mcast
        40 2 0 0 0 0
        TX: bytes packets errors dropped carrier collsns
        24 2 0 0 0 0
        root@vck_190_lowspeed:~# cansend can4 12345678##1212345678910111213141516171819202122
        root@vck_190_lowspeed:~# ip -d -s link show can5
        7: can5: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
        link/can promiscuity 0 minmtu 0 maxmtu 0
        can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
        bitrate 1000000 sample-point 0.750
        tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
        xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
        dbitrate 5714285 dsample-point 0.714
        dtq 25 dprop-seg 2 dphase-seg1 2 dphase-seg2 2 dsjw 1
        xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
        clock 80000000
        re-started bus-errors arbit-lost error-warn error-pass bus-off
        0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
        RX: bytes packets errors dropped overrun mcast
        44 3 0 0 0 0
        TX: bytes packets errors dropped carrier collsns
        40 2 0 0 0 0
        root@vck_190_lowspeed:~# ip link set can4 down
        root@vck_190_lowspeed:~# ip link set can5 down
        root@vck_190_lowspeed:~# ip link set can4 type can bitrate 1000000 dbitrate 7000000 fd on
        [ 5195.815096] xilinx_can a4050000.canfd can4: bitrate error 4.7%
        root@vck_190_lowspeed:~# ip link set can5 type can bitrate 1000000 dbitrate 7000000 fd on
        [ 5204.411094] xilinx_can a4060000.canfd can5: bitrate error 4.7%
        root@vck_190_lowspeed:~# ip link set can4 up
        root@vck_190_lowspeed:~# ip link set can5 up
        root@vck_190_lowspeed:~# ip -d -s link show can4
        6: can4: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
        link/can promiscuity 0 minmtu 0 maxmtu 0
        can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
        bitrate 1000000 sample-point 0.750
        tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
        xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
        dbitrate 6666666 dsample-point 0.750
        dtq 37 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
        xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
        clock 80000000
        re-started bus-errors arbit-lost error-warn error-pass bus-off
        0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
        RX: bytes packets errors dropped overrun mcast
        40 2 0 0 0 0
        TX: bytes packets errors dropped carrier collsns
        44 3 0 0 0 0
        root@vck_190_lowspeed:~# ip -d -s link show can5
        7: can5: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
        link/can promiscuity 0 minmtu 0 maxmtu 0
        can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
        bitrate 1000000 sample-point 0.750
        tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
        xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
        dbitrate 6666666 dsample-point 0.750
        dtq 37 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
        xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
        clock 80000000
        re-started bus-errors arbit-lost error-warn error-pass bus-off
        0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
        RX: bytes packets errors dropped overrun mcast
        44 3 0 0 0 0
        TX: bytes packets errors dropped carrier collsns
        40 2 0 0 0 0
        root@vck_190_lowspeed:~# cansend can4 12345678##13AA12345678910111213141516171819202122
        root@vck_190_lowspeed:~# cansend can5 12345678##11345678910111213141516171819202122
        root@vck_190_lowspeed:~# ip -d -s link show can4
        6: can4: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
        link/can promiscuity 0 minmtu 0 maxmtu 0
        can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
        bitrate 1000000 sample-point 0.750
        tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
        xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
        dbitrate 6666666 dsample-point 0.750
        dtq 37 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
        xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
        clock 80000000
        re-started bus-errors arbit-lost error-warn error-pass bus-off
        0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
        RX: bytes packets errors dropped overrun mcast
        60 3 0 0 0 0
        TX: bytes packets errors dropped carrier collsns
        64 4 0 0 0 0
        root@vck_190_lowspeed:~# ip -d -s link show can5
        7: can5: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
        link/can promiscuity 0 minmtu 0 maxmtu 0
        can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
        bitrate 1000000 sample-point 0.750
        tq 25 prop-seg 14 phase-seg1 15 phase-seg2 10 sjw 1
        xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
        dbitrate 6666666 dsample-point 0.750
        dtq 37 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
        xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
        clock 80000000
        re-started bus-errors arbit-lost error-warn error-pass bus-off
        0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
        RX: bytes packets errors dropped overrun mcast
        64 4 0 0 0 0
        TX: bytes packets errors dropped carrier collsns
        60 3 0 0 0 0

### Vitis:

#### AXI-CANFD polled mode example

a. Loop back mode
Test case to prove loopback mode of AXI-CANFD IP(CANFD0 is used for testing)

Log:

      .515403]****************************************
      [7.156612]Xilinx Versal Platform Loader and Manager
      [11.778312]Release 2020.2 Nov 18 2020 - 14:54:52
      [16.398515]Platform Version: v2.0 PMC: v2.0, PS: v2.0
      [21.103659]BOOTMODE: 0, MULTIBOOT: 0x0
      [24.526906]****************************************
      [29.085271] 24.741862 ms for PrtnNum: 1, Size: 2368 Bytes
      [34.110906]-------Loading Prtn No: 0x2
      [38.073840] 0.522284 ms for PrtnNum: 2, Size: 48 Bytes
      [42.328040]-------Loading Prtn No: 0x3
      [79.370056] 33.597000 ms for PrtnNum: 3, Size: 57168 Bytes
      [81.695446]-------Loading Prtn No: 0x4
      [85.145603] 0.012528 ms for PrtnNum: 4, Size: 2512 Bytes
      [90.079753]-------Loading Prtn No: 0x5
      [93.531903] 0.014315 ms for PrtnNum: 5, Size: 3424 Bytes
      [98.464084]-------Loading Prtn No: 0x6
      [101.909546] 0.007784 ms for PrtnNum: 6, Size: 80 Bytes
      [106.812181]+++++++Loading Image No: 0x2, Name: pl_cfi, Id: 0x18700000
      [112.921881]-------Loading Prtn No: 0x7
      [995.802834] 879.351834 ms for PrtnNum: 7, Size: 1320080 Bytes
      [998.470381]-------Loading Prtn No: 0x8
      [1264.032171] 262.031787 ms for PrtnNum: 8, Size: 385488 Bytes
      [1266.732781]+++++++Loading Image No: 0x3, Name: fpd, Id: 0x0420C003
      [1272.687837]-------Loading Prtn No: 0x9
      [1276.461434] 0.163878 ms for PrtnNum: 9, Size: 1008 Bytes
      [1281.465106]***********Boot PDI Load: Done*************
      [1286.391709]3493.231821 ms: ROM Time 
      [1289.712640]Total PLM Boot Time
      Successfully ran AXI-XCanFd Polled Mode example

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

      .511484]****************************************
      [7.150228]Xilinx Versal Platform Loader and Manager
      [11.768331]Release 2020.2 Nov 18 2020 - 14:54:52
      [16.386084]Platform Version: v2.0 PMC: v2.0, PS: v2.0
      [21.088656]BOOTMODE: 0, MULTIBOOT: 0x0
      [24.508521]****************************************
      [29.062896] 24.719875 ms for PrtnNum: 1, Size: 2368 Bytes
      [34.086221]-------Loading Prtn No: 0x2
      [38.045778] 0.521871 ms for PrtnNum: 2, Size: 48 Bytes
      [42.295921]-------Loading Prtn No: 0x3
      [80.737256] 34.998615 ms for PrtnNum: 3, Size: 57168 Bytes
      [83.061912]-------Loading Prtn No: 0x4
      [86.511062] 0.012528 ms for PrtnNum: 4, Size: 2512 Bytes
      [91.442693]-------Loading Prtn No: 0x5
      [94.893640] 0.014315 ms for PrtnNum: 5, Size: 3424 Bytes
      [99.824440]-------Loading Prtn No: 0x6
      [103.268771] 0.007784 ms for PrtnNum: 6, Size: 80 Bytes
      [108.170396]+++++++Loading Image No: 0x2, Name: pl_cfi, Id: 0x18700000
      [114.278143]-------Loading Prtn No: 0x7
      [989.749668] 871.943028 ms for PrtnNum: 7, Size: 1320080 Bytes
      [992.416915]-------Loading Prtn No: 0x8
      [1258.848028] 262.902481 ms for PrtnNum: 8, Size: 385488 Bytes
      [1261.548243]+++++++Loading Image No: 0x3, Name: fpd, Id: 0x0420C003
      [1267.501646]-------Loading Prtn No: 0x9
      [1271.273850] 0.163837 ms for PrtnNum: 9, Size: 1008 Bytes
      [1276.275103]***********Boot PDI Load: Done*************
      [1281.199112]3503.562853 ms: ROM Time
      [1284.517818]Total PLM Boot Time
      Successfully ran XCanFd Interrupt Mode example

b. Normal mode
Test case to prove normal mode of AXI CANFD IP with external loopback(CANFD1 and CANFD2 are connected to form CAN bus for testing)

Log:

      [5.585237]****************************************
      [7.223381]Xilinx Versal Platform Loader and Manager
      [11.838853]Release 2020.2 Nov 18 2020 - 14:54:52
      [16.454675]Platform Version: v2.0 PMC: v2.0, PS: v2.0
      [21.154840]BOOTMODE: 0, MULTIBOOT: 0x0
      [24.573131]****************************************
      [29.126518] 24.783471 ms for PrtnNum: 1, Size: 2368 Bytes
      [34.147625]-------Loading Prtn No: 0x2
      [38.107200] 0.521803 ms for PrtnNum: 2, Size: 48 Bytes
      [42.357878]-------Loading Prtn No: 0x3
      [78.824800] 33.025343 ms for PrtnNum: 3, Size: 57168 Bytes
      [81.147746]-------Loading Prtn No: 0x4
      [84.594984] 0.012528 ms for PrtnNum: 4, Size: 2512 Bytes
      [89.525156]-------Loading Prtn No: 0x5
      [92.975156] 0.014315 ms for PrtnNum: 5, Size: 3424 Bytes
      [97.904196]-------Loading Prtn No: 0x6
      [101.346862] 0.007784 ms for PrtnNum: 6, Size: 80 Bytes
      [106.247343]+++++++Loading Image No: 0x2, Name: pl_cfi, Id: 0x18700000
      [112.354046]-------Loading Prtn No: 0x7
      [994.975396] 879.093878 ms for PrtnNum: 7, Size: 1320080 Bytes
      [997.641593]-------Loading Prtn No: 0x8
      [1261.751853] 260.582953 ms for PrtnNum: 8, Size: 385488 Bytes
      [1264.452446]+++++++Loading Image No: 0x3, Name: fpd, Id: 0x0420C003
      [1270.405121]-------Loading Prtn No: 0x9
      [1274.177118] 0.163946 ms for PrtnNum: 9, Size: 1008 Bytes
      [1279.179815]***********Boot PDI Load: Done*************
      [1284.103790]3521.356059 ms: ROM Time
      [1287.423243]Total PLM Boot Time
      Successfully ran AXI-XCanFd Interrupt Mode example with external loopback

## Known Issues
In this section, list any known issues with the design, or any warning messages that might appear which can be safely ignored by the customer.

Copyright 2020 Xilinx Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
