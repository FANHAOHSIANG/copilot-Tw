package com.navdashn;
import android.app.Activity;import android.content.Intent;
import com.navipilot.google.GoogleKeyGate;import com.navipilot.google.GoogleKeySettings;
/** Also guards Android restoring Main/Guidance directly after process death. */
public final class GoogleReady {
 public static boolean ensure(Activity activity){
  try{GoogleKeyGate.Result r=GoogleKeySettings.initialize(activity);if(r==GoogleKeyGate.Result.INSTALLED||r==GoogleKeyGate.Result.UNCHANGED)return true;}catch(Exception ignored){}
  activity.startActivity(new Intent(activity,KeyEntryActivity.class));activity.finish();return false;
 }
 private GoogleReady(){}
}
