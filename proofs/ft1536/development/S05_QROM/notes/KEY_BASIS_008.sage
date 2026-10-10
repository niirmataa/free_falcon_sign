# sage KEY_BASIS_008.sage OUTDIR
# Exact discriminators for the pinned coefficientGram/scalarSplit definitions.
import json,sys
from pathlib import Path
out=Path(sys.argv[1]);out.mkdir(parents=True,exist_ok=True)
assert not (out/'certificate.json').exists()
R=PolynomialRing(QQ,names=('x','y','a','b','lam'));x,y,a,b,lam=R.gens()
def norm(x,y):return x*x+x*y+y*y
def polar(x,y,u,v):return x*u+(x*v+y*u)/2+y*v
assert norm(-y,x+y)==norm(x,y)
assert polar(x,y,-y,x+y)==norm(x,y)/2
# LDL(a2Gram(lam))=(lam,3*lam/4); reversal is NOT the same LDL list.
F=R.fraction_field()
assert F(lam-(lam/2)^2/lam)==3*lam/4
assert R.ideal([lam-3*a/4,3*lam/4-a]).reduce(lam)==0
assert R.ideal([lam-3*a/4,3*lam/4-a]).reduce(a)==0
assert norm(x+a,y+b)==(x+a+(y+b)/2)^2+QQ(3)/4*(y+b)^2

# Actual quotient-ring first columns, not a free unrelated 2x2 matrix.
checks=[]
for m in [1,3,6,768]:
 P=PolynomialRing(QQ,'X');X=P.gen();phi=X^(2*m)-X^m+1
 def pairs(v):return [(v[i],v[i+m]) for i in range(m)]
 def Q(v):return sum(norm(ZZ(aa),ZZ(bb)) for aa,bb in pairs(v))
 def bil(v,w):return sum(polar(aa,bb,cc,dd) for (aa,bb),(cc,dd) in zip(pairs(v),pairs(w)))
 for tag,f,g in [('unit',P.one(),P.zero()),('dense',P([(-1)^(i%3)*(i%2) for i in range(2*m)]),P([(i%3)-1 for i in range(2*m)]))]:
  if f==g==0:continue
  f1=(f*X^m)%phi;g1=(g*X^m)%phi
  for v,w in [(f,f1),(g,g1)]:
   assert pairs(w)==[(-bb,aa+bb) for aa,bb in pairs(v)]
  l=QQ(Q(f)+Q(g));assert l>0
  gram=matrix(QQ,[[l,QQ(bil(f,f1)+bil(g,g1))],[QQ(bil(f,f1)+bil(g,g1)),QQ(Q(f1)+Q(g1))]])
  assert gram==matrix(QQ,[[l,l/2],[l/2,l]])
  piv=[gram[0,0],gram[1,1]-gram[0,1]^2/gram[0,0]]
  assert piv==[l,3*l/4]
  leaf=4*l/3
  assert piv!=[3*leaf/4,leaf]
  checks.append({'half_degree':int(m),'fixture':tag,'first_pivots':[str(v) for v in piv],'root_assumption_instantiated':False})
# Correct LDL order vs reversed summation: shear is essential for the atom.
# diag(1,1) and shear Gram have identical LDL pivots but different atom at (0,1).
G=matrix(QQ,[[1,QQ(1)/2],[QQ(1)/2,QQ(5)/4]])
assert [G[0,0],G[1,1]-G[1,0]*G[0,1]/G[0,0]]==[1,1]
assert (vector(QQ,[0,1])*G*vector(QQ,[0,1]))==QQ(5)/4
assert sum(t*t for t in [QQ(0),QQ(1)])==1

result={'status':'EXACT_SYMBOLIC_IDENTITIES_AND_FINITE_SOURCE_ORDER_DISCRIMINATORS',
 'universal_symbolic_identities':['A2 rotation preserves norm','A2 rotation has inner product half norm','first two pivots are [lam,3lam/4]','equality to [3a/4,a] forces lam=a=0','affine complete-square identity'],
 'quotient_ring_checks':checks,
 'diagnosis':'scalarSplit starts [3a/4,a] but unitCoeff starts the A2 pair with pivots [lam,3lam/4]; a positive ldl_shape cannot use this order',
 'scope':'Universal source interpretation supplied by textual proof; no emitted-key counterexample or QROM insecurity inferred',
 'tower_warning':'Pivots alone do not determine atom; cross-coordinate shifts required',
 'kernel':False,'sampler007_conditional_theorem_refuted':False}
(out/'certificate.json').write_text(json.dumps(result,indent=2,default=int)+'\n')
print('PASS exact algebra and',len(checks),'quotient fixtures; first-pivot order incompatible with positive scalarSplit')
