<table width="100%">
 <tr width="100%">
    <td align="center"><img src="https://www.xilinx.com/content/dam/xilinx/imgs/press/media-kits/corporate/xilinx-logo.png" width="30%"/><h1>Vitis Embedded Software Debugging Guide (UG1515) 2021.1</h1>
    </td>
 </tr>
</table>

# Summary

This table summarises the available error information which has been described in the documentation for quick browsing.

| Topic  |Description | Debug Feature Highlighted|Link to Page |
| ------------- |-----------|-----------|-----------|
| Bare-Metal Debug | What to do when you see an "Error Launching Program" message when launching a debug session?|System Debugger, Linker Issue|[Error 1: Error Launching Program](../2-debugging-bare-metal-applications/README.html#error-1-error-launching-program) |
| Bare-Metal Debug |What to do when a bare-metal application fails to complete the required operations? |System Debugger, Register Viewer|[Error 2: Unfinished DMA Operation](../2-debugging-bare-metal-applications/README.html#error-2-unfinished-dma-operation) |
| Bare-Metal Debug | What to do when you get an unexpcted result when running your bare-metal application? |Breakpoints, System Debugger, Memory/Variables/Expressions Tabs|[Error 3: Unexpected DMA Transfer Result](../2-debugging-bare-metal-applications/README.html#error-3-unexpected-dma-transfer-result) |
| Bare-Metal Debug | What to do when your bare-metal application gets stuck at `Xil_Assert` when analyzing in System Debugger? |Assertions, System Debugger| [Error 4: Assertion](../2-debugging-bare-metal-applications/README.html#error-4-assertion) |
| Bare-Metal Debug |How to step through and perform detailed debugging of code? |Step functions |[Error 5: Non-Lowercased Characters](../2-debugging-bare-metal-applications/README.html#error-5-non-lowercased-characters) |
| Linux Debug |Are you getting started with linux application debug and facing connectivity issues?|Setting up Ethernet connection and TCF agent|[Error 1 : There is no Linux TCF agent running on the specified '192.168.0.1'](../3-debugging-linux-applications/README.html#error-1-there-is-no-linux-tcf-agent-running-on-the-specified-19216801)|
| Linux Debug| Where is it going wrong when you see a "(Linux-Agent : Disconnected) : No such file or directory" error? |Using the appropriate sysroot for TCF agent and application|[Error 2 : (Linux-Agent : Disconnected) : No such file or directory](../3-debugging-linux-applications/README.html#error-2-linux-agent--disconnected--no-such-file-or-directory)|
| Linux Debug| Why do you see this error when you try to read a certain memory address?| System Debugger, Vitis Debug view, Variables view |[Error 3: Cannot Read Target Memory, Input/Output Error](../3-debugging-linux-applications/README.html#error-3-cannot-read-target-memory-inputoutput-error)|
| Linux Debug|What to do when you see ???????? in memory view? |System Debugger, Memory View|[Error 4: Memory View Both Physical Address and Virtual Address Return ????????](../3-debugging-linux-applications/README.html#error-4-memory-view-both-physical-address-and-virtual-address-return-)| 
| Linux Debug|How to make your Linux application thread-safe?|System Debugger, Breakpoints, Stepping, Resume, Variables view|[Error 5: Multithread Application Debug](../3-debugging-linux-applications/README.html#error-5-multithread-application-debug)|
| Linux Debug|How to debug your dynamically allocated data issue?|System Debugger, Breakpoints, Variables view, Stepping|[Error 6: Dynamic Memory Allocation](../3-debugging-linux-applications/README.html#error-6-dynamic-memory-allocation)|
| Advanced Debug |How to debug a Linux userspace application with OS awareness?|Path Map, Attach to running target, Remote Host, OS Aware Debug, Breakpoints, Memory Viewer|[Error 1: AXI GPIO Application Debug](../4-advanced-debug-techniques/README.html#error-1-axi-gpio-application-debug)|
| Advanced Debug |How to debug kernel crash issues?|Path Map, Attach to running target, Remote Host, OS Aware Debug, Breakpoints|[Error 2: Debugging a Kernel Crash](../4-advanced-debug-techniques/README.html#error-2-debugging-a-kernel-crash)|
| Advanced Debug |How to debug issues with a kernel process?|Path Map, Attach to running target, Remote Host, OS Aware Debug, Breakpoints|[Error 3: Debugging a Kernel Process](../4-advanced-debug-techniques/README.html#error-3-debugging-a-kernel-process)|
| Advanced Debug |How to debug kernel module issues?|Path Map, Attach to running target, Remote Host, OS Aware Debug|[Error 4: Debugging Kernel Module](../4-advanced-debug-techniques/README.html#error-4-debugging-a-kernel-module)|


_Copyright 2021 Xilinx Inc. Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0. Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License._