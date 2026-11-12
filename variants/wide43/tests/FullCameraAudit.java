package com.navipilot.obf;
import java.io.*;import java.util.*;import java.util.zip.GZIPInputStream;
public class FullCameraAudit {
 static File root;static int wx=-999,wy=-999;static WideHcopRoad.Data window;
 static Map<String,WideHcopRoad.Data> cache=new LinkedHashMap<String,WideHcopRoad.Data>(128,.75f,true){protected boolean removeEldestEntry(Map.Entry<String,WideHcopRoad.Data> e){return size()>128;}};
 static String str(DataInputStream in)throws Exception {byte[] b=new byte[in.readInt()];in.readFully(b);return new String(b,"UTF-8");}
 static String[] strings(DataInputStream in)throws Exception {String[] a=new String[in.readInt()];for(int n=0;n<a.length;n++)a[n]=str(in);return a;}
 static double[][] line(DataInputStream in)throws Exception {double[][] a=new double[in.readInt()][2];for(double[] p:a){p[0]=in.readDouble();p[1]=in.readDouble();}return a;}
 static WideHcopRoad.Data tile(int x,int y)throws Exception {
  String key=x+"_"+y;if(cache.containsKey(key))return cache.get(key);WideHcopRoad.Data data=new WideHcopRoad.Data();File f=new File(root,"tiles/"+key+".bin.gz");
  if(f.exists())try(DataInputStream in=new DataInputStream(new BufferedInputStream(new GZIPInputStream(new FileInputStream(f))))){
   for(int n=in.readInt();n>0;n--){WideHcopRoad.Road r=new WideHcopRoad.Road();r.id=str(in);r.names=strings(in);r.dir=in.readInt();r.grade=str(in);r.forward=in.readInt();r.backward=in.readInt();r.xy=line(in);r.start=in.readLong();r.end=in.readLong();r.minLon=r.minLat=Double.POSITIVE_INFINITY;r.maxLon=r.maxLat=Double.NEGATIVE_INFINITY;for(double[] p:r.xy){r.minLon=Math.min(r.minLon,p[0]);r.maxLon=Math.max(r.maxLon,p[0]);r.minLat=Math.min(r.minLat,p[1]);r.maxLat=Math.max(r.maxLat,p[1]);}r.bounded=true;data.roads.add(r);}
   for(int n=in.readInt();n>0;n--){WideHcopRoad.Camera c=new WideHcopRoad.Camera();c.id=str(in);c.edge=str(in);c.road=str(in);c.limit=in.readInt();c.lat=in.readDouble();c.lon=in.readDouble();c.dirs=new int[in.readInt()];for(int j=0;j<c.dirs.length;j++)c.dirs[j]=in.readInt();data.cameras.add(c);}
   for(int n=in.readInt();n>0;n--){WideHcopRoad.Official o=new WideHcopRoad.Official();o.id=in.readInt();o.names=strings(in);o.limit=in.readInt();o.xy=line(in);o.source=str(in);data.signs.add(o);}
  }
  cache.put(key,data);return data;
 }
 static WideHcopRoad.Data load(double lat,double lon)throws Exception {
  int x=(int)Math.floor(lon/.02),y=(int)Math.floor(lat/.02);if(x==wx&&y==wy&&window!=null)return window;
  WideHcopRoad.Data d=new WideHcopRoad.Data();Set<String> rr=new HashSet<>(),cc=new HashSet<>();Set<Integer> oo=new HashSet<>();
  for(int a=x-2;a<=x+2;a++)for(int b=y-2;b<=y+2;b++){WideHcopRoad.Data t=tile(a,b);for(WideHcopRoad.Road r:t.roads)if(rr.add(r.id))d.roads.add(r);for(WideHcopRoad.Camera c:t.cameras)if(cc.add(c.id))d.cameras.add(c);for(WideHcopRoad.Official o:t.signs)if(oo.add(o.id))d.signs.add(o);}
  wx=x;wy=y;window=d;return d;
 }
 static double length(WideHcopRoad.Road r){return WideRoad.project(r.xy,r.xy[0][1],r.xy[0][0],0).length;}
 static class Leg{WideHcopRoad.Road r;int dir;double len;Leg(WideHcopRoad.Road r,int d,double l){this.r=r;dir=d;len=l;}}
 static boolean same(WideHcopRoad.Road a,WideHcopRoad.Road b){for(String x:a.names)for(String y:b.names)if(x.equals(y)&&x.length()>1&&!x.matches("[0-9]+"))return true;return false;}
 static double[] at(WideHcopRoad.Road r,double station,int direction){
  // Same metric as projection, iterated at the generated latitude.
  double lat=r.xy[0][1];double[] out=null;
  for(int round=0;round<3;round++){double remain=station,sx=111320*Math.cos(Math.toRadians(lat));
   for(int i=1;i<r.xy.length;i++){double[] a=r.xy[i-1],b=r.xy[i];double dx=(b[0]-a[0])*sx,dy=(b[1]-a[1])*111320,l=Math.hypot(dx,dy);if(l<.01)continue;
    if(remain<=l || i==r.xy.length-1){double t=Math.max(0,Math.min(1,remain/l));out=new double[]{a[1]+(b[1]-a[1])*t,a[0]+(b[0]-a[0])*t,(Math.toDegrees(Math.atan2(dx,dy))+(direction<0?180:0)+360)%360};lat=out[0];break;}remain-=l;
   }
  }return out;
 }
 static List<double[]> path(WideHcopRoad.Camera camera,int direction)throws Exception {
  WideHcopRoad.Data d=load(camera.lat,camera.lon);WideHcopRoad.Road r=null;for(WideHcopRoad.Road a:d.roads)if(a.id.equals(camera.edge))r=a;
  if(r==null)return new ArrayList<>();WideRoad.Projection p=WideRoad.project(r.xy,camera.lat,camera.lon,0);double part=direction>0?p.station:p.length-p.station;
  List<Leg> legs=new ArrayList<>();legs.add(new Leg(r,direction,part));double total=part;Set<String> seen=new HashSet<>();seen.add(r.id);int dir=direction;
  while(total<1250 && legs.size()<128){long entry=dir>0?r.start:r.end;Leg prev=null;boolean fork=false;
   for(WideHcopRoad.Road a:d.roads){if(seen.contains(a.id)||!same(a,r))continue;int flow=a.end==entry&&a.dir>=0?1:a.start==entry&&a.dir<=0?-1:0;if(flow==0)continue;if(prev!=null){fork=true;break;}prev=new Leg(a,flow,length(a));}
   if(prev==null||fork)break;legs.add(0,prev);total+=prev.len;seen.add(prev.r.id);r=prev.r;dir=prev.dir;
  }
  List<double[]> points=new ArrayList<>();double start=Math.min(1200,total-9);
  for(double distance=start;distance>=30;distance-=Math.min(20,Math.max(5,camera.limit/3.6*.8))){double progress=total-distance;Leg selected=legs.get(legs.size()-1);for(Leg leg:legs){selected=leg;if(progress<=leg.len)break;progress-=leg.len;}
   double station=selected.dir>0?progress:length(selected.r)-progress;double[] pos=at(selected.r,station,selected.dir);points.add(new double[]{pos[0],pos[1],pos[2],distance});
  }return points;
 }
 static String run(WideHcopRoad.Camera camera,int direction)throws Exception {
  List<double[]> path=path(camera,direction);double first=-1,closest=Double.POSITIVE_INFINITY;int hits=0,wrong=0;String last="",reason="";long t=1000;WideHcopRoad.Tracker tracker=new WideHcopRoad.Tracker();WideCameraTrace.clear();
  for(double[] p:path){WideHcopRoad.Data d=load(p[0],p[1]);WideCameraEngine.Fix f=new WideCameraEngine.Fix(p[0],p[1],9,p[2],Math.min(20,Math.max(5,camera.limit/3.6*.8)),t,true,false,true);WideHcopRoad.Decision original=tracker.accept(d,f,t);WideCameraTrace.update(d,f,t);WideHcopRoad.Decision display=WideCameraTrace.display(original,f,t);last=original.reason;
   if(display.camera!=null && display.camera.id.equals(camera.id)&&display.distance<=1000){hits++;if(first<0)first=display.distance;closest=Math.min(closest,display.distance);}
   else if(display.camera!=null)reason="other_camera_selected";
   if(WideCameraTrace.display(original,f,t+4000).camera!=null)throw new AssertionError("stale result");t+=1000;
  }
  boolean oppositeAllowed=false;for(int dd:camera.dirs)if(dd==-direction)oppositeAllowed=true;
  if(!oppositeAllowed){WideCameraTrace.clear();tracker=new WideHcopRoad.Tracker();t=1000;
   for(int i=path.size()-1;i>=0;i--){double[] p=path.get(i);WideHcopRoad.Data d=load(p[0],p[1]);WideCameraEngine.Fix f=new WideCameraEngine.Fix(p[0],p[1],9,(p[2]+180)%360,Math.min(20,Math.max(5,camera.limit/3.6*.8)),t,true,false,true);WideHcopRoad.Decision original=tracker.accept(d,f,t);WideCameraTrace.update(d,f,t);WideHcopRoad.Decision display=WideCameraTrace.display(original,f,t);if(display.camera!=null&&display.camera.id.equals(camera.id)&&display.distance<=1000){wrong++;System.err.println(camera.id+"\t"+p[0]+"\t"+p[1]+"\t"+((p[2]+180)%360)+"\t"+display.road.id+"\t"+display.direction+"\t"+display.distance+"\t"+original.reason);}t+=1000;}
  }
  return camera.id+"\t"+direction+"\t"+path.size()+"\t"+(path.isEmpty()?0:Math.round(path.get(0)[3]))+"\t"+hits+"\t"+Math.round(first)+"\t"+wrong+"\t"+oppositeAllowed+"\t"+last+"\t"+reason;
 }
 public static void main(String[] args)throws Exception {root=new File(args[0]);int count=0;
  try(BufferedReader in=new BufferedReader(new FileReader(new File(root,"mapped.tsv")));PrintWriter out=new PrintWriter(new File(root,System.getProperty("audit.only")==null?"replay.tsv":"replay-subset.tsv"))){out.println("id\tdirection\tsamples\tstartDistance\thits\tfirstAlertM\treverseFalseHits\toppositeAlsoEnforced\tlastOriginalReason\totherCameraSelected");String line;
   while((line=in.readLine())!=null){String[] s=line.split("\\t");if(System.getProperty("audit.only")!=null&&!System.getProperty("audit.only").contains(s[0]))continue;WideHcopRoad.Camera c=new WideHcopRoad.Camera();c.id=s[0];c.edge=s[1];c.road=s[2];c.limit=Integer.parseInt(s[3]);c.lat=Double.parseDouble(s[4]);c.lon=Double.parseDouble(s[5]);String[] ds=s[6].split(",");c.dirs=new int[ds.length];for(int i=0;i<ds.length;i++)c.dirs[i]=Integer.parseInt(ds[i]);
    for(int dir:c.dirs){out.println(run(c,dir));out.flush();}if(++count%25==0)System.out.println("checked mapped points "+count);
   }
  }
 }
}
