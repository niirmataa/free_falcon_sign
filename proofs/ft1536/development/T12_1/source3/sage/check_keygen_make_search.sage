"""050 PUBLIC scripted chronology/material controls, native Sage preparser.

Only the actual pinned caller is compiled. All cryptographic callees, context
layout and codecs are explicit diagnostic mocks. No entropy, private KeyGen,
real key bytes, mathematical gate law or probability measurement is used.
"""
import ast
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
def digest(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def plain(x):
    if isinstance(x,dict): return {str(k):plain(v) for k,v in x.items()}
    if isinstance(x,(list,tuple)): return [plain(v) for v in x]
    if isinstance(x,(str,bool)) or x is None: return x
    return int(x)
def once(text,first,last):
    assert text.count(first)==1,first
    return text.replace(first,last,int(1))

profile_path=old/'inputs/source/PROFILE.json'
profile=json.loads(profile_path.read_text())
pins={n:digest(root/n) for n in ['falcon-keygen.c','falcon-vrfy.c','internal.h','falcon.h','fpr-emulated.h']}
for n in pins:
    if n!='fpr-emulated.h': assert pins[n]==profile['core']['source_files'][n],n
assert pins['fpr-emulated.h']=='6b897d6c217ef25a322e3b5c3d9488b9d6b8d0e369a710d8fce2259f24e6d84f'
body=''.join((root/'falcon-keygen.c').read_text().splitlines(keepends=True)[int(7780):int(8187)])
actual=once(once(body,'local_attempts = 0;','local_attempts = injected_start;'),'falcon_keygen_make(','caller_control(')

# Static mock text is reused by a pinned AST extraction, never by executing049.
old_checker=component/'sage/check_keygen_make_control.sage'
assert digest(old_checker)=='3c51e8613229b58dec9719676eabaeaccefece497bf9f00e0bd9e004654bf559'
preludes=[n.value.value for n in ast.parse(old_checker.read_text()).body if isinstance(n,ast.Assign)
    and any(isinstance(t,ast.Name) and t.id=='prelude' for t in n.targets)]
assert len(preludes)==1 and isinstance(preludes[0],str)
prelude=preludes[0]
prelude=once(prelude,'static int identity;','static int identity; static int public_script[16]; static fpr *scratch_input;')
prelude=once(prelude,'static int reject(int gate) { return attempt==1 && failed_gate==gate; }',
    'static int reject(int gate) { return attempt<=16 && public_script[attempt-1]==gate; }')
prelude=once(prelude,'static int falcon_compute_public(',r'''
static int sample_bytes(const int16_t *p,int slot) {
 for(size_t i=0;i<1536;i++)if(p[i]!=(int16_t)((attempt+(int)i+slot)%3-1))return 0;
 return 1;
}
static int solved_bytes(const int16_t *p,int slot) {
 int16_t v=(int16_t)(slot==2?attempt%7:-attempt%7);
 for(size_t i=0;i<1536;i++)if(p[i]!=v)return 0;
 return 1;
}
static int falcon_compute_public(''')
prelude=once(prelude,'(void)l;(void)t;identity &= f==expected[0] && g==expected[1];public_input=h;',
    '(void)l;(void)t;identity &= f==expected[0] && g==expected[1] && sample_bytes(f,0) && sample_bytes(g,1);public_input=h;')
prelude=once(prelude,'(void)fk;identity &= f==expected[0] && g==expected[1];expected[2]=F;',
    '(void)fk;identity &= f==expected[0] && g==expected[1] && sample_bytes(f,0) && sample_bytes(g,1);expected[2]=F;')
prelude=once(prelude,'(void)tmp;(void)l;(void)t;identity &= f==expected[0] && g==expected[1] && F==expected[2] && G==expected[3];',
    '(void)l;(void)t;identity &= tmp==scratch_input && f==expected[0] && g==expected[1] && F==expected[2] && G==expected[3] && sample_bytes(f,0) && sample_bytes(g,1) && solved_bytes(F,2) && solved_bytes(G,3);')
prelude=once(prelude,'seen_enc++;event("enc,");if(len<2)return 0;',
    'identity &= seen_enc<2?sample_bytes(p,seen_enc):solved_bytes(p,seen_enc); seen_enc++;event("enc,");if(len<2)return 0;')
prelude=once(prelude,'(void)logn;identity &= h==public_input;event("pk,");',
    '(void)logn;identity &= h==public_input;for(size_t i=0;i<1536;i++)identity &= h[i]==(uint16_t)(attempt+i%7);event("pk,");')

scripts=[[0],[1,2,3,4,5,6,7,0],[7,7,0],[6,5,3,0],[1,6,7,0],[5,0],[2,4,0]]
cases=[{'ready':1,'script':s,'start':ZZ(0),'private':ZZ(128),'public':ZZ(128)} for s in scripts]
cases += [{'ready':1,'script':s,'start':ZZ(start),'private':ZZ(128),'public':ZZ(128)}
    for start in [2999998,2999999,3000000] for s in [[0],[5,6,0]]]
cases += [{'ready':0,'script':[0],'start':ZZ(0),'private':ZZ(128),'public':ZZ(128)},
    {'ready':1,'script':[7,0],'start':ZZ(0),'private':ZZ(0),'public':ZZ(128)},
    {'ready':1,'script':[6,0],'start':ZZ(0),'private':ZZ(4),'public':ZZ(128)},
    {'ready':1,'script':[5,0],'start':ZZ(0),'private':ZZ(128),'public':ZZ(0)}]
gates=['rf,','rg,','raw,','gs,','public,','solve,','cert,']
expected=[];chronology=[]
for index,case in enumerate(cases):
    counter=ZZ(case['start']);steps=[];sampled=ZZ(0);enc=ZZ(0);ret=ZZ(0);sk=case['private'];pk=case['public'];numbers=[];accepted=False;exhausted=False
    if case['ready']:
        for failed in case['script']:
            counter+=1
            if counter>3000000:
                exhausted=True
                break
            numbers.append(counter);sampled+=2
            steps+=['f,','g,']+gates[:int(failed or 7)]
            if failed==0:
                accepted=True
                if sk>=1:
                    enc=ZZ(4) if sk>=9 else ZZ(2);steps+=['enc,']*int(enc)
                    if sk>=9:
                        sk=ZZ(9)
                        if pk>=1: steps+=['pk,'];pk=ZZ(4);ret=ZZ(1)
                break
    assert sampled==2*len(numbers) and len(numbers)<=3000000-case['start']
    assert all(numbers[i]==case['start']+i+1 for i in range(len(numbers)))
    if exhausted: assert counter==3000001 and not accepted
    expected.append([ZZ(index),ret,sampled,enc,sk,pk,ZZ(1),''.join(steps) or '-'])
    chronology.append({'numbers':numbers,'counter':counter,'accepted':accepted,'exhausted_before_sampling':exhausted})
fixture={'scope':'PUBLIC SCRIPTED caller/memory diagnostics. Cryptographic callees/context/codecs are explicit MOCKS; not universal source proof or real KeyGen.',
    'cases':cases,'expected':expected,'chronology':chronology,
    'counter_seam':'Actual source0 replaced by injected public start ONLY in this finite diagnostic seam.'}
Path('SEARCH_PUBLIC_FIXTURE.json').write_text(json.dumps(plain(fixture),indent=2)+'\n')
rows=',\n'.join('{'+','.join(str(int(c[k])) for k in ['ready','start','private','public'])+',{'+','.join(str(int(x)) for x in c['script'])+'}}' for c in cases)
main=r'''
struct scenario {int ready;uint64_t start;size_t sk,pk;int script[16];};
static const struct scenario cases[]={SCENARIOS};
int main(void){
 static fpr scratch[4608]={0};falcon_keygen fk={10,1,scratch};unsigned char sk[128],pk[128];scratch_input=scratch;
 for(size_t c=0;c<sizeof cases/sizeof cases[0];c++){
  const struct scenario *s=&cases[c];ready=s->ready;injected_start=s->start;failed_gate=0;memcpy(public_script,s->script,sizeof public_script);
  attempt=compares=seen_samplers=seen_public=seen_solve=seen_cert=seen_enc=0;identity=1;trace_len=0;trace[0]=0;
  memset(expected,0,sizeof expected);public_input=0;size_t sklen=s->sk,pklen=s->pk;
  int ret=caller_control(&fk,0,sk,&sklen,pk,&pklen);
  printf("%zu %d %d %d %zu %zu %d %s\n",c,ret,seen_samplers,seen_enc,sklen,pklen,identity,trace_len?trace:"-");
 }
 return 0;
}
'''.replace('SCENARIOS',rows)
mutations={'baseline':actual,
    'reset_after_sampling':once(actual,'sample_true_ternary_secret(fk, g, n);','sample_true_ternary_secret(fk, g, n);\n local_attempts = injected_start;'),
    'swap_public_inputs':once(actual,'falcon_compute_public(h, f, g, logn, ter)','falcon_compute_public(h, g, f, logn, ter)'),
    'stale_same_pointer_material':once(actual,'/* FT1536 KeyGen Leaf Certificate */','f[0] = (int16_t)(f[0] + 1);\n /* FT1536 KeyGen Leaf Certificate */'),
    'wrong_certificate_scratch':once(actual,'ft_keygen_leaf_certificate((fpr *)fk->tmp,','ft_keygen_leaf_certificate((fpr *)fk->tmp + 1,'),
    'skip_certificate':once(actual,'if (ter && logn == 10 && n == 1536)','if (0 && ter && logn == 10 && n == 1536)'),
    'swap_fourth_segment':once(actual,'ske[3] = G;','ske[3] = F;')}
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
result={'status':'PASS_SCRIPTED_SEARCH_CONTROLS','scope':fixture['scope'],'source_pins':pins,
    'profile_sha256':digest(profile_path),'reused_mock_source_sha256':digest(old_checker),
    'fixture_sha256':digest('SEARCH_PUBLIC_FIXTURE.json'),'literal_make_range':[7781,8187],
    'variants':results,'runs':len(results),'cases_per_run':len(cases),'mutations_per_mode':len(mutations)-1,
    'limits':'Unchanged guarded runner. Public scripted diagnostic controls, not genuine callee bodies or a full M0 build.'}
Path('SEARCH_CONTROL_CHECK.json').write_text(json.dumps(plain(result),indent=2)+'\n')
