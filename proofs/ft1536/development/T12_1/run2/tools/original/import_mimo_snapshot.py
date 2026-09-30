"""Materialize reviewed snapshot sources in RUN_002, preserving author bytes."""
import argparse,hashlib,json,re,shutil
from pathlib import Path
W=Path(__file__).resolve().parent.parent
ap=argparse.ArgumentParser();ap.add_argument('--review',default='GAME_BINDING_REVIEW_002')
ap.add_argument('--pin',default='cc01337d093029458d07946088066b1ffeae93ac59a0896b8e26968d8c215269')
args=ap.parse_args();assert re.fullmatch(r'GAME_BINDING_REVIEW_[0-9]+',args.review)
R=W/'run'/args.review;S=R/('source_snapshot_'+args.pin[:8])
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
assert json.loads((R/'replay_001/REPLAY_RESULT.json').read_text())['status']=='FRESH_REPLAY_PASS'
assert sha(S/'OUTPUTS.sha256')==args.pin
items=[]
for p in sorted((S/'formal/FT1536').glob('*.lean')):
    d=W/'run/formal/FT1536'/p.name
    existed=d.exists()
    if existed:assert sha(d)==sha(p),('existing source differs',p.name)
    else:shutil.copyfile(p,d);d.chmod(0o644)
    scope='shared unchanged RUN_001' if existed else 'reviewed kernel declaration; scope limited by INTEGRATION_STATUS.md'
    if p.name=='BitCost.lean':scope='corrected cost composition and peak-storage envelope; actual-machine refinement supplied in RUN_002 integration'
    items.append(dict(source=str(p),destination=str(d.relative_to(W)),sha256=sha(p),existed=existed,scope=scope))
(W/'run/MIMO_INTEGRATION.json').write_text(json.dumps(dict(snapshot_manifest=sha(S/'OUTPUTS.sha256'),
    author_original_changed=False,author_frozen_in_Obrazy=True,files=items),indent=2)+'\n')
print('MATERIALIZED',sum(not x['existed'] for x in items),'new modules; shared',sum(x['existed'] for x in items))
