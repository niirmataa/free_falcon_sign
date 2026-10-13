#!/usr/bin/env python3
"""Seal complete074 source NONE memory round-trip; whole owner TODO continues; full codec TODO continues."""
from pathlib import Path
from datetime import datetime,timezone
from contextlib import redirect_stdout
from io import StringIO
import hashlib,json,shutil,subprocess,sys
import job
import keygen_codec_none_full074_audit as producer
import keygen_decode_dispatch_binding as dispatch
ROOT=Path(__file__).resolve().parents[1]
ENTRY='.build/levels_074/LOOP_STEP_002_POSTSEAL.json'
ENTRY_SHA='c1c1633d1843a5560a30928ea5541227abbd071deb51b7cf6ad70371512fa72b'
BASE='notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_074'
FINAL='.build/jobs/keygen_decode_none_074_035'
CAUSES={'021':'Closed-operation linter focus, explicit cast intermediate type and length comparison normalization.',
 '022':'Mixed: EntryCalculations accepted; reserved scoped identifier in EntryControl.',
 '024':'Reserved prefix identifier in Prologue; no failed mathematical implication.',
 '026':'CarrierList open syntax and zero BitVec representation in for initialization.',
 '032':'Dependent Fin/List index normalization in physical heap identity.',
 '034':'All native steps accepted, but full audit omitted21 shared-namespace helper declarations. Superseded scope; final035 rebuilds all18 steps with131 entries.'}
def path(p):
 p=Path(p);return p if p.is_absolute() else ROOT/p

def read(p):return json.loads(path(p).read_text())
def pin(p):
 p=path(p);return {'path':str(p.relative_to(ROOT)) if p.is_relative_to(ROOT) else str(p),'sha256':job.sha(p),'bytes':p.stat().st_size}
def write(p,value):
 p=path(p);p.parent.mkdir(parents=True,exist_ok=True)
 with p.open('x') as stream:json.dump(value,stream,indent=2);stream.write('\n')
 return pin(p)
def inputs():
 assert not job.active()
 assert job.sha(path(ENTRY))==ENTRY_SHA
 entry=read(ENTRY);assert len(entry['checked'])==entry['distinct_pinned_files']==16530
 for p,h in entry['checked'].items():assert job.sha(path(p))==h,('entry pin mismatch',p)
 return entry

def seal():
 inputs();records=read(FINAL+'/RECEIPTS.json');modules=producer.MODULES+['KeygenCodecNoneFull074Audit']
 assert len(records)==18 and all(r['accepted'] and r['clean_log'] and r['exit_code']==0 and r['forbidden_proof_markers']==[] for r in records)
 checks=[];head=subprocess.check_output(['git','rev-parse','HEAD'],cwd=job.REPO,text=True).strip()
 for name,rec in zip(modules,records):
  assert rec['name']=='Source3_'+name
  source='formal/Source3/'+name+'.lean';snap=FINAL+'/'+source;artifact=FINAL+'/lib/Source3/'+name+'.olean'
  assert job.sha(path(source))==job.sha(path(snap))==rec['source_sha256']
  assert job.sha(path(artifact))==rec['olean_sha256']
  rel=str(path(source).relative_to(job.REPO))
  assert hashlib.sha256(subprocess.check_output(['git','show',head+':'+rel],cwd=job.REPO)).hexdigest()==rec['source_sha256']
  checks.append({'module':'Source3.'+name,'source':pin(source),'snapshot':pin(snap),'artifact':pin(artifact),
   'stdout':pin(FINAL+'/'+rec['stdout']),'stderr':pin(FINAL+'/'+rec['stderr']),
   'elapsed_s':rec['elapsed_s'],'maxrss_kib':rec['cumulative_child_maxrss_kib']})
 live=read(FINAL+'/SOURCE_INPUTS.json')
 for e in live['sources']:assert job.sha(path(e['path']))==e['sha256']
 for e in live['reused']:
  assert job.sha(path(e.get('current_source',e['source'])))==e['source_sha256']
  assert job.sha(path(e['artifact']))==e['artifact_sha256']
 audit=read(FINAL+'/SEARCH_AUDIT.json')
 expected={ns+'.'+name for ns,names in producer.declarations().items() for name in names}|{'FT1536.Source3.'+n for n in producer.INHERITED}
 assert len(audit)==len(expected)==131 and {e['name'] for e in audit}==expected
 for e in audit:
  assert set(e['axioms'])<={'propext','Classical.choice','Quot.sound'} and '⋯' not in json.dumps(e,ensure_ascii=False)
  assert e['body'].get('term') or e['body'].get('constructors')
 dest=path('.build/levels_074/none_full074_audit_reproduction');dest.mkdir(exist_ok=False)
 for name in producer.MODULES+['KeygenDecodeNoneAudit']:
  p=dest/'formal/Source3'/(name+'.lean');p.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(path('formal/Source3/'+name+'.lean'),p)
 oldRoot=producer.ROOT;output=StringIO()
 try:
  producer.ROOT=dest
  with redirect_stdout(output):producer.main()
 finally:producer.ROOT=oldRoot
 reproduced=dest/'formal/Source3/KeygenCodecNoneFull074Audit.lean'
 assert reproduced.read_bytes()==path('formal/Source3/KeygenCodecNoneFull074Audit.lean').read_bytes()
 dispatchRoot=dest/'dispatcher_binding';oldDispatchRoot=dispatch.ROOT;oldArgv=sys.argv
 try:
  dispatch.ROOT=dispatchRoot;sys.argv=[dispatch.__file__]
  with redirect_stdout(output):dispatch.main()
 finally:dispatch.ROOT=oldDispatchRoot;sys.argv=oldArgv
 dispatchChecks=[]
 for name in ['KeygenDecodeDispatchBindingPart00','KeygenDecodeDispatchSource','KeygenDecodeDispatchBinding']:
  generated=dispatchRoot/'formal/Source3'/(name+'.lean');live=path('formal/Source3/'+name+'.lean')
  assert generated.read_bytes()==live.read_bytes()
  dispatchChecks.append({'source':pin(live),'reproduced':pin(generated)})
 history=[]
 for n in range(21,36):
  label='keygen_decode_none_074_'+str(n).zfill(3);directory=job.BUILD/'jobs'/label;rs=read(directory/'RECEIPTS.json')
  accepted=all(r['accepted'] for r in rs);cause=CAUSES.get(str(n).zfill(3));assert accepted or cause
  scope_superseded=(n==34)
  history.append({'job':label,'status':'ACCEPTED_SUPERSEDED_AUDIT_SCOPE' if scope_superseded else 'ACCEPTED' if accepted else 'FAILED_RETAINED','cause':cause if scope_superseded or not accepted else None,
   'files':[pin(p) for p in sorted(directory.rglob('*')) if p.is_file() and not p.is_symlink() and
    (p.parent==directory or p.parent==directory/'logs' or p.suffix in {'.lean','.olean'})],
   'wait':pin(job.BUILD/'waits'/label/'WAIT.jsonl')})
 result={'utc':datetime.now(timezone.utc).isoformat(),'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_074',
  'stage':'B1.08 / owner TODO item1 NONE','status':'NONE_SOURCE_MEMORY_ROUNDTRIP_PROVED_KERNEL_SCOPED / NOT_REVIEWED; WHOLE TODO CONTINUES',
  'entry':pin(ENTRY),'proof_head':head,'notes':pin(BASE+'_NOTES.md'),'modules':checks,
  'native_receipts':pin(FINAL+'/RECEIPTS.json'),'source_inputs':pin(FINAL+'/SOURCE_INPUTS.json'),
  'audit':pin(FINAL+'/SEARCH_AUDIT.json'),'audit_entries_jsonl':pin(FINAL+'/SEARCH_AUDIT_ENTRIES.jsonl'),
  'audit_counts':{'new':124,'inherited':7,'full_terms':128,'kernel_inductives':3},
  'audit_generator_reproduction':pin(reproduced),'dispatcher_generator_reproduction':dispatchChecks,'history':history,
  'closed':'Full source NONE decoder body/prologue/1536 stores/return and honest existence; actual encoder/decoder dispatchers with argument identity; physical value round-trip and exact derived frame; in-place identity on original coefficient memory. Explicit centered carrier retained.',
  'open':'NEXT full STATIC round-trip, then SAME mathematical-vector/physical-int16 transport, public codec LAST; inherited B1.07/B1.10 root/material/LegalWorkspace boundaries remain.',
  'b1_acceptance':'B1.07/B1.08 NOT MET;B1.09 OPEN','midpoint_close':False,'source_assumptions_added':False,
  'limits':'Unchanged guarded j1/-M6144/AS12GiB/RSS8GiB/wall1800s/maxHeartbeats2000000; warningAsError,clean0/0.',
  'self_review':pin('.build/levels_074/NONE_SELF_REVIEW_001.md'),
  'audit_scope_correction':[pin('.build/levels_074/none_full_audit_scope_correction/'+p) for p in ['PRODUCER_BEFORE.py','RECORD.json']],
  'new_proof_modules_074':33,'new_declarations_074':233,'new_named_theorems_074':156,
  'none_domain':'M0 q18433/logn10/comp0;1536 physical initialized input words on[-9216,9216];legal sufficient capacity/writable destination/non-aliasing; actual encoder execution with unrestricted observed return and enough supplied bytes relative to that observed return.',
  'mathematical_or_compiler_transport_assumed':False,
  'decoder_dispatcher_scope':'Complete source syntax; fixed-body NONE semantic profile, with STATIC explicitly outside this relation and no arbitrary STATIC callee.',
  'tools':[pin('tools/keygen_codec_none_full074_audit.py'),pin('tools/keygen_decode_dispatch_binding.py'),pin(Path(__file__))],'active_jobs':[],'push':False}
 assert not job.active();print(json.dumps(write(BASE+'.json',result)))

def postseal(expected):
 entry=inputs();assert job.sha(path(BASE+'.json'))==expected
 checked=dict(entry['checked'])
 def check(p,h):
  p=path(p);assert job.sha(p)==h,('pin mismatch',str(p))
  if str(p) in checked:assert checked[str(p)]==h
  checked[str(p)]=h
 def walk(v):
  if isinstance(v,dict):
   if 'path' in v and 'sha256' in v:check(v['path'],v['sha256'])
   for child in v.values():walk(child)
  elif isinstance(v,list):
   for child in v:walk(child)
 check(BASE+'.json',expected);step=read(BASE+'.json');walk(step)
 live=read(step['source_inputs']['path'])
 for e in live['sources']:check(e['path'],e['sha256'])
 for e in live['reused']:
  check(e.get('current_source',e['source']),e['source_sha256']);check(e['artifact'],e['artifact_sha256'])
 assert not job.active()
 print(json.dumps(write('.build/levels_074/POSTSEAL.json',{'utc':datetime.now(timezone.utc).isoformat(),
  'status':'PASS_SCOPED_NONE_SOURCE_MEMORY_ROUNDTRIP; NOT REVIEWED OR FULL B1 ACCEPTANCE','entry_pins_checked':16530,
  'checked':checked,'distinct_pinned_files':len(checked),'source_inputs_current':True,'native_final_job_all_clean':True,
  'verifier_sha256':job.sha(Path(__file__)),'midpoint_close':False,'active_jobs':[]})))
def next_entry(expected,post_sha):
 previous=inputs();assert job.sha(path(BASE+'.json'))==expected
 postPath='.build/levels_074/POSTSEAL.json';assert job.sha(path(postPath))==post_sha
 post=read(postPath)
 assert post['status']=='PASS_SCOPED_NONE_SOURCE_MEMORY_ROUNDTRIP; NOT REVIEWED OR FULL B1 ACCEPTANCE'
 assert post['source_inputs_current'] and post['native_final_job_all_clean'] and post['entry_pins_checked']==16530
 for p,h in post['checked'].items():assert job.sha(path(p))==h,('postseal pin mismatch',p)
 assert post['checked'][str(path(BASE+'.json'))]==expected
 checked=dict(post['checked']);checked[str(path(postPath))]=post_sha
 original074=read('.build/levels_074/ENTRY_PINS_074.json')
 assert not job.active()
 print(json.dumps(write('.build/levels_075/ENTRY_PINS_075.json',{
  'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-074','checked':checked,'distinct_pinned_files':len(checked),
  'completed_owner_todo_item':'1: full source NONE physical-memory round-trip',
  'next_owner_todo_item':'2: full source STATIC round-trip; then vector/int16 transport, public LAST',
  'postseal':pin(postPath),'batch074':pin(BASE+'.json'),
  'recorded_supersessions':original074.get('recorded_supersessions'),
  'explicit_pin_overlays_073':original074['explicit_pin_overlays'],
  'active_jobs':[],'verifier_sha256':job.sha(Path(__file__)),'push':False,'midpoint_close':False})))

if __name__=='__main__':
 if len(sys.argv)==2 and sys.argv[1]=='seal':seal()
 elif len(sys.argv)==3 and sys.argv[1]=='postseal':postseal(sys.argv[2])
 elif len(sys.argv)==4 and sys.argv[1]=='entry':next_entry(sys.argv[2],sys.argv[3])
 else:raise SystemExit('usage: keygen_codec_none_full074_batch.py seal | postseal BATCH_SHA | entry BATCH_SHA POSTSEAL_SHA')
