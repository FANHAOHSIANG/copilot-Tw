# Copilot tw wide.39：高德預調速綁定＋固定關閉按鈕

套件 com.jixiexiaoge.drivingassist.wide；版本 9.3.1-wide.39-amap-bound / 26110751。同簽章可覆蓋 wide.37；wide.38 為此次過程中的 UI 建置，整合交付為 wide.39。

## 速度來源

- 預調速固定來自目前選定的高德（車機／一般版），必須有原始程式接受且未過期的智慧調速結果。不是把任意高德道路速限當成預調速。
- 台灣模式仍由既有台灣配對提供道路速限及測速 sdi。原有資料覆蓋範圍、GPS／道路配對及測速控制門檻不變。
- 同時有高德有效預調速與台灣有效道路速限時，road_limit_kph 取較低值。例：高德60／台灣100 →60；高德100／台灣60 →60。台灣相機的速限／距離另以 sdi 保留，仍由 C4 原有策略處理。
- 沒有台灣配對時，仍可保留有效高德預調速；高德逾時或無有效策略，只有台灣有效資料參與。兩者皆無則不新增速度限制。
- 沿用原 R4 策略有效性／來源檢查；額外要求 speed 時戳不超過2秒、非未來時戳。切換高德／Google 仍經原 WideAmapSource 過濾。沒有延長策略壽命，也沒有用 UI 的1分鐘標誌保留時間控制車輛。
- 高德導航與轉彎資料保留。一般高德沒有輸出所需資料時，不會憑空建立策略。

舊版高德預調速同樣放在 road_limit_kph，台灣模式會移除此值。本版在原策略通過新鮮度檢查後加上內部來源標記，通過選定來源過濾、台灣合併，再取有效較低值。內部標記在送出前移除，沒有新增 C4 必須支援的封包欄位。合併時戳不晚於原高德資料，避免台灣更新讓高德結果延壽。未修改 C4 分支或即時車輛設定。

## 關閉按鈕

「顯示與版面」與「台灣測速設定／診斷」的關閉按鈕移到 ScrollView 外的底部中央。內容可捲動，按鈕固定，沿用原關閉事件。

## 驗證與限制

26項 Java 離線測試（含原 WideHcopMerge 與路況型別替身）、固定底欄結構測試、APK 編譯、簽章／16KiB對齊、最終反編譯掛點與資產差異檢查通過。測試替身未包進 APK。未經 Android 實機 UI 或 C4 實車減速驗證。App 送出較低值不等於車端已執行。沿用 wide.37 的測速覆蓋限制，沒有因此讓全部1856點都能提醒。

## 重建

這是原 APK 修改材料，不是完整 Gradle 專案。以公開下載的 wide.39 APK 或原 wide.37 APK（SHA256 見 verification）為基底，設定 COPILOT_BASE_APK、COPILOT_APKTOOL、COPILOT_BUILD_TOOLS、COPILOT_SIGNING_KEY、COPILOT_KEY_ALIAS、COPILOT_STORE_PASSWORD、COPILOT_KEY_PASSWORD 後執行 python3 rebuild.py。簽署私鑰不在包內，須使用自己的原簽章才能覆蓋更新。

速度測試：使用 org.json:json:20240303 及 Java8 編譯 src/WideAmapPreAdjust.java 與 tests/*.java，執行 com.navipilot.obf.BindingChecks。tests/WideBridge.java 只供編譯，整合案例直接呼叫原 WideHcopMerge，不代表完整 Android transport 測試。固定底欄測試另編譯 footer-tests/stubs、src/WideFixedFooter.java 和 footer-tests/FooterChecks.java。

[下載完整 APK 與修改材料](https://github.com/FANHAOHSIANG/copilot-Tw/releases/tag/wide.39)。安裝與功能說明請見儲存庫首頁。
