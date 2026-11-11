"""Restore byte-identical signed APK from public base; never handles signing keys."""
import hashlib
import json
import pathlib
import subprocess
import urllib.request
import bsdiff4

ROOT = pathlib.Path(__file__).resolve().parents[2]
HERE = pathlib.Path(__file__).resolve().parent
OUT = ROOT / 'release-output'
OUT.mkdir(exist_ok=True)
meta = json.loads((HERE / 'manifest.json').read_text())
def digest(data):
    return hashlib.sha256(data).hexdigest()
base = urllib.request.urlopen(meta['base_url'], timeout=120).read()
assert digest(base) == meta['base_sha256'], 'base hash mismatch'
parts = sorted(HERE.glob('patch-*.bin'))
assert [p.name for p in parts] == [f'patch-{i:03d}.bin' for i in range(meta['parts'])], 'missing patch part'
patch = b''.join(p.read_bytes() for p in parts)
assert digest(patch) == meta['patch_sha256'], 'patch hash mismatch'
apk = bsdiff4.patch(base, patch)
assert digest(apk) == meta['apk_sha256'], 'APK hash mismatch'
(OUT / meta['apk_name']).write_bytes(apk)
source = OUT / 'Copilot-tw-wide.39-source.zip'
subprocess.run(['git', 'archive', '--format=zip', '--output', str(source), 'HEAD'], cwd=ROOT, check=True)
files = [OUT / meta['apk_name'], source]
(OUT / 'SHA256SUMS.txt').write_text(''.join(f'{digest(p.read_bytes())}  {p.name}\n' for p in files))
print('Verified APK:', meta['apk_name'], meta['apk_sha256'])
