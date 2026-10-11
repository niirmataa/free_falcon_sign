# Exact finite controls and budget arithmetic, standard Sage preparser.
import json
from pathlib import Path
from sage.env import SAGE_VERSION
print("BEGIN_EXACT_CONTROLS", flush=True)
Q=QQ
C=[False,True]; O=['none','some_false','some_true']; A=[(c,o) for c in C for o in O]
p={a:Q(0) for a in A}; p[(False,'none')]=Q(1)/2; p[(True,'some_true')]=Q(1)/2
j={a:(Q(1)/4 if a[1] in ['none','some_true'] else Q(0)) for a in A}
assert sum(p.values())==sum(j.values())==1
for c in C: assert sum(j[(c,o)] for o in O)==sum(p[(c,o)] for o in O)
for o in O: assert sum(j[(c,o)] for c in C)==sum(p[(c,o)] for c in C)
assert j[(True,'none')]==Q(1)/4 and p[(True,'none')]==0
raw=sum(j[a]^2/p[a] for a in A if p[a]!=0)
assert raw==Q(1)/4
assert sum(j[(c,'none')] for c in C)==sum(p[(c,'none')] for c in C)==Q(1)/2
# Wrong-direction lower bound control.
J=[Q(1),Q(0)]; P=[Q(1)/2,Q(1)/2]; R=[Q(1)/8,Q(7)/8]
second=lambda u,v:sum(u[i]^2/v[i] for i in range(len(u)))
assert all(R[i]<=2*P[i] for i in range(2))
assert second(J,R)==8 and second(J,P)==2 and second(J,R)>2*second(J,P)
print("CORRELATION_AND_DIRECTION_PASS", flush=True)
# Nontrivial exact DPI controls over all maps 3->2, on a rational grid.
laws=[[Q(a)/4,Q(b)/4,Q(4-a-b)/4] for a in range(5) for b in range(5-a)]
checks=ZZ(0)
for u in laws:
 for v in laws:
  if any(u[i]!=0 and v[i]==0 for i in range(3)):continue
  base=sum(u[i]^2/v[i] for i in range(3) if v[i]!=0)
  for mask in range(8):
   f=[(mask>>i)&1 for i in range(3)]
   U=[sum(u[i] for i in range(3) if f[i]==b) for b in range(2)]
   V=[sum(v[i] for i in range(3) if f[i]==b) for b in range(2)]
   assert all(U[b]==0 for b in range(2) if V[b]==0)
   mapped=sum(U[b]^2/V[b] for b in range(2) if V[b]!=0)
   assert mapped<=base
   checks+=1
print("DPI_GRID_PASS", checks, flush=True)
# Example kappa only: no source bound is asserted for this value.
e=Q(1)/2^47; k=1+Q(1)/2^60; paid=k*(1+e)-1
assert paid==Q(1)/2^47+Q(1)/2^60+Q(1)/2^107
assert 1*(1+e)-1==e
ns=[ZZ(0),ZZ(1),ZZ(47),ZZ(256),ZZ(384),ZZ(1024),ZZ(24662538240)]
mods={str(n):int(power_mod(ZZ(2),n,ZZ(18433))) for n in ns}
assert all(x!=0 for x in mods.values())
print("BUDGET_AND_MODULAR_PASS", flush=True)
result={'status':'PASS_EXACT_CONTROLS','sage_version':SAGE_VERSION,
 'correlation_control':{'same_marginals':True,'same_failure_mass':'1/2','off_support_atom':'1/4','AC':False,'raw_second_without_AC':str(raw),'chi2':'infinite'},
 'wrong_direction_control':{'R_le_2P':True,'second_J_R':'8','second_J_P':'2','bound_2_times_second_J_P_fails':True},
 'DPI_finite_grid_checks':int(checks),'DPI_grid_denominator':int(4),'DPI_source_atoms':int(3),'DPI_target_atoms':int(2),
 'paid_budget_example':{'e':str(e),'kappa':str(k),'paid_e':str(paid),'kappa_source_witness':False},
 'finite_pow2_mod18433_controls':mods,
 'scope':'Exact finite controls; universal statements are the separately checked Lean lemmas. No source binding, source kappa, quantum composition or operational cost claim.'}
Path('result.json').write_text(json.dumps(result,indent=int(2))+'\n')
print('PASS_EXACT_CONTROLS: correlation/abort/support, denominator direction, finite DPI grid and explicit kappa budget')
