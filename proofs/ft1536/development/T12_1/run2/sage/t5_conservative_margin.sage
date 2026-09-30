# Recompute the T5 arithmetic margin with the conservative H3 error contract.
# This checks arithmetic of that implication; it does not substitute for its
# source-domain and graph-lattice proofs.
from pathlib import Path
import json
assert parent(1) is ZZ and parent(1/3) is QQ
R=RealBallField(512)
u=QQ(1)/2^48;eps=QQ(1)/2^50;tiny=QQ(1)/2^900
def cmul(m,e,ce):
    return 2*m*ce+2*e*(1+ce)+5*u*(m+e)*(1+ce)+5*tiny
m=QQ(2);err=eps
for j in range(8):
    me=cmul(m,err,eps)
    err=err+me+u*(3*m+err+me)+tiny
    m*=3
b1=cmul(m,err,eps);b2=cmul(2*m,b1,eps)
square=cmul(QQ(1),eps,eps)
c1=cmul(m,err,square);c2=cmul(2*m,c1,eps)
bc=b2+c2+u*(4*m+b2+c2)+tiny
err=err+bc+u*(5*m+err+bc)+tiny
N=ZZ(1536)
sq=2*N*err+err^2+u*(N+err)^2+tiny
norm=2*sq+u*(2*(N+err)^2*(1+u))+tiny
g00=2*norm+u*(4*(N+err)^2*(1+u)^2)+tiny
assert g00<1/64
minus=1-u;plus=1+u
lo=minus^20/plus^11;hi=plus^20/minus^11
bridge=min((31/32)/hi,(32/33)*lo/plus)
word=ZZ(0x4090000053700377)
exponent=(word>>52)&0x7ff;frac=word%2^52
machine=(2^52+frac)*QQ(2)^(exponent-1023-52)
lower=machine*bridge
assert lower>991
result=dict(schema='T5_CONSERVATIVE_ARITHMETIC_MARGIN_V1',
    u=str(u),twiddle_error=str(eps),absolute_floor=str(tiny),
    fft_error=str(R(err)),g00_error=str(R(g00)),g00_lt_1_over_64=True,
    gate_minimum_exact=str(machine),exact_leaf_lower=str(R(lower)),leaf_gt_991=True,
    scope='Exact QQ propagation of existing T5 recurrence with u=2^-48; source-domain and tower bindings required',
    no_new_key_filter=True)
Path('t5_conservative_margin.json').write_text(json.dumps(result,indent=int(2),sort_keys=True)+'\n')
print('T5_MARGIN_PASS',json.dumps(result,sort_keys=True))
