package com.navipilot.obf;
import org.json.JSONObject;
class WideCameraFace {static class Model {String voiceCameraId,state="searching";}}
class WideCameraDisplay {static WideCameraFace.Model value=new WideCameraFace.Model();static WideCameraFace.Model model(long now){return value;}}
class WideCameraFallback {static class Advisory {String id="test",reason="附近測速 · 道路待確認",road="test road";}static Advisory value;static Advisory advisory(long now){return value;}}
class WideCamera {static boolean running=true;static String gps(){return "test gps";}}
class WideCameraVoice {static boolean enabled=true;static int calls;static boolean enabled(android.content.Context c){return enabled;}static void observe(android.content.Context c,String id,long now){calls++;}}
class WideBridgeLog {static boolean recording(){return false;}static void event(String s,JSONObject j){}}
