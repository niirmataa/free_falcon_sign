"""Exact QQ error composition and RBF twiddles; complete symbolic linear FFT map."""
import hashlib,json
from pathlib import Path
from sage.all import QQ,RealBallField
from root_model import tables
from dyadic import value
from replaylib import sha
W=Path.cwd();square,cubic,fixed=tables(W);R=RealBallField(256);pi=R.pi();eps=QQ(1)/2**50;u=QQ(1)/2**48;eta=QQ(1)/2**900
def br(j,b):return int(format(j,'0'+str(b)+'b')[::-1],2) if b else 0
def pair(e):return (2*pi*e/4608).cos(),(2*pi*e/4608).sin()
sqmap={};cumap={};maxerr=R(0)
def check(word,e):
 global maxerr
 for w,t in zip(word,pair(e)):
  v=value(w);err=abs(R(QQ(v.numerator)/v.denominator)-t);assert err<R(eps);maxerr=max(maxerr,err)
for m in [2,4,8,16,32,64,128,256]:
 for j in range(m//2):
  e=768//m+(4608//m)*br(j,m.bit_length()-2);sqmap[str(m+j)]=e;check(square[m+j],e)
for j in range(256):e=1+6*br(j,8);cumap[str(512+j)]=e;check(cubic[512+j],e)
for word,e in zip(fixed,[768,1536,3072]):check(word,e)
mapsha=lambda m:hashlib.sha256(json.dumps(m,sort_keys=True,separators=(',',':')).encode()).hexdigest()
assert mapsha(sqmap)=='d87bea64489acf39ecfd9ac66b31c62917bc4f4a3bc376a4cc83eb2e9dfa553d'
assert mapsha(cumap)=='b5afac80fb5eacc652e5f40ed5da493d9f80201b6905a7be14ad99f9696d1f76'
# Every coefficient is symbolic, not a sample vector. Supports are disjoint.
def shift(p,e):return {k:(v+e)%4608 for k,v in p.items()}
def union(a,b):assert a.keys().isdisjoint(b);return a|b
a=[{i:0,i+768:768} for i in range(768)];t=768;m=2
while t>3:
 h=t//2
 for j in range(m//2):
  for i in range(j*t,j*t+h):
   left,right=a[i],shift(a[i+h],sqmap[str(m+j)]);a[i]=union(left,right);a[i+h]=union(left,shift(right,2304))
 t=h;m*=2
roots=[];checked=0
for i in range(0,768,3):
 e=cumap[str(512+i//3)]
 for k in range(3):
  r=e+k*1536;p=union(union(a[i],shift(a[i+1],r)),shift(a[i+2],2*r))
  assert len(p)==1536 and all(v==r*j%4608 for j,v in p.items());checked+=len(p);roots.append(r)
assert len(set(roots))==768 and {r%4608 for r in roots}|{(-r)%4608 for r in roots}=={i for i in range(4608) if i%6 in (1,5)}
def cmerr(M,e,d):return 2*M*d+2*e*(1+d)+6*u*(M+e)*(1+d)+4*eta
def fft_error(cap):
 M=QQ(2*cap);e=cap*eps+4*u*cap*(1+eps)+3*eta;trace=[e]
 for _ in range(8):
  p=cmerr(M,e,eps);e=e+p+u*(2*M+e+p)+eta;M*=2;trace.append(e)
 eb=cmerr(M,cmerr(M,e,eps),eps)
 ed=cmerr(QQ(1),eps,eps)
 ec=cmerr(M,cmerr(M,e,ed),eps)
 ebc=eb+ec+u*(2*M+eb+ec)+eta
 e=e+ebc+u*(3*M+e+ebc)+eta
 return e,trace
e1,t1=fft_error(1);eF,tF=fft_error(2047);ef=QQ(1)/2**26;eG=QQ(1)/2**15
assert e1<ef and eF<eG,(str(e1),str(eF))
N=QQ(1536);H=N*2047;q=QQ(18433);df=2*ef;dF=2*eG
Amax=2*N*N;Jmax=2*H*H
da=2*(2*N*df+df*df);dj=2*(2*H*dF+dF*dF);dc=2*(N*dF+H*df+df*dF);ddet=dc
ahatmax=2*(N+df)**2;jhatmax=2*(H+dF)**2
assert ddet<1 and da<QQ(1)/1024
# a,j,c here are EXACT Gram of the computed FFT matrix, not independent boxes.
gamma=8*u;schur_factor=256*u;schur_round=schur_factor*jhatmax
assert (1+4*u)*QQ(1)/4+7*eta<QQ(1)/2
assert (q-ddet)**2>ahatmax/4  # gives j>1/4 by Cauchy/Gram determinant
assert gamma<QQ(1)/1024
assert 14*eta<u/4 and 2*eta<u*(q-ddet)/ahatmax
# Direct per-component div, not reciprocal multiplication.
Lround_factor=(u*(1+gamma)+2*gamma)/(1-gamma)+8*eta
assert Lround_factor<32*u
# Bounds for muladj: propagated input error + operation error.
Pfactor=gamma+(1+gamma)*32*u+6*u*(1+gamma)*(1+32*u)+24*eta
assert Pfactor<64*u
Dfactor=gamma+Pfactor+2*u*(2+gamma+Pfactor)+8*eta
assert Dfactor<schur_factor
lower=(q-ddet)**2/ahatmax-schur_round
upper=4*(q+ddet)**2+schur_round
assert lower>32 and upper<2**31 and schur_round<32
assert ahatmax*(1+gamma)<2**23 and da<QQ(1)/4-QQ(1)/8
# a>=1/4; exact A>=1/8 (a differs by da). Tighter A>=1/4 follows gate+a error.
assert (QQ(1)/2-7*eta)/(1+4*u)-da>QQ(1)/4
Lmax=4*(2*(H+dF)) # 2*sqrt(j/a) <=4*sqrt(j) <=8*(H+dF)
Lerror=128*u*(2*(H+dF))+4*dc+16*H*da
Derror=4*(2*q*ddet+ddet**2)+16*q*q*da+schur_round
gramA=da+gamma*ahatmax;gramJ=dj+gamma*jhatmax;gramC=dc+gamma*2*(N+df)*(H+dF)
assert Lmax<2**25 and Lerror<2**14 and Derror<2**22
assert gramA<QQ(1)/1024 and gramC<1 and gramJ<1024
out=dict(schema='H3_ROOT_NUMERIC_CERTIFICATE_V1',status='PASS_EXACT_COMPOSITION',
 primitive=dict(u=str(u),eta=str(eta),add_input_abs_cap='2^100',mul_input_abs_cap='2^100',div_denominator_interval=['1/2','2^23'],proof='ANALYTIC_PROOF.md'),
 twiddles=dict(square_count=255,cubic_count=256,fixed_components=6,error_lt=str(eps),max_error_RBF256=str(maxerr),square_map_sha256=mapsha(sqmap),cubic_map_sha256=mapsha(cumap)),
 fft_map=dict(root_order=4608,roots=roots,checked_symbolic_coefficients=checked,all_1536_coefficients_all_768_slots=True,normalization='unscaled evaluation; real slot i, imaginary slot i+768'),
 constants=dict(fft_component_error_fg=str(ef),fft_component_error_FG=str(eG),gram_error_A='1/1024',gram_error_C_norm='1',gram_error_J='1024',
  source_g00_real_lower='1/2',source_g00_real_upper='8388608',source_L_norm_upper='33554432',L_error_norm_upper='16384',
  source_D_real_lower='32',source_D_real_upper='2147483648',source_D_error_norm_upper='4194304',source_D_imag_abs_upper='32'),
 derived={k:str(v) for k,v in dict(fft_error_fg=e1,fft_error_FG=eF,Amax=Amax,Jmax=Jmax,da=da,dj=dj,dc=dc,det_error=ddet,
  ahatmax=ahatmax,jhatmax=jhatmax,gramA=gramA,gramC=gramC,gramJ=gramJ,schur_round=schur_round,Dlower=lower,Dupper=upper,Lmax=Lmax,Lerror=Lerror,Derror=Derror).items()},
 backend_complete_IEEE_assumed=False,zero_E2_minus20_reused_outside_domain=False,
 source_sha256={n:sha(W/'source'/n) for n in ['falcon-fft.c','falcon-sign.c','falcon-keygen.c','fpr-emulated.c','fpr-emulated.h']})
(W/'artifacts/numeric_certificate.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps(dict(status=out['status'],symbolic_coefficients=checked,constants=out['constants']),indent=2))
