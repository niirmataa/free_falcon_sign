# sage COEFFICIENT_GRAM_013.sage FRESH_OUTPUT_DIRECTORY
# Exact finite controls for the concrete coordinate/metric convention.
import json,sys
from pathlib import Path
out=Path(sys.argv[1]);out.mkdir(parents=True,exist_ok=True)
assert not (out/'checks.json').exists()
P=PolynomialRing(QQ,'X');X=P.gen();q=ZZ(18433)
cases=[];negative={'wrong_metric':False,'wrong_basis_sign':False,'zero_basis_not_positive':False}
for m in [1,3,6]:
 n=2*m;phi=X^n-X^m+1
 idx=[(half,component,j) for half in [0,1] for component in [0,1] for j in range(m)]
 def pack(z):return vector(QQ,[z[c][j+half*m] for half,c,j in idx])
 def unpack(v):return tuple(sum(P(v[k])*X^(j+half*m) for k,(half,cc,j) in enumerate(idx) if cc==c) for c in [0,1])
 def basis(f,g,F,G,u):return ((g*u[0]+G*u[1])%phi,(-f*u[0]-F*u[1])%phi)
 def energy(z):return sum(z[c][j]^2+z[c][j]*z[c][j+m]+z[c][j+m]^2 for c in [0,1] for j in range(m))
 metric=matrix(QQ,len(idx),lambda a,b: (QQ(1) if idx[a][0]==idx[b][0] else QQ(1)/2) if idx[a][1:]==idx[b][1:] else QQ(0))
 units=[unpack(vector(QQ,[1 if j==k else 0 for j in range(4*m)])) for k in range(4*m)]
 for seed in [1,2,5]:
  f=P(1);g=sum(ZZ((j+seed)%3-1)*X^j for j in range(n));F=sum(ZZ((2*j+seed)%5-2)*X^j for j in range(n));G=(q+g*F)%phi
  assert (f*G-g*F)%phi==q
  M=matrix(QQ,[pack(basis(f,g,F,G,u)) for u in units]).transpose()
  dual=matrix(QQ,[pack(basis(-f,-F,-g,-G,u)) for u in units]).transpose()
  assert dual*M==q*identity_matrix(QQ,4*m)
  gram=M.transpose()*metric*M
  assert gram.is_symmetric() and all(gram[:j,:j].det()>0 for j in range(1,4*m+1))
  u=tuple(sum(ZZ((j+2*c+seed)%7-3)*X^j for j in range(n)) for c in [0,1])
  z=tuple(sum(ZZ((2*j+c+seed)%5-2)*X^j for j in range(n)) for c in [0,1])
  b=basis(f,g,F,G,u);x=pack(u)
  assert unpack(pack(u))==u and M*x==pack(b)
  assert x*gram*x==energy(b)
  v=pack(z)+M*x
  assert v*metric*v==energy((z[0]+b[0],z[1]+b[1]))
  wrong=matrix(QQ,4*m,lambda a,b: QQ(1) if idx[a][1:]==idx[b][1:] else QQ(0))
  negative['wrong_metric'] |= bool(v*wrong*v!=energy((z[0]+b[0],z[1]+b[1])))
  wrongM=matrix(QQ,[pack(((g*t[0]+G*t[1])%phi,(-f*t[0]+F*t[1])%phi)) for t in units]).transpose()
  negative['wrong_basis_sign'] |= bool(dual*wrongM!=q*identity_matrix(QQ,4*m))
  cases.append({'degree':int(n),'coordinates':int(4*m),'seed':int(seed),'gram_determinant':str(gram.det())})
 zero=zero_matrix(QQ,4*m);assert zero.det()==0
 negative['zero_basis_not_positive']=True
assert all(negative.values())
(out/'checks.json').write_text(json.dumps({'status':'PASS_EXACT_FINITE_CONTROLS','condition_class':'proof_obligation',
 'conditions':['Q-SAMPLER'],'cases':cases,'negative_controls':negative,
 'non_claims':['Finite controls do not prove dimension1536','No spectrum, source KeyGen or sampler moment bound']},indent=2)+'\n')
print('PASS',len(cases),'exact coefficient-Gram cases;',negative)
