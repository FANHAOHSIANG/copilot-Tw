#!/usr/bin/env python3
"""Independently compare a final Link APK to its hash-pinned base and check DEX references.

This verifies static APK scope/member resolution. It does not run Android, grant
AMap authorization, exercise Binder, or establish reception by C4.
"""
from __future__ import annotations

import argparse
from concurrent.futures import ThreadPoolExecutor
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import zipfile


HERE = Path(__file__).resolve().parent
VERSION = "9.3.1-wide.45-amap-link"
VERSION_CODE = 26110757
METHODS = {
    "com/navipilot/obf/WideVariant.smali": {"prepare(Landroid/app/Activity;)V"},
    "com/navipilot/obf/WideAmapSource.smali": {
        "matches(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z",
        "select(Ljava/lang/String;)V", "status()Ljava/lang/String;",
        "filter(Lcom/navipilot/obf/MG;Ljava/lang/String;Lorg/json/JSONObject;Ljava/util/Map;)Lorg/json/JSONObject;",
    },
    "com/navipilot/obf/MG.smali": {"b(Ljava/lang/String;Lorg/json/JSONObject;Ljava/lang/String;)V"},
    "com/navipilot/obf/WideDirect$Pane.smali": {
        "lambda$9$com-navipilot-obf-WideDirect$Pane(Lcom/navipilot/obf/Mt;Ljava/lang/String;Lcom/navipilot/obf/WideDirect$RenderSize;Landroid/view/Surface;Ljava/lang/String;Lcom/navipilot/obf/WideDirect$LayoutStamp;I)V",
    },
    "com/jixiexiaoge/drivingassist/CarrotAmapForegroundService.smali": {
        "onStartCommand(Landroid/content/Intent;II)I", "onDestroy()V",
    },
}
VERSION_CLASS = "com/navipilot/obf/Yg.smali"
METHOD_PATTERN = re.compile(r"(?ms)^\.method [^\n]*\n.*?^\.end method")


def digest(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def file_hash(path: Path) -> str:
    value = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            value.update(block)
    return value.hexdigest()


def normalize(text: str) -> str:
    # String-index width changes do not change string values or instruction semantics.
    # Sequential labels are produced by the same baksmali command for both APKs.
    text = text.replace("const-string/jumbo ", "const-string ")
    return "\n".join(line.rstrip() for line in text.splitlines()).strip() + "\n"


def methods(text: str) -> dict[str, str]:
    return {m.group().splitlines()[0].split()[-1]: m.group()
            for m in METHOD_PATTERN.finditer(text)}


def skeleton(text: str) -> str:
    return METHOD_PATTERN.sub(lambda m: m.group().splitlines()[0], text)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--base-apk", required=True, type=Path)
    parser.add_argument("--apk", required=True, type=Path)
    parser.add_argument("--toolchain", required=True, type=Path)
    parser.add_argument("--output-dir", required=True, type=Path,
                        help="New scratch directory for extracted DEX, smali and logs")
    parser.add_argument("--report", type=Path, default=HERE / "verification/apk-scope.json")
    args = parser.parse_args()
    base, final, tools = args.base_apk.resolve(), args.apk.resolve(), args.toolchain.resolve()
    work = args.output_dir.resolve()
    work.mkdir(parents=True, exist_ok=False)
    (work / "logs").mkdir()
    errors: list[str] = []

    def require(condition: bool, message: str) -> None:
        if not condition:
            errors.append(message)

    def run(label: str, command: list[str | Path]) -> str:
        completed = subprocess.run(list(map(str, command)), text=True, stdout=subprocess.PIPE,
                                   stderr=subprocess.STDOUT)
        (work / "logs" / (label + ".txt")).write_text(completed.stdout, encoding="utf-8")
        if completed.returncode:
            raise RuntimeError(label + " failed; see " + str(work / "logs"))
        return completed.stdout

    base_hash, final_hash = file_hash(base), file_hash(final)
    bases = json.loads((HERE / "verification/bases.json").read_text())
    if base_hash not in bases:
        raise SystemExit("Unrecognized base APK SHA-256")
    base_info = bases[base_hash]
    jars = sorted((tools / "baksmali").glob("*.jar"))
    if not jars:
        raise SystemExit("No baksmali dependency JARs found")
    android, asm, ecj = tools / "platform/android-35/android.jar", tools / "asm.jar", tools / "ecj.jar"
    for tool in [android, asm, ecj]:
        if not tool.is_file():
            raise SystemExit("Missing verification dependency: " + str(tool))
    classpath = os.pathsep.join(map(str, jars))
    tool_hashes = {str(p.relative_to(tools)): file_hash(p) for p in [*jars, android, asm, ecj]}

    with zipfile.ZipFile(base) as old, zipfile.ZipFile(final) as new:
        old_names, new_names = set(old.namelist()), set(new.namelist())
        old_dex = {n: digest(old.read(n)) for n in old_names if re.fullmatch(r"classes(?:\d+)?\.dex", n)}
        new_dex = {n: digest(new.read(n)) for n in new_names if re.fullmatch(r"classes(?:\d+)?\.dex", n)}
        require(old_dex.keys() == new_dex.keys(), "DEX entry set changed")
        changed_dex = sorted(n for n in old_dex.keys() & new_dex.keys() if old_dex[n] != new_dex[n])
        require(changed_dex == ["classes.dex"], "Unexpected changed DEX entries: " + str(changed_dex))
        changed_entries = sorted(n for n in old_names & new_names if not n.endswith("/")
                                 and old.read(n) != new.read(n))
        protected_entries = sorted(n for n in old_names if n.startswith(("assets/", "lib/", "res/"))
                                   and not n.endswith("/"))
        protected_changed = [n for n in protected_entries if n not in new_names or old.read(n) != new.read(n)]
        require(not protected_changed, "Unrelated asset/library/resource files changed")
        for label, archive in [("base", old), ("final", new)]:
            folder = work / label
            folder.mkdir()
            (folder / "classes.dex").write_bytes(archive.read("classes.dex"))

    def disassemble(label: str) -> None:
        run("baksmali-" + label, ["java", "-cp", classpath, "org.jf.baksmali.Main", "disassemble",
            "--api", "35", "--jobs", "2", "--sequential-labels", "--use-locals",
            "--accessor-comments", "false", "--debug-info", "true",
            "--output", work / label / "smali", work / label / "classes.dex"])
        if not (work / label / "smali" / "com/navipilot/obf/WideAmapSource.smali").is_file():
            raise RuntimeError("baksmali did not produce the expected classes; inspect its log")

    with ThreadPoolExecutor(max_workers=2) as workers:
        list(workers.map(disassemble, ["base", "final"]))

    def load(label: str) -> dict[str, str]:
        root = work / label / "smali"
        return {str(path.relative_to(root)): normalize(path.read_text(encoding="utf-8"))
                for path in root.rglob("*.smali")}

    before, after = load("base"), load("final")
    added = sorted(after.keys() - before.keys())
    removed = sorted(before.keys() - after.keys())
    changed = sorted(name for name in before.keys() & after.keys() if before[name] != after[name])
    unchanged = sorted(name for name in before.keys() & after.keys() if before[name] == after[name])
    require(not removed, "Classes were removed: " + str(removed))
    require(bool(added) and all(n.startswith("com/navipilot/obf/WideAmapLink") for n in added),
            "Unexpected added class scope")
    require(set(changed) == set(METHODS) | {VERSION_CLASS}, "Unexpected changed class scope: " + str(changed))

    changed_methods: dict[str, list[str]] = {}
    for name in changed:
        old_methods, new_methods = methods(before[name]), methods(after[name])
        require(old_methods.keys() == new_methods.keys(), "Existing method set changed in " + name)
        actual = sorted(m for m in old_methods.keys() & new_methods.keys() if old_methods[m] != new_methods[m])
        changed_methods[name] = actual
        require(skeleton(before[name]) == skeleton(after[name]), "Class metadata/fields changed in " + name)
        if name == VERSION_CLASS:
            old_text = before[name].replace(base_info["version"], "@VERSION@") \
                                   .replace(str(base_info["versionCode"]), "@CODE@")
            new_text = after[name].replace(VERSION, "@VERSION@").replace(str(VERSION_CODE), "@CODE@")
            require(old_text == new_text, "Version class has changes beyond version literals")
        elif name in METHODS:
            require(set(actual) == METHODS[name], "Unexpected changed methods in " + name + ": " + str(actual))

    source_name = "com/navipilot/obf/WideAmapSource.smali"
    old_source, new_source = methods(before[source_name]), methods(after[source_name])
    protected_gate = sorted(name for name in old_source if name not in METHODS[source_name])
    require(all(old_source[name] == new_source.get(name) for name in protected_gate),
            "An original gate/camera method changed")
    google = sorted(name for name in before if name.startswith("com/navipilot/obf/WideGoogle"))
    require(all(before[name] == after.get(name) for name in google), "Existing Google helper class changed")
    google_calls = lambda text: [line.strip() for line in text.splitlines()
                                if "invoke-" in line and "Lcom/navipilot/obf/WideGoogle" in line]
    require(google_calls(before[source_name]) == google_calls(after[source_name]),
            "Existing Google source-gate calls changed")
    protected_classes = ["com/navipilot/obf/" + n + ".smali" for n in
                         ["IG", "h4", "uI", "WideAmapCamera", "WideAmapCamera$Notice",
                          "WideAmapPreAdjust", "WideBridge", "WideHcopMerge"]]
    protected_classes.append("com/jixiexiaoge/drivingassist/AmapAutoStaticReceiver.smali")
    require(all(n in before and before[n] == after.get(n) for n in protected_classes),
            "Auto parser/camera/Taiwan merge class changed")

    selected = sorted(changed + added)
    targets = work / "reference-targets.txt"
    targets.write_text("".join("L" + name[:-6] + ";\n" for name in selected), encoding="utf-8")
    checker_classes = work / "checker-classes"
    checker_classes.mkdir()
    checker_cp = os.pathsep.join([str(asm), classpath])
    run("compile-reference-checker", ["java", "-jar", ecj, "-8", "-proc:none", "-nowarn",
        "-cp", checker_cp, "-d", checker_classes, HERE / "tooling/CheckReferences.java"])
    references = json.loads(run("reference-checker", ["java", "-cp",
        str(checker_classes) + os.pathsep + checker_cp, "CheckReferences", final, targets, android]))
    require(not references["unresolved"], "Unresolved internal DEX references")

    report = {
        "passed": not errors,
        "baseVersion": base_info["version"], "baseSha256": base_hash,
        "apkVersion": VERSION, "apkVersionCode": VERSION_CODE, "apkSha256": final_hash,
        "apkBytes": final.stat().st_size,
        "normalization": {
            "tool": "same baksmali invocation for both APKs",
            "sequentialLabels": True, "debugInformationCompared": True,
            "constStringIndexWidthNormalized": True,
            "toolSha256": tool_hashes,
        },
        "dex": {"base": old_dex, "final": new_dex, "changed": changed_dex,
                "unchangedOtherDex": sorted(n for n in old_dex.keys() & new_dex.keys() if old_dex[n] == new_dex[n])},
        "classes": {"baseCount": len(before), "finalCount": len(after),
                    "unchangedCount": len(unchanged), "changed": changed, "added": added,
                    "removed": removed, "changedMethods": changed_methods},
        "preserved": {"sourceGateMethods": protected_gate, "googleHelperClasses": google,
                      "googleGateCallsUnchanged": True, "autoCameraAndTaiwanClasses": protected_classes,
                      "assetLibraryResourceFiles": len(protected_entries),
                      "changedProtectedFiles": protected_changed},
        "apkEntries": {"changed": changed_entries, "added": sorted(new_names - old_names),
                       "removed": sorted(old_names - new_names)},
        "references": references,
        "errors": errors,
        "limitations": ["Static APK/DEX comparison and reference resolution only.",
                        "No Android/ART runtime or Binder execution was performed.",
                        "Authorization on the user's phone and C4 reception remain untested."]
    }
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"passed": report["passed"], "report": str(args.report.resolve()),
                      "unchangedClasses": len(unchanged), "changedClasses": len(changed),
                      "addedClasses": len(added), "internalMethodReferences": references["internalMethodReferences"],
                      "errors": errors}, ensure_ascii=False))
    if errors:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
