#!/usr/bin/env python3
"""Seal an internal077 complete public encoder step; full codec TODO continues."""
from pathlib import Path
from datetime import datetime,timezone
from contextlib import redirect_stdout
from io import StringIO
import hashlib,json,shutil,subprocess,sys
import job
import keygen_public_encoder077_audit as producer
ROOT=Path(__file__).resolve().parents[1]
ENTRY='.build/levels_077/ENTRY_PINS_077.json'
ENTRY_SHA='507d448fd4eda0b276842a53f16f9442dc26bf44451eb741f4f7bac26536519b'
BASE='notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_077_ENCODER_STEP_001'
FINAL='.build/jobs/keygen_public_077_030'
CAUSES={'002': 'Explicit integer constructor needs the underlying shared Value namespace.', '003': 'Dependent module requested after the preceding dependency failed; no artifact existed.', '004': 'Copied decoder field name data corrected to actual encoder out.', '006': 'Unavailable Option lemma and no-progress simplification replaced with constructor reasoning.', '007': 'Reserved local identifier at caused a parser error; renamed without proof suppression.', '008': 'Shared aliases required original definitions in simplification and fixed-Args induction patterns.', '009': 'Shared for-loop desugaring needed its underlying definition.', '010': 'Missing explicit import of the new public cell-frame module.', '011': 'Pending-bit recursion rewrites/conservation did not match the exact masked drain representation.', '012': 'Mask exponent bound needed generalization from pending<8 to pending<32.', '013': 'Missing explicit import of the existing uint64 conversion theorem.', '015': 'Ordinary alias and canonical state fields needed explicit normalization.', '018': 'Missing mask lemma import and nonexistent pointer-frame name; unchanged x follows canonical state.', '020': 'Wrong integer-cast lemma name and missing explicit loop-body argument.', '021': 'Congruence left a decision-instance equality; exact Int.ofNat_le normalization closes the comparison.', '022': 'Dependent iteration requested before failed drain dependency had an artifact.', '024': 'Concrete zero and scalar boolean needed exact normalization in the n>0 guard.', '025': 'Missing entry-calculation import and ambiguous IV abbreviation.', '026': 'Decoder and encoder syntax are distinct; created the actual encoder n expression while reusing integer primitives.', '027': 'Zero addition, encoded alias and bit-vector numeral forms required explicit normalization.', '028': 'Final stream append/encoded alias needed definitional closure.'}
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
 entry=read(ENTRY);assert len(entry['checked'])==entry['distinct_pinned_files']==19007
 for p,h in entry['checked'].items():assert job.sha(path(p))==h,('entry pin mismatch',p)
 return entry

def seal():
 inputs();records=read(FINAL+'/RECEIPTS.json');modules=producer.MODULES+['KeygenPublicEncoder077Audit']
 assert len(records)==43 and all(r['accepted'] and r['clean_log'] and r['exit_code']==0 and r['forbidden_proof_markers']==[] for r in records)
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
 assert len(audit)==len(expected)==677 and {e['name'] for e in audit}==expected
 for e in audit:
  assert set(e['axioms'])<={'propext','Classical.choice','Quot.sound'} and '⋯' not in json.dumps(e,ensure_ascii=False)
  assert e['body'].get('term') or e['body'].get('constructors')
 dest=path('.build/levels_077/encoder_step_001_audit_reproduction');dest.mkdir(exist_ok=False)
 for name in producer.MODULES+['KeygenDecodeNoneAudit']:
  p=dest/'formal/Source3'/(name+'.lean');p.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(path('formal/Source3/'+name+'.lean'),p)
 oldRoot=producer.ROOT;output=StringIO()
 try:
  producer.ROOT=dest
  with redirect_stdout(output):producer.main()
 finally:producer.ROOT=oldRoot
 reproduced=dest/'formal/Source3/KeygenPublicEncoder077Audit.lean'
 assert reproduced.read_bytes()==path('formal/Source3/KeygenPublicEncoder077Audit.lean').read_bytes()
 import keygen_public077_binding as binding
 bindingRoot=dest/'binding';oldBindingRoot=binding.ROOT;oldArgv=sys.argv
 try:
  binding.ROOT=bindingRoot;sys.argv=[binding.__file__]
  with redirect_stdout(output):binding.main()
 finally:binding.ROOT=oldBindingRoot;sys.argv=oldArgv
 bindingChecks=[]
 for name in producer.MODULES:
  if 'Binding077' not in name and 'Source077' not in name:continue
  generated=bindingRoot/'formal/Source3'/(name+'.lean');liveSource=path('formal/Source3/'+name+'.lean')
  assert generated.read_bytes()==liveSource.read_bytes()
  bindingChecks.append({'source':pin(liveSource),'reproduced':pin(generated)})
 history=[]
 for n in range(1,31):
  label='keygen_public_077_'+str(n).zfill(3);directory=job.BUILD/'jobs'/label;rs=read(directory/'RECEIPTS.json')
  accepted=all(r['accepted'] for r in rs);cause=CAUSES.get(str(n).zfill(3));assert accepted or cause
  history.append({'job':label,'status':'ACCEPTED' if accepted else 'FAILED_RETAINED','cause':None if accepted else cause,
   'files':[pin(p) for p in sorted(directory.rglob('*')) if p.is_file() and not p.is_symlink() and
    (p.parent==directory or p.parent==directory/'logs' or p.suffix in {'.lean','.olean'})],
   'wait':pin(job.BUILD/'waits'/label/'WAIT.jsonl')})
 result={'utc':datetime.now(timezone.utc).isoformat(),'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_077',
  'step':'ENCODER_STEP_001','status':'PROVED_KERNEL_SCOPED / NOT_REVIEWED; WHOLE TODO CONTINUES',
  'entry':pin(ENTRY),'proof_head':head,'notes':pin(BASE+'_NOTES.md'),'modules':checks,
  'native_receipts':pin(FINAL+'/RECEIPTS.json'),'source_inputs':pin(FINAL+'/SOURCE_INPUTS.json'),
  'audit':pin(FINAL+'/SEARCH_AUDIT.json'),'audit_entries_jsonl':pin(FINAL+'/SEARCH_AUDIT_ENTRIES.jsonl'),
  'audit_counts':{'new':673,'inherited':4,'full_terms':665,'kernel_inductives':12},
  'precommit_format_refusal':pin('.build/levels_077/ENCODER_PRECOMMIT_WHITESPACE_001.json'),'audit_generator_reproduction':pin(reproduced),'binding_generator_reproduction':bindingChecks,'history':history,
  'closed':'Both complete public18433 source bodies/signatures bound; unsigned physical input loads and actual pointer-LHS stores; full public encoder prologue,1536-word loop, byte writes/masks, derived2880 return and constructive honest execution; canonical15-bit stream identity.',
  'open':'Full public decoder, SAME source h transport, actual caller header/length and final public postseal. Root B1.07/B1.08 assembly remains explicit.',
  'b1_acceptance':'B1.07/B1.08 NOT MET;B1.09 OPEN','midpoint_close':False,'source_assumptions_added':False,
  'limits':'Unchanged guarded j1/-M6144/AS12GiB/RSS8GiB/wall1800s/maxHeartbeats2000000; warningAsError,clean0/0.',
  'proof_modules':42,'named_declarations':673,'named_theorems':270,
  'self_review':pin('.build/levels_077/ENCODER_SELF_REVIEW_001.md'),
  'tools':[pin('tools/keygen_public_encoder077_audit.py'),pin('tools/keygen_public077_binding.py'),pin(Path(__file__))],'active_jobs':[],'push':False}
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
 print(json.dumps(write('.build/levels_077/ENCODER_STEP_001_POSTSEAL.json',{'utc':datetime.now(timezone.utc).isoformat(),
  'status':'PASS_SCOPED_INTERNAL_STEP; NOT FULL CALLER ASSEMBLY OR B1 ACCEPTANCE','entry_pins_checked':19007,
  'checked':checked,'distinct_pinned_files':len(checked),'source_inputs_current':True,'native_final_job_all_clean':True,
  'verifier_sha256':job.sha(Path(__file__)),'midpoint_close':False,'active_jobs':[]})))
if __name__=='__main__':
 if len(sys.argv)==2 and sys.argv[1]=='seal':seal()
 elif len(sys.argv)==3 and sys.argv[1]=='postseal':postseal(sys.argv[2])
 else:raise SystemExit('usage: keygen_public_encoder077_step.py seal | postseal STEP_SHA')
