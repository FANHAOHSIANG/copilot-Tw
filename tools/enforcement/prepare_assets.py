"""Stage checked data into an explicitly supplied decoded APK assets directory."""
import argparse, shutil, json
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('--assets',type=Path,required=True);a=p.parse_args()
source=Path(__file__).resolve().parents[2]/'data/enforcement/tw_enforcement.json'
data=json.loads(source.read_text());assert data['schemaVersion']==1 and data['records']
a.assets.mkdir(parents=True,exist_ok=True)
shutil.copyfile(source,a.assets/'tw_enforcement.json')
print('Staged enforcement asset only; compile the catalog and integrate map consumer separately.')
