"""Uniform exact c3 and symbolic split/Schur certificate; no sampled keys."""
import json,re,sys
from pathlib import Path
sys.path.insert(0,str(Path.cwd()/'scripts'))
from sage.all import QQ,ZZ,PolynomialRing,NumberField,matrix,diagonal_matrix,identity_matrix,RealBallField
from root_model import tables
from node_model import INV3
from dyadic import value
from replaylib import sha,verify_manifest
W=Path.cwd();I=W/'inputs/bootstrap';verify_manifest(I,'MANIFEST.sha256','426db8a67b74de0de0141a8d9ca406fca7a2bdad45a42e97a913bad4d62b6ca3')
root=json.loads((I/'ROOT/artifacts/numeric_certificate.json').read_text());derived={k:QQ(v) for k,v in root['derived'].items()}
u=QQ(1)/2**48;eta=QQ(1)/2**900;eps=QQ(1)/2**50;q=QQ(18433)
Eroot=derived['schur_round'];mhat=(q-derived['det_error'])**2/derived['ahatmax'];Mhat=4*(q+derived['det_error'])**2
assert Eroot==256*u*derived['jhatmax'] and Eroot<32 and mhat-Eroot>32 and Mhat+Eroot<2**31
kapF=value(INV3);kap=QQ(kapF.numerator)/kapF.denominator
assert INV3==0x3fd5555555555555 and kap==QQ(1)/3-QQ(1)/(3*2**54)
# Re-audit precisely the twiddles used by split_top, including conjugation.
_,cubic,fixed=tables(W);R=RealBallField(256);pi=R.pi();maxerr=R(0);roots=[]
def br(j):return int(format(j,'08b')[::-1],2)
def check(word,e):
 global maxerr
 theta=2*pi*e/4608
 for w,t in zip(word,[theta.cos(),theta.sin()]):
  v=value(w);err=abs(R(QQ(v.numerator)/v.denominator)-t);assert err<R(eps);maxerr=max(maxerr,err)
for j in range(256):
 e=1+6*br(j);check(cubic[512+j],e);roots.append(e)
for word,e in zip(fixed[1:],[1536,3072]):check(word,e)
assert len(set(roots))==256 and {e%1536 for e in roots}|{(-e)%1536 for e in roots}=={e for e in range(1536) if e%6 in [1,5]}
for j,e in enumerate(roots):assert root['fft_map']['roots'][3*j:3*j+3]==[e,e+1536,e+3072]
# Independent exact Hermitian reference, after removing unit diagonal phases x^r.
Qz=PolynomialRing(QQ,'z');z=Qz.gen();K=NumberField(z*z+z+1,'w');w=K.gen();P=PolynomialRing(K,names=['a','b','c']);a,b,c=P.gens()
h=(a+b+c)/3;alpha=(a+w*w*b+w*c)/3;beta=(a+w*b+w*w*c)/3
H=matrix(P,[[h,alpha,beta],[beta,h,alpha],[alpha,beta,h]])
U=matrix(K,[[1,1,1],[1,w,w*w],[1,w*w,w]])
Uc=matrix(K,[[v.polynomial()(w*w) for v in row] for row in U.rows()]).transpose()
assert U*Uc==3*identity_matrix(K,3)
assert H==U.change_ring(P)*diagonal_matrix(P,[a,b,c])*Uc.change_ring(P)/3
assert H.det()==a*b*c and h*h-alpha*beta==(a*b+a*c+b*c)/3
def cmerr(M,e,d):return 2*M*d+2*e*(1+d)+6*u*(M+e)*(1+d)+4*eta
def split_round(B):
 ew=2*cmerr(B,QQ(0),eps)
 bc=2*ew+u*(2*B+2*ew)+2*eta
 total=bc+u*(3*B+bc)+2*eta
 square=cmerr(QQ(1),eps,eps)
 rotated=2*cmerr(3*B,total,square)
 plain=2*u*B+2*eta+u*(3*B+2*u*B+2*eta)+2*eta
 E=max(rotated,plain)
 return kap*E+3*B*abs(kap-QQ(1)/3)+u*kap*(3*B+E)+2*eta
records=[]
for branch,B,T,lam,m,E,Imax,eref in [
 (0,QQ(2**23),QQ(2**24),QQ(1)/4,QQ(1)/2,QQ(0),QQ(0),QQ(1)/1024+QQ(1)/8192),
 (1,QQ(2**32),QQ(2**33),QQ(16),mhat,Eroot,QQ(32),QQ(2**22)+QQ(1)/16)]:
 ds=B/2**36;s=E+ds;exactround=split_round(B)
 assert exactround<ds and m-3*s>lam and 2*s<m and B+ds<T
 if branch==1:assert s<Imax
 assert 1+4*s/lam<9
 r=u+2*eta # division error for L10,L20, since |b|/h<=1
 rp=r+6*u*(1+r)+8*eta/lam
 real1=rp+u*(2+rp)+eta/lam
 imag1=rp+u*(1+rp)+eta/lam
 assert real1<64*u and imag1<64*u
 e1=64*u*T;e2=65536*u*T
 assert e1<lam/2 and e2<lam/2
 # c*adj(b) before division; product bound is h²; h>=lam.
 ep=6*u+8*eta/(lam*lam)
 eq=ep+u*(1+ep)+2*eta/lam
 en=eq+u*(2+eq)+2*eta/lam
 assert en<64*u
 rel=64*u*T/lam;ratio=(64*u+3*64*u)/(1-rel)
 lc=ratio+u*(3+ratio)+2*eta
 assert lc<1024*u and 1024*u*T/lam<1
 # |L21|<=3, computed |L21|<4; source norm2 error <=3u|L21_C|²+4eta.
 normerr=7*1024*u+48*u+4*eta
 producterr=normerr*(1+rel)+9*64*u
 mulerr=producterr+u*(1+producterr)+eta/lam
 finalerr=64*u+mulerr+u*(2+64*u+mulerr)+eta/lam
 assert finalerr<65536*u
 # Exact-reference errors use Hermitian variational pivots, not independent boxes.
 le10=min(QQ(2),2*eref/lam)+2*u
 le21=min(QQ(4),(8*eref+2*eref*eref/lam)/lam)+1024*u*T/lam
 de1=4*eref+Imax+2*e1;de2=78*eref+Imax+2*e2
 Lerr=QQ(1)/64 if branch==0 else QQ(3);L21err=QQ(1)/16 if branch==0 else QQ(5)
 D1err=QQ(1)/128 if branch==0 else QQ(2**25);D2err=QQ(1)/8 if branch==0 else QQ(2**29)
 assert le10<Lerr and le21<L21err and de1<D1err and de2<D2err
 im1=QQ(1)/256 if branch==0 else QQ(33);im2=QQ(1)/256 if branch==0 else QQ(34)
 assert Imax+e1<=im1 and Imax+e2<=im2
 assert QQ(1)/16<=lam/2 and 2*T<2**35 and (128*T)<2**100 and 2*T*T<2**100
 record=dict(branch=branch,input_abs_cap=str(B),split_rounding_norm_error=str(ds),input_to_real_comparison_error=str(E),
  split_to_exact_reference_error=str(eref),comparison_eigen_lower=str(lam),comparison_entry_error=str(s),
  t0_real_lower=str(lam),t0_real_upper=str(T),d11_real_lower=str(lam/2),d22_real_lower=str(lam/2),diagonal_real_upper=str(2*T),
  t0_imag_abs_upper=str(Imax),d11_imag_abs_upper=str(im1),d22_imag_abs_upper=str(im2),
  L10_L20_norm_upper='2',L21_norm_upper='4',L10_L20_error_norm=str(Lerr),L21_error_norm=str(L21err),
  d11_error_norm=str(D1err),d22_error_norm=str(D2err),
  source_d11_error_to_H_real=str(e1),source_d22_error_to_H_real=str(e2),symmetry_modulus_gap_upper=str(2*s),
  source_L21_error_to_H=str(1024*u*T/lam),
  t0_error_norm=str(eref),all_operand_abs_cap='2^100',div_denominator_interval=['1/16',str(2**35)],
  intermediate_caps=dict(split_outputs=str(T),muladj_c_b=str(2*T*T),quotient_c_b_over_h=str(2*T),L21_numerator=str(4*T),mulselfadj_L21_real='32',final_product_real=str(128*T)),
  intermediate_imaginary=dict(split_t1_t2=str(T),muladj_b_L10=str(e1),muladj_L20_c=str(e1),muladj_c_b=str(2*T*T),L21_numerator=str(4*T),selfadj_and_final_product='raw +0'),
  checked_exact_split_rounding=str(exactround),checked_eigen_margin=str(m-3*s))
 records.append(record)
text=(W/'formal/NodeConstants.lean').read_text()
fields=['t0_real_lower','d11_real_lower','t0_real_upper','diagonal_real_upper','t0_imag_abs_upper','d11_imag_abs_upper','d22_imag_abs_upper','L10_L20_error_norm','L21_error_norm','d11_error_norm','d22_error_norm']
for b in [0,1]:
 line=re.search(r'def branch'+str(b)+r' : BranchConstants := (.*)',text).group(1)
 vals=[QQ(int(n))/int(d) for n,d in re.findall(r'\((-?\d+),(\d+)\)',line)]
 assert vals==[QQ(records[b][f]) for f in fields]
out=dict(schema='H3_NODE3_NUMERIC_CERTIFICATE_V1',status='PASS_UNIFORM_C3_COMPOSITION',constants=records,
 kernel_constant_fields_match=fields,
 primitive=dict(u=str(u),eta=str(eta),input_abs_cap='2^100',new_div_interval=['1/16',str(2**35)],div_exp_upper=1128,proof='ANALYTIC_PROOF.md'),
 inverse3=dict(raw=f'{INV3:016x}',value=str(kap),error_from_one_third=str(QQ(1)/3-kap)),
 split_map=dict(parent_root_order=4608,child_root_order=1536,child_exponents=roots,all256=True,parent_slots='3j,3j+1,3j+2; imag+768',child_slots='j; imag+256',normalization='source kappa=div_C(1,of_C(3)); exact reference1/3'),
 twiddle_audit=dict(cubic_pairs=256,fixed_components=4,component_error_lt=str(eps),max_RBF256=str(maxerr)),
 exact_identities=dict(unitary_scaled_by3=True,H_equals_phased_spectral_Gram=True,determinant='abc',pivots=['e1/3','e2/e1','3abc/e2']),
 root_consumed={r:sha(I/r) for r in ['ROOT/ROOT_CERTIFICATE.json','ROOT/ANALYTIC_PROOF.md','ROOT/EMITTED_BINDING.md','ROOT/ROOT_FRAME.md','ROOT/artifacts/numeric_certificate.json']},
 root_values=dict(real_comparison_min=str(mhat),real_comparison_max=str(Mhat),complex_error_envelope=str(Eroot)),
 full_node3_theorem_kernelized=False,universal_source_composition='ANALYTICAL_WITH_EXACT_CERTIFICATES_AND_KERNEL_INTEGER_LEMMAS')
(W/'artifacts/numeric_certificate.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps(dict(status=out['status'],inverse3=out['inverse3'],constants=[{k:v for k,v in r.items() if not k.startswith('checked_')} for r in records]),indent=2))
