import sys,json,copy,types,ast
from pathlib import Path
sys.path.insert(0,'bridge-build')
from carrot_navi_cereal import build_carrot_navi_payload
from carrot_navi_control import parse_carrot_navi_control
value=json.loads(Path('bridge-build/merged-test.json').read_text())
base={'generation':1,'session_id':'wide14-test','connected':True,'items':{
 'speed':{'present':True,'sequence':12,'source_timestamp_ms':1000,'received_mono_ns':2000000,'value':value},
 'guidance_current':{'present':True,'sequence':8,'value':{'distance_m':321,'turn_type':2,'main_text':'右轉'}},
 'navigation_status':{'present':True,'sequence':9,'value':{'guidance_active':True,'off_route':False}}
}}
payload=build_carrot_navi_payload(base,publish_mono_ns=3000000)
navi=parse_carrot_navi_control(payload)
assert navi.speed.sdi_present and navi.speed.sdi_type==1
assert navi.speed.sdi_speed_limit_kph==50 and navi.speed.road_limit_kph==60
assert navi.speed.sdi_distance_m==445 and not navi.speed.section_active
assert navi.current.present and navi.current.distance_m==321
# Execute the exact receiver's application method without importing hardware-dependent modules.
root=ast.parse(Path('bridge-build/carrot_serv.py').read_text())
method=next(m for cls in root.body if isinstance(cls,ast.ClassDef) for m in cls.body if isinstance(m,ast.FunctionDef) and m.name=='_apply_carrot_navi_speed')
ns={'CarrotNaviControl':object};exec(compile(ast.Module(body=[method],type_ignores=[]),'actual_carrot_serv.py','exec'),ns)
class Receiver:
 def _update_sdi(self):pass
 def _clear_rear_camera_events(self):pass
r=Receiver()
try:ns['_apply_carrot_navi_speed'](r,navi)
except AttributeError as e:
 print('Receiver fixture needs field:',e);raise
assert r.nSdiSpeedLimit==50 and r.nSdiType==1 and r.nSdiDist==445 and r.nRoadLimitSpeed==60
base['items']['speed']['value']={'road_limit_kph':60}
clear=parse_carrot_navi_control(build_carrot_navi_payload(base))
ns['_apply_carrot_navi_speed'](r,clear)
assert r.nSdiType==-1 and r.nSdiSpeedLimit==0 and r.nSdiDist==0
assert clear.current.distance_m==321
base['items']['speed']['value']=value;base['items']['navigation_status']['value']['off_route']=True
assert not parse_carrot_navi_control(build_carrot_navi_payload(base)).speed.sdi_present
print('PASS actual C4 normalizer, parser, speed application, clear, turn preservation, off-route rejection')
Path('bridge-build/receiver-fixture.json').write_text(json.dumps(payload,ensure_ascii=False,indent=2))
# Real receiver negotiation + record_json path, then health schema consumed by Android.
from carrot_navi import CarrotNaviReceiver,CATALOG
receiver=CarrotNaviReceiver()
manifest=receiver.negotiate({'type':'requirements_query','protocol_version':2,'catalog_revision':1,'streams':[{'kind':k,'name':n,'schema_version':1} for k,n in CATALOG]},'wide14-test')
receiver._control_connections=1
stream=next(s for s in manifest['streams'] if s['kind']=='json' and s['name']=='speed')
envelope={'type':'item_update','protocol_version':2,'session_id':manifest['session_id'],'kind':'json','name':'speed','manifest_revision':manifest['revision'],'stream_handle':stream['stream_handle'],'schema_version':1,'sequence':42,'source_timestamp_ms':1000,'sent_at_ms':1000,'present':True,'value':value}
receiver.record_json(manifest['session_id'],'speed',envelope,'127.0.0.1')
health=receiver.health();assert health['items']['json:speed']['sequence']==42 and health['items']['json:speed']['value']==value
assert health['control_connected'] and health['service']=='carrot_navi_receiver'
Path('bridge-build/health-fixture.json').write_text(json.dumps(health,ensure_ascii=False,indent=2))
print('PASS actual Navi v2 negotiation / wire ingestion / health receipt schema')
