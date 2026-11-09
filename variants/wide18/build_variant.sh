#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
flavor="${1:?Choose auto, phone or taiwan}"
case "$flavor" in auto|phone|taiwan) ;; *) exit 2 ;; esac
: "${COPILOT_ANDROID_TOOLS:?Set the Android tools directory}"
: "${COPILOT_SIGNING_KEY:?Set the local signing key path}"
: "${COPILOT_STORE_PASSWORD:?Set the signing store password}"
: "${COPILOT_KEY_PASSWORD:?Set the signing key password}"
tools_path="$COPILOT_ANDROID_TOOLS"
stage="build/$flavor"
apk="deliverables/Copilot-tw-9.3.1-wide.18-$flavor-adaptive.apk"
mkdir -p "$stage" deliverables
sha256sum --check inputs.sha256
if [[ ! -f "$stage/baseline/apktool.yml" ]]; then
    java -jar "$tools_path/apktool.jar" d -f "inputs/$flavor.apk" -o "$stage/baseline"
fi
python3 patch_apk.py "$flavor"
java -jar "$tools_path/apktool.jar" b "$stage/patched" -o "$stage/unsigned.apk"
"$tools_path/android-16/zipalign" -P 16 -f 4 "$stage/unsigned.apk" "$stage/aligned.apk"
bash "$tools_path/android-16/apksigner" sign \
    --ks "$COPILOT_SIGNING_KEY" --ks-key-alias "${COPILOT_KEY_ALIAS:-navipilot-wide-test}" \
    --ks-pass env:COPILOT_STORE_PASSWORD --key-pass env:COPILOT_KEY_PASSWORD \
    --out "$apk" "$stage/aligned.apk"
"$tools_path/android-16/zipalign" -c -P 16 4 "$apk"
java -jar "$tools_path/apktool.jar" d -r -f "$apk" -o "$stage/final-check"
python3 verify.py "$flavor"
