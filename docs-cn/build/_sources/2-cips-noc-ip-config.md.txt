# Versal ACAP CIPS 和 NoC (DDR) IP 核配置

Versal ACAP CIPS IP 核允许您配置处理器系统和 PMC 块，包括启动模式、外设、时钟、接口和中断等。

本章描述了如何执行以下任务：

- 创建 Vivado® 工程以供 Versal™ ACAP 通过配置 CIPS IP 核来选择相应的启动器件和外设。
- 在 Arm® Cortex™-A72 的片上存储器 (OCM) 上创建并运行 Hello World 软件应用。
- 在 Arm Cortex- R5F 的紧密耦合内存 (TCM) 上创建并运行 Hello World 软件应用。

NoC IP 核可帮助配置 DDR 内存和跨 DDR 内存的数据路径，以及系统中的处理引擎（标量引擎 (Scalar Engine)、自适应引擎 (Adaptable Engine) 和 AI 引擎 (AI Engine)）。

- 在 Arm Cortex-A72 上使用 DDR 作为内存来创建并运行 Hello World 软件应用。
- 在 Arm Cortex-R5F 上使用 DDR 作为内存来创建并运行 Hello World 软件应用。

### 要求

要创建并运行本章中所述 Hello World 应用，您需要安装 Vitis™ 统一软件平台。如需了解安装过程，请参阅《Vitis 统一软件平台文档：嵌入式软件开发》([UG1400](https://china.xilinx.com/cgi-bin/docs/rdoc?v=latest;d=ug1400-vitis-embedded.pdf))。

## CIPS IP 核配置

创建 Versal ACAP 系统设计中包括配置 CIPS IP 核以选择相应的启动器件和外设。首先，如果 CIPS IP 核外设和可用的多路复用 I/O (MIO) 连接满足要求，则无需任何 PL 组件。本章将指导您逐步完成创建基于 CIPS IP 核的简单设计的过程。

### 使用 Versal ACAP 创建全新的嵌入式工程

对于本示例，请启动 Vivado® Design Suite 并创建顶层为嵌入式处理器系统的工程。

#### 启动设计

1. 启动 Vivado® Design Suite。

2. 在 Tcl 控制台 (Tcl Console) 中，输入以下命令以启用 ES1 评估板：

   ```
   enable_beta_device
   ```

   按 **Enter** 键。

3. 在 Vivado“Quick Start”页面中，单击“**创建工程 (Create Project)**”以打开“新建工程 (New Project)”Wizard。

4. 使用下表中的信息在每个 Wizard 屏幕中选择相应选项。

   表 1：**系统属性设置**

   | Wizard 屏幕系统| 系统属性| 所用设置或命令
   |:----------|:----------|:----------
   | 工程名称 (Project Name)| 工程名称 (Project Name)| edt\_versal
   | | 工程位置 (Project Location)| C:/edt
   | | 创建工程子目录 (Create Project Subdirectory)| 保留勾选此项
   | 工程类型 (Project Type)| 指定要创建的工程类型。您可从 RTL 或已综合的 EDIF 开始着手| RTL 工程 (RTL Project)
   | | “当前请勿指定源代码 (Do not specify sources at this time)”复选框| 保留勾选此项
   | | “工程为可扩展 Vitit 平台 (Project is an extensible Vitis platform)”复选框| 保留勾选此项
   | 添加源代码 (Add Sources)| 请勿对此屏幕执行任何更改|
   | 添加约束 (Add Constraints)| 请勿对此屏幕执行任何更改|
   | 默认器件 (Default Part)| 选择| **开发板**
   | | 显示名称 (Display Name)| Versal VMK180/VCK190 评估平台
   | 工程摘要 (Project Summary)| 工程摘要 (Project Summary)| 复查工程摘要信息


5. 单击“**完成 (Finish)**”。这样即可关闭“New Project”Wizard，并在 Vivado 设计工具中打开您刚创建的工程。

> **注意**：选择开发板时，请勾选版本号。对于 ES1 硅片，开发板版本为 1.0，对于量产硅片，开发板版本为 2.0。请根据开发板上的硅片选择相应的版本。

#### 创建嵌入式处理器工程

要创建嵌入式处理器工程，请执行以下操作：

1. 在 Flow Navigator 中的 IP integrator 下，单击“**创建块设计 (Create Block Design)**”。

   ![](media/image5.png)

   这样即可打开“Create Block Design”Wizard。

2. 在“Create Block Design”Wizard 中使用以下信息选择相应的选项。

   表 2：**系统属性设置**

   | Wizard 屏幕| 系统属性| 所用设置或命令
   |:----------|:----------|:----------
   | 创建块设计 (Create Block Design)| 设计名称 (Design Name)| edt\_versal
   | | 目录 (Directory)| `<Local to Project>`
   | | 指定源代码集合 (Specify Source Set)| 设计源代码


3. 单击“**确定 (OK)**”。

   这样会打开“框图 (Diagram)”窗口视图，并显示消息称此设计为空。首先，添加来自 IP 目录的 IP。

4. 单击“**添加 IP (Add IP)**”按钮 ![](media/image6.png)。

5. 在搜索框中，输入 CIPS 以查找 Control, Interfaces and Processing System。

6. 双击“**Control, Interface \& Processing System IP**”以将其添加到块设计中。CIPS IP 核会显示在“Diagram”视图中，如下图所示：  
![](media/image7.png)

#### 在 Vivado Design Suite 中管理 Versal ACAP CIPS IP 核

现在，您已将 Versal™ ACAP 的处理器系统添加到设计中，接下来即可开始管理可用选项。

1. 双击“模块框图 (Block Diagram)”窗口中的 versal\_cips\_0。

2. 在“开发板 (Board)”选项卡中选择“**cips fixed io**”，如下图所示。

   ![cips-fixed-io-selection](./media/cips-fixed-io.png)

3. 单击“OK”。默认情况下，CIPS 中未启用任何控件或接口。应用开发板预设即可在 CIPS 上启用相应外设，在开发板上这些外设的 MIO 管脚均已连接。

4. 双击“模块框图 (Block Diagram)”窗口中的 versal\_cips\_0。这样会打开“重新自定义 IP (Re-customize IP)”对话框，如下图所示。

   ![](media/image9.jpeg)

5. 展开“**PS-PMC**”下拉菜单。单击“**IO 配置 (IO Configuration)**”，如下图所示。这样会打开“IO Configuration”对话框。

   I/O Configuration 会启用处理器系统中的外设，并允许为关联的 MIO 选择管脚分配。外设配置如下图所示：

   > **注意**：块自动化设置 (Block Automation) 不会显式运行。当“开发板接口 (Board interface)”从“定制 (Custom)”更改为“cips fixed io”时，会将其禁用。

   ![](./media/Recustomize-IP.PNG)

6. 单击“**OK**”以关闭 CIPS GUI。

#### 验证设计并生成输出

要验证设计并生成输出文件，请执行以下步骤：

1. 右键单击“Block Diagram”视图中的空白区域并选择“**验证设计 (Validate Design)**”。

   或者，您可按 **F6** 键。这样会显示如下消息对话框：

   ![validation\_message](./media/validation_message.PNG)

2. 在“Block Design”视图中，单击“**源代码 (Sources)**”选项卡。

   ![](media/image13.png)

3. 单击“**层级 (Hierarchy)**”。

4. 在“设计源代码 (Design Sources)”下，右键单击 **edt\_versal** 并选择“**创建 HDL 封装器 (Create HDL Wrapper)**”。

   这样会打开“Create HDL Wrapper”对话框。请使用此对话框来为处理器子系统创建 HDL 封装器文件。

   > **提示**：HDL 封装器是设计工具所需的顶层实体。

5. 选择“**让 Vivado 管理封装器并自动更新 (Let Vivado manage wrapper and auto-update)**”，然后单击“**OK**”。

6. 在“块设计源代码 (Block Design Sources)”窗口中的“Design Sources”下，展开 **edt\_versal\_wrapper**。

7. 右键单击标题为 edt\_versal\_i: edt\_versal 的顶层模块框图 (edt\_versal.bd) 并选择“**生成输出文件 (Generate Output Products)**”。

   这样会打开“Generate Output Products”对话框，如下图所示。

   ![](media/image15.png)

   > **注意**：如果在 Windows 上运行 Vivado® Design Suite，则“运行设置 (Run Settings)”下的选项可能与此处所示选项不同。在此情况下，请使用默认设置继续执行操作。

8. 单击“**生成 (Generate)**”。

   此步骤将为所选源代码构建所有必需的输出文件。例如，您无需手动为 IP 处理器系统创建约束。当您选中“**Generate Output Products**”时，Vivado 工具会自动为处理器子系统生成 XDC 文件。

9. 当“Generate Output Products”进程完成后，请单击“**OK**”。单击底部窗口的“设计运行 (Design Runs)”选项卡，以查看“OOC 模块运行/综合/实现运行 (OOC Module Runs/Synthesis/Implementation runs)”。

10. 在“Block Design Sources”窗口中，单击“**IP 源代码 (IP Sources)**”选项卡。您可在此处查看刚生成的输出文件，如下图所示。

    ![](media/image16.png)

#### 综合、实现和生成器件镜像

请遵循以下步骤为设计生成器件镜像。

1. 转至“**Flow Navigator → 编程与调试 (Program and Debug)**”，并单击“**生成器件镜像 (Generate Device Image)**”。

2. 这样会显示“无实现结果可用 (No Implementation Results Available)”菜单。单击“**Yes**”。

3. 这样会显示“启动运行 (Launch Run)”菜单。单击“**确定 (OK)**”。

   当“Device Image Generation”完成后，会显示“器件镜像生成已完成 (Device Image Generation Completed)”对话框。

4. 单击“**取消 (Cancel)**”关闭此窗口。

5. 生成器件镜像后，请导出硬件。

> **注意**：以下步骤为可选，您可跳过这些步骤并转至[导出硬件](#导出硬件)部分。这些步骤提供了生成器件镜像的详细流程，包括先运行综合与实现，然后再生成器件镜像。如需了解生成器件镜像的流程，请遵循以下提供的步骤进行操作。

6. 转至“**Flow Navigator → 综合 (Synthesis)**”、单击“**运行综合 (Run Synthesis)**”，然后单击“**OK**”。

   ![](media/image17.png)

7. 如果 Vivado® 提示您在启动综合前保存工程，请单击“**保存 (Save)**”。

   运行综合时，在右上角窗口中会显示其状态栏。在整个设计进程中，此状态栏会因各种原因而呈现假脱机状态。此状态栏表示进程正在后台运行。当综合完成后，会打开“综合已完成 (Synthesis Completed)”对话框。

8. 选择“**运行实现 (Run Implementation)**”，然后单击“**OK**”。

   当实现完成后，会打开“实现已完成 (Implementation Completed)”对话框。

9. 选择“**Generate Device Image**”，然后单击“**OK**”。

   当“Device Image Generation”完成后，会显示“器件镜像生成已完成 (Device Image Generation Completed)”对话框。

10. 单击“**取消 (Cancel)**”关闭此窗口。

    生成器件镜像后，请导出硬件。

#### 导出硬件

1. 在 Vivado 工具栏中，选择“**文件 (File) → 导出 (Export) → 导出硬件 (Export Hardware)**”。这样会打开“导出硬件 (Export Hardware)”对话框。

2. 选择“**包含器件镜像 (Include device image)**”，然后单击“**下一步 (Next)**”。

3. 为导出的文件提供名称（或者使用提供的默认名称）并选择导出位置。单击“**下一步 (Next)**”。

   如果硬件模块 (Hardware Module) 已导出，则会显示一条警告消息。如果显示覆盖消息，则请单击“**是 (Yes)**”以覆盖现有 XSA 文件。

4. 单击“**完成 (Finish)**”。

### 运行裸机 Hello World 应用

在此示例中，您将了解如何管理开发板设置、连接电缆、通过系统将电缆连接至开发板以及如何在赛灵思 Vitis 软件平台中通过 Arm Cortex-A72 上的片上存储器 (OCM) 和 Arm Cortex- R5F 上的紧密耦合存储器 (OCM) 来运行 Hello World 软件应用。

以下步骤演示了按要求连接电缆、通过系统将电缆连接至开发板以及启动 Vitis 软件平台的过程。

1. 将电源线缆连接到开发板。

2. 在 Windows 主机与目标开发板上的 USB JTAG 连接器之间连接 Micro USB 线。此线缆用于 USB 到串口之间的传输。

   > **注意**：请确保 SW1 开关设置为 JTAG 启动模式，如下图所示。

   ![](media/image19.jpeg)

3. 使用电源开关给 VMK180/VCK190 评估板上电，如下图所示。

   ![](media/image20.png)

   > **注意**：如果 Vitis 软件平台已运行，请跳转到步骤 6。

4. 选择“**工具 (Tools) → 从 Vivado 启动 Vitis IDE (Launch Vitis IDE from Vivado)**”以启动 Vitis 软件平台，并设置工作空间路径，在此例中，路径为 `C:\edt\edt_vck190`。

   或者，您可打开含默认工作空间的 Vitis 软件平台，稍后再通过如下方式来将其切换至正确的工作空间：选择“**文件 (File) → 切换工作空间 (Switch Workspace)**”，然后选择工作空间。

5. 打开对应系统上分配的 COM 端口的串行通信实用工具。Vitis 软件平台提供了 1 个串行终端实用工具，在本教程中均使用此工具，选择“**窗口 (Window) → 显示视图 (Show View) → 赛灵思 (Xilinx) → Vitis 串口终端 (Vitis Serial Terminal)**”即可将其打开。

   ![](media/image21.jpeg)

6. 单击 Vitis 终端上下文中的“**连接到串口 (Connect to a serial port)**”按钮 ![](media/image22.png) 以设置串行配置并连接此端口。

7. 在 Windows 器件管理器中验证此端口的详细信息。

   UART-0 终端对应于含“Interface-0”的 Com-Port。对于此示例，默认已设置 UART-0 终端，因此对于 Com-Port，请选择含 interface-0 的端口。下图显示了 Versal™ ACAP 处理器系统的标准配置。

   ![](media/image23.png)

> **注意**：您可使用外部终端串口控制台，如 Tera Term 或 Putty。您可在“控制面板 (Control Panel)”的“器件管理器 (Device Manager)”菜单中找到相关 COM 端口信息。

#### 为 Arm Cortex-A72 上的 OCM 创建 Hello World 应用

以下步骤演示了为 Arm Cortex-A72 上的 OCM 创建 Hello World 应用的步骤。

1. 选择“**文件 (File) → 新建 (New) → 应用工程 (Application Project)**”。这样会打开“新建应用工程 (Creating a New Application Project)”Wizard。如果这是首次启动 Vitis IDE，那么您可在“欢迎使用 (Welcome)”屏幕上选择“创建应用工程 (Create Application Project)”，如下图所示。

   ![](media/image24.png)

   > **注意**：或者，您也可以选中“下次跳过欢迎屏幕 (Skip welcome page next time)”，这样即可每次启动时跳过欢迎页面。

   ![](media/image25.jpeg)

2. 根据以下信息在 Wizard 屏幕中选择相应的选项。

   表 3：**系统属性设置**

   | Wizard 屏幕| 系统属性| 所用设置或命令
   |----------|----------|----------
   | 平台 (Platform)| 基于硬件创建新平台 (XSA) (Create a new platform from hardware (XSA))| 单击“Browse”按钮以添加 XSA 文件。
   | | 平台名称 (Platform Name)| vck190\_platform
   | 应用工程详情 (Application Project Details)| 应用工程名称 (Application project name)| helloworld\_a72
   | | 选择系统工程 (Select a system project)| +新建
   | | 系统工程名称 (System project name)| helloworld \_system
   | | 处理器 (Processor)| psv\_cortexa72\_0
   | 域 (Domain)| 选择域 (Select a domain)| +新建
   | | 名称| 分配的默认名称
   | | 显示名称 (Display Name)| 分配的默认名称
   | | 操作系统 (Operating System)| 独立
   | | 处理器 (Processor)| psv\_cortexa72\_0
   | | 架构| 64 位
   | 模板 (Templates)| 可用模板 (Available Templates)| Hello World

   执行完上述步骤后，Vitis 软件平台就会为平台工程 (vck190\_platform) 和系统工程 (helloworld\_system) 创建开发板支持封装，其中包含名为 helloworld\_a72 的应用工程，位于“Explorer”视图下。

3. 右键单击 **vck190\_platform** 并选择“**Build Project**”。或者，也可以单击 ![](media/image26.png)。

   > **注意**：如果无法看到 Project Explorer，请单击左侧面板上的复原图标 ![](media/image27.png) 然后执行步骤 3。

##### 修改 helloworld\_a72 应用源代码

1. 双击 **helloworld\_a72**，然后双击 **src** 并选择 **helloworld.c**。

   这样即可打开 helloworld\_a72 应用的 `helloworld.c` 源代码文件。

2. 修改 print 命令中的实参：

   ```
   print("Hello World from APU\n\r");
   print("Successfully ran Hello World application from APU\n\r");
   ```

   ![](./media/image28.png)

3. 单击 ![](./media/image29.png) 以构建该工程。

#### 在平台工程中添加新的 RPU 域

以下步骤演示了为 Arm Cortex-R5F 上的 TCM 创建裸机 Hello World 应用的过程。此应用需链接至域。创建应用工程前，请确保目标域软件环境可用。如果此环境不可用，请使用以下步骤将所需的域添加到您的平台中。

1. 双击“Vitis Explorer”视图中的 platform.spr 文件。（在此示例中，即 **vck190\_platform → platform.spr**）

2. 单击主视图中的 ![](./media/image30.png) 按钮。

3. 根据以下信息在“域 (Domain)”Wizard 屏幕中选择相应的选项。

   表 4：**新建域设置**

   | **Wizard 屏幕**| 字段| 所用设置或命令
   |----------|----------|----------
   | 域 (Domain)| 名称| r5\_domain
   | | 显示名称 (Display Name)| 自动生成
   | | 操作系统 (OS)| 独立
   | | 处理器 (Processor)| psv\_cortexr5\_0
   | | 受支持的运行时 (Supported Runtimes)| C/C++
   | | 架构| 32 位


4. 单击“**确定 (OK)**”。这样即可完成配置新生成的 r5\_domain。

   > **注意**：此时您会注意到在“Explorer”视图中的平台旁出现了“过期 (Out-of-date)”修饰器。

5. 单击 ![](./media/image26.png) 图标以构建平台。“Explorer”视图会在平台工程内显示生成的镜像文件。

#### 为 Arm Cortex-R5F 创建独立应用工程

以下步骤演示了为 Arm Cortex-R5F 创建 Hello World 应用的步骤。

1. 选择“**文件 (File) → 新建 (New) → 应用工程 (Application Project)**”。这样会打开“新建应用工程 (Creating a New Application Project)”Wizard。如果这是首次启动 Vitis IDE，那么您可在“Welcome”屏幕上选择“Create Application Project”。

   > **注意**：或者，您也可以选中“下次跳过欢迎屏幕 (Skip welcome page next time)”，这样即可每次启动时跳过欢迎页面。

2. 根据以下信息在 Wizard 屏幕中选择相应的选项。

   表 5：**系统属性设置**

   | Wizard 屏幕| 系统属性| 所用设置或命令
   |----------|----------|----------
   | 平台 (Platform)| 从存储库中选择平台| 选择 **vck190\_platform**
   | 应用工程详情 (Application Project Details)| 应用工程名称 (Application project name)| helloworld\_r5
   | | 选择系统工程 (Select a system project)| helloworld\_system
   | | 系统工程名称 (System project name)| helloworld \_system
   | | 目标处理器 (Target processor)| psv\_cortexr5\_0
   | 域 (Domain)| 选择域 (Select a domain)| r5\_domain
   | | 名称| r5\_domain
   | | 显示名称 (Display Name)| r5\_domain
   | | 操作系统 (Operating System)| 独立
   | | 处理器 (Processor)| psv\_cortexr5\_0
   | 模板 (Templates)| 可用模板 (Available Templates)| Hello World

   > **注意**：这样即可在现有系统工程 helloworld\_system 内生成独立应用 helloworld\_r5。

3. 右键单击 **vck190\_platform** 并选择“**Build Project**”。或者，您也可以单击 ![](./media/image29.png) 以构建工程。

##### 修改 helloworld\_r5 应用源代码

1. 展开 **helloworld\_r5** 并双击 **src**，然后选择 **helloworld.c** 以打开 helloworld\_r5 应用的 `helloworld.c` 源代码文件。

2. 修改 print 命令中的实参：

   ```
   print("Hello World from RPU\n\r");
   print("Successfully ran Hello World application from RPU\n\r");
   ```

   ![](./media/image31.png)

3. 单击 ![](./media/image29.png) 以构建该工程。

##### 为应用工程 helloworld\_r5 修改应用连接器脚本

以下步骤演示了为应用工程 helloworld\_r5 修改应用连接器脚本 (Application Linker Script) 的过程。

> **注意**：Vitis 软件平台提供了连接器脚本生成器用于简化为 GCC 创建连接器脚本的任务。连接器脚本生成器 GUI 会检验目标硬件平台并确认可用的存储器部分。您只需将 ELF 文件中的不同代码和数据部分分配至不同存储器区域即可。

1. 在“Vitis Explorer”视图中选择相应的工程 (helloworld\_r5)。

   > **注意**：如果平台上存在 DDR 内存，则连接器将使用 DDR 内存，否则将默认使用片上存储器 (OCM)。

2. 在 `src` 目录中，删除默认 `lscript.ld` 文件。

3. 右键单击 **helloworld\_r5** 并单击“**生成连接器脚本 (Generate Linker Script)**”。或者，您也可以选择“**Xilinx → Generate Linker Script**”。

   ![](./media/image32.png)

   > **注意**：在“Generate Linker Script”对话框中，左侧为只读，但“按如下方式修改工程构建设置 (Modify project build settings as follows)”字段中的“输出脚本名称 (Output Script name)”和工程构建设置除外。在右侧，有 2 个用于选择存储器分配方式的选项：“基本信息 (Basic)”选项卡或“高级 (Advanced)”选项卡。这 2 个选项执行的任务是相同的；但“Basic”选项卡粒度较低，将所有类型的数据都作为“数据”来处理，并将所有类型的指令都作为“代码”来处理。这通常足以完成大部分任务。使用“Advanced”选项卡可将软件块精准分配到各种类型的存储器中。

4. 针对“Basic”选项卡下的 3 个部分，在其下拉菜单中选择 **psv\_r5\_0\_atcm\_MEM\_0**，然后单击“**生成 (Generate)**”。

   ![](./media/image33.png)

   > **注意**：这样将在应用工程的 src 文件夹中生成新的连接器脚本 (`lscript.ld`)。

5. 右键单击 **helloworld \_system**，然后选择“**构建工程 (Build Project)**”，或者单击 ![](./media/image26.png)。这样即可在 helloworld\_r5 工程的 Debug 文件夹内生成工程的 elf 文件。

### 在 Vitis 软件平台中使用系统调试器以 JTAG 模式运行应用

要运行应用，则必须创建“运行配置 (Run configuration)”以采集用于执行应用的设置。您可为整个系统工程创建一种运行配置，或者也可以为各独立应用创建不同运行配置。

#### 为系统工程创建运行配置

1. 右键单击系统工程 **helloworld\_system** 并选择“**运行方式 (Run As) → 运行配置 (Run Configurations)**”。这样会打开“Run configuration”对话框。

2. 双击“**系统工程调试 (System Project Debug)**”以创建“Run Configuration”。

   Vitis 软件平台会创建新的运行配置，其名为：SystemDebugger\_helloworld\_system。对于其余选项，请参阅下表。

   表 6：**创建、管理和运行配置设置**

   | Wizard 选项卡| 系统属性| 所用设置或命令
   |----------|----------|----------
   | 主视图 (Main)| 工程 (Project)| helloworld\_system
   | | 目标 (Target) → 硬件服务器 (Hardware Server)| 随附到运行中的目标（本地）。如果尚未添加目标，请使用“新建 (New)”按钮添加目标。


3. 单击“**运行 (Run)**”。

   > **注意**：如果存在现有启动配置，则会显示 1 个对话框，询问您是否要终止此流程。单击“**Yes**”。这样会在终端上显示以下日志。

   ![](./media/image34.png)

#### 为系统工程内的单一应用创建运行配置

您可通过 2 种方式来为系统工程内的单一应用创建运行配置：

##### 方法 I

1. 右键单击系统工程 **helloworld\_system** 并选择“**运行方式 (Run As) → 运行配置 (Run Configurations)**”。这样会打开“Run configuration”对话框。

2. 双击“**系统工程调试 (System Project Debug)**”以创建“Run Configuration”。

   Vitis 软件平台会创建新的运行配置，其名为：SystemDebugger\_helloworld\_system\_1。将其重命名为 SystemDebugger\_helloworld\_system\_A72。对于其余选项，请参阅下表。

   表 7：**创建、管理和运行配置设置**

   | Wizard 选项卡| 系统属性| 所用设置或命令
   |----------|----------|----------
   | 主视图 (Main)| 工程 (Project)| helloworld\_system
   | | 仅调试所选应用 (Debug only selected applications)| 选中此框
   | | 所选应用 (Selected Applications)| 单击“**编辑 (Edit)**”按钮并勾选 helloworld\_a72
   | | 目标 (Target) → 硬件服务器 (Hardware Server)| 随附到运行中的目标（本地）。如果尚未添加目标，请使用“新建 (New)”按钮添加目标。


3. 单击“**应用 (Apply)**”。

4. 单击“**运行 (Run)**”。

   > **注意**：如果存在现有运行配置，则会显示 1 个对话框，询问您是否要终止此流程。单击“**Yes**”。这样会在终端上显示以下日志。

   ![](./media/image35.png)

> **注意**：APU 和 RPU 应用都会打印在相同控制台上，因为这两种应用使用的都是 UART0。应用软件会针对 APU 和 RPU 向 PS 部分的 UART0 外设发送 hello world 字符串。这些 hello world 字符串将从 UART0 逐字节发送到主机上运行的串行终端应用，在主机上会将其显示为字符串。

##### 方法 II

1. 右键单击应用工程 hello\_world\_r5 并选择“**Run As → Run Configurations**”。这样会打开“Run configuration”对话框。

2. 双击“**单工程调试 (Single Project Debug)**”以创建运行配置。

   Vitis 软件平台会创建新的运行配置，其名为：Debugger\_helloworld\_r5-Default。对于其余选项，请参阅下表。

   表 8：**创建、管理和运行配置设置**

   | Wizard 选项卡| 系统属性| 所用设置或命令
   |----------|----------|----------
   | 主视图 (Main)| 调试类型 (Debug Type)| 独立应用调试 (Standalone Application Debug)
   | | 连接 (Connection)| 连接至开发板。如果尚未连接，请在此处选择连接。
   | | 工程 (Project)| helloworld\_r5
   | | 配置 (Configuration)| 调试


3. 单击“**应用 (Apply)**”。

4. 单击“**运行 (Run)**”。

> **注意**：如果存在现有运行配置，则会显示 1 个对话框，询问您是否要终止此流程。单击“**Yes**”。这样会在终端上显示以下日志。

![](./media/image36.png)

## NoC（和 DDR）IP 核配置

本章节描述了 NoC（和 DDR）配置以及搭配本章前文中配置的 CIPS 使用所需的相关连接的信息。Versal™ ACAP CIPS IP 核允许您配置 2 个基于多核 Arm® Cortex™-A72 的超标量 APU、2 个 Arm Cortex™-R5F RPU、1 个平台管理控制器 (PMC) 和 1 个 CCIX PCIe® 模块 (CPM)。NoC IP 核支持配置 NoC 并启用 DDR 内存控制器。

### 在现有工程内配置 NoC IP 核

对于此示例，请启动 Vivado® Design Suite 和工程，并按[工程示例：使用 Versal ACAP 创建全新的嵌入式工程](./2-cips-noc-ip-config.md#使用-versal-acap-创建全新的嵌入式工程)中所示完成该工程的基本 CIPS 配置。

#### 配置设计

要配置设计，请执行以下步骤：

1. 打开[工程示例：使用 Versal ACAP 创建全新的嵌入式工程](./2-cips-noc-ip-config.md#使用-versal-acap-创建全新的嵌入式工程)中创建的设计 `edt_versal.xpr`。

2. 然后打开块设计 `edt_versal.bd`。

3. 在 Vivado Design Suite 的 Tcl 控制台中输入以下命令：

   ```
   apply_bd_automation -rule xilinx.com:bd_rule:versal_cips -config { apply_board_preset {0} configure_noc {Add new AXI NoC} num_ddr {1} pcie0_lane_width {None} pcie0_mode {None} pcie0_port_type {Endpoint Device} pcie1_lane_width {None} pcie1_mode {None} pcie1_port_type {Endpoint Device} pl_clocks {None} pl_resets {None}}  [get_bd_cells versal_cips_0]
   ```

4. 按 **Enter** 键。

5. 打开 AXI NoC IP。

6. 在“开发板 (Boards)”选项卡中，按下图所示配置设置，然后单击“**OK**”。

   ![axi-noc-ip-board](media/axi-noc-ip-board.png)

7. 单击设计中的 **sys\_clk\_0\_0** 管脚。

8. 在“外部接口属性 (External Interface Properties)”窗口中，选择“**属性 (Properties) → 配置 (CONFIG) → FREQ\_HZ**”，将频率更改为 200 MHz。

   ![external-interface](media/external-interface.png)

   这样即可添加 AXI NoC IP 以供 DDR 访问。

   ![](./media/image38.jpeg)

#### 验证设计并生成输出

要验证设计并生成输出，请执行以下步骤：

1. 右键单击“Diagram”窗口的空白区域，并选择“**Validate Design**”。或者，您可按 **F6** 键。这样会打开含以下消息的对话框：

   ![validation-message](media/validation_message.PNG)

2. 单击“**OK**”以关闭此消息。

3. 在“块设计源代码 (Block Design Sources)”窗口中的“Design Sources”下，展开 **edt\_versal\_wrapper**。

4. 右键单击标题为 edt\_versal\_i: edt\_versal 的顶层模块框图 (`edt_versal.bd`) 并选择“**Generate Output Products**”。

   这样会打开“Generate Output Products”对话框，如下图所示。

   ![](./media/image15.png)

   > **注意**：如果在 Windows 上运行 Vivado Design Suite，则“Run Settings”下的选项可能与此处所示选项不同。在此情况下，请使用默认设置继续执行操作。

5. 单击“**生成 (Generate)**”。

   此步骤将为所选源代码构建所有必需的输出文件。例如，您无需手动为 IP 处理器系统创建约束。当您选中“**Generate Output Products**”时，Vivado 工具会自动为处理器子系统生成 XDC 文件。

6. 当“Generate Output Products”进程完成后，请单击“**OK**”。单击底部窗口的“**设计运行 (Design Runs)**”选项卡，以查看“OOC Module Runs/Synthesis/Implementation runs”。

7. 在“Sources”窗口中，单击“**IP Sources**”视图。您可在此处查看刚生成的输出文件，如下图所示。

   ![](./media/image39.png)

#### 综合、实现和生成器件镜像

请遵循以下步骤为设计生成器件镜像。

1. 转至“**Flow Navigator → 编程与调试 (Program and Debug)**”，并单击“**生成器件镜像 (Generate Device Image)**”。

2. 这样会显示“无实现结果可用 (No Implementation Results Available)”菜单。单击“**Yes**”。

3. 这样会显示“启动运行 (Launch Run)”菜单。单击“**确定 (OK)**”。

   当“Device Image Generation”完成后，会显示“器件镜像生成已完成 (Device Image Generation Completed)”对话框。

4. 单击“**取消 (Cancel)**”关闭此窗口。

5. 生成器件镜像后，请导出硬件，并单击“**OK**”。

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

### 在 DDR 内存上运行裸机 Hello World 应用

在此示例中，您将了解如何管理开发板设置、连接电缆、通过 PC 将电缆连接至开发板以及如何在赛灵思 Vitis 软件平台中通过 Arm Cortex-A72 和 Arm Cortex- R5F 上的 DDR 内存来运行 Hello World 软件应用。

您将创建与[运行裸机 Hello World 应用](#运行裸机-hello-world-应用)中相似的新 Vitis 工程，区别在于此次将使用默认连接器脚本，该脚本将引用 DDR 内存。

1. 管理开发板设置、连接电缆、通过系统将电缆连接至开发板并按[运行裸机 Hello World 应用](#运行裸机-hello-world-应用)中的步骤 1 至 7 所述启动 Vitis 软件平台。

   > **注意**：需为此示例创建新的 Vitis 工作空间。请勿使用[运行裸机 Hello World 应用](#运行裸机-hello-world-应用)中创建的工作空间。

2. 为 Arm Cortex-A72 上运行的应用创建裸机 Hello World 系统工程，并按[为 Arm Cortex-A72 上的 OCM 创建 Hello World 应用](#为-arm-cortex-a72-上的-ocm-创建-hello-world-应用)的步骤 1 到 3 和[修改 helloworld\_a72 应用源代码](#修改-helloworld_a72-应用源代码)中的步骤 1 到 3 中所述，修改此应用的源代码。

3. 右键单击 **helloworld \_system** 并选择“**Build Project**”，或者单击 ![](./media/image29.png) 以在应用工程的 Debug 文件夹中生成项目 elf 文件。

4. 按[在平台工程中添加新的 RPU 域](#在平台工程中添加新的-rpu-域)的步骤 2 中所述，为平台创建另一个 RPU 域。

5. 在现有系统工程内创建在 Arm Cortex-R5F 上运行的裸机 Hello World 应用（在步骤 2 中构建），并按[为 Arm Cortex-R5F 创建独立应用工程](#为-arm-cortex-r5f-创建独立应用工程)的步骤 1 到 3 和[修改 helloworld\_r5 应用源代码](#修改-helloworld_r5-应用源代码)的步骤 1 到 3 中所述，修改此应用的源代码。

6. 右键单击 **helloworld \_system** 并选择“Build Project”，或者单击 ![](./media/image29.png) 以在应用工程的 Debug 文件夹中生成项目 elf 文件。

请参阅[在 Vitis 软件平台中使用系统调试器以 JTAG 模式运行应用](#在-vitis-软件平台中使用系统调试器以-jtag-模式运行应用)以了解如何在 Vitis 软件平台中使用系统调试器以 JTAG 模式运行以上构建的应用，并参阅[为独立应用生成启动镜像](./4-boot-and-config.md#为独立应用生成启动镜像)以了解如何为独立应用生成启动镜像。

© 2020 年赛灵思公司版权所有。
