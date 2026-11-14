"""Build the wide.68 projection update from the exact official wide.67 APK."""
import argparse
import hashlib
from pathlib import Path
import runpy
import tempfile

from patch import apply, once

BASE_SHA256 = "8a777d24da1661e38a318d207583995d8a8e9f6ce653afb515134b80e221e17b"


def fix(tree):
    apply(tree)
    direct = tree / "com/navipilot/obf/WideDirect.smali"
    direct.write_text(once(direct.read_text(), "Carrot Bridge wide.67", "Carrot Bridge wide.68"))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ("base", "tools", "output"):
        parser.add_argument(name, type=Path)
    args = parser.parse_args()
    with args.base.open("rb") as source:
        if hashlib.file_digest(source, "sha256").hexdigest() != BASE_SHA256:
            parser.error("Expected the exact signed wide.67 APK")
    previous = Path(__file__).resolve().parents[1] / "wide67" / "build.py"
    build = runpy.run_path(str(previous))["build"]
    with tempfile.TemporaryDirectory(prefix="wide68-") as temp:
        build(args.base, args.tools, args.output, Path(temp), patch=fix,
              old_version=("9.3.1-wide.67-ui", 26110779),
              new_version=("9.3.1-wide.68-ui", 26110780))
