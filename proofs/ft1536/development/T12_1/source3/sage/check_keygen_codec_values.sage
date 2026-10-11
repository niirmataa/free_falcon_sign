#!/usr/bin/env sage
# PUBLIC codec value-boundary controls for BATCH_065; finite evidence only.
import os
import subprocess
import json
from datetime import datetime, timezone

def locate(name):
    here=os.getcwd()
    for _ in range(12):
        p=os.path.join(here,name)
        if os.path.exists(p):return p
        here=os.path.dirname(here)
    raise RuntimeError(name)

source=locate('Extra/c/falcon-enc.c')
include=os.path.dirname(source)
raw=open(source).read()
harness=r'''
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "internal.h"
int main(int argc,char **argv) {
 if(argc!=7) return 90;
 int comp=atoi(argv[1]); unsigned q=(unsigned)atoi(argv[2]);
 unsigned logn=(unsigned)atoi(argv[3]); size_t cap=(size_t)atoi(argv[4]);
 int seed=atoi(argv[5]),dry=atoi(argv[6]);
 size_t n=q==12289?((size_t)1<<logn):((size_t)3<<(logn-1));
 int16_t *x=malloc(n*sizeof(*x)); unsigned char *storage=malloc(100128);
 if(!x||!storage||cap>100000) return 91;
 for(size_t i=0;i<n;i++) x[i]=seed==0?0:seed<0?(int16_t[]){-32768,-32767,-256,-1,0,1,255,32767}[i%8]:(int16_t)((i*37+seed)%515-257);
 for(size_t i=0;i<100128;i++)storage[i]=0xa5;
 size_t ret=falcon_encode_small(dry?NULL:storage+32,cap,comp,q,x,logn);
 printf("%zu\n",ret);
 for(size_t i=0;i<32+cap+32;i++)printf("%02x",storage[i]);
 printf("\n");
 for(size_t i=0;i<n;i++)if(x[i]!=(seed==0?0:seed<0?(int16_t[]){-32768,-32767,-256,-1,0,1,255,32767}[i%8]:(int16_t)((i*37+seed)%515-257)))return 92;
 free(x);free(storage);return 0;
}
'''
open('probe.c','w').write(harness)

def encode(values,comp,q):
    if comp==0:
        result=[]
        for w in values:
            v=ZZ(w)%65536
            result.extend([int(v>>8),int(v&255)])
        return result
    if comp!=1:return []
    j=ZZ(7 if q==12289 else 8)
    bits=[]
    for w in values:
        a=abs(ZZ(w))
        bits.append(int(w<0))
        bits.extend(int((a>>k)&1) for k in reversed(range(int(j))))
        bits.extend([0]*int(a>>j));bits.append(1)
    bits.extend([0]*int((-len(bits))%8))
    return [sum(bits[i+k]<<(7-k) for k in range(8)) for i in range(0,len(bits),8)]

cases=[]
# int16 extremes distinguish signed loading/promotion and unsigned casts.
for q,logn,seed in [(18433,10,-1),(12289,3,-1),(18433,2,0),(12289,2,7)]:
    n=int(ZZ(2)^logn if q==12289 else 3*ZZ(2)^(logn-1))
    values=([-32768,-32767,-256,-1,0,1,255,32767]*((n+7)//8))[:n] if seed<0 else [0 if seed==0 else int((i*37+seed)%515-257) for i in range(n)]
    for comp in [0,1,2]:
        encoded=encode(values,comp,q)
        for cap in sorted(set([0,1,max(0,len(encoded)-1),len(encoded),len(encoded)+7])):
            cases.append((int(comp),int(q),int(logn),int(cap),int(seed),0,encoded))
        cases.append((int(comp),int(q),int(logn),0,int(seed),1,encoded))

def check(binary,case):
    comp,q,logn,cap,seed,dry,encoded=case
    run=subprocess.run([binary,*map(str,[comp,q,logn,cap,seed,dry])],capture_output=True,text=True)
    if run.returncode!=0:return False
    lines=run.stdout.splitlines()
    if len(lines)!=2:return False
    if comp not in [0,1]:ret=0;written=[]
    elif dry:ret=len(encoded);written=[]
    elif cap<len(encoded):ret=0;written=encoded[:cap] if comp==1 else []
    else:ret=len(encoded);written=encoded
    expected=[165]*32+written+[165]*(cap+32-len(written))
    return int(lines[0])==ret and lines[1]==''.join('%02x'%x for x in expected)

mutations={
 'none_high_byte':('buf[u + 0] = (unsigned char)(w >> 8);','buf[u + 0] = (unsigned char)(w >> 7);'),
 'static_sign':('lo = 1U << j;','lo = 0;'),
 'static_width':('j = 8;','j = 7;'),
 'static_final_one':('acc += ((unsigned)ne >> 15) & 1;','acc += 0;'),
 'static_byte_shift':('buf[u] = (unsigned char)(acc >> acc_len);','buf[u+1] = (unsigned char)(acc >> acc_len);'),
 'dispatch_swap':('return compress_none(out, max_out_len, q, x, logn);','return compress_static(out, max_out_len, q, x, logn);')}
results=[]
for mode in ['normal','ubsan']:
    flags=['-O1','-std=c99','-ffunction-sections','-fdata-sections','-Wl,--gc-sections','-I',include]
    if mode=='ubsan':flags+=['-fsanitize=undefined','-fno-sanitize-recover=all']
    binary=os.path.abspath('probe_'+mode)
    build=subprocess.run(['gcc',*flags,source,'probe.c','-o',binary],capture_output=True,text=True)
    open('compile_'+mode+'.stdout','w').write(build.stdout);open('compile_'+mode+'.stderr','w').write(build.stderr)
    assert build.returncode==0
    baseline=[check(binary,case) for case in cases]
    assert all(baseline)
    detected={}
    for name,(before,after) in mutations.items():
        function='compress_none' if name.startswith('none_') else 'falcon_encode_small' if name=='dispatch_swap' else 'compress_static'
        start=raw.index(function+'(');end=raw.index('\n}\n',start)+2
        body=raw[start:end];assert before in body
        changed=raw[:start]+body.replace(before,after,1)+raw[end:]
        mutant='mutant_'+name+'.c';open(mutant,'w').write(changed)
        binary=os.path.abspath('mutant_'+name+'_'+mode)
        build=subprocess.run(['gcc',*flags,mutant,'probe.c','-o',binary],capture_output=True,text=True)
        assert build.returncode==0,build.stderr
        detected[name]=not all(check(binary,case) for case in cases)
    with open('MUTATION_PROGRESS_'+mode+'.json','w') as stream:json.dump(detected,stream,indent=2)
    assert all(detected.values())
    results.append({'mode':mode,'cases':len(cases),'baseline_pass':all(baseline),'mutations':detected})
out={'utc':datetime.now(timezone.utc).isoformat(),'status':'PASS_PUBLIC_CODEC_VALUE_CONTROLS',
 'scope':'Finite exact ZZ int16-boundary reference vs actual Extra/c encoder normal/UBSan; PUBLIC synthetic coefficients only; exact bytes/returns/canaries/input preservation. No universal codec, projection adequacy, KeyGen or law proof.',
 'results':results}
with open('CODEC_VALUE_CHECK.json','w') as stream:json.dump(out,stream,indent=2);stream.write('\n')
