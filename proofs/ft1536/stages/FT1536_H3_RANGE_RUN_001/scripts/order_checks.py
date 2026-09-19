import hashlib,json,os,signal,subprocess,sys,time,shlex
from pathlib import Path
from fractions import Fraction as F
import order_model as M
from dyadic import rn,value,sqrt_rn
W=Path.cwd();mode=sys.argv[1];assert mode in ['normal','san'];L=W/'checks/order_logs'/mode;L.mkdir(parents=True,exist_ok=True);records=[]
def run(tag,cmd,limit=45):
 t=time.monotonic();p=subprocess.Popen(cmd,stdout=subprocess.PIPE,stderr=subprocess.PIPE,start_new_session=True);timed=False
 try:o,e=p.communicate(timeout=limit)
 except subprocess.TimeoutExpired:timed=True;os.killpg(p.pid,signal.SIGKILL);o,e=p.communicate()
 so=L/(tag+'.stdout');se=L/(tag+'.stderr');so.write_bytes(o);se.write_bytes(e)
 records.append(dict(argv=cmd,cwd=str(W),exit_code=p.returncode,timeout=timed,limit=limit,elapsed=time.monotonic()-t,stdout=str(so.relative_to(W)),stderr=str(se.relative_to(W)),stdout_sha256=hashlib.sha256(o).hexdigest(),stderr_sha256=hashlib.sha256(e).hexdigest()))
 (W/f'artifacts/order_{mode}_receipts.json').write_text(json.dumps(records,indent=2)+'\n')
 assert not timed and p.returncode==0,(tag,o.decode(),e.decode())
 return o.decode()
flags=shlex.split(next(x for x in (W/'source/Makefile').read_text().splitlines() if x.startswith('CFLAGS = ')).split('=',1)[1]);exe='bin/order_'+mode
san=['-O1','-g','-fsanitize=address,undefined','-fno-sanitize-recover=all','-fno-omit-frame-pointer','-no-pie'] if mode=='san' else []
run('compile',['/usr/bin/gcc','-std=c99']+flags+san+['-ffunction-sections','-fdata-sections','-Isource','checks/order.c','source/fpr-emulated.c','source/falcon-fft.c','source/frng.c','source/shake.c','-Wl,--gc-sections','-lm','-o',exe],60)
results=[]
def data(name):
 tree=[rn(F(i%7-3,8)) for i in range(18432)]
 if name=='minusL':tree=list(map(M.neg,tree))
 size,off=M.normalize_layout();assert size==18432 and len(off)==1536 and len(set(off))==1536
 for i,o in enumerate(off):tree[o]=rn(F(768)/value(sqrt_rn(value(0x4114444d1a037d50 if i%2 else 0x4090000053700377))))
 return tree,[rn(F(i%11-5,8)) for i in range(1536)],[rn(F(i%13-6,4)) for i in range(1536)],off
for name in ['baseline','minusL','fault','terminal_negzero','noop']:
 text=run(name,[exe,name]);rows=text.splitlines();calls=[];leaves={};outputs={}
 for line in rows:
  a=line.split()
  if a[0]=='call':calls.append(dict(index=int(a[1]),mu=int(a[2],16),sigma=int(a[3],16),result=int(a[4]),active=int(a[5])))
  elif a[0]=='leaf':leaves[int(a[1])]=int(a[2],16)
  elif a[0] in ['out0','out1']:outputs[a[0]]=[int(x,16) for x in a[1:]]
  elif a[0]=='normalize':assert a[1:]==['18432','1536']
  elif a[0]=='count':assert a[1]=='3072'
  else:raise AssertionError(line)
 vm=M.Machine(W/'source/fpr-emulated.h',name)
 if name=='terminal_negzero':out=vm.inner([rn(2)],0,[0],[1<<63],'terminal')
 else:
  tree,t0,t1,offs=data(name);assert leaves=={o:tree[o] for o in offs};out=vm.top(tree,t0,t1)
 expected=[{k:v for k,v in r.items() if k not in ['path','slot']} for r in vm.calls]
 assert expected==calls,(name,next((i for i,(x,y) in enumerate(zip(expected,calls)) if x!=y),None))
 assert out[0]==outputs['out0'] and out[1]==outputs['out1'],name
 if mode=='normal':(W/f'artifacts/order_{name}_trace.json').write_text(json.dumps(vm.calls,indent=2)+'\n')
 results.append(dict(name=name,scalar_calls=len(calls),full_requests_returns_outputs_equal=True,active_calls=sum(c['active'] for c in calls),
   maximum_absolute_center=str(max(abs(value(c['mu'])) for c in calls)),
   negative_zero_centers=sum(c['mu']==1<<63 for c in calls),trace_sha256=hashlib.sha256(text.encode()).hexdigest(),
   domain='SYNTHETIC_TREE_NOT_EMITTED_KEY'))
assert results[-1]['trace_sha256']==results[0]['trace_sha256']
mutations=[]
if mode=='normal':
 # Real changes to equations in independent model, checked against source calls.
 for change in ['terminal_scale','correction_sign']:
  tree,t0,t1,_=data('baseline');vm=M.Machine(W/'source/fpr-emulated.h','baseline');oldIW=M.IW
  if change=='terminal_scale':M.IW=rn(1)
  else:
   original=vm.polymul;vm.polymul=lambda a,b:list(map(M.neg,original(a,b)))
  vm.top(tree,t0,t1);M.IW=oldIW
  want=json.loads((W/'artifacts/order_baseline_trace.json').read_text())
  changed=[i for i,(x,y) in enumerate(zip(vm.calls,want)) if x!=y];assert changed
  mutations.append(dict(change=change,first_different_call=changed[0],different_calls=len(changed),detected=True))
 (W/'artifacts/order_mutations.json').write_text(json.dumps(mutations,indent=2)+'\n')
(W/f'artifacts/order_{mode}.json').write_text(json.dumps(results,indent=2)+'\n')
if mode=='san':assert results==json.loads((W/'artifacts/order_normal.json').read_text())
print(json.dumps(dict(mode=mode,scenarios=results,mutations=mutations),indent=2))
