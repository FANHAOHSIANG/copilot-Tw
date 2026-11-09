# Navipilot 9.3.1-wide.14-tw-bridge

這版是台灣固定測速 → Carrot 的實際串接測試版，不是 wide.13 的純預覽。保留左側高德車機版、右上台灣面板、右下控制鈕與拖曳比例調整。

## 安裝與測試

1. 在車機上覆蓋安裝 `Navipilot-9.3.1-wide.14-tw-bridge.apk`，不必先移除 wide.13。package 與簽章維持原客製版，versionCode 26110726。
2. 連上原本 C4，保留高德車機版原有連線。車況 7000 連得上，不等於導航 Navi v2 通道也已建立。
3. 右上「GPS」啟動定位，允許精確位置。這版用車機 GPS，不借用 C4 定位。
4. 「設定」→「開始測試紀錄」→「啟用台灣測速串接（測試）」。初始與 App 行程重啟後都使用高德；切換為台灣後，測速來源不會自動回退高德。
5. 先以人工駕駛核對道路、速限與提醒距離。面板標示「同路段 · 沿道路距離」才代表通過串接判定；「候選（未串接）」只是畫面提醒。
6. 測試後「設定」→「停止並匯出測試紀錄 ZIP」。用分享畫面存到檔案或傳到手機，再把 ZIP 附在這個對話。補充發生時間、路名及方向即可。紀錄含 GPS 軌跡，請勿公開分享。

收到 ZIP 後可核對：GPS 精度與新鮮度 → 道路配對 → 實際傳送內容 → C4 接收端同序號回報 → 車況中的 carrotMan 結果。

## 本版實際串接範圍

- 固定測速顯示資料共 1,856 筆。226 筆通過保守 OSM 配對初篩；不等於每次經過都會啟用。`eligible-cameras.csv` 列出可配對點及幾何上可用的提前距離。
- 只使用 **同一段 OSM 路口間道路**，不跨路口、不猜測岔路路線。226 筆的幾何提前距離中位數約 176 m，僅 106 筆大於 200 m、32 筆大於 500 m；實際有效距離還會因定位與歧義再縮短，不能當作完整的提前減速方案。
- 方向與速限不明、測速點附近道路重疊、橋梁／隧道／非零層級、路口附近等，均不啟用。
- 行車定位需 GPS 精度 ≤15 m、有效行進方向、至少 3 次連續定位且跨度 ≥1.5 秒；GPS 超過 5 秒、跳點、方向錯誤、平行／重疊道路歧義等即撤銷候選。
- 傳送距離是道路折線投影的沿路距離，最大 1,500 m；不是測速點到車輛的直線距離。已通過或距離 ≤20 m 不再提供該點。
- 新北 24 個方向的區間測速保留畫面估算，**不送進 Carrot 控制**。其他未配對固定點同樣只顯示。
- OSM 與官方點位是資料快照；通過演算法條件不等於已實車確認道路、設備位置或速限。

## 通道與來源分工

實查這個 APK 後確認：原有 UDP 7706 主要是定位與按鍵命令；導航使用原本的 **Navi v2 WebSocket（預設 7714）**。本版不另開第二條導航傳送通道，也不將測速包硬塞進舊 UDP。

只在原有 `MG.b` 的 `speed` 流，進行資料複製與欄位替換：

- `sdi.type = 1`
- `sdi.speed_limit_kph = 台灣固定點速限`
- `sdi.distance_m = 同路段沿道路距離`
- 清除原有 `sdi_secondary` 與 `section`，避免測速來源競爭。
- 同一份原有 speed 資料的來源時間在 2 秒內才保留其 `road_limit_kph`、`current_kph` 等欄位；不因新 GPS 把高德過期欄位重新標成新鮮。
- 高德 `guidance_current`、`guidance_next`、`route`、`vehicle` 等流不改動。測速點速限不冒充整條道路速限。
- 沒有有效台灣候選時撤銷測速欄位；仍有新鮮高德速度欄位就保留，全部過期則撤銷 speed 流。沒有即時來源更新時仍受原通道排程與 C4 過期機制影響，不能保證網路中斷時立即清空車端。
- 切回高德，會恢復原本 speed 流；按「示範」也會切回高德，示範數字不傳送。

## 「已傳送」與「已接收」不同

- 「已排入傳送」：原 WebSocket 的 enqueue 回傳成功，並非網路送達保證。
- 「C4 已接收」：對原導航目標的 `/health` 做唯讀查詢，確認 session、sequence、速限、距離、目標主機與連接埠均與最近 5 秒內本機排入的台灣資料一致。每 2 秒最多查一次，連線逾時 700 ms／讀取逾時 1,000 ms，獨立背景執行，不阻塞導航。
- 現有 7000 精簡車況未帶 speed 封包序號，因此不能只靠「車況握手已完成」判定測速接收成功。
- 接收端收到不代表已發布 cereal、不代表規劃器採用、更不代表車輛已執行減速。紀錄中另含可取得的 `carrotNavi` 與 `carrotMan` 車況及接收端 `cereal_error` 供比對。
- 未相容 Navi v2、未啟動導航流或接收查詢失敗，都會維持未確認；本版沒有修改 C4、未增加實車權限、未修復既有 `state_send_timeout`。

## 測試紀錄

使用者手動開始，背景非同步寫入，最多 3 × 約 4 MB，超過就輪替；寫入佇列最多 200 筆。重新開始會清掉上次本機紀錄。匯出時停止紀錄，ZIP 含 `diagnostics.txt` 與 `events*.jsonl`。

事件包括：來源切換、GPS、配對結果／拒收原因、speed 實際封包、WebSocket 排入結果、C4 接收證據與車況。只在使用者點分享後開啟系統分享，不自動上傳。App 原有 FileProvider 的 `cache/share_images` 用來提供匯出檔。

## 已完成驗證與尚未驗證

- 24 項道路／合併測試、17 項串接狀態與接收比對測試。
- 保留原 26 項 GPS 候選測試、21 項區間／示範測試。
- 使用使用者 GitHub `FANHAOHSIANG/openpilot-carrot` 的 `carrot-wip` 接收端程式，離線通過 Navi v2 協商、封包接收、正規化、解析、速度欄位套用、撤銷、轉彎保留及偏航拒收。
- APK 簽章、16 KB zipalign、實際 DEX 方法引用、打包後 smali 往返檢查；原 UDP sender、按鍵命令、導航接收、拖曳與投屏流程不變。只修改 MG.b 合併、XG.f 排入觀察、Ae.f 車況觀察三個原方法。
- 畫面使用共用繪圖程式離線檢查；**沒有 Android 實機、車機與實車測試結果**。目前 C4 實際安裝 commit 亦未取得，仍須以你的回報確認相容性。

## 回復

先在設定切回高德即可停止台灣測速替換。若需完整回復，覆蓋安裝附件 `Navipilot-9.3.1-wide.13-camera-restore-build26.apk`，它是原 wide.13 功能，只提高版本碼以便覆蓋安裝，無須先解除安裝。

## 圖資與授權

- 固定點：警政署測速執法設置點，政府資料開放授權條款第 1 版。https://data.gov.tw/dataset/7320 、https://data.gov.tw/license
- 區間：新北市政府警察局區間平均速率執法設備設置地點，同上政府授權。https://data.ntpc.gov.tw/datasets/27b97ad9-9dba-4ca9-b0ed-14b29000ffec
- 道路：© OpenStreetMap contributors，ODbL 1.0。https://www.openstreetmap.org/copyright 、https://opendatacommons.org/licenses/odbl/1-0/
- OSM 輸入：Geofabrik Taiwan 2026-11-08，https://download.geofabrik.de/asia/taiwan-261108.osm.pbf 。已比對供應者 MD5；本包含衍生資料 `bridge-build/data/corridors.json`、生成程式、來源資訊及配對名單，衍生 OSM 道路資料依 ODbL 提供。
- 不使用 Mapbox，無須金鑰，也沒有新增線上圖資 API 呼叫。C4 接收確認是區域網路唯讀請求。

## 重建

這是原 APK 的可重建補丁，不是原作者完整 Android 專案。需要 Java、Python 3、ripgrep、apktool 3.0.3、ECJ 3.39、Android API 35、build-tools 36.0.0；工具不含在本包。補丁完整 Java、smali 注入腳本、對照檢查與資料均附上。

- `bash bridge-src/rebuild.sh`（會編譯 helper、以附帶 wide.13 APK 為基礎打包、簽章及檢查）
- `bash bridge-src/build_restore.sh`（產生回復版；已存在 restore 目錄時需先另存或移除）
- `bridge-src/test_receiver.py` 使用附帶的接收端來源快照；JVM 測試用 `org.json:json:20240303`，不要把測試替身或編譯 stubs 放進 APK。
- 若重建圖資：安裝 osmium、shapely、networkx 至 `bridge-build/python`，下載上列固定日期 PBF；執行 `extract_roads.py`、`prepare_corridors.py`。本包無須下載 PBF 即可使用已生成的道路資料。
- 測試簽章備份只供本人保管，不宜公開上傳。檔案 SHA256 與版本檢查見附帶 verification 與 checksums。
