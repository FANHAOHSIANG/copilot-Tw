from pathlib import Path
import sys,re,json,hashlib,xml.etree.ElementTree as ET
sys.path.insert(0,str(Path(__file__).resolve().parent.parent/'dualfix-src'))
from verify_dualfix import normalize_smali,files,method,SERVICE

def verify(base,out,final=None):
 a,b=files(base),files(out)
 names=('S3','VC','SC','TC','h4','XG','Ae')
 prefixes=('WideDirect','WideSettings','WideNavProbe','WideNavNotifications')
 def allowed(k):return k in ('apktool.yml','AndroidManifest.xml') or k in ['smali/com/navipilot/obf/'+n+'.smali' for n in names] or k.startswith('smali/com/navipilot/obf/') and Path(k).name.startswith(prefixes)
 changes=sorted(k for k in a if k not in b or a[k].read_bytes()!=b[k].read_bytes());added=sorted(set(b)-set(a))
 assert all(allowed(k) for k in changes+added),(changes,added)
 protected=[SERVICE]+['smali/com/navipilot/obf/'+n+'.smali' for n in ('Od','MG','IG','Z3','xe','ye','ze','WideGeometry','WideDivider','WideLayout','WideTelemetry','WideLinkDiagnostics')]
 for k in protected:assert a[k].read_bytes()==b[k].read_bytes(),k
 assert 'DatagramSocket' in b['smali/com/navipilot/obf/Od.smali'].read_text()
 assert '->a(I)V' not in method(b[SERVICE].read_text(),'f(Ljava/lang/String;IIIFLandroid/view/Surface;)I')
 k='smali/com/navipilot/obf/h4.smali';addition='\n    invoke-static {p1}, Lcom/navipilot/obf/WideNavProbe;->broadcast(Landroid/content/Intent;)V\n';assert b[k].read_text().count(addition)==1;assert b[k].read_text().replace(addition,'')==a[k].read_text()
 for cls,sig in [('XG','f(Ljava/lang/String;Lcom/navipilot/obf/s30;Ljava/lang/String;)Z'),('Ae','f(Lcom/navipilot/obf/zg;)V')]:
  k='smali/com/navipilot/obf/'+cls+'.smali';old=a[k].read_text();new=b[k].read_text();assert old.replace(method(old,sig),'')==new.replace(method(new,sig),'')
 pane=b['smali/com/navipilot/obf/WideDirect$Pane.smali'].read_text();assert '"com.autonavi.minimap"' in pane and '"tw.com.ainvest.outpack"' in pane and '"com.autonavi.amapauto"' not in pane
 assert 'WideTelemetry;->init' in b['smali/com/navipilot/obf/WideSettings.smali'].read_text()
 ns='{http://schemas.android.com/apk/res/android}';manifest=ET.parse(out/'AndroidManifest.xml');services=[s for s in manifest.findall('.//service') if s.get(ns+'name')=='com.navipilot.obf.WideNavNotifications'];assert len(services)==1 and services[0].get(ns+'permission')=='android.permission.BIND_NOTIFICATION_LISTENER_SERVICE'
 classes={}
 for p in out.glob('smali*/**/*.smali'):
  s=p.read_text();owner=re.search(r'^\.class[^\n]*? (L[^;]+;)$',s,re.M)[1];assert owner not in classes
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
  if not p.name.startswith(prefixes):continue
  s=p.read_text()
  for owner,name in re.findall(r'(L[^\s;]+;)->([^\s,]+)',s):
   if owner in classes:assert resolve(owner,name,'(' in name),(p.name,owner,name);refs+=1
  if p.name.startswith(('WideNavProbe','WideNavNotifications')):
   assert not re.search(r'Ljava/net/|Lcom/navipilot/obf/(?:h4|Od|MG|XG|IG|Z3);',s),p
 count=0
 if final:
  expected={str(p.relative_to(out)) for p in out.glob('smali*/**/*.smali')};actual={str(p.relative_to(final)) for p in final.glob('smali*/**/*.smali')};assert actual==expected
  for k in expected:assert normalize_smali((out/k).read_text())==normalize_smali((final/k).read_text()),k;count+=1
 return {'status':'PASS','versionCode':26110727,'versionName':'9.3.1-wide.15-phone-bridge','changes':changes,'added_classes':len(added),'app_method_references_checked':refs,'packaged_classes_verified':count,'core_same_as_auto11':['MG','IG','Z3','Od'],'receiver_h4':'identical except diagnostic observer','navi_transport_XG':'original send preserved; observe enqueue result only','notification_to_control':'NONE; text/extras/snapshots diagnostic only','dual_display_fix':'PRESERVED','android_runtime':'NOT RUN','phone_navigation_and_speed_data':'NEEDS DEVICE SOURCE + RECEIVER VERIFICATION'}
if __name__=='__main__':
 report=verify(Path('phone15-build/baseline'),Path('phone15-build/patched'),Path('phone15-build/final-check'))
 report['apk_sha256']=hashlib.sha256(Path('deliverables/Navipilot-9.3.1-wide.15-phone-bridge.apk').read_bytes()).hexdigest()
 print(json.dumps(report,ensure_ascii=False,indent=2))
