#!/usr/bin/env python3
"""Independent program-routing/manifest freshness controls; no estimator math."""
import copy
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys

W = Path(os.environ['FT_REVIEW_W'])
O = Path(os.environ['FT_REVIEW_OUTPUT'])
source = W/'inputs/subject/scripts/estimator_campaign/run_campaign.sage'
sha = lambda p: hashlib.sha256(Path(p).read_bytes()).hexdigest()
runner_sha = sha(source)
O.mkdir(parents=True,exist_ok=True)
template = {'estimator_commit':'1'*40,
            'modeling_points_closed':['circulant_vs_phi3n','p2_coset_threshold_semantics'],
            'model_mapping':{}}
for p in ('P1','P2'):
    for n in (768,1536,3072):
        template['model_mapping'][f'{p}:{n}'] = {
            'model_kind':'NTRU_PRIMAL' if p == 'P1' else 'ISIS_COSET',
            'estimator_symbol':'NTRU.estimate' if p == 'P1' else 'ISIS.estimate',
            'mapping_sha':'2'*64}
specs = [('default',None,True,3,False),('empty',{},True,4,False)]
def add(name,mutate,code=4,imported=False,allow=True):
    p=copy.deepcopy(template);mutate(p);specs.append((name,p,allow,code,imported))
add('missing_commit',lambda p:p.pop('estimator_commit'))
add('bad_commit',lambda p:p.update(estimator_commit='wrong'))
add('missing_modeling',lambda p:p.update(modeling_points_closed=[]))
add('missing_cell',lambda p:p['model_mapping'].pop('P2:3072'))
add('missing_mapping_sha',lambda p:p['model_mapping']['P2:768'].pop('mapping_sha'))
add('SIS_kind',lambda p:p['model_mapping']['P2:1536'].update(model_kind='HOMOGENEOUS_SIS'))
add('SIS_symbol',lambda p:p['model_mapping']['P2:1536'].update(estimator_symbol='SIS.estimate'))
add('SISParameters_symbol',lambda p:p['model_mapping']['P2:1536'].update(estimator_symbol='SISParameters'))
add('wrong_kind',lambda p:p['model_mapping']['P2:1536'].update(model_kind='NTRU_PRIMAL'))
add('valid_without_allow',lambda p:None,code=0,allow=False)
add('valid_mock_only',lambda p:None,code=0,imported=True)
rows=[]
mock='''import os,json
from pathlib import Path
Path(os.environ['REVIEW_MARKER']).write_text('imported')
class Backend:
    def __init__(self,name): self.name=name
    def estimate(self,params):
        with open(os.environ['REVIEW_CALLS'],'a') as f:
            f.write(json.dumps({'backend':self.name,'problem':params['problem'],'N':params['N']})+'\\n')
        return 'REVIEW_MOCK_ONLY_NO_COST'
NTRU=Backend('NTRU')
ISIS=Backend('ISIS')
SIS=Backend('SIS')
'''
for name,prem,allow,expected_code,expected_import in specs:
    d=O/name;(d/'mock').mkdir(parents=True)
    (d/'mock/estimator.py').write_text(mock)
    runner=d/'run_campaign.sage';runner.write_bytes(source.read_bytes())
    argv=[sys.executable,'-B',str(runner),str(d/'result')]
    if prem is not None:
        (d/'premises.json').write_text(json.dumps(prem,sort_keys=True)+'\n')
        argv += ['--premises',str(d/'premises.json')]
    if allow:argv+=['--allow-backend']
    env=os.environ.copy();env.update(PYTHONPATH=str(d/'mock'),REVIEW_MARKER=str(d/'marker'),REVIEW_CALLS=str(d/'calls.jsonl'))
    r=subprocess.run(argv,cwd=d,env=env,capture_output=True,timeout=30)
    (d/'stdout').write_bytes(r.stdout);(d/'stderr').write_bytes(r.stderr)
    imported=(d/'marker').exists()
    calls=[json.loads(x) for x in (d/'calls.jsonl').read_text().splitlines()] if (d/'calls.jsonl').exists() else []
    assert r.returncode==expected_code,(name,r.returncode,r.stderr)
    assert imported==expected_import,(name,imported)
    assert (len(calls)==6 and all(x['backend']!='SIS' for x in calls)) if imported else not calls
    assert sha(runner)==runner_sha
    rows.append({'case':name,'argv':argv,'runner_sha256':runner_sha,'exit_code':r.returncode,
                 'backend_imported':imported,'calls':len(calls),'pass':True,
                 'stdout_sha256':sha(d/'stdout'),'stderr_sha256':sha(d/'stderr')})
fresh=[]
for name,program in [('noop','pass'),('failure','raise SystemExit(7)')]:
    d=O/('freshness_'+name);d.mkdir()
    target=d/'target.json';target.write_bytes((W/'inputs/subject/results/chi_tail.json').read_bytes())
    old_sha=sha(target);target.unlink()
    argv=[sys.executable,'-B','-c',program]
    r=subprocess.run(argv,cwd=d,capture_output=True,timeout=10)
    (d/'stdout').write_bytes(r.stdout);(d/'stderr').write_bytes(r.stderr)
    fresh.append({'producer':name,'argv':argv,'exit':r.returncode,'deleted_copied_sha256':old_sha,
                  'target_exists':target.exists(),'freshness_guard_accepts':r.returncode==0 and target.exists()})
    assert not target.exists()
out={'scope':'R4 guard/program controls with a reviewer mock; no real estimator or attack cost',
     'cases':rows,'all_pass':True,'freshness_negative_controls':fresh,
     'premises_validation_boundary':'checks declared premises/shape, not truth of modeling statements or actual backend commit identity',
     'real_estimator_executed':False}
(O/'independent_r4.json').write_text(json.dumps(out,indent=2,sort_keys=True)+'\n')
print(json.dumps({'R4_cases':len(rows),'all_pass':True,'freshness_negative_controls':fresh},indent=2))
