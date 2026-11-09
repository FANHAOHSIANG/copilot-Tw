from pathlib import Path
import sys,re,json,hashlib,zipfile,subprocess,gzip
sys.path.insert(0,'source/phone15/dualfix-src')
from verify_dualfix import normalize_smali,files
base=Path('adaptive17-build/baseline');out=Path('adaptive17-build/patched');final=Path('adaptive17-build/final-check');apk=Path('deliverables/CoPilot-Tw-9.3.1-wide.17-hcop-tw-adaptive.apk')
a,b=files(base),files(out);prefixes=('WideGeometry','WideLayout','WideDivider','WideDirect','WideSettings','WideInsets','WideVariant','WideCameraPanel','WideTaiwan')
def allowed(k):return k in ('apktool.yml','AndroidManifest.xml','smali/com/navipilot/obf/XN.smali') or (k.startswith('res/values') and k.endswith('/strings.xml')) or k.startswith('smali/com/navipilot/obf/') and Path(k).name.startswith(prefixes)
changed=[k for k in a if k not in b or a[k].read_bytes()!=b[k].read_bytes()];added=list(set(b)-set(a));assert all(allowed(k) for k in changed+added),(changed,added)
for cls in ('MG','XG','Ae','IG','Od','Z3','h4','WideCamera','WideHcop','WideHcopRoad','WideHcopMerge','WideBridge','WideBridgeLog','WideTelemetry','WideLinkDiagnostics'):
 k='smali/com/navipilot/obf/'+cls+'.smali';assert a[k].read_bytes()==b[k].read_bytes(),k
assert a['AndroidManifest.xml'].read_text().replace('android:name="com.jixiexiaoge.drivingassist.MainActivity"','android:name="com.jixiexiaoge.drivingassist.MainActivity" android:resizeableActivity="true"')==b['AndroidManifest.xml'].read_text()
classes={}
for p in out.glob('smali*/**/*.smali'):
 s=p.read_text();owner=re.search(r'^\.class[^\n]*? (L[^;]+;)$',s,re.M)[1];assert owner not in classes
 classes[owner]=(re.findall(r'^\.(?:super|implements) (L[^;]+;)$',s,re.M),set(re.findall(r'^\.method .*? (\S+\(\S*)$',s,re.M)),set(re.findall(r'^\.field .*? (\S+:\S+?)(?: = .*|)$',s,re.M)))
def resolve(owner,name,method,seen=None):
 seen=set() if seen is None else seen
 if owner in seen:return False
 seen.add(owner)
 if owner not in classes:return owner.startswith(('Landroid/','Ljava/','Lorg/json/'))
 parents,methods,fields=classes[owner];return name in(methods if method else fields)or any(resolve(p,name,method,seen)for p in parents)
refs=0
for p in out.glob('smali/com/navipilot/obf/Wide*.smali'):
 if not p.name.startswith(prefixes):continue
 assert 'Test' not in p.name
 s=p.read_text()
 for owner,name in re.findall(r'(L[^\s;]+;)->([^\s,]+)',s):
  if owner in classes:assert resolve(owner,name,'(' in name),(p.name,owner,name);refs+=1
 if p.name.startswith('WideHcop'):assert 'Ljava/net/' not in s
expected={str(p.relative_to(out)) for p in out.glob('smali*/**/*.smali')};actual={str(p.relative_to(final)) for p in final.glob('smali*/**/*.smali')};assert expected==actual
def canonical(s):
 # DEX may omit a trailing static boolean initializer equal to the JVM default.
 return normalize_smali(re.sub(r'(^\.field .*?:Z) = false$',r'\1',s,flags=re.M))
for k in expected:assert canonical((out/k).read_text())==canonical((final/k).read_text()),k
with zipfile.ZipFile(apk) as z:
 with zipfile.ZipFile('inputs/hcop16.apk') as old:
  for name in old.namelist():
   if name.startswith(('lib/','assets/')):assert old.read(name)==z.read(name),name
# Signature identity and installed version are checked from the final APK, not just source settings.
def cert(p):
 s=subprocess.check_output(['bash','work/tools/android-16/apksigner','verify','--verbose','--print-certs',str(p)],text=True);return re.search(r'Signer #1 certificate SHA-256 digest: (.*)',s)[1]
assert cert(apk)==cert('inputs/hcop16.apk')
badging=subprocess.check_output(['work/tools/android-16/aapt2','dump','badging',str(apk)],text=True);assert "versionCode='26110729'" in badging and "versionName='9.3.1-wide.17-hcop-tw-adaptive'" in badging
assert "application-label:'CoPilot Tw'" in badging
r={'status':'PASS','versionCode':26110729,'versionName':'9.3.1-wide.17-hcop-tw-adaptive','smaliClassesRoundTrip':len(expected),'appReferencesResolved':refs,'changedFiles':len(changed),'addedFiles':len(added),'coreTransportReceiverControls':'unchanged from HCOP wide.16','signatureMatchesHCOP16':True,'minSdk':31,'androidDeviceRun':False,'realDrivingRun':False,'receiverRef':'97830a1ffe5b079c1326da0b97ed065cbb4ea125','sha256':hashlib.sha256(apk.read_bytes()).hexdigest(),'apkBytes':apk.stat().st_size}
Path('adaptive17-build/apk-verification.json').write_text(json.dumps(r,indent=2));print(json.dumps(r,indent=2))
