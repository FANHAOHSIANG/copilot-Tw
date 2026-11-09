from pathlib import Path
import re
import shutil

LABEL = "Copilot tw"
SMALI = "smali/com/navipilot/obf"
CLASS_PREFIXES = ()
VERSION_CODE = "26110735"
def version_name(_):
    return "9.3.1-wide.23-taiwan-icon"
def applies(filename, prefixes):
    return False
def background(text):
    assert text.count("#a9d8fa") == 1
    return text.replace("#a9d8fa", "#091121")
HOOKS = {"res/drawable/ic_launcher_background.xml": background}

if __name__ == "__main__":
    stage = Path("build/taiwan")
    target = stage / "patched"
    shutil.copytree(stage / "baseline", target)
    shutil.copyfile("icon.png", target / "res/drawable-nodpi/ic_launcher_playstore.png")
    for name, edit in HOOKS.items():
        path = target / name
        path.write_text(edit(path.read_text()))
    metadata = target / "apktool.yml"
    value = re.sub(r"(?m)^(\s*versionCode:\s*)\S+", rf"\g<1>{VERSION_CODE}", metadata.read_text())
    metadata.write_text(re.sub(r"(?m)^(\s*versionName:\s*)[^\n]+", rf"\g<1>{version_name(None)}", value))
