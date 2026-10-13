# Finite adversarial diagnostic; not a universal proof. Standard Sage preparser.
from pathlib import Path
from sage.version import version as sage_version
import json, hashlib, random, sys
ROOT=Path.cwd();S=ROOT/'proofs/ft1536/development/S05_QROM';B=S/'.build/pair_machine_020/producer_001'
program_path=B/'runs/coreexport001/stdout.txt'
program=json.loads(program_path.read_text())
MOD=ZZ(2)^512;HALF=ZZ(2)^511
word=lambda x: ZZ(x)%MOD
signed=lambda x: ZZ(x) if ZZ(x)<HALF else ZZ(x)-MOD
norm=lambda x: max(ZZ(0),signed(x))
def op(k,a,b):
 a=signed(a);b=signed(b)
 if k==0:v=a+b
 elif k==1:v=a-b
 elif k==2:v=a*b
 elif k in [3,4]:
  q=ZZ(0) if b==0 else (a//b if b>0 else -(a//(-b)))
  v=q if k==3 else a-b*q
 elif k==5:v=ZZ(a<b)
 elif k==6:v=ZZ(a==b)
 else:raise AssertionError(k)
 return word(v)
def execute(w):
 regs=[ZZ(0)]*64;out=[ZZ(0)]*96;miss=0
 for ins in program:
  k=ins[0];d=ins[1]
  if k==0:regs[d]=ZZ(ins[2])
  elif k==1:regs[d]=regs[ins[2]]
  elif k==2:regs[d]=op(ins[2],regs[ins[3]],regs[ins[4]])
  elif k==3:
   assert ins[2]==0
   a=signed(regs[ins[3]])
   if 0<=a<96:regs[d]=w[a]
   else:regs[d]=0;miss+=1
  elif k==4:out[d]=regs[ins[2]]
  elif k==5:regs[d]=regs[ins[3] if regs[ins[2]]==0 else ins[4]]
  else:raise AssertionError(k)
 assert miss==0
 return out
valid=lambda n,x: 0<=signed(x)<n
noneFrame=(ZZ(0),ZZ(0),ZZ(0))
def pending(fs):
 if len(fs)==0:return [ZZ(0)]*11
 if len(fs)==1:return [ZZ(1),ZZ(0)]+list(fs[0])+[ZZ(0)]*6
 return [ZZ(1),ZZ(1)]+[ZZ(0)]*3+list(fs[0])+list(fs[1])
def action(w):
 if not w[31]:return None
 tag=w[32];p=norm(w[33]);again=bool(w[18]);remain=w[20] if again else p
 if again and (tag!=11 or remain>p):return None
 if tag==11:
  if remain==0:return ([],(0,0,0))
  if not w[39]:return None
  if w[40]==0:return ([],(0,0,0))
  return ([(0,w[34],0),(1,w[19],remain-1)],(0,0,0))
 if tag==9:return ([(0,w[35],0),(0,w[34],0)],(0,0,0))
 if tag==10:
  return None if not w[41] else ([(0,w[34] if w[42]==0 else w[35],0)],(0,0,0))
 if tag in [3,4,5,6]:
  if p>=32 or not w[37]:return None
  if tag==3:return ([],(2,p,w[38]))
  extent={4:93698,5:4608,6:24662538240}[tag]
  if not valid(extent,w[38]):return ([],(1,0,0))
  return ([],(2,p,w[{4:44,5:43,6:45}[tag]]))
 if tag in [7,8]:
  if not w[39]:return None
  if not valid(4608 if tag==7 else 50689,w[40]):return ([],(1,0,0))
  if not w[37]:return None
  return ([],(3 if tag==7 else 4,w[40],w[38] if tag==7 else ZZ(w[38]!=0)))
 return None

def reference(w):
 meta=list(w[:16]);data=[];phase=w[0];cursor=w[1];left=w[2];sp=w[3]
 if phase==0:
  if sp==0:meta[0]=5
  elif left==0:meta[0]=6
  else:meta[0]=1;meta[1]=0
 elif phase in [1,2]:
  if cursor<877:
   v=None
   if phase==2 and w[46]:
    tag=w[21];p=norm(w[22])
    if tag==0:v=w[22]
    elif tag==1 and p<32:v=w[30]
    elif tag==2 and p<7 and w[26] and w[28]:v=op(p,w[29],w[27])
   data=[(142152+2*cursor,ZZ(v is not None)),(142153+2*cursor,ZZ(0) if v is None else v)]
   meta[1]=cursor+1
  elif phase==1:meta[0]=2;meta[1]=0
  else:meta[0]=3
 elif phase==3:
  result=action(w)
  if result is None:meta[0]=6
  else:
   fs,(tag,a,v)=result;meta[0]=4;meta[2]=max(0,left-1);meta[3]=max(0,sp-1);meta[4:15]=pending(fs)
   if tag==1:meta[15]=1
   elif tag in [2,3,4]:data=[({2:0,3:32,4:4640}[tag]+a,v)]
 elif phase==4:
  if w[4]==0:meta[0]=0
  elif sp==28941:meta[0]=6
  else:
   if w[5]==0:fr=w[6:9];meta[4:15]=pending([])
   else:fr=w[12:15];meta[4:15]=pending([w[9:12]])
   data=[(55329+3*sp+j,fr[j]) for j in range(3)];meta[3]=sp+1
 out=[ZZ(0)]*96
 for j,(a,v) in enumerate(data):out[3*j:3*j+3]=[1,word(a),word(v)]
 for j,v in enumerate(meta):out[3*(j+3):3*(j+3)+3]=[1,143906+j,word(v)]
 return out
rng=random.Random(int(200006))
vals=[ZZ(0),ZZ(1),ZZ(2),ZZ(31),ZZ(32),ZZ(4607),ZZ(4608),ZZ(50688),ZZ(50689),ZZ(93697),ZZ(93698),ZZ(24662538239),ZZ(24662538240),HALF-1,HALF,MOD-1]
frames=lambda: (ZZ(rng.randrange(2)),ZZ(rng.randrange(878)),ZZ(rng.randrange(8)))
def fixture(phase,tag,again):
 w=[ZZ(0)]*96
 w[0]=phase;w[1]=rng.choice([0,1,876,877]);w[2]=rng.choice([0,1,2,1106642201817]);w[3]=rng.choice([0,1,2,28940,28941]);w[15]=rng.randrange(2)
 w[4:15]=pending([frames() for _ in range(rng.randrange(3))])
 w[16]=rng.choice([0,1,876,877]);w[17]=ZZ(w[3]>0)
 if w[17]:w[18]=again;w[19]=rng.choice([0,1,876,877]);w[20]=rng.choice([0,1,2,7,HALF-1]) if again else 0
 w[46]=ZZ(w[1]<877 and w[1]<w[16])
 if w[46]:
  w[21]=rng.randrange(16);w[22]=rng.choice(vals)
  w[23]=rng.randrange(878);w[24]=rng.randrange(878);w[25]=rng.randrange(878)
  for p,v,child in [(26,27,23),(28,29,24)]:
   w[p]=ZZ(w[child]<w[1] and w[child]<w[16] and rng.randrange(2)==1);w[v]=rng.choice(vals) if w[p] else 0
  if w[21]==1 and norm(w[22])<32:w[30]=rng.choice(vals)
 w[31]=ZZ(w[17] and w[19]<w[16])
 if w[31]:
  w[32]=tag;w[33]=rng.choice(vals)
  w[34]=rng.randrange(878);w[35]=rng.randrange(878);w[36]=rng.randrange(878)
  for p,v,child in [(37,38,34),(39,40,35),(41,42,36)]:
   w[p]=ZZ(w[child]<w[16] and rng.randrange(2)==1);w[v]=rng.choice(vals) if w[p] else 0
  for v,extent in [(43,4608),(44,93698),(45,24662538240)]:
   if w[37] and valid(extent,w[38]):w[v]=rng.randrange(2) if v==45 else rng.choice(vals)
 return list(map(ZZ,w))
count=0;failure=None
for phase in range(7):
 for tag in range(16):
  for again in range(2):
   for repetition in range(20):
    w=fixture(phase,tag,again);actual=execute(w);expected=reference(w);count+=1
    if actual!=expected:
     failure={'phase':phase,'tag':tag,'again':again,'input':list(map(str,w)),'actual':list(map(str,actual)),'expected':list(map(str,expected))}
     break
   if failure:break
  if failure:break
 if failure:break
result={'status':'FINITE_DIAGNOSTIC_PASS_NOT_UNIVERSAL_PROOF' if failure is None else 'FINITE_COUNTEREXAMPLE',
 'sage':str(sage_version),'cases':count,'instructions':len(program),'seed':'200006 public fixture seed',
 'word_bits':512,'program_sha256':hashlib.sha256(program_path.read_bytes()).hexdigest(),
 'script_sha256':hashlib.sha256((S/'notes/CHECK_PRODUCER_CORE_020E6.sage').read_bytes()).hexdigest(),
 'failure':failure,'scope':'96-word synthetic snapshots; independent Sage reference vs exported Lean bytecode; no source/window-formation proof'}
out=Path(sys.argv[1]);assert not out.exists();out.write_text(json.dumps(result,indent=2,default=int)+'\n');print(json.dumps({k:v for k,v in result.items() if k!='failure'},indent=2,default=int))
if failure:raise SystemExit(1)
