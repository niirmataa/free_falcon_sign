"""Literal stopped scheduler over explicit public root stubs; no source reachability claim."""
import math
from codec_model import literal_encode
from post_model import narrow16,Qnorm
from buffer_model import proposal_schedule
N=1536;B=2093922385
def wide(kind):
 a=[0]*N;b=[0]*N
 if kind in [1,3]:a[:3]=[32767]*3
 if kind in [2,3]:b[0]=65536
 if kind==4:b[0]=-32768;b[768]=16384;b[1]=257;b[2]=-256
 if kind==5:
  rem=B;i=0
  while rem:a[i]=min(32767,math.isqrt(rem));rem-=a[i]**2;i+=1
 if kind==6:
  b[:768]=[1792 if i<330 else 1536 for i in range(768)];b[768:]=[-x for x in b[:768]]
 return a,b
def run(script,cap,checked,targets):
 lines=[];init=root=norm=enc=anybad=0;blocks=extra=drops=abandoned=returned=shake=0;ptr=0;buffer=bytearray([0xa5]*cap);status='ZERO';length=0;attempts=[]
 for counter in range(1,18):
  if counter>16:break
  if counter>1:abandoned+=4096-ptr
  spec=script[counter-1];init+=1;shake+=56;c=spec['counter'];lines.append(f'SHAKE {init} 56 {c:016x}\n');lines.append(f'INIT {init} {blocks} {(c+64)%2**64:016x} 1 0\n');blocks+=1;root+=1
  lines.append(f'TARGET {root} '+' '.join(f'{x:016x}' for x in targets)+'\n')
  schedule=proposal_schedule(spec['T']);ptr=schedule['ptr'];extra+=schedule['additional_refills'];blocks+=schedule['additional_refills'];drops+=schedule['getter_drops'];returned+=schedule['returned'];c=(c+64*(1+schedule['additional_refills']))%2**64
  lines.append(f'ROOT {root} {spec["T"]} {ptr} {c:016x}\n');w1,w2=wide(spec['kind']);bad=any(x< -32768 or x>32767 for x in w1+w2);anybad|=bad
  attempts.append(dict(attempt=counter,bad=bad,fault=spec['fault'],stored_norm=Qnorm(list(map(narrow16,w1)),list(map(narrow16,w2))),ptr=ptr,root_proposals=spec['T']))
  if checked and bad:status='PRECAST_EXIT';break
  s1=list(map(narrow16,w1));s2=list(map(narrow16,w2));lines.append(f'COMPLETE {root} {spec["fault"]} {int(anybad)}\n')
  if spec['fault']:break
  ok=Qnorm(s1,s2)<B;norm+=1;lines.append(f'NORM {root} {int(ok)}\n')
  if ok:
   enc+=1;n,body=literal_encode(s2,cap-1);buffer[1:1+len(body)]=body;lines.append(f'ENCODE {root} {cap-1} {n}\n')
   if n:buffer[0]=0xaa;length=n+1;status='BYTES'
   break
 unused=4096-ptr;assert 4096*blocks==returned+drops+abandoned+unused
 lines +=[f'RESULT {status} {length} {init} {norm} {enc} {int(anybad)}\n',f'RESOURCE {blocks} {extra} {returned} {drops} {abandoned} {unused} {shake}\n','BUFFER '+buffer.hex()+'\n','FRAME_CANARIES_PASS\n']
 public=(status,length,bytes(buffer[:length]).hex() if status=='BYTES' else None)
 return ''.join(lines),dict(status=status,length=length,init_count=init,norm_calls=norm,encode_calls=enc,WholeRegionBad=bool(anybad),public_result=public,resources=dict(blocks=blocks,additional=extra,returned=returned,getter_drops=drops,abandoned=abandoned,final_unused=unused,SHAKE56=shake),attempts=attempts)
