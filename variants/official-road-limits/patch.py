"""Use confirmed TDX road limits in the wide.68 C4 speed publisher."""
import argparse
from pathlib import Path

HELPER = Path(__file__).with_name("outbound_value.smali")
OWNER = "Lcom/navipilot/obf/WideOsmLimit;"
DECISION = "Lcom/navipilot/obf/WideHcopRoad$Decision;"


def replace_once(source, old, new):
    if source.count(old) != 1:
        raise ValueError(f"Expected one occurrence of {old!r}")
    return source.replace(old, new, 1)


def apply(tree):
    path = tree / "com/navipilot/obf/WideOsmLimit.smali"
    source = path.read_text()
    start = source.index(".method public static filter(")
    end = source.index(".end method", start)
    filter_body = replace_once(
        source[start:end],
        f"invoke-static {{v2}}, {OWNER}->value({DECISION})I",
        f"invoke-static {{v2}}, {OWNER}->outboundValue({DECISION})I",
    )
    updated = source[:start] + filter_body + source[end:]
    start = updated.index(".method private static appendOfficial(")
    end = updated.index(".end method", start) + len(".end method")
    updated = updated[:start] + updated[end:]
    start = updated.index(".method static status()")
    end = updated.index(".end method", start) + len(".end method")
    updated = updated[:start] + updated[end:] + "\n" + HELPER.read_text()
    settings = path.with_name("WideOsmLocation.smali")
    settings_source = replace_once(
        settings.read_text(),
        r'\u50b3\u9001 OSM \u9053\u8def\u901f\u9650\u81f3 C4',
        "傳送道路速限至 C4（TDX／OSM）",
    )
    path.write_text(updated)
    settings.write_text(settings_source)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("smali_root", type=Path)
    apply(parser.parse_args().smali_root)
