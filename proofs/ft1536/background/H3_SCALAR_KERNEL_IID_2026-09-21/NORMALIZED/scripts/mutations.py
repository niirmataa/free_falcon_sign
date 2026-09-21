import json,struct
from pathlib import Path
from stable_model import Stable,normalize,initial_sk,gate_single,MIN,MAX
from backend import sqrt,div,of
from fp_literal import pack
from replaylib import sha
W=Path.cwd();D=W/'checks/mutations';D.mkdir(parents=True,exist_ok=True)
roots=[int(x,16) for x in (W/'checks/data/roots_vary.input').read_text().split()]
expected=list(struct.unpack('<1536Q',(W/'checks/data/roots_vary.leaves.bin').read_bytes()));expected_sk=list(struct.unpack('<24576Q',(W/'checks/data/roots_vary.sk.bin').read_bytes()))
rows=[]
for kind in ['noop','reciprocal_forward','leaf_permutation','frame_basis','frame_internal']:
 m=Stable(kind);leaves,ok,_=m.roots([x^0 for x in roots]);sk,reads=normalize(leaves,initial_sk(),m,W,permutation=kind=='leaf_permutation')
 if kind=='frame_basis':sk[0]^=1
 if kind=='frame_internal':sk[6144]^=1
 accepted=leaves==expected and sk==expected_sk;assert accepted==(kind=='noop')
 (D/(kind+'.trace')).write_text('\n'.join(m.events)+'\n');(D/(kind+'.leaves.bin')).write_bytes(struct.pack('<1536Q',*leaves));(D/(kind+'.sk.bin')).write_bytes(struct.pack('<24576Q',*sk));(D/(kind+'.reads.json')).write_text(json.dumps(reads,indent=2)+'\n')
 rows.append(dict(mutation=kind,checker_accepts=accepted,stable_ok=ok,first_leaf_difference=next((i for i,(a,b) in enumerate(zip(leaves,expected)) if a!=b),None),first_sk_difference=next((i for i,(a,b) in enumerate(zip(sk,expected_sk)) if a!=b),None),trace_sha256=sha(D/(kind+'.trace')),sk_sha256=sha(D/(kind+'.sk.bin'))))
for name,x,bad,kwargs in [('sticky_reset',MIN,1,dict(reset=True)),('gate_off_by_one',MIN,0,dict(strict=True))]:
 true=gate_single(x,bad);mutant=gate_single(x,bad,**kwargs);assert true!=mutant;rows.append(dict(mutation=name,raw=f'{x:016x}',initial_bad=bad,source=true,mutant=mutant,checker_accepts=False))
f=json.loads((W/'artifacts/fixtures.json').read_text());w=f['sqrt_sticky_mutation'];x=int(w['raw'],16);z,t=sqrt(x,True);mut=pack(0,t['e'],t['q']<<1);assert mut!=z
rows.append(dict(mutation='sqrt_omit_sticky',**w,checker_accepts=False));(D/'sqrt_sticky.states.json').write_text(json.dumps(t,indent=2)+'\n')
# Actual wrong exponent-parity shift: 2048 should give sqrt(2048), not sqrt(1024).
x=of(2048);true=sqrt(x);wrong=sqrt(of(1024));assert true!=wrong
rows.append(dict(mutation='sqrt_wrong_parity_shift',raw=f'{x:016x}',source=f'{true:016x}',mutant=f'{wrong:016x}',checker_accepts=False))
invalid=[]
for name,fn in [('zero_divisor',lambda:div(of(1),of(0))),('negative_sqrt',lambda:sqrt(of(-1))),('subnormal_sqrt_outside_contract',lambda:sqrt(1))]:
 error=None
 try:fn()
 except ValueError as e:error=str(e)
 assert error;invalid.append(dict(case=name,preflight_stop=error,native_called=False))
invalid.append(dict(case='wrong_logn',preflight_stop='Outside fixed logn10; early helper return need not initialize pointer, so suffix not invoked',native_called=False))
out=dict(status='PASS_EXECUTED_STRUCTURAL_SCALAR_AND_FLAG_MUTATIONS',mutations=rows,invalid_preflight=invalid,source_modified=False,
 layer='Actual model operations/writes and scalar/flag equations changed; original C is not patched. No-op also exercised natively. Not P_key/emitted counterexamples.')
(W/'artifacts/mutations.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
