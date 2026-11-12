#!/usr/bin/env python3
"""Real production Runtime/Voice lifecycle checks with host Android boundary stubs."""
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
    parser.add_argument("--json-jar", type=Path, required=True)
    parser.add_argument("--report", type=Path)
    args = parser.parse_args()
    here = Path(__file__).resolve().parent
    repo = here.parents[3]
    sources = [repo / "variants/wide46/src/WideEnforcementRuntime.java",
               repo / "variants/wide46/src/WideEnforcementVoice.java",
               repo / "variants/wide46/src/WideEnforcementLabels.java",
               repo / "variants/enforcement-alert/src/WideEnforcementEngine.java",
               repo / "variants/wide37/compat/WideCameraEngine.java",
               repo / "variants/hcop-tw/work/src/WideHcopRoad.java",
               repo / "variants/hcop-tw/work/src/WideRoad.java", *sorted(here.rglob("*.java"))]
    hashes = {str(path.relative_to(repo)): hashlib.sha256(path.read_bytes()).hexdigest() for path in sources}
    with tempfile.TemporaryDirectory(prefix="copilot-enforcement-lifecycle-") as temporary:
        subprocess.run([args.javac, "-encoding", "UTF-8", "-cp", str(args.json_jar), "-d", temporary,
                        *map(str, sources)], check=True)
        result = subprocess.run([args.java, "-cp", temporary + os.pathsep + str(args.json_jar),
                                 "com.navipilot.obf.RuntimeVoiceChecks"], text=True, encoding="utf-8",
                                stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        print(result.stdout, end="")
        result.check_returncode()
    if hashes != {str(path.relative_to(repo)): hashlib.sha256(path.read_bytes()).hexdigest() for path in sources}:
        raise RuntimeError("Source changed during lifecycle tests; rerun against final implementation")
    count = int(re.search(r"RuntimeVoiceChecks: (\d+) assertions passed", result.stdout).group(1))
    report = {"assertions": count, "passed": True, "sourceSha256": hashes,
              "method": "Production Engine/Runtime/Voice; deterministic host clock, Handler, TTS and audio-focus boundaries",
              "limitations": "No Android service scheduling, real audio output, voice engine or device/vehicle verification"}
    if args.report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
