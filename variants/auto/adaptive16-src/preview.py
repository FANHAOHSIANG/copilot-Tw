"""Geometry inspection from production Java results; deliberately not an Android screenshot."""
from PIL import Image,ImageDraw,ImageFont
from pathlib import Path
import json
data=json.loads(Path('adaptive16-build/layouts.json').read_text())
im=Image.new('RGB',(1500,1140),'#0d1420');d=ImageDraw.Draw(im)
font='/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf'
f=lambda size:ImageFont.truetype(font,size)
d.text((30,18),'wide.16 - geometry verification',font=f(28),fill='white')
d.text((30,57),'Computed from production layout code. Diagram only; not an Android device screenshot.',font=f(18),fill='#afc0d4')
titles=['Car display / controls visible','Phone landscape / collapsed','Phone landscape / expanded','Phone portrait / collapsed','Phone portrait / expanded','Tablet portrait / custom split']
for i,p in enumerate(data):
 x=20+(i%3)*495;y=100+(i//3)*510
 d.rounded_rectangle((x,y,x+475,y+490),radius=14,fill='#182331')
 d.text((x+14,y+14),titles[i],font=f(17),fill='white')
 d.text((x+14,y+43),f'{int(p["width"])} x {int(p["height"])} dp',font=f(14),fill='#afc0d4')
 scale=min(447/p['width'],390/p['height']);ox=x+14+(447-p['width']*scale)/2;oy=y+80
 def panel(px,py,w,h,color,label):
  box=(ox+px*scale,oy+py*scale,ox+(px+w)*scale,oy+(py+h)*scale)
  d.rectangle(box,fill=color)
  toolbar=min(48,h)*scale
  d.rectangle((box[0],box[1],box[2],box[1]+toolbar),fill='#273548')
  if h*scale>40:
   d.text((box[0]+8,box[1]+toolbar+8),label,font=f(14),fill='white')
  return box
 a=panel(0,0,p['mapWidth'],p['mapHeight'],'#16416a','Navigation')
 b=panel(p['sideX'],p['sideY'],p['sideWidth'],p['shieldHeight'],'#18544e','Shield')
 if p['portrait']:d.line((a[0]+(a[2]-a[0])*.35,a[3]-4,a[0]+(a[2]-a[0])*.65,a[3]-4),fill='#c7d8ee',width=3)
 else:d.line((a[2]-4,a[1]+(a[3]-a[1])*.35,a[2]-4,a[1]+(a[3]-a[1])*.65),fill='#c7d8ee',width=3)
 if p['controls']:
  cx=p['sideX'];cy=p['sideY']+p['shieldHeight']+6;cw=p['sideWidth'];ch=p['controlsHeight']
  for row in range(3):
   for col in range(3):
    x0=ox+(cx+col*cw/3)*scale;y0=oy+(cy+row*ch/3)*scale
    d.rectangle((x0+1,y0+1,x0+cw/3*scale-1,y0+ch/3*scale-1),fill='#9d5c27')
  d.line((b[0]+(b[2]-b[0])*.35,b[3]-4,b[0]+(b[2]-b[0])*.65,b[3]-4),fill='#c7d8ee',width=3)
Path('adaptive16-build/layout-preview.png').write_bytes(b'')
im.save('adaptive16-build/layout-preview.png')
