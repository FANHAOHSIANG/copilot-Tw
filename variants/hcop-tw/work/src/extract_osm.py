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
raw=gzip.open(ROOT/'ways.jsonl.gz','wt')
class Reader(osmium.SimpleHandler):
 def way(self,w):
  global nways
  t=dict(w.tags);k=t.get('highway','')
  if k not in ALLOWED or any(t.get(a) in ('no','private') for a in ('access','motor_vehicle','motorcar')):return
  try:ps=[[round(n.lon,7),round(n.lat,7)] for n in w.nodes];ids=[n.ref for n in w.nodes]
  except osmium.InvalidLocationError:return
  if len(ps)<2:return
  nodeuses.update(ids);one=t.get('oneway','');direction=-1 if one=='-1' else 1 if one in ('yes','1','true') or (one not in ('no','0','false') and(k=='motorway' or t.get('junction')=='roundabout')) else 0
  # Retain all grades as competitors; conditional signs are not simplified into unconditional limits.
  conditional=any(a.startswith('maxspeed') and 'conditional' in a for a in t)
  mf=0 if conditional else speed(t.get('maxspeed:forward',t.get('maxspeed','')))
  mb=0 if conditional else speed(t.get('maxspeed:backward',t.get('maxspeed','')))
  grade=str(t.get('layer','0'))+'|'+str(t.get('bridge','no'))+'|'+str(t.get('tunnel','no'))
  names=list(dict.fromkeys(s for a in ('name','name:zh','ref') for s in t.get(a,'').split(';') if s))
  raw.write(json.dumps([w.id,ids,ps,names,direction,grade,mf,mb],ensure_ascii=False,separators=(',',':'))+'\n');nways+=1
  if nways%100000==0:print('ways',nways,flush=True)
Reader().apply_file(str(ROOT/'taiwan-261108.osm.pbf'),locations=True,idx='flex_mem');raw.close()
