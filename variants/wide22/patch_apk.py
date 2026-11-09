from pathlib import Path
import re
import shutil
import sys

SMALI = "smali/com/navipilot/obf"
CLASS_PREFIXES = ("WideDirect", "WideVariant", "WideAmapSource", "WideAmapIme", "WideDisplayResize")
VERSION_CODE = "26110734"
LABEL = "Copilot tw"


def version_name(_):
    return "9.3.1-wide.22-google-maps"


def applies(filename, prefixes=CLASS_PREFIXES):
    return any(filename == f"{prefix}.smali" or filename.startswith(prefix + "$") for prefix in prefixes)


HOOKS = {}


def patch(root):
    build = root / "build/taiwan"
    target = build / "patched"
    assert not target.exists(), target
    shutil.copytree(build / "baseline", target)
    for path in (target / SMALI).glob("*.smali"):
        if applies(path.name):
            path.unlink()
    for path in (root / "build/helper" / SMALI).glob("*.smali"):
        if applies(path.name):
            shutil.copyfile(path, target / SMALI / path.name)
    for name, edit in HOOKS.items():
        path = target / name
        path.write_text(edit(path.read_text()))
    version = target / "apktool.yml"
    value = re.sub(r'(?m)^(\s*versionCode:\s*)\S+', rf'\g<1>{VERSION_CODE}', version.read_text())
    version.write_text(re.sub(r'(?m)^(\s*versionName:\s*)[^\n]+', rf'\g<1>{version_name(None)}', value))


if __name__ == "__main__":
    assert sys.argv[1] == "taiwan"
    patch(Path(__file__).resolve().parent)
