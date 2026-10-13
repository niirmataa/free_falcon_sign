#!/usr/bin/env python3
"""Seal an internal075 STATIC foundation step; full codec TODO continues."""
from pathlib import Path
from datetime import datetime,timezone
from contextlib import redirect_stdout
from io import StringIO
import hashlib,json,shutil,subprocess,sys
import job
import keygen_decode_static_coefficient075_audit as producer
ROOT=Path(__file__).resolve().parents[1]
ENTRY='.build/levels_075/UNARY_STEP_005_POSTSEAL.json'
ENTRY_SHA='d32a4a14909aca06b4266459a20f35f3ce94a42d68f33d347f9406a5eaa21d2c'
BASE='notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_075_COEFFICIENT_STEP_006'
FINAL='.build/jobs/keygen_decode_static_075_071'
CAUSES={'061':'Sequence proof used a local binder resembling Flow.normal constructor; linter retained.',
 '062':'Mixed: Sequence accepted; complete coefficient used a reserved local prefix identifier.',
 '064':'Outer comparison needed explicit UInt64 integer evaluation and Nat/Int cast normalization.',
 '065':'Last outer comparison branch needed direct closed1535 evaluation.',
 '066':'Unnecessary tactic sequence focus removed without warning suppression.',
 '067':'Mixed: OuterCounter/PaddingBits accepted; PaddingReturn needed explicit source node091 unfolding.'}
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
 entry=read(ENTRY);assert len(entry['checked'])==entry['distinct_pinned_files']==18221
 for p,h in entry['checked'].items():assert job.sha(path(p))==h,('entry pin mismatch',p)
 return entry

def seal():
 inputs();records=read(FINAL+'/RECEIPTS.json');modules=producer.MODULES+['KeygenDecodeStaticCoefficient075Audit']
 assert len(records)==8 and all(r['accepted'] and r['clean_log'] and r['exit_code']==0 and r['forbidden_proof_markers']==[] for r in records)
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
 assert len(audit)==len(expected)==37 and {e['name'] for e in audit}==expected
 for e in audit:
  assert set(e['axioms'])<={'propext','Classical.choice','Quot.sound'} and '⋯' not in json.dumps(e,ensure_ascii=False)
  assert e['body'].get('term') or e['body'].get('constructors')
 dest=path('.build/levels_075/coefficient_step_006_audit_reproduction');dest.mkdir(exist_ok=False)
 for name in producer.MODULES+['KeygenDecodeNoneAudit']:
  p=dest/'formal/Source3'/(name+'.lean');p.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(path('formal/Source3/'+name+'.lean'),p)
 oldRoot=producer.ROOT;output=StringIO()
 try:
  producer.ROOT=dest
  with redirect_stdout(output):producer.main()
 finally:producer.ROOT=oldRoot
 reproduced=dest/'formal/Source3/KeygenDecodeStaticCoefficient075Audit.lean'
 assert reproduced.read_bytes()==path('formal/Source3/KeygenDecodeStaticCoefficient075Audit.lean').read_bytes()
 history=[]
 for n in range(61,72):
  label='keygen_decode_static_075_'+str(n).zfill(3);directory=job.BUILD/'jobs'/label;rs=read(directory/'RECEIPTS.json')
  accepted=all(r['accepted'] for r in rs);cause=CAUSES.get(str(n).zfill(3));assert accepted or cause
  history.append({'job':label,'status':'ACCEPTED' if accepted else 'FAILED_RETAINED','cause':None if accepted else cause,
   'files':[pin(p) for p in sorted(directory.rglob('*')) if p.is_file() and not p.is_symlink() and
    (p.parent==directory or p.parent==directory/'logs' or p.suffix in {'.lean','.olean'})],
   'wait':pin(job.BUILD/'waits'/label/'WAIT.jsonl')})
 result={'utc':datetime.now(timezone.utc).isoformat(),'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_075',
  'step':'COEFFICIENT_STEP_006','status':'PROVED_KERNEL_SCOPED / NOT_REVIEWED; WHOLE TODO CONTINUES',
  'entry':pin(ENTRY),'proof_head':head,'notes':pin(BASE+'_NOTES.md'),'modules':checks,
  'native_receipts':pin(FINAL+'/RECEIPTS.json'),'source_inputs':pin(FINAL+'/SOURCE_INPUTS.json'),
  'audit':pin(FINAL+'/SEARCH_AUDIT.json'),'audit_entries_jsonl':pin(FINAL+'/SEARCH_AUDIT_ENTRIES.jsonl'),
  'audit_counts':{'new':33,'inherited':4,'full_terms':37,'kernel_inductives':0},
  'audit_generator_reproduction':pin(reproduced),'history':history,
  'closed':'Complete source coefficient through SAME physical int16 store, exact outer ++u>=n, derived zero-padding/unread-byte exhaustion and actual padding/return-v suffix, including lexical scope. Full STATIC loop/prologue/dispatcher composition remains open.',
  'open':'Compose complete iterations and1536 actual stores, whole prologue/body/source dispatchers and STATIC round-trip; then SAME vector/int16 transport, public LAST.',
  'b1_acceptance':'B1.07/B1.08 NOT MET;B1.09 OPEN','midpoint_close':False,'source_assumptions_added':False,
  'limits':'Unchanged guarded j1/-M6144/AS12GiB/RSS8GiB/wall1800s/maxHeartbeats2000000; warningAsError,clean0/0.',
  'tools':[pin('tools/keygen_decode_static_coefficient075_audit.py'),pin(Path(__file__))],'active_jobs':[],'push':False}
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
 print(json.dumps(write('.build/levels_075/COEFFICIENT_STEP_006_POSTSEAL.json',{'utc':datetime.now(timezone.utc).isoformat(),
  'status':'PASS_SCOPED_INTERNAL_STEP; NOT FULL STATIC ROUNDTRIP OR B1 ACCEPTANCE','entry_pins_checked':18221,
  'checked':checked,'distinct_pinned_files':len(checked),'source_inputs_current':True,'native_final_job_all_clean':True,
  'verifier_sha256':job.sha(Path(__file__)),'midpoint_close':False,'active_jobs':[]})))
if __name__=='__main__':
 if len(sys.argv)==2 and sys.argv[1]=='seal':seal()
 elif len(sys.argv)==3 and sys.argv[1]=='postseal':postseal(sys.argv[2])
 else:raise SystemExit('usage: keygen_decode_core074_step.py seal | postseal STEP_SHA')
