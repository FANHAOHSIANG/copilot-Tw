"""Build the unsigned wide57 overlay using the pinned wide56 APK."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import zipfile

HERE = Path(__file__).resolve().parent
GOOGLE = HERE.parent / "google-navdash/app/src/main/java/com/navdashn"
BASE_SHA = "a6ccb0937845f36c0cd6aefb9f69c2ed665876b22ea263c5190c61b144444454"


def sha(path):
    with Path(path).open("rb") as handle:
        return hashlib.file_digest(handle, "sha256").hexdigest()


def run(*args):
    subprocess.run([str(arg) for arg in args], check=True)


def build(base, tools, output, temp):
    android = tools / "android.jar"
    apktool = tools / "apktool.jar"
    build_tools = tools / "android-15"
    smali_tools = os.pathsep.join(str(jar) for jar in sorted((tools / "deps").glob("*.jar")))
    decoded = temp / "decoded"
    run("java", "-jar", apktool, "d", "-f", base, "-o", decoded)
    run(sys.executable, HERE / "patch.py", decoded)

    compiled = temp / "compiled"
    run("java", "-jar", tools / "ecj.jar", "-8", "-proc:none", "-encoding", "UTF-8",
        "-cp", android, "-d", compiled, *sorted((HERE / "stubs").rglob("*.java")),
        GOOGLE / "GuidanceReturn.java")
    dex = temp / "dex"
    dex.mkdir()
    run("java", "-cp", build_tools / "lib/d8.jar", "com.android.tools.r8.D8",
        "--min-api", "31", "--no-desugaring", "--output", dex,
        *sorted((compiled / "com/navdashn").glob("GuidanceReturn*.class")))
    helper = temp / "helper"
    run("java", "-cp", smali_tools, "org.jf.baksmali.Main", "d", dex / "classes.dex", "-o", helper)
    generated = list(helper.rglob("*.smali"))
    if {item.name for item in generated} != {"GuidanceReturn.smali", "GuidanceReturn$1.smali"}:
        raise ValueError("Unexpected Java classes in the APK overlay")
    for item in generated:
        shutil.copyfile(item, decoded / "smali_classes5/com/navdashn" / item.name)

    rebuilt = temp / "rebuilt.apk"
    run("java", "-jar", apktool, "b", decoded, "-o", rebuilt)
    replacements = {"AndroidManifest.xml": None}
    for entry, folder in (("classes.dex", "smali"), ("classes5.dex", "smali_classes5")):
        file = temp / entry
        run("java", "-cp", smali_tools, "org.jf.smali.Main", "assemble", "--api", "31",
            decoded / folder, "-o", file)
        with file.open("rb") as dex_file:
            if dex_file.read(8) != b"dex\n039\0":
                raise ValueError(f"Unexpected DEX version: {entry}")
        replacements[entry] = file

    unaligned = temp / "unaligned.apk"
    with zipfile.ZipFile(base) as original, zipfile.ZipFile(rebuilt) as rebuilt_zip, \
            zipfile.ZipFile(unaligned, "w") as result:
        for entry in original.infolist():
            name = entry.filename
            if name not in replacements:
                data = original.read(name)
            elif replacements[name] is None:
                data = rebuilt_zip.read(name)
            else:
                data = replacements[name].read_bytes()
            result.writestr(entry, data)
    run(build_tools / "zipalign", "-P", "16", "-f", "4", unaligned, output)
    run(build_tools / "zipalign", "-c", "-P", "16", "4", output)
    with zipfile.ZipFile(base) as original, zipfile.ZipFile(output) as result:
        if original.namelist() != result.namelist():
            raise ValueError("APK entries changed")
        changed = sorted(name for name in result.namelist() if original.read(name) != result.read(name))
    if changed != sorted(replacements):
        raise ValueError(f"Unexpected APK changes: {changed}")
    return changed


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ("base-apk", "tools", "output"):
        parser.add_argument("--" + name, required=True, type=Path)
    args = parser.parse_args()
    if sha(args.base_apk) != BASE_SHA:
        parser.error("Expected the exact wide56 unsigned build")
    if args.output.exists() or "UNSIGNED" not in args.output.name:
        parser.error("Use a new filename containing UNSIGNED")
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="wide57-") as work:
        changed = build(args.base_apk.resolve(), args.tools.resolve(), args.output.resolve(), Path(work))
    report = {"sha256": sha(args.output), "changed_entries": changed, "android_device_tested": False}
    args.output.with_suffix(".build.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
