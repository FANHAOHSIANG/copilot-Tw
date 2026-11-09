from pathlib import Path
import shutil
p=Path('work/src')
for n in ['WideBridge.java','WideBridgeLog.java','WideSettings.java','WideCamera.java','WideCameraPanel.java','WideCameraFace.java','WideRoad.java']:
 shutil.copy('source/tw14/bridge-src/'+n,p/n)
f=p/'WideBridge.java';s=f.read_text();a=s.index(' public static synchronized void init(');b=s.index(' public static boolean enabled()',a)
s=s[:a]+''' public static synchronized void init(Context c){
  if(started)return;started=true;context=c.getApplicationContext();WideBridgeLog.init(context);WideHcop.init(context);enabled=false;
 }
'''+s[b:]
s=s.replace('private static final class Pending {String host;int limit,distance;long time;}','private static final class Pending {String host;int road,limit,distance;boolean sdi;long time;}')
s=s.replace('enabled=value;tracker.reset();','enabled=value;WideHcop.clear();tracker.reset();')
a=s.index(' public static void accept(');b=s.index(' public static JSONObject merge(',a)
s=s[:a]+''' public static void accept(WideCameraEngine.Fix f){WideHcop.accept(f);}
 public static void clear(){WideHcop.clear();}
 public static WideRoad.Match current(){
  WideHcopRoad.Decision d=WideHcop.current();WideRoad.Corridor c=null;
  if(d.confirmed&&d.camera!=null){c=new WideRoad.Corridor();c.id=d.camera.id;c.road=d.camera.road;c.limit=d.camera.limit;c.lat=d.camera.lat;c.lon=d.camera.lon;}
  return new WideRoad.Match(c,d.distance,d.direction,d.reason,d.time);
 }
'''+s[b:]
s=s.replace('WideRoad.Match m=current();JSONObject out=WideSpeedMerge.merge(original,fresh,m);','WideHcopRoad.Decision m=WideHcop.current();JSONObject out=WideHcopMerge.merge(original,fresh,m);')
s=s.replace('long stamp=m.camera!=null?wall-Math.max(0,mono-m.time):wall;','long stamp=m.confirmed?wall-Math.max(0,mono-m.time):wall;')
s=s.replace('(out.has("road_limit_kph")||out.has("current_kph"))','out.has("current_kph")')
s=s.replace('sdi!=null?"測速資料已排入傳送":"測速撤銷／原有速度資料已排入"','value!=null&&(sdi!=null||value.has("road_limit_kph"))?"速限資料已排入傳送":"速限撤銷已排入"')
s=s.replace('if(enabled&&ok&&sdi!=null){Pending p=new Pending();p.host=host+":"+port;p.limit=sdi.optInt("speed_limit_kph");p.distance=sdi.optInt("distance_m");p.time=now;', 'if(enabled&&ok&&value!=null&&(sdi!=null||value.has("road_limit_kph"))){Pending p=new Pending();p.host=host+":"+port;p.road=value.optInt("road_limit_kph",-1);p.sdi=sdi!=null;p.limit=sdi==null?0:sdi.optInt("speed_limit_kph");p.distance=sdi==null?0:sdi.optInt("distance_m");p.time=now;')
s=s.replace('if(sdi==null)return;','if(value==null)return;')
s=s.replace('||sdi.optInt("type",-1)!=1||sdi.optInt("speed_limit_kph")!=p.limit||sdi.optInt("distance_m")!=p.distance','||value.optInt("road_limit_kph",-1)!=p.road||(sdi!=null)!=p.sdi||(p.sdi&&(sdi.optInt("type",-1)!=1||sdi.optInt("speed_limit_kph")!=p.limit||sdi.optInt("distance_m")!=p.distance))')
s=s.replace('lastReceipt="C4 接收端已收到："+p.limit+" km/h · "+p.distance+" m（非執行確認）";','lastReceipt="C4 接收端已收到：道路 "+(p.road>0?p.road:"—")+" km/h"+(p.sdi?"；測速 "+p.limit+" km/h · "+p.distance+" m":"")+"（非執行確認）";')
a=s.index(' public static JSONObject decision()');s=s[:a]+''' public static JSONObject decision()throws JSONException{JSONObject j=WideHcop.json();j.put("enabled",enabled);return j;}
 public static String badge(){if(!enabled)return "預覽 · 高德來源";WideHcopRoad.Decision d=WideHcop.current();if(!d.confirmed)return "台灣暫無資料";long now=SystemClock.elapsedRealtime();return receiptAt>0&&now-receiptAt<5000?"最近已接收":"台灣待回報";}
 public static String report(){long now=SystemClock.elapsedRealtime();return "Navipilot wide.16-hcop-tw-test\\n來源："+(enabled?"HCOP 台灣道路／測速（測試）":"高德；台灣只預覽")+"\\n"+WideHcop.report()+"\\n導航通道：原有 Navi v2 / 7714\\n目標："+lastTarget+"\\n"+lastQueue+(queueAt>0?"（"+((now-queueAt)/1000)+" 秒前）":"")+"\\n"+lastReceipt+(receiptAt>0?"（"+((now-receiptAt)/1000)+" 秒前）":"")+"\\n佇列接受 "+queuedCount+" / 拒收 "+failedCount+" / 同序號接收確認 "+receivedCount+"\\n接收確認不代表已執行減速。\\n"+probeStatus+"\\n"+WideBridgeLog.status();}
}
''';f.write_text(s)
f=p/'WideCamera.java';s=f.read_text();a=s.index('    public static WideCameraFace.Model model()');b=s.index('    public static String gps()',a)
s=s[:a]+'''    public static WideCameraFace.Model model(){
        WideHcopRoad.Decision d=WideHcop.current();WideCameraFace.Model m=new WideCameraFace.Model();
        m.state=d.reason;m.footer=gps();m.badge=WideBridge.badge();m.title="前方測速";m.road=d.roadName();
        if(d.confirmed&&d.camera!=null){m.type=1;m.limit=d.camera.limit;m.distance=d.distance;m.title="同路段固定測速";m.road=d.camera.road;m.progress=1-d.distance/1500;m.roadMatched=true;}
        else {m.type=0;m.title=d.confirmed?"同路段暫無測速點":"等待道路確認";}
        return m;
    }
'''+s[b:];s=s.replace('Navipilot wide.14-tw-bridge','Navipilot wide.16-hcop-tw-test');f.write_text(s)
f=p/'WideCameraPanel.java';s=f.read_text().replace('private final Button gps,demo;','private final Button gps,demo;private final TextView roadLimit;')
s=s.replace('dashboard.invalidate();main.postDelayed(this,200);','roadLimit.setText(WideHcop.label());dashboard.invalidate();main.postDelayed(this,300);')
s=s.replace('addView(bar,new LayoutParams(-1,dp(40)));FrameLayout body=', 'addView(bar,new LayoutParams(-1,dp(40)));roadLimit=new TextView(c);roadLimit.setTextColor(0xffe7f4ff);roadLimit.setTextSize(14);roadLimit.setMaxLines(2);roadLimit.setEllipsize(TextUtils.TruncateAt.END);roadLimit.setPadding(dp(10),dp(3),dp(8),dp(3));roadLimit.setText("道路速限 —\\n等待定位");addView(roadLimit,new LayoutParams(-1,dp(49)));FrameLayout body=')
f.write_text(s)
f=p/'WideCameraFace.java';s=f.read_text().replace('m.type==0?"等待 GPS"','m.type==0?"—"').replace('"直線距離 · 道路待確認"','m.type==0?"等待同路段測速點":"直線距離 · 道路待確認"');f.write_text(s)
f=p/'WideBridgeLog.java';s=f.read_text().replace('wide.14','wide.16');f.write_text(s)
f=p/'WideSettings.java';s=f.read_text().replace('台灣測速 · 串接測試版','HCOP 台灣速限 · 測試版')
s=s.replace('左側高德車機版；右上測速面板；右下控制鈕。預設使用高德來源。開啟台灣來源後，通過道路配對的固定測速會替換原有測速資料；高德轉彎與路線維持原流程。','左側高德車機版；右上分開顯示道路速限與前方測速。預設使用高德來源；台灣資料先預覽。啟用台灣後，會取代道路速限與測速欄位；高德轉彎與路線繼續運作。')
s=s.replace('使用車機 GPS：每秒請求定位。串接只接受精度 ≤15 m、連續 3 次確認的同一道路段固定點。遇到路口、平行道路、高架疑慮、反向或 GPS 過期即撤銷測速。其他候選仍以直線距離顯示，並標示未串接。','採用 OSM 離線道路、HCOP 的 TDX 方向速限，以及警政署局部修正。定位需精度 ≤15 m、連續 3 次且移動 5 m。GPS 超過 3 秒、道路重疊或速限衝突時，不採用該筆速限。')
s=s.replace('固定測速：相機圖示與距離大字，500 m 內轉黃、200 m 內轉紅。區間測速：使用新北官方起終點，記錄到入口後顯示估計剩餘距離與速限通過時間尚餘。秒數歸零仍需遵守道路速限。','固定測速只顯示已確認同路段的點；距離沿道路計算，不跨路口猜路線。區間資料仍可在診斷查看；本版不將未配對的區間或固定點放到主要面板，也不傳送。')
s=s.replace('啟用台灣測速串接（測試）','啟用 HCOP 台灣道路速限＋測速（測試）').replace('切回高德測速來源','切回高德道路速限與測速')
s=s.replace('台灣模式：只有 226 / 1856 個固定點通過圖資初篩，行車時還需確認。未配對時撤銷測速，不自動改回高德測速。高德轉彎、路線與新鮮道路速限保留。重新啟動 App 會回到高德來源。','台灣模式缺少可靠資料時顯示 — 並撤銷該欄位，不以測速點猜整條道路速限，也不暗中切換來源。可手動切回高德。App 重啟回到高德；本包離線資料使用期限至 2027-02-15，之後需更新。')
s=s.replace('面板候選診斷（不同於串接判定）','原始點位診斷（不在主要面板顯示）')
s=s.replace('只取同一道路的路口間片段，不推測跨路口路線。資料快照不保證所有測速點仍在使用。','全台離線道路與路口間片段，不猜測跨路口路線。HCOP TDX 快照 2026-10-18；不將原版 800 m 圓形修正直接套給整條道路。資料快照不保證現場標誌未變更。')
s=s.replace('https://www.openstreetmap.org/copyright','https://www.openstreetmap.org/copyright\\nHCOP 程式與修正資料來源：https://github.com/henryopen/openpilot（MIT；圖資另依原授權）')
f.write_text(s)
