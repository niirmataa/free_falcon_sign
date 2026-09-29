"""Whole-root return, source basis suffix, and actual inverse-FFT error/domain closure."""
import json,sys
from pathlib import Path
sys.path.insert(0,str(Path.cwd()/'scripts'))
from sage.all import QQ,ZZ,QuadraticField,PolynomialRing,matrix,identity_matrix,RealBallField
from backend import div,of
from dyadic import value
from root_model import tables
from replaylib import sha
W=Path.cwd();I=W/'inputs/bootstrap';U=QQ(1)/2**48;eta=QQ(1)/2**900;eps=QQ(1)/2**50
left=json.loads((I/'LEFT/artifacts/energy_transfer.json').read_text());metric=json.loads((I/'LEFT/artifacts/metric_bounds.json').read_text());root=json.loads((I/'ROOT/artifacts/numeric_certificate.json').read_text());bank=json.loads((I/'LEFT/BANK_WEIGHTED_BOUNDS.json').read_text())
def qv(w):v=value(w);return QQ(v.numerator)/v.denominator
def ceil(x):return ZZ(x.ceil())
def sqrtup(x):return QQ(ZZ(ceil(x)).isqrt()+1)
def dyadicup(x):
 y=QQ(1)
 while y/2>x:y/=2
 while y<=x:y*=2
 return y
R=QQ(left['reconstruction']['right_source_residual_norm_cap']);delta=QQ(left['reconstruction']['actual_to_exact_source_L_reconstruction_norm_error'])
Pcap=QQ(left['root']['frequency_correction_cap'])+QQ(2**25)*delta
CMerr=6*U*Pcap+8*eta;lastsub=U*(R+Pcap+CMerr)+2*eta;rootDef=CMerr+lastsub
Y=R;X=R+Pcap+CMerr+lastsub
assert X<2**35 and Y<2**27
# Both completed branches have the same per-terminal budget, different metric factors.
Eterm=QQ(bank['right_768_terminal_budget']);k0=QQ(metric['products'][0]['metric_to_stable_integer_factor']);k1=QQ(metric['products'][1]['metric_to_stable_integer_factor'])
assert k0==2 and k1==6
aMax=QQ(root['derived']['ahatmax']);jMax=QQ(root['derived']['jhatmax']);dc=QQ(root['derived']['det_error']);q=QQ(18433)
beta=256*U*jMax*aMax/(q-dc)**2;gamma=8*U;alpha=QQ(1)/1024
c0=(1+alpha)/(1-gamma);c1=(1+(1+1/alpha)*(32*U)**2*jMax*aMax/(q-dc)**2)/(1-beta)
assert c0<2 and c1<2
Estar=2*(k0+k1)*Eterm
# Error in exact source-basis image: left reconstruction + root CM/sub defect, right reconstruction.
Edelta=2*(QQ(2**23)*(delta+rootDef)**2+QQ(2**31)*delta**2)
bSmall=QQ(1536)+QQ(1)/2**25;bLarge=QQ(3144192)+QQ(1)/2**14
def product_bound(a,b):return (1+6*U)*a*b+8*eta
sumProducts=X*bSmall+Y*bLarge
posterr=6*U*sumProducts+16*eta+U*(product_bound(X,bSmall)+product_bound(Y,bLarge))+2*eta
coarse=product_bound(X,bSmall)+product_bound(Y,bLarge)+U*(product_bound(X,bSmall)+product_bound(Y,bLarge))+2*eta
assert coarse<2**49
spectral=QQ(ceil(sqrtup(768*Estar)+sqrtup(Edelta)+posterr))
coefficient=QQ(ceil(sqrtup(2*Estar)+sqrtup(2*Edelta)+2*posterr))
assert spectral<2**27 and coefficient<2**23
# New iFFT stage recurrence on its actual source spectral input. Component errors.
square,cubic,fixed=tables(W);RBF=RealBallField(256);pi=RBF.pi();tw=0
def rev(j,k):return int(format(j,'0'+str(k)+'b')[::-1],2) if k else 0
for m in [2,4,8,16,32,64,128,256]:
 for j in range(m//2):
  theta=2*pi*(768//m+(4608//m)*rev(j,m.bit_length()-2))/4608
  for w,v in zip(square[m+j],[theta.cos(),theta.sin()]):assert abs(RBF(qv(w))-v)<RBF(eps)
  tw+=1
for j in range(256):
 theta=2*pi*(1+6*rev(j,8))/4608
 for w,v in zip(cubic[512+j],[theta.cos(),theta.sin()]):assert abs(RBF(qv(w))-v)<RBF(eps)
 tw+=1
iw=qv(0x3ff279a74590331c);assert abs(RBF(iw)-2/RBF(3).sqrt())<RBF(eps) and iw<2
def cm(M,e,d):return 2*M*d+2*e*(1+d)+6*U*(M+e)*(1+d)+4*eta
B=spectral;eW=cm(B,0,eps);eSum=2*eW+U*(2*B+2*eW)+eta;eSum+=U*(3*B+eSum)+eta
eSq=cm(QQ(1),eps,eps);plain=2*U*B+eta;plain+=U*(3*B+plain)+eta
e=max(plain,cm(3*B,eSum,eps),cm(3*B,eSum,eSq));M=3*B;stages=[dict(stage='cubic',ideal_component_cap=str(M),component_error=str(e),source_cap=str(M+e),blocks=256)]
index_rows=[];t=6;m=256
for k in range(8):
 ht=t//2;hm=m//2;pairs=[(v,v+ht,m+u) for u in range(hm) for v in range(u*t,u*t+ht)]
 assert len(pairs)==384 and sorted([x for a,b,c in pairs for x in [a,b]])==list(range(768))
 es=2*e+U*(2*M+2*e)+eta;e=max(es,cm(2*M,es,eps));M*=2
 assert M+e<2**38
 stages.append(dict(stage='binary_'+str(k),t=t,m=m,ideal_component_cap=str(M),component_error=str(e),source_cap=str(M+e),pairs=384))
 index_rows.append(dict(t=t,m=m,pairs=pairs));t*=2;m//=2
assert t==1536 and m==1
e1=iw*e+eps*M+U*iw*(M+e)+eta
e0=e+e1/2+QQ(1)/2**1023+U*(M+e+M+e1/2+QQ(1)/2**1023)+eta
e=max(e0,e1);M*=2
stages.append(dict(stage='terminal_X2-X+1',ideal_component_cap=str(M),component_error=str(e),source_cap=str(M+e),blocks=768))
ni=div(of(1),of(768));rho=qv(ni);nierror=abs(rho-QQ(1)/768)
err=rho*e+nierror*M+U*rho*(M+e)+eta;bound=dyadicup(err);floatcap=coefficient+bound;intcap=ZZ((floatcap+QQ(1)/2).floor())
assert floatcap<2**23 and intcap<2**23
stages.append(dict(stage='scale_inverse768',source_word=f'{ni:016x}',exact_value=str(rho),error_from_one_over768=str(nierror),component_error=str(err),component_error_outward=str(bound),source_output_abs_cap=str(floatcap)))
# Generic inverse-stage identities, not rounded FFT linearity.
K=QuadraticField(-3,'s3');w=(-1+K.gen())/2;Q=PolynomialRing(K,'x');x=Q.fraction_field().gen();F=x.parent()
fw=matrix(F,[[1,x,x*x],[1,w*x,w*w*x*x],[1,w*w*x,w*x*x]])
iv=matrix(F,[[1,1,1],[1/x,w*w/x,w/x],[1/(x*x),w/(x*x),w*w/(x*x)]]);assert iv*fw==3*identity_matrix(F,3)
assert matrix(F,[[1,1],[1/x,-1/x]])*matrix(F,[[1,x],[1,-x]])==2*identity_matrix(F,2)
assert 3*2**8==768
out=dict(schema='FT1536_POSTPROCESSING_NUMERIC_V1',status='PASS_COMPLETED_WHOLE_ROOT_SUFFIX_IFFT_RINT_DOMAINS',source_pin=sha(I/'CANDIDATE.sha256'),
 sampling_return=dict(domain='Actual whole ffSampling return in certified emitted/canonical/normalized/context domain; all terminal calls normal by LEFT',
  left_pre_root_sub_cap=str(R),right_y_cap=str(Y),root_product_cap=str(Pcap),root_last_CM_error=str(CMerr),root_last_sub_error=str(lastsub),returned_x_cap=str(X),
  both_branch_metric_factors=[2,6],terminal_budget_each=str(Eterm),source_basis_root_transform_factors=[str(c0),str(c1)],
  exact_source_L_reference_image_energy=str(Estar),source_return_image_error_energy=str(Edelta),right_only_energy_not_used_as_whole=True),
 suffix=dict(basis_small_cap=str(bSmall),basis_large_cap=str(bLarge),coarse_CM_sum_domain_cap=str(coarse),each_source_CM_add_error=str(posterr),
  actual_post_frequency_cap=str(spectral),mathematical_inverse_eval_coefficient_cap=str(coefficient),ternary_stores='rint(t0),rint(t1); no hm-minus or second negation'),
 ifft=dict(stages=stages,source_error_outward=str(bound),physical_index_stages=index_rows,twiddle_pairs_checked=tw,
  inverse768_bits=f'{ni:016x}',terminal_scalar_error=[str(e0),str(e1)],exact_inverse_identity='cubic inverse*forward=3I; each binary=2I; terminal real fold inverse; scale1/768',
  rounded_algorithm_not_assumed_linear=True,all_stage_source_operands_below='2^40',source_output_abs_cap=str(floatcap)),
 rint=dict(caller_abs_cap=str(floatcap),caller_int64_abs_cap=str(intcap),proved_model_domain='all finite raw words with encoded exponent<=1072 (abs value<2^50)',
  int64_margin=str(ZZ(2)**63-intcap),nearest_integer_ties_even=True),
 precast=dict(Safe16_proved=False,strongest_uniform_precast_abs=str(intcap),failure_type='bound does not imply [-32768,32767] for both vectors; no required-domain witness/probability assigned'),
 reference_integer_recovery_proved=False,required_domain_counterexample=False,
 dependencies={p:sha(I/p) for p in ['LEFT/artifacts/energy_transfer.json','LEFT/artifacts/metric_bounds.json','LEFT/BANK_WEIGHTED_BOUNDS.json','ROOT/artifacts/numeric_certificate.json','TARGETS/INITIAL_TARGET_CERTIFICATE.json']})
(W/'artifacts/numeric_certificate.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],root_outputs=[str(X),str(Y)],post_frequency=str(spectral),inverse_coefficient=str(coefficient),ifft_error=str(bound),rint_cap=str(intcap),ni768=f'{ni:016x}',Safe16=False),indent=2))
