# CP Google 導航 0.1.1（NavDash 衍生配套）

這是供 CP 搭子選取的獨立 Google Navigation SDK 導航 App。來源為 [henryopen/openpilot navdash](https://github.com/henryopen/openpilot/tree/2decc11c5d8cebbdb87c0751ef52b96a494506c0/navdash)，在同一台 Android 裝置內，把 SDK 提供的轉彎、位置與路線交給 CP 搭子的原生 Navi v2 傳送器。左側畫面繼續使用 CP 搭子的投屏功能。

本目錄保留原本可編譯的 Kotlin／Java／Gradle 原始碼，不是從 APK 反編譯的替代品。復原檔案雜湊在 `verification/source-recovery.json`；0.1.1 的修正另列於下文。

## 固定設定

| 項目 | 本版內容 |
| --- | --- |
| App 名稱 | CP Google 導航 |
| Android applicationId | `com.copilottw.googlenav` |
| Java／Kotlin namespace | `com.navdashn` |
| versionName／versionCode | `0.1.1-copilot`／`2` |
| Navigation SDK | `7.6.1` |
| Places SDK | `3.5.0`，`initializeWithNewPlacesApiEnabled` |
| Android SDK | compile／target 36，Build Tools 36.0.0，minSdk 26 |
| 配對主程式限制 | 主 CP 搭子仍要求 Android 12／API 31 以上 |
| 建置工具 | AGP 8.13.2、Gradle 8.13、Kotlin 2.2.10；本次用 JDK 21 編譯 |
| 本機資料通道 | `127.0.0.1:5002`；兩個 App 必須在同一台裝置 |

Navigation SDK 已包含地圖類別，因此專案排除重複的 `play-services-maps` 依賴。沒有從官方 Google Maps App 擷取私人路線資料。

## 個人金鑰與啟動

1. 在自己的 Google Cloud 專案設定計費並啟用 Navigation SDK、Places API (New)。費用與可用額度依帳戶、區域及 Google 現行規則決定，本 App 不保證免費。
2. 開啟 App，按「設定／更換 Google 金鑰」，在「我的 Google 導航金鑰」輸入自己的 key。
3. 用「複製套件名稱與 SHA-1」取得目前實際安裝 APK 的套件名稱及簽章憑證 SHA-1，填入 Google Cloud 的 Android 應用程式限制；API 限制也須包含實際使用的服務。
4. 儲存後按「開始 Google 導航」，接受 Google 條款及授予定位等權限。儲存 key 只代表本機保存成功，不代表 Google 已通過授權。
5. 主 CP 搭子選「更多 → CP Google 導航」，完成原有投屏與 C4 連線設定。

本版只從 App 設定頁接收 key，不將 key 編入 manifest、Gradle 或 `local.properties`。`GoogleKeySettings` 用 Android Keystore AES/GCM 加密，儲存於 `noBackupFilesDir/google-key-v1.bin`。Main／Guidance Activity 被 Android 恢復時也會先檢查初始化。

`NavigationApi.setApiKey` 由每程序共用的 `GoogleKeyGate` 管理。第一次儲存可直接進入；SDK 已初始化後更換或清除 key，必須到 Android 應用程式資訊強制停止，再重新開啟。無須重新安裝。

既有受控發行憑證 SHA-1：`AD:32:96:3B:94:DF:5E:30:DB:1B:24:EC:D6:2B:B9:11:F8:8D:48:7E`。自行建置通常使用其他憑證，應以 App 複製出的實際值為準。簽署私鑰不在此專案。

## 0.1.1 搜尋與生命週期修正

- Places API (New)：至少 2 個字才搜尋，文字輸入防抖 350 ms；同一查詢／同一代次 1 秒內去重。搜尋鍵與語音結果可立即送出，仍遵守去重。
- 同一輪 autocomplete 與所選地點的 `fetchPlace` 共用 session token；選點後替下一輪搜尋建立新 token。
- `fetchPlace` 僅要求 `Place.Field.ID` 和 `Place.Field.LAT_LNG`。名稱／地址沿用所選 prediction 的 primary／secondary text，不為顯示名稱另要求 NAME／DisplayName。這是減少不必要欄位，不代表搜尋、Details 或導航必然零費用。
- 9010 顯示配額／請求頻率、使用量與計費提示；9011 顯示 Places API (New)、API 限制及套件／SHA-1 提示。7 才是網路錯誤。不顯示原始 SDK 錯誤字串或 key。
- 舊 autocomplete 不能覆蓋新查詢；Activity 銷毀或停止導航使待處理 Details 失效。舊 `setDestination` 回呼不能在停止、釋放 SDK 或改選目的地後重開導航。
- 「停止模擬並撤銷導航」清除模擬定位、NavInfo、路線及待完成規劃；必須重新選目的地開始真實導航，不把舊模擬資料立即重新標為真實。

主要檔案：`MainActivity.kt`、`GoogleSearchPolicy.java`、`RequestGeneration.java`、`navigation/NavController.kt`。

## 本機資料與判斷界線

`NavHttpServer` 只綁定 loopback，接受 GET `/health`、`/nav`、`/route`。`/nav` 含程序 `sessionId`、路線 `routeVer`、實際 NavInfo 回呼 `navAgeMs`、位置 `ageMs`、模擬旗標、當前步驟、後續最多 3 步及剩餘行程。`/route` 含相同 session／version 與 `[lat,lng]` 座標。

下一步 `distFromPrev` 保留 Google SDK 的「與前一步間距」。配套主程式 wide46 的 `variants/google-bridge46` 按已核對的 C4 receiver 合約傳送間距，由 C4 加上目前距離：180 m current、260 m gap，最終為 440 m。歷史 wide44／45 的相加行為已由 wide46 修正。

主程式檢查程序、路線版本、來源選擇與 3 秒資料時效；停止、重新規劃、模擬、失效或切換來源時撤銷資料。路線 session／version 必須相符，主程式最多送連續 256 點。不從 Google 臆造道路速限、測速點或紅綠燈。

「CoPilot 本機通道：正在讀取」表示主 CP 在本機取得資料；「已交給原有 Navi v2 傳送流程」表示手機端交付，兩者都不是 C4 接收或車輛控制成功回報。

## 從原始碼建置

安裝 JDK 17 或相容版本、Android SDK 36／Build Tools 36.0.0。在未納入版控的 `local.properties` 設 `sdk.dir`，或設定 `ANDROID_HOME`。不要加入 API key。初次建置需網路下載 Gradle／Maven 依賴。

公開來源以 `prepare_resources.py` 恢復 7.8 MB 的上游 `hfop_bg.png`，因此可不將該 PNG 重複上傳到 Git。程式從固定上游 commit 下載，先驗證 7,803,668 bytes 與 SHA-256 `0443af2eb356b08eaac13ab404c774cd7be5135934726e0493d88f5813ec2782` 才寫入；若既有檔案相符，不會改寫；不符則拒絕，不能悄悄覆蓋。PNG 沿用上游授權。

```sh
python3 prepare_resources.py
./gradlew :app:testDebugUnitTest :app:assembleRelease
```

`.github/workflows/google-companion-build.yml` 在 `release/google-navigation-011-build` push 或手動觸發時，以 JDK 21、Android SDK 36／Build Tools 36.0.0 與 Gradle wrapper 執行正常 unit tests／release build，沒有排除 lint。它不使用簽署 secrets，只上傳該次未簽章 APK、SHA256SUMS、source commit／run metadata 及測試報告，Actions artifact 保存 90 天。後續簽署必須下載該次 artifact 並驗其雜湊，不以其他重編檔替代。

release 產物：`app/build/outputs/apk/release/app-release-unsigned.apk`，未簽章。請在專案外以受控金鑰簽署；不要提交私鑰、密碼、`local.properties`、`google-services.json`、SDK cache 或 build 目錄。開發測試可用 `./gradlew :app:assembleDebug`，debug 簽章不能覆蓋不同憑證的受控發行版。

本次離線環境已完成 release 編譯、8 個 JUnit 測試及 8 個原有金鑰生命週期斷言。因未快取 `com.android.tools.lint:lint-gradle:31.13.2`，本次命令排除 release lint 的三個 task；沒有把關閉 lint 寫進專案設定，也不宣稱 lint 通過。完整環境應使用上方不排除 task 的標準命令。結果見 `verification/build-011.json`。

## 來源與驗證界線

- [上游固定提交](https://github.com/henryopen/openpilot/tree/2decc11c5d8cebbdb87c0751ef52b96a494506c0/navdash)；MIT 授權在 `UPSTREAM_LICENSE`。
- [Google Navigation SDK 版本紀錄](https://developers.google.com/maps/documentation/navigation/android-sdk/release-notes)。
- [Google Places 欄位](https://developers.google.com/maps/documentation/places/android-sdk/place-details)。
- [Google Places 狀態碼](https://developers.google.com/maps/documentation/places/android-sdk/reference/com/google/android/libraries/places/api/net/PlacesStatusCodes)。

尚未用真實 key 執行搜尋／導航，未完成 Android 車機投屏、實際 SDK Messenger 傳送端身分、C4 接收或道路行為驗證。編譯與 host replay 不能代替裝置結果。
