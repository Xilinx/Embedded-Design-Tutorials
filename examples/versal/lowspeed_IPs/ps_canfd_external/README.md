## Introduction:
The purpose of this example is to prove the PS CANFD communication with external hardware setup.
This was tested with the help of Canoe analyzer as external device with baud-rate of arbitration phase of 1Mbps and data phase 5Mbps only on VCK190 evaluation kit,PS CANFD can be supported up to 8Mbps but due to the NXP PHY limitations on VCK190 it was tested upto 5Mbps.

## Pre-requisites:
- VCK190 EVK
- Petalinux 2022.1
- Vivado 2022.1
- CAN analyzer Setup (Ex: Canoe, PCAN)
## Hardware setup:
 ![image](https://user-images.githubusercontent.com/74894579/167302007-94ad3539-2fbc-476e-a936-72ea9a4bd9e1.png)

- VCK190 board with NXP PHY
- Length of wires –  ~30cm
- Termination resistors (120 Ohms) at the CANoe Analyzer side
## Block design:
![image](https://user-images.githubusercontent.com/74894579/167302063-c3736581-ed66-4e0b-8d29-4f91523fa0d3.png)
## IP Settings:
Enable CANFD1 in CIPS and change the requested frequency to 160Mhz and generate PDI and XSA
![image](https://user-images.githubusercontent.com/74894579/167302091-f03dd15d-ef36-40cd-8c64-23c762b382e7.png)
## Commands to be used:
- export CAN_BUS=can0
- ip link set $CAN_BUS down
- ip link set $CAN_BUS type can tq 12 prop-seg 39 phase-seg1 20 phase-seg2 20 sjw 20 dtq 12 dprop-seg 5 dphase-seg1 6 dphase-seg2 4 dsjw 4 fd on          
- ip link set $CAN_BUS up
- ifconfig $CAN_BUS txqueuelen 1000
- ip -d -s link show $CAN_BUS
- cangen $CAN_BUS -b -f -g 0 -e -i -n 1
- cangen $CAN_BUS -b -f -g 0 -e -i &

## Petalinux log
###### To figure out the CAN/CANFD network nodes presented in the design.
```
root@VCK190CANFD:~# ifconfig -a
can0      Link encap:UNSPEC  HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00
          NOARP  MTU:16  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:10
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
          Interrupt:15
```
###### Default CAN node status
```
root@VCK190CANFD:~# export CAN_BUS=can0
root@VCK190CANFD:~# ip -d -s link show $CAN_BUS
3: can0: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT group default qlen 10
    link/can  promiscuity 0 minmtu 0 maxmtu 0
    can state STOPPED (berr-counter tx 0 rx 0) restart-ms 0
          xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 1..256 brp-inc 1
          xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 1..256 dbrp-inc 1
          clock 79999920
          re-started bus-errors arbit-lost error-warn error-pass bus-off
          0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 parentbus platform parentdev ff070000.can
    RX:  bytes packets errors dropped  missed   mcast
             0       0      0       0       0       0
    TX:  bytes packets errors dropped carrier collsns
             0       0      0       0       0       0

```
###### CAN/CANFD node baud rate settings in the VCK190
```
root@VCK190CANFD:~# ip link set $CAN_BUS type can tq 12 prop-seg 39 phase-seg1 20 phase-seg2 20 sjw 20 dtq 12 dprop-seg 5 dphase-seg1 6 dphase-seg2 4 dsjw 4 fd on
root@VCK190CANFD:~# ip -d -s link show $CAN_BUS
3: can0: <NOARP,ECHO> mtu 72 qdisc noop state DOWN mode DEFAULT group default qlen 10
    link/can  promiscuity 0 minmtu 0 maxmtu 0
    can <FD> state STOPPED (berr-counter tx 0 rx 0) restart-ms 0
          bitrate 999999 sample-point 0.750
          tq 12 prop-seg 39 phase-seg1 20 phase-seg2 20 sjw 20
          xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 1..256 brp-inc 1
          dbitrate 4999995 dsample-point 0.750
          dtq 12 dprop-seg 5 dphase-seg1 6 dphase-seg2 4 dsjw 4
          xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 1..256 dbrp-inc 1
          clock 79999920
          re-started bus-errors arbit-lost error-warn error-pass bus-off
          0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 parentbus platform parentdev ff070000.can
    RX:  bytes packets errors dropped  missed   mcast
             0       0      0       0       0       0
    TX:  bytes packets errors dropped carrier collsns
             0       0      0       0       0       0
root@VCK190CANFD:~# ifconfig $CAN_BUS txqueuelen 1000

```
###### CANoe node baud rate settings
![image](https://user-images.githubusercontent.com/74894579/167305666-cfea5fab-013e-4391-8dd8-a5e0ad9e081e.png)
###### To up the VCK190 CANFD node
```
root@VCK190CANFD:~# ip link set $CAN_BUS up
[ 1374.468628] IPv6: ADDRCONF(NETDEV_CHANGE): can0: link becomes ready
root@VCK190CANFD:~# ip -d -s link show $CAN_BUS
3: can0: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
    link/can  promiscuity 0 minmtu 0 maxmtu 0
    can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
          bitrate 999999 sample-point 0.750
          tq 12 prop-seg 39 phase-seg1 20 phase-seg2 20 sjw 20
          xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 1..256 brp-inc 1
          dbitrate 4999995 dsample-point 0.750
          dtq 12 dprop-seg 5 dphase-seg1 6 dphase-seg2 4 dsjw 4
          xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 1..256 dbrp-inc 1
          clock 79999920
          re-started bus-errors arbit-lost error-warn error-pass bus-off
          0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 parentbus platform parentdev ff070000.can
    RX:  bytes packets errors dropped  missed   mcast
             0       0      0       0       0       0
    TX:  bytes packets errors dropped carrier collsns
             0       0      0       0       0       0
```
###### Transmit messages from CANoe to VCK190
![image](https://user-images.githubusercontent.com/74894579/167306534-2e4d3c21-6705-4b53-b199-581b6b017bb9.png)
###### VCK190 Status after receiving the messages from CANoe
```
root@VCK190CANFD:~# ip link set $CAN_BUS up
[ 1374.468628] IPv6: ADDRCONF(NETDEV_CHANGE): can0: link becomes ready
root@VCK190CANFD:~# ip -d -s link show $CAN_BUS
3: can0: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
    link/can  promiscuity 0 minmtu 0 maxmtu 0
    can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
          bitrate 999999 sample-point 0.750
          tq 12 prop-seg 39 phase-seg1 20 phase-seg2 20 sjw 20
          xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 1..256 brp-inc 1
          dbitrate 4999995 dsample-point 0.750
          dtq 12 dprop-seg 5 dphase-seg1 6 dphase-seg2 4 dsjw 4
          xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 1..256 dbrp-inc 1
          clock 79999920
          re-started bus-errors arbit-lost error-warn error-pass bus-off
          0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 parentbus platform parentdev ff070000.can
    RX:  bytes packets errors dropped  missed   mcast
       2164376   36964      0       0       0       0
    TX:  bytes packets errors dropped carrier collsns
             0       0      0       0       0       0
 ```
###### Transmit CANFD messages from VCK190 to CANoe
root@VCK190CANFD:~# cangen $CAN_BUS -b -f -g 0 -e -i &
###### Transmit CAN messages from VCK190 to CANoe
root@VCK190CANFD:~# cangen $CAN_BUS -g 0 -e -i &
```
root@VCK190CANFD:~# ip -d -s link show $CAN_BUS
3: can0: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
    link/can  promiscuity 0 minmtu 0 maxmtu 0
    can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
          bitrate 999999 sample-point 0.750
          tq 12 prop-seg 39 phase-seg1 20 phase-seg2 20 sjw 20
          xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 1..256 brp-inc 1
          dbitrate 4999995 dsample-point 0.750
          dtq 12 dprop-seg 5 dphase-seg1 6 dphase-seg2 4 dsjw 4
          xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 1..256 dbrp-inc 1
          clock 79999920
          re-started bus-errors arbit-lost error-warn error-pass bus-off
          0          0          0          0          0          0         numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 parentbus platform parentdev ff070000.can
    RX:  bytes packets errors dropped  missed   mcast
       2164376   36964      0       0       0       0
    TX:  bytes packets errors dropped carrier collsns
       8047430  509840      0       0       0       0
 ```
###### CANFD messages from VCK190 to CANoe
 ![image](https://user-images.githubusercontent.com/74894579/167306704-bf39da75-cdef-458d-8de9-bbe7bd2fd9b5.png)
###### CAN messages from VCK190 to CANoe
![image](https://user-images.githubusercontent.com/74894579/167306976-fad4960b-b791-47ae-8b30-719e4e90e30c.png)

###### TX/RX messages
![image](https://user-images.githubusercontent.com/74894579/167307389-d8d7b3a0-38b2-4019-922c-239cc259ce73.png)



