# Literal source transport and exact public constants only; no KeyGen,
# seeds or signing. Kernel consumers check the slices/lexer/parser.
from pathlib import Path
import sys, json, hashlib, re
assert parent(1) is ZZ and parent(1/3) is QQ
base=Path(sys.argv[1]).resolve()
expected={'falcon-keygen.c':'0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf',
          'fpr-emulated.h':'242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa'}
data={}
for name,h in expected.items():
    raw=(base/name).read_bytes()
    assert hashlib.sha256(raw).hexdigest()==h
    lines=raw.decode('utf-8').splitlines(keepends=True)
    assert ''.join(lines).encode('utf-8')==raw
    data[name]=lines
def lean_strings(name,lines):
    return 'def '+name+' : List String := [\n'+',\n'.join(json.dumps(s,ensure_ascii=False) for s in lines)+'\n]\n'
code='set_option maxRecDepth 32768\nnamespace FT1536.Source3.Pinned\n'
code+=lean_strings('keygenLines',data['falcon-keygen.c'])
code+=lean_strings('fprLines',data['fpr-emulated.h'])
code+='end FT1536.Source3.Pinned\n'
Path('generated').mkdir()
Path('generated/KeygenSource.lean').write_text(code)
p=ZZ(2147355649); q=ZZ(18433); Fcap=ZZ(2047); n=ZZ(1536)
assert (p-1)%9216==0 and 6*n*Fcap+q<p
lo=ZZ('4090000053700377',16);hi=ZZ('4114444d1a037d50',16)
def value(bits):
    exponent=(bits>>52)&ZZ(2047)
    return QQ(2^52+(bits%2^52))*QQ(2)^(exponent-1075)
assert value(lo)>1024 and value(hi)<332054
assert QQ(q^2)/332054>1023
result={'source_pins':expected,'generated_sha256':hashlib.sha256(code.encode()).hexdigest(),
        'source_line_counts':{k:len(v) for k,v in data.items()},
        'profile':'pinned M0 FPEMU source; uint64_t fpr typedef',
        'prime3_first':str(p),'coarse_NTRU_residual_cap':str(6*n*Fcap+q),
        'source_leaf_endpoints':[str(value(lo)),str(value(hi))],
        'arithmetic':'sage preparser; exact ZZ/QQ',
        'scope':'source transport/constants; no claim of all-KeyGen or exact-leaf error binding'}
Path('SOURCE_TRANSPORT.json').write_text(json.dumps(result,indent=int(2),sort_keys=True)+'\n')
print('KEYGEN_SOURCE_TRANSPORT_PASS',json.dumps(result,sort_keys=True))
