# Wide46 儀表板繪圖檢查

執行 `python variants/wide46/tests/ui/run_checks.py`，必要時加上 `--strict-layout` 讓文字越界或字形包圍框重疊造成失敗。

測試直接編譯 production `WideDashboardFace.drawState`、`WideEnforcementLabels`、`WideEnforcementEngine` 與道路幾何程式。科技執法的 Alert 經由 synthetic JSON 公告、道路及三筆前進定位取得，沒有繞過私有建構子。車況與 Google 導航提供明確示意值；Android runtime 邊界以小型 stub 隔離。

SVG 與 PNG 標明「示意資料／同繪圖程式」，不是裝置截圖。文字採 Noto Sans CJK TC Bold 測量、先依 production 數值規則縮字，再按 maxWidth 取 END 省略號；字型近似 Android，不能宣稱像素相同。可見字形包圍框會記錄到 `verification/ui-checks.json`，用於檢查 baseline、重疊與邊界。

`WideLiveCameraFace` 舊備援由醒目的占位 stub 取代，**它的版面未經這套預覽驗證**。測試只確認退回該分支及新的科技執法提示條仍被畫出。左側導航畫面、觸控、螢幕方向、系統縮放及 Android Canvas 字型仍需裝置驗證。

產物限定在 `variants/wide46/verification/ui-*`。寬卡 360×440、手機卡 240×320、完整卡門檻 230×280，以及 fallback 邊界都納入；主畫面的 dp 分配若改變，請補相應尺寸。所有預覽與檢查都不寫入車況、不傳控制資料。
