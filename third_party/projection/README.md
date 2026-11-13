# 投屏管理工具

本次附上使用者提供的原版 APK，沒有修改、解包重簽或植入 CoPilot。

| 工具 | 版本 | 上游與來源 |
| --- | --- | --- |
| Shizuku | 13.6.0.r1086.2650830c | [官方發布](https://github.com/RikkaApps/Shizuku/releases/tag/v13.6.0)、[對應原始碼](https://github.com/RikkaApps/Shizuku/tree/v13.6.0) |
| Stellar | 1.1 / 101000 | [官方發布](https://github.com/roro2239/Stellar/releases/tag/v1.1%28101000%29)、[對應原始碼](https://github.com/roro2239/Stellar/tree/v1.1%28101000%29) |

兩個檔案均通過 APK 簽章驗證；發布流程另外核對與使用者提供檔案一致的完整 SHA-256。校驗值見 `release/wide53/manifest.json`。發行頁附有各自授權全文；原作者保有其商標與權利，不代表上游替本 CoPilot 版本背書。

在 CoPilot「更多 → 投屏安裝與授權」選擇使用的管理工具。擇一啟動並授權 CoPilot；Stellar 需開啟 Shizuku 相容層。已有服務且授權可用時，自動連接投屏，不需要再開管理工具。服務未啟動時可自動開工具，仍須遵循工具與 Android 的配對／啟動流程；不會繞過權限，也不承諾無線偵錯失效或重開機後可以靜默重新取得權限。
