# wide.45：高德手機版 Link → 既有 Carrot Navi v2

這個修改模組讓「高德一般版」使用本機 Link 服務取得已授權的導航事件，並接入 CoPilot 原有的 Navi v2 傳送流程。高德車機版繼續使用原廣播；來源切換會撤銷上一個來源的導航。

版本：**9.3.1-wide.45-amap-link（26110757）**，Android 12 以上。

已完成 Java／DEX／APK 編譯、原簽章比對、16 KiB 對齊及離線測試。**尚未在使用者的高德 17.02.2.2014／170105 完成真實 Binder 授權、導航回呼或 C4 收件測試。** 上游在另一個手機高德版本成功的紀錄，不能替代這次裝置驗收。

## 使用方式

1. 安裝已簽署的 wide.45 APK。同簽章可覆蓋既有版本，無須先刪除設定。
2. 在 CoPilot「更多」的導航來源選 **高德一般版**，開啟已安裝的手機高德，開始駕車導航。
3. 查看原有來源診斷中的「高德一般版 Link」。它會分別顯示授權、訂閱、收到的資料及目前可用的轉向／距離。
4. C4 維持原有連線設定。只有原 Navi v2 sender 接受了該筆資料，診斷才會標記「已接受這筆引導」；這仍不是 C4 的收件確認。
5. 若顯示授權或訂閱遭拒，本次連線會停止自動重試。可在確認高德已開啟後，切到其他導航來源再切回一般版重試。介面不相容或服務拒絕的原因不會被隱藏成「已連線」。

這條資料讀取路徑不要求高德開發者 Key、付費 SDK、Root 或 LSPosed。原有投屏的 Shizuku／Stellar 授權依然由原投屏功能處理。高德可隨版本或政策改變是否允許本 App 連接，故不能保證所有手機版本均可無 Key 使用。

## 實際提供的資料

| 項目 | 本版行為 |
| --- | --- |
| 目前轉向 | 對已核對的左轉、右轉、急轉、迴轉、直行提示明確轉碼 |
| 下一個動作距離 | 使用 `segmentRemainDist`，不拿到終點的距離替代 |
| 道路名稱／提示 | 使用這筆 type 4 的 `nextRouteName`；缺少時不沿用舊道路 |
| 停止／抵達 | 立即清除引導，回報 idle |
| 箭頭已換、距離未到 | 清除舊距離與道路，等待完整的新指示 |
| 逾時 | 完整指示超過 3 秒即失效；重送、重畫與其他回呼不會續期 |
| 完整路線、下一轉向、道路限速、相機、車道、紅綠燈 | 尚無已確認的欄位解碼，本版不從 Link 生成這些資料 |

未確認的略左／略右、岔路與圓環細節會撤銷控制指引，不把圖示數字原樣當作 Carrot 代碼。原高德畫面的導航顯示仍由高德負責。

台灣測速來源仍依既有有效性規則獨立合併。選一般版時，不會因缺少手機限速而恢復先前車機版的限速或測速事件。

## 整合方式

- `WideAmapLink`：真實 App 身分綁定、正常 authenticate／register、回呼 UID 檢查、有限重試、斷線與 FD 關閉。
- `WideAmapLinkCodec`：明文／AES-GCM 框架、分段與大小／深度限制；分段保留最早接收時刻。
- `WideAmapLinkNavigation`：已確認的導航欄位、明確轉碼及 monotonic 3 秒有效期。
- `WideAmapLinkIntegration`：來源與服務生命週期、世代隔離、原 MG sender 與分層診斷。
- `patch_decoded.py`：只插入指定掛點；保留原 Auto、Google、台灣合併、Navi v2 協商與訂閱。

不新增另一個 C4 UDP sender，不修改高德 APK、不偽造其套件名稱／簽章，也不修改服務授權規則。協定來源、事件與映射表見 [PROTOCOL.md](PROTOCOL.md)。

## 驗證紀錄

執行方式與測試邊界見 [tests/README.md](tests/README.md)。結果見 [verification/host-checks.json](verification/host-checks.json)。測試以合成封包及可控制時鐘驗證實際 production codec、policy、mapper、integration；Android scheduler、Binder 與傳送邊界在 host harness 中替換，不能視作裝置測試。

本次共 **383 個離線斷言通過**。最終 APK 另經獨立 DEX 比較：3,807 個既有 class 不變，只修改五個掛點 class 與版本文字；新增 38 個 class 全為 `WideAmapLink*`。5,995 個 assets／lib／res 檔案逐檔一致，新增／變更 class 沒有無法解析的內部方法、欄位或型別參照。

本次交付 APK 使用已簽署的 **wide.44-google-bridge** 作為基底，保留其 Google 配套導航、右側版面及 wide.43 離線道路改進。基底 SHA-256 與成品資訊記錄在 [verification/build-verification.json](verification/build-verification.json)；最終 DEX 修改範圍見 [verification/apk-scope.json](verification/apk-scope.json)。

此目錄也允許對雜湊相符的 wide.42／wide.43 套用同一模組。**使用哪個 APK 當基底，就保留該基底的其他功能**；本模組不會憑空把 wide.44 的 Google 功能加到 wide.42。

## 重建

這是原 APK 的修改材料，並非原作者完整 Gradle 工程。工具需求：Python 3.9+、Java 17+、Apktool 3.0.3、ECJ 3.39、Android API 35、Android build-tools 36.0.0、baksmali／dexlib2 2.5.2 及其相依 JAR、ASM。測試另需 `org.json` JAR；各版本工具應由其原始發布來源取得。

工具目錄預期包含：`apktool.jar`、`ecj.jar`、`asm.jar`、`baksmali/*.jar`、`platform/android-35/android.jar`。Android build-tools 目錄需有 `zipalign`、`lib/d8.jar` 與 `lib/apksigner.jar`。

```bash
python3 variants/amap-link1/tests/run_checks.py \
  --jdk /absolute/path/to/jdk \
  --json-jar /absolute/path/to/json.jar

python3 variants/amap-link1/build.py \
  --base-apk /absolute/path/to/known-base.apk \
  --output-dir /absolute/path/to/new-output-directory \
  --toolchain /absolute/path/to/toolchain \
  --build-tools /absolute/path/to/android-build-tools \
  --unsigned

python3 variants/amap-link1/verify_apk.py \
  --base-apk /absolute/path/to/known-base.apk \
  --apk /absolute/path/to/built.apk \
  --toolchain /absolute/path/to/toolchain \
  --output-dir /absolute/path/to/new-verification-directory
```

`--unsigned` 的輸出不可作為已簽署安裝檔；移除此參數並在本機設定 `COPILOT_SIGNING_KEY`、`COPILOT_KEY_ALIAS`、`COPILOT_STORE_PASSWORD`、`COPILOT_KEY_PASSWORD` 才會簽署。程式會驗證成品與基底簽章相符，金鑰與密碼不寫入儲存庫或建置報告。

建置只接受 [verification/bases.json](verification/bases.json) 中的已知基底，且輸出目錄必須尚不存在。它從實際基底 DEX 擷取編譯期介面、重編所有 production Java，再套入窄範圍掛點；不把舊版 `WideVariant`／`WideDirect` 整檔蓋回較新基底。來源若在建置途中改變，驗證會失敗，避免成品與公開原始碼不一致。

## 已知邊界

尚待裝置確認：手機版服務是否開放、Android 真實 Binder／FD 行為、駕車導航回呼頻率、後台恢復及 C4 實際接收。原有投屏、音訊、Google 金鑰與測速道路演算法並未因本次離線檢查而獲得新的實機驗證。

APK SHA-256：

```text
38e9a898b1543eea4d09a8d3188667f8e49a712482dc278f838d35913074c598
```
