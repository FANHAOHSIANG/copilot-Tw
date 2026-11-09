#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
mkdir -p work/build/classes work/build/dex
java -jar work/tools/ecj.jar -source 8 -target 8 -nowarn -cp work/tools/android-35/android.jar -d work/build/classes $(rg --files source/tw14/resize-src/stubs source/tw14/dual-src/stubs source/tw14/bridge-src/stubs -g '*.java') source/tw14/resize-src/WideGeometry.java source/tw14/auto-src/WideLayout.java source/tw14/auto-src/WideDivider.java source/tw14/auto-src/WideApps.java source/tw14/telemetry-src/WideTelemetry.java source/tw14/telemetry-src/WideLinkDiagnostics.java source/tw14/camera-src/WideDirect.java source/tw14/camera13-src/WideCameraEngine.java source/tw14/camera13-src/WideCameraSection.java source/tw14/camera13-src/WideCameraService.java work/src/WideCameraFace.java work/src/WideCamera.java work/src/WideCameraPanel.java work/src/WideSettings.java work/src/WideRoad.java work/src/WideHcopRoad.java work/src/WideHcop.java work/src/WideHcopMerge.java work/src/WideBridge.java work/src/WideBridgeLog.java
bash work/tools/android-16/d8 --min-api 31 --lib work/tools/android-35/android.jar --output work/build/dex work/build/classes/com/navipilot/obf/WideCamera*.class work/build/classes/com/navipilot/obf/WideSettings*.class work/build/classes/com/navipilot/obf/WideRoad*.class work/build/classes/com/navipilot/obf/WideHcop*.class work/build/classes/com/navipilot/obf/WideBridge*.class
python3 - <<'PY'
import zipfile
with zipfile.ZipFile('inputs/Navipilot-9.3.1-wide.14-tw-bridge.apk') as base,zipfile.ZipFile('work/build/helper.apk','w') as out:
 for n in ('AndroidManifest.xml','resources.arsc'):out.writestr(n,base.read(n))
 out.write('work/build/dex/classes.dex','classes.dex')
PY
java -jar work/tools/apktool.jar d -r -f work/build/helper.apk -o work/build/helper-decoded
