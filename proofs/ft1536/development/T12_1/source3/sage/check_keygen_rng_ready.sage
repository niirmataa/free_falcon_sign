"""048 public deterministic readiness/source controls, native Sage preparser.

System calls are explicitly scripted PUBLIC fixtures. Never open the real
entropy source, invoke complete KeyGen, generate private keys or measure a law.
Finite controls supplement, not replace, the operational kernel theorems.
"""
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess

old=Path(os.environ['FT1536_SOURCE3_ORIGINAL_W'])
repo=next(p for p in old.parents if (p/'Extra/c/falcon-keygen.c').exists())
root=repo/'Extra/c';component=repo/'proofs/ft1536/development/T12_1/source3'
profile_path=old/'inputs/source/PROFILE.json';profile=json.loads(profile_path.read_text())
def digest(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def plain(x):
    if isinstance(x,dict): return {str(k):plain(v) for k,v in x.items()}
    if isinstance(x,(list,tuple)): return [plain(v) for v in x]
    if isinstance(x,(str,bool)) or x is None: return x
    return int(x)
def once(text,first,last):
    assert text.count(first)==1,first
    return text.replace(first,last,int(1))
def literal_list(text,name):
    match=re.search(r'def '+name+r' : List String := (\[.*?\])\n',text,re.S)
    assert match,name
    return json.loads(match.group(1))
names=['falcon-keygen.c','frng.c','shake.c','internal.h','falcon.h','shake.h','fpr-emulated.h']
pins={name:digest(root/name) for name in names}
historical={name:profile['core']['source_files'][name] for name in names}
for name in names:
    if name!='fpr-emulated.h': assert pins[name]==historical[name],name
assert historical['fpr-emulated.h']=='242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa'
assert pins['fpr-emulated.h']=='6b897d6c217ef25a322e3b5c3d9488b9d6b8d0e369a710d8fce2259f24e6d84f'
keygen=(root/'falcon-keygen.c').read_text();frng=(root/'frng.c').read_text();shake=(root/'shake.c').read_text()
frng_literal=component/'formal/Source3/KeygenEntropySource.lean';literal=frng_literal.read_text()
urandom_lines=literal_list(literal,'urandomLines');wrapper_lines=literal_list(literal,'wrapperLines')
linux_wrapper=literal_list(literal,'linuxWrapper')
assert urandom_lines==frng.splitlines(keepends=True)[int(117):int(148)]
assert wrapper_lines==frng.splitlines(keepends=True)[int(170):int(187)]
assert pins['frng.c'] in literal
macro_command=['gcc','-std=c99','-dM','-E','-I',str(root)]+profile['core']['Makefile_flags']+[str(root/'frng.c')]
macro=subprocess.run(macro_command,capture_output=True)
Path('linux_macros.stdout').write_bytes(macro.stdout);Path('linux_macros.stderr').write_bytes(macro.stderr)
assert macro.returncode==0 and not macro.stderr
macros={m.group(1):m.group(2).strip() for m in re.finditer(rb'^#define ([A-Za-z_]\w*) (.*)$',macro.stdout,re.M)}
expected_macros={b'USE_URANDOM':b'1',b'USE_WIN32_RAND':b'0',b'O_RDONLY':b'00',b'EINTR':b'4'}
for name,value in expected_macros.items(): assert macros.get(name,b'0')==value,(name,macros.get(name))
preprocess_command=['gcc','-std=c99','-E','-P','-I',str(root)]+profile['core']['Makefile_flags']+[str(root/'frng.c')]
preprocess=subprocess.run(preprocess_command,capture_output=True)
Path('linux_active.stdout').write_bytes(preprocess.stdout);Path('linux_active.stderr').write_bytes(preprocess.stderr)
assert preprocess.returncode==0 and not preprocess.stderr
def function_text(text,name):
    match=re.search(re.escape(name)+r'\([^;{}]*\)\s*\{',text)
    assert match,name
    start=match.start();opening=text.index('{',start);depth=ZZ(1);end=opening+1
    while depth:
        if text[end]=='{': depth+=1
        if text[end]=='}': depth-=1
        end+=1
    return text[start:end]
def tokens(text): return re.findall(r'\w+|[^\s\w]',text)
assert tokens(function_text(preprocess.stdout.decode(),'falcon_get_seed'))==tokens(function_text(''.join(linux_wrapper),'falcon_get_seed'))
binding={'source_pins':pins,'historical':historical,'frng_literal_sha256':digest(frng_literal),
    'linux_macro_values':{k.decode():v.decode() for k,v in expected_macros.items()},
    'macro_command':macro_command,'preprocess_command':preprocess_command,
    'literal_regions':{'urandom':[118,148],'wrapper':[171,187]},
    'scope':'Linux M0 helper controls, scripted public syscall observations. Inherited039 approved live FPR difference rehashed; not a complete historical M0 build or an OS proof.'}
Path('RNG_SOURCE_BINDING.json').write_text(json.dumps(plain(binding),indent=2)+'\n')

lengths=[ZZ(x) for x in [0,1,103,104,135,136,137,271,272,409]]
flags=[(0,0),(0,1),(1,0),(1,1),(-3,-4),(0,-7),(2,0)]
ready_cases=[];seed_cases=[];entropy_cases=[]
def initial(case,length): return bytes(int((13*i+17*case+3)%256) for i in range(length))
def external(case): return bytes(int((11*i+7*case+91)%256) for i in range(32))
def injected(case,length): return bytes(int((19*i+23*case+5)%256) for i in range(length))
def io_expected(length,plan):
    if length==0: return [1,0,0,0,0]
    return [[0,1,0,0,0],[0,1,1,1,0],[0,1,2,1,min(17,length)],
            [1,1,5,1,length],[1,1,1,1,length]][int(plan)]
for seeded,flipped in flags:
    for plan in range(5):
        case=ZZ(len(ready_cases));length=lengths[int(case%len(lengths))];data=initial(case,length)
        io=io_expected(ZZ(32),plan) if seeded==0 else [1,0,0,0,0]
        success=io[0]==1
        new_seeded=1 if seeded==0 and success else seeded
        new_flipped=1 if success and (flipped==0 or seeded==0) else flipped
        absorbed=data
        if seeded==0 and success:
            if flipped!=0: absorbed=hashlib.shake_256(data).digest(int(32))
            absorbed+=external(case)
        ready_cases.append({'case':case,'seeded':seeded,'flipped':flipped,'plan':plan,'length':length,
            'expected':{'return':io[0],'seeded':new_seeded,'flipped':new_flipped,'io':io[1:],
                'dptr':136 if success and (flipped==0 or seeded==0) else (136 if flipped else length%136),
                'digest':hashlib.shake_256(absorbed).hexdigest(int(64)) if success else '-',
                'unchanged':int(not success or (seeded!=0 and flipped!=0)),
                'counter':0 if success else -1,'extents':[6144]*5+[32] if success else [0]*6}})
for flipped in [0,-4]:
    for replace in [0,1,-2]:
        for length in [0,32,201]:
            case=ZZ(len(seed_cases));old_len=lengths[int(case%len(lengths))];data=initial(case,old_len)
            seeded=-3 if case%2 else 0
            if replace: absorbed=injected(case,length)
            else:
                absorbed=hashlib.shake_256(data).digest(int(32)) if flipped else data
                absorbed+=injected(case,length)
            seed_cases.append({'case':case,'flipped':flipped,'replace':replace,'length':length,'old_length':old_len,'seeded':seeded,
                'expected':{'seeded':1 if replace else seeded,'flipped':0,
                    'dptr':ZZ(len(absorbed))%136,'digest':hashlib.shake_256(absorbed).hexdigest(int(64))}})
for length in [0,32]:
    for plan in range(5):
        case=ZZ(len(entropy_cases));io=io_expected(ZZ(length),plan)
        payload=external(case);expected=payload[:int(io[4])]+bytes([int(204)])*(int(32-io[4]))
        entropy_cases.append({'case':case,'length':length,'plan':plan,'expected':{'io':io,'bytes':expected.hex()}})
Path('RNG_PUBLIC_FIXTURE.json').write_text(json.dumps(plain({'ready':ready_cases,'set_seed':seed_cases,'entropy':entropy_cases}),indent=2)+'\n')

declarations=r'''
#include <stdio.h>
#include <stddef.h>
#include <errno.h>
#include <sys/types.h>
static int plan, fixture_case, opens, reads, closes;
static size_t position;
static int fixture_open(const char *,int,...);
static ssize_t fixture_read(int,void *,size_t);
static int fixture_close(int);
'''
scripted=r'''
static int fixture_open(const char *path,int mode,...) {
 opens++; if(strcmp(path,"/dev/urandom") || mode!=0) return -1;
 return plan==0 ? -1 : 17;
}
static ssize_t fixture_read(int fd,void *out,size_t len) {
 reads++;if(fd!=17)return -1;
 if(plan==1 || (plan==2 && reads==2)){errno=EIO;return -1;}
 if(plan==3 && (reads==1 || reads==4)){errno=EINTR;return -1;}
 if(plan==3 && reads==2)return 0;
 size_t take=len;if(plan==2 && take>17)take=17;if(plan==3 && reads==3 && take>7)take=7;
 for(size_t i=0;i<take;i++)((unsigned char *)out)[i]=(unsigned char)(11*(position+i)+7*fixture_case+91);
 position+=take;return (ssize_t)take;
}
static int fixture_close(int fd){closes++;return fd==17?0:-1;}
static void reset_fixture(int c,int p){fixture_case=c;plan=p;opens=reads=closes=0;position=0;errno=0;}
static void fill_initial(unsigned char *data,size_t n,int c){for(size_t i=0;i<n;i++)data[i]=(unsigned char)(13*i+17*c+3);}
static void fill_seed(unsigned char *data,size_t n,int c){for(size_t i=0;i<n;i++)data[i]=(unsigned char)(19*i+23*c+5);}
static void print_hex(const unsigned char *data,size_t n){for(size_t i=0;i<n;i++)printf("%02x",data[i]);}
static void start(falcon_keygen *fk,int seeded,int flipped,int c,size_t length,uint32_t *scratch) {
 unsigned char data[512];memset(fk,0xA7,sizeof *fk);fk->logn=10;fk->ternary=1;fk->tmp=scratch;fk->tmp_len=65536;
 shake_init(&fk->rng,512);fill_initial(data,length,c);shake_inject(&fk->rng,data,length);
 fk->seeded=seeded;fk->flipped=flipped;if(flipped)shake_flip(&fk->rng);
}
struct observation {long long counter;size_t extents[6],n;int distinct;};
static int selected_ready_prefix(falcon_keygen *fk,struct observation *o) {
'''
prologue=''.join(keygen.splitlines(keepends=True)[int(7804):int(7838)])
prefix_end=r'''
 (void)sizeof u;(void)sizeof klen;(void)sizeof skoff;(void)sizeof skbuf;(void)sizeof i;
 o->counter=(long long)local_attempts;
 o->n=n;
 o->extents[0]=sizeof f;o->extents[1]=sizeof g;o->extents[2]=sizeof F;o->extents[3]=sizeof G;o->extents[4]=sizeof h;o->extents[5]=sizeof ske;
 const void *objects[]={f,g,F,G,h,ske};o->distinct=1;
 for(size_t a=0;a<6;a++)for(size_t b=a+1;b<6;b++)o->distinct &= objects[a]!=objects[b];
 return 1;
}
'''
ready_table='static const int ready[][4]={'+','.join('{'+','.join(str(int(c[k])) for k in ['seeded','flipped','plan','length'])+'}' for c in ready_cases)+'};\n'
seed_table='static const int seeds[][5]={'+','.join('{'+','.join(str(int(c[k])) for k in ['seeded','flipped','replace','length','old_length'])+'}' for c in seed_cases)+'};\n'
entropy_table='static const int entropy[][2]={'+','.join('{'+str(int(c['length']))+','+str(int(c['plan']))+'}' for c in entropy_cases)+'};\n'
main=r'''
int main(void){
 printf("L 0 %zu %zu %zu %zu %zu %zu %zu %zu %zu %zu %zu %zu %zu %zu %zu %zu\n",sizeof(falcon_keygen),offsetof(falcon_keygen,logn),offsetof(falcon_keygen,ternary),offsetof(falcon_keygen,rng),offsetof(falcon_keygen,seeded),offsetof(falcon_keygen,flipped),offsetof(falcon_keygen,tmp),offsetof(falcon_keygen,tmp_len),sizeof(shake_context),offsetof(shake_context,dbuf),offsetof(shake_context,dptr),offsetof(shake_context,rate),offsetof(shake_context,A),sizeof(ssize_t),sizeof(int),sizeof(void *));
 for(size_t c=0;c<sizeof ready/sizeof ready[0];c++) {
  falcon_keygen fk,old;uint32_t scratch[16384]={0};unsigned char out[64];struct observation o;
  memset(&o,0,sizeof o);o.counter=-1;start(&fk,ready[c][0],ready[c][1],(int)c,(size_t)ready[c][3],scratch);old=fk;reset_fixture((int)c,ready[c][2]);
  int ret=selected_ready_prefix(&fk,&o);int same=memcmp(&old,&fk,sizeof fk)==0;
  int outside=memcmp(&old,&fk,8)==0 && memcmp((unsigned char *)&old+432,(unsigned char *)&fk+432,sizeof fk-432)==0;
  printf("R %zu %d %d %d %d %d %d %zu %zu %d %d %lld %d",c,ret,fk.seeded,fk.flipped,opens,reads,closes,position,fk.rng.dptr,same,outside,o.counter,o.distinct);
  for(size_t k=0;k<6;k++){printf(" %zu",o.extents[k]);}printf(" %zu ",o.n);
  if(ret){shake_extract(&fk.rng,out,sizeof out);print_hex(out,sizeof out);}else printf("-");printf("\n");
 }
 for(size_t c=0;c<sizeof seeds/sizeof seeds[0];c++) {
  falcon_keygen fk,old;uint32_t scratch[16384]={0};unsigned char data[201],out[64];
  start(&fk,seeds[c][0],seeds[c][1],(int)c,(size_t)seeds[c][4],scratch);old=fk;fill_seed(data,sizeof data,(int)c);reset_fixture((int)c,0);
  falcon_keygen_set_seed(&fk,data,(size_t)seeds[c][3],seeds[c][2]);
  int outside=memcmp(&old,&fk,8)==0 && memcmp((unsigned char *)&old+432,(unsigned char *)&fk+432,sizeof fk-432)==0;
  printf("S %zu %d %d %zu %d %d %d %d ",c,fk.seeded,fk.flipped,fk.rng.dptr,outside,opens,reads,closes);
  shake_flip(&fk.rng);shake_extract(&fk.rng,out,sizeof out);print_hex(out,sizeof out);printf("\n");
 }
 for(size_t c=0;c<sizeof entropy/sizeof entropy[0];c++) {
  unsigned char out[32];memset(out,0xCC,sizeof out);reset_fixture((int)c,entropy[c][1]);
  int ret=falcon_get_seed(out,(size_t)entropy[c][0]);printf("E %zu %d %d %d %d %zu ",c,ret,opens,reads,closes,position);print_hex(out,sizeof out);printf("\n");
 }
 return 0;
}
'''
region=''.join(keygen.splitlines(keepends=True)[int(5272):int(5286)])
def mutate_ready(before,after): return once(keygen,region,once(region,before,after))
variants={'baseline':(keygen,shake),
    'missing_seeded_store':(mutate_ready('fk->seeded = 1;','fk->seeded = 0;'),shake),
    'missing_flipped_store':(mutate_ready('fk->flipped = 1;','fk->flipped = 0;'),shake),
    'forced_seed_failure':(mutate_ready('if (!falcon_get_seed(tmp, sizeof tmp))','if (!falcon_get_seed(tmp, sizeof tmp) || 1)'),shake),
    'wrong_tmp_extent':(keygen.replace('unsigned char tmp[32];','unsigned char tmp[31];'),shake),
    'wrong_replace_argument':(mutate_ready('falcon_keygen_set_seed(fk, tmp, sizeof tmp, 0);','falcon_keygen_set_seed(fk, tmp, sizeof tmp, 1);'),shake),
    'wrong_boundary_padding':(keygen,once(shake,'sc->dbuf[sc->dptr ++] = 0x9F;','sc->dbuf[sc->dptr ++] = 0x1F;'))}
assert keygen.count('unsigned char tmp[32];')==2
records=[];baseline=None
for mode,options in [('normal',['-O2']),('ubsan',['-O1','-fsanitize=undefined','-fno-sanitize-recover=all'])]:
    for variant,(kg,sh) in variants.items():
        label=mode+'_'+variant;cfile=Path(label+'.c');sfile=Path(label+'_shake.c');binary=Path(label+'.bin')
        cfile.write_text(declarations+kg+'\n#define open fixture_open\n#define read fixture_read\n#define close fixture_close\n'+frng+
            '\n#undef open\n#undef read\n#undef close\n'+scripted+prologue+prefix_end+ready_table+seed_table+entropy_table+main)
        sfile.write_text(sh)
        command=['gcc','-std=c99','-Wall','-Wextra','-Werror','-ffunction-sections','-fdata-sections']+profile['core']['Makefile_flags']+options+[
            '-I',str(root),str(cfile),str(sfile),'-Wl,--gc-sections','-o',str(binary)]
        compiled=subprocess.run(command,capture_output=True)
        Path(label+'.compile.stdout').write_bytes(compiled.stdout);Path(label+'.compile.stderr').write_bytes(compiled.stderr)
        assert compiled.returncode==0 and not compiled.stdout and not compiled.stderr,label
        ran=subprocess.run([str(binary.resolve())],capture_output=True)
        Path(label+'.stdout').write_bytes(ran.stdout);Path(label+'.stderr').write_bytes(ran.stderr)
        Path(label+'.run.json').write_text(json.dumps({'returncode':ran.returncode})+'\n')
        assert ran.returncode==0 and not ran.stderr,label
        rows=[];differences=[];counts={'L':0,'R':0,'S':0,'E':0}
        for line in ran.stdout.decode().splitlines():
            values=line.split();kind=values[0];case=ZZ(values[1]);assert case==counts[kind];counts[kind]+=1
            if kind=='L':
                assert [ZZ(x) for x in values[2:]]==[448,0,4,8,424,428,432,440,416,0,200,208,216,8,4,8],label
                ok=True
            elif kind=='R':
                ret,seeded,flipped,opens,reads,closes,position,dptr,same,outside,counter,distinct=[ZZ(x) for x in values[2:14]]
                extents=[ZZ(x) for x in values[14:20]];dimension=ZZ(values[20]);stream=values[21];expected=ready_cases[int(case)]['expected']
                ok=ret==expected['return'] and seeded==expected['seeded'] and flipped==expected['flipped'] and [opens,reads,closes,position]==expected['io'] and dptr==expected['dptr'] and same==expected['unchanged'] and outside==1 and counter==expected['counter'] and extents==expected['extents'] and distinct==int(ret!=0) and dimension==expected['return']*1536 and stream==expected['digest']
            elif kind=='S':
                seeded,flipped,dptr,outside,opens,reads,closes=[ZZ(x) for x in values[2:9]];stream=values[9];expected=seed_cases[int(case)]['expected']
                ok=seeded==expected['seeded'] and flipped==expected['flipped'] and dptr==expected['dptr'] and outside==1 and [opens,reads,closes]==[0,0,0] and stream==expected['digest']
            else:
                assert kind=='E';numbers=[ZZ(x) for x in values[2:7]];stream=values[7];expected=entropy_cases[int(case)]['expected'];ok=numbers==expected['io'] and stream==expected['bytes']
            rows.append({'kind':kind,'case':int(case),'observed':values[2:]})
            if not ok: differences.append({'kind':kind,'case':int(case)})
        assert counts=={'L':1,'R':35,'S':18,'E':10},(label,counts)
        if variant=='baseline':
            assert not differences,(label,differences)
            if baseline is None: baseline=rows
            else: assert baseline==rows
        else: assert differences,label
        artifacts=[cfile,sfile,binary,Path(label+'.compile.stdout'),Path(label+'.compile.stderr'),Path(label+'.stdout'),Path(label+'.stderr'),Path(label+'.run.json')]
        records.append({'mode':mode,'variant':variant,'counts':counts,'results':rows,'differences':differences,'command':command,
            'artifacts':{str(p):digest(p) for p in artifacts}})
Path('RNG_READY_CHECK.json').write_text(json.dumps(plain({'status':'PASS_FINITE_SOURCE_CONTROLS','variants':records,
    'source_pins':pins,'profile_sha256':digest(profile_path),'binding_sha256':digest('RNG_SOURCE_BINDING.json'),
    'fixture_sha256':digest('RNG_PUBLIC_FIXTURE.json'),'ready_cases_per_run':35,'set_seed_cases_per_run':18,'entropy_cases_per_run':10,
    'extra_artifacts':{str(p):digest(p) for p in [Path('linux_macros.stdout'),Path('linux_macros.stderr'),Path('linux_active.stdout'),Path('linux_active.stderr')]},
    'scope':'Actual selected7805--7838 prefix on all readiness branches; complete source set_seed/init/inject/flip and finite Linux frng control. Scripted PUBLIC entropy observations only, independent exact SHAKE fixtures and source frames/counter0/extents. No real entropy, whole KeyGen/attempt, emitted key, availability/uniformity/PRG or machine-refinement claim.'}),indent=2)+'\n')
