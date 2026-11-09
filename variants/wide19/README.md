# Copilot tw wide.19

[下載 Android APK 與 iOS Xcode 專案](https://github.com/FANHAOHSIANG/copilot-Tw/releases/tag/wide.19)

Android 12 以上安裝一個 APK，即可在「導航 → 更多」切換高德車機版或一般版，並選擇台灣測速或神盾面板。高德與神盾需另外安裝。APK 沿用前版的套件與簽章，原本使用同簽章的 wide.18 可以直接更新。

## Carrot 導航資料

在導航區選「更多 → 切換至高德一般版／高德車機版」。畫面與 Carrot 的高德來源一起切換。Copilot 撤銷上一個來源的速限、測速與路線欄位，待選定的高德送來新資料再更新。當兩個版本使用相同的廣播且系統無法提供發送者身分，Copilot 會捨棄該筆資料。只要選定版本有提供有效欄位，C4 就能使用它們作為調速輸入，實際加減速與最高速度由 C4 的控制邏輯及設定決定。

台灣測速面板預設只提醒。若另外在台灣測速區啟用「HCOP 台灣道路速限＋測速（測試）」，台灣資料提供道路速限與測速欄位，路線及轉彎仍跟隨選定的高德。台灣資料不足時撤銷該欄位。重新開啟 App 時會回到高德道路速限與測速。

## 台灣測速提醒

| 點位 | App 提醒 | Carrot 台灣測速輸入 |
|---|---|---|
| 482 筆道路配對候選，包含在 1,856 筆內 | 符合即時定位及同路段條件時顯示前方測速 | 啟用 HCOP 並通過即時同路段檢核後才可送出 |
| 其餘 1,374 筆固定點 | 符合定位、行進方向及距離條件時顯示「附近固定測速」，以直線距離標示 | 不送出 |
| 經常出沒點、機動測速 | 此資料快照沒有獨立點位。若現場也是收錄的固定點，依固定點規則提醒 | 不送出未收錄點位 |

符合條件的固定測速點在 500 公尺開始閃紅光。接近時，閃爍週期約從 1.2 秒縮短至 0.4 秒。可在「台灣測速 → 更多 → 示範固定測速」看效果。區間測速資料分開計算。固定點來源為 2026 年 11 月 9 日下載的警政署快照。[測速執法設置點資料](https://data.gov.tw/dataset/7320)

## Shizuku／Stellar 安裝與投屏

1. 在車機安裝 Shizuku 或 Stellar，選一個即可。[Shizuku 下載](https://github.com/RikkaApps/Shizuku/releases) · [Stellar 下載](https://github.com/roro2239/Stellar/releases)
2. 到 Android「開發人員選項」開啟無線偵錯。回管理工具選無線偵錯的配對流程，在系統選「使用配對碼配對裝置」，完成配對後按「啟動」。若車機沒有無線偵錯選項，照管理工具提供的電腦 USB ADB 流程啟動。[Shizuku 官方專案](https://github.com/RikkaApps/Shizuku)
3. 若用 Stellar，在 Stellar 裡確認「Shizuku 相容層」已開啟。回到 Copilot tw，按「導航 → 更多 → 啟動投屏／授權」，接受首次存取提示。[Stellar 官方專案](https://github.com/roro2239/Stellar)
4. 「導航 → 更多 → 投屏安裝與授權」內建同一套教學，可選管理工具並開啟「開 App 時開啟管理工具」。開 Copilot 時若服務尚未就緒，會帶到選定的管理工具。首次配對、授權及需要重啟服務時，依工具畫面操作。

## Tesla 瀏覽器只投神盾

1. 確認 Android 已安裝神盾測速照相，並完成 Shizuku 或 Stellar 的投屏授權。
2. 在「導航 → 更多」開啟「Amap2Tesla 僅投神盾」。
3. 依 Amap2Tesla 原有流程啟動 Tesla 投屏，確認裝置和車機可互通，再用 Tesla 瀏覽器開啟畫面顯示的網址。只投神盾模式下，投屏的虛擬螢幕會開啟神盾。要換回原投屏模式，先停止投屏，再切換設定。[Map2Tesla 投屏說明](https://github.com/jixiexiaoge/Map2Tesla)

## iPhone／iPad

[iOS 0.1 Xcode 專案](ios/)支援 iOS 17 以上，包含 Apple 地圖、前景 GPS、固定測速紅光與示範。用 Mac 的 Xcode 開啟專案，選擇自己的 Apple Team，再接 iPhone 安裝。此版尚未接入 Carrot、高德、神盾、Tesla 投屏與背景提醒。

## 重建 Android

使用 Java 17、Python 3、ripgrep、Apktool 3.0.3、ECJ 3.39、Android API 35 與 Android build-tools 36。以 `COPILOT_ANDROID_TOOLS` 指向工具目錄，其中包含 `apktool.jar`、`ecj.jar`、`android-35/android.jar` 及 `android-16/` 下的 d8、zipalign、apksigner。

把 [wide.18 的台灣版 APK](https://github.com/FANHAOHSIANG/copilot-Tw/releases/tag/wide.18) 存為 `inputs/taiwan.apk`，用 `inputs.sha256` 核對。公開程式碼不包含私人簽署金鑰。自行簽署時，在本機設定 `COPILOT_SIGNING_KEY`、`COPILOT_STORE_PASSWORD`、`COPILOT_KEY_PASSWORD`，需要時設定 `COPILOT_KEY_ALIAS`。

```sh
bash compile.sh
bash build_variant.sh taiwan
```

[APK 驗證結果](verification/android.json)涵蓋同簽章、16 KiB 對齊、DEX 重組及引用檢查。[離線測試](tests/Wide19Test.java)覆蓋切換後的舊來源阻擋、欄位撤銷及 500 公尺紅光行為。Android／C4、Tesla 及 iPhone 尚待實機驗證。
