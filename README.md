# Carrot Bridge

在 Android 手機或車機上整合高德、Google 地圖、Google 導航 NOO、右側 App 投屏與 C4 車況診斷。

## 下載

Carrot Bridge 需要 **Android 12 以上**。要投屏時，另外選裝 **Stellar 或 Shizuku 其中一個**。導航與右側投屏 App 依需求安裝在同一台裝置。

| 要安裝的項目 | 下載 | 何時需要 |
| --- | --- | --- |
| **Carrot Bridge wide.69** | **[下載主程式 APK](https://github.com/FANHAOHSIANG/copilot-Tw/releases/download/wide.69/Carrot-Bridge-9.3.1-wide.69-ui.apk)** | 首次安裝或覆蓋更新 |
| Stellar 1.1 | [下載官方 APK](https://github.com/roro2239/Stellar/releases/download/v1.1%28101000%29/stellar-v1.1-release.apk) | 投屏工具，搭配 Shizuku 相容層 |
| Shizuku 13.6.0 | [下載官方 APK](https://github.com/RikkaApps/Shizuku/releases/download/v13.6.0/shizuku-v13.6.0.r1086.2650830c-release.apk) | 投屏工具，可擇一使用 |
| 高德車機版／高德一般版 | [車機版官網](https://www.amapauto.com/) · [一般版官網](https://mobile.amap.com/cn/download.html) | 選用高德時，安裝對應版本 |
| Google 地圖 | [Google Play](https://play.google.com/store/apps/details?id=com.google.android.apps.maps&hl=zh-TW) | 選用「Google 地圖（僅投屏）」時 |
| 神盾測速照相 | [Google Play](https://play.google.com/store/apps/details?id=tw.com.ainvest.outpack&hl=zh-TW) | 要在右側顯示神盾時 |

**Google 導航 NOO 已內建在主程式**，所需的 Google Cloud 金鑰請到 App 內設定。[Google NOO 金鑰教學](docs/GOOGLE_SDK_zh-TW.md)

wide.69 沿用 wide.68 的簽章憑證，已安裝同簽章版本可直接覆蓋更新並保留設定。

[wide.69 更新與操作](variants/wide69/README.md) · [最新版發布說明與 SHA-256](https://github.com/FANHAOHSIANG/copilot-Tw/releases/latest) · [歷史版本](https://github.com/FANHAOHSIANG/copilot-Tw/releases)

## 安裝與第一次使用

1. 在 Android 裝置上下載並安裝 Carrot Bridge APK。
2. 要投屏時，安裝並啟動 Stellar 或 Shizuku。首次使用無線偵錯時先配對。使用 Stellar 時，開啟 Shizuku 相容層。
3. 開啟 Carrot Bridge。按右下角「左側 ⋯ → 啟動投屏／授權」，在系統提示上授權。
4. 在「左側 ⋯」選擇導航來源。要投屏神盾時，在「右側 ⋯ → 選擇投屏 App／空白畫面」選擇神盾。畫面較窄或面板收起時，按右下角「⋯」即可打開左右兩側選項。
5. 要查看車況時，讓 Android 裝置和 C4 互通，在 App 的連線設定填入你的 C4 位址，再到「即時診斷」查看資料是否持續更新。

[完整安裝、操作與排錯](docs/INSTALL_zh-TW.md) · [投屏工具啟動與授權](third_party/projection/README.md)

## 選擇地圖與面板

| 畫面或功能 | 用法 |
| --- | --- |
| 高德車機版／高德一般版 | 按右下角「左側 ⋯」切換，在選定的高德 App 內設定路線。傳送狀態可在診斷查看。 |
| Google 地圖（僅投屏） | 顯示官方 Google 地圖 App 畫面。 |
| Google 導航 NOO | 內建 Google Navigation SDK。使用自己的 Google Cloud 金鑰，在內建畫面搜尋、規劃並開始導航。 |
| 右側投屏／即時診斷 | 「右側 ⋯」可選神盾、其他已安裝 App 或留白。右下面板可切換「即時診斷」與「操作面板」，用「⌄」收起，用右下角「⋯ → 展開面板」叫回。 |
| 版面與比例 | 拖曳分隔線後放開，投屏會依新視窗尺寸重新適配。 |
| 道路速限 | 授權精確定位後自動定位。「顯示 OSM 速限牌」和「傳送道路速限至 C4（TDX／OSM）」各有獨立開關。 |

## C4 導航整合與分支相容性

[test/carrot-wip-upstream-20261104](https://github.com/FANHAOHSIANG/openpilot-carrot/tree/test/carrot-wip-upstream-20261104) 是本專案的 C4 導航整合測試基準。App 和車端的 Navi v2 接收修正以這支分支共同核對，方便重現問題與進行回歸測試。

- **高德一般版路線接收**：這支分支已合併 [PR #40](https://github.com/FANHAOHSIANG/openpilot-carrot/pull/40)。車端原本在 256 點截斷長路線，修正後可完整保留最多 4,096 點。離線測試涵蓋完整路線接收、停止導航時撤銷及重複封包拒收。實車 NOO 仍需另行驗證。
- **只使用投屏**：顯示高德、Google 地圖或神盾畫面時，Android 裝置可獨立使用，無需 C4 或更換分支。
- **將導航資料送到 C4**：使用官方原生分支或其他分支時，請依實際版本確認 Navi v2 接收、路線與引導欄位的相容性。App 送出狀態和 C4 接收狀態可分別查看。
- **HUD 藍線**：[PR #41](https://github.com/FANHAOHSIANG/openpilot-carrot/pull/41) 的藍線修正仍在草稿階段，尚未合併。

## wide.69 更新

投屏移除頂部標題條，左右 App 可個別返回或重啟。Google 導航 NOO 更新搜尋版面，結束後回到搜尋頁。神盾辨識可觸發 App 內紅光並記入診斷。道路速限可選擇傳送經道路與方向配對的 TDX／OSM 資料。手機與車機實際啟動、辨識及 C4 接收待驗證。[wide.69 驗證與操作](variants/wide69/README.md)

[更新紀錄](CHANGELOG.md) · [開發與重建](docs/BUILD_zh-TW.md) · [資料來源與授權](docs/DATA_SOURCES_zh-TW.md) · [歷史首頁](https://github.com/FANHAOHSIANG/copilot-Tw/blob/0299f57241f1baeccabb1e8e12c96565d52fd1c2/README.md)

原 CP 搭子／Navipilot、第三方 App 與圖資各自沿用原有授權。[Stellar 與 Shizuku 授權](third_party/projection/README.md#版本與校驗)
