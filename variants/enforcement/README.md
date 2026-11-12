# 全台科技執法資料層（尚未接入已發布 APK）

此模組將官方公告整理成獨立離線圖層，與既有 `tw_cameras.json` 分開。不是已部署的 UI 或語音功能，也不寫入 C4 的速限／減速封包。

`src/WideEnforcementCatalog.java` 使用 Android 內建 org.json；建構時傳入 assets 中 `tw_enforcement.json` 的 UTF-8 內容。請於背景執行緒載入，定位更新後以 `nearby(lat, lon, 2000, bearingOrNull, todayISO)` 查詢。不需目的地或導航路線；目前是周邊直線距離查詢，不是前方道路 2 公里路徑。

結果包含公告原文、取締類型、來源、距離及明確方向反向標記。未知方向仍保留為地圖候選。`preciseAlertReady()` 固定 false，因為這一階段尚未綁定 OSM 道路邊；不可直接把周邊候選當作前方同路段，或當成自動減速目標。區間點位只作參考，不能當作完整起訖端點。

打包資料：

```sh
python tools/enforcement/prepare_assets.py --assets /path/to/decoded-apk/assets
```

後續 App 接線：載入 catalog → 地圖新增獨立科技執法圖層 → 以連續 GPS 與 OSM 確認道路/方向/分層 → 通過門檻才顯示前方提示及科技執法語音。需處理同點多取締項目、與既有測速點重複提示及時間/車種限制。`addressGroupId` 只代表同縣市、行政區、地址文字相同，不代表已認定同一設備。

本提交不修改既有發布 APK，沒有簽名金鑰也不另造更新包。Java 讀取器已用 ECJ 3.38.0 / Java 8 與 org.json 20240303 編譯、執行測試；Android 實機 UI、背景定位、語音與道路配對尚未驗證。
