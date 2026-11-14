# Carrot Bridge wide.69

版本 `9.3.1-wide.69-ui`，版本碼 `26110781`，支援 Android 12 以上。已沿用 wide.68 的憑證簽署。[下載 APK](https://github.com/FANHAOHSIANG/copilot-Tw/releases/download/wide.69/Carrot-Bridge-9.3.1-wide.69-ui.apk) · [發布說明](https://github.com/FANHAOHSIANG/copilot-Tw/releases/tag/wide.69) · [安裝與使用](../../docs/INSTALL_zh-TW.md)

## 更新與操作

| 更新 | 操作 |
| --- | --- |
| C 版投屏 | 移除分割畫面兩個頂部標題。右下角的「左側 ⋯」「右側 ⋯」各有返回、重啟及投屏設定。按「⌄」收起右下面板。收起後按右下「⋯」，可以重新展開或個別重啟兩邊。窄視窗也會使用單一「⋯」。 |
| Google 導航 NOO | 「左側 ⋯ → Google 導航 NOO」。搜尋移至頂部，結果的名稱及地址分行。「收藏」「最近導航」及自訂地址可繼續使用。按結束後清除目前引導並回到搜尋頁。金鑰由「左側 ⋯ → Google 導航串接與金鑰」設定。 |
| 神盾紅光 | 「右側 ⋯ → 選擇投屏 App／空白畫面 → 神盾測速照相」後，到「設定」開啟「神盾紅光提醒、取樣與尺寸保護」。成功辨識固定式或移動式測速點且距離在 500 公尺以內時，整個 App 四邊閃紅光。越近越亮，閃爍間隔越短。 |
| TDX 道路速限 | 在「設定」開啟「傳送道路速限至 C4（TDX／OSM）」。道路及方向確認後優先送 TDX，沒有同方向 TDX 資料時才選已確認的 OSM。遇到資料衝突、路段不明或過期時撤銷。地圖的 OSM 圓牌可獨立顯示、隱藏及移動。 |
| C4 ROUTE | C4 另外更新到 [test/carrot-wip-upstream-20261104 的 ROUTE 修正](https://github.com/FANHAOHSIANG/openpilot-carrot/commit/37082496551fed7fe36878e6a88a7ee86ec69eea)，沿用現有設定。車端改動及回放數字見 [車端更新說明](https://github.com/FANHAOHSIANG/openpilot-carrot/blob/37082496551fed7fe36878e6a88a7ee86ec69eea/docs/route_short_reversal_20261115_zh-TW.md)。 |

神盾辨識使用右側投屏影格。視窗達 757 × 384 px 才會嘗試辨識，至少兩次一致取樣才顯示紅光。關閉開關即可自由拖曳比例。神盾辨識結果目前用於本機畫面與診斷；尚未接入此版的 C4 測速出站流程。

道路速限採用已隨 App 交付的 TDX 路段資料。高公局國道路段表和公路局快速公路里程表仍待另行完成對照。已確認的 70 km/h 可以傳送。C4 接收欄位使用 10 km/h 的整數倍。

## 編譯與簽署

1. 下載 [wide.68 APK](https://github.com/FANHAOHSIANG/copilot-Tw/releases/tag/wide.68)。建置會核對基底 SHA-256。
2. 準備 Python 3.12、完整 JDK 21、Apktool 2.12.1 和 Android SDK。工具目錄應包含 API 35 的 `android.jar`，並將 Android Build Tools 35.0.0 放在 `android-15/`。建置從固定版本取得 Tesseract4Android 與繁體中文模型，並核對兩者 SHA-256，亦可預先放入同一工具目錄。
3. 執行下面的建置指令。結果為已對齊的未簽署 APK。

```sh
python3 variants/wide69/build.py WIDE68_APK TOOLS APKTOOL_JAR Carrot-Bridge-9.3.1-wide.69-pending-signature.apk
```

4. 在保有 wide.68 原簽章的環境中，沿用 [簽署工具](../wide55/sign.py)。將 `WIDE55_KEYSTORE_PASS` 和 `WIDE55_KEY_PASS` 設在本機環境後，執行：

```sh
python3 variants/wide55/sign.py \
  --unsigned Carrot-Bridge-9.3.1-wide.69-pending-signature.apk \
  --apksigner /path/to/android-15/lib/apksigner.jar \
  --keystore /private/path/to/original.jks \
  --alias ORIGINAL_ALIAS \
  --output Carrot-Bridge-9.3.1-wide.69-ui.apk
```

簽署工具會核對原憑證。發布用 APK 的套件名稱仍是 `com.jixiexiaoge.drivingassist.wide`，原憑證 SHA-256 為 `eb0f6a44174aecf09cedc237be2ca0305ea491d47b381407d31e903acbd34b46`。簽好後以同一憑證覆蓋安裝可保留既有 Google 金鑰限制與 App 資料。

## 驗證範圍

GitHub 發布的已簽署 APK 通過 v3 簽章驗證，憑證與 wide.68 相符。APK 的 SHA-256 為 `12b1d75dfcc19c18e8dc53f62e6c9085c446907edeb1c9dfc715845dffbecd30`。[下載 SHA256SUMS.txt](https://github.com/FANHAOHSIANG/copilot-Tw/releases/download/wide.69/SHA256SUMS.txt)

已編譯主程式與 Google 模組、核對資源 ID、APK 完整性及 16 KiB 對齊。從 APK 抽取道路配對與出站邏輯，通過 34 項離線檢查，涵蓋 TDX、OSM 備援、相鄰道路歧義、衝突撤銷及關閉開關。以神盾固定式實拍作離線影像檢查，讀到固定式、224 公尺、60 km/h。手機／車機啟動、移動式實際影格及 C4 實機接收仍待驗證。

可在 JDK 21 以 `python3 variants/wide69/check_road_limits.py APK APKTOOL_JAR ENJARIFY_CHECKOUT JSON_JAR` 重跑出站檢查。Enjarify 與 JSON 只用於主機測試，不會包進 APK。
