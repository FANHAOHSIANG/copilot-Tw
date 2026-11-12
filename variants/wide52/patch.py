from pathlib import Path
import re,sys,xml.etree.ElementTree as E
root=Path(sys.argv[1]);d=root/'smali/com/navipilot/obf';host='com.jixiexiaoge.drivingassist.wide'
def method(file,sig,body):
 p=d/(file+'.smali');s=p.read_text();rx=r'(?m)^\.method [^\n]* '+re.escape(sig)+r'\n.*?^\.end method';m=re.search(rx,s,re.S|re.M);assert m,(file,sig)
 s=s[:m.start()]+m[0].split('\n')[0]+'\n'+body+'\n.end method'+s[m.end():];p.write_text(s)
void='    .locals 0\n    return-void'
false='    .locals 1\n    const/4 v0, 0x0\n    return v0'
method('WideCamera','init(Landroid/content/Context;)V',void)
method('WideCamera','start(Landroid/app/Activity;)Z',false)
method('WideAutoStart','attach(Landroid/app/Activity;)V',void)
method('WideAutoStart','enabled(Landroid/app/Activity;)Z',false)
method('WideBridge','enabled()Z',false)
method('WideBridge','setEnabled(Z)V','    .locals 0\n    const/4 p0, 0x0\n    sput-boolean p0, Lcom/navipilot/obf/WideBridge;->enabled:Z\n    return-void')
method('WideBridge','merge(Ljava/lang/String;Lorg/json/JSONObject;Ljava/util/Map;)Lorg/json/JSONObject;','    .locals 0\n    return-object p1')
method('WideBridge','accept(Lcom/navipilot/obf/WideCameraEngine$Fix;)V',void)
method('WideVariant','shieldPanel()Z','    .locals 1\n    const/4 v0, 0x1\n    return v0')
method('WideVariant','togglePanel(Landroid/app/Activity;)V',void)
method('WideStatusBorder','cameraGlow(J)I',false)
# Remove the old Taiwan settings entry by replacing its click target, then remove
# its menu entry in a separately asserted patch below.
method('WideTaiwanSettings','show(Landroid/app/Activity;Landroid/view/ViewGroup;)V',void)
# Internal Google source uses this APK package, still distinct from official Maps.
for name in ['WideGoogleNav','WideVariant$Navigation','WideAmapSource']:
 p=d/(name+'.smali');s=p.read_text().replace('com.copilottw.googlenav',host);p.write_text(s)
p=d/'WideGoogleNav.smali';s=p.read_text()
old='    invoke-virtual {p1, p2}, Landroid/content/pm/PackageManager;->getLaunchIntentForPackage(Ljava/lang/String;)Landroid/content/Intent;\n\n    move-result-object p1'
new='    new-instance p1, Landroid/content/Intent;\n    invoke-direct {p1}, Landroid/content/Intent;-><init>()V\n    const-string p2, "com.navdashn.KeyEntryActivity"\n    invoke-virtual {p1, p0, p2}, Landroid/content/Intent;->setClassName(Landroid/content/Context;Ljava/lang/String;)Landroid/content/Intent;'
assert old in s;s=s.replace(old,new);p.write_text(s)
# The privileged launcher must resolve the Google component, never recursively
# launch the CoPilot host into its own projected display.
p=root/'smali/com/navipilot/amap2tesla/privileged/PrivilegedDisplayService.smali';s=p.read_text();needle='    :goto_1\n    const-string v2, "Amap2TeslaPrivileged"';assert needle in s
s=s.replace(needle,'    :goto_1\n    const-string v2, "'+host+'"\n    invoke-virtual {v2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z\n    move-result v3\n    if-eqz v3, :cp_component_ready\n    const-string v5, "'+host+'/com.navdashn.KeyEntryActivity"\n    :cp_component_ready\n    const-string v2, "Amap2TeslaPrivileged"');p.write_text(s)
# Distinct task affinity keeps Google activities on the navigation virtual display.
A='{http://schemas.android.com/apk/res/android}';E.register_namespace('android',A[1:-1]);m=E.parse(root/'AndroidManifest.xml')
for x in m.getroot().find('application').findall('activity'):
 if x.get(A+'name','').startswith('com.navdashn.'):
  x.set(A+'taskAffinity',host+'.google');x.set(A+'resizeableActivity','true')
 if x.get(A+'name')=='com.navdashn.KeyEntryActivity':x.set(A+'launchMode','singleTask')
m.write(root/'AndroidManifest.xml',encoding='utf-8',xml_declaration=True)
# Remove Taiwan data entirely: no offline enforcement source can load in this build.
for p in (root/'assets').glob('tw_*'):
 import shutil
 if p.is_dir():shutil.rmtree(p)
 else:p.unlink()
p=d/'Yg.smali';p.write_text(p.read_text().replace('9.3.1-wide.51-camera-advisory','9.3.1-wide.52-google-integrated').replace('26110763','26110764'))
print('Google component routing and Taiwan shutdown applied')
p=d/'WideSettings.smali';s=p.read_text();s,n=re.subn(r'    \.line 83\n.*?(?=    \.line 84\n)','',s,flags=re.S);assert n==1;p.write_text(s)
p=d/'WideDirect$Pane.smali';s=p.read_text();s,n=re.subn(r'    \.line 225\n.*?(?=    \.line 226\n)','',s,flags=re.S);assert n==1;p.write_text(s)
# An integrated module must never kill its host process.
paths=list(root.glob('smali*/com/navdashn/MainActivity.smali'));assert len(paths)==1
p=paths[0];s=p.read_text();s,n=re.subn(r'    invoke-static \{v0\}, Landroid/os/Process;->killProcess\(I\)V','    nop',s);assert n==1;p.write_text(s)
