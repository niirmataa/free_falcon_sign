# Native Sage vendor checks and a bounded actual NTRU usvp sample per profile.
assert parent(1) is ZZ and parent(1/3) is QQ and 2^10 == 1024
import os,json,sys
from pathlib import Path
from sage.env import SAGE_VERSION
W=Path(os.environ['FT_REVIEW_W']);O=Path(os.environ['FT_REVIEW_OUTPUT'])
S=W/'inputs/campaign';sys.path.insert(0,str(W/'inputs/vendor'))
from estimator import NTRU
from estimator.nd import Ternary
from estimator.ntru_parameters import NTRUParameters
from estimator.reduction import ADPS16,BDGL16,LaaMosPol14,CheNgu12,ABFKSW20,ABLR21,ChaLoy21,GJ21,MATZOV
models={
 'MATZOV_ListDecoding':lambda:MATZOV(nn='ListDecoding'),
 'MATZOV_quantum':lambda:MATZOV(nn='quantum'),
 'GJ21':GJ21,'ChaLoy21':ChaLoy21,'ABFKSW20':ABFKSW20,'ABLR21':ABLR21,
 'ADPS16_classical':lambda:ADPS16(mode='classical'),
 'ADPS16_quantum':lambda:ADPS16(mode='quantum'),
 'ADPS16_paranoid':lambda:ADPS16(mode='paranoid'),
 'BDGL16':BDGL16,'LaaMosPol14':LaaMosPol14,'CheNgu12':CheNgu12}
stored=json.loads((S/'artifacts/rc_cost_surface.json').read_text())['rows']
R=RealField(192);surface=[]
for row in stored:
    rc=models[row['cost_model']]();errors=[];deltas=[]
    for shift in (-2,0,2):
        try:
            cost=rc(int(row['beta']+shift),int(row['d']))
            bits=R(log(cost)/log(2))
            key='log2_rop_%+d'%shift
            assert key in row,(row,key)
            error=abs(bits-R(str(row[key])))
            assert error<R(1)/10^8,(row,key,error)
            deltas.append(str(error))
        except KeyError as e:
            errors.append(repr(e));break
    if errors:assert row.get('error')==errors[0],(row,errors)
    else:assert 'error' not in row
    surface.append({'scheme':row['scheme'],'attack':row['attack'],'variant':row['variant'],'cost_model':row['cost_model'],'error_reproduced':errors,'log2_errors':deltas})

# The supported spelling is exercised but does not modify old campaign rows.
fixed=MATZOV(nn='classical')
fixed_example=R(log(fixed(int(1077),int(3072)))/log(2))

grid=[json.loads(x) for x in (S/'artifacts/ntru_grid.ndjson').read_text().splitlines()]
samples=[]
for tag,n in [('FT768',768),('FT1536',1536),('FT3072',3072)]:
    expected=next(r for r in grid if r.get('scheme')==tag and r.get('cost_model')=='ADPS16_classical' and r.get('shape_model')=='default_GSA')['attacks']['usvp']
    p=NTRUParameters(n=int(n),q=int(18433),Xs=Ternary,Xe=Ternary,m=int(n),tag=tag+'_SKR_RAW',ntru_type='circulant')
    result=NTRU.estimate(p,red_cost_model=ADPS16(mode='classical'),
                         deny_list=('dsd','bdd','bdd_hybrid','bdd_mitm_hybrid'),
                         jobs=int(1),catch_exceptions=False,quiet=True)['usvp']
    if result['rop'] == oo:
        assert str(expected['rop']).lower() in ('inf','infinity','+infinity')
        samples.append({'scheme':tag,'cost_model':'ADPS16_classical','shape':'default_GSA',
                        'attack':'usvp','rop':'oo','matches':True,
                        'meaning':'no finite result from this tool/attack model; not a hardness lower bound'})
        continue
    assert result['beta']==expected['beta'] and result['d']==expected['d']
    bits=R(log(result['rop'])/log(2));old=R(str(expected['rop'])).log()/R(2).log()
    assert abs(bits-old)<R(1)/10^8
    samples.append({'scheme':tag,'cost_model':'ADPS16_classical','shape':'default_GSA',
                    'attack':'usvp','beta':str(result['beta']),'dimension':str(result['d']),
                    'rop':str(result['rop']),'log2_rop':str(bits),
                    'stored_log2_delta':str(abs(bits-old)),'matches':True})
out={'sage_version':SAGE_VERSION,'mode':'sage backend_audit.sage','vendor_commit':'3e48ef421ec256afddb3e7d2249a77eab6e9ba12',
     'surface_rows_rechecked':int(len(surface)),'surface':surface,
     'MATZOV_classical_supported_example_log2_cost':str(fixed_example),
     'actual_NTRU_usvp_samples':samples,'full_grid_rerun':False,
     'scope':'132 cost-surface rows + 12 known errors; three single-attack cells, not all 70 grid cells or all 120 planned cells'}
O.mkdir(parents=True,exist_ok=True)
(O/'backend_audit.json').write_text(json.dumps(out,indent=2,sort_keys=True)+'\n')
print('PASS_VENDOR_SURFACE_AND_THREE_ACTUAL_NTRU_SAMPLES')
