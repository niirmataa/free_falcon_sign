#!/usr/bin/env sage
# Auxiliary finite source/index controls, never a premise of the kernel proof.
import hashlib,json,re
from pathlib import Path
from sage.env import SAGE_VERSION
root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
repo=root.parents[4]
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
fft=repo/'Extra/c/falcon-fft.c';header=repo/'Extra/c/fpr-emulated.h'
assert sha(fft)=='06b573b636ae368dcda3eb4d89c3936ab31272123440d0d5362317e55d9ac063'
assert sha(header)=='6b897d6c217ef25a322e3b5c3d9488b9d6b8d0e369a710d8fce2259f24e6d84f'
body=header.read_text().split('static const fpr fpr_gm3_square[] = {',1)[1].split('};',1)[0]
pairs=[(ZZ(a,16),ZZ(b,16)) for a,b in re.findall(r'FPC\(0x([0-9a-fA-F]+)ULL,\s*0x([0-9a-fA-F]+)ULL\)',body)]
assert len(pairs)==1024
assert all(0<=a<2^64 and 0<=b<2^64 for a,b in pairs)
words=[v for pair in pairs for v in pair]
for i in range(1024):assert (words[2*i],words[2*i+1])==pairs[i]
n=ZZ(1536);hn=ZZ(768);t=hn;m=ZZ(2);passes=[];groups=ZZ(0)
while t>3:
    ht=t//2;hm=m//2
    assert t==ht+ht and hm*t<=hn and m+hm<=1024 and 2*hn<=n<2^64
    visited=[];indices=[]
    for u in range(hm):
        u=ZZ(u);start=u*t
        assert start+ht+ht<=hn and m+u<1024 and start+ht<2^64
        real_index=((m+u)<<1)+0;imag_index=((m+u)<<1)+1
        assert real_index==2*(m+u) and imag_index==2*(m+u)+1
        assert (words[real_index],words[imag_index])==pairs[m+u]
        indices.append(int(m+u));groups+=1
        for v in range(start,start+ht):visited.extend([v,v+hn,v+ht,v+ht+hn])
        assert start+t==(u+1)*t
    assert sorted(visited)==list(range(n))
    passes.append({'m':int(m),'t':int(t),'hm':int(hm),'ht':int(ht),'twiddle_pairs':indices})
    t=ht;m<<=1
assert len(passes)==8 and groups==255 and (t,m)==(3,512)
(Path.cwd()/'FFTGROUP143_CONTROLS.json').write_text(json.dumps({
 'status':'PASS_EXACT_FINITE_CONTROL_ONLY; NOT_SOURCE_EXECUTION_OR_PROBABILITY',
 'sage_version':SAGE_VERSION,'domains':['ZZ'],'sources':[{'path':str(p),'sha256':sha(p)} for p in [fft,header]],
 'table_pairs':len(pairs),'group_count':int(groups),'passes':passes,
 'scope':'Checks all table flattening positions and planned group index/control constraints; later actual source passes are not claimed.'},indent=2)+'\n')
