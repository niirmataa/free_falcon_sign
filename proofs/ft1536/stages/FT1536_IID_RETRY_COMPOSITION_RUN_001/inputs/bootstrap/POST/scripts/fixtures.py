"""Public synthetic local inputs, never key generation or emitted-key claims."""
import json,math
from pathlib import Path
from fractions import Fraction as Q
from dyadic import rn,value
from backend import of,neg
from post_model import rint_word,rint_oracle,narrow16,ifft,suffix,Qnorm
from root_model import fft,tables
from codec_model import encode,literal_encode,decode,codebits
from replaylib import sha
W=Path.cwd();D=W/'artifacts/fixtures';M=W/'artifacts/models';D.mkdir(exist_ok=True);M.mkdir(exist_ok=True);rows=[];tab=tables(W);N=1536
def save(name,kind,text,model,scope):
 p=D/(name+'.input');p.write_text(text);q=M/(name+'.json');q.write_text(json.dumps(model,separators=(',',':'))+'\n');rows.append(dict(name=name,kind=kind,input=p.relative_to(W).as_posix(),input_sha256=sha(p),model=q.relative_to(W).as_posix(),model_sha256=sha(q),scope=scope,preflight='all literal primitive operations checked BEFORE native execution'))
def words(a):return ' '.join(f'{x:016x}' for x in a)+'\n'
mantissas=[0,1,2,3,2**21-1,2**21,2**32-1,2**32,2**50-1,2**50,2**51-1,2**51,2**52-3,2**52-2,2**52-1]
raw={s<<63|e<<52|m for e in range(1073) for s in range(2) for m in mantissas}
for v in [Q(1,2),Q(3,2),Q(5,2),Q(65537,2),Q(65535,2),Q(131071,2),Q(131073,2),Q(585228161,128)]:
 for s in [1,-1]:
  w=rn(s*v);raw.update([w-1,w,w+1])
raw=sorted(raw);expected=[]
for x in raw:
 w=rint_word(x);assert w==rint_oracle(x) and abs(value(x)-w)<=Q(1,2);expected.append([x,w,narrow16(w)])
save('rint_boundaries','rint',words(raw),expected,'EXTENDED_ALL_EXPONENTS_0_TO_1072; not source-history witnesses')
freqs={
 'ifft_signed_zeros':[(1<<63) if i%2 else 0 for i in range(N)],
 'ifft_dense':[of((i*73+19)%2001-1000) for i in range(N)],
 'ifft_large_cancel':[of((1 if i%3 else -1)*44000000) for i in range(N)],
 'ifft_tiny':[([0,1,2**52-1,1<<63,(1<<63)|1,(1<<63)|(2**52-1)])[i%6] for i in range(N)]}
for name,a in freqs.items():
 assert all(value(a[i])**2+value(a[i+768])**2<=89531345**2 for i in range(768))
 out,events=ifft(W,a);save(name,'ifft',words(a),dict(output=out,events=events),'PUBLIC_LOCAL_IFFT_DOMAIN_ONLY')
def poly(c):return fft([of(x) for x in c],tab)
def constant(n):return [n]+[0]*(N-1)
base=poly(constant(3))+poly(constant(-1))+poly([19 if i==0 else (i%3-1 if i<32 else 0) for i in range(N)])+poly(constant(-7))
inputs=[('suffix_zero',base,[0]*N,[1<<63]*N),('suffix_dense',base,poly([i%11-5 for i in range(N)]),poly([i%7-3 for i in range(N)])),('suffix_extended_wrap',poly(constant(1))*2+[0]*(2*N),poly(constant(65536)),[0]*N)]
codec=[]
for name,b,x,y in inputs:
 model=suffix(W,b,x,y);assert all(abs(w)<2**23 for w in model['w1']+model['w2'])
 save(name,'suffix',words(b+x+y),model,'EXTENDED_LOCAL_SUFFIX; synthetic basis, NO P_key/Emitted/source-history membership')
 codec.append(('codec_'+name,model['s1'],model['s2']))
codec.append(('codec_zero',[0]*N,[0]*N));v=[1792 if i<330 else 1536 for i in range(768)];codec.append(('codec_M0_witness',[0]*N,v+[-x for x in v]))
for target in [2093922384,2093922385,2093922386]:
 a=[0]*N;left=target;i=0
 while left:a[i]=min(32767,math.isqrt(left));left-=a[i]**2;i+=1
 assert i<768 and Qnorm(a,[0]*N)==target;codec.append(('codec_norm_'+str(target),a,[0]*N))
for chunk,start in enumerate(range(-32768,32768,N)):
 vals=list(range(start,min(32768,start+N)));vals+=[0]*(N-len(vals));codec.append(('codec_all16_'+str(chunk).zfill(2),[0]*N,vals))
seen=set()
for name,a,b in codec:
 data=encode(b);assert literal_encode(b)==(len(data),data) and decode(data)==(b,len(data));seen.update(b)
 model=dict(s1=a,s2=b,bytes=data.hex(),length=len(data),bits=len(codebits(b)),norm=Qnorm(a,b),short=Qnorm(a,b)<2093922385)
 if model['short']:assert len(data)+1<=3160
 save(name,'codec_brief' if 'all16' in name else 'codec',' '.join(map(str,a+b))+'\n',model,'ALL_SIGNED16_ENCODER_DOMAIN; norm acceptance checked separately; no emitted membership')
assert seen==set(range(-32768,32768))
(W/'artifacts/fixtures.json').write_text(json.dumps(dict(status='PASS_DOMAIN_PREFLIGHT_AND_INDEPENDENT_MODELS',cases=rows,rint_cases=len(raw),signed16_values_covered=len(seen),source_keys_generated=0),indent=2)+'\n');print('PASS_PREFLIGHT',len(rows),'rint',len(raw),'codec_values',len(seen))
