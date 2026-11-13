# wide.47：高德一般版 Link 診斷取樣

針對一般版高德導航已有當前轉彎、但完整路線與再下一轉彎未到達 C4 的問題，新增可隨原有「開始紀錄」開關啟用的資料取樣。本版**未新增完整路線或再下一轉彎解析**；這兩項目前仍不可宣稱接通。

## 安裝及取得下一份紀錄

1. 在原 CoPilot tw 上覆蓋安裝 `Copilot-tw-9.3.1-wide.47-amap-diagnostics.apk`，不需要解除安裝或改用 Google。
2. 按原有「開始紀錄」。先將導航來源切到別的來源，再切回「高德一般版」。這樣會把原有連線時的結構查詢也記下；本版沒有額外輪詢或更改授權流程。
3. 使用一般版高德設定目的地並開始導航。記錄約 3–5 分鐘，包含開始導航、轉彎或原本會讓引導消失的情境。操作與匯出請在停車時進行。
4. 使用原有「匯出紀錄」，保留 `diagnostics.txt` 及一同匯出的所有 `events*.jsonl`。不需要另外開啟 CP Google 導航。

原有記錄器維持三個約 4 MiB 的輪替檔案。資料含導航座標及道路名稱，僅作本機選擇性取樣；分享前可自行查看，不要將個人實測紀錄提交公開儲存庫。

## 新增的證據

| 事件 | 可以回答的問題 |
| --- | --- |
| `amap_link_packet` | 高德授權的導航回呼實際包含哪些事件、欄位與數值；在控制解析器捨棄未知項目前取樣 |
| `amap_link_query` | 原有指令 5／7 的查詢回覆是否帶有結構化導航資料 |
| `amap_link_state`、`amap_link_reset` | 是否發生斷線、重新綁定或訂閱狀態改變 |
| `amap_link_decision` | 引導是因為 3 秒逾時、未知圖示、距離不完整、圖示變更、停止或到達而撤銷 |
| `amap_link_output` | 現有 Navi v2 傳送器是否接受這筆引導；`c4_receipt=false`，並不冒充 C4 收件證據 |

匯出的摘要增加來源、連線狀態、各事件類型數量及尚未解析項目。取樣是有界、經敏感欄位遮蔽的結構副本，`raw_bytes_preserved=false`；不是逐位元原封包。保留數值、布林、物件／陣列與已知道路欄位，未知純文字只記長度。含 token、金鑰、帳號等欄位會遮蔽；巢狀 JSON 與 URI 編碼 JSON 會遞迴處理。截斷或無法解析會明確標記。若供應端使用未知文字編碼的路線，需要再確認格式，不能從本版的字串長度回復座標。

## 保持的行為與界線

- 沿用原有合法 Binder 連線、UID 檢查、授權、訂閱、查詢 7／5、FD／分塊接收及連線世代隔離。
- 原有 `WideAmapLinkCodec`、`WideAmapLinkPolicy`、`WideAmapLinkNavigation` 原始碼直接重用；當前轉彎的對應、時效與撤銷策略維持原樣。
- `route`、`guidance_next` 等未確認資料不送入控制。台灣道路限速與測速資料仍屬獨立來源，不能當作高德已提供的證據。
- 所有取樣均須原有紀錄開關啟用；沒有新增 Android 權限、服務、外傳端點或常駐錄製。

## 研究依據

高德官方 [AMapLinkClient API](https://developer.amap.com/api/aiot-sdk/guide/strong-ties/amaplinkclient-api) 描述指令 5 的 `navi_structured_info` 與指令 7。既有 CoPilot 已送出這兩個查詢，但未保留回覆。官方 [iOS Link 文件](https://developer.amap.com/api/aiot-sdk/guide/strong-ties/amap-ipc-link-kit) 所列路線類型不能直接當作目前 Android 手機回呼的 JSON 契約。本版因此先保存實際結構，不猜測路線座標或再下一步欄位。

下一步要將取樣中的高德事件、解析判定、Navi v2 接受紀錄與 C4 遙測按時間對照，區分「手機沒有提供」「目前解析器沒有對應」「傳送／接收失敗」。現有缺少 route／next 的紀錄不能單獨證明是 C4 網路斷線。

## 驗證結果

- 主機回歸：432 項 assertions 通過。包含原有 383 項，加上 49 項資料遮蔽、上限、未知圖示、紀錄開關、失效原因與傳送器接受證據檢查。
- 已產出簽章 APK，與 wide.46 相同簽章，版本碼 26110759；16 KiB 對齊通過。
- 獨立 APK 比對：3,878 個既有 classes 未變，所有 5,996 個既有 assets／libraries／resources 位元組一致。Manifest 僅版本更新；紀錄匯出僅新增一個可還原驗證的呼叫，另修正記錄器版本文字。
- APK SHA-256：`0fb5dd06e6f5e4a6798149114e95e9d1aa1b9fd9e8838c2b8b624d07c2d70f8a`。
- 詳細證據見 [verification](verification)。尚未進行本版 Android 實機導航／C4 收件驗收；主機測試以明確的邊界替身代替 Binder、Android 排程及 WebSocket。

## 重建

需要 Java runtime、ECJ、apktool、ASM、baksmali 與依賴、Android API 35 與 build-tools 36。工具目錄沿用 wide.46 格式。`build.py` 固定驗證原 wide.46 APK SHA-256；簽章材料僅從環境取得，不納入儲存庫。

```sh
python3 variants/wide47/tests/run_checks.py --jdk "$COPILOT_TEST_JDK" --json-jar "$COPILOT_TEST_JSON_JAR" --report /tmp/wide47-host.json
python3 variants/wide47/build.py --base-apk /path/to/wide46.apk --output-dir /path/to/new-build --toolchain /path/to/tools --build-tools /path/to/build-tools
python3 variants/wide47/verify_apk.py --base-apk /path/to/wide46.apk --apk /path/to/wide47.apk --toolchain /path/to/tools --build-tools /path/to/build-tools --output-dir /path/to/new-verification --report /tmp/wide47-apk.json
```

簽章環境變數：`COPILOT_SIGNING_KEY`、`COPILOT_KEY_ALIAS`、`COPILOT_STORE_PASSWORD`，以及需要時的 `COPILOT_KEY_PASSWORD`。沒有簽章材料時只能使用 `--unsigned`；不能拿不同簽章的 APK 當作可覆蓋安裝版本。
