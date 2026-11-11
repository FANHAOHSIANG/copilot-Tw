import json,csv,collections,pathlib,html
P=pathlib.Path(__file__).parent
rows=json.load(open(P/'inventory.json'));runs=list(csv.DictReader(open(P/'replay.tsv'),delimiter='\t'));by=collections.defaultdict(list)
for run in runs:
 for k in ['direction','samples','startDistance','hits','firstAlertM','reverseFalseHits']:run[k]=int(run[k])
 by[run['id']].append(run)
labels={'unmapped':'未進入提醒配對','pass':'已配對方向回放通過','partial':'部分方向未觸發','insufficient':'可用回放路徑不足','miss':'同向回放未觸發','reverse':'反向回放異常待查'}
counts=collections.Counter()
for row in rows:
 tests=by[row['id']];row['tests']=tests
 if not row['mapped']:status='unmapped'
 elif any(x['reverseFalseHits'] for x in tests):status='reverse'
 elif all(x['hits'] for x in tests):status='pass'
 elif any(x['hits'] for x in tests):status='partial'
 elif any(x['samples']<3 for x in tests):status='insufficient'
 else:status='miss'
 row['status']=status;row['statusLabel']=labels[status];counts[status]+=1
 row['firstAlertM']=[x['firstAlertM'] for x in tests if x['hits']]
 row['directionCoverageIncomplete']=row['mapped'] and len(row['bearings'])>len(row['mappedDirections'])
 issues=[]
 if not row['bearings']:issues.append('來源沒有可解析方向')
 if not row['limitValid']:issues.append('速限不確定或無效')
 if row['directionCoverageIncomplete']:issues.append('來源雙向，但配對清單只有一向')
 if '雙向' in row['road'] and len(row['bearings'])==1:issues.append('路名提及雙向，但方向欄位只列一向，待核對')
 if row.get('nearestRoadOffsetM',0)>30:issues.append('距最近圖資道路超過30m')
 if status=='unmapped':issues.append('目前版本未選入正式提醒清單，無法以此點產生台灣固定測速提醒')
 if status=='insufficient':issues.append('按唯一同名道路回溯後，不足3個有效取樣。不能當成實車必定漏報的證據')
 if status=='miss':issues.append('已建立至少3個取樣，仍未選到此相機；需核對路口歧義／其他相機優先')
 if status=='reverse':issues.append('反向合成軌跡仍選到此相機，需排查迴轉拓撲、道路誤配與測試路徑；不列為通過')
 row['issues']=issues
summary={'version':'wide.37','date':'2026-11-11','totalPoints':len(rows),'mappedPoints':sum(x['mapped'] for x in rows),'counts':dict(counts),'directionalRuns':len(runs),'directionalRunsAlerted':sum(x['hits']>0 for x in runs),'directionalRunsNoAlert':sum(x['hits']==0 for x in runs),'reverseAnomalyPoints':counts['reverse'],'incompleteDirectionMappings':sum(x['directionCoverageIncomplete'] for x in rows),'noParseableDirection':sum(not x['bearings'] for x in rows),'uncertainOrInvalidLimits':sum(not x['limitValid'] for x in rows),'firstAlertDistribution':dict(collections.Counter('900–1000m' if x['firstAlertM']>=900 else '500–899m' if x['firstAlertM']>=500 else '20–499m' if x['hits'] else '未觸發' for x in runs)),'scope':'All 1856 bundled fixed cameras inventoried. All 487 registered IDs evaluated in 539 directional synthetic geometry-generated cases with dynamic 3x3 tile windows, original Tracker plus wide.37 display helper. Unmapped points have structural exclusion evidence, not successful runtime tests. No independent physical site validation, real GPS logs, installed-device UI/audio or C4 adoption test. Sections and Amap notices excluded.','conditions':{'gpsAccuracyM':9,'gpsLateralOffsetM':0,'sampleIntervalMs':1000,'speedMps':'min(20,max(5,limitKph/3.6*0.8))','maxGeneratedApproachM':1200,'minGeneratedDistanceM':30,'voiceTargetThresholdM':1000,'followOnlyUniqueNamedPredecessors':True},'apkSha256':json.load(open(P/'apk-verification.json'))['apkSha256']}
(P/'summary.json').write_text(json.dumps(summary,ensure_ascii=False,indent=2))
(P/'all-points.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2))
(P/'anomalies.json').write_text(json.dumps([r for r in rows if r['status'] in ('reverse','miss','partial','insufficient')],ensure_ascii=False,indent=2))
with open(P/'all-status.tsv','w') as f:
 f.write('id\tstatus\tfirst_alert_m\tdirection_incomplete\n')
 for r in rows:f.write(r['id']+'\t'+r['status']+'\t'+','.join(map(str,r['firstAlertM']))+'\t'+str(r['directionCoverageIncomplete'])+'\n')
content='''<!doctype html><html lang="zh-Hant"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Copilot tw 全台固定測速離線驗證</title><style>
body{font-family:system-ui,"Noto Sans TC",sans-serif;background:#eef2f6;color:#182738;margin:0}main{max-width:1280px;margin:auto;padding:28px}h1{font-size:30px;margin:8px 0}header{background:#162c40;color:white;padding:28px;border-radius:16px}.lead{color:#bed5e8;line-height:1.8}section{background:white;padding:20px;border-radius:12px;margin:18px 0;line-height:1.75}.cards{display:grid;grid-template-columns:repeat(auto-fit,minmax(150px,1fr));gap:10px;margin-top:20px}.card{padding:14px;background:#ffffff12;border-radius:10px}.num{font-size:30px;font-weight:800;display:block}.label{font-size:13px}input,select{padding:12px;border:1px solid #b7c5d0;border-radius:8px;font-size:16px;max-width:100%;margin:4px}.scroll{overflow:auto}table{width:100%;border-collapse:collapse;font-size:14px}th,td{padding:12px;text-align:left;border-bottom:1px solid #e1e6ea;vertical-align:top}th{background:#edf3f8;white-space:nowrap}small{display:block;color:#617184}.tag{border-radius:6px;padding:4px 6px;background:#f3e4d7;white-space:nowrap}.pass{background:#d9ede7}.reverse,.miss{background:#f7dddd}details{min-width:220px}summary{cursor:pointer}footer{color:#617184;margin-top:18px}a{color:#176bb4}code{word-break:break-all}button{padding:10px;border:0;border-radius:8px;background:#176bb4;color:white;cursor:pointer}</style><main><header><div>COPILOT TW · wide.37 · 2026-11-11</div><h1>全台 1856 個固定測速點逐點檢查</h1><p class="lead">完整清單檢查 + 已配對點的道路幾何模擬回放。這是軟體離線驗證，不是實車通過證明，也不代表已核實每支相機的實際位置、方向或運作狀態。</p><div class="cards" id="cards"></div></header>
<section><strong>怎麼解讀結果</strong><p>未配對的 1369 點不會由目前的台灣固定點提醒流程選中。有配對的 487 點按配對方向展開成 539 組案例，使用與 wide.37 相同的 Java 配對、追蹤與顯示目標程式。每秒取樣、GPS 精度 9 公尺、定位在道路中心，車速取速限的 80%，最低 5、最高 20 m/s。最遠從相機前 1200 公尺建立軌跡。</p><p>「已配對方向回放通過」表示本次合成定位可形成 1 公里內提醒目標，不表示音效已在車機播放。原資料雙向但僅配對一向的點會另外標記。「路徑不足」表示回溯遇到無法確認的路口／路名或道路段太短，不能直接宣稱實車一定失敗。反向異常需排查道路選擇、迴轉拓撲及測試路徑。</p><p><strong>重要限制</strong> 未涵蓋真實 GPS 飄移、隧道、裝置權限、背景服務、音訊播放、C4 實際採用。未驗證區間測速與高德獨立提醒。本次未修改 APK。原始相機資料快照為 2026-11-09，OSM 為 2026-11-08。</p><div id="ranges"></div></section>
<section><label>搜尋路名、縣市或識別碼 <input id="q" placeholder="例如 國道一號、台北、竹北"></label><select id="status"><option value="">全部結果</option></select><select id="city"><option value="">全部縣市／國道</option></select><p id="count"></p><div class="scroll"><table><thead><tr><th>路段／方向</th><th>速限</th><th>檢查結果</th><th>首次提醒距離</th><th>診斷與回放細節</th></tr></thead><tbody id="tbody"></tbody></table></div><button id="more">顯示更多</button></section><footer>來源　警政署測速執法設置點／政府資料開放授權條款第1版。道路幾何 © OpenStreetMap contributors / ODbL 1.0。<br>APK SHA-256　<code id="sha"></code></footer></main><script>const DATA=__DATA__,STATS=__STATS__,LABELS=__LABELS__;
const esc=v=>String(v??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
let limit=100;const $=id=>document.getElementById(id);
$('cards').innerHTML=Object.entries(LABELS).map(([s,l])=>`<div class="card"><span class="num">${STATS.counts[s]||0}</span><span class="label">${l}</span></div>`).join('');
$('status').innerHTML+=Object.entries(LABELS).map(([s,l])=>`<option value="${s}">${l}</option>`).join('');
$('city').innerHTML+=[...new Set(DATA.map(r=>r.city))].sort().map(c=>`<option>${esc(c)}</option>`).join('');
$('sha').textContent=STATS.apkSha256;
$('ranges').innerHTML='<strong>539 組方向案例的首次觸發距離</strong><p>'+Object.entries(STATS.firstAlertDistribution).map(([k,v])=>`${esc(k)}：${v} 組`).join(' ／ ')+'</p><small>距離受前方可確認路徑長度影響，不能將「門檻 1 公里」解讀成每點都能提前 1 公里提醒。6 個點的原資料雙向但目前僅配對一向。</small>';
function render(){let q=$('q').value.trim().toLowerCase(),status=$('status').value,city=$('city').value;const found=DATA.filter(r=>(!status||r.status===status)&&(!city||r.city===city)&&(!q||(r.road+' '+r.city+' '+r.id+' '+r.direction).toLowerCase().includes(q)));$('count').textContent=`符合 ${found.length} 點，顯示 ${Math.min(found.length,limit)} 點`;$('tbody').innerHTML=found.slice(0,limit).map(r=>`<tr><td><strong>${esc(r.road)}</strong><small>${esc(r.city)} · ${esc(r.direction)}<br>${esc(r.id)}<br>${r.lat}, ${r.lon}</small></td><td>${r.limit||'未知'}<small>km/h</small></td><td><span class="tag ${r.status}">${esc(r.statusLabel)}</span>${r.directionCoverageIncomplete?'<small>⚠ 雙向資料僅配對一向</small>':''}</td><td>${r.firstAlertM.length?r.firstAlertM.map(x=>x+' m').join(' / '):'—'}</td><td><details><summary>${r.issues.length?esc(r.issues[0]):'查看配對與測試'}</summary><p>${r.issues.map(esc).join('<br>')||'本次已配對方向回放可觸發提醒目標。'}</p><small>最近圖資道路距離 ${r.nearestRoadOffsetM??'未知'} m<br>配對道路 ${esc(r.mappedEdge||'無')}</small>${r.tests.map(t=>`<p>方向 ${t.direction}：${t.samples} 次取樣，起始 ${t.startDistance} m，目標觸發 ${t.hits} 次，反向異常 ${t.reverseFalseHits} 次。<br>${esc(t.lastOriginalReason)} ${esc(t.otherCameraSelected)}</p>`).join('')}</details></td></tr>`).join('');$('more').hidden=found.length<=limit;}
for(let id of ['q','status','city'])$(id).addEventListener('input',()=>{limit=100;render()});$('more').onclick=()=>{limit+=100;render()};render();</script></html>'''
content=content.replace('__DATA__',json.dumps(rows,ensure_ascii=False).replace('</','<\\/')).replace('__STATS__',json.dumps(summary,ensure_ascii=False)).replace('__LABELS__',json.dumps(labels,ensure_ascii=False))
(P/'Copilot-tw-wide37-all-camera-audit.html').write_text(content)
print(json.dumps(summary,ensure_ascii=False,indent=2))
