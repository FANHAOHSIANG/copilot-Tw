import os,json,pathlib,subprocess,hashlib,shutil
P=pathlib.Path(__file__).resolve().parent
base=pathlib.Path(os.environ['COPILOT_BASE_APK']);tool=os.environ['COPILOT_APKTOOL'];bt=pathlib.Path(os.environ['COPILOT_BUILD_TOOLS'])
assert hashlib.sha256(base.read_bytes()).hexdigest()==json.loads((P/'verification/verification.json').read_text())['baseSha256'],'Unexpected base APK'
build=P/'rebuild';assert not build.exists();build.mkdir();decoded=build/'decoded'
def run(*args):subprocess.run(list(map(str,args)),check=True)
run('java','-jar',tool,'d','-f',base,'-o',decoded)
for f in (P/'smali').glob('*.smali'):shutil.copyfile(f,decoded/'smali/com/navipilot/obf'/f.name)
f=decoded/'apktool.yml';f.write_text(f.read_text().replace('26110749','26110751').replace('9.3.1-wide.37-highway-alert','9.3.1-wide.39-amap-bound'))
f=decoded/'smali/com/navipilot/obf/Yg.smali';f.write_text(f.read_text().replace('9.3.1-wide.37-highway-alert (26110749)','9.3.1-wide.39-amap-bound (26110751)'))
run('java','-jar',tool,'b',decoded,'-o',build/'unsigned.apk')
run(bt/'zipalign','-P','16','-f','4',build/'unsigned.apk',build/'aligned.apk')
final=build/'Copilot-tw-9.3.1-wide.39-amap-bound.apk'
run('java','-jar',bt/'lib/apksigner.jar','sign','--ks',os.environ['COPILOT_SIGNING_KEY'],'--ks-key-alias',os.environ['COPILOT_KEY_ALIAS'],'--ks-pass','env:COPILOT_STORE_PASSWORD','--key-pass','env:COPILOT_KEY_PASSWORD','--out',final,build/'aligned.apk')
run('java','-jar',bt/'lib/apksigner.jar','verify','--verbose',final)
run(bt/'zipalign','-c','-P','16','4',final)
print(final)
