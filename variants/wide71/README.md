# Carrot Bridge wide.71 號誌測試版

| 高德來源 | C4 資料流 | 行為 |
| --- | --- | --- |
| 手機版 Link | `json:traffic_signal` | type 12 提供秒數。導航與道路配對皆有效、第一路口在 300 公尺內且為可顯示相位時，送出 `ui_counter.remain_sec`。type 13、離路、停導、來源切換或逾時清除。 |
| 車機版號誌 | `json:traffic_signal` | 沿用既有 60073 解析。 |
| 車機版測速 | `json:speed` 的 `sdi` | 沿用既有高德廣播的相機類型、距離與執法速限。 |
| 手機版測速 | Link 診斷 | 現有紀錄尚未收到可用的相機欄位。區間測速 type 28 待實機樣本。 |

手機號誌接到 C4 畫面時鐘旁的「號誌 N 秒」。配套 C4 更新以
[`test/carrot-wip-upstream-20261104`](https://github.com/FANHAOHSIANG/openpilot-carrot/tree/test/carrot-wip-upstream-20261104)
為基底。手機燈色代碼待對照，畫面先顯示中性秒數。號誌只進入顯示路徑。
道路速限、縱向控制及外接 HUD 沿用既有路徑。

Carrot Bridge 選「高德一般版」或「高德車機版」後，沿用原本連線開始導航。
要核對實機，開啟 Carrot Bridge 診斷記錄並匯出。手機輸入記在 `amap_link_packet`，
車機包含測速欄位的廣播記在 `amap_auto_alert_input`。號誌與速度的 App 送出結果
分別記在 `traffic_signal_wire`、`speed_wire`。佇列接受提供 App 端證據，收件以 C4 為準。

## 編譯與驗證

以原版已簽署的 [wide.70 APK](https://github.com/FANHAOHSIANG/copilot-Tw/releases/download/wide.70/Carrot-Bridge-wide.70.apk) 為基底。

```sh
python3 variants/wide71/build.py WIDE70_APK TOOLS APKTOOL_JAR Carrot-Bridge-wide.71-unsigned.apk
```

使用原簽章及 [既有簽署工具](../wide55/sign.py) 產生可覆蓋更新的 APK。
以 JVM 搭配 `org.json` 執行 `tests/LinkSignalTest.java`。其輸出可交給
`tests/receiver_alerts.py <C4 checkout> <fixture.json>` 驗證 C4 WebSocket 接收。
可另傳入以 `received_mono_ms` 排序、每行含 `received_mono_ms` 與 `datas` 的 Link 記錄進行回放。
測速的 C4 驗證使用合成 Auto 封包。Android 裝置、高德實時廣播及 C4 實機仍待對照。
