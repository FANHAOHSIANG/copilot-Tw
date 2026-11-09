#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
flavor="${1:?auto or phone}"
case "$flavor" in auto|phone) ;; *) exit 2;; esac
sha256sum -c adaptive16-src/baselines.sha256
bt="${ANDROID_BUILD_TOOLS:-tools/build-tools/android-16}"
build="adaptive16-build/$flavor"
mkdir -p "$build/classes" "$build/dex" "$build/generated"
python3 - "$flavor" <<'PY'
from pathlib import Path
import sys
f=sys.argv[1];phone=f=='phone'
text='''package com.navipilot.obf;
public final class WideVariant {
 public static final boolean PHONE=%s;
 public static final String NAME="%s",PACKAGE="%s",DISPLAY="%s";
 public static void init(android.app.Activity a){%s}
 public static void diagnostics(android.app.Activity a){%s}
}'''%('true' if phone else 'false','高德一般版' if phone else '高德車機版','com.autonavi.minimap' if phone else 'com.autonavi.amapauto','WideAmapPhone' if phone else 'WideAmap','WideNavProbe.init(a);' if phone else '','WideNavProbe.show(a);' if phone else '')
Path('adaptive16-build',f,'generated/WideVariant.java').write_text(text)
PY
java -jar tools/ecj.jar -source 8 -target 8 -nowarn -cp tools/platform/android-35/android.jar -d "$build/classes" $(rg --files resize-src/stubs dual-src/stubs bridge-src/stubs -g '*.java') adaptive16-src/Wide*.java "$build/generated/WideVariant.java" auto-src/WideApps.java telemetry-src/WideTelemetry.java telemetry-src/WideLinkDiagnostics.java phone15-src/WideNavProbe.java phone15-src/WideNavNotifications.java
classes=()
for prefix in WideGeometry WideLayout WideSettings WideDivider WideDirect WideInsets WideVariant; do
 for file in "$build/classes/com/navipilot/obf/$prefix"*.class; do classes+=("$file"); done
done
bash "$bt/d8" --min-api 31 --lib tools/platform/android-35/android.jar --output "$build/dex" "${classes[@]}"
if [[ "$flavor" == auto ]]; then baseline="deliverables/Navipilot-9.3.1-wide.11-auto-diagnostic.apk"; else baseline="deliverables/Navipilot-9.3.1-wide.15-phone-bridge.apk"; fi
python3 - "$baseline" "$build" <<'PY'
import sys,zipfile
from pathlib import Path
with zipfile.ZipFile(sys.argv[1]) as base,zipfile.ZipFile(Path(sys.argv[2])/'helper.apk','w') as out:
 for n in ('AndroidManifest.xml','resources.arsc'):out.writestr(n,base.read(n))
 out.write(Path(sys.argv[2])/'dex/classes.dex','classes.dex')
PY
java -jar tools/apktool.jar d -r -f "$build/helper.apk" -o "$build/helper-decoded"
java -jar tools/apktool.jar d -f "$baseline" -o "$build/baseline"
python3 adaptive16-src/patch_adaptive.py "$flavor"
java -jar tools/apktool.jar b "$build/patched" -o "$build/unsigned.apk"
"$bt/zipalign" -P 16 -f 4 "$build/unsigned.apk" "$build/aligned.apk"
apk="deliverables/Navipilot-9.3.1-wide.16-$flavor-adaptive.apk"
bash "$bt/apksigner" sign --ks project/wide-build/signing/navipilot-wide-test.jks --ks-key-alias navipilot-wide-test --ks-pass pass:android --key-pass pass:android --out "$apk" "$build/aligned.apk"
bash "$bt/apksigner" verify --verbose --print-certs "$apk" > "$build/signature.txt"
"$bt/zipalign" -c -P 16 4 "$apk"
java -jar tools/apktool.jar d -r -f "$apk" -o "$build/final-check"
python3 adaptive16-src/verify.py "$flavor" > "$build/verification.json"
cat "$build/verification.json"
