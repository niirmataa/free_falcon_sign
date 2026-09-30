# Actual parameters; numerical component computation by explicit 1D series.
# No finite Gaussian surrogate is substituted for the model.
from pathlib import Path
import json
assert parent(1) is ZZ and parent(1/3) is QQ
R=RealBallField(768);sigma=ZZ(768);M=ZZ(65535);q=ZZ(18433)
alpha=R(1)/(2*sigma^2);cut=ZZ(20000)

def upper_tail(a,L):
    r=(-a*(2*L+1)).exp();f=(-a*L^2).exp()
    mass=f/(1-r)
    moment=f*(L^2/(1-r)+2*L*r/(1-r)^2+r*(1+r)/(1-r)^3)
    return mass,moment

def series(mult,half):
    a=mult*alpha
    if half:
        S=R(0);H=R(0)
        for n in range(cut+1):
            x=QQ(n)+1/2;w=(-a*x^2).exp()
            S+=2*w;H+=2*x^2*w
        L=R(cut)+3/2
    else:
        S=R(1);H=R(0)
        for n in range(1,cut+1):
            w=(-a*n^2).exp();S+=2*w;H+=2*n^2*w
        L=R(cut+1)
    tail,tailH=upper_tail(a,L)
    print('SERIES_DONE',mult,bool(half),flush=True)
    return S.add_error(2*tail),H.add_error(2*tailH)

U,H=series(1,False);U3,H3=series(3,False)
V,J=series(1,True);V3,J3=series(3,True)
Ginf=U*U3+V*V3
Hinf=H*U3+3*U*H3+J*V3+3*V*J3
shiftS=1+(2*R.pi()).sqrt()*sigma
shiftH=(2*R.pi()).sqrt()*sigma^3+4*sigma^2
tailA,tailA2=upper_tail(R(3)/(8*sigma^2),R(M+1))
tailG=4*shiftS*tailA
tailH=4*(shiftH*tailA+R(3)/4*shiftS*tailA2)
Gbox=Ginf.add_error(tailG)
Hbox=Hinf.add_error(tailH)
mean=Hbox/Gbox
assert mean>0 and mean<R(1179650)

def rounding(ball,digits=100):
    lg=ball.log()/R(10).log();e=floor(lg.lower());assert e==floor(lg.upper())
    scale=QQ(10)^(digits-1-e)
    lo=ball.lower().exact_rational();hi=ball.upper().exact_rational()
    k=floor(lo*scale+1/2);assert k==floor(hi*scale+1/2)
    s=str(k)
    return dict(decimal=s[0]+'.'+s[1:]+'e'+str(e),digits=int(digits),
        lower=str(lo),upper=str(hi),integer_mantissa=str(k),scale=str(digits-1-e))

def Q(x,y):return x*x+x*y+y*y
def lifts(c):return [ZZ(c+k*q) for k in range(ceil(QQ(-M-c)/q),(M-c)//q+1)]
def fiber(c,d):return sum((-alpha*Q(x,y)).exp() for x in lifts(c) for y in lifts(d))
P0=fiber(0,0);P9=fiber(9217,9217)
mode_mass=((2*(-alpha*84943873).exp())/P9)^9/P0^759
T=ZZ(2093922385)-9*84943873
# These last quantities are explicit bounds, not the requested delta value.
# They demonstrate the difference between conditioned and uniform-target error.
signed_tail,_=upper_tail(R(3)/(8*sigma^2),R(32768))
sign_failure=1536*2*shiftS*signed_tail/Gbox
one_success_lower=mode_mass*(1-768*mean/T-sign_failure)
cap_nonabort_lower=1-(1-one_success_lower)^16-16*sign_failure
assert cap_nonabort_lower>99/100
result=dict(schema='FT1536_EXPLICIT_SERIES_COMPONENTS_V1',
    scope='auxiliary exact-model normalizer/moment enclosures; NOT total delta(h)',
    precision_bits=int(768),series_cut=int(cut),Gbox=rounding(Gbox),Hbox=rounding(Hbox),mean_block_Q=rounding(mean),
    selected_h0_target=dict(active_blocks=int(9),mode_mass=str(mode_mass),
        cap_nonabort_lower=str(cap_nonabort_lower),
        interpretation='For this fixed rare target, every emitted positive signature fails Verify; this is not a lower bound of .99 on the uniform-target game.'),
    analytic_proof_obligations=['sum factorization by parity','Gaussian unimodal sum bounds',
        'outer-tail union and positive-series remainders','h=0 product law','Markov and cap/Emit loss binding'],
    kernel_complete=False,total_error_probability_computed=False)
Path('ft1536_series_moments.json').write_text(json.dumps(result,indent=int(2),sort_keys=True)+'\n')
print('SERIES_COMPONENTS_PASS')
for name in ['Gbox','Hbox','mean_block_Q']:print(name,result[name]['decimal'])
print('FIXED_TARGET_BOUND_NOT_GLOBAL',cap_nonabort_lower)
