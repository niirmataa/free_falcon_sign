#!/usr/bin/env python3
"""Seal/verify068 without rewriting any predecessor or failed attempt."""
from datetime import datetime, timezone
from pathlib import Path
from contextlib import redirect_stdout
from io import StringIO
import json, shutil, subprocess, sys
import job
import keygen_codec_static_audit as producer
from keygen_intermediate_batch import path, read, pin, committed, streams
from keygen_public_first_batch import write_receipt

BASE='notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_068'
ENTRY='.build/levels_068/ENTRY_PINS_068.json'
ENTRY_SHA='889fdb295e6421fdb8e832b1f084dd8a6665c7b826d05816cf19ba5f244dbd70'
AUDIT='KeygenCodecStaticAudit'


def checked_inputs():
    assert not job.active(), 'A proof job is active'
    assert job.sha(path(ENTRY))==ENTRY_SHA
    entry=read(ENTRY)
    assert entry['batch']=='BATCH_015-067'
    assert len(entry['checked'])==entry['distinct_pinned_files']==14135
    assert entry['active_jobs']==[]
    for p,expected in entry['checked'].items():
        assert job.sha(path(p))==expected, ('predecessor changed',p)
    return entry


def predecessor(target):
    entry=checked_inputs()
    print(json.dumps(write_receipt(target, {'checked':entry['checked'],'entry':pin(ENTRY),
      'verifier_sha256':job.sha(Path(__file__)),'recorded_supersessions':entry.get('recorded_supersessions'),'active_jobs':[]})))


def generator():
    dest=path('.build/levels_068/audit_reproduction');dest.mkdir(exist_ok=False)
    for name in producer.MODULES+['KeygenLevelsAudit']:
        p=dest/'formal/Source3'/(name+'.lean');p.parent.mkdir(parents=True,exist_ok=True)
        shutil.copyfile(path('formal/Source3/'+name+'.lean'),p)
    original=producer.ROOT;printed=StringIO()
    try:
        producer.ROOT=dest
        with redirect_stdout(printed):producer.main()
    finally:
        producer.ROOT=original
    reproduced=dest/'formal/Source3'/(AUDIT+'.lean');source=path('formal/Source3/'+AUDIT+'.lean')
    assert reproduced.read_bytes()==source.read_bytes()
    print(json.dumps(write_receipt('.build/levels_068/GENERATOR_CHECK.json',{
      'status':'BYTE_EXACT_PRODUCER_REPRODUCTION','source':pin(source),'reproduced':pin(reproduced),'output':printed.getvalue()})))


def seal():
    assert not path(BASE+'.json').exists(), 'Never overwrite a sealed pair'
    entry=checked_inputs();preseal=read('.build/levels_068/PRESEAL.json')
    assert preseal['checked']==entry['checked'] and preseal['verifier_sha256']==job.sha(Path(__file__))
    generated=read('.build/levels_068/GENERATOR_CHECK.json')
    assert generated['status']=='BYTE_EXACT_PRODUCER_REPRODUCTION'
    assert job.sha(path(generated['source']['path']))==generated['source']['sha256']
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
            if imported in cache:assert cache[imported]['artifact_sha256']==expected, (module,imported)
        modules.append({'module':module,'source':pin(source),'snapshot':pin(snapshot),'artifact':pin(artifact),
          'cache_artifact':pin(current['artifact']),'receipt':pin(current['receipt']),
          'source_inputs':pin(directory/'SOURCE_INPUTS.json'),'logs':streams(directory,record,True),
          'maxrss_kib':record['cumulative_child_maxrss_kib'],'elapsed_s':record['elapsed_s']})
    audit_dir=path(cache['Source3.'+AUDIT]['receipt']).parent;audit=read(audit_dir/'SEARCH_AUDIT.json')
    expected=set(producer.declarations())|{'FT1536.Source3.'+n for n in producer.INHERITED}
    assert len(audit)==len(expected)==86 and {e['name'] for e in audit}==expected
    assert len((audit_dir/'SEARCH_AUDIT_ENTRIES.jsonl').read_text().splitlines())==len(audit)
    for e in audit:
        assert set(e['axioms'])<={'propext','Classical.choice','Quot.sound'} and '⋯' not in json.dumps(e,ensure_ascii=False), e['name']
        if e['body']['kind']=='definition_or_theorem':assert e['body']['term']
        else:assert e['body']['kind']=='kernel_inductive' and e['body']['constructors']
    inputs=read(audit_dir/'SOURCE_INPUTS.json')
    for e in inputs['sources']:assert job.sha(path(e['path']))==e['sha256']
    for e in inputs['reused']:
        assert job.sha(path(e.get('current_source',e['source'])))==e['source_sha256']
        assert job.sha(path(e['artifact']))==e['artifact_sha256']
    causes=read('.build/levels_068/CAUSES.json');history=[]
    for directory in sorted((job.BUILD/'jobs').glob('keygen_*_068_*')):
        records=read(directory/'RECEIPTS.json') if (directory/'RECEIPTS.json').exists() else []
        status='ACCEPTED' if records and all(r['accepted'] for r in records) else 'FAILED_RETAINED' if records else 'PRESTEP_ABORT_RETAINED'
        cause=causes.get(directory.name)
        assert status=='ACCEPTED' or cause, ('missing retained cause',directory.name)
        wait=job.BUILD/'waits'/directory.name/'WAIT.jsonl'
        history.append({'job':directory.name,'status':status,'cause':cause,
          'wait':pin(wait) if wait.exists() else None,
          'files':[pin(p) for p in sorted(directory.rglob('*')) if p.is_file() and not p.is_symlink() and
            (p.parent==directory or p.parent==directory/'logs' or p.suffix in {'.lean','.sage'})]})
    tools=['tools/job.py','tools/job_when_available.py','tools/keygen_codec_static_audit.py','tools/keygen_codec_static_batch.py']
    for p in tools+['../../../../../Extra/c/falcon-enc.c','../../../../../Extra/c/falcon-keygen.c']:committed(p,head)
    result={'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_068','stage':'B1.07 / B1.08 source-codec seam',
      'window':'CLOSED_AT_RECOVERABLE_MIDPOINT','single_close':True,'b1_07_acceptance':'NOT_MET',
      'stage_result':'PARTIAL_PROOF','status':'IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN',
      'created_utc':datetime.now(timezone.utc).isoformat(),'harness':'Codex; historical runner identities retained',
      'proof_head':head,'source_reference':[pin('../../../../../Extra/c/'+p) for p in ['falcon-enc.c','falcon-keygen.c','falcon.h']],
      'notes':pin(BASE+'_NOTES.md'),'entry_pins_receipt':pin(ENTRY),'preseal':pin('.build/levels_068/PRESEAL.json'),
      'generator_check':pin('.build/levels_068/GENERATOR_CHECK.json'),'recorded_supersessions':entry.get('recorded_supersessions'),
      'accepted_module_checks':modules,'audit':{**pin(audit_dir/'SEARCH_AUDIT.json'),
        'entries_jsonl':pin(audit_dir/'SEARCH_AUDIT_ENTRIES.jsonl'),'source_inputs':pin(audit_dir/'SOURCE_INPUTS.json'),
        'exports':len(producer.declarations()),'inherited_interfaces':len(producer.INHERITED),
        'full_terms':sum(e['body']['kind']=='definition_or_theorem' for e in audit),
        'kernel_inductives':sum(e['body']['kind']=='kernel_inductive' for e in audit)},
      'new_sage_or_c_runs':0,'finite_controls':'BATCH_066 controls and both retained counterexamples remain pinned; no finite replay substitutes for a theorem.',
      'attempt_details':history,'tools':[pin(p) for p in tools],
      'extra_evidence':[pin('.build/levels_068/'+p) for p in ['TARGET.json','CAUSES.json','SELF_REVIEW.md','ENVIRONMENT_EVENTS.json']],
      'closed_obligations':[
        'j8 derived from the actual full STATIC prologue at q18433 and source-frame preservation through its actual remaining body.',
        'Actual unary guard/countdown, bit RHS and shift/add, preincrement/byte reset; full unary word/pending/low-suffix invariant and terminal ne=-2, with visible local initial cells.',
        'Actual unary store byte content; universal full unary byte and mathematical padding identities for arbitrary old accumulator high bits.'],
      'open_obligations':[
        'Full STATIC coefficient/outer-loop invariant: actual n/mask/u/acc/acc_len initialization, signed input/magnitude/sign/low9/quotient transport, first byte drain, byte histories/cursors and final source padding.',
        'Source STATIC encoded/consumed lengths and complete decoder segment++tail proofs, four segments/final store and coefficient-WORD transport; no desired result/length/frame premises.',
        'B1.09 public codec last, canonical15-bit packing/same h/actual2881 and supplied-length decoder behavior.',
        'Inherited common call ID/snapshots, all-state LegalWorkspace refutation status and full B1.07/B1.10.'],
      'active_jobs_at_close':[],'push':False,'review':False,'delegation':False,
      'limits':'Unchanged j1/-M6144,AS12GiB/RSS8GiB/wall1800s/maxHeartbeats2000000; accepted Lean logs0/0.'}
    assert not job.active()
    with path(BASE+'.json').open('x') as stream:json.dump(result,stream,indent=2);stream.write('\n')
    print(json.dumps({'batch':pin(BASE+'.json'),'notes':pin(BASE+'_NOTES.md'),'audit_entries':len(audit)}))


def verify(batch_sha,notes_sha,target):
    entry=checked_inputs();checked=dict(entry['checked'])
    def check(p,expected):
        p=path(p);actual=job.sha(p);assert actual==expected, (str(p),expected,actual)
        if str(p) in checked:assert checked[str(p)]==expected
        checked[str(p)]=actual
    def walk(v):
        if isinstance(v,dict):
            if 'path' in v and 'sha256' in v:check(v['path'],v['sha256'])
            for child in v.values():walk(child)
        elif isinstance(v,list):
            for child in v:walk(child)
    check(BASE+'.json',batch_sha);check(BASE+'_NOTES.md',notes_sha);batch=read(BASE+'.json');walk(batch)
    assert batch['batch']=='BATCH_068' and batch['active_jobs_at_close']==[]
    inputs=read(batch['audit']['source_inputs']['path'])
    for e in inputs['sources']:check(e['path'],e['sha256'])
    for e in inputs['reused']:
        check(e.get('current_source',e['source']),e['source_sha256']);check(e['artifact'],e['artifact_sha256'])
    assert not job.active()
    result={'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-068','checked':checked,
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
