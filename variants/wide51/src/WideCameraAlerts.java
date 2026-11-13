package com.navipilot.obf;
import android.content.Context;
import android.os.*;
import android.media.AudioAttributes;
import android.speech.tts.*;
import java.util.*;
import org.json.JSONObject;
/** Service-owned reminder clock. No steering, speed or navigation packet writes. */
final class WideCameraAlerts {
 private final Context context;
 private final Handler handler=new Handler(Looper.getMainLooper());
 private TextToSpeech tts;private boolean ready,closed;
 private String active="",lastRecord="";private long started,retryAt;
 private final HashMap<String,Long> spoken=new HashMap<>();
 private final Runnable tick=new Runnable(){public void run(){if(closed)return;try{sample();}catch(RuntimeException e){record("error",e.getClass().getSimpleName());}handler.postDelayed(this,500);}};
 WideCameraAlerts(Context c){context=c.getApplicationContext();}
 void start(){handler.removeCallbacks(tick);handler.post(tick);}
 void stop(){closed=true;handler.removeCallbacks(tick);if(tts!=null){tts.stop();tts.shutdown();tts=null;}ready=false;active="";}
 private void init(){if(tts!=null||closed)return;tts=new TextToSpeech(context,result->handler.post(()->{
  if(closed||tts==null)return;
  if(result!=TextToSpeech.SUCCESS){record("voice","中文語音初始化失敗");return;}
  Set<Voice> voices=tts.getVoices();Voice chosen=null;
  if(voices!=null)for(Voice v:voices)if(!v.isNetworkConnectionRequired()&&"zh".equals(v.getLocale().getLanguage())){if(chosen==null||"TW".equals(v.getLocale().getCountry()))chosen=v;}
  if(chosen==null){record("voice","未安裝離線中文語音");return;}
  ready=tts.setVoice(chosen)!=TextToSpeech.ERROR;
  tts.setAudioAttributes(new AudioAttributes.Builder().setUsage(AudioAttributes.USAGE_ASSISTANCE_NAVIGATION_GUIDANCE).setContentType(AudioAttributes.CONTENT_TYPE_SPEECH).build());
  tts.setOnUtteranceProgressListener(new UtteranceProgressListener(){
   public void onStart(String id){}
   public void onDone(String id){handler.post(()->{if(!closed&&id.equals(active)){spoken.put(id,SystemClock.elapsedRealtime());active="";record("voice","待確認提醒播放完成");}});}
   public void onError(String id){handler.post(()->{if(!closed&&id.equals(active)){active="";retryAt=SystemClock.elapsedRealtime()+5000;record("voice","播放失敗，稍後重試");}});}
  });
 }));}
 private void sample(){
  long now=SystemClock.elapsedRealtime();
  WideCameraFace.Model m=WideCameraDisplay.model(now);
  WideCameraFallback.Advisory a=WideCameraFallback.advisory(now);
  boolean known=m.voiceCameraId!=null&&!m.voiceCameraId.isEmpty();
  if(!WideCamera.running||!WideCameraVoice.enabled(context)||known||a==null){
   if(!active.isEmpty()&&tts!=null){tts.stop();active="";}
   if(WideCamera.running&&known)WideCameraVoice.observe(context,m.voiceCameraId,now);
  }else{
   if(!active.isEmpty()&&(!active.equals(a.id)||now-started>15000)){tts.stop();active="";retryAt=now+5000;}
   Long previous=spoken.get(a.id);
   if(active.isEmpty()&&(previous==null||now-previous>120000)&&now>=retryAt){
    init();if(ready){active=a.id;started=now;
     String text=a.reason.startsWith("前方")?"前方測速照相，取締方向待確認":"附近測速照相，道路或取締方向待確認";
     if(tts.speak(text,TextToSpeech.QUEUE_FLUSH,null,active)==TextToSpeech.ERROR){active="";retryAt=now+5000;record("voice","播放請求失敗");}
    }
   }
  }
  String summary=known?"前方測速："+m.voiceCameraId:a!=null?a.reason+" · "+a.road:m.state;
  if(!Objects.equals(summary,lastRecord)){lastRecord=summary;record("decision",summary);}
  Iterator<Map.Entry<String,Long>> it=spoken.entrySet().iterator();while(it.hasNext())if(now-it.next().getValue()>120000)it.remove();
 }
 private void record(String kind,String state){if(!WideBridgeLog.recording())return;try{WideBridgeLog.event("camera_alert",new JSONObject().put("kind",kind).put("state",state).put("gps",WideCamera.gps()));}catch(Exception ignored){}}
}
