# 科技執法資料串接核對（2026-11-12，臺灣時間）

已整理 2148 筆來源紀錄，1152 筆有通過範圍檢查的座標，996 筆待定位。這是公告紀錄數，包含同址不同方向、不同取締項目、跨版本資料及一般固定測速，**不是不重複設備數，也不是全台完整即時名單**。21 個縣市有紀錄；連江縣尚未找到可核實公開點位，不能解讀為沒有設備。另收錄航空警察局、國道公路警察局資料。

## 已提交內容

- `data/enforcement/tw_enforcement.json`：統一格式、原始欄位、0.01 度離線索引、來源及快照 SHA256。
- `data/enforcement/tw_enforcement.geojson`：有座標的獨立圖層。
- `data/enforcement/audit.json`：22 縣市覆蓋、下載/解析狀態、未能可靠解析的 PDF 行。
- `tools/enforcement/`：下載、保留上次快照、CSV/JSON/PDF 解析、資產打包與測試。
- `variants/enforcement/`：Android Java 查詢讀取器與測試。**尚未接線到已發布 App 的地圖、語音或 C4；沒有新 APK。**

## 核對與限制

臺中資料的經緯度欄互換，僅在臺灣座標範圍能明確判別時修正並留標記。取締項目誤填地址時不猜類別。國道 1 號 86.7 公里經度原值缺小數點，留待核對，未加入地圖。方向為「雙向」不推定道路軸線。多重/車種速限不硬轉成單一數字。未來啟用日期不回傳為當前候選。沒有啟用日期時狀態為 announced，不能證明設備今日仍運作。

金門、嘉義縣、屏東等使用可取得的較舊正式附件，並保留來源日期；官方新資料下載失敗不等於沒有設備。PDF 排版不明確的行保留於解析例外，不能宣稱所有附件行已完整抽取。屏東掃描附件第 2 頁人工核對 8 筆，綁定原檔 SHA256；原檔改變須重新檢查。無座標不以路口中心、縣市中心或猜測座標代入。

目前所有紀錄的 preciseAlertReady 為 false：尚未與 OSM 路段綁定。2 公里查詢是周邊候選，不能等同未導航時前方必經道路。現有 1856 測速點沒有被覆蓋，也尚未完成跨資料庫實體去重。

## 重建與測試

```sh
python -m pip install -r tools/enforcement/requirements.txt
python tools/enforcement/download.py
python tools/enforcement/build.py
python tools/enforcement/test_build.py
# 需要 javac 及 org.json JAR；Android 使用內建 org.json
javac -cp /path/to/json.jar -d /tmp/enforcement-classes variants/enforcement/src/*.java variants/enforcement/tests/*.java
java -cp /tmp/enforcement-classes:/path/to/json.jar com.navipilot.obf.CatalogTest data/enforcement/tw_enforcement.json
```

下載是手動執行的更新流程，沒有排定自動更新或背景同步。正式更新時需審查 audit 差異，特別是資料大幅減少、來源版本過舊與解析例外。

## 縣市覆蓋

|縣市|來源紀錄|有座標|狀態|
|---|---:|---:|---|
|臺北市|95|95|部分公告快照|
|新北市|252|0|部分公告快照|
|桃園市|145|145|部分公告快照|
|臺中市|79|77|部分公告快照|
|臺南市|382|0|部分公告快照|
|高雄市|455|440|部分公告快照|
|基隆市|23|0|部分公告快照|
|新竹市|34|33|部分公告快照|
|嘉義市|56|13|部分公告快照|
|新竹縣|78|0|部分公告快照|
|苗栗縣|19|19|部分公告快照|
|彰化縣|57|57|部分公告快照|
|南投縣|39|39|部分公告快照|
|雲林縣|118|118|部分公告快照|
|嘉義縣|33|33|部分公告快照|
|屏東縣|8|0|部分公告快照|
|宜蘭縣|112|0|部分公告快照|
|花蓮縣|66|0|部分公告快照|
|臺東縣|39|32|部分公告快照|
|澎湖縣|4|4|部分公告快照|
|金門縣|48|45|部分公告快照|
|連江縣|0|0|尚無可核實來源|

## 官方來源登錄

- [臺北市／臺北市智慧管理科技執法設備資料表](https://data.gov.tw/dataset/135957)（`taipei`）
- [桃園市／桃園市科技執法設備地點（115年9月）](https://data.gov.tw/dataset/178168)（`taoyuan`）
- [臺中市／臺中市科技執法取締地點](https://data.gov.tw/dataset/170673)（`taichung`）
- [新竹市／新竹市科技執法點位資訊](https://data.gov.tw/dataset/178144)（`hsinchu-city`）
- [澎湖縣／澎湖縣科技執法地點](https://data.gov.tw/dataset/172940)（`penghu`）
- [苗栗縣／苗栗縣科技執法設備取締地點](https://data.gov.tw/dataset/172178)（`miaoli`）
- [嘉義縣／嘉義縣警察局固定式科技執法設置地點](https://data.gov.tw/dataset/178140)（`chiayi-county`）
- [基隆市／基隆市科技執法取締地點](https://data.gov.tw/dataset/178159)（`keelung`）
- [屏東縣／屏東縣科技執法路段及項目](https://data.gov.tw/dataset/159972)（`pingtung`）
- [高雄市／115年路口科技執法第3次公告](https://data.gov.tw/dataset/176561)（`kaohsiung-junction`）
- [高雄市／115年不停讓行人第2次公告](https://data.gov.tw/dataset/176555)（`kaohsiung-pedestrian`）
- [高雄市／115年租賃式車不停讓行人第3次公告](https://data.gov.tw/dataset/177827)（`kaohsiung-rental`）
- [高雄市／115年限制車種違規駛入第4次公告](https://data.gov.tw/dataset/176551)（`kaohsiung-restricted`）
- [高雄市／115年違規停車監測系統](https://data.gov.tw/dataset/176553)（`kaohsiung-parking`）
- [南投縣／南投縣科技執法禁駛路段（1150724）](https://data.gov.tw/dataset/176021)（`nantou-restricted`）
- [彰化縣／彰化縣固定式科技執法設備](https://data.gov.tw/dataset/172905)（`changhua`）
- [嘉義市／嘉義市固定式科技執法自動偵測系統](https://data.gov.tw/en/datasets/161852)（`chiayi-city`）
- [臺南市／臺南市智慧管理科技執法設備設置地點](https://data.tainan.gov.tw/Resource/1c7e82f0-d6b2-4b20-aeff-5c768100f82c)（`tainan`）
- [金門縣／金門縣警察局固定式科學儀器執法設備設置地點一覽表.pdf](https://www.xizhi.police.ntpc.gov.tw/cp-3940-142233-22.html)（`kinmen-pdf`）
- [南投縣／4495769_南投縣政府警察局固定式科學儀器設置地點一覽表.pdf](https://www.xizhi.police.ntpc.gov.tw/cp-3940-142235-22.html)（`nantou-pdf`）
- [新竹市／4505051_新竹市警察局科技執法取締地點一覽表（1150909更新）.pdf](https://www.xizhi.police.ntpc.gov.tw/cp-3940-142237-22.html)（`hsinchu-city-pdf`）
- [新竹縣／新竹縣政府警察局「固定式科學儀器執法設備」設置地點一覽表.pdf](https://www.xizhi.police.ntpc.gov.tw/cp-3940-142240-22.html)（`hsinchu-county-pdf`）
- [嘉義市／嘉義市政府警察局「固定式科學儀器執法設備」設置地點一覽表.pdf](https://www.xizhi.police.ntpc.gov.tw/cp-3940-142446-22.html)（`chiayi-city-pdf`）
- [新北市／交通科技執法設備設置地點一覽表1150901.pdf](https://www.traffic.police.ntpc.gov.tw/cp-3313-143085-27.html)（`newtaipei`）
- [雲林縣／pdf](https://ylhpb.yunlin.gov.tw/Traffic/News_Content.aspx?n=31207&sms=22409&s=613550)（`yunlin`）
- [宜蘭縣／宜蘭縣政府警察局「固定式科學儀器執法設備設置地點」一覽表.pdf](https://www.traffic.police.ntpc.gov.tw/cp-1084-138085-27.html)（`yilan`）
- [高雄市／高雄市政府警察局115年「固定式違規照相科技執法設備」設置地點一覽表.pdf](https://www.traffic.police.ntpc.gov.tw/cp-1084-140949-27.html)（`kaohsiung-pdf`）
- [花蓮縣／114年度測速闖紅燈及科技執法一覽表](https://data.gov.tw/dataset/177297)（`hualien`）
- [臺東縣／1151102取締違規照相暨科技執法](https://data.gov.tw/dataset/179008)（`taitung`）
- [航空警察局／航空警察局科技執法公告](https://www.apb.npa.gov.tw/ch/app/data/view?id=2346&module=wg146&serno=59783747-1079-4559-974e-db54e9d8cdd5)（`airport`）
- [屏東縣／屏東縣轄區固定測速照相系統設置地點一覽表.pdf](https://www.xizhi.police.ntpc.gov.tw/cp-3940-142234-22.html)（`pingtung-pdf`）
- [臺南市／臺南市政府警察局固定式交通違規照相路段設置一覽表.pdf](https://www.xizhi.police.ntpc.gov.tw/cp-3940-142238-22.html)（`tainan-pdf`）
- [基隆市／基隆市警察局固定式科技執法設備設置地點一覽表.pdf](https://www.traffic.police.ntpc.gov.tw/cp-1084-137006-27.html)（`keelung-pdf`）
- [臺東縣／臺東縣警察局固定式取締違規照相桿設置地點一覽表.pdf](https://www.traffic.police.ntpc.gov.tw/cp-1084-143923-27.html)（`taitung-pdf`）
- [臺東縣／臺東縣警察局科技執法偵測設置地點一覽表.pdf](https://www.traffic.police.ntpc.gov.tw/cp-1084-143923-27.html)（`taitung-pdf-1`）
- [臺東縣／臺東縣警察局區間平均速率執法設備設置地點一覽表.pdf](https://www.traffic.police.ntpc.gov.tw/cp-1084-143923-27.html)（`taitung-pdf-2`）
- [花蓮縣／公告及一覽表.pdf](https://www.traffic.police.ntpc.gov.tw/fp-1084-138817-27.html)（`hualien-pdf`）
- [南投縣／南投縣政府警察局固定式科學儀器交通執法設備設置地點一覽表.pdf](https://www.traffic.police.ntpc.gov.tw/cp-1084-141579-27.html)（`nantou-latest-pdf`）
- [屏東縣／公告及一覽表.pdf](https://www.traffic.police.ntpc.gov.tw/fp-1084-121546-27.html)（`pingtung-technology-pdf`）
- [金門縣／114年3月28日修訂設備表（歷史快照）](https://www.traffic.police.ntpc.gov.tw/dl-36387-b568b76f-3f73-49b4-811c-9f227def8eb4.html)（`kinmen-fallback-pdf`）
- [嘉義縣／1141205固定式科學儀器交通執法設備（歷史快照）](https://www-ws.gov.taipei/Download.ashx?icon=..pdf&n=5ZiJ576p57ij5Zu65a6a5byP56eR5a245YSA5Zmo5Lqk6YCa5Z%2B35rOV6Kit5YKZ6Kit572u5Zyw6bue5LiA6Ka96KGoKDExNDEyMDUpLnBkZg%3D%3D&u=LzAwMS9VcGxvYWQvNDY3L3JlbGZpbGUvMzIyNTkvOTUxMzExNS84NTE2NTZmYi01YTUwLTQ1NTAtODBmZi01YjYyMDdhMGFjYmIucGRm)（`chiayi-county-fallback-pdf`）
- [國道公路警察局／AI違規偵測系統設備地點（1150702）](https://www.hpb.npa.gov.tw/ch/app/data/view?id=2593&module=wg160&serno=f2e50c40-d837-4fe4-96a6-9e788d679c70)（`national-highway-ai`）
