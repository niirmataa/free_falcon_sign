"""Complete and pin the transitive ZERO source dependency closure after the missing-import diagnostic."""
import json,re,shutil
from pathlib import Path
from replaylib import sha,verify_manifest
W=Path.cwd();I=W/'inputs/bootstrap';pin='f1f5aee612f7f1651ec79a5e716a8f6d2963b5121566e80c7335ce0bf32dac73'
manifest=verify_manifest(I,'MANIFEST.sha256',pin);order=[]
def visit(mod):
 if mod in order:return
 p=I/'ZERO/formal'/(mod+'.lean');assert sha(p)==manifest['ZERO/formal/'+mod+'.lean']
 for dep in re.findall(r'^import (\w+)',p.read_text(),re.M):
  if (I/'ZERO/formal'/(dep+'.lean')).exists():visit(dep)
 target=W/'formal'/(mod+'.lean')
 if target.exists():assert sha(target)==sha(p)
 else:shutil.copyfile(p,target)
 order.append(mod)
visit('PackOf')
old=W/'artifacts/reuse.json';saved=W/'artifacts/reuse_initial.json';assert not saved.exists();shutil.copyfile(old,saved)
rows=[r for r in json.loads(old.read_text()) if not r['copy'].startswith('formal/')]
for mod in order:
 p='formal/'+mod+'.lean';rows.append(dict(input='inputs/bootstrap/ZERO/'+p,copy=p,sha256=sha(W/p),byte_identical=True))
old.write_text(json.dumps(rows,indent=2)+'\n');(W/'artifacts/inherited_order.json').write_text(json.dumps(order,indent=2)+'\n')
print(json.dumps(dict(inherited_order=order,all_sources_byte_identical=True),indent=2))
