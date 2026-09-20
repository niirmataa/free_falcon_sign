"""Fresh exact FFT cap18432 proof certificate and two target error layers."""
import hashlib,json,sys
from pathlib import Path
sys.path.insert(0,str(Path.cwd()/'scripts'))
from sage.all import QQ,ZZ,RealBallField,PolynomialRing
from root_model import tables
from backend import div,of
from dyadic import value
from replaylib import sha
W=Path.cwd();I=W/'inputs/bootstrap';N=1536;q=18433;cap=18432
U=QQ(1)/2**48;eta=QQ(1)/2**900;eps=QQ(1)/2**50;R=RealBallField(256)
square,cubic,fixed=tables(W);pi=R.pi()
def br(j,b):return int(format(j,'0'+str(b)+'b')[::-1],2) if b else 0
def qv(w):
 v=value(w);return QQ(v.numerator)/v.denominator
def digest(x):return hashlib.sha256(json.dumps(x,sort_keys=True,separators=(',',':')).encode()).hexdigest()
maxerr=R(0);sm={};cm={}
def twiddle(words,e):
 global maxerr
 theta=2*pi*e/4608
 for w,z in zip(words,[theta.cos(),theta.sin()]):
  err=abs(R(qv(w))-z);assert err<R(eps);maxerr=max(maxerr,err)
for m in [2,4,8,16,32,64,128,256]:
 for j in range(m//2):
  e=768//m+4608//m*br(j,m.bit_length()-2);sm[str(m+j)]=e;twiddle(square[m+j],e)
for j in range(256):e=1+6*br(j,8);cm[str(512+j)]=e;twiddle(cubic[512+j],e)
for words,e in zip(fixed,[768,1536,3072]):twiddle(words,e)
assert digest(sm)=='d87bea64489acf39ecfd9ac66b31c62917bc4f4a3bc376a4cc83eb2e9dfa553d'
assert digest(cm)=='b5afac80fb5eacc652e5f40ed5da493d9f80201b6905a7be14ad99f9696d1f76'
def shift(a,e):return {k:(v+e)%4608 for k,v in a.items()}
def union(a,b):assert a.keys().isdisjoint(b);return a|b
# Symbolic IDEAL operator, not a claim that the rounded source FFT is linear.
a=[{i:0,i+768:768} for i in range(768)];t=768;m=2
while t>3:
 h=t//2
 for j in range(m//2):
  for i in range(j*t,j*t+h):
   left=a[i];right=shift(a[i+h],sm[str(m+j)]);a[i]=union(left,right);a[i+h]=union(left,shift(right,2304))
 t=h;m*=2
roots=[];checked=0
for i in range(0,768,3):
 e=cm[str(512+i//3)]
 for k in range(3):
  r=e+k*1536;poly=union(union(a[i],shift(a[i+1],r)),shift(a[i+2],2*r))
  assert len(poly)==N and all(w==r*j%4608 for j,w in poly.items());roots.append(r);checked+=len(poly)
assert roots==json.loads((I/'ROOT/artifacts/numeric_certificate.json').read_text())['fft_map']['roots']
assert set(roots)|{(-r)%4608 for r in roots}=={r for r in range(4608) if r%6 in [1,5]}
def cmerr(M,e,d):return 2*M*d+2*e*(1+d)+6*U*(M+e)*(1+d)+4*eta
def cm_domain(M,e,d):
 p=(1+U)*(M+e)*(1+d)+eta;z=2*(1+U)*p+eta
 assert M+e<2**28 and 1+d<2 and p<2**28 and z<2**28
 return dict(input_component=str(M+e),twiddle_component=str(1+d),scalar_product=str(p),sum_sub=str(z))
def fft_error(C):
 C=QQ(C);M=2*C;e=C*eps+4*U*C*(1+eps)+3*eta
 assert (1+U)*C*(1+eps)+eta<2**28 and M+e<2**28
 stages=[dict(stage='first_fold',butterflies=768,ideal_modulus=str(M),component_error=str(e),source_component=str(M+e))]
 for k in range(8):
  dom=cm_domain(M,e,eps);p=cmerr(M,e,eps);e=e+p+U*(2*M+e+p)+eta;M*=2
  assert M+e<2**28
  stages.append(dict(stage='square_'+str(k+1),butterflies=384,ideal_modulus=str(M),component_error=str(e),source_component=str(M+e),primitive_domains=dom))
 b0=cmerr(M,e,eps);b1=cmerr(M,b0,eps);x2=cmerr(QQ(1),eps,eps);c0=cmerr(M,e,x2);c1=cmerr(M,c0,eps)
 for mm,ee,dd in [(M,e,eps),(M,b0,eps),(QQ(1),eps,eps),(M,e,x2),(M,c0,eps)]:cm_domain(mm,ee,dd)
 assert (1+U)*(1+eps)**2+eta<2 # source twiddle FPC_SQR double domain
 ebc=b1+c1+U*(2*M+b1+c1)+eta;e=e+ebc+U*(3*M+e+ebc)+eta
 assert 3*M+e<2**28
 stages.append(dict(stage='final_cubic',butterflies=256,ideal_modulus=str(3*M),component_error=str(e),source_component=str(3*M+e),B0_error=str(b0),B12_error=str(b1),squared_twiddle_error=str(x2),C0_error=str(c0),C12_error=str(c1),BC_sum_error=str(ebc)))
 return e,stages
ec,stages=fft_error(cap);e1,_=fft_error(1);eF,_=fft_error(2047)
assert e1<QQ(1)/2**26 and eF<QQ(1)/2**15
def outward2(x):
 z=QQ(1)
 while z/2>x:z/=2
 while z<=x:z*=2
 return z
EC=outward2(ec);EF=QQ(1)/2**15;Ef=QQ(1)/2**26
ni=div(of(1),of(q));rho=qv(ni);delta=abs(rho-QQ(1)/q)
assert 0<rho and QQ(1)/2**15<rho<QQ(1)/2**14 and delta<=U/q+eta
theta=q*delta+q*rho*(7*U+6*U*U);tail=8*eta*rho*(1+U)+2*eta
assert theta<QQ(1)/2**44 and tail<3*eta
targets=[];Ac=QQ(N*cap);Ah=Ac+2*EC
for name,B,eb,sign,column in [('t0',QQ(N*2047),EF,-1,'b11'),('t1',QQ(N),Ef,1,'b01')]:
 Bh=B+2*eb;product_round=6*U*Ah*Bh+8*eta
 rounded_error=rho*(1+U)*product_round+(delta+U*rho)*Ah*Bh+2*eta
 fft_transport=(2*EC*B+Ac*2*eb+4*EC*eb)/q
 ideal_error=rounded_error+fft_transport;mag=Ac*B/q
 Rerr=outward2(rounded_error);Eerr=outward2(ideal_error);abs_cap=ZZ((mag+Eerr).ceil())
 assert Ah<2**26 and Bh<(2**22 if name=='t0' else 2**11)
 scalar_product=(1+U)*Ah*Bh+eta;before_add=2*(1+U)*scalar_product+eta
 assert scalar_product<2**48 and before_add<2**49 and Ah*Bh+product_round<2**49
 assert (Ah*Bh+product_round)*rho*(1+U)+eta<2**36
 targets.append(dict(target=name,basis_column=column,ideal_sign=sign,ideal_coefficient_cap=2047 if name=='t0' else 1,
  ideal_modulus_upper=str(mag),rounded_basis_value_modulus_upper=str(Ah*Bh/q),source_modulus_and_component_upper=str(abs_cap),
  source_complex_product_modulus_upper=str(Ah*Bh+product_round),complex_multiply_error_norm=str(product_round),
  rounding_only_error_norm=str(rounded_error),rounding_only_error_outward=str(Rerr),FFT_basis_transport_error_norm=str(fft_transport),
  ideal_reference_error_norm=str(ideal_error),ideal_reference_error_outward=str(Eerr),
  exact_coefficient_abs_upper=str(QQ(2304)*cap*(2047 if name=='t0' else 1)/q),
  inverse_eval_source_coefficient_l2_error_upper=str(2*Eerr),
  source_inverse_eval_coefficient_abs_upper=str(QQ(2304)*cap*(2047 if name=='t0' else 1)/q+2*Eerr),
  primitive_preflight=dict(FFT_input_component=str(Ah),basis_component=str(Bh),scalar_product=str(scalar_product),add_sub_operand_sum=str(before_add),all_abs_below='2^100'),
  raw_class='finite normal or signed zero; absolute error includes cancellation/reference zero'))
# Exact monomial reduction, independently by recursive X^N=X^(N/2)-1.
reduced=[]
for e in range(2*N-1):
 if e<N:r={e:1}
 else:
  r=dict(reduced[e-768])
  for k,v in reduced[e-1536].items():r[k]=r.get(k,0)-v
  r={k:v for k,v in r.items() if v}
 reduced.append(r)
row_counts=[0]*N;pairs=0
for i in range(N):
 for j in range(N):
  for k,v in reduced[i+j].items():row_counts[k]+=abs(v)
  pairs+=1
assert row_counts==[2303-k for k in range(768)]+[2304]*768 and pairs==2359296
# Exact Gram of all root evaluations: only differences0,+/-768 survive.
gram_diagonals=[dict(difference=d,coefficient=1536 if d==0 else 768 if abs(d)==768 else 0) for d in range(-1535,1536)]
P=PolynomialRing(QQ,names=['f','g','F','G','c']);f,g,F,G,c=P.gens();det=f*G-g*F
assert (-c*F)*g+(c*f)*G==c*det and (-c*F)*(-f)+(c*f)*(-F)==0
out=dict(schema='FT1536_INITIAL_TARGET_NUMERIC_V1',status='PASS_ALL_CANONICAL_CHALLENGE_FFT_AND_TARGET_ERRORS',N=N,q=q,canonical_cap=cap,U=str(U),eta=str(eta),eps_twiddle=str(eps),
 fft=dict(challenge_component_error_exact=str(ec),challenge_component_error_outward=str(EC),ideal_modulus_upper=N*cap,all_stage_primitive_abs_cap='2^28',stages=stages,
  basis_error_f=str(Ef),basis_error_F=str(EF),old_2047_bound_reused_for_challenge=False,reference_only_is_linear=True),
 map=dict(root_order=4608,roots=roots,real_indices='i0..767',imag_indices='i+768',all_symbolic_coefficients=checked,all_1536_coefficients_all_768_positions=True),
 twiddles=dict(square=255,cubic=256,fixed_components=6,error_lt=str(eps),max_error_RBF256=str(maxerr),square_map_sha256=digest(sm),cubic_map_sha256=digest(cm)),
 reciprocal=dict(word=f'{ni:016x}',value=str(rho),exact_reference='1/18433',absolute_error=str(delta),positive_normal=True,source='div_C(one,of_C(18433))',negation='XOR bit63'),
 rounding_relative=dict(theta=str(theta),theta_outward='1/17592186044416',absolute_tail=str(tail),tail_outward='3*eta',scope='norm error to same actual FFT/basis values product divided by exact q; no division by unknown reference zero'),
 targets=targets,coefficient_space=dict(pair_count=pairs,row_absolute_counts=row_counts,row_max=2304,
  full_evaluation_gram=gram_diagonals,eigenvalues=[768,2304],identity='sum_full_roots |eval(a)|^2 =1536*(sum a_i^2+sum_{i<768} a_i*a_{i+768})',
  inverse_eval_error='component frequency error E -> real coefficient l2 error <=2E; source inverse evaluation is mathematical, not execution of iFFT3',
  norm_bounds='For B=2304*18432*coefficient_cap/q: coefficient linf<=B, l2^2<=1536*B^2, Phi quadratic form<=2304*B^2; add inverse-eval error only through stated transport'),
 source_pin=sha(I/'CANDIDATE.sha256'),proof_kind='MIXED_KERNEL_AND_UNIVERSAL_ANALYTICAL_SOURCE_PROOF',rounded_basis_determinant_assumed_exact_q=False,NumericCenter_or_Reach_claimed=False)
(W/'artifacts/numeric_certificate.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps(dict(status=out['status'],fft_error=str(EC),ni=out['reciprocal'],targets=[{k:r[k] for k in ['target','ideal_modulus_upper','source_modulus_and_component_upper','rounding_only_error_outward','ideal_reference_error_outward','exact_coefficient_abs_upper']} for r in targets],symbolic_weights=checked,monomial_pairs=pairs),indent=2))
