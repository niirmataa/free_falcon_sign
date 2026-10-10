# Authoritative bounded/exact checks for S05-015. Not a universal proof.
R = RealBallField(512)
eps=QQ(1)/2^34
boxloss=QQ(1)/2^160
L=1-eps-boxloss
U=1+eps
t=QQ(1811939328)/2093922385
r=1/t
a=(1-t)*QQ(2093922385)/1179648
# An upper log bound certified using a finite positive exponential sum.
ell=QQ(144665)/10^6
poly=sum(ell^k/factorial(k) for k in range(7))
checks={
 'positive_lower': L>0,
 'box_exp_budget': QQ(1700)*QQ(7)/10 < QQ(3584)/3,
 'ratio_budget': U/L < QQ(17)/16,
 'flatness_lower': (1-QQ(1)/2^32)*U<=L,
 'flatness_upper': U<=(1+QQ(1)/2^32)*L,
 'exp_polynomial_dominates_ratio': r<poly,
 'norm_exponent_budget': QQ(1536)*ell-a < -24*QQ(693147181)/10^9-QQ(1)/16,
}
rho=QQ(1)/2^32; u=QQ(1)/2^24; ki=1+QQ(1)/2^60
z=(rho+u)/(1-u)
moment=ki^2*(1+z^2)/(1-u^16)
checks['full_second_budget']=moment<1+QQ(1)/2^44
checks['strengthened_second_budget']=moment<1+QQ(1)/2^47
checks['next_dyadic_budget_fails_for_this_envelope']=moment>1+QQ(1)/2^48
for name,value in checks.items():
 print(name, bool(value)); assert value
print('log_ratio_ball', R(r).log())
print('tail_ball', (R(U/L)*(-R(a)).exp()*R(r)^1536))
print('moment_excess_ball', R(moment-1))
print('PASS',len(checks),'exact rational certificates; balls diagnostic only')
