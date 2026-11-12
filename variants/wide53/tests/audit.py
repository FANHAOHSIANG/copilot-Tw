import sys,re,json
from pathlib import Path
r=Path(sys.argv[1]);d=r/'smali/com/navipilot/obf';count=0
def check(ok,msg):
 global count
 count+=1
 assert ok,msg
check('WidePanels;->controls' in (d/'XN.smali').read_text(),'lower pane hook')
md=(d/'MD.smali').read_text();m=re.search(r'\.method public static final b\(.*?\.end method',md,re.S)[0]
check('WidePlaces;->showContext' in m and 'tr;->c()' not in m,'legacy home actions removed')
main=next(r.glob('smali*/com/navdashn/MainActivity.smali')).read_text()
for name in ['favorite','install','resume']:check('WideGoogleUi;->'+name in main,'google hook '+name)
check('Process;->killProcess' not in main,'integrated process survives exit')
check('com.navdashn.HelpActivity' not in (r/'AndroidManifest.xml').read_text(),'removed native keyboard help activity')
for name in ['WideDirect','WideProjectionHelp','WideViewport','WideReconnectPolicy','WideGoogleUi','WidePlaces','WidePanels','WideDiagnostics']:
 check((d/(name+'.smali')).exists(),name)
for name in ['WideGoogleAdapter','WideAmapInput','WideTelemetry','WideVehiclePanel']:
 check((d/(name+'.smali')).exists(),'preserve '+name)
bridge=(d/'WideBridge.smali').read_text();check('return-object p1' in bridge,'Taiwan override remains disabled')
check(not list((r/'assets').glob('tw_*')),'no Taiwan data restored')
check('WideLaunch;->execute' in (r/'smali/com/navipilot/amap2tesla/privileged/PrivilegedDisplayService.smali').read_text(),'intent routed to owned display')
# User-facing legacy headings must be gone, not merely new headings added.
for p in d.glob('*.smali'):
 for m in re.finditer(r'const-string[^\n]*?, ("(?:\\.|[^"\\])*")',p.read_text()):
  try:text=json.loads(m[1])
  except:continue
  assert text not in ('車機連線','車機連接','高德投屏','高德車機版投屏'),(p,text)
check(True,'legacy headings renamed')
print('PASS',count,'APK wiring checks')
