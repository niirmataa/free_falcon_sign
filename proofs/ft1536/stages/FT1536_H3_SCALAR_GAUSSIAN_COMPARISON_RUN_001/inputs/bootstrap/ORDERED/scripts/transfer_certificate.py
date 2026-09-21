import json,sys
from pathlib import Path
sys.path.insert(0,str(Path.cwd()/'scripts'))
from sage.all import QQ,PolynomialRing,RealBallField
from backend import div,of,add,sub,mul
from half_model import half
from dyadic import value,rn
from root_model import tables
from replaylib import sha
W=Path.cwd();U=QQ(1)/2**48;eta=QQ(1)/2**900;eps=QQ(1)/2**50;gamma=QQ(1)/2**32;P=PolynomialRing(QQ,'B');B=P.gen()
def cmerr(M,e,d):return 2*M*d+2*e*(1+d)+6*U*(M+e)*(1+d)+4*eta
def covered(error,slope=gamma):
 p=P(1+slope*B-error);assert all(c>=0 for c in p.list()),p;return str(error)
ew=2*cmerr(B,0,eps);ebc=2*ew+U*(2*B+2*ew)+2*eta;esum=ebc+U*(3*B+ebc)+2*eta;esq=cmerr(QQ(1),eps,eps)
pre=2*cmerr(3*B,esum,esq);k=QQ(6004799503160661)/18014398509481984
top=k*pre+3*B*abs(k-QQ(1)/3)+U*k*(3*B+pre)+2*eta
deep=(2*cmerr(2*B,2*U*B+2*eta,eps))/2+2*eta
merge=2*cmerr(B,0,eps)+U*(2*B+2*cmerr(B,0,eps))+2*eta
merge_top=2*cmerr(B,2*cmerr(B,0,eps),eps)+2*cmerr(B,2*cmerr(B,0,esq),eps)
merge_top+=U*(2*B+merge_top)+2*eta
merge_top+=U*(3*B+merge_top)+2*eta
errors={n:covered(e) for n,e in [('top_split',top),('deep_split',deep),('deep_merge',merge),('top_merge',merge_top)]}
R=RealBallField(256);sq,cub,fixed=tables(W);pi=R.pi()
def qv(w):v=value(w);return QQ(v.numerator)/v.denominator
iw=qv(0x3ff279a74590331c);w1r=qv(fixed[0][0]);w1i=qv(fixed[0][1]);assert w1r==QQ(1)/2
assert iw<2 and 1+(iw/2)**2<4 and w1r**2+w1i**2<1+4*eps
assert abs(R(iw)-2/R(3).sqrt())<R(eps);assert abs(R(w1i)-R(3).sqrt()/2)<R(eps)
covered(U*2*B+eta+U*(B+iw*B/2+U*B)+3*eta)
count=0
def rev(j,b):return int(format(j,'0'+str(b)+'b')[::-1],2) if b else 0
for k in range(2,10):
 for j in range(2**(k-2)):
  angle=2*pi*(1+6*rev(j,k-2))/(3*2**k)
  for word,v in zip(sq[2**(k-1)+j],[angle.cos(),angle.sin()]):assert abs(R(qv(word))-v)<R(eps)
  count+=1
for j in range(256):
 angle=2*pi*(1+6*rev(j,8))/4608
 for word,v in zip(cub[512+j],[angle.cos(),angle.sin()]):assert abs(R(qv(word))-v)<R(eps)
count+=256
# Independent dyadic/RBF check for signed terminal inputs, including exact zero and subnormal classes.
trials=[]
from fractions import Fraction as F
for re in [0,1,-1,156276714,-156276714]:
 for im in [0,1,-1,367,-367]:
  x=rn(re);y=rn(im);z=mul(0x3ff279a74590331c,y);a=sub(x,half(z));b=z
  out=[add(a,mul(b,fixed[0][0])),mul(b,fixed[0][1])]
  ideal=[R(re)-R(im)/R(3).sqrt(),2*R(im)/R(3).sqrt()]
  M=max(1,abs(re)+abs(im));assert abs(R(qv(a))-ideal[0])<R(gamma*M+1) and abs(R(qv(b))-ideal[1])<R(gamma*M+1)
  assert abs(R(qv(out[0]))-R(re))<R(gamma*M+1) and abs(R(qv(out[1]))-R(im))<R(gamma*M+1)
  trials.append(dict(re=re,im=im,split=[f'{a:016x}',f'{b:016x}'],merged=[f'{z:016x}' for z in out]))
out=dict(status='PASS_SIGNED_SPLIT_MERGE_TRANSFER_CONTRACTS',gamma=str(gamma),absolute_floor='1 per transfer; eta terms dominated exactly',source_error_polynomials=errors,twiddle_pairs_checked=count,
 terminal=dict(IW1I=str(iw),W1R=str(w1r),W1I=str(w1i),split_ideal='(re-im/sqrt(3),2im/sqrt(3))',merge_ideal='(a+b/2,sqrt(3)b/2)',nonpositive_inputs_allowed=True,half_not_assumed_RN=True),
 primitive_domain='All explicitly bounded operands and product/add intermediates in the certified prefix, each abs<=2^100; not all possible arbitrary arrays',
 local_binary_L_bound='1+2^-40 from positive actual H and source div error<=2U',raw_stable_global_metric_identity_proved=False,trials=trials)
(W/'artifacts/transfer_certificate.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],twiddle_pairs=count,terminal_oracle_cases=len(trials)),indent=2))
