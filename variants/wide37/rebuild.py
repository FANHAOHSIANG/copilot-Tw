"""Rebuild the exact helper overlay onto a hash-pinned wide.36 base."""
import os,json,pathlib,subprocess,hashlib,shutil
P=pathlib.Path(__file__).resolve().parent
base=pathlib.Path(os.environ['COPILOT_BASE_APK']);tool=os.environ['COPILOT_APKTOOL'];bt=pathlib.Path(os.environ['COPILOT_BUILD_TOOLS'])
expected=json.loads((P/'verification/verification.json').read_text())['baseSha256']
assert hashlib.sha256(base.read_bytes()).hexdigest()==expected,'Unexpected baseline APK'
build=P/'rebuild';assert not build.exists(),'Use a fresh rebuild directory'
build.mkdir();decoded=build/'decoded'
def run(*args):subprocess.run(list(map(str,args)),check=True)
run('java','-jar',tool,'d','-f',base,'-o',decoded)
for f in (P/'smali').glob('*.smali'):shutil.copyfile(f,decoded/'smali/com/navipilot/obf'/f.name)
f=decoded/'apktool.yml';s=f.read_text();assert '26110748' in s;s=s.replace('26110748','26110749').replace('9.3.1-wide.36-camera-trace','9.3.1-wide.37-highway-alert');f.write_text(s)
f=decoded/'smali/com/navipilot/obf/Yg.smali';s=f.read_text();assert '9.3.1-wide.36-camera-trace (26110748)' in s;f.write_text(s.replace('9.3.1-wide.36-camera-trace (26110748)','9.3.1-wide.37-highway-alert (26110749)'))
f=decoded/'smali/com/navipilot/obf/WideCamera.smali';s=f.read_text();old='\\u540c\\u8def\\u6bb5\\u56fa\\u5b9a\\u6e2c\\u901f';assert old in s;f.write_text(s.replace(old,'同向路線固定測速'))
run('java','-jar',tool,'b',decoded,'-o',build/'unsigned.apk')
run(bt/'zipalign','-P','16','-f','4',build/'unsigned.apk',build/'aligned.apk')
final=build/'Copilot-tw-9.3.1-wide.37-highway-alert.apk'
run('java','-jar',bt/'lib/apksigner.jar','sign','--ks',os.environ['COPILOT_SIGNING_KEY'],'--ks-key-alias',os.environ['COPILOT_KEY_ALIAS'],'--ks-pass','env:COPILOT_STORE_PASSWORD','--key-pass','env:COPILOT_KEY_PASSWORD','--out',final,build/'aligned.apk')
run('java','-jar',bt/'lib/apksigner.jar','verify','--verbose',final)
run(bt/'zipalign','-c','-P','16','4',final)
print(final)
