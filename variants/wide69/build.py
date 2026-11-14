"""Build the unsigned wide.69 APK from the released wide.68 APK."""
import argparse
from hashlib import file_digest
from pathlib import Path
import re
import runpy
import struct
import subprocess
import tempfile
import urllib.request
from zipfile import ZIP_STORED, ZipFile

from patch_google_noo_design import FILES, apply as patch_design
from patch_google_noo_exit import apply as patch_exit
from patch_projection import apply as patch_projection, replace_once

HERE = Path(__file__).resolve().parent
BASE = "54c270b96d33f3eae56357480d4c25faed9e531bf8854fe142d6241a7e4c0f2c"
OCR_AAR = "https://jitpack.io/cz/adaptech/tesseract4android/tesseract4android/4.9.0/tesseract4android-4.9.0.aar"
OCR_AAR_SHA = "bce5d6413a1a5ae3d7240033fbbc851ba3217d0a08d9769400e17a077f42cb2a"
OCR_MODEL = ("https://raw.githubusercontent.com/tesseract-ocr/tessdata_fast/"
             "65727574dfcd264acbb0c3e07860e4e9e9b22185/chi_tra.traineddata")
OCR_MODEL_SHA = "529c5b5797d64b126065cd55f2bb4c7fd7b15790798091b1ff259941a829330b"
CHANGED_RES = {"res/" + name for name in FILES} | {"resources.arsc"}


def run(*args, **kwargs):
    return subprocess.run([str(arg) for arg in args], check=True, **kwargs)


def digest(path):
    with path.open("rb") as handle:
        return file_digest(handle, "sha256").hexdigest()


def dependency(cache, name, url, expected):
    path = cache / name
    if not path.is_file():
        with urllib.request.urlopen(url, timeout=45) as response:
            data = response.read()
        path.write_bytes(data)
    if digest(path) != expected:
        raise ValueError(f"Dependency checksum does not match: {name}")
    return path


def resource_ids(aapt2, apk):
    output = run(aapt2, "dump", "resources", apk, capture_output=True, text=True).stdout
    return set(re.findall(r"(?m)^\s*resource (0x[\da-f]+) ([\w./:$-]+)", output))


def build(base, tool_dir, apktool, out, work):
    sdk = tool_dir / "android-15"
    android = tool_dir / "android.jar"
    model = dependency(tool_dir, "chi_tra.traineddata", OCR_MODEL, OCR_MODEL_SHA)
    aar = dependency(tool_dir, "tesseract.aar", OCR_AAR, OCR_AAR_SHA)

    decoded = work / "decoded"
    frame = work / "framework"
    frame.mkdir()
    run("java", "-jar", apktool, "d", "-s", "-p", frame, "-o", decoded, base)
    dalvik = ("java", "-cp", apktool, HERE / "Dalvik.java")
    parts = {"classes.dex": "smali", "classes5.dex": "smali_classes5"}
    with ZipFile(base) as original:
        for dex, directory in parts.items():
            path = work / dex
            path.write_bytes(original.read(dex))
            run(*dalvik, "decode", path, decoded / directory)
    patch_design(decoded)
    patch_exit(decoded)
    patch_projection(decoded)
    official = HERE.parent / "official-road-limits" / "patch.py"
    runpy.run_path(str(official))["apply"](decoded / "smali")

    replacement_dex = {}
    for dex, directory in parts.items():
        path = work / ("patched-" + dex)
        run(*dalvik, "assemble", decoded / directory, path)
        replacement_dex[dex] = path.read_bytes()
        # Apktool links resources independently of these two assembled DEX files.
        (decoded / directory).rename(work / directory)

    built_res = work / "resources.apk"
    run("java", "-jar", apktool, "b", "-p", frame, "-o", built_res, decoded)
    ids = resource_ids(sdk / "aapt2", base)
    if len(ids) < 1000 or ids != resource_ids(sdk / "aapt2", built_res):
        raise ValueError("Resource IDs changed while linking the new layouts")

    stubs, classes, d8_out = (work / name for name in ("stubs", "classes", "d8"))
    d8_out.mkdir()
    tesseract = work / "tesseract.jar"
    with ZipFile(aar) as package:
        tesseract.write_bytes(package.read("classes.jar"))
        libs = {"lib/" + p.removeprefix("jni/"): package.read(p)
                for p in package.namelist() if p.startswith("jni/") and p.endswith(".so")}
    javac = ("java", "-m", "jdk.compiler/com.sun.tools.javac.Main", "-source", "17", "-target", "17", "-Xlint:-options", "-encoding", "UTF-8")
    run(*javac, "-cp", android, "-d", stubs, HERE / "stubs/ProjectionApi.java")
    run(*javac, "-cp", f"{android}:{stubs}:{tesseract}", "-d", classes, *sorted((HERE / "src").glob("*.java")))
    run("java", "-cp", sdk / "lib/d8.jar", "com.android.tools.r8.D8", "--min-api", "31",
        "--lib", android, "--classpath", stubs, "--output", d8_out,
        tesseract, *sorted(classes.rglob("*.class")))

    unaligned = work / "unaligned.apk"
    with ZipFile(base) as original, ZipFile(built_res) as linked, ZipFile(unaligned, "w") as target:
        manifest = original.read("AndroidManifest.xml")
        manifest = replace_once(manifest, "9.3.1-wide.68-ui".encode("utf-16le"), "9.3.1-wide.69-ui".encode("utf-16le"))
        manifest = replace_once(manifest, struct.pack("<I", 26110780), struct.pack("<I", 26110781))
        changes = {**replacement_dex, "AndroidManifest.xml": manifest,
                   **{name: linked.read(name) for name in sorted(CHANGED_RES)}}
        additions = {"classes8.dex": (d8_out / "classes.dex").read_bytes(),
                     "assets/shield/chi_tra.traineddata": model.read_bytes(),
                     **{f"assets/shield/{name}": (HERE / name).read_bytes()
                        for name in ("OCR-NOTICE.txt", "OCR-LICENSE.txt")}, **libs}
        if additions.keys() & set(original.namelist()):
            raise ValueError("An OCR runtime entry would overwrite a base entry")
        for entry in original.infolist():
            name = entry.filename
            if not re.fullmatch(r"META-INF/(?:MANIFEST\.MF|[^/]+\.(?:SF|RSA|DSA|EC))", name, re.I):
                target.writestr(entry, changes[name] if name in changes else original.read(entry))
        for name, data in additions.items():
            target.writestr(name, data, compress_type=ZIP_STORED)

    aligned = work / "aligned.apk"
    run(sdk / "zipalign", "-P", "16", "-f", "4", unaligned, aligned)
    run(sdk / "zipalign", "-P", "16", "-c", "4", aligned)
    with ZipFile(base) as original, ZipFile(aligned) as target:
        if target.testzip() or set(target.namelist()) - set(original.namelist()) != additions.keys():
            raise ValueError("APK inventory or CRC check failed")
        changed = {p for p in target.namelist() if p in original.namelist() and target.read(p) != original.read(p)}
        if changed != changes.keys() or ids != resource_ids(sdk / "aapt2", aligned):
            raise ValueError("Unexpected APK payload differences")
    with out.open("xb") as target:
        target.write(aligned.read_bytes())


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ("base", "tools", "apktool", "output"):
        parser.add_argument(name, type=Path)
    args = parser.parse_args()
    if digest(args.base) != BASE:
        parser.error("Expected the exact released wide.68 APK")
    if args.output.exists():
        parser.error("Choose a new output filename")
    with tempfile.TemporaryDirectory(prefix="bridge-wide69-") as temp:
        build(args.base.resolve(), args.tools.resolve(), args.apktool.resolve(), args.output.resolve(), Path(temp))
