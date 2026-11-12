# 三版本發布

使用者要求分別保存台灣測速版、Google 融合版與獨立 CP Google。

| 版本 | 功能 | 發布標籤 |
|---|---|---|
| CoPilot wide.51 | 保留內建台灣測速；Google SDK 使用獨立配套 | wide.51 |
| CoPilot wide.52 | Google 已內建；撤除台灣測速，只留神盾投屏 | wide.52 |
| CP Google 0.1.2 | 獨立 Google SDK 導航 App | cp-google-0.1.2 |

三者均以測試版發布，未宣稱完成實車／C4 驗收。APK 與先前交付檔案逐位元相同；保留原簽章，不使用或提交私人簽署金鑰。每個 Release 附 APK、對應原始碼 ZIP、SHA256SUMS.txt、RELEASE_MANIFEST.json。

`publish.py` 從既有公開 wide.46 Release 的固定 SHA-256 基底，加上此處的壓縮差異資料，還原精確簽署檔。所有基底與還原結果皆核對 SHA-256。原始碼 ZIP 固定到各版本原提交，不包含本次傳輸資料。工作流程只允許新增 Release，遇到既有同名 Release 或 tag 即停止，不覆蓋。

發布完成後請至 [Releases](https://github.com/FANHAOHSIANG/copilot-Tw/releases) 選擇對應版本。
