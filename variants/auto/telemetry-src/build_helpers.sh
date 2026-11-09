#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
: "${ANDROID_BUILD_TOOLS:?Set Android build-tools 36.0.0 path}"
mkdir -p telemetry-build/classes telemetry-build/test-classes telemetry-build/dex
java -jar tools/ecj.jar -source 8 -target 8 -nowarn -d telemetry-build/test-classes telemetry-src/WideLinkDiagnostics.java telemetry-src/WideLinkDiagnosticsTest.java
java -cp telemetry-build/test-classes com.navipilot.obf.WideLinkDiagnosticsTest > telemetry-build/unit-tests.txt
java -jar tools/ecj.jar -source 8 -target 8 -nowarn -cp tools/platform/android-35/android.jar -d telemetry-build/classes resize-src/stubs/com/navipilot/obf/Ae.java resize-src/stubs/com/navipilot/obf/mO.java resize-src/stubs/com/navipilot/obf/yW.java resize-src/stubs/com/navipilot/obf/sg.java resize-src/WideGeometry.java telemetry-src/WideTelemetry.java telemetry-src/WideLinkDiagnostics.java
# Compile stubs and unchanged WideGeometry are deliberately excluded from DEX.
bash "$ANDROID_BUILD_TOOLS/d8" --min-api 31 --lib tools/platform/android-35/android.jar --output telemetry-build/dex telemetry-build/classes/com/navipilot/obf/WideTelemetry.class telemetry-build/classes/com/navipilot/obf/WideLinkDiagnostics*.class
python3 - <<'PY'
from pathlib import Path
import zipfile
with zipfile.ZipFile('deliverables/Navipilot-9.3.1-wide.10-probe-dualfix.apk') as base:
    with zipfile.ZipFile('telemetry-build/helper.apk', 'w') as out:
        for name in ['AndroidManifest.xml', 'resources.arsc']: out.writestr(name, base.read(name))
        out.write('telemetry-build/dex/classes.dex', 'classes.dex')
PY
java -jar tools/apktool.jar d -r -f telemetry-build/helper.apk -o telemetry-build/helper-decoded
cat telemetry-build/unit-tests.txt
