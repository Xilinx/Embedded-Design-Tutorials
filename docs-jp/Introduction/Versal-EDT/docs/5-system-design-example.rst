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

**************************************************************
スカラー型エンジンと適応型エンジンを使用したシステム デザイン例
**************************************************************

この章では、使用可能なツールとサポートされているソフトウェア ブロックを使用して、Versal |trade| デバイスをベースにしたシステムを構築する方法を説明します。この章では、Vivado |reg| ツールで PL AXI GPIO および PL AXI UART を使用してエンベデッド デザインを作成する方法について説明します。また、Versal ACAPデバイス上で Arm |reg| Cortex |trade|-A72 コア ベースの APU 用の Linux オペレーティング システムをコンフィギュレーションしてビルドする手順についても説明します。

この章では、PetaLinux ツールの使用例についても説明します。

==============================
デザイン例: AXI GPIO の使用
==============================

Linux アプリケーションは、PL ベースの AXI GPIO インターフェイスを使用してボードの DIP スイッチを監視し、ボードの LED を制御します。LED アプリケーションは、VMK180 および VCK190 ボードの両方で実行できます。

RPU アプリケーションは、PL ベースの AXI UART lite を使用して、PS UART コンソールではなく AXI UART コンソールにデバッグ メッセージを表示します。PL UART アプリケーションは VMK180 および VCK190 ボードの両方で実行できます。

ハードウェアの設定
~~~~~~~~~~~~~~~~~~~~

このデザインの最初の手順として、PS セクションと PL セクションを設定します。これは、Vivado IP インテグレーターを使用して実行できます。まず Vivado IP カタログから必要な IP を追加し、PS サブシステムのブロックにコンポーネントを接続します。ハードウェアを設定する方法は、次のとおりです。

.. note:: Vivado Design Suite が既に開いている場合は、手順 3 へ進みます。

1. `「Versal ACAP CIPS および NoC (DDR) IP コアの設定」 <../docs/2-cips-noc-ip-config.rst>`__ で作成した Vivado プロジェクトを開きます。

   `C:/edt/edt_versal/edt_versal.xpr`

2. Flow Navigator の **[IP Integrator]** → **[Open Block Design]** をクリックします。

   .. image:: ./media/image5.png

3. ブロック図で右クリックし、**[Add IP]** をクリックします。

IP ブロックを接続して完全なシステムを作成
------------------------------------------------

IP ブロックを接続してシステムを作成する手順は、次のとおりです。

1. Versal ACAP CIPS IP コアをダブルクリックします。

2. **[PS-PMC]** → **[PL-PS Interfaces]** をクリックします。

   .. image:: ./media/image60.png

3. M_AXI_FPD インターフェイスをイネーブルにし、**[Number of PL Resets]** を 1 に設定します (前の図を参照)。

4. **[Clocking]** をクリックし、**[Output Clocks]** タブをクリックします。

5.[PMC Domain Clocks] を展開します。次に、[PL Fabric Clocks] を展開します。次の図のように PL0_REF_CLK を 300 MHz に設定します。

   .. image::./media/image61.png

6. **[Finish]** および **[OK]** をクリックして設定を完了し、ブロック図に戻ります。

IP アドレスの追加および設定
-----------------------------------

IP アドレスを追加および設定する手順は、次のとおりです。

1. ブロック図を右クリックし、**[Add IP]** をクリックして IP カタログから IP を追加します。

2. AXI GPIO を検索し、**[AXI GPIO]** をダブルクリックしてブロック図に追加します。

3. AXI GPIO IP の別のインスタンスをデザインに追加します。

4. IP カタログで **AXI Uartlite** を検索し、デザインに追加します。

5. [Block Design] ビューで **[Run Connection Automation]** をクリックします。
    
   .. image:: ./media/image62.png

   [Run Connection Automation] ダイアログ ボックスが開きます。

6. [Run Connection Automation] ダイアログ ボックスで、[All Automation] をオンにします。

   .. image:: ./media/image63.png

   これにより、AXI GPIO IP のすべてのポートの自動化がチェックされます。

7. `axi_gpio_0` の **GPIO** をクリックし、次に示すように [Select Board Part Interface] を **[Custom]** に設定します。

   .. image:: ./media/image64.jpg

8. `axi_gpio_1` の GPIO も同じ設定にします。

9. `Axi_gpio_0` の **S_AXI** をクリックします。次の図に示すように設定します。

   .. image:: ./media/image65.jpg

10. `axi_gpio_1` の S_AXI も同じ設定にします。

11. `axi_uartlite_0` の **S_AXI** をクリックします。次の図に示すように設定します。

    .. image:: media/s-axi-uartlite.png

12. これにより、次の接続が設定されます。

    - CIPS と AXI GPIO IP 間のブリッジ IP として SmartConnect を使用して `S_AXI of AXI_GPIO` と AXI Uartlite を `M_AXI_FPD` に接続します。
    - プロセッサ システム リセット IP をイネーブルにします。
    - `pl0_ref_clk` をプロセッサ システム リセット、AXI GPIO、および SmartConnect IP クロックに接続します。
    - SmartConnect および AXI GPIO のリセットをプロセッサ システム リセット IP の `peripheral_aresetn` に接続します。

13. `axi_uartlite_0` の **UART** をクリックします。次の図に示すように設定します。

    .. image:: media/uart.png

14. **[OK]** をクリックします。

15. [Block Design] ビューで **[Run Connection Automation]** をクリックし、[All Automation] チェック ボックスをオンにします。

16. **ext_reset_in** をクリックして、次のように設定します。

    .. image:: ./media/image66.jpg

    これにより、Prosessor System Reset IP の `ext_reset_in` が CIPS の `pl_resetn` に接続されます。

17. **[OK]** をクリックします。

18. プロセッサ システム リセット IP の `peripheral_aresetn` から SmartConnect IP の `aresetn` への接続を解除します。

19. SmartConnect IP の `aresetn` を Prosessor System Reset IP の `interconnect_aresetn` に接続します。

    .. image:: ./media/image67.jpeg

20. axi_gpio_0 IP をダブルクリックして開きます。

21. 次の図のように [IP Configuration] タブを設定します。

    .. image:: ./media/image68.png

22. axi_gpio_1 も同じ設定にします。

23. Slice IP のインスタンスをさらに 4 つ追加します。

24. AXI GPIO IP の外部ピンを削除し、インターフェイスを展開します。

25. axi_gpio_0 の出力ピン gpio_io_0 をスライス 0 およびスライス 1 に接続します。

26. 同様に、axi_gpio_1 の出力ピン gpio_io_0 をスライス 2 およびスライス 3 に接続します。

27. Slice IP の出力を外部接続 (Make External) にします。

28. 次のように各 Slice IP を設定します。

    .. image:: ./media/image69.png

    .. image:: ./media/image70.png

    .. image:: ./media/image71.png

    .. image:: ./media/image72.png

29. **axi_uartlite_0** をダブルクリックし、IP を開きます。

30. 次のように [Board] タブでボード インターフェイスを設定します。

    .. image:: media/board-interface.png
    
31. 次の図のように [IP Configuration] タブを設定します。

    .. image:: media/configure-ip-settings.png

32. **[Clock Wizard IP]** を追加します。IP をダブルクリックして開きます。

33. [Clocking Features] タブに移動し、次のように設定します。

    .. image:: media/clocking-features.png

34. [Input Clock Information] の [Source] オプションを [Global buffer] に設定します。
    
35. [Output Clocks] タブに移動し、次のように設定します。

    .. image:: media/output-clocks-tab.png

36. CIPS の `pl0_ref_clk` を右クリックし、**[Disconnect Pin]** をクリックします。

37. CIPS からの `pl0_ref_clk` をクロッキング ウィザードの入力 `clk_in1` に接続します。

38. クロッキング ウィザードの出力を Processor System Reset IP の `slowest_sync_clock` に接続します。

    これでタイミング エラーを回避しやすくなります。 

ブロック デザイン全体が次のようになります。

.. image:: media/image73.png

デザインの検証および出力の生成
-----------------------------------------------

デザインを検証し、出力ファイルを生成するには、次の手順を実行します。

1. [Block Design] ビューに戻り、ブロック デザインを保存します (**Ctrl+S** キーを押す)。

2. [Diagram] ビューの空白部分を右クリックして、**[Validate Design]** をクリックします。または、**F6** キーを押します。

    次のメッセージを示すダイアログ ボックスが開きます。

    .. image:: ./media/validation_message.PNG

3. **[OK]** をクリックしてメッセージを閉じます。

4. **[Sources]** ウィンドウをクリックします。

   1. 制約を展開します。

   2. **constrs_1** を右クリックし、**[Add Sources]** をクリックします。

      [Add Sources] ウィンドウが開きます。

   3. **[Add or Create Constraints]** オプションを選択し、**[Next]** をクリックします。

   4. 追加する .xdc ファイルを選択します。

      .. note:: 制約ファイルは `pl_gpio_uart/constrs` フォルダーにパッケージの一部として含まれます。
    
   5. **[Finish]** をクリックします。

5. **[Hierarchy]** タブをクリックします。

6. [Sources] ウィンドウの [Design Sources] の下の **[edt_versal_wrapper]** を展開します。

7. edt_versal_i : edt_versal (`edt_versal.bd`) という最上位ブロックを右クリックし、**[Generate Output Products]** をクリックします。

   .. image:: ./media/image15.png

8. **[Generate]** をクリックします。

9. [Generate Output Products] の処理が完了したら、**[OK]** をクリックします。

10. [Sources] ウィンドウで **[IP Sources]** ビューをクリックします。次の図に示すように、生成した出力ファイルが表示されます。

    .. image:: ./media/image74.png

デバイス イメージの合成、インプリメント、生成
-----------------------------------------------------------

デザインのデバイス イメージを生成するには、次の手順を実行します。

1. **Flow Navigator** の **[Program and Debug]** をクリックし、**[Generate Device Image]** をクリックし、**[OK]** をクリックします。

2. [No Implementation Results Available] メニューが表示されます。**[Yes]** をクリックします。

3. [Launch Run] メニューが表示されます。**[OK]** をクリックします。

   デバイス イメージの生成が完了すると、[Device Image Generation Completed] ダイアログ ボックスが開きます。

4. **[Cancel]** をクリックしてウィンドウを閉じます。

5. デバイス イメージを生成したら、ハードウェアをエクスポートします。

   .. note:: 次の手順はオプションなので、省略して「-ハードウェアの、[エクスポートされたハードウェア](#exporting-hardware) セクションに進むこともできます。これらの手順を実行すると、デバイス イメージを生成する前に合成およびインプリメンテーションを実行するので、デバイス イメージ生成の詳細なフローがわかるようになります。デバイス イメージの生成フローを理解する必要がある場合は、次の手順を実行します。

6. **Flow Navigator** で **[Synthesis]** をクリックし、**[Run Synthesis]** をクリックします。

   .. image:: media/image17.png

7. 合成の開始前にプロジェクトを保存するようメッセージが表示された場合は、**[Save]** をクリックします。

   合成の実行中、ウィンドウの右上にステータス バーが表示されます。このステータス バーは、デザイン プロセスをとおして、さまざまな理由により表示されます。ステータス バーは、プロセスがバックグランドで実行されていることを示します。合成が完了すると、[Synthesis Completed] ダイアログ ボックスが開きます。

8. **[Run Implementation]** をクリックして **[OK]** をクリックします。

   インプリメンテーションが完了すると、[Implementation Completed] ダイアログ ボックスが開きます。

9. **[Generate Device Image]** をクリックして **[OK]** をクリックします。

   デバイス イメージの生成が完了すると、[Device Image Generation Completed] ダイアログ ボックスが開きます。

10. **[Cancel]** をクリックしてウィンドウを閉じます。

    デバイス イメージを生成したら、ハードウェアをエクスポートします。

ハードウェアのエクスポート
------------------

1. Vivado のメイン メニューから **[File]** → **[Export]** → **[Export Hardware]** をクリックします。[Export Hardware] ダイアログ ボックスが開きます。

2. **[Include bitstream]** を選択し、**[Next]** をクリックします。
 
3. エクスポートしたファイルの名前を入力し (またはデフォルトを使用し)、ディレクトリを選択します。**[Next]** をクリックします。

   ハードウェア モジュールが既にエクスポートされている場合は、警告メッセージが表示されます。既存の XSA ファイルを上書きするかどうか尋ねるメッセージが表示されたら、**[Yes]** をクリックします。

4. **[Finish]** をクリックします。

====================================================================
サンプル プロジェクト: RPU を使用した FreeRTOS AXI UARTLITE アプリケーション プロジェクト
====================================================================

このセクションでは、Versal デバイス上で Arm Cortex-R5F コア ベースの RPU 用の FreeRTOS アプリケーションをコンフィギュレーションしてビルドする手順について説明します。

次の手順は、Arm Cortex-R5F から FreeRTOS アプリケーションを作成する手順を示しています:

1. Vitis |trade| IDE を起動し、`c:/edt/freertos` などの新しいワークスペースを作成します。
   
2. **[File]** → **[New]** → **[Application Project]** をクリックします。**[Create a New Application Project]** ページが開きます。Vitis IDE を初めて起動した場合は、次の図に示す Welcome 画面で **[Create Application Project]** を選択できます。

   .. image:: ./media/image75.jpeg

   .. note:: オプションで、[**Skip welcome page next time] チェック ボックスをオンにすると、毎回 Welcome ページを表示しないようにすることもできます。

3. Vitis IDE には、ターゲット プラットフォーム、システム プロジェクト、ドメイン、テンプレートの 4 つのコンポーネントがあります。 Vitis IDE で新しいアプリケーション プロジェクトを作成するには、次の手順に従います。

   1. ターゲット プラットフォームには、ベース ハードウェア デザインと、宣言されたインターフェイスにアクセラレータを接続するのに使用されたメタデータが含まれます。プラットフォームを選択するか、Vivado Design Suite からエクスポートした XSA からプラットフォーム プロジェクトを作成します。
   2. アプリケーション プロジェクトをシステム プロジェクトに配置し、プロセッサに関連付けます。
   3. ドメインでは、ターゲット プラットフォームでホスト プログラムを実行するのに使用されるプロセッサおよびオペレーティング システムを定義します。
   4. アプリケーションのテンプレートを選択して、開発を迅速に開始します。ウィザードの各ページで次の表の情報に基づいて設定を選択します。

    **表 9: ウィザード情報**

    +---------------+-------------------------+---------------------------+
    | Wizard Screen | System Properties       | Setting or Command to Use |
    +===============+=========================+===========================+
    | Platform      | Create a new platform   | Click Browse to add your  |
    |               | from hardware (XSA)     | XSA file                  |
    +---------------+-------------------------+---------------------------+
    |               | Platform Name           | vck190_platform           |
    +---------------+-------------------------+---------------------------+
    | Application   | Application project     | freertos_gpio_test        |
    | Project       | name                    |                           |
    | Detail        |                         |                           |
    +---------------+-------------------------+---------------------------+
    |               | Select a system project | +Create New               |
    +---------------+-------------------------+---------------------------+
    |               | System project name     | freertos_gpio_test_system |
    +---------------+-------------------------+---------------------------+
    |               | Processor               | versal_cips               |
    |               |                         | _0_pspmc_0_psv_cortexr5_0 |
    +---------------+-------------------------+---------------------------+
    | Dom           | Select a domain         | +Create New               |
    +---------------+-------------------------+---------------------------+
    |               | Name                    | The default name assigned |
    +---------------+-------------------------+---------------------------+
    |               | Display Name            | The default name assigned |
    +---------------+-------------------------+---------------------------+
    |               | Operating System        | freertos10_xilinx         |
    +---------------+-------------------------+---------------------------+
    |               | Processor               | versal_cips               |
    |               |                         | _0_pspmc_0_psv_cortexr5_0 |
    +---------------+-------------------------+---------------------------+
    | Templates     | Available               | Freertos Hello            |
    +---------------+-------------------------+---------------------------+
    |               | Templates               | world                     |
    +---------------+-------------------------+---------------------------+
 
Vitis ソフトウェア プラットフォームは、上記の手順を実行した後、Explorer ビューの**下に、プラットフォーム プロジェクト (**vck190_platform**) と **freertos_gpio_test** というアプリケーション プロジェクトを含むシステム プロジェクト (**freertos_gpio_test_system**) のボード サポート パッケージを作成します。

4. `src/` の下にある `freertos_hello_world.c` ファイルを右クリックし、`freertos_hello_world.c` ファイルを削除します。FreeRTOS プロジェクト パスから freertos ソース コード ファイルをコピーします。
`<design-package>/ch5_system_design_example_source__files/rpu/` を `src/` ディレクトリにコピーします。
   
5. FreeRTOS ボード サポート パッケージの下で、XilPM ライブラリを有効にするように Vitis IDE を設定します。 

   vck190_platform プロジェクトの下の `platform.spr` に移動し、[Board support package] の下の **[Modify BSP]** を選択し、図に示すように <Y> オプションを押して、XilPM ライブラリを有効にします。

   .. image:: media/vitis_xilpm_enable.JPG

6. Vitis IDE で [FreeRTOS Board Support Package] の下の RPU 用の AXI UARTLITE アプリケーション デバッグ コンソールをオンします。

   vck190_platform プロジェクトの下の `platform.spr` に移動し、[Board support package] の下の **[Modify BSP]** 設定をオンにし、図に示すように <Y> オプションを押して stdin と stdout を **axi_uarlite_0** に変更します。

   .. image:: media/vitis_uartlite_enable.JPG

7. **[OK]** をクリック して上記の設定を保存し、コンフィギュレーション ウィザードを終了します。

8. **freertos_gpio_test_system** を右クリックし、**[Build Project]** をクリックします。または、|build| をクリックします。

Linux イメージをビルドし、FreeRTOS ELF をイメージに組み込む方法については、`サンプル プロジェクト: PetaLinux を使用した Linux イメージの作成 <./5-system-design-example.rst#example-project-creating-linux-images-using-petalinux>`__ を参照してください。

9. PL AXI UART シリアル コンソールでは、RPU デバッグ ログが次のように表示されます。

   .. code-block::
   
      Gpio Initialization started
      Counter 0
      Counter 1
      Counter 2
      Counter 3
      Counter 4
      Counter 5

======================================================
サンプル プロジェクト: PetaLinux を使用した Linux イメージの作成
======================================================

このセクションでは、Versal デバイス上で Arm Cortex-A72 コア ベースの APU 用の Linux オペレーティング システムをコンフィギュレーションしてビルドする手順について説明します。PetaLinux ツールをボード固有の BSP と使用すると、Linux イメージをコンフィギュレーションおよびビルドできます。

このサンプル プロジェクトには、Linux ホスト マシンが必要です。PetaLinux ツールの依存関係とインストール手順については、`UG1144 <https://japn.xilinx.com/cgi-bin/docs/rdoc?v=latest;d=ug1144-petalinux-tools-reference-guide.pdf>`__ を参照してください。

.. important:: 

    この例では、VCK190 PetaLinux BSP を使用して PetaLinux プロジェクトを作成します。PetaLinux (VCK190/VMK180) に該当する BSP がダウンロードされていることを確認します。 
    
    - VCK190 ES1 ボードを使用している場合は、`https://japan.xilinx.com/member/vck190_headstart.html <https://japan.xilinx.com/member/vck190_headstart.html>`__ から `xilinx-vck190-es1-v2021.1-final.bsp` ファイルをダウンロードします。
    - VCK190 プロダクション ボードを使用している場合は、`https://japan.xilinx.com/member/vck190_headstart.html <https://japan.xilinx.com/member/vck190_headstart.html`__> から `xilinx-vck190-v2021.1-final.bsp` ファイルをダウンロードします。
    - VMK180 ES1 ボードを使用している場合は、`https://japan.xilinx.com/member/vmk180_headstart.html <https://japan.xilinx.com/member/vmk180_headstart.html>`__ から VMK180 PetaLinux 2021.1 BSP (`xilinx-vmk180-es1-v2021.1-final.bsp`) をダウンロードします。
    - VMK180 プロダクション ボードを使用している場合は、`https://www.xilinx.com/member/vmk180_headstart.html <https://www.xilinx.com/member/vmk180_headstart.html>`__ から VMK180 PetaLinux 2021.1 BSP (`xilinx-vmk180-v2021.1-final.bsp`) をダウンロードします。
    

1. 各ボードの PetaLinux BSP を現在のディレクトリにコピーします。
   
2. PetaLinux 環境を設定します。
   
   .. code-block::

        $ source <petalinux-tools-path>/settings.csh

3. 次のコマンドを使用して PetaLinux プロジェクトを作成します。
   
   .. code-block::
   
        $ petalinux-create -t project -s xilinx-vck190-vxxyy.z-final.bsp -n led_example

    .. note:: VMK180 ボードの場合は、コマンドの `-s` オプションの後に `xilinx-vmk180-vxxyy.z-final.bsp` を使用します。

4. 次のコマンドを使用して、PetaLinux プロジェクト ディレクトリに移動します。

   .. code-block::
    
        $cd led_example

5. ハードウェア プラットフォーム プロジェクトの XSA を Linux ホスト マシンにコピーします。

   .. note:: VMK180 ボードの場合は、「[デザイン例: AXI GPIO の使用」](#design-example-using-axi-gpio) で生成した XSA ファイルを使用します。

6. 次のコマンドを実行して BSP を再設定します。

   .. code-block::

        $ petalinux-config --get-hw-description=<path till the directory containing the respective xsa file>

   [PetaLinux Configuration] ウィンドウが開きます。この例では、このウィンドウで何も変更する必要はありません。

7. **[Save]** をクリックして上記の設定を保存し、**[Exit]** でコンフィギュレーション ウィザードを終了します。

8. 次のコマンドを使用して、PetaLinux プロジェクト内に gpiotest という名前の Linux アプリケーションを作成します。

   .. code-block::

        $petalinux-create -t apps --template install --name gpiotest --enable

9. 次のコマンドを使用して、`<design-package>/<vck190 or vmk180>/linux/bootimages` からアプリケーションファイルをプロジェクトにコピーします。

   .. code-block::
    
        $cp <design-package>/ch5_system_design_example_source__files/apu/gpiotest_app/gpiotest/files/* <plnxproj-root>/project-spec/meta-user/recipes-apps/gpiotest/files/
        $cp <design-package>/ch5_system_design_example_source__files/apu/gpiotest_app/gpiotest.bb <plnx-proj-root>/project-spec/meta-user/recipes-apps/gpiotest/gpiotest.bb
        $cp <design-package>/ch5_system_design_example_source__files/apu/device_tree/system-user.dtsi <plnx-proj-root>/project-spec/meta-user/recipes-bsp/device-tree/files/system-user.dtsi

10. カーネル コンフィギュレーション内で GPIO サポートをイネーブルにします。

    .. code-block::
        
        $petalinux-config -c kernel

    .. note:: このコマンドは、PetaLinux プロジェクトのカーネル コンフィギュレーション ウィザードを開きます。

11. **[Device drivers]** → **[GPIO Support]** をクリックし、**<Y>** キーを押してイネーブルにします。**Enter** キーを押し、**<Y>** キーを押して、Debug GPIO 呼び出しと `/sys/class/gpio/...(sysfs interface)` のエントリをイネーブルにします。

    .. image:: ./media/versal_2021_gpio_debug.png

12. **[Memory mapped GPIO drivers]** まで移動し、**<Y>** キーを押して、ザイリンクス GPIO サポートおよびザイリンクス Zynq GPIO サポートをイネーブルにします。

    .. image:: ./media/versal_2021_gpio_xilinx.png

13. **[Save]** をクリック して上記の設定を保存し、[Exit] でコンフィギュレーション ウィザードを終了します。

14. AIE、STDC++、および TCL オプションを無効にするように ROOTFS を設定し、rootfs のサイズを SD および OSPI/QSPI フラッシュ パーティションの両方に収まるように縮小します。 
 
    .. code-block::
   
       petalinux-config -c rootfs

15. 次の図に示すように、ユーザー パッケージに移動し、<Y> キーを押して aie-notebooks、openamp-demo-notebooks、packagegroup-petalinux-jupyter、pm-notebooks、python3-ipywidgets をディスエーブルにします。

    .. image:: media/rootfs_config_aie.JPG

16. 次の図に示すように、Y キーを押して **[Filesystem Packages]** → **[misc]** → **[gcc-runtime]** に移動し、** libstdc++ support** をオフにします。

    .. image:: media/rootfs_config_stdc++.JPG

17. 次の図に示すように、<Y> キーを押して **[Filesystem Packages]** → **[devel]** → **[tcltk]** → **[tcl]** に移動し、**[tcl support]** をオフにします。 

    .. image:: media/rootfs_config_tcl.JPG

18. **[Save]** をクリックして上記の設定を保存し、**[Exit]** でコンフィギュレーション ウィザードを終了します。

19. OSPI および eMMC ブート モードは、VCK190/VMK180 REVB プロダクション ボードでのみ機能します。

20. OSPI ビルドの場合は、次のコードを PLNX プロジェクト bsp ファイル `<plnxproj-root>/project-spec/meta-user/conf/petalinuxbsp.conf` にコピーします。

   .. code-block::
   
		  VCK190 プロダクション ボード:
		  YAML_DT_BOARD_FLAGS_vck190 = "{BOARD versal-vck190-reva-x-ebm-03-reva}"
		  
		  VMK180 プロダクション ボード:
		  YAML_DT_BOARD_FLAGS_vmk180 = "{BOARD versal-vmk180-reva-x-ebm-03-reva}"

21. eMMC ビルドの場合は、次のコードを PLNX プロジェクト bsp ファイル `<plnxproj-root>/project-spec/meta-user/conf/petalinuxbsp.conf` にコピーします。

   .. code-block::
   
		  VCK190 プロダクション ボード:
		  YAML_DT_BOARD_FLAGS_vck190 = "{BOARD versal-vck190-reva-x-ebm-02-reva}"
		  
		  VMK180 プロダクション ボード:
		  YAML_DT_BOARD_FLAGS_vmk180 = "{BOARD versal-vmk180-reva-x-ebm-02-reva}"

22. 次のコマンドを使用して、Linux イメージをビルドします。

    .. code-block::
       
        $ petalinux-build

BIF ファイルを使用した FreeRTOS と APU イメージの結合
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Vitis IDE ワークスペースで XSCT コンソールを開きます。

2. PetaLinux プロジェクトの `images/linux` ディレクトリに移動します。

   .. code-block::

        $ cd <petalinux-project>/images/linux/

3. Freertos ELF ファイルは、QSPI/SD ブート イメージに対してのみサポートされています。`<design-package>/vck190/freertos/bootimages/` から `freertos_gpio_test.elf` を `images/linux` ディレクトリにコピーします

   .. code-block::
        
        $ cp <design-package>/vck190/ready_to_test/qspi_images/freertos/freertos_gpio_test.elf .

4. `<design-package>/` から `bootgen.bif` ファイルを `images/linux` ディレクトリにコピーします。

   .. code-block::

        $ cp <design-package>/vck190/ready_to_test/qspi_images/linux/bootgen.bif .

5. 次のコマンドを実行して `BOOT.BIN` を作成します。

   .. code-block::

        $ bootgen -image bootgen.bif -arch versal -o BOOT.BIN -w

    これで、`<petalinux-project>/images/linux/` ディレクトリに `BOOT.BIN` イメージ ファイルが作成されます。

.. note:: SD ブート モードを使用してイメージを実行するには、`「SD ブート モードのブート シーケンス」 <./4-boot-and-config.rst#boot-sequence-for-sd-boot-mode>`__ を参照してください。

-----------------------------------------------

この資料は 2021 年 8 月 12 日時点の表記バージョンの英語版を翻訳したもので、内容に相違が生じる場合には原文を優先します。資料によっては英語版の更新に対応していないものがあります。日本語版は参考用としてご使用の上、最新情報につきましては、必ず最新英語版をご参照ください。


.. |trade|  unicode:: U+02122 .. TRADEMARK SIGN
   :ltrim:
.. |reg|    unicode:: U+000AE .. REGISTERED TRADEMARK SIGN
   :ltrim:
.. |build-icon|  image:: ./media/image29.png

