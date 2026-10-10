#!/usr/bin/env python3
"""S05-only dependency snapshot and bounded Lean build. No mathematics in Python.
Existing source3 jobs are read as pinned data, never resumed or mutated.
"""
from pathlib import Path
import json,hashlib,subprocess,os,sys,time,resource,shutil
S=Path(__file__).resolve().parent.parent;REPO=S.parents[3]
D=REPO/'proofs/ft1536/development/T12_1';BUILD=S/'.build/key_support_011'
BASE=BUILD/'dependencies';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
SEED=D/'source3/.build/jobs/keygen_make_attempt_spine_056_003/SOURCE_INPUTS.json'
INDEX=D/'source3/.build/cache/CACHE_INDEX.json'

def prepare():
 BASE.mkdir(parents=True,exist_ok=False)
 data=json.loads(SEED.read_text());cache={v['module']:v for v in data['reused']}
 cache['Source3.KeygenMakeAttemptSpine']=json.loads(INDEX.read_text())['Source3.KeygenMakeAttemptSpine']
 archived={}
 for owner in [D/'run2',D/'source3']:
  for v in json.loads((owner/'ARCHIVED_DEPENDENCIES.json').read_text())['files']:
   if v['target'].startswith('formal/') and v['target'].endswith('.lean'):
    archived[v['target'][7:-5].replace('/','.')]=REPO/v['stage']
 def source(m):
  c=cache.get(m,{})
  choices=[D/'run2/formal'/(m.replace('.','/')+'.lean'),D/'source3/formal'/(m.replace('.','/')+'.lean'),archived.get(m)]
  choices += [Path(c[k]) for k in ['current_source','source'] if k in c]
  return next(p for p in choices if p and p.is_file())
 records={};order=[]
 def visit(m):
  if m.startswith(('Mathlib','Lean','Std','Batteries','Aesop','Qq','Init')) or m in records:return
  p=source(m);rec={'module':m,'source':str(p),'source_sha256':sha(p),'imports':[]};records[m]=rec
  for line in p.read_text().splitlines():
   if line.startswith('import '):
    for dep in line.split()[1:]:rec['imports'].append(dep);visit(dep)
  target=BASE/'sources'/(m.replace('.','/')+'.lean');target.parent.mkdir(parents=True,exist_ok=True);target.write_bytes(p.read_bytes())
  if m in cache:
   c=cache[m];assert rec['source_sha256']==c['source_sha256'],('source mismatch',m)
   artifact=Path(c['artifact']);assert sha(artifact)==c['artifact_sha256'],('artifact mismatch',m)
   dst=BASE/'lib'/(m.replace('.','/')+'.olean');dst.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(artifact,dst)
   rec.update({'mode':'pinned_read_only_reuse','artifact_sha256':c['artifact_sha256'],'origin':c.get('origin'),'original_artifact':str(artifact)})
   for suffix in ['.private','.server']:
    extra=Path(str(artifact)+suffix)
    if extra.exists():shutil.copyfile(extra,Path(str(dst)+suffix))
  else:rec['mode']='fresh_dependency_build';order.append(m)
 for m in ['Run2.LawBinding','Source3.KeygenMakeAttemptSpine','Run2.ActualNTRUFiber']:visit(m)
 result={'base_commit':subprocess.check_output(['git','rev-parse','HEAD'],cwd=REPO,text=True).strip(),'seed_source_inputs_sha256':sha(SEED),'library_roots':data['library_roots'],'modules':records,'fresh_order':order}
 (BASE/'PINS.json').write_text(json.dumps(result,indent=2)+'\n')
 print(json.dumps({'modules':len(records),'fresh':len(order),'pins':str(BASE/'PINS.json')}))

def compile_one(src,outdir,module,lib,libs):
 outdir.mkdir(parents=True,exist_ok=False)
 snap=outdir/'source'/(module.replace('.','/')+'.lean');snap.parent.mkdir(parents=True,exist_ok=True);snap.write_bytes(src.read_bytes())
 lean=Path(libs['lean']['build']).parents[1]/'bin/lean'
 env=os.environ.copy();env['LEAN_PATH']=':'.join([str(lib),str(BASE/'lib')]+[v['build'] for k,v in libs.items() if k!='lean'])
 for k,sub in [('TMPDIR','tmp'),('XDG_CACHE_HOME','cache')]:
  p=BUILD/sub;p.mkdir(parents=True,exist_ok=True);env[k]=str(p)
 artifact=lib/(module.replace('.','/')+'.olean');artifact.parent.mkdir(parents=True,exist_ok=True)
 assert not artifact.exists(),('never overwrite artifact',artifact)
 cmd=[str(lean),'--root='+str(outdir/'source'),'-j1','-M4096','-o',str(artifact),str(snap)]
 def caps():
  resource.setrlimit(resource.RLIMIT_AS,(8*1024**3,8*1024**3));resource.setrlimit(resource.RLIMIT_CPU,(110,115));os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
 t=time.monotonic();status='completed'
 with (outdir/'stdout.txt').open('w') as so,(outdir/'stderr.txt').open('w') as se:
  try:code=subprocess.run(cmd,cwd=outdir,env=env,stdout=so,stderr=se,timeout=120,preexec_fn=caps).returncode
  except subprocess.TimeoutExpired:code=None;status='timeout'
 log=(outdir/'stdout.txt').read_text()+(outdir/'stderr.txt').read_text()
 rec={'module':module,'command':cmd,'status':status,'exit_code':code,'elapsed_seconds':time.monotonic()-t,'source_sha256':sha(src),'snapshot_sha256':sha(snap),'artifact':str(artifact),'artifact_sha256':sha(artifact) if artifact.exists() else None,'stdout_sha256':sha(outdir/'stdout.txt'),'stderr_sha256':sha(outdir/'stderr.txt'),'warning_count':log.count('warning:'),'error_count':log.count('error:'),'runner_sha256':sha(Path(__file__)),'dependency_pins_sha256':sha(BASE/'PINS.json'),'memory_GiB':8,'cpu_seconds':110,'wall_seconds':120,'cores':1}
 (outdir/'receipt.json').write_text(json.dumps(rec,indent=2)+'\n')
 print(json.dumps({k:rec[k] for k in ['module','status','exit_code','elapsed_seconds','warning_count']}),flush=True)
 return code==0

if sys.argv[1]=='prepare':prepare()
elif sys.argv[1]=='dependencies':
 data=json.loads((BASE/'PINS.json').read_text())
 for m in data['fresh_order']:
  out=BASE/'runs'/m.replace('.','_')
  if out.exists():
   r=json.loads((out/'receipt.json').read_text());assert r['exit_code']==0 and sha(Path(r['artifact']))==r['artifact_sha256'];continue
  src=BASE/'sources'/(m.replace('.','/')+'.lean')
  if not compile_one(src,out,m,BASE/'lib',data['library_roots']):sys.exit(1)
elif sys.argv[1]=='module':
 data=json.loads((BASE/'PINS.json').read_text());name,label=sys.argv[2:4]
 out=BUILD/'runs'/label
 if not compile_one(S/'formal'/(name+'.lean'),out,name,out/'lib',data['library_roots']):sys.exit(1)
else:raise ValueError('prepare | dependencies | module NAME FRESH_LABEL')
