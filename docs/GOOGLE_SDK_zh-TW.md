# Carrot Bridge 內建 Google 導航 NOO 設定

本章適用於 Carrot Bridge wide.68 至 wide.70。內建 Google 導航 NOO 使用 Google Navigation SDK 與地點搜尋，請先安裝 [Carrot Bridge](../README.md#下載)。裝置需有 Google Play 服務、網路與精確定位。

1. 在 Carrot Bridge 開啟「分區二 ⋯ → Google 導航串接與金鑰 → 開啟 Google 金鑰／導航」。也可以選擇「Google 導航 NOO」後，在內建畫面按「設定／更換 Google 金鑰」。舊版入口見 [wide.69 說明](../variants/wide69/README.md)。
2. 按「複製套件名稱與 SHA-1」。上述正式 APK 的套件皆為 `com.jixiexiaoge.drivingassist.wide`，簽章 SHA-1 皆為 `AD:32:96:3B:94:DF:5E:30:DB:1B:24:EC:D6:2B:B9:11:F8:8D:48:7E`。設定時以實際安裝版本複製出的資料為準。
3. 在 [Google Cloud Console](https://console.cloud.google.com/) 建立或選取專案、連結有效的計費帳戶，再啟用 [Navigation SDK for Android](https://console.cloud.google.com/apis/library/navigationsdk.googleapis.com) 與 [Places API (New)](https://console.cloud.google.com/apis/library/places.googleapis.com)。使用量可能產生費用，請依 [Google 官方設定說明](https://developers.google.com/maps/documentation/navigation/android-sdk/get-api-key) 與專案的 Billing 頁面確認。
4. 在「API 和服務 → 憑證」建立 API 金鑰。應用程式限制選「Android 應用程式」，貼上第 2 步的套件名稱和 SHA-1。API 限制只允許上一步啟用的兩項 API。
5. 把金鑰貼回 Carrot Bridge 並儲存。更換金鑰後依畫面提示完整關閉並重新開啟 Google 導航 NOO。選定目的地、規劃路線後開始導航。
6. 若要確認對 C4 的傳送，先在「即時診斷 → 報告」查看 SDK、搜尋與 Navi v2 狀態，再核對 C4 的接收紀錄。

「Google 地圖（僅投屏）」直接顯示官方 Google 地圖 App，可以走一般投屏授權流程。

[回安裝與使用](INSTALL_zh-TW.md#3-導航與投屏操作)

## 舊版 CP Google 獨立配套

以下為 CP Google 0.1.1 與 wide.46 的歷史操作手冊。使用新版內建導航時，請依上方步驟設定。

<details>
<summary>展開舊版 CP Google 導航設定教學</summary>

# CP Google 導航完整設定教學

## 從申請 Google Cloud，到輸入金鑰、開始導航及連接 CoPilot tw

**文件核對日期：2026-11-12。** 本教學適用於 Android 的「CP Google 導航」配套 App，套件名稱為 `com.copilottw.googlenav`，以 **0.1.1 配套及 CoPilot tw wide.46** 為主要對象。0.1.0 使用者也可依相同方式申請金鑰，但建議先更新，以取得搜尋用量、錯誤提示與導航資料銜接的修正。

完成後，你會擁有自己的 Google Cloud 專案及受限制的 API 金鑰，由 CP Google 導航規劃路線，再讓同一台 Android 裝置上的 CoPilot tw 讀取導航資料。Google Cloud 帳戶、付款資訊及 Google 條款都由你本人確認。本文件不會替你開通計費，也沒有內附共用金鑰。

**先記住：Google Navigation SDK 有每月免費用量，但仍須啟用計費；超出免費用量可以產生費用。搜尋目的地的 Places API 另行計算。** 現行制度是各 SKU 的每月免費用量，不應沿用舊文章的「每月一律送 US$200」說法。[S01][S02][S03]

---

## 1. 先看整個流程

| 階段 | 要完成的事情 | 完成後應看到什麼 |
| --- | --- | --- |
| 1 | 安裝 CP Google 導航，取得套件名稱及 SHA-1 | App 的金鑰設定畫面可以複製兩項資料 |
| 2 | 建立 Google Cloud 專案，連結自己的計費帳戶 | 專案具有有效的 Billing 關聯 |
| 3 | 啟用 Navigation SDK for Android、Places API (New) | 兩個服務頁面都顯示「管理／Manage」 |
| 4 | 建立 API Key，設定 Android 與 API 限制 | 同一把金鑰只允許本 App 及需要的兩個服務 |
| 5 | 設定預算通知、檢查配額 | 知道警示寄到哪裡，以及超出配額會中止服務 |
| 6 | 把金鑰貼入 CP Google 導航 | SDK 初始化成功，能搜尋並規劃目的地 |
| 7 | CoPilot tw 選擇「CP Google 導航」 | 主程式開始讀取本機導航資料 |
| 8 | 分別核對手機導航、資料讀取、C4 接收 | 不把某一層成功當成整條鏈路成功 |

這個配套 App 使用 Google 的導航 SDK 自己執行導航。Google Maps 官方 App、CP Google 導航和 CoPilot tw 是不同的應用程式；Cloud 金鑰的 Android 限制要填 **CP Google 導航的套件名稱**。[S04]（App 核對 A1、A2）

## 2. 開始前準備

準備下列項目：

- 可以登入 Google Cloud Console 的 Google 帳戶。
- 可依 Google 開戶畫面完成驗證的付款資料；如果已有計費帳戶，確認你有權把專案連結到它。
- **搭配 CoPilot tw 主程式時，準備 Android 12 或更新版本的裝置**，安裝 Google Play services，並可連上 Google 服務。CP Google 導航配套本身的最低版本是 Android 8.0，但主程式要求較高，完整搭配時要同時符合兩者。
- CP Google 導航與支援此來源的 CoPilot tw 主程式，安裝在**同一台 Android 裝置**。
- 網際網路、定位功能，以及可取得定位的位置。首次設定可在停車狀態完成。

Google 官方另列出 Google Play services、至少 2 GB RAM 與 OpenGL ES 2.0 等裝置要求。裝置能安裝 APK，仍需確認 Google 服務與定位正常。[S04]（App 核對 A1）

### 不需要先做的事情

使用已建置好的 APK 時，不需要自己安裝 Android Studio 或編譯 SDK。這個流程使用 API Key；不用為此建立 OAuth 同意畫面、下載 Service Account JSON，或把私鑰放進手機。以下步驟直接在 Google Cloud 網頁及 CP Google 導航 App 完成。[S01]（App 核對 A2）

## 3. 先取得正確的套件名稱與 SHA-1

1. 在 Android 裝置開啟 **CP Google 導航**。
2. 點 **「設定／更換 Google 金鑰」**。
3. 在 **「我的 Google 導航金鑰」**視窗，點 **「複製套件名稱與 SHA-1」**。
4. 暫時保留這段文字，稍後填入 Google Cloud。

這個按鈕讀取的是**目前實際安裝的 App**。若你自行編譯、換過簽章或取得不同發行包，應以按鈕顯示的資料為準。

| 欄位 | 本配套的資料 |
| --- | --- |
| App 名稱 | CP Google 導航 |
| Android package name | `com.copilottw.googlenav` |
| 本次 0.1.1 APK 已核對的簽章 SHA-1 | `AD:32:96:3B:94:DF:5E:30:DB:1B:24:EC:D6:2B:B9:11:F8:8D:48:7E` |
| 最終要填的 SHA-1 | 以你手機的「複製套件名稱與 SHA-1」結果為準 |

**SHA-1 要填 APK 的簽章憑證指紋。** APK 檔案的 SHA-256 雜湊、Google 帳號、手機序號或 API Key 都不是這個欄位。原始碼中的 `com.navdashn` 是程式 namespace；本配套安裝後的 package 是 `com.copilottw.googlenav`。自行建置的 debug APK 通常具有不同的簽章。[S05][S06]（App 核對 A1、A2）

## 4. 建立 Google Cloud 專案與計費帳戶

### 4.1 建立專案

1. 開啟 [Google Cloud Console](https://console.cloud.google.com/)，用自己的 Google 帳戶登入。
2. 點頁面頂端的專案選擇器。
3. 選 **「新增專案／New project」**。
4. 專案名稱可填 `CP Google Navigation`；如果是個人帳戶且畫面允許，組織選「無組織」。
5. 按 **「建立／Create」**，完成後在頂端選取剛建立的專案。
6. 記下 Project ID，之後排錯時可用它確認你正在操作正確專案。

Google Cloud 也可能先呈現互動式開戶精靈。依精靈完成後，仍要回來確認目前選中的專案；不要在 A 專案啟用服務、卻拿 B 專案的 Key。[S07]

### 4.2 連結計費

1. 在目前專案開啟 **「計費／Billing」**。
2. 已有可用的計費帳戶：選擇把此專案連結到該帳戶。
3. 沒有帳戶：依畫面建立自己的計費帳戶，確認帳單國家／地區、帳戶類型、姓名或公司資料，以及付款方式。
4. 完成 Google 要求的驗證，並閱讀即將接受的付款與服務條款。
5. 回到專案 Billing，確認它已有有效計費關聯。

**啟用 Billing 的意思是專案具備使用與結算資格，並不表示立刻扣一筆固定的 Navigation SDK 月費；實際費用依用量、價格及適用方案計算。** 本教學採一般隨用隨付流程，不要求另外購買 Maps 訂閱方案。[S01][S03]

### 4.3 如果畫面提供免費試用

Google Cloud 的現行 Free Program 文件列出，符合資格的新客戶可有 US$300、90 天的試用額度；實際資格、剩餘額度與截止日請以你帳戶的 Billing 頁面為準。這是有期限的試用，與 Maps 各 SKU 每月重設的免費用量不同。升級為付費帳戶後，未被免費用量或有效抵用額度涵蓋的使用量可能產生費用；試用結束而未升級也可能造成服務停止。[S08]

## 5. 啟用兩個正確的服務

先確認 Console 頂端仍是你的 `CP Google Navigation` 專案，再進入 **「API 和服務 → 程式庫／APIs & Services → Library」**。

| 服務 | 本 App 用途 | 可直接開啟的官方 Console 頁 |
| --- | --- | --- |
| **Navigation SDK for Android** | Google 地圖導航畫面、路線與導航引導 | [啟用 Navigation SDK](https://console.cloud.google.com/apis/library/navigationsdk.googleapis.com) |
| **Places API (New)** | 搜尋目的地、選定地點後取得位置資訊 | [啟用 Places API (New)](https://console.cloud.google.com/apis/library/places.googleapis.com) |

逐一打開，按 **「啟用／Enable」**。若顯示 **「管理／Manage」**，表示已經啟用。完成後回到 **「已啟用的 API 和服務」**，確認兩個項目都在清單。新啟用或更改設定後可能需要數分鐘生效。[S01][S09]

### 為什麼一定要選 Places API (New)？

本配套已使用 `Places.initializeWithNewPlacesApiEnabled()`。Places SDK 3.5.0 可支援這條 New 流程；只看版本號較舊，不能斷定它在使用 Legacy。[S10]（App 核對 A3）

目前 Google 的 Legacy 文件寫明，新 Cloud 專案不能再啟用 Places API (Legacy)。若搜尋到舊教學要求只開「Places API」或使用舊的 `Places.initialize()`，不要照它改本配套設定。[S11]

本配套的 Navigation SDK 已提供地圖層，依官方設定步驟，這次啟用與金鑰限制選上述兩項即可，不需另外選 Maps SDK for Android。程式本身也不應同時引入獨立的 Maps SDK；此配套不以 Directions API、Routes API 或 JavaScript API 當作導航來源。[S01][S04][S09]（App 核對 A1、A3）

## 6. 建立 API Key，並把兩種限制都設好

### 6.1 建立金鑰

1. 進入 **Google Maps Platform → Keys & Credentials**，或 **API 和服務 → 憑證／Credentials**。
2. 按 **「建立憑證／Create credentials → API key」**。
3. 命名為容易辨認的名稱，例如 `CP Google Navigation Android`。
4. 依畫面選取本 App 需要的 API，建立後打開這把 Key 的編輯頁。

Console 的中英文名稱或排列可能調整，但要找的核心項目相同：**API Key、Application restrictions、API restrictions**。[S01][S09]

### 6.2 Application restrictions：限制哪個 App 可以用

選 **「Android apps／Android 應用程式」**，按新增項目，再填：

```text
Package name:
com.copilottw.googlenav

SHA-1 certificate fingerprint:
貼上 CP Google 導航 App 顯示的實際 SHA-1
```

套件名稱、SHA-1 分別貼到各自的欄位，不要把 `SHA-1:` 標題一起貼進指紋欄。這個 App 使用 Android 原生 SDK，應選 Android apps 限制，不要填網站網址或手機熱點 IP。[S05]

### 6.3 API restrictions：限制這把 Key 可呼叫什麼服務

選 **「Restrict key／限制金鑰」**，只勾本配套需要的：

- **Navigation SDK for Android**
- **Places API (New)**

按 **儲存／Save**。注意：**把 API 加入金鑰的允許清單，不等於已在專案啟用 API**；第五節的啟用與這裡的限制，兩者都要完成。[S01][S09]

完成後，這把金鑰的設定應是：

| 設定區 | 正確狀態 |
| --- | --- |
| 所屬專案 | 有 Billing 的那個專案 |
| Application restrictions | Android apps |
| Package | `com.copilottw.googlenav` |
| SHA-1 | 實際安裝 APK 的簽章指紋 |
| API restrictions | Navigation SDK for Android ＋ Places API (New) |

金鑰是這個專案的識別與計費憑證。只貼到你自己的 App 設定中；不要把完整 Key 放在公開截圖、GitHub issue 或聊天群組。Google 官方也建議不同 App 分開使用金鑰，並同時設定應用程式與 API 限制。[S05]

## 7. 先理解費用，再按第一個目的地

以下為 **2026-11-12 核對的全球一般隨用隨付價目**，金額是美元，表內單價為**每 1,000 個計費事件**，且只列第一個付費級距。你的帳戶幣別、稅項、契約及其他使用量仍需以帳單為準。[S02]

| 計費項目 SKU | 每月免費用量 | 超出免費量後、月用量不超過 100,000 的單價 |
| --- | ---: | ---: |
| Navigation Request | 1,000 個目的地計費事件 | US$25／1,000 |
| Autocomplete Requests | 10,000 個請求 | US$2.83／1,000 |
| Places API Place Details Essentials | 10,000 個請求 | US$5／1,000 |
| Autocomplete Session Usage | 無限量免收費的此 SKU 事件 | US$0；不代表整個搜尋流程全免費 |

### 7.1 導航按什麼算？

Navigation Request 的核心單位是請求規劃的**目的地／waypoint**，不是開 App 幾小時，也不是一秒一筆的本機資料讀取。一次路線請求包含多個目的地時，要按目的地數量計算。已取得目的地之後，啟動逐向導航及因交通、封路或偏離路線而進行的調整，不另外收取該類重新規劃費；重新選目的地、再次發出新的路線請求則要按新請求判斷。[S12]

只看 Navigation Request，在一般全球隨用隨付價格下，每月第 1 至第 1,000 個計費事件由免費用量涵蓋；第 1,001 個起進入首個付費級距，每個是 US$0.025，直到該級距上限。不是用到第 1,001 個就把前 1,000 個重新收費。[S02]

例如同一計費月份共 1,200 個計費事件，且沒有其他會影響免費用量或價格的使用：

```text
超出免費量 = 1,200 − 1,000 = 200
導航費用 = 200 ÷ 1,000 × US$25 = US$5
```

這個算例只計導航 SKU，沒有把 Places 費用、稅或其他服務加入。[S02]（算例為依價目計算）

不要把失敗訊息一律當作不計費。Google 文件目前列出，伺服器已處理的 `NO_ROUTE_FOUND`、`ROUTE_CANCELED` 也可能計費；網路錯誤、定位未開啟與部分客戶端錯誤則不同。排錯時避免連續猛按同一目的地。[S12]

### 7.2 地點搜尋會另外計費

搜尋通常涉及兩步：輸入文字產生 Autocomplete 建議，選中結果後呼叫 Place Details 取得位置。輸入一個目的地可能產生多次搜尋請求，不是「打一個地名永遠只算一次」。新搜尋若沒有完成選取，也可能按單次 Autocomplete 請求計算。[S13]

**0.1.1 的 Place Details 只請求 `ID`、`LAT_LNG`，名稱與地址沿用所選搜尋建議中的文字。** 它不再另外請求名稱或地址欄位。依現行規則，座標屬 Essentials；在同一有效 session token 下，以 Place Details Essentials 結束搜尋時，前 12 個 Autocomplete 請求按 Autocomplete Requests 計算，同一 session 後續請求使用免收費的 Autocomplete Session Usage；結束 session 的 Details Essentials 仍有自己的計費事件。[S13][S14]（App 核對 A3）

新版在停止輸入約 350 毫秒後才查詢，並抑制同一搜尋中一秒內的重複查詢；按「搜尋」或完成語音輸入可立即查詢。這能減少無意義的重複請求，但不是免費保證。搜尋及選取的 Details 使用同一 token，選中地點後換下一個 token；實際計費結果仍應在自己的帳單確認。（App 核對 A3）

**0.1.0 使用者注意：** 原版的 Place Details 還要求地點名稱 `NAME`。依目前 Google 欄位與 session 規則，名稱屬較高級的資料；以包含 Pro 等級欄位的 Details 結束 Autocomplete session，可能按 Place Details Enterprise + Atmosphere SKU 計費。該 SKU 目前每月免費量為 1,000，第一付費級距為 US$25／1,000。這是根據程式欄位與官方規則的判讀，尚未用你的帳戶帳單實測，不能把 0.1.1 的 Essentials 成本假設直接套在 0.1.0。[S02][S13][S15]（App 核對 A3）

### 7.3 「看起來用得很少」仍要看帳單

免費用量依 SKU 計算，按月重設；Google 文件以美國太平洋時間的月初為界。Google 會合併同一計費帳戶下各專案的相關用量判定費用。建立第二個專案不代表所有免費量可以重新獨立計算。首次測試後，應在 Billing 報表查看真正出現的 SKU；尤其搜尋有 session、欄位與未完成操作的差異，不能只靠按鈕次數估計。[S02][S03][S13]

## 8. 設定預算通知與配額

### 8.1 先設費用警示

1. 打開 **Billing → Budgets & alerts／預算與快訊**。
2. 建立一個預算，範圍指定本專案。
3. 期間選每月；金額填你願意監控的金額。例如美元帳戶可先用 US$5 作為提醒門檻，其他幣別請按自己的帳戶填寫。
4. 設定例如 **50%、90%、100%** 的通知門檻。
5. 確認接收通知的電子郵件是你會查看的帳號，然後儲存。

**一般 alerts-only 預算會寄通知，不會在達到金額時自動停止 Navigation 或 Places。** Google 新增的 spend-cap budget 目前適用服務清單沒有列 Navigation／Places，不能假設替本專案填上金額就有自動斷費保護。[S16][S17]

### 8.2 再檢查實際用量配額

1. 開啟 **Google Maps Platform → Quotas**；如果介面不同，可從已啟用的 API 進入 **Quotas & System Limits／配額和系統限制**。
2. 分別選 Navigation SDK 與 Places API (New)。
3. 查看有哪些能調整的配額、單位及週期。
4. 先設定足夠個人測試使用、又不會允許大量誤觸的數值。
5. Places (New) 的限制按 API method 分開，需分別注意 Autocomplete 與 Place Details。

如果 Console 提供可調整的**每日**配額，個人初測可考慮 Navigation 20 個目的地／日、Place Details 20 次／日、Autocomplete 100 次／日這類保守起點。這是本教學的用量規劃範例，不是 Google 的建議預設或免費保證；請依畫面顯示的實際單位調整。20 × 31 = 620，只是用來理解每日額度與月用量的關係。[S12][S18][S19]（數值為教學建議）

若只看到「每分鐘」，不要把它當成「每天」或「每月」。例如每分鐘 20 次，持續一天仍可能累積很多請求。查不到每日限制時，就保留較低的速率上限、費用警示及人工檢查，不要宣稱已設定零費用上限。

配額到頂時，相關 API 請求會失敗，導航或搜尋可能暫停。帳單與用量系統也可能有延遲及差異，因此應留餘裕，不要把上限精準設在自己完全不能超過的金額。[S18]

## 9. 把金鑰輸入 CP Google 導航

1. 回到手機的 **CP Google 導航**。
2. 點 **「設定／更換 Google 金鑰」**。
3. 在 **「我的 Google 導航金鑰」**貼上剛建立的 API Key；不要貼 Project ID、Key 名稱或整段 JSON。
4. 按 **「儲存」**。
5. 首次設定可以回到入口，點 **「開始 Google 導航」**。
6. 如果這個程序已經用過另一把 Key，或你正在更換／清除 Key：到 Android **設定 → 應用程式 → CP Google 導航 → 強制停止**，再重新打開 App。

這個配套不會在已初始化的 SDK 中直接切換金鑰；只從最近使用清單把畫面滑掉，不一定等於程序已停止。**「已儲存」只表示本機成功保存，真正授權是否通過，要等導航與搜尋實際初始化。** 金鑰以本機加密方式保存，不需要把它填進 CoPilot 主程式或 C4。（App 核對 A2）

## 10. 第一次啟動與規劃路線

### 10.1 完成權限與條款

1. 按 **「開始 Google 導航」**。
2. Android 詢問位置權限時，允許 App 使用定位，並選擇精確位置。
3. 如果 Android 版本詢問通知權限，依畫面允許導航通知。
4. Google 顯示導航條款時，閱讀後由你決定是否接受；未接受就無法初始化導航。
5. 如畫面顯示 **「同意服務條款」**或 **「重新初始化導航 SDK」**，按對應按鈕繼續。

初始化成功後，應能進入目的地畫面，並看到「目前未導航」等正常狀態，而不是持續顯示「導航 SDK 尚未初始化」。官方區分定位未授權、網路、API 未授權與條款未接受等錯誤，後文列出對照。[S20]（App 核對 A3）

### 10.2 搜尋第一個目的地

1. 點 **「搜尋目的地…」**。
2. 輸入至少兩個字，例如完整站名或地址。
3. 等候結果；也可按 **「搜尋」**。
4. 確認結果名稱及地址，再點選該筆結果。
5. 本版選中地點後就會取得位置並開始計算路線；看到 **「計算路線中…」**時請等候，不必連續點選。
6. 成功後會進入 Google 導航畫面，顯示目前路線及導航提示。

本配套搜尋設定目前限制為 **台灣（TW）**。搜不到海外地點時，先確認是否落在這個範圍；不要立即判定 Key 失效。語音搜尋按鈕使用裝置的語音辨識服務，無語音服務時仍可手動輸入文字。（App 核對 A3）

### 10.3 平常使用的幾個按鈕

| 畫面功能 | 用途 |
| --- | --- |
| 常用目的地／最近導航 | 選取已保存的目的地；重新開始路線仍可能產生新的導航計費事件 |
| 回到導航畫面 | 從目的地畫面回到正在進行的導航 |
| 結束導航 | 停止目前導航 |
| 模擬行駛（測試用） | 僅供軟體畫面測試；本教學的 CoPilot／C4 接收確認使用真實定位，不用模擬資料驗證控制 |
| 停止模擬 | 結束模擬並撤銷該次導航資料；要開始真實導航，須重新選擇目的地 |
| 結束 CP Google 導航 | 結束導航並停止這個配套的背景服務 |

0.1.1 已把退出名稱與連線提示改成 CP Google 導航／CoPilot 本機通道。舊版可能仍顯示 NavDash／PiBar；排錯時請一併提供 App 版本。（App 核對 A3、A4）

## 11. 接上 CoPilot tw 主程式

先確定 CP Google 導航本身已能正常顯示路線，再做資料串接。

1. 在**同一台 Android 裝置**開啟 CoPilot tw 主程式。
2. 進入主程式的導航來源／投屏設定，選 **「CP Google 導航」**。
3. 使用主程式原有的啟動／投屏流程打開配套，並在配套開始一條真實的測試路線。
4. 查看主程式是否持續更新目前導航資料。
5. 再檢查主程式與 C4 的既有連線，以及 C4 端是否有對應資料；每一層都各自確認。

此配套的資料服務只監聽 **`127.0.0.1:5002`**。`127.0.0.1` 指「這台裝置自己」，因此兩個 App 必須在同機。不同手機即使連同一個熱點，也不能直接讀取另一台手機的這個 loopback 服務。一般使用不用開路由器連接埠，也不用把 Google Key 設成 IP 白名單。（App 核對 A4）

### 怎樣判斷哪一層成功？

| 現象 | 可以確認什麼 | 還不能單獨證明什麼 |
| --- | --- | --- |
| CP Google 導航可以搜尋 | Places 請求已能工作 | Navigation 授權及路線一定正常 |
| CP Google 導航顯示有效路線 | Google 導航流程已成功 | CoPilot 或 C4 已收到資料 |
| 配套顯示 `CoPilot 本機通道：正在讀取（127.0.0.1；不代表 C4 已收到）` | 有本機程式最近讀取 `/nav` | 讀取者一定是 C4，或 C4 已接受資料 |
| CoPilot 主程式的來源資料更新 | 主程式已取得配套資料 | C4 的每項下游功能都已驗證 |
| C4 端顯示對應更新 | 已觀察到 C4 接收／顯示 | 所有道路、背景狀態與駕駛功能都已驗證 |

如果配套的搜尋、路線都正常，但 CoPilot 未更新，應查本機橋接、來源選擇與主程式版本；這時重建 Google Key 通常不能修好本機橋接。（App 核對 A4）

### 新版下一轉彎距離的檢查例

搭配 0.1.1 與 wide46 時，橋接會把「目前轉彎到下一轉彎的間隔」交給 C4，由接收端加上車輛到目前轉彎的距離一次。若目前轉彎還有 **180 公尺**，再下一個轉彎間隔 **260 公尺**，則車輛到下一個轉彎的總距離應為 **180＋260＝440 公尺**。先在橋接加成 440，再讓 C4 加一次 180，就會錯成 620 公尺；新版修正的是這個重複加總問題。（App 核對 A5）

回報距離問題時，記下配套版本、CoPilot 版本、目前轉彎距離與下一轉彎的間隔，再對照 C4 顯示；這些是同一時間點的資料檢查，不是要在 App 手動填入距離。上述算例已經過程式路徑核對與主機測試，不代表已完成真車路測。

## 12. 第一次設定後，去 Console 看一次實際用量

1. 回到 Google Cloud，選同一個專案。
2. 到 Maps Platform 的 API 指標，查看 Navigation 與 Places 是否有請求及錯誤。
3. 到 Billing 報表，限制為本專案，依 **SKU** 分組查看。
4. 確認 Navigation Request、Autocomplete、Place Details 的實際項目，是否符合你使用的 App 版本。
5. 看看預算通知的範圍及信箱是否正確。

計費資料不是即時更新；官方成本管理文件提醒，Billing 顯示可能延遲，甚至可到 48 小時。剛測試完看到 US$0，不足以證明沒有產生請求或永遠不會計費。免費用量內的使用也應從指標及 SKU 資訊確認。[S18]

## 13. 依症狀排錯

### 13.1 SDK 完全無法初始化

| 訊息／錯誤碼 | 含義 | 依序檢查 |
| --- | --- | --- |
| `NOT_AUTHORIZED`／1 | Navigation 金鑰未獲授權 | Key 所屬專案 → Billing → Navigation SDK 已啟用 → Key 的 API 限制 → package＋實際 SHA-1 → 設定生效時間 |
| `TERMS_NOT_ACCEPTED`／2 | 尚未接受 Google 導航條款 | 回到 App，按「同意服務條款」 |
| `NETWORK_ERROR`／3 | SDK 初始化連線失敗或逾時 | 裝置實際網路、Google 服務連線、稍後重新初始化 |
| `LOCATION_PERMISSION_MISSING`／4 | App 未取得定位權限 | Android App 權限、精確位置與系統定位 |
| 「已儲存」但仍用舊 Key | SDK 已在本程序初始化 | 強制停止 CP Google 導航，再重新開啟 |
| 「API Key 未設定」 | App 沒有讀到保存的 Key | 回金鑰入口重新貼入；不要把 Key 名稱或 Project ID 當 Key |

Google 官方對這四個 Navigation 初始化錯誤有明確定義；本 App 的「儲存成功」不是 Google 的授權回應。[S20]（App 核對 A2）

### 13.2 地圖能開，但搜尋失敗

| Places 錯誤 | 官方含義 | 處理方向 |
| --- | --- | --- |
| `9011 REQUEST_DENIED` | 授權問題 | 是否啟用 **Places API (New)**；Key 是否允許它；Android package／SHA-1 是否正確；Billing 是否可用 |
| `9010 OVER_QUERY_LIMIT` | 超出查詢限制 | 檢查 Places 該 method 的配額、用量與服務／計費狀態；不要只檢查 Wi-Fi |
| `9012 INVALID_REQUEST` | 請求不正確 | 記下 App 版本及完整錯誤碼，交由維護者檢查請求 |
| `9013 NOT_FOUND` | 找不到結果 | 換更完整的地址，並確認目前搜尋範圍為台灣 |
| 純網路錯誤 | 裝置連不上服務 | 確認裝置本身上網；重新嘗試，避免連續快速重試 |

**舊 0.1.0 的文案可能把 9010 顯示成「沒有網路」。官方定義是超出查詢限制，排錯應以實際錯誤碼為準。** 如果仍用舊版，請一併查看 Cloud 的配額及用量。[S21]（App 核對 A3）

### 13.3 路線計算失敗

- `LOCATION_DISABLED`／`LOCATION_UNKNOWN`：先確認定位與 GPS；移到較能取得定位的位置後再試。
- `QUOTA_CHECK_FAILED`：查 Navigation 配額與計費資格。
- `NO_ROUTE_FOUND`：確認目的地、出發位置與可行車路線；不是所有這類失敗都免計費。
- 只有海外目的地查不到：先確認本配套的台灣搜尋限制。

以上是判斷方向，應保留完整錯誤訊息再核對官方 RouteStatus／計費文件，不要只靠「沒有路線」四個字猜原因。[S12]

### 13.4 CP Google 導航正常，但主程式／C4 沒資料

依序檢查：兩個 App 是否同機、主程式是否選 CP Google 導航、配套是否真的在導航、配套背景服務是否被停止、主程式的本機讀取是否成功、主程式與 C4 是否仍連線。若從「結束 CP Google 導航」退出，`:5002` 服務也會停止，需要重新打開配套。（App 核對 A3、A4）

### 13.5 台灣看不到道路限速、號誌或相機

不要以此直接判定 Key 設錯。Google Navigation SDK 官方的台灣覆蓋表目前顯示可提供行車導航等服務，但 **Speed Limits、Traffic Lights／Stop Signs、Real-Time Disruptions** 三欄為「—」，其定義是該地區未提供，或品質／可用性低。一般 Google Maps App 畫面上的功能也不能直接視為 SDK 一定提供的資料。[S22]

CoPilot 的台灣離線／HCOP 提醒是另一個資料來源；不要把它取得的限速或相機標成 Google SDK 回傳，也不要把沒有的欄位補成 0 當作實際資料。

## 14. 進階檢查：本機服務是否啟動

只有需要排查時才做。請在**安裝兩個 App 的同一台 Android 裝置**，以瀏覽器開啟：

```text
http://127.0.0.1:5002/health
```

正常回應會包含 `status`、`server`、`version`、`ready`。`status: "ok"` 表示本機 HTTP 服務有回應；`ready: true` 表示配套認為導航 SDK 已就緒。這仍不是「已有有效路線」或「C4 已收到」的證明。

必要時還可查看：

```text
http://127.0.0.1:5002/nav
http://127.0.0.1:5002/route
```

這些頁面可含目前目的地、位置或路線。自己檢查即可，不要直接把完整內容公開；回報問題時保留版本、狀態與錯誤碼，遮住行程資料。手動打開 `/nav` 也會更新 App 的「最近有人讀取」指示，因此測試後看到「CoPilot 本機通道：正在讀取」，不能據此判定 CoPilot 或 C4 已成功。（App 核對 A4）

## 15. 更換 Key、換手機或暫停使用

### 更換金鑰

先在 Cloud 建好新 Key 並套用同樣限制，再到 CP Google 導航貼入。強制停止 App 後重開，確認搜尋及導航成功，再刪除不再使用的舊 Key。若舊 Key 已外洩，應立即在 Cloud 撤銷或刪除，之後再完成替換。[S05]（App 核對 A2）

### 換手機

重新安裝配套後，使用 App 顯示的 package＋SHA-1 再核對限制。相同簽章 APK 的指紋不會因手機不同而變成另一支手機的硬體指紋；但自行編譯或不同簽章版本可能不同。金鑰不在這個 App 的一般備份檔內，必要時由你重新填入。[S06]（App 核對 A2）

### 暫時不用

在 App 結束導航及退出配套。若要阻止這把 Key 之後再被使用，可在 Cloud 撤銷／刪除這把 Key，或停用相關 API；這會影響使用它的 App。單純在手機按「清除」只移除本機保存的 Key，不會刪除 Google Cloud 中的金鑰或清掉已產生的帳單。[S05][S07]（App 核對 A2）

## 16. 完成設定後的確認清單

- [ ] Google Cloud 選的是正確專案，且已連結有效 Billing。
- [ ] Navigation SDK for Android 與 Places API (New) 都已啟用。
- [ ] API Key 使用 Android apps 限制。
- [ ] package 是 `com.copilottw.googlenav`。
- [ ] SHA-1 與目前實際安裝的 APK 相符。
- [ ] Key 的 API 允許清單包含上述兩個服務。
- [ ] 預算通知的金額、範圍與收件信箱已核對。
- [ ] 知道配額的單位是每分鐘、每日或其他週期。
- [ ] CP Google 導航能初始化、搜尋台灣地點及規劃一條路線。
- [ ] CoPilot tw 與配套在同一台裝置，且已選 CP Google 導航來源。
- [ ] 手機導航、CoPilot 讀取、C4 接收分別確認。
- [ ] 首次測試後有查看實際用量與 SKU；沒有把「剛好顯示 US$0」當作永久免費。

## 附錄 A：自行編譯時如何取得 SHA-1

一般使用者直接用 App 的複製按鈕即可。維護者若要核對 APK，可使用 Android SDK Build Tools 的 `apksigner`：

```sh
apksigner verify --verbose --print-certs CP-Google-Navigation-0.1.1.apk
```

找輸出中的簽章憑證 SHA-1，並與 App 內顯示值比對。Android Studio 自行 debug 建置，也可用 `signingReport` 查 debug 簽章。若日後使用 Play App Signing，則要辨別「實際 App signing certificate」與「upload certificate」，不要把上傳憑證錯當成使用者安裝 App 的簽章。[S06][S23]

## 官方資料來源

以下均為 Google／Android 官方資料；核對日期皆為 **2026-11-12**。價格、Console 介面與服務範圍可能更新，重新設定時應開啟連結核對。

| 編號 | 官方文件 | 本文用途 |
| --- | --- | --- |
| S01 | [Set up the Navigation SDK for Android][S01] | Billing、啟用 Navigation、API Key 與限制 |
| S02 | [Google Maps Platform core services pricing list][S02] | 各 SKU 免費用量、美元價格及用量合併 |
| S03 | [Google Maps Platform pricing overview][S03] | 按量計費、免費用量與舊 US$200 制度變更 |
| S04 | [Navigation SDK overview and requirements][S04] | 裝置要求及 Navigation／Maps SDK 關係 |
| S05 | [Google Maps Platform security guidance][S05] | Android package＋SHA-1、API 限制與 Key 管理 |
| S06 | [Android: Sign your app][S06] | Debug／release／Play 簽章及憑證指紋 |
| S07 | [Getting started with Google Maps Platform][S07] | 專案與服務的基本設定流程 |
| S08 | [Free Google Cloud features and trial offer][S08] | 試用資格、額度、期限及付費帳戶差異 |
| S09 | [Set up the Places SDK for Android][S09] | 啟用 Places API (New) 與 Key 設定 |
| S10 | [Places SDK (Legacy) overview][S10] | New 初始化方法與 SDK 版本對照 |
| S11 | [Place Details (Legacy)][S11] | 新 Cloud 專案無法再啟用 Legacy 的公告 |
| S12 | [Navigation SDK for Android Usage and Billing][S12] | 目的地計費、重新規劃、失敗狀態與配額 |
| S13 | [Autocomplete (New) and session pricing][S13] | Session、放棄搜尋及 Essentials／較高級資料計費 |
| S14 | [Place Data Fields (New)][S14] | 座標、地址、名稱等欄位的 SKU |
| S15 | [Places (New) SKU details][S15] | 名稱欄位與 session 結束的進階定價規則 |
| S16 | [Create, edit, or delete budgets and budget alerts][S16] | Alerts-only 預算與通知 |
| S17 | [Manage spend cap budgets][S17] | Spend-cap 適用服務範圍與限制 |
| S18 | [Manage Google Maps Platform costs][S18] | 用量控制、每日配額、計費延遲 |
| S19 | [Places SDK for Android Usage and Billing][S19] | Places method 配額與欄位計費 |
| S20 | [NavigationApi.ErrorCode][S20] | Navigation 初始化錯誤 1／2／3／4 |
| S21 | [PlacesStatusCodes][S21] | Places 9010／9011／9012／9013 |
| S22 | [Navigation SDK country and region coverage][S22] | 台灣導航、限速、號誌與即時事件覆蓋 |
| S23 | [Android: apksigner][S23] | APK 簽章資訊核對 |

### App 實作核對

本教學的 App 按鈕名稱、套件名稱、同機連接方式與重啟要求，來自本專案原始碼及本次 0.1.1 APK 的簽章核對，不是把 Google 文件的範例 App 當成本配套。

- **A1：** `variants/google-navdash/app/build.gradle.kts`、`app/src/main/AndroidManifest.xml`、`app/src/main/res/values/strings.xml`。
- **A2：** `variants/google-navdash/app/src/main/java/com/navipilot/google/GoogleKeySettings.java`、`GoogleKeyGate.java`、`com/navdashn/GoogleReady.java`。
- **A3：** `variants/google-navdash/app/src/main/java/com/navdashn/MainActivity.kt`、`GoogleSearchPolicy.java`、`navigation/NavController.kt`、`GuidanceActivity.kt`。
- **A4：** `variants/google-navdash/app/src/main/java/com/navdashn/navigation/NavHttpServer.kt`、`NavService.kt`，以及配套 README。
- **A5：** `variants/google-bridge46/src/WideGoogleAdapter.java` 及其距離契約檢查，並對照 Carrot 接收端的目前／下一轉彎加總方式；主程式的 Android 12 下限另核對既有 APK 的 `minSdkVersion: 31` 與安裝文件。

### 核對範圍

本教學已核對官方文件與 0.1.1 的設定、搜尋及本機橋接實作。你的 Google 授權、地區網路、實際計費 SKU 與 C4 接收仍需依第 10 至 12 節實際確認；本文沒有以使用者的真實 Key 完成帳單或真車路測驗證。APK 簽章請以目前安裝版本的複製按鈕為準。

[S01]: https://developers.google.com/maps/documentation/navigation/android-sdk/get-api-key
[S02]: https://developers.google.com/maps/billing-and-pricing/pricing
[S03]: https://developers.google.com/maps/billing-and-pricing/overview
[S04]: https://developers.google.com/maps/documentation/navigation/android-sdk/setup-overview
[S05]: https://developers.google.com/maps/api-security-best-practices
[S06]: https://developer.android.com/studio/publish/app-signing
[S07]: https://developers.google.com/maps/get-started
[S08]: https://docs.cloud.google.com/free/docs/free-cloud-features
[S09]: https://developers.google.com/maps/documentation/places/android-sdk/get-api-key
[S10]: https://developers.google.com/maps/documentation/places/android-sdk/legacy/overview-legacy
[S11]: https://developers.google.com/maps/documentation/places/android-sdk/legacy/place-details
[S12]: https://developers.google.com/maps/documentation/navigation/android-sdk/pricing
[S13]: https://developers.google.com/maps/documentation/places/android-sdk/session-pricing
[S14]: https://developers.google.com/maps/documentation/places/android-sdk/data-fields
[S15]: https://developers.google.com/maps/billing-and-pricing/sku-details/places
[S16]: https://docs.cloud.google.com/billing/docs/how-to/budgets
[S17]: https://docs.cloud.google.com/billing/docs/how-to/budgets-spend-caps
[S18]: https://developers.google.com/maps/billing-and-pricing/manage-costs
[S19]: https://developers.google.com/maps/documentation/places/android-sdk/usage-and-billing
[S20]: https://developers.google.com/maps/documentation/navigation/android-sdk/reference/com/google/android/libraries/navigation/NavigationApi.ErrorCode
[S21]: https://developers.google.com/maps/documentation/places/android-sdk/reference/com/google/android/libraries/places/api/net/PlacesStatusCodes
[S22]: https://developers.google.com/maps/documentation/navigation/android-sdk/coverage-nav-sdk
[S23]: https://developer.android.com/tools/apksigner

</details>
