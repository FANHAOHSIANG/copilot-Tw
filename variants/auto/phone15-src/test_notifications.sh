#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p phone15-build/test-classes
java -jar tools/ecj.jar -source 8 -target 8 -nowarn -d phone15-build/test-classes $(rg --files phone15-src/jvm -g '*.java') phone15-src/WideNavNotifications.java
java -cp phone15-build/test-classes com.navipilot.obf.WideNotificationTest
