# sage HARMONIC_BRIDGE_009.sage OUTDIR
# Exact arithmetic: a replacement for the uninhabitable scalar-list interface.
import json,sys,hashlib
from pathlib import Path
out=Path(sys.argv[1]);out.mkdir(parents=True,exist_ok=True)
assert not (out/'certificate.json').exists()
q=ZZ(18433);limit=QQ(q^2)/991
assert 4608<limit
S=PolynomialRing(QQ,names=('a','b','c'));a,b,c=S.gens();K=S.fraction_field()
assert 1/K(2*a*b/(a+b))==(1/a+1/b)/2
assert 1/K(3*a*b*c/(a*b+a*c+b*c))==(1/a+1/b+1/c)/3

def binary(xs):
 if len(xs)==1:return xs
 return binary([(a+b)/2 for a,b in zip(xs[::2],xs[1::2])])+binary([2*a*b/(a+b) for a,b in zip(xs[::2],xs[1::2])])
def primary(xs):
 triples=list(zip(xs[::3],xs[1::3],xs[2::3]))
 return binary([(a+b+c)/3 for a,b,c in triples])+binary([(a*b+a*c+b*c)/(a+b+c) for a,b,c in triples])+binary([3*a*b*c/(a*b+a*c+b*c) for a,b,c in triples])
for k in range(9):
 xs=[QQ(3+(j%17),1+(j%5)) for j in range(3*2^k)]
 leaves=primary(xs)
 assert leaves[-1]==len(xs)/sum(1/x for x in xs)

# Exact finite spectral/Gram dictionaries for three actual quotient rings.
fixtures=[]
for m in [1,3,6]:
 n=2*m;P=PolynomialRing(QQ,'X');X=P.gen();phi=X^n-X^m+1
 f=P.one();g=P([ZZ((j*j+j+1)%3)-1 for j in range(n)])
 bigF=P.zero();bigG=P(q)
 H=identity_matrix(QQ,n)
 for j in range(m):H[j,j+m]=H[j+m,j]=QQ(1)/2
 def multmat(v):return matrix(QQ,n,n,lambda i,j:((v*X^j)%phi)[i])
 M=block_matrix(QQ,[[multmat(g),multmat(bigG)],[-multmat(f),-multmat(bigF)]])
 Qmat=block_diagonal_matrix([H,H]);Gram=M.transpose()*Qmat*M
 A=Gram[:n,:n];C=Gram[:n,n:];D=Gram[n:,n:]
 Schur=D-C.transpose()*A.inverse()*C
 # Independent inverse-operator identity.
 Aop=H.inverse()*A
 assert Schur==q^2*H*Aop.inverse()
 F=CyclotomicField(6*m);z=F.gen();roots=[z^j for j in range(6*m) if j%6 in [1,5]]
 assert len(roots)==n and all(phi(r)==0 for r in roots)
 V=matrix(F,[[r^j for j in range(n)] for r in roots])
 adj=lambda A:A.conjugate().transpose()
 assert adj(V)*V/n==H
 ev=[f(r)*f(r).conjugate()+g(r)*g(r).conjugate() for r in roots]
 assert all(v!=0 for v in ev)
 avg=QQ(sum(ev)/n);invavg=QQ(sum(1/v for v in ev)/n)
 assert all(A[i,i]==avg for i in range(n))
 assert all(Schur[i,i]==q^2*invavg for i in range(n))
 # Scalar Schur recursion upper bounds the actual pivots by these diagonals.
 def pivots(G):
  ps=[]
  while G.nrows():
   v=G[0,0];assert v>0;ps.append(v)
   G=G[1:,1:]-G[1:,0:1]*G[0:1,1:]/v
  return ps
 p1=pivots(A);p2=pivots(Schur)
 assert all(v<=avg for v in p1) and all(v<=q^2*invavg for v in p2)
 assert pivots(Gram)==p1+p2
 fixtures.append({'half_degree':int(m),'primal_diagonal':str(avg),'harmonic_mass':str(1/invavg),'dual_diagonal':str(q^2*invavg),'actual_pivots':[str(v) for v in p1+p2]})

print('Full FT1536 degree: public Golay construction and exact NTRU witness',flush=True)
P=PolynomialRing(ZZ,'X');X=P.gen();m=ZZ(768);n=2*m;phi=X^n-X^m+1
f=P.one();g=P.one();length=ZZ(1)
for _ in range(9):f,g=f+X^length*g,f-X^length*g;length*=2
assert length==512 and all(v in [-1,0,1] for v in f.list()+g.list())
xinv=(X^(m-1)-X^(n-1))%phi
assert (X*xinv)%phi==1
# Star substitution via modular exponentiation, exact in the quotient.
def star(v):
 return sum(v[i]*power_mod(xinv,i,phi) for i in range(v.degree()+1))%phi
fs=star(f);gs=star(g)
assert (f*fs+g*gs)%phi==1024
# f is a unit modulo 2; Hensel-lift the inverse to modulus 1024.
F2=PolynomialRing(GF(2),'x');f2=F2(f.list());phi2=F2(phi.list())
u=P([ZZ(v) for v in f2.inverse_mod(phi2).list()]);mod=ZZ(2)
def reduce_coeff(v,k):return P([ZZ(t)%k for t in (v%phi).list()])
while mod<1024:
 new=min(mod^2,ZZ(1024));u=reduce_coeff(u*(2-f*u),new);mod=new
 assert all(ZZ(v)%mod==0 for v in ((f*u-1)%phi).list())
v=((f*u-1)%phi)/1024;assert v in P;v=P(v)
bigG=(q*(u-v*fs))%phi;bigF=(q*v*gs)%phi
assert (f*bigG-g*bigF)%phi==q
assert all(t in [-1,0,1] for t in f.list()+g.list())
assert 0<1024<=limit and 0<QQ(q^2)/1024<=limit
hRing=PolynomialRing(GF(q),'t');hphi=hRing(phi.list());hf=hRing(f.list())
assert hf.gcd(hphi)==1
h=(hRing(g.list())*hf.inverse_mod(hphi))%hphi
assert (hf*h-hRing(g.list()))%hphi==0
# The full-rank integral basis/entire-fiber theorem uses exactly these identities.
witness={'kind':'public deterministic algebraic fixture, NOT an emitted key',
 'degree':int(n),'f':[int(f[i]) for i in range(n)],'g':[int(g[i]) for i in range(n)],
 'F':[int(bigF[i]) for i in range(n)],'G':[int(bigG[i]) for i in range(n)],'h':[int(ZZ(h[i])) for i in range(n)]}
(out/'golay_ntru_witness.json').write_text(json.dumps(witness,indent=2)+'\n')
cert={'status':'EXACT_HARMONIC_SCHUR_BRIDGE_CHECKS_AND_FULL_DEGREE_ALGEBRAIC_WITNESS',
 'symbolic_reciprocal_identities':2,'harmonic_last_leaf_cases':9,
 'spectral_gram_quotient_fixtures':fixtures,
 'full_degree_witness':{'ntru_verified':True,'f_g_ternary':True,'flat_spectrum':'1024','harmonic_leaf':'1024','f_invertible_mod_q':True,
 'primal_scalar_pivots':['1024','768'],'dual_scalar_pivots':[str(QQ(q^2)/1024),str(QQ(3*q^2)/4096)],
 'pivot_bound':str(limit),'F_max_abs':str(max(abs(x) for x in bigF.list())),'G_max_abs':str(max(abs(x) for x in bigG.list())),
 'witness_sha256':hashlib.sha256((out/'golay_ntru_witness.json').read_bytes()).hexdigest(),
 'emitted_KeyGen':False,'C_leaf_execution':False},
 'universal_conclusion':'Requires the textual spectral/Schur proof; fixture counts do not prove the general theorem',
 'remaining_source_obligation':'actual NTRU/ternary binding and computed last primary leaf within <33 of harmonic mean of exact roots',
 'kernel_full_bridge':False}
(out/'certificate.json').write_text(json.dumps(cert,indent=2)+'\n')
print('PASS: exact spectral dictionaries, harmonic route, full degree ternary NTRU fixture',flush=True)
