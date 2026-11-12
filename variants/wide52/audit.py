from pathlib import Path
import xml.etree.ElementTree as E,json,re,sys,collections
r=Path(sys.argv[1]);g=Path(sys.argv[2]);d=r/'smali/com/navipilot/obf';checks=[]
def check(name,value):
 assert value,name
 checks.append(name)
A='{http://schemas.android.com/apk/res/android}';m=E.parse(r/'AndroidManifest.xml').getroot();app=m.find('application')
check('original upgrade package',m.get('package')=='com.jixiexiaoge.drivingassist.wide')
launch=[x.get(A+'name') for x in app.findall('activity') if any(z.get(A+'name')=='android.intent.category.LAUNCHER' for y in x.findall('intent-filter') for z in y)]
check('single CoPilot launcher',launch==['com.jixiexiaoge.drivingassist.MainActivity'])
check('Taiwan foreground service absent',not any(x.get(A+'name')=='com.navipilot.obf.WideCameraService' for x in app))
check('Taiwan data absent',not list((r/'assets').glob('tw_*')))
classes=[re.search(r'(?m)^\.class[^\n]*? (L[^;]+;)',p.read_text())[1] for p in r.glob('smali*/**/*.smali')]
check('no duplicate DEX class definitions',len(classes)==len(set(classes)))
for x in app:
 name=x.get(A+'name','')
 if x.tag in ['activity','service','provider','receiver']:
  check('manifest component '+name,'L'+name.replace('.','/')+';' in classes)
pub=E.parse(r/'res/values/public.xml').getroot();gp=E.parse(g/'res/values/public.xml').getroot();actual={(x.get('type'),x.get('name')):x.get('id') for x in pub}
check('all 8472 Google resource IDs unchanged',all(actual[x.get('type'),x.get('name')]==x.get('id') for x in gp))
check('all merged resource IDs unique',len(pub)==len({x.get('id') for x in pub}))
check('218 relocated CoPilot resources',len(pub)-len(gp)==218)
def body(c,sig):
 return re.search(r'(?m)^\.method [^\n]* '+re.escape(sig)+r'\n(.*?)^\.end method',(d/(c+'.smali')).read_text(),re.S|re.M)[1]
check('camera cannot start','return v0' in body('WideCamera','start(Landroid/app/Activity;)Z') and 'const/4 v0, 0x0' in body('WideCamera','start(Landroid/app/Activity;)Z'))
check('auto start disabled','invoke-' not in body('WideAutoStart','attach(Landroid/app/Activity;)V'))
check('Taiwan source cannot enable','const/4 p0, 0x0' in body('WideBridge','setEnabled(Z)V'))
check('Taiwan speed override removed','invoke-' not in body('WideBridge','merge(Ljava/lang/String;Lorg/json/JSONObject;Ljava/util/Map;)Lorg/json/JSONObject;'))
check('Shield is only speed pane','WideTaiwanHost' not in (d/'WideSpeedHost.smali').read_text())
check('Taiwan settings button absent','new-instance v0, Lcom/navipilot/obf/WideSettings$1;' not in (d/'WideSettings.smali').read_text())
check('Taiwan switching menu absent','\\u6539\\u7528\\u53f0\\u7063' not in (d/'WideDirect$Pane.smali').read_text())
check('navigation exit never kills host',not any('->killProcess(' in p.read_text() or 'Ljava/lang/System;->exit(' in p.read_text() for p in r.glob('smali*/com/navdashn/**/*.smali')))
check('integrated Google client separate port','127.0.0.1:5003' in (d/'WideGoogleNav.smali').read_text())
server=next(r.glob('smali*/com/navdashn/navigation/NavService.smali')).read_text();check('integrated Google server separate port','0x138b' in server and '0x138a' not in server)
check('virtual display launches Google component', 'com.jixiexiaoge.drivingassist.wide/com.navdashn.KeyEntryActivity' in (r/'smali/com/navipilot/amap2tesla/privileged/PrivilegedDisplayService.smali').read_text())
check('legacy Google selection migrates','cp_source_restored' in (d/'WideVariant$Navigation.smali').read_text())
for x in app.findall('activity'):
 if x.get(A+'name','').startswith('com.navdashn.'):
  check('separate Google task '+x.get(A+'name'),x.get(A+'taskAffinity')=='com.jixiexiaoge.drivingassist.wide.google')
out={'passed':len(checks),'checks':checks,'androidDeviceTest':False,'c4ReceptionTest':False,'googleKeyValidation':False,'projectionDeviceTest':False}
(r.parent/'audit.json').write_text(json.dumps(out,ensure_ascii=False,indent=2));print(json.dumps(out,ensure_ascii=False))
