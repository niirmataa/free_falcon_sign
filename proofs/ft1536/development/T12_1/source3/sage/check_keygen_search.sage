"""Public exact controls for the full ternary_depth0 source and output gate.

ZZ polynomial lifts give independent expected outputs for constant f/g.
These finite controls supplement the operational/frame proofs.
"""
import hashlib
import json
import os
from pathlib import Path
import subprocess

root = Path(os.environ['FT1536_SOURCE3_ORIGINAL_W'])/'inputs/source'
profile = json.loads((root/'PROFILE.json').read_text())
def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()
for name,pin in profile['core']['source_files'].items():
    assert digest(root/name)==pin, name
lines=(root/'falcon-keygen.c').read_text().splitlines(keepends=True)
def region(a,b):
    return ''.join(lines[int(a-1):int(b)])
def once(text,old,new):
    assert text.count(old)==int(1), old
    return text.replace(old,new,int(1))

# P(X^3) is computed in the exact integer quotient, not using the C FFT.
R=PolynomialRing(ZZ,'X'); X=R.gen()
phi=X^1536-X^768+1
pattern=[ZZ((j*7+3)%3)-1 for j in range(512)]
P=sum(pattern[j]*X^j for j in range(512))
lift=P(X^3)%phi
assert lift.degree()<1536
lifted=[ZZ(lift[j]) for j in range(1536)]
cases=[]
for a,b,scale in [(1,0,1),(0,1,7),(1,1,11),(-1,0,2047),(0,-1,2048),(1,0,2048),(1,1,2047)]:
    lowerF=[scale*z for z in pattern]
    lowerG=[(-scale if a==b else scale)*z for z in pattern]
    finalF=[(b^2)*z for z in [scale*t for t in lifted]]
    finalG=[(a^2)*z for z in [(-scale if a==b else scale)*t for t in lifted]]
    # In every case the numerator for the Babai correction is zero.
    assert all(a*f+b*g==0 for f,g in zip(finalF,finalG))
    accepted=all(abs(z)<=2047 for z in finalF+finalG)
    cases.append({'a':int(a),'b':int(b),'lowerF':[int(z) for z in lowerF],
        'lowerG':[int(z) for z in lowerG],'F':[int(z) for z in finalF],
        'G':[int(z) for z in finalG],'accepted':bool(accepted)})
Path('PUBLIC_FIXTURE.json').write_text(json.dumps(cases,indent=2)+'\n')

header=r'''
#include <stdio.h>
#include <stddef.h>
#include <inttypes.h>
#include "internal.h"
'''+region(61,61)+region(4679,4698)+region(4430,4438)+region(5316,5330)+region(5355,5364)
depth0=region(7051,7273)
small=region(4492,4508)
assert small.count('poly_big_to_small(')==int(1)
data='static const int a_values[7]={'+','.join(str(c['a']) for c in cases)+'};\n'
data+='static const int b_values[7]={'+','.join(str(c['b']) for c in cases)+'};\n'
for field in ['lowerF','lowerG']:
    data+='static const int32_t '+field+'[7][512]={\n'+',\n'.join(
        '{'+','.join(str(z) for z in c[field])+'}' for c in cases)+'\n};\n'
main=r'''
int main(void) {
  printf("L %zu %zu %zu %zu %zu %zu\n",sizeof(falcon_keygen),offsetof(falcon_keygen,logn),
    offsetof(falcon_keygen,ternary),offsetof(falcon_keygen,rng),offsetof(falcon_keygen,tmp),sizeof(fpr));
  for (unsigned k=0;k<7;k++) {
    uint64_t storage[16386];
    int16_t f[1538],g[1538],F[1538],G[1538],fs[1538],gs[1538];
    falcon_keygen fk,saved;
    memset(&fk,0,sizeof fk);
    memset(storage,0,sizeof storage);
    storage[0]=storage[16385]=UINT64_C(0x735ab98ef12cd460);
    fk.logn=10; fk.ternary=1; fk.tmp=(uint32_t *)(storage+1); fk.tmp_len=32768;
    fk.seeded=17; fk.flipped=23;
    memcpy(&saved,&fk,sizeof fk);
    for (size_t j=0;j<1538;j++) {f[j]=g[j]=0; F[j]=G[j]=12345;}
    f[0]=f[1537]=g[0]=g[1537]=12345;
    f[1]=(int16_t)a_values[k]; g[1]=(int16_t)b_values[k];
    memcpy(fs,f,sizeof f); memcpy(gs,g,sizeof g);
    for (size_t j=0;j<512;j++) {
      fk.tmp[j]=(uint32_t)lowerF[k][j]&0x7FFFFFFF;
      fk.tmp[512+j]=(uint32_t)lowerG[k][j]&0x7FFFFFFF;
    }
    int ret=solve_NTRU_ternary_depth0(&fk,f+1,g+1);
    int bad=memcmp(fs,f,sizeof f)!=0 || memcmp(gs,g,sizeof g)!=0 || memcmp(&saved,&fk,sizeof fk)!=0
      || storage[0]!=UINT64_C(0x735ab98ef12cd460) || storage[16385]!=UINT64_C(0x735ab98ef12cd460);
    int passed=poly_big_to_small(F+1,fk.tmp,10,1) && poly_big_to_small(G+1,fk.tmp+1536,10,1);
    bad |= F[0]!=12345 || F[1537]!=12345 || G[0]!=12345 || G[1537]!=12345;
    printf("S %u %d %d %d",k,ret,bad,passed);
    for (size_t j=0;j<3072;j++) printf(" %" PRId32,(int32_t)fk.tmp[j]);
    for (size_t j=1;j<=1536;j++) printf(" %d",F[j]);
    for (size_t j=1;j<=1536;j++) printf(" %d",G[j]);
    printf("\n");
  }
  return 0;
}
'''
variants={
  'baseline':(depth0,small),
  'write_f':(once(depth0,'logn = fk->logn;','((int16_t *)f)[0] = 0;\n\tlogn = fk->logn;'),small),
  'write_g':(once(depth0,'return 1;','((int16_t *)g)[0] = 7;\n\treturn 1;'),small),
  'wrong_G_alias':(once(depth0,'Gp = Fp + tn;','Gp = Fp + tn + 1;'),small),
  'omit_G_store':(once(depth0,'Gp[u] = (uint32_t)fpr_rint(rt2[u]);','if (u != 1530) Gp[u] = (uint32_t)fpr_rint(rt2[u]);'),small),
  'wrong_G_round':(once(depth0,'Gp[u] = (uint32_t)fpr_rint(rt2[u]);','Gp[u] = (uint32_t)fpr_rint(rt2[u]) + 1;'),small),
  'bound_2048':(depth0,once(small,'z < -2047 || z > 2047','z < -2048 || z > 2048')),
}
records=[]
for mode,flags in [('normal',['-O2']),('ubsan',['-O1','-fsanitize=undefined','-fno-sanitize-recover=all'])]:
    for variant,(body,gate) in variants.items():
        label=mode+'_'+variant
        cfile=Path(label+'.c'); binary=Path(label+'.bin')
        cfile.write_text(header+gate+body+data+main)
        command=['gcc','-std=c99','-Wall','-Wextra','-Werror']+profile['core']['Makefile_flags']+flags+[
            '-I',str(root),str(cfile),str(root/'falcon-fft.c'),str(root/'fpr-emulated.c'),'-o',str(binary)]
        compiled=subprocess.run(command,capture_output=True)
        Path(label+'.compile.stdout').write_bytes(compiled.stdout); Path(label+'.compile.stderr').write_bytes(compiled.stderr)
        assert compiled.returncode==0 and not compiled.stdout and not compiled.stderr,label
        ran=subprocess.run([str(binary.resolve())],capture_output=True)
        Path(label+'.stdout').write_bytes(ran.stdout); Path(label+'.stderr').write_bytes(ran.stderr)
        assert ran.returncode==0 and not ran.stderr,label
        rows=ran.stdout.decode().splitlines()
        assert [int(z) for z in rows[0].split()[1:]]==[448,0,4,8,432,8]
        assert len(rows)==8
        differences=[]
        for k,(row,case) in enumerate(zip(rows[1:],cases)):
            kind,*raw=row.split(); values=[int(z) for z in raw]
            assert kind=='S' and len(values)==int(6148)
            expected=[int(k),int(1),int(0),int(case['accepted'])]+case['F']+case['G']
            mismatch=values[:int(3076)]!=expected
            if case['accepted']:
                mismatch = mismatch or values[int(3076):]!=case['F']+case['G']
            if mismatch: differences.append(int(k))
        assert bool(differences)==(variant!='baseline'),(label,differences)
        files=[cfile,Path(label+'.compile.stdout'),Path(label+'.compile.stderr'),Path(label+'.stdout'),Path(label+'.stderr')]
        records.append({'mode':mode,'variant':variant,'differences':differences,'command':command,
            'artifacts':{str(p):digest(p) for p in files}})
Path('SEARCH_CHECK.json').write_text(json.dumps({'status':'PASS_FINITE_SOURCE_CONTROLS',
    'cases':int(len(cases)),'variants':records,'fixture_sha256':digest('PUBLIC_FIXTURE.json'),
    'profile_sha256':digest(root/'PROFILE.json'),'source_pins':profile['core']['source_files'],
    'scope':'Full pinned ternary_depth0 and real output gate; constant public f/g, exact ZZ P(X^3), same-array/context guards. No deepest/intermediate execution, termination, distribution or compiler theorem.'},indent=2)+'\n')
