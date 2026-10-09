"""BATCH_036 finite chronological controls: whole upper loops and the finish.

Sage standard preparser and ZZ. Public deterministic helper inputs only.
Checked here: every executed cube/square paired store, the complete final
gm/igm image 1..1023 with sentinels, and the exceptional top row where
igm[0] is radix/(2*firstRoot-1), NOT radix/firstRoot. Six mutations in
normal/UBSan modes. These diagnostics supplement the kernel proof; they do
not prove the remaining NTT/nonzero/division/KeyGen obligations.
"""
import hashlib
import json
import os
from pathlib import Path
import subprocess

root = Path(os.environ['FT1536_SOURCE3_ORIGINAL_W'])/'inputs/source'
profile = json.loads((root/'PROFILE.json').read_text())
def digest(path): return hashlib.sha256(Path(path).read_bytes()).hexdigest()
for name,pin in profile['core']['source_files'].items():
    assert digest(root/name)==pin,name
source = (root/'falcon-vrfy.c').read_text()
def once(text,old,new):
    assert text.count(old)==1,old
    return text.replace(old,new,int(1))
def plain(x):
    if isinstance(x,dict): return {str(k):plain(v) for k,v in x.items()}
    if isinstance(x,(list,tuple)): return [plain(v) for v in x]
    if isinstance(x,(str,bool)) or x is None: return x
    return int(x)

q=ZZ(18433);radix=ZZ(2)^16;r=power_mod(ZZ(25),2,q);ir=inverse_mod(r,q)
assert q.is_prime() and power_mod(r,4608,q)==1
def reverse9(x):
    return sum(((ZZ(x)>>b)&1)*2^(8-b) for b in range(9))
def word(base,e): return (radix*power_mod(base,e,q))%q
def exponent(u): return 3*u+1+u%2
def table_exponent(i):
    i=max(ZZ(1),ZZ(i));level=ZZ(i.nbits()-1);position=i-2^level
    rev=sum(((position>>b)&1)*2^(level-1-b) for b in range(level))
    return (1 if level==9 else 3*2^(8-level))*exponent(rev)
assert table_exponent(0)==table_exponent(1)==768
first_root=power_mod(r,768,q)
exceptional=(radix*inverse_mod((2*first_root-1)%q,q))%q
naive=word(ir,table_exponent(0))
top=[word(r,table_exponent(0)),word(r,table_exponent(1)),word(r,table_exponent(1)),exceptional]
# raw word law of the source chain: mq_div_18433(R2t, mq_sub(mq_add(w,w,Qt),Rt,Qt))
divisor=(2*top[2]-ZZ(10237))%q
raw=(ZZ(4564)*inverse_mod(divisor,q))%q
assert raw==top[3]==(radix*inverse_mod((2*first_root-1)%q,q))%q
assert top[3]!=naive
image={i:[word(r,table_exponent(i)),word(ir,table_exponent(i))] for i in range(1,1024)}
fixture={'final_image':image,'top':[top[0],top[1],top[2],top[3]],'naive_igm0':naive,
    'exceptional_igm0':exceptional,'raw_word_law':raw}
Path('PUBLIC_UPPER_FIXTURE.json').write_text(json.dumps(plain(fixture),indent=2)+'\n')

pair=r'''
            printf("C %zu %u %u\n",u,(unsigned)gm[u],(unsigned)igm[u]);
'''
square=r'''
        printf("S %zu %u %u\n",u,(unsigned)gm[u],(unsigned)igm[u]);
'''
end=r'''
    printf("F %u %u %u %u\n",(unsigned)gm[0],(unsigned)gm[1],(unsigned)w,(unsigned)igm[0]);
    for(size_t a=0;a<2050;a++)printf("L %zu %u %u\n",a,
        (unsigned)(gm-1)[a],(unsigned)(igm-1)[a]);
'''
main=r'''
int main(void) {
    uint16_t gm[2050],igm[2050];
    for(size_t i=0;i<2050;i++){gm[i]=(uint16_t)(50000+i);igm[i]=(uint16_t)(45000+i);}
    mq_mkgm3(gm+1,igm+1,10);
    return 0;
}
'''
finishTail='Qt));\n}\n\n/*\n * Compute NTT on a ring element, binary case.'
def instrument(text,squareStore):
    text=once(text,'z, mq_montymul(z, z, Qt, Q0It), Qt, Q0It);',
        'z, mq_montymul(z, z, Qt, Q0It), Qt, Q0It);'+pair)
    text=once(text,squareStore,squareStore+square)
    return once(text,finishTail,'Qt));\n'+end+'}\n\n/*\n * Compute NTT on a ring element, binary case.')
baseSquare='igm[u] = (uint16_t)mq_montymul(igm[v], igm[v], Qt, Q0It);'
variants={'baseline':source,
    'gm0_copies_gm2':once(source,'gm[0] = gm[1];','gm[0] = gm[2];'),
    'w_reads_igm1':once(source,'w = gm[1];','w = igm[1];'),
    'igm0_wrong_numerator':once(source,'mq_div_18433(\n\t\tR2t,','mq_div_18433(\n\t\tRt,'),
    'igm0_add_instead_of_sub':once(source,'mq_sub(mq_add(w, w, Qt), Rt, Qt));',
        'mq_add(mq_add(w, w, Qt), Rt, Qt));'),
    'cube_inverse_reads_forward':once(source,'z = igm[u << 1];','z = gm[u << 1];'),
    'square_uses_forward':once(source,baseSquare,
        'igm[u] = (uint16_t)mq_montymul(gm[v], gm[v], Qt, Q0It);')}
records=[]
for mode,flags in [('normal',['-O2']),('ubsan',['-O1','-fsanitize=undefined','-fno-sanitize-recover=all'])]:
  for variant,text in variants.items():
    squareStore='igm[u] = (uint16_t)mq_montymul('+('gm[v], gm[v]' if variant=='square_uses_forward' else 'igm[v], igm[v]')+', Qt, Q0It);'
    text=instrument(text,squareStore)
    label=mode+'_'+variant;cfile=Path(label+'.c');binary=Path(label+'.bin')
    cfile.write_text('#include <stdio.h>\n'+text+main)
    command=['gcc','-std=c99','-Wall','-Wextra','-Werror','-ffunction-sections','-fdata-sections']+profile['core']['Makefile_flags']+flags+[
        '-I',str(root),str(cfile),'-Wl,--gc-sections','-o',str(binary)]
    compiled=subprocess.run(command,capture_output=True)
    Path(label+'.compile.stdout').write_bytes(compiled.stdout);Path(label+'.compile.stderr').write_bytes(compiled.stderr)
    assert compiled.returncode==0 and not compiled.stdout and not compiled.stderr,label
    ran=subprocess.run([str(binary.resolve())],capture_output=True)
    Path(label+'.stdout').write_bytes(ran.stdout);Path(label+'.stderr').write_bytes(ran.stderr)
    Path(label+'.run.json').write_text(json.dumps({'returncode':ran.returncode})+'\n')
    assert ran.returncode==0 and not ran.stderr,label
    counts={tag:ZZ(0) for tag in ['C','S','F','L']};differences=[]
    for line in ran.stdout.decode().splitlines():
        tag,*payload=line.split();v=[ZZ(x) for x in payload];ordinal=counts[tag];counts[tag]+=1
        if tag=='C':
            i,g,ig=v;ok=i==256+ordinal and [g,ig]==image[int(i)]
        elif tag=='S':
            i,g,ig=v;ok=i==255-ordinal and [g,ig]==image[int(i)]
        elif tag=='F':
            ok=v==top
            if ok:ok=v[3]!=naive
        elif tag=='L':
            a,g,ig=v
            expected=[top[0],top[3]] if a==1 else (image[int(a-1)] if 2<=a<=1024 else [50000+a,45000+a])
            ok=[g,ig]==expected
        else:raise AssertionError(tag)
        if not ok:differences.append({'tag':tag,'ordinal':ordinal})
    assert counts=={'C':256,'S':255,'F':1,'L':2050},counts
    assert bool(differences)==(variant!='baseline'),(label,differences[:10])
    artifacts=[cfile,Path(label+'.compile.stdout'),Path(label+'.compile.stderr'),Path(label+'.stdout'),Path(label+'.stderr'),Path(label+'.run.json')]
    records.append({'mode':mode,'variant':variant,'counts':counts,'detected_differences':len(differences),
        'first_differences':differences[:20],'command':command,'artifacts':{str(p):digest(p) for p in artifacts}})
Path('PUBLIC_UPPER_CHECK.json').write_text(json.dumps(plain({'status':'PASS_FINITE_SOURCE_CONTROLS',
    'variants':records,'fixture_sha256':digest('PUBLIC_UPPER_FIXTURE.json'),'profile_sha256':digest(root/'PROFILE.json'),
    'source_pins':profile['core']['source_files'],
    'scope':'Complete final gm/igm image 1..1023 with sentinels, all256 cube and255 square paired stores and the exceptional top row: gm[0]=gm[1], w=gm[1], igm[0]=radix/(2*firstRoot-1), provably different from radix/firstRoot. Raw word law checked exactly over ZZ. Six mutations in normal/UBSan modes. Finite diagnostic controls; they do not discharge the source proofs of the table images, later NTTs, nonzero tests, division/inverse, canonical h, fInv or the SAME-material equations.'}),indent=2)+'\n')
