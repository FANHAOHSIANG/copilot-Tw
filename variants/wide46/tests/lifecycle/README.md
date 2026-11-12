# Runtime 與語音生命週期回歸測試

執行真正的 `WideEnforcementEngine`、`WideEnforcementRuntime`、`WideEnforcementVoice`。只有 Android 的時鐘、Handler、TTS、偏好設定與音訊焦點使用 host 邊界 stub；不複製 runtime 判斷邏輯。

覆蓋的具體回歸：

- 讓舊 worker 等在 publication 的同一把鎖，先執行 clear，再允許 worker 繼續；舊世代不得重新發布。
- 同一 GPS 時刻，已完成但沒有道路匹配的結果，不能被 raw callback 蓋掉，也不能被「已處理過 confirmed」擋掉。
- AHEAD 與 DIRECTION_UNKNOWN 都可在 raw→road 短空窗暫留原 frame，但保留原 fix 時間和 3 秒截止時間；新 raw 不續期。
- 相同地點 ID 的提醒由 AHEAD 降為 DIRECTION_UNKNOWN，或適用公告 ID 改變後，舊句不得開始；onStart 與 WATCH 也撤銷它。
- owner signature 包含世代、候選 ID、level 與排序後的適用 recordIds；單純清單順序變動不誤判成新語意。
- clear、停止 GPS、關閉語音、定位過期及原測速聲音優先都會撤銷播報並釋放音訊焦點。
- 安裝離線中文語音後，試聽可重新初始化；不把 host 接受 speak 呼叫當作裝置真的有聲音。

```sh
python variants/wide46/tests/lifecycle/run_checks.py \
  --java /path/to/jdk/bin/java \
  --javac /path/to/jdk/bin/javac \
  --json-jar /path/to/json.jar \
  --report /path/to/lifecycle-checks.json
```

這些檢查驗證程式的生命週期與語意邊界，不是 Android 服務排程、真實 TTS、車機喇叭或實車驗證。
