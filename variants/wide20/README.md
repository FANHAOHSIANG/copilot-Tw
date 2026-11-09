# Copilot tw wide.20 鍵盤修正版

[下載 Android APK](https://github.com/FANHAOHSIANG/copilot-Tw/releases/tag/wide.20)

可從同簽章的 wide.19 直接覆蓋安裝。到導航側的「更多」切換成高德一般版，啟動投屏後點高德的地址搜尋框。鍵盤應可在導航分區展開。若車機系統將鍵盤放在主畫面，鍵盤開啟或收起時，Copilot 會保留目前的投屏，避免一般高德失去輸入焦點。

變更只針對高德一般版的本機分割投屏。由既有已授權的投屏服務，對該虛擬螢幕設定鍵盤顯示方式。若系統拒絕該設定，保留系統的鍵盤位置。沒有新增 Android 權限或更動系統的預設輸入法。[Android 多螢幕輸入法說明](https://source.android.com/docs/core/display/multi_display/ime-support)

本包已通過同簽章檢查、APK 對齊與反組譯驗證。離線測試檢查鍵盤設定僅套用於一般高德、系統拒絕時繼續投屏，以及鍵盤尺寸變動的判斷。車機輸入法的實際顯示與連續輸入仍待實測。[驗證結果](verification/android.json)

[投屏安裝、神盾、Carrot 與 iOS 說明](../wide19/README.md)

## 重建

依照 [wide.19 工具和簽署設定](../wide19/README.md)。把 wide.19 的統一版 APK 放在 `inputs/taiwan.apk`，以 `inputs.sha256` 驗證。編譯會引用同層的 `../wide19` 原始碼，或以 `COPILOT_WIDE19_SOURCE` 指定位置。

```sh
bash compile.sh
bash build_variant.sh taiwan
```
