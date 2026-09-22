"""Exact adaptive finite trees, zero-probability branches, stopped union and coupling."""
import json
from fractions import Fraction as Q
from pathlib import Path
W=Path.cwd()
def enumerate_tree(cap,p_cap,node):
 reach=[Q(0)]*cap;leaves=[];zero=[];entry_checks=[]
 def visit(history,p):
  j=len(history)+1
  if j>cap:leaves.append((history,p,'ZERO'));return
  reach[j-1]+=p;options=node(history,j);assert sum(v[0] for v in options)==1
  conditional_bad=sum(prob for prob,bad,accept,tag in options if bad);assert conditional_bad<=p_cap;entry_checks.append(dict(history=[x[2] for x in history],bad_probability=str(conditional_bad)))
  for prob,bad,accept,tag in options:
   if not prob:zero.append(dict(history=[x[2] for x in history],tag=tag));continue
   h=history+[(bad,accept,tag)]
   if accept:leaves.append((h,p*prob,'BYTES_'+str(j)+'_'+str(sum(x[0] for x in h))))
   else:visit(h,p*prob)
 visit([],Q(1));assert sum(p for h,p,o in leaves)==1
 P={};Qchecked={};bad=success=both=Q(0)
 for h,p,o in leaves:
  b=any(x[0] for x in h);bad+=p*b;success+=p*(o!='ZERO');both+=p*(b and o!='ZERO');P[o]=P.get(o,Q(0))+p
  checked='PRECAST_EXIT' if b else o;Qchecked[checked]=Qchecked.get(checked,Q(0))+p
 tv=sum(abs(P.get(x,0)-Qchecked.get(x,0)) for x in set(P)|set(Qchecked))/2
 assert tv==bad and bad<=p_cap*sum(reach)<=cap*p_cap and bad<=1-(1-p_cap)**cap
 return dict(cap=cap,p_cap=str(p_cap),reached_probabilities=list(map(str,reach)),expected_reached=str(sum(reach)),WholeRegionBad=str(bad),Bad_and_positive=str(both),positive_probability=str(success),Bad_conditioned_on_positive=str(both/success) if success else None,weighted_union=str(p_cap*sum(reach)),uniform_union=str(cap*p_cap),hazard_bound=str(1-(1-p_cap)**cap),tagged_TV=str(tv),original_distribution={k:str(v) for k,v in P.items()},checked_distribution={k:str(v) for k,v in Qchecked.items()},zero_probability_branches=zero,conditional_entry_checks=entry_checks,leaf_count=len(leaves))
def adaptive(h,j):
 bad=Q(1,32) if (j+sum(x[0] for x in h))%2 else Q(1,64);accept=Q(1,4) if h and h[-1][0] else Q(1,2)
 return [(accept,False,True,'good_accept'),(bad,True,False,'bad_reject'),(1-accept-bad,False,False,'good_reject'),(Q(0),True,True,'impossible')]
a=enumerate_tree(4,Q(1,32),adaptive)
b=enumerate_tree(3,Q(1,128),lambda h,j:[(Q(1,128),True,True,'bad_accept'),(Q(127,128),False,False,'good_reject')]);assert b['Bad_conditioned_on_positive']=='1' and Q(b['WholeRegionBad'])<Q(1,32)
c=enumerate_tree(4,Q(1,16),lambda h,j:[(Q(1),False,False,'reject'),(Q(0),True,True,'impossible')]);assert c['Bad_conditioned_on_positive'] is None
# Disjoint events from an adaptive second transition, not independent marginals.
joint={(True,False):Q(1,10),(False,True):Q(9,10)*Q(1,9),(False,False):Q(9,10)*Q(8,9)}
union=sum(p for (x,y),p in joint.items() if x or y);m1=sum(p for (x,y),p in joint.items() if x);m2=sum(p for (x,y),p in joint.items() if y);wrong=1-(1-m1)*(1-m2);assert union>wrong
out=dict(status='PASS_EXACT_ADAPTIVE_STOPPED_UNION_COUPLING_AND_CONDITIONING',game='finite toy models of G_retry_IID scheduler, no source Emitted membership',adaptive=a,success_countermodel=b,zero_success=c,independent_marginal_countermodel=dict(actual_union=str(union),wrong_product_formula=str(wrong),marginals=[str(m1),str(m2)],second_hazard_given_no_first_bad='1/9'),uniform_conditional_hazard_product_bound='sound without independence when conditional hazards<=p; proved separately, not classified as a failing mutation')
(W/'artifacts/probability_controls.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],adaptive_leaves=a['leaf_count'],adaptive_bad=a['WholeRegionBad'],tagged_TV=a['tagged_TV'],bad_given_success=b['Bad_conditioned_on_positive'],zero_success_undefined=True),indent=2))
