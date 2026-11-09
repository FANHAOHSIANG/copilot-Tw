#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p bridge-build/classes bridge-build/test-classes bridge-build/dex
java -jar tools/ecj.jar -source 8 -target 8 -nowarn -cp tools/platform/android-35/android.jar -d bridge-build/classes $(rg --files resize-src/stubs dual-src/stubs bridge-src/stubs -g '*.java') resize-src/WideGeometry.java auto-src/WideLayout.java auto-src/WideDivider.java auto-src/WideApps.java telemetry-src/WideTelemetry.java telemetry-src/WideLinkDiagnostics.java camera-src/WideDirect.java camera13-src/WideCameraEngine.java camera13-src/WideCameraSection.java camera13-src/WideCameraService.java bridge-src/WideCameraFace.java bridge-src/WideCamera.java bridge-src/WideCameraPanel.java bridge-src/WideSettings.java bridge-src/WideRoad.java bridge-src/WideSpeedMerge.java bridge-src/WideBridge.java bridge-src/WideBridgeLog.java
bash tools/build-tools/android-16/d8 --min-api 31 --lib tools/platform/android-35/android.jar --output bridge-build/dex bridge-build/classes/com/navipilot/obf/WideCamera*.class bridge-build/classes/com/navipilot/obf/WideSettings*.class bridge-build/classes/com/navipilot/obf/WideRoad*.class bridge-build/classes/com/navipilot/obf/WideSpeedMerge*.class bridge-build/classes/com/navipilot/obf/WideBridge*.class
python3 - <<'PY'
import zipfile
with zipfile.ZipFile('deliverables/Navipilot-9.3.1-wide.13-camera-alerts.apk') as base:
 with zipfile.ZipFile('bridge-build/helper.apk','w') as out:
  for name in ['AndroidManifest.xml','resources.arsc']:out.writestr(name,base.read(name))
  out.write('bridge-build/dex/classes.dex','classes.dex')
PY
java -jar tools/apktool.jar d -r -f bridge-build/helper.apk -o bridge-build/helper-decoded
