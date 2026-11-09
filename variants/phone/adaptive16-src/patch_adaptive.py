from pathlib import Path
import shutil,re,sys

flavor=sys.argv[1]
assert flavor in ('auto','phone')
root=Path(__file__).resolve().parent.parent
build=root/'adaptive16-build'/flavor
base=build/'baseline';out=build/'patched'
assert not out.exists(),out
shutil.copytree(base,out,ignore=lambda d,n:[x for x in n if Path(d)==base and x in ('build','dist')])
sm=out/'smali/com/navipilot/obf'
prefixes=('WideGeometry','WideLayout','WideSettings','WideDivider','WideDirect','WideInsets','WideVariant')
for p in sm.glob('Wide*.smali'):
 if p.name.startswith(prefixes):p.unlink()
for p in (build/'helper-decoded/smali/com/navipilot/obf').glob('Wide*.smali'):shutil.copy(p,sm/p.name)
# Keep the watchdog instruction-for-instruction identical to the installed baseline.
def method(s,sig):
 m=re.search(r'^\.method [^\n]* '+re.escape(sig)+r'\n.*?^\.end method',s,re.M|re.S);assert m,sig
 return m.group()
p=sm/'WideGeometry.smali';s=p.read_text();sig='reconnect(ZZJJJZ)Z'
s=s.replace(method(s,sig),method((base/'smali/com/navipilot/obf/WideGeometry.smali').read_text(),sig));p.write_text(s)

p=sm/'XN.smali';s=p.read_text()
def replace(before,after):
 global s
 assert s.count(before)==1,(before[:160],s.count(before))
 s=s.replace(before,after)
# Switch the outer measure policy; the same map/Shield AndroidViews remain in place.
before='''    sget-object v11, Lcom/navipilot/obf/S3;->n:Lcom/navipilot/obf/Wa;

    const/16 v12, 0x36

    invoke-static {v10, v11, v4, v12}, Lcom/navipilot/obf/QQ;->b(Lcom/navipilot/obf/c9;Lcom/navipilot/obf/Wa;Lcom/navipilot/obf/Hh;I)Lcom/navipilot/obf/SQ;

    move-result-object v10'''
after='''    const/16 v12, 0x36
    invoke-static {}, Lcom/navipilot/obf/WideLayout;->portrait()Z
    move-result v11
    if-eqz v11, :adaptive_row
    sget-object v11, Lcom/navipilot/obf/S3;->q:Lcom/navipilot/obf/Va;
    invoke-static {v10, v11, v4, v12}, Lcom/navipilot/obf/fg;->a(Lcom/navipilot/obf/f9;Lcom/navipilot/obf/Va;Lcom/navipilot/obf/Hh;I)Lcom/navipilot/obf/gg;
    move-result-object v10
    goto :adaptive_policy_done
    :adaptive_row
    sget-object v11, Lcom/navipilot/obf/S3;->n:Lcom/navipilot/obf/Wa;
    invoke-static {v10, v11, v4, v12}, Lcom/navipilot/obf/QQ;->b(Lcom/navipilot/obf/c9;Lcom/navipilot/obf/Wa;Lcom/navipilot/obf/Hh;I)Lcom/navipilot/obf/SQ;
    move-result-object v10
    :adaptive_policy_done'''
replace(before,after)
replace('invoke-static {v7}, Lcom/navipilot/obf/hg;->b(Lcom/navipilot/obf/VE;)Lcom/navipilot/obf/VE;',
        'invoke-static {v7}, Lcom/navipilot/obf/WideLayout;->sidePane(Lcom/navipilot/obf/VE;)Lcom/navipilot/obf/VE;')
# Do not compose zero-sized controls. Retain the original callable and callbacks.
replace('''    if-eqz v7, :cond_18

    invoke-virtual {v6, v1, v0}''','''    if-eqz v7, :cond_18
    invoke-static {}, Lcom/navipilot/obf/WideLayout;->controlsVisible()Z
    move-result v5
    if-eqz v5, :cond_18

    invoke-virtual {v6, v1, v0}''')
p.write_text(s)
p=out/'apktool.yml';s=p.read_text();s=re.sub(r'versionCode: \d+','versionCode: 26110728',s);s=re.sub(r'versionName: [^\n]+','versionName: 9.3.1-wide.16-'+flavor+'-adaptive',s);p.write_text(s)
p=out/'AndroidManifest.xml';s=p.read_text()
needle='android:name="com.jixiexiaoge.drivingassist.MainActivity"';assert s.count(needle)==1
s=s.replace(needle,needle+' android:resizeableActivity="true"');p.write_text(s)
print('Patched adaptive layout:',flavor)
