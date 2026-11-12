#!/usr/bin/env python3
"""Restore the unchanged upstream background by immutable URL and SHA-256.

Existing files are verified and never silently replaced. No Google API key,
signing material, paid service, or package-manager dependency is needed.
"""
import argparse
import hashlib
import json
from pathlib import Path
import tempfile
import urllib.request

HERE = Path(__file__).resolve().parent
RESOURCE = Path("app/src/main/res/drawable/hfop_bg.png")
URL = "https://raw.githubusercontent.com/henryopen/openpilot/2decc11c5d8cebbdb87c0751ef52b96a494506c0/navdash/app/src/main/res/drawable/hfop_bg.png"
SIZE = 7803668
SHA256 = "0443af2eb356b08eaac13ab404c774cd7be5135934726e0493d88f5813ec2782"


def verify(data):
    if len(data) != SIZE or hashlib.sha256(data).hexdigest() != SHA256:
        raise SystemExit("Background size/SHA-256 mismatch; refusing to use or overwrite the resource")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--project-dir", type=Path, default=HERE)
    parser.add_argument("--verify-only", action="store_true")
    args = parser.parse_args()
    target = args.project_dir.expanduser().resolve() / RESOURCE
    if target.is_file():
        verify(target.read_bytes())
        action = "verified-existing"
    elif args.verify_only:
        raise SystemExit("Background is absent; run prepare_resources.py without --verify-only")
    else:
        with urllib.request.urlopen(URL, timeout=30) as response:
            data = response.read(SIZE + 1)
        verify(data)
        target.parent.mkdir(parents=True, exist_ok=True)
        temporary = None
        try:
            with tempfile.NamedTemporaryFile(dir=target.parent, prefix="hfop-bg-", suffix=".download", delete=False) as output:
                temporary = Path(output.name)
                output.write(data)
            temporary.replace(target)
        finally:
            if temporary is not None:
                temporary.unlink(missing_ok=True)
        action = "restored"
    print(json.dumps({"resource": RESOURCE.as_posix(), "action": action, "bytes": SIZE, "sha256": SHA256}))


if __name__ == "__main__":
    main()
