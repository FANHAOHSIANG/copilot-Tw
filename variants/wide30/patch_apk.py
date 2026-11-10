from pathlib import Path
import re
import shutil
import sys

SMALI = "smali/com/navipilot/obf"
CLASS_PREFIXES = ("WideLiveCameraFace", "WideCameraCard", "WideCameraPanel", "WideTaiwanHost", "WideSpeedHost")
VERSION_CODE = "26110742"
LABEL = "Copilot tw"


def version_name(_):
    return "9.3.1-wide.30-live-pane"


def applies(filename, prefixes=CLASS_PREFIXES):
    return any(filename == f"{prefix}.smali" or filename.startswith(prefix + "$") for prefix in prefixes)


SPEED_SLOT = SMALI + "/XN.smali"
VERSION_DIALOG = SMALI + "/Yg.smali"
SPEED_HOST_CALL = (
    "    invoke-static {v5, v4, v8}, Lcom/navipilot/obf/WideDirect;->shield"
    "(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;"
)
FILL_SPEED_HEIGHT = (
    "    invoke-static {v5}, Landroidx/compose/foundation/layout/c;->b"
    "(Lcom/navipilot/obf/VE;)Lcom/navipilot/obf/VE;\n\n"
    "    move-result-object v5\n\n"
)


def fill_speed_slot(source):
    # The Box centers its child and does not pass its minimum height. This modifier
    # fills the Box's bounded height as well as the width it already requests.
    assert source.count(SPEED_HOST_CALL) == 1, "unexpected speed panel entry point"
    return source.replace(SPEED_HOST_CALL, FILL_SPEED_HEIGHT + SPEED_HOST_CALL)


def update_version_dialog(source):
    original = 'const-string v42, "9.3.1 (26110712)"'
    assert source.count(original) == 1, "unexpected version dialog label"
    return source.replace(original, f'const-string v42, "{version_name(None)} ({VERSION_CODE})"')


HOOKS = {SPEED_SLOT: fill_speed_slot, VERSION_DIALOG: update_version_dialog}


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
