#!/usr/bin/env python3
"""Exact hooks into wide.45; the existing GPS, camera, Google and AMap flows stay in place."""
import argparse
import importlib.util
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location("link_patcher", HERE.parent / "amap-link1/patch_decoded.py")
legacy = importlib.util.module_from_spec(spec)
spec.loader.exec_module(legacy)
RUNTIME = "Lcom/navipilot/obf/WideEnforcementRuntime;"

def patch(decoded):
    decoded = Path(decoded).resolve()
    changes = {}
    path = legacy._file(decoded, "com/navipilot/obf/WideCamera.smali")
    text = path.read_text()
    text = legacy._method(text, "init(Landroid/content/Context;)V", RUNTIME + "->init(",
        lambda m: legacy._entry(m, "    invoke-static/range {p0 .. p0}, " + RUNTIME + "->init(Landroid/content/Context;)V"))
    text = legacy._method(text, "clearFix()V", RUNTIME + "->clear()V",
        lambda m: legacy._entry(m, "    invoke-static {}, " + RUNTIME + "->clear()V"))
    anchor = "    invoke-static {v0}, Lcom/navipilot/obf/WideBridge;->accept(Lcom/navipilot/obf/WideCameraEngine$Fix;)V"
    text = legacy._method(text, "accept(Landroid/location/Location;)V", RUNTIME + "->onFix(",
        lambda m: legacy._once(m, anchor, anchor + "\n\n    invoke-static {v0}, " + RUNTIME
            + "->onFix(Lcom/navipilot/obf/WideCameraEngine$Fix;)V", "accepted GPS fix"))
    changes[path] = text
    path = legacy._file(decoded, "com/navipilot/obf/WideCameraTrace.smali")
    text = path.read_text()
    anchor = "    sput-object p3, Lcom/navipilot/obf/WideCameraTrace;->published:Lcom/navipilot/obf/WideCameraTrace$Frame;"
    text = legacy._method(text,
        "update(Lcom/navipilot/obf/WideHcopRoad$Data;Lcom/navipilot/obf/WideCameraEngine$Fix;J)V",
        RUNTIME + "->onRoadUpdate(", lambda m: legacy._once(m, anchor, anchor
            + "\n\n    invoke-static {p0, p1, p2}, " + RUNTIME
            + "->onRoadUpdate(Lcom/navipilot/obf/WideHcopRoad$Data;Lcom/navipilot/obf/WideCameraEngine$Fix;Lcom/navipilot/obf/WideHcopRoad$Decision;)V",
            "prepared road-trace result"))
    changes[path] = text
    path = legacy._file(decoded, "com/navipilot/obf/WideCameraVoice.smali")
    text = path.read_text()
    anchor = "    invoke-virtual {p2}, Landroid/media/MediaPlayer;->start()V"
    text = legacy._method(text, "lambda$1(Landroid/content/Context;ZLandroid/media/MediaPlayer;)V",
        RUNTIME + "->cameraVoiceStarted()V", lambda m: legacy._once(m, anchor, anchor
            + "\n\n    invoke-static {}, " + RUNTIME + "->cameraVoiceStarted()V", "camera playback priority"))
    changes[path] = text
    manifest = decoded / "AndroidManifest.xml"
    xml = manifest.read_text()
    if "android.intent.action.TTS_SERVICE" not in xml:
        xml = legacy._once(xml, "</queries>", '    <intent><action android:name="android.intent.action.TTS_SERVICE" /></intent>\n    </queries>', "TTS package visibility")
    changes[manifest] = xml
    for path, text in changes.items():
        path.write_text(text)
    return {str(p.relative_to(decoded)): 1 for p in changes}

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("decoded", type=Path)
    args = parser.parse_args()
    print(json.dumps(patch(args.decoded), indent=2))
