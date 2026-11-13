"""Offline compatibility, real pinned C4 conversion/control methods; no network or road test."""
import ast,sys,json,importlib.util
from pathlib import Path
c4=Path(sys.argv[1]); fixtures=Path(sys.argv[2])
def module(name,path):
 spec=importlib.util.spec_from_file_location(name,path);m=importlib.util.module_from_spec(spec);sys.modules[name]=m;spec.loader.exec_module(m);return m
cereal=module('pinned_cereal',c4/'carrot_navi_cereal.py');control=module('pinned_control',c4/'carrot_navi_control.py')
tree=ast.parse((c4/'carrot_serv.py').read_text())
methods=[n for n in ast.walk(tree) if isinstance(n,ast.FunctionDef) and n.name in ['_update_tbt','_apply_carrot_navi_guidance']]
assert len(methods)==2
space={'CarrotNaviControl':control.CarrotNaviControl};exec(compile(ast.Module(body=methods,type_ignores=[]),'<pinned C4 methods>','exec'),space)
class State:pass
State._update_tbt=space['_update_tbt'];State.apply=space['_apply_carrot_navi_guidance']
expected={3:2,2:1,8:7,9:0,999:-1,100:-1};rows=[]
for seq,line in enumerate(fixtures.read_text().splitlines(),1):
 f=json.loads(line);items={}
 for key,v in [('guidance_current',f['guidance']),('navigation_status',f['status'])]:
  items[key]={'present':v is not None,'sequence':seq,'value':v,'received_mono_ns':1000000000,'source_timestamp_ms':1700000000000}
 payload=cereal.build_carrot_navi_payload({'connected':True,'session_id':'offline-check','items':items},1000000000)
 n=control.parse_carrot_navi_control(payload);assert n is not None
 state=State();state.carrot_navi_current_sequence=state.carrot_navi_next_sequence=-1;state.xDistToTurn=state.xDistToTurnNext=0
 state.apply(n,force=True);assert state.xTurnInfo==expected[f['icon']]
 if f['icon'] in [3,2,8]:assert state.xDistToTurn==f['guidance']['distance_m']
 assert not n.speed.present and not n.route.present and not n.traffic.present
 rows.append({'inputIcon':f['icon'],'carrotTurn':state.xTurnInfo,'distance':state.xDistToTurn,'guidancePresent':n.current.present})
print(json.dumps({'result':'passed','cases':rows,'boundary':'Synthetic inputs through pinned C4 conversion and guidance methods; not real-device delivery or steering validation'},ensure_ascii=False,indent=2))
