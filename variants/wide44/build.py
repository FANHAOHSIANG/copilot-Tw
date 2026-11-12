#!/usr/bin/env python3
"""Rebuild recovered wide44 sources on the pinned signed wide43 APK.

Produces an unsigned, aligned APK. Signing stays outside this repository.
This is an APK overlay project, not the original CoPilot Gradle project.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import zipfile

HERE = Path(__file__).resolve().parent
BASE_SHA256 = "0b86165f9b16236d1c744ab218c3ec26e36435774223c0cf14f448757d5fbcfc"
BASE_VERSION = "9.3.1-wide.43-offline-forward"
VERSION = "9.3.1-wide.44-google-bridge"
VERSION_CODE = 26110756
FAMILIES = ("WideCameraPanel", "WideDashboardFace", "WideDirect", "WideGoogleAdapter",
            "WideGoogleNav", "WideVariant", "WideVehiclePanel")
PATCHES = ("WideAmapSource.smali", "WideCameraCard.smali", "WideStatusBorder.smali")


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def belongs(name):
    return any(name == family + ".smali" or name.startswith(family + "$")
               or name.startswith(family + "-") for family in FAMILIES)


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--base-apk", type=Path, required=True)
    p.add_argument("--output-dir", type=Path, required=True)
    p.add_argument("--toolchain", type=Path, required=True,
                   help="apktool.jar, ecj.jar, asm.jar, baksmali/*.jar, platform/android-35/android.jar")
    p.add_argument("--build-tools", type=Path, required=True, help="Android SDK build-tools directory")
    p.add_argument("--retained-smali", action="store_true",
                   help="Use historical retained smali instead of compiling the seven Java sources")
    a = p.parse_args()
    base, root, bt = (x.expanduser().resolve() for x in (a.base_apk, a.toolchain, a.build_tools))
    if digest(base) != BASE_SHA256:
        raise SystemExit("Base APK does not match the pinned wide43 SHA-256")
    work = a.output_dir.expanduser().resolve()
    work.mkdir(parents=True, exist_ok=False)
    logs = work / "logs"
    logs.mkdir()

    def run(label, command):
        print(label, flush=True)
        result = subprocess.run([str(x) for x in command], stdout=subprocess.PIPE,
                                stderr=subprocess.STDOUT, text=True)
        (logs / (label.lower().replace(" ", "-") + ".txt")).write_text(result.stdout)
        if result.returncode:
            raise SystemExit(label + " failed; see " + str(logs))

    jars = sorted((root / "baksmali").glob("*.jar"))
    android = Path(os.environ.get("COPILOT_ANDROID_JAR", root / "platform/android-35/android.jar"))
    tools = [root / "apktool.jar", root / "ecj.jar", root / "asm.jar", android,
             bt / "lib/d8.jar", bt / "zipalign"]
    if not jars or any(not f.is_file() for f in tools):
        raise SystemExit("Incomplete explicit Android/Java toolchain")
    sources = sorted((HERE / "src").glob("*.java"))
    if {x.stem for x in sources} != set(FAMILIES):
        raise SystemExit("Unexpected recovered Java source scope")
    inputs = sources + sorted((HERE / "smali").glob("*.smali"))
    hashes = {str(x.relative_to(HERE)): digest(x) for x in inputs}
    decoded = work / "decoded"
    run("Decode pinned wide43", ["java", "-jar", root / "apktool.jar", "d", "-f", base, "-o", decoded])
    destination = decoded / "smali/com/navipilot/obf"
    if not destination.is_dir():
        raise SystemExit("Unexpected base package layout")

    if a.retained_smali:
        generated = HERE / "smali"
    else:
        # Extract compiler signatures from this exact base; the stub JAR is never packaged.
        with zipfile.ZipFile(base) as apk:
            (work / "base.dex").write_bytes(apk.read("classes.dex"))
        api_classes = work / "api-classes"
        api_classes.mkdir()
        compiler_cp = os.pathsep.join(str(x) for x in [root / "asm.jar", *jars])
        signature_source = HERE / "tooling/ApiSignatures44.java"
        if not signature_source.is_file():
            raise SystemExit("Missing repository shared compiler-signature tool: " + str(signature_source))
        run("Compile signature extractor", ["java", "-jar", root / "ecj.jar", "-8", "-proc:none",
             "-cp", compiler_cp, "-d", api_classes, signature_source])
        api = work / "base-api.jar"
        run("Extract exact base signatures", ["java", "-cp", str(api_classes) + os.pathsep + compiler_cp,
             "ApiSignatures44", work / "base.dex", api])
        classes = work / "classes"
        classes.mkdir()
        run("Compile seven recovered sources", ["java", "-jar", root / "ecj.jar", "-8", "-proc:none",
             "-nowarn", "-cp", str(android) + os.pathsep + str(api), "-d", classes, *sources])
        dex = work / "dex"
        dex.mkdir()
        run("Build recovered source dex", ["java", "-cp", bt / "lib/d8.jar", "com.android.tools.r8.D8",
             "--min-api", "31", "--lib", android, "--classpath", api, "--output", dex,
             *sorted(classes.rglob("*.class"))])
        generated_root = work / "generated-smali"
        run("Disassemble rebuilt classes", ["java", "-cp", os.pathsep.join(map(str, jars)),
             "org.jf.baksmali.Main", "d", dex / "classes.dex", "-o", generated_root])
        generated = generated_root / "com/navipilot/obf"
        if any(not belongs(x.name) for x in generated.glob("*.smali")):
            raise SystemExit("Compiled classes exceeded the expected seven source families")

    # Remove obsolete anonymous/lambda classes before replacing their owning source families.
    for old in destination.glob("*.smali"):
        if belongs(old.name):
            old.unlink()
    changed = []
    for smali in sorted(generated.glob("*.smali")):
        if belongs(smali.name):
            shutil.copyfile(smali, destination / smali.name)
            changed.append(smali.name)
    for name in PATCHES:
        shutil.copyfile(HERE / "smali" / name, destination / name)
        changed.append(name)
    for file in (decoded / "apktool.yml", destination / "Yg.smali"):
        old = file.read_text()
        if BASE_VERSION not in old or "26110755" not in old:
            raise SystemExit("Unexpected base version metadata")
        file.write_text(old.replace(BASE_VERSION, VERSION).replace("26110755", str(VERSION_CODE)))
    manifest = decoded / "AndroidManifest.xml"
    text = manifest.read_text()
    text = re.sub(r'\s*<package android:name="com.copilottw.googlenav"\s*/>', "", text)
    if "<queries>" in text:
        text = text.replace("<queries>", '<queries>\n        <package android:name="com.copilottw.googlenav" />', 1)
    else:
        text = text.replace("<application", '<queries><package android:name="com.copilottw.googlenav" /></queries>\n    <application', 1)
    manifest.write_text(text)
    unsigned = work / "unsigned.apk"
    output = work / ("Copilot-tw-" + VERSION + "-unsigned-aligned.apk")
    run("Assemble source rebuild", ["java", "-jar", root / "apktool.jar", "b", decoded, "-o", unsigned])
    run("Align unsigned APK", [bt / "zipalign", "-P", "16", "-f", "4", unsigned, output])
    run("Verify unsigned alignment", [bt / "zipalign", "-c", "-P", "16", "4", output])
    with zipfile.ZipFile(base) as old, zipfile.ZipFile(output) as new:
        protected = [n for n in old.namelist() if not n.endswith("/") and
                     (n.startswith(("assets/", "lib/")) or (re.fullmatch(r"classes\d+\.dex", n)))]
        if any(old.read(n) != new.read(n) for n in protected):
            raise SystemExit("Unrelated assets/native libraries/secondary DEX changed")
    if any(digest(HERE / name) != sha for name, sha in hashes.items()):
        raise SystemExit("Source changed while rebuilding; rerun against a stable revision")
    report = dict(version=VERSION, versionCode=VERSION_CODE, baseSha256=BASE_SHA256,
                  mode="retained-smali" if a.retained_smali else "recompiled-original-source",
                  apk=output.name, apkSha256=digest(output), unsigned=True,
                  alignment16KiB=True, protectedFilesUnchanged=len(protected),
                  overlaidClasses=changed, sourceSha256=hashes,
                  originalSignedArtifactByteIdentical=False, onDeviceVerified=False)
    (work / "build-verification.json").write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
    print(output)


if __name__ == "__main__":
    main()
