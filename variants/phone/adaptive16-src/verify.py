from pathlib import Path
import sys,re,json,hashlib,xml.etree.ElementTree as ET
sys.path.insert(0,str(Path(__file__).resolve().parent.parent/'dualfix-src'))
from verify_dualfix import normalize_smali,files,method,SERVICE

flavor=sys.argv[1];build=Path('adaptive16-build')/flavor
base,out,final=(build/n for n in ('baseline','patched','final-check'))
a,b=files(base),files(out)
prefixes=('WideGeometry','WideLayout','WideSettings','WideDivider','WideDirect','WideInsets','WideVariant')
def allowed(k):
 return k in ('apktool.yml','AndroidManifest.xml','smali/com/navipilot/obf/XN.smali') or k.startswith('smali/com/navipilot/obf/') and Path(k).name.startswith(prefixes)
changed=sorted(k for k in a if k not in b or a[k].read_bytes()!=b[k].read_bytes());added=sorted(set(b)-set(a))
assert all(allowed(k) for k in changed+added),(changed,added)
for k in a:
 if not allowed(k):assert a[k].read_bytes()==b[k].read_bytes(),k
for n in ('Od','MG','IG','Z3','h4','Ae','XG','xe','ye','ze','WideTelemetry','WideLinkDiagnostics'):
 k='smali/com/navipilot/obf/'+n+'.smali';assert a[k].read_bytes()==b[k].read_bytes(),k
assert a[SERVICE].read_bytes()==b[SERVICE].read_bytes()
assert '->a(I)V' not in method(b[SERVICE].read_text(),'f(Ljava/lang/String;IIIFLandroid/view/Surface;)I')
sig='reconnect(ZZJJJZ)Z';k='smali/com/navipilot/obf/WideGeometry.smali'
assert method(a[k].read_text(),sig)==method(b[k].read_text(),sig)
if flavor=='phone':
 for k in a:
  if Path(k).name.startswith(('WideNavProbe','WideNavNotifications')):assert a[k].read_bytes()==b[k].read_bytes(),k
pane=b['smali/com/navipilot/obf/WideDirect$Pane.smali'].read_text()
assert ('"com.autonavi.minimap"' if flavor=='phone' else '"com.autonavi.amapauto"') in pane
assert '"tw.com.ainvest.outpack"' in pane
ns='{http://schemas.android.com/apk/res/android}'
manifest=ET.parse(out/'AndroidManifest.xml');activity=manifest.find('.//activity[@'+ns+'name="com.jixiexiaoge.drivingassist.MainActivity"]')
assert activity is not None and activity.get(ns+'resizeableActivity')=='true'
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
for p in out.glob('smali/com/navipilot/obf/*.smali'):
 if not p.name.startswith(prefixes+('XN.',)):continue
 for owner,name in re.findall(r'(L[^\s;]+;)->([^\s,]+)',p.read_text()):
  if owner in classes:assert resolve(owner,name,'(' in name),(p.name,owner,name);refs+=1
expected={str(p.relative_to(out)) for p in out.glob('smali*/**/*.smali')};actual={str(p.relative_to(final)) for p in final.glob('smali*/**/*.smali')};assert actual==expected
def normalized(s):
 # The assembler omits an explicit false initializer because the DEX default is false.
 return re.sub(r'(?m)^(\.field [^\n]+:Z) = false$',r'\1',normalize_smali(s))
for k in expected:assert normalized((out/k).read_text())==normalized((final/k).read_text()),k
apk=Path('deliverables')/('Navipilot-9.3.1-wide.16-'+flavor+'-adaptive.apk')
print(json.dumps({'status':'PASS','flavor':flavor,'versionCode':26110728,'sha256':hashlib.sha256(apk.read_bytes()).hexdigest(),'changed_files':changed,'added_classes':len(added),'member_references_checked':refs,'packaged_classes_verified':len(expected),'navigation_and_control_code':'UNCHANGED from '+('auto11' if flavor=='auto' else 'phone15'),'watchdog_and_dual_display_service':'UNCHANGED','device_runtime':'NOT RUN; device validation required'},ensure_ascii=False,indent=2))
