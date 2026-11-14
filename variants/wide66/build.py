"""Rebuild wide.65 with the settings and projection resize changes."""
import argparse
from copy import copy
import hashlib
from pathlib import Path
import re
import struct
import subprocess
import tempfile
import zipfile

BASE_SHA256 = "9e00213e5526c04a238dbb385ea920dfe5adff8a5afbef5e1bd779f9e4a42b42"


def replace_once(data, old, new):
    if data.count(old) != 1:
        raise ValueError(f"Expected one occurrence: {old!r}")
    return data.replace(old, new, 1)


def run(*args):
    subprocess.run([str(arg) for arg in args], check=True)


def fix(tree):
    from patch import apply
    apply(tree)
    direct = tree / "com/navipilot/obf/WideDirect.smali"
    direct.write_text(replace_once(direct.read_text(), "Carrot Bridge wide.65", "Carrot Bridge wide.66"))


def build(base, tools, output, work):
    dex = work / "classes.dex"
    tree = work / "smali"
    patched = work / "patched.dex"
    unaligned = work / "unaligned.apk"
    aligned = work / "aligned.apk"
    cp = tools / "deps/*"
    with zipfile.ZipFile(base) as source:
        dex.write_bytes(source.read("classes.dex"))
        run("java", "-cp", cp, "org.jf.baksmali.Main", "d", dex, "-o", tree)
        fix(tree)
        run("java", "-cp", cp, "org.jf.smali.Main", "a", "--api", "31", tree, "-o", patched)
        manifest = source.read("AndroidManifest.xml")
        manifest = replace_once(manifest, "9.3.1-wide.65-ui".encode("utf-16le"), "9.3.1-wide.66-ui".encode("utf-16le"))
        manifest = replace_once(manifest, struct.pack("<I", 26110777), struct.pack("<I", 26110778))
        replacements = {"classes.dex": patched.read_bytes(), "AndroidManifest.xml": manifest}
        names = [name for name in source.namelist()
                 if not re.fullmatch(r"META-INF/(?:MANIFEST\.MF|[^/]+\.(?:SF|RSA|DSA|EC))", name, re.I)]
        with zipfile.ZipFile(unaligned, "w") as target:
            for name in names:
                target.writestr(copy(source.getinfo(name)), replacements[name] if name in replacements else source.read(name))
        run(tools / "android-15/zipalign", "-P", "16", "-f", "4", unaligned, aligned)
        run(tools / "android-15/zipalign", "-P", "16", "-c", "4", aligned)
        with zipfile.ZipFile(aligned) as target:
            if target.namelist() != names or target.testzip():
                raise ValueError("Invalid APK entries")
            if {name for name in names if source.read(name) != target.read(name)} != replacements.keys():
                raise ValueError("Unexpected payload changes")
    with output.open("xb") as target:
        target.write(aligned.read_bytes())


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ("base", "tools", "output"):
        parser.add_argument(name, type=Path)
    args = parser.parse_args()
    with args.base.open("rb") as source:
        if hashlib.file_digest(source, "sha256").hexdigest() != BASE_SHA256:
            parser.error("Expected the exact signed wide.65 APK")
    with tempfile.TemporaryDirectory(prefix="wide66-") as temp:
        build(args.base, args.tools, args.output, Path(temp))
