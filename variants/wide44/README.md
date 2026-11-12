# wide.44：Google SDK → C4 與右側車況／提醒分區

> 本目錄是復原的歷史 wide44 原始碼與當時行為。2026-11-12 已確認其下一步距離與目前 C4 receiver 會重複相加；修正位於 `variants/google-bridge46`，使用時應選 wide46。下方保留歷史描述，不能作為新版距離合約。

此版保留原有 Google Maps 投屏，新增 **CP Google 導航** 配套來源。需要安裝兩個 APK：CP 搭子 wide.44，以及 CP Google Navigation 0.1.0。後者使用 Google Navigation SDK，畫面仍由原有投屏系統顯示在左側；資料透過本機 127.0.0.1:5002 交給 CP 搭子，沿用原生 Navi v2 通道送往 C4。不是讀取官方 Google Maps App 的私人路線資料。

## 使用

1. 在同一台 Android 車機／手機安裝兩個 APK。wide.44 與 wide.43 同簽章，可覆蓋更新；不要先移除既有設定。
2. 開啟「CP Google 導航」，按「設定／更換 Google 金鑰」。將自己的金鑰貼在 App，勿貼到 GitHub 或聊天中。
3. 在自己的 Google Cloud 專案啟用計費、Navigation SDK 與 Places API (New)。Android 應用程式限制使用 `com.copilottw.googlenav`，SHA-1 從設定頁的「複製套件名稱與 SHA-1」取得；這與主程式的套件名稱不同。
4. 回到 CP 搭子，導航「更多 → CP Google 導航」，沿用已有投屏授權。在左側搜尋目的地並開始導航。授予導航程式精確定位及所需通知權限。
5. 「更多 → Google 導航串接與金鑰」可查看來源狀態；原有 C4 連線照常設定。顯示「已交給原有 Navi v2 傳送流程」只代表手機端已提供資料，並不是 C4 接收確認，更不是減速執行確認。

首次儲存金鑰可直接返回開始導航。已初始化 Google SDK 後更換金鑰，依 Google API 的每程序一次限制，需在 Android 應用程式資訊強制停止 CP Google 導航後重開。離線測速不需要 Google 金鑰。

## 傳送內容

| 原始資料 | 原生 CP / C4 串流 |
| --- | --- |
| Google currentStep 指示、道路、距離、時間 | guidance_current |
| 下一步與前一步的間距，加上目前剩餘距離 | guidance_next（相對目前車輛的距離） |
| 剩餘距離／時間、Google 路線座標 | route |
| Google 貼合道路定位、航向、速度 | vehicle |
| 導航／停止狀態 | navigation_status |

路線使用 `{lat,lon}`，遵守原生通道最多 256 點的限制。從目前位置附近的路段起保留連續座標，**不以遠端終點連線取代中間彎道**；不宣稱超長行程的全部幾何可在單一封包內傳送。位置距路線超過 100 公尺時不送幾何。速度由 m/s 轉 km/h，不從 Google 臆造道路速限、測速點或紅綠燈資料。

目前／下一步、路線版本及生產程序 sessionId 會交叉核對；SDK 指示與定位超過 3 秒、重新規劃、停止導航、模擬、切換來源時撤銷相關資料。保守未映射轉向仍可顯示文字，但不假裝已確認可用的轉彎控制代碼。左／右轉、岔路、匝道等代碼依 carrot-wip 的 `carrot_serv.py` 核對。

## 版面

左半保留導航。右側空間足夠時分為上方車況、下方提醒：C4 車速有效時使用 C4，否則用 GPS 並清楚標示；橫向／縱向旗標逾時顯示未知。道路速限原有 1 分鐘暫存會標記「暫存速限」。固定測速與區間倒數資訊保留；沒有優先的近距離測速提醒時可顯示 Google 轉彎。

提醒區高度不足時可自動收合九宮格快捷鍵（每次面板建立最多一次），也保留手動展開。很小的區域仍採原有緊湊版面，避免硬塞上下卡片。預覽中的科技執法場景屬設計示意，此版尚未將新增科技執法清冊接入語音／提醒判斷。

## 驗證與邊界

- 32 項 Google 資料轉換測試：方向映射、下一步距離、座標順序、過期／停止／模擬、路線版本、程序重啟、256 點上限。
- 保留 wide.43 的 77 項測速測試，Google 金鑰生命週期另有 8 項測試。
- 配套導航使用 Navigation SDK **7.6.1**、Places **3.5.0**，AGP 8.13.2、Gradle 8.13、Kotlin 2.2.10 編譯通過。7.6.1 包含 7.6.0 的 Android 12 修復。
- APK 已驗章與對齊；主 APK 使用原簽章。實際 C4 接收、Google 計費授權、虛擬螢幕與裝置音訊仍未驗證，沒有以測試金鑰假裝實車完成。
- 本版沒有改動 wide.43 測速道路演算法，因此不重複宣稱做過新的 539 組回放；wide.43 原有 17 組未命中與 9 組反向疑似案例仍待解決。

Google 導航配套原始碼與來源授權在 `variants/google-navdash`。本目錄的原始 Java／smali 已恢復，不含簽章私鑰。新版 companion 0.1.1 的生命週期與搜尋修正請看其 README。

## 復原與可重建材料（2026-11-12）

`verification/source-recovery.json` 保存復原時的檔案雜湊；七個 Java 檔及歷史 smali 沒有為新版行為而修改。`build.py` 從固定 SHA 的 wide43 APK 擷取實際 API 簽名，編譯七個來源，加入三個原有 smali hook，產生未簽章、16 KiB 對齊的 wide44 APK。

```sh
python variants/wide44/build.py \
  --base-apk /path/to/Copilot-tw-9.3.1-wide.43-offline-forward.apk \
  --output-dir /path/to/new-wide44-rebuild-directory \
  --toolchain /path/to/copilot-toolchain \
  --build-tools /path/to/android-sdk/build-tools/36.0.0
```

工具目錄需 apktool.jar、ecj.jar、asm.jar、baksmali/*.jar 與 platform/android-35/android.jar；API 35+ android.jar 也可用 `COPILOT_ANDROID_JAR` 指定。Nested class metadata 由本目錄 `tooling/ApiSignatures44.java` 從 DEX 註記讀取；stub API JAR 不會包入成品。

加 `--retained-smali` 可重組歷史 smali，不重新編譯 Java。兩種方式都只產生未簽章 APK，簽署由專案外受控流程負責。本次已完成來源編譯、APK 重組、對齊與資產／native library／其他 DEX 未改動檢查，報告為 `verification/source-rebuild.json`；不宣稱新編譯檔與原簽署成品逐位元相同，也不宣稱已做 Android 裝置測試。

重編譯成品另外以 `variants/amap-link1/tooling/CheckReferences.java` 檢查 55 個 overlay／版本類別：270 個方法、611 個內部方法參照、830 個內部欄位參照、134 個內部型別參照均解析成功（`verification/source-reference-check.json`）。這是 DEX 結構檢查，不是 Android ART 執行驗證。
