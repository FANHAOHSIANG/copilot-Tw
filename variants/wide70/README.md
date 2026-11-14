# Carrot Bridge wide.70

支援 Android 12 以上。已沿用 wide.69 的簽章，安裝同簽章版本可直接覆蓋並保留設定。[下載 APK](https://github.com/FANHAOHSIANG/copilot-Tw/releases/download/wide.70/Carrot-Bridge-wide.70.apk) · [安裝與操作](../../docs/INSTALL_zh-TW.md) · [發布說明](https://github.com/FANHAOHSIANG/copilot-Tw/releases/tag/wide.70)

| 分區 | 橫向位置 | 顯示內容 |
| --- | --- | --- |
| 分區一 | 右側 | 神盾或其他 App 投屏，可選靜謐時鐘。 |
| 分區二 | 左側 | 高德、Google 地圖或 Google 導航 NOO。 |

等待投屏時，各區顯示名稱和連線狀態。投屏收到第一個影格後會隱藏分區標示。選擇靜謐時鐘時，時鐘仍顯示「分區一」。

按「分區一 ⋯」或「分區二 ⋯」即可開啟對應選單，第一項為「返回投屏 App」。面板收起或視窗較窄時，從分區一底部的「⋯」打開個別分區的選項。App 名稱統一顯示「Carrot Bridge」，版本顯示為 `wide.70`。

## 建置與驗證

準備 Python 3.12、JDK 21、Apktool 2.12.1 與 Android SDK 35。工具目錄應包含 API 35 的 `android.jar`，並將 Android Build Tools 35.0.0 放在 `android-15/`。以已發布的 [wide.69 APK](https://github.com/FANHAOHSIANG/copilot-Tw/releases/tag/wide.69) 為基底。

```sh
python3 variants/wide70/build.py WIDE69_APK TOOLS APKTOOL_JAR Carrot-Bridge-wide.70-unsigned.apk
```

使用原簽章及 [簽署工具](../wide55/sign.py) 產生可覆蓋更新的 APK。[簽署步驟](../wide69/README.md#編譯與簽署)

已核對 APK v3 簽章、16 KiB 對齊、Android 套件名稱與版本資訊，確認兩區標示、第一個投屏影格與重啟／失敗狀態。通過 467 項既有主機檢查、34 項道路速限檢查及 26 項投屏狀態檢查。Android 實機啟動與投屏驗收待完成。

發布檔案 SHA-256 為 `3b6860407433ccb558a6e063c8bafd10d5e7d914b88eb174a6e2281676cd875a`。[下載 SHA256SUMS.txt](https://github.com/FANHAOHSIANG/copilot-Tw/releases/download/wide.70/SHA256SUMS.txt)
