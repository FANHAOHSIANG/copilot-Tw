# wide.55 — 高德一般版導引交付候選修正

**狀態：程式與離線接收測試完成，尚未實機驗收；沒有可覆蓋安裝的已簽署 APK。**

本版以實際 wide.54 APK 為底修補導航傳送鏈路，目標是讓高德一般版已解析的轉彎、距離及道路名稱，透過既有 Navi v2 交給 C4 的導引處理程式。這不是「全部導航資料已完成」或「實車已會轉彎」的發布。

## 已核對的證據

- 手機診斷已有 Link 授權、訂閱及有效引導，例如右轉 120 縣道、1544 公尺，但該筆尚未被 Navi v2 傳送端接受。
- 使用者提供的 15 段行車紀錄中，2191 筆 carrotNavi 都沒有有效 guidanceCurrent，navigationStatus 為 idle；18000 筆 carrotMan 的 xTurnInfo 都是 -1，導引文字及路線為空。
- 車況連線成功與地圖投屏成功，均不能證明導引送達。手機報告缺少可與行車紀錄精確對時的時間，所以這些證據不能單獨確定哪個傳送分支是實際根因。
- 對照接收端固定為 `FANHAOHSIANG/openpilot-carrot` 的 `98331d2321fa063174a82cb7d17d2c5c8a35a004`；測試使用檔案的雜湊列於 [c4-source.json](verification/c4-source.json)。

## 本次修改

1. Navi v2 握手完成、傳送記錄重置後，立即把 Link 綁定到該導航傳送端；若已有有效快照，嘗試交付。
2. 以擁有 Link 讀取器的選定來源決定手機高德輸出，避免舊的 Google／車機來源分流遮蔽 Link 快照。保留原來源的生命週期登記及其他來源行為。
3. 診斷新增交付嘗試、有效引導排入佇列、撤銷排入佇列、最近交付結果。區分未訂閱、資料流未啟用、內容未變、等待傳送間隔與佇列拒收；排入佇列不標成 C4 回覆。

保留 wide.54 的 Link 取樣、既有 UI 與投屏。未知轉向、停止導航和過期撤銷沿用既有規則，不放行猜測資料；路線折線、再下一轉彎、測速相機、道路限速仍未加入。本版不修改 C4 的車輛控制程式。

## 驗證結果與範圍

| 檢查 | 結果 | 實際範圍 |
| --- | --- | --- |
| 既有 Link 回歸 | 383 項通過 | 儲存庫內 codec、policy、navigation、integration 原始碼及明確測試替身，非 Android 實機 |
| 新增傳送 helper | 14 項通過 | 來源切換、撤銷、時間戳及排隊診斷；使用測試替身 |
| C4 轉換／導引消費端 | 6 情境通過 | 合成 Link 資料進入固定提交的 C4 方法；右轉 1544m、左轉 80m、迴轉 60m 正確對應 |
| C4 WebSocket 本機接收 | 6 情境與重複序號拒收通過 | 真正 C4 接收程式在 localhost 握手、接收、撤銷，再送轉換與導引方法；發送端是 Python 測試客戶端 |
| APK 成員引用 | 無未解析引用 | 4 個相關類別；不能代替 Android ART 載入與執行 |
| 修改範圍 | 5 個類別 | MG、TB、WideAmapLinkIntegration、版本字串 Yg，以及新增 WideLinkDelivery |
| APK 資源與二級 dex | 原始位元組保留 | ZIP 內容只改 AndroidManifest.xml 與 classes.dex，移除失效舊簽章；16 KiB 對齊通過 |
| 實際手機 → C4 | **尚未驗證** | 還不能宣稱使用者手機的傳送問題已排除 |

直行保留 C4 原本的處理：轉向代碼為 0，不使用 turn countdown；未知圖示及停止導航不產生有效轉向。所有合成資料都明確沒有路線與速限。驗證報告在 [verification](verification/)。

## 建置

這是原 APK 的修改材料，不是完整原作者 Gradle 專案。底包必須是 SHA-256：

```text
7254813300d14223c835bf32fe469ea6713fa8d2b42f82fc4bdb926f4b5c9bd4
```

建置工具與版本列在 `build.py` 開頭。測試替身只提供編譯簽名，D8 只收 `WideLinkDelivery.class`，不會把替身打包。

```sh
python variants/wide55/build.py \
  --base-apk /path/to/Carrot-Bridge-9.3.1-wide.54.apk \
  --tools /path/to/android-tools \
  --output /path/to/Carrot-Bridge-wide.55-UNSIGNED.apk
```

腳本檢查底包雜湊、修改類別範圍、主 dex 039 格式、原資源及二級 dex 完整性，並輸出建置報告。主 dex 明確使用 API 31 組譯，保留原 App 的 Android 12 支援範圍；manifest 的 target SDK 不變。

```sh
python variants/amap-link1/tests/run_checks.py \
  --jdk /path/to/jdk --json-jar /path/to/json.jar --report /tmp/link-regression.json
python variants/wide55/tests/run_checks.py \
  --ecj /path/to/ecj.jar --json-jar /path/to/json.jar \
  --c4-source-dir /path/to/pinned-carrot-files --report-dir /tmp/wide55-checks
```

第二組測試需 Python aiohttp；接收端檔案應從上述固定提交的 `openpilot/selfdrive/carrot/` 取得。測試會檢查四個檔案雜湊。

## 簽章與實機驗收尚缺

已驗證底包簽章憑證；本次工作環境沒有對應私鑰。不能從 APK 還原私鑰，也不能換一把新金鑰就覆蓋現有 App。需要原 `.jks`／`.keystore`（或在持有原金鑰的電腦執行下方腳本）。金鑰及密碼不能放入 GitHub。

設定 `WIDE55_KEYSTORE_PASS` 與 `WIDE55_KEY_PASS` 後，在持有金鑰的電腦執行：

```sh
python variants/wide55/sign.py \
  --unsigned /path/to/Carrot-Bridge-wide.55-UNSIGNED.apk \
  --apksigner /path/to/apksigner.jar --keystore /private/path/original.jks \
  --alias navipilot-wide-test --output /path/to/Carrot-Bridge-wide.55.apk
```

此腳本只接受與 wide.54 一致的憑證；不符時不產生最終安裝檔。取得已簽署候選版後，實機驗收要確認：

1. 手機 Link 可用引導與「有效引導排入佇列」持續更新；若拒收，保留新增的原因文字。
2. 同時段 C4 的 `guidanceCurrent.meta.present=true`、序號遞增、`navigationStatus.guidanceActive=true`。
3. `carrotMan.xTurnInfo`、`xDistToTurn` 及導引文字與該路口一致。
4. 停止導航、斷線、切 Google／車機版後，舊高德手機版引導會撤銷。

先以停車／不接管狀態確認資料鏈路；資料接收成功本身不等於實車轉向或減速驗收完成。尚未發布正式版，也未在使用者 C4 部署變更。
