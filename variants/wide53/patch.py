#!/usr/bin/env python3
"""Apply narrow, asserted hooks to the pinned integrated wide52 APK."""
import json,re,sys,xml.etree.ElementTree as E
from pathlib import Path
from opencc import OpenCC
r=Path(sys.argv[1]);d=r/'smali/com/navipilot/obf';A='{http://schemas.android.com/apk/res/android}';E.register_namespace('android',A[1:-1]);E.register_namespace('app','http://schemas.android.com/apk/res-auto')
def replace_method(p,sig,body):
 s=p.read_text();pattern=r'(?m)^\.method [^\n]* '+re.escape(sig)+r'\n.*?^\.end method';m=re.search(pattern,s,re.S|re.M);assert m,(p,sig);s=s[:m.start()]+m[0].split('\n')[0]+'\n'+body+'\n.end method'+s[m.end():];p.write_text(s)
p=d/'XN.smali';s=p.read_text();old='invoke-interface {v7, v0, v4, v2}, Lcom/navipilot/obf/yr;->h(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;';assert s.count(old)==1;s=s.replace(old,'invoke-static {v7, v0, v4, v2}, Lcom/navipilot/obf/WidePanels;->controls(Lcom/navipilot/obf/yr;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;');p.write_text(s)
replace_method(d/'MD.smali','b(Lcom/navipilot/obf/tr;Lcom/navipilot/obf/tr;Landroid/content/Context;Lcom/navipilot/obf/tr;Z)V','    .locals 0\n    invoke-static {p2}, Lcom/navipilot/obf/WidePlaces;->showContext(Landroid/content/Context;)V\n    return-void')
p=r/'smali/com/navipilot/amap2tesla/privileged/PrivilegedDisplayService.smali';s=p.read_text();sig='.method public final e(Ljava/lang/String;I)Z';a=s.index(sig);b=s.index('.end method',a);part=s[a:b];needle='    :cond_0\n';assert part.count(needle)==1
part=part.replace(needle,needle+'''    const-string v1, "copilot-intent:"
    invoke-virtual {p1, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v1
    if-eqz v1, :wide53_launcher
    invoke-static {p1, p2}, Lcom/navipilot/obf/WideLaunch;->execute(Ljava/lang/String;I)Z
    move-result v0
    return v0
    :wide53_launcher
''');s=s[:a]+part+s[b:];p.write_text(s)
# Google UI: keep SDK routing/lifecycle; remove custom voice input/help entrypoints.
main=next(r.glob('smali*/com/navdashn/MainActivity.smali'))
replace_method(main,'startVoiceSearch()V','    .locals 0\n    return-void')
for sig in ['onCreate(Landroid/os/Bundle;)V','onResume()V']:
 s=main.read_text();pattern=r'(?m)^\.method [^\n]* '+re.escape(sig)+r'\n.*?^\.end method';m=re.search(pattern,s,re.S|re.M);assert m
 # onCreate can exit before binding; find hook by setupButtons invocation, resume by super call.
 part=m[0]
 if sig.startswith('onCreate'):
  needle='    invoke-direct {p0}, Lcom/navdashn/MainActivity;->setupButtons()V';hook='install'
 else:
  needle='    invoke-super {p0}, Landroidx/appcompat/app/AppCompatActivity;->onResume()V';hook='resume'
 assert needle in part,(sig,needle);part=part.replace(needle,needle+'\n    invoke-static {p0}, Lcom/navipilot/obf/WideGoogleUi;->'+hook+'(Landroid/app/Activity;)V');main.write_text(s[:m.start()]+part+s[m.end():])
for old,new,flag in [('onAddToFavorites','addFavoriteOriginal',0),('onRemoveFromFavorites','removeFavoriteOriginal',1)]:
 s=main.read_text();header='.method private final '+old+'(Lcom/navdashn/navigation/PlaceItem;)Z';assert s.count(header)==1;s=s.replace(header,'.method private final '+new+'(Lcom/navdashn/navigation/PlaceItem;)Z');s+='\n'+header+'\n    .locals 1\n    const/4 v0, '+str(flag)+'\n    invoke-static {p0, p1, v0}, Lcom/navipilot/obf/WideGoogleUi;->favorite(Landroid/app/Activity;Ljava/lang/Object;Z)Z\n    move-result v0\n    return v0\n.end method\n';main.write_text(s)
# Hide help from guidance even when its orientation adapts. The layout keeps IDs for view-binding ABI.
for p in r.glob('smali*/com/navdashn/GuidanceActivity.smali'):
 s=p.read_text();sig='.method protected onCreate(Landroid/os/Bundle;)V';a=s.index(sig);b=s.index('.end method',a);part=s[a:b];part=part.replace('    return-void','    invoke-static {p0}, Lcom/navipilot/obf/WideGoogleUi;->install(Landroid/app/Activity;)V\n    return-void');p.write_text(s[:a]+part+s[b:])
# Style the key gate without changing initialization or handling user keys.
key=next(r.glob('smali*/com/navdashn/KeyEntryActivity.smali'));s=key.read_text()
needle='    invoke-virtual {p0, v0}, Lcom/navdashn/KeyEntryActivity;->setContentView(Landroid/view/View;)V'
# Register allocation is pinned but select the actual view register explicitly.
m=re.search(r'    invoke-virtual \{p0, ([vp]\d+)\}, Lcom/navdashn/KeyEntryActivity;->setContentView\(Landroid/view/View;\)V',s);assert m
s=s[:m.end()]+'\n    invoke-static {p0}, Lcom/navipilot/obf/WideGoogleUi;->keyScreen(Landroid/app/Activity;)V'+s[m.end():];key.write_text(s)
# Keep voice guidance, remove C3/Bluetooth keyboard documentation screen and microphone input.
p=r/'AndroidManifest.xml';tree=E.parse(p);app=tree.getroot().find('application')
for x in list(app):
 if x.get(A+'name')=='com.navdashn.HelpActivity':app.remove(x)
queries=tree.getroot().find('queries')
if queries is None:queries=E.SubElement(tree.getroot(),'queries')
intent=E.SubElement(queries,'intent');E.SubElement(intent,'action',{A+'name':'android.intent.action.MAIN'});E.SubElement(intent,'category',{A+'name':'android.intent.category.LAUNCHER'})
tree.write(p,encoding='utf-8',xml_declaration=True)
for name in ['activity_main.xml','guidance_controls.xml']:
 p=r/'res/layout'/name;t=E.parse(p)
 for el in t.iter():
  if el.get(A+'id','').split('/')[-1] in ['voiceSearchButton','helpButton','guidanceHelpButton']:el.set(A+'visibility','gone')
  if el.get(A+'padding')=='16.0dip':el.set(A+'padding','12.0dip')
 t.write(p,encoding='utf-8',xml_declaration=True)
p=r/'res/values/colors.xml';t=E.parse(p);colors={'primary':'#91C5FF','primary_dark':'#579BD7','primary_light':'#C8E4FF','background':'#0B1321','surface':'#121E30','card':'#1B2A40','text_primary':'#F2F6FC','text_secondary':'#A6B7C9','text_hint':'#A6B7C9','divider':'#2B3D54','fab_background':'#91C5FF'}
for e in t.getroot():
 if e.get('name') in colors:e.text=colors[e.get('name')]
t.write(p,encoding='utf-8',xml_declaration=True)
# Translate app-owned literal UI text only; identifiers, assets, vehicle protocols, SDK libraries unchanged.
cc=OpenCC('s2twp');changes=[]
labels={'高德車機版投屏':'地圖投屏','車機連線':'comma','車機連接':'comma','高德投屏':'地圖投屏','高德車機投屏':'地圖投屏','車機連接狀態':'comma','車機連線狀態':'comma','一鍵導航回家':'常用地址','一鍵導航去公司':'編輯常用地址','回家 / 公司':'常用地址','回家':'常用地址','長按：回公司':'三個自訂地址'}
def translate(v):
 v=cc.convert(v)
 for a,b in labels.items():v=v.replace(a,b)
 return v
for p in d.glob('*.smali'):
 s=p.read_text()
 def literal(m):
  try:v=json.loads(m[2])
  except:return m[0]
  if not re.search('[\u4e00-\u9fff]',v) or '://' in v or v.lstrip().startswith(('{','[')):return m[0]
  new=translate(v)
  if new!=v:changes.append({'class':p.stem,'before':v,'after':new})
  return m[1]+json.dumps(new,ensure_ascii=True)
 s=re.sub(r'(const-string(?:/jumbo)? \w+, )("(?:\\.|[^"\\])*")',literal,s);p.write_text(s)
for p in [r/'res/values/strings.xml',*r.glob('res/values-zh*/strings.xml')]:
 t=E.parse(p)
 for el in t.getroot():
  if el.text and (el.get('name','').startswith('copilot_') or p.parent.name=='values'):el.text=translate(el.text)
 t.write(p,encoding='utf-8',xml_declaration=True)
p=r/'apktool.yml';s=p.read_text();s=re.sub(r'(?m)^  versionCode: .*','  versionCode: 26110765',s);s=re.sub(r'(?m)^  versionName: .*','  versionName: 9.3.1-wide.53-adaptive-dashboard',s);p.write_text(s)
p=d/'Yg.smali';s=p.read_text().replace('9.3.1-wide.52-google-integrated','9.3.1-wide.53-adaptive-dashboard').replace('26110764','26110765');p.write_text(s)
(r.parent/'translation-audit.json').write_text(json.dumps(changes,ensure_ascii=False,indent=2))
print('Patched wide53; translated',len(changes),'literals')
