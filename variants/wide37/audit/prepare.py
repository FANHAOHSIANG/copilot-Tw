import json,gzip,pathlib,struct,math,sys,functools,os
ROOT=pathlib.Path(os.environ.get('COPILOT_ASSETS','assets'));OUT=pathlib.Path(__file__).resolve().parent;(OUT/'tiles').mkdir(exist_ok=True)
from geometry import project
points=json.load(open(ROOT/'tw_cameras.json'))['points'];mapped={};road_ids=set();allroads={}
def i(f,x):f.write(struct.pack('>i',int(x)))
def l(f,x):f.write(struct.pack('>q',int(x)))
def d(f,x):f.write(struct.pack('>d',float(x)))
def s(f,x):b=str(x).encode();i(f,len(b));f.write(b)
def ss(f,x):i(f,len(x));[s(f,v) for v in x]
def xy(f,x):i(f,len(x));[(d(f,a),d(f,b)) for a,b in x]
for n,p in enumerate(sorted((ROOT/'tw_hcop').glob('*.gz'))):
 t=json.load(gzip.open(p));
 with gzip.open(OUT/'tiles'/p.name.replace('.json.gz','.bin.gz'),'wb',compresslevel=1) as f:
  i(f,len(t['r']))
  for r in t['r']:
   road_ids.add(r[0]);s(f,r[0]);ss(f,r[1]);i(f,r[2]);s(f,r[3]);i(f,r[4]);i(f,r[5]);xy(f,r[6]);l(f,r[7]);l(f,r[8])
  i(f,len(t['c']))
  for c in t['c']:
   mapped[c[0]]=c;s(f,c[0]);s(f,c[1]);s(f,c[2]);i(f,c[3]);d(f,c[4]);d(f,c[5]);i(f,len(c[6]));[i(f,v) for v in c[6]]
  i(f,len(t['f']))
  for o in t['f']:i(f,o[0]);ss(f,o[1]);i(f,o[2]);xy(f,o[3]);s(f,o[4])
 if n%1500==0:print('tiles',n,flush=True)
for c in json.load(open(OUT/'supplementary-mappings.json')):
 if c['accepted']:mapped[c['id']]=[c['id'],c['edge'],c['road'],c['limit'],c['lat'],c['lon'],[1]]
@functools.lru_cache(128)
def tile(x,y):
 p=ROOT/'tw_hcop'/f'{x}_{y}.json.gz';return json.load(gzip.open(p)) if p.exists() else {'r':[]}
def nearby(lat,lon):
 found={};x=int(lon/.02);y=int(lat/.02)
 for a in range(x-1,x+2):
  for b in range(y-1,y+2):
   for r in tile(a,b)['r']:found[r[0]]=r
 return found
rows=[]
for c in points:
 m=mapped.get(c['id']);near=nearby(c['lat'],c['lon']);best=min(((project(r[6],c['lat'],c['lon']),r) for r in near.values()),default=None)
 row=dict(c,mapped=bool(m),mappedEdge=m[1] if m else '',mappedDirections=m[6] if m else [],mappingEdgeExists=bool(m and m[1] in road_ids))
 if best:
  p,r=best;row.update(nearestRoad=r[1],nearestRoadOffsetM=round(p[0],2),nearestLocalHeading=round(p[2],2),nearJunction=min(p[1],p[3]-p[1])<8)
 row['coordinatesValid']=20<=c['lat']<=27 and 116<=c['lon']<=124
 row['limitValid']=0<c['limit']<=130 and not c['limitUncertain']
 rows.append(row)
(OUT/'inventory.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2))
with open(OUT/'mapped.tsv','w') as f:
 for c in mapped.values():f.write('\t'.join(map(str,c[:6]))+'\t'+','.join(map(str,c[6]))+'\n')
print('inventory',len(rows),'mapped',sum(x['mapped'] for x in rows),'unmapped',sum(not x['mapped'] for x in rows),'unique mapped IDs',len(mapped),flush=True)
