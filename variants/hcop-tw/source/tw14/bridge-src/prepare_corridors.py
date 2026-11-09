import sys,json,gzip,math,collections
from pathlib import Path
sys.path.insert(0,'bridge-build/python')
from shapely.geometry import LineString,Point,box
from shapely.strtree import STRtree
from shapely.ops import substring
root=Path('bridge-build/data')
print('Loading edges',flush=True)
doc=json.load(gzip.open(root/'roads.json.gz','rt')); edges=doc['edges']
SX=101000.;SY=111320.
lines=[LineString([(x*SX,y*SY) for x,y in e['xy']]) for e in edges]
tree=STRtree(lines)
pts=json.load(open('camera13-build/data/tw_cameras.json'))['points']
out=[];rejections=collections.Counter()
def diff(a,b):return abs((a-b+180)%360-180)
def tangent(line,s):
 a=line.interpolate(max(0,s-2));b=line.interpolate(min(line.length,s+2));return math.degrees(math.atan2(b.x-a.x,b.y-a.y))%360
for cam in pts:
 p=Point(cam['lon']*SX,cam['lat']*SY)
 if cam.get('limitUncertain') or not cam['bearings']:
  rejections['unknown limit/direction']+=1;continue
 near=sorted((lines[int(i)].distance(p),int(i)) for i in tree.query(p.buffer(60)))
 if not near or near[0][0]>25:rejections['no road within 25m']+=1;continue
 d,idx=near[0];e=edges[idx];line=lines[idx];s=line.project(p)
 if len(near)>1 and near[1][0]-d<12:rejections['ambiguous camera road']+=1;continue
 if s<25 or line.length-s<25:rejections['camera near junction/edge end']+=1;continue
 if e['layer'] not in ('','0') or e['bridge'] not in ('','no') or e['tunnel'] not in ('','no'):
  rejections['grade separation not verifiable']+=1;continue
 heading=tangent(line,s)
 dirs=[v for v in (1,-1) if e['dir'] in (0,v) and any(diff((heading+(180 if v<0 else 0))%360,b)<=35 for b in cam['bearings'])]
 if not dirs:rejections['direction mismatch']+=1;continue
 # Never traverse junctions. Trim only within this edge, maximum 1500m either side.
 lo=max(0,s-1520);hi=min(line.length,s+1520);corridor=substring(line,lo,hi)
 nearby=[]
 for j in tree.query(corridor.buffer(65)):
  j=int(j)
  if j!=idx and lines[j].distance(corridor)<65:
   # retain intersecting local pieces, including competing grades
   clipped=lines[j].intersection(corridor.buffer(80))
   pieces=[clipped] if clipped.geom_type=='LineString' else list(clipped.geoms) if clipped.geom_type=='MultiLineString' else []
   for piece in pieces:
    if piece.length>1:nearby.append([[round(x/SX,7),round(y/SY,7)] for x,y in piece.coords])
 row={k:cam[k] for k in ('id','road','limit','lat','lon')}
 row.update(osm=e['osm'],edgeA=e['a'],edgeB=e['b'],osmName=e['name'],dirs=dirs,xy=[[round(x/SX,7),round(y/SY,7)] for x,y in corridor.coords],others=nearby)
 out.append(row)
meta=dict(doc['metadata']);meta.update(camerasTotal=len(pts),eligibleCameras=len(out),rejections=dict(rejections),matching='Same junction-bounded OSM edge only; no junction routing, no section control; ambiguous / stacked candidates rejected',maxDistanceM=1500)
(root/'corridors.json').write_text(json.dumps({'metadata':meta,'corridors':out},ensure_ascii=False,separators=(',',':')))
(root/'corridors-metadata.json').write_text(json.dumps(meta,ensure_ascii=False,indent=2))
print(json.dumps(meta,ensure_ascii=False,indent=2),flush=True)
