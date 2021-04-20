# 付録: PLM の作成

次に、Vitis™ ソフトウェア プラットフォームでプラットフォーム ローダーおよびマネージャー (PLM) の ELF ファイルを作成する手順を示します。Versal™ デバイスでは、PLM は PMC で実行され、APU および RPU のブートストラップに使用されます。

1. **[File] → [New] → \[Application Project]** をクリックします。New Application Project ウィザードが開きます。

2. ウィザードの各ページで次の表の情報にづいて設定を選択します。

   **表 10: システム プロパティ設定**

   | ウィザード ページ| システム プロパティ| 設定または使用するコマンド
   |----------|----------|----------
   | Platform| Create a new platform from hardware (XSA)| **\[Browse]** ボタンをクリックして XSA ファイルを追加
   | | Platform name| plm_platform
   | Application Project Details| Application project name| plm
   | | システム プロジェクトを選択| +Create New
   | | System project name| plm_system
   | | Target processor| psv_pmc_0
   | Domain| Select a domain| +Create New
   | | Name| デフォルト名入力済み
   | | Display Name| デフォルト名入力済み
   | | Operating System| standalone
   | | Processor| psv_pmc_0   <br> **注記:** プロセッサのリストに psv_pmc_0 オプションが表示されない場合は、[Show all processors in the hardware specification] オプションの横にあるチェック ボックスをオンにして、アプリケーション プロジェクトで使用可能なすべてのターゲットプロセッサを表示します。
   | | Architecture| 32-bit
   | Templates| Available Templates| Versal PLM



Vitis ソフトウェア プラットフォームは、[Explorer] ビューの下に PLM アプリケーション プロジェクトと edt_versal_wrapper プラットフォームを作成します。プラットフォーム プロジェクトを右クリックし、**\[Build Project]** をクリックします。プラットフォーム プロジェクトをビルドしたら、plm_system プロジェクトを右クリックし、**\[Build Project]** をクリックします。これにより、アプリケーション プロジェクトの Debug フォルダー内に `plm.elf` ファイルが生成されます。プロジェクトをビルドしたら、プラットフォームもビルドします。

© Copyright 2020-2021 Xilinx, Inc.

Apache ライセンス、バージョン 2.0 (以下「ライセンス」) に基づいてライセンス付与されています。本ライセンスに準拠しないと、このファイルを使用することはできません。ライセンスのコピーは、[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0) から入手できます。

適切な法律で要求されるか、書面で同意された場合を除き、本ライセンスに基づいて配布されるソフトウェアは、明示的または黙示的を問わず、いかなる種類の保証または条件もなく、「現状のまま」配布されます。ライセンスに基づく権限と制限を管理する特定の言語については、ライセンスを参照してください。

<p align="center"><sup>この資料は 2021 年 3 月 30 日時点の表記バージョンの英語版を翻訳したもので、内容に相違が生じる場合には原文を優先します。資料によっては英語版の更新に対応していないものがあります。
日本語版は参考用としてご使用の上、最新情報につきましては、必ず最新英語版をご参照ください。</sup></p>
