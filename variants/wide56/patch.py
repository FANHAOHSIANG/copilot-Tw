"""Apply wide55 delivery fixes, then bind verified Link route snapshots without replacing UI/capture."""
from pathlib import Path
import re,sys,subprocess
root=Path(sys.argv[1]);here=Path(__file__).resolve().parent
subprocess.run([sys.executable,str(here.parent/'wide55/patch.py'),str(root)],check=True)
d=root/'smali/com/navipilot/obf'
def once(s,a,b):
 assert s.count(a)==1,(a,s.count(a));return s.replace(a,b,1)
def method(s,name,fn):
 p=re.compile(r'(?ms)^\.method [^\n]* '+re.escape(name)+r'\n.*?^\.end method');m=list(p.finditer(s));assert len(m)==1,name
 return s[:m[0].start()]+fn(m[0].group())+s[m[0].end():]
p=d/'WideAmapLinkIntegration.smali';s=p.read_text()
def filter_method(m):
 start=m.index('    .line 284\n');end=m.index('    .line 292\n',start)
 return m[:start]+'''    invoke-virtual {v0, p1}, Lcom/navipilot/obf/WideAmapLinkNavigation$Snapshot;->stream(Ljava/lang/String;)Lorg/json/JSONObject;
    move-result-object v5
    invoke-virtual {v0, p1}, Lcom/navipilot/obf/WideAmapLinkNavigation$Snapshot;->timestamp(Ljava/lang/String;)J
    move-result-wide v6
'''+m[end:]
s=method(s,'filter(Lcom/navipilot/obf/MG;Ljava/lang/String;Lorg/json/JSONObject;Ljava/util/Map;)Lorg/json/JSONObject;',filter_method)
def publish(m):
 a='    .line 265\n    const-string v2, "guidance_current"'
 b='    const/4 v3, 0x0\n'
 for name in ['route','guidance_next','speed']:
  b+='    const-string v2, "'+name+'"\n    invoke-virtual {v0, v2, v3, v1}, Lcom/navipilot/obf/MG;->b(Ljava/lang/String;Lorg/json/JSONObject;Ljava/lang/String;)V\n'
 return once(m,a,b+a)
s=method(s,'publish()V',publish)
def status(m):
 line=next(x for x in m.splitlines() if '\\u5c1a\\u672a\\u89e3\\u6790' in x)
 return once(m,line,'    invoke-virtual {v2}, Lcom/navipilot/obf/WideAmapLinkNavigation$Snapshot;->routeStatus()Ljava/lang/String;\n    move-result-object v1')
s=method(s,'status()Ljava/lang/String;',status)
s=s.replace('const-string v7, "wide.47"','const-string v7, "wide.56"')
for name in ['route_forwarding','next_turn_forwarding']:
 s=once(s,'    const-string v6, "'+name+'"\n\n    invoke-virtual {v2, v6, v3}', '    const-string v6, "'+name+'_supported"\n\n    invoke-virtual {v2, v6, v5}')
p.write_text(s)
p=d/'MG.smali';s=p.read_text()
a='    invoke-static {v8, v9, v1}, Lcom/navipilot/obf/WideAmapPreAdjust;->merge(Ljava/lang/String;Lorg/json/JSONObject;Ljava/util/Map;)Lorg/json/JSONObject;\n\n    move-result-object v9'
b='    invoke-static {}, Lcom/navipilot/obf/WideAmapLinkIntegration;->phoneSelected()Z\n    move-result v2\n    if-nez v2, :wide56_link_authoritative\n'+a+'\n    :wide56_link_authoritative'
s=once(s,a,b);p.write_text(s)
p=d/'WideAmapLinkIntegration$6.smali';s=p.read_text()
# Existing stop callback withdraws current and status. Also withdraw every new stream.
a='    const-string v2, "navigation_status"'
if a not in s:
 a=next(x for x in s.splitlines() if 'const-string' in x and 'navigation_status' in x)
 # use the same sender and null/reason registers as the existing status call
idx=s.index(a);call=re.search(r'    invoke-virtual \{[^\n]+MG;->b[^\n]+',s[idx:]).group()
reg=a.split()[1].rstrip(',');extra=''
for name in ['route','guidance_next','speed']:extra+='    const-string '+reg+', "'+name+'"\n'+call+'\n'
s=once(s,a,extra+a);p.write_text(s)
p=root/'apktool.yml';s=p.read_text().replace('26110767','26110768').replace('9.3.1-wide.55-link-delivery','9.3.1-wide.56-amap-route');p.write_text(s)
for name in ['Yg.smali','WideBrand.smali']:
 p=d/name
 if p.exists():p.write_text(p.read_text().replace('9.3.1-wide.55-link-delivery','9.3.1-wide.56-amap-route').replace('26110767','26110768').replace('wide.55','wide.56'))
print('wide56 route hooks applied')
