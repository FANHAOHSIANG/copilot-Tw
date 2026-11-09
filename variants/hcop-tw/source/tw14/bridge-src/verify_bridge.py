from pathlib import Path
import sys,re,json,hashlib,argparse,xml.etree.ElementTree as ET,zipfile
sys.path.insert(0,str(Path(__file__).resolve().parent.parent/'dualfix-src'))
from verify_dualfix import normalize_smali,files,method,SERVICE
PREF=('WideCamera','WideSettings','WideRoad','WideSpeedMerge','WideBridge')
def verify(base,out,final=None,apk=None):
 a,b=files(base),files(out)
 changes=sorted(k for k in a if k not in b or a[k].read_bytes()!=b[k].read_bytes())
 added=sorted(set(b)-set(a))
 allowed=lambda k:k in ('apktool.yml','assets/tw_corridors.json','smali/com/navipilot/obf/MG.smali','smali/com/navipilot/obf/XG.smali','smali/com/navipilot/obf/Ae.smali') or k.startswith('smali/com/navipilot/obf/') and Path(k).name.startswith(PREF)
 assert all(allowed(k) for k in changes),changes
 assert all(k=='assets/tw_sections.json' or allowed(k) for k in added),added
 # Every original navigation receiver, sender, vehicle control method, retry handler,
 # display manager and drag layout must remain identical to the auto .11 baseline.
 protected=[SERVICE]+['smali/com/navipilot/obf/'+n+'.smali' for n in ('Od','h4','xe','ye','ze','WideGeometry','WideDivider','WideLayout','WideTelemetry','WideLinkDiagnostics')]
 for k in protected:assert a[k].read_bytes()==b[k].read_bytes(),k
 create=method(b[SERVICE].read_text(),'f(Ljava/lang/String;IIIFLandroid/view/Surface;)I')
 assert '->a(I)V' not in create
 assert 'DatagramSocket' in b['smali/com/navipilot/obf/Od.smali'].read_text()
 classes={}
 for p in out.glob('smali*/**/*.smali'):
  s=p.read_text();owner=re.search(r'^\.class[^\n]*? (L[^;]+;)$',s,re.M)[1]
  assert owner not in classes,owner
  classes[owner]=(re.findall(r'^\.(?:super|implements) (L[^;]+;)$',s,re.M),set(re.findall(r'^\.method .*? (\S+\(\S*)$',s,re.M)),set(re.findall(r'^\.field .*? (\S+:\S+?)(?: = .*|)$',s,re.M)))
 def resolve(owner,name,is_method,seen=None):
  seen=set() if seen is None else seen
  if owner in seen:return False
  seen.add(owner)
  if owner not in classes:return owner.startswith(('Landroid/','Ljava/','Lorg/json/'))
  parents,methods,fields=classes[owner]
  return name in (methods if is_method else fields) or any(resolve(p,name,is_method,seen) for p in parents)
 refs=0
 for p in out.glob('smali/com/navipilot/obf/Wide*.smali'):
  if not p.name.startswith(PREF):continue
  s=p.read_text()
  for owner,name in re.findall(r'(L[^\s;]+;)->([^\s,]+)',s):
   if owner in classes:assert resolve(owner,name,'(' in name),(p.name,owner,name);refs+=1
  if p.name.startswith(('WideCamera','WideRoad')):
   assert not re.search(r'Ljava/net/|Lcom/navipilot/obf/(?:Od|h4|Ae);',s),p
  assert not any(v in p.name for v in ('Test','Preview')),p
 shield=method(b['smali/com/navipilot/obf/WideDirect.smali'].read_text(),'shield(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;')
 assert '->compose' not in shield
 combined='\n'.join(p.read_text() for p in out.glob('smali/com/navipilot/obf/WideDirect*.smali'))
 assert 'WideCameraPanel;-><init>' in combined
 assert 'WideTelemetry;->init' in b['smali/com/navipilot/obf/WideSettings.smali'].read_text()
 manifest=ET.parse(out/'AndroidManifest.xml');ns='{http://schemas.android.com/apk/res/android}'
 services=[s for s in manifest.findall('.//service') if s.get(ns+'name')=='com.navipilot.obf.WideCameraService']
 assert len(services)==1 and services[0].get(ns+'exported')=='false' and services[0].get(ns+'foregroundServiceType')=='location'
 doc=json.loads(b['assets/tw_cameras.json'].read_text());pts=doc['points'];meta=doc['metadata']
 assert len(pts)==meta['fixedRecords'] and len({x['id'] for x in pts})==len(pts)
 for x in pts:
  assert 20<=x['lat']<=27 and 116<=x['lon']<=124 and 20<=x['limit']<=130
  assert '區間' not in x['road']+x['direction']
  assert all(0<=v<360 for v in x['bearings'])
 section_doc=json.loads(b['assets/tw_sections.json'].read_text())
 assert len(section_doc['sections'])==section_doc['metadata']['directionalSections']==24
 assert a['assets/tw_cameras.json'].read_bytes()==b['assets/tw_cameras.json'].read_bytes()
 for section in section_doc['sections']:assert section['lengthM']>=section['chordM']*.98 and section['roadMatched'] is False
 assert a['AndroidManifest.xml'].read_bytes()==b['AndroidManifest.xml'].read_bytes()
 # Validate exact integration seams and every unchanged original method outside those seams.
 for cls,signature in [('MG','b(Ljava/lang/String;Lorg/json/JSONObject;Ljava/lang/String;)V'),('XG','f(Ljava/lang/String;Lcom/navipilot/obf/s30;Ljava/lang/String;)Z'),('Ae','f(Lcom/navipilot/obf/zg;)V')]:
  key='smali/com/navipilot/obf/'+cls+'.smali';old=a[key].read_text();new=b[key].read_text()
  assert old.replace(method(old,signature),'')==new.replace(method(new,signature),'')
 assert 'WideBridge;->merge' in b['smali/com/navipilot/obf/MG.smali'].read_text()
 assert 'WideBridge;->queued' in b['smali/com/navipilot/obf/XG.smali'].read_text()
 assert 'WideBridge;->telemetry' in b['smali/com/navipilot/obf/Ae.smali'].read_text()
 roads=json.loads(b['assets/tw_corridors.json'].read_text());assert len(roads['corridors'])==roads['metadata']['eligibleCameras']==226
 assert all(c['dirs'] and 20<=c['limit']<=130 and len(c['xy'])>=2 for c in roads['corridors'])
 count=0
 if final:
  expected={str(p.relative_to(out)) for p in out.glob('smali*/**/*.smali')};actual={str(p.relative_to(final)) for p in final.glob('smali*/**/*.smali')}
  assert expected==actual
  for k in expected:assert normalize_smali((out/k).read_text())==normalize_smali((final/k).read_text()),k;count+=1
 report={'status':'PASS','versionCode':26110726,'versionName':'9.3.1-wide.14-tw-bridge','changed_file_count':len(changes),'added_file_count':len(added),'app_method_references_checked':refs,'packaged_classes_verified':count,'camera_records':len(pts),'directional_sections':len(section_doc['sections']),'known_direction_records':meta['knownDirectionRecords'],'camera_network_or_control_output':'Existing Navi v2 speed stream merged; no second navigation sender; read-only HTTP receipt check; default Amap per process','original_auto_navigation_controls_telemetry_drag':'speed stream merge + observational enqueue/receipt hooks only; UDP/manual/turn/drag preserved','android_device_runtime':'NOT RUN','gps_distance':'226 eligible fixed cameras: junction-bounded OSM polyline; other fixed/section display only','server_timeout_fix':'NOT CLAIMED'}
 if apk:
  with zipfile.ZipFile(apk) as z:assert z.read('assets/tw_cameras.json')==b['assets/tw_cameras.json'].read_bytes()
  report['apk_sha256']=hashlib.sha256(apk.read_bytes()).hexdigest()
 return report
if __name__=='__main__':
 p=argparse.ArgumentParser();p.add_argument('base',type=Path);p.add_argument('out',type=Path);p.add_argument('--final',type=Path);p.add_argument('--apk',type=Path);a=p.parse_args();print(json.dumps(verify(a.base,a.out,a.final,a.apk),ensure_ascii=False,indent=2))
