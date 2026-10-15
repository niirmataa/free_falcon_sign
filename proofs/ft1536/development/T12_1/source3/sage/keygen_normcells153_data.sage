#!/usr/bin/env sage
# Literal per-iteration norm candidates, not kernel premises.
import hashlib,json
from pathlib import Path
from sage.env import SAGE_VERSION
root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
candidate=root/'.build/jobs/keygen_norm151_006/NORM151_CANDIDATE.json'
vectors=root/'.build/jobs/keygen_fftvalues152_009/FFT152_CANDIDATES.json'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
assert sha(candidate)=='f586d16a9da07b6367374216852faf6462292834230ec58e2953e5e656bd772b'
assert sha(vectors)=='3e9da927968cec19503661809c41af3402da104bfad29c2f041e59204b24d891'
data=json.loads(candidate.read_text());v=json.loads(vectors.read_text())
assert [ZZ(w) for w in data['rt1_words']]==[ZZ(w) for w in v['f']['triple']]
assert [ZZ(w) for w in data['rt2_words']]==[ZZ(w) for w in v['g']['triple']]
points=[ZZ(0)];events=data['ordered_accumulation'];assert len(events)==1536
for u,event in enumerate(events):
    assert ZZ(event['u'])==u and ZZ(event['before'])==points[-1]
    points.append(ZZ(event['after_g']))
assert len(points)==1537 and all(0<=x<2^64 for x in points)
assert points[-1]==ZZ(data['sum_word'])
def build(values):
    if len(values)==1:return values[0]
    return (build(values[::2]),build(values[1::2]))
def read(tree,index):
    if not isinstance(tree,tuple):return tree
    return read(tree[index%2],index//2)
def emit(tree):
    if not isinstance(tree,tuple):return '(.leaf '+format(int(tree),'#018x')+')'
    return '(.node '+emit(tree[0])+'\n'+emit(tree[1])+')'
tree=build(points+[ZZ(0)]*(2048-len(points)))
assert all(read(tree,ZZ(i))==x for i,x in enumerate(points))
module='GeneratedNormData153'
text='import Source3.WordTree153\nimport Source3.FprHeadersFast137\n\nset_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\nnamespace FT1536.Source3.'+module+'\n\n'
text+='def data : WordTree153.Tree := '+emit(tree)+'\n\n'
text+='def point (i : Nat) : BitVec 64 := WordTree153.read data i\n'
text+='def sumWord : BitVec 64 := '+format(int(points[-1]),'#018x')+'\n'
text+='def finalWord : BitVec 64 := '+format(int(ZZ(data['doubled_word'])),'#018x')+'\n\n'
text+='theorem first : point 0=0 := by decide +kernel\n'
text+='theorem last : point 1536=sumWord := by decide +kernel\n'
text+='theorem doubled : FprHeadersFast137.double sumWord=finalWord := by decide +kernel\n\n'
text+='end FT1536.Source3.'+module+'\n'
p=Path.cwd()/(module+'.lean');p.write_text(text)
(Path.cwd()/'NORMDATA153_MANIFEST.json').write_text(json.dumps({'status':'TRACE_CANDIDATE_ONLY; TRANSITION_CHECKS_OPEN','sage_version':SAGE_VERSION,'domains':['ZZ'],
 'source':{'path':str(candidate),'sha256':sha(candidate)},'vectors':{'path':str(vectors),'sha256':sha(vectors)},
 'module':module,'output':{'path':str(p),'sha256':sha(p)},'points':int(len(points)),'sum_word':str(points[-1]),'final_word':data['doubled_word']},indent=2)+'\n')
