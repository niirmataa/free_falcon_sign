#!/usr/bin/env sage
# Exact finite image control, never a source or probability proof premise.
import hashlib,json,re,sys
from pathlib import Path
from sage.env import SAGE_VERSION
root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
assert len(sys.argv)==3
label,digest=sys.argv[1:]
assert re.fullmatch(r'keygen_conversion136_[0-9]{3}',label)
assert re.fullmatch(r'[0-9a-f]{64}',digest)
folder=root/'.build/jobs'/label;candidate=folder/'CONVERSION136_IMAGES.json'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
assert sha(candidate)==digest
images=json.loads(candidate.read_text());assert images['first_output_preserved_after_second']
manifest=root/'.build/jobs/keygen_witness113_005/WITNESS113.json'
assert sha(manifest)=='dda0d8b5ec86f6b29139bf6c6ef02f30146ecf7cba87e9fe042b7b8624839ddf'
m=json.loads(manifest.read_text());decoded=Path(m['selected'])/'DECODED.json'
assert sha(decoded)==next(r['sha256'] for r in m['artifacts'] if r['path']==str(decoded))
values=json.loads(decoded.read_text());pins=json.loads((root/'.build/conversion136/GENERATED_CANDIDATES.json').read_text())
assert [r['array'] for r in images['outputs']]==['f','g']
results=[]
for row,tag in zip(images['outputs'],['F','G']):
    name='GeneratedConversion136'+tag+'23';source=root/'formal/Source3'/(name+'.lean')
    pin=next(r for r in pins if r['module']==name);assert sha(source)==pin['sha256']
    text=source.read_text();block=text.split('def dataBlock : C99FiniteMemory114.Block := ',1)[1].split('\n\ndef localSnapshot',1)[0]
    assert block==(folder/('CONVERSION136_'+tag+'_BLOCK.txt')).read_text()
    coefficients=[ZZ(x) for x in values[row['array']]];words=[ZZ(x) for x in row['words']]
    assert len(coefficients)==len(words)==1536
    assert all(x in [-1,0,1] for x in coefficients)
    expected=[ZZ(0xbff0000000000000) if x==-1 else ZZ(0) if x==0 else ZZ(0x3ff0000000000000) for x in coefficients]
    assert words==expected
    results.append({'array':row['array'],'count':int(1536),'source':{'path':str(source),'sha256':sha(source)},
      'block_text':{'path':str(folder/('CONVERSION136_'+tag+'_BLOCK.txt')),'sha256':sha(folder/('CONVERSION136_'+tag+'_BLOCK.txt'))},
      'negative':int(coefficients.count(-1)),'zero':int(coefficients.count(0)),'positive':int(coefficients.count(1))})
(Path.cwd()/'CONVERSION136_CONTROL.json').write_text(json.dumps({
 'status':'PASS_EXACT_FINITE_CONTROL_ONLY; NOT_SOURCE_OR_PROBABILITY_PREMISE',
 'sage_version':SAGE_VERSION,'domains':['ZZ'],'candidate':{'path':str(candidate),'sha256':digest},
 'decoded':{'path':str(decoded),'sha256':sha(decoded)},'results':results,
 'first_output_preserved_after_second':True},indent=2)+'\n')
