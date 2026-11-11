import unittest,json
from pathlib import Path
from build import normalize,coords,DATA
S={'id':'test','region':'臺北市','checkedDate':'2026-11-12'}
class BuildTests(unittest.TestCase):
 def test_swapped(self):
  self.assertEqual(coords('120.5','24.1'),([120.5,24.1],['coordinate_columns_swapped']))
 def test_bad(self):
  self.assertIsNone(coords('區間測速','區間測速')[0]);self.assertIsNone(coords('0','0')[0])
 def test_no_invented_limit_or_direction(self):
  r=normalize(S,{'地點':'測試路口','取締項目':'不停讓行人','拍攝方向':'雙向','速限':'-'},'row:1')
  self.assertIsNone(r['speedLimitKph']);self.assertIsNone(r['travelBearing']);self.assertEqual(r['categories'],['pedestrian']);self.assertFalse(r['preciseAlertReady'])
 def test_future_roc(self):
  r=normalize(S,{'地點':'測試路口','啟用日期':'116年1月1日'},'row:1');self.assertEqual(r['status'],'planned')
 def test_address_in_violation(self):
  r=normalize(S,{'地點':'中山路與中正路口','取締項目':'中山路與中正路口'},'row:1');self.assertIn('violation_field_contains_address',r['qualityFlags'])
 def test_dataset(self):
  d=json.loads((DATA/'tw_enforcement.json').read_text());rs=d['records']
  self.assertEqual(len(rs),len(set(r['id'] for r in rs)))
  self.assertTrue(all(not r['preciseAlertReady'] for r in rs))
  self.assertEqual(sum(map(len,d['tiles'].values())),sum(bool(r['coordinates']) for r in rs))
  self.assertEqual(len(json.loads((DATA/'audit.json').read_text())['coverage']),22)
if __name__=='__main__':unittest.main()
