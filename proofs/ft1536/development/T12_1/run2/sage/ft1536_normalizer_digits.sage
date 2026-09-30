# Actual FT1536 parameters. Auxiliary normalizers, NOT delta(h).
# Analytic identities/tail proof are recorded as formalization obligations.
from pathlib import Path
import json
assert parent(1) is ZZ and parent(1/3) is QQ and 2^10==1024
R=RealBallField(768);C=ComplexBallField(768)
q=ZZ(18433);M=ZZ(65535);sigma=ZZ(768)
a=R(1)/(2*sigma^2)
tau=C(0,1)*C(a/R.pi())
th=C(0).jacobi_theta(tau)
th3=C(0).jacobi_theta(3*tau)
Ginf=(th[2]*th3[2]+th[1]*th3[1]).real()
assert Ginf>0
# Q(x,y)=(y+x/2)^2+3*x^2/4.
# Sup of a shifted one-dimensional Gaussian sum <=1+sqrt(2*pi)*sigma.
# Union over |x|>M or |y|>M; geometric majorant on the squared tail.
L=M+1
shift_bound=1+(2*R.pi()).sqrt()*sigma
first=(-R(3)*L^2/(8*sigma^2)).exp()
ratio=(-R(3)*(2*L+1)/(8*sigma^2)).exp()
tail=4*shift_bound*first/(1-ratio)
assert 0<ratio<1 and tail>0
Gbox=Ginf.add_error(tail)

def Q(x,y):return x*x+x*y+y*y
def lifts(c):return [ZZ(c+k*q) for k in range(ceil(QQ(-M-c)/q),(M-c)//q+1)]
def fiber1(c,d):
    return sum((-a*Q(x,y)).exp() for x in lifts(c) for y in lifts(d))
P0=fiber1(0,0)
P9=fiber1(9217,9217)
# h=0, c with9 active residue pairs and759 zero pairs:
Z_c=Gbox^768 * P9^9 * P0^759

def certified_rounding(ball,digits=100):
    assert ball>0
    log10=ball.log()/R(10).log()
    el=floor(log10.lower());eu=floor(log10.upper());assert el==eu
    scale=QQ(10)^(digits-1-el)
    lo=ball.lower().exact_rational();hi=ball.upper().exact_rational()
    il=floor(lo*scale+1/2);iu=floor(hi*scale+1/2)
    assert il==iu
    s=str(il)
    return dict(significant_digits=int(digits),decimal=s[0]+'.'+s[1:]+'e'+str(el),
        integer_mantissa=str(il),decimal_scale=str(digits-1-el),
        lower_rational=str(lo),upper_rational=str(hi))
result=dict(schema='FT1536_AUX_NORMALIZER_DIGITS_RESEARCH_V1',
    scope='auxiliary normalizers for actual FT1536 h=0/c-pattern; not error probability',
    precision_bits=int(768),Gbox=certified_rounding(Gbox),
    P0=certified_rounding(P0),P9=certified_rounding(P9),Z_c=certified_rounding(Z_c),
    truncation_tail_log10=str(tail.log()/R(10).log()),
    formal_obligations=['Jacobi theta factorization of infinite A2 sum',
        'shifted Gaussian sum integral bound and geometric rectangle tail',
        'binding of factorized h=0 coset normalizer to full BoxPair sum'],
    error_probability_computed=False)
Path('ft1536_normalizer_digits.json').write_text(json.dumps(result,indent=int(2),sort_keys=True)+'\n')
print('NORMALIZER_DIGITS_PASS_AUXILIARY_ONLY')
for name in ['Gbox','P0','P9','Z_c']:print(name,result[name]['decimal'])
print('tail_log10',result['truncation_tail_log10'])
