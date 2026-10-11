#!/usr/bin/env sage
# PUBLIC out-of-profile counterexample to an unqualified capacity-window claim.
import os,subprocess,json

def locate(name):
    here=os.getcwd()
    for _ in range(12):
        p=os.path.join(here,name)
        if os.path.exists(p):return p
        here=os.path.dirname(here)
    raise RuntimeError(name)
source=locate('Extra/c/falcon-enc.c')
include=os.path.dirname(source)
probe=r'''
#include <stdio.h>
#include <stdint.h>
#include "internal.h"
int main(void) {
 unsigned char out[8]={0xa5,0xa5,0xa5,0xa5,0xa5,0xa5,0xa5,0xa5};
 int16_t x[2]={0x1234,0x5678};
 size_t result=falcon_encode_small(out,3,FALCON_COMP_NONE,18433,x,0);
 printf("%zu\n",result);
 for(unsigned i=0;i<8;i++)printf("%02x",out[i]);
 printf("\n");
 return 0;
}
'''
open('scope.c','w').write(probe)
# The allocation has eight bytes and x has two readable coefficients:
# writing byte3 is C-defined, but lies outside the requested [0,3) window.
length=ZZ(3)<<0
indices=[u+k for u in range(0,int(length),2) for k in [0,1]]
assert length==3 and indices==[0,1,2,3] and max(indices)>=length
rows=[]
for mode in ['normal','ubsan']:
    flags=['-O1','-std=c99','-ffunction-sections','-fdata-sections','-Wl,--gc-sections','-I',include]
    if mode=='ubsan':flags+=['-fsanitize=undefined','-fno-sanitize-recover=all']
    binary=os.path.abspath('scope_'+mode)
    build=subprocess.run(['gcc',*flags,source,'scope.c','-o',binary],capture_output=True,text=True)
    open('compile_'+mode+'.stdout','w').write(build.stdout)
    open('compile_'+mode+'.stderr','w').write(build.stderr)
    assert build.returncode==0
    run=subprocess.run([binary],capture_output=True,text=True)
    open('run_'+mode+'.stdout','w').write(run.stdout)
    open('run_'+mode+'.stderr','w').write(run.stderr)
    assert run.returncode==0 and run.stderr==''
    assert run.stdout=='3\n12345678a5a5a5a5\n'
    rows.append({'mode':mode,'return':int(3),'capacity':int(3),'changed_offsets':list(map(int,[0,1,2,3])),'allocated_bytes':int(8),'undefined_behavior_reported':False})
result={'status':'OUT_OF_PROFILE_CAPACITY_COUNTEREXAMPLE_REPRODUCED','rows':rows,
 'scope':'One defined PUBLIC C call q18433/logn0/NONE disproves an unqualified capacity-window statement. The actual KeyGen profile is logn10, whose argument restriction is derived separately. No profile bug or failure of the block frame is claimed.'}
with open('CAPACITY_SCOPE_CHECK.json','w') as stream:json.dump(result,stream,indent=2);stream.write('\n')
