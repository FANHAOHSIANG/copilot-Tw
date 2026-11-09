from pathlib import Path
import shutil,json
BASE=Path('work/build/baseline');OUT=Path('work/build/patched')
PREFIX=('WideCamera','WideSettings','WideRoad','WideHcop','WideBridge')
assert not OUT.exists(), 'Use a fresh build directory'
meta=json.loads(Path('work/assets/tw_hcop_metadata.json').read_text());assert meta['edges']==1159186 and meta['tiles']==5927 and meta['matchedCameras']==482
shutil.copytree(BASE,OUT,ignore=lambda d,n:[x for x in n if Path(d)==BASE and x in ('build','dist')])
sm=OUT/'smali/com/navipilot/obf'
for f in sm.glob('*.smali'):
 if f.name.startswith(PREFIX):f.unlink()
for f in Path('work/build/helper-decoded/smali/com/navipilot/obf').glob('*.smali'):
 assert f.name.startswith(PREFIX) and 'Test' not in f.name,f
 shutil.copy(f,sm/f.name)
shutil.copytree('work/assets',OUT/'assets',dirs_exist_ok=True)
shutil.copy('work/upstream/hcop-LICENSE',OUT/'assets/HCOP-LICENSE.txt')
p=OUT/'apktool.yml';s=p.read_text();assert 'versionCode: 26110726' in s;s=s.replace('versionCode: 26110726','versionCode: 26110728').replace('versionName: 9.3.1-wide.14-tw-bridge','versionName: 9.3.1-wide.16-hcop-tw-test');p.write_text(s)
print('Patched',meta['edges'],'road edges; existing transport unchanged')
