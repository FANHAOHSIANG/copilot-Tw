from pathlib import Path
import shutil
BASE=Path('bridge-build/baseline');OUT=Path('bridge-build/patched')
PREFIX=('WideCamera','WideSettings','WideRoad','WideSpeedMerge','WideBridge')
def patch():
 if OUT.exists():raise FileExistsError(OUT)
 shutil.copytree(BASE,OUT,ignore=lambda d,n:[x for x in n if Path(d)==BASE and x in ('build','dist')])
 sm=OUT/'smali/com/navipilot/obf'
 for p in sm.glob('*.smali'):
  if p.name.startswith(PREFIX):p.unlink()
 for p in Path('bridge-build/helper-decoded/smali/com/navipilot/obf').glob('*.smali'):
  assert p.name.startswith(PREFIX),p
  shutil.copy(p,sm/p.name)
 shutil.copy('bridge-build/data/corridors.json',OUT/'assets/tw_corridors.json')
 p=OUT/'apktool.yml';s=p.read_text();assert 'versionCode: 26110725' in s
 p.write_text(s.replace('versionCode: 26110725','versionCode: 26110726').replace('versionName: 9.3.1-wide.13-camera-alerts','versionName: 9.3.1-wide.14-tw-bridge'))
 # Merge before the existing presence, deduplication and rate-limit decisions.
 p=sm/'MG.smali';s=p.read_text();a=s.index('.method public final b(');b=s.index('.end method',a);m=s[a:b]
 old='    move-object/from16 v9, p2\n'
 inject='''
    iget-object v1, v0, Lcom/navipilot/obf/MG;->i:Ljava/util/LinkedHashMap;
    invoke-static {v8, v9, v1}, Lcom/navipilot/obf/WideBridge;->merge(Ljava/lang/String;Lorg/json/JSONObject;Ljava/util/Map;)Lorg/json/JSONObject;
    move-result-object v9
    move-object/16 p2, v9
'''
 assert m.count(old)==1;m=m.replace(old,old+inject)
 old='    :goto_3\n'
 inject='''    move-wide/from16 v1, v23
    invoke-static {v8, v1, v2}, Lcom/navipilot/obf/WideBridge;->timestamp(Ljava/lang/String;J)J
    move-result-wide v23

'''
 assert m.count(old)==1;m=m.replace(old,old+inject);p.write_text(s[:a]+m+s[b:])
 # Observe actual enqueue return, never call a second sender or claim delivery here.
 p=sm/'XG.smali';s=p.read_text();a=s.index('.method public final f(');b=s.index('.end method',a);m=s[a:b]
 m=m.replace('.locals 3','.locals 4\n\n    move-object v3, p3',1)
 old='    :goto_0\n';assert m.count(old)==1
 m=m.replace(old,old+'''    iget-object v0, p0, Lcom/navipilot/obf/XG;->e:Ljava/lang/String;
    iget v1, p0, Lcom/navipilot/obf/XG;->f:I
    invoke-static {p1, v3, p3, v0, v1}, Lcom/navipilot/obf/WideBridge;->queued(Ljava/lang/String;Ljava/lang/String;ZLjava/lang/String;I)V

''');p.write_text(s[:a]+m+s[b:])
 # Accepted compact telemetry snapshot; match session + sequence + host + exact SDI values.
 p=sm/'Ae.smali';s=p.read_text();a=s.index('.method public final f(');b=s.index('.end method',a);m=s[a:b]
 old='    move-object/from16 v1, p1\n';assert m.count(old)==1
 m=m.replace(old,old+'''
    iget-object v2, v0, Lcom/navipilot/obf/Ae;->m:Ljava/lang/String;
    invoke-static {v1, v2}, Lcom/navipilot/obf/WideBridge;->telemetry(Lcom/navipilot/obf/zg;Ljava/lang/String;)V
''');p.write_text(s[:a]+m+s[b:])
if __name__=='__main__':patch()
