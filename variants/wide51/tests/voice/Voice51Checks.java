package com.navipilot.obf;
import android.os.*;import android.speech.tts.*;import android.content.Context;
public class Voice51Checks {
 static int n;static void check(boolean b,String m){n++;if(!b)throw new AssertionError(m);}
 static void step(long t){SystemClock.now=t;Handler.runReady();}
 public static void main(String[] args){
  WideCameraAlerts a=new WideCameraAlerts(new Context());WideCameraFallback.value=new WideCameraFallback.Advisory();a.start();step(10000);step(10500);
  TextToSpeech t=TextToSpeech.last;check(t.speakCalls==1,"service clock speaks without a view");check(t.text.contains("待確認"),"uncertainty spoken");
  t.listener.onDone(t.utterance);step(10500);step(11000);check(t.speakCalls==1,"successful reminder deduped");
  WideCameraFallback.value.id="second";step(11500);check(t.speakCalls==2,"new target speaks");
  t.listener.onError(t.utterance);step(11500);step(12000);check(t.speakCalls==2,"failure backoff");step(16500);check(t.speakCalls==3,"failed speech retried");
  WideCameraFallback.value=null;step(17000);check(t.stopCalls>0,"lost target cancels speech");
  WideCameraDisplay.value.voiceCameraId="confirmed";step(17500);check(WideCameraVoice.calls>0,"confirmed camera service trigger");
  WideCameraDisplay.value.voiceCameraId=null;WideCameraFallback.value=new WideCameraFallback.Advisory();WideCameraFallback.value.id="third";WideCameraVoice.enabled=false;step(18000);check(t.speakCalls==3,"mute respected");
  a.stop();int before=t.speakCalls;step(20000);check(t.shutdownCalls==1&&t.speakCalls==before,"service teardown cancels timer");
  System.out.println("PASS "+n+" service voice checks (mock TTS, no audible device claim)");
 }
}
