"""Build offline enforcement layer from pinned official snapshots. No geocoding guesses."""
import csv, io, json, re, hashlib, math, unicodedata, datetime
from collections import Counter, defaultdict
from pathlib import Path
ROOT = Path(__file__).resolve().parents[2]
DATA = ROOT / 'data/enforcement'
REGIONS = '臺北市 新北市 桃園市 臺中市 臺南市 高雄市 基隆市 新竹市 嘉義市 新竹縣 苗栗縣 彰化縣 南投縣 雲林縣 嘉義縣 屏東縣 宜蘭縣 花蓮縣 臺東縣 澎湖縣 金門縣 連江縣'.split()
def clean(v): return re.sub(r'\s+', '', unicodedata.normalize('NFKC',str(v or ''))).lstrip('\ufeff')
def decode(b):
    try: return b.decode('utf-8-sig').lstrip('\ufeff')
    except UnicodeDecodeError: return b.decode('cp950')
def field(row, *names):
    for name in names:
        for k,v in row.items():
            if clean(k)==name: return clean(v)
    return ''
def number(v):
    try: return float(v)
    except (ValueError,TypeError): return None
def coords(lat,lon):
    a,b=number(lat),number(lon)
    if a is None or b is None: return None, ['missing_or_ambiguous_coordinates']
    if 118<=a<=123 and 21<=b<=27: return [a,b], ['coordinate_columns_swapped']
    if 21<=a<=27 and 118<=b<=123: return [b,a], []
    return None,['coordinates_out_of_bounds']
RULES = [('section_speed','區間|平均速率'),('speed','測速|超速'),('red_light','闖紅燈'),('pedestrian','行人|車不讓人'),('parking','停車|停放|違停'),('restricted_vehicle','禁行|禁駛|限制車種'),('lane_signal','標誌|標線|號誌|跨線|跨越|車道'),('turn','轉彎|左轉|右轉|迴轉|違左'),('wrong_way','逆向'),('following_distance','安距|安全距離'),('weighing','過磅')]
def normalize(source, row, locator):
    place=field(row,'設置地點（路口或路段）','設置地點(路口或路段)','設置地點_路口或路段','設置地點','設置位置','地點','測照地點','路段','地點及路名')
    if not place: return None
    rawitem=field(row,'取締項目','取締項目(以"、"分隔)','測照型式','設備型式','違規偵測項目')
    kind=field(row,'科技執法種類','設備型式')
    flags=[]
    if rawitem==place: flags.append('violation_field_contains_address'); rawitem=''
    categories=[key for key,pattern in RULES if re.search(pattern,rawitem+' '+kind)]
    if not categories: categories=['unspecified'];flags.append('violation_unspecified')
    lat=field(row,'座標緯度','緯度','座標緯(N)度');lon=field(row,'座標經度','經度','座標經(E)度')
    if not lat and not lon:
        combined=field(row,'經緯度','座標','備註(座標)')
        nums=re.findall(r'\d{2,3}\.\d+', combined)
        if len(nums)==2: lat,lon=nums
    point,cf=coords(lat,lon);flags+=cf
    direction=field(row,'拍攝方向','測照方向','測照行向','拍攝行向')
    # Cardinal arrows refer to vehicle travel only where source is explicit; do not guess from bidirectional.
    bearings={'南向北':0,'北向南':180,'西向東':90,'東向西':270,'東南向西北':315,'西北向東南':135,'東北向西南':225,'西南向東北':45}.get(direction)
    limit=field(row,'速限','速限(km/hr)');limitnum=number(limit)
    if limitnum is None or not 10<=limitnum<=130: limitnum=None
    active=field(row,'啟用日期','開始執法日期')
    date=None
    m=re.fullmatch(r'(\d{3,4})[-年/.](\d{1,2})[-月/.](\d{1,2})日?', active)
    if m:
        y,mo,d=map(int,m.groups())
        try:date=datetime.date(y+1911 if y<1911 else y,mo,d).isoformat()
        except ValueError:flags.append('invalid_activation_date')
    status='announced' # not proof of operation today
    if date and date>source['checkedDate']:status='planned';flags.append('future_activation')
    identity=json.dumps([source['id'],row],ensure_ascii=False,sort_keys=True)
    return dict(id=source['id']+'-'+hashlib.sha256(identity.encode()).hexdigest()[:16],sourceId=source['id'],sourceLocator=locator,region=source['region'],district=field(row,'行政區'),location=place,categories=categories,violationText=rawitem,kind=kind,coordinates=point,geometryRole='reference_only' if 'section_speed' in categories else 'site',directionText=direction,travelBearing=bearings,speedLimitKph=limitnum,speedLimitText=limit,activationDate=date,activationText=field(row,'啟用時間','啟用民國日期'),status=status,vehicleRestrictionText=rawitem if 'restricted_vehicle' in categories else None,qualityFlags=flags,roadMatch=None,preciseAlertReady=False,raw=row)

def pdf_rows(path, rejects):
    import pdfplumber
    header=None;lastplace=None
    with pdfplumber.open(path) as pdf:
        for pi,page in enumerate(pdf.pages,1):
            for ti,table in enumerate(page.extract_tables(),1):
                for ri,raw in enumerate(table,1):
                    locator=f'page:{pi}/table:{ti}/row:{ri}'
                    cells=list(raw)
                    # Expanded PDF grid contains merged columns; collapse only exact 3-column subdivisions.
                    if len(cells) in (18,27) and all(cells[i] is None for i in range(len(cells)) if i%3): cells=cells[::3]
                    while cells and cells[-1] is None:cells.pop()
                    vals=[clean(v) for v in cells]
                    if any(v in ('設置地點','設置位置','地點','測照地點','路段','地點及路名') for v in vals):
                        header=vals;lastplace=None;continue
                    if header and len(vals)<len(header):vals+=['']*(len(header)-len(vals))
                    if not header or len(vals)!=len(header):
                        if any(vals): rejects.append({'sourceId':path.stem,'locator':locator,'reason':'title_or_unrecognized_table_shape','cells':raw})
                        continue
                    if sum(bool(v) for v in vals)<=1:continue
                    # Repeated merged headings for coordinates in the section table.
                    hs=list(header)
                    if path.stem=='kaohsiung-pdf' and pi==19 and len(hs)==7:hs[-2:]=['緯度','經度']
                    row={}
                    key=''
                    for ci,(h,v) in enumerate(zip(hs,vals)):
                        if h in ('經緯度','座標','備註(座標)'):
                            v=str(cells[ci] or '').replace('\n',',').replace(' ', '')
                        if h:key=h
                        if key and v:row[key]=row.get(key,'')+v
                    place=field(row,'設置地點','設置位置','地點','測照地點','路段','地點及路名')
                    if place:lastplace=place
                    elif lastplace and cells[1] is None:
                        # Actual vertically merged cell, not empty data: retain its parent address.
                        row[next(h for h in hs if h in ('設置地點','設置位置','地點','測照地點','路段','地點及路名'))]=lastplace
                    else:
                        rejects.append({'sourceId':path.stem,'locator':locator,'reason':'missing_location','cells':raw});continue
                    yield row,locator

def build():
    sources=json.loads((ROOT/'tools/enforcement/sources.json').read_text())
    records=[];rejects=[];status=[]
    for source in sources:
        path=DATA/'raw'/f"{source['id']}.{source['format']}"
        start=len(records)
        if not path.exists():status.append(dict(sourceId=source['id'],status='download_unavailable',records=0));continue
        try:
            if source['format']=='pdf':
                manual=ROOT/'tools/enforcement/manual'/f"{source['id']}.json"
                if manual.exists():
                    m=json.loads(manual.read_text())
                    if m['sha256']!=hashlib.sha256(path.read_bytes()).hexdigest():raise ValueError('Manual transcription snapshot changed; review required')
                    rows=((r,f'page:2/manual-row:{i}') for i,r in enumerate(m['rows'],1))
                else:rows=pdf_rows(path,rejects)
            else:
                value=decode(path.read_bytes())
                values=list(csv.DictReader(io.StringIO(value))) if source['format']=='csv' else json.loads(value)
                if not isinstance(values,list):raise ValueError('Unsupported JSON envelope; requires explicit adapter')
                rows=((r,f'row:{i}') for i,r in enumerate(values,1))
            for row,locator in rows:
                item=normalize(source,row,locator)
                if item:records.append(item)
                else:rejects.append(dict(sourceId=source['id'],locator=locator,reason='missing_location',raw=row))
            status.append(dict(sourceId=source['id'],status='parsed' if len(records)>start else 'needs_extraction_review',records=len(records)-start))
        except Exception as e:status.append(dict(sourceId=source['id'],status='parse_failed',error=str(e),records=len(records)-start))
    # Exact duplicates only; differing direction/item rows intentionally remain separate.
    records=list({r['id']:r for r in records}.values())
    for r in records:
        key=r['region']+'|'+r['district']+'|'+r['location']
        r['addressGroupId']=hashlib.sha256(key.encode()).hexdigest()[:16]
    for source in sources:
        meta=DATA/'raw'/f"{source['id']}.{source['format']}.provenance.json"
        source['snapshotProvenance']=json.loads(meta.read_text()) if meta.exists() else None
    tiles=defaultdict(list)
    for i,r in enumerate(records):
        if r['coordinates']:
            lon,lat=r['coordinates'];tiles[f'{math.floor(lon*100)}:{math.floor(lat*100)}'].append(i)
    coverage=[]
    for region in REGIONS:
        ss=[s['id'] for s in sources if s['region']==region];rr=[r for r in records if r['region']==region]
        coverage.append(dict(region=region,sources=ss,records=len(rr),located=sum(bool(r['coordinates']) for r in rr),status='partial_snapshot' if rr else 'download_pending' if ss else 'no_verified_source_found'))
    output=dict(schemaVersion=1,snapshotDate='2026-11-12',description='官方公告彙整；不是全台設備完整清單或現況保證',records=records,tileDegrees=.01,tiles=dict(tiles),sources=sources)
    DATA.mkdir(exist_ok=True,parents=True)
    (DATA/'tw_enforcement.json').write_text(json.dumps(output,ensure_ascii=False,separators=(',',':'))+'\n')
    geo=dict(type='FeatureCollection',features=[dict(type='Feature',id=r['id'],geometry=dict(type='Point',coordinates=r['coordinates']),properties={k:v for k,v in r.items() if k not in ('coordinates','raw')}) for r in records if r['coordinates']])
    (DATA/'tw_enforcement.geojson').write_text(json.dumps(geo,ensure_ascii=False,separators=(',',':'))+'\n')
    report=dict(records=len(records),located=len(geo['features']),pendingLocation=len(records)-len(geo['features']),preciseAlertReady=0,coverage=coverage,sourceStatus=status,extractionExceptions=rejects)
    (DATA/'audit.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
    print(json.dumps({k:v for k,v in report.items() if k!='extractionExceptions'},ensure_ascii=False,indent=2))
if __name__=='__main__':build()
