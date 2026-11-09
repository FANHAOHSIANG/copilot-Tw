# wide.11：雙投屏＋車況斷線診斷

## 這次確認的問題

使用者回報握手已完成、最後有效車況 0.1 秒前，卻仍顯示
`closed 1011: state_send_timeout` 與重連 0 次。
前版診斷只計算資料停滯後的強制重連，漏算原 App 正常斷線重連流程；
它也保留上次錯誤而未標示歷史時間。這份舊紀錄不足以判斷是否反覆斷線。

此外 wide.10 的車況診斷標題仍寫 wide.8-auto 或 wide.9-probe；
不能用該標題判斷沒有升級。wide.11 改由 Android 套件資訊取得實際版本與版本代碼。

## 本版內容

- 保留 wide.10 已移除「建立新分區就關閉其他分區」的雙投屏修正。
- 顯示目前連線／握手／有效資料新鮮度，區分握手完成但尚未收到本次資料。
- 在原本有效連線的失敗回呼中記錄事件，包含相同原因連續發生、快速斷線重連。
- 分開統計斷線／連線失敗、車端回報 state_send_timeout、握手、有效資料恢復與強制重連。
- 保留最近 8 筆事件，標示距今秒數；上次錯誤明確標為歷史紀錄。
- 只在記憶體保存，複製由使用者操作；沒有新增網路傳送、權限或 C4 設定修改。

本版沒有調整車端傳送期限、訂閱頻率、App 原重連等待時間或導航控制。
**沒有宣稱修復 state_send_timeout 的真正成因。** 此訊息需搭配故障時的紀錄判斷。
本版的「有效資料新鮮」表示至少收到有效車況資料，並非所有服務或車輛控制均已驗證。

## 安裝與取樣

依目前地圖版本擇一覆蓋安裝，不用卸載：

| APK | 左側地圖 | 導航資料傳送 |
| --- | --- | --- |
| Navipilot-9.3.1-wide.11-probe-diagnostic.apk | 高德一般版 | 保留取樣模式；原導航 UDP 7706 通道及同通道快捷指令仍停用 |
| Navipilot-9.3.1-wide.11-auto-diagnostic.apk | 高德車機版 | 保留既有傳送流程 |

右上皆為神盾，神盾資訊仍未串接 Carrot。
兩版版本代碼均為 26110723，沿用原套件及測試簽章，互相覆蓋切換，不會同時安裝。

先停止投屏、安裝、重新開啟 CP搭子。停車開始投屏後進「版面 → 複製目前車況診斷」。
正常時複製一份；再次卡住時，於同一次 App 執行期間再複製一份，方便比較計數和時間。
另註明是高德／神盾畫面停住，還是車況數值停止更新。不要為了取樣先強制停止 App，
因為記憶體紀錄會清空。

診斷頁文字是開啟時的快照；「複製目前車況診斷」會重新產生當下的紀錄。
統計屬於本次連線監測，重新開啟 App 或切換連線監測會重置。
待確認真實車機資料後，再評估連線或車端修正。

## 驗證

`unit-tests.txt` 記錄純 Java 診斷狀態測試，涵蓋舊錯誤、快速重複斷線、
握手後仍是舊資料、恢復計數、資料過期及最多 8 筆紀錄。
`verification.json` 記錄 APK 修改範圍、類別參照、完整 smali 封裝比對和雜湊。
重建流程會驗證原簽章與 16 KB 對齊。
**沒有 Android 車機執行或網路故障重現測試。**

## 重建

需要 Java 17、Python 3.9+、Apktool 3.0.3 放 tools/apktool.jar、
ECJ 3.39 放 tools/ecj.jar、Android 35 android.jar 放 tools/platform/android-35/android.jar。
設定 ANDROID_BUILD_TOOLS 指向 Android Build Tools 36.0.0。

```bash
bash telemetry-src/build_helpers.sh
bash telemetry-src/rebuild.sh probe
# 車機版修改包可改成：bash telemetry-src/rebuild.sh auto
```

包含前版 APK、精確基準雜湊、補丁、Java 原始碼、編譯 stubs、
驗證腳本／結果及測試簽章 key。stubs 不可納入 APK。
測試 key alias navipilot-wide-test，密碼 android。
patched 目錄必須不存在；重建請使用新解壓目錄，避免覆蓋既有工作。
