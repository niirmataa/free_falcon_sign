#!/usr/bin/env python3
"""Append-only073 development-step pins; does not assert a codec round-trip."""
from datetime import datetime,timezone
from pathlib import Path
import hashlib,json,sys
import job
import keygen_decode_none_audit as producer
ROOT=Path(__file__).resolve().parents[1]
ENTRY='.build/levels_073/ENTRY_PINS_073.json'
ENTRY_SHA='ec2bab593a372b8dd9fc2b8a15df0c9e3b20d636ee5f1028920998c530ac9681'
BASE='notes/run/KEYGEN_DECODE_MEMORY_073_STEP'
CAUSES={
 '001':'Outer sandbox NETLINK_ROUTE refusal. The inner bwrap runner was unchanged; authorized outer execution002 succeeded.',
 '003':'Copied induction alternatives included an Args index; the independent relation has Args as a fixed parameter. Final alternatives repaired.',
 '004':'Premature dependent launch after003 failed; PointerFrame product absent. No accepted memory result from this job.',
 '005':'Mixed job: three frame modules accepted; Memory failed on pointer-width normalization and generic bit-index simplification/linter errors. Repaired006.',
 '008':'Comparison determinism tactic chose an inappropriate constructor; separate compare_unique repaired009.',
 '010':'Mixed job: all eight proof modules accepted; audit lacked an explicit inherited Pairs import. Repaired011.'}

def read(p):return json.loads((ROOT/p).read_text())
def pin(p):
 p=Path(p);p=p if p.is_absolute() else ROOT/p
 return {'path':str(p.relative_to(ROOT)) if p.is_relative_to(ROOT) else str(p),'sha256':job.sha(p),'bytes':p.stat().st_size}
def write(p,value):
 p=ROOT/p;p.parent.mkdir(parents=True,exist_ok=True)
 with p.open('x') as stream:json.dump(value,stream,indent=2);stream.write('\n')
 return pin(p)
def predecessor():
 assert job.sha(ROOT/ENTRY)==ENTRY_SHA
 entry=read(ENTRY);assert entry['distinct_pinned_files']==len(entry['checked'])==15815
 for path,expected in entry['checked'].items():assert job.sha(Path(path))==expected,('predecessor changed',path)
 assert not job.active()
 return entry

def seal():
 predecessor();cache=read('.build/cache/CACHE_INDEX.json');modules=[]
 for name in producer.MODULES+['KeygenDecodeNoneAudit']:
  e=cache['Source3.'+name];directory=Path(e['receipt']).parent
  source=ROOT/'formal/Source3'/(name+'.lean');snapshot=directory/'formal/Source3'/(name+'.lean')
  record=next(r for r in json.loads(Path(e['receipt']).read_text()) if r['name']=='Source3_'+name)
  assert record['accepted'] and record['clean_log'] and record['exit_code']==0 and record['forbidden_proof_markers']==[]
  assert job.sha(source)==job.sha(snapshot)==record['source_sha256']==e['source_sha256']
  artifact=directory/'lib/Source3'/(name+'.olean')
  assert job.sha(artifact)==job.sha(Path(e['artifact']))==record['olean_sha256']==e['artifact_sha256']
  modules.append({'module':'Source3.'+name,'source':pin(source),'snapshot':pin(snapshot),'artifact':pin(artifact),
   'cache_artifact':pin(e['artifact']),'receipt':pin(e['receipt']),'source_inputs':pin(directory/'SOURCE_INPUTS.json'),
   'stdout':pin(directory/record['stdout']),'stderr':pin(directory/record['stderr']),
   'elapsed_s':record['elapsed_s'],'maxrss_kib':record['cumulative_child_maxrss_kib']})
 auditDir=Path(cache['Source3.KeygenDecodeNoneAudit']['receipt']).parent
 audit=json.loads((auditDir/'SEARCH_AUDIT.json').read_text())
 expected={ns+'.'+n for ns,n in producer.declarations()}|{'FT1536.Source3.'+n for n in producer.INHERITED}
 assert {e['name'] for e in audit}==expected and len(audit)==len(expected)==75
 for e in audit:
  assert set(e['axioms'])<={'propext','Classical.choice','Quot.sound'} and '⋯' not in json.dumps(e,ensure_ascii=False)
  assert e['body'].get('term') or e['body'].get('constructors')
 history=[]
 for n in range(1,12):
  label='keygen_decode_none_073_'+str(n).zfill(3);directory=job.BUILD/'jobs'/label
  records=json.loads((directory/'RECEIPTS.json').read_text()) if (directory/'RECEIPTS.json').exists() else []
  accepted=bool(records) and all(r['accepted'] for r in records)
  assert accepted or str(n).zfill(3) in CAUSES,label
  history.append({'job':label,'status':'ACCEPTED' if accepted else 'FAILED_RETAINED',
   'cause':None if accepted else CAUSES[str(n).zfill(3)],
   'files':[pin(p) for p in sorted(directory.rglob('*')) if p.is_file() and not p.is_symlink() and
      (p.parent==directory or p.parent==directory/'logs' or p.suffix in {'.lean','.olean'})],
   'wait':pin(job.BUILD/'waits'/label/'WAIT.jsonl')})
 result={'created_utc':datetime.now(timezone.utc).isoformat(),'task':'KEYGEN_SOURCE_TO_FIBER_001',
 'step':'073_MEMORY_INFRASTRUCTURE','status':'PROVED_KERNEL_SCOPED / NOT_REVIEWED; TODO CONTINUES',
 'entry':pin(ENTRY),'notes':pin(BASE+'_NOTES.md'),'target':pin('.build/levels_073/TARGET.json'),
 'modules':modules,'audit':pin(auditDir/'SEARCH_AUDIT.json'),'audit_entries':75,'full_terms':62,'kernel_inductives':13,
 'audit_entries_jsonl':pin(auditDir/'SEARCH_AUDIT_ENTRIES.jsonl'),'attempts':history,
 'tools':[pin('tools/keygen_decode_none_audit.py'),pin('tools/keygen_decode_none_batch.py')],
 'closed':['Independent physical byte-read/int16-store decoder semantics.',
 'Complete bound NONE source_frame for unrestricted actual flow; no desired frame premise.',
 'Physical store_readback and exact store_same_memory; no whole-decoder correctness claim.'],
 'open':['Full source NONE memory round-trip and honest source-execution existence.',
 'Full source STATIC round-trip; same mathematical/physical transport; public source codec LAST.'],
 'midpoint_close':False,'push':False,'independent_review':False,'active_jobs':[]}
 print(json.dumps(write(BASE+'.json',result)))

def verify(expected,target):
 entry=predecessor();checked=dict(entry['checked'])
 def check(p,sha):
  p=Path(p);p=p if p.is_absolute() else ROOT/p
  assert job.sha(p)==sha,('pin mismatch',str(p))
  if str(p) in checked:assert checked[str(p)]==sha
  checked[str(p)]=sha
 def walk(value):
  if isinstance(value,dict):
   if 'path' in value and 'sha256' in value:check(value['path'],value['sha256'])
   for v in value.values():walk(v)
  elif isinstance(value,list):
   for v in value:walk(v)
 check(BASE+'.json',expected);result=read(BASE+'.json');walk(result)
 for module in result['modules']:
  inputs=read(module['source_inputs']['path'])
  for e in inputs['sources']:check(e['path'],e['sha256'])
  for e in inputs['reused']:
   check(e.get('current_source',e['source']),e['source_sha256']);check(e['artifact'],e['artifact_sha256'])
 assert not job.active()
 print(json.dumps(write(target,{'utc':datetime.now(timezone.utc).isoformat(),'step':'073_MEMORY_INFRASTRUCTURE',
 'checked':checked,'distinct_pinned_files':len(checked),'active_jobs':[],'verifier_sha256':job.sha(Path(__file__))})))
if __name__=='__main__':
 if sys.argv[1]=='seal':seal()
 else:
  assert sys.argv[1]=='verify' and len(sys.argv)==4
  verify(sys.argv[2],sys.argv[3])
