..
   Copyright 2000-2021 Xilinx, Inc.

   Apache ライセンス、バージョン 2.0 (以下「ライセンス」) に基づいてライセンス付与されています。
   「ライセンス」に準拠しないと、このファイルを使用することはできません。
   ライセンスのコピーは、次から入手できます。

       http://www.apache.org/licenses/LICENSE-2.0

   適切な法律で要求されるか、書面で同意された場合を除き、
   本ライセンスに基づいて配布されるソフトウェアは、明示的または黙示的を問わず、
   いかなる種類の保証または条件もなく、「現状のまま」配布されます。
   ライセンスに基づく権限と制限を管理する特定の言語については、
   ライセンスを参照してください。

***************
はじめに
***************

必要なツールが正しくインストールされ、環境が要件に適合していることを確認します。

=====================
ハードウェア要件
=====================

このチュートリアルでは、Versal™ ACAP VCK190 および VMK180 評価ボードをターゲットとしています。このチュートリアルのサンプル プロジェクトは VCK190 ES1 ボードを使用してテストされています。このガイドを使用するには、次のハードウェアが必要です。これらは、評価ボードに含まれています。

- VCK190/VMK180 ES1/プロダクション ボード
- AC 電源アダプター (12 VDC)
- USB Type-A/Micro ケーブル (UART 通信用)
- USB-Micro JTAG 接続を介するプログラムおよびデバッグ用の USB Micro ケーブル
- Linux ブート用の SD-MMC フラッシュ カード
- QSPI ドーター カード X_EBM-01、REV_A01
- OSPI ドーター カード X-EBM-03、REV_A02
- eMMC ドーター カード X-EBM-02 REV_A02

.. Note:: OSPI および eMMC ブート モードは、VCK190 および VMK180 RevB プロダクション ボードでのみサポートされています。

=========================
インストール要件
=========================

Vitis 統合デザイン環境および Vivado Design Suite
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Vitis™ 2021.1 ソフトウェア開発プラットフォームがインストールされていることを確認します。Vitis IDE は、ハードウェアおよびソフトウェアが 1 つのパッケージとして提供されるザイリンクス統合ツールです。Vitis IDE をインストールすると、Vivado ® Design Suite および Vitis 開発ツールの両方が自動的にインストールされます。インストール時に余分にオプションを選択する必要はありません。

.. note:: Visit `https://japan.xilinx.com/support/download.html <https://japan.xilinx.com/support/download.html>`__ から、最新バージョンをインストールしているかどうか確認してください。

Vivado Design Suite のインストールに関する詳細は、『Vitis 統合ソフトウェア プラットフォームの資料: エンベデッド ソフトウェア開発』 (`UG1400 <https://japan.xilinx.com/support/documentation/sw_manuals/xilinx2021_1/ug1400-vitis-embedded.pdf>`__) を参照してください。

PetaLinux ツール
~~~~~~~~~~~~~~~

このチュートリアルの Linux 部分の演習で実行する PetaLinux ツールをインストールします。PetaLinux ツールは、次のいずれかが稼働している Linux ホスト システムで実行します。

- Red Hat Enterprise Workstation/Server 7.4、7.5、7.6、7.7、7.8 (64 ビット)
- CentOS Workstation/Server 7.4、7.5、7.6、7.7、7.8 (64 ビット)
- Ubuntu Linux Workstation/Server 16.04.5、16.04.6、18.04.1、18.04.02、18.04.3、18.04.4 (64 ビット)

このツールは、専用 Linux ホスト システム、または Windows 開発プラットフォーム上でこれらの Linux オペレーティング システムのいずれかが稼働している仮想マシンを使用できます。

PetaLinux ツールを選択したシステムにインストールするには、次を実行する必要があります。

- PetaLinux 2021.1 ツールを、ザイリンクスのウェブサイトからダウンロードします。

- `サンプル プロジェクト: PetaLinux を使用した Linux イメージの作成 <../docs/5-system-design-example.rst#example-project-creating-linux-images-using-petalinux>`__ を参照し、該当する BSP をダウンロードします。

- ワークステーションまたは仮想マシンに共通のシステム パッケージおよびライブラリを追加します。詳細は、『PetaLinux ツールの資料: リファレンス ガイド』 (`UG1144 <https://japan.xilinx.com/support/documentation/sw_manuals/xilinx2021_1/ug1144-petalinux-tools-reference-guide.pdf>`__) および `PetaLinux リリース ノート 2021.1 <https://japan.xilinx.com/support/answers/75775.html>`__ を参照してください。

=============
必要な環境
=============

- 8 GB RAM (ザイリンクス ツールで推奨される最小サイズ)
- 2 GHz CPU クロックまたは同等の CPU (少なくとも 8 つのコア)
- 100 GB のハードディスク空き容量

PetaLinux パッケージの展開
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

PetaLinux ツールのインストールは簡単です。オプションを指定しない場合、PetaLinux ツールは現在のディレクトリにインストールされます。インストール先パスをオプションで指定することもできます。

たとえば、PetaLinux ツールを `/opt/pkg/petalinux/<petalinux-version>` にインストールするには、次のコマンドを使用します。

.. code-block:: bash

    $ mkdir -p /opt/pkg/petalinux/<petalinux-version>
    $ ./petalinux-v<petalinux-version>-final-installer.run --dir /opt/pkg/petalinux/<petalinux-version>


.. note:: インストール ディレクトリの権限を chmod 775 に変更すると、BitBake エラーが発生することがあります。これで、PetaLinux ツールが `/opt/pkg/petalinux/<petalinux-version>` ディレクトリにインストールされます。

詳細は、『PetaLinux ツールの資料: リファレンス ガイド』 (`UG1144 <https://japan.xilinx.com/cgi-bin/docs/rdoc?d=xilinx2021_1/ug1144-petalinux-tools-reference-guide.pdf>`__) を参照してください。

==================
ソフトウェアのライセンス
==================

ザイリンクスのソフトウェアには FLEXnet ライセンスが使用されています。ソフトウェアを初めて起動する際、ライセンスの検証プロセスが実行されます。ライセンス検証で有効なライセンスが検出されない場合、ライセンス ウィザードに従ってライセンスを取得し、インストールしたツールでそのライセンスを使用できるようにします。ソフトウェアのフル バージョンが不要な場合は、評価版ライセンスを使用できます。インストール手順と情報については、『Vivado Design Suite ユーザー ガイド: リリース ノート、インストール、およびライセンス』 (`UG973 <https://japan.xilinx.com/support/documentation/sw_manuals/xilinx2021_1/ug973-vivado-release-注記s-install-license.pdf>`__) を参照してください。

=====================
チュートリアルのデザイン ファイル
=====================

プロダクション シリコンのリファレンス デザイン ファイルは `ref_files <https://github.com/Xilinx/Embedded-Design-Tutorials/tree/master/docs/Introduction/Versal-EDT/ref_files>`__ ディレクトリにあります。

ラウンジには ES1 のデザイン ファイルがあります。

-----------------------------------------------

この資料は 2021 年 8 月 12 日時点の表記バージョンの英語版を翻訳したもので、内容に相違が生じる場合には原文を優先します。資料によっては英語版の更新に対応していないものがあります。日本語版は参考用としてご使用の上、最新情報につきましては、必ず最新英語版をご参照ください。

.. |trade|  unicode:: U+02122 .. TRADEMARK SIGN
   :ltrim:
.. |reg|    unicode:: U+000AE .. REGISTERED TRADEMARK SIGN
   :ltrim:

