# CoPilot Tw

## wide.39 高德預調速綁定與固定關閉按鈕

預調速固定採用所選高德的有效策略；台灣模式保留台灣速限／測速點，高德預調速與台灣道路速限同時有效時取較低值送出。保留資料時效與來源切換撤銷，避免互相覆蓋。右側更多的兩個設定頁，關閉按鈕固定在底部中央。26項離線速度測試及底欄結構、APK簽章檢查通過，尚未完成 Android 實機與 C4 實車驗證。測速覆蓋範圍沿用 wide.37。

[使用、來源規則與重建說明](variants/wide39/README.md) · [檢查紀錄](variants/wide39/verification/verification.json)

APK 於對話交付，尚未建立 wide.39 GitHub Release。

## wide.37 全量離線驗證結果

已檢查包內 1856 個固定測速點。1369 個未進入提醒配對。487 個已配對點展開為 539 組方向回放，457 點的已配對方向通過，3 點部分方向未觸發、19 點可用回放路徑不足、2 點同向未觸發、6 點反向回放異常待查。這是道路幾何合成定位測試，並非全台實車驗證。487 個點中另有 6 點原資料雙向但僅配對一向。不能將 wide.37 當成完整全台覆蓋。

[完整方法與結果](variants/wide37/audit/README.md) · [全部 ID 結果](variants/wide37/audit/all-status.tsv) · [未通過案例](variants/wide37/audit/anomalies.json)

## wide.37 國一北上測速提醒修正

修正國道北上被誤當正北方向及僅搜尋同一道路分段造成的漏報。補回竹北往台北範圍 5 個測速點，連同既有 63.7 公里共 6 點通過道路幾何模擬回放，語音門檻為 1 公里。34.4 公里匝道點仍待確認。新增提醒只影響畫面／語音，未擴充 C4 控制資料。尚待 Android 實機與實車驗證。

[安裝與重建說明](variants/wide37/README.md) · [配對結果](variants/wide37/verification/mapping-report.json) · [離線回放](variants/wide37/verification/replay.txt) · [APK 檢查](variants/wide37/verification/verification.json)

此項為原始碼與測試存檔，APK 已於對話交付，尚未建立 wide.37 GitHub Release。

## wide.30 台灣測速正式畫面修正

修正分割畫面只剩工具列與分隔線的問題。台灣測速分區可顯示即時時速、可用速限、測速距離與 GPS 狀態，面板較矮時將「更多」移到切換列。已在 Android 15 模擬器重現舊版問題，並驗證覆蓋安裝、縮小版面及模擬定位更新。

[下載 Android APK 與原始碼 ZIP](https://github.com/FANHAOHSIANG/copilot-Tw/releases/tag/wide.30) · [安裝與重建](variants/wide30/README.md) · [驗證紀錄](variants/wide30/verification/emulator.json) · [正式畫面截圖](variants/wide30/verification/emulator-live.png)

## wide.23 藍灰衛星地形圖示

[下載 Android APK](https://github.com/FANHAOHSIANG/copilot-Tw/releases/tag/wide.23) · [重建說明](variants/wide23/README.md)

## wide.22 Google 地圖投屏

導航選單可切換高德車機版、高德一般版或 Google 地圖。Google 模式只投屏，並撤銷上一個高德來源的導航資料。

[Android APK](https://github.com/FANHAOHSIANG/copilot-Tw/releases/tag/wide.22) · [切換與重建說明](variants/wide22/README.md)

## wide.21 投屏與介面更新

一般高德鍵盤預設顯示在車機主畫面。鍵盤開合保留導航與神盾投屏。新版更新導航、神盾、台灣測速工具列與版面設定。

[Android APK](https://github.com/FANHAOHSIANG/copilot-Tw/releases/tag/wide.21) · [更新與重建說明](variants/wide21/README.md)

## wide.20 鍵盤修正版

修正高德一般版在分割畫面搜尋地址時的鍵盤顯示與輸入焦點。可直接覆蓋同簽章的 wide.19。

[Android APK](https://github.com/FANHAOHSIANG/copilot-Tw/releases/tag/wide.20) · [修正與重建說明](variants/wide20/README.md)

## wide.19 測試版

單一 Android APK 可切換高德車機版／一般版，Carrot 導航來源同步切換。台灣固定測速紅光從 500 公尺開始加快。另有 Shizuku／Stellar 安裝教學、Amap2Tesla 僅投神盾及 iOS 原生 Xcode 專案。

[Android APK 與 iOS 專案](https://github.com/FANHAOHSIANG/copilot-Tw/releases/tag/wide.19) · [使用與安裝教學](variants/wide19/README.md)

## wide.18 測試版

三版桌面名稱均為 **Copilot tw**，全畫面加入 C4 接管細框。台灣版可切換車機／一般高德，並加入獨立測速示範與接近紅光。

[三版 APK](../../releases/tag/wide.18) · [安裝與重建](variants/wide18/README.md)

## 最新合併測試版：wide.17 HCOP Taiwan Adaptive

**[下載 wide.17 APK 與修改包](../../releases/tag/wide.17-hcop-tw-adaptive)** · [安裝與檢查結果](variants/hcop-tw-adaptive/README_zh-TW.md)

已將自製台灣測速面板合併自動橫直排版，統一「GPS／快捷／更多」操作，App 顯示名稱為 **CoPilot Tw**。使用高德車機版，原 HCOP 資料與導航核心保持不變。版本碼 26110729，原簽章，可覆蓋 wide.16。已通過編譯與離線檢查，尚未實機／實車驗證。

以下為先前 wide.16 三版本存檔：

CP 搭子 Taiwan：集中保存 Navipilot wide.16 的三個客製測試版本、Java／smali 補丁、安裝與使用說明。

**[下載三版 APK 與修改包](../../releases/tag/wide.16-archive)** · [安裝與使用](docs/INSTALL_zh-TW.md) · [原始碼與重建](docs/BUILD_zh-TW.md)

## 版本選擇

| 版本 | APK | 導航與右側畫面 | 狀態 |
| --- | --- | --- | --- |
| Auto Adaptive | `Navipilot-9.3.1-wide.16-auto-adaptive.apk` | 高德車機版＋神盾；橫直向自動排版 | 排版測試版 |
| Phone Adaptive | `Navipilot-9.3.1-wide.16-phone-adaptive.apk` | 高德一般版＋神盾；橫直向自動排版 | 一般版導航資料仍待裝置驗證 |
| HCOP Taiwan | `Navipilot-9.3.1-wide.16-hcop-tw-test.apk` | 高德車機版＋台灣道路速限／固定測速面板 | HCOP 台灣資料串接測試版 |

Auto／Phone 的差別是搭配的高德 App，不是限制只能安裝在車機或手機。HCOP Taiwan 以 wide.14 為基底，**沒有合併 Adaptive 的直向自動排版**。

三版沿用套件 `com.jixiexiaoge.drivingassist.wide`、既有測試簽章及版本碼 `26110728`，互相覆蓋，不會並存。

## 保存內容

- `variants/auto/`：車機高德版補丁、排版程式與既有驗證紀錄。
- `variants/phone/`：一般高德版補丁、通知診斷與排版程式。
- `variants/hcop-tw/`：台灣道路速限、固定測速、資料生成及接收端離線測試程式。
- Releases：三個既有 APK、三份公開修改包（含基底 APK、smali／資料資產）及 SHA-256。
- 各版本原有 README 保留在其目錄；簽署金鑰相關內容請以 [重建說明](docs/BUILD_zh-TW.md) 為準。

這是**原 APK 的修改程式碼與重建材料存檔**，不是原作者完整 Gradle／Android Studio 專案。原始碼目錄供直接檢視；重建應解壓對應的 Release 修改包，保留原相對路徑。

## 品牌與驗證範圍

專案名稱為 **CoPilot Tw**。此次存檔未重新編譯 APK，安裝後的原 App 顯示名稱、套件名稱、簽章與內容維持原檔，不代表已完成 App 內名稱變更。

既有版本的編譯、離線測試與檢查紀錄隨程式保存；此次上傳驗證檔案完整性、APK 與來源雜湊一致、公開修改包排除簽署金鑰。沒有新增 Android 實機或實車驗證。

一般高德出現通知不代表已提供完整導航資料；神盾投屏不代表已取得神盾內部測速資料。HCOP Taiwan 預設只預覽台灣資料，資料送往 C4 必須手動開啟測試設定；接收成功不代表車輛已執行減速。

## 授權與來源

原 CP 搭子／Navipilot APK 權利屬原作者，本儲存庫未替原 App 重新授權。
HCOP 參考程式的原 MIT 授權、OpenStreetMap ODbL 與政府開放資料來源說明保留於 [HCOP Taiwan 說明](variants/hcop-tw/README_zh-TW.md)。沒有將整個專案一律標成 MIT。

私人簽署金鑰不公開。公開修改包（含其巢狀 ZIP）已移除 `.jks` 等簽章私鑰；個人行車紀錄不在本次上傳範圍。
