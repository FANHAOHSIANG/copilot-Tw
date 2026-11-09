# CoPilot Tw 安裝與使用

## 安裝

1. 到本儲存庫 Releases 選擇 wide.16-archive，下載需要的 APK。Auto 搭配高德車機版 `com.autonavi.amapauto`；Phone 搭配高德一般版 `com.autonavi.minimap`；HCOP Taiwan 搭配高德車機版。
2. Android 12 以上，準備對應高德 App；Auto／Phone 另需神盾。啟動 Shizuku 並完成原 App 所需授權。
3. 停車時停止投屏並關閉 CP 搭子，覆蓋安裝選定的 APK。三版互相覆蓋；不要為切換版本先解除安裝，以免遺失設定。若系統顯示簽章不相容，先確認目前安裝來源。
4. 重新開啟 App，依原設定連接 C4，完成定位、投屏與必要權限。C4 車況連線成功不等於導航傳送通道已建立。
5. 可用根目錄或 Release 的 `SHA256SUMS.txt` 核對下載檔；Linux 使用 `sha256sum`，macOS 使用 `shasum -a 256`。

## Auto／Phone 自動排版

寬橫向採左導航、右側神盾與快捷鍵；直向採上導航、下神盾。按「快捷」展開控制鈕；長按分隔把手後拖曳，橫向與直向比例各自保存。「更多 → 版面與比例設定」可調整或恢復預設。

Phone 的通知／廣播診斷保留，但目前沒有證實一般高德會提供完整導航、測速與轉彎資料。請參閱 [Adaptive 原說明](../variants/phone/adaptive16-src/README_zh-TW.md) 與 [Phone 串接說明](../variants/phone/phone15-src/README_zh-TW.md)。

## HCOP Taiwan

按「GPS」授予精確定位，先核對道路名稱、來源與固定測速資訊。有效行進方向與持續定位是確認條件，停車顯示空白不必然是故障。

預設使用高德，台灣資料只預覽。需測試時才在設定開啟「啟用 HCOP 台灣道路速限＋測速（測試）」。重開 App 會回到高德；手動切回高德可停止台灣欄位替換。此版尚未確認實車減速表現。

資料包期限至 2027-02-15；2027-02-16 起不送台灣資料，需更新資料包。完整範圍與限制見 [HCOP Taiwan 原說明](../variants/hcop-tw/README_zh-TW.md)。

## 回復與問題紀錄

Auto／Phone 公開修改包內 `deliverables/` 保留 previous-layout-restore-build28 APK，可回復各自舊排版。HCOP 可先在設定切回高德停用台灣來源；原 wide.14 專用回復 APK 未列入這次三版 APK 發布。

測試記錄可能含 GPS 軌跡、主機資訊及通知內容，請自行檢查後再分享，不要直接放在公開 Issue。記錄裝置、Android 版本、APK 名稱、發生時間及具體畫面即可協助定位問題。
