#!/usr/bin/env python3
"""Download the pinned JSON dependency and run the APK-independent CoPilot host suites."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import time
import urllib.request


JSON_URL = "https://repo.maven.apache.org/maven2/org/json/json/20240303/json-20240303.jar"
JSON_SHA256 = "3cf6cd6892e32e2b4c1c39e0f52f5248a2f5b37646fdfbb79a66b46b618414ed"


def write_report(output, report):
    (output / "host-checks.json").write_text(
        json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def require_jdk21(java, javac):
    versions = {}
    for name, tool, pattern in (("java", java, r'(?:openjdk|java) version "(\d+)'),
                                ("javac", javac, r"javac (\d+)")):
        result = subprocess.run([tool, "-version"], check=True, text=True, encoding="utf-8",
                                stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        versions[name] = result.stdout.strip()
        match = re.search(pattern, result.stdout)
        if not match or int(match.group(1)) != 21:
            raise RuntimeError(name + " must use JDK 21; got " + result.stdout.strip())
    return versions


def download_json(output):
    # Always fetch into this run's new output directory. No machine-local JAR or
    # mutable Maven version is an implicit input to the checks.
    with urllib.request.urlopen(JSON_URL, timeout=45) as response:
        data = response.read(2 * 1024 * 1024 + 1)
    if len(data) > 2 * 1024 * 1024:
        raise RuntimeError("Pinned org.json download exceeds the expected size bound")
    actual = hashlib.sha256(data).hexdigest()
    if actual != JSON_SHA256:
        raise RuntimeError("org.json SHA-256 mismatch: " + actual)
    dependencies = output / "dependencies"
    dependencies.mkdir()
    jar = dependencies / "json-20240303.jar"
    jar.write_bytes(data)
    print("Verified org.json 20240303: " + actual, flush=True)
    return jar, {"url": JSON_URL, "sha256": actual, "bytes": len(data)}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--java", default="java", help="JDK 21 java command or path")
    parser.add_argument("--javac", default="javac", help="JDK 21 javac command or path")
    parser.add_argument("--output-dir", required=True, type=Path, help="New or empty directory for this run")
    args = parser.parse_args()
    repo = Path(__file__).resolve().parents[2]
    output = args.output_dir.resolve()
    output.mkdir(parents=True, exist_ok=True)
    if any(output.iterdir()):
        parser.error("--output-dir must be new or empty to avoid mixing reports from different runs")
    report = {
        "passed": False,
        "sourceCommit": os.environ.get("GITHUB_SHA"),
        "python": sys.version.split()[0],
        "suites": [],
        "limitations": "Host checks only; no private base APK, Android runtime, Google service, audio device or vehicle verification",
    }
    write_report(output, report)
    try:
        report["jdk"] = require_jdk21(args.java, args.javac)
        jar, report["dependency"] = download_json(output)
        common = ["--java", args.java, "--javac", args.javac, "--json-jar", str(jar)]
        # Minimums prevent accidentally dropping the catalog checks or selecting
        # an obsolete mapper suite, while allowing future tests to be added.
        suites = [
            ("enforcement-core", "variants/enforcement-alert/tests/run_checks.py",
             ["--catalog", str(repo / "data/enforcement/tw_enforcement.json")],
             r"^EngineChecks: (\d+) assertions passed$", 67),
            ("enforcement-lifecycle", "variants/wide46/tests/lifecycle/run_checks.py",
             ["--report", str(output / "lifecycle.json")],
             r"^RuntimeVoiceChecks: (\d+) assertions passed$", 46),
            ("dashboard-ui", "variants/wide46/tests/ui/run_checks.py",
             ["--strict-layout", "--output-dir", str(output / "ui")],
             r"^PASS (\d+) semantic/fitting assertions;", 316),
            ("google-mapper", "variants/google-bridge46/tests/run_checks.py",
             ["--report", str(output / "google-mapper.json")],
             r"^PASS (\d+) Google bridge checks$", 38),
        ]
        for name, runner, options, pattern, minimum in suites:
            print("Running " + name, flush=True)
            started = time.monotonic()
            command = [sys.executable, str(repo / runner), *common, *options]
            result = subprocess.run(command, cwd=repo, text=True, encoding="utf-8", errors="replace",
                                    stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
            (output / (name + ".log")).write_text(result.stdout, encoding="utf-8")
            print(result.stdout, end="", flush=True)
            match = re.search(pattern, result.stdout, re.MULTILINE)
            count = int(match.group(1)) if match else 0
            passed = result.returncode == 0 and count >= minimum
            report["suites"].append({
                "name": name,
                "runner": runner,
                "assertions": count,
                "minimumAssertions": minimum,
                "passed": passed,
                "exitCode": result.returncode,
                "seconds": round(time.monotonic() - started, 3),
                "log": name + ".log",
            })
            write_report(output, report)
            if not passed:
                print("FAILED " + name + ": inspect " + str(output / (name + ".log")), file=sys.stderr)
        report["assertions"] = sum(suite["assertions"] for suite in report["suites"])
        report["passed"] = all(suite["passed"] for suite in report["suites"])
    except Exception as error:
        report["error"] = str(error)
        print(str(error), file=sys.stderr)
    finally:
        write_report(output, report)
    print(("PASS " if report["passed"] else "FAIL ") + str(report.get("assertions", 0))
          + " host assertions; report: " + str(output / "host-checks.json"), flush=True)
    return 0 if report["passed"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
