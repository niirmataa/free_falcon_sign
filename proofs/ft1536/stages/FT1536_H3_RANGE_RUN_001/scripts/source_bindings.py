import hashlib,json
from pathlib import Path
W=Path.cwd()
def sha(p):return hashlib.sha256((W/p).read_bytes()).hexdigest()
spans=[('FPR_pack','fpr-emulated.h',39,55),('FPR_floor','fpr-emulated.h',117,133),('FPR_shifts','fpr-emulated.h',18,37),
 ('FPR_half_neg','fpr-emulated.h',151,174),('FPR_add','fpr-emulated.c',448,554),('FPR_mul','fpr-emulated.c',680,774),
 ('FPR_div','fpr-emulated.c',915,1000),('FPR_sqrt','fpr-emulated.c',1182,1257),
 ('key_cap','falcon-keygen.c',4486,4508),('key_solve_cap_return','falcon-keygen.c',7337,7410),
 ('key_emit_path','falcon-keygen.c',7782,8187),('loader_tree','falcon-sign.c',1159,1268),('tree_dim2','falcon-sign.c',504,530),
 ('tree_dim3','falcon-sign.c',547,595),('tree_recursive','falcon-sign.c',597,755),('leaf_normalize','falcon-sign.c',963,1040),
 ('inner_calls','falcon-sign.c',1616,1694),('depth1_calls','falcon-sign.c',1696,1780),('top_calls','falcon-sign.c',1782,1839),
 ('initial_targets','falcon-sign.c',1848,1897),('sampler_guards','falcon-sign.c',2840,2876),('proposal','falcon-sign.c',2729,2829),
 ('sampler_return','falcon-sign.c',2898,2972),('outer_retry','falcon-sign.c',3308,3422),('split_merge','falcon-fft.c',1273,1455)]
rows=[]
for name,src,a,b in spans:
 data=(W/'source'/src).read_bytes();sl=b''.join(data.splitlines(keepends=True)[a-1:b]);rel='inputs/slices/'+name+'.txt'
 (W/rel).parent.mkdir(exist_ok=True);(W/rel).write_bytes(sl)
 rows.append(dict(id=name,source='source/'+src,source_sha256=hashlib.sha256(data).hexdigest(),lines=[a,b],slice=rel,slice_sha256=hashlib.sha256(sl).hexdigest()))
sign=(W/'source/falcon-sign.c').read_text();kg=(W/'source/falcon-keygen.c').read_text()
checks=dict(floor_before_dss=sign.index('s = fpr_floor(mu);',sign.index('sampler_large(void'))<sign.index('dss = fpr_inv',sign.index('sampler_large(void')),
 leaf_overwrite_preserves_internal='The internal L coefficients remain those of the' in sign,
 key_cap_required='if (!poly_big_to_small(F, fk->tmp, logn, fk->ternary)' in kg and '|| !poly_big_to_small(G, fk->tmp + n, logn, fk->ternary)' in kg,
 emitted_solve_required='if (!solve_NTRU(fk, F, G, f, g))' in kg,mandatory_leaf='if (!ft_keygen_leaf_certificate' in kg,
 fault_before_floor=sign.index('if (tsc->fault != FT_SAMPLER_FAULT_NONE)',sign.index('sampler_large(void'))<sign.index('s = fpr_floor(mu);',sign.index('sampler_large(void')))
assert all(checks.values())
out=dict(source_manifest_sha256=sha('inputs/bootstrap/CANDIDATE.sha256'),spans=rows,structural_checks=checks,
 input_bootstrap=sha('inputs/bootstrap/MANIFEST.sha256'),models=['formal/Floor.lean','formal/Proposal.lean','formal/Comparator.lean','formal/OrderedResidual.lean','formal/GuardPrefix.lean','scripts/order_model.py'],
 C_probe_scope='Unmodified source includes; synthetic fpr words and public artificial trees. No KeyGen, source Sign-with-key or loader invocation.',
 explicit_gaps=['full C operational semantics/refinement of complete emitted-key path','uniform internal subtractive LDL numerical certificate','Reach -> CenterClass, in particular negative-zero/domain invariant'])
(W/'artifacts/source_bindings.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(spans=len(rows),checks=checks),indent=2))
