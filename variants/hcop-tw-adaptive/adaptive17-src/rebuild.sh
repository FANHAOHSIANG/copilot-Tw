#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
: "${COPILOT_SIGNING_KEY:?Set path to your original private signing key}"
: "${COPILOT_STORE_PASSWORD:?Set signing store password}"
: "${COPILOT_KEY_PASSWORD:?Set signing key password}"
if [[ -e adaptive17-build/patched ]]; then echo 'Use a fresh package directory; patched already exists.' >&2; exit 1; fi
sha256sum -c adaptive17-src/baseline.sha256
mkdir -p deliverables
java -jar work/tools/apktool.jar d -f inputs/hcop16.apk -o adaptive17-build/baseline
bash adaptive17-src/compile.sh
bash work/tools/android-16/d8 --min-api 31 --lib work/tools/android-35/android.jar --output adaptive17-build/dex adaptive17-build/classes/com/navipilot/obf/WideGeometry*.class adaptive17-build/classes/com/navipilot/obf/WideLayout*.class adaptive17-build/classes/com/navipilot/obf/WideDivider*.class adaptive17-build/classes/com/navipilot/obf/WideDirect*.class adaptive17-build/classes/com/navipilot/obf/WideSettings*.class adaptive17-build/classes/com/navipilot/obf/WideInsets*.class adaptive17-build/classes/com/navipilot/obf/WideVariant*.class adaptive17-build/classes/com/navipilot/obf/WideCameraPanel*.class adaptive17-build/classes/com/navipilot/obf/WideTaiwan*.class
python3 - <<'PY'
import zipfile
with zipfile.ZipFile('inputs/hcop16.apk') as b,zipfile.ZipFile('adaptive17-build/helper.apk','w') as z:
 for n in ['AndroidManifest.xml','resources.arsc']:z.writestr(n,b.read(n))
 z.write('adaptive17-build/dex/classes.dex','classes.dex')
PY
java -jar work/tools/apktool.jar d -r -f adaptive17-build/helper.apk -o adaptive17-build/helper-decoded
python3 adaptive17-src/patch_adaptive.py
java -jar work/tools/apktool.jar b adaptive17-build/patched -o adaptive17-build/unsigned.apk
work/tools/android-16/zipalign -P 16 -f 4 adaptive17-build/unsigned.apk adaptive17-build/aligned.apk
bash work/tools/android-16/apksigner sign --ks "$COPILOT_SIGNING_KEY" --ks-key-alias "${COPILOT_KEY_ALIAS:-navipilot-wide-test}" --ks-pass env:COPILOT_STORE_PASSWORD --key-pass env:COPILOT_KEY_PASSWORD --out deliverables/CoPilot-Tw-9.3.1-wide.17-hcop-tw-adaptive.apk adaptive17-build/aligned.apk
work/tools/android-16/zipalign -c -P 16 4 deliverables/CoPilot-Tw-9.3.1-wide.17-hcop-tw-adaptive.apk
java -jar work/tools/apktool.jar d -r -f deliverables/CoPilot-Tw-9.3.1-wide.17-hcop-tw-adaptive.apk -o adaptive17-build/final-check
python3 adaptive17-src/verify_apk.py
