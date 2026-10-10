# sage C_GATE_009_CHECK.sage GATE_JSON WITNESS_JSON OUTDIR
import json,sys,hashlib
from pathlib import Path
p=Path(sys.argv[1]);w=Path(sys.argv[2]);out=Path(sys.argv[3]);out.mkdir(parents=True,exist_ok=True)
assert not (out/'checks.json').exists()
a=json.loads(p.read_text());fixture=json.loads(w.read_text())
assert a['accepted']==1
assert len(a['g00_words'])==768 and len(a['leaf_words'])==1536

def value(h):
 x=ZZ(h,16);sign=x>>63;exp=(x>>52)&2047;mant=x&(ZZ(2)^52-1)
 assert sign==0 and 0<exp<2047
 return QQ(ZZ(2)^52+mant)*QQ(2)^(exp-1023-52)
roots=[value(x) for x in a['g00_words']];leaves=[value(x) for x in a['leaf_words']]
err=max(abs(x-2048) for x in roots)
assert err<QQ(1)/128
assert all(value('4090000053700377')<=x<=value('4114444d1a037d50') for x in leaves)
assert max(abs(x-2048) for x in leaves[:768])<33
assert max(abs(x-QQ(18433)^2/2048) for x in leaves[768:])<33
assert all(abs(t)<=1 for key in ['f','g'] for t in fixture[key])
assert all(-32768<=t<=32767 for key in ['F','G'] for t in fixture[key])
result={'status':'ONE_PUBLIC_FIXTURE_ACCEPTED_BY_PINNED_C_LEAF_GATE',
 'gate_json_sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'witness_sha256':hashlib.sha256(w.read_bytes()).hexdigest(),
 'root_words':768,'leaf_words':1536,'max_root_absolute_error_exact':str(err),
 'last_primary_leaf_exact':str(leaves[767]),'stored_lower_bound_exact':str(value('4090000053700377')),
 'all_leaf_words_in_source_range':True,'all_words_positive_normal':True,
 'kernel_source_binding':False,'universal_root_error':False,'emitted_keygen':False,
 'scope':'C leaf-certificate function only; no sampler randomness, KeyGen distribution, full KeyGen acceptance or emitted-key law claim'}
(out/'checks.json').write_text(json.dumps(result,indent=2,default=int)+'\n')
print('PASS: gate accepted, all raw words decoded in QQ, root error<1/128 for this fixture only')
