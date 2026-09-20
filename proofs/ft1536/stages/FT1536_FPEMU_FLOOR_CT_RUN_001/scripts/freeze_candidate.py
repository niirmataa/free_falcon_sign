import difflib,json
from pathlib import Path
from replaylib import sha
W=Path.cwd();base=W/'baseline/source';cand=W/'candidate/source';rows={}
for line in (W/'inputs/bootstrap/CANDIDATE.sha256').read_text().splitlines():
 h,n=line.split('  ',1);assert sha(base/n)==h;rows[n]=h
assert len(rows)==17 and set(p.name for p in cand.iterdir())==set(rows)
changed=[n for n,h in rows.items() if sha(cand/n)!=h];assert changed==['fpr-emulated.h']
old=(base/'fpr-emulated.h').read_text();new=(cand/'fpr-emulated.h').read_text()
start='static inline long\nfpr_floor(fpr x)\n';end='\nstatic inline int64_t\nfpr_trunc(fpr x)'
a,b=old.split(start,1);oldbody,c=b.split(end,1);aa,bb=new.split(start,1);newbody,cc=bb.split(end,1)
assert a==aa and c==cc and '__asm__' not in newbody
patch=''.join(difflib.unified_diff(old.splitlines(True),new.splitlines(True),fromfile='baseline/source/fpr-emulated.h',tofile='candidate/source/fpr-emulated.h'))
with (W/'PATCH.diff').open('x') as f:f.write(patch)
with (W/'candidate/CANDIDATE.sha256').open('x') as f:
 for n in rows:f.write(sha(cand/n)+'  '+n+'\n')
out=dict(status='CANDIDATE_FROZEN_BEFORE_CONFIRMATORY_TIMING',changed_files=changed,unchanged_source_files=16,
 baseline_manifest_sha256=sha(W/'inputs/bootstrap/CANDIDATE.sha256'),candidate_manifest_sha256=sha(W/'candidate/CANDIDATE.sha256'),
 candidate_header_sha256=sha(cand/'fpr-emulated.h'),patch_sha256=sha(W/'PATCH.diff'),compiler_barrier_used=False,
 candidate_source_changed=True,production_source_changed=False,new_source_patch_integrated=False,owner_accepted=False)
with (W/'artifacts/candidate_freeze.json').open('x') as f:json.dump(out,f,indent=2);f.write('\n')
print(json.dumps(out,indent=2))
