"""049 PUBLIC control-only caller diagnostics, native Sage preparser.

The complete live pinned make body runs against SCRIPTED CALLEE STUBS.
No entropy, genuine samplers/FPEMU/NTT/solver/certificate/codecs, private
KeyGen, real emitted key or probability measurement is executed. These
finite controls cannot replace the missing operational composition proof.
"""
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess

old=Path(os.environ['FT1536_SOURCE3_ORIGINAL_W'])
repo=next(p for p in old.parents if (p/'Extra/c/falcon-keygen.c').exists())
component=repo/'proofs/ft1536/development/T12_1/source3'
root=repo/'Extra/c'
profile_path=old/'inputs/source/PROFILE.json'
profile=json.loads(profile_path.read_text())
def digest(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def plain(x):
    if isinstance(x,dict): return {str(k):plain(v) for k,v in x.items()}
    if isinstance(x,(list,tuple)): return [plain(v) for v in x]
    if isinstance(x,(str,bool)) or x is None: return x
    return int(x)
def once(text,first,last):
    assert text.count(first)==1,first
    return text.replace(first,last,int(1))
names=['falcon-keygen.c','internal.h','falcon.h','fpr-emulated.h']
pins={n:digest(root/n) for n in names}
for n in names:
    if n!='fpr-emulated.h': assert pins[n]==profile['core']['source_files'][n],n
assert pins['falcon-keygen.c']=='0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf'
assert pins['fpr-emulated.h']=='6b897d6c217ef25a322e3b5c3d9488b9d6b8d0e369a710d8fce2259f24e6d84f'
body=''.join((root/'falcon-keygen.c').read_text().splitlines(keepends=True)[int(7780):int(8187)])
assert body.count('local_attempts = 0;')==1
actual=once(body,'local_attempts = 0;','local_attempts = injected_start;')
actual=once(actual,'falcon_keygen_make(','caller_control(')
prelude=r'''
#include <stdint.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>
typedef uint64_t fpr;
/* Deliberate mock context: no claim about the real falcon_keygen layout. */
typedef struct { unsigned logn,ternary; fpr *tmp; } falcon_keygen;
#define MKN(logn,ter) ((size_t)(1+((ter)<<1))<<((logn)-(ter)))
#define TRUE_TERNARY_SECRET 1
#define TERNARY_KEYGEN_BOUND_SCALE_NUM 1250
#define TERNARY_KEYGEN_BOUND_SCALE_DEN 100
#define TERNARY_KEYGEN_MAX_ATTEMPTS 3000000
static uint64_t injected_start;
static int ready,failed_gate,attempt,compares,seen_samplers,seen_public,seen_solve,seen_cert,seen_enc;
static int identity;
static int16_t *expected[4];
static uint16_t *public_input;
static char trace[1024];
static size_t trace_len;
static void event(const char *s) { size_t n=strlen(s); if(trace_len+n<sizeof trace){memcpy(trace+trace_len,s,n+1);trace_len+=n;} }
static int reject(int gate) { return attempt==1 && failed_gate==gate; }
static int rng_ready(falcon_keygen *fk) { (void)fk;return ready; }
static void sample_true_ternary_secret(falcon_keygen *fk,int16_t *out,size_t n) {
 (void)fk; unsigned slot=(unsigned)seen_samplers%2; if(slot==0){attempt++;compares=0;}
 expected[slot]=out;seen_samplers++;event(slot==0?"f,":"g,");
 for(size_t i=0;i<n;i++)out[i]=(int16_t)((attempt+(int)i+(int)slot)%3-1);
}
static int mod2_res_ternary(const int16_t *p,unsigned logn) {
 (void)logn;int gate=p==expected[0]?1:2;event(gate==1?"rf,":"rg,");return !reject(gate);
}
/* Explicit INTEGER/TAPE mocks, not FPEMU or mathematical norm functions. */
static fpr fpr_of(int64_t x){return (uint64_t)x;}
static fpr fpr_sqrt(fpr x){return x?x:1;}
static fpr fpr_div(fpr x,fpr y){return x/(y?y:1);}
static fpr fpr_mul(fpr x,fpr y){return x*y;}
static fpr fpr_add(fpr x,fpr y){return x+y;}
static fpr fpr_sqr(fpr x){(void)x;return 0;}
static fpr fpr_double(fpr x){return x+x;}
static int fpr_lt(fpr x,fpr y){(void)x;(void)y;compares++;event(compares==1?"raw,":"gs,");return !reject(compares==1?3:4);}
static void poly_small_to_fp(fpr *out,const int16_t *p,unsigned logn,unsigned ter){(void)p;for(size_t i=0;i<MKN(logn,ter);i++)out[i]=0;}
static void falcon_FFT3(fpr *p,unsigned logn,unsigned full){(void)p;(void)logn;(void)full;}
static void falcon_FFT(fpr *p,unsigned logn){(void)p;(void)logn;}
static void falcon_iFFT(fpr *p,unsigned logn){(void)p;(void)logn;}
static void falcon_poly_invnorm2_fft3(fpr *r,const fpr *a,const fpr *b,unsigned l,unsigned t){(void)r;(void)a;(void)b;(void)l;(void)t;}
static void falcon_poly_invnorm2_fft(fpr *r,const fpr *a,const fpr *b,unsigned l){(void)r;(void)a;(void)b;(void)l;}
static void falcon_poly_adj_fft3(fpr *r,unsigned l,unsigned t){(void)r;(void)l;(void)t;}
static void falcon_poly_adj_fft(fpr *r,unsigned l){(void)r;(void)l;}
static void falcon_poly_mulconst_fft3(fpr *r,fpr v,unsigned l,unsigned t){(void)r;(void)v;(void)l;(void)t;}
static void falcon_poly_mulconst_fft(fpr *r,fpr v,unsigned l){(void)r;(void)v;(void)l;}
static void falcon_poly_mul_autoadj_fft3(fpr *r,const fpr *a,unsigned l,unsigned t){(void)r;(void)a;(void)l;(void)t;}
static void falcon_poly_mul_autoadj_fft(fpr *r,const fpr *a,unsigned l){(void)r;(void)a;(void)l;}
static void poly_small_mkgauss(falcon_keygen *fk,int16_t *p,unsigned logn){(void)fk;(void)p;(void)logn;}
static uint32_t poly_small_sqnorm(const int16_t *p,unsigned l,unsigned t){(void)p;(void)l;(void)t;return 0;}
static int falcon_compute_public(uint16_t *h,const int16_t *f,const int16_t *g,unsigned l,int t) {
 (void)l;(void)t;identity &= f==expected[0] && g==expected[1];public_input=h;seen_public++;event("public,");
 for(size_t i=0;i<1536;i++){h[i]=(uint16_t)(attempt+i%7);}return !reject(5);
}
static int solve_NTRU(falcon_keygen *fk,int16_t *F,int16_t *G,const int16_t *f,const int16_t *g) {
 (void)fk;identity &= f==expected[0] && g==expected[1];expected[2]=F;expected[3]=G;seen_solve++;event("solve,");
 for(size_t i=0;i<1536;i++){F[i]=(int16_t)(attempt%7);G[i]=(int16_t)(-attempt%7);}return !reject(6);
}
static int ft_keygen_leaf_certificate(fpr *tmp,const int16_t *f,const int16_t *g,const int16_t *F,const int16_t *G,unsigned l,unsigned t) {
 (void)tmp;(void)l;(void)t;identity &= f==expected[0] && g==expected[1] && F==expected[2] && G==expected[3];
 seen_cert++;event("cert,");return !reject(7);
}
/* Dummy 2/3-byte tags, NOT actual codecs or emitted secret/public keys. */
static size_t falcon_encode_small(void *out,size_t len,int comp,unsigned q,const int16_t *p,unsigned logn) {
 (void)comp;(void)logn;identity &= seen_enc<4 && p==expected[seen_enc] && q==18433;
 seen_enc++;event("enc,");if(len<2)return 0;memset(out,0xA5,2);return 2;
}
static size_t falcon_encode_18433(void *out,size_t len,const uint16_t *h,unsigned logn) {
 (void)logn;identity &= h==public_input;event("pk,");if(len<3)return 0;memset(out,0x5A,3);return 3;
}
static size_t falcon_encode_12289(void *out,size_t len,const uint16_t *h,unsigned logn) {
 (void)out;(void)len;(void)h;(void)logn;return 0;
}
'''
cases=[]
for gate in range(8): cases.append({'ready':1,'gate':gate,'start':ZZ(0),'private':ZZ(128),'public':ZZ(128)})
cases += [{'ready':0,'gate':0,'start':ZZ(0),'private':ZZ(128),'public':ZZ(128)},
          {'ready':1,'gate':0,'start':ZZ(2999999),'private':ZZ(128),'public':ZZ(128)},
          {'ready':1,'gate':0,'start':ZZ(3000000),'private':ZZ(128),'public':ZZ(128)},
          {'ready':1,'gate':0,'start':ZZ(0),'private':ZZ(0),'public':ZZ(128)},
          {'ready':1,'gate':0,'start':ZZ(0),'private':ZZ(4),'public':ZZ(128)},
          {'ready':1,'gate':0,'start':ZZ(0),'private':ZZ(128),'public':ZZ(0)}]
gates=['rf,','rg,','raw,','gs,','public,','solve,','cert,']
expected=[]
for i,case in enumerate(cases):
    steps=[];samples=ZZ(0);gate=case['gate'];enc=ZZ(0);ret=ZZ(0);sk=case['private'];pk=case['public']
    if case['ready'] and case['start']<3000000:
        if gate: steps+=['f,','g,']+gates[:gate];samples+=2
        steps+=['f,','g,']+gates;samples+=2
        if sk>=1:
            enc=4 if sk>=9 else 2
            steps+=['enc,']*int(enc)
            if sk>=9:
                sk=ZZ(9)
                if pk>=1:
                    steps+=['pk,'];pk=ZZ(4);ret=ZZ(1)
    expected.append([ZZ(i),ret,samples,enc,sk,pk,ZZ(1),''.join(steps) or '-'])
fixture={'scope':'Control-only scripted mocks and public synthetic arrays, NOT full cryptographic KeyGen or a probability law.',
    'cases':cases,'expected':expected,'counter_initializer_injection':'Actual source0 replaced by public fixture start only in this diagnostic seam.'}
Path('MAKE_PUBLIC_FIXTURE.json').write_text(json.dumps(plain(fixture),indent=2)+'\n')
rows=',\n'.join('{'+','.join(str(int(case[k])) for k in ['ready','gate','start','private','public'])+'}' for case in cases)
main=r'''
struct scenario {int ready,gate;uint64_t start;size_t sk,pk;};
static const struct scenario cases[]={SCENARIOS};
int main(void){
 fpr scratch[4608]={0};falcon_keygen fk={10,1,scratch};unsigned char sk[128],pk[128];
 for(size_t c=0;c<sizeof cases/sizeof cases[0];c++){
  const struct scenario *s=&cases[c];ready=s->ready;failed_gate=s->gate;injected_start=s->start;
  attempt=compares=seen_samplers=seen_public=seen_solve=seen_cert=seen_enc=0;identity=1;trace_len=0;trace[0]=0;
  memset(expected,0,sizeof expected);public_input=0;size_t sklen=s->sk,pklen=s->pk;
  int ret=caller_control(&fk,0,sk,&sklen,pk,&pklen);
  printf("%zu %d %d %d %zu %zu %d %s\n",c,ret,seen_samplers,seen_enc,sklen,pklen,identity,trace_len?trace:"-");
 }
 return 0;
}
'''.replace('SCENARIOS',rows)
mutations={'baseline':actual,
    'drop_resultant_g':once(actual,'if (mod2_res_ternary(g, logn) == 0)', 'if (0 && mod2_res_ternary(g, logn) == 0)'),
    'swap_fourth_segment':once(actual,'ske[3] = G;','ske[3] = F;'),
    'skip_certificate':once(actual,'if (ter && logn == 10 && n == 1536)', 'if (0 && ter && logn == 10 && n == 1536)'),
    'early_capacity':once(actual,'if (!rng_ready(fk)) {','if (*privkey_len < 1) { return 0; }\n\tif (!rng_ready(fk)) {')}
cap=re.search(r'\t\t\tif \(local_attempts > TERNARY_KEYGEN_MAX_ATTEMPTS\) \{.*?\t\t\t\}',actual,re.S)
assert cap
text=cap.group(0)
late=once(actual,text,'/* cap intentionally moved in this negative control */')
mutations['late_cap']=once(late,'sample_true_ternary_secret(fk, g, n);','sample_true_ternary_secret(fk, g, n);\n'+text)
results=[]
for mode in ['normal','ubsan']:
    for name,caller in mutations.items():
        label=mode+'_'+name;source=Path(label+'.c');binary=Path(label+'.exe')
        source.write_text(prelude+caller+main)
        command=['gcc','-std=c99','-O1','-Wall','-Wextra','-Werror']
        if mode=='ubsan': command+=['-fsanitize=undefined','-fno-sanitize-recover=all']
        command += [str(source),'-o',str(binary)]
        compiled=subprocess.run(command,capture_output=True)
        Path(label+'.compile.stdout').write_bytes(compiled.stdout);Path(label+'.compile.stderr').write_bytes(compiled.stderr)
        assert compiled.returncode==0 and not compiled.stdout and not compiled.stderr,(label,compiled.returncode,compiled.stderr.decode())
        run=subprocess.run([str(binary.resolve())],capture_output=True)
        Path(label+'.stdout').write_bytes(run.stdout);Path(label+'.stderr').write_bytes(run.stderr)
        assert run.returncode==0 and not run.stderr,(label,run.returncode,run.stderr.decode())
        parsed=[]
        for line in run.stdout.decode().splitlines():
            columns=line.split();assert len(columns)==8
            parsed.append([ZZ(x) for x in columns[:7]]+[columns[7]])
        assert len(parsed)==len(expected)
        differences=[i for i,(a,b) in enumerate(zip(parsed,expected)) if a!=b]
        assert bool(differences)==(name!='baseline'),(label,differences)
        files=[source,binary]+[Path(label+s) for s in ['.compile.stdout','.compile.stderr','.stdout','.stderr']]
        results.append({'mode':mode,'variant':name,'cases':len(parsed),'differences':differences,
            'results':parsed,'command':command,'artifacts':{str(p):digest(p) for p in files}})
result={'status':'PASS_SCRIPTED_CALLER_CONTROLS','scope':fixture['scope'],'source_pins':pins,
    'profile_sha256':digest(profile_path),'fixture_sha256':digest('MAKE_PUBLIC_FIXTURE.json'),
    'literal_make_range':[7781,8187],'variants':results,'runs':len(results),'cases_per_run':len(cases),
    'limits':'Unchanged guarded runner. These are explicit mocks, NOT genuine callee bodies or a full M0 build.'}
Path('MAKE_CONTROL_CHECK.json').write_text(json.dumps(plain(result),indent=2)+'\n')
