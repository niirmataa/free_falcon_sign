#!/usr/bin/env python3
"""Append a final complete-body audit seal without modifying earlier seals."""
from pathlib import Path
from datetime import datetime, timezone
from contextlib import redirect_stdout
from io import StringIO
import hashlib, json, shutil, subprocess, sys
import job
import keygen_codec_whole078_audit as producer
ROOT=Path(__file__).resolve().parents[1]
ENTRY='.build/levels_078/ENTRY_PINS_078.json'
ENTRY_SHA='dc91e7adad875c0ae6c9a068f210b1a62f1b1e13ddac19147277f9e6b8f122e1'
BASE='notes/run/KEYGEN_SOURCE_TO_FIBER_001_CODEC_WHOLE_TODO_SEAL_001'
FINAL='.build/jobs/keygen_codec_final_078_001'
POST='.build/levels_078/WHOLE_TODO_POSTSEAL_001.json'
AUDIT='KeygenCodecWholeTodo078Audit'
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
 entry=read(ENTRY);assert entry['distinct_pinned_files']==len(entry['checked'])==20591
 for p,h in entry['checked'].items():assert job.sha(path(p))==h,('input pin mismatch',p)
 return entry

def seal():
 inputs()
 records=read(FINAL+'/RECEIPTS.json');assert len(records)==1
 rec=records[0];assert rec['name']=='Source3_'+AUDIT and rec['accepted'] and rec['clean_log'] and rec['exit_code']==0 and rec['forbidden_proof_markers']==[]
 source='formal/Source3/'+AUDIT+'.lean';snapshot=FINAL+'/'+source;artifact=FINAL+'/lib/Source3/'+AUDIT+'.olean'
 assert job.sha(path(source))==job.sha(path(snapshot))==rec['source_sha256']
 assert job.sha(path(artifact))==rec['olean_sha256']
 head=subprocess.check_output(['git','rev-parse','HEAD'],cwd=job.REPO,text=True).strip()
 proof_sources=[]
 for name in producer.MODULES+[AUDIT]:
  p=path('formal/Source3/'+name+'.lean');rel=str(p.relative_to(job.REPO))
  assert hashlib.sha256(subprocess.check_output(['git','show',head+':'+rel],cwd=job.REPO)).hexdigest()==job.sha(p)
  proof_sources.append(pin(p))
 live=read(FINAL+'/SOURCE_INPUTS.json')
 for e in live['sources']:assert job.sha(path(e['path']))==e['sha256']
 for e in live['reused']:
  assert job.sha(path(e.get('current_source',e['source'])))==e['source_sha256']
  assert job.sha(path(e['artifact']))==e['artifact_sha256']
 expected={ns+'.'+name for ns,names in producer.declarations().items() for name in names}
 assert len(expected)==1986 and len(producer.MODULES)==186
 inherited={'FT1536.Source3.'+n for n in producer.INHERITED}
 rows=read(FINAL+'/SEARCH_AUDIT.json')
 assert len(rows)==1990 and {r['name'] for r in rows}==expected|inherited
 for r in rows:
  assert set(r['axioms'])<={'propext','Classical.choice','Quot.sound'} and '⋯' not in json.dumps(r,ensure_ascii=False)
  assert r['body'].get('term') or r['body'].get('constructors')
 gap=read('.build/levels_078/AUDIT_COVERAGE_GAP_001.json')
 assert len(gap['missing_full_body_inventory'])==18 and set(gap['missing_full_body_inventory'])<=expected
 dest=path('.build/levels_078/whole_audit_reproduction_001');dest.mkdir(exist_ok=False)
 for name in producer.MODULES+['KeygenDecodeNoneAudit']:
  p=dest/'formal/Source3'/(name+'.lean');p.parent.mkdir(parents=True,exist_ok=True)
  shutil.copyfile(path('formal/Source3/'+name+'.lean'),p)
 oldRoot=producer.ROOT
 try:
  producer.ROOT=dest
  with redirect_stdout(StringIO()):producer.main()
 finally:producer.ROOT=oldRoot
 reproduced=dest/'formal/Source3'/(AUDIT+'.lean')
 assert reproduced.read_bytes()==path(source).read_bytes()
 result={'utc':datetime.now(timezone.utc).isoformat(),'task':'KEYGEN_SOURCE_TO_FIBER_001','scope':'Owner whole codec TODO after checkpoint52R, batches073–077, additive complete-body audit078',
  'status':'ALL_FOUR_LOCAL_CODEC_COMPONENTS_PROVED_KERNEL_SCOPED / NOT_REVIEWED; WHOLE_ROOT_B1_ACCEPTANCE_NOT_MET',
  'entry':pin(ENTRY),'proof_head':head,'notes':pin(BASE+'_NOTES.md'),'proof_sources':proof_sources,
  'audit_source':pin(source),'audit_snapshot':pin(snapshot),'audit_artifact':pin(artifact),
  'receipts':pin(FINAL+'/RECEIPTS.json'),'source_inputs':pin(FINAL+'/SOURCE_INPUTS.json'),
  'stdout':pin(FINAL+'/'+rec['stdout']),'stderr':pin(FINAL+'/'+rec['stderr']),
  'audit':pin(FINAL+'/SEARCH_AUDIT.json'),'audit_entries_jsonl':pin(FINAL+'/SEARCH_AUDIT_ENTRIES.jsonl'),
  'audit_counts':{'new_named_declarations':1986,'inherited':4,'entries':1990,'full_terms':1941,'kernel_inductives':49},
  'proof_module_count':186,'named_theorem_count':1002,'audit_module_count':18,
  'coverage_gap_retained':pin('.build/levels_078/AUDIT_COVERAGE_GAP_001.json'),'missing_coverage_after_audit':[],
  'generator_reproduction':pin(reproduced),'wait':pin('.build/waits/keygen_codec_final_078_001/WAIT.jsonl'),
  'final_job_files':[pin(p) for p in sorted(path(FINAL).iterdir()) if p.is_file()],
  'all_proof_source_bytes_unchanged':True,'prior_manifests_and_seals_unchanged':True,
  'open':'B1.07 accepted-attempt/serialization-entry and legal-workspace/relocation/call-ID/lifetime assembly; B1.08 final secret blob/header observation; B1.09 whole-root join. No full KeyGen-to-fiber/compiler/probability/security claim.',
  'tools':[pin('tools/keygen_codec_whole078_audit.py'),pin(Path(__file__))],
  'limits':'Guarded j1/-M6144/AS12GiB/RSS8GiB/wall1800s/maxHeartbeats2000000; warningAsError; final clean0/0.',
  'active_jobs':[],'push':False,'independent_review':False}
 assert not job.active()
 print(json.dumps(write(BASE+'.json',result)))

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
 check(BASE+'.json',expected);manifest=read(BASE+'.json');walk(manifest)
 gap=read(manifest['coverage_gap_retained']['path']);walk(gap)
 live=read(manifest['source_inputs']['path'])
 for e in live['sources']:check(e['path'],e['sha256'])
 for e in live['reused']:
  check(e.get('current_source',e['source']),e['source_sha256']);check(e['artifact'],e['artifact_sha256'])
 assert not job.active()
 print(json.dumps(write(POST,{'utc':datetime.now(timezone.utc).isoformat(),'status':'PASS_SCOPED_WHOLE_TODO_COMPLETE_AUDIT; NOT_REVIEWED; ROOT_ACCEPTANCE_NOT_MET',
  'entry_pins_checked':20591,'checked':checked,'distinct_pinned_files':len(checked),'all1986_new_named_declarations_audited':True,
  'no_hash_mismatches':True,'prior_proofs_and_seals_unchanged':True,'native_final_job_clean':True,'active_jobs':[],
  'verifier_sha256':job.sha(Path(__file__)),'push':False})))
if __name__=='__main__':
 if len(sys.argv)==2 and sys.argv[1]=='seal':seal()
 elif len(sys.argv)==3 and sys.argv[1]=='postseal':postseal(sys.argv[2])
 else:raise SystemExit('usage: keygen_codec_whole078_seal.py seal | postseal MANIFEST_SHA')
