import difflib,json
from pathlib import Path
from replaylib import sha,verify_manifest,member
W=Path.cwd();I=W/'inputs/bootstrap';verify_manifest(I,'MANIFEST.sha256','2caffdcc7d805d880e22be683a4529f933d1a1cb59485a3728ae8cf24fdc3c9c')
freeze=json.loads((W/'artifacts/candidate_freeze.json').read_text());assert sha(W/'candidate/CANDIDATE.sha256')==freeze['candidate_manifest_sha256']
assert sha(W/'candidate/source/fpr-emulated.h')==freeze['candidate_header_sha256'] and sha(W/'PATCH.diff')==freeze['patch_sha256']
base_rows={n:h for h,n in (line.split('  ',1) for line in (I/'CANDIDATE.sha256').read_text().splitlines())}
cand_rows={n:h for h,n in (line.split('  ',1) for line in (W/'candidate/CANDIDATE.sha256').read_text().splitlines())}
assert len(base_rows)==len(cand_rows)==17 and set(base_rows)==set(cand_rows)
for variant,rows in [('baseline',base_rows),('candidate',cand_rows)]:
 assert {p.name for p in (W/variant/'source').iterdir()}==set(rows)
 for n,h in rows.items():assert sha(member(W/variant/'source',n))==h
old=(W/'baseline/source/fpr-emulated.h').read_text();new=(W/'candidate/source/fpr-emulated.h').read_text()
start='static inline long\nfpr_floor(fpr x)\n';end='\nstatic inline int64_t\nfpr_trunc(fpr x)'
a,b=old.split(start,1);oldbody,c=b.split(end,1);aa,bb=new.split(start,1);newbody,cc=bb.split(end,1)
assert a==aa and c==cc and '__asm__' not in newbody
patch=''.join(difflib.unified_diff(old.splitlines(True),new.splitlines(True),fromfile='baseline/source/fpr-emulated.h',tofile='candidate/source/fpr-emulated.h'))
assert (W/'PATCH.diff').read_text()==patch
changed=[]
for line in (I/'CANDIDATE.sha256').read_text().splitlines():
 h,n=line.split('  ',1);assert sha(W/'baseline/source'/n)==h
 if sha(W/'candidate/source'/n)!=h:changed.append(n)
assert changed==['fpr-emulated.h']
for folder,names in [('harness',['benchmark.c','targets.c']),('vendor',['dudect.h','LICENSE','README.md'])]:
 for n in names:assert sha(W/folder/n)==sha(I/folder/n)
spans=[];dest=W/'inputs/slices';dest.mkdir(exist_ok=True)
for variant in ['baseline','candidate']:
 for name,windows in {'fpr-emulated.h':[(18,37),(117,136)],'falcon-sign.c':[(2472,2486),(2536,2548),(2841,2874)]}.items():
  src=W/variant/'source'/name;lines=src.read_text().splitlines()
  for a,b in windows:
   p=dest/f'{variant}_{name}_{a}_{b}.txt';p.write_text('\n'.join(f'{i+1}: {lines[i]}' for i in range(a-1,b))+'\n')
   spans.append(dict(source=src.relative_to(W).as_posix(),source_sha256=sha(src),first=a,last=b,copy=p.relative_to(W).as_posix(),sha256=sha(p)))
diffs=[]
for old,new in [('ZERO/scripts/run.py','scripts/run.py'),('ZERO/scripts/audit.py','scripts/audit.py'),('harness/campaign.py','scripts/timing_ab.py'),('harness/prepare.py','scripts/build_benchmark.py')]:
 p=W/'artifacts/diffs'/('binding_'+Path(new).stem+'.patch')
 p.write_text(''.join(difflib.unified_diff((I/old).read_text().splitlines(True),(W/new).read_text().splitlines(True),fromfile='inputs/bootstrap/'+old,tofile=new)))
 diffs.append(dict(original='inputs/bootstrap/'+old,original_sha256=sha(I/old),new=new,new_sha256=sha(W/new),diff=p.relative_to(W).as_posix(),diff_sha256=sha(p)))
out=dict(status='PASS_ONLY_FLOOR_BODY_CHANGED_AND_BINDING',changed_files=changed,unchanged_files=16,spans=spans,adaptations=diffs,
 candidate_manifest_sha256=freeze['candidate_manifest_sha256'],candidate_header_sha256=freeze['candidate_header_sha256'],
 semantics_documents={r:sha(W/r) for r in ['SEMANTICS.md','EQUIVALENCE.md','SOURCE_MODEL_BINDING.md','ASSEMBLY_REVIEW.md','IMPACT_MATRIX.md']},
 all_word_model='FloorCT.all_word64_equivalence',definedness='FloorCT.all_word64_defined plus explicit C99/GCC/LP64 range/representation binding',
 barrier_used=False,compiler_verified=False,production_source_changed=False,new_source_patch_integrated=False)
(W/'artifacts/source_binding.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],spans=len(spans),changed_files=changed),indent=2))
