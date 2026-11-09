import urllib.request,concurrent.futures,pathlib,hashlib,json
items={
'apktool.jar':'https://github.com/iBotPeaches/Apktool/releases/download/v3.0.3/apktool_3.0.3.jar',
'ecj.jar':'https://repo.maven.apache.org/maven2/org/eclipse/jdt/ecj/3.39.0/ecj-3.39.0.jar',
'json.jar':'https://repo.maven.apache.org/maven2/org/json/json/20240303/json-20240303.jar',
'build-tools.zip':'https://dl.google.com/android/repository/build-tools_r36_linux.zip',
'platform.zip':'https://dl.google.com/android/repository/platform-35_r02.zip',
}
up={p:'https://raw.githubusercontent.com/henryopen/openpilot/2decc11c5d8cebbdb87c0751ef52b96a494506c0/'+q for p,q in {
'hcop-speed-limit.py':'openpilot/selfdrive/mapd/speed_limit.py',
'hcop-fixes.json':'openpilot/selfdrive/mapd/speed_limit_fixes.json',
'hcop-LICENSE':'LICENSE',
'hcop-mapd.py':'openpilot/selfdrive/mapd/mapd.py'}.items()}
def fetch(x):
 path,url=x
 try:
  with urllib.request.urlopen(url,timeout=90) as r,open(path,'wb') as f:
   while b:=r.read(1024*1024): f.write(b)
  p=pathlib.Path(path);print(json.dumps({'file':str(p),'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()}),flush=True)
 except Exception as e: print(str(path)+': '+str(e),flush=True)
with concurrent.futures.ThreadPoolExecutor(max_workers=5) as ex:list(ex.map(fetch,[(pathlib.Path('work/tools')/p,u) for p,u in items.items()]+[(pathlib.Path('work/upstream')/p,u) for p,u in up.items()]))
