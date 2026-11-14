# Carrot Bridge

目前原始碼統一維護於本儲存庫的 `main`；C4 固定搭配 [test/carrot-wip-upstream-20261104](https://github.com/FANHAOHSIANG/openpilot-carrot/tree/test/carrot-wip-upstream-20261104)，不需要另外切換高德導航功能分支。

## 下載最新版

**Carrot Bridge 9.3.1-wide.68-ui（26110780）**可直接覆蓋安裝同簽章的 wide.67，並保留 App 資料。

| 下載 | 內容 |
| --- | --- |
| [下載 wide.68 APK](https://github.com/FANHAOHSIANG/copilot-Tw/releases/download/wide.68/Carrot-Bridge-9.3.1-wide.68-ui.apk) | Android 主程式 |
| [wide.68 發布說明](https://github.com/FANHAOHSIANG/copilot-Tw/releases/tag/wide.68) | 更新內容、安裝方式與 SHA-256 |
| [歷史版本](https://github.com/FANHAOHSIANG/copilot-Tw/releases) | 舊版與獨立版本 |

- 「Google 導航 NOO」緊接在「Google 地圖（僅投屏）」下方。
- 放開分隔線後，投屏依最新視窗尺寸重新適配，並同步調整觸控座標。等待適配時以等比方式填滿，畫面邊緣可能暫時裁切。

已核對簽章、APK 完整性、16 KiB 對齊與成品 DEX，並通過 121 組縮放與座標換算檢查。手機與車機的冷啟動及投屏縮放仍待實機驗證。

[wide.68 建置與驗證](variants/wide68/README.md) · [投屏工具與授權](third_party/projection/README.md) · [Google SDK 設定](docs/GOOGLE_SDK_zh-TW.md)

<details><summary>wide.56、wide.53 與較早版本說明</summary>

[wide.56 高德原始路線整合](variants/wide56/README.md) 已納入 wide.55 的 Link 傳送修正。**這是程式碼整合，wide.56 APK 尚待原金鑰簽署及實機驗收；下方舊版下載不包含 wide.56 修正。**

目前融合版：[**wide.53 自訂投屏與手機版面修正**](https://github.com/FANHAOHSIANG/copilot-Tw/releases/tag/wide.53)。以使用者已實際使用的 wide.52 為基礎，原套件與原簽章覆蓋更新。

| 下載 | 內容 |
| --- | --- |
| [wide.53](https://github.com/FANHAOHSIANG/copilot-Tw/releases/tag/wide.53) | 手機比例修正、右上自選 App／留白、右下即時診斷／原九宮格、三個常用地址、繁體介面；附 Shizuku 與 Stellar APK |
| [台灣測速 wide.51](https://github.com/FANHAOHSIANG/copilot-Tw/releases/tag/wide.51) | 保留台灣測速的獨立版本 |
| [融合版 wide.52](https://github.com/FANHAOHSIANG/copilot-Tw/releases/tag/wide.52) | 上一個融合版 |
| [CP Google 0.1.2](https://github.com/FANHAOHSIANG/copilot-Tw/releases/tag/cp-google-0.1.2) | 獨立配套；融合版已內建，不需另外安裝 |

[wide.53 操作與驗證說明](variants/wide53/README.md) · [投屏工具與授權](third_party/projection/README.md) · [Google SDK 設定](docs/GOOGLE_SDK_zh-TW.md)

wide.53 已完成編譯、程式檢查、原簽章與對齊驗證；新增功能仍需手機／車機驗收。融合版不含內建台灣測速。外部投屏 App 需自行安裝；投屏本身不代表其資料可傳給 comma。

# Copilot tw

> 最新整合測試版：[wide.46 科技執法與 Google 導航](variants/wide46/README.md)。完整 [Google Cloud 申請、設定、使用教學](docs/GOOGLE_SDK_zh-TW.md) 與 [裝置驗收步驟](docs/DEVICE_ACCEPTANCE_zh-TW.md) 已提供。

**把導航、台灣測速提醒與 Carrot 車況整合在同一個 Android 行車畫面。**

在同一個 App 切換高德車機版／一般版／Google 地圖，右側選擇台灣測速儀表或神盾投屏。配合 C4，可查看接管狀態，並傳送有效的導航與測速資料。

## 下載最新版

目前提供 **9.3.1-wide.46-enforcement-google（26110758）整合測試版**，搭配 **CP Google 導航 0.1.1**，更新日期 2026-11-12。完整搭配需要 Android 12 以上。

| 檔案 | 用途 |
| --- | --- |
| **[下載 CoPilot tw wide.46 APK](https://github.com/FANHAOHSIANG/copilot-Tw/releases/download/wide.46/Copilot-tw-9.3.1-wide.46-enforcement-google.apk)** | 主程式；同簽章受控發行版可覆蓋更新 |
| **[下載 CP Google 導航 0.1.1 APK](https://github.com/FANHAOHSIANG/copilot-Tw/releases/download/wide.46/CP-Google-Navigation-0.1.1.apk)** | Google SDK 配套；與主程式安裝同機，使用自己的 Google Cloud Key |
| [下載原始碼與修改材料 ZIP](https://github.com/FANHAOHSIANG/copilot-Tw/releases/download/wide.46/Copilot-tw-wide.46-source.zip) | 含恢復的 wide.44、wide.45／46 overlay、Google Gradle 專案與驗證材料 |
| [下載 SHA256SUMS](https://github.com/FANHAOHSIANG/copilot-Tw/releases/download/wide.46/SHA256SUMS.txt) | 核對下載完整性 |

[版本下載頁](https://github.com/FANHAOHSIANG/copilot-Tw/releases/tag/wide.46) · [Google SDK 完整教學](docs/GOOGLE_SDK_zh-TW.md) · [裝置驗收](docs/DEVICE_ACCEPTANCE_zh-TW.md) · [建置說明](variants/wide46/README.md) · [更新紀錄](CHANGELOG.md)

## wide.46 本次更新

科技執法公告接上 GPS、道路判定、儀表與離線中文語音。同路前方但取締方向未公開時，畫面與語音明說方向待確認；附近、條件待確認及參考公告不主動播報。停止定位、資料過期或道路／公告內容改變後，撤銷舊提醒。入口在右側面板「更多 → 科技執法提醒與診斷」。

Google 修正下一轉彎距離重複加總；CP Google 0.1.1 只請求必要地點欄位、加入搜尋防抖及非同步取消，並修正錯誤提示。Google 有免費用量但仍需 Billing，超量可收費；本專案沒有內附共用 Key。

已完成 67 項核心、46 項生命週期、316 項繪圖、38 項 Google mapper、21 項 receiver 合約檢查，主 APK 獨立 scope／reference、簽章及 16 KiB 對齊通過。Google 配套在乾淨 GitHub CI 完成單元測試、release lint 與建置。

**使用者裝置的 Google 授權、離線 TTS 實際聲音、背景定位與 C4 接收仍需按驗收文件確認。** 程式／資料回放不代表真車測試。科技執法新功能不產生速限或自動減速欄位；資料覆蓋限制詳見 [引擎說明](variants/enforcement-alert/README.md)。

## wide.42 本次更新

修正未知執法方向點擋住其他測速點、定位精度短暫變差清空歷史、定位每 4 秒更新無法確認方向，以及低速軌跡視窗不足的問題。各測速點獨立追蹤；失效定位不播報，有效定位恢復後才接續。候選資訊只供畫面／語音，不傳給 C4。

63 項程式檢查通過，另完成 17 種合成定位情境與 539 組道路回放；道路回放仍有 17 組未形成目標、9 組反向標記待查，未新增異常組。尚未完成實機 GPS、音訊、背景／切換來源及 C4 接收驗證。高德一般版仍為診斷階段，不能宣稱已修復實機傳輸。

[本版修改與驗證](variants/wide42/README.md)。已完成原金鑰簽署與 16 KiB 對齊，可覆蓋同簽章舊版。

## wide.41 本次更新

修正背景計算稍慢便隱藏提醒、道路候選過多時全部重置、空結果蓋掉有效測速點與道路速限未保留的問題。道路配對失敗時，另用同向且持續接近的點做畫面／語音備援，標示「道路未確認／直線距離」。這條備援不傳給 C4。

保留平面／高架文字與語音；未知層級不猜測，使用一般提醒。高德一般版新增廣播接收、來源過濾、KEY_TYPE 解析入口及可送出資料的診斷。**一般版實機是否成功送達 C4 仍待確認，並未以放行來源不明廣播假裝修好。**

[本版修改與48項離線檢查](variants/wide41/README.md)。已完成編譯、原簽章及對齊檢查；尚無本版 Android 實機、音訊及 C4 接收驗證。

## 可以做什麼

| 功能 | 說明 |
| --- | --- |
| 導航切換 | 高德車機／一般版、Google 地圖投屏，以及 CP Google SDK 配套導航資料來源 |
| 台灣測速儀表 | 即時時速、可用速限、測速距離、定位與資料狀態；靠近時放大距離顯示 |
| 測速語音 | 符合提醒條件、進入 1 公里門檻時按道路層級播報；未分類播報「前方測速照相」；配對較晚時也可能較晚提醒 |
| 全畫面紅光 | 接近測速 500 公尺內，App 四邊閃紅光，距離越近閃爍越快 |
| 速限暫存 | 最後有效標誌保留最多 60 秒並標示暫存；這不延長 C4 控制資料有效期 |
| 神盾投屏 | 右側可切換神盾畫面；顯示模式與傳給 C4 的資料來源分開設定 |
| C4 接管外框 | 6 dp、內角圓弧；僅橫向為水藍，橫向＋縱向為綠色，橫向未接管時隱藏 |
| 自動版面 | 橫向左右分割、直向上下分割，可調整比例；更多設定的關閉鈕固定在底部中央 |
| 高德預調速 | 固定使用目前選定高德的有效策略，切台灣來源也保留；與台灣有效道路速限取較低值送出 |
| 投屏教學 | App 內提供 Shizuku／Stellar 授權說明與管理工具入口，另有 Amap2Tesla 僅投神盾選項 |

高德、Google 地圖、神盾及投屏管理工具需自行安裝。神盾投屏不代表讀取神盾內部測速資料；官方 Google 地圖模式提供投屏；「CP Google 導航」配套才提供 SDK 導航資料。

## 第一次使用

1. 下載上方 APK，停車時安裝或覆蓋更新。
2. 授予精確定位；依需求啟動 Shizuku 或 Stellar，完成 Copilot 投屏授權。
3. 在導航「更多」選擇已安裝的高德車機／一般版、Google 地圖或 CP Google 導航；CP Google 先依完整教學設定個人 Key。
4. 在右側選擇「台灣測速」或「神盾投屏」。台灣畫面先確認 GPS 和道路配對狀態。
5. 如要連 C4，填入實際 C4 位址並確認車況；需要台灣控制資料時，再啟用台灣來源。顯示面板切換不等於控制來源切換。
6. 查看「更多」診斷，分別確認定位、測速配對、傳送紀錄與 C4 接收情況。

完整流程與排錯請看 [使用說明](docs/INSTALL_zh-TW.md)。

## 提醒覆蓋與驗證狀態

內建 1,856 筆固定點不等於 1,856 點都能提醒。目前 487 點具提醒道路配對、1,369 點未進入提醒配對。487 點展開 539 組方向合成回放，其中 457 點的已配對方向通過，其餘存在短路徑、漏觸發或反向異常待查。以上為 wide.37 的歷史合成回放；wide.41 另有同向接近備援，因此未配對點不再一律排除，但方向不明及條件不符仍不提醒，不能宣稱 1,856 點全部可用。經常出沒／機動測速並沒有完整全台點位庫。

wide.39 已通過 26 項離線速度合併測試、底欄結構與 APK 簽章檢查；**尚未完成此版 Android 實機與 C4 實車驗證**。先前 wide.30 的模擬器通過結果不能代替此版驗證。封包傳送或接收成功也不等於已執行減速。

[全量點位驗證](variants/wide37/audit/README.md) · [wide.39 技術與驗證紀錄](variants/wide39/README.md)

## 開發與其他平台

- [開發／重建說明](docs/BUILD_zh-TW.md)：本專案是原 APK 的修改材料存檔，不是完整原作者 Gradle 專案。
- [歷史版本](https://github.com/FANHAOHSIANG/copilot-Tw/releases)：供比對與回退參考；Android 可能拒絕直接降版，請先保存設定。
- iOS 是獨立試作，不與 Android 功能等同。本頁的 APK 不能在 iPhone 安裝；[既有 iOS 0.1 原始碼](variants/wide19/ios/)僅列為歷史存檔，不代表最新 iOS 投屏版。

## 授權與資料來源

原 CP 搭子／Navipilot APK 權利屬原作者；本儲存庫沒有替整個 App 重新授權。HCOP、OpenStreetMap 與政府開放資料的來源／授權保留於 [資料說明](docs/DATA_SOURCES_zh-TW.md)及各原始目錄。公開檔案不包含私人簽署金鑰或個人行車紀錄。

## 科技執法資料層

新增[全台官方科技執法資料核對與覆蓋](docs/ENFORCEMENT_zh-TW.md)，含離線 GeoJSON、來源追蹤與 Android 查詢模組。wide.46 已以分層判定接入畫面與語音；[核心規則與合成覆蓋](variants/enforcement-alert/README.md) 和 [整合驗證](variants/wide46/README.md) 分別保存。

</details>
