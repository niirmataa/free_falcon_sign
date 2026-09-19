import json,re,shlex,subprocess,sys,time
from fractions import Fraction as F
from pathlib import Path
from backend import add,sub,mul,div,conj,ca,cm,neg
from half_model import half
from node2_model import split_pair,dim2,point,slice_words
from node_model import slice_words as node3_slice
from root_model import tables,root_point
from dyadic import value,rn
from fixtures import root_words,half_words
from replaylib import sha
W=Path.cwd();mode=sys.argv[1];assert mode in ['normal','san'];log=W/'checks/logs'/mode;log.mkdir(parents=True,exist_ok=True);commands=[]
def run(tag,argv,data=None):
 t=time.monotonic();p=subprocess.run(argv,input=data,capture_output=True,timeout=120)
 so=log/(tag+'.stdout');se=log/(tag+'.stderr');so.write_bytes(p.stdout);se.write_bytes(p.stderr)
 commands.append(dict(argv=argv,cwd=str(W),wall_limit=120,exit_code=p.returncode,elapsed=time.monotonic()-t,stdout=str(so.relative_to(W)),stderr=str(se.relative_to(W)),stdout_sha256=sha(so),stderr_sha256=sha(se)))
 (log/'commands.json').write_text(json.dumps(commands,indent=2)+'\n');assert p.returncode==0,(tag,p.stderr.decode());return p.stdout
flags=shlex.split(re.search(r'^CFLAGS = (.*)$',(W/'source/Makefile').read_text(),re.M).group(1));flags=[s.replace('\\"','"') for s in flags]+['-std=c99','-ffunction-sections','-fdata-sections','-Isource']
if mode=='san':flags+=['-fsanitize=address,undefined','-fno-omit-frame-pointer','-g']
exe='bin/binary_'+mode;run('compile',['/usr/bin/gcc']+flags+['checks/binary.c','source/falcon-fft.c','source/fpr-emulated.c','-Wl,--gc-sections','-lm','-o',exe])
assert run('frame',[exe,'frame'])==b'DEFINED_PREFIX_FRAME_PASS 3 2304\n'
words=half_words();data=''.join(f'{x:016x}\n' for x in words).encode();(W/'checks/half_inputs.txt').write_bytes(data)
raw=run('half',[exe,'half'],data);got=[tuple(int(z,16) for z in l.split()) for l in raw.decode().splitlines()]
assert got==[(half(x),sub(half(x),rn(0))) for x in words]
halfmut=[];postmut=[]
for x,(h,p) in zip(words,got):
 assert abs(value(h)-value(x)/2)<=F(1,2**1023)
 ideal=rn(value(x)/2,zero_sign=x>>63)
 if ideal!=h:halfmut.append(dict(input=f'{x:016x}',source=f'{h:016x}',ideal=f'{ideal:016x}'))
 if h!=p:postmut.append(dict(half=f'{h:016x}',sub_plus_zero=f'{p:016x}'))
assert halfmut and postmut
(W/'checks/half_jobs.txt').write_text(''.join(str(x)+'\n' for x in words));(W/'checks/half_expected.txt').write_text(''.join(str(h)+'\n' for h,p in got))
patterns=[(3,1,5,10),(F(1,2),1,2,16),(2**22+3,2**32+1,2**32-1,2**44),(7,2**20+1,2**21+3,2**41)]
rootrows=[tuple(rn(F(z)) for z in patterns[i%len(patterns)]) for i in range(768)]
payload=''.join(' '.join(f'{x:016x}' for x in r)+'\n' for r in rootrows).encode();(W/'checks/root_imag_inputs.txt').write_bytes(payload)
rootout=run('root_imag',[exe,'root'],payload);rootgot=[tuple(int(z,16) for z in l.split()) for l in rootout.decode().splitlines()]
U=F(1,2**48);maxroot=F(0)
for r,z in zip(rootrows,rootgot):
 l,d=root_point(r[0],r[1],r[2],r[3]);assert z==l+d
 a,cr,ci,j=map(value,r);assert cr*cr+ci*ci<=a*j
 err=abs(value(z[3]));assert err<=8*U*j and err<1;maxroot=max(maxroot,err)
tab=tables(W);summaries=[];mutations={}
def changed(kind,actual,bad,b,k,f):
 if actual!=bad and kind not in mutations:mutations[kind]=dict(branch=b,diagonal=k,slot=f,actual=str(actual),mutant=str(bad))
for b in [0,1]:
 rootv=root_words(b);n3=node3_slice(rootv,tab);text=''.join(f'{x:016x}\n' for x in rootv);(W/'checks'/f'root{b}_input.txt').write_text(text)
 for k,idx in enumerate([0,3,4]):
  v=n3[idx];model=slice_words(v,tab) # preflight first divisor only, no future pivot premise
  (W/'checks'/f'parent_{b}_{k}.txt').write_text(''.join(f'{x:016x}\n' for x in v))
  raw=run(f'node_{b}_{k}',[exe,'pipeline',str(k)],text.encode());(W/'checks'/f'node_{b}_{k}_{mode}.txt').write_bytes(raw)
  assert [tuple(int(z,16) for z in l.split()) for l in raw.decode().splitlines()]==list(zip(*model))
  assert slice_words([x^0 for x in v],tab)==model
  nonzero_im=0
  for f in range(128):
   a=(v[2*f],v[2*f+256]);bb=(v[2*f+1],v[2*f+1+256]);s0,s1=split_pair(a,bb,f,tab);out=dim2(s0,conj(s1))
   h=value(out[0][0]);assert value(out[3][0])>0
   nonzero_im+=value(out[3][1])!=0
   changed('omit_input_imag',out,point((a[0],0),(bb[0],0),f,tab),b,k,f)
   changed('wrong_Adj',out,dim2(s0,s1),b,k,f)
   changed('wrong_root_phase',out,point(a,bb,(f+1)%128,tab),b,k,f)
   ra,ta=value(a[0]),value(a[1]);rb,tb=value(bb[0]),value(bb[1]);margin=ra*rb-(ta-tb)**2/4
   changed('omit_imag_difference_squared',str(margin),str(ra*rb),b,k,f)
   changed('ideal_harmonic_pivot',out[3][0],rn(2*ra*rb/(ra+rb)),b,k,f)
   cr,ci=map(value,out[1]);exact=h-(cr*cr+ci*ci)/h
   changed('omit_rounding',str(value(out[3][0])),str(exact),b,k,f)
   tau=value(out[0][1])
   if tau:
    full_re=(cr*h+ci*tau)/(h*h+tau*tau);full_im=(ci*h-cr*tau)/(h*h+tau*tau)
    changed('complex_instead_real_div',[str(value(z)) for z in out[2]],[str(full_re),str(full_im)],b,k,f)
   if h>2**23:mutations.setdefault('old_ROOT_div_domain',dict(branch=b,diagonal=k,slot=f,actual_h=str(h),old_upper='8388608',used_upper=str(2**35)))
  summaries.append(dict(branch=b,diagonal=k,positions=128,raw_words=1024,nonzero_d11_imag=nonzero_im,output_sha256=sha(W/'checks'/f'node_{b}_{k}_{mode}.txt')))
# Public countermodel of ONLY the old independent Re/Im box. h=9 is a legal divisor.
box=[rn(9)]*256+[rn(34 if i%2==0 else -34) for i in range(256)];boxmodel=slice_words(box,tab)
payload=''.join(f'{x:016x}\n' for x in box).encode();(W/'checks/coarse_box_input.txt').write_bytes(payload)
boxraw=run('coarse_box',[exe,'direct'],payload);(W/'checks'/f'coarse_box_{mode}.txt').write_bytes(boxraw)
assert [tuple(int(z,16) for z in l.split()) for l in boxraw.decode().splitlines()]==list(zip(*boxmodel))
assert all(value(x)<0 for x in boxmodel[3][:128])
stops=[]
try:slice_words([0]*512,tab)
except ValueError as e:stops.append(dict(case='zero_first_divisor',status=str(e),C_not_called=True))
assert stops
required={'omit_input_imag','wrong_Adj','wrong_root_phase','omit_imag_difference_squared','ideal_harmonic_pivot','omit_rounding','complex_instead_real_div','old_ROOT_div_domain'}
assert required<=set(mutations)
out=dict(status='PASS_FINITE_BINDING_CONTROLS',level=dict(split_logn=9,ldl_logn=8,full=0),cases=summaries,half_words=len(words),
 half_mutants=halfmut[:10],post_half_raw_preservation_counterexamples=postmut[:10],maximum_observed_root_imag=str(maxroot),root_imag_controls=768,
 mutations=mutations,coarse_box=dict(classification='COUNTERMODEL_COARSE_NODE3_BOX_ONLY_NOT_P_KEY_OR_EMITTED',exact_margin='-1075',exact_pivot='-1075/9',
  source_first_pivot=f'{boxmodel[3][0]:016x}',source_first_pivot_value=str(value(boxmodel[3][0])),legal_first_divisor='9'),
 preflight_stops=stops,noop_pass=True,frame_controls=3,frame_and_canaries=True,
 scope='Public synthetic inputs and local helpers only. No KeyGen/private loader/Sign. Universal proof separate from finite controls.')
(W/'artifacts'/('controls_'+mode+'.json')).write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k not in ['mutations','half_mutants','post_half_raw_preservation_counterexamples']},indent=2))
