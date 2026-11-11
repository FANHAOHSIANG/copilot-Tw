"""Build display/voice-only National Highway 1 mappings from bundled OSM topology.
Direction follows directed carriageway connectivity, not the literal compass word 北.
Ambiguous ramp point 34.4 km is intentionally excluded.
"""
import sys,json,gzip,collections,pathlib
sys.path.insert(0,str(pathlib.Path(__file__).parent))
from inspect_roads import ROOT,project
OUT=pathlib.Path(__file__).parent
families={'中山高速公路':'main','五股楊梅高架道路':'elevated'}
roads={}
for f in (ROOT/'tw_hcop').glob('*.gz'):
 x,y=map(int,f.name.split('.')[0].split('_'))
 if not (6040<=x<=6085 and 1235<=y<=1260):continue
 for r in json.load(gzip.open(f))['r']:
  if r[2]==1 and '1' in r[1] and any(n in families for n in r[1]) and r[4]>=80:roads[r[0]]=r
by_start=collections.defaultdict(list);by_end=collections.defaultdict(list)
for r in roads.values():by_start[r[7]].append(r);by_end[r[8]].append(r)
seeds=['820453965:0:11','534195519:0:72']
# All connected road edges preserve the OSM forward flow in this one-way network.
visited=set(seeds);q=collections.deque(roads[s] for s in seeds)
while q:
 r=q.popleft()
 for other in by_start[r[8]]+by_end[r[7]]:
  if other[0] not in visited:visited.add(other[0]);q.append(other)
report=[];selected=[]
for c in json.load(open(ROOT/'tw_cameras.json'))['points']:
 if not(c['city']=='國道一號' and c['direction']=='往北' and 24.8<c['lat']<25.1 and c['lon']<121.54):continue
 fam='elevated' if '五楊高架' in c['road'] else 'main'
 choices=sorted((project(r[6],c['lat'],c['lon']),r) for r in roads.values() if r[0] in visited and any(families.get(n)==fam for n in r[1]))
 p,r=choices[0];ok=p[0]<=15 and min(p[1],p[3]-p[1])>2
 rec=dict(c,edge=r[0],offset=round(p[0],2),localHeading=round(p[2],2),accepted=ok,reason='directed_connected_carriageway' if ok else 'no_close_verified_mainline_ramp_not_inferred')
 report.append(rec)
 if ok:selected.append(rec)
print('roads',len(roads),'north-connected',len(visited))
for r in report: print(r['road'],r['accepted'],r['offset'],r['localHeading'],r['edge'])
(OUT/'mapping-report.json').write_text(json.dumps(report,ensure_ascii=False,indent=2))
lines=['package com.navipilot.obf;','final class WideHighwayAlertData {','static final WideHcopRoad.Camera[] CAMERAS = {']
for c in selected:lines.append('make(%s,%s,%s,%s,%s,%s),'%(json.dumps(c['id']),json.dumps(c['edge']),json.dumps(c['road'],ensure_ascii=False),c['limit'],c['lat'],c['lon']))
lines+=['};','private static WideHcopRoad.Camera make(String id,String edge,String road,int limit,double lat,double lon){','WideHcopRoad.Camera c=new WideHcopRoad.Camera(); c.id=id;c.edge=edge;c.road=road;c.limit=limit;c.lat=lat;c.lon=lon;c.dirs=new int[]{1};return c;','}','}']
(OUT/'src/WideHighwayAlertData.java').write_text('\n'.join(lines))
(OUT/'north-roads.json').write_text(json.dumps([roads[s] for s in sorted(visited)],ensure_ascii=False))
