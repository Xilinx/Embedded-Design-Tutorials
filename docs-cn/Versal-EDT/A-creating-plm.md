# 附录：创建 PLM

以下是在 Vitis™ 软件平台中创建 Platform Loader and Manager (PLM) elf 文件的步骤。在 Versal™ 器件中，PLM 在 PMC 内执行，并用于引导 APU 和 RPU。

1. 选择“**文件 (File) → 新建 (New) → 应用工程 (Application Project)**”。这样会打开“新建应用工程 (New ApplicationProject)”Wizard。

2. 根据下表中的信息在 Wizard 屏幕中选择相应的选项。

   表 10：**系统属性设置**

   | Wizard 屏幕| 系统属性| 所用设置或命令
   |----------|----------|----------
   | 平台 (Platform)| 基于硬件创建新平台 (XSA) (Create a new platform from hardware (XSA))| 单击“**Browse**”按钮以添加 XSA 文件。
   | | 平台名称 (Platform Name)| plm\_platform
   | 应用工程详情 (Application Project Details)| 应用工程名称 (Application project name)| plm
   | | 选择系统工程 (Select a system project)| +新建
   | | 系统工程名称 (System project name)| plm\_system
   | | 目标处理器 (Target processor)| psv\_pmc\_0
   | 域 (Domain)| 选择域 (Select a domain)| +新建
   | | 名称| 分配的默认名称
   | | 显示名称 (Display Name)| 分配的默认名称
   | | 操作系统 (Operating System)| 独立
   | | 处理器 (Processor)| psv\_pmc\_0   <br> **注意**：如果在处理器列表下未显示 psv\_pmc\_0 选项，那么请选中“硬件规格 (Hardware Specification)”选项中的“显示所有处理器 (Show all processors)”旁的复选框，以查看该应用工程可用的所有目标处理器。
   | | 架构| 32 位
   | 模板 (Templates)| 可用模板 (Available Templates)| Versal PLM



Vitis™ 软件平台会在“资源管理器 (Explorer)”视图下创建 plm 应用工程和 edt\_versal\_wrapper 平台。右键单击平台工程，然后选择“**构建工程 (Build Project)**”。构建平台工程后，请右键单击 plm\_system 工程，然后单击“**Build Project**”。这样即可在应用工程的 Debug 文件夹下生成 plm.elf 文件。构建好工程后，还请构建平台。

© 2020 年赛灵思公司版权所有。
