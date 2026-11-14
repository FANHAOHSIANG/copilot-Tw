"""Exercise the APK's actual matcher and speed publisher with stubbed Android inputs."""
import argparse
import os
from pathlib import Path
import shutil
import sys
import tempfile
from zipfile import ZipFile

from build import HERE, run

PACKAGE = Path("com/navipilot/obf")
CLASS_NAMES = ("WideAmapPreAdjust", "WideOsmLimit", "WideHcopRoad", "WideRoad", "WideCameraEngine")


def check(apk, apktool, enjarify, json_jar, temp):
    dalvik = ("java", "-cp", apktool, HERE / "Dalvik.java")
    original = temp / "classes.dex"
    with ZipFile(apk) as source:
        original.write_bytes(source.read("classes.dex"))
    decoded = temp / "decoded"
    run(*dalvik, "decode", original, decoded)
    subset = temp / "subset" / PACKAGE
    subset.mkdir(parents=True)
    for name in CLASS_NAMES:
        shutil.copyfile(decoded / PACKAGE / (name + ".smali"), subset / (name + ".smali"))
        for nested in (decoded / PACKAGE).glob(name + "$*.smali"):
            shutil.copyfile(nested, subset / nested.name)
    dex = temp / "road.dex"
    run(*dalvik, "assemble", temp / "subset", dex)
    jar = temp / "road.jar"
    run(sys.executable, "-m", "enjarify.main", dex, "-o", jar, env={**os.environ, "PYTHONPATH": str(enjarify)})
    cp = os.pathsep.join(map(str, (jar, json_jar)))
    tests = temp / "tests"
    run("java", "-m", "jdk.compiler/com.sun.tools.javac.Main", "-cp", cp, "-d", tests,
        *sorted((HERE / "tests").glob("*.java")))
    run("java", "-cp", os.pathsep.join((str(tests), cp)), "com.navipilot.obf.RoadOutputChecks")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ("apk", "apktool", "enjarify", "json_jar"):
        parser.add_argument(name, type=Path)
    args = parser.parse_args()
    with tempfile.TemporaryDirectory(prefix="wide69-check-") as temp:
        check(args.apk.resolve(), args.apktool.resolve(), args.enjarify.resolve(), args.json_jar.resolve(), Path(temp))
