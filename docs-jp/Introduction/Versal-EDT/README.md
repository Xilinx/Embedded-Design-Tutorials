# 概要

この資料では、VCK190/VMK180 評価ボードにザイリンクス Vivado® Design Suite フローを使用する方法について説明します。使用するツールは、Vivado Design Suite および Vitis™ 統合ソフトウェア プラットフォームのバージョン 2020.2 です。Vitis 統合ソフトウェア プラットフォームをインストールするには、『Vitis 統合ソフトウェア プラットフォームの資料: エンベデッド ソフトウェア開発 ([UG1400](https://japan.xilinx.com/cgi-bin/docs/rdoc?v=latest%3Bd%3Dug1400-vitis-embedded.pdf)) を参照してください。

> **注記:** このチュートリアルでのハードウェア上で Linux をブートする各手順は、2020.2 リリースの PetaLinux ツールに固有のものです。PetaLinux ツールは Linux ホスト マシンにインストールしないと、このガイドの Linux 部分の演習を実行できません。

> **重要:** VCK190/VMK180 評価キットには、Silicon Labs CP210x VCP USB-UART Bridge. が含まれます。これらのドライバーは必ずインストールしている必要があります。詳細は、『Silicon Labs CP210x USB-to-UART Installation Guide』 ([UG1033](https://japan.xilinx.com/cgi-bin/docs/bkdoc?k=install;v=latest;d=ug1033-cp210x-usb-uart-install.pdf)) を参照してください。

このガイドのサンプル プロジェクトは、64 ビットの Windows 10 オペレーティング システムで実行するザイリンクス ツール、Vitis ソフトウェア プラットフォームおよび 64 ビットの Linux オペレーティング システムで実行する PetaLinux を使用して作成されています。ほかの Windows インストールで別バージョンのツールを実行した場合、結果が異なることがあります。サンプル プロジェクトは、エンベデッド デザインの次の項目について紹介することに重点を置いています。

- **[Versal™ ACAP CIPS おうよび NoC (DDR) IP コアの設定](../Versal-EDT/docs/2-cips-noc-ip-config.md):** Versal™ ACAP CIPS (Control, Interfaces, and Processing System) IP コアと NoC を使用してデザインを作成し、 Arm® Cortex™-A72 および Cortex™-R5F プロセッサ上で単純な Hello World アプリケーションを実行する方法について説明します。この章では、簡単なデザインを例として使用し、ハードウェアおよびソフトウェア ツールの概要を説明します。

- **[Vitis ソフトウェア プラットフォームを使用したデバッグ](../Versal-EDT/docs/3-debugging.md):** ザイリンクス Vitis ソフトウェア プラットフォームのデバッグ機能を紹介します。この章では、前のデザインを使用してソフトウェアをベアメタル (OS なし) で実行して、Vitis IDE のデバッグ機能を示します。また、Versal ACAP のデバッグ コンフィギュレーションもリストします。

- **[ブートおよびコンフィギュレーション](../Versal-EDT/docs/4-boot-and-config.md):** Versal ACAP のブートイメージを設定および作成するためのコンポーネントの統合を示します。この章の主旨は、ブートローダーを統合およびロードする方法を理解することです。

- **[スカラー型エンジンと適応型エンジンを使用したシステム デザイン例](../Versal-EDT/docs/5-system-design-example.md): ** 使用可能なツールとサポートされるソフトウェア ブロックを使用して、Versal ACAP 上にシステムを構築する方法について説明します。この章では、Vivado ツールで PL AXI GPIO を使用してエンベデッド デザインを作成する方法について説明します。また、Versal デバイス上で Arm Cortex-A72 コア ベースの APU 用の Linux オペレーティング システムをコンフィギュレーションしてビルドする手順についても説明します。

- **[SmartLynq+ モジュールを使用した高速デバッグ ポート (HSDP) のシステム デザイン例](../Versal-EDT/docs/6-system-design-example-HSDP.md): ** 高速デバッグ ポート (HSDP) を使用して Versal ACAP 上にシステムを構築する方法について説明します。この章では、Vivado ツールで HSDP を利用し、Linux イメージのダウンロードに SmartLynq+ モジュールを使用するエンベデッド デザインを作成する方法について説明します。

このデザイン チュートリアルでは、ザイリンクスの提供する多数のファイルを使用する必要があります。これらは、ザイリンクス ウェブサイトからダウンロードできる ZIP ファイルに含まれます  （[はじめに](../Versal-EDT/docs/1-getting-started.md)を参照）。このチュートリアルでは ZIP ファイルの内容が `C:\edt` に抽出されていることを前提にしています。

## この資料に関連する設計プロセス

ザイリンクスの資料は、開発タスクに関連する内容を見つけやすいように、標準設計プロセスに基づいて構成されています。この資料では、次の設計プロセスについて説明します。

* **システムおよびソリューション プランニング**: システム レベルのコンポーネント、パフォーマンス、I/O、およびデータ転送要件を特定します。ソリューションの PS、PL 、および AI エンジンへのアプリケーション マッピングも含みます。

  * [既存のプロジェクトでの NoC IP コアの設定](../Versal-EDT/docs/2-cips-noc-ip-config.md#configuring-the-noc-ip-core-in-an-existing-project)
  * [スカラー型エンジンと適応型エンジンを使用したシステム デザイン例](../Versal-EDT/docs/5-system-design-example.md)

* **エンベデッド ソフトウェア開発**: ハードウェア プラットフォームからソフトウェア プラットフォームを作成し、エンベデッド CPU を使用してアプリケーションを開発します。XRT および Graph API についても説明します。

  * [ベアメタルの Hello World アプリケーションの実行](../Versal-EDT/docs/2-cips-noc-ip-config.md#running-a-bare-metal-hello-world-application)
  * [Vitis ソフトウェア プラットフォームでのシステム デバッガーを使用した JTAG モードでのアプリケーションの実行](../Versal-EDT/docs/2-cips-noc-ip-config.md#running-applications-in-the-jtag-mode-using-the-system-debugger-in-the-vitis-software-platform)
  * [DDR メモリでのベアメタル Hello World アプリケーションの実行](../Versal-EDT/docs/2-cips-noc-ip-config.md#running-a-bare-metal-hello-world-application-on-ddr-memory)

* **ハードウェア、IP、およびプラットフォーム開発**: ハードウェア プラットフォーム用の PL IP ブロックの作成、PL カーネルの作成、サブシステムの論理シミュレーション、および Vivado のタイミング、リソース使用、消費電力クロージャの評価を実行します。システム統合用のハードウェア プラットフォームの開発も含まれます。この資料では、次のトピックがこの設計プロセスに関連します。

  * [CIPS IP コアの設定](../Versal-EDT/docs/2-cips-noc-ip-config.md#cips-ip-core-configuration)
  * [NoC (および DDR) IP コアの設定](../Versal-EDT/docs/2-cips-noc-ip-config.md#noc-and-ddr-ip-core-configuration)
  * [デザイン例: AXI GPIO の使用](../Versal-EDT/docs/5-system-design-example.md#design-example-using-axi-gpio)

* **システム統合および検証**: タイミング、リソース使用量、消費電力クロージャを含むシステムの機能的なパフォーマンスを統合して検証します。この資料では、次のトピックがこの設計プロセスに関連します。

  * [ブートおよびコンフィギュレーション](../Versal-EDT/docs/4-boot-and-config.md)
  * [サンプル プロジェクト: RPU を使用した FreeRTOS GPIO アプリケーション プロジェクト](../Versal-EDT/docs/5-system-design-example.md#example-project-freertos-gpio-application-project-with-rpu)
  * [サンプル プロジェクト: PetaLinux を使用した Linux イメージの作成](../Versal-EDT/docs/5-system-design-example.md#example-project-creating-linux-images-using-petalinux)

© Copyright 2020-2021 Xilinx, Inc.

Apache ライセンス、バージョン 2.0 (以下「ライセンス」) に基づいてライセンス付与されています。本ライセンスに準拠しないと、このファイルを使用することはできません。ライセンスのコピーは、[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0) から入手できます。

適切な法律で要求されるか、書面で同意された場合を除き、本ライセンスに基づいて配布されるソフトウェアは、明示的または黙示的を問わず、いかなる種類の保証または条件もなく、「現状のまま」配布されます。ライセンスに基づく権限と制限を管理する特定の言語については、ライセンスを参照してください。

<p align="center"><sup>この資料は 2021 年 3 月 30 日時点の表記バージョンの英語版を翻訳したもので、内容に相違が生じる場合には原文を優先します。資料によっては英語版の更新に対応していないものがあります。
日本語版は参考用としてご使用の上、最新情報につきましては、必ず最新英語版をご参照ください。</sup></p>
