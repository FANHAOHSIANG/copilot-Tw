# 高德一般版道路速限與 HUD

以 wide.60 為基礎，先套用 `../wide60/route-refresh.patch`，再套用
`amap-road-limit.patch`。此修改沿用 wide.60 的 `navigation_status` 傳送及診斷掛點。
每個版本先由使用者確認改動與驗證結果，再打包 APK。

- 高德 Android 17.03.0.2008 的 `libamaphorus.so` 以 `0x6bb128` 建立
  Link type 27。它與畫面事件 452（`0x82f37c`）共用
  `NaviSpeedLimitSectionInfoData`（`0x6be2e4`），序列化欄位為
  `maxSpeed` 與 `minSpeed`（`0xd275d4`）。type 28 是獨立的區間測速相機資料。
- type 27 只使用正整數 `maxSpeed`。導航狀態須新鮮，且同一路線、路段與道路連結
  身分可辨識。零、無效值、換路、停止、抵達、來源重設與過期都清除速限。
  同一路段可保留最後有效限速最多 10 秒，導航引導仍使用原本 3 秒期限。
- Bridge 透過 `navigation_status.road_limit_display_kph` 傳給 C4 HUD。
  已知模擬導航的速限只留在原始封包紀錄。此欄位不產生 `speed` 控制資料。
  HUD 顯示優先使用車輛本身的有效速限，否則使用有效的高德速限。
- C4 需要配套更新，相關程式位於 `c4-source` 的本機修改，基底
  `cd4e739fe6086f06f9325ae423db27a86642c41c`。配套更新亦讓既有 Navi v2
  路徑在沒有有效速限時停止把預設值刊登為 `navInstructionCarrot.speedLimit`。
- 使用者的 Play 版 17.02.2.2014 兩份診斷裡，994 個 Link 封包僅有一筆
  type 27，數值為 0。正值和變更順序使用離線資料驗證，仍需在實機確認台灣道路的覆蓋率與更新頻率。
