#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
bt="${ANDROID_BUILD_TOOLS:-tools/build-tools/android-16}"
mkdir -p phone15-build deliverables
sha256sum -c phone15-src/baseline.sha256
bash phone15-src/build_helpers.sh
java -jar tools/apktool.jar d -f deliverables/Navipilot-9.3.1-wide.11-auto-diagnostic.apk -o phone15-build/baseline
python3 phone15-src/patch_phone.py
java -jar tools/apktool.jar b phone15-build/patched -o phone15-build/unsigned.apk
"$bt/zipalign" -P 16 -f 4 phone15-build/unsigned.apk phone15-build/aligned.apk
bash "$bt/apksigner" sign --ks project/wide-build/signing/navipilot-wide-test.jks --ks-key-alias navipilot-wide-test --ks-pass pass:android --key-pass pass:android --out deliverables/Navipilot-9.3.1-wide.15-phone-bridge.apk phone15-build/aligned.apk
bash "$bt/apksigner" verify --verbose --print-certs deliverables/Navipilot-9.3.1-wide.15-phone-bridge.apk
"$bt/zipalign" -c -P 16 4 deliverables/Navipilot-9.3.1-wide.15-phone-bridge.apk
java -jar tools/apktool.jar d -r -f deliverables/Navipilot-9.3.1-wide.15-phone-bridge.apk -o phone15-build/final-check
python3 phone15-src/verify_phone.py > phone15-build/verification.json
cat phone15-build/verification.json
