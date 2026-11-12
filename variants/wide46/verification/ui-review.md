# Wide46 右側儀表板 UI QA

核對日期：2026-11-12。這是 **示意資料／同繪圖程式** 的主機檢查，不是 Android 裝置截圖或道路測試。

## 結果

目前 production `WideDashboardFace.drawState` 在已列尺寸與情境下通過 316 項語義／字形 fitting 斷言，13 個記錄布局沒有可見字形包圍框重疊或超出整張卡片邊界。長字串依實際 `maxWidth` 近似 END ellipsis，沒有把未截字的文字直接塞進 SVG。

| 檢查 | 已觀察到的結果 |
| --- | --- |
| 測速＋科技執法 | 測速主提醒與底部科技執法條同時存在 |
| 只有科技執法 | 確認前方的執法點使用主提醒，資料本身不產生速限標誌 |
| Google 轉彎＋科技執法 | 180 公尺轉彎保留主提醒，650 公尺執法保留次提醒 |
| 方向待確認 | 顯示「同路前方 · 方向待確認」，沒有升成已確認的「前方科技執法」 |
| 寬卡與窄卡 | 同上四情境均跑過 360×440 與 240×320 的 production 布局 |
| 完整卡片下限 | 230×280 維持所有主要資訊，字形不重疊 |
| 時效 | Alert 在 exact expiry 邊界保留，下一毫秒撤銷，反覆繪圖不能續期 |
| 優先級邊界 | 200 公尺 Google 轉彎優先；201 公尺時確認前方執法可作主提醒；1,001 公尺測速不掩蓋近距離轉彎 |
| 車況未知 | 不把未知車速補成 0，也不把未知橫／縱向狀態補成已／未接管 |
| 暫存限速 | 保留「暫存速限」標籤，與科技執法資料分開呈現 |
| 參考公告次提醒 | 真實引擎判為 REFERENCE 的純測速參考記錄保留「執法公告參考」，不升成「鄰近科技執法」 |

## 已回報並修正的問題

初讀舊稿時，240 dp 寬的三位數車速可能延伸至 x132，而 `km/h` 從 x103.2 開始，存在重疊風險。主程式維護者已把單位改到數字下方。此批預覽與 strict 檢查使用的是修正後 production source；`ui-checks.json` 保留編譯來源 SHA-256，沒有把未渲染的舊稿假裝成前後截圖。

次提醒條原先把所有非確認、非沿路資料縮成「鄰近科技執法」，可能丟失歷史／未啟用等 REFERENCE 限定。維護者已讓 REFERENCE 顯示「執法公告參考」，並以真實引擎產生的參考 Alert 加入回歸檢查。

目前圖中 108 km/h 是明確的邊界測試值，不是實際 C4／GPS 車速。科技執法 Alert 是真實 production 引擎讀入 synthetic 公告、道路與三筆定位之後得到的結果，沒有直接呼叫或改開私有建構子。

## 預覽與重跑

- 總覽：`ui-contact-sheet.png`。
- 單張：`ui-camera-wide.svg`、`ui-enforcement-wide.svg`、`ui-google-wide.svg`、`ui-unknown-wide.svg`；對應 `-phone.svg` 為窄卡。每張均有同名 PNG。
- 邊界：`ui-minimum-full.svg`、`ui-fallback-width.svg`、`ui-unknown-vehicle.svg`、`ui-retained-limit.svg`、`ui-reference-secondary.svg`。
- 結果與字形座標：`ui-checks.json`。

```sh
python variants/wide46/tests/ui/run_checks.py --strict-layout
```

## 實際限制

字型採 Noto Sans CJK TC Bold，數值縮字及省略號依 Android painter 的規則近似執行；字形尺寸不是 Android Canvas 的像素保證。仍需以裝置檢查字型替換、實際 dp 分配、左右畫面比例、螢幕方向與觸控。

寬度小於 230 或高度小於 280 時，production 會退回 `WideLiveCameraFace`。本測試對舊版備援使用醒目標示的 stub，**未視覺驗證其車況、Google 轉彎或舊測速布局**；只檢查分支與新科技執法條仍執行。左側導航畫面也沒有在這些右卡圖中冒充 production 渲染。

本報告未測試 Google API 授權、資料庫實際位置、Android 背景服務、GPS 行進結果、語音播放或 C4 控制傳輸；這些由對應核心與整合驗證負責。
