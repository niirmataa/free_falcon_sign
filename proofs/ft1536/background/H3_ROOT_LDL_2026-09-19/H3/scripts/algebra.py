"""Exact algebraic interfaces only: do not equate the subtractive FPEMU tree
with this ideal Gram/Schur calculation."""
from sage.all import PolynomialRing,QQ
from pathlib import Path
import json
W=Path.cwd();P=PolynomialRing(QQ,names=['f','g','F','G','fb','gb','Fb','Gb','H','q']);f,g,F,G,fb,gb,Fb,Gb,H,q=P.gens();K=P.fraction_field()
A=f*fb+g*gb;U=F*fb+G*gb;Ub=Fb*f+Gb*g;C=F*Fb+G*Gb;det=f*G-g*F;detb=fb*Gb-gb*Fb
schur=K(C)-K(U*Ub)/A
assert schur==K(det*detb)/A
L=K(U)/A;t0=-K(H*F)/q;t1=K(H*f)/q
assert t0+t1*L-K(H*gb)/A==K(H*gb*(det-q))/(q*A)
counts=[]
# The unchanged Phi reduction of degree<=3070, counted without floating point.
for k in range(1536):
 c=0
 for d in [k,k+768,k+1536,k+2304]:
  if d>3070:continue
  if d<1536:row={d:1}
  elif d<2304:row={d-768:1,d-1536:-1}
  else:row={d-2304:-1}
  if k in row:c+=d+1 if d<1536 else 3071-d
 counts.append(c)
assert max(counts)==2304
qv=18433;cap=QQ(2304*18432*2047)/qv
out=dict(status='EXACT_ALGEBRA_WITH_UNDISCHARGED_MACHINE_BRIDGE',identities=dict(
 Schur='g11-|g10|^2/g00 = det*conj(det)/g00; equals q^2/g00 under NTRU',
 target='t0+t1*L = H*adj(g)/g00 under NTRU',
 actual_residual_center='t0+r1*L = H*adj(g)/g00 + (r1-t1)*L; residual term does NOT disappear'),
 denominator_premises=['g00 !=0','q !=0'],
 exact_Phi_coefficient_term_count_max=2304,root_target_exact_coefficient_bound=str(cap),
 root_target_scope='Exact coefficient polynomial c*F/q using canonical c and |F_i|<=2047; NOT an actual FFT buffer/leaf-center bound.',
 global_H3_proved=False,machine_error_transfer='OPEN: source operations, split/merge scales, internal pivots/multipliers and represented-zero domain',
 normalized_leaf_changes=1536,total_expanded_tree_words=18432,untouched_internal_words=16896,
 history='No private key, new KeyGen or secret Sign execution.')
(W/'artifacts/algebra.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
