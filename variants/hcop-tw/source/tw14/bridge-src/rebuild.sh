#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
sha256sum -c bridge-src/baseline.sha256
bash bridge-src/build_helpers.sh
java -jar tools/apktool.jar d -f deliverables/Navipilot-9.3.1-wide.13-camera-alerts.apk -o bridge-build/baseline
# Remove only a prior generated patched build when explicitly rebuilding.
if [ -d bridge-build/patched ]; then mv bridge-build/patched "bridge-build/patched-backup-$(date +%s)"; fi
python3 bridge-src/patch_bridge.py
python3 bridge-src/verify_bridge.py bridge-build/baseline bridge-build/patched
java -jar tools/apktool.jar b bridge-build/patched -o bridge-build/unsigned.apk
tools/build-tools/android-16/zipalign -P 16 -f 4 bridge-build/unsigned.apk bridge-build/aligned.apk
bash tools/build-tools/android-16/apksigner sign --ks project/wide-build/signing/navipilot-wide-test.jks --ks-key-alias navipilot-wide-test --ks-pass pass:android --key-pass pass:android --out deliverables/Navipilot-9.3.1-wide.14-tw-bridge.apk bridge-build/aligned.apk
bash tools/build-tools/android-16/apksigner verify --verbose --print-certs deliverables/Navipilot-9.3.1-wide.14-tw-bridge.apk > bridge-build/signature-check.txt
tools/build-tools/android-16/zipalign -c -P 16 4 deliverables/Navipilot-9.3.1-wide.14-tw-bridge.apk
java -jar tools/apktool.jar d -r -f deliverables/Navipilot-9.3.1-wide.14-tw-bridge.apk -o bridge-build/final-check
python3 bridge-src/verify_bridge.py bridge-build/baseline bridge-build/patched --final bridge-build/final-check --apk deliverables/Navipilot-9.3.1-wide.14-tw-bridge.apk > bridge-build/verification.json
