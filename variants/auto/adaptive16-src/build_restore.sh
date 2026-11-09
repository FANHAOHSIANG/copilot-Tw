#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
flavor="${1:?auto or phone}"
case "$flavor" in auto|phone) ;; *) exit 2;; esac
bt="${ANDROID_BUILD_TOOLS:-tools/build-tools/android-16}"
build="adaptive16-build/$flavor"
python3 - "$flavor" <<'PY'
from pathlib import Path
import shutil,re,sys
b=Path('adaptive16-build')/sys.argv[1]
assert not (b/'restore').exists()
shutil.copytree(b/'baseline',b/'restore',ignore=lambda d,n:[x for x in n if x in ('build','dist')])
p=b/'restore/apktool.yml';s=p.read_text();p.write_text(re.sub(r'versionCode: \d+','versionCode: 26110728',s))
PY
java -jar tools/apktool.jar b "$build/restore" -o "$build/restore-unsigned.apk"
"$bt/zipalign" -P 16 -f 4 "$build/restore-unsigned.apk" "$build/restore-aligned.apk"
apk="deliverables/Navipilot-$flavor-previous-layout-restore-build28.apk"
bash "$bt/apksigner" sign --ks project/wide-build/signing/navipilot-wide-test.jks --ks-key-alias navipilot-wide-test --ks-pass pass:android --key-pass pass:android --out "$apk" "$build/restore-aligned.apk"
bash "$bt/apksigner" verify "$apk"
"$bt/zipalign" -c -P 16 4 "$apk"
java -jar tools/apktool.jar d -r -f "$apk" -o "$build/restore-check"
python3 - "$flavor" <<'PY'
import sys,json,hashlib
from pathlib import Path
sys.path.insert(0,'dualfix-src');from verify_dualfix import normalize_smali
flavor=sys.argv[1];b=Path('adaptive16-build')/flavor
expected={str(p.relative_to(b/'baseline')) for p in (b/'baseline').glob('smali*/**/*.smali')}
actual={str(p.relative_to(b/'restore-check')) for p in (b/'restore-check').glob('smali*/**/*.smali')}
assert actual==expected
for k in expected:assert normalize_smali((b/'baseline'/k).read_text())==normalize_smali((b/'restore-check'/k).read_text()),k
apk=Path('deliverables')/('Navipilot-'+flavor+'-previous-layout-restore-build28.apk')
result={'status':'PASS','classes_identical_to_previous':len(expected),'versionCode':26110728,'sha256':hashlib.sha256(apk.read_bytes()).hexdigest()}
(b/'restore-verification.json').write_text(json.dumps(result,indent=2));print(result)
PY
