# Versal 嵌入式设计教程

本文档旨在提供有关将赛灵思 Vivado® Design Suite 流程应用于 Versal™ VMK180/VCK190 评估板的指示信息。所使用的工具为 Vivado Design Suite 和 Vitis™ 统一软件平台 2020.2 版。要安装 Vitis 统一软件平台，请参阅《Vitis 统一软件平台文档：嵌入式软件开发》([UG1400](https://china.xilinx.com/cgi-bin/docs/rdoc?v=latest;d=ug1400-vitis-embedded.pdf))。

> **注意**：在本教程中，有关在硬件上启动 Linux 的指示信息仅适用于针对 2020.2 版发布的 PetaLinux 工具，这些工具将安装在 Linux 主机上用于实践本文档的 Linux 部分内容。

> **重要**！VCK190/VMK180 评估板包含 Silicon Labs CP210x VCP USB-UART Bridge。请确保这些驱动均已完成安装。请参阅《Silicon Labs CP210x USB-to-UART 安装指南》([UG1033](https://china.xilinx.com/support/documentation/boards_and_kits/install/ug1033-cp210x-usb-uart-install.pdf))，以获取更多信息。

本文档中的示例是使用 Windows 10 64 位操作系统上运行的赛灵思工具、Vitis 软件平台和 Linux 64 位操作系统上的 PetaLinux 所创建的。使用其它 Windows 上运行的其它版本的工具进行安装所产生的结果可能与此处结果不尽相同。这些示例主要围绕嵌入式设计的以下方面来展开。

- **[Versal ACAP CIPS 和 NoC (DDR) IP 核配置](./2-cips-noc-ip-config.md#versal-acap-cips-和-noc-ddr-ip-核配置)**：描述如何使用 Versal™ ACAP Control, Interfaces, and Processing System (CIPS) IP 核与 NoC 来创建设计，以及如何在 Arm® Cortex™-A72 和 Cortex™-R5F 处理器上运行简单的“Hello World”应用。本章提供了使用简单设计作为示例的软硬件工具简介。

- **[使用 Vitis 软件平台进行调试](./3-debugging.md#使用-vitis-软件平台进行调试)**：介绍赛灵思 Vitis 软件平台的调试功能。本章使用前述设计并在裸机（无操作系统）上运行软件以演示 Vitis IDE 的调试功能。本章还列出了 Versal ACAP 的调试配置。

- **[启动和配置](./4-boot-and-config.md#启动和配置)**：显示集成组件以便为 Versal ACAP 配置并创建启动镜像。本章旨在帮助您了解如何集成和加载引导加载程序。

- **[使用标量引擎和自适应引擎的系统设计示例](./5-system-design-example.md#使用标量引擎和自适应引擎的系统设计示例)**：描述如何在 Versal ACAP 上使用可用工具和受支持的软件块来构建系统。本章演示了如何利用 Vivado 工具并使用 PL AXI GPIO 来创建嵌入式设计。其中还演示了如何在 Versal 器件上为基于 Arm Cortex-A72 核的 APU 配置并构建 Linux 操作系统。

本设计教程需使用多个赛灵思提供的文件。这些文件包含在 ZIP 文件内，此文件可从赛灵思网站下载。（请参阅[入门指南](./1-getting-started.md#入门指南)）。本教程假定该 ZIP 文件的内容已解压至 `C:\edt`。

## 按设计进程浏览内容

赛灵思文档按一组标准设计进程进行组织，以便帮助您查找当前开发任务相关的内容。本文档涵盖了以下设计进程：

* **系统和解决方案规划**：确认系统级别的组件、性能、I/O 和数据传输要求。包括解决方案到 PS、PL 和 AI 引擎的应用映射。

  * [在现有工程内配置 NoC IP 核](./2-cips-noc-ip-config.md#在现有工程内配置-noc-ip-核)
  * [使用标量引擎和自适应引擎的系统设计示例](./5-system-design-example.md#使用标量引擎和自适应引擎的系统设计示例)

* **嵌入式软件开发**：从硬件平台创建软件平台，并使用嵌入式 CPU 开发应用代码。还涵盖 XRT 和 Graph API。

  * [运行裸机 Hello World 应用](./2-cips-noc-ip-config.md#运行裸机-hello-world-应用)
  * [在 Vitis 软件平台中使用系统调试器以 JTAG 模式运行应用](./2-cips-noc-ip-config.md#在-vitis-软件平台中使用系统调试器以-jtag-模式运行应用)
  * [在 DDR 内存上运行裸机 Hello World 应用](./2-cips-noc-ip-config.md#在-ddr-内存上运行裸机-hello-world-应用)

* **硬件、IP 和平台开发**：为硬件平台创建 PL IP 块、创建 PL 内核、子系统功能仿真以及评估 Vivado® 时序收敛、资源使用情况和功耗收敛。还涉及为系统集成开发硬件平台。本文档中适用于此设计进程的主题包括：

  * [CIPS IP 核配置](./2-cips-noc-ip-config.md#cips-ip-核配置)
  * [NoC（和 DDR）IP 核配置](./2-cips-noc-ip-config.md#noc和-ddrip-核配置)
  * [设计示例：使用 AXI GPIO](./5-system-design-example.md#设计示例使用-axi-gpio)

* **系统集成与验证**：集成和验证系统功能性能，包括时序收敛、资源使用情况和功耗收敛。本文档中适用于此设计进程的主题包括：

  * [启动和配置](./4-boot-and-config.md#启动和配置)
  * [工程示例：含 RPU 的 FreeRTOS GPIO 应用工程](./5-system-design-example.md#工程示例含-rpu-的-freertos-gpio-应用工程)
  * [工程示例：使用 PetaLinux 创建 Linux 镜像](./5-system-design-example.md#工程示例使用-petalinux-创建-linux-镜像)
