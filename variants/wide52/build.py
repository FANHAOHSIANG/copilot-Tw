#!/usr/bin/env python3
"""Rebuild the single-APK test candidate from pinned, signed input APKs.
Signing secrets are supplied only by environment variables; never embedded.
"""
import argparse,hashlib,os,subprocess,shutil,sys
from pathlib import Path
H=Path(__file__).resolve().parent
p=argparse.ArgumentParser();p.add_argument('--base-apk',type=Path,required=True);p.add_argument('--google-apk',type=Path,required=True);p.add_argument('--toolchain',type=Path,required=True);p.add_argument('--output-dir',type=Path,required=True);p.add_argument('--base-api',type=Path,required=True,help='ApiSignatures output from the pinned CoPilot base');a=p.parse_args()
for f,expected in [(a.base_apk,'4146c5279264599e088c1bfc13f6af177cd337671f59d61502e957085d272e44'),(a.google_apk,'f4640bb63a1496f93911789ddb33137a58699df6c05e7f988922f09a14e1d14e')]:
 assert hashlib.sha256(f.read_bytes()).hexdigest()==expected,'Unexpected input APK'
w=a.output_dir.resolve();w.mkdir(parents=True,exist_ok=False);t=a.toolchain.resolve();bt=t/'build-tools/android-16';android=t/'platform/android-35/android.jar';api=a.base_api.resolve()
def run(*args):subprocess.run(list(map(str,args)),check=True)
for name,apk in [('base',a.base_apk),('google',a.google_apk)]:run('java','-jar',t/'apktool.jar','d','-f',apk.resolve(),'-o',w/name)
run(sys.executable,H/'merge.py',w/'base',w/'google',w/'decoded')
(w/'classes').mkdir();(w/'dex').mkdir()
run('java','-jar',t/'ecj.jar','-8','-proc:none','-nowarn','-cp',str(android)+os.pathsep+str(api),'-d',w/'classes',*sorted((H/'src').glob('*.java')))
run('java','-cp',bt/'lib/d8.jar','com.android.tools.r8.D8','--min-api','31','--lib',android,'--classpath',api,'--output',w/'dex',*sorted((w/'classes').rglob('*.class')))
run('java','-cp',os.pathsep.join(map(str,(t/'baksmali').glob('*.jar'))),'org.jf.baksmali.Main','d',w/'dex/classes.dex','-o',w/'generated')
run(sys.executable,H/'patch.py',w/'decoded');run(sys.executable,H/'finish_patch.py',w/'decoded')
dest=w/'decoded/smali/com/navipilot/obf'
for f in dest.glob('WideSpeedHost*.smali'):f.unlink()
for f in (w/'generated/com/navipilot/obf').glob('*.smali'):shutil.copy2(f,dest/f.name)
run(sys.executable,H/'audit.py',w/'decoded',w/'google')
run('java','-jar',t/'apktool.jar','b',w/'decoded','-o',w/'unsigned.apk')
run(bt/'zipalign','-P','16','-f','4',w/'unsigned.apk',w/'aligned.apk')
final=w/'Copilot-tw-9.3.1-wide.52-google-integrated-test.apk'
args=['java','-jar',str(bt/'lib/apksigner.jar'),'sign','--ks',os.environ['COPILOT_SIGNING_KEY'],'--ks-key-alias',os.environ['COPILOT_KEY_ALIAS'],'--ks-pass','env:COPILOT_STORE_PASSWORD','--key-pass','env:COPILOT_KEY_PASSWORD','--out',str(final),str(w/'aligned.apk')]
r=subprocess.run(args,capture_output=True);assert r.returncode==0,'Private signing failed'
run('java','-jar',bt/'lib/apksigner.jar','verify','--verbose','--print-certs',final)
run(bt/'zipalign','-c','-P','16','4',final)
print('SHA256',hashlib.sha256(final.read_bytes()).hexdigest())
