"""Direct inverse evaluation, adjoint coefficients and independent constant-basis variance."""
import json,sys
from pathlib import Path
sys.path.insert(0,str(Path.cwd()/'scripts'))
from sage.all import QQ,RealBallField
from linear_noise import NoiseMap
from dyadic import value
from replaylib import sha
W=Path.cwd();name=['constant_basis','nonzero_complex_tree'][int(sys.argv[1])];data=json.loads((W/'artifacts/controls'/(name+'_data.json')).read_text());RB=RealBallField(256)
def qv(w):v=value(w);return QQ(v.numerator)/v.denominator
xi=[qv(int(r['mu'],16))-r['sample'] for r in data['calls']];sigmas=[qv(int(r['sigma'],16)) for r in data['calls']]
mapping=json.loads((W/'SOURCE_NOISE_MAP.json').read_text());nm=NoiseMap(data['tree'],data['basis']);F=nm.forward(xi);ideal=[nm.inverse_fast(f) for f in F]
assert [p for _,p in nm.leaves]==[r['leaf_word'] for r in mapping['call_order'][::2]]
for i,r in enumerate(mapping['call_order']):
 expected=data['tree'][r['leaf_word']]
 if r['width_class']=='stored':assert int(data['calls'][i]['sigma'],16)==expected
errors=[]
for j in range(2):
 e=[abs(RB(qv(w))-z) for w,z in zip(data['post']['t'+str(j)],ideal[j])];assert all(x<RB(QQ(json.loads((W/'ERROR_LEDGER.json').read_text())['total_source_error_exact_outward'])) for x in e);errors.append(e)
selected=[0,1,127,255,767,768,769,1023,1535];rows=[];coeffs={};maxVar=RB(0)
V=QQ(json.loads((W/'VARIANCE_BRIDGE.json').read_text())['variance_proxy_exact_outward'])
for component in range(2):
 for r in selected:
  a=nm.row(component,r);assert len(a)==3072
  direct=nm.inverse_direct(F[component],r);dot=sum(ai*RB(x) for ai,x in zip(a,xi));assert abs(dot-direct)<RB(QQ(1)/2**160) and abs(direct-ideal[component][r])<RB(QQ(1)/2**160)
  proxy=sum(ai**2*RB(s)**2 for ai,s in zip(a,sigmas));assert proxy<RB(V)
  if name=='constant_basis':
   L=qv(data['tree'][0]);B0=qv(data['basis'][1536*component]);B1=qv(data['basis'][1536*(component+2)]);perp=B1-L*B0
   right0=sigmas[1];right1=sigmas[0];left0=sigmas[1537];left1=sigmas[1536]
   vr=right0**2+right1**2/4 if r<768 else right1**2;vl=left0**2+left1**2/4 if r<768 else left1**2
   closed=B0**2*vl+perp**2*vr;assert abs(proxy-RB(closed))<RB(QQ(1)/2**120)
  else:closed=None
  maxVar=proxy if proxy.upper()>maxVar.upper() else maxVar
  rows.append(dict(component=component,coefficient=r,source_value=str(qv(data['post']['t'+str(component)][r])),exact_map_ball=str(direct),source_error_ball=str(errors[component][r]),variance_proxy_ball=str(proxy),independent_constant_formula=str(closed) if closed is not None else None,adjoint_dot_matches_direct=True))
  if r in [0,768]:coeffs[str(component)+'_'+str(r)]=[str(z) for z in a]
# Independent impulse responses at selected leaf positions (not native source histories).
impulses=[]
for i in [0,1,510,511,1536,1537,3070,3071]:
 unit=[0]*3072;unit[i]=1;FF=nm.forward(unit)
 for comp,r in [(0,0),(1,768)]:
  direct=nm.inverse_direct(FF[comp],r);a=nm.row(comp,r);assert abs(direct-a[i])<RB(QQ(1)/2**160);impulses.append(dict(innovation=i,component=comp,coefficient=r,direct=str(direct),adjoint=str(a[i])))
maxError=max((e for es in errors for e in es),key=lambda x:x.upper());nonzero=any(e.lower()>0 for es in errors for e in es)
out=dict(status='PASS_SOURCE_NOISE_MAP_VARIANCE_AND_ROUNDOFF_CONTROLS',game='IID_BUFFER',reference='Q_S',fixture=name,scope='LOCAL_SYNTHETIC_ENTRY, no Emitted/canonical-key membership; not the proof of uniform supremum',source_data_sha256=sha(W/'artifacts/controls'/(name+'_data.json')),all_coefficients_checked=3072,selected_adjoint_rows=rows,impulse_crosschecks=impulses,max_actual_source_error_ball=str(maxError),nonzero_source_roundoff_observed=nonzero,max_selected_variance_ball=str(maxVar),physical_order_all3072_matches=True,coefficients_do_not_read_history=True)
(W/'artifacts'/('map_oracle_'+name+'.json')).write_text(json.dumps(out,indent=2)+'\n');(W/'artifacts'/('adjoint_'+name+'.json')).write_text(json.dumps(dict(coefficients=coeffs,scope='RBF-enclosed selected complete rows, ordered3072 actual innovation coordinates'),indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k not in ['selected_adjoint_rows','impulse_crosschecks']},indent=2))
