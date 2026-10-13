#!/usr/bin/env python3
"""Seal public077 source round-trip and observed public caller output; close the owner TODO components."""
from pathlib import Path
from datetime import datetime,timezone
from contextlib import redirect_stdout
from io import StringIO
import hashlib,json,shutil,subprocess,sys
import job
import keygen_public_caller077_audit as producer
ROOT=Path(__file__).resolve().parents[1]
ENTRY='.build/levels_077/DECODER_STEP_002_POSTSEAL.json'
ENTRY_SHA='f9fe9c5087ff2ce506f0283cdcf00753c5bbd0101cbd410fa08cd10db56c21ca'
BASE='notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_077'
FINAL='.build/jobs/keygen_public_077_054'
CAUSES={'047':'Packet take/drop rewrites, explicit list-index proof and finite universal simplification required normalization; caller-site module accepted.', '048':'List.take_length takes an implicit list parameter.', '050':'The existing caller relation has two identical capacity-pass constructors; both reflexive branches must close. Packet module accepted.', '052':'Byte-view block projection required explicit normalization in header-read preservation.'}
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
 entry=read(ENTRY);assert len(entry['checked'])==entry['distinct_pinned_files']==20429
 for p,h in entry['checked'].items():assert job.sha(path(p))==h,('entry pin mismatch',p)
 return entry

def seal():
 inputs();records=read(FINAL+'/RECEIPTS.json');modules=producer.MODULES+['KeygenPublicCaller077Audit']
 assert len(records)==7 and all(r['accepted'] and r['clean_log'] and r['exit_code']==0 and r['forbidden_proof_markers']==[] for r in records)
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
 assert len(audit)==len(expected)==53 and {e['name'] for e in audit}==expected
 for e in audit:
  assert set(e['axioms'])<={'propext','Classical.choice','Quot.sound'} and '⋯' not in json.dumps(e,ensure_ascii=False)
  assert e['body'].get('term') or e['body'].get('constructors')
 dest=path('.build/levels_077/public_caller077_audit_reproduction');dest.mkdir(exist_ok=False)
 for name in producer.MODULES+['KeygenDecodeNoneAudit']:
  p=dest/'formal/Source3'/(name+'.lean');p.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(path('formal/Source3/'+name+'.lean'),p)
 oldRoot=producer.ROOT;output=StringIO()
 try:
  producer.ROOT=dest
  with redirect_stdout(output):producer.main()
 finally:producer.ROOT=oldRoot
 reproduced=dest/'formal/Source3/KeygenPublicCaller077Audit.lean'
 assert reproduced.read_bytes()==path('formal/Source3/KeygenPublicCaller077Audit.lean').read_bytes()
 history=[]
 for n in range(47,55):
  label='keygen_public_077_'+str(n).zfill(3);directory=job.BUILD/'jobs'/label;rs=read(directory/'RECEIPTS.json')
  accepted=all(r['accepted'] for r in rs);cause=CAUSES.get(str(n).zfill(3));assert accepted or cause
  scope_superseded=False
  history.append({'job':label,'status':'ACCEPTED_SUPERSEDED_AUDIT_SCOPE' if scope_superseded else 'ACCEPTED' if accepted else 'FAILED_RETAINED','cause':cause if scope_superseded or not accepted else None,
   'files':[pin(p) for p in sorted(directory.rglob('*')) if p.is_file() and not p.is_symlink() and
    (p.parent==directory or p.parent==directory/'logs' or p.suffix in {'.lean','.olean'})],
   'wait':pin(job.BUILD/'waits'/label/'WAIT.jsonl')})
 result={'utc':datetime.now(timezone.utc).isoformat(),'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_077',
  'stage':'B1.09 / owner TODO item4 public codec LAST','status':'PUBLIC_CODEC_AND_OBSERVED_PUBLIC_SUFFIX_PROVED_KERNEL_SCOPED / NOT_REVIEWED; OWNER TODO COMPONENTS COMPLETE',
  'entry':pin(ENTRY),'proof_head':head,'notes':pin(BASE+'_NOTES.md'),'modules':checks,
  'native_receipts':pin(FINAL+'/RECEIPTS.json'),'source_inputs':pin(FINAL+'/SOURCE_INPUTS.json'),
  'audit':pin(FINAL+'/SEARCH_AUDIT.json'),'audit_entries_jsonl':pin(FINAL+'/SEARCH_AUDIT_ENTRIES.jsonl'),
  'audit_counts':{'new':49,'inherited':4,'full_terms':49,'kernel_inductives':4},
  'audit_generator_reproduction':pin(reproduced),'history':history,
  'closed':'Full public18433 source encoder/decoder, honest memory round-trip and SAME source h. Actual seven-statement public caller suffix, header0x8a, fixed-body call, derived2880 payload/2881 output length, physical length store, independent ObservedPublic and DecodePublic of actual emitted bytes equals SAME h from local source material/public/inverse equations.',
  'open':'Whole-root accepted-attempt to serialization-entry join, LegalWorkspace/relocation/call-ID, certificate lifetime/global assembly and final secret-blob/header observation remain outside the proved local codec components. No final KeyGen-to-fiber, probability, compiler or security theorem is inferred.',
  'b1_acceptance':'B1.07/B1.08 NOT MET;B1.09 local public suffix PROVED, whole-root acceptance NOT MET','midpoint_close':False,'source_assumptions_added':False,
  'limits':'Unchanged guarded j1/-M6144/AS12GiB/RSS8GiB/wall1800s/maxHeartbeats2000000; warningAsError,clean0/0.',
  'self_review':pin('.build/levels_077/PUBLIC_SELF_REVIEW_003.md'),
  'new_proof_modules_077':62,'new_declarations_077':812,'new_named_theorems_077':360,
  'transport_domain':'Canonical source h in existing Relation.Rq; physical unsigned uint16 words; M0 logn10/ter1; initialized arrays, numeric input capacity2881, legal writable buffers and explicit block separation. Only observed enclosing caller return1 is a result premise; no codec result/output bytes/encoded length/frame premise.',
  'mathematical_or_compiler_transport_assumed':False,
  'tools':[pin('tools/keygen_public_caller077_audit.py'),pin(Path(__file__))],'active_jobs':[],'push':False}
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
 print(json.dumps(write('.build/levels_077/POSTSEAL.json',{'utc':datetime.now(timezone.utc).isoformat(),
  'status':'PASS_SCOPED_PUBLIC_CODEC_AND_OBSERVED_SUFFIX; NOT REVIEWED OR FULL ROOT B1 ACCEPTANCE','entry_pins_checked':20429,
  'checked':checked,'distinct_pinned_files':len(checked),'source_inputs_current':True,'native_final_job_all_clean':True,
  'verifier_sha256':job.sha(Path(__file__)),'midpoint_close':False,'active_jobs':[]})))
def next_entry(expected,post_sha):
 previous=inputs();assert job.sha(path(BASE+'.json'))==expected
 postPath='.build/levels_077/POSTSEAL.json';assert job.sha(path(postPath))==post_sha
 post=read(postPath)
 assert post['status']=='PASS_SCOPED_PUBLIC_CODEC_AND_OBSERVED_SUFFIX; NOT REVIEWED OR FULL ROOT B1 ACCEPTANCE'
 assert post['source_inputs_current'] and post['native_final_job_all_clean'] and post['entry_pins_checked']==20429
 for p,h in post['checked'].items():assert job.sha(path(p))==h,('postseal pin mismatch',p)
 assert post['checked'][str(path(BASE+'.json'))]==expected
 checked=dict(post['checked']);checked[str(path(postPath))]=post_sha
 original077=read('.build/levels_077/ENTRY_PINS_077.json')
 assert not job.active()
 print(json.dumps(write('.build/levels_077/ENTRY_PINS_077.json',{
  'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-077','checked':checked,'distinct_pinned_files':len(checked),
  'completed_owner_todo_item':'4: public codec LAST; all four scoped codec/transport components complete',
  'next_owner_todo_item':'Whole-TODO final report; no automatic start of root assembly',
  'postseal':pin(postPath),'batch077':pin(BASE+'.json'),
  'recorded_supersessions':original077.get('recorded_supersessions'),
  'explicit_pin_overlays_073':original077['explicit_pin_overlays_073'],
  'active_jobs':[],'verifier_sha256':job.sha(Path(__file__)),'push':False,'midpoint_close':False})))

if __name__=='__main__':
 if len(sys.argv)==2 and sys.argv[1]=='seal':seal()
 elif len(sys.argv)==3 and sys.argv[1]=='postseal':postseal(sys.argv[2])
 elif len(sys.argv)==4 and sys.argv[1]=='entry':next_entry(sys.argv[2],sys.argv[3])
 else:raise SystemExit('usage: keygen_public_full077_batch.py seal | postseal BATCH_SHA | entry BATCH_SHA POSTSEAL_SHA')
