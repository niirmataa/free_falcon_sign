#!/usr/bin/env python3
"""Preserve073 diagnostic evidence at an integrity stop; never repair a seal."""
from pathlib import Path
from datetime import datetime,timezone
import json,re,subprocess
import job
ROOT=Path(__file__).resolve().parents[1]
ENTRY='.build/levels_073/ENTRY_PINS_073.json'
ENTRY_SHA='ec2bab593a372b8dd9fc2b8a15df0c9e3b20d636ee5f1028920998c530ac9681'
BASE='notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_073'
MODULES=['KeygenDecodeValues','KeygenDecodeExecution','KeygenDecodeCellFrame','KeygenDecodePointerFrame',
 'KeygenDecodeStateFrame','KeygenDecodeMemory','KeygenDecodeNoneFrame','KeygenDecodePure','KeygenDecodeNoneAudit',
 'KeygenCodecNoneWord','KeygenCodecNonePairBytes','KeygenCodecNoneHistory','KeygenCodecNoneOriginal','KeygenCodecNoneWire']
CAUSES={
 '001':'Outer sandbox refused NETLINK_ROUTE. Authorized outer execution002 retained unchanged inner bwrap/network isolation/limits.',
 '003':'Induction alternatives copied an Args index; Args is a fixed parameter of the new relation. Repaired005.',
 '004':'Dependent module launched after003 failed; PointerFrame olean absent. No accepted result.',
 '005':'Mixed job: three frame modules accepted; Memory failed on pointer-width/bit-index normalization and unused simp arguments. Repaired006.',
 '008':'Comparison-determinism tactic selected a value constructor. Explicit compare_unique repaired009.',
 '010':'Mixed job: eight proof modules accepted; audit failed on missing explicit Pairs import. Audit repaired011. Its mixed SOURCE_INPUTS later caused the memory-step postseal refusal.',
 '012':'Kernel decision expected a closed width bound, but implicit word variable remained. Explicit change to8<32 repaired013.',
 '014':'Dependent skip elimination removed the local state name low. Explicit final state repaired015.',
 '016':'Unavailable list length lemma and nullable-pointer-list normalization. Structural empty-list proof and explicit map reduction repaired017.',
 '019':'Physical byte-view block needed explicit reduction; dependent Fin indexing normalization failed. Fin.cases repaired020.'}
def read(p):return json.loads((ROOT/p).read_text())
def pin(p):
 p=Path(p);p=p if p.is_absolute() else ROOT/p
 return {'path':str(p.relative_to(ROOT)) if p.is_relative_to(ROOT) else str(p),'sha256':job.sha(p),'bytes':p.stat().st_size}
def write(p,value):
 p=ROOT/p
 with p.open('x') as stream:json.dump(value,stream,indent=2);stream.write('\n')
 return pin(p)
def main():
 assert not job.active()
 assert job.sha(ROOT/ENTRY)==ENTRY_SHA
 entry=read(ENTRY);assert len(entry['checked'])==entry['distinct_pinned_files']==15815
 for path,expected in entry['checked'].items():assert job.sha(Path(path))==expected,('predecessor changed',path)
 previous=write('.build/levels_073/PREDECESSOR_AT_STOP.json',{
  'utc':datetime.now(timezone.utc).isoformat(),'status':'UNCHANGED_PREDECESSOR_PINS_ONLY',
  'entry':pin(ENTRY),'checked_files':15815,'active_jobs':[]})
 assert not (ROOT/'.build/levels_073/MEMORY_POSTSEAL.json').exists()
 manifest=read('.build/jobs/keygen_decode_none_073_010/SOURCE_INPUTS.json')
 old=next(e for e in manifest['sources'] if e['module']=='Source3.KeygenDecodeNoneAudit')
 current=ROOT/'formal/Source3/KeygenDecodeNoneAudit.lean'
 snapshot=ROOT/'.build/jobs/keygen_decode_none_073_010/formal/Source3/KeygenDecodeNoneAudit.lean'
 assert job.sha(snapshot)==old['sha256'] and job.sha(current)!=old['sha256']
 refusal=write('.build/levels_073/INTEGRITY_REFUSAL.json',{
  'utc':datetime.now(timezone.utc).isoformat(),'status':'INTEGRITY_STOP; NOT A MATHEMATICAL_COUNTEREXAMPLE',
  'command':['python3','-B','tools/keygen_decode_none_batch.py','verify',
   'acf532c5c2ee03e4d7afc70c477f1e42c69632d73b0c8fb98375e7c131f9bd07','.build/levels_073/MEMORY_POSTSEAL.json'],
  'exit_code':1,'exception':'AssertionError: pin mismatch for Source3.KeygenDecodeNoneAudit',
  'manifest_expected_sha256':old['sha256'],'actual_current_sha256':job.sha(current),
  'manifest':pin('.build/jobs/keygen_decode_none_073_010/SOURCE_INPUTS.json'),
  'failed_audit_snapshot':pin(snapshot),'final_accepted_audit_source':pin(current),
  'stdout':pin('.build/levels_073/MEMORY_POSTSEAL_REFUSAL.stdout'),
  'stderr':pin('.build/levels_073/MEMORY_POSTSEAL_REFUSAL.stderr'),
  'postseal_created':False,'repair_attempted':False,'sealed_step_rewritten':False})
 cache=read('.build/cache/CACHE_INDEX.json');modules=[];declarations=theorems=0
 for name in MODULES:
  e=cache['Source3.'+name];directory=Path(e['receipt']).parent
  source=ROOT/'formal/Source3'/(name+'.lean');snap=directory/'formal/Source3'/(name+'.lean')
  artifact=directory/'lib/Source3'/(name+'.olean')
  rec=next(r for r in json.loads(Path(e['receipt']).read_text()) if r['name']=='Source3_'+name)
  assert rec['accepted'] and rec['clean_log'] and rec['exit_code']==0 and rec['forbidden_proof_markers']==[]
  assert job.sha(source)==job.sha(snap)==rec['source_sha256']==e['source_sha256']
  assert job.sha(artifact)==job.sha(Path(e['artifact']))==rec['olean_sha256']==e['artifact_sha256']
  text=source.read_text();names=re.findall(r'^\s*(?:def|abbrev|theorem|structure|inductive)\s+(\w+(?:\.\w+)*)',text,re.M)
  nTheorems=len(re.findall(r'^theorem ',text,re.M));declarations+=len(names);theorems+=nTheorems
  modules.append({'module':'Source3.'+name,'source':pin(source),'snapshot':pin(snap),
   'artifact':pin(artifact),'cache_artifact':pin(e['artifact']),'receipt':pin(e['receipt']),
   'source_inputs':pin(directory/'SOURCE_INPUTS.json'),'stdout':pin(directory/rec['stdout']),
   'stderr':pin(directory/rec['stderr']),'declarations':names,'theorems':nTheorems,
   'accepted':True,'clean_log':True,'elapsed_s':rec['elapsed_s'],'maxrss_kib':rec['cumulative_child_maxrss_kib'],
   'boundary':'Per-module native checks only; complete mixed010 SOURCE_INPUTS has the explicitly recorded stale selected audit.'})
 history=[];steps=[]
 for directory in sorted((job.BUILD/'jobs').glob('keygen_decode_none_073_*')):
  records=json.loads((directory/'RECEIPTS.json').read_text());steps+=records
  accepted=all(r['accepted'] for r in records);number=directory.name.rsplit('_',1)[1]
  assert accepted or number in CAUSES
  history.append({'job':directory.name,'status':'ACCEPTED' if accepted else 'FAILED_RETAINED',
   'cause':None if accepted else CAUSES[number],
   'files':[pin(p) for p in sorted(directory.rglob('*')) if p.is_file() and not p.is_symlink() and
    (p.parent==directory or p.parent==directory/'logs' or p.suffix in {'.lean','.olean'})],
   'wait':pin(job.BUILD/'waits'/directory.name/'WAIT.jsonl')})
 auditDir=Path(cache['Source3.KeygenDecodeNoneAudit']['receipt']).parent
 audit=json.loads((auditDir/'SEARCH_AUDIT.json').read_text())
 assert len(audit)==75
 for e in audit:
  assert set(e['axioms'])<={'propext','Classical.choice','Quot.sound'} and '⋯' not in json.dumps(e,ensure_ascii=False)
  assert e['body'].get('term') or e['body'].get('constructors')
 result={'created_utc':datetime.now(timezone.utc).isoformat(),'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_073',
  'status':'INTEGRITY_STOP / PARTIAL_PROOF / NOT_REVIEWED / TODO_NOT_COMPLETED',
  'close_reason':'Owner-requested stop on hard integrity refusal; NOT a routine midpoint close.',
  'base_checkpoint':'52R','base_head':'3619a22db195c4401e6247bec46b282f898fcee6',
  'assessment_head':subprocess.check_output(['git','rev-parse','HEAD'],cwd=job.REPO,text=True).strip(),
  'own_source_commits':['06392f4f5e535f0cbb3030bf851e97fe56fe33fa','cbad429fd0b967197e82a7087da49515910036a6'],
  'foreign_shared_commits_preserved':['a824f625','ecdac3d0','1236b53f'],
  'entry':pin(ENTRY),'predecessor_at_stop':previous,'integrity_refusal':refusal,'target':pin('.build/levels_073/TARGET.json'),
  'rejected_step':pin('notes/run/KEYGEN_DECODE_MEMORY_073_STEP.json'),
  'rejected_step_notes':pin('notes/run/KEYGEN_DECODE_MEMORY_073_STEP_NOTES.md'),
  'errata':pin('notes/run/KEYGEN_DECODE_MEMORY_073_ERRATA.md'),'notes':pin(BASE+'_NOTES.md'),
  'accepted_current_module_checks':modules,'new_proof_modules':13,'audit_modules':1,
  'new_declarations':declarations,'new_theorems':theorems,
  'audit':{'file':pin(auditDir/'SEARCH_AUDIT.json'),'entries':75,'new':71,'inherited':4,'full_terms':62,'kernel_inductives':13,
   'entries_jsonl':pin(auditDir/'SEARCH_AUDIT_ENTRIES.jsonl'),
   'scope':'Eight initial modules only. Five later NONE encoder modules have native clean builds; expanded full-term audit not run after integrity stop.'},
  'history':history,'jobs':len(history),'wholly_accepted_jobs':sum(e['status']=='ACCEPTED' for e in history),
  'failed_jobs':sum(e['status']!='ACCEPTED' for e in history),'steps':len(steps),
  'accepted_steps':sum(r['accepted'] for r in steps),'maxrss_kib':max(r['cumulative_child_maxrss_kib'] for r in steps),
  'native_child_elapsed_sum_s':round(sum(r['elapsed_s'] for r in steps),3),
  'latest_current_module_elapsed_sum_s':round(sum(e['elapsed_s'] for e in modules),3),
  'postseal_success':False,'diagnostic_inventory_only':True,
  'b1_07_acceptance':'NOT_MET / inherited PARTIAL_PROOF','b1_08_acceptance':'NOT_MET / PARTIAL_PROOF',
  'b1_09_acceptance':'NOT_MET / OPEN_UNSTARTED073','whole_todo_complete':False,
  'order_status':{'NONE':'Whole encoder bytes and whole decoder frame proved; full source decoder inverse OPEN.',
   'STATIC':'Inherited071 encoder and072 lengths unchanged; full source decoder OPEN, not started073.',
   'math_physical_transport':'OPEN, not started073.', 'public_codec_LAST':'OPEN, not started073.'},
  'counterexamples':'Inherited065/066 and072 carrier/padding witnesses unchanged; no new source counterexample, Sage or C campaign.',
  'mathematical_impossibility_established':False,
  'resume_condition':'Owner decision on a new superseding provenance receipt or clean native rebuild; never rewrite the rejected sealed step or weaken its verifier. Then finish source NONE decoder values/loop/return/existence, STATIC, transport, public LAST.',
  'limits':'Unchanged j1/-M6144, AS12GiB/RSS8GiB/wall1800s/maxHeartbeats2000000, warningAsError; accepted logs0/0.',
  'proofread_math_self_review':{'scope':'New13 proof modules and final English synthesis; no mathematical-token edits; no independent review.',
   'scope_issue':'Generic decoder Exec has no call/switch/break rules; used only for complete NONE, never claimed as complete STATIC/dispatcher semantics.'},
  'active_jobs':[],'push':False,'independent_review':False,'delegation':False,'migration':False,'production_C_changed':False,
  'tools':[pin('tools/keygen_decode_none_audit.py'),pin('tools/keygen_decode_none_batch.py'),pin(Path(__file__))]}
 assert not job.active()
 print(json.dumps(write(BASE+'.json',result)))
if __name__=='__main__':main()
