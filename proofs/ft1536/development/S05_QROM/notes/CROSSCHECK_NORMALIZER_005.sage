# sage CROSSCHECK_NORMALIZER_005.sage CERT512 CERT768 OUTDIR
# Exact QQ comparison of outward endpoints; this is an arithmetic replay check.
import json,sys
from pathlib import Path
a=json.loads(Path(sys.argv[1]).read_text()); b=json.loads(Path(sys.argv[2]).read_text())
out=Path(sys.argv[3]); out.mkdir(parents=True,exist_ok=True)
dest=out/'crosscheck.json'
if dest.exists(): raise FileExistsError('fresh result required')
assert (a['precision_bits'],b['precision_bits'])==(512,768)
checked=[]
precision_dependent=[]
def visit(x,y,path):
    if isinstance(x,dict):
        assert isinstance(y,dict) and set(x)==set(y)
        if 'lower_exact' in x:
            if path.rsplit('/',1)[-1] in ['relative_width','normalizer_relative_width','inverse_relative_width']:
                # Widths of computed enclosures are precision-dependent outputs,
                # not two enclosures of one mathematical real number.
                precision_dependent.append(path)
                return
            xl,xu=QQ(x['lower_exact']),QQ(x['upper_exact'])
            yl,yu=QQ(y['lower_exact']),QQ(y['upper_exact'])
            assert xl<=xu and yl<=yu and max(xl,yl)<=min(xu,yu)
            checked.append(path)
        for k in x: visit(x[k],y[k],path+'/'+k)
    elif isinstance(x,list):
        assert isinstance(y,list) and len(x)==len(y)
        for i in range(len(x)): visit(x[i],y[i],path+'/'+str(i))
visit(a,b,'')
assert len(checked)>=48
for c in [a,b]:
    for key in ['normalizer_relative_width','inverse_relative_width','cap16_full_reply_TV_upper']:
        assert 0<QQ(c['h1_c0_full_fiber'][key]['upper_exact'])<QQ(2)^(-180)
    assert QQ(c['sequential_pre_norm_moment']['block_lower']['lower_exact'])>4
    assert QQ(c['reciprocal_tail_warning']['actual_log2_Z1_zero_over_repeated_9216_0']['lower_exact'])>78000
dest.write_text(json.dumps({'status':'PASS_EXACT_ENDPOINT_CROSSCHECK','intervals_checked':len(checked),
    'paths':checked,'precision_dependent_widths_not_compared_for_overlap':precision_dependent,
    'non_claim':'Precision agreement is not independent theorem verification.'},indent=2)+'\n')
print('PASS:',len(checked),'exact endpoint overlaps and claim-bound assertions')
