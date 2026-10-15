#!/usr/bin/env sage
# Exact finite control only; no source-call or probability premise.
import hashlib,json,re,sys
from pathlib import Path
from sage.env import SAGE_VERSION
root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
assert len(sys.argv)==3
label,digest=sys.argv[1:]
assert re.fullmatch(r'keygen_resultant130_[0-9]{3}',label)
assert re.fullmatch(r'[0-9a-f]{64}',digest)
candidate=root/'.build/jobs'/label/'RESULTANT130_CANDIDATES.json'
assert sha(candidate)==digest
manifest=root/'.build/jobs/keygen_witness113_005/WITNESS113.json'
assert sha(manifest)=='dda0d8b5ec86f6b29139bf6c6ef02f30146ecf7cba87e9fe042b7b8624839ddf'
record=json.loads(manifest.read_text());path=Path(record['selected'])/'DECODED.json'
assert sha(path)==next(row['sha256'] for row in record['artifacts'] if row['path']==str(path))
decoded=json.loads(path.read_text())
ring=PolynomialRing(GF(2),'x');x=ring.gen();phi=x^6+x^3+1
assert phi.is_irreducible()
rows=json.loads(candidate.read_text());assert [row['array'] for row in rows]==['f','g']
results=[]
for row in rows:
    values=[ZZ(v) for v in decoded[row['array']]]
    assert len(values)==1536 and all(-1<=v<=1 for v in values)
    packed=[ZZ(v) for v in row['packed']]
    reduced=[ZZ(v) for v in row['reduced']]
    final=[ZZ(v) for v in row['final']]
    assert len(packed)==len(reduced)==len(final)==96
    assert all(0<=v<2^32 for v in packed+reduced+final)
    expected=[sum((values[32*i+j]%2)*2^j for j in range(32)) for i in range(48)]+[ZZ(0)]*48
    assert packed==expected
    polynomial=ring([v%2 for v in values]);remainder=polynomial%phi
    bits=sum(ZZ(remainder[i])*2^i for i in range(6))
    assert reduced[0]==bits and 0<=bits<64
    assert final==reduced
    assert ZZ(row['return'])==ZZ(bits!=0)==1
    results.append({'array':row['array'],'packed_words_checked':int(96),
      'remainder_bits':int(bits),'return':int(row['return']),'nonzero':bool(bits!=0)})
(Path.cwd()/'RESULTANT130_CONTROL.json').write_text(json.dumps({
 'status':'PASS_EXACT_FINITE_CONTROL_ONLY; NOT_SOURCE_OR_PROBABILITY_PROOF',
 'sage_version':SAGE_VERSION,'domains':['ZZ','GF(2)[x]'],
 'candidate':{'path':str(candidate),'sha256':digest},
 'decoded':{'path':str(path),'sha256':sha(path)},
 'manifest':{'path':str(manifest),'sha256':sha(manifest)},
 'modulus':'x^6+x^3+1','irreducible':True,'results':results},indent=2)+'\n')
