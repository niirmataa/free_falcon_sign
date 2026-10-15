#!/usr/bin/env sage
# Generate balanced literal candidates, with exact ZZ indexing controls.
import hashlib,json
from pathlib import Path
from sage.env import SAGE_VERSION
root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
candidate=root/'.build/jobs/keygen_fftvalues152_009/FFT152_CANDIDATES.json'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
assert sha(candidate)=='3e9da927968cec19503661809c41af3402da104bfad29c2f041e59204b24d891'
data=json.loads(candidate.read_text());rows=[]
def build(values):
    if len(values)==1:return values[0]
    assert len(values)%2==0
    return (build(values[::2]),build(values[1::2]))
def read(tree,index):
    if not isinstance(tree,tuple):return tree
    return read(tree[index%2],index//2)
def emit(tree):
    if not isinstance(tree,tuple):return '(.leaf '+format(int(tree),'#018x')+')'
    return '(.node '+emit(tree[0])+'\n'+emit(tree[1])+')'
for side in ['f','g']:
    for stage,encoded in data[side].items():
        words=[ZZ(v) for v in encoded]
        assert len(words)==1536 and all(0<=v<2^64 for v in words)
        tree=build(words+[ZZ(0)]*512)
        assert all(read(tree,ZZ(i))==words[i] for i in range(1536))
        suffix=''.join(part[0].upper()+part[1:] for part in stage.split('_'))
        module='GeneratedFftTree153'+side.upper()+suffix
        text='import Source3.WordTree153\n\nset_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\nnamespace FT1536.Source3.'+module+'\n\n'
        text+='def data : WordTree153.Tree := '+emit(tree)+'\n\n'
        text+='def word (i : Fin 1536) : BitVec 64 := WordTree153.read data i.val\n\n'
        text+='end FT1536.Source3.'+module+'\n'
        p=Path.cwd()/(module+'.lean');p.write_text(text)
        rows.append({'side':side,'stage':stage,'module':module,'path':str(p),'sha256':sha(p),'words':int(len(words)),'depth':int(11)})
(Path.cwd()/'TREE153_MANIFEST.json').write_text(json.dumps({
 'status':'CANDIDATE_LITERAL_TREES; KERNEL_IMAGE_EQUALITIES_NOT_YET_PROVED','sage_version':SAGE_VERSION,'domains':['ZZ'],
 'candidate':{'path':str(candidate),'sha256':sha(candidate)},'modules':rows},indent=2)+'\n')
