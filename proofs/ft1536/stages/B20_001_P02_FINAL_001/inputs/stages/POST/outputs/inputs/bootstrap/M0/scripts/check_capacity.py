"""Independent exact Sage arithmetic for all capacity/framing controls."""
from sage.all import ZZ
import json
from pathlib import Path
W=Path.cwd();normal=json.loads((W/'checks/native_normal.json').read_text());san=json.loads((W/'checks/native_san.json').read_text())
N=1536;B=ZZ(2093922385);x=[1792]*330+[1536]*438
vectors={'witness':x+[-v for v in x],'exact3073':[1536]*768+[-1536]*768,'zero':[0]*N,'not_short':[-32768]*N}
facts={}
for name,s in vectors.items():
    Q=sum(ZZ(s[i])**2+ZZ(s[i])*ZZ(s[i+768])+ZZ(s[i+768])**2 for i in range(768))
    T=sum(abs(ZZ(v)) for v in s);U=sum(abs(ZZ(v))//256 for v in s);bits=10*N+U;payload=1+(bits+7)//8
    actual=normal['baseline'][name]
    assert actual['norm']==Q and actual['short']==int(Q<B)
    assert actual['encoder_query']==payload-1 and actual['payload_query']==payload
    for row in actual['capacities']:
        cap=row['payload_capacity'];assert row['encoder_capacity']==cap-1 and row['canaries']==1
        if cap>=payload:
            assert row['encoder_return']==payload-1 and row['actual_payload']==payload and row['roundtrip']==1 and row['unused_suffix_untouched']==1
        else:assert row['encoder_return']==0 and row['actual_payload']==0
    assert normal['noop'][name]==actual and san['baseline'][name]==actual
    assert actual['framing']==dict(same_hash_input_after_repartition=1,accept_r40=1,accept_r39=0,accept_r40_payload5000=1)
    facts[name]=dict(Q=int(Q),l1=int(T),unary=int(U),bits=int(bits),payload=int(payload),short=bool(Q<B))
assert facts['witness']['Q']==2093088768 and facts['witness']['payload']==3156
assert ZZ(2*N*(B-1)).isqrt()==2536243 and ZZ(2536243)//256==9907
assert 1+(10*N+9907+7)//8==3160<4096
mutations={}
for name in ['terminator','j7','framing']:
    changed=normal[name]['witness']!=normal['baseline']['witness'];assert changed
    if name=='framing':assert normal[name]['witness']['framing']['accept_r39']==1
    else:assert normal[name]['witness']['payload_query']!=3156
    mutations[name]=dict(detected=changed,payload_query=normal[name]['witness']['payload_query'],framing=normal[name]['witness']['framing'])
out=dict(status='PASS',capacity_bound=3160,honest_capacity=4096,nonce_bytes=40,witness=facts['witness'],cases=facts,
    native_query_and_roundtrip=True,canaries=True,asan_ubsan_match=True,noop_pass=True,mutations=mutations,
    old_cli_2049_sufficiency=False,buffer3073_is_universal_STATIC_bound=False,
    no_KeyGen_or_Sign_sample_claim=True,framing_injective_domain='nonce exactly40 bytes; r39 repartition rejected')
(W/'artifacts/capacity_checks.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps(out,indent=2))
