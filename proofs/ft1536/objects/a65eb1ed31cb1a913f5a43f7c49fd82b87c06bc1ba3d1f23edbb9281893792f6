import hashlib,json,sys
from fractions import Fraction as F
from pathlib import Path
from dyadic import value,rn,sqrt_rn,floor_bits,floor_parts,fraction_json
W=Path.cwd();a=json.loads((W/'artifacts/probes_normal.json').read_text());b=json.loads((W/'artifacts/probes_san.json').read_text());assert a==b
issues=[];checked=0;model=[]
for r in a:
 args=r['args'];op=args[0]
 if op=='floor':
  x=int(args[1],16);out=int(r['output']);assert floor_bits(x)==out
  if (x>>52)&2047<=1053:assert floor_parts(x)==out
  exact=value(x);want=exact.numerator//exact.denominator;checked+=1
  if out!=want:issues.append(dict(kind='floor',input=args[1],source=out,mathematical=want,required_reachability='NOT_ESTABLISHED'))
 elif op in ['add','sub','mul','div','half','neg','sqrt']:
  x=value(int(args[1],16));y=value(int(args[2],16)) if len(args)>2 else None;out=int(r['output'],16)
  if op=='sqrt':
   if x<0:continue
   expected=sqrt_rn(x);true_val=None
  else:
   v={'add':lambda:x+y,'sub':lambda:x-y,'mul':lambda:x*y,'div':lambda:x/y,'half':lambda:x/2,'neg':lambda:-x}[op]()
   true_val=v;expected=rn(v)
  actual=value(out);ev=value(expected);checked+=1
  equal_value=actual==ev
  item=dict(op=op,args=args[1:],source_bits=r['output'],oracle_RN_bits=f'{expected:016x}',same_exact_value=equal_value)
  if true_val is not None:
   err=abs(actual-true_val);budget=abs(true_val)*F(1,1<<53)+F(1,1<<1075)
   item.update(exact_error=fraction_json(err),mixed_IEEE_budget=fraction_json(budget),within_u_abs_plus_eta=err<=budget)
  model.append(item)
  if not equal_value:issues.append(dict(kind='backend_not_complete_IEEE',**item,required_reachability='SYNTHETIC_EXTENDED_DOMAIN_ONLY'))
negative_zero=next(r for r in a if r['args']==['floor','8000000000000000']);assert negative_zero['output']=='-1'
guard=next(r for r in a if r['args']==['guard','8000000000000000','3ff0000000000000']);assert guard['output']=='1 1 1'
flush=next(r for r in model if r['op']=='mul' and r['args']==['0010000000000000','3fe8000000000000'])
assert not flush['within_u_abs_plus_eta']
subnormal=next(r for r in model if r['op']=='half' and r['args']==['0010000000000001']);assert not subnormal['same_exact_value']
rounded=next(r for r in model if r['op']=='add' and r['args']==['3ff0000000000000','3c90000000000000'])
assert rounded['within_u_abs_plus_eta'] and int(rounded['exact_error']['n'])>0
width=next(r['output'] for r in a if r['args']==['widths']).splitlines();endpoints=[]
for row in width:
 _,db,sig,paired,d0,d1=row.split();d=value(int(db,16))
 sd=sqrt_rn(d);sg=rn(F(768)/value(sd));pg=rn(value(0x3ff279a74590331c)*value(sg))
 def inv2sq(w):return rn(F(1)/value(rn(value(rn(value(w)**2))*2)))
 assert [int(sig,16),int(paired,16),int(d0,16),int(d1,16)]==[sg,pg,inv2sq(sg),inv2sq(pg)]
 endpoints.append(dict(D_bits=db,sigma_bits=sig,paired_sigma_bits=paired,dss_bits=d0,paired_dss_bits=d1,oracle='exact dyadic RN-even integer sqrt'))
out=dict(status='LOCAL_CONTROLS_PASS_WITH_EXPLICIT_EXTENDED_DOMAIN_FAILURES',normal_sanitizer_equal=True,comparisons=checked,
 negative_zero_floor_mismatch=True,negative_zero_passes_active_guards=True,universal_u_abs_plus_eta_invalid=True,
 required_domain_counterexample=False,width_endpoints=endpoints,diagnostics=issues,operations=model,
 semantic_mutations_detected=['omitted nonzero rounding error on1+2^-54','universal IEEE underflow budget','ignoring negative-zero floor exception'],noop_pass=True,
 consequence='No complete-IEEE or canonical-zero invariant may be imported without a reachable-domain proof; endpoints alone are not a universal H4 FPEMU theorem.')
(W/'artifacts/fpr_analysis.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps({k:v for k,v in out.items() if k not in ['diagnostics','operations']},indent=2))
