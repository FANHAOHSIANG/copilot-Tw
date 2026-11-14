# Carrot Bridge wide.68

導航選單依序顯示高德車機版、高德一般版、Google 地圖（僅投屏）、Google 導航 NOO。已選來源的識別值維持原有對應。

調整投屏比例時，等待拖曳結束再調整目前的虛擬顯示與影像緩衝區。每個視窗最多有一個尺寸請求執行中。完成時會重新檢查視窗尺寸，避免較早發出的調整覆蓋最後的比例。等待調整或服務拒絕時，舊畫面維持比例並置中填滿，邊緣可能裁切。觸控使用同一個比例與偏移計算。尺寸調整本身不會要求重開外部 App，個別 App 仍可能因 Android 組態變更自行重建畫面。

建置使用官方 [wide.67 APK](https://github.com/FANHAOHSIANG/copilot-Tw/releases/tag/wide.67)。將 smali／baksmali 相依項放在工具目錄的 `deps/`，將 Android build tools 放在 `android-15/`。執行 `python3 variants/wide68/build.py BASE_APK TOOLS OUTPUT_APK` 會產生未簽章 APK。

已完成未簽章建置、DEX 結構與範圍檢查、16 KiB 對齊，以及 121 組視窗／緩衝區組合的填滿比例與座標換算檢查。待實機確認手機與車機冷啟動、拖曳分隔線連續縮放、橫直轉及縮放後的觸控。
