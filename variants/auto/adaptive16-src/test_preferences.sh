#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
java -jar tools/ecj.jar -source 8 -target 8 -nowarn -cp tools/platform/android-35/android.jar:adaptive16-build/auto/classes -d adaptive16-build/preference-tests $(rg --files adaptive16-src/jvm -g '*.java')
java -cp adaptive16-build/preference-tests:adaptive16-build/auto/classes:tools/platform/android-35/android.jar com.navipilot.obf.PreferencesTest
