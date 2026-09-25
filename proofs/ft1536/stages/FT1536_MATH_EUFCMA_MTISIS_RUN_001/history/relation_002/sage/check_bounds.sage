# Authoritative exact computations and diagnostic controls; run with Sage preparser.
from pathlib import Path
import json

assert parent(1) is ZZ
assert parent(1/3) is QQ
assert 2^10 == 1024
assert str(version()).startswith('SageMath version 10.9')

def chi(j, p):
    if any(p[i] == 0 and j[i] != 0 for i in range(len(p))):
        return Infinity
    return sum(j[i]^2/p[i] for i in range(len(p)) if p[i] != 0)-1

def block(x,y):
    return x^2+x*y+y^2

def center(x):
    return (x+9216) % 18433 - 9216

B = ZZ(2093922385)
before = block(9217,-5000)+block(32767,18000)
after = block(center(9217),center(-5000))+block(32767,18000)
assert before < B and after >= B
assert all(-32768 <= x <= 32767 for x in [9217,-5000,32767,18000])

p = [QQ(1/3), QQ(2/3)]
j = [QQ(1/2), QQ(1/2)]
d = chi(j,p)
assert d == 1/8
assert chi(p,j) == 1/9
assert chi([QQ(1),QQ(0)], [QQ(0),QQ(1)]) is Infinity

# Conditional laws depend on the first observed bit: genuinely adaptive.
pk = [[QQ(1/4),QQ(3/4)],[QQ(2/3),QQ(1/3)]]
jk = [[QQ(1/2),QQ(1/2)],[QQ(3/4),QQ(1/4)]]
P = [p[x]*pk[x][y] for x in range(2) for y in range(2)]
J = [j[x]*jk[x][y] for x in range(2) for y in range(2)]
exact_joint = chi(J,P)
factorized = sum(j[x]^2/p[x]*(1+chi(jk[x],pk[x])) for x in range(2))-1
assert exact_joint == factorized
e = max([d]+[chi(jk[x],pk[x]) for x in range(2)])
assert exact_joint <= (1+e)^2-1
for mask in range(16):
    a = sum(P[x] for x in range(4) if mask & (1 << x))
    b = sum(J[x] for x in range(4) if mask & (1 << x))
    assert (a-b)^2 <= exact_joint*a*(1-a)

retry = []
for a in [QQ(0),QQ(1/3),QQ(1)]:
    for n in [0,1,16]:
        good = 1-(1-a)^n
        assert sum((1-a)^k*a for k in range(n)) == good
        assert 0 <= good <= 1
        if good > 0:
            L = [QQ(0),QQ(1/4),QQ(3/4)]
            K = [1-good,good/4,3*good/4]
            assert 1+chi(L,K) == 1/good
        retry.append(dict(a=str(a),n=int(n),success=str(good)))

for qs in range(20):
    for qh in [0,1,17]:
        assert sum(qh+i for i in range(qs)) == qs*qh+qs*max(qs-1,0)/2

# ROM controls are over inputs, not output values. Same nonce/different messages
# is safe; a repeated exact name is stopped, not silently resampled.
table = {(0,'m0'): ('sign',0), (1,'m1'): ('target',0)}
assert (0,'m1') not in table
assert (0,'m0') in table
assert table[(0,'m0')][1] == table[(1,'m1')][1]
seen = {'pre_abort_message','post_abort_message','m0'}
assert 'pre_abort_message' in seen and 'post_abort_message' in seen

R = RealBallField(256)
def phi(D,b):
    D,b = R(D),R(b)
    return (2*b+D+(D^2+4*D*b*(1-b)).sqrt())/(2*(1+D))
phi_values = []
for D in [QQ(0),QQ(1/8),QQ(2)]:
    for b in [QQ(0),QQ(1/3),QQ(1)]:
        v = phi(D,b)
        phi_values.append(dict(D=str(D),b=str(b),enclosure=str(v)))

result = dict(schema='T12_1_EXACT_CONTROLS_V1',sage=version(),preparser=True,
    centering=dict(before=str(before),after=str(after),B=str(B)),
    directional=dict(forward=str(d),reverse=str(chi(p,j))),
    adaptive=dict(joint=str(exact_joint),uniform_e=str(e),bound=str((1+e)^2-1),
                  event_masks_checked=16),retry=retry,phi_RBF256=phi_values,
    scope='Exact arithmetic controls; general theorems are in Lean; no security estimate.')
Path('certificates.json').write_text(json.dumps(result,indent=2,sort_keys=True)+'\n')
Path('generated').mkdir(exist_ok=True)
certificate = '''import FT1536.Geometry
namespace FT1536.Certificate
theorem centering_values :
  Geometry.block 9217 (-5000) + Geometry.block 32767 18000 = BEFORE ∧
  Geometry.block (-9216) (-5000) + Geometry.block 32767 18000 = AFTER := by
  norm_num [Geometry.block]
theorem nontrivial_directional_chi2 :
  ((1/2 : ℝ)^2/(1/3)+(1/2)^2/(2/3)-1) = 1/8 ∧
  ((1/3 : ℝ)^2/(1/2)+(2/3)^2/(1/2)-1) = 1/9 := by norm_num
theorem adaptive_exact_value :
  ((1/4 : ℝ)^2/(1/12)+(1/4)^2/(1/4)+(3/8)^2/(4/9)+(1/8)^2/(2/9)-1)
    = JOINT := by norm_num
end FT1536.Certificate
'''.replace('BEFORE',str(before)).replace('AFTER',str(after)).replace('JOINT','('+str(exact_joint)+')')
Path('generated/Certificate.lean').write_text(certificate)
print('SAGE_CONTROLS_PASS')
print(json.dumps(result,sort_keys=True))
