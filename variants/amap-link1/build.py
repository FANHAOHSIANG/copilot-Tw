#!/usr/bin/env python3
"""Compile the Link adapter and overlay a hash-verified existing CoPilot APK.

This is an APK modification project, not the original author's Gradle project.
Each invocation uses a new output directory. All external tools are explicit;
the script neither downloads dependencies nor reads a signing key from the repo.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import zipfile

HERE = Path(__file__).resolve().parent
VERSION = "9.3.1-wide.45-amap-link"
VERSION_CODE = 26110757


def sha256(path):
    digest = hashlib.sha256()
    with Path(path).open("rb") as source:
        for block in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def tool(value, name):
    if not value:
        raise SystemExit("Missing tool: " + name)
    path = Path(value).expanduser().resolve()
    if not path.is_file():
        raise SystemExit("Tool not found: " + name + " (" + str(path) + ")")
    return path


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--base-apk", required=True, type=Path)
    parser.add_argument("--output-dir", required=True, type=Path)
    parser.add_argument("--toolchain", type=Path, default=os.environ.get("COPILOT_TOOLCHAIN"),
                        help="Directory containing apktool.jar, ecj.jar, asm.jar, baksmali/, platform/android-35/")
    parser.add_argument("--build-tools", type=Path, default=os.environ.get("COPILOT_BUILD_TOOLS"))
    parser.add_argument("--unsigned", action="store_true", help="Produce explicitly unsigned aligned APK")
    args = parser.parse_args()
    root = args.toolchain.expanduser().resolve() if args.toolchain else None
    apktool = tool(os.environ.get("COPILOT_APKTOOL") or (root / "apktool.jar" if root else None), "apktool.jar")
    ecj = tool(os.environ.get("COPILOT_ECJ") or (root / "ecj.jar" if root else None), "ecj.jar")
    asm = tool(os.environ.get("COPILOT_ASM") or (root / "asm.jar" if root else None), "asm.jar")
    android = tool(os.environ.get("COPILOT_ANDROID_JAR") or
                   (root / "platform/android-35/android.jar" if root else None), "android.jar (API 35+)")
    baksmali = Path(os.environ.get("COPILOT_BAKSMALI_DIR") or
                    (root / "baksmali" if root else "missing-baksmali")).resolve()
    jars = sorted(baksmali.glob("*.jar"))
    if not jars:
        raise SystemExit("Missing baksmali/dexlib2 dependency JARs")
    bt = args.build_tools.expanduser().resolve() if args.build_tools else None
    if bt is None:
        raise SystemExit("Set --build-tools or COPILOT_BUILD_TOOLS")
    d8 = tool(bt / "lib/d8.jar", "D8")
    signer = tool(bt / "lib/apksigner.jar", "apksigner")
    zipalign = tool(bt / "zipalign", "zipalign")
    base = args.base_apk.expanduser().resolve()
    digest = sha256(base)
    supported = json.loads((HERE / "verification/bases.json").read_text())
    if digest not in supported:
        raise SystemExit("Unrecognized base APK SHA-256; refusing an unverified overlay: " + digest)
    base_info = supported[digest]
    work = args.output_dir.expanduser().resolve()
    work.mkdir(parents=True, exist_ok=False)
    logs = work / "logs"
    logs.mkdir()

    def run(label, command, *, capture=False, env=None):
        print(label, flush=True)
        result = subprocess.run([str(item) for item in command], text=True,
                                stdout=subprocess.PIPE, stderr=subprocess.STDOUT, env=env)
        # Signing output never includes argument/env dumps. Keep any private tool
        # diagnostics out of build artifacts if the signing command fails.
        if label != "Sign APK":
            (logs / (label.lower().replace(" ", "-") + ".txt")).write_text(result.stdout)
        if result.returncode:
            raise SystemExit(label + " failed; " + ("private diagnostics suppressed" if
                             label == "Sign APK" else "see " + str(logs)))
        return result.stdout if capture else None

    decoded = work / "decoded"
    run("Decode verified base", ["java", "-jar", apktool, "d", "-f", base, "-o", decoded])
    with zipfile.ZipFile(base) as source:
        (work / "base.dex").write_bytes(source.read("classes.dex"))
    api_classes = work / "api-classes"
    api_classes.mkdir()
    java_cp = os.pathsep.join(str(item) for item in [asm, *jars])
    run("Compile signature tool", ["java", "-jar", ecj, "-8", "-proc:none", "-cp", java_cp,
                                    "-d", api_classes, HERE / "tooling/ApiSignatures.java"])
    api = work / "base-api.jar"
    run("Extract compiler signatures", ["java", "-cp", str(api_classes) + os.pathsep + java_cp,
                                         "ApiSignatures", work / "base.dex", api])
    classes = work / "classes"
    classes.mkdir()
    sources = sorted((HERE / "src").glob("*.java"))
    if not sources:
        raise SystemExit("Missing Link implementation sources")
    source_hashes = {str(file.relative_to(HERE)): sha256(file) for file in sources}
    patcher_hash = sha256(HERE / "patch_decoded.py")
    run("Compile Link sources", ["java", "-jar", ecj, "-8", "-proc:none", "-nowarn",
                                  "-cp", str(android) + os.pathsep + str(api), "-d", classes, *sources])
    dex = work / "dex"
    dex.mkdir()
    run("Build Link dex", ["java", "-cp", d8, "com.android.tools.r8.D8", "--min-api", "31",
                            "--lib", android, "--classpath", api, "--output", dex,
                            *sorted(classes.rglob("*.class"))])
    generated = work / "generated-smali"
    run("Disassemble Link dex", ["java", "-cp", os.pathsep.join(map(str, jars)),
                                  "org.jf.baksmali.Main", "d", dex / "classes.dex", "-o", generated])
    destination = decoded / "smali/com/navipilot/obf"
    generated_files = list((generated / "com/navipilot/obf").glob("*.smali"))
    if not generated_files or any(not file.name.startswith("WideAmap") for file in generated_files):
        raise SystemExit("Unexpected compiled class scope")
    for file in generated_files:
        shutil.copyfile(file, destination / file.name)
    run("Apply lifecycle hooks", [sys.executable, HERE / "patch_decoded.py", decoded])
    config = decoded / "apktool.yml"
    old_config = config.read_text()
    new_config, count = re.subn(r"(?m)^(  versionCode:) .*", r"\g<1> " + str(VERSION_CODE), old_config)
    new_config, count_name = re.subn(r"(?m)^(  versionName:) .*", r"\g<1> " + VERSION, new_config)
    if count != 1 or count_name != 1:
        raise SystemExit("Unexpected APK version metadata")
    config.write_text(new_config)
    version_ui = destination / "Yg.smali"
    contents = version_ui.read_text()
    if base_info["version"] not in contents:
        raise SystemExit("Unexpected in-app version label")
    contents = contents.replace(base_info["version"], VERSION).replace(str(base_info["versionCode"]), str(VERSION_CODE))
    version_ui.write_text(contents)
    run("Build APK", ["java", "-jar", apktool, "b", decoded, "-o", work / "unsigned.apk"])
    aligned = work / ("Copilot-tw-" + VERSION + "-unsigned-aligned.apk")
    run("Align APK", [zipalign, "-P", "16", "-f", "4", work / "unsigned.apk", aligned])
    final = aligned
    certificate_match = None
    if not args.unsigned:
        signing_key = tool(os.environ.get("COPILOT_SIGNING_KEY"), "COPILOT_SIGNING_KEY")
        alias = os.environ.get("COPILOT_KEY_ALIAS")
        if not alias or not os.environ.get("COPILOT_STORE_PASSWORD"):
            raise SystemExit("Signing variables missing; use --unsigned if signing is not available")
        final = work / ("Copilot-tw-" + VERSION + ".apk")
        command = ["java", "-jar", signer, "sign", "--ks", signing_key, "--ks-key-alias", alias,
                   "--ks-pass", "env:COPILOT_STORE_PASSWORD"]
        if os.environ.get("COPILOT_KEY_PASSWORD"):
            command += ["--key-pass", "env:COPILOT_KEY_PASSWORD"]
        run("Sign APK", command + ["--out", final, aligned])
        original = run("Verify base signature", ["java", "-jar", signer, "verify", "--print-certs", base], capture=True)
        signed = run("Verify new signature", ["java", "-jar", signer, "verify", "--verbose", "--print-certs", final], capture=True)
        pattern = r"certificate SHA-256 digest: ([a-f0-9]+)"
        before, after = re.findall(pattern, original), re.findall(pattern, signed)
        certificate_match = bool(before) and before == after
        if not certificate_match:
            raise SystemExit("Signing certificate differs from base; this APK cannot cover-update it")
    run("Verify alignment", [zipalign, "-c", "-P", "16", "4", final])
    with zipfile.ZipFile(base) as old, zipfile.ZipFile(final) as new:
        protected = [name for name in old.namelist() if name.startswith(("assets/", "lib/")) and not name.endswith("/")]
        if any(old.read(name) != new.read(name) for name in protected):
            raise SystemExit("Unrelated assets/native libraries changed")
    if any(sha256(HERE / name) != digest for name, digest in source_hashes.items()) or \
            sha256(HERE / "patch_decoded.py") != patcher_hash:
        raise SystemExit("Sources changed during the build; rebuild from one consistent revision")
    result = {
        "version": VERSION, "versionCode": VERSION_CODE,
        "baseVersion": base_info["version"], "baseSha256": digest,
        "apk": final.name, "apkSha256": sha256(final), "apkBytes": final.stat().st_size,
        "sameSigningCertificate": certificate_match, "alignment16KiB": True,
        "unchangedAssetsAndLibraries": len(protected),
        "compiledClasses": sorted(file.name for file in generated_files),
        "sourceSha256": source_hashes, "patcherSha256": patcher_hash,
        "deviceTest": False, "amapAuthorizationVerifiedOnUserPhone": False,
        "c4ReceptionVerified": False
    }
    (work / "build-verification.json").write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n")
    print(str(final))
    print("SHA-256: " + result["apkSha256"])


if __name__ == "__main__":
    main()
