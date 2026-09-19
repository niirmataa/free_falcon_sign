"""Finite rank/exponent/remainder certificates for the universal analytical
source proof. Endpoints range over whole integer intervals, not samples."""
from sage.all import QQ,ZZ
import hashlib,json
from pathlib import Path
W=Path.cwd()
rank=[]
for k in range(64):
 lo=2**k;hi=2**(k+1)-1;shift=0;steps=[]
 for step in [32,16,8,4,2,1]:
  threshold=2**(64-step)
  lower=lo*2**shift;upper=hi*2**shift
  take=upper<threshold
  assert take or lower>=threshold
  steps.append(dict(step=step,shift=take,input_low=str(lower),input_high=str(upper),threshold=str(threshold)))
  if take:shift+=step
 assert shift==63-k and 2**63<=lo*2**shift<=hi*2**shift<2**64
 rank.append(dict(leading_bit=k,total_shift=shift,steps=steps))
pack=[]
for r in range(8):
 inc=(0xc8>>r)&1;error=4*(r//4+inc)-r;assert -2<=error<=2
 pack.append(dict(remainder8=r,rounding_bit=inc,error_in_mantissa_units=error))
maxerr=QQ(13)/2**24+QQ(1)/2**1021;E=QQ(1)/2**20
assert maxerr<E<QQ(1)/4
classes=0
for e in range(1055):
 lam=QQ(2)**(e-1078);assert lam<=QQ(1)/2**24
 for sh in range(7,64):
  muunit=QQ(2)**(e-1069-sh)
  assert muunit<=4*lam
  if e+7-sh<0:assert (ZZ(2)**55-1)*muunit<QQ(1)/2**1022
  else:assert 0<=e+7-sh<=1054
  classes+=1
# Integer OF: all31+1 nonzero magnitude ranks for signed32. Exact discarded bits.
ofranks=[]
for k in range(32):
 sh=63-k;assert sh>=32 and sh-9>=23
 assert 1022<=1085-sh<=1053
 ofranks.append(dict(magnitude_leading_bit=k,shift=sh,mantissa_low_zero_bits_at_pack=sh-9,pack_biased_base=1085-sh,exact=True))
out=dict(status='EXACT_CERTIFICATE_FOR_ANALYTICAL_PROOF',rank_cases=rank,rounding_cases=pack,add_exponent_shift_classes=classes,
 of_signed32_rank_classes=ofranks,alignment_bound='lambda=2^(ea-1078)',normalization_shrink_bound='<=4lambda',pack_bound='<=8lambda or underflow<2^-1022',
 decoded_exp0_total_error='<2^-1022',universal_add_envelope=str(maxerr),E_r=str(E),E_res=str(E),
 proof='ANALYTIC_PROOF.md: source branches and bit identities justify interval classes; no complete-IEEE model assumed.',
 finite_test_substitution=False)
(W/'artifacts/error_certificate.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps({k:v for k,v in out.items() if k not in ['rank_cases','rounding_cases','of_signed32_rank_classes']},indent=2))
