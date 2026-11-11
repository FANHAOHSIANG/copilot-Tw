import json,gzip,math,pathlib,os
ROOT=pathlib.Path(os.environ.get('COPILOT_ASSETS','assets'))
def project(xy,lat,lon):
 sx=111320*math.cos(math.radians(lat)); sy=111320;best=(1e9,0,0);length=0
 for a,b in zip(xy,xy[1:]):
  ax,ay=(a[0]-lon)*sx,(a[1]-lat)*sy;dx,dy=(b[0]-a[0])*sx,(b[1]-a[1])*sy;l=math.hypot(dx,dy)
  if l<.01:continue
  t=max(0,min(1,-(ax*dx+ay*dy)/(l*l)));off=math.hypot(ax+t*dx,ay+t*dy)
  if off<best[0]:best=(off,length+t*l,math.degrees(math.atan2(dx,dy))%360)
  length+=l
 return (*best,length)
def nearby(lat,lon):
 roads={};x=int(lon/.02);y=int(lat/.02)
 for i in range(x-1,x+2):
  for j in range(y-1,y+2):
   f=ROOT/'tw_hcop'/f'{i}_{j}.json.gz'
   if f.exists():
    for r in json.load(gzip.open(f))['r']:roads[r[0]]=r
 return roads
if __name__=='__main__':
 for c in json.load(open(ROOT/'tw_cameras.json'))['points']:
  if c['city']=='國道一號' and c['direction']=='往北' and 24.8<c['lat']<25.1 and c['lon']<121.54:
   print('\n',c['road'])
   for p,r in sorted((project(r[6],c['lat'],c['lon']),r) for r in nearby(c['lat'],c['lon']).values())[:8]: print([round(n,1) for n in p],r[:6])
