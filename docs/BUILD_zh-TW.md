> 最新 wide.40：提醒可用連續GPS補足方向，高架／平面模糊時仍提示同向候選；依點位道路標籤播報「前方平面道路測速」或「前方高架道路測速」。未分類仍用原A聲音。這只影響提醒，C4仍採原確認條件。30項離線檢查通過，未實機驗證。[wide.40下載與說明](../variants/wide40/README.md)。以下保留既有操作與控制來源說明。

# 開發、重建與下載檔案

本儲存庫保存原 CP 搭子／Navipilot APK 的客製 Java、smali、資料與修改材料，並非原作者完整 Gradle 專案。GitHub 的一般 Gradle 建置方法不適用。

## wide.40

1. 下載 [wide.39 APK 與原始碼 ZIP](https://github.com/FANHAOHSIANG/copilot-Tw/releases/tag/wide.40)，核對同頁 SHA256SUMS。
2. ZIP 解開後，進入 `variants/wide40`。該目錄包含 Java、新舊掛點差異、完整受修改 smali、離線測試及 `rebuild.py`。
3. 準備 Python3、Java、Apktool3.0.3、Android build-tools（zipalign、lib/apksigner.jar）。如果重編 Java helper，另需 ECJ／D8 及 org.json。
4. 設定 `COPILOT_BASE_APK` 指向已下載的 wide.39 APK；也接受雜湊相符的原 wide.39。設定 `COPILOT_APKTOOL` 和 `COPILOT_BUILD_TOOLS`。
5. 私人簽章在本機設定 `COPILOT_SIGNING_KEY`、`COPILOT_KEY_ALIAS`、`COPILOT_STORE_PASSWORD`、`COPILOT_KEY_PASSWORD`，執行 `python3 rebuild.py`。

重建預設使用包內 smali；修改 Java 後需先重新編譯成對應 smali。`rebuild/` 不得已存在，以免覆蓋先前建置。原 APK 作為基底保留其他模組；此方式不是從原作者完整原始碼重新建置。

## 簽章

公開下載不含 `.jks`、私人金鑰與密碼。覆蓋更新需要原簽署金鑰，改用新金鑰會與原安裝簽章不相容。不要把金鑰提交到 GitHub。

## 發布檔案

`release/wide40` 保存已簽章 APK 的差分發布材料與雜湊。發布流程從已公開的 wide.39 基底還原**同一個**已交付 wide.40 APK，核對 SHA-256 後上傳 Release；不需要接觸私鑰，也不會重新簽章。差分材料不供一般使用者安裝，直接下載 Release 的完整 APK 即可。

原始碼 ZIP 取自發布提交的儲存庫快照，含最新版說明與修改材料；SHA256SUMS 與兩個下載檔一同產生。歷史版本不刪除。
