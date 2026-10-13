#!/usr/bin/env python3
"""Seal complete075 source STATIC memory round-trip; whole owner TODO continues."""
from pathlib import Path
from datetime import datetime,timezone
from contextlib import redirect_stdout
from io import StringIO
import hashlib,json,shutil,subprocess,sys
import job
import keygen_codec_static_full075_audit as producer
import keygen_decode_static_binding as binding
ROOT=Path(__file__).resolve().parents[1]
ENTRY='.build/levels_075/LOOP_STEP_007_POSTSEAL.json'
ENTRY_SHA='2e233d0593be13437f0a7ce3dec77cdacf5754003eb7d9b351bd59339412268d'
BASE='notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_075'
FINAL='.build/jobs/keygen_decode_static_075_086'
CAUSES={'075':'Unnecessary tactic sequence focus in closed prologue shift proof; removed without warning suppression.',
 '077':'Prologue q/logn Option equalities required explicit integer type/value constructor tags.',
 '080':'Physical byte-read tuple needed a separately bound pointer-advance proof term.',
 '082':'Mixed: STATIC dispatcher execution accepted; facts retained NONE0 in a copied local comp result, corrected to actual STATIC1.'}
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
 entry=read(ENTRY);assert len(entry['checked'])==entry['distinct_pinned_files']==18481
 for p,h in entry['checked'].items():assert job.sha(path(p))==h,('entry pin mismatch',p)
 return entry

def seal():
 inputs();records=read(FINAL+'/RECEIPTS.json');modules=producer.MODULES+['KeygenCodecStaticFull075Audit']
 assert len(records)==12 and all(r['accepted'] and r['clean_log'] and r['exit_code']==0 and r['forbidden_proof_markers']==[] for r in records)
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
 assert len(audit)==len(expected)==66 and {e['name'] for e in audit}==expected
 for e in audit:
  assert set(e['axioms'])<={'propext','Classical.choice','Quot.sound'} and '⋯' not in json.dumps(e,ensure_ascii=False)
  assert e['body'].get('term') or e['body'].get('constructors')
 dest=path('.build/levels_075/static_full075_audit_reproduction');dest.mkdir(exist_ok=False)
 for name in producer.MODULES+['KeygenDecodeNoneAudit']:
  p=dest/'formal/Source3'/(name+'.lean');p.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(path('formal/Source3/'+name+'.lean'),p)
 oldRoot=producer.ROOT;output=StringIO()
 try:
  producer.ROOT=dest
  with redirect_stdout(output):producer.main()
 finally:producer.ROOT=oldRoot
 reproduced=dest/'formal/Source3/KeygenCodecStaticFull075Audit.lean'
 assert reproduced.read_bytes()==path('formal/Source3/KeygenCodecStaticFull075Audit.lean').read_bytes()
 bindingRoot=dest/'static_binding';oldBindingRoot=binding.ROOT;oldArgv=sys.argv
 try:
  binding.ROOT=bindingRoot;sys.argv=[binding.__file__]
  with redirect_stdout(output):binding.main()
 finally:binding.ROOT=oldBindingRoot;sys.argv=oldArgv
 bindingChecks=[]
 for name in ['KeygenDecodeStaticBindingPart00','KeygenDecodeStaticBindingPart01','KeygenDecodeStaticBindingPart02','KeygenDecodeStaticBindingPart03','KeygenDecodeStaticBindingPart04','KeygenDecodeStaticSource','KeygenDecodeStaticBinding']:
  generated=bindingRoot/'formal/Source3'/(name+'.lean');live=path('formal/Source3/'+name+'.lean')
  assert generated.read_bytes()==live.read_bytes()
  bindingChecks.append({'source':pin(live),'reproduced':pin(generated)})
 history=[]
 for n in range(75,87):
  label='keygen_decode_static_075_'+str(n).zfill(3);directory=job.BUILD/'jobs'/label;rs=read(directory/'RECEIPTS.json')
  accepted=all(r['accepted'] for r in rs);cause=CAUSES.get(str(n).zfill(3));assert accepted or cause
  scope_superseded=False
  history.append({'job':label,'status':'ACCEPTED_SUPERSEDED_AUDIT_SCOPE' if scope_superseded else 'ACCEPTED' if accepted else 'FAILED_RETAINED','cause':cause if scope_superseded or not accepted else None,
   'files':[pin(p) for p in sorted(directory.rglob('*')) if p.is_file() and not p.is_symlink() and
    (p.parent==directory or p.parent==directory/'logs' or p.suffix in {'.lean','.olean'})],
   'wait':pin(job.BUILD/'waits'/label/'WAIT.jsonl')})
 result={'utc':datetime.now(timezone.utc).isoformat(),'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_075',
  'stage':'B1.08 / owner TODO item2 STATIC','status':'STATIC_SOURCE_MEMORY_ROUNDTRIP_PROVED_KERNEL_SCOPED / NOT_REVIEWED; WHOLE TODO CONTINUES',
  'entry':pin(ENTRY),'proof_head':head,'notes':pin(BASE+'_NOTES.md'),'modules':checks,
  'native_receipts':pin(FINAL+'/RECEIPTS.json'),'source_inputs':pin(FINAL+'/SOURCE_INPUTS.json'),
  'audit':pin(FINAL+'/SEARCH_AUDIT.json'),'audit_entries_jsonl':pin(FINAL+'/SEARCH_AUDIT_ENTRIES.jsonl'),
  'audit_counts':{'new':61,'inherited':5,'full_terms':64,'kernel_inductives':2},
  'audit_generator_reproduction':pin(reproduced),'static_binding_generator_reproduction':bindingChecks,'history':history,
  'closed':'Full source STATIC decoder prologue/1536 stores/own padding/actual consumed return and honest existence; SAME encoder-derived physical bytes and both dispatchers with argument identity; all-int16 value round-trip, exact3072-byte frame and in-place original coefficient memory identity.',
  'open':'NEXT SAME mathematical-vector/physical-int16 transport BOTH directions, public codec LAST; inherited B1.07/B1.10 root/material/LegalWorkspace boundaries remain.',
  'b1_acceptance':'B1.07/B1.08 NOT MET;B1.09 OPEN','midpoint_close':False,'source_assumptions_added':False,
  'limits':'Unchanged guarded j1/-M6144/AS12GiB/RSS8GiB/wall1800s/maxHeartbeats2000000; warningAsError,clean0/0.',
  'self_review':pin('.build/levels_075/STATIC_SELF_REVIEW_001.md'),
  'new_proof_modules_075':68,'new_declarations_075':771,'new_named_theorems_075':376,
  'static_domain':'M0 q18433/logn10/comp1;1536 initialized physical int16 input words; numeric capacity covers the independently source-proved mathematical bit budget;legal writable decoder destination/non-aliasing. Actual encoder execution has unrestricted observed return; supplied extent covers that observed return. No desired codec output/length/frame/success premise.',
  'mathematical_or_compiler_transport_assumed':False,
  'decoder_dispatcher_scope':'Complete source syntax; fixed-body STATIC profile. NONE has its already checked separate fixed-body profile; no arbitrary unproved alternate callee.',
  'tools':[pin('tools/keygen_codec_static_full075_audit.py'),pin('tools/keygen_decode_static_binding.py'),pin(Path(__file__))],'active_jobs':[],'push':False}
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
 print(json.dumps(write('.build/levels_075/POSTSEAL.json',{'utc':datetime.now(timezone.utc).isoformat(),
  'status':'PASS_SCOPED_STATIC_SOURCE_MEMORY_ROUNDTRIP; NOT REVIEWED OR FULL B1 ACCEPTANCE','entry_pins_checked':18481,
  'checked':checked,'distinct_pinned_files':len(checked),'source_inputs_current':True,'native_final_job_all_clean':True,
  'verifier_sha256':job.sha(Path(__file__)),'midpoint_close':False,'active_jobs':[]})))
def next_entry(expected,post_sha):
 previous=inputs();assert job.sha(path(BASE+'.json'))==expected
 postPath='.build/levels_075/POSTSEAL.json';assert job.sha(path(postPath))==post_sha
 post=read(postPath)
 assert post['status']=='PASS_SCOPED_STATIC_SOURCE_MEMORY_ROUNDTRIP; NOT REVIEWED OR FULL B1 ACCEPTANCE'
 assert post['source_inputs_current'] and post['native_final_job_all_clean'] and post['entry_pins_checked']==18481
 for p,h in post['checked'].items():assert job.sha(path(p))==h,('postseal pin mismatch',p)
 assert post['checked'][str(path(BASE+'.json'))]==expected
 checked=dict(post['checked']);checked[str(path(postPath))]=post_sha
 original075=read('.build/levels_075/ENTRY_PINS_075.json')
 assert not job.active()
 print(json.dumps(write('.build/levels_076/ENTRY_PINS_076.json',{
  'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-075','checked':checked,'distinct_pinned_files':len(checked),
  'completed_owner_todo_item':'2: full source STATIC physical-memory round-trip',
  'next_owner_todo_item':'3: SAME mathematical-vector/physical-int16 transport both ways; public LAST',
  'postseal':pin(postPath),'batch075':pin(BASE+'.json'),
  'recorded_supersessions':original075.get('recorded_supersessions'),
  'explicit_pin_overlays_073':original075['explicit_pin_overlays_073'],
  'active_jobs':[],'verifier_sha256':job.sha(Path(__file__)),'push':False,'midpoint_close':False})))

if __name__=='__main__':
 if len(sys.argv)==2 and sys.argv[1]=='seal':seal()
 elif len(sys.argv)==3 and sys.argv[1]=='postseal':postseal(sys.argv[2])
 elif len(sys.argv)==4 and sys.argv[1]=='entry':next_entry(sys.argv[2],sys.argv[3])
 else:raise SystemExit('usage: keygen_codec_static_full075_batch.py seal | postseal BATCH_SHA | entry BATCH_SHA POSTSEAL_SHA')
