"""Bounded single-worker fresh computation: never seed derived expected outputs."""
import json,os,subprocess,sys,time
from pathlib import Path
W=Path.cwd();jobs=[]
def job(script,args=(),limit=180,asan=False,interpreter=None):jobs.append((limit,asan,[interpreter or sys.executable]+([] if interpreter else ['-B'])+['scripts/'+script]+list(args)))
job('verify_inputs.py',limit=60);job('toolchain.py',limit=240);job('binding.py',limit=60)
job('numeric_certificate.py',limit=60);job('sage_check.py',limit=120,interpreter='/home/footfalcon/.local/bin/sage')
job('fixtures.py',limit=180);job('probability_controls.py',limit=60)
job('build.py',['normal']);job('build.py',['sanitized'],asan=True)
for mode in ['normal','sanitized']:
 for g in range(3):job('native_checks.py',[mode,str(g)],asan=mode=='sanitized')
 job('reset_checks.py',[mode],limit=60,asan=mode=='sanitized')
job('mutations.py',limit=240)
for g in range(6):job('kernel_build.py',[str(g)],limit=240)
job('audit.py',limit=180);job('metadata.py',limit=60);job('semantic.py',limit=60)
receipts=[]
for i,(limit,asan,cmd) in enumerate(jobs):
 env=dict(os.environ);env['FT1536_ASAN']='1' if asan else '0';t=time.monotonic()
 p=subprocess.run([sys.executable,'-B','scripts/run.py',str(limit)]+cmd,cwd=W,env=env,capture_output=True,timeout=limit+15)
 for stream,b in [('stdout',p.stdout),('stderr',p.stderr)]:(W/'logs'/('recipe_'+str(i)+'.'+stream)).write_bytes(b)
 receipts.append(dict(index=i,argv=cmd,asan=asan,wall_limit=limit,exit_code=p.returncode,elapsed=time.monotonic()-t))
 (W/'artifacts/recipe_receipts.json').write_text(json.dumps(receipts,indent=2)+'\n')
 print('RECIPE',i,cmd[-2:],p.returncode,flush=True)
 if p.returncode:raise SystemExit(p.returncode)
print('FRESH_RECIPE_COMPLETED',len(jobs))
