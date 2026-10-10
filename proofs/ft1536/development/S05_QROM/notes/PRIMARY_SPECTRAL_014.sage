# sage PRIMARY_SPECTRAL_014.sage FRESH_OUTPUT_DIRECTORY
# Exact finite controls; low-dimensional tests are not the FT1536 theorem.
import json,sys
from pathlib import Path
out=Path(sys.argv[1]);out.mkdir(parents=True,exist_ok=True)
assert not (out/'checks.json').exists()
P=PolynomialRing(QQ,'X');X=P.gen();q=ZZ(18433);cases=[];shift_checks=0
negative={'naive_wrap_quotient_mismatch':False,'wrong_fourier_normalization':False,'drop_cross_block':False}
norm_only_insufficient=True
for m in [1,3,6]:
 n=2*m;phi=X^n-X^m+1
 idx=[(half,component,j) for half in [0,1] for component in [0,1] for j in range(m)]
 local=[(half,j) for half in [0,1] for j in range(m)]
 primary=[k for k,(_,c,_) in enumerate(idx) if c==0];secondary=[k for k,(_,c,_) in enumerate(idx) if c==1]
 perm=primary+secondary
 H=matrix(QQ,4*m,lambda a,b: (QQ(1) if idx[a][0]==idx[b][0] else QQ(1)/2) if idx[a][1:]==idx[b][1:] else QQ(0))
 H0=H.matrix_from_rows_and_columns(primary,primary)
 def pack(z):return vector(QQ,[z[c][j+half*m] for half,c,j in idx])
 def unpack(v):return tuple(sum(P(v[k])*X^(j+half*m) for k,(half,cc,j) in enumerate(idx) if cc==c) for c in [0,1])
 def norm0(v):return sum(v[j]^2+v[j]*v[j+m]+v[j+m]^2 for j in range(m))
 def basis(f,g,F,G,u):return ((g*u[0]+G*u[1])%phi,(-f*u[0]-F*u[1])%phi)
 K=CyclotomicField(6*m);zeta=K.gen();roots=[zeta^r for r in range(6*m) if r%6 in [1,5]]
 V=matrix(K,[[z^(j+half*m) for half,j in local] for z in roots])
 assert V.conjugate().transpose()*V/n==H0.change_ring(K)
 assert all(z^n-z^m+1==0 and z.conjugate()*z==1 for z in roots)
 for seed in [1,2,5]:
  f=P(1);g=sum(ZZ((j+seed)%3-1)*X^j for j in range(n));F=sum(ZZ((2*j+seed)%5-2)*X^j for j in range(n));G=(q+g*F)%phi
  for v in [f,g,F,G]:
   for power in range(6*m+2):assert norm0((X^power*v)%phi)==norm0(v);shift_checks+=1
  units=[unpack(vector(QQ,[1 if j==k else 0 for j in range(4*m)])) for k in range(4*m)]
  M=matrix(QQ,[pack(basis(f,g,F,G,u)) for u in units]).transpose()
  gram=(M.transpose()*H*M).matrix_from_rows_and_columns(perm,perm)
  A=gram[:n,:n];C=gram[:n,n:];D=gram[n:,n:];S=D-C.transpose()*A.inverse()*C
  diagonal=norm0(f)+norm0(g)
  assert all(A[j,j]==diagonal for j in range(n)) and diagonal<=6*m
  weights=[K(f(z))*K(f(z)).conjugate()+K(g(z))*K(g(z)).conjugate() for z in roots]
  assert all(w!=0 for w in weights)
  spectralA=V.conjugate().transpose()*diagonal_matrix(K,weights)*V/n
  spectralS=V.conjugate().transpose()*diagonal_matrix(K,[q^2/w for w in weights])*V/n
  assert spectralA==A.change_ring(K) and spectralS==S.change_ring(K)
  harmonic=QQ(n/sum(1/w for w in weights))
  assert harmonic>0 and all(S[j,j]==q^2/harmonic for j in range(n))
  negative['wrong_fourier_normalization'] |= bool(V.conjugate().transpose()*diagonal_matrix(K,weights)*V!=A.change_ring(K))
  negative['drop_cross_block'] |= bool(D!=S)
  cases.append({'degree':int(n),'seed':int(seed),'primary_diagonal':str(diagonal),'harmonic':str(harmonic),
   'schur_diagonal':str(S[0,0]),'harmonic_991_premise_holds':bool(harmonic>=991)})
 v=X^(n-1)+X^(m-1)
 naive=(X*v)%(X^n-1)
 negative['naive_wrap_quotient_mismatch'] |= bool(naive!=(X*v)%phi)
 norm_only_insufficient &= bool(norm0(naive)==norm0(v))
assert all(negative.values())
assert norm_only_insufficient
(out/'checks.json').write_text(json.dumps({'status':'PASS_EXACT_FINITE_PRIMARY_SPECTRAL_CONTROLS',
 'condition_class':'proof_obligation','conditions':['Q-SAMPLER'],'cases':cases,'monomial_shift_cases':int(shift_checks),
 'negative_controls':negative,'norm_only_cannot_certify_quotient':bool(norm_only_insufficient),
 'scope':'Synthetic degrees2/6/12; exact cyclotomic arithmetic. Not emitted FT1536 keys, not a universal Parseval proof, not a small moment certificate.'},indent=2)+'\n')
print('PASS',len(cases),'primary/spectral cases;',shift_checks,'shifts;',negative)
