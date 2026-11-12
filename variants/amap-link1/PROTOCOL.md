# 手機高德 Link 接入：資料來源與設計依據

## 目標與來源

將同一台 Android 上的高德一般版 `com.autonavi.minimap` 已提供給本 App 的導航事件，轉為既有 CoPilot Navi v2 串流。不使用高德付費 SDK、內嵌開發者 Key、Root、LSPosed 或修改高德 APK。原有投屏功能的 Shizuku／Stellar 需求與這條資料讀取路徑分開。

互通資訊參考以下固定版本，並以新的 Java 實作接入既有 APK：

- [HyperCar：導航接入紀錄](https://github.com/fw867/hypercar/blob/e7d6e3acb1a60e0af28edabe80d522ebe0825ede/docs/NAVIGATION.md)，及同版本 `AmapLinkProbe.kt`、`LinkEnvelope.kt`、`LinkPayload.kt`、`AmapLinkNavigation.kt`。這些來源說明了實際服務名稱、Binder 介面、封包框架與已觀察欄位。上游程式為 GPL-3.0；本目錄沒有引入其 Kotlin 檔或複製其實作。本次使用互通格式資訊，自行編寫 Java 讀取、排程、邊界檢查及 CoPilot 整合。
- [高德 LinkClient 文件](https://developer.amap.com/api/aiot-sdk/guide/strong-ties/amaplinkclient-api)與 [AIoT FAQ](https://developer.amap.com/api/aiot-sdk/faq-old)：作為 Link 資料訂閱與事件類型的對照。官方文件的授權要求不等於所有手機版本都允許無 Key 的相容用戶端。
- [Carrot 官方 Navi v2 協定](https://github.com/ajouatom/openpilot/blob/ffa5723eda259de6c3ef3962f687c5c8579c23ee/openpilot/selfdrive/carrot/carrot_navi_api.md)與 [`carrot_serv.py`](https://github.com/ajouatom/openpilot/blob/ffa5723eda259de6c3ef3962f687c5c8579c23ee/openpilot/selfdrive/carrot/carrot_serv.py)：使用目前轉向處理路徑實際辨識的代碼，而非只看顯示用對照表。
- CoPilot tw 原有 `MG`、`XG`、`WideAmapSource`、`WideAmapPreAdjust`：保留既有 Navi v2 協商、訂閱、各串流序號、時間戳、傳送頻率及台灣測速合併邏輯。

HyperCar 的作者在高德 17.02.0.2010 回報一般 App 身分的 bind/authenticate/register 成功；這是該環境的上游紀錄，並非本專案已在使用者的 17.02.2.2014 完成實測，也不是高德對所有版本的免費承諾。授權拒絕即停止這次連線，不更改套件身分、簽章或服務授權政策。

## 已觀察的本機介面

| 項目 | 值 |
| --- | --- |
| 套件 | `com.autonavi.minimap` |
| 服務 action | `com.autonavi.minimap.service.NAVIGATION_SERVICE` |
| 明確服務 component | `com.amap.bundle.wearable.connect.glass.AmapLinkService` |
| 控制 descriptor | `com.amap.linksdk.aidldefine.ILinkSdkControl` |
| 回呼 descriptor | `com.amap.linksdk.aidldefine.ILinkSdkCallback` |
| authenticate / execute / register / unregister | Binder transaction 1 / 2 / 3 / 4 |
| 文字回呼 | callback transaction 1，字串 |
| FD 回呼 | callback transaction 2，**metadata 字串在前**，接 presence flag 及 `ParcelFileDescriptor` |
| 導航業務封包 | `bizType: 113`，`datas` 為陣列或包裹陣列的 JSON 字串 |

使用實際安裝套件的 UID 檢查每個 Binder 回呼。只有當正常 authenticate 回覆 `status: success` 且 register 成功，資料才進入導航狀態。服務提供的短期 token 只留在記憶體，僅供同次已授權連線的唯讀查詢；不記錄於診斷或封包檔。

資料本體可以是明文 JSON，或帶有每個訊息自己的金鑰與 nonce 的 AES-GCM 框架。這個每訊息金鑰是已交付封包的一部分，與高德開發者 API Key／授權憑證不同；它不會用來取得尚未獲准交付的資料。驗證標籤錯誤、長度超界或不完整分段均拒絕。

文字、分段及 FD 都設大小限制。大封包可接收，不代表其內部的完整路線、座標系統或測速資料已獲證實；本版只解讀下表列出的導航欄位。

## 導航事件與可用欄位

| Link 事件 | 本版處理 |
| --- | --- |
| type 4 | 讀取 `curManeuverID`、`segmentRemainDist`、`nextRouteName`；前兩者必須是有效整數 |
| type 5 | 讀取 `maneuverID`；轉向改變時，先撤銷上一個轉向的距離與道路，等下一筆完整 type 4 |
| type 100 | 導航停止，立即撤銷目前指引 |
| type 200 | 抵達，立即撤銷目前指引，導航狀態回 idle |
| type 7 與其他類型 | 不推測欄位意義，不續期轉彎資料；同批 type 7 也不覆蓋有效 type 4 |

`segmentRemainDist` 是目前下一個動作的路段剩餘距離。目的地剩餘距離 `routeRemainDist` 不得拿來替代。缺少新道路時不沿用上一個道路。分數、非有限數、字串型數值及無法對應的轉向不當成已確認控制資料。

| AMap ManeuverIconID | Carrot `turn_type` | 意義 |
| --- | --- | --- |
| 2 / 3 | 12 / 13 | 左轉／右轉 |
| 6 / 7 | 16 / 19 | 向左後方／向右後方轉彎 |
| 8 / 19 | 14 | 迴轉 |
| 9 / 20 | 51 | 直行提示；Carrot 不把它當作左右轉控制事件 |
| 其他 | 無 guidance 值 | 例如未核對的岔路、略左／略右、圓環出口，保留為未知 |

輸出的 `guidance_current` 包含有效的 `distance_m`、`turn_type`、道路與文字。`navigation_status` 表達 guiding／idle，但不捏造 `off_route` 或路線幾何。未證實的下一個路口、限速、測速點、紅綠燈、車道及座標不從手機 Link 產生。既有台灣資料來源仍由原合併程式獨立處理。

## 來源與時效

每次選擇來源與每次 Link binding 都有獨立世代。來源切換、重新綁定、服務斷線及授權失敗會先清除前一世代資料；遲到的回呼不會重新把它補回來。手機 Link 成為手機選項的唯一導航輸入，不把來源不明的 Auto 廣播混進手機狀態。

有效完整 type 4 的有效期為 **3,000 ms**，以 `elapsedRealtime` 計算。重畫畫面、重送封包、相同箭頭的 type 5 或其他事件都不延長它。Navi v2 仍保留該筆資料實際接收時刻對應的牆鐘時間戳。這是保守的輸入有效期設定，尚非實車驗證出的控制參數。

「資料已交給既有 Navi v2」只描述本 App 的傳送流程，不能當作 C4 已接收或車輛已採取動作的確認。

## 授權範圍

此修改材料不替原 CP 搭子／Navipilot APK 重新授權，也不宣稱擁有高德、Carrot 或 HyperCar 的原始碼。重建需要使用者合法取得的既有 CoPilot APK 與相應簽署金鑰；本目錄不含私人簽章或個人路線紀錄。
