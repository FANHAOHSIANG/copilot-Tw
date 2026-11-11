package com.navipilot.obf;
import java.io.*;
import java.util.*;
public final class HighwayReplayChecks {
 static void check(boolean v,String m){if(!v)throw new AssertionError(m);}
 static WideCameraEngine.Fix fix(double lat,double lon,double heading,long t){return new WideCameraEngine.Fix(lat,lon,9,heading,30,t,true,false,true);}
 public static void main(String[] args)throws Exception {
  for(File file:new File(args[0]).listFiles()) {
   WideHcopRoad.Data data=new WideHcopRoad.Data();Map<String,WideHcopRoad.Road> roads=new HashMap<>();
   List<String[]> fixes=new ArrayList<>();String id="",name="";
   try(BufferedReader br=new BufferedReader(new FileReader(file))){String line;while((line=br.readLine())!=null){
    String[] s=line.split("\\t",-1);
    if(s[0].equals("C")){id=s[1];name=s[2];}
    if(s[0].equals("F"))fixes.add(s);
    if(s[0].equals("R")){
     WideHcopRoad.Road r=new WideHcopRoad.Road();r.id=s[1];r.names=s[2].split(",");r.dir=Integer.parseInt(s[3]);r.grade=s[4];r.start=Long.parseLong(s[5]);r.end=Long.parseLong(s[6]);
     String[] xy=s[7].split(";");r.xy=new double[xy.length][2];for(int i=0;i<xy.length;i++){String[] p=xy[i].split(",");r.xy[i][0]=Double.parseDouble(p[0]);r.xy[i][1]=Double.parseDouble(p[1]);}
     data.roads.add(r);roads.put(r.id,r);
    }
   }}
   WideCameraTrace.clear();WideCameraTrace trace=new WideCameraTrace();int hits=0,reverseHits=0;double first=0;long t=1000;
   for(String[] s:fixes){
    WideCameraEngine.Fix f=fix(Double.parseDouble(s[1]),Double.parseDouble(s[2]),Double.parseDouble(s[3]),t);
    WideHcopRoad.Decision d=trace.accept(data,f,t);
    if(d!=null && d.camera!=null && d.camera.id.equals(id) && d.distance<=1000){hits++;if(first==0)first=d.distance;}
    // Verify original confirmed decisions can gain ahead cameras without mutating control fields.
    WideCameraTrace.update(data,f,t);WideHcopRoad.Decision original=new WideHcopRoad.Decision("original",t);
    original.confirmed=true;original.road=roads.get(s[5]);original.direction=1;original.limit=100;original.source="OSM";
    WideHcopRoad.Decision shown=WideCameraTrace.display(original,f,t);
    check(original.camera==null && original.limit==100 && data.cameras.isEmpty(),"must not mutate control data");
    if(Double.parseDouble(s[4])<950 && Double.parseDouble(s[4])>100)check(shown.camera!=null && shown.camera.id.equals(id),"confirmed route lookahead "+name+" at "+s[4]);
    check(shown.limit==100 && shown.source.equals("OSM"),"preserve road speed limit");
    check(WideCameraTrace.display(original,f,t+4000)==original,"stale trace forbidden");
    t+=1000;
   }
   trace=new WideCameraTrace();t=1000;
   for(String[] s:fixes){WideCameraEngine.Fix f=fix(Double.parseDouble(s[1]),Double.parseDouble(s[2]),(Double.parseDouble(s[3])+180)%360,t);WideHcopRoad.Decision d=trace.accept(data,f,t);if(d!=null && d.camera!=null && d.camera.id.equals(id))reverseHits++;t+=1000;}
   check(hits>0,"no GPS trace alert "+name);check(first>850,"alert too late "+name+" "+first);check(reverseHits==0,"reverse false alert "+name);
   System.out.println("PASS "+name+" first-under-1km="+Math.round(first)+"m hits="+hits+" reverse="+reverseHits);
  }
 }
}
