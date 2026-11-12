#!/usr/bin/env python3
"""Run the current Google bridge's pure Java mapper checks, without an Android APK."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import tempfile


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--java", default="java")
    parser.add_argument("--javac", default="javac")
    parser.add_argument("--json-jar", required=True, type=Path)
    parser.add_argument("--report", type=Path)
    args = parser.parse_args()
    here = Path(__file__).resolve().parent
    repo = here.parents[2]
    sources = [here.parent / "src/WideGoogleAdapter.java", here / "GoogleBridgeChecks.java"]
    hashes = {str(path.relative_to(repo)): hashlib.sha256(path.read_bytes()).hexdigest() for path in sources}
    with tempfile.TemporaryDirectory(prefix="copilot-google-bridge-checks-") as temporary:
        subprocess.run([args.javac, "-encoding", "UTF-8", "-cp", str(args.json_jar), "-d", temporary,
                        *map(str, sources)], check=True)
        result = subprocess.run([args.java, "-cp", temporary + os.pathsep + str(args.json_jar),
                                 "com.navipilot.obf.GoogleBridgeChecks"], text=True, encoding="utf-8",
                                stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        print(result.stdout, end="")
        result.check_returncode()
    if hashes != {str(path.relative_to(repo)): hashlib.sha256(path.read_bytes()).hexdigest() for path in sources}:
        raise RuntimeError("Source changed during mapper checks; rerun against final implementation")
    count = int(re.search(r"PASS (\d+) Google bridge checks", result.stdout).group(1))
    if args.report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(json.dumps({
            "assertions": count,
            "passed": True,
            "sourceSha256": hashes,
            "method": "Production WideGoogleAdapter with synthetic navigation and route JSON",
            "limitations": "No Android SDK, Google service, receiver integration or device verification",
        }, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
