#!/usr/bin/env python3
"""Add one diagnostic-export hook and update only the recorder's build label."""
from pathlib import Path
import sys

root = Path(sys.argv[1]) / "smali/com/navipilot/obf"
path = root / "WideBridgeLog.smali"
text = path.read_text()
anchor = "    invoke-static {}, Lcom/navipilot/obf/WideTelemetry;->report()Ljava/lang/String;\n\n    move-result-object v1"
addition = "\n\n    invoke-static {v1}, Lcom/navipilot/obf/WideAmapLinkIntegration;->extendReport(Ljava/lang/String;)Ljava/lang/String;\n\n    move-result-object v1"
if text.count(anchor) != 1 or "->extendReport(" in text:
    raise SystemExit("Unexpected recorder export hook")
path.write_text(text.replace(anchor, anchor + addition))
path = root / "WideBridgeLog$1.smali"
text = path.read_text()
if text.count("wide.16") != 1:
    raise SystemExit("Unexpected recorder start label")
path.write_text(text.replace("wide.16", "wide.47"))
print("Added one export hook; corrected recorder build label")
