import json,shutil
from pathlib import Path
from backend import of,neg,div,mul
from root_model import fft,tables
from post_model import cmvec
from scheduler_model import run,wide
from codec_model import encode,decode
from replaylib import sha
W=Path.cwd();assert shutil.disk_usage(W).free>2*1024**3;D=W/'artifacts/fixtures';D.mkdir(exist_ok=True);C=W/'artifacts/models';C.mkdir(exist_ok=True);N=1536
hm=[(i*7+13)%18433 for i in range(N)];t=fft([of(x) for x in hm],tables(W));b01=[of(-1)]*768+[0]*768;b11=[of(-128)]*768+[0]*768;ni=div(of(1),of(18433));t1=[mul(x,neg(ni)) for x in cmvec(t,b01)];t0=[mul(x,ni) for x in cmvec(t,b11)];targets=t0+t1
(W/'artifacts/target_words.json').write_text(json.dumps(dict(status='PASS_INDEPENDENT_LITERAL_TARGET_PREFLIGHT',hm=hm,targets=targets,source_reads='initial target fill plus original1886-1892; stale scratch not used',scope='public local basis, not emitted membership'),separators=(',',':'))+'\n')
def s(kind=0,fault=0,T=3072,counter=0):return dict(kind=kind,fault=fault,T=T,counter=counter)
configs=[('first_accept',[s(4)],4096),('last_accept',[s(1,T=3072+i) for i in range(15)]+[s(6,T=3091)],4096),('sixteen_reject',[s(1,T=3072+i) for i in range(16)],4096),('bad_then_accept',[s(3),s(4)],4096),('bad_and_accept',[s(2)],4096),('bad_then_zero',[s(3)]+[s(1)]*15,4096),('strict_equal_then_accept',[s(5),s(0)],4096),('fault_after_root',[s(0,fault=1)],4096),('codec_capacity_failure',[s(4)],64),('repeated_state56_reset',[s(1,counter=2**64-64),s(4,counter=2**64-64)],4096),('M0_capacity_witness',[s(6)],4096)]
rows=[]
for label,spec,cap in configs:
 outputs=[]
 for checked in [0,1]:
  name=label+('_checked' if checked else '_source');inp=f'{checked} {cap} {len(spec)}\n'+''.join(f'{x["kind"]} {x["fault"]} {x["T"]} {x["counter"]}\n' for x in spec);expected,model=run(spec,cap,checked,targets)
  p=D/(name+'.input');q=D/(name+'.expected');m=C/(name+'.json');p.write_text(inp);q.write_text(expected);m.write_text(json.dumps(model,indent=2)+'\n')
  rows.append(dict(name=name,input=p.relative_to(W).as_posix(),input_sha256=sha(p),expected=q.relative_to(W).as_posix(),expected_sha256=sha(q),model=m.relative_to(W).as_posix(),model_sha256=sha(m),scope='PUBLIC_SCRIPTED_SCHEDULER/ROOT_STUBS; no Emitted membership. Fault and cap64 are extended control paths.',preflight=True));outputs.append(model)
 if not outputs[0]['WholeRegionBad']:assert outputs[0]['public_result']==outputs[1]['public_result']
 else:assert outputs[1]['status']=='PRECAST_EXIT'
for kind in [0,4,6]:
 _,b=wide(kind);body=encode(b);assert decode(body)==(b,len(body))
(W/'artifacts/fixtures.json').write_text(json.dumps(dict(status='PASS_SOURCE_SCHEDULER_MODELS_AND_PREFLIGHT',cases=rows,count=len(rows),actual_do_sign_executed=False,real_seeded_PRNG_executed=False),indent=2)+'\n');print('PASS_RETRY_FIXTURES',len(rows))
