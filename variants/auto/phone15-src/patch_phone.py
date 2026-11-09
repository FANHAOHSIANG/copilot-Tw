from pathlib import Path
import shutil

BASE=Path('phone15-build/baseline'); OUT=Path('phone15-build/patched')
def patch():
 if OUT.exists(): raise FileExistsError(OUT)
 shutil.copytree(BASE,OUT,ignore=lambda d,n:[x for x in n if Path(d)==BASE and x in ('build','dist')])
 sm=OUT/'smali/com/navipilot/obf'
 for p in sm.glob('*.smali'):
  if p.name.startswith(('WideDirect','WideSettings','WideNavProbe','WideNavNotifications')): p.unlink()
 for p in Path('phone15-build/helper-decoded/smali/com/navipilot/obf').glob('*.smali'):
  assert p.name.startswith(('WideDirect','WideSettings','WideNavProbe','WideNavNotifications')),p
  shutil.copy(p,sm/p.name)
 for name in ('S3','VC','SC','TC'):
  p=sm/(name+'.smali');s=p.read_text().replace('com.autonavi.amapauto','com.autonavi.minimap')
  p.write_text(s.replace('高德車機版','高德一般版').replace('高德車機版'.encode('unicode_escape').decode(),'高德一般版'))
 p=sm/'h4.smali';s=p.read_text();old='.method public static final a(Lcom/navipilot/obf/h4;Landroid/content/Intent;I)V\n    .locals 5\n';assert s.count(old)==1
 p.write_text(s.replace(old,old+'\n    invoke-static {p1}, Lcom/navipilot/obf/WideNavProbe;->broadcast(Landroid/content/Intent;)V\n'))
 p=sm/'XG.smali';s=p.read_text();a=s.index('.method public final f(');b=s.index('.end method',a);m=s[a:b]
 assert m.count('.locals 3')==1;m=m.replace('.locals 3','.locals 4\n\n    move-object v3, p3',1)
 old='    :goto_0\n';assert m.count(old)==1
 m=m.replace(old,old+'''    iget-object v0, p0, Lcom/navipilot/obf/XG;->e:Ljava/lang/String;
    iget v1, p0, Lcom/navipilot/obf/XG;->f:I
    invoke-static {p1, v3, p3, v0, v1}, Lcom/navipilot/obf/WideNavProbe;->queued(Ljava/lang/String;Ljava/lang/String;ZLjava/lang/String;I)V

''');p.write_text(s[:a]+m+s[b:])
 p=sm/'Ae.smali';s=p.read_text();a=s.index('.method public final f(');b=s.index('.end method',a);m=s[a:b]
 old='    move-object/from16 v1, p1\n';assert m.count(old)==1
 m=m.replace(old,old+'''
    iget-object v2, v0, Lcom/navipilot/obf/Ae;->m:Ljava/lang/String;
    invoke-static {v1, v2}, Lcom/navipilot/obf/WideNavProbe;->telemetry(Lcom/navipilot/obf/zg;Ljava/lang/String;)V
''');p.write_text(s[:a]+m+s[b:])
 p=OUT/'AndroidManifest.xml';s=p.read_text();assert 'WideNavNotifications' not in s
 service='''<service android:name="com.navipilot.obf.WideNavNotifications" android:label="CP搭子 高德資料測試" android:exported="true" android:permission="android.permission.BIND_NOTIFICATION_LISTENER_SERVICE">
 <intent-filter><action android:name="android.service.notification.NotificationListenerService"/></intent-filter>
 </service>'''
 p.write_text(s.replace('</application>',service+'\n</application>'))
 p=OUT/'apktool.yml';s=p.read_text();assert 'versionCode: 26110723' in s
 p.write_text(s.replace('versionCode: 26110723','versionCode: 26110727').replace('versionName: 9.3.1-wide.11-auto-diagnostic','versionName: 9.3.1-wide.15-phone-bridge'))
if __name__=='__main__':patch()
