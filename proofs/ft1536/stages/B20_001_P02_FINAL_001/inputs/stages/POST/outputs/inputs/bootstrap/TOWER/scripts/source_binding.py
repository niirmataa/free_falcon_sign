import difflib,json
from pathlib import Path
from replaylib import sha,verify_manifest
W=Path.cwd();I=W/'inputs/bootstrap';verify_manifest(I,'MANIFEST.sha256','9bd79a0179910af92457ce6db5419aa859017499a79c575fb8256b5bfc92d7a1')
spans={'falcon-sign.c':[(505,530),(598,647),(651,752),(1159,1268)],'falcon-fft.c':[(52,108),(1026,1037),(1260,1271),(1326,1370)],
 'fpr-emulated.h':[(18,55),(151,193)],'fpr-emulated.c':[(448,556),(680,776),(915,1002)]}
folder=W/'inputs/slices';folder.mkdir(exist_ok=True);rows=[]
for name,windows in spans.items():
 src=W/'source'/name;assert sha(src)==sha(I/'source'/name);lines=src.read_text().splitlines()
 for a,b in windows:
  p=folder/f'{name}_{a}_{b}.txt';p.write_text('\n'.join(f'{i+1}: {lines[i]}' for i in range(a-1,b))+'\n')
  rows.append(dict(source='source/'+name,source_sha256=sha(src),first=a,last=b,copy=str(p.relative_to(W)),sha256=sha(p)))
text=(W/'source/falcon-sign.c').read_text();inner=text.split('\nffLDL_inner_fft3(',1)[1].split('\nstatic size_t',1)[0]
for s in ['if (logn == 1)','tree[2] = g00[0];','tree[3] = tmp[0];','return 4;','s += ffLDL_inner_fft3(tree + s, t0, t1, t0, logn - 1, t2);','LDL_dim2_fft3(t2, tree, g00, g10, g11, logn, 0);']:assert s in inner
assert inner.index('s += ffLDL_inner_fft3')<inner.index('LDL_dim2_fft3(t2, tree')<inner.rindex('s += ffLDL_inner_fft3')
changes=[];(W/'artifacts/diffs').mkdir(exist_ok=True)
for name in ['run','audit','controls','certificate','source_binding','ledger','oracle']:
 old=I/'NODE2/scripts'/(name+'.py');new=W/'scripts'/(name+'.py')
 if not new.exists():continue
 patch=''.join(difflib.unified_diff(old.read_text().splitlines(True),new.read_text().splitlines(True),fromfile='inputs/bootstrap/NODE2/scripts/'+name+'.py',tofile='scripts/'+name+'.py'))
 p=W/'artifacts/diffs'/(name+'.patch');p.write_text(patch)
 changes.append(dict(original=old.relative_to(W).as_posix(),original_sha256=sha(old),new=new.relative_to(W).as_posix(),new_sha256=sha(new),diff=p.relative_to(W).as_posix(),diff_sha256=sha(p)))
out=dict(status='PASS_UNCHANGED_SOURCE_ORDER_AND_BASE_BINDING',source_files=17,spans=rows,source_first_local_second_verified=True,base_stores_verified=True,
 controls='Original included function body; three observer wrappers delegate exactly once; base leaves observed at next hook/final return.',
 models={r:sha(W/r) for r in ['scripts/tower_model.py','scripts/backend.py','scripts/half_model.py','formal/TowerExecution.lean','formal/TowerOrder.lean']},
 analytical_proofs={r:sha(W/r) for r in ['INDUCTION.md','LEVEL7.md','ASSEMBLY_INTERFACE.md']},adaptations=changes,
 full_C_compiler_refinement=False,full_binary_tower_theorem_kernelized=False)
(W/'artifacts/source_binding.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],spans=len(rows),adaptations=len(changes)),indent=2))
