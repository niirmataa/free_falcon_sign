"""All-coefficient finite-field certificate for the final KeyGen NTRU check, not a KeyGen run."""
import json,re,sys
from pathlib import Path
sys.path.insert(0,str(Path.cwd()/'scripts'))
from sage.all import ZZ,PolynomialRing
from replaylib import sha
W=Path.cwd();text=(W/'source/falcon-keygen.c').read_text()
p,g=map(int,re.search(r'PRIMES3\[\] = \{\s*\{\s*(\d+),\s*(\d+)',text).groups())
assert p==2147355649 and g==1907584673 and ZZ(p).is_prime(proof=True)
assert pow(g,9216,p)==1 and pow(g,4608,p)!=1 and pow(g,3072,p)!=1
g=pow(g,2,p);R=1<<31;Ri=pow(R,-1,p)
def br(x,b):return int(format(x,'0'+str(b)+'b')[::-1],2)
revtext=re.search(r'REV10\[.*?\] = \{(.*?)\n\};',text,re.S).group(1)
rev=[int(x) for x in re.findall(r'\d+',revtext)];assert len(rev)==1024 and all(rev[i]==br(i,10) for i in range(1024))
gm=[0]*1024;e=1
for i in range(0,512,2):
 gm[512+rev[i*2]]=e;e+=4;gm[512+rev[(i+1)*2]]=e;e+=2
for i in range(256,512):gm[i]=3*gm[2*i]%4608
for i in range(255,0,-1):gm[i]=2*gm[2*i]%4608
gm[0]=gm[1];assert gm[1]==768
raw=list(map(int,(W/'checks/keygen_map_normal.txt').read_text().split()));assert raw[:2]==[p,1907584673]
assert (raw[2]*p+1)%R==0
assert raw[3:1027]==[pow(g,e,p)*R%p for e in gm]
assert (1-pow(g,768,p))%p==pow(g,3840,p)
def shift(a,e):return {k:(v+e)%4608 for k,v in a.items()}
def join(a,b):assert a.keys().isdisjoint(b);return a|b
a=[{} for _ in range(1536)]
for i in range(768):a[i]={i:0,i+768:768};a[i+768]={i:0,i+768:3840}
t=768;m=2
while t>3:
 h=t//2
 for j in range(m):
  for i in range(j*t,j*t+h):
   x,y=a[i],shift(a[i+h],gm[m+j]);a[i]=join(x,y);a[i+h]=join(x,shift(y,2304))
 t=h;m*=2
roots=[];count=0
for i in range(0,1536,3):
 for k in range(3):
  e=(gm[512+i//3]+1536*k)%4608;b=join(join(a[i],shift(a[i+1],e)),shift(a[i+2],2*e))
  assert len(b)==1536 and all(v==j*e%4608 for j,v in b.items());count+=len(b);roots.append(e)
assert set(roots)=={e for e in range(4608) if e%6 in (1,5)}
assert raw[1027:]==[pow(g,e,p) for e in roots]
bound=6*1536*2047+18433;assert bound<p
# Universal Gram determinant identity in independent integer indeterminates.
P=PolynomialRing(ZZ,names=['fr','fi','gr','gi','Fr','Fi','Gr','Gi']);fr,fi,gr,gi,Fr,Fi,Gr,Gi=P.gens()
A=fr**2+fi**2+gr**2+gi**2;J=Fr**2+Fi**2+Gr**2+Gi**2
Cr=Gr*gr+Gi*gi+Fr*fr+Fi*fi;Ci=Gi*gr-Gr*gi+Fi*fr-Fr*fi
detre=fr*Gr-fi*Gi-gr*Fr+gi*Fi;detim=fr*Gi+fi*Gr-gr*Fi-gi*Fr
assert A*J-Cr**2-Ci**2==detre**2+detim**2
out=dict(status='PASS_SOURCE_NTRU_CHECK_AND_EXACT_ALGEBRA',prime=p,primitive9216=1907584673,
 source_forward_gm_entries=1024,all_symbolic_coefficients=count,distinct_phi_roots=1536,integer_lift_abs_bound=bound,
 native_X_transform_matches=True,gram_orientation='B B*, B=[[g,-f],[G,-F]], C=G conj(g)+F conj(f)',
 exact_determinant_identity=True,source_membership_proof='EMITTED_BINDING.md; no generated/read key, native helper evaluates only public X',
 source_sha256=sha(W/'source/falcon-keygen.c'),native_helper_sha256=sha(W/'checks/keygen_map_normal.txt'))
(W/'artifacts/emitted_certificate.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
