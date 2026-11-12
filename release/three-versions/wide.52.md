Google＋CoPilot 融合版 wide.52（測試版／僅神盾投屏）

Google 導航整合進單一 CoPilot APK；保留高德切換。撤除內建台灣測速入口、背景定位服務、資料庫與 Taiwan speed override，右側只保留神盾投屏。神盾官方 App 仍需另外安裝；投屏不等於將神盾測速資料傳給 C4。

Google 退出時的 killProcess 已移除，避免終止整個 CoPilot。47 項靜態結構檢查、編譯與簽章檢查通過，**尚未完成 Android 車機、Google 金鑰、雙區投屏或 C4 實機驗收**。

覆蓋安裝同簽章 CoPilot；不需獨立 CP Google App。舊配套的金鑰不會自動複製，請在內建導航重新輸入並在 Google Cloud Android 限制新增：
- 套件：`com.jixiexiaoge.drivingassist.wide`
- SHA-1：`AD:32:96:3B:94:DF:5E:30:DB:1B:24:EC:D6:2B:B9:11:F8:8D:48:7E`

APK 與先前交付 wide.52 完全相同，無私鑰或使用者 API key。source.zip、RELEASE_MANIFEST.json、SHA256SUMS.txt 一併提供。
