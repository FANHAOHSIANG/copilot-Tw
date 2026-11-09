#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
android_tools="${ANDROID_BUILD_TOOLS:-$PWD/tools/build-tools/android-16}"
python3 - <<'PY'
from pathlib import Path
import shutil
base=Path('bridge-build/baseline');out=Path('bridge-build/restore')
if out.exists():raise FileExistsError(out)
shutil.copytree(base,out,ignore=lambda d,n:[x for x in n if Path(d)==base and x in ('build','dist')])
p=out/'apktool.yml';s=p.read_text();assert 'versionCode: 26110725' in s
p.write_text(s.replace('versionCode: 26110725','versionCode: 26110726').replace('versionName: 9.3.1-wide.13-camera-alerts','versionName: 9.3.1-wide.13-camera-restore'))
for p in base.rglob('*'):
 if p.is_file() and p.name!='apktool.yml':assert p.read_bytes()==(out/p.relative_to(base)).read_bytes()
PY
java -jar tools/apktool.jar b bridge-build/restore -o bridge-build/restore-unsigned.apk
"$android_tools/zipalign" -P 16 -f 4 bridge-build/restore-unsigned.apk bridge-build/restore-aligned.apk
bash "$android_tools/apksigner" sign --ks project/wide-build/signing/navipilot-wide-test.jks --ks-key-alias navipilot-wide-test --ks-pass pass:android --key-pass pass:android --out deliverables/Navipilot-9.3.1-wide.13-camera-restore-build26.apk bridge-build/restore-aligned.apk
bash "$android_tools/apksigner" verify --verbose --print-certs deliverables/Navipilot-9.3.1-wide.13-camera-restore-build26.apk > bridge-build/restore-signature.txt
"$android_tools/zipalign" -c -P 16 4 deliverables/Navipilot-9.3.1-wide.13-camera-restore-build26.apk
java -jar tools/apktool.jar d -r -f deliverables/Navipilot-9.3.1-wide.13-camera-restore-build26.apk -o bridge-build/restore-check
python3 - <<'PY'
from pathlib import Path
import sys,json,hashlib
sys.path.insert(0,'dualfix-src')
from verify_dualfix import normalize_smali
base=Path('bridge-build/baseline');out=Path('bridge-build/restore-check');count=0
for p in base.glob('smali*/**/*.smali'):
 assert normalize_smali(p.read_text())==normalize_smali((out/p.relative_to(base)).read_text());count+=1
r={'status':'PASS','smali_classes_unchanged':count,'versionCode':26110726,'camera_module':'wide.13 unchanged','sha256':hashlib.sha256(Path('deliverables/Navipilot-9.3.1-wide.13-camera-restore-build26.apk').read_bytes()).hexdigest()}
Path('bridge-build/restore-verification.json').write_text(json.dumps(r,indent=2));print(r)
PY
