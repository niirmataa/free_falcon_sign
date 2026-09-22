import json,hashlib
from pathlib import Path
from fractions import Fraction as Q
from post_model import suffix,ifft,rint_word,Qnorm
from codec_model import encode,decode,frame,codebits
from dyadic import value
from replaylib import sha
W=Path.cwd();D=W/'artifacts/mutations';D.mkdir(exist_ok=True);rows=[]
def load(n):return json.loads((W/'artifacts/models'/(n+'.json')).read_text())
def digest(x):return hashlib.sha256(json.dumps(x,separators=(',',':')).encode()).hexdigest()
def record(name,baseline,changed,expected_equal=False,scope='SYNTHETIC_LOCAL_ONLY'):
 baseline=json.loads(json.dumps(baseline));changed=json.loads(json.dumps(changed))
 same=baseline==changed;assert same==expected_equal,name
 p=D/(name+'.json');p.write_text(json.dumps(dict(name=name,baseline=baseline,changed=changed,matched=same,expected_equal=expected_equal,scope=scope),separators=(',',':'))+'\n')
 rows.append(dict(name=name,outcome='NOOP_PASS' if expected_equal else 'MUTATION_DETECTED',baseline_sha256=digest(baseline),mutated_sha256=digest(changed),evidence_sha256=sha(p),scope=scope))
a=[int(x,16) for x in (W/'artifacts/fixtures/suffix_dense.input').read_text().split()];b,x,y=a[:6144],a[6144:7680],a[7680:];base=load('suffix_dense')
record('noop',base,suffix(W,b,x,y),True)
for name in ['binary_sign','stale_copy','wrong_scale']:
 z=suffix(W,b,x,y,name);record(name,[base['w1'],base['w2']],[z['w1'],z['w2']])
a=[int(x,16) for x in (W/'artifacts/fixtures/ifft_dense.input').read_text().split()]
for name in ['wrong_order','wrong_conjugation','wrong_scale']:
 z,s=ifft(W,a,name);record('ifft_'+name,load('ifft_dense')['output'],z)
base=load('rint_boundaries');away=[]
for w,n,s in base:
 v=value(w);a=abs(v);q,r=divmod(a.numerator,a.denominator);away.append([w,(-1 if v<0 else 1)*(q+int(2*r>=a.denominator)),s])
record('ties_away',base,away)
wrap=load('suffix_extended_wrap');assert not wrap['Safe16'] and Qnorm(wrap['s1'],wrap['s2'])<2093922385
record('omit_narrowing',[wrap['s1'],wrap['s2']],[wrap['w1'],wrap['w2']])
record('future_norm_implies_precast',True,wrap['Safe16'],scope='EXTENDED_LOCAL_SUFFIX_COUNTERMODEL_NOT_EMITTED: actual source stores have Q<B but not Safe16')
v=load('codec_M0_witness')['s2'];baseline=encode(v)
record('j7',baseline.hex(),encode(v,j=7).hex());record('omit_terminator',baseline.hex(),encode(v,terminator=False).hex())
v=[0]*1536;v[0]=256;assert len(codebits(v))%8!=0
baseline=encode(v);bad=encode(v,pad=1);assert decode(baseline)==(v,len(baseline)) and decode(bad) is None;record('nonzero_padding',baseline.hex(),bad.hex())
r,buffer=frame(v,len(baseline));assert r==0 and buffer[0]==0xa5
record('early_header_on_failure',buffer.hex(),(b'\xaa'+buffer[1:]).hex())
stops=[]
for w in [1073<<52,2047<<52,(2047<<52)|1,0xffffffffffffffff]:
 try:rint_word(w)
 except ValueError as e:stops.append(dict(word=f'{w:016x}',outcome=str(e),native_called=False))
 else:raise AssertionError('domain preflight failed')
out=dict(status='PASS_EXECUTED_MEANINGFUL_MUTATIONS_AND_NOOP',mutations=rows,domain_stops=stops,required_domain_counterexample=False,extended_local_wrap=dict(w1_0=wrap['w1'][0],w2_0=wrap['w2'][0],s1_0=wrap['s1'][0],s2_0=wrap['s2'][0],Q=Qnorm(wrap['s1'],wrap['s2']),Safe16=False,P_key=False,emitted=False,source_sampler_history=False))
(W/'artifacts/mutations.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],mutations=len(rows),domain_stops=len(stops),extended_local_wrap=out['extended_local_wrap']),indent=2))
