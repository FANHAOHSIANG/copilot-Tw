package com.navipilot.obf;
import android.app.*;
import android.content.*;
import android.view.*;
import android.widget.*;
import java.lang.reflect.*;
/** UI-only hooks for the pinned Google module; existing navigation contracts are retained. */
public final class WideGoogleUi {
 private static View find(Activity a,String name){int id=a.getResources().getIdentifier(name,"id",a.getPackageName());return id==0?null:a.findViewById(id);}
 public static void install(Activity a){
  for(String name:new String[]{"helpButton","voiceSearchButton","guidanceHelpButton"}){View v=find(a,name);if(v!=null){v.setVisibility(View.GONE);v.setOnClickListener(null);}}
  View root=a.findViewById(android.R.id.content);if(root!=null)root.setBackgroundColor(WideUi.BG);
  View status=find(a,"navStatusText");
  if(status!=null && status.getParent() instanceof LinearLayout){LinearLayout box=(LinearLayout)status.getParent();
   if(box.findViewWithTag("wide53-key-settings")==null){Button key=WideUi.button(a,"Google 金鑰設定",WideUi.BLUE,v->{try{Class.forName("com.navipilot.google.GoogleKeySettings").getMethod("show",Activity.class).invoke(null,a);}catch(Exception e){Toast.makeText(a,"無法開啟設定",0).show();}});key.setTag("wide53-key-settings");box.addView(key,new LinearLayout.LayoutParams(-1,WideUi.dp(a,44)));}
  }
  View input=find(a,"searchInput");if(input instanceof EditText){((EditText)input).setHint("想去哪裡？搜尋地址或地點");((EditText)input).setTextSize(17);}
  View search=find(a,"searchButton");
  if(search!=null&&search.getParent() instanceof ViewGroup){ViewGroup card=(ViewGroup)((View)search.getParent()).getParent();
   if(card.getParent() instanceof View && ((View)card.getParent()).getParent() instanceof LinearLayout){
    View whole=(View)card.getParent();LinearLayout list=(LinearLayout)whole.getParent();
    if(list.indexOfChild(whole)>0){list.removeView(whole);list.addView(whole,0);}
   }
  }
 }
 public static void keyScreen(Activity a){
  View content=a.findViewById(android.R.id.content);if(!(content instanceof ViewGroup))return;
  ViewGroup group=(ViewGroup)content;if(group.getChildCount()==0||!(group.getChildAt(0) instanceof LinearLayout))return;
  LinearLayout box=(LinearLayout)group.getChildAt(0);box.setBackgroundColor(WideUi.BG);int pad=WideUi.dp(a,20);box.setPadding(pad,pad,pad,pad);
  for(int i=0;i<box.getChildCount();i++){View v=box.getChildAt(i);if(v instanceof Button){Button b=(Button)v;b.setTextColor(WideUi.BLUE);b.setTextSize(16);b.setAllCaps(false);b.setBackground(WideUi.shape(a,WideUi.SURFACE,WideUi.EDGE,12));LinearLayout.LayoutParams lp=new LinearLayout.LayoutParams(-1,WideUi.dp(a,52));lp.topMargin=WideUi.dp(a,12);b.setLayoutParams(lp);}else if(v instanceof TextView){((TextView)v).setTextColor(WideUi.INK);((TextView)v).setTextSize(19);}}
  // A restored, valid key opens the selected internal map automatically.
  try{Object result=Class.forName("com.navipilot.google.GoogleKeySettings").getMethod("initialize",Context.class).invoke(null,a);
   String state=String.valueOf(result);
   if(state.equals("INSTALLED")||state.equals("UNCHANGED")){
    String screen="com.navdashn.MainActivity";
    try{Class<?> nav=Class.forName("com.navdashn.navigation.NavController");Object instance=nav.getField("INSTANCE").get(null);if(Boolean.TRUE.equals(nav.getMethod("isNavigating").invoke(instance)))screen="com.navdashn.GuidanceActivity";}catch(Exception ignored){}
    // A shortcut must show its search even if an older route is still active.
    if(!WidePlaces.prefs(a).getString("pending_query","").isEmpty())screen="com.navdashn.MainActivity";
    a.startActivity(new Intent().setClassName(a,screen));a.finish();
   }
  }catch(Exception ignored){} // Keep the visible gate when setup is missing/invalid.

 }
 public static void resume(Activity a){install(a);View input=find(a,"searchInput");if(!(input instanceof EditText))return;
  String query=WidePlaces.prefs(a).getString("pending_query","");if(query.isEmpty())return;
  WidePlaces.prefs(a).edit().remove("pending_query").apply();((EditText)input).setText(query);View search=find(a,"searchButton");if(search!=null)search.performClick();
 }
 public static boolean favorite(Activity a,Object place,boolean saved){try{
  String name=(String)place.getClass().getMethod("getName").invoke(place),address=(String)place.getClass().getMethod("getAddress").invoke(place);
  LinearLayout box=new LinearLayout(a);box.setOrientation(1);int pad=WideUi.dp(a,18);box.setPadding(pad,pad,pad,pad);box.setBackgroundColor(WideUi.BG);
  TextView title=WideUi.text(a,name,21,WideUi.INK,true),subtitle=WideUi.text(a,address,14,WideUi.MUTED,false);box.addView(title);box.addView(subtitle);
  String[] choices={saved?"移除收藏":"儲存到收藏","設為地址 1","設為地址 2","設為地址 3"};
  AlertDialog dialog=new AlertDialog.Builder(a).setTitle("地點選項").setView(box).setNegativeButton("取消",null).create();
  for(int n=0;n<choices.length;n++){final int i=n;box.addView(WideUi.button(a,choices[n],WideUi.BLUE,v->{
   if(i==0){try{Method m=a.getClass().getDeclaredMethod(saved?"removeFavoriteOriginal":"addFavoriteOriginal",place.getClass());m.setAccessible(true);m.invoke(a,place);}catch(Exception e){Toast.makeText(a,"儲存失敗，請重試",0).show();}}
   else{WidePlaces.prefs(a).edit().putString("name"+(i-1),name).putString("address"+(i-1),address==null||address.trim().isEmpty()?name:address).apply();Toast.makeText(a,"已設為地址 "+i,0).show();}
   dialog.dismiss();
  }),new LinearLayout.LayoutParams(-1,WideUi.dp(a,48)));}
  dialog.show();return true;
 }catch(Exception e){Toast.makeText(a,"無法讀取地點，請重新搜尋",0).show();return true;}}
}
