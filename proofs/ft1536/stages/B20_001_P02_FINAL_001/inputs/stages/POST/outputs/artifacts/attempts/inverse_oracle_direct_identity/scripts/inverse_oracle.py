"""Independent direct 768-root inverse: no source butterfly algorithm."""
import json,sys
from pathlib import Path
sys.path.insert(0,str(Path.cwd()/'scripts'))
from sage.all import RealBallField,ComplexBallField,QQ
from dyadic import value
from replaylib import sha
W=Path.cwd();RB=RealBallField(256);CB=ComplexBallField(256);pi=RB.pi();cases=json.loads((W/'artifacts/fixtures.json').read_text())['cases'];out=[]
def rat(w):v=value(w);return QQ(v.numerator)/v.denominator
roots=[1+6*int(format(j,'08b')[::-1],2)+1536*k for j in range(256) for k in range(3)]
assert sorted(roots)==list(range(1,4608,6))
phase=[CB((2*pi*r/4608).cos(),-(2*pi*r/4608).sin()) for r in roots];s3=RB(3).sqrt()
def direct(words,source,name):
 accum=[CB(0) for _ in range(768)]
 for j in range(768):
  y=CB(rat(words[j]),rat(words[j+768]));power=CB(1)
  for k in range(768):accum[k]+=y*power;power*=phase[j]
 accum=[z/768 for z in accum];ideal=[z.real()-z.imag()/s3 for z in accum]+[2*z.imag()/s3 for z in accum]
 errors=[abs(RB(rat(w))-x) for w,x in zip(source,ideal)];assert all(e<RB(QQ(1)/128) for e in errors)
 record=dict(name=name,all_1536_coefficients_checked=True,direct_inverse_balls=[str(x) for x in ideal],error_balls=[str(e) for e in errors],allowed_error='1/128')
 p=W/'artifacts'/('oracle_'+name+'.json');p.write_text(json.dumps(record,indent=2)+'\n');out.append(dict(name=name,sha256=sha(p),max_error_ball=str(max(errors,key=lambda x:x.upper()))))
for c in cases:
 if c['kind'] not in ['ifft','suffix']:continue
 model=json.loads((W/c['model']).read_text())
 if c['kind']=='ifft':direct([int(x,16) for x in (W/c['input']).read_text().split()],model['output'],c['name'])
 else:
  for k in range(2):direct(model['post_frequency'][k],model['t'+str(k)],c['name']+'_'+str(k))
 print('PASS_DIRECT_INVERSE',c['name'],flush=True)
(W/'artifacts/inverse_oracle.json').write_text(json.dumps(dict(status='PASS_DIRECT_RBF256_INVERSE_ALL_COEFFICIENTS',root_order=roots,cases=out,finite_controls_not_uniform_proof=True),indent=2)+'\n')
