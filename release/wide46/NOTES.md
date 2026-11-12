# CoPilot tw wide.46 + CP Google 導航 0.1.1

這次完成科技執法畫面／語音接線、Google 下一步距離修正，並恢復 wide.44 原始來源與完整 Google 配套專案。兩個簽署 APK 都保留原受控發行憑證。

## 安裝檔

- **Copilot-tw-9.3.1-wide.46-enforcement-google.apk**：主程式，Android 12 以上。
- **CP-Google-Navigation-0.1.1.apk**：Google Navigation SDK 配套；與主程式安裝在同一台 Android 裝置。使用自己的 Google Cloud API Key，依 Google 現行免費額度／計費規則使用。
- **Copilot-tw-wide.46-source.zip**：此 release commit 的完整來源及修改材料；主程式是可編譯 overlay，Google 配套是 Gradle 專案。
- **SHA256SUMS.txt**：下載完整性核對。

## 完成的功能

科技執法不需設定目的地。已確認同路及適用行向時才產生確定提醒；同路前方但公告行向未知，語音明說「取締方向待確認」。附近、條件未確認及參考記錄不主動播報。新提醒只提供畫面及聲音，不產生道路速限或自動減速欄位。設定與診斷入口在主面板「更多 → 科技執法提醒與診斷」。

右側儀表顯示車速、接管狀態、有效速限與主要提醒；測速或 Google 轉彎優先時仍保留科技執法次提示。停止、定位過期、道路判定降級或公告適用內容改變，舊語音會撤銷。

Google 的 next distance 改交付步驟間距，已核對的 C4 receiver 再加 current 一次：180 m＋260 m＝440 m。配套 0.1.1 只索取 Place Details ID／LAT_LNG，加入搜尋防抖、session token 修正及非同步取消；不保證零費用。

## 驗證及實際限制

67 項核心、46 項 runtime／語音生命週期、316 項繪圖、38 項 Google mapper、21 項實際 receiver 合約檢查通過。Google 配套的 8 個 JUnit 與 8 個 key 生命週期斷言通過；GitHub CI 正常執行 release lint／assembleRelease，與本機 unsigned APK 逐位元一致。

最終主 APK 獨立核對通過：原有 3,839 類及 5,995 個 assets／lib／res 檔不變，所有新增／修改類別及反向呼叫者沒有未解析內部引用，5 處新增 hook 可還原原方法。簽章與 16 KiB 對齊均已核對。

2,148 筆官方公告中 1,152 筆有座標。合成道路情境得到 56 筆確定方向與 229 筆方向待確認語音提議；這不是實車覆蓋率，也不代表所有公告設備仍有效。

**尚未以使用者手機、Google 個人 Key／帳單或 C4 完成實際驗收。** 請依附帶的 Device-Acceptance-zh-TW.md 分別確認安裝、離線中文 TTS、背景定位、導航、本機讀取及 C4 接收。完整 Google Cloud 申請、設定與使用見 CP-Google-Navigation-Complete-Guide-zh-TW.md；原始來源的 docs/GOOGLE_SDK_zh-TW.md 保留相同完整內容及官方引用。

## 維護材料

`CP-Google-Navigation-0.1.1-unsigned-build-input.bin` 是固定 CI 的未簽署建置輸入，供公開 signature patch 日後精確還原使用；**一般使用者不需下載，也不能把它當作安裝檔**。它沒有私人簽署金鑰。來源中的 release/wide46/restore.py 驗證 base、patch 及最終 APK 的完整 SHA-256；release/wide45/manifest.json 另能還原主程式建置需要的固定 wide.45。
