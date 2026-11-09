# 原始碼與重建

本儲存庫保存可重建 Java／smali 補丁，沒有原作者完整 Android 專案。

## 檔案配置

請從 Releases 下載對應 `CoPilot-Tw-wide.16-*-public-modifications.zip`，解壓到乾淨目錄。修改包保留必要基底 APK、已產生 helper smali、驗證紀錄；HCOP 包還包含離線圖磚和來源快照。Git 中的 `variants/` 是可瀏覽程式與文件，不包含所有大型二進位資產。

## 簽署金鑰

公開包已排除簽署私鑰，包含巢狀 ZIP 內的金鑰。原 README 所稱「附測試簽章／金鑰」只適用原私人修改包，不適用本公開存檔。APK 本身未重新簽章。

要覆蓋更新原測試版，必須自行保管並提供原簽署金鑰。既有腳本使用以下路徑：

- Auto／Phone：`project/wide-build/signing/navipilot-wide-test.jks`
- HCOP Taiwan：`source/tw14/project/wide-build/signing/navipilot-wide-test.jks`

將私人金鑰放入本機路徑，不要提交；`.gitignore` 已排除常見私鑰格式。改用新金鑰會與已安裝版簽章不相容。

## Auto／Phone

需要 JDK、Python 3、ripgrep、ECJ 3.39、Apktool 3.0.3、Android API 35 及 Build Tools 36。依 `adaptive16-src/README_zh-TW.md` 準備 tools 相對路徑。

```sh
bash adaptive16-src/build.sh auto
# 或
bash adaptive16-src/build.sh phone
```

## HCOP Taiwan

需要 Python 3、Java 17、ripgrep，依原說明準備工具並提供私人簽署金鑰：

```sh
bash work/src/setup_tools.sh
bash work/src/rebuild.sh
```

既有離線圖磚可直接重用；重新生成圖資的方法、固定快照、資料來源與授權見版本 README。修改資料日期時須同步處理程式有效期限並重新驗證。

此次匯入沒有重跑 Android 編譯與實車測試；隨附 `*-build/` 或 `work/build/` 報告是原版本紀錄。
