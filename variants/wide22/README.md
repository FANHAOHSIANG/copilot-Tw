# Copilot tw wide.22

[下載 Android APK](https://github.com/FANHAOHSIANG/copilot-Tw/releases/tag/wide.22)

沿用 wide.21 簽章，可直接覆蓋安裝。啟動投屏後，在導航側的「更多」選「高德車機版」、「高德一般版」或「Google 地圖」。已選的導航會打勾，重開後會記住。Google 模式使用車機已安裝的 Google 地圖 App。

| 選擇 | 導航區 | Copilot 傳給 Carrot 的導航資料 |
| --- | --- | --- |
| 高德車機版 | 高德車機 App | 所選高德版本送出的有效資料 |
| 高德一般版 | 高德一般 App | 所選高德版本送出的有效資料 |
| Google 地圖 | Google 地圖 App | 切換時撤銷高德路線、轉彎、速限與測速。Google 模式只投屏。 |

若另有啟用 HCOP 台灣道路速限與測速，該資料源獨立運作。分享目的地座標給 Carrot 也屬獨立功能。Google 文件提供啟動官方 App 的操作，另有需要專案整合的 Navigation SDK。[啟動 Google 地圖](https://developers.google.com/maps/documentation/android-sdk/intents) · [Navigation SDK](https://developers.google.com/maps/documentation/navigation/android-sdk/overview)

已通過同簽章、APK 對齊、反組譯與離線切換測試。Google 地圖投屏仍待車機實測。[APK 驗證結果](verification/android.json)

## 重建

使用 [wide.21 的工具與簽署設定](../wide21/README.md)。把 wide.21 的 APK 存為 `inputs/taiwan.apk`，以 `inputs.sha256` 核對。編譯預設引用同層的 `../wide19` 與 `../wide21` 原始碼。也可用 `COPILOT_WIDE19_SOURCE` 和 `COPILOT_WIDE21_SOURCE` 指定位置。

```sh
bash compile.sh
bash build_variant.sh taiwan
```
