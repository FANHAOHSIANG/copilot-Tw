# Copilot tw wide.18

三個 APK 的桌面名稱均為 **Copilot tw**，版本碼 26110730。三版使用同一套件及原簽章，可從 wide.16／wide.17 覆蓋安裝，三版會互相替換。

| APK 尾碼 | 導航 | 測速 |
|---|---|---|
| auto-adaptive | 高德車機版 | 神盾投屏 |
| phone-adaptive | 高德一般版 | 神盾投屏 |
| taiwan-adaptive | 車機版／一般版可切換 | 自製台灣測速 |

在台灣版的導航區按「更多 → 切換至高德一般版／高德車機版」。選擇會記住。如果只安裝了一般版，首次使用會自動選它。高德投屏仍需 Shizuku。一般高德的導航資料能否送達 C4，取決於該高德版本實際提供的資料。

台灣測速區的「更多 → 示範固定測速」會開獨立預覽，顯示距離逐步縮短。接近 500 公尺內時，圖卡內緣的紅光會逐漸加強。實況需啟動 GPS，並有符合原 HCOP 條件的同路段測速資料。區間測速也有獨立示範。示範數字只在預覽中顯示。

三版全畫面的 C4 外框均為 2 dp。只開橫向時灰色，橫向及縱向都開時綠色。兩者皆關、只有縱向、或車控資料遺失／過期時隱藏。

三版均通過 APK 簽章、對齊、桌面名稱、DEX 重組及引用檢查。離線測試覆蓋 C4 狀態組合、資料過期、窄版示範卡及紅光強度。車機上預覽視窗、高德切換與即時外框仍待實機確認。

## 重建

使用 Java 17、Python 3、ripgrep、Apktool 3.0.3、ECJ 3.39、Android 35 及 Android build-tools 36。工具路徑結構同 wide.17 的 `work/tools`，以環境變數 `COPILOT_ANDROID_TOOLS` 指定。

把三個原 APK 存到以下路徑。以 `inputs.sha256` 核對基底。

- `inputs/auto.apk` 取自 wide.16-archive 的 Navipilot-9.3.1-wide.16-auto-adaptive.apk。
- `inputs/phone.apk` 取自 wide.16-archive 的 Navipilot-9.3.1-wide.16-phone-adaptive.apk。
- `inputs/taiwan.apk` 取自 wide.17-hcop-tw-adaptive 的 CoPilot-Tw-9.3.1-wide.17-hcop-tw-adaptive.apk。

公開程式碼不包含私人簽署金鑰。已發布的 APK 可直接安裝。自行重建時，在本機設定 `COPILOT_SIGNING_KEY`、`COPILOT_STORE_PASSWORD`、`COPILOT_KEY_PASSWORD` 與需要時的 `COPILOT_KEY_ALIAS`。

```sh
bash compile.sh
bash build_variant.sh auto
bash build_variant.sh phone
bash build_variant.sh taiwan
```

驗證結果見 `verification/`。
