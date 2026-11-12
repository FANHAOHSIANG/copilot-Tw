package com.navipilot.obf;
import android.content.Context;
import org.json.JSONObject;
final class WideCamera { static volatile boolean running = true; }
final class WideCameraVoice { static boolean enabled(Context context) { return true; } }
final class WideBridgeLog { static void event(String type, JSONObject data) { } }
