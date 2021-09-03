# 使用标量引擎和自适应引擎的系统设计示例

本章将逐步指导您使用可用的工具和受支持的软件块来构建基于 Versal™ 器件的系统。本章演示了如何利用 Vivado® 工具并使用 PL AXI GPIO 来创建嵌入式设计。其中还演示了如何在 Versal 器件上为基于 Arm® Cortex™-A72 核的 APU 配置并构建 Linux 操作系统。

在本章中还提供了 PetaLinux 工具的使用示例。

## 设计示例：使用 AXI GPIO

Linux 应用使用基于 PL 的 AXI GPIO 接口来监控开发板的 DIP 开关，并对开发板 LED 进行相应的控制。LED 应用可在 VMK180/VCK190 上运行。

### 配置应用

此设计中的第一步是配置 PS 和 PL 部分。您可使用 Vivado® IP integrator 执行此配置。首先从 Vivado IP 目录添加所需 IP，然后将各组件连接到 PS 子系统中的各块。要配置硬件，请执行以下步骤：

**注意**：如果已打开 Vivado® Design Suite，请跳至步骤 3。

1. 打开您在[第 2 章：Versal ACAP CIPS 和 NoC (DDR) IP 核配置](./2-cips-noc-ip-config.md#versal-acap-cips-和-noc-ddr-ip-核配置)中创建的 Vivado 工程。

   `C:/edt/edt_versal/edt_versal.xpr`

2. 在 Flow Navigator 中的 **IP integrator** 下，单击“**打开块设计 (Open Block Design)**”。

   ![](./media/image5.png)

3. 右键单击模块框图，然后选择“**添加 IP (Add IP)**”。

#### 连接 IP 块以创建完整系统。

要连接 IP 块以创建系统，请遵循以下步骤进行操作。

1. 双击 Versal™ ACAP CIPS IP 核。

2. 单击“**PS-PMC → PL-PS 接口 (PS-PMC → PL-PS Interfaces)**”。

   ![](./media/image60.png)

3. 启用 M\_AXI\_FPD 接口，将“PL 复位数 (Number of PL Resets)”设置为 1，如下图所示。

4. 单击“**时钟配置 (Clock Configuration)**”，然后单击“输出时钟 (Output Clocks)”选项卡。

5. 展开“PMC 域时钟 (PMC Domain Clocks)”。然后展开“PL 架构时钟 (PL Fabric Clocks)”。按下图所示，配置 PL0\_REF\_CLK 时钟：

   ![](./media/image61.jpeg)

6. 单击“**OK**”以完成配置并返回至模块框图。

#### 添加并配置 IP 地址

要添加并配置 IP 地址，请执行以下操作：

1. 右键单击模块框图，然后从 IP 目录中选择“**添加 IP (Add IP)**”。

2. 搜索 AXI GPIO，然后双击“**AXI GPIO IP**”以将其添加到您的设计中。

3. 将另一个 AXI GPIO IP 实例添加到设计中。

4. 单击“块设计 (Block Design)”视图中的“**运行自动连接 (Run Connection Automation)**”。![](./media/image62.png)

   这样会打开“Run Connection Automation”对话框。

5. 在“Run Connection Automation”对话框中，选择“全部自动化 (All Automation)”复选框。

   ![](./media/image63.png)

   这样即可选中自动操作 AXI GPIO IP 的所有端口。

6. 单击 axi\_gpio\_0 的“**GPIO**”，然后将“选择开发板器件接口 (Select Board Part Interface)”设置为“**定制 (Custom)**”，如下所示。

   ![](./media/image64.png)

7. 采用与 axi\_gpio\_1 的 GPIO 相同的设置。

8. 单击 axi\_gpio\_0 的“**S\_AXI**”。按下图所示设置配置：

   ![](./media/image65.jpeg)

9. 采用与 axi\_gpio\_1 的 S\_AXI 相同的配置。此配置将设置如下连接：

   - 将 AXI\_GPIO 的 S\_AXI 连接到 CIPS 的 M\_AXI\_FPD，在 CIPS 与 AXI GPIO IP 之间采用 SmartConnect 作为桥接 IP。

   - 启用处理器系统复位 IP。

   - 将 pl0\_ref\_clk 连接至处理器系统复位 AXI GPIO 和 SmartConnect IP 块。

   - 将 SmartConnect 和 AXI GPIO 的复位连接至处理器系统复位 IP 的 peripheral\_aresetn。

10. 单击“**确定 (OK)**”。

11. 单击“Block Design”窗口中的“**Run Connection Automation**”，然后选中“All Automation”复选框。

12. 单击“**ext\_reset\_in**”并配置设置，如下所示。

    ![](./media/image66.jpeg)

    这样即可将处理器系统复位 IP 的 `ext_reset_in` 连接到 CIPS 的 pl\_resetn。

13. 单击“**确定 (OK)**”。

14. 断开 SmartConnect IP 的 `aresetn` 与处理器系统复位 IP 的 `peripheral_aresetn` 之间的连接。

15. 将 SmartConnect IP 的 `aresetn` 连接到处理器系统复位 IP 的 `interconnect_aresetn`。

    ![](./media/image67.jpeg)

16. 双击 axi\_gpio\_0 IP 以将其打开。

17. 转至“IP 配置 (IP Configuration)”选项卡并按下图所示配置设置。

    ![](./media/image68.png)

18. 采用与 axi\_gpio\_1 相同的设置。

19. 再添加 4 个 slice IP 实例。

20. 删除 AXI GPIO IP 的外部管脚，并展开接口。

21. 将 axi\_gpio\_0 的输出管脚 gpio\_io\_0 连接到 slice 0 和 slice 1。

22. 同样，将 axi\_gpio\_1 的输出管脚 gpio\_io\_0 连接到 slice 2 和 slice 3。

23. 将 slice IP 的输出设置为“外部 (External)”。

24. 按下图所示配置每个 slice IP。

    ![](./media/image69.png)

    ![](./media/image70.png)

    ![](./media/image71.png)

    ![](./media/image72.png)

总体块设计如下图所示：

![](./media/image73.jpeg)

#### 验证设计并生成输出

要验证设计并生成输出文件，请执行以下步骤：

1. 返回“Block Design”视图并保存块设计（按 **Ctrl+S** 键）。

2. 右键单击“Block Diagram”视图中的空白区域，并选择“**验证设计 (Validate Design)**”。或者，您可按 **F6** 键。

   这样会打开含以下消息的对话框：

   ![validation\_message](./media/validation_message.PNG)

3. 单击“**OK**”以关闭此消息。

4. 单击“**Sources**”窗口。

   1. 展开“约束 (Constraints)”。
   2. 右键单击“**constrs\_1-> 添加源代码 (ADD Sources)**”。这样会打开“Add Sources”窗口。
   3. 选择“**添加或创建约束 (Add or Create Constraints)**”选项，然后单击“**下一步 (Next)**”。
   4. 选择要添加的 .xdc 文件。
      > **注意**：约束文件包含在封装内一起提供，位于 `pl_axigpio/ constrs` 文件夹下。
   5. 单击“**完成 (Finish)**”。

5. 单击“**层级 (Hierarchy)**”。

6. 在“Sources”窗口中的“设计源代码 (Design Sources)”下，展开“**edt\_versal\_wrapper**”。

7. 右键单击顶层块设计 edt\_versal\_i : edt\_versal (`edt_versal.bd`) 并选择“**Generate Output Products**”。

   ![](./media/image15.png)

8. 单击“**生成 (Generate)**”。

9. 当“Generate Output Products”进程完成后，请单击“**OK**”。

10. 在“Sources”窗口中，单击“**IP Sources**”视图。您可在此处查看刚生成的输出文件，如下图所示。

    ![](./media/image74.png)

#### 综合、实现和生成器件镜像

请遵循以下步骤为设计生成器件镜像。

1. 转至“**Flow Navigator → Program and Debug**”，单击“**Generate Device Image**”，然后单击“**OK**”。

2. 这样会显示“无实现结果可用 (No Implementation Results Available)”菜单。单击“**Yes**”。

3. 这样会显示“启动运行 (Launch Run)”菜单。单击“**确定 (OK)**”。

   当“Device Image Generation”完成后，会显示“器件镜像生成已完成 (Device Image Generation Completed)”对话框。

4. 单击“**取消 (Cancel)**”关闭此窗口。

5. 生成器件镜像后，请导出硬件。

> **注意**：以下步骤为可选，您可跳过这些步骤并转至[导出硬件](#导出硬件)部分。这些步骤提供了生成器件镜像的详细流程，包括先运行综合与实现，然后再生成器件镜像。如需了解生成器件镜像的流程，请遵循以下提供的步骤进行操作。

5. 转至“**Flow Navigator → Synthesis**”，然后单击“**Run Synthesis**”。

   ![](media/image17.png)

6. 如果 Vivado® 提示您在启动综合前保存工程，请单击“**保存 (Save)**”。

   运行综合时，在右上角窗口中会显示其状态栏。在整个设计进程中，此状态栏会因各种原因而呈现假脱机状态。此状态栏表示进程正在后台运行。当综合完成后，会打开“综合已完成 (Synthesis Completed)”对话框。

7. 选择“**运行实现 (Run Implementation)**”，然后单击“**OK**”。

   当实现完成后，会打开“实现已完成 (Implementation Completed)”对话框。

8. 选择“**Generate Device Image**”，然后单击“**OK**”。

   当“Device Image Generation”完成后，会显示“器件镜像生成已完成 (Device Image Generation Completed)”对话框。

9. 单击“**取消 (Cancel)**”关闭此窗口。

   生成器件镜像后，请导出硬件。

#### 导出硬件

1. 在 Vivado 主菜单中，选择“**File→ Export → Export Hardware**”。这样会打开“导出硬件 (Export Hardware)”对话框。

2. 选择“**包含比特流 (Include bitstream)**”，然后单击“**Next**”。

3. 为导出的文件提供名称（或者使用提供的默认名称）并选择导出位置。单击“**下一步 (Next)**”。

   如果硬件模块已导出，则会显示一条警告消息。如果显示覆盖消息，则请单击“**是 (Yes)**”以覆盖现有 XSA 文件。

4. 单击“**完成 (Finish)**”。

## 工程示例：含 RPU 的 FreeRTOS GPIO 应用工程

本节解释了如何在 Versal™ 器件上为基于 Arm® Cortex™- R5F 核的 RPU 配置并构建 FreeRTOS 应用。

以下步骤演示了从 Arm Cortex-R5F 创建 FreeRTOS 应用的过程：

1. 启动 Vitis IDE 并创建新的工作空间，例如，`c:/edt/freertos`。

2. 选择“**文件 (File) → 新建 (New) → 应用工程 (Application Project)**”。这样会打开“**新建应用工程 (Creating a New Application Project)**”Wizard。如果这是首次启动 Vitis™ IDE，那么您可在“欢迎使用 (Welcome)”屏幕上选择“**创建应用工程 (Create Application Project)**”，如下图所示。

   ![](./media/image75.jpeg)

    <div class="note">
     <div class="title">注意</div>或者，您也可以选中&ldquo;下次跳过欢迎屏幕 (Skip welcome page next time)&rdquo;，这样即可每次启动时跳过欢迎页面。</div>

3. 在 Vitis IDE 中，每个应用工程均由 4 个部分组成：目标平台、系统工程、域和模板。要在 Vitis IDE 中创建新应用工程，请遵循以下步骤：

   1. 目标平台由基本硬件设计与在将加速器连接到声明的接口过程中所使用的元数据组成。根据从 Vivado® Design Suite 导出的 XSA 选择平台或者创建平台工程。

   2. 将应用工程置于系统工程内，并将其与处理器关联。

   3. 域负责定义用于在目标平台上运行主机程序的处理器和操作系统。

   4. 请为应用选择模板以便快速开始开发。根据以下信息在 Wizard 屏幕中选择相应的选项。

   表 9：**Wizard 信息**

   | Wizard 屏幕| 系统属性| 所用设置或命令
   |----------|----------|----------
   | 平台 (Platform)| 基于硬件创建新平台 (XSA) (Create a new platform from hardware (XSA))| 单击“Browse”以添加 XSA 文件
   | | 平台名称 (Platform Name)| vck190\_platform
   | 应用工程详情 (Application Project Detail)| 应用工程名称 (Application project name)| freertos\_gpio\_test
   | | 选择系统工程 (Select a system project)| +新建
   | | 系统工程名称 (System project name)| freertos\_gpio\_test\_system
   | | 处理器 (Processor)| psv\_cortexr5\_0
   | 域 (Domain)| 选择域 (Select a domain)| +新建
   | | 名称| 分配的默认名称
   | | 显示名称 (Display Name)| 分配的默认名称
   | | 操作系统 (Operating System)| freertos10\_xilinx
   | | 处理器 (Processor)| psv\_cortexr5\_0
   | 模板 (Templates)| 可用 (Available)| Freertos Hello
   | | 模板 (Templates)| world

   执行完上述步骤后，Vitis 软件平台就会为平台工程 (**vck190\_platform**) 和系统工程 (**freertos\_gpio\_test\_system**) 创建开发板支持封装，其中包含名为 **freertos\_gpio\_test** 的应用工程，位于“Explorer”视图下。

4. 右键单击位于 `src/` 下的 `freertos_hello_world.c` 文件，并将 `freertos_hello_world.c` 文件重命名为 `freertos_gpio_test.c`。将 `freertos_gpio_test.c` 文件从 FreeRTOS 工程路径复制到位于 `src/` 下的 `freertos_gpio_test.c`。

5. 右键单击 **vck190\_platform** 并选择“**Build Project**”。或者，也可以单击 ![](./media/image77.jpeg)。

    <div class="note">
     <div class="title">注意</div>如果无法看到 Project Explorer，请单击左侧面板上的复原图标，然后执行此步骤。</div>


要了解如何构建 Linux 镜像并将 FreeRTOS elf 整合到镜像中，请参阅[工程示例：使用 PetaLinux 创建 Linux 镜像](#工程示例使用-petalinux-创建-linux-镜像)。

## 工程示例：使用 PetaLinux 创建 Linux 镜像

本节解释了如何在 Versal™ 器件上，为基于 Arm® Cortex™-A72 核的 APU 配置并构建 Linux 操作系统。您可将 PetaLinux 工具用于特定于开发板的 BSP 以配置和构建 Linux 镜像。

此示例需要 Linux 主机。请参阅[《PetaLinux 工具文档：参考指南》(UG1144)](https://china.xilinx.com/member/versal_tools_ea.html#embedded)，以了解有关 PetaLinux 工具的依赖关系和安装过程的信息。

> **重要**：此示例使用 VCK190 PetaLinux BSP 来创建 PetaLinux 工程。*请确保您已下载适用于 PetaLinux (VCK190/VMK180) 的相应 BSP。*
>
> - 如果您使用的是 VCK190 开发板，请从 <https://china.xilinx.com/member/vck190_headstart.html> 下载 `xilinx-vck190-v2020.2-final.bsp` 文件。
>
> - 如果您使用的是 VMK180 开发板，请从 <https://china.xilinx.com/member/vmk180_headstart.html> 下载 VMK180 PetaLinux 2020.2 BSP (xilinx- vmk180-v2020.2-final.bsp)。

1. 将对应开发板的 PetaLinux BSP 复制到当前目录。

2. 使用以下命令创建 PetaLinux 工程。

   > **注意**：对于 VMK180 开发板，请在命令中的 `-s` 选项后使用 `xilinx-vmk180-vxxyy.z-final.bsp`。

3. 使用以下命令切换至 PetaLinux 工程目录。

   `\$cd led_example`

4. 将硬件平台工程 XSA 复制到 Linux 主机。

   > **注意**：对于 VMK180 开发板，请使用[设计示例：使用 AXI GPIO](#设计示例使用-axi-gpio) 中生成的 XSA 文件。

5. 使用以下命令重新配置 BSP。

   此命令会打开“PetaLinux 配置 (PetaLinux Configuration)”窗口。对于此示例，无需在此窗口中执行任何更改。

6. 请选择“**Save**”，然后选择“**OK**”保存以上配置，然后选择“**Exit**”以退出“Configuration”Wizard。

7. 使用以下命令，在 PetaLinux 工程内创建名为 gpiotest 的 Linux 应用。

   `\$petalinux-create -t apps \--template install \--name gpiotest\--enable`

8. 使用以下命令将应用文件从 `<design-package>/<vck190 or vmk180>/linux/bootimages` 复制到工程。

   ```
   $cp <design-package>/vck190/linux/design_files/gpiotest_app/files/* <plnx-proj-root>/projectspec/meta-user/recipes-apps/gpiotest/files/
   $cp <design-package>/vck190/linux/design_files/gpiotest_app/gpiotest.bb <plnx-proj-root>/projectspec/meta-user/recipes-apps/gpiotest/gpiotest.bb
   $cp <design-package>/vck190/linux/design_files/device_tree/system-user.dtsi
   ```

9. 在内核配置中启用 GPIO 支持。

   `\$petalinux-config -c kernel`

   > **注意**：此命令会为 PetaLinux 工程打开“内核配置 (Kernel Configuration)”Wizard。

10. 浏览至“**器件驱动 (Device drivers) → GPIO 支持 (GPIO Support)**”，并按 **Y** 键将其启用。按 **Enter** 键并按 **Y** 键，启用“调试 GPIO 调用 (Debug GPIO calls)”和 `/sys/class/gpio/... (sysfs interface)` 条目，如下图所示。

    ![](./media/image79.jpeg)

11. 浏览至“**存储器映射 GPIO 驱动 (Memory mapped GPIO drivers)**”，并按 **Y** 键，启用“赛灵思 GPIO 支持 (Xilinx GPIO support)”和“赛灵思 Zynq GPIO 支持 (Xilinx Zynq GPIO support)”，如下图所示。

    ![](./media/image80.jpeg)

12. 单击“**Save**”保存以上配置，然后单击“**Exit**”选项以退出“Configuration”Wizard。

13. 使用以下命令构建 Linux 镜像。

    `$ petalinux-build`

### 使用 BIF 文件将 FreeRTOS 与 APU 镜像进行组合

1. 在 Vitis IDE 工作空间内打开 XSCT 控制台。

2. 浏览至 PetaLinux 工程的 `images/linux` 目录。

   `$ cd <petalinux-project>/images/linux/`

3. 将 `bootgen.bif` 文件从 `<design-package>/path` 复制到 `images/linux` 目录。

   `$ cp <design-package>/path/bootgen.bif`

4. 运行以下命令以创建 `BOOT.BIN`。

   `$ bootgen -image bootgen.bif -arch versal -o BOOT.BIN -w`

   这样会在 `<petalinux-project>/images/linux/` 目录中创建 `BOOT.BIN` 镜像文件。

> **注意**：要了解如何使用 SD 启动模式运行镜像，请参阅 [SD 启动模式的启动顺序](./4-boot-and-config.md#sd-启动模式的启动顺序)。

© 2020 年赛灵思公司版权所有。
