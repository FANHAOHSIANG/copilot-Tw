package com.navipilot.obf;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.ActivityNotFoundException;
import android.content.DialogInterface;
import android.content.Intent;
import android.view.View;
import android.widget.Toast;
import com.navdashn.navigation.NavController;

public final class WideDiagnosticActions implements View.OnClickListener {
    private static volatile String searchStatus = "本次啟動尚無搜尋結果";

    public static void searchFailed(int code) {
        searchStatus = "搜尋失敗，狀態碼 " + code;
        WideBridgeLog.event("google_search_failure", Integer.valueOf(code));
    }

    public static void searchSucceeded() {
        searchStatus = "已收到搜尋回應";
    }

    @Override public void onClick(View view) {
        Activity activity = WideVariant.activity(view.getContext());
        if (activity == null || activity.isFinishing()) return;
        String record = WideBridgeLog.recording() ? "停止記錄" : "開始記錄";
        new AlertDialog.Builder(activity)
                .setTitle("診斷報告")
                .setItems(new String[]{record, "分享當下報告", "匯出報告與事件 ZIP（可能含位置與路線）"},
                        new DialogInterface.OnClickListener() {
                            @Override public void onClick(DialogInterface dialog, int choice) {
                                switch (choice) {
                                    case 0:
                                        WideBridgeLog.toggle();
                                        Toast.makeText(activity, WideBridgeLog.status(), Toast.LENGTH_SHORT).show();
                                        break;
                                    case 1:
                                        shareSnapshot(activity);
                                        break;
                                    case 2:
                                        WideBridgeLog.share(activity);
                                        break;
                                    default:
                                        break;
                                }
                            }
                        })
                .setNegativeButton("取消", null)
                .show();
    }

    private static void shareSnapshot(Activity activity) {
        Intent send = new Intent(Intent.ACTION_SEND).setType("text/plain")
                .putExtra(Intent.EXTRA_SUBJECT, "Carrot Bridge 診斷報告")
                .putExtra(Intent.EXTRA_TEXT, report());
        try {
            activity.startActivity(Intent.createChooser(send, "分享診斷報告"));
        } catch (ActivityNotFoundException unavailable) {
            Toast.makeText(activity, "沒有可分享報告的 App，可改用複製報告。", Toast.LENGTH_LONG).show();
        }
    }

    static String report() {
        return WideAmapLinkIntegration.extendReport(WideDiagnostics.report())
                + "\n\nGoogle 導航 NOO\n" + WideGoogleNav.status()
                + "\nSDK 狀態：" + NavController.INSTANCE.getState()
                + "\n地點搜尋：" + searchStatus
                + "\n\n事件記錄\n" + WideBridgeLog.status();
    }
}
