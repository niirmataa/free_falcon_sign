import json,struct
from fractions import Fraction as Q
from pathlib import Path
from target_model import target,canonical
from replaylib import sha
W=Path.cwd();D=W/'checks/mutations';D.mkdir(parents=True,exist_ok=True)
meta=json.loads((W/'checks/data/dense_dense.meta.json').read_text());original=json.loads((W/'checks/data/dense_dense.snapshots.json').read_text())
c=meta['canonical_challenge'];sk=[0x3ff0000000000000+(i*65537)%2**52 for i in range(24576)];sk[:6144]=meta['basis_words'];rows=[]
for kind in ['noop','wrong_sign','wrong_column','missing_1q','centered','copy_zero','copy_late','wrong_alias','wrong_packing']:
 s,e=target(W,[x^0 for x in c],list(sk),None if kind=='noop' else kind);same=s==original;assert same==(kind=='noop')
 (D/(kind+'.json')).write_text(json.dumps(s,indent=2)+'\n');(D/(kind+'.trace')).write_text('\n'.join(e)+'\n')
 rows.append(dict(mutation=kind,checker_accepts=same,first_t0_difference=next((i for i,(a,b) in enumerate(zip(s['t0'],original['t0'])) if a!=b),None),
  first_t1_difference=next((i for i,(a,b) in enumerate(zip(s['t1'],original['t1'])) if a!=b),snapshot_sha256=sha(D/(kind+'.json')),trace_sha256=sha(D/(kind+'.trace'))))
num=json.loads((W/'artifacts/numeric_certificate.json').read_text());needed=Q(num['fft']['challenge_component_error_exact']);old=Q(1,32768)
assert needed>old
rows.append(dict(mutation='reuse_2047_FFT_error',checker_accepts=False,old_bound=str(old),actual_new_recurrence_majorant=str(needed),
 classification='Rejected proof-certificate extrapolation; not a witnessed source FFT numerical counterexample'))
bad=[]
for name,data in [('out_of_range_q',[18433]+c[1:]),('negative_residue',[-1]+c[1:]),('short_vector',c[:-1])]:
 err=None
 try:canonical(data)
 except ValueError as ex:err=str(ex)
 assert err;bad.append(dict(case=name,stop=err,native_called=False))
for name,value in [('nonfinite_basis',0x7ff0000000000000),('oversized_basis',0x40a0000000000000)]:
 key=list(sk);key[1536]=value;err=None
 try:target(W,c,key)
 except ValueError as ex:err=str(ex)
 assert err;bad.append(dict(case=name,stop=err,native_called=False))
def legal_disjoint(a,b):return a[1]<=b[0] or b[1]<=a[0]
assert legal_disjoint((0,10752),(32768,32768+24576)) and not legal_disjoint((0,10752),(0,24576))
bad.append(dict(case='output_key_alias',stop='STOP_RESTRICT_MEMCPY_DOMAIN',native_called=False))
out=dict(status='PASS_TARGET_VALUE_ORDER_DOMAIN_MUTATIONS',rows=rows,invalid_cases=bad,
 mutation_layer='Executed integer model changed sign/column/scale/input/copy order/alias/packing; no-op also native; no C source patch',
 P_key_or_emitted_counterexample_claimed=False)
(W/'artifacts/mutations.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
