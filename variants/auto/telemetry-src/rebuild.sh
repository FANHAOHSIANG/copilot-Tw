#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
: "${ANDROID_BUILD_TOOLS:?Set Android build-tools 36.0.0 path}"
flavor="${1:-probe}"
case "$flavor" in auto|probe) ;; *) echo 'Use auto or probe' >&2; exit 2 ;; esac
work="telemetry-build/$flavor"
output="deliverables/Navipilot-9.3.1-wide.11-$flavor-diagnostic.apk"
mkdir -p "$work" deliverables
sha256sum -c "telemetry-src/$flavor-baseline.sha256"
java -jar tools/apktool.jar d -f "deliverables/Navipilot-9.3.1-wide.10-$flavor-dualfix.apk" -o "$work/baseline"
python3 telemetry-src/patch_telemetry.py "$work/baseline" "$work/patched" telemetry-build/helper-decoded/smali/com/navipilot/obf "$flavor"
python3 telemetry-src/verify_telemetry.py "$work/baseline" "$work/patched" "$flavor"
java -jar tools/apktool.jar b "$work/patched" -o "$work/unsigned.apk"
"$ANDROID_BUILD_TOOLS/zipalign" -P 16 -f 4 "$work/unsigned.apk" "$work/aligned.apk"
bash "$ANDROID_BUILD_TOOLS/apksigner" sign --ks project/wide-build/signing/navipilot-wide-test.jks --ks-key-alias navipilot-wide-test --ks-pass pass:android --key-pass pass:android --out "$output" "$work/aligned.apk"
bash "$ANDROID_BUILD_TOOLS/apksigner" verify --verbose --print-certs "$output"
"$ANDROID_BUILD_TOOLS/zipalign" -c -P 16 4 "$output"
java -jar tools/apktool.jar d -r -f "$output" -o "$work/final-check"
python3 telemetry-src/verify_telemetry.py "$work/baseline" "$work/patched" "$flavor" --final "$work/final-check" --apk "$output" > "$work/verification.json"
cat "$work/verification.json"
