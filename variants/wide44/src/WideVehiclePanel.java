package com.navipilot.obf;
import java.util.Map;
/** Read-only view of existing C4 telemetry; every field expires independently. */
public final class WideVehiclePanel {
 public static final class State {public double speed=Double.NaN,cruise=Double.NaN;public Boolean lateral,longitudinal;long speedExpiry,controlExpiry,cruiseExpiry;}
 private static volatile State latest=new State();
 static double number(Object v,double scale){if(!(v instanceof Number))return Double.NaN;double n=((Number)v).doubleValue()*scale;return Double.isFinite(n)&&n>=0&&n<=360?n:Double.NaN;}
 public static void update(zg telemetry){State s=new State();long now=System.nanoTime()/1000000;
  if(telemetry!=null){vg cs=telemetry.b("carState"),cc=telemetry.b("carControl"),ss=telemetry.b("selfdriveState");
   if(cs!=null&&cs.a!=null&&cs.a.c!=null){s.speed=number(cs.a.c.get("vEgo"),3.6);s.speedExpiry=Math.min(cs.c,now+3000);}
   if(cc!=null&&cc.a!=null&&cc.a.c!=null){Map m=cc.a.c;Object l=m.get("latActive"),v=m.get("longActive");s.lateral=l instanceof Boolean?(Boolean)l:null;s.longitudinal=v instanceof Boolean?(Boolean)v:null;s.controlExpiry=Math.min(cc.c,now+3000);}
   if(ss!=null&&ss.a!=null&&ss.a.c!=null){s.cruise=number(ss.a.c.get("vCruise"),1);s.cruiseExpiry=Math.min(ss.c,now+3000);}
  }latest=s;
 }
 public static State current(){State old=latest,s=new State();long now=System.nanoTime()/1000000;if(now<old.speedExpiry)s.speed=old.speed;if(now<old.cruiseExpiry)s.cruise=old.cruise;if(now<old.controlExpiry){s.lateral=old.lateral;s.longitudinal=old.longitudinal;}return s;}
 private WideVehiclePanel(){}
}
