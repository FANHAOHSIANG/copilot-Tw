package com.navipilot.obf;
import org.json.JSONObject;
public class ExportGuidance {
 public static void main(String[] args)throws Exception{
  WideAmapLinkNavigation n=new WideAmapLinkNavigation();n.reset(1);
  int[] icons={3,2,8,9,999};int[] distances={1544,80,60,300,20};
  for(int i=0;i<icons.length;i++){
   long t=1000+i*1000;
   n.accept(1,4,new JSONObject().put("curManeuverID",icons[i]).put("segmentRemainDist",distances[i]).put("nextRouteName","120縣道"),t,1700000000000L+t);
   WideAmapLinkNavigation.Snapshot s=n.snapshot(t);
   System.out.println(new JSONObject().put("icon",icons[i]).put("guidance",s.guidance==null?JSONObject.NULL:s.guidance).put("status",s.status==null?JSONObject.NULL:s.status));
  }
  n.accept(1,100,new JSONObject(),6100,1700000006100L);
  WideAmapLinkNavigation.Snapshot s=n.snapshot(6100);
  System.out.println(new JSONObject().put("icon",100).put("guidance",s.guidance==null?JSONObject.NULL:s.guidance).put("status",s.status));
 }
}
