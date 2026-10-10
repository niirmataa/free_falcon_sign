# sage CROSSCHECK_MARGINAL_006.sage CERT512 CERT768 OUTDIR
import json,sys
from pathlib import Path
a=json.loads(Path(sys.argv[1]).read_text());b=json.loads(Path(sys.argv[2]).read_text())
out=Path(sys.argv[3]);out.mkdir(parents=True,exist_ok=True)
p=out/'crosscheck.json'
if p.exists():raise FileExistsError('fresh result required')
assert (a['precision_bits'],b['precision_bits'])==(512,768)
assert a['exact_toy_cases']==b['exact_toy_cases'] and len(a['exact_toy_cases'])==102
assert a['universal_crude_bounds']==b['universal_crude_bounds']
endpoint_count=0
def check_endpoints(obj):
    global endpoint_count
    if isinstance(obj,dict):
        if 'lower_exact' in obj:
            for key in ['lower_exact','upper_exact']:
                denominator=QQ(obj[key]).denominator()
                assert denominator>0 and (denominator & (denominator-1))==0
                endpoint_count+=1
        for value in obj.values(): check_endpoints(value)
    elif isinstance(obj,list):
        for value in obj:check_endpoints(value)
check_endpoints(a);check_endpoints(b)
# Regression: QQ(MPFR) can move an upper endpoint inward; never use it here.
probe=(RealBallField(512)(1)/3).upper()
assert QQ(probe)<probe.exact_rational()
paths=[('whole_vector_rejection','Gtriangle'),
       ('fresh_conditional_budget','core_excess_ball'),
       ('fresh_conditional_budget','joint_excess_ball')]
for group,key in paths:
    x=a[group][key];y=b[group][key]
    assert max(QQ(x['lower_exact']),QQ(y['lower_exact']))<=min(QQ(x['upper_exact']),QQ(y['upper_exact']))
for v in [a,b]:
    assert 0<QQ(v['whole_vector_rejection']['acceptance_upper']['upper_exact'])<QQ(2)^(-767)
    assert 0<QQ(v['fresh_conditional_budget']['core_excess_ball']['upper_exact'])<QQ(2)^(-230)
    assert 0<QQ(v['fresh_conditional_budget']['joint_excess_ball']['upper_exact'])<QQ(2)^(-119)
p.write_text(json.dumps({'status':'PASS','identical_exact_law_cases':int(102),
 'common_real_intervals_checked':int(3),'claim_inequalities_checked_at_both_precisions':int(3),
 'dyadic_endpoints_checked':int(endpoint_count),'inward_QQ_conversion_negative_control':True,
 'note':'Acceptance upper bounds depend on computed endpoints, so only their claimed threshold is cross-checked.'},indent=2)+'\n')
print('PASS: 102 identical exact laws, 3 interval overlaps, 3 bounds at each precision')
