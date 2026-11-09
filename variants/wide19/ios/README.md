# Copilot tw iOS 0.1

iPhone／iPad 的原生 SwiftUI 專案。包含 Apple 地圖、GPS、前方固定測速提醒與紅光示範。地圖自動適配直橫畫面。資料是隨專案附上的警政署固定測速快照，資料來源與下載時間在 JSON metadata 中。

在 Mac 用支援 iOS 17 SDK 或更新版的 Xcode 開啟 `CopilotTw.xcodeproj`。選擇 CopilotTw scheme，接上 iPhone。在 Signing & Capabilities 選自己的 Apple Team。若 Bundle Identifier 已被使用，可自行改成專屬名稱。按 Run 安裝。App 顯示後按 GPS 允許精確位置。點「示範」可以在沒有 GPS 的情況看紅光變化。

此版在 App 畫面顯示提醒，位置背景權限與 C4 轉發尚未整合。Android 的 Shizuku、Stellar 及其分割投屏功能屬於 Android 版。iOS 專案需要在 macOS 環境完成 Xcode 編譯、簽署與裝置測試。
