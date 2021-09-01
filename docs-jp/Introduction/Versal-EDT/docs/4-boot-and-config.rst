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


**********************
ブートおよびコンフィギュレーション
**********************

Versal |trade| ACAP 用にブートローダー、ベアメタル アプリケーション (APU/RPU 用)、および Linux オペレーティング システムを統合してロードする方法を示します。この章では、次のトピックについて説明します。

- システム ソフトウェア: PLM、Arm |reg|  トラステッド ファームウェア (ATF)、U-Boot
- スタンドアロン アプリケーションのブート イメージを生成する手順。
- SD ブート、QSPI、および OSPI ブート モードのブート シーケンス。

これらの設定は、Vitis |trade| ソフトウェア プラットフォームと PetaLinux ツール フローを使用して実行できます。`「Versal ACAP CIPS および NoC (DDR) IP コアの設定」 <./2-cips-noc-ip-config.rst>`__ では、PS 内に各プロセッシング ユニットのソフトウェア ブロックを作成することにのみに重点を置いていましたが、この章ではより大規模なシステムの一部としてこれらのブロックをロードする方法を説明します。

===============
システム ソフトウェア
===============

この章のブートおよびコンフィギュレーションの説明の大部分は、ここで挙げるシステム ソフトウェア ブロックについてです。

プラットフォーム ローダーおよびマネージャー
~~~~~~~~~~~~~~~~~~~~~~~~~~~

PLM (プラットフォーム ローダーおよびマネージャー) は、Versal ACAP の PMC (Platform Management Controller) ブロック内の専用プロセッサの 1 つで実行されるソフトウェアです。プラットフォーム管理、エラー管理、パーシャル リコンフィギュレーション、デバイスのサブシステム再起動など、起動および実行時の管理を担当します。PLM はイメージを再ロードし、パーシャル PDI とサービス割り込みをロードできます。PLM はブート ソースからプログラマブル デバイス イメージを読み取り、NoC の初期化、DDR メモリの初期化、プログラマブル ロジック、およびプロセッシング システムを含むシステムのコンポーネントを設定してから、デバイスのブートを完了します。

U-Boot
~~~~~~

U-Boot はセカンダリ ブートローダーとして機能します。U-Boot は、PLM ハンドオフ後に Linux を Arm A72 APU にロードし、ボード コンフィギュレーションに基づいてプロセッシング システム内の残りのペリフェラルをコンフィギュレーションします。U-Boot は、eMMC、SATA、TFTP、SD、QSPI などのさまざまなメモリ ソースからイメージを取得できます。U-Boot は、PetaLinux ツール フローを使用して設定およびビルドできます。

Arm トラステッド ファームウェア
~~~~~~~~~~~~~~~~~~~~

Arm トラステッド ファームウェア (ATF) は、APU の EL3 (例外レベル 3) で実行される透過的なベアメタル アプリケーション レイヤーです。ATF には、セキュア ワールドと非セキュア ワールドを切り替えるためのセキュア モニター レイヤーが含まれます。セキュア モニターの呼び出しと TBBR (Trusted Board Boot Requirements) の実装により、Versal ACAP の APU に Linux をロードするには ATF レイヤーが必須です。PLM は APU で実行される ATF をロードします。ATF は EL3 で動作し続けてサービス要求を待ちます。PLM は APU で実行される U-Boot を DDR にロードします。U-Boot は SMP モードで Linux OS を APU にロードします。ATF (`bl31.elf`) はデフォルトで PetaLinux に含まれており、PetaLinux プロジェクトの image ディレクトリにあります。

================================================
スタンドアロン アプリケーションのブート イメージの生成
================================================

Vitis ソフトウェア プラットフォームは、Versal アーキテクチャの自動ブート イメージ作成をサポートしていません。ブータブル イメージを生成するには Bootgen を使用します。Bootgen は、Vitis ソフトウェア プラットフォーム パッケージに含まれるコマンド ライン ユーティリティです。Bootgen の主な機能は、ブータブル イメージのさまざまなパーティションを統合することです。Bootgen は、Bootgen イメージ フォーマット (BIF) ファイルを入力として使用し、バイナリ BIN または PDI フォーマットで 1 つのファイル イメージを生成します。不揮発性メモリ (NVM) (QSPI または SD カード) にロードできる単一のファイル イメージを出力します。次の手順を実行して、PDI/BIN ファイルを生成します。

1. Vitis IDE で [XSCT Console] ビューがまだ開いていない場合は、**[Window]** → **[Show View]** をクリックして開きます。Show View ウィザードの検索バーに `xsct console` と入力します。**[Open]** をクリックして、コンソールを開きます。

   .. image:: ./media/image49.png

2. [XSCT Console] で次のコマンドを入力して、ブート イメージを生成するフォルダーを作成します。

   .. code-block::

        mkdir bootimages
        cd bootimages/
    

3. `<design-package>/<board-name>/ready_to_test/qspi_images/standalone/<cips or cips_noc>/<apu or rpu>/` ディレクトリ内にある sd_boot.bif ファイルと、`<Vitis platform project>/hw/<.pdi-file>` 内にある PDI ファイルと、`<Vitis application-project>/Debug` フォルダー内にあるアプリケーション ELF ファイルを手順 2 で作成したフォルダーにコピーします。

   .. note:: 必要に応じて、任意のテキストエディタで `sd_boot.bif` ファイルを開き、Vitis プロジェクトごとに PDI または ELF の名前を変更します。

4. [XSCT Console] ビューで次のコマンドを実行します。

   .. code-block::

      `bootgen -image <bif filename>.bif -arch versal -o BOOT.BIN`

   [XSCT Console] ビューには、次のログが表示されます。

   .. image:: ./media/image51.jpeg

==============================
SD ブート モードのブート シーケンス
==============================

次の手順は、SD ブートモードのブート シーケンスを示しています。

1. イメージを確認するには、必要なイメージを SD カードにコピーします。

   - スタンドアロンの場合は、`BOOT.BIN` を SD カードにコピーします。

   - Linux イメージの場合は、`<plnx-proj-root>/images/linux` に移動し、`BOOT.BIN`、`Image`、`rootfs.cpio.gz.uboot`、`boot.scr` を SD カードにコピーします。

   .. note:: リリースされたパッケージ パス (`<design-package>/<vck190 or vmk180>/ready_to_test/qspi_images/linux/`) の一部として、すぐにテスト可能なイメージを使用して VCK190/VMK180 ボードを起動するか 、`「サンプル プロジェクト: PetaLinux を使用した Linux イメージの作成」 <../docs/5-system-design-example.rst#example-project-creating-linux-images-using-petalinux>`__ を参照し、PetaLinux ツールを使用して独自の Linux イメージ セットをビルドします。

2. SD カードを VMK180/VCK190 ボードの J302 コネクタに挿入します。

3. Micro USB ケーブルの一端を VMK180/VCK190 ボードの Micro USB ポート (J207) に接続し、もう一端をホスト マシンの空きの USB ポートに接続します。

4. スイッチ SW1 を次の図に示すように設定し、ボードを SD ブート モードに設定します。

   .. image:: ./media/sd_boot_mode.JPG

5. 12V 電源を VMK180/VCK190 の 6 ピン Molex コネクタに接続します。

6. 使用しているホスト マシンによって、Tera Term または Minicom を使用して、ターミナル セッションを開始します。次の図に示すように、システムの COM ポートとボー レートを設定します。

   .. image:: ./media/image46.png

7. ポート設定では、デバイス マネージャーで COM ポートを検証し、com ポートに対して Interface-0 を選択します。

8. 電源スイッチ (SW13) を使用してVMK180/VCK190ボードに電源を投入します。

   .. note:: スタンドアロン イメージの場合は、それぞれのログがターミナルに表示されます。Linux イメージの場合は、ターミナルで起動シーケンスの後に user: root および pw: root を使用してログインできます。その後、ターミナルで gpiotest を実行します。次の図のようログが表示されます。

   .. image:: ./media/led_example_console_prints.PNG

================================
QSPI ブート モードのブート シーケンス
================================

このセクションでは、QSPI ブートモードのブート シーケンスを示します。このためには、次の図に示すように QSPI ドーター カード (製品番号: X_EBM-01、REV_A01) を接続する必要があります。

**図 2: VCK190 のドーター カード**

.. image:: ./media/image54.jpeg

.. note:: スタンドアロンの場合は、BOOT.BIN を SD カードにコピーします。Linux イメージの場合は、リリースされたパッケージ パス (`<design-package>/<vck190 or vmk180>/ready_to_test/qspi_images/linux/`) の一部として、すぐにテスト可能なイメージを使用して VCK190/VMK180 ボードを起動するか、`「サンプル プロジェクト: PetaLinux を使用した Linux イメージの作成」 <./5-system-design-example.rst#example-project-creating-linux-images-using-petalinux>`__ を参照し、PetaLinux ツールを使用して独自の Linux イメージ セットをビルドします。

次の手順に従って、イメージをドーター カードのフラッシュ メモリに書き込む必要があります。
.. note:: 次の手順では、最初に SD ブート モードを使用してイメージを読み込み、QSPI フラッシュを間接的にプログラムします。

1. カードの電源を切った状態で、QSPI ドーター カードを取り付けます。

2. 次の図に示すように、ブート モード スイッチ SW1 を ON-OFF-OFF-OFF の SD モード スイッチに設定します。
     
   .. image:: ./media/sd_boot_mode.JPG

3. ボード上の SD カード スロットに SD カードを挿入します。

   .. image:: ./media/image56.jpeg

4. ボードに電源を投入します。U-Boot 段階で、「Hit any key to stop autoboot:」というメッセージが表示されたら、いずれかのキーを押し、次のコマンドを実行して QSPI ドーター カードのイメージをフラッシュ メモリに書き込みます。

   .. code-block::

        sf probe 0 0 0
        sf erase 0x0 0x10000000
        fatload mmc 0 0x80000 BOOT.BIN
        sf write 0x80000 0x0 <BOOT.BIN_filesize_in_hex>
        fatload mmc 0 0x80000 Image
        sf write 0x80000 0xF00000 <Image_filesize_in_hex>
        fatload mmc 0 0x80000 rootfs.cpio.gz.u-boot
        sf write 0x80000 0x2E00000 <rootfs.cpio.gz.u-boot_filesize_in_hex>
        fatload mmc 0 0x80000 boot.scr
        sf write 0x80000 0x7F80000  <boot.scr_filesize_in_hex>


5.画像をフラッシュ メモリに書き込んだ後、ボードの電源スイッチをオフにし、SW1 ブート モード ピンの設定を QSPI ブート モード (ON-OFF-ON-ON) に変更します。

   .. image:: ./media/image52.png

6.ボードの電源を切って入れ直します。これで、QSPI フラッシュ内のイメージを使用してボードが起動します。

================================
OSPI ブート モードのブート シーケンス
================================

OSPI ブート モードにデザインをコンフィギュレーションするには、「OSPI ブート モードのコンフィギュレーション」を参照してください。このセクションでは、OSPI ブートモードのブート シーケンスを示します。このためには、次の図に示すように OSPI ドーター カード (製品番号 X-EBM-03 REV_A02) を接続する必要があります。

.. image:: ./media/X-EBM-03_OSPI_Daughter_card.jpg

.. note:: スタンドアロンの場合は、`BOOT.BIN` を SD カードにコピーします。Linux イメージの場合は、リリースされたパッケージ パス (`<design-package>/<vck190 or vmk180>/ready_to_test/ospi_images/linux`) の一部として、すぐにテスト可能なイメージを使用して VCK190/VMK180 ボードを起動するか 、`「サンプル プロジェクト: PetaLinux を使用した Linux イメージの作成」 <./5-system-design-example.rst#example-project-creating-linux-images-using-petalinux>`__ を参照し、PetaLinux ツールを使用して独自の Linux イメージ セットをビルドします。

次の手順に従って、イメージをドーター カードのフラッシュ メモリに書き込む必要があります。

.. note:: 次の手順では、最初に SD ブート モードを使用してイメージを読み込み、OSPI フラッシュを間接的にプログラムします。

1. カードの電源を切った状態で、OSPI ドーター カードを取り付けます。
2. 次の図に示すブート モードように、ブート モード スイッチ SW1 を ON-OFF-OFF-OFF の SD ブート モードに設定します。
   
   .. image:: ./media/sd_boot_mode.JPG

3. ボード上の SD カード スロットに SD カードを挿入します。
   
   .. image:: ./media/image56.jpeg

4. ボードに電源を投入します。U-Boot 段階で、「Hit any key to stop autoboot:」というメッセージが表示されたら、いずれかのキーを押し、次のコマンドを実行して OSPI ドーター カードのイメージをフラッシュ メモリに書き込みます。

   .. code-block::

        sf probe 0 0 0
        sf erase 0x0 0x10000000
        fatload mmc 0 0x80000 BOOT.BIN
        sf write 0x80000 0x0 <BOOT.BIN_filesize_in_hex>
        fatload mmc 0 0x80000 Image
        sf write 0x80000 0xF00000 <Image_filesize_in_hex>
        fatload mmc 0 0x80000 rootfs.cpio.gz.u-boot
        sf write 0x80000 0x2E00000 <rootfs.cpio.gz.u-bootfilesize_in_hex>
        fatload mmc 0 0x80000 boot.scr
        sf write 0x80000 0x7F80000  <boot.scr_filesize_in_hex>


5. イメージをフラッシュしたら、ボードの電源スイッチをオフにします。
6. SW1 ブート モードのピン設定を、ON-OFF-OFF-OFF の OSPI ブート モードに変更します。
7. ボードの電源を切って入れ直します。これで、OSPI フラッシュ内のイメージを使用してボードが起動します。

.. note:: VMK180 プロダクション ボードの場合、OSPI イメージはデザイン パッケージには含まれません。VCK190 の OSPI イメージのみがデザイン パッケージで共有されます。

================================
eMMC ブート モードのブート シーケンス
================================

eMMC ブート モード用にデザインをコンフィギュレーションするには、「eMMC ブート モードのコンフィギュレーション」を参照してください。このセクションでは、emmc ブートモードのブート シーケンスを示します。このためには、次の図に示すように eMMC ドーター カード (製品番号X-EBM-02、REV_A02) を接続する必要があります。

.. image:: ./media/X-EBM-02_emmc_Daughter_card.jpg

.. note:: スタンドアロンの場合は、BOOT.BIN を SD カードにコピーします。Linux イメージの場合は、リリースされたパッケージ パス (`<designpackage>/<vck190 or YAML_DT_BOARD_FLAGS_vmk180>/ready_to_test/emmc_images/linux`) の一部として、すぐにテスト可能なイメージを使用して VCK190 または vmk180 ボードを起動するか、`「サンプル プロジェクト: PetaLinux を使用した Linux イメージの作成」 <./5-system-design-example.rst#example-project-creating-linux-images-using-petalinux>`__ を参照し、PetaLinux ツールを使用して独自の Linux イメージ セットをビルドします。

Versal ボード上の eMMC フラッシュを初めてフォーマットする場合は、次の手順を実行します。

1. カードの電源を切った状態で、eMMC ドーター カードを取り付けます。

2. 次の図に示すように、ブート モード スイッチ SW1 を ON-ON-ON-ON の JTAG ブート モードに設定します。

   .. image:: ./media/vck190_jtag_boot_mode_sw1_settings.png

   この例では、XSCT コンソールを使用して、ブート イメージファイル (BOOT.BIN) をダウンロードします。U-Boot コンソールを使用して Linux イメージを読み込んで、eMMC フラッシュをフォーマットします。

3. イーサネット ケーブルでホストとボードが接続されていることを確認してください。ホスト上で dhcp および tftpb サーバーを設定します。 

4. Linux イメージ BOOT.BIN、Image、`rootfs.cpio.gz.u-boot`、および `boot.scr` を tftp ホームディレクトリのホストにコピーします。

5. [XSCT Console] ビューで、次の connect コマンドを使用して JTAG を介してターゲットに接続します。

   .. code-block::
   
       xsct% connect

   connect コマンドは、接続のチャネル ID を返します。 

6. `target` コマンドを実行し、使用可能なターゲットをリストして、各 ID を使用してターゲットを選択します。ターゲットには JTAG チェーンで検出されたときに ID が割り当てられるので、ターゲット ID はセッションごとに変わります。

   .. code-block::

	 xsct% targets

7. 次のコマンドを使用して、VCK190 ボードに BOOT.BIN をダウンロードし、U-Boot コンソールを取得します。

   .. code-block::
   
		xsct% targets 1
		xsct% rst
		xsct% device program BOOT.BIN

   このコマンドを実行すると、シリアル コンソールに PLM ブートログと U-Boot ブートログが表示されます。

8. U-Boot 段階で、「Hit any key to stop autoboot:」というメッセージが表示されたら、いずれかのキーを押し、次のコマンドを実行して eMMC ドーター カードのイメージをフラッシュ メモリに書き込みます。

   .. code-block::
        dhcp
        tftpboot 0x80000 Image
        tftpboot 0x2000000 rootfs.cpio.gz.u-boot
        booti 0x80000 0x2000000 0x1000          

   上記の U-Boot コマンドを実行すると、Linux が起動を開始し、Linux コンソール プロンプトで停止した状態で、ユーザー入力コマンドを待ちます。

9. Linux コンソール プロンプトから次のコマンドを実行して、eMMC Linux ブータブル パーティションを作成し、eMMC を FAT32 ファイル システムでフォーマットします。

   .. code-block::
	
        root@xilinx-vmk180-2021_1:~# fdisk /dev/mmcblk0
        The number of cylinders for this disk is set to 233472.
        There is nothing wrong with that, but this is larger than 1024,
        and could in certain setups cause problems with:
        1) software that runs at boot time (e.g., old versions of LILO)
        2) booting and partitioning software from other OSs
        (e.g., DOS FDISK, OS/2 FDISK)

        Command (m for help): m
        Command Action
        a       toggle a bootable flag  
        b       edit bsd disklabel
        c       toggle the dos compatibility flag
        d       delete a partition
        l       list known partition types
        n       add a new partition
        o       create a new empty DOS partition table
        p       print the partition table
        q       quit without saving changes
        s       create a new empty Sun disklabel
        t       change a partition's system id
        u       change display/entry units
        v       verify the partition table
        w       write table to disk and exit

        Command (m for help): n
        Partition type
        p   primary partition (1-4)
        e   extended
        p
        Partition number (1-4): 1
        First sector (16-14942207, default 16):
        Using default value 16
        Last sector or +size{,K,M,G,T} (16-14942207, default 14942207):
        Using default value 14942207

        Command (m for help): w
        The partition table has been altered.
        Calling ioctl() to re-read partition table
        fdisk: WARNING: rereading partition table failed, kernel still uses old table: Device or resource busy

        root@xilinx-vmk180-2021_1:~# mkfs.vfat -F 32 -n boot /dev/mmcblk0p1


   eMMC フラッシュは FAT32 ファイル システムでフォーマットされています。

Linux イメージを eMMC フラッシュ メモリに書き込むには、次の手順を実行します。

1. カードの電源を切った状態で、eMMC ドーター カードを取り付けます。

2. 次の図に示すように、ブート モード スイッチ SW1 を ON-ON-ON-ON の JTAG ブート モードに設定します。

   .. image:: ./media/vck190_jtag_boot_mode_sw1_settings.png

   この例では、XSCT コンソールを使用して、ブート イメージファイル (BOOT.BIN) をダウンロードします。U-Boot コンソールを使用して、Linux イメージを eMMC フラッシュに読み込みます。

3. イーサネット ケーブルがボードに接続されていることを確認します。ホスト上で dhcp および tftpb サーバーを設定します。

4. Linux イメージ BOOT.BIN、Image、`rootfs.cpio.gz.u-boot`、および `boot.scr` をホスト tftp ホーム ディレクトリにコピーします。また、U-Boot からイメージを初めてコピーする前に、前のセクションで説明したように eMMC カードが FAT32 ファイル システムでフォーマットされていることを確認してください。

5. [XSCT Console] ビューで、次の connect コマンドを使用して JTAG を介してターゲットに接続します。

   .. code-block::

	 xsct% connect
		
   connect コマンドは、接続のチャネル ID を返します。
   
6. `targets` コマンドを実行して、使用可能なターゲットをリストします。ID を使用してターゲットを選択します。ターゲットには JTAG チェーンで検出されたときに ID が割り当てられるので、ターゲット ID はセッションごとに変わります。

   .. code-block::

		xsct% targets

7. 次のコマンドを使用して、VCK190 ボードに BOOT.BIN をダウンロードし、U-Boot コンソールを取得します。

   .. code-block::
   
		xsct% targets 1
		xsct% rst
		xsct% device program BOOT.BIN

   このコマンドを実行すると、シリアル コンソールに PLM ブートログと U-Boot ブートログが表示されます。

8. U-Boot 段階で、「Hit any key to stop autoboot:」というメッセージが表示されたら、いずれかのキーを押し、次のコマンドを実行して eMMC ドーター カードのイメージをフラッシュ メモリに書き込みます。

   .. code-block::
	
        fatls mmc 0  // to check emmc is formatted or not.
        dhcp
        tftpb 0x80000 BOOT.BIN
        fatwrite mmc 0 0x80000 BOOT.BIN $filesize
        tftpb 0x80000  Image
        fatwrite mmc 0 0x80000 Image $filesize
        tftpb 0x80000  rootfs.cpio.gz.u-boot
        fatwrite mmc 0 0x80000 rootfs.cpio.gz.u-boot $filesize
        tftpb 0x80000  boot.scr
        fatwrite mmc 0 0x80000 boot.scr $filesize

9. 画像をフラッシュ メモリに書き込んだ後、ボードの電源スイッチをオフにし、SW1 ブート モード ピンの設定を eMMC ブート モード (OFF-ON-ON-OFF) に変更します。

10. ボードの電源を切って入れ直します。これで、eMMC フラッシュ内のイメージを使用してボードが起動します。

-----------------------------------------------

この資料は 2021 年 8 月 12 日時点の表記バージョンの英語版を翻訳したもので、内容に相違が生じる場合には原文を優先します。資料によっては英語版の更新に対応していないものがあります。日本語版は参考用としてご使用の上、最新情報につきましては、必ず最新英語版をご参照ください。


.. |trade|  unicode:: U+02122 .. TRADEMARK SIGN
   :ltrim:
.. |reg|    unicode:: U+000AE .. REGISTERED TRADEMARK SIGN
   :ltrim:

