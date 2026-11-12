"""Restore the signed wide.43 APK. Requires Python bsdiff4; no signing key."""
import hashlib
import json
import pathlib
import subprocess
import sys
import bsdiff4

ROOT = pathlib.Path(__file__).resolve().parents[2]
HERE = pathlib.Path(__file__).resolve().parent
meta = json.loads((HERE / 'manifest.json').read_text())
out = ROOT / 'release-output'
base = out / meta['base_name']
if not base.exists():
    subprocess.run([sys.executable, str(ROOT / 'release/wide42/publish.py')], check=True)
digest = lambda data: hashlib.sha256(data).hexdigest()
original = base.read_bytes()
assert digest(original) == meta['base_sha256'], 'Base hash mismatch'
patch = (HERE / 'patch.bin').read_bytes()
assert digest(patch) == meta['patch_sha256'], 'Patch hash mismatch'
apk = bsdiff4.patch(original, patch)
assert digest(apk) == meta['apk_sha256'], 'APK hash mismatch'
(out / meta['apk_name']).write_bytes(apk)
print('Verified APK:', meta['apk_name'], meta['apk_sha256'])
