"""T02.1 preflight: pin and integrity checks before any computation.

Verifies the sealed TASK and SageMath-rule hashes, the bootstrap MANIFEST
(39 members), member set/hashes, absence of symlinks/escapes, ORIGINS.json
pinning to Git BASE c90233c1..., CANDIDATE.sha256 source17, and that no
OUTPUTS.sha256 exists yet (active, not frozen).
"""
import json,os,re
from pathlib import Path
from replaylib import sha,member,verify_manifest
from common import run_logged,W
IN=W/'inputs/bootstrap'
TASK_SHA='7b0007c095c51b1fe4c5d94b0b1a0012227aba4df0d1c59cfa8fcd92589fe5f1'
RULE_SHA='b6afcdcabb811dd8bc31072455ed9a94a4c4773ec68d41d207ac1d7e98eae241'
MANIFEST_SHA='03b0612cbe3b18e487bee6399c71c238e5ff3a0527818a7c4330d007b72abae2'
BASE='c90233c171265e050930958fb29bafa9338f81ff'
CANDIDATE_SHA='56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985'
def main():
 replay_role=bool(os.environ.get('FT1536_REPLAY_ORIGINAL'))
 out=dict(schema='PRNG_T021_INPUT_VALIDATION_V1',replay_role=replay_role,task_sha256=TASK_SHA,sagemath_rule_sha256=RULE_SHA,bootstrap_manifest_sha256=MANIFEST_SHA,base_commit=BASE)
 assert sha(W/'TASK.md')==TASK_SHA,'TASK.md pin mismatch'
 assert sha(W/'SAGEMATH_RULE.md')==RULE_SHA,'SAGEMATH_RULE.md pin mismatch'
 assert sha(W/'inputs/documents/TASK.md')==TASK_SHA
 assert sha(W/'inputs/documents/SAGEMATH_RULE.md')==RULE_SHA
 assert sha(IN/'MANIFEST.sha256')==MANIFEST_SHA,'manifest external pin mismatch'
 rows=verify_manifest(IN,'MANIFEST.sha256',MANIFEST_SHA)
 assert len(rows)==39,('bootstrap member count',len(rows))
 src=[r for r in rows if r.startswith('source/')]
 assert len(src)==17,('source17 count',len(src))
 out.update(members=len(rows),source_members=len(src),member_bytes=sum((IN/r).stat().st_size for r in rows))
 origins=json.loads((IN/'ORIGINS.json').read_text())
 assert origins['base_commit']==BASE,'ORIGINS base mismatch'
 assert len(origins['files'])==37,('origins count',len(origins['files']))
 for e in origins['files']:
  p=member(IN,e['copy'])
  assert sha(p)==e['sha256'] and p.stat().st_size==e['bytes'],('origin mismatch',e['copy'])
 assert all(e['original'].startswith('git:'+BASE+':') for e in origins['files'])
 out['origins_files']=len(origins['files'])
 cand={}
 for line in (IN/'CANDIDATE.sha256').read_text().splitlines():
  h,rel=line.split('  ',1);cand[rel]=h
 assert re.fullmatch('[0-9a-f]{64}',sha(IN/'CANDIDATE.sha256')) and len(cand)==17
 for r,h in cand.items():
  assert rows['source/'+r]==h,('candidate mismatch',r)
 out['candidate_matches_manifest']=True
 forbidden=[p for p in IN.rglob('*') if p.is_symlink()]
 assert not forbidden,forbidden
 if not replay_role:
  assert not (W/'OUTPUTS.sha256').exists(),'W is already frozen'
 out['status']='PASS'
 (W/'receipts').mkdir(exist_ok=True)
 (W/'receipts/input_validation.json').write_text(json.dumps(out,indent=2)+'\n')
 print(json.dumps(out,indent=2))
if __name__=='__main__':main()
