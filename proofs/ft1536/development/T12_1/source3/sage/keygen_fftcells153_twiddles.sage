#!/usr/bin/env sage
# Active literal twiddle ranges; all source equalities still require Lean.
import hashlib,json,re
from pathlib import Path
from sage.env import SAGE_VERSION
root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
header=root.parents[4]/'Extra/c/fpr-emulated.h'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
assert sha(header)=='6b897d6c217ef25a322e3b5c3d9488b9d6b8d0e369a710d8fce2259f24e6d84f'
text=header.read_text();rows=[]
def build(values):
    if len(values)==1:return values[0]
    return (build(values[::2]),build(values[1::2]))
def read(tree,index):
    if not isinstance(tree,tuple):return tree
    return read(tree[index%2],index//2)
def emit(tree):
    if not isinstance(tree,tuple):return '(.leaf '+format(int(tree),'#018x')+')'
    return '(.node '+emit(tree[0])+'\n'+emit(tree[1])+')'
for kind,start,count,total,capacity in [('Square',0,384,1024,1024),('Cubic',512,256,2048,512)]:
    body=text.split('static const fpr fpr_gm3_'+kind.lower()+'[] = {',1)[1].split('};',1)[0]
    pairs=re.findall(r'FPC\(\s*0x([0-9a-f]+)ULL,\s*0x([0-9a-f]+)ULL\)',body)
    assert len(pairs)==total
    words=[ZZ(v,16) for pair in pairs[start:start+count] for v in pair]
    assert len(words)==2*count and all(0<=v<2^64 for v in words)
    tree=build(words+[ZZ(0)]*(capacity-len(words)))
    assert all(read(tree,ZZ(i))==word for i,word in enumerate(words))
    module='GeneratedFftTwiddle153'+kind
    output='import Source3.WordTree153\n\nset_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\nnamespace FT1536.Source3.'+module+'\n\n'
    output+='def data : WordTree153.Tree := '+emit(tree)+'\n\n'
    output+='def word (i : Fin '+str(len(words))+') : BitVec 64 := WordTree153.read data i.val\n\n'
    output+='end FT1536.Source3.'+module+'\n'
    p=Path.cwd()/(module+'.lean');p.write_text(output)
    rows.append({'kind':kind,'start_pair':int(start),'pair_count':int(count),'words':int(len(words)),'module':module,'path':str(p),'sha256':sha(p)})
(Path.cwd()/'TWIDDLE153_MANIFEST.json').write_text(json.dumps({'status':'LITERAL_CANDIDATES; SOURCE_CHECKS_OPEN','sage_version':SAGE_VERSION,'domains':['ZZ'],'header':{'path':str(header),'sha256':sha(header)},'modules':rows},indent=2)+'\n')
