"""Copy only road data from the existing licensed Taiwan OSM asset archive."""
import gzip
import json
import re
import zipfile

PREFIX = "work/assets/"
TILE = re.compile(r"work/assets/tw_hcop/\d+_\d+\.json\.gz")


def install(source, target):
    with zipfile.ZipFile(source) as archive:
        metadata = json.loads(archive.read(PREFIX + "tw_hcop_metadata.json"))
        names = [name for name in archive.namelist() if TILE.fullmatch(name)]
        if metadata.get("schema") != 1 or len(set(names)) != metadata.get("tiles") or len(set(names)) != len(names):
            raise ValueError("Invalid Taiwan OSM asset archive")
        for name in names:
            tile = json.loads(gzip.decompress(archive.read(name)))
            # The existing tile reader requires all three arrays.
            roads = {"r": tile["r"], "f": [], "c": []}
            target.writestr(name.replace(PREFIX, "assets/", 1),
                            gzip.compress(json.dumps(roads, ensure_ascii=False, separators=(",", ":")).encode(),
                                          compresslevel=5, mtime=0))
        metadata["hcopFixes"] = 0
        metadata["tdxDirectionalStretches"] = 0
        metadata.pop("tdxSnapshotDate", None)
        metadata["scope"] = "Taiwan OSM road geometry and directional speed limits."
        metadata["cameras"] = 0
        metadata["matchedCameras"] = 0
        metadata.pop("cameraRejections", None)
        target.writestr("assets/tw_hcop_metadata.json", json.dumps(metadata, ensure_ascii=False))
        target.writestr("assets/OSM-ATTRIBUTION.txt",
                        "© OpenStreetMap contributors. Open Database License (ODbL).\n"
                        "https://www.openstreetmap.org/copyright\n")
        return len(names) + 2
