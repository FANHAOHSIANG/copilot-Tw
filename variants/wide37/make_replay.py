import json,math,pathlib
from inspect_roads import nearby,project
O=pathlib.Path(__file__).parent
roads={r[0]:r for r in json.load(open(O/'north-roads.json'))}
def at(r,station):
 xy=r[6];lat=sum(p[1] for p in xy)/len(xy);sx=111320*math.cos(math.radians(lat));done=0
 for a,b in zip(xy,xy[1:]):
  dx,dy=(b[0]-a[0])*sx,(b[1]-a[1])*111320;l=math.hypot(dx,dy)
  if done+l>=station:
   t=max(0,min(1,(station-done)/l));return a[1]+t*(b[1]-a[1]),a[0]+t*(b[0]-a[0]),math.degrees(math.atan2(dx,dy))%360
  done+=l
 return xy[-1][1],xy[-1][0],0
out=O/'fixtures';out.mkdir(exist_ok=True)
for c in json.load(open(O/'mapping-report.json')):
 if not c['accepted']:continue
 r=roads[c['edge']];station=project(r[6],c['lat'],c['lon'])[1];segments=[(r,station)]
 while sum(s for _,s in segments)<1250:
  prev=[p for p in roads.values() if p[8]==r[7] and set(p[1])&set(r[1])-{'1'}]
  if len(prev)!=1:break
  r=prev[0];segments.insert(0,(r,project(r[6],r[6][0][1],r[6][0][0])[3]))
 total=sum(s for _,s in segments);fixes=[];used={}
 for dist in range(min(1200,int(total)-10),89,-30):
  left=total-dist
  for r,length in segments:
   if left<=length:break
   left-=length
  lat,lon,h=at(r,left);fixes.append((lat,lon,h,dist,r[0]));used.update(nearby(lat,lon))
 with open(out/(c['id']+'.tsv'),'w') as f:
  f.write('C\t'+c['id']+'\t'+c['road']+'\n')
  for r in used.values():f.write('\t'.join(['R',r[0],','.join(r[1]),str(r[2]),r[3],str(r[7]),str(r[8]),';'.join(str(x)+','+str(y) for x,y in r[6])])+'\n')
  for lat,lon,h,d,e in fixes:f.write('\t'.join(map(str,['F',lat,lon,h,d,e]))+'\n')
