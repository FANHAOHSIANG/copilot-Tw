#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
mkdir -p work/build work/deliverables
if [ -d work/build/patched ]; then echo 'Please use a fresh extracted package or move the previous work/build/patched directory.' >&2; exit 1; fi
java -jar work/tools/apktool.jar d -f inputs/Navipilot-9.3.1-wide.14-tw-bridge.apk -o work/build/baseline
bash work/src/build_helpers.sh
java -jar work/tools/ecj.jar -source 8 -target 8 -nowarn -cp work/tools/json.jar:work/build/classes -d work/build/test-classes work/src/WideHcopTest.java
java -cp work/tools/json.jar:work/build/classes:work/build/test-classes com.navipilot.obf.WideHcopTest
java -jar work/tools/ecj.jar -source 8 -target 8 -nowarn -cp work/tools/json.jar:work/build/classes -d work/build/runtime-tests $(rg --files work/tests -g '*.java')
java -cp work/build/runtime-tests:work/build/classes:work/tools/json.jar com.navipilot.obf.BridgeReceiptTest
java -Xmx512m -cp work/build/runtime-tests:work/build/classes:work/tools/json.jar com.navipilot.obf.RuntimeMapTest
python3 work/src/test_receiver.py
python3 work/src/package_apk.py
java -jar work/tools/apktool.jar b work/build/patched -o work/build/unsigned.apk
work/tools/android-16/zipalign -P 16 -f 4 work/build/unsigned.apk work/build/aligned.apk
bash work/tools/android-16/apksigner sign --ks source/tw14/project/wide-build/signing/navipilot-wide-test.jks --ks-key-alias navipilot-wide-test --ks-pass pass:android --key-pass pass:android --out work/deliverables/Navipilot-9.3.1-wide.16-hcop-tw-test.apk work/build/aligned.apk
work/tools/android-16/zipalign -c -P 16 4 work/deliverables/Navipilot-9.3.1-wide.16-hcop-tw-test.apk
java -jar work/tools/apktool.jar d -r -f work/deliverables/Navipilot-9.3.1-wide.16-hcop-tw-test.apk -o work/build/final-check
python3 work/src/verify_apk.py
