#!/usr/bin/env python3
"""Owner-authorized073 pin overlay, immutable-history postseal, then074 entry."""
from datetime import datetime, timezone
from pathlib import Path
import difflib, json, subprocess, sys
import job

ROOT=Path(__file__).resolve().parents[1]
SUP='notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_073_SEAL_SUPPLEMENT_001.json'
RUNTIME='.build/levels_073/seal_supplement_001'
ENTRY='.build/levels_073/ENTRY_PINS_073.json'
ENTRY_SHA='ec2bab593a372b8dd9fc2b8a15df0c9e3b20d636ee5f1028920998c530ac9681'
BATCH='notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_073.json'
BATCH_SHA='b6b0080a341bbe8fae7ecb7b62f658d78cb3defe01acf765789faeee7041b5d0'
STEP='notes/run/KEYGEN_DECODE_MEMORY_073_STEP.json'
STEP_SHA='acf532c5c2ee03e4d7afc70c477f1e42c69632d73b0c8fb98375e7c131f9bd07'
AUDIT='formal/Source3/KeygenDecodeNoneAudit.lean'
OLD='d818dd129d1b8aee439b4f3f12307d0b3a614cc6d236ba28f40ff4e433085301'
NEW='dc2f54399f781ec25842eea26f5cc7adfa7955d348470443c16d63b2ad9d7cc0'
J10='.build/jobs/keygen_decode_none_073_010'
J11='.build/jobs/keygen_decode_none_073_011'
MANIFEST=J10+'/SOURCE_INPUTS.json'
MANIFEST_SHA='b19c0a31efb85af044952e6984eec107052582622640d9d1a667e57116960358'
POST='.build/levels_073/POSTSEAL_WITH_SUPPLEMENT_001.json'
NEXT='.build/levels_074/ENTRY_PINS_074.json'

def path(p):
 p=Path(p);return p if p.is_absolute() else ROOT/p

def read(p):return json.loads(path(p).read_text())
def pin(p):
 p=path(p)
 return {'path':str(p.relative_to(ROOT)) if p.is_relative_to(ROOT) else str(p),
  'sha256':job.sha(p),'bytes':p.stat().st_size}

def write(p,value):
 p=path(p);p.parent.mkdir(parents=True,exist_ok=True)
 with p.open('x') as stream:json.dump(value,stream,indent=2);stream.write('\n')
 return pin(p)

def require_sha(p,expected):
 actual=job.sha(path(p));assert actual==expected,('pin mismatch',str(path(p)),expected,actual)

def predecessor():
 assert not job.active(),'A guarded proof job is active; wait without weakening this check'
 require_sha(ENTRY,ENTRY_SHA);entry=read(ENTRY)
 assert len(entry['checked'])==entry['distinct_pinned_files']==15815
 for p,expected in entry['checked'].items():require_sha(p,expected)
 require_sha(BATCH,BATCH_SHA);require_sha(STEP,STEP_SHA);require_sha(MANIFEST,MANIFEST_SHA)
 return entry

def source_scan():
 files=list((ROOT/'formal').rglob('*.lean'))+list((ROOT/'sage').rglob('*.sage'))
 files += [p for p in (job.REPO/'Extra/c').rglob('*') if p.is_file() and p.suffix in {'.c','.h'}]
 return {str(p.resolve()):job.sha(p) for p in sorted(files)}

def historical_audits():
 oldSnapshot=J10+'/formal/Source3/KeygenDecodeNoneAudit.lean'
 newSnapshot=J11+'/formal/Source3/KeygenDecodeNoneAudit.lean'
 require_sha(oldSnapshot,OLD);require_sha(newSnapshot,NEW);require_sha(AUDIT,NEW)
 old=path(oldSnapshot).read_bytes();new=path(newSnapshot).read_bytes()
 anchor=b'import Source3.KeygenCodecExactLengths\n'
 assert old.count(anchor)==1
 assert new==old.replace(anchor,anchor+b'import Source3.KeygenDecodeNonePairs\n')
 manifest=read(MANIFEST)
 matches=[(i,e) for i,e in enumerate(manifest['sources']) if e['module']=='Source3.KeygenDecodeNoneAudit']
 assert len(matches)==1
 index,selected=matches[0]
 assert index==8 and path(selected['path'])==path(AUDIT) and selected['sha256']==OLD
 oldRecords=read(J10+'/RECEIPTS.json');newRecords=read(J11+'/RECEIPTS.json')
 assert len(oldRecords)==9 and all(r['accepted'] for r in oldRecords[:8])
 oldRecord=oldRecords[-1];assert oldRecord['name']=='Source3_KeygenDecodeNoneAudit'
 assert not oldRecord['accepted'] and oldRecord['source_sha256']==OLD
 assert len(newRecords)==1
 newRecord=newRecords[0]
 assert newRecord['name']=='Source3_KeygenDecodeNoneAudit' and newRecord['source_sha256']==NEW
 assert newRecord['accepted'] and newRecord['clean_log'] and newRecord['exit_code']==0
 assert newRecord['forbidden_proof_markers']==[]
 require_sha(J11+'/lib/Source3/KeygenDecodeNoneAudit.olean',newRecord['olean_sha256'])
 newInputs=read(J11+'/SOURCE_INPUTS.json')
 assert len(newInputs['sources'])==1 and newInputs['sources'][0]['sha256']==NEW
 correction=''.join(difflib.unified_diff(old.decode().splitlines(keepends=True),new.decode().splitlines(keepends=True),
  fromfile='keygen_decode_none_073_010/KeygenDecodeNoneAudit.lean',
  tofile='keygen_decode_none_073_011/KeygenDecodeNoneAudit.lean'))
 return oldSnapshot,newSnapshot,index,correction

def create():
 entry=predecessor();oldSnapshot,newSnapshot,index,correction=historical_audits()
 assert not path(SUP).exists(),'Never overwrite a seal supplement'
 baseline=source_scan()
 scan=write(RUNTIME+'/PRE_SUPPLEMENT_SCAN.json',{
  'utc':datetime.now(timezone.utc).isoformat(),'entry':pin(ENTRY),
  'all_15815_entry_pins_match':True,'checked_entry_pin_count':15815,
  'entry_pins_changed':[],'source_files_before':baseline,'active_jobs':[]})
 diffPath=path(RUNTIME+'/AUDIT_010_TO_011.diff')
 diffPath.parent.mkdir(parents=True,exist_ok=True)
 with diffPath.open('x') as stream:stream.write(correction)
 notes=SUP.replace('.json','_NOTES.md')
 result={'created_utc':datetime.now(timezone.utc).isoformat(),
  'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_073','supplement':'SEAL_SUPPLEMENT_001',
  'status':'OWNER_AUTHORIZED_PIN_ONLY_CORRECTION; POSTSEAL REQUIRED',
  'owner_authorization':'ZATWIERDZAM korektę pinu w suplemencie; preserve manifest010, both historical states and postseal refusal; rescan all15815 inputs; no source/theorem byte changes; postseal before ENTRY_PINS_074.',
  'authorization_scope':'Exactly one selected audit source-pin overlay at /sources/8/sha256 in the frozen010 manifest; no historical manifest mutation.',
  'reason':'organizer połączył wyniki mieszanego jobu 010 z poprawionym audytem 011',
  'original_batch':pin(BATCH),'original_rejected_step':pin(STEP),'notes':pin(notes),
  'correction':{'module':'Source3.KeygenDecodeNoneAudit','frozen_manifest':pin(MANIFEST),
   'json_pointer':'/sources/'+str(index)+'/sha256','live_source_path':str(path(AUDIT)),
   'old_sha256':OLD,'new_sha256':NEW,'old_failed_job':'keygen_decode_none_073_010',
   'new_accepted_job':'keygen_decode_none_073_011',
   'old_job_receipts':pin(J10+'/RECEIPTS.json'),'new_job_receipts':pin(J11+'/RECEIPTS.json'),
   'old_snapshot':pin(oldSnapshot),'new_snapshot':pin(newSnapshot),'current_source':pin(AUDIT),
   'new_source_inputs':pin(J11+'/SOURCE_INPUTS.json'),'new_accepted_olean':pin(J11+'/lib/Source3/KeygenDecodeNoneAudit.olean'),
   'new_full_audit':pin(J11+'/SEARCH_AUDIT.json'),'correction_diff':pin(diffPath),
   'historical_fix':'Exactly one added explicit import Source3.KeygenDecodeNonePairs, already accepted in011 and committed in06392f4f; no new proof/source edit in this supplement.',
   'job010_rerun_or_relabelled':False,'failed_audit010_claimed_accepted':False},
  'all_other_input_pins':{'entry':pin(ENTRY),'scan_receipt':scan,'scanned':15815,'matching':15815,
   'mismatches':[],'all_match':True},
  'scope_statement':'The correction affects only the audit pin used for live-input reconciliation of frozen manifest010. Manifest010 bytes, historical snapshots and refusal remain unchanged. No Lean, Sage, C source or theorem bytes are changed by this supplement.',
  'source_bytes_unchanged':{'scan_receipt':scan,'source_file_count':len(baseline),'unchanged_after_creation':True,
   'categories':['source3/formal/**/*.lean','source3/sage/**/*.sage','Extra/c/**/*.{c,h}']},
  'retained_refusal':{'record':pin('.build/levels_073/INTEGRITY_REFUSAL.json'),
   'stdout':pin('.build/levels_073/MEMORY_POSTSEAL_REFUSAL.stdout'),
   'stderr':pin('.build/levels_073/MEMORY_POSTSEAL_REFUSAL.stderr'),
   'errata':pin('notes/run/KEYGEN_DECODE_MEMORY_073_ERRATA.md')},
  'verifier':pin(Path(__file__)),
  'mathematical_status':'Unchanged: B1.07/B1.08 Acceptance NOT MET, B1.09 OPEN; no round-trip or REVIEWED claim.',
  'postseal_destination':POST,'next_entry_destination':NEXT,
  'staged_order':'Create supplement; verify postseal with supplement in closure; only then create074 entry.',
  'historical_manifests_edited':False,'sources_or_theorems_edited':False,'push':False}
 assert source_scan()==baseline
 print(json.dumps(write(SUP,result)))

def verify_closure(supplement_sha):
 entry=predecessor();require_sha(SUP,supplement_sha);supplement=read(SUP)
 oldSnapshot,newSnapshot,index,correction=historical_audits()
 assert supplement['correction']['old_sha256']==OLD and supplement['correction']['new_sha256']==NEW
 assert supplement['correction']['frozen_manifest']['sha256']==MANIFEST_SHA
 assert supplement['correction']['json_pointer']=='/sources/8/sha256'
 assert supplement['authorization_scope'].startswith('Exactly one selected audit source-pin overlay')
 scan=read(supplement['all_other_input_pins']['scan_receipt']['path'])
 assert scan['all_15815_entry_pins_match'] and scan['checked_entry_pin_count']==15815
 assert source_scan()==scan['source_files_before'],'Source bytes changed during the pin-only supplement'
 checked=dict(entry['checked'])
 def check(p,expected):
  p=path(p);require_sha(p,expected)
  if str(p) in checked:assert checked[str(p)]==expected,('conflicting pin',str(p))
  checked[str(p)]=expected
 def walk(v):
  if isinstance(v,dict):
   if 'path' in v and 'sha256' in v:check(v['path'],v['sha256'])
   for value in v.values():walk(value)
  elif isinstance(v,list):
   for value in v:walk(value)
 for p,sha in [(BATCH,BATCH_SHA),(STEP,STEP_SHA),(SUP,supplement_sha)]:
  check(p,sha);walk(read(p))
 manifests=set()
 for item in read(BATCH)['accepted_current_module_checks']+read(STEP)['modules']:
  manifests.add(str(path(item['source_inputs']['path'])))
 overlays=[];live_checks=0
 for m in sorted(manifests):
  inputs=read(m)
  for i,e in enumerate(inputs['sources']):
   expected=e['sha256']
   if path(m)==path(MANIFEST) and i==index:
    assert job.sha(path(m))==MANIFEST_SHA
    assert e['module']=='Source3.KeygenDecodeNoneAudit' and path(e['path'])==path(AUDIT) and expected==OLD
    expected=NEW
    overlays.append({'frozen_manifest':pin(m),'json_pointer':'/sources/8/sha256','old_sha256':OLD,
     'effective_live_sha256':NEW,'authority':pin(SUP),'historical_snapshot':pin(oldSnapshot)})
   check(e['path'],expected);live_checks+=1
  for e in inputs['reused']:
   check(e.get('current_source',e['source']),e['source_sha256'])
   check(e['artifact'],e['artifact_sha256']);live_checks+=2
 assert len(overlays)==1,'Only the one owner-authorized overlay is permitted'
 assert not job.active()
 return checked,overlays,live_checks,len(manifests),scan

def postseal(supplement_sha):
 checked,overlays,live_checks,manifest_count,scan=verify_closure(supplement_sha)
 result={'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-073',
  'status':'PASS_WITH_OWNER_AUTHORIZED_SEAL_SUPPLEMENT_001','postseal_success':True,
  'original_batch':pin(BATCH),'seal_supplement':pin(SUP),'checked':checked,
  'distinct_pinned_files':len(checked),'original_entry_pins_checked':15815,
  'all_15815_entry_pins_match':True,'source_input_manifests_checked':manifest_count,
  'live_source_and_artifact_checks':live_checks,'explicit_pin_overlays':overlays,
  'source_files_unchanged':len(scan['source_files_before']),
  'historical_manifest010_preserved':pin(MANIFEST),'original_refusal_preserved':pin('.build/levels_073/INTEGRITY_REFUSAL.json'),
  'no_source_or_theorem_byte_changes':True,'mathematical_status_unchanged':True,
  'supplement_in_closure':str(path(SUP)) in checked,'verifier_sha256':job.sha(Path(__file__)),
  'active_jobs':[],'push':False}
 assert result['supplement_in_closure']
 print(json.dumps(write(POST,result)))

def entry(supplement_sha,postseal_sha):
 checked,overlays,live_checks,manifest_count,scan=verify_closure(supplement_sha)
 require_sha(POST,postseal_sha);post=read(POST)
 assert post['postseal_success'] and post['status']=='PASS_WITH_OWNER_AUTHORIZED_SEAL_SUPPLEMENT_001'
 assert post['seal_supplement']['sha256']==supplement_sha and post['checked']==checked
 assert post['explicit_pin_overlays']==overlays and post['supplement_in_closure']
 for p,expected in post['checked'].items():require_sha(p,expected)
 checked[str(path(POST))]=postseal_sha
 result={'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-073',
  'purpose':'ENTRY_PINS_074; created only after successful supplemented073 postseal',
  'checked':checked,'distinct_pinned_files':len(checked),'postseal_receipt':pin(POST),
  'seal_supplement':pin(SUP),'explicit_pin_overlays':overlays,
  'original_entry_pins_checked':15815,'all_15815_entry_pins_match':True,
  'source_files_unchanged':len(scan['source_files_before']),
  'recorded_supersessions':read(ENTRY).get('recorded_supersessions'),
  'new_supersession_scope':'Only /sources/8/sha256 in frozen010 live-input reconciliation, as recorded in the immutable seal supplement; historical bytes preserved.',
  'postseal_success':True,'supplement_in_closure':True,'active_jobs':[],
  'verifier_sha256':job.sha(Path(__file__))}
 assert not job.active()
 print(json.dumps(write(NEXT,result)))

if __name__=='__main__':
 if len(sys.argv)==2 and sys.argv[1]=='create':create()
 elif len(sys.argv)==3 and sys.argv[1]=='postseal':postseal(sys.argv[2])
 elif len(sys.argv)==4 and sys.argv[1]=='entry':entry(sys.argv[2],sys.argv[3])
 else:raise SystemExit('usage: keygen_codec_seal_supplement073.py create | postseal SUP_SHA | entry SUP_SHA POSTSEAL_SHA')
