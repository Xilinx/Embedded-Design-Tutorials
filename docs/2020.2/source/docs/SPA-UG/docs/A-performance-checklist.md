# Performance Checklist

The goal of this appendix is to provide you with a checklist of items to consider when evaluating the performance of your Zynq®-7000 SoC design. This should by no means be considered an exhaustive list, but
instead a starting point for things to look out for and possible "gotchas" that are not easy to find. The Vitis™ IDE can also be a helpful tool in evaluating your system performance, and some of its features and benefits are also highlighted here.

- **Use SPM:** SPM is ideal for investigating system performance
     without any reliance on prior hardware design work or knowledge.
     The SPM can deliver assurance that your performance goals will be
     met, provide a better understanding of the achieved performance
     metrics of your design, and offer an environment to investigate
     what-if scenarios. While creating or debugging your design, SPM
     can provide a low-overhead means of investigating design and
     architectural decisions. This guide covers a number of different
     examples that should help get you started.

- **Adjust clock frequencies in the SPM:** The SPM can enable
     investigation into adjusting the clock frequencies of the PS, PL,
     and DDR. If you have high-bandwidth constraints for your system,
     the clock frequency would be an excellent way to increase
     throughputs. In an early evaluation environment, these frequencies
     could serve as design goals.

- **Set/Unset the L2 Cache Prefetch:** Check the instruction and data
     prefetch setting on the PL310 cache controller. Refer to [Chapter
     5: Evaluating Software Performance](#chapter-5) for information
     about how this is performed.

- **Compiler Optimization Settings:** Check the C/C++ build settings
     in the Vitis IDE. For best performance, it is recommended to use
     either "Optimize More (O2)" or "Optimize Most (O3)".

- **Write Efficient Software Code:** This guide described how the
     performance of matrix multiplication was improved by almost 5x.
     Information on how to write high-performance, efficient software
     can be found in [What Every Programmer Should Know About
     Memory](http://www.cs.bgu.ac.il/%7Eos142/wiki.files/drepper-2007.pdf)
     by Ulrich Drepper. Some options to consider as described in that
     document include:

  - Bypassing the cache (for non-temporal writes)

  - Optimizing cache accesses and miss rates

  - Utilizing prefetching

  - Exploiting concurrency and multi-threading.

- **Understand Contention:** While running software-only tests can
     often produce predictable performance results, introducing traffic
     scenarios on either the HP ports or the ACP can lead to
     performance impacts that are difficult to predict. Introducing
     other high-bandwidth traffic into a system can inevitably lead to
     contention at the L2 cache, high-performance switches, or the DDR
     controller. Taking the time to understand the depth and impact of
     this contention can be beneficial.

- **DDR Controller Settings:** These settings can either be modified
     in the Vitis IDE (SPM design only) or in Vivado® Design Suite
     under the configuration of the Processing System 7 (PS7) IP block.
     Note that these settings can be used to re-allocate bandwidth from
     the DDR based on the desired needs of your system. Refer to
     [Evaluating DDR Controller Settings](../docs/7-evaluating-DDR-controller-settings.md) to see
     how this is done as well as how it might affect the DDR bandwidth
     of the CPUs and the HP ports.

- **Use the Zynq-7000 SoC On-Chip Memory:** The OCM is a 256 KB memory
     block accessible to both CPUs and the programmable logic from the
     ACP, GP, and HP ports. The OCM provides low-latency access and is
     an ideal component for use in synchronization or scratch pad
     applications.

- **Use the Accelerator Coherency Port:** The ACP is intended for
     cache coherency with the Arm® Cortex-A9 processors. While this
     coherency can be very useful for some applications, it does create
     possible contention at the L2 Cache. If this contention becomes
     undesirable in your design, the OCM can be used with the ACP to
     create a low-latency memory interface.

- **Use the High-Performance Ports:** The HP ports provide very
     high-throughput interfaces between the PS, PL, and DDR. The HP
     ports are recommended for any portion of a design where high
     bandwidth is required. While all HP ports are created equal, it is
     important to understand the pairing of HP ports used in the DDR
     controller. One DDR port is shared by HP0 and HP1, while another
     is shared by HP2 and HP3. These port pairings can be used together
     (if modifying DDRC settings) or separately (to maximize bandwidth
     across multiple DDRC ports).
