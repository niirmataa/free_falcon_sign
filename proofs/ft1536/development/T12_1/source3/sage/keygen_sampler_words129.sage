#!/usr/bin/env sage
# Public synthetic candidate words only; source and memory checks are separate.
import hashlib,json
from pathlib import Path
from sage.env import SAGE_VERSION
root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
manifest=root/'.build/jobs/keygen_witness113_005/WITNESS113.json'
assert sha(manifest)=='dda0d8b5ec86f6b29139bf6c6ef02f30146ecf7cba87e9fe042b7b8624839ddf'
record=json.loads(manifest.read_text())
path=Path(record['selected'])/'DECODED.json'
assert sha(path)==next(row['sha256'] for row in record['artifacts'] if row['path']==str(path))
decoded=json.loads(path.read_text())
text='import Source3.KeygenMaterial\nimport Source3.C99FiniteMap114\n\nnamespace FT1536.Source3.GeneratedSamplerWords129\n'
def digits(index):
    result=[]
    while index:
        result.append(int(index%2));index=index//2
    return tuple(result)
def render(cells):
    if not cells:return '.empty'
    here='none' if () not in cells else '(some ('+str(cells[()])+'))'
    zero={key[1:]:value for key,value in cells.items() if key and key[0]==0}
    one={key[1:]:value for key,value in cells.items() if key and key[0]==1}
    return '(.node '+here+' '+render(zero)+' '+render(one)+')'
for label in ['f','g']:
    values=[ZZ(x) for x in decoded[label]]
    assert len(values)==1536 and all(-1<=x<=1 for x in values)
    cells={digits(i):value for i,value in enumerate(values)}
    assert len(cells)==1536
    text+='def '+label+'Words : C99FiniteMap114.Tree Int := '+render(cells)+'\n\n'
    text+='def '+label+'Vector : Geometry.Vec := fun i => ((C99FiniteMap114.lookup '+label+'Words i.val).getD 0,(C99FiniteMap114.lookup '+label+'Words (i.val+768)).getD 0)\n\n'
text+='end FT1536.Source3.GeneratedSamplerWords129\n'
output=Path.cwd()/'GeneratedSamplerWords129.lean';output.write_text(text)
(Path.cwd()/'SAMPLER_WORDS129.json').write_text(json.dumps({
 'status':'CANDIDATE_DATA_ONLY; KERNEL_MEMORY_AND_SOURCE_CHECKS_REQUIRED',
 'sage_version':SAGE_VERSION,'input':{'path':str(path),'sha256':sha(path)},
 'manifest':{'path':str(manifest),'sha256':sha(manifest)},
 'output':{'path':str(output),'sha256':sha(output)},'words_per_array':int(1536)},indent=2)+'\n')
