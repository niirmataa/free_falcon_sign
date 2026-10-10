"""047 public source-prefix/cap controls. No private KeyGen or emitted keys.

Native Sage preparser, exact ZZ. Counter-boundary injections and observation
stores are explicit diagnostics, NOT production whole-call executions. Other
rng_ready paths are finite controls only; their universal binding is OPEN.
"""
import hashlib
import json
import os
from pathlib import Path
import subprocess

old=Path(os.environ['FT1536_SOURCE3_ORIGINAL_W'])
repo=next(p for p in old.parents if (p/'Extra/c/falcon-keygen.c').exists())
root=repo/'Extra/c';profile_path=old/'inputs/source/PROFILE.json'
profile=json.loads(profile_path.read_text())
def digest(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def plain(x):
    if isinstance(x,dict): return {str(k):plain(v) for k,v in x.items()}
    if isinstance(x,(list,tuple)): return [plain(v) for v in x]
    if isinstance(x,(str,bool)) or x is None: return x
    return int(x)
def once(text,before,after):
    assert text.count(before)==1,before
    return text.replace(before,after,int(1))
names=['falcon-keygen.c','shake.c','internal.h','falcon.h','shake.h','fpr-emulated.h']
pins={name:digest(root/name) for name in names}
historical={name:profile['core']['source_files'][name] for name in names}
for name in names:
    if name!='fpr-emulated.h': assert pins[name]==historical[name],name
assert historical['fpr-emulated.h']=='242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa'
assert pins['fpr-emulated.h']=='6b897d6c217ef25a322e3b5c3d9488b9d6b8d0e369a710d8fce2259f24e6d84f'
Path('MAKE_ENTRY_HEADERS.json').write_text(json.dumps({'actual':pins,'historical':historical,
    'scope':'Inherited039 approved header difference, rehashed; not a complete historical M0 build.'},indent=2)+'\n')
n=ZZ(1536);cap=ZZ(3000000)
fixtures=[]
for case in range(4):
    label='FT1536 public enclosing-prefix047/'+str(case)
    stream=hashlib.shake_256(label.encode()).digest(int(16384))
    cursor=ZZ(0);vectors=[]
    for call in range(2):
        vector=[];bits=ZZ(0);word=ZZ(0)
        while len(vector)<n:
            if bits<2:
                word=ZZ(int.from_bytes(stream[int(cursor):int(cursor+8)],'little'));cursor+=8;bits=64
            draw=word & 3;word>>=2;bits-=2
            if draw<3: vector.append(draw-1)
        vectors.append(vector)
    fixtures.append({'label':label,'f':vectors[0],'g':vectors[1],'cursor':cursor})
counts=[ZZ(0),ZZ(1),cap-2,cap-1,cap]
Path('MAKE_ENTRY_FIXTURE.json').write_text(json.dumps(plain({'fixtures':fixtures,'incoming_counters':counts}),indent=2)+'\n')
source=(root/'falcon-keygen.c').read_text();lines=source.splitlines(keepends=True)
prologue=''.join(lines[int(7804):int(7838)])
setup=''.join(lines[int(7865):int(7881)])
sampling=''.join(lines[int(7887):int(7889)])
observed_prologue=once(prologue,'local_attempts = 0;','local_attempts = 0; o->initial = local_attempts;')
sampling=once(sampling,'sample_true_ternary_secret(fk, f, n);','o->calls++; sample_true_ternary_secret(fk, f, n);')
sampling=once(sampling,'sample_true_ternary_secret(fk, g, n);','o->calls++; sample_true_ternary_secret(fk, g, n);')
prefix=r'''
struct observation { uint64_t initial,counter; size_t n,bytes[6],dptr; int calls,distinct; ptrdiff_t offsets[3]; int16_t f[1536],g[1536]; };
static int seed_calls;
int falcon_get_seed(void *seed,size_t len) { (void)seed; (void)len; seed_calls++; return 0; }
static int selected_prefix(falcon_keygen *fk,uint64_t injected,struct observation *o) {
'''+observed_prologue+r'''
 /* Public diagnostic injection at the cap boundary; production starts at0. */
 local_attempts=injected; o->n=n;
 o->bytes[0]=sizeof f;o->bytes[1]=sizeof g;o->bytes[2]=sizeof F;o->bytes[3]=sizeof G;o->bytes[4]=sizeof h;o->bytes[5]=sizeof ske;
 (void)sizeof u;(void)sizeof klen;(void)sizeof skoff;(void)sizeof skbuf;(void)sizeof i;
 const void *objects[]={f,g,F,G,h,ske};o->distinct=1;
 for(size_t a=0;a<6;a++)for(size_t b=a+1;b<6;b++)o->distinct &= objects[a]!=objects[b];
 for(;;) {
'''+setup+r'''
   (void)sizeof norm;(void)sizeof bound;
   o->counter=local_attempts;
   o->offsets[0]=(unsigned char *)rt1-(unsigned char *)fk->tmp;
   o->offsets[1]=(unsigned char *)rt2-(unsigned char *)fk->tmp;
   o->offsets[2]=(unsigned char *)rt3-(unsigned char *)fk->tmp;
'''+sampling+r'''
   memcpy(o->f,f,sizeof o->f);memcpy(o->g,g,sizeof o->g);o->dptr=fk->rng.dptr;return 1;
  }
  return 3;
 }
}
'''
# Observe the abort counter immediately before the ACTUAL cap return.
prefix=once(prefix,'return 0;\n\t\t\t}', 'o->counter=local_attempts; return 0;\n\t\t\t}')
labels='static const char *labels[]={'+','.join(json.dumps(f['label']) for f in fixtures)+'};\n'
main=r'''
int main(void) {
 const uint64_t counts[]={0,1,2999998,2999999,3000000};
 for(size_t c=0;c<4;c++)for(size_t j=0;j<5;j++) {
  falcon_keygen fk,old;uint32_t scratch[16384]={0};struct observation o;
  memset(&fk,0,sizeof fk);memset(&o,0,sizeof o);fk.logn=10;fk.ternary=1;fk.tmp=scratch;fk.tmp_len=sizeof scratch;fk.seeded=1;fk.flipped=1;
  shake_init(&fk.rng,512);shake_inject(&fk.rng,labels[c],strlen(labels[c]));shake_flip(&fk.rng);old=fk;
  o.offsets[0]=o.offsets[1]=o.offsets[2]=-1;seed_calls=0;
  int result=selected_prefix(&fk,counts[j],&o);
  int changed=memcmp(&old,&fk,8)!=0 || memcmp((unsigned char *)&old+424,(unsigned char *)&fk+424,sizeof fk-424)!=0;
  printf("P %zu %zu %d %llu %llu %zu %d %d %td %td %td %zu %d %d",c,j,result,(unsigned long long)o.initial,(unsigned long long)o.counter,o.n,o.calls,o.distinct,o.offsets[0],o.offsets[1],o.offsets[2],o.dptr,changed,seed_calls);
  for(size_t k=0;k<6;k++)printf(" %zu",o.bytes[k]);
  if(result==1){for(size_t k=0;k<1536;k++)printf(" %d",(int)o.f[k]);for(size_t k=0;k<1536;k++)printf(" %d",(int)o.g[k]);}printf("\n");
 }
 const int flags[][2]={{1,1},{-3,-4},{1,0},{0,1},{0,0},{-1,1}};
 for(size_t i=0;i<6;i++) {
  falcon_keygen fk,old;memset(&fk,0,sizeof fk);fk.logn=10;fk.ternary=1;fk.seeded=flags[i][0];fk.flipped=flags[i][1];
  shake_init(&fk.rng,512);shake_inject(&fk.rng,"PUBLIC readiness fixture",24);if(fk.flipped)shake_flip(&fk.rng);old=fk;seed_calls=0;
  int ret=rng_ready(&fk);printf("R %zu %d %d %d %d %d %d\n",i,ret,seed_calls,fk.seeded,fk.flipped,memcmp(&old,&fk,sizeof fk)==0,memcmp(&old,&fk,8)==0);
 }
 return 0;
}
'''
variants={'baseline':prefix,
    'wrong_counter_zero':once(prefix,'local_attempts = 0;','local_attempts = 1;'),
    'early_cap':once(prefix,'local_attempts > TERNARY_KEYGEN_MAX_ATTEMPTS','local_attempts >= TERNARY_KEYGEN_MAX_ATTEMPTS'),
    'missing_increment':once(prefix,'local_attempts ++;','local_attempts += 0;'),
    'wrong_automatic_extent':once(prefix,'int16_t f[3072]','int16_t f[3071]')}
records=[];baseline=None
for mode,flags in [('normal',['-O2']),('ubsan',['-O1','-fsanitize=undefined','-fno-sanitize-recover=all'])]:
    for variant,helper in variants.items():
        label=mode+'_'+variant;cfile=Path(label+'.c');binary=Path(label+'.bin')
        cfile.write_text('#include <stdio.h>\n#include <stddef.h>\n'+source+helper+labels+main)
        command=['gcc','-std=c99','-Wall','-Wextra','-Werror','-ffunction-sections','-fdata-sections']+profile['core']['Makefile_flags']+flags+[
            '-I',str(root),str(cfile),str(root/'shake.c'),'-Wl,--gc-sections','-o',str(binary)]
        compiled=subprocess.run(command,capture_output=True)
        Path(label+'.compile.stdout').write_bytes(compiled.stdout);Path(label+'.compile.stderr').write_bytes(compiled.stderr)
        assert compiled.returncode==0 and not compiled.stdout and not compiled.stderr,label
        ran=subprocess.run([str(binary.resolve())],capture_output=True)
        Path(label+'.stdout').write_bytes(ran.stdout);Path(label+'.stderr').write_bytes(ran.stderr)
        Path(label+'.run.json').write_text(json.dumps({'returncode':ran.returncode})+'\n')
        assert ran.returncode==0 and not ran.stderr,label
        rows=[];differences=[];ready_rows=[]
        for line in ran.stdout.decode().splitlines():
            values=line.split()
            if values[0]=='R':
                i,ret,seed_calls,seeded,flipped,same,profile_same=[ZZ(x) for x in values[1:]]
                expected=[[1,0,1,1,1,1],[1,0,-3,-4,1,1],[1,0,1,1,0,1],[0,1,0,1,1,1],[0,1,0,0,1,1],[1,0,-1,1,1,1]][int(i)]
                assert [ret,seed_calls,seeded,flipped,same,profile_same]==expected,(label,i)
                ready_rows.append(expected);continue
            assert values[0]=='P'
            case,j,ret,initial,counter,dimension,calls,distinct,o1,o2,o3,dptr,changed,seed_calls=[ZZ(x) for x in values[1:15]]
            storage=[ZZ(x) for x in values[15:21]];vectors=[ZZ(x) for x in values[21:]]
            assert case*5+j==len(rows)
            accepted=counts[int(j)]<cap;fixture=fixtures[int(case)]
            ok=initial==0 and counter==counts[int(j)]+1 and dimension==n and distinct==1 and storage==[6144]*5+[32] and changed==0 and seed_calls==0
            if accepted:
                ok=ok and ret==1 and calls==2 and [o1,o2,o3]==[0,8*n,16*n] and vectors==fixture['f']+fixture['g'] and dptr==(fixture['cursor']-1)%136+1
            else:
                ok=ok and ret==0 and calls==0 and [o1,o2,o3]==[-1]*3 and not vectors
            row={'case':case,'injected':counts[int(j)],'return':ret,'initial':initial,'counter':counter,'n':dimension,
                'calls':calls,'storage':storage,'offsets':[o1,o2,o3],'distinct':distinct,'context_changed':changed,
                'seed_calls':seed_calls,'cursor':dptr,'vectors':vectors}
            rows.append(plain(row))
            if not ok: differences.append({'case':int(case),'counter_index':int(j),'kind':'prefix/cap/material'})
        assert len(rows)==20 and len(ready_rows)==6
        if variant=='baseline':
            assert not differences,(label,differences)
            if baseline is None: baseline=rows
            else: assert rows==baseline
        else: assert differences,label
        artifacts=[cfile,Path(label+'.compile.stdout'),Path(label+'.compile.stderr'),Path(label+'.stdout'),Path(label+'.stderr'),Path(label+'.run.json')]
        records.append({'mode':mode,'variant':variant,'results':rows,'readiness_controls':ready_rows,'differences':differences,
            'command':command,'artifacts':{str(p):digest(p) for p in artifacts}})
Path('MAKE_ENTRY_CHECK.json').write_text(json.dumps(plain({'status':'PASS_FINITE_SOURCE_CONTROLS','variants':records,
    'source_pins':pins,'profile_sha256':digest(profile_path),'header_sha256':digest('MAKE_ENTRY_HEADERS.json'),
    'fixture_sha256':digest('MAKE_ENTRY_FIXTURE.json'),'prefix_cases_per_run':20,'readiness_cases_per_run':6,
    'scope':'Instrumented public selected prefix, six automatic extents/separation, source counter0/MKN/readiness, injected boundary cap before sampling, two exact MODE1 samples. Other RNG paths are finite diagnostic controls ONLY. No complete invocation/attempt acceptance, emitted key or probability claim.'}),indent=2)+'\n')
