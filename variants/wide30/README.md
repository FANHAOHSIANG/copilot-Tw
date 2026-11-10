# Copilot tw wide.30 — 台灣測速正式面板

Android APK 版本 `9.3.1-wide.30-live-pane`，可覆蓋同簽章的 wide.29。進入導航畫面後，選右側「台灣測速」。時速、速限標誌、距離和定位資訊會直接出現在該分區，定位尚未取得時會顯示等待狀態。

## 修正空白的原因

wide.29 的右側框架有預留高度，但內部視圖只填滿寬度。包住儀表的捲動容器在量測時縮到只容納工具列與拖曳線，儀表再扣掉拖曳線的留白就沒有可畫的高度。wide.30 讓右側分區填滿實際分配的高度，儀表、工具列和拖曳線各有自己的位置。

分區較矮時，「更多」合併到上面的台灣測速／神盾切換列，裡面可開關定位、調整版面及顯示或收合快捷鍵。GPS 時速取得後會顯示數值。測速距離在 500 公尺內隨接近放大，並加快紅光警示。只有取得有效速限時才顯示標誌，附近候選會標示「未確認」。

## 驗證及重建

`verification/android.json` 記錄 APK 校驗和簽章比對，`verification/emulator.json` 記錄模擬器測試結果。原始碼包內的 Java 檢查涵蓋導航來源、GPS 權限與自動啟動、資料過期、附近候選、距離縮放和示範畫面。實車 GPS 與 C4 行為需在車機上驗證。

重建請將 wide.29 APK 放在 `inputs/taiwan.apk`。用 `COPILOT_ANDROID_TOOLS` 指定 Android SDK 建置工具，以 `COPILOT_SIGNING_KEY`、`COPILOT_STORE_PASSWORD` 和 `COPILOT_KEY_PASSWORD` 指定本機簽章資料，再執行 `bash compile.sh` 和 `bash build_variant.sh taiwan`。原始碼包沒有 APK 或私有金鑰。
