"""Finite refill controls: independent ZZ Keccak, real context, two calls.

Only public labelled input bytes and synthetic helper states are used. This
does not run KeyGen or establish a probability law or compiler refinement.
"""
import hashlib
import json
import os
from pathlib import Path
import subprocess

root = Path(os.environ['FT1536_SOURCE3_ORIGINAL_W'])/'inputs/source'
profile = json.loads((root/'PROFILE.json').read_text())
for name,pin in profile['core']['source_files'].items():
    assert hashlib.sha256((root/name).read_bytes()).hexdigest() == pin, name
lines = (root/'falcon-keygen.c').read_text().splitlines(keepends=True)
def region(a,b):
    return ''.join(lines[int(a-1):int(b)])
def once(text,old,new):
    assert text.count(old)==int(1), old
    return text.replace(old,new,int(1))
def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()

mask = (ZZ(1)<<64)-1
rc=[]
lfsr=ZZ(1)
for round_index in range(24):
    word=ZZ(0)
    for j in range(7):
        if lfsr & 1:
            word = word ^^ (ZZ(1)<<((ZZ(1)<<j)-1))
        lfsr = ((lfsr<<1) ^^ (ZZ(0x71) if lfsr & 128 else ZZ(0))) & 255
    rc.append(word)
assert rc[0]==1 and rc[23]==ZZ(0x8000000080008008)
rho=[ZZ(0) for _ in range(25)]
x,y=ZZ(1),ZZ(0)
for t in range(24):
    rho[int(x+5*y)] = ((ZZ(t)+1)*(ZZ(t)+2)//2)%64
    x,y=y,(2*x+3*y)%5
def rotate(a,n):
    return ((a<<n)|(a>>(64-n))) & mask if n else a
def permute(a):
    a=list(a)
    for constant in rc:
        c=[]
        for x in range(5):
            z=ZZ(0)
            for y in range(5):
                z=z ^^ a[int(x+5*y)]
            c.append(z)
        d=[c[int((x-1)%5)] ^^ rotate(c[int((x+1)%5)],ZZ(1)) for x in range(5)]
        b=[ZZ(0) for _ in range(25)]
        for x in range(5):
            for y in range(5):
                b[int(y+5*((2*x+3*y)%5))]=rotate(a[int(x+5*y)] ^^ d[int(x)],rho[int(x+5*y)])
        for x in range(5):
            for y in range(5):
                a[int(x+5*y)]=(b[int(x+5*y)] ^^ ((mask ^^ b[int((x+1)%5+5*y)]) & b[int((x+2)%5+5*y)])) & mask
        a[0]=a[0] ^^ constant
    return a
assert permute([ZZ(0)]*int(25))[0]==ZZ(0xf1258f7940e1dde7)
complement={int(i) for i in [1,2,8,12,17,20]}
inputs=[]; permutation_expected=[]
for k in range(8):
    logical=[ZZ(0) if k==0 else ((ZZ(k)*ZZ(0x0123456789abcdef)+(ZZ(i)+1)*ZZ(0x9e3779b97f4a7c15)) & mask) for i in range(25)]
    inputs.append([word ^^ (mask if i in complement else ZZ(0)) for i,word in enumerate(logical)])
    result=permute(logical)
    permutation_expected.append([int(k),int(0)]+[int(word ^^ (mask if i in complement else ZZ(0))) for i,word in enumerate(result)])

rng=once(region(4706,4735),'get_rng_u64(shake_context *rng)','get_rng_u64_impl(shake_context *rng)')
sampler=region(4753,4813)
sampler=once(sampler,'x = (uint32_t)rb & 3U;','x = (uint32_t)rb & 3U; draws++; if (x == 3U) rejects++;')
shake=(root/'shake.c').read_text()
header=r'''
#include <stdio.h>
#include <stddef.h>
#include <inttypes.h>
#include "internal.h"
typedef char le_profile_required[(FALCON_LE_U == 1) ? 1 : -1];
'''+region(4679,4698)
wrapper=r'''
static unsigned long words,draws,rejects;
static uint64_t get_rng_u64(shake_context *rng) { words++; return get_rng_u64_impl(rng); }
'''
data='static const uint64_t test_inputs[8][25] = {\n'+',\n'.join('{'+','.join(str(w)+'ULL' for w in row)+'}' for row in inputs)+'\n};\n'
main=r'''
int main(void) {
  printf("L %zu %zu %zu %zu %zu %zu %zu %zu %d\n",sizeof(shake_context),offsetof(shake_context,dbuf),
    offsetof(shake_context,dptr),offsetof(shake_context,rate),offsetof(shake_context,A),
    sizeof(falcon_keygen),offsetof(falcon_keygen,rng),offsetof(falcon_keygen,tmp),FALCON_LE_U);
  for (unsigned k=0;k<8;k++) {
    uint64_t storage[27];
    storage[0]=storage[26]=123456789012345ULL;
    memcpy(storage+1,test_inputs[k],sizeof test_inputs[k]);
    process_block(storage+1);
    printf("P %u %d",k,storage[0]!=123456789012345ULL || storage[26]!=123456789012345ULL);
    for (unsigned j=0;j<25;j++) printf(" %" PRIu64,storage[j+1]);
    printf("\n");
  }
  const size_t lengths[]={0,1,31,32,33,1536};
  for (unsigned seed=0;seed<4;seed++) for (unsigned k=0;k<6;k++) {
    char label[100];
    falcon_keygen fk;
    uint32_t tmp[4]={111,222,333,444};
    int16_t a[1538],b[1538],saved[1538];
    fk.logn=10; fk.ternary=1; fk.seeded=17; fk.flipped=23; fk.tmp=tmp; fk.tmp_len=4;
    int len=snprintf(label,sizeof label,"FT1536 B1.05 BATCH022 public refill %u",seed);
    shake_init(&fk.rng,512); shake_inject(&fk.rng,label,(size_t)len); shake_flip(&fk.rng);
    for (size_t i=0;i<1538;i++) a[i]=b[i]=12345;
    words=draws=rejects=0;
    sample_true_ternary_secret(&fk,a+1,lengths[k]);
    memcpy(saved,a,sizeof a);
    sample_true_ternary_secret(&fk,b+1,lengths[k]);
    int bad=memcmp(saved,a,sizeof a)!=0 || a[0]!=12345 || b[0]!=12345 || a[lengths[k]+1]!=12345 || b[lengths[k]+1]!=12345
      || fk.logn!=10 || fk.ternary!=1 || fk.seeded!=17 || fk.flipped!=23 || fk.tmp!=tmp || fk.tmp_len!=4
      || tmp[0]!=111 || tmp[1]!=222 || tmp[2]!=333 || tmp[3]!=444;
    printf("S %u %zu %lu %lu %lu %zu %d",seed,lengths[k],words,draws,rejects,fk.rng.dptr,bad);
    for (size_t i=0;i<lengths[k];i++) printf(" %d",a[i+1]);
    for (size_t i=0;i<lengths[k];i++) printf(" %d",b[i+1]);
    printf("\n");
  }
  return 0;
}
'''
expected=[]
for seed in range(4):
    stream=hashlib.shake_256(('FT1536 B1.05 BATCH022 public refill '+str(seed)).encode()).digest(int(16384))
    for n in [0,1,31,32,33,1536]:
        cursor=ZZ(0); draws=ZZ(0); rejects=ZZ(0); result=[]
        for call in range(2):
            rb=ZZ(0); rbits=ZZ(0); coefficients=[]
            while len(coefficients)<n:
                if rbits<2:
                    rb=ZZ(int.from_bytes(stream[int(cursor):int(cursor+8)],'little'))
                    cursor+=8; rbits=64
                x=rb & 3; rb >>= 2; rbits-=2; draws+=1
                if x<3: coefficients.append(x-1)
                else: rejects+=1
            assert all(-1<=z<=1 for z in coefficients)
            result.extend(coefficients)
        expected.append([int(seed),int(n),int(cursor//8),int(draws),int(rejects),int((cursor-1)%136+1 if cursor else 136),int(0)]+[int(z) for z in result])
assert any(row[int(4)]>0 for row in expected)
assert any(row[int(2)]*8>136 for row in expected)
variants={
    'baseline':(shake,rng,sampler),
    'wrong_rng_byte_order':(shake,once(rng,'return r;','return __builtin_bswap64(r);'),sampler),
    'wrong_refill_bits':(shake,rng,once(sampler,'rbits = 64;','rbits = 62;')),
    'missing_last_store':(shake,rng,once(sampler,'v[u] = (int16_t)((int)x - 1);','if (u != 1535) v[u] = (int16_t)((int)x - 1);')),
    'wrong_lane_complement':(once(shake,'enc64le(dbuf +   8, ~A[ 1]);','enc64le(dbuf +   8, A[ 1]);'),rng,sampler),
    'wrong_round_constant':(once(shake,'0x0000000000000001, 0x0000000000008082,','0x0000000000000000, 0x0000000000008082,'),rng,sampler),
    'accept_three':(shake,rng,once(sampler,'if (x < 3U)','if (x < 4U)')),
}
records=[]
for mode,flags in [('normal',['-O2']),('ubsan',['-O1','-fsanitize=undefined','-fno-sanitize-recover=all'])]:
    for variant,(shake_code,rng_code,sampler_code) in variants.items():
        label=mode+'_'+variant
        cfile=Path(label+'.c'); binary=Path(label+'.bin')
        cfile.write_text(header+shake_code+rng_code+wrapper+sampler_code+data+main)
        command=['gcc','-std=c99','-Wall','-Wextra','-Werror']+profile['core']['Makefile_flags']+flags+['-I',str(root),str(cfile),'-o',str(binary)]
        compiled=subprocess.run(command,capture_output=True)
        Path(label+'.compile.stdout').write_bytes(compiled.stdout); Path(label+'.compile.stderr').write_bytes(compiled.stderr)
        assert compiled.returncode==0 and not compiled.stdout and not compiled.stderr, label
        ran=subprocess.run([str(binary.resolve())],capture_output=True)
        Path(label+'.stdout').write_bytes(ran.stdout); Path(label+'.stderr').write_bytes(ran.stderr)
        assert ran.returncode==0 and not ran.stderr, label
        layout=[]; permutations=[]; samples=[]
        for line in ran.stdout.decode().splitlines():
            kind,*row=line.split(); row=[int(x) for x in row]
            (layout if kind=='L' else permutations if kind=='P' else samples).append(row)
        assert layout==[[416,0,200,208,216,448,8,432,1]],layout
        # The final printed field is the active little-endian macro.
        assert len(permutations)==8 and len(samples)==24
        pdiff=[int(i) for i,(a,b) in enumerate(zip(permutations,permutation_expected)) if a!=b]
        sdiff=[int(i) for i,(a,b) in enumerate(zip(samples,expected)) if a!=b]
        assert bool(pdiff or sdiff)==(variant!='baseline'), label
        records.append({'mode':mode,'variant':variant,'permutation_differences':pdiff,'sampler_differences':sdiff,
            'command':command,'artifacts':{str(p):digest(p) for p in [cfile,Path(label+'.compile.stdout'),Path(label+'.compile.stderr'),
                Path(label+'.stdout'),Path(label+'.stderr')]}})
Path('SAMPLER_REFILL_CHECK.json').write_text(json.dumps({'status':'PASS_FINITE_SOURCE_CONTROLS',
    'source_pins':profile['core']['source_files'],'profile_sha256':digest(root/'PROFILE.json'),
    'variants':records,'permutation_cases':int(8),'sampler_cases':int(24),
    'reference_sha256':hashlib.sha256(json.dumps([permutation_expected,expected]).encode()).hexdigest(),
    'scope':'Independent ZZ FIPS202 theta/rho/pi/chi/iota with LFSR constants; actual pinned shake and full falcon_keygen struct; exact two-call bytes/cursors and protected arrays/fields. Finite controls, not full caller or compiler proof.'},indent=2)+'\n')
