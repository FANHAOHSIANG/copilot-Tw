from pathlib import Path
import sys,re
r=Path(sys.argv[1]);d=r/'smali/com/navipilot/obf'
p=d/'WideBridge.smali';s=p.read_text();s=s.replace('    invoke-static {p0}, Lcom/navipilot/obf/WideHcop;->init(Landroid/content/Context;)V','    nop');p.write_text(s)
p=d/'WideVariant$Navigation.smali';s=p.read_text();old='.method static restore(Ljava/lang/String;Z)Lcom/navipilot/obf/WideVariant$Navigation;\n    .locals 5';assert old in s
s=s.replace(old,old+'\n    const-string v0, "com.copilottw.googlenav"\n    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z\n    move-result v0\n    if-eqz v0, :cp_source_restored\n    const-string p0, "com.jixiexiaoge.drivingassist.wide"\n    :cp_source_restored');p.write_text(s)
# Isolate the integrated server from any still-installed/running companion.
for p in list(r.glob('smali*/com/navdashn/navigation/NavService.smali'))+list(r.glob('smali*/com/navdashn/utils/Constants.smali'))+[d/'WideGoogleNav.smali']:
 s=p.read_text().replace('0x138a','0x138b').replace('5002','5003');p.write_text(s)
# Remove obsolete installation instructions from the integrated settings dialog.
p=d/'WideGoogleNav.smali';s=p.read_text()
def edit(m):
 import json
 try:v=json.loads(m[1])
 except:return m[0]
 v=v.replace('請先安裝配套的 CP Google 導航 APK。','內建 Google 導航無法開啟，請匯出診斷。').replace('在導航來源選『CP Google 導航』，於該畫面設定自己的金鑰並開始導航。','Google 導航已整合在本 App，請在內建導航設定金鑰並開始導航。')
 return 'const-string '+m[2]+', '+json.dumps(v,ensure_ascii=True)
s=re.sub(r'const-string (\w+), ("(?:\\.|[^"\\])*")',lambda m:edit(type('M',(),{'__getitem__':lambda _,i:{0:m[0],1:m[2],2:m[1]}[i]})()),s)
p.write_text(s)
