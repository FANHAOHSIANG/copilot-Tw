"""Build an unsigned wide.71 APK from the exact signed wide.70 release."""
import argparse
from hashlib import file_digest
from pathlib import Path
import re
import shutil
import struct
import subprocess
import tempfile
from zipfile import ZipFile

from patch import VERSION, apply, replace


HERE = Path(__file__).resolve().parent
BASE_SHA256 = "3b6860407433ccb558a6e063c8bafd10d5e7d914b88eb174a6e2281676cd875a"
PACKAGE = Path("com/navipilot/obf")
OLD_SIGNATURE = re.compile(r"META-INF/(?:MANIFEST\.MF|[^/]+\.(?:SF|RSA|DSA|EC))", re.I)


def run(*args):
    subprocess.run([str(arg) for arg in args], check=True)


def manifest_version(data):
    data = replace(data, "wide.70".encode("utf-16le"), VERSION.encode("utf-16le"))
    return replace(data, struct.pack("<I", 26110782), struct.pack("<I", 26110783))


def build(base, tools, apktool, output, work):
    sdk = tools / "android-15"
    android = tools / "android.jar"
    dalvik = ("java", "-cp", apktool, HERE.parent / "wide69/Dalvik.java")
    primary = work / "primary"
    original_dex = work / "original.dex"
    with ZipFile(base) as apk:
        original_dex.write_bytes(apk.read("classes.dex"))
        manifest = manifest_version(apk.read("AndroidManifest.xml"))
    run(*dalvik, "decode", original_dex, primary)
    apply(primary / PACKAGE)

    d8 = work / "d8"
    d8.mkdir()
    stubs, classes = (work / folder for folder in ("stubs", "classes"))
    javac = ("java", "-m", "jdk.compiler/com.sun.tools.javac.Main", "-source", "17", "-target", "17",
             "-Xlint:-options", "-encoding", "UTF-8")
    run(*javac, "-cp", android, "-d", stubs, HERE / "stubs/WideBridgeLog.java")
    run(*javac, "-cp", f"{android}:{stubs}", "-d", classes, *sorted((HERE / "src").glob("*.java")))
    run("java", "-cp", sdk / "lib/d8.jar", "com.android.tools.r8.D8", "--min-api", "31",
        "--lib", android, "--classpath", stubs, "--output", d8, *sorted(classes.rglob("*.class")))
    overlay = work / "overlay"
    run(*dalvik, "decode", d8 / "classes.dex", overlay)
    for path in sorted((overlay / PACKAGE).glob("*.smali")):
        destination = primary / PACKAGE / path.name
        with path.open("rb") as source, destination.open("xb") as target:
            shutil.copyfileobj(source, target)

    dex = work / "patched.dex"
    run(*dalvik, "assemble", primary, dex)
    changes = {"AndroidManifest.xml": manifest, "classes.dex": dex.read_bytes()}
    unaligned, aligned = (work / name for name in ("unaligned.apk", "aligned.apk"))
    with ZipFile(base) as original, ZipFile(unaligned, "w") as apk:
        for entry in original.infolist():
            name = entry.filename
            if not OLD_SIGNATURE.fullmatch(name):
                apk.writestr(entry, changes[name] if name in changes else original.read(entry))
    run(sdk / "zipalign", "-P", "16", "-f", "4", unaligned, aligned)
    run(sdk / "zipalign", "-P", "16", "-c", "4", aligned)
    with ZipFile(base) as original, ZipFile(aligned) as apk:
        entries = {name for name in original.namelist() if not OLD_SIGNATURE.fullmatch(name)}
        if set(apk.namelist()) != entries or apk.testzip() is not None:
            raise ValueError("APK inventory or CRC check failed")
        changed = {name for name in entries if apk.read(name) != original.read(name)}
        if changed != changes.keys():
            raise ValueError(f"Unexpected changes in APK entries: {changed ^ changes.keys()}")
    with aligned.open("rb") as source, output.open("xb") as target:
        shutil.copyfileobj(source, target)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ("base", "tools", "apktool", "output"):
        parser.add_argument(name, type=Path)
    args = parser.parse_args()
    with args.base.open("rb") as source:
        if file_digest(source, "sha256").hexdigest() != BASE_SHA256:
            parser.error("Use the exact signed wide.70 release APK")
    if args.output.exists():
        parser.error("Choose a new output filename")
    with tempfile.TemporaryDirectory(prefix="bridge-wide71-") as directory:
        build(args.base.resolve(), args.tools.resolve(), args.apktool.resolve(), args.output.resolve(), Path(directory))
