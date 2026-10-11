#!/usr/bin/env python3
"""Seal/verify BATCH_065 without rewriting its predecessor or failed runs."""
from datetime import datetime,timezone
from pathlib import Path
from contextlib import redirect_stdout
from io import StringIO
import json,shutil,subprocess,sys
import job
import keygen_codec_typed_audit as producer
from keygen_intermediate_batch import path,read,pin,committed,streams
from keygen_public_first_batch import write_receipt
BASE='notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_065'
ENTRY='.build/levels_065/ENTRY_PINS_065.json'
ENTRY_SHA='c58e0f05cc3f77cef0373139c469740bf83f838280ed01d6c3888b9ece8ef92a'
AUDIT='KeygenCodecTypedAudit'
SAGE='sage/check_keygen_codec_values.sage'

def checked_inputs():
 assert not job.active(),'A proof job is active'
 assert job.sha(path(ENTRY))==ENTRY_SHA
 entry=read(ENTRY)
 assert entry['batch']=='BATCH_015-064' and len(entry['checked'])==entry['distinct_pinned_files']==12667
 assert entry['current_source_inputs']==735 and entry['active_jobs']==[]
 for p,expected in entry['checked'].items():assert job.sha(path(p))==expected,('predecessor changed',p)
 return entry

def generator():
 dest=path('.build/levels_065/audit_reproduction');dest.mkdir(exist_ok=False)
 for name in producer.MODULES+['KeygenLevelsAudit']:
  p=dest/'formal/Source3'/(name+'.lean');p.parent.mkdir(parents=True,exist_ok=True)
  shutil.copyfile(path('formal/Source3/'+name+'.lean'),p)
 original=producer.ROOT;printed=StringIO()
 try:
  producer.ROOT=dest
  with redirect_stdout(printed):producer.main()
 finally:producer.ROOT=original
 p=dest/'formal/Source3'/ (AUDIT+'.lean');actual=path('formal/Source3/'+AUDIT+'.lean')
 assert p.read_bytes()==actual.read_bytes()
 print(json.dumps(write_receipt('.build/levels_065/GENERATOR_CHECK.json',{
  'status':'BYTE_EXACT_PRODUCER_REPRODUCTION','source':pin(actual),'reproduced':pin(p),'output':printed.getvalue()})))

def predecessor(target):
 entry=checked_inputs()
 print(json.dumps(write_receipt(target,{'checked':entry['checked'],'entry':pin(ENTRY),
  'verifier_sha256':job.sha(Path(__file__)),'recorded_supersessions':entry.get('recorded_supersessions'),'active_jobs':[]})))

def seal():
 assert not path(BASE+'.json').exists(),'Never overwrite a sealed batch'
 entry=checked_inputs();preseal=read('.build/levels_065/PRESEAL.json')
 assert preseal['checked']==entry['checked'] and preseal['verifier_sha256']==job.sha(Path(__file__))
 generated=read('.build/levels_065/GENERATOR_CHECK.json')
 assert generated['status']=='BYTE_EXACT_PRODUCER_REPRODUCTION'
 assert job.sha(path(generated['source']['path']))==generated['source']['sha256']
 head=subprocess.check_output(['git','rev-parse','HEAD'],cwd=job.REPO,text=True).strip()
 assert subprocess.check_output(['git','branch','--show-current'],cwd=job.REPO,text=True).strip()=='main'
 cache=read('.build/cache/CACHE_INDEX.json');modules=[]
 for name in producer.MODULES+[AUDIT]:
  module='Source3.'+name;current=cache[module];source=path(current['source']);committed(source,head)
  directory=path(current['receipt']).parent
  record=next(r for r in read(current['receipt']) if r['name']==module.replace('.','_'))
  assert record['accepted'] and record['clean_log'] and record['exit_code']==0
  assert record['forbidden_proof_markers']==[] and record['cumulative_child_maxrss_kib']<=8*1024*1024
  snapshot=directory/'formal/Source3'/(name+'.lean');artifact=directory/'lib/Source3'/(name+'.olean')
  assert job.sha(source)==job.sha(snapshot)==record['source_sha256']==current['source_sha256']
  assert job.sha(artifact)==job.sha(path(current['artifact']))==record['olean_sha256']==current['artifact_sha256']
  for imported,expected in current.get('imports',{}).items():
   if imported in cache:assert cache[imported]['artifact_sha256']==expected,(module,imported)
  modules.append({'module':module,'source':pin(source),'snapshot':pin(snapshot),'artifact':pin(artifact),
   'cache_artifact':pin(current['artifact']),'receipt':pin(current['receipt']),
   'source_inputs':pin(directory/'SOURCE_INPUTS.json'),'logs':streams(directory,record,True),
   'maxrss_kib':record['cumulative_child_maxrss_kib'],'elapsed_s':record['elapsed_s']})
 audit_dir=path(cache['Source3.'+AUDIT]['receipt']).parent;audit=read(audit_dir/'SEARCH_AUDIT.json')
 expected=set(producer.declarations())|{'FT1536.Source3.'+n for n in producer.INHERITED}
 assert len(audit)==len(expected) and {e['name'] for e in audit}==expected
 assert len((audit_dir/'SEARCH_AUDIT_ENTRIES.jsonl').read_text().splitlines())==len(audit)
 for e in audit:
  assert set(e['axioms'])<={'propext','Classical.choice','Quot.sound'} and '⋯' not in json.dumps(e,ensure_ascii=False),e['name']
  if e['body']['kind']=='definition_or_theorem':assert e['body']['term']
  else:assert e['body']['kind']=='kernel_inductive' and e['body']['constructors']
 inputs=read(audit_dir/'SOURCE_INPUTS.json')
 for e in inputs['sources']:assert job.sha(path(e['path']))==e['sha256']
 for e in inputs['reused']:
  assert job.sha(path(e.get('current_source',e['source'])))==e['source_sha256']
  assert job.sha(path(e['artifact']))==e['artifact_sha256']
 sage_dir=job.BUILD/'jobs/keygen_codec_typed_sage_065_final'
 controls=read(sage_dir/'CODEC_VALUE_CHECK.json');rec=read(sage_dir/'RECEIPTS.json')[0]
 assert rec['accepted'] and rec['clean_log'] and rec['exit_code']==0
 assert job.sha(path(SAGE))==job.sha(sage_dir/SAGE)==rec['source_sha256']
 assert controls['status']=='PASS_PUBLIC_CODEC_VALUE_CONTROLS'
 for r in controls['results']:assert r['baseline_pass'] and all(r['mutations'].values())
 causes=read('.build/levels_065/CAUSES.json');history=[]
 for directory in sorted((job.BUILD/'jobs').glob('keygen_codec*_065_*')):
  records=read(directory/'RECEIPTS.json') if (directory/'RECEIPTS.json').exists() else []
  status='ACCEPTED' if records and all(r['accepted'] for r in records) else 'FAILED_RETAINED' if records else 'PRESTEP_ABORT_RETAINED'
  cause=causes.get(directory.name)
  assert status=='ACCEPTED' or cause,('missing retained cause',directory.name)
  history.append({'job':directory.name,'status':status,'cause':cause,
   'files':[pin(p) for p in sorted(directory.rglob('*')) if p.is_file() and not p.is_symlink() and
     (p.parent==directory or p.parent==directory/'logs' or p.suffix in {'.lean','.sage'})]})
 scope_dir=job.BUILD/'jobs/keygen_codec_capacity_scope_065_019'
 scope_control=read(scope_dir/'CAPACITY_SCOPE_CHECK.json');scope_rec=read(scope_dir/'RECEIPTS.json')[0]
 assert scope_rec['accepted'] and scope_rec['clean_log'] and scope_rec['exit_code']==0
 assert scope_control['status']=='OUT_OF_PROFILE_CAPACITY_COUNTEREXAMPLE_REPRODUCED'
 assert job.sha(path('sage/check_keygen_codec_capacity_scope.sage'))==job.sha(scope_dir/'sage/check_keygen_codec_capacity_scope.sage')==scope_rec['source_sha256']
 tools=['tools/job.py','tools/job_when_available.py','tools/keygen_codec_typed_audit.py','tools/keygen_codec_typed_batch.py',SAGE,'sage/check_keygen_codec_capacity_scope.sage']
 for p in tools+['../../../../../Extra/c/falcon-enc.c','../../../../../Extra/c/falcon-keygen.c']:committed(p,head)
 result={'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_065','stage':'B1.07 / B1.08-09 seam',
  'window':'CLOSED_AT_RECOVERABLE_MIDPOINT','b1_07_acceptance':'NOT_MET','stage_result':'PARTIAL_PROOF',
  'status':'IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN','created_utc':datetime.now(timezone.utc).isoformat(),
  'harness':'Codex; historical runner identity labels retained','proof_head':head,
  'source_reference':[pin('../../../../../Extra/c/falcon-enc.c'),pin('../../../../../Extra/c/falcon-keygen.c'),pin('../../../../../Extra/c/falcon.h')],'notes':pin(BASE+'_NOTES.md'),
  'entry_pins_receipt':pin(ENTRY),'preseal':pin('.build/levels_065/PRESEAL.json'),
  'generator_check':pin('.build/levels_065/GENERATOR_CHECK.json'),
  'recorded_supersessions':entry.get('recorded_supersessions'),'accepted_module_checks':modules,
  'audit':{**pin(audit_dir/'SEARCH_AUDIT.json'),'entries_jsonl':pin(audit_dir/'SEARCH_AUDIT_ENTRIES.jsonl'),
   'source_inputs':pin(audit_dir/'SOURCE_INPUTS.json'),'exports':len(producer.declarations()),
   'inherited_interfaces':len(producer.INHERITED),'full_terms':sum(e['body']['kind']=='definition_or_theorem' for e in audit),
   'kernel_inductives':sum(e['body']['kind']=='kernel_inductive' for e in audit)},
  'sage':{'result':pin(sage_dir/'CODEC_VALUE_CHECK.json'),'receipt':pin(sage_dir/'RECEIPTS.json'),'scope':controls['scope']},
  'capacity_scope_counterexample':{'result':pin(scope_dir/'CAPACITY_SCOPE_CHECK.json'),'receipt':pin(scope_dir/'RECEIPTS.json'),'scope':scope_control['scope']},
  'attempt_details':history,'tools':[pin(p) for p in tools],
  'extra_evidence':[pin(p) for p in sorted((job.BUILD/'levels_065').glob('IMPORT_STOP_*.json'))]+[pin('.build/levels_065/TARGET.json'),pin('.build/levels_065/AUDIT_BEFORE_PROFILE.lean'),pin('.build/levels_065/CAUSES.json'),pin('.build/levels_065/SELF_REVIEW.md')],
  'open_obligations':['Whole-invocation replacement of the old open codec seam; old unrestricted Segments cannot imply a typed body execution.',
   'Fold the three derived guarded STATIC windows over the full body with reachable u/capacity/buf bindings; NONE loop/capacity and whole encoded/consumed lengths remain open. Only NONE RHS3072 is proved; low-suffix accumulator, round-trips and public codec remain open.',
   'Explicit common call ID/snapshots; all-state LegalWorkspace refutation status; inherited plan obligations.'],
  'active_jobs_at_close':[],'push':False,'review':False,
  'limits':'Unchanged j1/-M6144,AS12GiB/RSS8GiB/wall1800s; native Sage; accepted Lean diagnostics0/0.'}
 assert not job.active()
 with path(BASE+'.json').open('x') as stream:json.dump(result,stream,indent=2);stream.write('\n')
 print(json.dumps({'batch':pin(BASE+'.json'),'notes':pin(BASE+'_NOTES.md'),'audit_entries':len(audit)}))

def verify(batch_sha,notes_sha,target):
 entry=checked_inputs();checked=dict(entry['checked'])
 def check(p,expected):
  p=path(p);actual=job.sha(p);assert actual==expected,(str(p),expected,actual)
  if str(p) in checked:assert checked[str(p)]==expected
  checked[str(p)]=actual
 def walk(v):
  if isinstance(v,dict):
   if 'path' in v and 'sha256' in v:check(v['path'],v['sha256'])
   for child in v.values():walk(child)
  elif isinstance(v,list):
   for child in v:walk(child)
 check(BASE+'.json',batch_sha);check(BASE+'_NOTES.md',notes_sha);batch=read(BASE+'.json');walk(batch)
 assert batch['batch']=='BATCH_065' and batch['active_jobs_at_close']==[]
 inputs=read(batch['audit']['source_inputs']['path'])
 for e in inputs['sources']:check(e['path'],e['sha256'])
 for e in inputs['reused']:
  check(e.get('current_source',e['source']),e['source_sha256']);check(e['artifact'],e['artifact_sha256'])
 assert not job.active()
 result={'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-065','checked':checked,
  'distinct_pinned_files':len(checked),'current_source_inputs':batch['audit']['exports']+batch['audit']['inherited_interfaces'],
  'superseded':{},'recorded_supersessions':entry.get('recorded_supersessions'),'active_jobs':[],
  'verifier_sha256':job.sha(Path(__file__))}
 print(json.dumps({'receipt':write_receipt(target,result),'distinct_pinned_files':len(checked)}))

if __name__=='__main__':
 command=sys.argv[1]
 if command=='generator':generator()
 elif command=='predecessor':predecessor(sys.argv[2])
 elif command=='seal':seal()
 else:
  assert command=='verify' and len(sys.argv)==5
  verify(*sys.argv[2:])
