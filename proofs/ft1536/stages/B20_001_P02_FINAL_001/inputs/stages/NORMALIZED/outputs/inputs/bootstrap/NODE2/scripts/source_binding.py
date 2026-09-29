import difflib,json
from pathlib import Path
from replaylib import sha,verify_manifest
W=Path.cwd();I=W/'inputs/bootstrap';verify_manifest(I,'MANIFEST.sha256','f92dbaa6f4262f2cce5d4bd27e002da0f684f87a92fef8619bee226221782178')
spans={'falcon-fft.c':[(52,108),(1026,1037),(1260,1271),(1326,1370)],'falcon-sign.c':[(505,530),(598,703),(706,752)],
 'fpr-emulated.h':[(18,55),(151,193)],'fpr-emulated.c':[(448,556),(680,776),(915,1002)]}
folder=W/'inputs/slices';folder.mkdir(exist_ok=True);rows=[]
for name,windows in spans.items():
 src=W/'source'/name;assert sha(src)==sha(I/'source'/name);lines=src.read_text().splitlines()
 for a,b in windows:
  p=folder/f'{name}_{a}_{b}.txt';p.write_text('\n'.join(f'{i+1}: {lines[i]}' for i in range(a-1,b))+'\n')
  rows.append(dict(source='source/'+name,source_sha256=sha(src),first=a,last=b,copy=str(p.relative_to(W)),sha256=sha(p)))
text=(W/'source/falcon-fft.c').read_text();split=text.split('falcon_poly_split_deep_fft3(',1)[1].split('/* see internal.h */',1)[0]
for s in ['if (logn == 1)','f0[u] = fpr_half(t_re);','f1[u] = fpr_half(t_re);','fpr_gm3_square[((u + m) << 1) + 0]']:assert s in split
header=(W/'source/fpr-emulated.h').read_text()
for s in ['x -= (uint64_t)1 << 52;','t = (((uint32_t)(x >> 52) & 0x7FF) + 1) >> 11;','x &= (uint64_t)t - 1;']:assert s in header
changes=[];(W/'artifacts/diffs').mkdir(exist_ok=True)
for name in ['run','audit','check_lean_values','controls','certificate','source_binding','ledger','fixtures']:
 old=I/'NODE3/scripts'/(name+'.py');new=W/'scripts'/(name+'.py')
 if not new.exists():continue
 patch=''.join(difflib.unified_diff(old.read_text().splitlines(True),new.read_text().splitlines(True),fromfile='inputs/bootstrap/NODE3/scripts/'+name+'.py',tofile='scripts/'+name+'.py'))
 p=W/'artifacts/diffs'/(name+'.patch');p.write_text(patch)
 changes.append(dict(original=old.relative_to(W).as_posix(),original_sha256=sha(old),new=new.relative_to(W).as_posix(),new_sha256=sha(new),diff=p.relative_to(W).as_posix(),diff_sha256=sha(p)))
out=dict(status='PASS_SOURCE_BYTE_LAYOUT_AND_HALF_BINDING',source_files=17,spans=rows,level=dict(split_logn=9,ldl_logn=8,full=0),
 source_inputs='NODE3 t0/d11/d22 at their source lifetimes; s0 alias g00=g11 for local dim2',
 literal_models={r:sha(W/r) for r in ['scripts/half_model.py','scripts/node2_model.py','scripts/node_model.py','scripts/backend.py','formal/Half.lean']},
 analytical_proofs={r:sha(W/r) for r in ['ANALYTIC_PROOF.md','UPSTREAM_REFINEMENT.md','NODE2_FRAME.md']},adaptations=changes,
 full_C_compiler_refinement=False,full_node2_theorem_kernelized=False)
(W/'artifacts/source_binding.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],spans=len(rows),adaptations=len(changes)),indent=2))
