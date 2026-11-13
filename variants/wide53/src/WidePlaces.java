package com.navipilot.obf;
import android.app.*;
import android.content.*;
import android.net.Uri;
import android.view.*;
import android.widget.*;
/** Three user-owned text destinations. No geocoding or guessed coordinates. */
public final class WidePlaces {
 static SharedPreferences prefs(Context c){return c.getSharedPreferences("copilot_destinations",0);}
 public static View strip(Context c){LinearLayout row=new LinearLayout(c);row.setPadding(4,2,4,2);row.setBackgroundColor(WideUi.SURFACE);
  for(int i=0;i<3;i++){final int n=i;Button b=WideUi.button(c,prefs(c).getString("name"+i,"＋ 地址 "+(i+1)),WideUi.BLUE,v->{Activity a=WideVariant.activity(c);if(a!=null)open(a,n);});
   b.setSingleLine();b.setEllipsize(android.text.TextUtils.TruncateAt.END);b.setOnLongClickListener(v->{Activity a=WideVariant.activity(c);if(a!=null)edit(a,n,()->b.setText(prefs(c).getString("name"+n,"＋ 地址 "+(n+1))));return true;});
   final SharedPreferences.OnSharedPreferenceChangeListener refresh=(p,key)->b.setText(prefs(c).getString("name"+n,"＋ 地址 "+(n+1)));
   b.addOnAttachStateChangeListener(new View.OnAttachStateChangeListener(){public void onViewAttachedToWindow(View v){prefs(c).registerOnSharedPreferenceChangeListener(refresh);refresh.onSharedPreferenceChanged(prefs(c),"");}public void onViewDetachedFromWindow(View v){prefs(c).unregisterOnSharedPreferenceChangeListener(refresh);}});
   LinearLayout.LayoutParams lp=new LinearLayout.LayoutParams(0,-1,1);lp.setMargins(2,0,2,0);row.addView(b,lp);
  }return row;
 }
 public static void showContext(Context c){Activity a=WideVariant.activity(c);if(a!=null)show(a);}
 public static void show(Activity a){LinearLayout box=new LinearLayout(a);box.setOrientation(1);box.setPadding(16,16,16,16);TextView hint=WideUi.text(a,"點選開啟目的地；長按可修改名稱與地址。",14,WideUi.INK,false);box.addView(hint);box.addView(strip(a),new LinearLayout.LayoutParams(-1,WideUi.dp(a,64)));new AlertDialog.Builder(a).setTitle("常用地址").setView(box).setNegativeButton("關閉",null).show();}
 static void edit(Activity a,int n,Runnable done){LinearLayout box=new LinearLayout(a);box.setOrientation(1);box.setPadding(24,8,24,8);EditText name=new EditText(a),address=new EditText(a);name.setHint("名稱，例如：健身房");address.setHint("完整地址或地點名稱");name.setSingleLine();address.setMaxLines(3);name.setText(prefs(a).getString("name"+n,""));address.setText(prefs(a).getString("address"+n,""));box.addView(name);box.addView(address);
  AlertDialog d=new AlertDialog.Builder(a).setTitle("地址 "+(n+1)).setView(box).setPositiveButton("儲存",null).setNegativeButton("取消",null).setNeutralButton("清除",(x,y)->{prefs(a).edit().remove("name"+n).remove("address"+n).apply();done.run();}).create();d.setOnShowListener(x->d.getButton(-1).setOnClickListener(v->{String text=address.getText().toString().trim(),label=name.getText().toString().trim();if(text.isEmpty()){address.setError("請輸入地址");return;}if(label.isEmpty())label="地址 "+(n+1);prefs(a).edit().putString("name"+n,label).putString("address"+n,text).apply();done.run();d.dismiss();}));d.show();
 }
 static void open(Activity a,int n){String address=prefs(a).getString("address"+n,"");if(address.isEmpty()){edit(a,n,()->{});return;}String pkg=WideVariant.packageName();Intent intent;
  if(pkg.equals(a.getPackageName())){prefs(a).edit().putString("pending_query",address).apply();intent=new Intent().setClassName(a,"com.navdashn.KeyEntryActivity");}
  else if(pkg.equals("com.google.android.apps.maps"))intent=new Intent(Intent.ACTION_VIEW,Uri.parse("google.navigation:q="+Uri.encode(address)+"&mode=d")).setPackage(pkg);
  else if(pkg.equals("com.autonavi.minimap"))intent=new Intent(Intent.ACTION_VIEW,Uri.parse("androidamap://poi?sourceApplication=CoPilot&keywords="+Uri.encode(address)+"&dev=0")).setPackage(pkg);
  else {intent=new Intent(Intent.ACTION_SEARCH).setPackage(pkg).putExtra("query",address);if(intent.resolveActivity(a.getPackageManager())==null){
   ((ClipboardManager)a.getSystemService(Context.CLIPBOARD_SERVICE)).setPrimaryClip(ClipData.newPlainText("目的地",address));new AlertDialog.Builder(a).setTitle("此地圖未提供地址搜尋入口").setMessage("地址已複製："+address+"\n請在地圖搜尋欄貼上並確認目的地。").setPositiveButton("知道了",null).show();return;
  }}
  WideDirect.launchMapIntent(intent,()->Toast.makeText(a,"目的地無法開啟，請檢查地圖與投屏連線",Toast.LENGTH_LONG).show());
 }
}
