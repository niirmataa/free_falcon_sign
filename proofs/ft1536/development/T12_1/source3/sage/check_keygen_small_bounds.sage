"""Finite source-helper controls, actual SHAKE/public inputs, exact ZZ checks."""
from pathlib import Path
import hashlib
import json
import os
import subprocess

root = Path(os.environ['FT1536_SOURCE3_ORIGINAL_W'])/'inputs/source'
profile = json.loads((root/'PROFILE.json').read_text())
for name in ['falcon-keygen.c','shake.c','shake.h']:
    assert hashlib.sha256((root/name).read_bytes()).hexdigest() == profile['core']['source_files'][name]
lines = (root/'falcon-keygen.c').read_text().splitlines(keepends=True)
def region(a,b):
    return ''.join(lines[a-1:b])
def once(text, old, new):
    assert text.count(old)==1, old
    return text.replace(old,new,1)
def digest(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()
small = region(4430,4438)+region(4492,4508)
rng = once(region(4706,4735),'get_rng_u64(shake_context *rng)','get_rng_u64_impl(shake_context *rng)')
sampler = region(4753,4781)+'}\n'
sampler = sampler.replace('#if TRUE_TERNARY_SECRET_MODE == 1\n','')
assert '#if' not in sampler and 'for (;;)' in sampler
instrumented = once(sampler,'x = (uint32_t)rb & 3U;',
    'x = (uint32_t)rb & 3U; draws++; if (x == 3U) rejects++;')
wrapper = r'''
static unsigned long words,draws,rejects;
static uint64_t get_rng_u64(shake_context *rng) { words++; return get_rng_u64_impl(rng); }
'''
header = r'''
#include <stdint.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include "shake.h"
#define FALCON_LE_U 1
#define MKN(logn, full) ((size_t)(1 + ((full) << 1)) << ((logn) - (full)))
typedef struct { shake_context rng; } falcon_keygen;
'''
test_words = [ZZ(0),ZZ(1),ZZ(2047),ZZ(2048),ZZ(2)^30-2047,ZZ(2)^31-2047,
    ZZ(2)^31-2048,ZZ(2)^31-1,ZZ(2)^30,ZZ(2)^30-1,ZZ(2)^31,ZZ(2)^32-1]
positions = [ZZ(0),ZZ(767),ZZ(1535)]
small_expected = []
for word in test_words:
    extended = (word | ((word & (ZZ(2)^30)) << 1)) % (ZZ(2)^32)
    z = extended if extended<ZZ(2)^31 else extended-ZZ(2)^32
    for pos in positions:
        accepted = abs(z)<=2047
        small_expected.append([int(word),int(pos),int(z),int(accepted),int(1536 if accepted else pos)])
data = 'static const uint32_t inputs[] = {'+','.join(str(x)+'U' for x in test_words)+'};\n'
main = r'''
int main(void) {
  const size_t positions[]={0,767,1535}, lengths[]={0,1,31,32,33,1536};
  uint32_t wide[1536];
  int16_t out[1538];
  for (size_t t=0;t<sizeof inputs/sizeof *inputs;t++) for (size_t k=0;k<3;k++) {
    memset(wide,0,sizeof wide);
    wide[positions[k]]=inputs[t];
    for (size_t j=0;j<1538;j++) out[j]=12345;
    int accepted=poly_big_to_small(out+1,wide,10,1);
    size_t writes=0;
    for (size_t j=0;j<1536;j++) if (out[j+1]!=12345) writes++;
    printf("B %u %zu %d %d %zu %d\n",inputs[t],positions[k],zint_one_to_plain(wide+positions[k]),accepted,writes,
      out[0]!=12345 || out[1537]!=12345 || (accepted && out[positions[k]+1]!=zint_one_to_plain(wide+positions[k])));
  }
  for (unsigned seed=0;seed<4;seed++) for (unsigned k=0;k<6;k++) {
    char label[80];
    falcon_keygen fk;
    int16_t a[1538],b[1538],saved[1538];
    int len=snprintf(label,sizeof label,"FT1536 B1.05 public sampler fixture %u",seed);
    shake_init(&fk.rng,512); shake_inject(&fk.rng,label,(size_t)len); shake_flip(&fk.rng);
    for (size_t i=0;i<1538;i++) a[i]=b[i]=12345;
    words=draws=rejects=0;
    sample_true_ternary_secret(&fk,a+1,lengths[k]);
    memcpy(saved,a,sizeof a);
    sample_true_ternary_secret(&fk,b+1,lengths[k]);
    printf("S %u %zu %lu %lu %lu %d",seed,lengths[k],words,draws,rejects,
      memcmp(saved,a,sizeof a)!=0 || a[0]!=12345 || b[0]!=12345 || a[lengths[k]+1]!=12345 || b[lengths[k]+1]!=12345);
    for (size_t i=0;i<lengths[k];i++) printf(" %d",a[i+1]);
    for (size_t i=0;i<lengths[k];i++) printf(" %d",b[i+1]);
    printf("\n");
  }
  return 0;
}
'''

expected_sampler=[]
for seed in range(4):
    stream=hashlib.shake_256(('FT1536 B1.05 public sampler fixture '+str(seed)).encode()).digest(int(16384))
    for n in [0,1,31,32,33,1536]:
        cursor=ZZ(0); ndraws=ZZ(0); rejected=ZZ(0); coeffs=[]
        for call in range(2):
            rb=ZZ(0); rbits=ZZ(0); output=[]
            while len(output)<n:
                if rbits<2:
                    rb=ZZ(int.from_bytes(stream[int(cursor):int(cursor+8)],'little'))
                    cursor+=8; rbits=64
                x=rb & 3; rb >>= 2; rbits-=2; ndraws+=1
                if x<3:
                    output.append(x-1)
                else:
                    rejected+=1
            assert all(-1<=x<=1 for x in output)
            coeffs.extend(output)
        expected_sampler.append([int(seed),int(n),int(cursor/8),int(ndraws),int(rejected),int(0)]+[int(x) for x in coeffs])
assert any(row[4]>0 for row in expected_sampler)
assert any(row[2]>2 for row in expected_sampler)

variants={
    'baseline':(small,instrumented),
    'widened_bound':(small.replace('2047','2048'),instrumented),
    'wrong_sign_bit':(once(small,'0x40000000','0x20000000'),instrumented),
    'missing_last_store':(once(small,'d[u] = (int16_t)z;','if (u != 1535) d[u] = (int16_t)z;'),instrumented),
    'accept_three':(small,once(instrumented,'if (x < 3U)','if (x < 4U)')),
    'wrong_center':(small,once(instrumented,'((int)x - 1)','((int)x - 0)')),
    'wrong_shift':(small,once(instrumented,'rb >>= 2;','rb >>= 1;')),
}
records=[]
for mode,flags in [('normal',['-O2']),('ubsan',['-O1','-fsanitize=undefined','-fno-sanitize-recover=all'])]:
    for variant,(small_code,sampler_code) in variants.items():
        label=mode+'_'+variant
        cfile=Path(label+'.c'); binary=Path(label+'.bin')
        cfile.write_text(header+small_code+rng+wrapper+sampler_code+data+main)
        command=['gcc','-std=c99','-Wall','-Wextra','-Werror']+flags+['-I',str(root),str(cfile),str(root/'shake.c'),'-o',str(binary)]
        compiled=subprocess.run(command,capture_output=True)
        Path(label+'.compile.stdout').write_bytes(compiled.stdout)
        Path(label+'.compile.stderr').write_bytes(compiled.stderr)
        assert compiled.returncode==0 and not compiled.stdout and not compiled.stderr, label
        ran=subprocess.run([str(binary.resolve())],capture_output=True)
        Path(label+'.stdout').write_bytes(ran.stdout); Path(label+'.stderr').write_bytes(ran.stderr)
        assert ran.returncode==0 and not ran.stderr, label
        small_rows=[]; sampler_rows=[]
        for line in ran.stdout.decode().splitlines():
            kind,*values=line.split(); values=[int(x) for x in values]
            (small_rows if kind=='B' else sampler_rows).append(values)
        assert len(small_rows)==len(small_expected) and len(sampler_rows)==len(expected_sampler)
        small_differences=[i for i,(a,b) in enumerate(zip(small_rows,small_expected)) if a!=b+[int(0)]]
        sampler_differences=[i for i,(a,b) in enumerate(zip(sampler_rows,expected_sampler)) if a!=b]
        assert bool(small_differences or sampler_differences)==(variant!='baseline'),label
        records.append({'mode':mode,'variant':variant,'small_differences':small_differences,
            'sampler_differences':sampler_differences,'command':command,
            'artifacts':{str(p):digest(p) for p in [cfile,Path(label+'.stdout'),Path(label+'.stderr'),
                Path(label+'.compile.stdout'),Path(label+'.compile.stderr')]}})
Path('SMALL_BOUNDS_CHECK.json').write_text(json.dumps({'status':'PASS_FINITE_SOURCE_CONTROLS',
    'source_pins':{name:profile['core']['source_files'][name] for name in ['falcon-keygen.c','shake.c','shake.h']},
    'small_cases':len(small_expected),'sampler_cases':len(expected_sampler),'variants':records,
    'small_expected':small_expected,'sampler_reference_sha256':hashlib.sha256(json.dumps(expected_sampler).encode()).hexdigest(),
    'scope':'Copied pinned helpers, public SHAKE256 seeds, real shake_extract linked to pinned shake.c; mock caller struct supplies only rng for this fixture. No KeyGen call or private key generated. Exact ZZ values/cursors, finite normal/UBSan controls and six detected mutations; not the missing whole-sampler/caller kernel proof.'},indent=2)+'\n')
