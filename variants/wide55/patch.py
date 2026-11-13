"""Hash-pinned wide54 overlay. Preserve existing UI, Link capture and all unrelated classes."""
from pathlib import Path
import re,sys
root=Path(sys.argv[1]); d=root/'smali/com/navipilot/obf'
def once(s,a,b):
 assert s.count(a)==1,(a,s.count(a))
 return s.replace(a,b,1)
def method(s,name,fn):
 p=re.compile(r'(?ms)^\.method [^\n]* '+re.escape(name)+r'\n.*?^\.end method')
 m=list(p.finditer(s));assert len(m)==1,name
 return s[:m[0].start()]+fn(m[0].group())+s[m[0].end():]
p=d/'WideAmapLinkIntegration.smali';s=p.read_text()
s+='''
.method public static phoneSelected()Z
    .locals 2
    const-string v0, "com.autonavi.minimap"
    sget-object v1, Lcom/navipilot/obf/WideAmapLinkIntegration;->selected:Ljava/lang/String;
    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    return v0
.end method

.method public static attachSender(Lcom/navipilot/obf/MG;)V
    .locals 1
    new-instance v0, Ljava/lang/ref/WeakReference;
    invoke-direct {v0, p0}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V
    sput-object v0, Lcom/navipilot/obf/WideAmapLinkIntegration;->bridge:Ljava/lang/ref/WeakReference;
    sget-object v0, Lcom/navipilot/obf/WideAmapLinkIntegration;->current:Lcom/navipilot/obf/WideAmapLinkIntegration;
    if-eqz v0, :done
    invoke-direct {v0}, Lcom/navipilot/obf/WideAmapLinkIntegration;->publish()V
    :done
    return-void
.end method
'''
def status(m):
 # Append before the existing final StringBuilder conversion; preserve all original diagnostics.
 a='    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;'
 b='    invoke-static {}, Lcom/navipilot/obf/WideLinkDelivery;->status()Ljava/lang/String;\n    move-result-object v4\n    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;\n\n'+a
 return once(m,a,b)
s=method(s,'status()Ljava/lang/String;',status)
s=method(s,'select(Ljava/lang/String;)V',lambda m:once(m,'    .locals 5','    .locals 5\n\n    invoke-static {}, Lcom/navipilot/obf/WideLinkDelivery;->reset()V'))
p.write_text(s)
p=d/'MG.smali';s=p.read_text()
def send(m):
 m=once(m,'Lcom/navipilot/obf/WideAmapSource;->filter(', 'Lcom/navipilot/obf/WideLinkDelivery;->route(')
 def diag(label):
  return '    const-string v2, "'+label+'"\n    invoke-static {v8, v9, v2}, Lcom/navipilot/obf/WideLinkDelivery;->result(Ljava/lang/String;Lorg/json/JSONObject;Ljava/lang/String;)V\n'
 # v2 is scratch here; it is initialized again before the original algorithm needs it.
 m=once(m,'    move-object/16 p2, v9','    move-object/16 p2, v9\n\n'+diag('開始交付'))
 m=once(m,'    if-eqz v1, :cond_15','    if-nez v1, :wide55_manifest_ok\n'+diag('尚無此資料流訂閱')+'    return-void\n    :wide55_manifest_ok')
 m=once(m,'    goto/16 :goto_d',diag('資料流未啟用')+'    goto/16 :goto_d')
 m=once(m,'    :cond_10\n    if-nez v15, :cond_11','    :cond_10\n    if-nez v15, :cond_11')
 m=once(m,'    if-nez v22, :cond_11\n\n    return-void','    if-nez v22, :cond_11\n\n'+diag('內容未變更，等待心跳')+'    return-void')
 m=once(m,'    if-gez v1, :cond_12\n\n    return-void','    if-gez v1, :cond_12\n\n'+diag('等待訂閱的傳送間隔')+'    return-void')
 m=once(m,'    if-eqz v0, :cond_15','    if-nez v0, :wide55_queue_ok\n'+diag('傳送佇列未接受：檢查連線及資料流通道')+'    return-void\n    :wide55_queue_ok\n'+diag('已交給傳送佇列'))
 return m
s=method(s,'b(Ljava/lang/String;Lorg/json/JSONObject;Ljava/lang/String;)V',send);p.write_text(s)
p=d/'TB.smali';s=p.read_text()
a='    monitor-exit v0\n\n    iget-object v0, p0, Lcom/navipilot/obf/TB;->k:Lcom/navipilot/obf/MG;'
s=once(s,a,'    monitor-exit v0\n\n    invoke-static {v0}, Lcom/navipilot/obf/WideAmapLinkIntegration;->attachSender(Lcom/navipilot/obf/MG;)V\n\n    iget-object v0, p0, Lcom/navipilot/obf/TB;->k:Lcom/navipilot/obf/MG;');p.write_text(s)
p=root/'apktool.yml';s=p.read_text();s=re.sub(r'(?m)^  versionCode: .*','  versionCode: 26110767',s);s=re.sub(r'(?m)^  versionName: .*','  versionName: 9.3.1-wide.55-link-delivery',s);p.write_text(s)
for name in ['Yg.smali','WideBrand.smali']:
 p=d/name
 if p.exists():p.write_text(p.read_text().replace('9.3.1-wide.54-carrot-bridge','9.3.1-wide.55-link-delivery').replace('26110766','26110767').replace('wide.54','wide.55'))
print('wide55 sender hooks applied')
