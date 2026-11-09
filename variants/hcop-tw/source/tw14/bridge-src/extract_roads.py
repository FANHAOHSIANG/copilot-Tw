"""Extract an attributed offline road graph around bundled camera points."""
import sys
sys.path.insert(0,'bridge-build/python')
import osmium,json,math,gzip,time,hashlib
from pathlib import Path
from shapely.geometry import Point,LineString,box
from shapely.strtree import STRtree
cameras=json.loads(Path('camera13-build/data/tw_cameras.json').read_text())['points']
sections=json.loads(Path('camera13-build/data/tw_sections.json').read_text())['sections']
locations=[(x['lon'],x['lat']) for x in cameras]+[(x[k+'Lon'],x[k+'Lat']) for x in sections for k in ['start','end']]
boxes=[box(x-.022,y-.020,x+.022,y+.020) for x,y in locations]
idx=STRtree(boxes)
allowed={'motorway','trunk','primary','secondary','tertiary','unclassified','residential','living_street','service','motorway_link','trunk_link','primary_link','secondary_link','tertiary_link'}
ways=[];nodeuses={};seen=0
class Roads(osmium.SimpleHandler):
 def way(self,w):
  global seen
  tags=dict(w.tags);kind=tags.get('highway','')
  if kind not in allowed or any(tags.get(k) in ('no','private') for k in ('access','motor_vehicle','motorcar')):return
  try: pts=[(n.lon,n.lat) for n in w.nodes]
  except osmium.InvalidLocationError:return
  if len(pts)<2 or len(idx.query(LineString(pts),predicate='intersects'))==0:return
  ids=[n.ref for n in w.nodes]
  for n in ids:nodeuses[n]=nodeuses.get(n,0)+1
  one=tags.get('oneway','');direction=-1 if one=='-1' else 1 if one in ('yes','1','true') or (one not in ('no','0','false') and (kind=='motorway' or tags.get('junction')=='roundabout')) else 0
  ways.append((w.id,ids,pts,tags.get('name',''),direction,tags.get('layer','0'),tags.get('bridge','no'),tags.get('tunnel','no'),kind))
  if len(ways)%20000==0: print('selected ways',len(ways),flush=True)
start=time.time();Roads().apply_file('bridge-build/data/taiwan-261108.osm.pbf',locations=True,idx='flex_mem')
edges=[]
for wid,ids,pts,name,direction,layer,bridge,tunnel,kind in ways:
 cuts=[0]+[i for i in range(1,len(ids)-1) if nodeuses[ids[i]]>1]+[len(ids)-1]
 for a,b in zip(cuts,cuts[1:]):
  if a==b:continue
  edges.append({'osm':wid,'a':ids[a],'b':ids[b],'name':name,'dir':direction,'layer':layer,'bridge':bridge,'tunnel':tunnel,'kind':kind,'xy':[[round(x,7),round(y,7)] for x,y in pts[a:b+1]]})
meta={'source':'OpenStreetMap contributors / Geofabrik Taiwan 2026-11-08','sourceUrl':'https://download.geofabrik.de/asia/taiwan-261108.osm.pbf','license':'ODbL 1.0','attribution':'© OpenStreetMap contributors','licenseUrl':'https://www.openstreetmap.org/copyright','ways':len(ways),'edges':len(edges),'scope':'Road geometry within approximately 2 km of bundled fixed cameras and section endpoints; not a complete navigation map','turnRestrictions':'not extracted; must not assume branch paths are legally traversable without additional validation'}
p=Path('bridge-build/data/roads.json.gz')
with gzip.open(p,'wt',encoding='utf8') as f:json.dump({'metadata':meta,'edges':edges},f,ensure_ascii=False,separators=(',',':'))
Path('bridge-build/data/roads-metadata.json').write_text(json.dumps(meta,ensure_ascii=False,indent=2))
print(json.dumps({'seconds':round(time.time()-start),'compressedBytes':p.stat().st_size,**meta},ensure_ascii=False),flush=True)
