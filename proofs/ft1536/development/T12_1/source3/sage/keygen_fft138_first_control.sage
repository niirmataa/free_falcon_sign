#!/usr/bin/env sage
# Exact finite first-pass consistency control, not a source/probability premise.
import hashlib,json,re,sys
from pathlib import Path
from sage.env import SAGE_VERSION
root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
assert len(sys.argv)==3
label,digest=sys.argv[1:]
assert re.fullmatch(r'keygen_fft138_[0-9]{3}',label)
assert re.fullmatch(r'[0-9a-f]{64}',digest)
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
folder=root/'.build/jobs'/label;path=folder/'FFT138_CONTROL_CANDIDATE.json';assert sha(path)==digest
data=json.loads(path.read_text());assert data['g_preserved']
source=root/'formal/Source3/GeneratedFft138FirstF24.lean'
pins=json.loads((root/'.build/fft138/FIRST_CANDIDATES.json').read_text())
assert sha(source)==next(r['sha256'] for r in pins if r['module']=='GeneratedFft138FirstF24')
block=source.read_text().split('def dataBlock : C99FiniteMemory114.Block := ',1)[1].split('\n\ndef localSnapshot',1)[0]
assert block==(folder/'FFT138_CONTROL_BLOCK.txt').read_text()
manifest=root/'.build/jobs/keygen_witness113_005/WITNESS113.json'
assert sha(manifest)=='dda0d8b5ec86f6b29139bf6c6ef02f30146ecf7cba87e9fe042b7b8624839ddf'
m=json.loads(manifest.read_text());decoded=Path(m['selected'])/'DECODED.json'
assert sha(decoded)==next(r['sha256'] for r in m['artifacts'] if r['path']==str(decoded))
f=[ZZ(v) for v in json.loads(decoded.read_text())['f']];assert len(f)==1536 and all(v in [-1,0,1] for v in f)
def encoded(v):return ZZ(0xbff0000000000000) if v==-1 else ZZ(0) if v==0 else ZZ(0x3ff0000000000000)
table={}
for event in data['events']:
 key=(event['name'],tuple(ZZ(v) for v in event['args']));out=ZZ(event['out'])
 assert key not in table or table[key]==out
 table[key]=out
assert len(data['events'])==15
real=ZZ(data['real']);imag=ZZ(data['imag']);expected=[ZZ(0)]*1536
for i in range(768):
 a0=encoded(f[i]);a1=encoded(f[i+768])
 scaled=table[('fpr_mul',(a1,real))]
 expected[i]=table[('fpr_add',(a0,scaled))]
 expected[i+768]=table[('fpr_mul',(a1,imag))]
assert [ZZ(v) for v in data['f_words']]==expected
(Path.cwd()/'FFT138_FIRST_CONTROL.json').write_text(json.dumps({
 'status':'PASS_EXACT_FINITE_CONSISTENCY_ONLY; NOT_SOURCE_OR_PROBABILITY_PREMISE',
 'sage_version':SAGE_VERSION,'domains':['ZZ'],'iterations':int(768),'f_words':int(1536),'g_preserved':True,
 'candidate':{'path':str(path),'sha256':digest},'source':{'path':str(source),'sha256':sha(source)},
 'decoded':{'path':str(decoded),'sha256':sha(decoded)},'event_count':int(15)},indent=2)+'\n')
