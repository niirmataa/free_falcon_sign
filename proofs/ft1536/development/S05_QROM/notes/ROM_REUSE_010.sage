# sage ROM_REUSE_010.sage ROOT_CERT OUTDIR
# Reuse of pinned ROM numerical exports, not a re-proof of their source semantics.
import json,sys
from pathlib import Path
root=json.loads(Path(sys.argv[1]).read_text());out=Path(sys.argv[2]);out.mkdir(parents=True,exist_ok=True)
assert not (out/'certificate.json').exists()
assert root['constants']['gram_error_A']=='1/1024'
assert root['constants']['source_g00_real_lower']=='1/2'
roots=[ZZ(x) for x in root['fft_map']['roots']]
assert len(roots)==len(set(roots))==768
both=set(roots)|set((-r)%4608 for r in roots)
assert len(both)==1536 and both=={ZZ(r) for r in range(4608) if r%6 in [1,5]}
U=QQ(2)^(-48);eta=QQ(2)^(-900);beta=2*U
assert U+QQ(2)^112*eta<beta
kappa=1/(1-2*QQ(1)/1024);assert kappa==QQ(512)/511
factor=(1+beta)^20/(1-beta)^11
word=ZZ('4090000053700377',16);exp=(word>>52)&2047;mant=word&(ZZ(2)^52-1)
minimum=QQ(ZZ(2)^52+mant)*QQ(2)^(exp-1023-52)
assert minimum==QQ(4503601027220343)/4398046511104
harmonic_floor=minimum/(kappa*factor)
assert harmonic_floor>1022 and 1022>991
# The same bound still works at the weaker 1/64 margin of CenteringClosure.
coarse_floor=minimum*(QQ(31)/32)/factor
assert coarse_floor>991
result={'status':'EXACT_ROM_EXPORT_CONSUMER_MARGIN',
 'root_error_reused':'<1/1024','root_lower_reused':'1/2','root_map_covered':1536,
 'primitive_reused':{'U':'2^-48','eta':'2^-900','minimum_operation_scale':'>2^-112','absorbed_relative_error':'2^-47'},
 'machine_gate_minimum_exact':str(minimum),'harmonic_floor_exact':str(harmonic_floor),
 'proved_margin':'harmonic >1022 >991; coarse1/64 route also >991',
 'full_source_proof_replayed':False,'source_contracts':'Inherited mixed source-analytical H3 ROOT/STABLE; no complete IEEE assumption',
 'kernel_full_bridge':False}
(out/'certificate.json').write_text(json.dumps(result,indent=2,default=int)+'\n')
print('PASS: 768 conjugate representatives, source error absorption, emitted harmonic floor>1022')
