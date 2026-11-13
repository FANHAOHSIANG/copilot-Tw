"""Apply the OSM road-limit filter to the disassembled wide.60 main DEX."""
import argparse
from pathlib import Path
import re

HERE = Path(__file__).resolve().parent
PACKAGE = "com/navipilot/obf"
SIGNATURE = "b(Ljava/lang/String;Lorg/json/JSONObject;Ljava/lang/String;)V"
HOOK = "    move-object/16 p2, v9\n"
FILTER = (
    "    invoke-static {v8, v9, v1}, "
    "Lcom/navipilot/obf/WideOsmLimit;->filter"
    "(Ljava/lang/String;Lorg/json/JSONObject;Ljava/util/Map;)Lorg/json/JSONObject;\n"
    "    move-result-object v9\n"
)

def apply(root):
    package = root / PACKAGE
    sender = package / "MG.smali"
    diagnostics = package / "WideDirect.smali"
    helper = package / "WideOsmLimit.smali"
    source = sender.read_text()
    start = source.index(".method public final " + SIGNATURE)
    end = source.index(".end method", start)
    method = source[start:end]
    join = re.search(r"(?m)^    :(cond_[0-9a-f]+)\n" + re.escape(HOOK), method)
    if (helper.exists() or method.count(HOOK) != 1
            or not join or f"    if-nez v2, :{join[1]}\n" not in method[:join.start()]
            or "WideAmapPreAdjust;->merge" not in method
            or "WideLinkDelivery;->route" not in method):
        raise ValueError("Expected the wide.60 Navi v2 sender")
    report_source = diagnostics.read_text()
    report_start = report_source.index(".method public static report()Ljava/lang/String;")
    report_end = report_source.index(".end method", report_start)
    report = report_source[report_start:report_end]
    report_hook = "    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;\n"
    if report.count(report_hook) != 1:
        raise ValueError("Expected one live diagnostic report builder")
    report = report.replace(report_hook,
        "    invoke-static {}, Lcom/navipilot/obf/WideOsmLimit;->status()Ljava/lang/String;\n"
        "    move-result-object v1\n"
        "    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;\n"
        + report_hook)
    # v1 is the stream timestamp map for every source at the join point.
    sender.write_text(source[:start] + method.replace(HOOK, FILTER + HOOK) + source[end:])
    helper.write_text((HERE / helper.name).read_text())
    diagnostics.write_text(report_source[:report_start] + report + report_source[report_end:])

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("main_smali", type=Path)
    apply(parser.parse_args().main_smali)
