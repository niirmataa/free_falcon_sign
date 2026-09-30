import json,os,shutil,sys
from pathlib import Path
from job import W,env_for,step,LEAN,SAGE,sha
root=W/'run/GAME_BINDING_REVIEW_001';D=root/(sys.argv[1] if len(sys.argv)>1 else 'checks_001');D.mkdir(exist_ok=False)
source=root/'source_snapshot_6f0d4f42'
assert json.loads((root/'replay_001/REPLAY_RESULT.json').read_text())['status']=='FRESH_REPLAY_PASS'
for name in ['ReviewerChecks.lean','resource_controls.sage']:shutil.copyfile(root/name,D/name)
env=env_for(D);env['LEAN_PATH']=str(root/'replay_001/lib')+':'+env['LEAN_PATH']
jobs=[]
jobs.append(step(D,'sage_resource_controls',[SAGE,str(D/'resource_controls.sage')],D,env))
jobs.append(step(D,'lean_resource_controls',[str(LEAN),'-j1','-M6144',str(D/'ReviewerChecks.lean')],D,env))
(D/'EXECUTION_RECEIPTS.json').write_text(json.dumps(jobs,indent=2)+'\n')
result=dict(source_manifest='6f0d4f42f1a71526070864f162252e4105d012786104d50ef1ed16eca7975e7f',
    status='PASS' if all(r['exit_code']==0 for r in jobs) else 'FAIL',
    sources={name:sha(D/name) for name in ['ReviewerChecks.lean','resource_controls.sage']},jobs=jobs)
(D/'RESULT.json').write_text(json.dumps(result,indent=2)+'\n')
print('REVIEW_CONTROLS',result['status'])
if result['status']!='PASS':raise SystemExit(1)
