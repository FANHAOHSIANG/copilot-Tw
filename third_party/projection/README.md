# Stellar 與 Shizuku 投屏授權

投屏工具擇一使用。以下 APK 由各工具的官方 GitHub Release 提供。

| 工具 | 下載 | 官方說明 |
| --- | --- | --- |
| Stellar 1.1（101000） | [下載 Stellar APK](https://github.com/roro2239/Stellar/releases/download/v1.1%28101000%29/stellar-v1.1-release.apk) | [發布頁](https://github.com/roro2239/Stellar/releases/tag/v1.1%28101000%29) · [專案說明](https://github.com/roro2239/Stellar) |
| Shizuku 13.6.0 | [下載 Shizuku APK](https://github.com/RikkaApps/Shizuku/releases/download/v13.6.0/shizuku-v13.6.0.r1086.2650830c-release.apk) | [發布頁](https://github.com/RikkaApps/Shizuku/releases/tag/v13.6.0) · [官方啟動手冊](https://shizuku.rikka.app/guide/setup/) |

## 首次啟動

1. 在同一台 Android 裝置安裝所選工具及 [Carrot Bridge](../../README.md#下載)。
2. 開啟「開發人員選項 → 無線偵錯」。從工具開始配對，再到系統的「使用配對碼配對裝置」取得代碼，依工具指示輸入。
3. 回工具按「啟動」，確認服務正在執行。Stellar 需開啟 Shizuku 相容層。
4. 在 Carrot Bridge 的地圖區按「更多 → 啟動投屏／授權」，於工具或系統顯示的權限提示中授權。
5. 到「更多 → 投屏安裝與授權」核對服務與授權狀態。重開機後若服務已停止，在原工具重新啟動。只要原配對仍有效，通常可直接啟動服務。

無線偵錯選項依車機或手機廠牌而異。沒有此選項且裝置支援 USB 偵錯時，可用電腦的 [Android SDK Platform-Tools](https://developer.android.com/tools/releases/platform-tools)，依工具內顯示的 ADB 啟動指令操作。

## 版本與校驗

兩個官方 APK 已核對簽章及下列 SHA-256。[Stellar 授權](STELLAR-LICENSE.txt) · [Shizuku 授權](SHIZUKU-LICENSE.txt)

| APK | SHA-256 |
| --- | --- |
| `stellar-v1.1-release.apk` | `47276b8b9296553cde1e29bd67f925d993b33a4e52bc8e6c78f283691f670856` |
| `shizuku-v13.6.0.r1086.2650830c-release.apk` | `6e273ab0e991c4e79bc8b1bbb9b9dd739ccac1a8712a541a214078886b7b790f` |
