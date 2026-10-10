# sage SCHUR_012.sage OUTDIR
# Exact finite controls for the universal Lean matrix statements.
import json,sys
from pathlib import Path
out=Path(sys.argv[1]);out.mkdir(parents=True,exist_ok=True)
assert not (out/'checks.json').exists()
def step(G):
 if G.nrows()==0:return G
 return G[1:,1:]-G[0:1,1:].transpose()*G[0:1,1:]/G[0,0]
def piv(G):return [] if G.nrows()==0 else [G[0,0]]+piv(step(G))
def expansion(G,x):
 if G.nrows()==0:return QQ(0)
 tail=vector(QQ,x[1:]);offset=(G[0:1,1:]*tail)[0]/G[0,0]
 return G[0,0]*(x[0]+offset)^2+expansion(step(G),tail)
scalar=0;blocks=0
for n in range(8):
 for seed in [1,2,5]:
  M=matrix(QQ,n,n,lambda i,j:QQ(((i+1)*(j+2)+seed)%7-3)/3)
  G=M.transpose()*M+identity_matrix(QQ,n)
  ps=piv(G);assert len(ps)==n and all(x>0 for x in ps)
  if n:assert max(ps)<=max(G[i,i] for i in range(n))
  x=vector(QQ,[QQ(i-seed, )/5 for i in range(n)])
  assert (x*G*x)==expansion(G,x)
  scalar+=1
  for m in range(n+1):
   A=G[:m,:m];B=G[:m,m:];D=G[m:,m:]
   C=D-B.transpose()*A.inverse()*B
   u=vector(QQ,x[:m]);v=vector(QQ,x[m:]);shift=u+A.inverse()*B*v
   assert u*A*u+2*u*B*v+v*D*v==shift*A*shift+v*C*v
   assert piv(G)==piv(A)+piv(C)
   assert all(C[i,i]<=D[i,i] for i in range(n-m))
   blocks+=1
# Large off-diagonal terms show why two-block bounds are weaker than a
# small diagonal bound on the entire coefficient Gram.
G=matrix(QQ,[[1,100],[100,10001]])
assert piv(G)==[1,1] and G[1,1]>1 and step(G)[0,0]==1
assert vector(QQ,[0,1])*G*vector(QQ,[0,1])!=1
A2=matrix(QQ,[[4,2],[2,4]])
assert piv(A2)==[4,3] and piv(A2)!=[3,4]
spectral=[]
for m in [1,3,6]:
 n=2*m;K=CyclotomicField(6*m);z=K.gen();roots=[z^r for r in range(6*m) if r%6 in [1,5]]
 V=matrix(K,[[r^j for j in range(n)] for r in roots])
 weights=[QQ(1000+i) for i in range(n)]
 H=n/sum(1/w for w in weights)
 form=V.conjugate().transpose()*diagonal_matrix(K,weights)*V/n
 dual=V.conjugate().transpose()*diagonal_matrix(K,[QQ(18433)^2/w for w in weights])*V/n
 assert all(QQ(form[j,j])==sum(weights)/n for j in range(n))
 assert all(QQ(dual[j,j])==QQ(18433)^2/H for j in range(n))
 assert H>991 and all(QQ(dual[j,j])<QQ(18433)^2/991 for j in range(n))
 spectral.append({'degree':int(n),'harmonic':str(H)})
(out/'checks.json').write_text(json.dumps({'status':'PASS_EXACT_FINITE_CONTROLS','condition_class':'proof_obligation','conditions':['Q-SAMPLER'],
 'scalar_cases':int(scalar),'block_partitions':int(blocks),'spectral_cases':spectral,
 'empty_dimension_checked':True,'wrong_pivot_order_detected':True,'omitted_shear_detected':True,
 'scope':'Finite controls supplement universal kernel lemmas; no actual FT1536 coefficient-Gram/source binding or QROM theorem'},indent=2)+'\n')
print('PASS:',scalar,'scalar cases,',blocks,'block partitions and3 exact spectral cases')
