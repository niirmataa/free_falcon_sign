import json,os,re,shlex,subprocess,sys,time
from fractions import Fraction as F
from pathlib import Path
from backend import add,mul,div,cm,conj,cv
from root_model import tables,gram_root,root_point
from dyadic import value,rn
from replaylib import sha
W=Path.cwd();mode=sys.argv[1];assert mode in ['normal','san'];log=W/'checks/logs'/mode;log.mkdir(parents=True,exist_ok=True);records=[]
def run(tag,cmd,data=None,limit=90):
 t=time.monotonic();p=subprocess.run(cmd,input=data,capture_output=True,timeout=limit);so=log/(tag+'.stdout');se=log/(tag+'.stderr');so.write_bytes(p.stdout);se.write_bytes(p.stderr)
 records.append(dict(argv=cmd,cwd=str(W),exit_code=p.returncode,wall_limit=limit,elapsed=time.monotonic()-t,stdout=str(so.relative_to(W)),stderr=str(se.relative_to(W)),stdout_sha256=sha(so),stderr_sha256=sha(se)))
 (log/'commands.json').write_text(json.dumps(records,indent=2)+'\n');assert p.returncode==0,(tag,p.stderr.decode());return p.stdout
flags=shlex.split(re.search(r'^CFLAGS = (.*)$',(W/'source/Makefile').read_text(),re.M).group(1));flags=[f.replace('\\"','"') for f in flags]
flags+=['-std=c99','-ffunction-sections','-fdata-sections','-Isource']
if mode=='san':flags+=['-fsanitize=address,undefined','-fno-omit-frame-pointer','-g']
for name in ['root','keygen_map']:
 exe='bin/'+name+'_'+mode;cmd=['/usr/bin/gcc']+flags+['checks/'+name+'.c','source/falcon-fft.c','source/fpr-emulated.c','-Wl,--gc-sections','-lm','-o',exe];run('compile_'+name,cmd)
ntt=run('keygen_map',['bin/keygen_map_'+mode]);(W/'checks'/('keygen_map_'+mode+'.txt')).write_bytes(ntt)
words={0,1,0x000fffffffffffff,0x0010000000000000,0x3fe0000000000000,0x3ff0000000000000}
for e in [1,2,100,500,900,1000,1022,1023,1040,1054,1067,1100,1122]:
 for f in [0,1,(1<<51)-1,(1<<52)-1]:words.add((e<<52)|f)
words|={x^(1<<63) for x in words}
pairs=[(x,y) for x in sorted(words) for y in [rn(F(1,2)),rn(3),rn((1<<23)-1)]]
pairs +=[(rn(1<<44),rn(F(1,1024))),(1,rn(1<<80)),(rn(1<<80),1),(0x8000000000000000,rn(1))]
data=''.join(f'{x:016x} {y:016x}\n' for x,y in pairs).encode();(W/'checks/scalar_inputs.txt').write_bytes(data)
out=run('scalar',['bin/root_'+mode,'scalar'],data);native=[tuple(int(t,16) for t in row.split()) for row in out.decode().splitlines()]
assert native==[(add(x,y),mul(x,y),div(x,y)) for x,y in pairs]
u=F(1,1<<48);eta=F(1,1<<900);max_errors={k:F(0) for k in ['add','mul','div']}
for (x,y),outputs in zip(pairs,native):
 a,b=value(x),value(y)
 for op,z,ref,allow in [('add',outputs[0],a+b,u*(abs(a)+abs(b))+eta),('mul',outputs[1],a*b,u*abs(a*b)+eta),('div',outputs[2],a/b,u*abs(a/b)+eta)]:
  if op=='div' and not F(1,2)<=b<=2**23:continue
  err=abs(value(z)-ref);assert err<=allow;(max_errors.__setitem__(op,max(max_errors[op],err)))
(W/'checks/model_jobs.txt').write_text(''.join(f'{x} {y}\n' for x,y in pairs))
(W/'checks/model_expected.txt').write_text(''.join(f'{o[1]} {o[2]}\n' for o in native))
fixtures=[(F(1,2),1,2,10,0),(5,36866,0,339775489,0),(3,1,2,10,0),(1,0,0,1,0),(1,1,0,1,0),
 (F(1,2)-F(1,1<<54),3,-4,20,0),(1,0,1,1,0),(1,1,1,2,0),(1,F(1,1<<1074),0,F(1,1<<1022),0),
 (2**22,2**33+1,2**33-1,2**44+3,0)]
rows=[tuple(rn(F(v)) for v in fixtures[i%len(fixtures)]) for i in range(768)]
rows[10]=(rn(1),1<<63,0,0,1<<63)
data=''.join(' '.join(f'{v:016x}' for v in r)+'\n' for r in rows).encode();(W/'checks/gram_inputs.txt').write_bytes(data)
out=run('gram',['bin/root_'+mode,'gram'],data);expect=[tuple(root_point(*r)[0]+root_point(*r)[1]) for r in rows]
assert [tuple(int(t,16) for t in s.split()) for s in out.decode().splitlines()]==expect
mut=[]
for r,z in zip(rows,expect):
 ar,cr,ci,jr,ji=map(value,r);lr,li,dr,di=map(value,z)
 exactL=(cr/ar,ci/ar);exactD=(jr-(cr*cr+ci*ci)/ar,ji)
 if (dr,di)!=exactD:mut.append(dict(kind='omit_gram_div_sub_error',input=[f'{v:016x}' for v in r],D=[str(dr),str(di)],exact=[str(v) for v in exactD]))
 if dr!=value(div(rn(339775489),r[0])):mut.append(dict(kind='replace_subtractive_by_reciprocal',input=[f'{v:016x}' for v in r],source=f'{z[2]:016x}',replacement=f'{div(rn(339775489),r[0]):016x}'))
 if ci and cr:
  wrong=cm((r[1],r[2]),(z[0],z[1]));right=cm((r[1],r[2]),conj((z[0],z[1])))
  if wrong!=right:mut.append(dict(kind='wrong_conjugation',right=[f'{v:016x}' for v in right],wrong=[f'{v:016x}' for v in wrong]))
assert all(any(m['kind']==k for m in mut) for k in ['omit_gram_div_sub_error','replace_subtractive_by_reciprocal','wrong_conjugation'])
x,y=rn(1<<44),rn(F(1,1024));err=abs(value(add(x,y))-value(x)-value(y));assert err>F(1,1<<20)
mut.append(dict(kind='illegal_ZERO_bound_above_domain',x=f'{x:016x}',y=f'{y:016x}',exponent=(x>>52)&2047,error=str(err),rejected_bound='1/1048576'))
def sparse(items):
 p=[0]*1536
 for k,v in items:p[k]=v
 return p
polys=[
 [sparse([(0,1)]),sparse([(1,1)]),sparse([(2,2047)]),sparse([(3,-2047)])],
 [[(i%3)-1 for i in range(1536)],[((i*7+1)%3)-1 for i in range(1536)],[(i*37%4095)-2047 for i in range(1536)],[(i*97%4095)-2047 for i in range(1536)]]]
tab=tables(W);polymatches=[]
for k,p in enumerate(polys):
 data=('\n'.join(' '.join(map(str,v)) for v in p)+'\n').encode();(W/'checks'/f'polys_{k}.txt').write_bytes(data)
 output=run('polys_'+str(k),['bin/root_'+mode,'polys'],data)
 (W/'checks'/f'polys_{k}_{mode}.txt').write_bytes(output)
 model=gram_root(p,tab);got=[tuple(int(t,16) for t in s.split()) for s in output.decode().splitlines()]
 assert got==list(zip(*model));polymatches.append(dict(index=k,words=9*1536,output_sha256=sha(W/'checks'/f'polys_{k}_{mode}.txt')))
out=dict(status='PASS_FINITE_BINDING_CONTROLS',scalar_pairs=len(pairs),root_frequency_slots=768,full_degree_polynomial_cases=len(polys),
 polynomial_matches=polymatches,all_raw_bits_equal=True,input_arrays_unchanged_and_output_canaries=True,noop_pass=True,
 maximum_observed_errors={k:str(v) for k,v in max_errors.items()},mutations=mut[:40]+[mut[-1]],
 ntt_map_output_sha256=sha(W/'checks'/('keygen_map_'+mode+'.txt')),
 note='All inputs public synthetic. No KeyGen/private loader/Sign. Polynomial controls do not claim NTRU or emitted membership. Universal proof is separate.')
(W/'artifacts'/('controls_'+mode+'.json')).write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='mutations'},indent=2))
