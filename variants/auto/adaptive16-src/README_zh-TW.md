# Navipilot 9.3.1 wide.16 自動排版測試版

兩個 APK 都支援 Android 手機、平板與可安裝 Android App 的車機。

| 安裝包 | 左側／上方導航 App | 右側／下方 |
|---|---|---|
| wide.16-auto-adaptive | 高德車機版 `com.autonavi.amapauto` | 神盾與原有快捷鍵 |
| wide.16-phone-adaptive | 高德一般版 `com.autonavi.minimap` | 神盾與原有快捷鍵 |

這兩版的差別是投屏的高德 App；不是一版只能安裝在車機、另一版只能安裝在手機。

## 安裝與操作

1. Android 12 以上，先安裝對應高德、神盾與 Shizuku，完成必要的定位與投屏授權。
2. 選擇一個 APK 覆蓋目前的寬螢幕版。兩版使用同一套件名稱與簽章，會互相覆蓋，不會並存。`versionCode=26110728`。
3. 寬橫向：左導航，右上神盾，右下原有快捷鍵。空間較小時，快捷鍵預設收合。
4. 直向：上導航，下神盾；按神盾工具列「快捷」展開原按鍵，再按「收合」隱藏。
5. 長按導航與神盾的邊界把手後拖動；快捷鍵展開時，也可拖神盾下緣。橫向與直向分別儲存比例。
6. 「返回」只返回該投屏 App。「更多 → 版面與比例設定」調整排版或恢復當前方向預設。版面設定與返回鍵不再使用重疊位置。
7. 寬螢幕設定使用右側區域；手機、小視窗與直向設定使用完整內容區。旋轉或改變視窗大小時，已開啟的版面對話框會關閉，重新開啟即可按新的可用空間顯示。

保留按鍵最小空間，因此拖拉設定百分比在極端值時會被實際可用尺寸限制。小畫面工具列會隱藏標題文字，仍保留返回、快捷、更多按鈕。橫向與直向比例互不覆蓋；舊版的比例只遷移到橫向。

## 既有資料功能

- 車機版以 wide.11-auto-diagnostic 為底，手機一般版以 wide.15-phone-bridge 為底。
- 原有高德解析、導航封包傳送、Carrot 車況與控制程式保持原樣，沒有新增加減速或 NOO 控制。
- 一般版的完整廣播／通知診斷保留。這次排版更新沒有證實一般高德能產出車機版相同的導航、測速或轉彎資料；通知文字仍不轉成行車控制。
- 神盾是投屏畫面；本更新沒有擷取神盾內部的測速資料。
- 保留兩個虛擬螢幕互不清除的修正。拖拉中暫緩重建虛擬螢幕，放開並穩定約 500 ms 後依新尺寸重建。每個畫面保留 1280 像素長邊上限、30 Hz 要求。

## 驗證範圍

已完成兩版 Java 編譯、APK 組裝、簽章、16 KB 對齊、打包後 smali 比對、應用內方法／欄位引用檢查；12 種視窗尺寸與隨機幾何邊界檢查、11 項比例保存／旋轉狀態測試，以及手機版原有 8 項通知診斷回歸測試。

尚未在你的車機或 Android 手機執行。幾何預覽僅顯示程式計算的分區，不是 Android 實機截圖。高德／神盾自己的直向、分割畫面與背景行為仍受其 App 及裝置系統限制。

首次驗收請在停車時檢查：橫／直旋轉、拖拉後返回原方向、退出重開後比例保存、快捷展開／收合、返回與更多分開可按、設定內容完整可捲動、兩個投屏畫面能同時更新。不要把本版的 UI 驗證當成導航資料或實車控制驗證。

## 回復舊排版

修改包附 `Navipilot-auto-previous-layout-restore-build28.apk` 或 `Navipilot-phone-previous-layout-restore-build28.apk`，對應原 wide.11 車機版／wide.15 一般版。它們只將安裝版本碼提高到 26110728，程式類別與舊版一致，可直接覆蓋回復，免解除安裝。顯示版本名稱仍為舊版，以辨識已回復。

## 重建

保留修改包既有內容。新來源在 `adaptive16-src/`；基底 APK 在 `deliverables/`；新 helper smali 與驗證報告在 `adaptive16-build/<auto|phone>/`。

準備 JDK、Python 3、ECJ 3.39、Apktool 3.0.3、Android SDK 35 android.jar、Android Build Tools 36。使用下列相對路徑：`tools/ecj.jar`、`tools/apktool.jar`、`tools/platform/android-35/android.jar`、`tools/build-tools/android-16/`。亦可設定 `ANDROID_BUILD_TOOLS`。工具二進位不含在此修改包。

在乾淨工作目錄執行 `bash adaptive16-src/build.sh auto` 或 `bash adaptive16-src/build.sh phone`。建置用中繼 `patched` 目錄已存在時腳本會停止，避免覆蓋工作。驗證用 `python3 adaptive16-src/verify.py auto`／`phone`。

Java 測試替身位於 `adaptive16-src/jvm/`、`phone15-src/jvm/`，不會打包進 APK。套件 `com.jixiexiaoge.drivingassist.wide`；附開發簽署金鑰僅供延續原測試版更新，不代表正式發布簽章。
