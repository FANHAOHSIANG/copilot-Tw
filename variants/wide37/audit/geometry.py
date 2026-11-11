import math
def project(xy,lat,lon):
 sx=111320*math.cos(math.radians(lat)); sy=111320;best=(1e9,0,0);length=0
 for a,b in zip(xy,xy[1:]):
  ax,ay=(a[0]-lon)*sx,(a[1]-lat)*sy;dx,dy=(b[0]-a[0])*sx,(b[1]-a[1])*sy;l=math.hypot(dx,dy)
  if l<.01:continue
  t=max(0,min(1,-(ax*dx+ay*dy)/(l*l)));off=math.hypot(ax+t*dx,ay+t*dy)
  if off<best[0]:best=(off,length+t*l,math.degrees(math.atan2(dx,dy))%360)
  length+=l
 return (*best,length)
