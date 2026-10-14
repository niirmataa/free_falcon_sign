#!/usr/bin/env sage
# Native witness selection and independent exact packet controls.
# Native observations do NOT instantiate the Lean source Execution relation.
import hashlib, json, os, re, shlex, shutil, struct, subprocess, sys, time
from pathlib import Path
from sage.env import SAGE_VERSION

root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
repo=root.parents[4]; source=repo/'Extra/c'; dest=Path.cwd()
def sha(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
parent=root/'.build/success112/POSTSEAL_112.json'
assert sha(parent)=='e387fe7824253fa149e10bbc93fa707aa039df10de2e58b90aea2ad7933e29c3'
pins=json.loads(parent.read_text())['checked']
smap=root/'notes/run/DO_SIGN_SOURCE_MAP_086.json';assert sha(smap)==pins[str(smap)]
inputs=[]
for row in json.loads(smap.read_text())['sources']:
    p=repo/row['path'];assert sha(p)==row['sha256'];inputs.append({'path':str(p),'sha256':sha(p)})
inputs.append({'path':str(source/'Makefile'),'sha256':sha(source/'Makefile')})
for rel in ['checks/keygen_witness113.c','tools/keygen_witness113_instrument.py','sage/keygen_witness113.sage']:
    p=root/rel;inputs.append({'path':str(p),'sha256':sha(p)})
flags=shlex.split(re.search(r'^CFLAGS = (.+)$',(source/'Makefile').read_text(),re.M).group(1))
assert '-DFPR_IMPL="fpr-emulated.h"' in flags
assert '-DTRUE_TERNARY_SECRET_MODE=1' in flags and '-DTERNARY_KEYGEN_MAX_ATTEMPTS=3000000' in flags
commands=[]
def command(label,argv,cwd=dest):
    out=dest/(label+'.stdout');err=dest/(label+'.stderr')
    start=time.monotonic()
    executable=Path(str(argv[0])).resolve()
    executable_hash=sha(executable)
    with out.open('wb') as so,err.open('wb') as se:
        result=subprocess.run([str(a) for a in argv],cwd=cwd,stdout=so,stderr=se,timeout=600)
    assert sha(executable)==executable_hash,('EXECUTABLE_CHANGED',label)
    row={'label':label,'executable':str(executable),'executable_sha256':executable_hash,'argv':[str(a) for a in argv],'cwd':str(cwd),'exit_code':int(result.returncode),
        'elapsed_s':float(time.monotonic()-start),'stdout':str(out),'stdout_sha256':sha(out),'stderr':str(err),'stderr_sha256':sha(err)}
    commands.append(row);(dest/'COMMANDS.json').write_text(json.dumps(commands,indent=2)+'\n')
    assert result.returncode==0,(label,result.returncode,str(err))
    assert out.stat().st_size==err.stat().st_size==0,('NONEMPTY_LOG',label)

modified=dest/'observed_keygen.c'
command('instrument',[sys.executable,'-B',root/'tools/keygen_witness113_instrument.py',modified])
shutil.copyfile(root/'checks/keygen_witness113.c',dest/'witness.c')
objects=[]
for name in ['falcon-enc','falcon-vrfy','frng','shake','fpr-emulated','falcon-fft','falcon-sign']:
    obj=dest/(name+'.o');command('compile_'+name,['/usr/bin/c99',*flags,'-I',source,'-c',source/(name+'.c'),'-o',obj]);objects.append(obj)
for label,body in [('original',source/'falcon-keygen.c'),('observed',modified)]:
    command('compile_'+label,['/usr/bin/c99',*flags,'-I',source,'-DKEYGEN_BODY="'+str(body)+'"','-c',dest/'witness.c','-o',dest/(label+'.o')])
    command('link_'+label,['/usr/bin/c99','-o',dest/label,dest/(label+'.o'),*objects,'-lm'])

selected=None;attempts=[]
candidate_counters=[int(sys.argv[1])] if len(sys.argv)==2 else range(32)
for counter in candidate_counters:
    run=dest/('candidate_%03d'%counter);run.mkdir()
    command('candidate_%03d'%counter,[dest/'observed',str(counter)],run)
    result=json.loads((run/'RESULT.json').read_text());attempts.append(result)
    if result['return']==1 and result['attempts_observed']==1:
        selected=run;break
assert selected is not None,'No first-attempt witness in the bounded public candidate list'
counter=json.loads((selected/'RESULT.json').read_text())['counter']
control=dest/'original_control';control.mkdir();command('original_control',[dest/'original',str(counter)],control)
repeat=dest/'observed_repeat';repeat.mkdir();command('observed_repeat',[dest/'observed',str(counter)],repeat)
for name in ['seed.bin','private.bin','public.bin']:
    assert (selected/name).read_bytes()==(control/name).read_bytes()==(repeat/name).read_bytes(),name
assert (selected/'events.bin').read_bytes()==(repeat/'events.bin').read_bytes()

def events(folder):
    raw=(folder/'events.bin').read_bytes();at=0;out=[]
    while at<len(raw):
        n=int.from_bytes(raw[at:at+4],'little');at+=4
        tag=raw[at:at+n].decode();at+=n
        n=int.from_bytes(raw[at:at+8],'little');at+=8
        data=raw[at:at+n];assert len(data)==n;at+=n;out.append((tag,data))
    assert at==len(raw);return out
records=events(selected)
def all_tag(tag):return [data for name,data in records if name==tag]
def only(tag):
    xs=all_tag(tag);assert len(xs)==1,(tag,len(xs));return xs[0]
seed=(selected/'seed.bin').read_bytes();assert len(seed)==32
stream=b''.join(all_tag('shake_bytes'))
assert stream==hashlib.shake_256(seed).digest(len(stream))
assert stream==b''.join(data for name,data in events(control) if name=='shake_bytes')
position=0;sampled=[]
for vector in range(2):
    rb=ZZ(0);bits=ZZ(0);xs=[]
    for u in range(1536):
        while True:
            if bits<2:
                assert position+8<=len(stream)
                rb=ZZ(int.from_bytes(stream[position:position+8],'little'));position+=8;bits=64
            x=rb & 3;rb >>= 2;bits-=2
            if x<3:
                xs.append(x-1);break
    sampled.append(xs)
assert position==len(stream)
source_vectors=[[ZZ(v) for v in struct.unpack('<1536h',only(tag))] for tag in ['sample_f','sample_g','solver_F','solver_G']]
assert sampled==source_vectors[:2]
assert all(abs(v)<=bound for xs,bound in zip(source_vectors,[1,1,2047,2047]) for v in xs)
assert all(int.from_bytes(only(tag),'little',signed=True)==1 for tag in ['public_return','solver_return','leaf_return'])
assert all(int.from_bytes(only(tag),'little',signed=True)!=0 for tag in ['resultant_f','resultant_g'])

sk=(selected/'private.bin').read_bytes();pk=(selected/'public.bin').read_bytes()
assert sk[0]==170 and pk[0]==138
bitpos=8;decoded=[];lengths=[]
def bit():
    global bitpos
    assert bitpos<8*len(sk)
    b=(sk[bitpos//8]>>(7-bitpos%8))&1;bitpos+=1;return ZZ(b)
for vector in range(4):
    start=bitpos;xs=[]
    for u in range(1536):
        sign=bit();low=ZZ(0)
        for _ in range(8):low=2*low+bit()
        high=ZZ(0)
        while bit()==0:high+=1
        magnitude=low+256*high
        assert not(sign and magnitude==0)
        xs.append(-magnitude if sign else magnitude)
    while bitpos%8:assert bit()==0
    lengths.append((bitpos-start)//8);decoded.append(xs)
assert bitpos==8*len(sk) and decoded==source_vectors
assert len(sk)==1+sum(lengths) and len(sk)<=10369
assert len(pk)==2881
public_bits=[(b>>j)&1 for b in pk[1:] for j in reversed(range(8))]
h=[sum(ZZ(public_bits[15*i+j]) * 2^(14-j) for j in range(15)) for i in range(1536)]
assert all(0<=v<18433 for v in h)
assert h==[ZZ(v) for v in struct.unpack('<1536H',only('public_h'))]
ring=PolynomialRing(ZZ,'x');x=ring.gen();phi=x^1536-x^768+1
f,g,F,G=[ring(xs) for xs in source_vectors]
assert (f*G-g*F)%phi==18433
assert all(v%18433==0 for v in ((f*ring(h)-g)%phi).list())

(selected/'DECODED.json').write_text(json.dumps({'f':[int(v) for v in decoded[0]],'g':[int(v) for v in decoded[1]],'F':[int(v) for v in decoded[2]],'G':[int(v) for v in decoded[3]],'h':[int(v) for v in h]},indent=2)+'\n')
(selected/'STREAM.bin').write_bytes(stream)
for row in inputs:assert sha(row['path'])==row['sha256']
# Declare scientific outputs explicitly; runtime cache/process files are not evidence.
scientific=[modified,modified.with_suffix('.json'),dest/'witness.c',dest/'COMMANDS.json',dest/'SOURCE_INPUTS.json']
for run_info in attempts:
    folder=dest/('candidate_%03d'%run_info['counter'])
    scientific += [folder/name for name in ['seed.bin','events.bin','RESULT.json','private.bin','public.bin']]
scientific += [selected/'DECODED.json',selected/'STREAM.bin']
for folder in [control,repeat]:
    scientific += [folder/name for name in ['seed.bin','events.bin','RESULT.json','private.bin','public.bin']]
assert len(scientific)==len(set(scientific))
artifacts=[]
for path in sorted(scientific):
    assert path.is_file(),('MISSING_DECLARED_RESULT',str(path))
    artifacts.append({'path':str(path),'sha256':sha(path),'bytes':int(path.stat().st_size)})

result={'status':'NATIVE_FIRST_ATTEMPT_WITNESS_AND_EXACT_CONTROLS; KERNEL_SOURCE_WITNESS_OPEN',
    'selected':str(selected),'counter':int(counter),'seed_hex':seed.hex(),'selection_attempts':attempts,
    'observed_return':int(1),'observed_attempt_count':int(1),'private_length':int(len(sk)),'public_length':int(len(pk)),
    'private_segment_lengths':[int(v) for v in lengths],'shake_bytes':int(len(stream)),
    'profile_flags':flags,'allocator':'fixed zero-initialized fresh objects; source bodies unchanged in original control',
    'observation_coverage':json.loads(modified.with_suffix('.json').read_text())['coverage'],
    'full_statement_trace':False,'kernel_source_witness':False,'probability_lower_bound_proved':False,
    'source_inputs':inputs,'binary_pins':[{'path':str(dest/name),'sha256':sha(dest/name)} for name in ['original','observed']],'artifacts':artifacts,'sage_version':SAGE_VERSION,'python_version':sys.version,
    'exact_domains':['ZZ','ZZ[x]'],'checks':['original/observed/repeated packet equality','repeated boundary evidence byte equality','SHAKE256 output equality','MODE1 2-bit rejection stream equality','STATIC decoding and segment padding','public canonical decoding','coefficient bounds','exact NTRU equation','public-key quotient equation']}
(dest/'WITNESS113.json').write_text(json.dumps(result,indent=2)+'\n')
