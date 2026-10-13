#!/usr/bin/env python3
"""Seal/verify071 without rewriting any predecessor or failed attempt."""
from datetime import datetime, timezone
from pathlib import Path
from contextlib import redirect_stdout
from io import StringIO
import json, shutil, subprocess, sys
import job
import keygen_codec_complete_audit as producer
from keygen_intermediate_batch import path, read, pin, committed, streams
from keygen_public_first_batch import write_receipt

BASE='notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_071'
ENTRY='.build/levels_071/ENTRY_PINS_071.json'
ENTRY_SHA='4dbcedebc9813348f5d724170bf11b99371495d271e0dc03c22a9ba445a42ce2'
AUDIT='KeygenCodecCompleteAudit'


def checked_inputs():
    assert not job.active(), 'A proof job is active'
    assert job.sha(path(ENTRY))==ENTRY_SHA
    entry=read(ENTRY)
    assert entry['batch']=='BATCH_015-070'
    assert len(entry['checked'])==entry['distinct_pinned_files']==15178
    assert entry['active_jobs']==[]
    for p,expected in entry['checked'].items():
        assert job.sha(path(p))==expected, ('predecessor changed',p)
    return entry


def predecessor(target):
    entry=checked_inputs()
    print(json.dumps(write_receipt(target, {'checked':entry['checked'],'entry':pin(ENTRY),
      'verifier_sha256':job.sha(Path(__file__)),'recorded_supersessions':entry.get('recorded_supersessions'),'active_jobs':[]})))


def generator():
    dest=path('.build/levels_071/audit_reproduction');dest.mkdir(exist_ok=False)
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
    print(json.dumps(write_receipt('.build/levels_071/GENERATOR_CHECK.json',{
      'status':'BYTE_EXACT_PRODUCER_REPRODUCTION','source':pin(source),'reproduced':pin(reproduced),'output':printed.getvalue()})))


def seal():
    assert not path(BASE+'.json').exists(), 'Never overwrite a sealed pair'
    entry=checked_inputs();preseal=read('.build/levels_071/PRESEAL.json')
    assert preseal['checked']==entry['checked'] and preseal['verifier_sha256']==job.sha(Path(__file__))
    generated=read('.build/levels_071/GENERATOR_CHECK.json')
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
    assert len(audit)==len(expected)==len(producer.declarations())+len(producer.INHERITED) and {e['name'] for e in audit}==expected
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
    causes=read('.build/levels_071/CAUSES.json');history=[]
    for directory in sorted((job.BUILD/'jobs').glob('keygen_*_071_*')):
        records=read(directory/'RECEIPTS.json') if (directory/'RECEIPTS.json').exists() else []
        status='ACCEPTED' if records and all(r['accepted'] for r in records) else 'FAILED_RETAINED' if records else 'PRESTEP_ABORT_RETAINED'
        cause=causes.get(directory.name)
        assert status=='ACCEPTED' or cause, ('missing retained cause',directory.name)
        wait=job.BUILD/'waits'/directory.name/'WAIT.jsonl'
        history.append({'job':directory.name,'status':status,'cause':cause,
          'wait':pin(wait) if wait.exists() else None,
          'files':[pin(p) for p in sorted(directory.rglob('*')) if p.is_file() and not p.is_symlink() and
            (p.parent==directory or p.parent==directory/'logs' or p.suffix in {'.lean','.sage','.olean'})]})
    tools=['tools/job.py','tools/job_when_available.py','tools/keygen_codec_complete_audit.py','tools/keygen_codec_complete_batch.py']
    for p in tools+['../../../../../Extra/c/falcon-enc.c','../../../../../Extra/c/falcon-keygen.c']:committed(p,head)
    result={'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_071','stage':'B1.07 / B1.08 source-codec seam',
      'window':'CLOSED_AT_RECOVERABLE_MIDPOINT','single_close':True,'b1_07_acceptance':'NOT_MET',
      'stage_result':'PARTIAL_PROOF','status':'IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN',
      'created_utc':datetime.now(timezone.utc).isoformat(),'harness':'Codex; historical runner identities retained',
      'proof_head':head,'source_reference':[pin('../../../../../Extra/c/'+p) for p in ['falcon-enc.c','falcon-keygen.c','falcon.h']],
      'notes':pin(BASE+'_NOTES.md'),'entry_pins_receipt':pin(ENTRY),'preseal':pin('.build/levels_071/PRESEAL.json'),
      'generator_check':pin('.build/levels_071/GENERATOR_CHECK.json'),'recorded_supersessions':entry.get('recorded_supersessions'),
      'accepted_module_checks':modules,'audit':{**pin(audit_dir/'SEARCH_AUDIT.json'),
        'entries_jsonl':pin(audit_dir/'SEARCH_AUDIT_ENTRIES.jsonl'),'source_inputs':pin(audit_dir/'SOURCE_INPUTS.json'),
        'exports':len(producer.declarations()),'inherited_interfaces':len(producer.INHERITED),
        'full_terms':sum(e['body']['kind']=='definition_or_theorem' for e in audit),
        'kernel_inductives':sum(e['body']['kind']=='kernel_inductive' for e in audit)},
      'new_sage_or_c_runs':0,'finite_controls':'BATCH_066 controls and both retained counterexamples remain pinned; no finite replay substitutes for a theorem.',
      'attempt_details':history,'tools':[pin(p) for p in tools],
      'extra_evidence':[pin('.build/levels_071/'+p) for p in ['TARGET.json','CAUSES.json','SELF_REVIEW.md','ENVIRONMENT_EVENTS.json','COMPUTATION_MANIFEST.json','MANIFEST_VALIDATION.txt']],
      'full_static':'PROVED_KERNEL_SCOPED_PHYSICAL_INPUT / NOT_REVIEWED',
      'closed_obligations':['Same-read coefficient witness simultaneously supplies expected bytes, cursor progress, normal pending/word state and actual input-pointer progression on all flows.', 'Conservative int16 coefficient budget131, derived full all-flow outer history and source cursor no-wrap from1536 iterations; no desired encoded length or whole-accumulator bound.', 'One actual full prologue state derives Ready, reserved scalar absence, capacity, buffer, u0/acc0/pending0/n1536/j8/mask255 and original input pointer.', 'Full original physical int16 input list supplies the outer bytes and normal state fold; actual stores preserve future input words under memory-entry separation, including capacity-return prefixes.', 'Full STATIC code and dispatcher derive complete expected stream with independent final padding, actual successful return or strict-prefix capacity return0; observed flow unrestricted.', 'Actual chronological four-call caller chain preserves all four original physical arrays through earlier codec writes. Profiles/pointer identity come from inherited source chain; buffer separation follows actual allocation freshness and live external destination.'],
      'open_obligations':['Full B1.07 Acceptance and package NOT MET/NOT_REVIEWED. New full STATIC is scoped to bound finite defined reference executions, original allocated physical int16 arrays and separation. It is not compiler/ISO-C correctness or full KeyGen/Sign/security.', 'Next in fixed order: exact encoded/consumed lengths, complete decoders/segment++tail, four independent paddings, final length store and same coefficient-WORD transport from original mathematical vectors. No such exact-length/decoder theorem was advanced in071.', 'Public codec LAST: same h/canonical15-bit packing/2881 and actual supplied-length decoder behavior. Inherited call IDs/snapshots and all-state LegalWorkspace refutation status remain. B1.10 and B4/B5 laws/availability/PRG/security remain outside.'],
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
    assert batch['batch']=='BATCH_071' and batch['active_jobs_at_close']==[]
    inputs=read(batch['audit']['source_inputs']['path'])
    for e in inputs['sources']:check(e['path'],e['sha256'])
    for e in inputs['reused']:
        check(e.get('current_source',e['source']),e['source_sha256']);check(e['artifact'],e['artifact_sha256'])
    assert not job.active()
    result={'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-071','checked':checked,
      'distinct_pinned_files':len(checked),'current_source_inputs':len(inputs['sources'])+len(inputs['reused']),
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
