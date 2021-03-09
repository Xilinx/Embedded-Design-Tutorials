# Evaluating High-Performance Ports

 A great benefit provided by System Performance Modeling (SPM) is to
 perform what if scenarios of Processing System (PS) and Programmable
 Logic (PL) activity and their interaction. This is a feature that
 enables you to explore performance before beginning the design phase,
 thus reducing the likelihood of finding performance issues late in the
 design. Although contention on the Zynq®-7000 SoC device is not
 directly visualized, its impact on system performance is displayed.

 You can configure the SPM design to model specific traffic scenarios
 while running a software application in the PS. You can then use PL
 master performance metrics, such as throughput and latency, to verify
 that the desired system performance can be sustained in such an
 environment. This process can be repeated multiple times using
 different traffic scenarios.

 One critical shared resource on the Zynq-7000 SoC device is the DDR
 controller. This resource is shared by both CPUs, the four
 High-Performance (HP) ports, the Accelerator Coherency Port (ACP), and
 other masters via the central interconnect (see [Chapter 7: Evaluating DDR Controller Settings](#chapter-7) for more details). Because of this sharing, it is important to understand the available
 DDR bandwidth.

 You can calculate the total theoretical bandwidth of the DDR using the
 following equation:

 `(533.3 Mcycles)/sec x (2 tranx)/cycle× (4 bytes)/tranx=4270 MB/s`

 While this is the maximum bandwidth achievable by this memory, the
 actual DDR utilization is based on many factors, including number of
 requesting masters and the types of memory accesses. As shown in this
 chapter, requesting bandwidth that approaches or exceeds this maximum
 will potentially impact the achieved throughput and latency of all
 requesting masters. The System Performance Analysis (SPA) toolbox in
 the Vitis™ IDE aids in this analysis.

## HD Video Traffic

 The software application used was the BEEBS benchmark program
 described in [SPM Software](#spm-software). See [Figure 9: Application Setup in the Vitis IDE Configuration Wizard](#figure-9-application-setup-in-the-vitis-ide-configuration-wizard),
 which shows how this can be specified in the Vitis IDE. In this
 scenario, traffic on the four High Performance (HP) ports was injected
 into the system, and software and hardware performance metrics are
 measured in the Vitis IDE. This models a system that is performing
 complex algorithms in software while simultaneously processing HD
 video streams in the PL. Rather than design a system that implements
 this processing, you can instead model the performance using SPM. You
 can quickly verify that your desired performance is achieved before
 beginning your design.

 The following figure shows the first traffic scenario used (see
 [Chapter 4: Getting Started with SPM](#_bookmark17) for a description of this traffic specification). This scenario models four uncompressed 1080p/60 (that is, 1080 lines, progressive, and 60 frames/s) HD video streams. Two streams are being read from the DDR on
 ports HP0 and HP2, while two are being written on ports HP1 and HP3.
 For all of these modeled video streams, the Tranx Interval was chosen
 to request 376 MB/s, the estimated throughput of the uncompressed RGB
 4:4:4 video.

 *Figure 18:* ATG Traffic Configuration Modeling HD Video Streams on HP Ports

![](./media/image18.jpeg)

 This HD video traffic was run on a ZC702 board. As shown in the
 following figure, all four HP ports were able to sustain the requested
 throughput of 376 MB/s. These high throughputs were even achieved
 while the BEEBS benchmarks were running on CPU0. The total bandwidth
 used by the four HP ports was 1510 MB/s, or 35% of the available
 bandwidth of the DDR. Thus, the Zynq-7000 SoC device was capable of
 achieving these throughputs. However, due to arbitration and
 scheduling in the DDR controller, some contention was introduced,
 impacting the

 performance of the software application (see [Figure 24: Relative Run-Times of BEEBS Benchmarks with Varying HP Port Traffic (Data Array Size: 1024
 KB](#figure-24-relative-run-times-of-beebs-benchmarks-with-varying-hp-port-traffic-data-array-size-1024-kb) for a summary). Most benchmarks had minimal impact on their run-time;
 however, the benchmarks that have a high number of memory accesses
 were impacted the most. The worst case was the integer matrix
 multiplication, which had a run-time increase of 14.0%.

 *Figure 19:* Summary of Performance Results from Modeling HD Video Streams on HP Ports

![](./media/image19.jpeg)

## High-Bandwidth Traffic

 The traffic modeling concept described in [HD Video
 Traffic](#hd-video-traffic) can be extended. You can run the same
 BEEBS benchmarks but with a different traffic scenario on the HP
 ports.

 The following figure shows traffic that executes a stress test to see
 how high-bandwidth traffic can affect performance. All four HP ports
 request 512 MB/s for both read and write traffic using incremental
 addressing to the DDR. The total duration was set to 80 seconds to
 ensure that the traffic duration coincided with the entire length of
 the BEEBS benchmark application.
 [Figure 13: CPU Utilization Labeled with BEEBS Benchmarks](#figure-13-cpu-utilization-labeled-with-beebs-benchmarks) helps orient the timeline for the results.

 *Figure 20:* ATG Traffic Configuration Modeling High-Bandwidth Traffic on HP Ports

![](./media/image20.jpeg)

 The total throughput requested by HP masters is 8 \* 512 = 4096 MB/s,
 or 95.9% of the theoretical maximum throughput of the DDR. Because the
 traffic contains both write and read requests, the DDR controller is
 further stressed because it needs to arbitrate between not just
 multiple requestors but also different types of requests. Therefore,
 consider this a stress test of the achievable DDR bandwidth. While
 this traffic represents a worst-case scenario, it is important to
 perform to visualize the backpressure that occurs when more bandwidth
 is requested than what the memory can provide.

 *Figure 21:* Summary of Performance Results from Modeling High-Bandwidth Traffic on HP Ports

![](./media/image21.jpeg)

 Using the SPM design in the Vitis IDE, this type of stress test can be
 easily performed. The BEEBS benchmark application was run on CPU0
 while the ATGs are configured by the Vitis IDE to run the requested
 traffic shown in [Figure 20: ATG Traffic Configuration Modeling High-Bandwidth Traffic on HP Ports](#figure-20-atg-traffic-configuration-modeling-high-bandwidth-traffic-on-hp-ports).
 A summary of the performance results from this traffic scenario is
 shown in [Figure 21: Summary of Performance Results from Modeling High-Bandwidth Traffic on HP Ports](#figure-21-summary-of-performance-results-from-modeling-high-bandwidth-traffic-on-hp-ports).
 As expected, the requested throughput of 512 MB/s per HP port is not
 achieved; however, a very high total throughput is indeed achieved.
 The total read/write bandwidth allocated to the HP ports can be
 calculated as follows:

 `Total bandwidth=457.1 + 457.3 + 457 + 457.3 + 438.6 + 438.7 + 440.8 + 441.1= 3587.9 MB/s`

 While this bandwidth is 84% of the theoretical maximum from , there is
 also the bandwidth allocated to CPU0 running the BEEBS benchmark
 suite. This stress test confirms the arbitration used by the DDR
 controller for write and read traffic across four HP ports. Note that
 exclusively write or read traffic could also be used, increasing the
 bandwidth performance of the DDR controller.

 Because both write and read traffic is being specified, it is
 important to analyze the performance of both types of transactions.
 The following figure shows the performance of the write AXI
 transactions in the PL Performance panel. The three graphs shown
 include: Write Transactions, Average Write Latency, and Write
 Throughput. The write throughput and latency are relatively consistent
 on all four HP ports across the entire test run, with a slight drop in
 the average value and some variance introduced at about 3.2s.

 *Figure 22:* Write Performance Results of High-Bandwidth Traffic on HP Ports with BEEBS Benchmarks Running

![](./media/image22.jpeg)

 The read throughput and latency of the HP ports show a more noticeable
 drop in performance during the matrix multiplications (see the
 following figure). During all other tests, the read bandwidths are
 about 420 MB/s, while during the memory-intensive matrix multipliers
 (using the 1024 KB data array) the throughput drops to about 340 MB/s.
 Hovering the mouse over the graph will confirm the fact. At an elapsed
 time of 64 sec, the read throughputs of the four HP ports are all
 about 338 MB/s. This decrease in throughput coincides with an increase
 in latency, both caused by saturation at the DDR controller.

 *Figure 23:* Read Performance Results of High-Bandwidth Traffic on HP Ports with BEEBS Benchmarks Running

![](./media/image23.jpeg)

 You can also use the Trace Tooltip button to report performance metric
 values at a specific point in time. When the tooltip is shown, you can
 move it to any point in time on any graph, and it will display the
 specified metric values. This is very helpful in pinpointing the
 performance at precise points in time.

 The impact of increased HP traffic can be seen in the software
 performance. A useful metric of this performance is run time. Using
 the instrumentation (see [Instrumenting Hardware](#instrumenting-hardware)) that was added to the BEEBS software, the following figure shows the relative run times of the
 eight benchmarks using the 1024 KB data array size. The run time of
 each benchmark with no traffic was normalized to 1.0. Because this
 large array requires accesses to the DDR, any increase in software run
 time would be attributed to the DDR saturation. The matrix
 multiplications experience the largest increases in software run
 times. The Cyclic Redundancy Check (CRC) algorithm also has a
 noticeable impact on run time, most likely due to the increased memory
 reads of the data array as well as the CRC polynomial table. All other
 benchmarks see minimal impact on performance, even with the
 high-throughput traffic on all four HP ports.

 *Figure 24:* Relative Run-Times of BEEBS Benchmarks with Varying HP Port Traffic (Data Array Size: 1024 KB)

![](./media/image24.png)