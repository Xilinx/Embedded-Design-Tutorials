# 面向含 SmartLynq+ 模块的高速调试端口的系统设计示例

## 引言

本章旨在演示如何基于 Versal™ 来构建同时使用 SmartLynq+ 模块和高速调试端口 (HSDP) 的系统。您还将了解到如何使用 JTAG 或 HSDP 来设置 SmartLynq+ 模块和下载 Linux 镜像。

> **重要**：本教程需要使用 SmartLynq+ 模块、VCK190 或 VMK180 评估板以及 Linux 主机。

## 设计示例：启用 HSDP

要启用 HSDP，请首先使用您在前一章中构建的 VCK190 或 VMK180 工程（或者设计包 `<design-package>/smartlynq_plus/vck190/design_files/vck190_edt_versal_hsdp.xpr.zip` 中提供的预构建工程），修改此工程，使其包含 HSDP 支持。

### 修改设计以启用 HSDP

此设计使用[使用标量引擎和自适应引擎的系统设计示例](./5-system-design-example.md#使用标量引擎和自适应引擎的系统设计示例)中构建的工程，并启用 HSDP 接口。您可使用 Vivado IP integrator 执行此配置。

1. 打开您在[第 5 章：使用标量引擎和自适应引擎的系统设计示例](./5-system-design-example.md#使用标量引擎和自适应引擎的系统设计示例)中创建的 Vivado 工程。

   `C:/edt/edt_versal/edt_versal.xpr`

2. 在 Flow Navigator 中的 **IP integrator** 下，单击“**打开块设计 (Open Block Design)**”。

   ![](./media/image5.png)

3. 双击 Versal ACAP CIPS IP 核，然后单击“**调试 (Debug) → 调试配置 (Debug Configuration)**”。![](./media/ch6-image1.png)

4. 在“**高速调试端口 (High-Speed Debug Port (HSDP))**”下，选择“**AURORA**”作为“**往来调试包控制器的路径 (Pathway to/from Debug Packet Controller (DPC))**”。

   ![](./media/ch6-image2.png)

5. 设置以下选项：

   - “**GT 选择 (GT Selection)**”设为“**HSDP1 GT**”
   - “**GT 参考时钟选择 (GT Refclk Selection)**”设为 **REFCLK1**
   - “**GT 参考时钟频率 (GT Refclk Freq (MHz))**”设为 **156.25**

   > **注意**：线速率固定为 10.0 Gb/s。

6. 单击“**确定 (OK)**”保存更改。这样会在 CIPS IP 上创建 2 个端口：`gt_refclk1` 和 `HSDP1_GT`。

7. 在“**IP Integrator**”页面上右键单击 `gt_refclk1` 并选择“**设为外部端口 (Make External)**”。对 **HSDP1\_GT** 执行相同的操作。

   ![](./media/ch6-image4.png)

   ![](./media/ch6-image5.png)

8. 单击“**验证设计 (Validate Design)**”，然后单击“**保存 (Save)**”。

### 综合、实现和生成器件镜像

1. 在 Flow Navigator 中的“**编程和调试 (Programming and Debug)**”下，单击“**生成器件镜像 (Generate Device Image)**”以启动实现。

   当完成器件镜像生成后，会显示“器件镜像生成已完成 (Device Image Generation Completed)”对话框。

   ![](./media/ch6-image9.png)

### 导出硬件 (XSA)

1. 从 Vivado 工具栏中选择“**文件 (File) → 导出 (Export) → 导出硬件 (Export Hardware)**”。这样会打开“导出硬件 (Export Hardware)”对话框。

   ![](./media/ch6-image10.png)

2. 选择“**固定 (Fixed)**”，然后单击“**下一步 (Next)**”。

3. 选择“**包含器件镜像 (Include Device Image)**”，然后单击“**下一步 (Next)**”。

4. 为导出的文件提供名称（例如：`edt_versal_wrapper_with_hsdp`）。单击“**下一步 (Next)**”。

5. 单击“**完成 (Finish)**”。

## 使用 PetaLinux 创建启用 HSDP 的 Linux 镜像

此示例使用上一步中构建的启用 HSDP 的 XSA 重新构建 PetaLinux 工程。假定已根据[使用标量引擎和自适应引擎的系统设计示例](./5-system-design-example.md#使用标量引擎和自适应引擎的系统设计示例)中的指示信息创建 PetaLinux 工程。

> **重要**：如果您构建本教程时，在上一章中未创建 PetaLinux 工程，请遵循[工程示例：使用 PetaLinux 创建 Linux 镜像](./5-system-design-example.md#工程示例使用-petalinux-创建-linux-镜像)章节中的步骤 1 至 12 创建新的 PetaLinux 工程。

此示例需要 Linux 主机。请参阅[《PetaLinux 工具文档：参考指南》(UG1144)](https://china.xilinx.com/member/versal_tools_ea.html#embedded)，以了解有关 PetaLinux 工具的依赖关系和安装过程的信息。

1. 使用以下命令切换至[工程示例：使用 PetaLinux 创建 Linux 镜像](./5-system-design-example.md#工程示例使用-petalinux-创建-linux-镜像)中创建的 PetaLinux 工程目录。

   `$ cd led_example`

2. 将新的硬件平台工程 XSA 复制到 Linux 主机中，置于 PetaLinux 构建根目录上一层的目录中。

   > **注意**：请确保您使用的是上一步中生成的已更新的 XSA 文件。

3. 使用以下命令重新配置 BSP。

   ```
   petalinux-config --get-hw-description=<path till the directory containing the respective xsa file>
   ```

4. 使用以下命令构建 Linux 镜像。

   ```
   $ petalinux-build
   ```

5. 构建完成后，请使用以下命令封装 boot 镜像：

   ```
   $ petalinux-package --force --boot --atf --u-boot
   ```

   > **注意**：封装的 Linux 启动镜像置于 PetaLinux 构建根目录中的 `<PetaLinux-project>/images/Linux/` 目录下。请记住此目录位置，因为在后续步骤中将使用此目录。如果要用于下载 Linux 启动镜像（使用 martLynq+）的机器并非先前用于构建 PetaLinux 的机器（例如，基于 Windows 的 PC），那么应先将此目录的内容传输至该机器，然后再继续本教程。

## 设置 SmartLynq+ 模块

构建并封装 Linux 镜像后，即可使用 JTAG 或 HSDP 将这些镜像加载到 VCK190 或 VMK180评估板上。要设置 SmartLynq+ 模块以便使用 HSDP 建立链接，请遵循下列步骤：

1. 使用 USB-C 线来连接 VCK190 USB-C 连接器与 SmartLynq+ 模块。

   ![](./media/ch6-slp1.png)

2. 将 SmartLynq+ 连接至以太网或 USB。

   * **使用以太网**：在 SmartLynq+ 上的以太网端口与局域网之间使用以太网电缆进行连接。
   * **使用 USB**：在 SmartLynq+ 上的 USB 端口与您的 PC 之间使用提供的 USB 线进行连接。

3. 将电源适配器连接到 SmartLynq+，并对 VCK190/VMK180 开发板上电。

4. 当 SmartLynq+ 完成启动后，会在屏幕上的 `eth0` 或 `usb0` 下显示 IP 地址。请记录此 IP 地址，因为在使用以太网和使用 USB 的情况下都将使用此 IP 地址连接到 SmartLynq+。

   ![](./media/ch6-image23.jpg)

   > **注意**：如果使用以太网，那么 SmartLynq+ 会从网络上找到的 DHCP 服务器获取 IP 地址。如果使用 USB，那么 USB 端口采用固定 IP 地址：`10.0.0.2`。

5. 从设计包 `<design-package>/smartlynq_plus/xsdb` 复制 Linux 下载脚本。

### 使用 SmartLynq+ 作为串行终端

SmartLynq+ 也可用作为串行终端来远程查看来自 VCK190 的 UART 输出。如果无法以物理方式访问远程设置，则可使用此功能。SmartLynq+ 模块已预安装 minicom 应用，此应用可用于直接连接至 VCK190 上的 UART。

1. 使用 SSH 客户端（例如，Windows 上的 `PuTTY` 或 基于 Unix 的系统上的 `ssh`），使用 SSH 连接至 SmartLynq+ 显示的 IP 地址。

   * 用户名：`xilinx`
   * 密码：`xilinx`

   例如，如果 SmartLynq+ 显示的 IP 地址为 `192.168.0.10`，那么您应发出以下命令：`ssh xilinx@192.168.0.10`。

2. 默认情况下，minicom 应用使用硬件流程控制。由于在 VCK190 UART 上不使用硬件流程控制，因此要成功连接至赛灵思开发板上的 UART，应将其禁用。要禁用硬件流程控制，请发出 `sudo minicom -s` 以进入 minicom 设置模式并禁用该功能。或者，以 root 用户身份发出以下命令以修改 minicom 默认配置：

   ```
   echo "pu rtscts No" | sudo tee -a /etc/minicom/minirc.dfl
   ```

3. 最后，要连接到 VCK190/VMK180 串行终端输出，请执行以下操作：

   ```
   sudo minicom --device /dev/ttyUSB1
   ```

4. 使该终端保持打开状态，继续下一章。

   ![](./media/ch6-image15.png)

### 通过 JTAG 或 HSDP 启动 Linux 镜像

SmartLynq+ 可用于将 Linux 镜像直接下载至 VCK190/VMK180，无需使用 SD 卡。Linux 镜像可使用 JTAG 或 HSDP 来加载。

通过使用本教程随附的设计包中所含脚本，即可使用 SmartLynq+ 模块来下载先前步骤中创建的 Linux 镜像。此脚本可使用 JTAG 或 HSDP。

1. 在可访问 SmartLynq+ 模块的机器上，打开 Vivado tcl shell。

   ![](./media/ch6-image24.png)

2. 如果在用于构建 PetaLinux 的机器上工作，请将工作目录切换至 PetaLinux 构建根目录，或者切换至先前步骤中已传输至本地机器的 `images/Linux` 目录所在的位置。

3. 在 Vivado tcl shell 中，发出以下命令使用 HSDP 下载镜像：

   ```
   xsdb Linux_download.tcl <smartlynq+ ip> images/Linux HSDP
   ```

   这样即可使用 JTAG 加载 `BOOT.BIN`，然后将自动协商 HSDP 链接，并使用 HSDP 加载其余启动镜像。这比使用 JTAG 要快得多。

   ![](./media/ch6-image16.png)

   > **注意**：您也可以通过将此脚本的最后一个实参更改为 `FTDI-JTAG` 来使用 JTAG 下载 Linux 镜像，如下图所示：`xsdb Linux-download <smartlynq+ ip> images/Linux FTDI-JTAG`。这样即可使用 JTAG 对所有 Linux 启动镜像进行编程。请注意此操作与使用 HSDP 下载时的速度差异。

4. 在上一章中打开的终端上，可通过 VCK190 UART 查看 Versal 启动消息：

   ![](./media/ch6-image17.png)

5. 使用 JTAG 或 HSDP 完成 Linux 启动后，将显示以下登录屏幕：

   ![](./media/ch6-image18.png)

## 实用链接

* 如需了解有关实用 PL 硬件调试核（例如，AXIS-ILA、AXIS-VIO、PCIe™ Debugger 和/或 DDRMC 校准接口）的更多信息，请参阅[《Vivado Design Suite 用户指南：编程与调试》(UG908)](https://china.xilinx.com/support/documentation/sw_manuals/xilinx2020_2/c_ug908-vivado-programming-debugging.pdf)。

* 如需了解有关 SmartLynq+ 模块的更多信息，请参阅[《SmartLynq+ 模块用户指南》](https://china.xilinx.com/support/documentation/boards_and_kits/smartlynq/ug1258-smartlynq-cable.pdf)。

## 总结

在本章中，您已完成下列操作：构建使用 HSDP 的设计、连接至 SmartLynq+ 模块、配置 SmartLynq+ 以执行远程 UART 访问，以及使用 HSDP 将 Linux 镜像下载到开发板上。

© 2020 年赛灵思公司版权所有。
