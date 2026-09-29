import json,re,shlex,subprocess,sys,time
from fractions import Fraction as F
from pathlib import Path
from backend import mul,div,conj,cs
from node_model import INV3,split_point,node_point,slice_words
from root_model import tables
from dyadic import value,rn
from fixtures import make,scalar_pairs
from replaylib import sha
W=Path.cwd();mode=sys.argv[1];assert mode in ['normal','san'];log=W/'checks/logs'/mode;log.mkdir(parents=True,exist_ok=True);commands=[]
def run(tag,argv,data=None):
 t=time.monotonic();p=subprocess.run(argv,input=data,capture_output=True,timeout=120)
 so=log/(tag+'.stdout');se=log/(tag+'.stderr');so.write_bytes(p.stdout);se.write_bytes(p.stderr)
 commands.append(dict(argv=argv,cwd=str(W),wall_limit=120,exit_code=p.returncode,elapsed=time.monotonic()-t,stdout=str(so.relative_to(W)),stderr=str(se.relative_to(W)),stdout_sha256=sha(so),stderr_sha256=sha(se)))
 (log/'commands.json').write_text(json.dumps(commands,indent=2)+'\n');assert p.returncode==0,(tag,p.stderr.decode());return p.stdout
flags=shlex.split(re.search(r'^CFLAGS = (.*)$',(W/'source/Makefile').read_text(),re.M).group(1));flags=[s.replace('\\"','"') for s in flags]
flags+=['-std=c99','-ffunction-sections','-fdata-sections','-Isource']
if mode=='san':flags+=['-fsanitize=address,undefined','-fno-omit-frame-pointer','-g']
exe='bin/node_'+mode;run('compile',['/usr/bin/gcc']+flags+['checks/node.c','source/falcon-fft.c','source/fpr-emulated.c','-Wl,--gc-sections','-lm','-o',exe])
word=int(run('inverse',[exe,'inverse']).strip(),16);assert word==INV3==0x3fd5555555555555
pairs=scalar_pairs();data=''.join(f'{x:016x} {y:016x}\n' for x,y in pairs).encode();(W/'checks/scalar_inputs.txt').write_bytes(data)
native=[tuple(int(t,16) for t in l.split()) for l in run('scalar',[exe,'scalar'],data).decode().splitlines()]
assert native==[(mul(x,y),div(x,y)) for x,y in pairs]
u=F(1,2**48);eta=F(1,2**900)
for (x,y),(m,d) in zip(pairs,native):
 a,b=value(x),value(y);assert F(1,16)<=b<=2**35 and abs(a)<=2**100
 assert abs(value(d)-a/b)<=u*abs(a/b)+eta and abs(value(m)-a*b)<=u*abs(a*b)+eta
(W/'checks/model_jobs.txt').write_text(''.join(f'{x} {y}\n' for x,y in pairs));(W/'checks/model_expected.txt').write_text(''.join(f'{m} {d}\n' for m,d in native))
tab=tables(W);mutations={};summaries=[];domain_stops=[]
def changed(kind,actual,mutant,branch,j):
 if actual!=mutant and kind not in mutations:mutations[kind]=dict(branch=branch,slot=j,actual=str(actual),mutant=str(mutant))
for branch in [0,1]:
 v=make(branch);model=slice_words(v,tab) # Preflight both divisors, before any C node call.
 payload='\n'.join(f'{x:016x}' for x in v)+'\n';(W/'checks'/f'branch{branch}_input.txt').write_text(payload)
 raw=run('branch'+str(branch),[exe,'branch'+str(branch)],payload.encode());(W/'checks'/f'branch{branch}_{mode}.txt').write_bytes(raw)
 got=[tuple(int(t,16) for t in l.split()) for l in raw.decode().splitlines()];assert got==list(zip(*model))
 assert slice_words([x^0 for x in v],tab)==model
 counts=dict(nonzero_t0_imag=0,nonzero_d11_imag=0,nonzero_d22_imag=0,negative_zero_words=0)
 for j in range(256):
  tri=[(v[3*j+k],v[768+3*j+k]) for k in range(3)];t=split_point(tri,j,tab);out,tr=node_point(t,trace=True)
  for key,k in [('nonzero_t0_imag',0),('nonzero_d11_imag',3),('nonzero_d22_imag',4)]:counts[key]+=value(out[k][1])!=0
  counts['negative_zero_words']+=sum(z==1<<63 for pair in out for z in pair)
  h=value(out[0][0]);d1=value(out[3][0]);assert h>0 and d1>0
  if h>2**23 or d1>2**23:
   mutations.setdefault('old_div_domain',dict(branch=branch,slot=j,actual_denominators=[str(h),str(d1)],old_upper='8388608',new_upper=str(2**35)))
  variants=[('omit_input_imag',[(a,0) for a,b in tri]),('wrong_root_slot',[tri[0],tri[2],tri[1]])]
  for kind,bad in variants:
   try:badout=node_point(split_point(bad,j,tab));changed(kind,out,badout,branch,j)
   except ValueError as e:mutations.setdefault(kind,dict(branch=branch,slot=j,stop=str(e)))
  badt=[t[0],conj(t[1]),conj(t[2])]
  try:changed('wrong_Adj',out,node_point(badt),branch,j)
  except ValueError as e:mutations.setdefault('wrong_Adj',dict(branch=branch,slot=j,stop=str(e)))
  changed('ideal_one_third',t,split_point(tri,j,tab,ideal_third=True),branch,j)
  # A proof projection after split: L and real pivots ignore ONLY diagonal imag.
  projected=node_point([(t[0][0],0),t[1],t[2]])
  assert projected[5:]==out[5:] and projected[3][0]==out[3][0] and projected[4][0]==out[4][0]
  wrongtmp=(mul(tr['norm'][0],out[3][1]),mul(tr['norm'][1],out[3][1]))
  changed('imag_slot_in_mul_autoadj',out[4],cs(tr['q2'],wrongtmp),branch,j)
  r=[value(z[0]) for z in tri];e1=sum(r);e2=r[0]*r[1]+r[0]*r[2]+r[1]*r[2]
  changed('replace_subtractive_pivots',[out[3][0],out[4][0]],[rn(e2/e1),rn(3*r[0]*r[1]*r[2]/e2)],branch,j)
  bR,bI=map(value,out[1]);exact=h-(bR*bR+bI*bI)/h
  changed('omit_rounding_term',str(value(out[3][0])),str(exact),branch,j)
 summaries.append(dict(branch=branch,physical_frequencies=256,raw_words=512*8,output_sha256=sha(W/'checks'/f'branch{branch}_{mode}.txt'),**counts))
for label,tri in [('zero_denominator',[(0,0)]*3),('rank_one_spectrum',[(rn(1),0),(0,0),(0,0)])]:
 try:node_point(split_point(tri,0,tab))
 except ValueError as e:domain_stops.append(dict(case=label,status=str(e),C_not_called=True))
assert domain_stops and domain_stops[0]['status']=='STOP_BEFORE_FIRST_DIVISOR'
required=['omit_input_imag','wrong_root_slot','wrong_Adj','ideal_one_third','imag_slot_in_mul_autoadj','replace_subtractive_pivots','old_div_domain','omit_rounding_term']
assert set(required)<=set(mutations)
out=dict(status='PASS_FINITE_SOURCE_BINDING_CONTROLS',scalar_pairs=len(pairs),inverse3_raw=f'{INV3:016x}',branches=summaries,mutations=mutations,
 preflight_stops=domain_stops,noop_pass=True,real_slot_noninterference_checked=True,source_alias_and_scratch_reuse=True,input_children_unchanged=True,canaries_pass=True,
 scope='Public synthetic numerical-envelope controls, not P_key/emitted witnesses. Universal proof separate; no KeyGen/loader/Sign call.')
(W/'artifacts'/('controls_'+mode+'.json')).write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='mutations'},indent=2))
