#!/usr/bin/env python3
"""Run host behavior checks; this does not emulate Android Binder or a C4 device.

Requires a JDK 11+ and an org.json JVM jar. All class files use a temporary directory.
No dependency download, Android install, signing, source mutation or network I/O occurs.
"""

from __future__ import annotations

import argparse
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile


TESTS = Path(__file__).resolve().parent
VARIANT = TESTS.parent
REPO = VARIANT.parent.parent
PURE_SUITES = ["CodecChecks", "PolicyChecks", "NavigationChecks", "PipelineChecks"]
PURE_SOURCES = ["WideAmapLinkCodec", "WideAmapLinkPolicy", "WideAmapLinkNavigation"]
BOUNDARY_NOTE = (
    "Production codec, retry policy, navigation model and integration are executed. "
    "Integration replaces Android scheduling, source-gate call boundary, Binder transport "
    "and MG/WebSocket boundary with explicit host doubles. APK smali preservation, real "
    "Android service authorization/FD delivery, phone-version compatibility and C4 receipt "
    "require separate build/device checks. No fixture is a capture from the user's phone."
)


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run(command: list[str]) -> str:
    result = subprocess.run(command, text=True, capture_output=True, timeout=60)
    output = result.stdout + result.stderr
    if result.returncode:
        raise SystemExit(f"Command failed ({result.returncode}): {command[0]}\n{output}")
    return output.strip()


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--jdk", type=Path, default=os.environ.get("COPILOT_TEST_JDK"),
                        help="JDK directory containing bin/java and bin/javac; otherwise use PATH")
    parser.add_argument("--json-jar", type=Path, default=os.environ.get("COPILOT_TEST_JSON_JAR"),
                        required=not os.environ.get("COPILOT_TEST_JSON_JAR"),
                        help="Existing org.json JVM implementation jar")
    parser.add_argument("--report", type=Path, help="Optional JSON report path")
    args = parser.parse_args()
    java = str(args.jdk / "bin/java") if args.jdk else shutil.which("java")
    javac = str(args.jdk / "bin/javac") if args.jdk else shutil.which("javac")
    if not java or not javac:
        parser.error("A JDK is required; pass --jdk or set COPILOT_TEST_JDK")
    json_jar = args.json_jar.resolve()
    if not json_jar.is_file():
        parser.error(f"Missing JSON jar: {json_jar}")

    pure_sources = [VARIANT / "src" / f"{name}.java" for name in PURE_SOURCES]
    pure_sources += [TESTS / f"{name}.java" for name in PURE_SUITES]
    integration_sources = sorted((TESTS / "integration-stubs").rglob("*.java"))
    integration_sources += [VARIANT / "src/WideAmapLinkNavigation.java",
                            VARIANT / "src/WideAmapLinkIntegration.java",
                            TESTS / "IntegrationChecks.java"]
    files = sorted(set(pure_sources + integration_sources + [Path(__file__).resolve()]))
    initial_hashes = {str(path.relative_to(REPO)): digest(path) for path in files}
    suites: list[dict[str, object]] = []
    with tempfile.TemporaryDirectory(prefix="copilot-amap-link1-checks-") as temporary:
        for group, sources, names in [
            ("pure", pure_sources, PURE_SUITES),
            ("integration", integration_sources, ["IntegrationChecks"]),
        ]:
            output = Path(temporary) / group
            output.mkdir()
            run([javac, "-encoding", "UTF-8", "-cp", str(json_jar), "-d", str(output)]
                + [str(path) for path in sources])
            for name in names:
                result = run([java, "-XX:-UsePerfData", "-cp", str(output) + os.pathsep + str(json_jar),
                              "com.navipilot.obf." + name])
                match = re.search(rf"{re.escape(name)}: (\d+) assertions passed", result)
                if not match:
                    raise SystemExit(f"Missing success result for {name}: {result}")
                count = int(match.group(1))
                suites.append({"suite": name, "assertions": count, "result": "passed"})
                print(result, flush=True)
    for path in files:
        if digest(path) != initial_hashes[str(path.relative_to(REPO))]:
            raise SystemExit(f"Source changed during test run: {path}")
    total = sum(int(suite["assertions"]) for suite in suites)
    print(f"Total: {total} assertions passed", flush=True)
    print(BOUNDARY_NOTE, flush=True)
    if args.report:
        report = {
            "created_utc": datetime.now(timezone.utc).isoformat(),
            "result": "passed",
            "assertions": total,
            "suites": suites,
            "boundary_note": BOUNDARY_NOTE,
            "java_version": run([java, "-version"]),
            "json_jar_sha256": digest(json_jar),
            "tested_source_sha256": initial_hashes,
        }
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print(f"Report: {args.report}", flush=True)


if __name__ == "__main__":
    main()
