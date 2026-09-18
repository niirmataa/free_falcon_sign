"""Kernel-checkable fixed generator/tree/matrix certificates, bound to C tables."""
import hashlib,json
from pathlib import Path
W=Path.cwd();c=json.loads((W/'artifacts/constants_certificate.json').read_text());q=18433
gm,ig=c['gm'],c['igm'];Ri=5184;Rt=10237
def mul(a,b):return a*b%q
def mm(a,b):return a*b*Ri%q
def ordinary(x):return x*Ri%q
families={}
families['units']=[[i,gm[i],ig[i]] for i in range(1024)]
families['sequence']=c['generator_rows']
families['parents']=[[i,2*i,gm[2*i],gm[i],ig[2*i],ig[i]] for i in range(1,512)]
families['tree']=[[2 if i<256 else 3,i,gm[i],gm[2*i],gm[2*i+1]] for i in range(2,512)]
rows2=[]
def row2_certificate(A,I,scale):
    for j in range(2):rows2.append(I[j]+A[0]+A[1]+[scale if j==0 else 0,scale if j==1 else 0])
row2_certificate(c['ordinary_matrices']['A2'],c['ordinary_matrices']['I2'],2)
for j in range(2,512):
    s=ordinary(gm[j]);si=ordinary(ig[j]);row2_certificate([[1,s],[1,(-s)%q]],[[1,1],[si,(-si)%q]],2)
families['rows2']=rows2
rows3=[];w=c['w'];wi=pow(w,-1,q)
for j in range(512,1024):
    a=ordinary(gm[j]);ai=ordinary(ig[j]);a2=a*a%q;ai2=ai*ai%q
    A=[[1,a,a2],[1,a*w%q,a2*w*w%q],[1,a*w*w%q,a2*w%q]]
    I=[[1,1,1],[ai,ai*wi%q,ai*wi*wi%q],[ai2,ai2*wi*wi%q,ai2*wi%q]]
    for k in range(3):rows3.append(I[k]+sum(A,[])+[3 if k==i else 0 for i in range(3)])
families['rows3']=rows3

# Fixed mq_div operation instances: op,x,y,result, with initial conversion
# and all 19 chain values, and final ordinary-x multiplication.
chain=[]
for call in c['division_calls']:
    vals=call['chain'];y=call['y']
    for i,row in enumerate(c['division_schedule']):
        if i==0:a,b=y,4564
        elif row['operation']=='montysqr':a=b=vals[int(row['arguments'][0][1:])]
        else:a=vals[int(row['arguments'][0][1:])];b=vals[int(row['arguments'][1][1:])]
        chain.append([a,b,vals[i]])
    chain.append([vals[-1],call['x'],call['result']])
families['chain']=chain
defs='''import Std
set_option maxRecDepth 32768
set_option maxHeartbeats 30000000

namespace FT1536Tables
def mm (x y : Int) : Int := (x*y*5184)%18433
def revAux : Nat → Nat → Nat → Nat
  | 0, _, y => y
  | n+1, x, y => revAux n (x/2) (2*y+x%2)
def rev10 (x : Nat) : Nat := revAux 10 x 0

def unitsCheck : List Int → Bool
  | [i,g,ig] => decide (0≤i ∧ i<1024 ∧ 0≤g ∧ g<18433 ∧ 0≤ig ∧ ig<18433 ∧ (i=0 ∨ (g*ig)%18433=4564))
  | _ => false
def sequenceCheck : List Int → Bool
  | [u,i0,i1,x0,x1,xn,y0,y1,yn] => decide (0≤u ∧ u<512 ∧ u%2=0 ∧
      i0=512+Int.ofNat (rev10 (2*u.toNat)) ∧ i1=512+Int.ofNat (rev10 (2*(u+1).toNat)) ∧
      mm x0 10542=x1 ∧ mm x1 9971=xn ∧ mm y0 14786=y1 ∧ mm y1 3463=yn)
  | _ => false
def parentsCheck : List Int → Bool
  | [i,j,x,p,y,r] => decide (1≤i ∧ i<512 ∧ j=2*i ∧
      (if i<256 then mm x x=p ∧ mm y y=r else mm x (mm x x)=p ∧ mm y (mm y y)=r))
  | _ => false
def treeCheck : List Int → Bool
  | [kind,i,p,x,y] => decide (2≤i ∧ i<512 ∧
      (if i<256 then kind=2 ∧ mm x x=p ∧ mm y y=(-p)%18433
       else kind=3 ∧ mm x (mm x x)=p ∧ mm y (mm y y)=(-p)%18433))
  | _ => false
def rows2Check : List Int → Bool
  | [a,b,c,d,e,f,t0,t1] => decide ((a*c+b*e)%18433=t0 ∧ (a*d+b*f)%18433=t1)
  | _ => false
def rows3Check : List Int → Bool
  | [a,b,c,d,e,f,g,h,i,j,k,l,t0,t1,t2] =>
      decide ((a*d+b*g+c*j)%18433=t0 ∧ (a*e+b*h+c*k)%18433=t1 ∧ (a*f+b*i+c*l)%18433=t2)
  | _ => false
def chainCheck : List Int → Bool
  | [a,b,c] => decide (0≤a ∧ a<18433 ∧ 0≤b ∧ b<18433 ∧ mm a b=c ∧ 0≤c ∧ c<18433)
  | _ => false

theorem all_sound {α : Type} (p : α → Bool) (xs : List α) (h : xs.all p = true) :
    ∀ x, x ∈ xs → p x = true := List.all_eq_true.mp h

theorem row2_sound (a b c d e f t0 t1 : Int)
    (h : rows2Check [a,b,c,d,e,f,t0,t1] = true) :
    (a*c+b*e)%18433=t0 ∧ (a*d+b*f)%18433=t1 := of_decide_eq_true h

theorem row3_sound (a b c d e f g h i j k l t0 t1 t2 : Int)
    (ok : rows3Check [a,b,c,d,e,f,g,h,i,j,k,l,t0,t1,t2] = true) :
    (a*d+b*g+c*j)%18433=t0 ∧ (a*e+b*h+c*k)%18433=t1 ∧ (a*f+b*i+c*l)%18433=t2 := of_decide_eq_true ok

theorem rev_even_range : ∀ u : Fin 512, rev10 (2*u.val) < 512 := by decide
theorem rev_even_involution : ∀ u : Fin 512, rev10 (2*rev10 (2*u.val)) = u.val := by decide

#print axioms all_sound
#print axioms row2_sound
#print axioms row3_sound
#print axioms rev_even_range
#print axioms rev_even_involution
'''
parts=[defs];counts={};names=[]
for family,rows in families.items():
    counts[family]=len(rows)
    for k in range(0,len(rows),32):
        name=family+'_'+str(k//32);names.append(name+'_checked')
        literal='['+',\n'.join('['+','.join(map(str,row))+']' for row in rows[k:k+32])+']'
        parts.append(f'def {name} : List (List Int) := {literal}\n')
        parts.append(f'theorem {name}_checked : {name}.all {family}Check = true := by decide\n#print axioms {name}_checked\n')
a=gm[1];a2=gm[2];a3=gm[3];ig0=ig[0];g=gm[512];g2=c['generator_scalars']['g2'];g4=c['generator_scalars']['g4'];ix=ig[512]
root=f'''theorem root_and_scale_facts :
    mm (mm 25 4564) (mm 25 4564)={g} ∧
    mm {g} {g}={g2} ∧ mm {g2} {g2}={g4} ∧
    mm {ix} {ix}=3463 ∧ mm 3463 3463=14786 ∧
    mm {g} 1=625 ∧ ({gm[0]}:Int)={a} ∧
    (14649*14649-14649+1)%18433=0 ∧
    (14648*14648+14648+1)%18433=0 ∧ (14648:Int)≠1 ∧
    mm {a} 1=14649 ∧ mm {ig0} 1=2523 ∧
    mm (mm {a} {a}) 1=14648 ∧ mm (mm {ig[1]} {ig[1]}) 1=3784 ∧
    mm {a2} {a2}={a} ∧ mm {a3} {a3}=(10237-{a})%18433 ∧
    ((2*14649-1)*2523)%18433=1 ∧
    (((2*{a}-10237)%18433)*{ig0})%18433=4564 ∧
    (({g}:Int)*{ix})%18433=4564 ∧
    ((6187:Int)*1536)%18433=10237 ∧ mm 6187 1=18421 ∧
    (3:Nat)*2^8*2=1536 := by decide
#print axioms root_and_scale_facts
end FT1536Tables
'''
parts.append(root)
path=W/'formal/Tables.lean';path.write_text('\n'.join(parts))
bundle=dict(families=families,counts=counts,kernel_theorems=names+['root_and_scale_facts'],
            tables_C_sha256=hashlib.sha256((W/'artifacts/tables_C.json').read_bytes()).hexdigest(),
            constants_certificate_sha256=hashlib.sha256((W/'artifacts/constants_certificate.json').read_bytes()).hexdigest(),
            lean_sha256=hashlib.sha256(path.read_bytes()).hexdigest(),
            binding='rows drawn at the stated indices from the full pinned C table dump; no uninitialized tail',
            source_sha256=hashlib.sha256((W/'source/falcon-vrfy.c').read_bytes()).hexdigest())
(W/'artifacts/kernel_literals.json').write_text(json.dumps(bundle,indent=2)+'\n')
print(json.dumps(dict(counts=counts,lean_sha256=bundle['lean_sha256'],lean_bytes=path.stat().st_size,theorems=len(names)+6),indent=2))
