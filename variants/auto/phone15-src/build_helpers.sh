#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
bt="${ANDROID_BUILD_TOOLS:-tools/build-tools/android-16}"
mkdir -p phone15-build/classes phone15-build/dex
java -jar tools/ecj.jar -source 8 -target 8 -nowarn -cp tools/platform/android-35/android.jar -d phone15-build/classes $(rg --files resize-src/stubs dual-src/stubs bridge-src/stubs -g '*.java') resize-src/WideGeometry.java auto-src/WideLayout.java auto-src/WideDivider.java auto-src/WideApps.java telemetry-src/WideTelemetry.java telemetry-src/WideLinkDiagnostics.java phone15-src/WideDirect.java phone15-src/WideSettings.java phone15-src/WideNavProbe.java phone15-src/WideNavNotifications.java
bash "$bt/d8" --min-api 31 --lib tools/platform/android-35/android.jar --output phone15-build/dex phone15-build/classes/com/navipilot/obf/WideDirect*.class phone15-build/classes/com/navipilot/obf/WideSettings*.class phone15-build/classes/com/navipilot/obf/WideNavProbe*.class phone15-build/classes/com/navipilot/obf/WideNavNotifications*.class
python3 - <<'PY'
import zipfile
with zipfile.ZipFile('deliverables/Navipilot-9.3.1-wide.11-auto-diagnostic.apk') as base:
 with zipfile.ZipFile('phone15-build/helper.apk','w') as out:
  for n in ('AndroidManifest.xml','resources.arsc'):out.writestr(n,base.read(n))
  out.write('phone15-build/dex/classes.dex','classes.dex')
PY
java -jar tools/apktool.jar d -r -f phone15-build/helper.apk -o phone15-build/helper-decoded
