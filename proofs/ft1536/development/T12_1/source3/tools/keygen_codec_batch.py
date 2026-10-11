#!/usr/bin/env python3
"""Seal/verify064's actual scoped codec syntax and projected-memory result.
Preserve the full 015--063 closure and the owner-authorized 063 correction.
No typed-value adequacy, capacity-window frame or B1 Acceptance is claimed.
"""
from contextlib import redirect_stdout
from datetime import datetime,timezone
from io import StringIO
from pathlib import Path
import json,shutil,subprocess,sys
import job
import keygen_codec_audit as producer
from keygen_intermediate_batch import path,read,pin,committed,streams
from keygen_public_first_batch import write_receipt
BASE='notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_064'
ENTRY='.build/levels_064/ENTRY_PINS_064.json'
ENTRY_SHA='e472e2a382f5b5d4096951c4738bcc078d93d9c3cce3d62905628fae723e8c75'
AUDIT='KeygenCodecAudit'
SAGE='sage/check_keygen_codec_frames.sage'
PRESEAL='.build/levels_064/PRESEAL.json'
GENERATOR='.build/levels_064/GENERATOR_CHECK.json'
CAUSES={
 'keygen_codec_syntax_064_001':'Syntax accepted; compositional grammar rejected because at is a reserved Lean token used as a binder. Renamed firstTokens; snapshot retained.',
 'keygen_codec_bindings_064_003':'Source/none/static bindings accepted. Own dispatcher witness elaboration stopped near unchanged RSS cap (TERM, exit143, 748.268s). Snapshot, raw streams and DISPATCH_STOP_003 retained; no limit increase.',
 'keygen_codec_effects_064_004':'Explicit dispatcher constructor did not fix the atom reduction blowup; INTERNAL PANIC out of memory, exit1. Retained; closed decide+kernel atoms used subsequently.',
 'keygen_codec_dispatch_064_005':'Dispatcher accepted; footprint rejected on compact n!= tokenization and bind-case equality inversion syntax. Retained.',
 'keygen_codec_frames_064_006':'Footprint accepted; survival rejected on compact 4≤i parsing in the trace constructor. Spaced comparison, same proof; snapshot retained.',
 'keygen_codec_survival_064_007':'User interrupted turn: survival step accepted with its own raw receipt and product, audit started but no terminal whole-job receipt. All available streams/snapshots retained; both modules rebuilt in008.'}

def checked_inputs():
 assert not job.active(),'A proof job is active'
 assert job.sha(path(ENTRY))==ENTRY_SHA
 entry=read(ENTRY)
 assert entry['batch']=='BATCH_015-063' and len(entry['checked'])==entry['distinct_pinned_files']==12350
 assert entry['current_source_inputs']==87 and entry['active_jobs']==[]
 for p,expected in entry['checked'].items():assert job.sha(path(p))==expected,('predecessor changed',p)
 return entry

def predecessor(target):
 entry=checked_inputs()
 print(json.dumps(write_receipt(target,{'utc':datetime.now(timezone.utc).isoformat(),
  'checked':entry['checked'],'entry':pin(ENTRY),'verifier_sha256':job.sha(Path(__file__)),
  'recorded_supersessions':entry.get('recorded_supersessions'),'active_jobs':[]})))

def generator():
 dest=path('.build/levels_064/final_generator');dest.mkdir(exist_ok=False)
 for tool,subdir in [('tools/keygen_codec_syntax.py','syntax'),('tools/keygen_codec_binding.py','binding')]:
  subprocess.run([sys.executable,'-B',str(path(tool)),str((dest/subdir).relative_to(job.ROOT))],cwd=job.ROOT,check=True)
 generated=[]
 for p in sorted(dest.rglob('*.lean')):
  actual=path('formal/Source3/'+p.name);assert actual.read_bytes()==p.read_bytes(),p.name
  generated.append({'source':pin(actual),'reproduced':pin(p)})
 for name in producer.MODULES+['KeygenLevelsAudit']:
  p=dest/'audit/formal/Source3'/(name+'.lean');p.parent.mkdir(parents=True,exist_ok=True)
  shutil.copyfile(path('formal/Source3/'+name+'.lean'),p)
 original=producer.ROOT;printed=StringIO()
 try:
  producer.ROOT=dest/'audit'
  with redirect_stdout(printed):producer.main()
 finally:producer.ROOT=original
 p=dest/'audit/formal/Source3/KeygenCodecAudit.lean';actual=path('formal/Source3/KeygenCodecAudit.lean')
 assert p.read_bytes()==actual.read_bytes()
 generated.append({'source':pin(actual),'reproduced':pin(p)})
 print(json.dumps(write_receipt(GENERATOR,{'utc':datetime.now(timezone.utc).isoformat(),
  'status':'BYTE_EXACT_PRODUCER_REPRODUCTION','files':generated,'audit_generator_output':printed.getvalue()})))

def seal():
 assert not path(BASE+'.json').exists(),'Never overwrite a sealed batch'
 entry=checked_inputs();preseal=read(PRESEAL)
 assert preseal['checked']==entry['checked'] and preseal['verifier_sha256']==job.sha(Path(__file__))
 generated=read(GENERATOR);assert generated['status']=='BYTE_EXACT_PRODUCER_REPRODUCTION'
 for e in generated['files']:assert job.sha(path(e['source']['path']))==e['source']['sha256']
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
 sage_dir=job.BUILD/'jobs/keygen_codec_sage_064_009'
 controls=read(sage_dir/'CODEC_FRAME_CHECK.json');rec=read(sage_dir/'RECEIPTS.json')[0]
 assert rec['accepted'] and rec['clean_log'] and rec['exit_code']==0
 assert job.sha(path(SAGE))==job.sha(sage_dir/SAGE)==rec['source_sha256']
 assert controls['status']=='PASS_PUBLIC_SOURCE_CODEC_CONTROLS'
 for r in controls['results']:assert r['baseline_pass'] and all(r['mutations'].values())
 history=[]
 for directory in sorted((job.BUILD/'jobs').glob('keygen_codec*_064_*')):
  records=read(directory/'RECEIPTS.json') if (directory/'RECEIPTS.json').exists() else []
  status='ACCEPTED' if records and all(r['accepted'] for r in records) else 'FAILED_RETAINED' if records else 'INTERRUPTED_RETAINED'
  history.append({'job':directory.name,'status':status,'cause':CAUSES.get(directory.name),
   'files':[pin(p) for p in sorted(directory.rglob('*')) if p.is_file() and not p.is_symlink() and
     (p.parent==directory or p.parent==directory/'logs' or p.suffix in {'.lean','.sage'})]})
 for h in history:
  assert h['status']=='ACCEPTED' or h['cause'],('missing retained cause',h['job'])
 tools=['tools/job.py','tools/job_when_available.py','tools/keygen_codec_syntax.py','tools/keygen_codec_binding.py',
  'tools/keygen_codec_audit.py','tools/keygen_codec_batch.py','tools/keygen_make_binding.py',SAGE,'formal/Source3/KeygenLevelsAudit.lean']
 for p in tools+['../../../../../Extra/c/falcon-enc.c','../../../../../Extra/c/falcon.h']:committed(p,head)
 notes=BASE+'_NOTES.md'
 result={'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_064','stage':'B1.07 / B1.08-09 seam',
  'window':'CLOSED_AT_RECOVERABLE_MIDPOINT','b1_07_acceptance':'NOT_MET',
  'stage_result':'PARTIAL_PROOF','status':'IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN',
  'created_utc':datetime.now(timezone.utc).isoformat(),'harness':'Codex; historical runner identity labels retained',
  'proof_head':head,'notes':pin(notes),'entry_pins_receipt':pin(ENTRY),'preseal':pin(PRESEAL),
  'generator_check':pin(GENERATOR),'recorded_supersessions':entry.get('recorded_supersessions'),
  'accepted_module_checks':modules,
  'audit':{**pin(audit_dir/'SEARCH_AUDIT.json'),'entries_jsonl':pin(audit_dir/'SEARCH_AUDIT_ENTRIES.jsonl'),
   'source_inputs':pin(audit_dir/'SOURCE_INPUTS.json'),'exports':len(producer.declarations()),
   'inherited_interfaces':len(producer.INHERITED),'full_terms':sum(e['body']['kind']=='definition_or_theorem' for e in audit),
   'kernel_inductives':sum(e['body']['kind']=='kernel_inductive' for e in audit)},
  'sage':{'result':pin(sage_dir/'CODEC_FRAME_CHECK.json'),'receipt':pin(sage_dir/'RECEIPTS.json'),
   'scope':controls['scope']},'attempt_details':history,
  'source_reference':[pin('../../../../../Extra/c/falcon-enc.c'),pin('../../../../../Extra/c/falcon.h')],
  'tools':[pin(p) for p in tools],
  'extra_evidence':[pin(p) for p in sorted((job.BUILD/'levels_064').glob('DISPATCH_STOP_*.json'))],
  'open_obligations':['Typed scalar/value C execution to the fixed memory-effect projection; no such adequacy theorem is assumed.',
   'Derive this body-bound trace from the original unrestricted SmallSite/Segments invocation; current exported histories concern the new projected-body trace.',
   'Capacity-window write range (the proved frame is destination BLOCK), exact codec lengths and bytewise round-trips; public encoder bodies.',
   'Explicit common call ID/snapshots; all-state LegalWorkspace refutation status; inherited plan obligations.'],
  'active_jobs_at_close':[],'push':False,'review':False,'limits':'Unchanged j1/-M6144,AS12GiB/RSS8GiB/wall1800s; native Sage; accepted Lean diagnostics0/0.'}
 assert not job.active()
 with path(BASE+'.json').open('x') as stream:json.dump(result,stream,indent=2);stream.write('\n')
 print(json.dumps({'batch':pin(BASE+'.json'),'notes':pin(notes),'audit_entries':len(audit)}))

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
 assert batch['batch']=='BATCH_064' and batch['active_jobs_at_close']==[]
 inputs=read(batch['audit']['source_inputs']['path'])
 for e in inputs['sources']:check(e['path'],e['sha256'])
 for e in inputs['reused']:
  check(e.get('current_source',e['source']),e['source_sha256']);check(e['artifact'],e['artifact_sha256'])
 assert not job.active()
 result={'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-064','checked':checked,
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
