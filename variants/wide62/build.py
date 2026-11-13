"""Rebuild the exact wide.60 unsigned base with the wide.64 OSM overlay."""
import argparse
import hashlib
from pathlib import Path
import struct
import tempfile
import zipfile

import patch
import patch_badge
import patch_location
import osm_assets
from patch_badge import run

BASE_SHA256 = "db816a40e8a7df1a673f31b79359e8785107ef6c71b702beed1a96d0cd29755f"


def replace_once(data, old, new):
    if data.count(old) != 1:
        raise ValueError(f"Expected exactly one occurrence of {old!r}")
    return data.replace(old, new, 1)


def build(base, tools, output, work, osm_archive):
    classpath = tools / "deps/*"
    patches = {}
    with zipfile.ZipFile(base) as source:
        for name in ("classes.dex", "classes5.dex"):
            original = work / name
            original.write_bytes(source.read(name))
            tree = work / original.stem
            run("java", "-cp", classpath, "org.jf.baksmali.Main", "d", original, "-o", tree)
            patches[name] = tree

        main, google = patches.values()
        patch.apply(main)
        badge_work = work / "badge"
        badge_work.mkdir()
        patch_badge.apply(main, google, tools, badge_work)
        diagnostics = main / patch.PACKAGE / "WideDirect.smali"
        diagnostics.write_text(replace_once(diagnostics.read_text(),
            "Carrot Bridge wide.60", "Carrot Bridge wide.64"))

        replacements = {}
        for name, tree in patches.items():
            dex = work / ("updated-" + name)
            run("java", "-cp", classpath, "org.jf.smali.Main", "assemble",
                "--api", "31", tree, "-o", dex)
            replacements[name] = dex.read_bytes()
            if not replacements[name].startswith(b"dex\n039\0"):
                raise ValueError(f"Unexpected DEX format for {name}")

        decoded = work / "manifest"
        rebuilt = work / "manifest.apk"
        run("java", "-jar", tools / "apktool.jar", "d", "-s", base, "-o", decoded)
        patch_location.add_service(decoded / "AndroidManifest.xml")
        run("java", "-jar", tools / "apktool.jar", "b", decoded, "-o", rebuilt)
        with zipfile.ZipFile(rebuilt) as manifest_apk:
            manifest = manifest_apk.read("AndroidManifest.xml")
        manifest = replace_once(manifest, "9.3.1-wide.60-ui".encode("utf-16le"),
                                "9.3.1-wide.64-ui".encode("utf-16le"))
        replacements["AndroidManifest.xml"] = replace_once(
            manifest, struct.pack("<I", 26110772), struct.pack("<I", 26110776))
        unaligned = work / "unaligned.apk"
        with zipfile.ZipFile(unaligned, "w") as target:
            for entry in source.infolist():
                name = entry.filename
                target.writestr(entry, replacements[name] if name in replacements else source.read(name))
            asset_count = osm_assets.install(osm_archive, target)

    align = tools / "android-15/zipalign"
    aligned = work / "aligned.apk"
    run(align, "-P", "16", "-f", "4", unaligned, aligned)
    run(align, "-c", "-P", "16", "4", aligned)
    with zipfile.ZipFile(base) as source, zipfile.ZipFile(aligned) as rebuilt:
        if source.namelist() != rebuilt.namelist()[:-asset_count] or rebuilt.testzip():
            raise ValueError("APK ZIP entries failed verification")
        changed = {name for name in source.namelist() if source.read(name) != rebuilt.read(name)}
        if changed != replacements.keys():
            raise ValueError(f"Unexpected changed APK entries: {changed}")
    with output.open("xb") as handle:
        handle.write(aligned.read_bytes())


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ("base", "tools", "output", "osm_archive"):
        parser.add_argument(name, type=Path)
    args = parser.parse_args()
    with args.base.open("rb") as handle:
        if hashlib.file_digest(handle, "sha256").hexdigest() != BASE_SHA256:
            parser.error("Expected the exact wide.60 unsigned APK")
    if args.output.exists() or "UNSIGNED" not in args.output.name:
        parser.error("Use a new output filename containing UNSIGNED")
    with tempfile.TemporaryDirectory(prefix="wide62-") as directory:
        build(args.base, args.tools, args.output, Path(directory), args.osm_archive)


if __name__ == "__main__":
    main()
