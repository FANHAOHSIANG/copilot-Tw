#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p adaptive17-build/tests
java -jar work/tools/ecj.jar -source 8 -target 8 -nowarn -d adaptive17-build/tests adaptive17-src/WideGeometry.java adaptive17-src/GeometryTest.java
java -cp adaptive17-build/tests com.navipilot.obf.GeometryTest
java -jar work/tools/ecj.jar -source 8 -target 8 -nowarn -cp work/tools/android-35/android.jar:adaptive17-build/classes -d adaptive17-build/preference-tests $(rg --files adaptive17-src/jvm -g '*.java')
java -cp adaptive17-build/preference-tests:adaptive17-build/classes:work/tools/android-35/android.jar com.navipilot.obf.PreferencesTest
java -jar work/tools/ecj.jar -source 8 -target 8 -nowarn -cp work/tools/json.jar:adaptive17-build/classes -d adaptive17-build/hcop-tests work/src/WideHcopTest.java
java -cp work/tools/json.jar:adaptive17-build/classes:adaptive17-build/hcop-tests com.navipilot.obf.WideHcopTest
java -jar work/tools/ecj.jar -source 8 -target 8 -nowarn -cp work/tools/json.jar:adaptive17-build/classes -d adaptive17-build/runtime-tests $(rg --files work/tests -g '*.java')
java -cp adaptive17-build/runtime-tests:adaptive17-build/classes:work/tools/json.jar com.navipilot.obf.BridgeReceiptTest
