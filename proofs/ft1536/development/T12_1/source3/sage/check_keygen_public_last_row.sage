"""BATCH_035 finite chronological controls for both actual last-row writes.

Sage standard preparser and ZZ. Public deterministic helper inputs only.
These diagnostics supplement the kernel proof; they do not prove later NTTs.
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
rows=[]
for j in range(256):
    u=2*j;i=512+reverse9(u);k=512+reverse9(u+1)
    rows.append([u,i,word(r,exponent(u)),word(ir,exponent(u)),
        k,word(r,exponent(u+1)),word(ir,exponent(u+1)),word(r,6*(j+1)+1),word(ir,6*(j+1)+1)])
assert len({row[1] for row in rows}|{row[4] for row in rows})==512
image={512+reverse9(u):[word(r,exponent(u)),word(ir,exponent(u))] for u in range(512)}
fixture={'chronological_pairs':rows,'physical_image':image,'terminal_u':512,'k':1,'b':512}
Path('PUBLIC_LAST_FIXTURE.json').write_text(json.dumps(plain(fixture),indent=2)+'\n')

pair=r'''
            printf("P %zu %u %u %u %u %u %u %u %u\n",u,
              (unsigned)(b+rev10((unsigned)(u<<k))),
              (unsigned)gm[b+rev10((unsigned)(u<<k))],
              (unsigned)igm[b+rev10((unsigned)(u<<k))],
              (unsigned)(b+rev10((unsigned)((u+1)<<k))),
              (unsigned)gm[b+rev10((unsigned)((u+1)<<k))],
              (unsigned)igm[b+rev10((unsigned)((u+1)<<k))],x,ix);
'''
end=r'''
    if(logn>1) {
        printf("T %zu %u\n",u,k);
        for(size_t a=0;a<2050;a++)printf("L %zu %u %u\n",a,
            (unsigned)(gm-1)[a],(unsigned)(igm-1)[a]);
    }
'''
main=r'''
int main(void) {
    uint16_t gm[2050],igm[2050];
    for(size_t i=0;i<2050;i++){gm[i]=(uint16_t)(50000+i);igm[i]=(uint16_t)(45000+i);}
    mq_mkgm3(gm+1,igm+1,10);
    return 0;
}
'''
variants={'baseline':source,
    'even_inverse_uses_forward':once(source,
        'igm[b + rev10((unsigned)(u << k))] = (uint16_t)ix;',
        'igm[b + rev10((unsigned)(u << k))] = (uint16_t)x;'),
    'odd_forward_overwrites_even':once(source,
        'gm[b + rev10((unsigned)((u + 1) << k))] = (uint16_t)x;',
        'gm[b + rev10((unsigned)(u << k))] = (uint16_t)x;'),
    'skips_last_pair':once(source,'for (u = 0; u < b; u += 2) {',
        'for (u = 0; u + 2 < b; u += 2) {'),
    'cube_becomes_square':once(source,
        'y, mq_montymul(y, y, Qt, Q0It), Qt, Q0It);',
        'Rt, mq_montymul(y, y, Qt, Q0It), Qt, Q0It);'),
    'upper_inverse_uses_forward':once(source,
        'igm[u] = (uint16_t)mq_montymul(igm[v], igm[v], Qt, Q0It);',
        'igm[u] = (uint16_t)mq_montymul(gm[v], gm[v], Qt, Q0It);')}
records=[]
for mode,flags in [('normal',['-O2']),('ubsan',['-O1','-fsanitize=undefined','-fno-sanitize-recover=all'])]:
  for variant,text in variants.items():
    text=once(text,'ix = mq_montymul(ix, ig2, Qt, Q0It);',
        'ix = mq_montymul(ix, ig2, Qt, Q0It);'+pair)
    text=once(text,'k = logn - 2;',end+'\n\tk = logn - 2;')
    text=once(text,'z, mq_montymul(z, z, Qt, Q0It), Qt, Q0It);',
        'z, mq_montymul(z, z, Qt, Q0It), Qt, Q0It);\n'+
        '\t\tprintf("C %zu %u %u\\n",u,(unsigned)gm[u],(unsigned)igm[u]);')
    squareStore='igm[u] = (uint16_t)mq_montymul('+('gm[v], gm[v]' if variant=='upper_inverse_uses_forward' else 'igm[v], igm[v]')+', Qt, Q0It);'
    text=once(text,squareStore,squareStore+'\n'+
        '\t\tprintf("S %zu %u %u\\n",u,(unsigned)gm[u],(unsigned)igm[u]);')
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
    counts={tag:ZZ(0) for tag in ['P','T','L','C','S']};differences=[]
    for line in ran.stdout.decode().splitlines():
        tag,*payload=line.split();v=[ZZ(x) for x in payload];ordinal=counts[tag];counts[tag]+=1
        if tag=='P':ok=ordinal<256 and v==rows[int(ordinal)]
        elif tag=='T':ok=v==[512,1]
        elif tag=='L':
            a,g,ig=v
            expected=image[int(a-1)] if 513<=a<=1024 else [50000+a,45000+a]
            ok=[g,ig]==expected
        elif tag in ['C','S']:
            i,g,ig=v;expectedIndex=256+ordinal if tag=='C' else 255-ordinal
            ok=i==expectedIndex and [g,ig]==[word(r,table_exponent(i)),word(ir,table_exponent(i))]
        else:raise AssertionError(tag)
        if not ok:differences.append({'tag':tag,'ordinal':ordinal})
    expectedPairs=255 if variant=='skips_last_pair' else 256
    assert counts=={'P':expectedPairs,'T':1,'L':2050,'C':256,'S':255},counts
    if counts['P']!=256:differences.append({'tag':'missing_pair','ordinal':counts['P']})
    assert bool(differences)==(variant!='baseline'),(label,differences[:10])
    artifacts=[cfile,Path(label+'.compile.stdout'),Path(label+'.compile.stderr'),Path(label+'.stdout'),Path(label+'.stderr'),Path(label+'.run.json')]
    records.append({'mode':mode,'variant':variant,'counts':counts,'detected_differences':len(differences),
        'first_differences':differences[:20],'command':command,'artifacts':{str(p):digest(p) for p in artifacts}})
Path('PUBLIC_LAST_CHECK.json').write_text(json.dumps(plain({'status':'PASS_FINITE_SOURCE_CONTROLS',
    'variants':records,'fixture_sha256':digest('PUBLIC_LAST_FIXTURE.json'),'profile_sha256':digest(root/'PROFILE.json'),
    'source_pins':profile['core']['source_files'],
    'scope':'Chronological pairs for both table directions, source cast/rev indices, both next seed words, terminal u512/k1, complete pre-upward table/sentinel image and every executed cube/square paired store. Five mutations in normal/UBSan modes. Finite diagnostic helper controls; the upper-loop composition and later table/NTT/public/KeyGen proof obligations are not discharged by these tests.'}),indent=2)+'\n')
