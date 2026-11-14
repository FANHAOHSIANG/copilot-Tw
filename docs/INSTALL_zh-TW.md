# Carrot Bridge 安裝與使用

適用於 **wide.69（9.3.1-wide.69-ui，版本碼 26110781）**，支援 Android 12 以上手機或車機。

[回首頁與下載清單](../README.md#下載) · [直接下載主程式 APK](https://github.com/FANHAOHSIANG/copilot-Tw/releases/download/wide.69/Carrot-Bridge-9.3.1-wide.69-ui.apk) · [GitHub 發布說明](https://github.com/FANHAOHSIANG/copilot-Tw/releases/tag/wide.69)

wide.69 沿用 wide.68 的簽章憑證。[wide.69 更新與操作](../variants/wide69/README.md) · [wide.68 舊版操作](https://github.com/FANHAOHSIANG/copilot-Tw/blob/0d094f4e86f323b8de23ac0c060e39b2d1c87ea9/docs/INSTALL_zh-TW.md)

## 1. 安裝或更新

1. 停妥車輛後下載 APK。在 Android 的下載清單點開檔案，依系統提示允許瀏覽器或檔案管理工具安裝。
2. 已使用同簽章的舊版時，直接覆蓋安裝以保留資料。若 Android 顯示簽章不相容，先確認已安裝版本的來源並備份資料。
3. 按需要安裝高德、Google 地圖或神盾。GitHub Assets 裡的 `Source code` ZIP 和 TAR 是原始碼下載，安裝 Android 請選 `.apk`。
4. 要顯示 OSM 速限或用內建 Google 導航時，在 App 首次詢問時授予精確定位。定位取自安裝 Carrot Bridge 的手機或車機。

## 2. 啟動投屏與授權

1. 選裝 [Stellar APK](https://github.com/roro2239/Stellar/releases/download/v1.1%28101000%29/stellar-v1.1-release.apk) 或 [Shizuku APK](https://github.com/RikkaApps/Shizuku/releases/download/v13.6.0/shizuku-v13.6.0.r1086.2650830c-release.apk)。
2. 在裝置的「開發人員選項」開啟「無線偵錯」。在投屏工具內開始配對，依系統提示輸入配對碼，再回工具按「啟動」。使用 Stellar 時須開啟 Shizuku 相容層。
3. 確認工具顯示服務已啟動。回 Carrot Bridge，按右下角「左側 ⋯ → 啟動投屏／授權」，允許 Carrot Bridge 存取。
4. 「左側 ⋯ → 投屏安裝與授權」可換管理工具並查看服務、授權和連線狀態。裝置重啟後若服務停止，到同一個工具再啟動。

車機若沒有無線偵錯，可在支援 USB 偵錯時依工具提示用電腦 ADB 啟動服務。[投屏工具詳細步驟](../third_party/projection/README.md)

## 3. 導航與投屏操作

| 要用的功能 | 在哪裡操作 |
| --- | --- |
| 高德車機版 | 「左側 ⋯ → 高德車機版」。在高德內設目的地，切換來源後先查看導航資料狀態。 |
| 高德一般版 | 「左側 ⋯ → 高德一般版」。鍵盤位置可在左側選單切到導航區或車機主畫面。Link 授權、訂閱及引導狀態可在診斷查看。 |
| Google 地圖（僅投屏） | 「左側 ⋯ → Google 地圖（僅投屏）」。Google 地圖路線與速限由官方 App 顯示。 |
| Google 導航 NOO | 「左側 ⋯ → Google 導航串接與金鑰」，完成 [金鑰設定](GOOGLE_SDK_zh-TW.md) 後，選「Google 導航 NOO」並開始導航。結束後回到搜尋頁。 |
| 神盾或其他右側 App | 「右側 ⋯ → 選擇投屏 App／空白畫面」，選已安裝的 App。可選留白或時鐘。 |
| 即時診斷／操作面板 | 按右下面板的「切換」。按「⌄」可收起，再按右下角「⋯ → 展開面板」叫回。 |
| 個別返回或重啟 | 打開對應的左側或右側選單，使用「返回投屏 App」或「重新開啟」。面板收起或視窗較窄時，右下角「⋯」有左右兩側選項及各自的重啟指令。 |

拖曳分隔線即可調整視窗比例。放開後畫面會重新適配，等比填滿時邊緣可能短暫裁切。橫向與直向的比例各自保存。

## 4. OSM、神盾與 C4 診斷

從右下角的投屏選單開啟設定，可調整下列三項。

| 設定 | 行為 |
| --- | --- |
| 顯示 OSM 速限牌 | 控制地圖上的速限牌。長按可移動，缺少有效路段資料時顯示「—」。 |
| 傳送道路速限至 C4（TDX／OSM） | 開啟後，優先送符合道路與方向的 TDX 速限，其次送符合配對條件的 OSM 速限。資料衝突、過期或無法確認時撤銷。 |
| 神盾紅光提醒、取樣與尺寸保護 | 開啟後保留辨識所需的最小視窗，並將影格取樣寫入診斷。辨識到 500 公尺內的固定式或移動式測速點後，App 四邊閃紅光。神盾事件目前用於 App 提醒與診斷。 |

Android 和 C4 須互通。在 App 的連線設定填實際 C4 位址，確認即時車況資料持續更新。「Navi v2」可用來查看 App 的引導處理狀態。要確認 C4 有收到導航資料，仍須核對車端紀錄。

在右下「即時診斷」按「報告」，可分享當下診斷。要記錄問題發生前後的事件，在報告選單按「開始記錄」，重現後用「匯出報告與事件 ZIP」。公開前請檢查位置、路線及連線位址。

## Amap2Tesla 瀏覽器投屏

Carrot Bridge 內建「Amap2Tesla 僅投神盾」。準備神盾和投屏授權後，可用內建的瀏覽器投屏模式單獨打開神盾畫面。

1. 按「左側 ⋯ → Amap2Tesla 僅投神盾」。投屏已啟動時，先停止瀏覽器投屏再切換設定。
2. 啟動 Amap2Tesla 瀏覽器投屏。讓車機或平板與 Android 手機連到可互通的無線網路或手機熱點。
3. 在接收端瀏覽器輸入 App 顯示的完整投屏網址與埠號。
4. 想恢復 Carrot Bridge 的右側本機投屏時，先關掉瀏覽器投屏，再關閉「Amap2Tesla 僅投神盾」。

這是 Carrot Bridge 內建模式。獨立版特投屏也能在 Android 端用自訂投屏選擇神盾。你的車機瀏覽器和神盾虛擬螢幕相容性要以實機畫面確認。瀏覽器顯示和 C4 路況資料各用自己的流程。[特投屏下載與說明](https://github.com/jixiexiaoge/Map2Tesla)

## 5. 常見問題

| 現象 | 先檢查 |
| --- | --- |
| 顯示等待投屏或黑畫面 | 目標 App 已安裝、投屏工具服務已啟動、Carrot Bridge 已獲授權。從「投屏安裝與授權」查看三項狀態。 |
| 重新開機後投屏失效 | 在原本的管理工具重新啟動服務，再回 Carrot Bridge。 |
| Google NOO 搜尋或導航失敗 | Google Play 服務、網路、精確定位、Google Cloud 計費、兩項 API 和金鑰 Android 限制。 |
| OSM 速限牌顯示「—」 | 確認定位有效、目前道路可配對、OSM 路段有速限資料。 |
| 視窗調整後仍不合框 | 記下 App 版本、手機或車機型號、Android 版本與目前投屏來源，附問題畫面及診斷報告。 |
| APK 無法安裝 | 檢查 Android 版本、檔案是否完整，以及既有 App 的套件簽章。 |

主 APK 的 SHA-256 列在 [wide.69 發布說明](https://github.com/FANHAOHSIANG/copilot-Tw/releases/tag/wide.69)。macOS 可用 `shasum -a 256 檔名.apk`，Linux 可用 `sha256sum 檔名.apk`，Windows PowerShell 可用 `Get-FileHash 檔名.apk -Algorithm SHA256`。

[wide.40 舊版說明](https://github.com/FANHAOHSIANG/copilot-Tw/blob/0299f57241f1baeccabb1e8e12c96565d52fd1c2/docs/INSTALL_zh-TW.md)
