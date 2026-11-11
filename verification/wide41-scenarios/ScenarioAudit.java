package com.navipilot.obf;
import java.util.*;
public class ScenarioAudit {
 static WideCameraEngine.Point p(String id,double lat,boolean known){return new WideCameraEngine.Point(id,"test","","",lat,121,60,known?new double[]{0}:new double[0],false);}
 static void run(String name,int mode,List<WideCameraEngine.Point> points){
 WideCameraTrace.clear();int hits=0,voice=0,first=-1;Set<String> ids=new TreeSet<>();
 for(int i=0;i<70;i++){
 double acc=10,speed=11.12,heading=0,lat=25+i*.0001;boolean hv=true,sv=true;long t=1000+i*1000;long now=t;
 if(mode==1)hv=false;
 if(mode==2){hv=false;sv=false;speed=0;}
 if(mode==3)hv=i%3!=0;
 if(mode==4&&i<5)speed=0;
 if(mode==5&&i>=8&&i<=12)now+=4000;
 if(mode==6&&i>=8&&i<=12)acc=45;
 if(mode==7)acc=i%2==0?10:31;
 if(mode==8){hv=false;t=1000+i*4000L;now=t;lat=25+i*.0004;}
 if(mode==9){hv=false;speed=2;acc=20;lat=25+i*.000018;}
 if(mode==10)heading=180;
 if(mode==11)speed=0;
 if(mode==12&&i%2==1)lat=25+(i-1)*.0001;
 if(mode==13){hv=false;acc=20;lat=25+i*.0001;}
 if(mode==14&&i==20)WideCameraTrace.clear();
 WideCameraEngine.Fix f=new WideCameraEngine.Fix(lat,121,acc,heading,speed,t,hv,false,sv);
 WideHcopRoad.Decision d=WideCameraTrace.displayPoints(new WideHcopRoad.Decision("no roads",t),f,now,points);
 if(d.camera!=null){hits++;ids.add(d.camera.id);if(first<0)first=i;if(d.distance<=1000)voice++;}
 }
 System.out.println(name+"\t"+hits+"\t"+voice+"\t"+first+"\t"+ids+"\t"+WideCameraFallback.status());
 }
 public static void main(String[] args){
 List<WideCameraEngine.Point> normal=Arrays.asList(p("A",25.005,true),p("B",25.011,true));
 String[] names={"normal_two_cameras","no_heading","no_heading_or_speed","intermittent_heading","stop_then_start","GPS_outage_then_recovery","bad_accuracy_then_recovery","alternating_10m_31m_accuracy","4_second_updates_no_heading","7kmh_no_heading_accuracy20","reverse","reported_zero_speed_while_coordinates_move","duplicate_positions","no_heading_accuracy20","clear_then_recovery"};
 System.out.println("scenario\tcamera_frames\twithin_1km_frames\tfirst_index\tcamera_ids\tfinal_status");
 for(int i=0;i<names.length;i++)run(names[i],i,normal);
 run("unknown_direction_occludes_known",0,Arrays.asList(p("unknown",25.009,false),p("known",25.011,true)));
 run("known_alone_control",0,Arrays.asList(p("known",25.011,true)));
 }
}
