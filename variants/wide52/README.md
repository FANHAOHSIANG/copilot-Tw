# wide.52 Google 整合／神盾投屏測試版

本版將 CP Google Navigation 0.1.2 的程式、Google Navigation SDK、資源、原生函式庫與元件併入 CoPilot wide.51。只有一個 CoPilot APK 與桌面入口；不是在 CoPilot 裡放另一個 APK 安裝包。

## 使用

覆蓋安裝 CoPilot，保留原簽章與套件 `com.jixiexiaoge.drivingassist.wide`。導航來源仍可選高德車機版、一般版、官方 Google Maps 投屏或內建 CP Google 導航。右側只保留神盾投屏，神盾官方 App 仍需另外安裝與原有投屏授權。

舊 CP Google App 的私有金鑰設定不會自動複製。請在內建導航重新填入自己的金鑰，Google Cloud Android 應用程式限制增加：

- 套件：`com.jixiexiaoge.drivingassist.wide`
- SHA-1：`AD:32:96:3B:94:DF:5E:30:DB:1B:24:EC:D6:2B:B9:11:F8:8D:48:7E`

保留原 Google Navigation SDK／Places 所需 API 與帳務設定。本版沒有內嵌任何使用者金鑰。可先保留舊 CP Google App，但新版使用獨立本機埠 5003，避免舊 App 占用 5002。舊導航來源偏好會遷移至內建來源。

## 已撤除的功能

台灣測速的選擇鈕、切換選單、設定入口、GPS 自動啟動、定位服務註冊、離線台灣資料、測速閃光與原有 Taiwan speed override 均撤除或停用。保留相容類別以免既有 APK 呼叫失效，但不能啟用該來源。高德原本的導航資料傳送仍保留。

神盾投屏不等於將神盾測速資料傳給 C4。本版沒有新增神盾資料擷取，也沒有承諾 C4 會依神盾警告減速。

## 實作

Google 的 8,472 個 resource ID 保持不變；CoPilot 218 個資源改名並映射至不衝突 ID。15 個原 CoPilot 未混淆 AndroidX 類別搬到 legacy namespace，保留原本連結的 ABI。兩份初始化 provider 使用不同 authority。Google 活動使用獨立 task affinity，投屏啟動明確指定內建 Google Activity，避免把 CoPilot 主畫面再投回自身。

Google 退出流程的 `killProcess` 呼叫移除，避免合併後終止整個 CoPilot。導航取消與釋放沿用 0.1.2。這不代表過去所有閃退均已確認根因。

## 驗證與限制

47 項靜態結構檢查通過，APK 編譯、原簽章與 16 KiB ZIP 對齊驗證通過。檢查項目詳見 verification/audit.json；這不是 47 次實車測試。

**尚未在 Android 車機安裝啟動、Google 真實金鑰、雙區投屏、背景導航或 C4 接收端驗收。僅為整合測試候選，不是實機驗收完成版。**

停車時先驗證：原設定保留；內建 Google 可啟動並設定路線；神盾能同時投屏；結束導航不關閉 CoPilot；再次導航可恢復；C4 診斷收到有效路線及轉彎且退出後清除。通過前不要把收到導航資訊解讀為已驗證車輛轉向行為。

## 重建

`build.py --base-apk <signed-wide51.apk> --google-apk <signed-google012.apk> --toolchain <tools> --base-api <ApiSignatures-output.jar> --output-dir <new-dir>`

工具與簽署環境沿用 wide.51；base-api 使用 wide.46/tooling/ApiSignatures.java 從固定基底 DEX 擷取。簽署變數為 COPILOT_SIGNING_KEY、COPILOT_KEY_ALIAS、COPILOT_STORE_PASSWORD、COPILOT_KEY_PASSWORD。原始輸入 APK 的 SHA-256 在腳本中固定，不包含金鑰或密碼。
