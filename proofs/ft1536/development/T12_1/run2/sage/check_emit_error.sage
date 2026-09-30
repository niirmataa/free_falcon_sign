from pathlib import Path
import json
from sage.version import version as sage_version
assert sage_version == '10.9'
assert parent(1) is ZZ and parent(1/3) is QQ and 2^10 == 1024

def chi(J,P):
    if any(p==0 and j!=0 for j,p in zip(J,P)):
        return Infinity
    return sum(j^2/p for j,p in zip(J,P) if p!=0)-1

checks=[]
for pi in [QQ(0),QQ(1/16),QQ(1/2),QQ(1)]:
    for b in [QQ(0),QQ(1/7),QQ(1/2),QQ(1)]:
        L=[b,(1-b)/3,2*(1-b)/3]
        K=[1-pi+pi*b]+[pi*x for x in L[1:]]
        d=chi(L,K)
        if pi>0:
            abort_term=QQ(0) if K[0]==0 else b^2/K[0]
            exact=(1-b)/pi+abort_term
            assert 1+d==exact and exact<=1/pi
        else:
            assert (d==0 if b==1 else d is Infinity)
        checks.append(dict(pi=str(pi),b=str(b),chi2=str(d)))

# Exact trial masses, Emit merges one terminal success with abort.
trial=[QQ(1/3),QQ(1/6),QQ(1/2)] # retry, emitted abort, positive response
pi=1-trial[0]^16
b=trial[1]/(1-trial[0])
K_abort=trial[0]^16+sum(trial[0]^i*trial[1] for i in range(16))
assert K_abort==1-pi+pi*b
assert sum(trial[0]^i*trial[2] for i in range(16))==pi*(1-b)

# Uniform bound for ALL h. These are endpoints of a very loose envelope,
# NOT an evaluation of the actual failure probability delta(h).
N=ZZ(1536);q=ZZ(18433);side=ZZ(131071);B=ZZ(2093922385)
D=q^N*side^(2*N)
E=QQ(2051350378)/(2*768^2)
assert q<=2^15 and side<=2^17
assert D<=2^75264 and E<1740
assert 2*1740+75264==78744
R=RealBallField(512)
log2_D=R(D).log()/R(2).log()
log2_lb=-R(E)/R(2).log()-log2_D
log10_lb=-R(E)/R(10).log()-R(D).log()/R(10).log()
margin_log10=-R(D).log()/R(10).log()
coarse_lower=R(2)^(-78744)
coarse_margin=R(2)^(-75264)
assert coarse_lower>0 and coarse_margin>0
assert log2_lb>-78744
assert log2_D<75264
result=dict(schema='RUN002_EMIT_AND_UNIFORM_ERROR_V1',sage=sage_version,
    preparser=True,domains=['ZZ','QQ','RealBallField512'],mixture_checks=checks,
    emit_example=dict(pi=str(pi),b=str(b),K_abort=str(K_abort)),
    total_error_definition='delta(h)=sum_c U(c)*(sum_i<16 rejection(h,c)^i)*tBad(h,c)',
    uniform_envelope=dict(kernel='Run2.UniformErrorBound.binary_envelope',
        lower='2^(-78744)',upper='1-2^(-75264)',
        exact_lower_expression='exp(-2051350378/1179648)/(18433^1536*131071^3072)',
        exact_upper_expression='1-1/(18433^1536*131071^3072)',
        log2_D=str(log2_D),log2_lower_expression=str(log2_lb),
        log10_lower_expression=str(log10_lb),log10_upper_complement=str(margin_log10),
        coarse_lower_RBF512=str(coarse_lower),coarse_upper_complement_RBF512=str(coarse_margin),
        is_tight=False,determines_actual_error_size=False,
        conclusion='Envelope essentially spans [0,1]; no smallness or largeness conclusion.'),
    next_obligation='Certified nontrivial uniform upper bound on firstBad(h); existing bound is too loose.')
Path('error_certificate.json').write_text(json.dumps(result,indent=int(2),sort_keys=True)+'\n')
Path('generated').mkdir(exist_ok=True)
Path('generated/NumericCertificate.lean').write_text('''import Run2.UniformErrorBound
namespace FT1536.Run2.NumericCertificate
theorem arithmetic : (18433 : ℕ) ≤ 2^15 ∧ (131071 : ℕ) ≤ 2^17 ∧
  (2051350378 : ℚ)/1179648 < 1740 ∧ (2*1740+75264 : ℕ)=78744 := by norm_num
theorem uniform_envelope (h : FT1536.Relation.Rq) :
  (1 : ℝ)/2^78744 ≤ CorrectnessProbability.delta h ∧
  CorrectnessProbability.delta h ≤ 1-(1 : ℝ)/2^75264 :=
  UniformErrorBound.binary_envelope h
end FT1536.Run2.NumericCertificate
''')
print('EMIT_AND_ERROR_CONTROLS_PASS')
print(json.dumps(result,sort_keys=True))
