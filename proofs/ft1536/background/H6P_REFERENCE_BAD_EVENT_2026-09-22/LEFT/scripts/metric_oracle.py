"""Independent exact Hermitian defects and RBF ideal reconstruction of source terminal words."""
import json,struct,sys
from pathlib import Path
sys.path.insert(0,str(Path.cwd()/'scripts'))
from sage.all import QQ,QuadraticField,PolynomialRing,matrix,diagonal_matrix,identity_matrix,ComplexBallField,RealBallField
from backend import sub,of,half,mul,cm
from dyadic import value
from replaylib import sha
W=Path.cwd();I=W/'inputs/bootstrap';D=W/'checks/data';F=QuadraticField(-1,'ii');ii=F.gen();R=RealBallField(256);C=ComplexBallField(256);U=QQ(1)/2**48
def qv(w):v=value(w);return QQ(v.numerator)/v.denominator
def zword(words,j):n=len(words)//2;return F(qv(words[j]))+ii*qv(words[j+n])
def bar(z):return z[0]-ii*z[1]
def star(m):return m.apply_map(bar).transpose()
def pd(m):
 assert m==star(m)
 for k in range(1,m.nrows()+1):
  d=m[:k,:k].det();assert d[1]==0 and d[0]>0
def cb(z):return C(R(z[0]),R(z[1]))
def br(j,k):return int(format(j,'0'+str(k)+'b')[::-1],2) if k else 0
phases={}
def phase(order,e):
 key=(order,e)
 if key not in phases:
  angle=2*R.pi()*e/order;phases[key]=C(angle.cos(),angle.sin())
 return phases[key]
mapping=json.loads((I/'RAW/LEAF_MAP.json').read_text())['entries'];metric=json.loads((W/'artifacts/metric_bounds.json').read_text());energy=json.loads((W/'artifacts/energy_transfer.json').read_text());bank=json.loads((W/'BANK_WEIGHTED_BOUNDS.json').read_text())
outputs=[]
for kind in ['flat','vary','tilted']:
 data=json.loads((D/(kind+'.tree.json')).read_text());records=data['records'];raw=data['raw'];stable=data['stable'];count={1:0,2:0,3:0,4:0,5:0,6:0,7:0,8:0,'cubic':0};witness=None
 for rec in records:
  if rec['kind']=='binary':
   n=len(rec['input0']);hn=n//2
   for j in range(hn):
    h=qv(rec['input0'][j]);c=zword(rec['input1'],j);l=zword(rec['L'],j);d=qv(rec['D'][j]);H=matrix(F,[[h,bar(c)],[c,h]]);L=matrix(F,[[1,0],[l,1]]);M=L*diagonal_matrix(F,[h,d])*star(L);scale=128*U*h
    pd(H);pd(M);E=M-H;pd(scale*identity_matrix(F,2)+E);pd(scale*identity_matrix(F,2)-E)
    assert (l*bar(l))[0]<(1+QQ(1)/2**40)**2
    if witness is None and not E.is_zero():witness=dict(level=rec['level'],path=rec['path'],slot=j,defect=[[str(x) for x in row] for row in E.rows()],classification='Exact-zero raw-factor defect is false on a public source fixture; not emitted counterexample')
    count[rec['level']]+=1
  else:
   for j in range(256):
    h=qv(rec['a'][j]);b=zword(rec['b'],j);c=zword(rec['c'],j);l10=zword(rec['L10'],j);l20=zword(rec['L20'],j);l21=zword(rec['L21'],j);d=qv(rec['d'][j]);e=qv(rec['e'][j])
    H=matrix(F,[[h,bar(b),bar(c)],[b,h,bar(b)],[c,b,h]]);L=matrix(F,[[1,0,0],[l10,1,0],[l20,l21,1]]);M=L*diagonal_matrix(F,[h,d,e])*star(L);scale=2048*U*h;pd(H);pd(M);E=M-H;pd(scale*identity_matrix(F,3)+E);pd(scale*identity_matrix(F,3)-E);count['cubic']+=1
 assert all(count[k]==768 for k in range(1,9)) and count['cubic']==512
 calls=json.loads((D/(kind+'_normal.calls.json')).read_text());pairs={};weighted=QQ(0);termrows=[]
 for j,leaf in enumerate(reversed(mapping)):
  one,two=calls[2*j:2*j+2];assert one['outcome']==two['outcome']=='NORMAL_RETURN'
  mu1=int(one['mu'],16);mu0=int(two['mu'],16);r1=sub(mu1,of(one['sample']));rx=half(r1);u0=sub(mu0,of(two['sample']));r0=sub(u0,rx);a=qv(r0);b=qv(r1);lam=qv(stable[leaf['ordinal']]);E=lam*(a*a+a*b+b*b)
  assert E<bank['terminal_A2_energy_integer_upper'];pairs[leaf['tree_index']]=(a,b)
  if leaf['ordinal']>=768:weighted+=E
  termrows.append(dict(stable_index=leaf['ordinal'],tree=leaf['tree_index'],bank_pair=[one['bank'],two['bank']],D=str(lam),r0=str(a),r1=str(b),weighted_A2=str(E)))
 def merge(k,a,b):
  if k==1:return [C(a[0]+b[0]/2,R(3).sqrt()*b[0]/2)]
  z=[]
  for j,(x,y) in enumerate(zip(a,b)):
   p=phase(3*2**k,1+6*br(j,k-2));z.extend([x+y*p,x-y*p])
  return z
 def unpack(off,n):return [cb(zword(raw[off:off+n],j)) for j in range(n//2)]
 def inner(k,off):
  if k==0:
   x,y=pairs[off];return [R(x)],[R(y)]
  n=2**k;child=k*2**(k-1);a,b=inner(k-1,off+n+child);z1=merge(k,a,b);a,b=inner(k-1,off+n);v=merge(k,a,b);L=unpack(off,n);return [x-y*l for x,y,l in zip(v,z1,L)],z1
 B=9984;n=512;subs=[merge(9,*inner(8,B+1536+k*2304)) for k in range(3)];l10=unpack(B,512);l20=unpack(B+512,512);l21=unpack(B+1024,512)
 z2=subs[2];z1=[a-b*l for a,b,l in zip(subs[1],z2,l21)];z0=[a-b*l-c*m for a,b,c,l,m in zip(subs[0],z1,z2,l10,l20)]
 omega=phase(3,1);Z=[]
 for j,(a,b,c) in enumerate(zip(z0,z1,z2)):
  x=phase(4608,1+6*br(j,8));B0=b*x;C0=c*x*x;Z += [a+B0+C0,a+B0*omega+C0*omega**2,a+B0*omega**2+C0*omega]
 mem=list(struct.unpack('<10752Q',(D/(kind+'_normal.memory.bin')).read_bytes()));actual=mem[4608:6144];d=data['rootD'];normE=R(0);maxerror=R(0);producterr=QQ(0);maxgain=QQ(0);rational_energy=QQ(0)
 for j,z in enumerate(Z):
  dz=cb(zword(actual,j))-z;maxerror=max(maxerror,abs(dz));normE+=R(qv(d[j]))*(z.real()**2+z.imag()**2)/768
  aw=zword(actual,j);l=zword(raw[:1536],j);gain=(l*bar(l))[0]/qv(d[j]);maxgain=max(maxgain,gain);rational_energy+=qv(d[j])*(aw*bar(aw))[0]/768
  got=zword(mem[6144:7680],j);diff=got-aw*l;producterr=max(producterr,(diff*bar(diff))[0])
 assert maxerror<R(QQ(energy['reconstruction']['actual_to_exact_source_L_reconstruction_norm_error']))
 assert normE<R(QQ(metric['products'][1]['metric_to_stable_integer_factor'])*weighted)
 assert maxgain<QQ(metric['root']['source_root_gain_squared_integer_upper'])
 assert producterr<QQ(energy['root']['source_CM_rounding_error'])**2
 ratio=normE/R(weighted) if weighted else R(0)
 result=dict(status='PASS_EXACT_LOCAL_METRIC_AND_INDEPENDENT_RECONSTRUCTION',kind=kind,checked_local_frequencies=count,
  right_terminal_weighted_energy=str(weighted),right_Gram_energy_of_exact_source_L_reconstruction=str(normE),observed_metric_ratio=str(ratio),actual_right_Gram_energy=str(rational_energy),
  actual_to_reference_reconstruction_max_error=str(maxerror),actual_root_gain_squared_max=str(maxgain),root_CM_error_squared_max=str(producterr),
  terminal_metrics=termrows,exact_equality_countermodel=witness,membership='Synthetic public source Gram/tree fixture, not coefficient/P_key/emitted key')
 p=D/(kind+'.metric_oracle.json');p.write_text(json.dumps(result,indent=2)+'\n');outputs.append(dict(kind=kind,sha256=sha(p),local_frequencies=sum(count.values()),observed_metric_ratio=str(ratio),reconstruction_error=str(maxerror),has_exact_defect_witness=witness is not None));print(json.dumps(outputs[-1]),flush=True)
# Exact generic split/reciprocal identities independent of source code.
Q=PolynomialRing(QQ,names=['a','b','c','q']);a,b,c,q=Q.gens();FQ=Q.fraction_field();a,b,c,q=map(FQ,[a,b,c,q]);e1=a+b+c;e2=a*b+a*c+b*c
primary=[e1/3,e2/e1,3*a*b*c/e2];x,y,z=[q*q/a,q*q/b,q*q/c];recip=[(x+y+z)/3,(x*y+x*z+y*z)/(x+y+z),3*x*y*z/(x*y+x*z+y*z)]
assert recip==[q*q/t for t in reversed(primary)] and (q*q/a+q*q/b)/2==q*q/(2*a*b/(a+b))
for f in [primary[0],primary[1],primary[2],2*a*b/(a+b)]:
 for v in Q.gens()[:3]:
  derivative=f.derivative(v);assert all(x>=0 for x in derivative.numerator().coefficients())
 assert sum(FQ(v)*f.derivative(v) for v in Q.gens()[:3])==f
out=dict(status='PASS_INDEPENDENT_METRIC_ENERGY_AND_EXACT_RECIPROCAL_ORACLES',cases=outputs,exact_positive_pivot_monotonicity_and_homogeneity=True,reciprocal_reverse_identity=True,
 scope='Finite source controls plus generic exact identities; uniform Loewner/source bounds separately justified in METRIC_BRIDGE and numeric certificates',precision=256)
(W/'artifacts/metric_oracle.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],cases=len(outputs)),indent=2))
