# wide46 Google → Navi v2 距離合約修正

此 overlay 只替換 `WideGoogleAdapter` 與其 `Snapshot` 類別。歷史 `variants/wide44` 原始碼及 smali 保持當時行為，建置 wide46 才套用此修正。

## 已確認問題

Google companion 傳回當前步驟剩餘距離 `step.dist` 及下一步與前一步的間距 `next[0].distFromPrev`。wide44 將兩者相加後放入 `guidance_next.distance_m`；下列固定 SHA 的 C4 receiver 又在 `_update_tbt()` 相加，造成重複加上當前距離。

| Receiver | 固定提交 |
| --- | --- |
| FANHAOHSIANG/openpilot-carrot `test/carrot-wip-upstream-20261104` | `98331d2321fa063174a82cb7d17d2c5c8a35a004` |
| ajouatom/openpilot `carrot-wip` | `ffa5723eda259de6c3ef3962f687c5c8579c23ee` |

完整路徑已核對：`carrot_navi.record_json`、`cereal_snapshot` 保留原 value；`carrot_navi_cereal._guidance` 直接把 `distance_m` 轉為 `distanceM`；`carrot_navi_control._guidance` 直接保留距離；`carrot_serv._apply_carrot_navi_guidance` 放入 `nTBTDistNext`；最後 `_update_tbt` 才算 `nTBTDistNext + nTBTDist`。前段沒有扣除 current。

本版只把正值 `distFromPrev` 放入 next。當前 180 m、間距 260 m，receiver 最終為 440 m；舊版經相同程式重播為 620 m。receiver 以 `nTBTDistNext > 0` 才重算下一步距離，零間距無法安全表達，因此本版撤銷該次 next；缺失／無效間距也撤銷 next，當前引導不受影響。

未知 `turn_type=-1` 保留。兩個 receiver 實際方法均轉成 `navType="invalid"`、`xTurnInfo=-1`，不使用上一個可操作轉向。既有停止、模擬、路線版本、程序 session、來源切換、定位精度、3 秒 TTL 與不臆造速限的規則不變。

## 可重跑驗證

- `tests/GoogleBridgeChecks.java`：38 項映射、過期、session、route、停止、模擬、未知方向及零間距檢查。
- 歷史 wide44 的 32 項原始檢查獨立通過，沒有修改歷史預期掩蓋差異。
- `tests/ContractFixture.java` 輸出實際編譯 mapper 的 JSON，沒有在 Python 重新實作 mapper。
- `tests/test_receiver_contract.py` 驗證 Git blob SHA 後載入完整 receiver、cereal、control 來源；原樣以 AST 擷取 carrot_serv 的兩個實際方法，執行 21 項合約斷言。沒有啟動 C4、socket server 或車輛控制回圈。

```sh
javac -cp /path/to/json.jar -d /tmp/google-bridge-tests \
  variants/google-bridge46/src/WideGoogleAdapter.java \
  variants/google-bridge46/tests/GoogleBridgeChecks.java \
  variants/google-bridge46/tests/ContractFixture.java
java -cp /tmp/google-bridge-tests:/path/to/json.jar \
  com.navipilot.obf.GoogleBridgeChecks
java -cp /tmp/google-bridge-tests:/path/to/json.jar \
  com.navipilot.obf.ContractFixture /tmp/google-bridge-fixture.json
```

合約重播另需以歷史 wide44 adapter 在另一輸出目錄編譯同一 fixture generator。按 `verification/receiver-sources.json` 固定 URL 取得五個 Python 檔，命名 `user_navi.py`、`user_cereal.py`、`user_control.py`、`user_serv.py`、`up_serv.py`。安裝 `aiohttp` 後：

```sh
python variants/google-bridge46/tests/test_receiver_contract.py \
  --receiver-dir /path/to/pinned-receiver-files \
  --fixture /tmp/google-bridge-fixture.json \
  --historical-fixture /tmp/google-wide44-fixture.json \
  --output /tmp/receiver-contract.json
```

來源 URL、Git blob SHA 與結果保存在 `verification/receiver-sources.json`、`verification/receiver-contract.json`。這是 host 程式路徑驗證，不代表使用者裝置正在跑相同 receiver SHA，也不代表已收到封包或完成道路測試。其他 receiver 若改變 next 定義，需要重新核對。
