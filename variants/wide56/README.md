# wide.56 — 高德所選路線直接交付 C4

**狀態：候選程式碼及未簽署建置已完成，尚未交付可覆蓋安裝的 APK，也未做實機驗收。**

以 wide.54 為基底，包含 wide.55 的 Link 傳送修正，新增高德 Link 完整路線與再下一轉彎對應。沿用高德已選定路線，不另外呼叫 Mapbox 規劃；原投屏、UI、診斷匯出、原始 Link 擷取保留。

- type 2 按 `highlightRoute` 選擇 `info` 中的完整路線。
- type 4 核對 route ID、路段索引及當前轉彎，提供下一段動作／距離。
- 路線切換、重設、停止、抵達、無效或過期引導撤銷舊資料。
- 手機高德來源不再經舊台灣測速／預調速合併；不以其他來源填補缺失值。
- 道路限速目前顯示未確認；測速相機不在這次必要範圍。
- [C4 配套修正 PR #40](https://github.com/FANHAOHSIANG/openpilot-carrot/pull/40) 把接收端 256 點截斷改為最多 4,096 點完整保留；超限或無效座標整條撤銷。

格式證據和實機版本差異見 [SCHEMA.md](SCHEMA.md)。測試結果在 `verification/`，不可視為車輛 NOO 或控制安全驗收。

## 重現

```sh
python variants/wide56/build.py \
  --base-apk /path/Carrot-Bridge-9.3.1-wide.54.apk \
  --tools /path/android-tools \
  --output /path/Carrot-Bridge-wide.56-UNSIGNED.apk

python variants/wide56/tests/run_checks.py \
  --ecj /path/ecj.jar --json-jar /path/json.jar \
  --c4-source-dir /path/c4-test-source \
  --report-dir /path/reports
```

工具版本／目錄沿用 `../wide55/build.py`。測試另需 aiohttp；C4 測試來源為配套分支中的 `carrot_navi.py`、`carrot_navi_cereal.py`、`carrot_navi_control.py`、`carrot_serv.py` 及 navigation 的 `source.py`，完整雜湊已記錄。

## 交付阻礙

wide.54 原簽署私鑰不在目前可取得檔案中。原憑證 SHA-256 為 `eb0f6a44174aecf09cedc237be2ca0305ea491d47b381407d31e903acbd34b46`。需要同一金鑰才能在保留資料和現有授權下覆蓋安裝；未建立替代金鑰，也未將未簽署產物標為正式 release。

取得原金鑰後可使用 `../wide55/sign.py` 驗證憑證再簽署；接著必須用使用者 Play 17.02.2.2014 的實際導航封包和 C4 接收紀錄核對路線、路口距離、偏航換路與停止撤銷。
