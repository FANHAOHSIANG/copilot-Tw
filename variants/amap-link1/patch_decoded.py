#!/usr/bin/env python3
"""Apply narrow Link hooks to a decoded wide42/43/44 base.

The original source gate, Auto decoder, Google paths, Taiwan merge and Navi v2
sender remain in place. New compiled WideAmapLink* classes are installed by the
build script, never by replacing WideDirect or WideVariant wholesale.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import re


INTEGRATION = "Lcom/navipilot/obf/WideAmapLinkIntegration;"
SOURCE = "Lcom/navipilot/obf/WideAmapSource;"


def _once(text: str, old: str, new: str, label: str) -> str:
    if text.count(old) != 1:
        raise ValueError(f"{label}: expected one anchor, found {text.count(old)}")
    return text.replace(old, new, 1)


def _method(text: str, signature: str, marker: str, transform) -> str:
    pattern = re.compile(r"(?ms)^\.method [^\n]*\n.*?^\.end method")
    found = [m for m in pattern.finditer(text)
             if m.group().splitlines()[0].endswith(" " + signature)]
    if len(found) != 1:
        raise ValueError(f"Expected one method {signature}, found {len(found)}")
    match = found[0]
    original = match.group()
    if marker in original:
        return text
    updated = transform(original)
    if marker not in updated:
        raise ValueError(f"Hook was not installed in {signature}")
    return text[:match.start()] + updated + text[match.end():]


def _entry(method: str, block: str) -> str:
    # These entry-hook methods have no method annotations. Assert rather than
    # placing executable instructions inside an unexpected annotation block.
    match = re.search(r"(?m)^    \.(?:locals|registers) \d+\s*$", method)
    if not match:
        raise ValueError("Method has no register declaration")
    tail = method[match.end():]
    if tail.lstrip().startswith(".annotation"):
        raise ValueError("Entry hook needs an explicit annotation-safe anchor")
    return method[:match.end()] + "\n\n" + block + "\n" + tail


def _file(decoded: Path, relative: str) -> Path:
    candidates = [p / relative for p in decoded.glob("smali*") if (p / relative).is_file()]
    if len(candidates) != 1:
        raise ValueError(f"Expected one decoded class {relative}, found {len(candidates)}")
    return candidates[0]


def patch(decoded: Path) -> dict[str, int]:
    decoded = Path(decoded).resolve()
    changes: dict[Path, str] = {}

    def read(relative: str) -> tuple[Path, str]:
        path = _file(decoded, relative)
        return path, path.read_text(encoding="utf-8")

    path, text = read("com/navipilot/obf/WideVariant.smali")
    text = _method(text, "prepare(Landroid/app/Activity;)V", "->prepare(Landroid/content/Context;)V",
        lambda m: _entry(m,
            "    # amap-link: application context before p0 is reused\n"
            f"    invoke-static/range {{p0 .. p0}}, {INTEGRATION}->prepare(Landroid/content/Context;)V"))
    changes[path] = text

    path, text = read("com/navipilot/obf/WideAmapSource.smali")
    text = _method(text, "matches(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z",
        ":amap_link_broadcast_legacy", lambda m: _entry(m,
            "    # amap-link: PHONE has a source-authenticated Binder input\n"
            '    const-string v0, "com.autonavi.minimap"\n'
            "    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z\n"
            "    move-result v0\n"
            "    if-eqz v0, :amap_link_broadcast_legacy\n"
            "    const/4 v0, 0x0\n"
            "    return v0\n"
            "    :amap_link_broadcast_legacy"))

    selected_anchor = f"    sput-object p0, {SOURCE}->selected:Ljava/lang/String;"
    text = _method(text, "select(Ljava/lang/String;)V", f"{INTEGRATION}->select(Ljava/lang/String;)V",
        lambda m: _once(m, selected_anchor, selected_anchor + "\n\n"
            "    # amap-link: invalidate old source instance before native withdrawals\n"
            f"    invoke-static/range {{p0 .. p0}}, {INTEGRATION}->select(Ljava/lang/String;)V",
            "source selection"))

    def source_filter(method: str) -> str:
        anchors = list(re.finditer(r"(?m)^    if-eqz p2, :\w+$", method))
        if len(anchors) != 1:
            raise ValueError("source filter: expected the original null-payload branch")
        anchor = anchors[0]
        block = (
            "    # amap-link: keep bridge registration and any preceding Google branch\n"
            f"    sget-object v0, {SOURCE}->selected:Ljava/lang/String;\n"
            '    const-string v1, "com.autonavi.minimap"\n'
            "    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z\n"
            "    move-result v0\n"
            "    if-eqz v0, :amap_link_filter_legacy\n"
            f"    invoke-static {{p0, p1, p2, p3}}, {INTEGRATION}->filter(Lcom/navipilot/obf/MG;Ljava/lang/String;Lorg/json/JSONObject;Ljava/util/Map;)Lorg/json/JSONObject;\n"
            "    move-result-object v0\n"
            "    return-object v0\n"
            "    :amap_link_filter_legacy\n\n"
        )
        return method[:anchor.start()] + block + method[anchor.start():]

    text = _method(text,
        "filter(Lcom/navipilot/obf/MG;Ljava/lang/String;Lorg/json/JSONObject;Ljava/util/Map;)Lorg/json/JSONObject;",
        ":amap_link_filter_legacy", source_filter)
    text = _method(text, "status()Ljava/lang/String;", ":amap_link_status_legacy",
        lambda m: _entry(m,
            f"    sget-object v0, {SOURCE}->selected:Ljava/lang/String;\n"
            f"    invoke-static {{v0}}, {INTEGRATION}->statusFor(Ljava/lang/String;)Ljava/lang/String;\n"
            "    move-result-object v0\n"
            "    if-eqz v0, :amap_link_status_legacy\n"
            "    return-object v0\n"
            "    :amap_link_status_legacy"))
    # Do not edit generation(), dispatch(), currentCamera(), Auto receipt checks or clearing.
    changes[path] = text

    path, text = read("com/navipilot/obf/MG.smali")

    def published(method: str) -> str:
        pattern = re.compile(
            r"(?m)^    invoke-virtual/range \{v0 \.\. v6\}, Lcom/navipilot/obf/XG;->r\(Ljava/lang/String;ZLorg/json/JSONObject;Ljava/lang/String;J\)Z"
            r"\s+move-result v0\s+if-eqz v0, :\w+")
        matches = list(pattern.finditer(method))
        if len(matches) != 1:
            raise ValueError("MG publication: expected one accepted final XG.r branch")
        match = matches[0]
        return method[:match.end()] + "\n\n" + (
            "    # amap-link: diagnostics only after the existing sender accepts this value\n"
            f"    invoke-static/range {{p0 .. p2}}, {INTEGRATION}->published(Lcom/navipilot/obf/MG;Ljava/lang/String;Lorg/json/JSONObject;)V\n"
        ) + method[match.end():]

    text = _method(text, "b(Ljava/lang/String;Lorg/json/JSONObject;Ljava/lang/String;)V",
        f"{INTEGRATION}->published(", published)
    changes[path] = text

    path, text = read("com/navipilot/obf/WideDirect$Pane.smali")
    marker = f"{INTEGRATION}->afterMapLaunch(Ljava/lang/String;)V"
    if marker not in text:
        pattern = re.compile(
            r"(?m)^    invoke-interface \{p1, p5, v3\}, Lcom/navipilot/obf/Mt;->e\(Ljava/lang/String;I\)Z"
            r"\s+move-result v2\s+if-eqz v2, :\w+")
        matches = list(pattern.finditer(text))
        if len(matches) != 1:
            raise ValueError("Projection launch: expected one successful package launch branch")
        match = matches[0]
        text = text[:match.end()] + "\n\n" + (
            "    # amap-link: retry only after the real package launch succeeded\n"
            f"    invoke-static/range {{p5 .. p5}}, {marker}\n"
        ) + text[match.end():]
    changes[path] = text

    path, text = read("com/jixiexiaoge/drivingassist/CarrotAmapForegroundService.smali")
    text = _method(text, "onStartCommand(Landroid/content/Intent;II)I",
        f"{INTEGRATION}->serviceCommand(", lambda m: _entry(m,
            f"    invoke-static/range {{p0 .. p1}}, {INTEGRATION}->serviceCommand(Landroid/content/Context;Landroid/content/Intent;)V"))
    text = _method(text, "onDestroy()V", f"{INTEGRATION}->serviceStopped()V",
        lambda m: _entry(m, f"    invoke-static {{}}, {INTEGRATION}->serviceStopped()V"))
    changes[path] = text

    # Explicit package visibility already exists in the supported bases. No new
    # exported component, service, permission, API key or application ID is added.
    manifest = (decoded / "AndroidManifest.xml").read_text(encoding="utf-8")
    if not re.search(r'<package\s+android:name="com\.autonavi\.minimap"\s*/>', manifest):
        raise ValueError("Expected the base manifest's existing AMap mobile package query")

    # Commit modifications only once all expected hook sites have been verified.
    result: dict[str, int] = {}
    for path, updated in changes.items():
        original = path.read_text(encoding="utf-8")
        if original != updated:
            path.write_text(updated, encoding="utf-8")
        result[str(path.relative_to(decoded))] = updated.count(INTEGRATION)
    return result


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("decoded", type=Path)
    arguments = parser.parse_args()
    print(json.dumps(patch(arguments.decoded), ensure_ascii=False, indent=2))
