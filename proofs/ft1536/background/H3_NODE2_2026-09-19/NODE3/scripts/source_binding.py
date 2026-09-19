import difflib,json
from pathlib import Path
from replaylib import sha,verify_manifest
W=Path.cwd();I=W/'inputs/bootstrap';verify_manifest(I,'MANIFEST.sha256','426db8a67b74de0de0141a8d9ca406fca7a2bdad45a42e97a913bad4d62b6ca3')
spans={'falcon-fft.c':[(52,108),(1026,1037),(1243,1322)],'falcon-sign.c':[(490,595),(597,752)],
 'fpr-emulated.h':[(18,55),(86,96),(151,193)],'fpr-emulated.c':[(150,204),(448,556),(680,776),(915,1002)]}
folder=W/'inputs/slices';folder.mkdir(exist_ok=True);rows=[]
for name,windows in spans.items():
 src=W/'source'/name;assert sha(src)==sha(I/'source'/name);lines=src.read_text().splitlines()
 for a,b in windows:
  p=folder/f'{name}_{a}_{b}.txt';p.write_text('\n'.join(f'{i+1}: {lines[i]}' for i in range(a-1,b))+'\n')
  rows.append(dict(source='source/'+name,source_sha256=sha(src),first=a,last=b,copy=str(p.relative_to(W)),sha256=sha(p)))
text=(W/'source/falcon-fft.c').read_text();split=text.split('falcon_poly_split_top_fft3(',1)[1].split('/* see internal.h */',1)[0]
assert split.count('fpr_inverse_of(3)')==6
for x in ['fpr_neg(fpr_gm3_cubic','FPC_SQR(xr, xi, xr, xi);','f0[v + qn]','f2[v + qn]']:assert x in split
sign=(W/'source/falcon-sign.c').read_text()
for x in ['falcon_poly_div_autoadj_fft3(l21, d11, logn, full);','falcon_poly_mul_autoadj_fft3(tmp, d11, logn, full);','g00, g10, g11, g20, g21, g22, logn, 0, t2);']:assert x in sign
changes=[];(W/'artifacts/diffs').mkdir(exist_ok=True)
for name in ['run','audit','check_lean_values','controls','certificate','source_binding','ledger']:
 old=I/'ROOT/scripts'/(name+'.py');new=W/'scripts'/(name+'.py')
 if not new.exists():continue
 patch=''.join(difflib.unified_diff(old.read_text().splitlines(True),new.read_text().splitlines(True),fromfile='inputs/bootstrap/ROOT/scripts/'+name+'.py',tofile='scripts/'+name+'.py'))
 p=W/'artifacts/diffs'/(name+'.patch');p.write_text(patch)
 changes.append(dict(original=old.relative_to(W).as_posix(),original_sha256=sha(old),new=new.relative_to(W).as_posix(),new_sha256=sha(new),diff=p.relative_to(W).as_posix(),diff_sha256=sha(p)))
out=dict(status='PASS_SOURCE_BYTE_AND_LAYOUT_BINDING',source_files=17,spans=rows,six_actual_inverse_of3_multiplications=True,
 per_component_div_and_real_slot_mul=True,source_aliases='g00=g11=g22=t0; g10=g21=Adj(t1); g20=Adj(t2)',
 literal_models={r:sha(W/r) for r in ['scripts/node_model.py','scripts/backend.py','scripts/fp_literal.py','formal/NodeDataflow.lean','formal/NodeInverse.lean']},
 analytical_proofs={r:sha(W/r) for r in ['ANALYTIC_PROOF.md','ROOT_CONSUMPTION.md','NODE3_FRAME.md']},adaptations=changes,
 full_C_compiler_refinement=False,full_node3_theorem_kernelized=False)
(W/'artifacts/source_binding.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],spans=len(rows),adaptations=len(changes)),indent=2))
