"""Binding controls for every analytical error summand on the native fixtures.
Universal justification is ANALYTIC_PROOF, not extrapolation from this run."""
from fractions import Fraction as F
from pathlib import Path
import json
from dyadic import value
import fp_literal as C
W=Path.cwd();checks=0;underflow=0;zero=0;maximum=F(0);round_mut=None;under_mut=None
def p2(e):return F(2**e) if e>=0 else F(1,2**(-e))
def check_sub(x,y):
 global checks,underflow,zero,maximum,round_mut,under_mut
 output,t=C.sub(x,y,True);a=t['sorted_x'];b=t['sorted_y'];lam=p2(t['ex']);ulp=p2(t['e'])
 ea=(a>>52)&2047;eb=(b>>52)&2047;assert ea<=1054 and eb<=1054 and ea>=eb
 sa=-1 if t['sx'] else 1;sb=-1 if t['sy'] else 1
 da=sa*t['raw_xu']*lam;db=sb*t['raw_yu']*p2(t['ey'])
 assert abs(da-value(a))<p2(-1023) and abs(db-value(b))<p2(-1023)
 align=sb*t['aligned']*lam-db
 assert abs(align)<=lam and t['T']<2**57
 assert sa*t['T']*lam==da+sb*t['aligned']*lam
 h=t['ex']+9-t['e'];assert 7<=h<=63 and t['normal']==t['T']*2**h
 if t['T']:
  assert 2**63<=t['normal']<2**64 and 2**54<=t['m']<2**55
 else:assert t['normal']==t['m']==0;zero+=1
 shrink=sa*t['m']*ulp-sa*t['T']*lam
 assert abs(shrink)<=ulp<=4*lam
 pk=value(output)-sa*t['m']*ulp
 if t['e']+1076<0:
  assert output in [0,1<<63] and abs(pk)<p2(-1022);underflow+=1
  if pk:under_mut=dict(x=f'{x:016x}',y=f'{y:016x}',observed_pack_error=str(abs(pk)),mutated_allowance='0')
 else:
  assert abs(pk)<=2*ulp
  if pk:round_mut=dict(x=f'{x:016x}',y=f'{y:016x}',observed_pack_error=str(abs(pk)),mutated_allowance='0')
 err=da-value(a)+db-value(b)+align+shrink+pk
 assert err==value(output)-(value(x)-value(y))
 assert abs(err)<=13*p2(-24)+p2(-1021)<p2(-20)
 assert ((output>>52)&2047)<2047 and (output&((1<<63)-1)==0 or ((output>>52)&2047)>0)
 maximum=max(maximum,abs(err));checks+=1
for row in (W/'checks/scalars.txt').read_text().splitlines():
 x,z,dom=row.split();x=int(x,16);z=int(z)
 if dom!='1':continue
 s=C.floor(x);r=C.center(x)
 check_sub(x,C.of(s));check_sub(x,C.of(s+z));check_sub(C.of(1),r)
assert under_mut is not None and round_mut is not None
out=dict(status='PASS_BINDING_CONTROLS',checked_add_transcripts=checks,underflow_branches=underflow,zero_mantissa_branches=zero,
 maximum_observed_error=str(maximum),all_assigned_phase_bounds_hold=True,
 omitted_rounding_mutation=round_mut,omitted_underflow_mutation=under_mut,
 scope='Native-tested input fixtures; universal proof is analytical plus kernel integer lemmas.')
(W/'artifacts/phase_controls.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
