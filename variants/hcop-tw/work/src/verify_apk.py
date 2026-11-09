from pathlib import Path
import sys,re,json,hashlib,zipfile,subprocess,gzip
sys.path.insert(0,'source/phone15/dualfix-src')
from verify_dualfix import normalize_smali,files
base=Path('work/build/baseline');out=Path('work/build/patched');final=Path('work/build/final-check');apk=Path('work/deliverables/Navipilot-9.3.1-wide.16-hcop-tw-test.apk')
a,b=files(base),files(out);prefixes=('WideCamera','WideSettings','WideRoad','WideHcop','WideBridge')
def allowed(k):return k=='apktool.yml' or k.startswith('assets/tw_hcop') or k=='assets/HCOP-LICENSE.txt' or k.startswith('smali/com/navipilot/obf/') and Path(k).name.startswith(prefixes)
changed=[k for k in a if k not in b or a[k].read_bytes()!=b[k].read_bytes()];added=list(set(b)-set(a));assert all(allowed(k) for k in changed+added),(changed,added)
for cls in ('MG','XG','Ae','IG','Od','Z3','h4','WideDirect','WideLayout','WideGeometry','WideDivider','WideTelemetry','WideLinkDiagnostics'):
 k='smali/com/navipilot/obf/'+cls+'.smali';assert a[k].read_bytes()==b[k].read_bytes(),k
assert a['AndroidManifest.xml'].read_bytes()==b['AndroidManifest.xml'].read_bytes()
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
for k in expected:assert normalize_smali((out/k).read_text())==normalize_smali((final/k).read_text()),k
with zipfile.ZipFile(apk) as z:
 for p in Path('work/assets').rglob('*'):
  if p.is_file():assert z.read('assets/'+str(p.relative_to('work/assets')))==p.read_bytes(),p
 with zipfile.ZipFile('inputs/Navipilot-9.3.1-wide.14-tw-bridge.apk') as old:
  for name in old.namelist():
   if name.startswith('lib/'):assert old.read(name)==z.read(name),name
# Signature identity and installed version are checked from the final APK, not just source settings.
def cert(p):
 s=subprocess.check_output(['bash','work/tools/android-16/apksigner','verify','--verbose','--print-certs',str(p)],text=True);return re.search(r'Signer #1 certificate SHA-256 digest: (.*)',s)[1]
assert cert(apk)==cert('inputs/Navipilot-9.3.1-wide.14-tw-bridge.apk')==cert('inputs/Navipilot-9.3.1-wide.15-phone-bridge.apk')
badging=subprocess.check_output(['work/tools/android-16/aapt2','dump','badging',str(apk)],text=True);assert "versionCode='26110728'" in badging and "versionName='9.3.1-wide.16-hcop-tw-test'" in badging
r={'status':'PASS','versionCode':26110728,'versionName':'9.3.1-wide.16-hcop-tw-test','smaliClassesRoundTrip':len(expected),'appReferencesResolved':refs,'changedFiles':len(changed),'addedFiles':len(added),'coreTransportReceiverControls':'unchanged from wide.14','signatureMatchesWide14And15':True,'minSdk':31,'androidDeviceRun':False,'realDrivingRun':False,'receiverRef':'97830a1ffe5b079c1326da0b97ed065cbb4ea125','sha256':hashlib.sha256(apk.read_bytes()).hexdigest(),'apkBytes':apk.stat().st_size}
Path('work/build/apk-verification.json').write_text(json.dumps(r,indent=2));print(json.dumps(r,indent=2))
