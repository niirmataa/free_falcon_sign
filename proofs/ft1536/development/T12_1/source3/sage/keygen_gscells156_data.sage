#!/usr/bin/env sage
# Reuse pinned GS candidates and emit balanced literal trees for kernel certificates.
from pathlib import Path
import hashlib,json
from sage.env import SAGE_VERSION
root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
candidate=root/'.build/jobs/keygen_gs154_009/GS154_CANDIDATES.json'
assert sha(candidate)=='dcc03ce308ed26ab1e17578ec0884e3d0487d716df97877ccabeb37ae22b987b'
native=root/'.build/jobs/keygen_gs155_008/CONTROL155.json'
assert sha(native)=='9c91e40f46107e152e1c22abe44e29fe60ed5f155dfca67d20fb044a8c55465e'
data=json.loads(candidate.read_text())
helper=root/'sage/keygen_fastfpr137_control.sage'
assert sha(helper)=='a90b036ca826dc9dfd72380dedc62a8ab0f3972d8fa6260b81bd0cc86a40853f'
t=helper.read_text();library=Path.cwd()/'EXACT_WORDS156.sage';library.write_text(t[t.index('M64='):t.index('boundaries=')]);load(str(library))
trace=[ZZ(x) for x in data['norm_trace']];assert len(trace)==1537 and trace[0]==0
for i,(x,y) in enumerate(zip(data['final_f'],data['final_g'])):
    assert trace[i+1]==add(add(trace[i],mul(ZZ(x),ZZ(x))),mul(ZZ(y),ZZ(y)))
assert double(trace[-1])==ZZ(data['norm_word'])
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
rows=[]
for field,suffix,count in [('denominator','Denominator',768),('inverse','Inverse',768),
    ('scaled_f','ScaledF',1536),('scaled_g','ScaledG',1536),('final_f','FinalF',1536),('final_g','FinalG',1536),('norm_trace','Norm',1537)]:
    words=[ZZ(x) for x in data[field]];assert len(words)==count and all(0<=x<2^64 for x in words)
    size=ZZ(1)
    while size<count:size*=2
    tree=build(words+[ZZ(0)]*int(size-count));assert all(read(tree,ZZ(i))==x for i,x in enumerate(words))
    module='GeneratedGsData156'+suffix
    text='import Source3.WordTree153\n'
    if suffix=='Norm':text+='import Source3.FprHeadersFast137\n'
    text+='\nset_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\nnamespace FT1536.Source3.'+module+'\n\n'
    text+='def data : WordTree153.Tree := '+emit(tree)+'\n\n'
    if suffix=='Norm':
        text+='def point (i : Nat) : BitVec 64 := WordTree153.read data i\n'
        text+='def sumWord : BitVec 64 := '+format(int(words[-1]),'#018x')+'\n'
        text+='def finalWord : BitVec 64 := '+format(int(ZZ(data['norm_word'])),'#018x')+'\n\n'
        text+='theorem first : point 0=0 := by decide +kernel\n'
        text+='theorem last : point 1536=sumWord := by decide +kernel\n'
        text+='theorem doubled : FprHeadersFast137.double sumWord=finalWord := by decide +kernel\n'
    else:text+='def word (i : Fin '+str(count)+') : BitVec 64 := WordTree153.read data i.val\n'
    text+='\nend FT1536.Source3.'+module+'\n';p=Path.cwd()/(module+'.lean');p.write_text(text)
    rows.append({'field':field,'module':module,'path':str(p),'sha256':sha(p),'words':int(count),'tree_leaves':int(size)})
(Path.cwd()/'GSDATA156_MANIFEST.json').write_text(json.dumps({'status':'LITERAL_CANDIDATES; KERNEL_IMAGE_EQUALITIES_OPEN',
 'sage_version':SAGE_VERSION,'domains':['ZZ'],'candidate':{'path':str(candidate),'sha256':sha(candidate)},
 'native_control':{'path':str(native),'sha256':sha(native)},'helper':{'path':str(helper),'sha256':sha(helper)},
 'modules':rows},indent=2)+'\n')
