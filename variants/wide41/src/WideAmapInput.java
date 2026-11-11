package com.navipilot.obf;
/** Diagnostics only: no payload values, credentials, route coordinates or source bypass. */
public final class WideAmapInput {
 private static long seen,accepted,rejected,lastAt,parsedAt,forwardAt;
 private static String selected="",sender="",action="",key="",stream="";
 public static synchronized void reset(){seen=accepted=rejected=lastAt=parsedAt=forwardAt=0;selected=sender=action=key=stream="";}
 public static synchronized void observed(String selection,String producer,String name,boolean allowed){
  seen++;if(allowed)accepted++;else rejected++;
  selected=selection;sender=producer==null||producer.length()==0?"系統未提供來源套件":producer;action=name;lastAt=System.currentTimeMillis();
 }
 public static synchronized void parsed(int type){key=type<0?"缺少 KEY_TYPE，不能視為導航資料":String.valueOf(type);parsedAt=System.currentTimeMillis();}
 public static synchronized void forwarded(String name){stream=name;forwardAt=System.currentTimeMillis();}
 public static synchronized String status(String base){
  if(seen==0)return base+"\n尚未收到導航廣播；開啟地圖不代表已有導航資料";
  long now=System.currentTimeMillis();
  return base+"\n接收 "+seen+"／允許 "+accepted+"／過濾 "+rejected+" · "+Math.max(0,(now-lastAt)/1000)+" 秒前"
   +"\n選擇："+selected+"\n來源："+sender+"\n廣播："+action
   +"\n解析入口："+(parsedAt==0?"尚未進入":key+" · "+Math.max(0,(now-parsedAt)/1000)+" 秒前")
   +"\n通過來源過濾："+(forwardAt==0?"尚無可送出的資料":stream+" · "+Math.max(0,(now-forwardAt)/1000)+" 秒前")
   +"\n以上是手機端處理狀態，不代表 C4 已收到。";
 }
}
