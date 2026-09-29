"""Exact INIT/STEP/all-paths certificate; source induction soundness in INDUCTION.md."""
import json,sys
from pathlib import Path
sys.path.insert(0,str(Path.cwd()/'scripts'))
from sage.all import QQ,ZZ,RealBallField,PolynomialRing
from root_model import tables
from dyadic import value
from replaylib import sha,verify_manifest
W=Path.cwd();I=W/'inputs/bootstrap';verify_manifest(I,'MANIFEST.sha256','9bd79a0179910af92457ce6db5419aa859017499a79c575fb8256b5bfc92d7a1')
U=QQ(1)/2**48;eta=QQ(1)/2**900;eps=QQ(1)/2**50;grid=ZZ(2)**40
def down(x):return QQ((x*grid).floor())/grid
def up(x):return QQ((x*grid).ceil())/grid
def cmerr(M,e,d):return 2*M*d+2*e*(1+d)+6*U*(M+e)*(1+d)+4*eta
def encode(d):return {k:str(v) for k,v in d.items()}
n3=json.loads((I/'NODE3/artifacts/numeric_certificate.json').read_text())
n2=json.loads((I/'NODE2/artifacts/numeric_certificate.json').read_text())
root=json.loads((I/'ROOT/artifacts/numeric_certificate.json').read_text())
assert n2['upstream_refinement']['root_imag_uniform']=='1'
# New stronger INIT: compare cubic split to the ACTUAL REAL root spectrum.
init=[]
for b in [0,1]:
 rmin=QQ(1)/2 if b==0 else QQ(32);rmax=QQ(2**(23 if b==0 else 31));Iroot=QQ(b)
 ds=QQ(n3['constants'][b]['split_rounding_norm_error']);hmax=rmax+ds
 hmin=rmin-3*(Iroot+ds);pivotmin=hmin-65536*U*hmax;pivotmax=(1+65536*U)*hmax
 m=QQ(127)/256 if b==0 else QQ(28);M=rmax+1
 assert m<pivotmin and pivotmax<M
 for k in range(3):
  imag=QQ(0) if b==0 and k==0 else QQ(1)/2**18 if b==0 else QQ(17)/16 if k==0 else QQ(1089)/1024
  requiredI=(QQ(0) if b==0 else Iroot+ds)+(64*U*hmax if k else 0)
  assert requiredI<=imag
  E=QQ(n3['constants'][b][['t0_error_norm','d11_error_norm','d22_error_norm'][k]])
  R=QQ(2*1536**2) if b==0 else QQ(4*18433**2)
  init.append(dict(branch=b,diagonal=k,params=encode(dict(m=m,M=M,I=imag,E=E,R=R)),
   exact_proved_lower=str(pivotmin),exact_proved_upper=str(pivotmax),imag_rhs=str(requiredI)))
def step(inp):
 m,M,im,E,R=[inp[k] for k in ['m','M','I','E','R']]
 assert 0<im+1 and 0<m<=M and 0<=im<m and M+im<2**100
 B=M+im;eadd=2*U*B+2*eta
 delta=up(max(eadd/2+2*eta,cmerr(2*B,eadd,eps)+2*eta))
 hmin=(1-U)*m-eta;hmax=(1+U)*M+eta
 eig=down(m-im-2*delta)
 assert eig>0 and hmin>QQ(1)/16 and hmax<2**35
 # Real add before half is safely normal; imaginary half uses the universal eta.
 assert 2*m*(1-U)-eta>QQ(1)/16
 I0=(1+U)*im+2*eta;assert I0<hmin
 rp=U+2*eta+6*U*(1+U+2*eta)+8*eta/eig
 assert rp+U*(2+rp)+eta/eig<64*U and rp+U*(1+rp)+eta/eig<64*U
 ed=64*U*hmax
 # Variational Schur perturbation <=4delta; crucial paired real lower loss is I²/m.
 lower=m-im*im/m-4*delta-ed
 o0=dict(m=down(hmin),M=up(hmax),I=up(I0),R=R)
 o1=dict(m=down(lower),M=up((1+64*U)*hmax),I=up(I0+ed),R=R)
 for o in [o0,o1]:assert 0<o['m']<=o['M'] and o['I']<o['m'] and o['M']<2**35
 e=E+delta
 o0['E']=up(min(e,max(o0['M'],R)+o0['I']))
 o1['E']=up(min(4*e+I0+2*ed,max(o1['M'],R)+o1['I']))
 Lerr=up(min(QQ(2),2*e/eig)+2*U)
 assert 4*hmax<2**100 and Lerr<3
 return dict(input=encode(inp),B=str(B),delta=str(delta),eigen_lower=str(eig),denominator_lower=str(down(hmin)),denominator_upper=str(up(hmax)),
  source_D_error_to_H=str(up(ed)),source_L_error_to_H=str(2*U),L_norm_upper='2',L_error_to_exact=str(Lerr),
  outputs=[encode(o0),encode(o1)],raw_output_classes=['d00 finite may have subnormal imag','d11/L finite normal or zero; positive real pivots normal'])
records=[];base=[]
for r in init:
 inp={k:QQ(v) for k,v in r['params'].items()};s8=step(inp);base.append(dict(branch=r['branch'],diagonal=r['diagonal'],level=8,path='',**s8))
 def descend(level,path,p):
  s=step(p);records.append(dict(branch=r['branch'],diagonal=r['diagonal'],level=level,path=path,**s))
  if level>1:
   for e in range(2):descend(level-1,path+str(e),{k:QQ(v) for k,v in s['outputs'][e].items()})
 for e in range(2):descend(7,str(e),{k:QQ(v) for k,v in s8['outputs'][e].items()})
summaries=[]
for level in range(7,0,-1):
 rs=[r for r in records if r['level']==level]
 assert len(rs)==6*2**(8-level) and all(len(r['path'])==8-level for r in rs)
 assert len({(r['branch'],r['diagonal'],r['path']) for r in rs})==len(rs)
 assert len(rs)*2**(level-1)==768
 for b in [0,1]:
  os=[o for r in rs if r['branch']==b for o in r['outputs']]
  low=min(QQ(o['m']) for o in os);hi=max(QQ(o['M']) for o in os);im=max(QQ(o['I']) for o in os);er=max(QQ(o['E']) for o in os)
  assert low>(QQ(49)/100 if b==0 else QQ(27))
  assert hi<2**(23 if b==0 else 31)+2
  assert im<(QQ(1)/32768 if b==0 else QQ(9)/8)
  assert er<(QQ(2**15) if b==0 else QQ(2**32))
  summaries.append(dict(level=level,branch=b,nodes=len(rs)//2,positions=384,real_lower=str(low),real_upper=str(hi),imag_upper=str(im),reference_error=str(er)))
# All square rows used by split8,...,2, with each actual adjacent parent pair.
square,_,_=tables(W);RBF=RealBallField(256);pi=RBF.pi();maps=[];maxerr=RBF(0)
def br(j,b):return int(format(j,'0'+str(b)+'b')[::-1],2) if b else 0
for q in range(8,1,-1):
 m=2**(q-1);order=3*2**q;exps=[]
 for j in range(2**(q-2)):
  e=1+6*br(j,q-2);exps.append(e)
  assert 1+6*br(2*j,q-1)==e and 1+6*br(2*j+1,q-1)==e+order//2
  theta=2*pi*e/order
  for word,target in zip(square[m+j],[theta.cos(),theta.sin()]):
   v=value(word);err=abs(RBF(QQ(v.numerator)/v.denominator)-target);assert err<RBF(eps);maxerr=max(maxerr,err)
 assert {e%(order//2) for e in exps}|{(-e)%(order//2) for e in exps}=={e for e in range(order//2) if e%6 in [1,5]}
 maps.append(dict(split_logn=q,level=q-1,parent_order=order,child_order=order//2,square_first=m,child_exponents=exps))
assert sum(len(r['child_exponents']) for r in maps)==127
P=PolynomialRing(QQ,names=['a','b','t','s']);a,b,t,s=P.gens()
assert ((a+b)**2-(a-b)**2-(t-s)**2)/4==a*b-(t-s)**2/4
assert len(records)==1524 and len(base)==6
out=dict(schema='FT1536_BINARY_TOWER_NUMERIC_V1',status='PASS_INIT_AND_ALL_LEVELS',grid_denominator=str(grid),rounding='floor lower; ceil upper/imag/errors; exact QQ before each outward rounding',
 initial_refinement=init,level8_refined=base,nodes=records,summaries=summaries,root_maps=maps,twiddle_count=127,max_twiddle_error_RBF256=str(maxerr),
 uniform_summaries=dict(branch0=dict(real_lower='49/100',real_upper=str(2**23+2),imag_upper='1/32768',reference_error=str(2**15)),branch1=dict(real_lower='27',real_upper=str(2**31+2),imag_upper='9/8',reference_error=str(2**32)),L_norm_upper='2',L_error_upper='3'),
 coverage=dict(levels=list(range(7,0,-1)),positions_per_level=768,nodes=1524,subtrees=12,L_words=10752,raw_leaf_words=1536,tree_words_per_inner7=1024,scratch_words_per_inner7=256),
 primitive_domains=dict(input_abs_cap='2^100',positive_divisor=['1/16','2^35'],U=str(U),eta=str(eta),half='NODE2 finite all-word theorem; may create subnormal'),
 kernel_scope='Numeric scalar lemmas and abstract execution/structure are kernel checked; source/error induction is analytical, not certified by this JSON alone.',
 upstream_pins={r:sha(I/r) for r in ['NODE2/NODE2_CERTIFICATE.json','NODE2/UPSTREAM_REFINEMENT.md','NODE3/ANALYTIC_PROOF.md','ROOT/ANALYTIC_PROOF.md']})
(W/'artifacts/numeric_certificate.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps(dict(status=out['status'],coverage=out['coverage'],uniform_summaries=out['uniform_summaries'],levels=summaries),indent=2))
