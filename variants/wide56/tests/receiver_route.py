"""Real C4 receiver/converter/route selector with synthetic Link-derived geometry.
No Android runtime, physical C4 or vehicle actuation is involved.
"""
import ast, asyncio, contextlib, importlib.util, io, json, sys, time
from pathlib import Path
from aiohttp import ClientSession
from aiohttp.test_utils import TestServer
c4, fixture_path=map(Path,sys.argv[1:3])
def module(name,filename):
 s=importlib.util.spec_from_file_location(name,c4/filename);m=importlib.util.module_from_spec(s);sys.modules[name]=m;s.loader.exec_module(m);return m
receiver=module('route_receiver','carrot_navi.py');cereal=module('route_cereal','carrot_navi_cereal.py');control=module('route_control','carrot_navi_control.py');source=module('route_source','source.py')
tree=ast.parse((c4/'carrot_serv.py').read_text());methods=[n for n in ast.walk(tree) if isinstance(n,ast.FunctionDef) and n.name in ['_update_tbt','_apply_carrot_navi_guidance']]
space={'CarrotNaviControl':control.CarrotNaviControl};exec(compile(ast.Module(body=methods,type_ignores=[]),'<actual C4 guidance>','exec'),space)
class State:
 _update_tbt=space['_update_tbt'];apply=space['_apply_carrot_navi_guidance']
async def main():
 fixture=json.loads(fixture_path.read_text());model=receiver.CarrotNaviReceiver();names=list(fixture);selector=source.RouteSource();selector.mapbox=((35.,135.),)
 async with TestServer(receiver.create_app(model),host='127.0.0.1') as server, ClientSession() as client:
  ctrl=await client.ws_connect(server.make_url('/api/navi/ws/v2/control/wide56-loopback'))
  await ctrl.send_json(dict(type='requirements_query',protocol_version=2,catalog_revision=1,streams=[dict(kind=k,name=n,schema_version=1) for k,n in receiver.CATALOG]))
  manifest=await ctrl.receive_json(timeout=3);session=manifest['session_id'];streams={s['name']:s for s in manifest['streams'] if s['kind']=='json'}
  sockets={n:await client.ws_connect(server.make_url(f'/api/navi/ws/v2/json/{session}/{n}')) for n in names}
  results=[]
  for seq,values in [(1,fixture),(2,{n:None for n in names})]:
   for name,value in values.items():
    env=dict(type='item_update',protocol_version=2,session_id=session,manifest_revision=manifest['revision'],kind='json',name=name,stream_handle=streams[name]['stream_handle'],schema_version=1,sequence=seq,source_timestamp_ms=receiver.now_ms(),sent_at_ms=receiver.now_ms(),present=value is not None,value=value)
    if value is None:env['reason']='source_absent'
    await sockets[name].send_json(env)
   for _ in range(100):
    snap=model.cereal_snapshot()
    if all(snap['items'].get(n,{}).get('sequence')==seq for n in names):break
    await asyncio.sleep(.01)
   else:raise AssertionError('receiver ingestion timed out')
   payload=cereal.build_carrot_navi_payload(snap,time.monotonic_ns());parsed=control.parse_carrot_navi_control(payload)
   assert parsed is not None
   state=State();state.carrot_navi_current_sequence=state.carrot_navi_next_sequence=-1;state.xDistToTurn=state.xDistToTurnNext=0;state.apply(parsed,force=True)
   route=selector.select(True,parsed)
   if seq==1:
    expected=fixture['route']['polyline'];assert len(route)==len(expected)>256
    assert route[-1]=={'latitude':expected[-1]['lat'],'longitude':expected[-1]['lon']}
    assert state.xDistToTurn==120 and state.xDistToTurnNext==620
    assert state.xTurnInfo==2 and state.xTurnInfoNext==1
    assert not parsed.speed.present
   else:assert route==[] and not parsed.next.present and not parsed.current.present
   results.append(dict(sequence=seq,routePoints=len(route),currentDistance=state.xDistToTurn,nextDistance=state.xDistToTurnNext))
  await sockets['navigation_status'].send_json(env);error=await sockets['navigation_status'].receive_json(timeout=3);assert error['type']=='protocol_error'
  await asyncio.gather(*(s.close() for s in sockets.values()));await ctrl.close()
 # Converter limits: full 4096 survives; 4097 and a bad coordinate reject entire geometry.
 for count,valid in [(4096,True),(4097,False)]:
  pts=[dict(lat=24+i*.000001,lon=121) for i in range(count)]
  snapshot={'connected':True,'items':{'route':{'present':True,'sequence':10,'value':{'polyline':pts}}}}
  payload=cereal.build_carrot_navi_payload(snapshot);parsed=control.parse_carrot_navi_control(payload)
  assert len(parsed.route.polyline)==(count if valid else 0)
  if not valid:assert not parsed.route.present
 for bad in [None,True,'24.5',float('nan'),91]:
  snapshot={'connected':True,'items':{'route':{'present':True,'value':{'polyline':[dict(lat=24,lon=121),dict(lat=bad,lon=121)]}}}}
  payload=cereal.build_carrot_navi_payload(snapshot);assert not payload['route']['meta']['present'] and payload['route']['polyline']==[]
 return dict(result='passed',cases=results,max4096Preserved=True,overBudgetRejected=True,invalidCoordinatesRejected=True,duplicateSequenceRejected=True,noMapboxReplacement=True,physicalC4Validated=False,androidSenderValidated=False)
with contextlib.redirect_stdout(io.StringIO()):report=asyncio.run(main())
print(json.dumps(report,indent=2))
