package com.navdashn;
import android.app.Activity;
import android.os.Bundle;
import android.content.Intent;
import android.widget.*;
import com.navipilot.google.GoogleKeyGate;
import com.navipilot.google.GoogleKeySettings;
/** Runs before any Google map is inflated. Uses the owner's local key. */
public final class KeyEntryActivity extends Activity {
 @Override public void onCreate(Bundle state){
  super.onCreate(state);
  LinearLayout root=new LinearLayout(this);root.setOrientation(LinearLayout.VERTICAL);root.setPadding(32,32,32,32);
  TextView title=new TextView(this);title.setText("CP Google 導航\n使用自己的 Google Cloud 金鑰。導航路線與轉彎透過本機通道交給 CP 搭子。\n這與官方 Google Maps App 的投屏為不同來源。");title.setTextSize(20);root.addView(title);
  Button settings=new Button(this);settings.setText("設定／更換 Google 金鑰");settings.setOnClickListener(v->GoogleKeySettings.show(this));root.addView(settings);
  Button start=new Button(this);start.setText("開始 Google 導航");start.setOnClickListener(v->{
   try{GoogleKeyGate.Result r=GoogleKeySettings.initialize(this);
    if(r==GoogleKeyGate.Result.DISABLED){GoogleKeySettings.show(this);return;}
    if(r==GoogleKeyGate.Result.RESTART_REQUIRED){Toast.makeText(this,"金鑰已變更，請完整關閉並重開 CP Google 導航。",Toast.LENGTH_LONG).show();return;}
    startActivity(new Intent(this,MainActivity.class));finish();
   }catch(Exception e){Toast.makeText(this,"無法初始化導航，請檢查金鑰設定。",Toast.LENGTH_LONG).show();}
  });root.addView(start);setContentView(root);
 }
}
