# 高德 Link 路線格式與驗證邊界

本次只使用高德已選定的路線，不新增 Mapbox、Google 或其他路線規劃請求。

## 格式來源

- 高德官網下載入口：https://mobile.amap.com/
- 官網版本資訊：https://mapdownload.autonavi.com/apps/apps/amap-official/amap-official/mobile_and.json
- 分析版本：17.03.0.2008，官方 Android C3060，Build2611091537。
- APK SHA-256：`287202d017d27c6bbacb84c658da9a6cc265655c4cf9e44d878127b50836d15b`。
- 官方簽章憑證 SHA-256：`b36c0b80cb2417e7fe4c3df01a2d163a7d8443604dd276a2bc1ab0d325102e3e`。
- 官方事件文件：https://lbs.amap.com/api/aiot-sdk/faq-old
- 官方 Link API：https://lbs.amap.com/api/aiot-sdk/guide/strong-ties/amaplinkclient-api

以官方 APK 的發送端序列化程式核對互通欄位。沒有修改高德 APK、繞過其授權或重新散布高德程式碼。
**使用者實機是 Play 17.02.2.2014；目前尚未取得該版本的完整 type 2 原始封包，因此不能把本次靜態核對稱作該版本的實機驗收。**

## 已核對映射

| 高德來源 | C4 欄位／處理 |
| --- | --- |
| type 2 `highlightRoute` | 目前選定 route ID；不可直接取第一條備選路線 |
| type 2 `info[route ID]` | 該路線物件 |
| `segmentInfo[].linkInfo[].lat[] / lon[]` | 有序經緯度點，轉為 `route.polyline[].lat/lon` |
| `segmentInfo[].length / iconType` | 路段距離與路口動作 |
| `routeLength` | `route.total_distance_m` |
| type 4 `pathID / curSegIdx / curManeuverID` | 核對目前路線、路段索引與動作 |
| type 4 `segmentRemainDist / nextRouteName` | 當前轉彎距離與道路名稱 |
| type 4 `routeRemainDist / routeRemainTime` | 剩餘距離／秒數 |
| type 20 `routeId` | 切換高德選定路線；等待新引導後才送出 |
| type 19、100、200 | 重設、導航停止、抵達時撤銷路線 |
| type 1 | 計算成功，不代表採用；不以它替換路線 |

供追溯的 libamaphorus.so 虛擬位址：

- `0x6baa54` 建立完整路線資料；`0x6bae48` 指定 Link type 2。
- `0xd27200` 寫出 `highlightRoute`、`info`，`0xd2724c` 以 route ID 為物件鍵。
- `0xd27070` 路線欄位；`0xd26f40` 路段欄位；`0xd26eac` 道路連結經緯度陣列。
- `0x6be9a0` 將內部角度單位除以 3,600,000；wire 已是角度，不應再次除數。
- `0x6bb000` 建立 type 20，`0xc9c100` 寫出 `routeId`。
- IPC2OpenSDKModule 將原生 SyncToGlassInfo 事件交給 wearable biz 113，再由既有 Link Binder 接收。

## 路線品質與生命週期

- 僅在同一 Link session、同一路線的新鮮 type 4 引導存在時發送路線；3 秒無新鮮引導即撤銷。
- 型別錯誤、缺選定路線、座標陣列長度不同、無效座標、路段總長不符時撤銷，不沿用上一條路線。
- 保留每個路段終點，以最多 2 公尺平面誤差簡化幾何；最多 4,096 點、原始最多 50,000 點。無法在界限內保留路線就不發送，絕不直接截掉尾端。
- 不使用 Mapbox 重新算路，不把備選路線或其他導航來源混入。
- 不自行假設或套用 GCJ-02/WGS-84 位移。wire 角度原樣保留；仍須以使用者手機的台灣路線和 C4 定位實測確認位置一致。
- 再下一轉彎用「下一路段長度」。C4 的 `_update_tbt` 會自行加上當前轉彎剩餘距離；不能預先相加。
- 路段索引與當前 icon 不一致、下一動作未映射時，`guidance_next` 不送出。

## 尚未確認項目

未確認可用的道路限速 Link wire 欄位；`speed`、`cameraSpeedLimit` 不能代替道路限速。這版不發送道路限速或測速相機資料。原生引擎內有道路限速欄位，不等於目前 Link 訂閱一定會提供。

離線測試使用依已核對格式建立的合成資料。尚未執行 Android ART/Binder 實機、使用者 Play 版封包回放、C4 實機接收或車輛控制驗收。
