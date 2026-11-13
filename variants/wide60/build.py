"""Apply the AMap refresh fix to the exact wide59 unsigned APK."""
import argparse
import hashlib
from pathlib import Path
import shutil
import struct
import subprocess
import tempfile
import zipfile


HERE = Path(__file__).resolve().parent
BASE_SHA256 = "f2e3332da2714f48b4995a5fe1e23aa86cc612eb8402705e97b6c2205906890f"


def run(*args, cwd=None):
    subprocess.run([str(arg) for arg in args], cwd=cwd, check=True)


def replace_once(data, old, new):
    if data.count(old) != 1:
        raise ValueError(f"Expected exactly one {old!r}")
    return data.replace(old, new, 1)


def build(base, tools, output, work):
    build_tools = tools / "android-15"
    classpath = str(tools / "deps" / "*")
    variant = work / "variants/wide56"
    shutil.copytree(HERE.parent / "wide56", variant)
    run("git", "apply", HERE / "route-refresh.patch", cwd=work)
    compiled = work / "compiled"
    run("java", "-jar", tools / "ecj.jar", "-8", "-proc:none", "-encoding", "UTF-8",
        "-cp", tools / "json.jar", "-d", compiled,
        *sorted((variant / "src").glob("*.java")), variant / "tests/RouteChecks.java")
    run("java", "-cp", f"{compiled}:{tools / 'json.jar'}", "com.navipilot.obf.RouteChecks")

    helper_dex = work / "helper"
    helper_dex.mkdir()
    run("java", "-cp", build_tools / "lib/d8.jar", "com.android.tools.r8.D8", "--min-api", "31",
        "--no-desugaring", "--output", helper_dex, *sorted(compiled.rglob("WideAmapLink*.class")))
    helper_smali = work / "helper-smali"
    run("java", "-cp", classpath, "org.jf.baksmali.Main", "disassemble",
        helper_dex / "classes.dex", "-o", helper_smali)

    base_dex = work / "base.dex"
    with zipfile.ZipFile(base) as source:
        base_dex.write_bytes(source.read("classes.dex"))
    smali = work / "smali"
    run("java", "-cp", classpath, "org.jf.baksmali.Main", "disassemble", base_dex, "-o", smali)
    for item in helper_smali.rglob("*.smali"):
        shutil.copyfile(item, smali / item.relative_to(helper_smali))
    direct = smali / "com/navipilot/obf/WideDirect.smali"
    direct.write_text(replace_once(direct.read_text(), "Carrot Bridge wide.59", "Carrot Bridge wide.60"))

    dex = work / "classes.dex"
    run("java", "-cp", classpath, "org.jf.smali.Main", "assemble", "--api", "31", smali, "-o", dex)
    dex_bytes = dex.read_bytes()
    if not dex_bytes.startswith(b"dex\n039\0"):
        raise ValueError("Unexpected DEX version")
    unaligned = work / "unaligned.apk"
    with zipfile.ZipFile(base) as source, zipfile.ZipFile(unaligned, "w") as target:
        manifest = replace_once(source.read("AndroidManifest.xml"),
            "9.3.1-wide.59-ui".encode("utf-16le"), "9.3.1-wide.60-ui".encode("utf-16le"))
        manifest = replace_once(manifest, struct.pack("<I", 26110771), struct.pack("<I", 26110772))
        replacements = {"classes.dex": dex_bytes, "AndroidManifest.xml": manifest}
        for entry in source.infolist():
            name = entry.filename
            target.writestr(entry, replacements[name] if name in replacements else source.read(name))
    align = build_tools / "zipalign"
    run(align, "-P", "16", "-f", "4", unaligned, output)
    run(align, "-c", "-P", "16", "4", output)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for field in ("base", "tools", "output"):
        parser.add_argument(field, type=Path)
    args = parser.parse_args()
    with args.base.open("rb") as source:
        if hashlib.file_digest(source, "sha256").hexdigest() != BASE_SHA256:
            parser.error("Expected the exact wide59 unsigned APK")
    if args.output.exists() or "UNSIGNED" not in args.output.name:
        parser.error("Use a new output filename containing UNSIGNED")
    with tempfile.TemporaryDirectory(prefix="wide60-") as work:
        build(args.base.resolve(), args.tools.resolve(), args.output.resolve(), Path(work))


if __name__ == "__main__":
    main()
