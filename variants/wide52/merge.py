#!/usr/bin/env python3
"""Experimental single APK merge. Inputs must be decoded wide51 and Google012.
Preserve Google's resource IDs; relocate the small CoPilot resource table and
its retained AndroidX classes to avoid linking them to different library ABIs.
"""
from pathlib import Path
import argparse, shutil, re, json, xml.etree.ElementTree as E
p=argparse.ArgumentParser();p.add_argument('base',type=Path);p.add_argument('google',type=Path);p.add_argument('out',type=Path);a=p.parse_args();b,g,o=a.base,a.google,a.out
assert not o.exists();shutil.copytree(b,o)
A='{http://schemas.android.com/apk/res/android}';E.register_namespace('android',A[1:-1])
bpub=E.parse(b/'res/values/public.xml').getroot();gpub=E.parse(g/'res/values/public.xml').getroot()
types={x.get('type'):int(x.get('id'),16)>>16 for x in gpub};ends={}
for x in gpub: ends[x.get('type')]=max(ends.get(x.get('type'),-1),int(x.get('id'),16)&65535)
ids={};names={}
for x in bpub:
 t,n=x.get('type'),x.get('name');names[t,n]='cp_'+n
 if t not in types:types[t]=max(types.values())+1;ends[t]=-1
 ends[t]+=1;new=(types[t]<<16)|ends[t];ids[int(x.get('id'),16)]=new
 E.SubElement(gpub,'public',{'type':t,'name':'cp_'+n,'id':hex(new)})
shutil.rmtree(o/'res');shutil.copytree(g/'res',o/'res')
def refs(s):
 return re.sub(r'([@?]\+?)([a-z]+)/([\w.]+)',lambda m:m[1]+m[2]+'/'+names.get((m[2],m[3]),m[3]),s)
for f in (b/'res').rglob('*'):
 if not f.is_file() or f.name=='public.xml':continue
 rel=f.relative_to(b/'res');target=o/'res'/rel.parent/('cp_'+rel.name);target.parent.mkdir(parents=True,exist_ok=True)
 if f.suffix!='.xml':shutil.copy2(f,target);continue
 s=refs(f.read_text())
 if rel.parts[0].startswith('values'):
  r=E.fromstring(s)
  for x in r:
   typ=x.get('type',x.tag);n=x.get('name')
   if (typ,n) in names:x.set('name',names[typ,n])
   if x.tag=='style':
    for v in x:
     if ('attr',v.get('name')) in names:v.set('name',names['attr',v.get('name')])
  s=E.tostring(r,encoding='unicode')
 target.write_text(s)
E.ElementTree(gpub).write(o/'res/values/public.xml',encoding='utf-8',xml_declaration=True)
bc={f.relative_to(d).as_posix():f for d in b.glob('smali*') for f in d.rglob('*.smali')};gc={f.relative_to(d).as_posix():f for d in g.glob('smali*') for f in d.rglob('*.smali')}
shared=set(bc)&set(gc);relocate={x[:-6]:'com/copilottw/legacy/'+x[:-6] for x in shared if not x.startswith('android/window/')}
def classes(s):
 for old,new in relocate.items():s=s.replace('L'+old+';','L'+new+';').replace('"'+old.replace('/','.')+'"','"'+new.replace('/','.')+'"')
 return s
for d in list(o.glob('smali*')):shutil.rmtree(d)
for key,f in bc.items():
 if key in shared and key.startswith('android/window/'):continue
 s=classes(f.read_text());s=re.sub(r'0x7f[0-9a-f]{6}\b',lambda m:hex(ids.get(int(m[0],16),int(m[0],16))),s)
 # A relocated ID can no longer be encoded using const/high16.
 s=re.sub(r'const/high16 (\w+), (0x7f[0-9a-f]{6})',r'const \1, \2',s)
 dest=o/'smali'/(relocate.get(key[:-6],key[:-6])+'.smali');dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(s)
for i,d in enumerate(sorted(g.glob('smali*')),2):shutil.copytree(d,o/('smali_classes'+str(i)))
for folder in ['assets','lib','unknown']:
 for f in (g/folder).rglob('*'):
  if not f.is_file():continue
  dest=o/folder/f.relative_to(g/folder)
  if dest.exists() and dest.read_bytes()!=f.read_bytes():
   if folder=='lib':raise RuntimeError('Native collision '+str(dest))
   if 'dexopt' in str(dest):continue
   if folder=='unknown':shutil.copy2(f,dest);continue
   raise RuntimeError('Asset collision '+str(dest))
  dest.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(f,dest)
# Profiles no longer describe merged dex files.
shutil.rmtree(o/'assets/dexopt',ignore_errors=True)
s=refs((b/'AndroidManifest.xml').read_text())
for old,new in relocate.items():s=s.replace(old.replace('/','.'),new.replace('/','.'))
r=E.fromstring(s);gr=E.parse(g/'AndroidManifest.xml').getroot();app=r.find('application');ga=gr.find('application')
existing={(x.tag,x.get(A+'name')) for x in r}
for x in gr:
 if x.tag in ['application','queries']:continue
 if (x.tag,x.get(A+'name')) not in existing:r.append(x)
queries=r.find('queries')
for x in gr.find('queries'):queries.append(x)
for x in ga:
 if x.tag=='activity':
  if A+'theme' not in x.attrib:x.set(A+'theme','@style/Theme.NavDashN')
  for child in list(x):
   if child.tag=='intent-filter' and any(v.get(A+'name')=='android.intent.category.LAUNCHER' for v in child):x.remove(child)
 if x.tag=='provider':x.set(A+'authorities',x.get(A+'authorities').replace('com.copilottw.googlenav','com.jixiexiaoge.drivingassist.wide.google'))
 app.append(x)
for x in list(app):
 if x.get(A+'name')=='com.navipilot.obf.WideCameraService':app.remove(x)
E.ElementTree(r).write(o/'AndroidManifest.xml',encoding='utf-8',xml_declaration=True)
(o/'apktool.yml').write_text((b/'apktool.yml').read_text().replace('26110763','26110764').replace('9.3.1-wide.51-camera-advisory','9.3.1-wide.52-google-integrated'))
(o.parent/'merge-report.json').write_text(json.dumps({'resourceIds':{hex(k):hex(v) for k,v in ids.items()},'relocatedClasses':relocate,'sharedPlatform':sorted(shared-set(x+'.smali' for x in relocate)),'deviceVerified':False},indent=2))
print('Merged resources and classes:',len(ids),len(relocate))
