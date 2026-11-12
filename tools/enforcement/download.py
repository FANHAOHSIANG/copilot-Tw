"""Fetch pinned official resources; preserve last good snapshot on failure."""
import concurrent.futures
import datetime
import hashlib
import json
import csv
import io
from pathlib import Path
import urllib.request

ROOT = Path(__file__).resolve().parents[2]
DATA = ROOT / 'data/enforcement'

def download(source):
    path = DATA / 'raw' / (source['id'] + '.' + source['format'])
    result = {'sourceId': source['id'], 'url': source['url'], 'attemptedAt': datetime.datetime.now(datetime.timezone.utc).isoformat()}
    if source['format']=='manual-json':
        result.update(status='manual_refresh_required',cached=path.exists())
        return result
    try:
        request = urllib.request.Request(source['url'], headers={'User-Agent': 'CoPilot-TW-data-audit/1.0'})
        with urllib.request.urlopen(request, timeout=25) as response:
            body = response.read(20_000_001)
            if len(body) > 20_000_000:
                raise ValueError('resource exceeds 20MB')
            if not body or b'<html' in body[:512].lower() or b'<!doctype html' in body[:512].lower():
                raise ValueError('empty resource or HTML returned instead of data')
            result['contentType'] = response.headers.get('Content-Type')
            result['resolvedUrl'] = response.url
        if source['format'] == 'json':
            parsed = json.loads(body.decode('utf-8-sig'))
            if not isinstance(parsed, list) or not parsed or not all(isinstance(r,dict) for r in parsed):
                raise ValueError('unexpected JSON root')
        if source['format']=='pdf' and not body.startswith(b'%PDF-'):
            raise ValueError('not a PDF')
        if source['format']=='csv':
            from build import decode
            rows=list(csv.DictReader(io.StringIO(decode(body))))
            if not rows or len(rows[0])<2:raise ValueError('not a tabular CSV')
        path.parent.mkdir(parents=True, exist_ok=True)
        temp = path.with_suffix(path.suffix + '.tmp')
        temp.write_bytes(body)
        temp.replace(path)
        result.update(status='downloaded', bytes=len(body), sha256=hashlib.sha256(body).hexdigest(), retrievedAt=result['attemptedAt'])
        path.with_suffix(path.suffix + '.provenance.json').write_text(json.dumps(result, ensure_ascii=False, indent=2)+'\n')
    except Exception as exc:
        result.update(status='cached_after_failure' if path.exists() else 'unavailable', error=str(exc))
    return result

if __name__ == '__main__':
    sources = json.loads((Path(__file__).parent / 'sources.json').read_text())
    DATA.mkdir(parents=True, exist_ok=True)
    with concurrent.futures.ThreadPoolExecutor(max_workers=6) as pool:
        results = list(pool.map(download, sources))
    (DATA / 'download-status.json').write_text(json.dumps(results, ensure_ascii=False, indent=2)+'\n')
    for result in results:
        print(result['sourceId'], result['status'], result.get('bytes', result.get('error')))
