# Copilot tw wide.37 國一北上測速提醒修正

Android 版本 `9.3.1-wide.37-highway-alert`，版本碼 `26110749`。
可覆蓋同簽章的 wide.36，保留既有設定。安裝後在「關於」確認版本，選台灣測速、開啟 GPS 與測速語音。播報維持聲音 A「前方測速照相」，沿路距離進入 1000 公尺才啟用語音目標，畫面最遠可顯示 1500 公尺。

## 修正

- 國道「北上」是車流方向，不能直接當成 GPS 正北 0 度。湖口路段的北上車道實際朝東。本版以既有 OSM 單向車道連通關係補充提醒用配對。
- 竹北至台北範圍補回北上 82.1、81.1、37 公里及五楊高架北上 64.3、38.8 公里，共 5 個點。原本已有的 63.7 公里也納入回放驗證。
- 沿同名道路、同向且唯一相連的路段向前找測速點，距離用道路折線累加。路段跨越、短路段跳過可保留定位歷史。分岔無法確認時停止延伸，不猜出口。
- 修正舊道路判定已確認時，直接略過新軌跡搜尋結果的問題。UI 使用新的 Decision，保留原道路速限，不改寫控制端物件。
- 34.4 公里座標靠近匝道，尚未納入新增提醒。此版不是全台 1856 點全部可用的宣告。

## 驗證與限制

`verification/replay.txt` 是用包內 OSM 道路幾何產生的模擬 GPS 回放，不是使用者真實行車紀錄。六個點在約 990 公尺時進入語音距離條件，反向測試未觸發目標相機。另測多段道路、斷路、分岔、不同名稱高架道路、反向相機、已通過相機、短路段跨越和過期定位。

已完成編譯、APK 簽章、與 wide.36 同簽章比對、16 KiB 對齊、APK 反解與新 helper 引用檢查。未完成本版 Android 實機安裝、音訊輸出或實車 GPS 驗證。GPS 精度、方向與更新時效仍影響提醒。

此次新增配對與跨段搜尋只提供畫面／語音。C4 傳送程式、原 482 點控制用資料、原控制端道路配對規則均維持原樣，不能將新出現的提醒視為 C4 已收到減速資料。

## 原始碼與重建

這是以 wide.36 APK 為基底的增量修改包，不是完整原作者 Gradle 專案。`src` 是新 Java 實作及離線測試，`compat` 是測試／編譯依賴，`smali` 是實際 APK 使用的編譯結果。`fixtures` 是 OSM 幾何產生的測試資料，不含個人 GPS 紀錄。

需 Python 3、Java、apktool 3.0.3、Android Build Tools 36。設定 `COPILOT_BASE_APK` 為原 wide.36 APK 絕對路徑、`COPILOT_APKTOOL` 為 apktool.jar 絕對路徑、`COPILOT_BUILD_TOOLS` 為含 zipalign 與 lib/apksigner.jar 的目錄。簽章以 `COPILOT_SIGNING_KEY`、`COPILOT_KEY_ALIAS`、`COPILOT_STORE_PASSWORD`、`COPILOT_KEY_PASSWORD` 提供，執行 `python3 rebuild.py`。

基底 SHA-256 與交付 APK SHA-256 見 `verification/verification.json`。私鑰與密碼不在包內。

若要重跑 Java 測試，用 JDK 的 javac 編譯 `compat/*.java src/*.java`，再執行 `com.navipilot.obf.HighwayReplayChecks fixtures` 及 `com.navipilot.obf.HighwayTopologyChecks`。Java helper 使用 Java 8 語法，Android 最低 API 31。

## 資料來源與授權

測速點取自警政署政府開放資料 https://data.gov.tw/dataset/7320 ，依政府資料開放授權條款第 1 版。道路幾何 © OpenStreetMap contributors，ODbL 1.0，原包快照日期 2026-11-08。此增量包不替原 App 重新授權。

GitHub 原始碼存檔不含大型回放 fixtures。可設定 `COPILOT_ASSETS` 指向解開 wide.36 後的 assets 目錄，依序執行 `python3 build_alert_data.py`、`python3 make_replay.py` 重新生成。下載的原始碼 ZIP 已附 fixtures。
