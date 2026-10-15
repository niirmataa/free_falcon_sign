#!/usr/bin/env sage
# Exact finite pass candidates; numerical source-image certificates remain open.
import hashlib,json,re
from pathlib import Path
from sage.env import SAGE_VERSION
root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
repo=root.parents[4]
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def pin(p):return {'path':str(p),'sha256':sha(p)}
manifest=root/'.build/jobs/keygen_witness113_005/WITNESS113.json'
assert sha(manifest)=='dda0d8b5ec86f6b29139bf6c6ef02f30146ecf7cba87e9fe042b7b8624839ddf'
m=json.loads(manifest.read_text());decoded=Path(m['selected'])/'DECODED.json'
assert sha(decoded)==next(r['sha256'] for r in m['artifacts'] if r['path']==str(decoded))
native=root/'.build/jobs/keygen_norm151_006/NORM151_CANDIDATE.json'
assert sha(native)=='f586d16a9da07b6367374216852faf6462292834230ec58e2953e5e656bd772b'
target=json.loads(native.read_text())
header=repo/'Extra/c/fpr-emulated.h';fft=repo/'Extra/c/falcon-fft.c'
assert sha(header)=='6b897d6c217ef25a322e3b5c3d9488b9d6b8d0e369a710d8fce2259f24e6d84f'
assert sha(fft)=='06b573b636ae368dcda3eb4d89c3936ab31272123440d0d5362317e55d9ac063'
word_source=root/'sage/keygen_fastfpr137_control.sage'
assert sha(word_source)=='a90b036ca826dc9dfd72380dedc62a8ab0f3972d8fa6260b81bd0cc86a40853f'
helper=Path.cwd()/'WORD152.sage'
helper.write_text('M64='+word_source.read_text().split('M64=',1)[1].split('boundaries=',1)[0])
load(str(helper))
text=header.read_text()
def table(name,count):
    body=text.split('static const fpr '+name+'[] = {',1)[1].split('};',1)[0]
    rows=re.findall(r'FPC\(\s*0x([0-9a-f]+)ULL,\s*0x([0-9a-f]+)ULL\)',body)
    assert len(rows)==count
    return [(ZZ(a,16),ZZ(b,16)) for a,b in rows]
square=table('fpr_gm3_square',1024);cubic=table('fpr_gm3_cubic',2048)
def constant(name):return ZZ(re.search('static const fpr '+name+r' = 0x([0-9a-f]+)ULL;',text).group(1),16)
w1=(constant('fpr_W1R'),constant('fpr_W1I'));w2=(constant('fpr_W2R'),constant('fpr_W2I'));w4=(constant('fpr_W4R'),constant('fpr_W4I'))
def sub(x,y):return add(x,neg(y))
def cmul(a,b):return (sub(mul(a[0],b[0]),mul(a[1],b[1])),add(mul(a[0],b[1]),mul(a[1],b[0])))
def cadd(a,b):return (add(a[0],b[0]),add(a[1],b[1]))
def csqr(a):return (sub(mul(a[0],a[0]),mul(a[1],a[1])),double(mul(a[0],a[1])))
def encoded(v):
    assert v in [-1,0,1]
    return ZZ(0xbff0000000000000) if v==-1 else ZZ(0) if v==0 else ZZ(0x3ff0000000000000)
def butterfly(a,v,ht,tw):
    ar,ai=a[v],a[v+768];br,bi=cmul((a[v+ht],a[v+ht+768]),tw)
    return [add(ar,br),add(ai,bi),sub(ar,br),sub(ai,bi)]
def middle_indexed(a,t,m,i):
    r=ZZ(i) if i<768 else ZZ(i)-768
    k=r//t;start=k*t;ht=t//2
    v=r if r<start+ht else r-ht
    words=butterfly(a,v,ht,square[m+k])
    which=(0 if r<start+ht else 2)+(0 if i<768 else 1)
    return words[which]
def triple_words(a,k):
    u=3*ZZ(k);A=(a[u],a[u+768]);B=(a[u+1],a[u+1+768]);C=(a[u+2],a[u+2+768]);q=cubic[512+k]
    b0=cmul(B,q);b1=cmul(b0,w2);b2=cmul(b0,w4)
    q2=csqr(q);c0=cmul(C,q2);c1=cmul(c0,w2);c2=cmul(c0,w4)
    d0=cadd(A,cadd(b0,c0));d1=cadd(A,cadd(b1,c2));d2=cadd(A,cadd(b2,c1))
    return [d0[0],d0[1],d1[0],d1[1],d2[0],d2[1]]
def execute(coefficients):
    a=[encoded(ZZ(v)) for v in coefficients];assert len(a)==1536
    stages={'input':list(a)}
    prior=list(a)
    for u in range(768):
        x,y=a[u],a[u+768];a[u]=add(x,mul(y,w1[0]));a[u+768]=mul(y,w1[1])
    direct=[add(prior[i],mul(prior[i+768],w1[0])) if i<768 else mul(prior[i],w1[1]) for i in range(1536)]
    assert a==direct;stages['first']=list(a)
    t=ZZ(768);m=ZZ(2);pass_index=0
    while t>3:
        ht=t//2;hm=m//2;prior=list(a);seen=0
        for k in range(hm):
            start=ZZ(k)*t
            for v in range(start,start+ht):
                v=ZZ(v);words=butterfly(a,v,ht,square[m+k])
                for slot,word in zip([v,v+768,v+ht,v+ht+768],words):a[slot]=word
                seen+=1
                if pass_index==0 and seen==24:stages['middle0_at24']=list(a)
        assert a==[middle_indexed(prior,t,m,i) for i in range(1536)]
        stages['middle'+str(pass_index)]=list(a);pass_index+=1;t=ht;m*=2
    assert (pass_index,t,m)==(8,3,512)
    prior=list(a)
    for k in range(256):
        u=3*ZZ(k);words=triple_words(a,k)
        for slot,word in zip([u,u+768,u+1,u+1+768,u+2,u+2+768],words):a[slot]=word
    direct=[]
    for i in range(1536):
        r=ZZ(i) if i<768 else ZZ(i)-768;k=r//3
        direct.append(triple_words(prior,k)[2*(r%3)+(0 if i<768 else 1)])
    assert a==direct;stages['triple']=list(a)
    return stages
fg=json.loads(decoded.read_text());f=execute(fg['f']);g=execute(fg['g'])
assert f['triple']==[ZZ(v) for v in target['rt1_words']]
assert g['triple']==[ZZ(v) for v in target['rt2_words']]
acc=ZZ(0)
for x,y in zip(f['triple'],g['triple']):acc=add(add(acc,mul(x,x)),mul(y,y))
assert double(acc)==ZZ(target['doubled_word'])
(Path.cwd()/'FFT152_CANDIDATES.json').write_text(json.dumps({
 'status':'PASS_EXACT_ZZ_SEQUENTIAL_INDEXED_AND_NATIVE_FINAL_CONTROLS; KERNEL_NUMERIC_CERTIFICATES_OPEN',
 'sage_version':SAGE_VERSION,'domains':['ZZ'],'f':{k:[str(v) for v in a] for k,a in f.items()},'g':{k:[str(v) for v in a] for k,a in g.items()},
 'norm_word':str(double(acc)),'source_manifest':pin(manifest),'decoded':pin(decoded),'native_candidate':pin(native),
 'header':pin(header),'fft_source':pin(fft),'word_source':pin(word_source),'helper':pin(helper),
 'scope':'Exact staged candidate images; every indexed pass agrees with sequential ZZ updates and both final vectors match pinned native C. These candidates are not Lean image-equality premises.'},indent=2)+'\n')
