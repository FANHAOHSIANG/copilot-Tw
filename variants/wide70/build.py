"""Build an unsigned wide.70 APK from the exact signed wide.69 release."""
import argparse
from hashlib import file_digest
from pathlib import Path
import re
import struct
import subprocess
import tempfile
from zipfile import ZipFile

from patch import VERSION, apply, replace


HERE = Path(__file__).resolve().parent
BASE_SHA256 = "12b1d75dfcc19c18e8dc53f62e6c9085c446907edeb1c9dfc715845dffbecd30"
PACKAGE = Path("com/navipilot/obf")
CHANGED = {"classes.dex", "classes8.dex", "resources.arsc", "AndroidManifest.xml"}
OLD_SIGNATURE = re.compile(r"META-INF/(?:MANIFEST\.MF|[^/]+\.(?:SF|RSA|DSA|EC))", re.I)


def run(*args, **kwargs):
    return subprocess.run([str(arg) for arg in args], check=True, **kwargs)


def manifest_version(data):
    def utf16_string(value):
        return struct.pack("<H", len(value)) + value.encode("utf-16le") + b"\0\0"

    previous = utf16_string("9.3.1-wide.69-ui")
    current = utf16_string(VERSION)
    # Keep the original UTF-16 string-pool offsets and binary XML structure.
    data = replace(data, previous, current.ljust(len(previous), b"\0"))
    return replace(data, struct.pack("<I", 26110781), struct.pack("<I", 26110782))


def resource_table(base, apktool, aapt2, work):
    decoded = work / "resources"
    framework = work / "framework"
    framework.mkdir()
    run("java", "-jar", apktool, "d", "-s", "-p", framework, "-o", decoded, base)
    strings = decoded / "res/values/strings.xml"
    data = strings.read_text(encoding="utf-8")
    strings.write_text(replace(data, "CoPilot 本機通道", "Carrot Bridge 本機通道", 3), encoding="utf-8")
    linked = work / "linked.apk"
    run("java", "-jar", apktool, "b", "-p", framework, "-o", linked, decoded)

    def resource_dump(apk):
        return run(aapt2, "dump", "resources", apk, capture_output=True, text=True).stdout

    old_dump = resource_dump(base)
    new_dump = resource_dump(linked)
    ids = r"(?m)^\s*resource (0x[\da-f]+) ([\w./:$-]+)"
    if set(re.findall(ids, old_dump)) != set(re.findall(ids, new_dump)):
        raise ValueError("Resource IDs changed when linking the new text")
    with ZipFile(linked) as apk:
        return apk.read("resources.arsc")


def build(base, tools, apktool, output, work):
    sdk = tools / "android-15"
    android = tools / "android.jar"
    dalvik = ("java", "-cp", apktool, HERE.parent / "wide69/Dalvik.java")
    dex_parts = {"classes.dex": work / "primary", "classes8.dex": work / "extras"}
    with ZipFile(base) as apk:
        manifest = manifest_version(apk.read("AndroidManifest.xml"))
        for name, directory in dex_parts.items():
            path = work / name
            path.write_bytes(apk.read(name))
            run(*dalvik, "decode", path, directory)
    apply(*(directory / PACKAGE for directory in dex_parts.values()))

    d8 = work / "d8"
    d8.mkdir()
    stubs, classes = (work / folder for folder in ("stubs", "classes"))
    javac = ("java", "-m", "jdk.compiler/com.sun.tools.javac.Main", "-source", "17", "-target", "17",
             "-Xlint:-options", "-encoding", "UTF-8")
    run(*javac, "-cp", android, "-d", stubs, HERE / "stubs/ProjectionApi.java")
    run(*javac, "-cp", f"{android}:{stubs}", "-d", classes, HERE / "src/WideProjectionStatus.java")
    run("java", "-cp", sdk / "lib/d8.jar", "com.android.tools.r8.D8", "--min-api", "31",
        "--lib", android, "--classpath", stubs, "--output", d8, *sorted(classes.rglob("*.class")))
    run(*dalvik, "decode", d8 / "classes.dex", dex_parts["classes8.dex"])

    changes = {"AndroidManifest.xml": manifest, "resources.arsc": resource_table(base, apktool, sdk / "aapt2", work)}
    for name, directory in dex_parts.items():
        path = work / ("patched-" + name)
        run(*dalvik, "assemble", directory, path)
        changes[name] = path.read_bytes()

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
        if changed != CHANGED:
            raise ValueError(f"Unexpected differences in APK entries: {changed ^ CHANGED}")
    with output.open("xb") as handle:
        handle.write(aligned.read_bytes())


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ("base", "tools", "apktool", "output"):
        parser.add_argument(name, type=Path)
    args = parser.parse_args()
    with args.base.open("rb") as source:
        if file_digest(source, "sha256").hexdigest() != BASE_SHA256:
            parser.error("Use the exact signed wide.69 release APK")
    if args.output.exists():
        parser.error("Choose a new output filename")
    with tempfile.TemporaryDirectory(prefix="bridge-wide70-build-") as directory:
        build(args.base.resolve(), args.tools.resolve(), args.apktool.resolve(), args.output.resolve(), Path(directory))
