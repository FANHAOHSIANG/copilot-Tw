# Google 個人金鑰模組（尚未接入 wide.43 APK）

HCOP / Navdash 的 full 分支在核對的 commit `2decc11c5d8cebbdb87c0751ef52b96a494506c0` 使用 Navigation SDK 5.0.0、Places 3.5.0。`local.properties` 的 MAPS_API_KEY 經 manifest placeholder 寫進 APK；PreferenceManager 的 apiKey 欄位不等於實際 SDK 支援動態換鑰。

此模組提供使用者自行貼上、替換與清除金鑰的 Android 對話框。金鑰使用 Android Keystore AES/GCM 加密，存在 noBackupFilesDir，不寫日誌、不放入 Git、不上傳自家伺服器。使用者自行在 Google Cloud 啟用計費與需要的 API，設定 Android 套件名稱與簽章 SHA-1 限制；介面提供複製這兩項公開資訊。儲存成功不代表 Google 已驗證授權。

Navigation SDK 7.6.0 開始支援 `NavigationApi.setApiKey`，必須在任何 Google SDK／地圖初始化之前呼叫，而且一個程序只能呼叫一次。GoogleKeyGate 保證重複初始化不重設金鑰；更改或清除後回傳 RESTART_REQUIRED，呼叫端必須關閉 Google 畫面並要求完整程序重啟，不能只重建 Activity。沒有金鑰時回傳 DISABLED，保留離線測速功能。

原始碼已使用真實 Navigation SDK 7.6.0 AAR + Android API 35 編譯，8 項金鑰生命週期測試通過；未使用真實金鑰發出計費請求。這是最低 API 相容性驗證，不是建議部署 7.6.0：Google 已列出 7.6.0 在 Android 12/12L 的已知問題，7.6.1 修復，正式整合必須選擇含修復的相容版本並重新測試。

接入時：

1. 在可選 Google 導航 flavor 加入 Navigation SDK 及其完整 Gradle 相依套件，依官方指南設定 desugaring；排除重複的 `play-services-maps`，Navigation SDK 已帶地圖類別。
2. 設定頁呼叫 `GoogleKeySettings.show(activity)`。
3. 進入 Google 頁面前呼叫 `GoogleKeySettings.initialize(context)`，僅 INSTALLED／UNCHANGED 可建立導航視圖並呼叫 `NavigationApi.getNavigator`。處理授權失敗與使用條款流程，顯示一般錯誤，不輸出例外中的憑證內容。
4. 若加入 Places，依其 API 個別初始化、處理啟用與計費；Navigation 的 key gate 不會替 Places 初始化。
5. 將 Google 道路貼合與導航事件送進獨立來源介面，切換來源時清除過期資料。離線測速不依賴 Google。

wide.43 APK 沒有捆綁 Google SDK，也沒有顯示這個設定頁，不能把本模組的編譯通過宣稱為 Google 導航完成。

參考：
- https://github.com/henryopen/openpilot/blob/full/navdash/app/build.gradle.kts
- https://developers.google.com/maps/documentation/navigation/android-sdk/release-notes
- https://developers.google.com/maps/documentation/navigation/android-sdk/reference/com/google/android/libraries/navigation/NavigationApi
- https://developers.google.com/maps/documentation/navigation/android-sdk/android-studio-setup
