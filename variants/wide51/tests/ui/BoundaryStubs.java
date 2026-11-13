package com.navipilot.obf;

import org.json.JSONObject;

/** Host-only Android/runtime boundaries. No alert construction or production layout is mocked. */
final class WideVehiclePanel {
    static final class State {
        public double speed=Double.NaN, cruise=Double.NaN;
        public Boolean lateral, longitudinal;
    }
    static State current() { return new State(); }
}
final class WideGoogleNav {
    static JSONObject guidance() { return null; }
}
final class WideEnforcementRuntime {
    static WideEnforcementEngine.Frame current() { return null; }
}
final class WideLiveCameraFace {
    static int calls;
    static void render(WideCameraFace.Painter p,float w,float h,WideCameraFace.Model m,
                       long now,boolean demo,int retainedLimit) {
        calls++;
        p.rect(0,0,w,h,0,0xff30333b);
        p.text("舊版備援：未在此預覽驗證",10,30,10,0xffffd075,w-20,false);
        p.text("此區為邊界 stub，非實際畫面",10,48,9,0xffd6dce8,w-20,false);
    }
}

class WideCameraFallback {static class Advisory {String reason="附近測速 · 道路待確認 · 取締方向待確認",road="公道路 616 號前";} static Advisory value;static Advisory advisory(long t){return value;}}
