"""Build the wide58 UI overlay from the exact wide57 unsigned APK."""
import argparse
import hashlib
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import zipfile

HERE = Path(__file__).resolve().parent
BASE_SHA = "f1c22ada09d0010f8683ab60b38d0fb81e914d987a8e8343863a9ee14a0d22d4"
RENAMED = {"res/mipmap-anydpi-v26/bridge_launcher.xml": "res/mipmap-anydpi/bridge_launcher.xml"}
CHANGED = {"AndroidManifest.xml", "classes.dex", "classes5.dex", "resources.arsc", "res/layout/activity_main.xml"}


def sha(path):
    with path.open("rb") as source:
        return hashlib.file_digest(source, "sha256").hexdigest()


def run(*args):
    subprocess.run([str(arg) for arg in args], check=True)


def build(base, tools, output, temp):
    apktool = tools / "apktool.jar"
    build_tools = tools / "android-15"
    dependencies = os.pathsep.join(str(jar) for jar in sorted((tools / "deps").glob("*.jar")))
    decoded = temp / "decoded"
    run("java", "-jar", apktool, "d", "-f", base, "-o", decoded)
    run(sys.executable, HERE / "patch.py", decoded)

    compiled = temp / "compiled"
    run("java", "-jar", tools / "ecj.jar", "-8", "-proc:none", "-encoding", "UTF-8",
        "-cp", tools / "android.jar", "-d", compiled,
        *sorted((HERE / "stubs").rglob("*.java")), *sorted((HERE / "src").glob("*.java")))
    helpers = sorted(path for path in compiled.rglob("*.class")
                     if path.name.startswith(("WideFirstRun", "WideDiagnosticActions")))
    dex = temp / "dex"
    dex.mkdir()
    run("java", "-cp", build_tools / "lib/d8.jar", "com.android.tools.r8.D8", "--min-api", "31",
        "--no-desugaring", "--output", dex, *helpers)
    generated = temp / "generated"
    run("java", "-cp", dependencies, "org.jf.baksmali.Main", "d", dex / "classes.dex", "-o", generated)
    for item in generated.rglob("*.smali"):
        shutil.copyfile(item, decoded / "smali" / item.relative_to(generated))

    rebuilt = temp / "rebuilt.apk"
    run("java", "-jar", apktool, "b", decoded, "-o", rebuilt)
    dex_files = {}
    for name, folder in (("classes.dex", "smali"), ("classes5.dex", "smali_classes5")):
        dex_file = temp / name
        run("java", "-cp", dependencies, "org.jf.smali.Main", "assemble", "--api", "31",
            decoded / folder, "-o", dex_file)
        with dex_file.open("rb") as handle:
            if handle.read(8) != b"dex\n039\0":
                raise ValueError(f"Unexpected DEX format: {name}")
        dex_files[name] = dex_file

    unaligned = temp / "unaligned.apk"
    with zipfile.ZipFile(base) as original, zipfile.ZipFile(rebuilt) as source, \
            zipfile.ZipFile(unaligned, "w") as result:
        for entry in original.infolist():
            name = entry.filename
            if name in dex_files:
                data = dex_files[name].read_bytes()
            elif name in CHANGED:
                data = source.read(name)
            else:
                data = original.read(name)
            if name in RENAMED:
                entry.filename = RENAMED[name]
            result.writestr(entry, data)
    run(build_tools / "zipalign", "-P", "16", "-f", "4", unaligned, output)
    run(build_tools / "zipalign", "-c", "-P", "16", "4", output)
    with zipfile.ZipFile(base) as original, zipfile.ZipFile(output) as result:
        original_names = original.namelist()
        if [RENAMED.get(name, name) for name in original_names] != result.namelist():
            raise ValueError("APK entries changed")
        actual = {name for name in original_names
                  if original.read(name) != result.read(RENAMED.get(name, name))}
    if actual != CHANGED:
        raise ValueError(f"Unexpected APK payload changes: {actual}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ("base-apk", "tools", "output"):
        parser.add_argument("--" + name, required=True, type=Path)
    args = parser.parse_args()
    if sha(args.base_apk) != BASE_SHA:
        parser.error("Expected the pinned wide57 unsigned APK")
    if args.output.exists() or "UNSIGNED" not in args.output.name:
        parser.error("Use a new filename containing UNSIGNED")
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="wide58-") as work:
        build(args.base_apk.resolve(), args.tools.resolve(), args.output.resolve(), Path(work))
    print("SHA-256:", sha(args.output))


if __name__ == "__main__":
    main()
