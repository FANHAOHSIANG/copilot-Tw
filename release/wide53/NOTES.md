# wide.53：自訂投屏、即時診斷與手機畫面修正

基於使用者已實際使用的融合版 wide.52，保留原套件及原簽章，可覆蓋更新；不回復台灣測速功能。

- 投屏依實際區域大小調整解析度，等待調整時保持比例；觸控座標與留黑區一致。旋轉／拖動分隔線及調整遭拒的重新建立流程均已處理。
- 服務已啟動並授權時自動綁定投屏，恢復原導航來源；服務晚到有重試，連接成功後停止重試。未授權不自動點選權限，管理工具每次開啟 App 最多自動開一次。
- 右上「更多 → 選擇投屏 App／空白畫面」：可選已安裝、有桌面入口的 App，或靜謐時鐘。App 本身若禁止多螢幕／受保護內容，不能保證投屏。
- 右下「更多 → 右下：即時診斷／九宮格」：保留原有九宮格控制；可改成唯讀即時參數、comma 連接與地圖傳送資料。逾時車速與控制旗標顯示未知。
- 「更多 → 診斷與連線」獨立入口，可複製報告；移出版面設定。既有 Google／高德資料診斷仍保留。
- 地圖底部三個地址：點選開啟，長按修改或清除。Google Maps 接收導航地址；內建 Google 開啟搜尋供確認；高德手機使用地點搜尋；車機版如不支援 ACTION_SEARCH，明確提示並複製地址供手動貼上。沒有假稱所有地圖可直接開始導航。
- 原「回家／公司」快捷改為常用地址選擇，不再送出原高德 home/company 指令。
- 內建 Google 搜尋卡移到上方、統一深藍配色；長按地點顯示收藏／指定地址對話框。移除原藍牙鍵盤／C3 語音說明與麥克風輸入入口；保留系統文字鍵盤、Google 導航播報與靜音切換。
- App 自有文字轉繁體中文，投屏標題改「地圖投屏」，自有連接診斷使用 comma。外部 App 自己的語言不由本 App 改寫。

## 驗證範圍

58 項實際幾何／自動連線策略斷言、APK 掛接與 DEX 成員解析檢查；原簽章、16 KiB ZIP 對齊驗證。完整結果在 verification。

這批新功能尚未在使用者手機／車機驗收；wide.52 已能實際使用是使用者回報，不能替代 wide.53 的新功能驗收。所有診斷只讀，不更改 C4 轉向、縱向、AEB 或訊息控制合約。

## 安裝後確認

1. 覆蓋安裝，確認原導航來源及設定保留。
2. Shizuku 或 Stellar 服務已啟動、授權可用時，關閉再開 CoPilot，確認恢復投屏。
3. 旋轉手機、拖動分隔線，確認圓形不變橢圓，觸控點位一致。
4. 右上切空白再切 App，右下切診斷再切九宮格，確認原控制入口保留。
5. 測試三個地址及 Google 收藏，確認目的地後再開始導航。

## 重建

`python variants/wide53/build.py --base-apk <wide52.apk> --toolchain <tools> --output-dir <new-directory>`

工具沿用 wide.52（apktool 2.12.1、ECJ 3.38.0、ASM 9.7、baksmali 2.5.2、API 35 android.jar、build-tools 36），Python 需 `opencc-python-reimplemented` 與 `bsdiff4==1.4.2`。簽署材料透過 `COPILOT_SIGNING_KEY`、`COPILOT_KEY_ALIAS`、`COPILOT_STORE_PASSWORD`、`COPILOT_KEY_PASSWORD` 提供。未簽署驗證可加 `--unsigned`，不得把 unsigned 當可安裝檔。私鑰不在 GitHub。新介面以 Java overlay 與有斷言的 smali 掛接實作，Google 原始 Gradle 目錄為基底來源；應使用本目錄的 build.py 重建這個整合版。

`release/wide53/restore.py <output>` 則從固定 wide.52 和公開二進位差異還原完全相同的已簽署 wide.53，不含私鑰。
