#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
mkdir -p work/tools work/upstream work/build work/data
python3 work/fetch_dependencies.py
sha256sum -c work/src/tool-checksums.sha256
python3 - <<'PY'
import zipfile,os
for f in ['platform','build-tools']:
 with zipfile.ZipFile('work/tools/'+f+'.zip') as z:z.extractall('work/tools')
for root,dirs,files in os.walk('work/tools/android-16'):
 for f in files:
  if not f.endswith(('.jar','.txt','.so')):os.chmod(os.path.join(root,f),0o755)
PY
