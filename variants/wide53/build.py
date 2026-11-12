#!/usr/bin/env python3
"""Rebuild wide53; signing is external and must match the installed wide52 certificate."""
import argparse,hashlib,json,os,re,shutil,subprocess,sys,zipfile
from pathlib import Path
H=Path(__file__).resolve().parent
p=argparse.ArgumentParser();p.add_argument('--base-apk',type=Path,required=True);p.add_argument('--toolchain',type=Path,required=True);p.add_argument('--output-dir',type=Path,required=True);p.add_argument('--unsigned',action='store_true');a=p.parse_args()
base=a.base_apk.resolve();t=a.toolchain.resolve();w=a.output_dir.resolve();bt=t/'build-tools/android-16';android=t/'platform/android-35/android.jar';api=w/'base-api.jar'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(base)=='9e6fd23f15d4f2de9ce9c78cc4d6eee9435592974e23875957d9f85a312412e1','Wrong base APK'
w.mkdir(exist_ok=False,parents=True);(w/'logs').mkdir()
def run(label,*args,private=False):
 print(label,flush=True);r=subprocess.run(list(map(str,args)),capture_output=True,text=True)
 if not private:(w/'logs'/(label+'.txt')).write_text(r.stdout+r.stderr)
 if r.returncode:raise SystemExit(label+' failed'+(' (private details suppressed)' if private else ': '+r.stdout[-1000:]+r.stderr[-3000:]))
 return r.stdout
jars=list((t/'baksmali').glob('*.jar'));cp=os.pathsep.join(map(str,[t/'asm.jar',*jars]));(w/'api-classes').mkdir()
run('decode','java','-jar',t/'apktool.jar','d','-f',base,'-o',w/'decoded')
with zipfile.ZipFile(base) as z:(w/'base.dex').write_bytes(z.read('classes.dex'))
run('signature-reader','java','-jar',t/'ecj.jar','-8','-proc:none','-nowarn','-cp',cp,'-d',w/'api-classes',H.parent/'wide44/tooling/ApiSignatures44.java',H.parent/'amap-link1/tooling/CheckReferences.java')
run('base-api','java','-cp',str(w/'api-classes')+os.pathsep+cp,'ApiSignatures44',w/'base.dex',api)
src=sorted((H/'src').glob('*.java'));(w/'classes').mkdir();(w/'dex').mkdir();(w/'tests').mkdir()
run('regression-compile','java','-jar',t/'ecj.jar','-8','-proc:none','-nowarn','-d',w/'tests',H/'src/WideViewport.java',H/'src/WideReconnectPolicy.java',H/'tests/Regression.java')
reg=run('regression','java','-cp',w/'tests','com.navipilot.obf.Regression')
run('overlay-compile','java','-jar',t/'ecj.jar','-8','-proc:none','-nowarn','-cp',str(android)+os.pathsep+str(api),'-d',w/'classes',*src)
run('dex','java','-cp',bt/'lib/d8.jar','com.android.tools.r8.D8','--min-api','31','--lib',android,'--classpath',api,'--output',w/'dex',*sorted((w/'classes').rglob('*.class')))
run('smali','java','-cp',os.pathsep.join(map(str,jars)),'org.jf.baksmali.Main','d',w/'dex/classes.dex','-o',w/'generated')
d=w/'decoded/smali/com/navipilot/obf';generated=list((w/'generated/com/navipilot/obf').glob('*.smali'))
for source in src:
 for f in d.glob(source.stem+'*.smali'):
  if f.name==source.stem+'.smali' or f.name.startswith(source.stem+'$'):f.unlink()
for f in generated:shutil.copy2(f,d/f.name)
run('hooks','python3',H/'patch.py',w/'decoded')
run('assemble','java','-jar',t/'apktool.jar','b',w/'decoded','-o',w/'unsigned.apk')
aligned=w/'aligned.apk';run('align',bt/'zipalign','-P','16','-f','4',w/'unsigned.apk',aligned)
final=w/'Copilot-tw-9.3.1-wide.53-adaptive-dashboard.apk';certificate=None
if a.unsigned:final=w/'wide53-UNSIGNED.apk';shutil.copyfile(aligned,final)
else:
 key=os.environ.get('COPILOT_SIGNING_KEY','');assert Path(key).is_file(),'External signing key unavailable'
 run('sign','java','-jar',bt/'lib/apksigner.jar','sign','--ks',key,'--ks-key-alias',os.environ['COPILOT_KEY_ALIAS'],'--ks-pass','env:COPILOT_STORE_PASSWORD','--key-pass','env:COPILOT_KEY_PASSWORD','--out',final,aligned,private=True)
 before=run('base-certificate','java','-jar',bt/'lib/apksigner.jar','verify','--print-certs',base)
 after=run('certificate','java','-jar',bt/'lib/apksigner.jar','verify','--verbose','--print-certs',final)
 pattern=r'certificate SHA-256 digest: ([a-f0-9]+)';assert re.findall(pattern,before)==re.findall(pattern,after)
 certificate=re.findall(pattern,after)[0]
run('alignment-check',bt/'zipalign','-c','-P','16','4',final)
classes=['Lcom/navipilot/obf/'+f.stem+';' for f in generated]+['Lcom/navipilot/obf/XN;','Lcom/navipilot/obf/MD;','Lcom/navdashn/MainActivity;','Lcom/navdashn/GuidanceActivity;','Lcom/navdashn/KeyEntryActivity;','Lcom/navipilot/amap2tesla/privileged/PrivilegedDisplayService;']
(w/'classes.txt').write_text('\n'.join(classes));ref=run('references','java','-cp',str(w/'api-classes')+os.pathsep+cp,'CheckReferences',final,w/'classes.txt',android)
with zipfile.ZipFile(base) as old,zipfile.ZipFile(final) as new:
 for name in old.namelist():
  if name.startswith(('lib/','assets/')):assert old.read(name)==new.read(name),name
run('audit','python3',H/'tests/audit.py',w/'decoded')
report={'version':'wide.53','sha256':sha(final),'bytes':final.stat().st_size,'sameCertificateSha256':certificate,'alignment16KiB':True,'regression':reg.strip(),'references':json.loads(ref),'deviceTest':False,'baseVersionUserReportedUsable':True,'sourceHashes':{f.name:sha(f) for f in src}}
(w/'verification.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n');print(final)
