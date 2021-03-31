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

        root@vck_190_lowspeed:~# /sys/class/net/can0/device/driver/
        a4010000.can/ a4020000.can/ a4030000.can/ a4040000.canfd/ a4050000.canfd/ a4060000.canfd/ ff060000.can/ ff070000.can/
        root@vck_190_lowspeed:~# ifconfig -a | grep can
        can6 Link encap:UNSPEC HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  → ff060000.can/   ==> PS-CANFD0
        can7 Link encap:UNSPEC HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  → ff070000.can/   ==> PS-CANFD1

 #### PS-CANFD LOOP BACK
 
  a. This test case done on PS_CANFD0(CAN6) uses internal loopback mode available in the software configuration register no external loop back b/w TX and RX.
  
   Log:

        root@vck_190_lowspeed:~# ip -d -s link show can6
        9: can6: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT group default qlen 10
        link/can promiscuity 0 minmtu 0 maxmtu 0
        can state STOPPED (berr-counter tx 0 rx 0) restart-ms 0
        xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
        xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
        clock 49999999
        re-started bus-errors arbit-lost error-warn error-pass bus-off
        0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
        RX: bytes packets errors dropped overrun mcast
        0 0 0 0 0 0
        TX: bytes packets errors dropped carrier collsns
        0 0 0 0 0 0
        root@vck_190_lowspeed:~# ip link set can6 type can bitrate 1000000 dbitrate 6000000 fd on loopback on
        [ 5648.887169] xilinx_can ff060000.can can6: bitrate error 0.0%
        [ 5648.892852] xilinx_can ff060000.can can6: bitrate error 4.1%
        root@vck_190_lowspeed:~# ifconfig can6 txqueuelen 1000
        root@vck_190_lowspeed:~# ip link set can6 type can bitrate 1000000 dbitrate 6500000 fd on loopback on
        [ 5900.983150] xilinx_can ff060000.can can6: bitrate error 0.0%
        [ 5900.988832] xilinx_can ff060000.can can6: bitrate error 3.8%
        root@vck_190_lowspeed:~# ip link set can6 up
        [ 5935.819228] IPv6: ADDRCONF(NETDEV_CHANGE): can6: link becomes ready
        root@vck_190_lowspeed:~# ip -d -s link show can6
        9: can6: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
        link/can promiscuity 0 minmtu 0 maxmtu 0
        can <LOOPBACK,FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
        bitrate 999999 sample-point 0.720
        tq 40 prop-seg 8 phase-seg1 9 phase-seg2 7 sjw 1
        xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
        dbitrate 6249999 dsample-point 0.750
        dtq 40 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
        xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
        clock 49999999
        re-started bus-errors arbit-lost error-warn error-pass bus-off
        0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
        RX: bytes packets errors dropped overrun mcast
        0 0 0 0 0 0
        TX: bytes packets errors dropped carrier collsns
        0 0 0 0 0 0
        root@vck_190_lowspeed:~# cansend can6 123#112233
        root@vck_190_lowspeed:~# ip -d -s link show can6
        9: can6: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
        link/can promiscuity 0 minmtu 0 maxmtu 0
        can <LOOPBACK,FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
        bitrate 99999 sample-point 0.872
        tq 80 prop-seg 54 phase-seg1 54 phase-seg2 16 sjw 1
        xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
        dbitrate 4166666 dsample-point 0.750
        dtq 60 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
        xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
        clock 49999999
        re-started bus-errors arbit-lost error-warn error-pass bus-off
        0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
        RX: bytes packets errors dropped overrun mcast
        3 1 0 0 0 0
        TX: bytes packets errors dropped carrier collsns
        3 1 0 0 0 0
        root@vck_190_lowspeed:~# cansend can6 12345678#F112233445566778899AABBCCDDEEFF
        root@vck_190_lowspeed:~# ip -d -s link show can6
        9: can6: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
        link/can promiscuity 0 minmtu 0 maxmtu 0
        can <LOOPBACK,FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
        bitrate 99999 sample-point 0.872
        tq 80 prop-seg 54 phase-seg1 54 phase-seg2 16 sjw 1
        xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
        dbitrate 4166666 dsample-point 0.750
        dtq 60 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
        xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
        clock 49999999
        re-started bus-errors arbit-lost error-warn error-pass bus-off
        0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
        RX: bytes packets errors dropped overrun mcast
        11 2 0 0 0 0
        TX: bytes packets errors dropped carrier collsns
        11 2 0 0 0 0
        root@vck_190_lowspeed:~# cansend can6 12345678##F112233445566778899AABBCCDDEEFF
        root@vck_190_lowspeed:~# ip -d -s link show can6
        9: can6: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
        link/can promiscuity 0 minmtu 0 maxmtu 0
        can <LOOPBACK,FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
        bitrate 99999 sample-point 0.872
        tq 80 prop-seg 54 phase-seg1 54 phase-seg2 16 sjw 1
        xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
        dbitrate 4166666 dsample-point 0.750
        dtq 60 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
        xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
        clock 49999999
        re-started bus-errors arbit-lost error-warn error-pass bus-off
        0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
        RX: bytes packets errors dropped overrun mcast
        27 3 0 0 0 0
        TX: bytes packets errors dropped carrier collsns
        27 3 0 0 0 0
	
#### PS-CANFD NORMAL MODE 

 a. PS-CANFD_0(CAN6) and PS_CANFD_1(CAN7) are connected  node to node on the bus to prove the communication b/w the nodes in normal mode.

  Log

        root@vck_190_lowspeed:~# ip -d -s link show can6
        9: can6: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT group default qlen 10
        link/can promiscuity 0 minmtu 0 maxmtu 0
        can state STOPPED (berr-counter tx 0 rx 0) restart-ms 0
        xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
        xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
        clock 49999999
        re-started bus-errors arbit-lost error-warn error-pass bus-off
        0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
        RX: bytes packets errors dropped overrun mcast
        0 0 0 0 0 0
        TX: bytes packets errors dropped carrier collsns
        0 0 0 0 0 0
        root@vck_190_lowspeed:~# ip -d -s link show can7
        10: can7: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT group default qlen 10
        link/can promiscuity 0 minmtu 0 maxmtu 0
        can state STOPPED (berr-counter tx 0 rx 0) restart-ms 0
        xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
        xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
        clock 49999999
        re-started bus-errors arbit-lost error-warn error-pass bus-off
        0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
        RX: bytes packets errors dropped overrun mcast
        0 0 0 0 0 0
        TX: bytes packets errors dropped carrier collsns
        0 0 0 0 0 0
        root@vck_190_lowspeed:~# ip link set can6 type can bitrate 100000 dbitrate 4000000 fd on
        [ 122.063396] xilinx_can ff060000.can can6: bitrate error 0.0%
        [ 122.069081] xilinx_can ff060000.can can6: bitrate error 4.1%
        root@vck_190_lowspeed:~# ip link set can7 type can bitrate 100000 dbitrate 4000000 fd on
        [ 127.503357] xilinx_can ff070000.can can7: bitrate error 0.0%
        [ 127.509034] xilinx_can ff070000.can can7: bitrate error 4.1%
        root@vck_190_lowspeed:~# ifconfig can6 txqueuelen 1000
        root@vck_190_lowspeed:~# ifconfig can7 txqueuelen 1000
        root@vck_190_lowspeed:~# ip link set can0 up
        [ 262.767249] xilinx_can a4010000.can can0: bit-timing not yet defined
        RTNETLINK answers: Invalid argument
        root@vck_190_lowspeed:~# ip link set can6 up
        [ 267.279380] IPv6: ADDRCONF(NETDEV_CHANGE): can6: link becomes ready
        root@vck_190_lowspeed:~# ip link set can7 up
        [ 272.395372] IPv6: ADDRCONF(NETDEV_CHANGE): can7: link becomes ready
        root@vck_190_lowspeed:~# cansend can6 123#1122334455
        root@vck_190_lowspeed:~# ip -d -s link show can6
        9: can6: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
        link/can promiscuity 0 minmtu 0 maxmtu 0
        can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
        bitrate 99999 sample-point 0.872
        tq 80 prop-seg 54 phase-seg1 54 phase-seg2 16 sjw 1
        xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
        dbitrate 4166666 dsample-point 0.750
        dtq 60 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
        xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
        clock 49999999
        re-started bus-errors arbit-lost error-warn error-pass bus-off
        0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
        RX: bytes packets errors dropped overrun mcast
        0 0 0 0 0 0
        TX: bytes packets errors dropped carrier collsns
        5 1 0 0 0 0
        root@vck_190_lowspeed:~# ip -d -s link show can7
        10: can7: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
        link/can promiscuity 0 minmtu 0 maxmtu 0
        can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
        bitrate 99999 sample-point 0.872
        tq 80 prop-seg 54 phase-seg1 54 phase-seg2 16 sjw 1
        xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
        dbitrate 4166666 dsample-point 0.750
        dtq 60 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
        xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
        clock 49999999
        re-started bus-errors arbit-lost error-warn error-pass bus-off
        0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
        RX: bytes packets errors dropped overrun mcast
        5 1 0 0 0 0
        TX: bytes packets errors dropped carrier collsns
        0 0 0 0 0 0
        root@vck_190_lowspeed:~# cansend can6 12345678##9112233445566778899
        root@vck_190_lowspeed:~# ip -d -s link show can6
        9: can6: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
        link/can promiscuity 0 minmtu 0 maxmtu 0
        can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
        bitrate 99999 sample-point 0.872
        tq 80 prop-seg 54 phase-seg1 54 phase-seg2 16 sjw 1
        xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
        dbitrate 4166666 dsample-point 0.750
        dtq 60 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
        xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
        clock 49999999
        re-started bus-errors arbit-lost error-warn error-pass bus-off
        0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
        RX: bytes packets errors dropped overrun mcast
        0 0 0 0 0 0
        TX: bytes packets errors dropped carrier collsns
        17 2 0 0 0 0
        root@vck_190_lowspeed:~# ip -d -s link show can7
        10: can7: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
        link/can promiscuity 0 minmtu 0 maxmtu 0
        can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
        bitrate 99999 sample-point 0.872
        tq 80 prop-seg 54 phase-seg1 54 phase-seg2 16 sjw 1
        xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
        dbitrate 4166666 dsample-point 0.750
        dtq 60 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
        xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
        clock 49999999
        re-started bus-errors arbit-lost error-warn error-pass bus-off
        0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
        RX: bytes packets errors dropped overrun mcast
        17 2 0 0 0 0
        TX: bytes packets errors dropped carrier collsns
        0 0 0 0 0 0
        root@vck_190_lowspeed:~# cansend can7 12345678##A112233445566778899AA
        root@vck_190_lowspeed:~# ip -d -s link show can6
        9: can6: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
        link/can promiscuity 0 minmtu 0 maxmtu 0
        can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
        bitrate 99999 sample-point 0.872
        tq 80 prop-seg 54 phase-seg1 54 phase-seg2 16 sjw 1
        xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
        dbitrate 4166666 dsample-point 0.750
        dtq 60 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
        xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
        clock 49999999
        re-started bus-errors arbit-lost error-warn error-pass bus-off
        0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
        RX: bytes packets errors dropped overrun mcast
        12 1 0 0 0 0
        TX: bytes packets errors dropped carrier collsns
        17 2 0 0 0 0
        root@vck_190_lowspeed:~# ip -d -s link show can7
        10: can7: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
        link/can promiscuity 0 minmtu 0 maxmtu 0
        can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
        bitrate 99999 sample-point 0.872
        tq 80 prop-seg 54 phase-seg1 54 phase-seg2 16 sjw 1
        xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
        dbitrate 4166666 dsample-point 0.750
        dtq 60 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
        xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
        clock 49999999
        re-started bus-errors arbit-lost error-warn error-pass bus-off
        0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
        RX: bytes packets errors dropped overrun mcast
        17 2 0 0 0 0
        TX: bytes packets errors dropped carrier collsns
        12 1 0 0 0 0
        root@vck_190_lowspeed:~#
        root@vck_190_lowspeed:~# ip link set can7 down
        root@vck_190_lowspeed:~# ip link set can7 type can bitrate 100000 dbitrate 5000000 fd on
        [ 625.567384] xilinx_can ff070000.can can7: bitrate error 0.0%
        [ 625.573066] xilinx_can ff070000.can can7: bitrate error 0.0%
        root@vck_190_lowspeed:~# ip link set can7 up
        root@vck_190_lowspeed:~# ip -d -s link show can7
        10: can7: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
        link/can promiscuity 0 minmtu 0 maxmtu 0
        can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
        bitrate 99999 sample-point 0.872
        tq 80 prop-seg 54 phase-seg1 54 phase-seg2 16 sjw 1
        xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
        dbitrate 4999999 dsample-point 0.600
        dtq 40 dprop-seg 1 dphase-seg1 1 dphase-seg2 2 dsjw 1
        xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
        clock 49999999
        re-started bus-errors arbit-lost error-warn error-pass bus-off
        0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
        RX: bytes packets errors dropped overrun mcast
        17 2 0 0 0 0
        TX: bytes packets errors dropped carrier collsns
        12 1 0 0 0 0
        root@vck_190_lowspeed:~# cansend can7 12345678##A112233445566778899AA
        root@vck_190_lowspeed:~# ip -d -s link show can7
        10: can7: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
        link/can promiscuity 0 minmtu 0 maxmtu 0
        can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
        bitrate 99999 sample-point 0.872
        tq 80 prop-seg 54 phase-seg1 54 phase-seg2 16 sjw 1
        xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
        dbitrate 4999999 dsample-point 0.600
        dtq 40 dprop-seg 1 dphase-seg1 1 dphase-seg2 2 dsjw 1
        xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
        clock 49999999
        re-started bus-errors arbit-lost error-warn error-pass bus-off
        0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
        RX: bytes packets errors dropped overrun mcast
        17 2 0 0 0 0
        TX: bytes packets errors dropped carrier collsns
        24 2 0 0 0 0
        root@vck_190_lowspeed:~# ip link set can7 down
        root@vck_190_lowspeed:~# ip link set can7 type can bitrate 100000 dbitrate 6000000 fd on
        [ 679.131430] xilinx_can ff070000.can can7: bitrate error 0.0%
        [ 679.137113] xilinx_can ff070000.can can7: bitrate error 4.1%
        root@vck_190_lowspeed:~# ip link set can7 up
        root@vck_190_lowspeed:~# cansend can7 12345678##A112233445566778899AA
        root@vck_190_lowspeed:~# ip -d -s link show can7
        10: can7: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
        link/can promiscuity 0 minmtu 0 maxmtu 0
        can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
        bitrate 99999 sample-point 0.872
        tq 80 prop-seg 54 phase-seg1 54 phase-seg2 16 sjw 1
        xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
        dbitrate 6249999 dsample-point 0.750
        dtq 40 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
        xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
        clock 49999999
        re-started bus-errors arbit-lost error-warn error-pass bus-off
        0 0 0 0 0 0 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
        RX: bytes packets errors dropped overrun mcast
        17 2 0 0 0 0
        TX: bytes packets errors dropped carrier collsns
        36 3 0 0 0 0
  

### Vitis:

The bare-metal test cases are similar to AXI_CANFD requesting to refer the follwoing link https://gitenterprise.xilinx.com/Xilinx-Wiki-Projects/VCK190_LowSpeed_IPs/tree/master/axi_can_fd/software/vitis 

With minimum changes in the examples user can use the same for PS-CANFD.

## Known Issues
In this section, list any known issues with the design, or any warning messages that might appear which can be safely ignored by the customer.

Copyright 2020 Xilinx Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

