package com.navipilot.obf;
import android.app.Activity;
import android.content.Intent;
import android.content.ActivityNotFoundException;
import android.net.Uri;
import android.provider.Settings;
import android.widget.Toast;
public final class WideApps {
    private static final String SHIELD="tw.com.ainvest.outpack";
    public static void openShield(Activity a) {
        Intent i=a.getPackageManager().getLaunchIntentForPackage(SHIELD);
        if(i==null){Toast.makeText(a,"尚未安裝神盾測速照相，請先在車機安裝官方 App",Toast.LENGTH_LONG).show();return;}
        launch(a,i);
    }
    public static void shieldSettings(Activity a) {
        try {a.getPackageManager().getPackageInfo(SHIELD,0);}
        catch(android.content.pm.PackageManager.NameNotFoundException e){Toast.makeText(a,"請先安裝神盾測速照相",Toast.LENGTH_LONG).show();return;}
        launch(a,new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS,Uri.parse("package:"+SHIELD)));
    }
    private static void launch(Activity a,Intent i){
        try {a.startActivity(i);}
        catch(ActivityNotFoundException e){Toast.makeText(a,"此車機無法開啟該頁面",Toast.LENGTH_LONG).show();}
        catch(SecurityException e){Toast.makeText(a,"車機限制開啟該 App，請從桌面開啟",Toast.LENGTH_LONG).show();}
    }
}
