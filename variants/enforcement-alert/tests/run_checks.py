#!/usr/bin/env python3
"""Compile pure Java decision checks; optionally replay the shipped OSM tile geometry."""
import argparse
import os
from pathlib import Path
import subprocess
import tempfile


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--java", default="java")
    parser.add_argument("--javac", default="javac")
    parser.add_argument("--json-jar", required=True, type=Path)
    parser.add_argument("--catalog", type=Path)
    parser.add_argument("--tiles", type=Path)
    parser.add_argument("--audit-output", type=Path)
    args = parser.parse_args()
    here = Path(__file__).resolve().parent
    repo = here.parents[2]
    sources = [here.parent / "src/WideEnforcementEngine.java", here / "EngineChecks.java",
               here / "CatalogRoadAudit.java", repo / "variants/wide37/compat/WideCameraEngine.java",
               repo / "variants/hcop-tw/work/src/WideHcopRoad.java",
               repo / "variants/hcop-tw/work/src/WideRoad.java"]
    with tempfile.TemporaryDirectory(prefix="copilot-enforcement-checks-") as temporary:
        subprocess.run([args.javac, "-encoding", "UTF-8", "-cp", str(args.json_jar),
                        "-d", temporary, *map(str, sources)], check=True)
        command = [args.java, "-Xmx1400m", "-cp", temporary + os.pathsep + str(args.json_jar)]
        subprocess.run(command + ["com.navipilot.obf.EngineChecks"] +
                       ([str(args.catalog)] if args.catalog else []), check=True)
        if args.tiles:
            if not args.catalog or not args.audit_output:
                parser.error("--tiles requires --catalog and --audit-output")
            subprocess.run(command + ["com.navipilot.obf.CatalogRoadAudit", str(args.catalog),
                                       str(args.tiles), str(args.audit_output)], check=True)


if __name__ == "__main__":
    main()
