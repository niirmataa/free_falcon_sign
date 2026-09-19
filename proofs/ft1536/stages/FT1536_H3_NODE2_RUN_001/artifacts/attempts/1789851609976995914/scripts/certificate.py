"""New upstream imaginary refinement and uniform first-binary-level c2; exact QQ/RBF algebra."""
import json,sys
from pathlib import Path
sys.path.insert(0,str(Path.cwd()/'scripts'))
from sage.all import QQ,PolynomialRing,RealBallField
from root_model import tables
from dyadic import value
from replaylib import sha,verify_manifest
W=Path.cwd();I=W/'inputs/bootstrap';verify_manifest(I,'MANIFEST.sha256','f92dbaa6f4262f2cce5d4bd27e002da0f684f87a92fef8619bee226221782178')
root=json.loads((I/'ROOT/artifacts/numeric_certificate.json').read_text());n3=json.loads((I/'NODE3/artifacts/numeric_certificate.json').read_text())
u=QQ(1)/2**48;eta=QQ(1)/2**900;eps=QQ(1)/2**50;half_eta=QQ(1)/2**1023
gamma=8*u;jmax=QQ(root['derived']['jhatmax']);K=(1+gamma)**2/(1-gamma)
# Bound imag of c0*conj(div(c0,a0)), without the unrelated real Schur error.
mul_im=(7*u+6*u*u)*K+4*((2+12*u)*eta*2**35+8*eta)
root_im=(1+u)*mul_im+4*eta
assert root_im<8*u and 8*u*jmax<1
node_im=[[QQ(0),64*u*2**24,64*u*2**24],[QQ(17)/16,QQ(17)/16+64*u*2**33,QQ(17)/16+64*u*2**33]]
assert node_im[0][1]==QQ(1)/262144 and node_im[1][1]==QQ(545)/512
# Only used square twiddles, with actual NODE3 physical parent order.
square,_,_=tables(W);R=RealBallField(256);pi=R.pi();roots=[];maximum=R(0)
def br(j):return int(format(j,'07b')[::-1],2)
for f in range(128):
 e=1+6*br(f);roots.append(e)
 assert n3['split_map']['child_exponents'][2*f]==e
 assert n3['split_map']['child_exponents'][2*f+1]==e+768
 theta=2*pi*e/1536
 for w,t in zip(square[256+f],[theta.cos(),theta.sin()]):
  a=value(w);d=abs(R(QQ(a.numerator)/a.denominator)-t);assert d<R(eps);maximum=max(maximum,d)
assert len(set(roots))==128 and {e%768 for e in roots}|{(-e)%768 for e in roots}=={e for e in range(768) if e%6 in [1,5]}
P=PolynomialRing(QQ,names=['ra','rb','ta','tb']);ra,rb,ta,tb=P.gens()
h=(ra+rb)/2;norm=((ra-rb)**2+(ta-tb)**2)/4
assert h*h-norm==ra*rb-(ta-tb)**2/4
assert ((ra+rb)**2-(ra-rb)**2)/4==ra*rb
def cmerr(M,e,d):return 2*M*d+2*e*(1+d)+6*u*(M+e)*(1+d)+4*eta
records=[]
for b in [0,1]:
 B=QQ(2**(26 if b==0 else 35));rmax=QQ(2**(25 if b==0 else 34));T=2*rmax
 m=QQ(1)/8 if b==0 else QQ(8);lam=QQ(1)/16 if b==0 else QQ(4);ds=B/2**40
 eadd=2*u*B+2*eta;spliterr=max(eadd/2+2*eta,cmerr(2*B,eadd,eps)+2*eta)
 assert half_eta<eta and spliterr<ds
 assert (1+u)*rmax+eta<T and 2*m*(1-u)-eta>QQ(1)/16 # real half input safely normal
 rp=u+2*eta+6*u*(1+u+2*eta)+8*eta/lam
 assert rp+u*(2+rp)+eta/lam<64*u and rp+u*(1+rp)+eta/lam<64*u
 ed=64*u*T;assert ed<lam/2 and lam>=QQ(1)/16 and T<=2**35
 for k in range(3):
  Im=node_im[b][k];assert m-Im-2*ds>lam and Im+ds<lam
  detmin=m*m-Im*Im;assert detmin>0
  parent=n3['constants'][b];E=QQ(parent[['t0_error_norm','d11_error_norm','d22_error_norm'][k]])
  er=E+ds;le=min(QQ(2),2*er/lam)+2*u;de=4*er+Im+ds+2*ed
  Lerr=[QQ(1)/16,QQ(1)/2,QQ(3)][k] if b==0 else QQ(3)
  Derr=[QQ(1)/128,QQ(1)/16,QQ(1)][k] if b==0 else QQ(2**[25,28,32][k])
  assert le<Lerr and de<Derr
  Iout=QQ(1)/8192 if b==0 else QQ(9)/8
  assert Im+ds+ed<Iout
  records.append(dict(branch=b,diagonal=k,input_real_lower=str(m),input_real_upper=str(rmax),input_imag_abs_upper=str(Im),input_complex_cap=str(B),
   split_rounding_norm_error=str(ds),split_error_to_exact_reference=str(er),pair_determinant_lower=str(detmin),comparison_eigen_lower=str(lam),
   s0_real_lower=str(lam),s0_real_upper=str(T),d11_real_lower=str(lam/2),d11_real_upper=str(2*T),
   s0_imag_abs_upper=str(Iout),d11_imag_abs_upper=str(Iout),L_norm_upper='2',L_error_norm=str(Lerr),d11_error_norm=str(Derr),
   source_L_error_to_H=str(2*u),source_d11_real_error_to_H=str(ed),source_imag_error_to_split_tau=str(ed),
   half_may_create_subnormal=True,split_imag_class='finite, possibly zero/subnormal/normal',d11_L_class='finite normal or zero; positive real pivot normal',
   div_denominator_interval=['1/16',str(2**35)],operand_abs_cap='2^100',intermediate_product_norm_upper=str(4*T),
   checked_split_round_error=str(spliterr),checked_eigen_margin=str(m-Im-2*ds)))
out=dict(schema='H3_NODE2_NUMERIC_CERTIFICATE_V1',status='PASS_UNIFORM_FIRST_BINARY_COMPOSITION',level=dict(split_logn=9,ldl_logn=8,full=0,positions='2*3*128'),constants=records,
 upstream_refinement=dict(root_imag_coefficient=str(root_im),root_imag_lt_8Uj=True,root_imag_uniform='1',root_8Ujmax=str(8*u*jmax),
  node3_imag=[[str(x) for x in r] for r in node_im],proof='UPSTREAM_REFINEMENT.md',old_certificates_unchanged=True),
 half=dict(error_bound=str(half_eta),both_zeros_map_to_positive_zero=True,exponent0_maps_to_positive_zero=True,exponent1_may_emit_subnormal=True,exponent_ge2_exact=True),
 map=dict(parent_order=1536,child_order=768,child_exponents=roots,parent_slots='2f,2f+1; imag+256',child_slots='f; imag+128',square_indices='256+f'),
 twiddle_audit=dict(pairs=128,component_error_lt=str(eps),max_RBF256=str(maximum)),
 exact_identity='h²-|u1|²=ra*rb-(ta-tb)²/4; real reference pivot=2ab/(a+b)',
 coarse_box_countermodel=dict(ra='9',rb='9',ta='34',tb='-34',determinant='-1075',pivot='-1075/9',classification='COUNTERMODEL_COARSE_NODE3_BOX_ONLY_NOT_P_KEY_OR_EMITTED'),
 proof_kind='MIXED_KERNEL_AND_UNIVERSAL_ANALYTICAL_SOURCE_PROOF',full_node2_theorem_kernelized=False,
 upstream_pins={r:sha(I/r) for r in ['NODE3/NODE3_CERTIFICATE.json','NODE3/ANALYTIC_PROOF.md','NODE3/artifacts/numeric_certificate.json','ROOT/ANALYTIC_PROOF.md','ROOT/artifacts/numeric_certificate.json']})
(W/'artifacts/numeric_certificate.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps(dict(status=out['status'],upstream_refinement=out['upstream_refinement'],constants=[{k:v for k,v in r.items() if not k.startswith('checked_')} for r in records]),indent=2))
