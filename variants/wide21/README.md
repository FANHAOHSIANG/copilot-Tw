# Copilot tw wide.21

[下載 Android APK](https://github.com/FANHAOHSIANG/copilot-Tw/releases/tag/wide.21)

沿用 wide.20 簽章，可直接覆蓋安裝。

## 一般高德鍵盤

鍵盤預設顯示在車機主畫面。它會疊在兩個分區上方，投屏視窗保留原本大小。只改變鍵盤或 Surface 大小時，高德和神盾保留原投屏。手動拖曳或調整版面時，Copilot 直接調整既有虛擬螢幕的尺寸。切換高德版本時，只切換導航分區。

在一般高德的「更多」選「將鍵盤移至導航區」可改用分區內鍵盤。這個選項需要重開一次導航投屏才會套用。部分車機仍可能依系統設定選擇鍵盤顯示位置。[Android 多螢幕鍵盤說明](https://source.android.com/docs/core/display/multi_display/ime-support)

## 畫面

導航採淡藍識別，神盾用琥珀色，台灣測速用薄荷綠。三個分區共用深色工具列、字級與圓角按鈕。投屏未就緒時顯示原因和下一個操作。版面設定把比例與診斷分區顯示。

## 驗證

已通過同簽章、APK 對齊和反組譯驗證。離線檢查涵蓋主畫面與導航區的鍵盤路由、尺寸變動保留投屏、手動分割調整及原有 Carrot 資料選擇。中文鍵盤、手動比例調整及新版介面仍待車機實測。[APK 驗證結果](verification/android.json)

[投屏安裝、神盾、Carrot 與 iOS 說明](../wide19/README.md)

## 重建

使用 [wide.19 的工具與簽署設定](../wide19/README.md)。把 wide.20 的 APK 存為 `inputs/taiwan.apk`，以 `inputs.sha256` 核對。編譯預設引用同層的 `../wide19` 原始碼，可用 `COPILOT_WIDE19_SOURCE` 指定位置。

```sh
bash compile.sh
bash build_variant.sh taiwan
```
