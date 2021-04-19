# 入门指南

请确保您已正确安装所需工具，并且您的环境符合要求。

## 硬件要求

本教程对应目标为 Versal ACAP VCK190 和 VMK 180 评估板。本教程中的示例已使用 VCK190 ES1 评估板经过测试。要使用本教程，您需要具备以下硬件项，这些硬件项均随附于该评估板中：

- VCK 190/VMK 180 ES1 评估板
- 交流电源适配器 (12 VDC)
- USB Type-A 转 Micro USB 转接线（用于 UART 通信）
- Micro USB 线用于通过 USB-Micro JTAG 连接进行编程和调试
- SD-MMC 闪存卡，用于启动 Linux
- QSPI 子卡 X\_EBM-01 REV\_A01
- OSPI 子卡 X-EBM-03 REV\_A02

## 安装要求

### Vitis 集成设计环境和 Vivado Design Suite

请确保您已安装 Vitis 2020.2 软件开发平台。Vitis IDE 是赛灵思统一工具，以封装形式随附所有硬件和软件。安装 Vitis IDE 时，将自动获得 Vivado Design Suite 和 Vitis IDE。您无需在安装程序中执行任何其它选择。

> **注意**：请访问 <https://china.xilinx.com/support/download.html> 以确认您的工具为最新版本。

如需获取有关安装 Vivado Design Suite 的更多信息，请参阅《Vitis 统一软件平台文档：嵌入式软件开发》([UG1400](https://china.xilinx.com/cgi-bin/docs/rdoc?v=latest;d=ug1400-vitis-embedded.pdf))。

### PetaLinux 工具

安装 PetaLinux 工具，以便在本工具的 Linux 部分中运行这些工具。PetaLinux 工具在 Linux 主机系统下运行，此系统运行下列工具的任一版本：

- Red Hat Enterprise Workstation/Server 7.4、7.5、7.6、7.7、7.8（64 位）
- CentOS Workstation/Server 7.4、7.5、7.6、7.7、7.8（64 位）
- Ubuntu Linux Workstation/Server 16.04.5、16.04.6、18.04.1、18.04.02、18.04.3、18.04.4（64 位）

您可使用专用 Linux 主机，或者也可以使用在 Windows 开发平台上运行以上任一 Linux 操作系统的虚拟机。

在您所选系统上安装 PetaLinux 工具时，必须执行下列操作：

- 从赛灵思网站下载 PetaLinux 2020.2 软件。

- 下载相应的 BSP，欲知详情，请参阅[工程示例：使用 PetaLinux 创建 Linux 镜像](./5-system-design-example.md#工程示例使用-petalinux-创建-linux-镜像)。

- 将常用系统封装和库添加到工作站或虚拟机上。如需了解更多信息，请参阅《PetaLinux 工具文档：参考指南》([UG1144](https://china.xilinx.com/cgi-bin/docs/rdoc?v=latest;d=c_ug1144-petalinux-tools-reference-guide.pdf)) 中的“安装要求”以及 [PetaLinux 版本说明：2020.2](https://xilinx.sharepoint.com/sites/XKB/SitePages/Articleviewer.aspx?ArticleNumber=75775)。

## 要求

- 8 GB RAM（针对赛灵思工具推荐的最低要求）
- 2 GHz CPU 时钟或同等频率（至少 8 核）。
- 100 GB 可用 HDD 空间

### 解压 PetaLinux 封装

PetaLinux 工具采用直通式安装。PetaLinux 工具将被直接安装到当前工作目录中，无附加选项。或者，您也可以指定安装路径。

例如，要将 PetaLinux 工具安装至 `/opt/pkg/petalinux/<petalinux-version>` 下，请执行以下操作：

```
$ mkdir -p /opt/pkg/petalinux/<petalinux-version>
$ ./petalinux-v<petalinux-version>-final-installer.run --dir /opt/pkg/petalinux/<petalinux-version>
```

> **注意**：切勿将安装目录权限更改为 CHMOD 775，否则将产生 BitBake 错误。这样即可将 PetaLinux 工具安装到 `/opt/pkg/petalinux/<petalinux-version>` 目录中。

如需了解更多信息，请参阅《PetaLinux 工具文档：参考指南》([UG1144](https://china.xilinx.com/cgi-bin/docs/rdoc?v=latest;d=c_ug1144-petalinux-tools-reference-guide.pdf))。

#### 软件许可

赛灵思软件使用 FLEXnet 许可证。首次运行软件时，它会执行许可证验证流程。如果许可证验证并未找到有效许可证，那么“License”Wizard 会指导您逐步完成相应流程以获取许可证并确保该许可证可用于所安装的工具。如果您不需要完整版本的软件，则可使用评估许可证。如需了解安装指令和安装信息，请参阅《Vivado Design Suite 用户指南：版本说明、安装和许可》([UG973](https://china.xilinx.com/cgi-bin/docs/rdoc?v=2020.2;d=c_ug973-vivado-release-notes-install-license.pdf))。

#### 教程设计文件

1. 从赛灵思网站下载[参考设计文件](https://china.xilinx.com/cgi-bin/docs/ctdoc?cid=12516610-29d7-4627-bd77-dbfaa3a50ef0;d=ug1305-versal-embedded-tutorial.zip)。

2. 将 ZIP 文件内容解压至您具有可写权限的任何位置。

要查看 ZIP 文件的内容，请下载 ZIP 文件，并将其内容解压至 `C:\edt`。设计文件中包含 XSA 文件、源代码和预构建的镜像，适用于所有部分。

© 2020 年赛灵思公司版权所有。
