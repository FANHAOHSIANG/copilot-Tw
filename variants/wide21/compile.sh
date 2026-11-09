#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
: "${COPILOT_ANDROID_TOOLS:?Set the absolute Android build tools directory described in README}"
tools_path="$COPILOT_ANDROID_TOOLS"
source19="${COPILOT_WIDE19_SOURCE:-../wide19}"
compat="$source19/compat"
mkdir -p build/classes build/dex
mapfile -t stubs < <(rg --files "$compat"/{resize-src,dual-src,bridge-src}/stubs -g '*.java')
mapfile -t inherited < <(rg --files "$source19/src" -g '*.java' -g '!WideDirect.java' -g '!WideSettings.java' -g '!WideCameraPanel.java')
mapfile -t common < <(rg --files "$compat" --maxdepth 1 -g '*.java' -g '!WideInsets.java')
java -jar "$tools_path/ecj.jar" -source 8 -target 8 -nowarn \
    -cp "$tools_path/android-35/android.jar" -d build/classes \
    "${stubs[@]}" stubs/com/navipilot/obf/zM.java "${common[@]}" "$compat/auto-src/WideApps.java" "$compat"/telemetry-src/*.java \
    "$compat"/camera13-src/WideCamera{Engine,Section,Service}.java "${inherited[@]}" src/*.java
classes=()
for class in WideDirect WideAmapIme WideDisplayResize WideInsets WideUi WideCameraPanel WideSettings; do
    classes+=("build/classes/com/navipilot/obf/$class.class")
    for inner in build/classes/com/navipilot/obf/"$class"\$*.class; do
        [[ ! -f "$inner" ]] || classes+=("$inner")
    done
done
bash "$tools_path/android-16/d8" --min-api 31 --lib "$tools_path/android-35/android.jar" \
    --output build/dex "${classes[@]}"
python3 - <<'PY'
import zipfile
with zipfile.ZipFile('inputs/taiwan.apk') as base, zipfile.ZipFile('build/helper.apk','w') as helper:
    for name in ('AndroidManifest.xml', 'resources.arsc'):
        helper.writestr(name, base.read(name))
    helper.write('build/dex/classes.dex', 'classes.dex')
PY
java -jar "$tools_path/apktool.jar" d -r -f build/helper.apk -o build/helper
