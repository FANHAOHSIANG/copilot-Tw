# wide.46：科技執法提醒、Google 導航與可重建交付

版本 `9.3.1-wide.46-enforcement-google`，versionCode `26110758`。由已交付的 wide.45 延續，加入科技執法畫面／語音、修正 Google 下一步距離，並保留既有導航來源選擇及原 C4 Navi v2 傳送路徑。

## 完成內容

- 科技執法引擎接上既有有效 GPS、道路視窗及道路判定；內建 gzip 官方公告清冊。
- 不需目的地即可使用。具道路、行向與條件證明才顯示確定前方；同路但取締方向未知時保留標示，語音明說「取締方向待確認」。只在附近、條件不明、純參考記錄不主動播報。
- 右側儀表上方顯示車速、接管狀態及可用速限；下方顯示目前主要提醒，並在測速或 Google 轉彎佔主卡時保留科技執法次提示。
- 新增「更多 → 科技執法提醒與診斷」：開關、離線中文 TTS 試聽與安裝入口、診斷文字、GPS 測試紀錄 ZIP。
- 提醒固定 3 秒定位有效期，停止／清除不能被延遲結果重新發布。相同定位時刻的負面道路結果優先於 raw callback；語音綁定資料世代、公告、分類與適用記錄，舊句不能在方向／條件改變後沿用。
- Google mapper 改傳下一步與當前步的間距，讓已核對的 C4 receiver 只加上當前距離一次。180 m＋260 m＝440 m，修正歷史雙重累加成 620 m。
- 配套 [CP Google 導航 0.1.1](../google-navdash/README.md) 縮小 Places 欄位、防抖與 session token、修正錯誤提示及停止／換路線的非同步回呼。

科技執法新功能只輸出畫面與聲音，不產生道路速限、目標車速或自動減速欄位。道路或公告無法證明的狀態會保留在分層顯示，而不是猜成本車可用控制資料。

## 資料覆蓋

清冊為 2026-11-12 快照：2,148 筆公告，1,152 筆具座標，996 筆待定位。在提供已確認道路的 3,686 組合成接近情境中，56 筆形成確定方向語音提議，229 筆形成方向待確認公告提議；合計 285 筆、去重後 282 組。不能把這個結果當作實際 GPS 配對率、設備仍有效的查核或全台提醒覆蓋率。

完整規則、門檻、縣市結果與限制見 [科技執法引擎](../enforcement-alert/README.md) 及其逐筆 audit。既有台灣測速點另有自己的資料與提醒規則。

## 驗證結果

| 驗證 | 結果 |
| --- | --- |
| 科技執法核心 | 67 項通過 |
| Runtime／Voice 生命週期 | 46 項通過；使用真實 production 類別與 Android 邊界 stub |
| 儀表繪圖 | 316 項斷言、13 個記錄布局，0 字形重疊或越界發現 |
| Google mapper | 38 項通過 |
| 固定 SHA 的實際 C4 receiver 合約 | 21 項通過 |
| Google companion | 8 個 JUnit、8 個金鑰生命週期斷言；另有遠端正常建置結果 |
| 最終 APK | 同簽章、16 KiB 對齊；3,839 個原類別不變 |
| 精確 hooks | 5 處，移除新增呼叫後原方法完整還原 |
| 內部參照 | 61 類、347 方法的 733 method／1,719 field／177 type references，無未解析 |
| 原 assets／lib／res | 5,995 個檔案逐位元相同，resources.arsc 相同 |
| 新資源 | 僅 tw_enforcement.json.gz；解壓後與 repo 清冊一致 |

證據：[build.json](verification/build.json)、[apk-scope.json](verification/apk-scope.json)、[UI 檢查](verification/ui-review.md)、[生命週期](tests/lifecycle/checks.json)、[Google 接收契約](../google-bridge46/verification/receiver-contract.json)。

UI 圖為相同 production 繪圖程式的示意資料預覽，不是裝置截圖。低於完整卡片尺寸的舊 fallback 只驗介面銜接；其舊繪圖實作未在這批預覽內重新驗證。

**尚未實際連接使用者 Android、Google 個人 Key／帳單或 C4。** 安裝、TTS 可聽性、SDK 真實授權、背景行為及 C4 收件按 [裝置驗收](../../docs/DEVICE_ACCEPTANCE_zh-TW.md) 操作並記錄。

## 安裝與使用

完整搭配需 Android 12 或以上。主程式與 CP Google 配套安裝同機；同簽章既有受控發行版可覆蓋更新。Google 金鑰的申請、Billing、兩個 API、Android package＋SHA-1、使用與排錯見 [完整 Google SDK 教學](../../docs/GOOGLE_SDK_zh-TW.md)。

科技執法使用主面板「定位」啟動，再到「更多 → 科技執法提醒與診斷」試聽與觀察。語音需要已安裝的離線中文 TTS；日誌含行程軌跡，不應整份公開。

## 可攜的主機檢查

安裝 JDK 21、Python 3.12 及 Noto Sans CJK TC 後，執行 `python3 .github/scripts/run_host_checks.py --output-dir /path/to/new/results`。入口會從官方 Maven 下載並核對固定 org.json，依序跑 67＋46＋316＋38 共 467 項檢查；不需要私人基底 APK、Google Key 或 Android 裝置。實際 receiver 的 21 項 pinned-source 合約回放另見 Google bridge 說明。

## 從來源建置

這是原 APK 的可編譯 overlay，並非原作者完整 Gradle 專案。base 必須是 SHA-256 固定的受控 wide.45，不能將其他 APK 改名代入。

先安裝 `bsdiff4==1.4.2`，使用 release 還原工具從公開 wide.42 還原簽署 wide.45：

```sh
python release/wide46/restore.py --manifest release/wide45/manifest.json --output-dir /tmp/copilot-base
```

準備 JDK 21、apktool、ECJ、ASM、dexlib2／baksmali、Android API 35 JAR 及 Android Build Tools 36.0.0。工具配置延續 [wide.45 建置說明](../amap-link1/README.md)，編譯用的 DEX API jar 只做簽名索引，不打包進 App。

```sh
python variants/wide46/build.py \
  --base-apk /tmp/copilot-base/Copilot-tw-9.3.1-wide.45-amap-link.apk \
  --output-dir /tmp/copilot-wide46-build \
  --toolchain /path/to/copilot-build \
  --build-tools /path/to/android-sdk/build-tools/36.0.0 \
  --unsigned
```

建置目錄必須尚不存在。受控簽署時省略 `--unsigned`，並由環境提供 `COPILOT_SIGNING_KEY`、`COPILOT_KEY_ALIAS`、`COPILOT_STORE_PASSWORD`、可選 `COPILOT_KEY_PASSWORD`；不將私鑰或密碼提交 Git。簽章不同的自建版本不能直接覆蓋既有版本。

建置結束後應獨立核對成品，不能只採信 build report：

```sh
python variants/wide46/verify_apk.py \
  --base-apk /tmp/copilot-base/Copilot-tw-9.3.1-wide.45-amap-link.apk \
  --apk /path/to/final-signed-wide46.apk \
  --toolchain /path/to/copilot-build \
  --output-dir /tmp/copilot-wide46-independent-check
```

最終 APK SHA-256：`6b388d7a6a39a3dd0e026dd47c452e231433d7030c0fe87ecfe5dd014364b696`。

歷史 wide.44 原始來源及當時行為已恢復到 [variants/wide44](../wide44/README.md)，其重編驗證與 wide.46 修正分別保存。發布來源 ZIP 以該次 release commit 打包，不包含私人簽署材料、API Key、cache 或個人定位紀錄。
