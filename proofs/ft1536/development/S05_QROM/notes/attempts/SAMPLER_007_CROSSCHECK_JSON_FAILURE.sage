# sage SAMPLER_007_CROSSCHECK.sage CERT512 CERT768 CHECK512 CHECK768 OUT
# Exact QQ comparison; a pair of upper-bound constructions need not overlap.
import json, sys
from pathlib import Path
a,b,ca,cb=[json.loads(Path(p).read_text()) for p in sys.argv[1:5]]
out=Path(sys.argv[5]);assert not out.exists()
def ends(v):
    lo,hi=QQ(v['lower_exact']),QQ(v['upper_exact'])
    assert lo<=hi
    assert lo.denominator().is_power_of(2) and hi.denominator().is_power_of(2)
    return lo,hi
keys=[k for k,v in a.items() if isinstance(v,dict) and 'lower_exact' in v]
for k in keys:ends(a[k]);ends(b[k])
for k in ['triangle_normalizer','global_norm_tail']:
    al,au=ends(a[k]);bl,bu=ends(b[k]);assert max(al,bl)<=min(au,bu)
targets={'implementation_density_excess':QQ(2)^(-60),
         'cap_density_contribution':QQ(2)^(-160),
         'finite_box_key_flatness':QQ(2)^(-32),
         'key_box_tail':QQ(2)^(-400),'key_norm_tail':QQ(2)^(-24),
         'full_joint_excess':QQ(2)^(-44)}
for c in [a,b]:
    for k,bound in targets.items():assert 0<=ends(c[k])[0]<=ends(c[k])[1]<bound
    assert c['kernel']==c['real_key_law_certificate']==c['all_h_certificate']==False
    assert not c['key_mass_assumption']['emitted_key_binding_proved']
for c in [ca,cb]:
    for row in c['samples']:del row['seconds']
assert ca==cb
assert a['cost']==b['cost']
out.write_text(json.dumps({'status':'PASS_EXACT_QQ_CROSSCHECK',
    'endpoint_fields_checked':len(keys),'precisions':[512,768],
    'overlap_required':['triangle_normalizer','global_norm_tail'],
    'upper_bound_thresholds':{k:str(v) for k,v in targets.items()},
    'synthetic_results_equal_except_timings':True,'no_key_witness_inferred':True,
    'interpretation':'Rigorous numeric bounds plus finite execution checks; no universal proof or kernel.'},indent=2)+'\n')
print('PASS: exact endpoints, numeric thresholds, deterministic execution and scope')
