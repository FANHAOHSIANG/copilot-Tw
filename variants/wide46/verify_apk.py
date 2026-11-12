#!/usr/bin/env python3
"""Independent wide46 APK scope, exact-hook and internal-member verifier.

Does not import build.py/patch_decoded.py or trust their reports. Does not execute
Android/ART, Google authorization, GPS, speech playback or C4 vehicle control.
"""
from __future__ import annotations

import argparse
from concurrent.futures import ThreadPoolExecutor
import difflib
import gzip
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import zipfile

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[1]
BASE_HASH = "38e9a898b1543eea4d09a8d3188667f8e49a712482dc278f838d35913074c598"
BASE_VERSION, BASE_CODE = "9.3.1-wide.45-amap-link", 26110757
VERSION, CODE = "9.3.1-wide.46-enforcement-google", 26110758
ROOT = "com/navipilot/obf/"
VERSION_CLASS = ROOT + "Yg.smali"
FAMILIES = ("WideCameraPanel", "WideDashboardFace", "WideGoogleAdapter")
ASSET = "assets/tw_enforcement.json.gz"
RUNTIME = "Lcom/navipilot/obf/WideEnforcementRuntime;"
METHOD_RE = re.compile(r"(?ms)^\.method [^\n]*\n.*?^\.end method")
# Hook body, exact new opcode/arguments, and exact immediately preceding anchor.
# None means the inserted call must be the first executable opcode.
HOOKS = {
    ROOT + "WideCamera.smali": {
        "init(Landroid/content/Context;)V":
            ("invoke-static/range {p0 .. p0}, " + RUNTIME + "->init(Landroid/content/Context;)V", None),
        "clearFix()V": ("invoke-static {}, " + RUNTIME + "->clear()V", None),
        "accept(Landroid/location/Location;)V":
            ("invoke-static {v0}, " + RUNTIME + "->onFix(Lcom/navipilot/obf/WideCameraEngine$Fix;)V",
             "invoke-static {v0}, Lcom/navipilot/obf/WideBridge;->accept(Lcom/navipilot/obf/WideCameraEngine$Fix;)V"),
    },
    ROOT + "WideCameraTrace.smali": {
        "update(Lcom/navipilot/obf/WideHcopRoad$Data;Lcom/navipilot/obf/WideCameraEngine$Fix;J)V":
            ("invoke-static {p0, p1, p2}, " + RUNTIME + "->onRoadUpdate(Lcom/navipilot/obf/WideHcopRoad$Data;Lcom/navipilot/obf/WideCameraEngine$Fix;Lcom/navipilot/obf/WideHcopRoad$Decision;)V",
             "sput-object p3, Lcom/navipilot/obf/WideCameraTrace;->published:Lcom/navipilot/obf/WideCameraTrace$Frame;"),
    },
    ROOT + "WideCameraVoice.smali": {
        "lambda$1(Landroid/content/Context;ZLandroid/media/MediaPlayer;)V":
            ("invoke-static {}, " + RUNTIME + "->cameraVoiceStarted()V",
             "invoke-virtual {p2}, Landroid/media/MediaPlayer;->start()V"),
    },
}


def digest(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def file_hash(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for block in iter(lambda: f.read(1024 * 1024), b""):
            h.update(block)
    return h.hexdigest()


def normalize(text: str) -> str:
    # Only string-pool index encoding width is normalized; debug info stays compared.
    text = text.replace("const-string/jumbo ", "const-string ")
    return "\n".join(line.rstrip() for line in text.splitlines()).strip() + "\n"


def methods(text: str) -> dict[str, str]:
    return {m.group().splitlines()[0].split()[-1]: m.group() for m in METHOD_RE.finditer(text)}


def skeleton(text: str) -> str:
    return METHOD_RE.sub(lambda m: m.group().splitlines()[0], text)


def nonempty(text: str) -> list[str]:
    return [line.rstrip() for line in text.splitlines() if line.strip()]


def family(name: str) -> bool:
    if not name.startswith(ROOT):
        return False
    local = name[len(ROOT):]
    return any(local == f + ".smali" or local.startswith(f + "$") for f in FAMILIES)


def enforcement(name: str) -> bool:
    return name.startswith(ROOT + "WideEnforcement") and name.endswith(".smali")


def signing_metadata(name: str) -> bool:
    return bool(re.fullmatch(r"META-INF/(?:MANIFEST\.MF|[^/]+\.(?:SF|RSA|DSA|EC))", name, re.I))


def xml_tree(dump: str) -> dict:
    """Parse aapt2's binary-AXML tree, retaining values/order and ignoring source line numbers."""
    result = {"namespaces": [], "children": []}
    stack: list[tuple[int, dict]] = [(-1, result)]
    for raw in dump.splitlines():
        line = re.sub(r" \(line=\d+\)$", "", raw.rstrip())
        stripped = line.lstrip()
        if not stripped:
            continue
        indent = len(line) - len(stripped)
        if stripped.startswith("N: "):
            result["namespaces"].append(stripped)
        elif stripped.startswith("E: "):
            while stack[-1][0] >= indent:
                stack.pop()
            node = {"element": stripped[3:], "attributes": [], "children": []}
            stack[-1][1]["children"].append(node)
            stack.append((indent, node))
        elif stripped.startswith("A: "):
            if len(stack) == 1 or indent <= stack[-1][0]:
                raise ValueError("Unexpected binary manifest attribute hierarchy")
            stack[-1][1]["attributes"].append(stripped[3:])
        else:
            raise ValueError("Unsupported aapt2 manifest token: " + stripped)
    return result


def manifest_version(tree: dict, version: str, code: int) -> None:
    if len(tree["children"]) != 1 or tree["children"][0]["element"] != "manifest":
        raise ValueError("Unexpected manifest root")
    attrs = tree["children"][0]["attributes"]
    expected = {
        "versionCode": f"http://schemas.android.com/apk/res/android:versionCode(0x0101021b)={code}",
        "versionName": f'http://schemas.android.com/apk/res/android:versionName(0x0101021c)="{version}" (Raw: "{version}")',
    }
    for key, value in expected.items():
        if attrs.count(value) != 1:
            raise ValueError("Unexpected APK " + key)
        attrs[attrs.index(value)] = "@" + key + "@"


def remove_tts_query(tree: dict) -> int:
    name = 'http://schemas.android.com/apk/res/android:name(0x01010003)="android.intent.action.TTS_SERVICE" (Raw: "android.intent.action.TTS_SERVICE")'
    expected = {"element": "intent", "attributes": [], "children": [
        {"element": "action", "attributes": [name], "children": []}]}
    count = 0
    for item in tree["children"][0]["children"]:
        if item["element"] == "queries":
            count += item["children"].count(expected)
            item["children"] = [child for child in item["children"] if child != expected]
    return count


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--base-apk", required=True, type=Path)
    parser.add_argument("--apk", required=True, type=Path)
    parser.add_argument("--toolchain", type=Path, default=Path("/tmp/copilot-build"))
    parser.add_argument("--build-tools", type=Path)
    parser.add_argument("--output-dir", required=True, type=Path, help="New scratch directory for verifier evidence")
    parser.add_argument("--catalog", type=Path, default=REPO / "data/enforcement/tw_enforcement.json")
    parser.add_argument("--report", type=Path, default=HERE / "verification/apk-scope.json")
    args = parser.parse_args()
    base, final, tools, work = [p.resolve() for p in (args.base_apk, args.apk, args.toolchain, args.output_dir)]
    bt = (args.build_tools or tools / "build-tools/android-16").resolve()
    base_hash, final_hash = file_hash(base), file_hash(final)
    if base_hash != BASE_HASH:
        raise SystemExit("Unrecognized base APK SHA-256; expected the delivered signed wide45")
    work.mkdir(parents=True, exist_ok=False)
    (work / "logs").mkdir()
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps({"passed": False, "verificationComplete": False,
        "baseSha256": base_hash, "apkSha256": final_hash, "evidenceDirectory": str(work),
        "errors": ["Verification has not completed; inspect the command result and evidence logs."]},
        ensure_ascii=False, indent=2) + "\n")
    errors: list[str] = []

    def require(okay: bool, message: str) -> None:
        if not okay:
            errors.append(message)

    def run(label: str, cmd: list[str | Path], accepted=(0,)) -> str:
        completed = subprocess.run(list(map(str, cmd)), stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
        (work / "logs" / (label + ".txt")).write_text(completed.stdout, encoding="utf-8")
        if completed.returncode not in accepted:
            raise RuntimeError(label + " failed; inspect " + str(work / "logs" / (label + ".txt")))
        return completed.stdout

    java = tools / "jdk21/bin/java"
    jars = sorted((tools / "baksmali").glob("*.jar"))
    android, asm, ecj = tools / "platform/android-35/android.jar", tools / "asm.jar", tools / "ecj.jar"
    checker = HERE.parent / "amap-link1/tooling/CheckReferences.java"
    dependencies = [java, *jars, android, asm, ecj, bt / "aapt2", bt / "lib/apksigner.jar", checker]
    if not jars or any(not p.is_file() for p in dependencies):
        raise SystemExit("Missing verifier dependency")
    tool_hashes = {str(p): file_hash(p) for p in dependencies}
    # Tool bundles can be read-only/non-executable. Make only a local executable copy.
    aapt = work / "aapt2"
    shutil.copyfile(bt / "aapt2", aapt)
    aapt.chmod(0o755)
    cp = os.pathsep.join(map(str, jars))

    with zipfile.ZipFile(base) as old, zipfile.ZipFile(final) as new:
        old_all, new_all = old.namelist(), new.namelist()
        require(len(old_all) == len(set(old_all)) and len(new_all) == len(set(new_all)), "Duplicate APK ZIP entries")
        old_names, new_names = {n for n in old_all if not n.endswith("/")}, {n for n in new_all if not n.endswith("/")}
        changed_entries = sorted(n for n in old_names & new_names if old.read(n) != new.read(n))
        added_entries, removed_entries = sorted(new_names - old_names), sorted(old_names - new_names)
        require(all(n in {"classes.dex", "AndroidManifest.xml"} or signing_metadata(n) for n in changed_entries),
                "Unexpected modified ZIP payload: " + str([n for n in changed_entries if n not in {"classes.dex", "AndroidManifest.xml"} and not signing_metadata(n)]))
        require(all(n == ASSET or signing_metadata(n) for n in added_entries) and ASSET in added_entries, "Unexpected new APK entries")
        require(all(signing_metadata(n) for n in removed_entries), "Non-signature APK entries were removed")
        old_dex = {n: digest(old.read(n)) for n in old_names if re.fullmatch(r"classes(?:\d+)?\.dex", n)}
        new_dex = {n: digest(new.read(n)) for n in new_names if re.fullmatch(r"classes(?:\d+)?\.dex", n)}
        changed_dex = sorted(n for n in old_dex.keys() & new_dex.keys() if old_dex[n] != new_dex[n])
        require(old_dex.keys() == new_dex.keys() and changed_dex == ["classes.dex"], "Unexpected DEX entry scope")
        protected_entries = sorted(n for n in old_names if n.startswith(("assets/", "lib/", "res/")))
        protected_changed = [n for n in protected_entries if n not in new_names or old.read(n) != new.read(n)]
        require(not protected_changed, "An original asset/library/resource changed")
        asset_data = gzip.decompress(new.read(ASSET))
        catalog_data = args.catalog.read_bytes()
        require(asset_data == catalog_data, "Bundled enforcement catalog differs from the reviewed source JSON")
        asset_catalog = json.loads(asset_data)
        require(asset_catalog.get("schemaVersion") == 1 and bool(asset_catalog.get("records")), "Bundled catalog schema is invalid")
        for label, archive in [("base", old), ("final", new)]:
            folder = work / label
            folder.mkdir()
            (folder / "classes.dex").write_bytes(archive.read("classes.dex"))

    def disassemble(label: str) -> None:
        run("baksmali-" + label, [java, "-cp", cp, "org.jf.baksmali.Main", "disassemble", "--api", "35",
            "--jobs", "2", "--sequential-labels", "--use-locals", "--accessor-comments", "false", "--debug-info", "true",
            "--output", work / label / "smali", work / label / "classes.dex"])
        if not (work / label / "smali" / (ROOT + "WideAmapSource.smali")).is_file():
            raise RuntimeError("Missing expected disassembled class")

    with ThreadPoolExecutor(max_workers=2) as pool:
        list(pool.map(disassemble, ["base", "final"]))

    def load(label: str) -> dict[str, str]:
        folder = work / label / "smali"
        return {str(p.relative_to(folder)): normalize(p.read_text()) for p in folder.rglob("*.smali")}

    before, after = load("base"), load("final")
    added, removed = sorted(after.keys() - before.keys()), sorted(before.keys() - after.keys())
    changed = sorted(n for n in before.keys() & after.keys() if before[n] != after[n])
    unchanged = sorted(n for n in before.keys() & after.keys() if before[n] == after[n])
    require(all(family(n) or enforcement(n) for n in added), "Unexpected added class scope")
    require(all(family(n) and "$" in n for n in removed), "A non-synthetic or unrelated class was removed")
    require(all(family(n) or n in HOOKS or n == VERSION_CLASS for n in changed), "Unexpected changed class scope")
    require(set(HOOKS) | {VERSION_CLASS} <= set(changed), "A required hook/version class did not change")
    require(all(ROOT + f + ".smali" in changed for f in FAMILIES), "A required replacement root did not change")
    require(all(ROOT + f + ".smali" in added for f in ["WideEnforcementEngine", "WideEnforcementRuntime", "WideEnforcementVoice", "WideEnforcementPanel", "WideEnforcementLabels"]),
            "Missing required enforcement production class")
    changed_methods, hook_results = {}, []
    for name in [*HOOKS, VERSION_CLASS]:
        if name not in before or name not in after:
            require(False, "Missing protected hook class " + name)
            continue
        old_methods, new_methods = methods(before[name]), methods(after[name])
        actual = sorted(m for m in old_methods.keys() & new_methods.keys() if old_methods[m] != new_methods[m])
        changed_methods[name] = actual
        require(old_methods.keys() == new_methods.keys(), "Method set changed in protected hook class " + name)
        require(skeleton(before[name]) == skeleton(after[name]), "Fields/metadata changed in protected hook class " + name)
        if name == VERSION_CLASS:
            require(BASE_VERSION in before[name] and VERSION in after[name], "Version UI label is absent")
            require(before[name].replace(BASE_VERSION, "@VERSION@").replace(str(BASE_CODE), "@CODE@") ==
                    after[name].replace(VERSION, "@VERSION@").replace(str(CODE), "@CODE@"), "Version class has changes beyond allowed literals")
            continue
        require(set(actual) == set(HOOKS[name]), "Unexpected modified methods in " + name)
        for signature, (opcode, anchor) in HOOKS[name].items():
            old_body, new_body = old_methods.get(signature, ""), new_methods.get(signature, "")
            lines = nonempty(new_body)
            inserted = [i for i, line in enumerate(lines) if line.strip() == opcode]
            require(len(inserted) == 1, "Hook must appear exactly once: " + signature)
            if len(inserted) != 1:
                continue
            pos = inserted[0]
            if anchor is None:
                executable = [i for i, line in enumerate(lines) if not line.strip().startswith((".", ":", "#"))]
                position_ok = bool(executable) and executable[0] == pos
            else:
                position_ok = pos > 0 and lines[pos - 1].strip() == anchor
            require(position_ok, "Hook is not at its authorized exact anchor: " + signature)
            restored = lines[:pos] + lines[pos + 1:]
            restored_equal = restored == nonempty(old_body)
            require(restored_equal, "Hook method has unrelated instruction/debug changes: " + signature)
            hook_results.append({"class": name, "method": signature, "opcode": opcode,
                                 "exactAnchor": position_ok, "originalBodyRestoredAfterRemovingSingleCall": restored_equal})

    # Explicit independent protection summaries in addition to the global allowlist.
    protected_classes = sorted(n for n in before if n.startswith(ROOT + "WideAmap") or n in {
        ROOT + f + ".smali" for f in ["MG", "XG", "WideVariant", "WideBridge", "WideHcopMerge", "WideVehiclePanel", "IG", "h4", "uI"]}
        or n.startswith(ROOT + "WideVehiclePanel$") or n == "com/jixiexiaoge/drivingassist/AmapAutoStaticReceiver.smali")
    require(all(before[n] == after.get(n) for n in protected_classes), "Source gate, AMap, vehicle or control class changed")
    google_protected = sorted(n for n in before if n.startswith(ROOT + "WideGoogle") and not family(n))
    require(all(before[n] == after.get(n) for n in google_protected), "Unrelated Google integration class changed")
    removed_descriptors = ["L" + n[:-6] + ";" for n in removed]
    stale_type_references = {n: [d for d in removed_descriptors if d in text]
                             for n, text in after.items() if any(d in text for d in removed_descriptors)}
    require(not stale_type_references, "Final classes still mention a removed synthetic type")

    manifest_raw = {label: run("manifest-" + label, [aapt, "dump", "xmltree", "--file", "AndroidManifest.xml", apk])
                    for label, apk in [("base", base), ("final", final)]}
    manifest_trees = {label: xml_tree(raw) for label, raw in manifest_raw.items()}
    manifest_version(manifest_trees["base"], BASE_VERSION, BASE_CODE)
    manifest_version(manifest_trees["final"], VERSION, CODE)
    base_tts, new_tts = [remove_tts_query(manifest_trees[label]) for label in ["base", "final"]]
    require(base_tts == 0 and new_tts == 1, "TTS package query must be the single exact authorized addition")
    manifest_equal = manifest_trees["base"] == manifest_trees["final"]
    require(manifest_equal, "Manifest changed beyond version and one TTS_SERVICE query")
    manifest_diff = "".join(difflib.unified_diff(
        re.sub(r" \(line=\d+\)", "", manifest_raw["base"]).splitlines(keepends=True),
        re.sub(r" \(line=\d+\)", "", manifest_raw["final"]).splitlines(keepends=True), "base", "final"))
    (work / "manifest-diff.txt").write_text(manifest_diff)

    # Also check unchanged reverse consumers of replacement families, so removed
    # synthetic helpers or changed member signatures cannot leave stale call sites.
    replacement_reference = re.compile(r"Lcom/navipilot/obf/(?:WideCameraPanel|WideDashboardFace|WideGoogleAdapter)(?:\$[^;\s]+)?;->")
    consumers = sorted(n for n, text in after.items() if replacement_reference.search(text))
    selected = sorted(set(changed + added + consumers) | {n for n in after if family(n)})
    target_file = work / "reference-targets.txt"
    target_file.write_text("".join("L" + n[:-6] + ";\n" for n in selected))
    checker_classes = work / "checker-classes"
    checker_classes.mkdir()
    checker_cp = os.pathsep.join([str(asm), cp])
    run("compile-reference-checker", [java, "-jar", ecj, "-8", "-proc:none", "-nowarn", "-cp", checker_cp,
                                     "-d", checker_classes, checker])
    references = json.loads(run("reference-checker", [java, "-cp", str(checker_classes) + os.pathsep + checker_cp,
        "CheckReferences", final, target_file, android], accepted=(0, 1)))
    require(not references["unresolved"], "Unresolved internal DEX member references")
    require(references["selectedClassCount"] == len(selected), "Reference checker did not check every selected class")

    certificates = {}
    for label, apk in [("base", base), ("final", final)]:
        result = run("certificate-" + label, [java, "-jar", bt / "lib/apksigner.jar", "verify", "--verbose", "--print-certs", apk])
        certificates[label] = re.findall(r"certificate SHA-256 digest: ([a-f0-9]+)", result)
    require(bool(certificates["base"]) and certificates["base"] == certificates["final"], "APK signing certificate changed")
    require(base_hash == file_hash(base) and final_hash == file_hash(final), "An APK changed during verification")

    report = {
        "passed": not errors, "verificationComplete": True, "verifierSha256": file_hash(Path(__file__)),
        "version": VERSION, "versionCode": CODE, "baseVersion": BASE_VERSION,
        "baseSha256": base_hash, "apkSha256": final_hash, "apkBytes": final.stat().st_size,
        "independentOfBuildReport": True,
        "normalization": {"tool": "identical baksmali invocation", "sequentialLabels": True,
                          "debugInformationCompared": True, "constStringIndexWidthNormalized": True,
                          "hookWhitespaceOnlyIgnored": True, "toolSha256": tool_hashes},
        "dex": {"base": old_dex, "final": new_dex, "changed": changed_dex,
                "unchangedOtherDex": sorted(n for n in old_dex if old_dex[n] == new_dex.get(n))},
        "classes": {"baseCount": len(before), "finalCount": len(after), "unchangedCount": len(unchanged),
                    "changed": changed, "added": added, "removedStaleFamilySynthetics": removed,
                    "protectedHookChangedMethods": changed_methods},
        "exactHooks": hook_results,
        "manifest": {"versionAndExactTtsQueryOnly": manifest_equal and base_tts == 0 and new_tts == 1,
                     "baseTtsQueries": base_tts, "finalTtsQueries": new_tts, "diff": manifest_diff},
        "preserved": {"sourceGateAmapVehicleControlClasses": protected_classes,
                      "googleIntegrationClasses": google_protected, "originalAssetsLibrariesResources": len(protected_entries),
                      "changedProtectedFiles": protected_changed, "resourcesArscUnchanged": "resources.arsc" not in changed_entries},
        "apkEntries": {"changed": changed_entries, "added": added_entries, "removed": removed_entries},
        "catalog": {"entry": ASSET, "matchesSource": asset_data == catalog_data, "jsonSha256": digest(asset_data),
                    "records": len(asset_catalog["records"])},
        "references": {**references, "additionalUnchangedReverseConsumers": [n for n in consumers if n not in changed and n not in added]},
        "removedSyntheticTypeReferences": stale_type_references,
        "certificatesSha256": certificates, "sameSigningCertificate": certificates["base"] == certificates["final"],
        "errors": errors,
        "limitations": ["Static APK/DEX/manifest comparison and internal member resolution only.",
                        "Compilation does not establish Android/ART runtime, GPS, TTS or C4 behavior.",
                        "External platform references are bounded by the compilation SDK; this checker reports external references skipped.",
                        "Google authorization, actual account billing and road testing were not performed."]}
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps({"passed": not errors, "report": str(args.report.resolve()), "apkSha256": final_hash,
                      "unchangedClasses": len(unchanged), "changedClasses": len(changed), "addedClasses": len(added),
                      "removedStaleSynthetics": len(removed), "checkedReferenceClasses": references["selectedClassCount"],
                      "internalMethodReferences": references["internalMethodReferences"], "errors": errors}, ensure_ascii=False))
    if errors:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
