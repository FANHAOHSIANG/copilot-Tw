"""Compile pinned OSM / HCOP / NPA snapshots into independently loadable offline tiles."""
import sys
sys.path.insert(0,'work/python')
import osmium,json,gzip,math,sqlite3,collections,hashlib,datetime
from pathlib import Path
from shapely.geometry import LineString,Point
ROOT=Path('work/data'); ASSETS=Path('work/assets');ASSETS.mkdir(exist_ok=True)
TILE=.02; SCALEX=101000.;SCALEY=111320.
ALLOWED={'motorway','trunk','primary','secondary','tertiary','unclassified','residential','living_street','service','motorway_link','trunk_link','primary_link','secondary_link','tertiary_link'}
def tile(x,y):return int(math.floor(x/TILE)),int(math.floor(y/TILE))
def keys(pts):
 x0,y0=tile(min(p[0] for p in pts),min(p[1] for p in pts));x1,y1=tile(max(p[0] for p in pts),max(p[1] for p in pts))
 return [(x,y) for x in range(x0,x1+1) for y in range(y0,y1+1)]
def speed(s):
 return int(s) if s and s.isdigit() and 10<=int(s)<=130 else 0
nodeuses=collections.Counter(); nways=0
# Reuse only the fully extracted, validated OSM way snapshot.
for s in gzip.open(ROOT/'ways.jsonl.gz','rt'):
 row=json.loads(s);nodeuses.update(row[1]);nways+=1
print('ways read',nways,flush=True)
roads={};buckets=collections.defaultdict(list)
for s in gzip.open(ROOT/'ways.jsonl.gz','rt'):
 wid,ids,ps,names,direction,grade,mf,mb=json.loads(s)
 cuts=[0]+[i for i in range(1,len(ids)-1) if nodeuses[ids[i]]>1]+[len(ids)-1]
 for a,b in zip(cuts,cuts[1:]):
  pts=ps[a:b+1]
  if len(pts)<2:continue
  eid=f'{wid}:{a}:{b}';row=[eid,names,direction,grade,mf,mb,pts,ids[a],ids[b]]
  roads[eid]=row
  for k in keys(pts):buckets[k].append(eid)
del nodeuses
assert len(roads)>100000
print('edges',len(roads),'tiles',len(buckets),flush=True)
cams=json.load(open('source/tw14/camera13-build/data/tw_cameras.json')); reject=collections.Counter();associated=[]
def nearby(lon,lat):
 x,y=tile(lon,lat)
 return [roads[e] for e in {eid for dx in (-1,0,1) for dy in (-1,0,1) for eid in buckets.get((x+dx,y+dy),[])}]
def diff(a,b):return abs((a-b+180)%360-180)
def projection(row,lon,lat):
 line=LineString([(x*SCALEX,y*SCALEY) for x,y in row[6]]);p=Point(lon*SCALEX,lat*SCALEY);d=line.distance(p);s=line.project(p)
 a=line.interpolate(max(0,s-2));b=line.interpolate(min(line.length,s+2));hd=math.degrees(math.atan2(b.x-a.x,b.y-a.y))%360
 return d,s,hd,line.length
for c in cams['points']:
 if c.get('limitUncertain') or not c['bearings'] or not 10<=c['limit']<=130:reject['unknown_limit_or_direction']+=1;continue
 near=[]
 for row in nearby(c['lon'],c['lat']):
  ps=row[6]
  if c['lon']<min(p[0] for p in ps)-.0005 or c['lon']>max(p[0] for p in ps)+.0005 or c['lat']<min(p[1] for p in ps)-.0005 or c['lat']>max(p[1] for p in ps)+.0005:continue
  d,s,h,length=projection(row,c['lon'],c['lat'])
  if d<=40:near.append((d,s,h,length,row))
 compatible=[]
 for d,s,h,l,row in near:
  dirs=[v for v in (1,-1) if row[2] in (0,v) and any(diff(h+(180 if v<0 else 0),b)<=30 for b in c['bearings'])]
  if dirs and d<=20:compatible.append((d,s,h,l,row,dirs))
 compatible.sort(key=lambda z:z[0])
 if not compatible:reject['no_direction_matched_road']+=1;continue
 d,s,h,length,row,dirs=compatible[0]
 if s<15 or length-s<15:reject['junction_endpoint']+=1;continue
 # Differing grade, or same travel heading, is an ambiguity even when the camera name seems plausible.
 ambiguous=False
 for d2,s2,h2,l2,r2 in near:
  if r2[0]==row[0] or d2-d>=12:continue
  if r2[3]!=row[3] or any(r2[2] in (0,v) and any(diff(h2+(180 if v<0 else 0),b)<=35 for b in c['bearings']) for v in (1,-1)):
   ambiguous=True;break
 if ambiguous:reject['parallel_or_grade_ambiguity']+=1;continue
 associated.append([c['id'],row[0],c['road'],c['limit'],c['lat'],c['lon'],dirs])
print('camera matched',len(associated),'rejected',dict(reject),flush=True)
# Pin upstream rows; global/radius-only corrections remain reference data. They cannot establish a directional road stretch.
fixdoc=json.load(open('work/upstream/hcop-fixes.json'));fixes=fixdoc['fixes'];fix_tiles=collections.defaultdict(list);linecount=0
for i,f in enumerate(fixes):
 if 'line' not in f:continue
 line=[[p[1],p[0]] for p in f['line']]
 if len(line)<2 or not 10<=f['limit']<=130:continue
 row=[i,f['name'],f['limit'],line,f.get('src','')]
 for k in keys(line):fix_tiles[k].append(row)
 linecount+=1
cam_tiles=collections.defaultdict(list)
for c in associated:
 for x,y in keys(roads[c[1]][6]):cam_tiles[(x,y)].append(c)
out=ASSETS/'tw_hcop';out.mkdir(exist_ok=True);ntiles=0
for (x,y) in sorted(set(buckets)|set(fix_tiles)):
 rows=[roads[e] for e in buckets.get((x,y),[])]
 data={'r':rows,'f':fix_tiles.get((x,y),[]),'c':cam_tiles.get((x,y),[])}
 with gzip.open(out/f'{x}_{y}.json.gz','wt',encoding='utf8',compresslevel=9) as f:json.dump(data,f,ensure_ascii=False,separators=(',',':'))
 ntiles+=1
meta={'schema':1,'version':'wide.16-hcop-tw-test','builtAt':datetime.datetime.now(datetime.timezone.utc).isoformat(),'osmDate':'2026-11-08','cameraDate':'2026-11-09','tdxSnapshotDate':'2026-10-18','validUntil':'2027-02-15','tileDegrees':TILE,'ways':nways,'edges':len(roads),'tiles':ntiles,'cameras':len(cams['points']),'matchedCameras':len(associated),'cameraRejections':dict(reject),'hcopFixes':len(fixes),'tdxDirectionalStretches':linecount,'hcopRef':'2decc11c5d8cebbdb87c0751ef52b96a494506c0','hcopFixSha256':hashlib.sha256(Path('work/upstream/hcop-fixes.json').read_bytes()).hexdigest(),'osmUrl':'https://download.geofabrik.de/asia/taiwan-261108.osm.pbf','osmLicense':'© OpenStreetMap contributors / ODbL 1.0','cameraSource':'https://data.gov.tw/dataset/7320','governmentLicense':'政府資料開放授權條款第1版','scope':'OSM graph for Taiwan; camera matching stays within junction-bounded edges; no route guessing. NPA road corrections only within 200 m along the same edge and direction. HCOP broad circle/box fixes kept as reference, never used as control road limits. TDX lines require OSM road-name/ref, geometry and heading agreement; conflicting equal-priority values rejected.'}
(ASSETS/'tw_hcop_metadata.json').write_text(json.dumps(meta,ensure_ascii=False,indent=2))
(ROOT/'matched-cameras.json').write_text(json.dumps(associated,ensure_ascii=False))
print(json.dumps(meta,ensure_ascii=False,indent=2),flush=True)
