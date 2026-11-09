import sys,json,ast
from pathlib import Path
sys.path.insert(0,'work/receiver')
from carrot_navi_cereal import build_carrot_navi_payload
from carrot_navi_control import parse_carrot_navi_control
from carrot_navi import CarrotNaviReceiver,CATALOG
wire=json.loads(Path('work/build/hcop-wire.json').read_text())
base={'generation':1,'session_id':'hcop-test','connected':True,'items':{'speed':{'present':True,'sequence':12,'source_timestamp_ms':1000,'received_mono_ns':2000000,'value':wire},'guidance_current':{'present':True,'sequence':8,'value':{'distance_m':321,'turn_type':2,'main_text':'右轉'}},'navigation_status':{'present':True,'sequence':9,'value':{'guidance_active':True,'off_route':False}}}}
root=ast.parse(Path('work/receiver/carrot_serv.py').read_text());method=next(m for cls in root.body if isinstance(cls,ast.ClassDef) for m in cls.body if isinstance(m,ast.FunctionDef) and m.name=='_apply_carrot_navi_speed')
ns={'CarrotNaviControl':object};exec(compile(ast.Module(body=[method],type_ignores=[]),'actual_carrot_serv.py','exec'),ns)
class R:
 def _update_sdi(self):pass
 def _clear_rear_camera_events(self):pass
r=R();n=parse_carrot_navi_control(build_carrot_navi_payload(base));ns['_apply_carrot_navi_speed'](r,n)
assert r.nRoadLimitSpeed==50 and r.nSdiSpeedLimit==60 and r.nSdiDist==445
assert n.current.distance_m==321
base['items']['speed']['value']={'road_limit_kph':70};n=parse_carrot_navi_control(build_carrot_navi_payload(base));ns['_apply_carrot_navi_speed'](r,n)
assert r.nRoadLimitSpeed==70 and r.nSdiType==-1 and r.nSdiSpeedLimit==0 and r.carrot_navi_road_limit_valid
base['items']['speed']['value']={'current_kph':40};n=parse_carrot_navi_control(build_carrot_navi_payload(base));ns['_apply_carrot_navi_speed'](r,n)
assert not r.carrot_navi_road_limit_valid and not n.speed.sdi_present
base['items']['speed']['value']=wire;base['items']['navigation_status']['value']['off_route']=True
assert not parse_carrot_navi_control(build_carrot_navi_payload(base)).speed.sdi_present
receiver=CarrotNaviReceiver();manifest=receiver.negotiate({'type':'requirements_query','protocol_version':2,'catalog_revision':1,'streams':[{'kind':k,'name':n,'schema_version':1} for k,n in CATALOG]},'hcop-test');receiver._control_connections=1
stream=next(s for s in manifest['streams'] if s['kind']=='json' and s['name']=='speed')
for seq,value in [(1,wire),(2,{'road_limit_kph':70})]:
 envelope={'type':'item_update','protocol_version':2,'session_id':manifest['session_id'],'kind':'json','name':'speed','manifest_revision':manifest['revision'],'stream_handle':stream['stream_handle'],'schema_version':1,'sequence':seq,'source_timestamp_ms':1000,'sent_at_ms':1000,'present':True,'value':value}
 receiver.record_json(manifest['session_id'],'speed',envelope,'127.0.0.1');health=receiver.health();assert health['items']['json:speed']['sequence']==seq and health['items']['json:speed']['value']==value
print('PASS actual current test-branch receiver: road+camera, road-only, withdrawal validity, turn preservation, off-route, negotiation and health schema')
