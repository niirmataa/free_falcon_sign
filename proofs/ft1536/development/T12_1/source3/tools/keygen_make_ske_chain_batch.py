#!/usr/bin/env python3
"""Immutable tooling supplement sealing BATCH_063; original pair unchanged.
The 062 ceremony is retained: complete audit, reproduction, guarded receipts,
PUBLIC Sage controls, preseal, exact pins and recursive next-entry verify.
"""
from contextlib import redirect_stdout
from datetime import datetime, timezone
from io import StringIO
from pathlib import Path
import json
import shutil
import subprocess
import sys
import job
import keygen_make_ske_chain_audit as producer
from keygen_intermediate_batch import path, read, pin, committed, streams
from keygen_public_first_batch import write_receipt

ORIGINAL='notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_063'
BASE=ORIGINAL+'_TOOLING_001'
ORIGINAL_SHA='7dfeaccf40b1dc49cbedc1630dba076bee8fe6e070f4ada61aac8ef50766ed51'
ORIGINAL_NOTES_SHA='e71f8140c2d33af404309b6b9e26f57b1a57d22329add6e61378265dbe29a2fb'
ENTRY='.build/levels_063/ENTRY_PINS_063.json'
ENTRY_SHA='4403201aac8e9542f6563a90ea7d7b11d8747dacbb1aed9ac0d71fa6238510aa'
AUDIT='KeygenMakeSkeChainAudit'
SAGE='sage/check_keygen_make_ske_chain.sage'
REFERENCE='../../../../../Extra/c/falcon-keygen.c'
PRESEAL='.build/levels_063/TOOLING_PRESEAL.json'
GENERATOR='.build/levels_063/TOOLING_GENERATOR_CHECK.json'

def checked_inputs():
    assert not job.active(),'A proof job is active'
    assert job.sha(path(ENTRY))==ENTRY_SHA
    entry=read(ENTRY)
    assert entry['batch']=='BATCH_015-062' and len(entry['checked'])==12249
    assert entry['current_source_inputs']==147 and entry['active_jobs']==[]
    checked={}
    def check(p,expected):
        p=path(p);actual=job.sha(p);assert actual==expected,(str(p),expected,actual)
        if str(p) in checked: assert checked[str(p)]==expected
        checked[str(p)]=actual
    def walk(value):
        if isinstance(value,dict):
            if 'path' in value and 'sha256' in value: check(value['path'],value['sha256'])
            for child in value.values(): walk(child)
        elif isinstance(value,list):
            for child in value: walk(child)
    for p,expected in entry['checked'].items(): check(p,expected)
    check(ORIGINAL+'.json',ORIGINAL_SHA);check(ORIGINAL+'_NOTES.md',ORIGINAL_NOTES_SHA)
    original=read(ORIGINAL+'.json')
    historical=subprocess.check_output(['git','show','2d6735bc:'+str((job.ROOT/'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_063_NOTES.md').relative_to(job.REPO))],cwd=job.REPO)
    import hashlib
    assert hashlib.sha256(historical).hexdigest()==original['notes']['sha256']=='2c06bc865cc145f62334ce0f06c219b488ffebc66957f19b00a1576cea38b3a2'
    assert len(historical)==original['notes']['bytes']==8212
    at_annotation=subprocess.check_output(['git','show','835dfc6b:'+str((job.ROOT/'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_063_NOTES.md').relative_to(job.REPO))],cwd=job.REPO)
    assert hashlib.sha256(at_annotation).hexdigest()==ORIGINAL_NOTES_SHA
    original_for_walk={**original,'notes':pin(ORIGINAL+'_NOTES.md')}
    assert original['batch']=='BATCH_063' and original['active_jobs_at_close']==[]
    walk(original_for_walk);check(ORIGINAL+'.json',job.sha(path(ORIGINAL+'.json')))
    return entry,original,checked,check,walk

def predecessor(target):
    entry,_,checked,_,_=checked_inputs()
    result={'utc':datetime.now(timezone.utc).isoformat(),'checked':checked,
        'entry':pin(ENTRY),'recorded_supersessions':entry.get('recorded_supersessions'),
        'verifier_sha256':job.sha(Path(__file__)),'active_jobs':[]}
    print(json.dumps(write_receipt(target,result)))

def generator():
    dest=path('.build/levels_063/tooling_audit_generator');dest.mkdir(parents=True,exist_ok=False)
    for name in producer.MODULES+['KeygenLevelsAudit']:
        p=dest/'formal/Source3'/(name+'.lean');p.parent.mkdir(parents=True,exist_ok=True)
        shutil.copyfile(path('formal/Source3/'+name+'.lean'),p)
    original=producer.ROOT;printed=StringIO()
    try:
        producer.ROOT=dest
        with redirect_stdout(printed): producer.main()
    finally: producer.ROOT=original
    source=path('formal/Source3/'+AUDIT+'.lean');target=dest/'formal/Source3'/(AUDIT+'.lean')
    assert source.read_bytes()==target.read_bytes()
    print(json.dumps(write_receipt(GENERATOR,{'status':'BYTE_EXACT_AUDIT_PRODUCER_REPRODUCTION',
        'source':pin(source),'reproduced':pin(target),'generator_output':printed.getvalue()})))

def seal():
    assert not path(BASE+'.json').exists(),'Never overwrite a sealed artifact'
    entry,original,checked,_,_=checked_inputs()
    preseal=read(PRESEAL)
    assert preseal['checked']==checked and preseal['verifier_sha256']==job.sha(Path(__file__))
    generated=read(GENERATOR);assert generated['status']=='BYTE_EXACT_AUDIT_PRODUCER_REPRODUCTION'
    assert job.sha(path(generated['source']['path']))==generated['source']['sha256']
    head=subprocess.check_output(['git','rev-parse','HEAD'],cwd=job.REPO,text=True).strip()
    assert subprocess.check_output(['git','branch','--show-current'],cwd=job.REPO,text=True).strip()=='main'
    cache=read('.build/cache/CACHE_INDEX.json');modules=[]
    for name in producer.MODULES+[AUDIT]:
        current=cache['Source3.'+name];source=path(current['source']);committed(source,head)
        directory=path(current['receipt']).parent
        record=next(r for r in read(current['receipt']) if r['name']=='Source3_'+name)
        assert record['accepted'] and record['clean_log'] and record['exit_code']==0
        assert record['forbidden_proof_markers']==[] and record['cumulative_child_maxrss_kib']<=8*1024*1024
        snapshot=directory/'formal/Source3'/(name+'.lean');artifact=directory/'lib/Source3'/(name+'.olean')
        assert job.sha(source)==job.sha(snapshot)==record['source_sha256']==current['source_sha256']
        assert job.sha(artifact)==job.sha(path(current['artifact']))==record['olean_sha256']==current['artifact_sha256']
        modules.append({'module':'Source3.'+name,'source':pin(source),'snapshot':pin(snapshot),
            'artifact':pin(artifact),'cache_artifact':pin(current['artifact']),
            'receipt':pin(current['receipt']),'source_inputs':pin(directory/'SOURCE_INPUTS.json'),
            'logs':streams(directory,record,True)})
    audit_dir=path(cache['Source3.'+AUDIT]['receipt']).parent
    audit=read(audit_dir/'SEARCH_AUDIT.json');expected=set(producer.declarations())|{'FT1536.Source3.'+n for n in producer.INHERITED}
    assert len(audit)==len(expected) and {e['name'] for e in audit}==expected
    assert len((audit_dir/'SEARCH_AUDIT_ENTRIES.jsonl').read_text().splitlines())==len(audit)
    for e in audit:
        assert set(e['axioms'])<={'propext','Classical.choice','Quot.sound'} and '⋯' not in json.dumps(e,ensure_ascii=False)
        if e['body']['kind']=='definition_or_theorem': assert e['body']['term']
        else: assert e['body']['kind']=='kernel_inductive' and e['body']['constructors']
    sage_dir=job.BUILD/'jobs/keygen_make_ske_chain_sage_063_009'
    controls=read(sage_dir/'SKE_CHAIN_CHECK.json');rec=read(sage_dir/'RECEIPTS.json')[0]
    assert rec['accepted'] and rec['clean_log'] and rec['exit_code']==0
    assert job.sha(path(SAGE))==job.sha(sage_dir/SAGE)==rec['source_sha256']
    assert controls['status']=='PASS_SCRIPTED_SKE_CHAIN_CONTROLS' and controls['baseline_pass'] and controls['mutations_all_detected']
    history=[]
    for directory in sorted((job.BUILD/'jobs').glob('keygen_make_ske_chain*_063_*')):
        records=read(directory/'RECEIPTS.json') if (directory/'RECEIPTS.json').exists() else []
        history.append({'job':directory.name,'status':'ACCEPTED' if records and all(r['accepted'] for r in records) else 'FAILED_RETAINED',
            'cause':'Outer sandbox denied bwrap NETLINK_ROUTE before Lean; retried unchanged as 007.' if directory.name.endswith('audit_063_006') else
                'Sage exact Integer was not converted to JSON int in mutation_kinds; output serialization failed, retained snapshot and partial result.' if directory.name.endswith('sage_063_008') else
                next((x.get('cause') for x in original['attempt_details'] if x['job']==directory.name),None),
            'files':[pin(p) for p in sorted(directory.rglob('*')) if p.is_file() and not p.is_symlink() and
                (p.parent==directory or p.parent==directory/'logs' or p.suffix=='.lean')]})
    tools=['tools/job.py','tools/job_when_available.py','tools/keygen_make_ske_chain_audit.py',
        'tools/keygen_make_ske_chain_batch.py',SAGE,'formal/Source3/KeygenLevelsAudit.lean']
    for p in tools+[REFERENCE]: committed(p,head)
    result={'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_063_TOOLING_001','stage':'B1.07',
        'status':'PARTIAL_PROOF / NOT_REVIEWED / WORKING_NOT_FROZEN','window':'TOOLING_CONTINUATION_NO_NEW_CLOSE',
        'proof_head':head,'created_utc':datetime.now(timezone.utc).isoformat(),
        'harness':'Codex; runner historical identity labels retained as provenance',
        'original_pair':[pin(ORIGINAL+'.json'),pin(ORIGINAL+'_NOTES.md')],
        'owner_authorized_notes_supersession':{'old_sha256':original['notes']['sha256'],'new_sha256':ORIGINAL_NOTES_SHA,'old_bytes':8212,'new_bytes':8330,'historical_git_commit':'2d6735bc2e7e2f52d44c7a4bfd2268b0682b7b3e','annotation_git_commit':'835dfc6bd7bbb7b5f43006a65ea3973d94030d39','owner_authorization':'Zatwierdzam korektę w suplemencie i kontynuację','scope':'Only the original JSON.notes path pin; both original files preserved; strict checks elsewhere'},
        'notes':pin(BASE+'_NOTES.md'),'entry_pins_receipt':pin(ENTRY),'preseal':pin(PRESEAL),
        'generator_check':pin(GENERATOR),'recorded_supersessions':entry.get('recorded_supersessions'),
        'accepted_module_checks':modules,
        'audit':{**pin(audit_dir/'SEARCH_AUDIT.json'),'entries_jsonl':pin(audit_dir/'SEARCH_AUDIT_ENTRIES.jsonl'),
            'source_inputs':pin(audit_dir/'SOURCE_INPUTS.json'),'exports':len(producer.declarations()),
            'inherited_interfaces':len(producer.INHERITED)},
        'sage':{'result':pin(sage_dir/'SKE_CHAIN_CHECK.json'),'receipt':pin(sage_dir/'RECEIPTS.json')},
        'attempt_details':history,'reference':pin(REFERENCE),'tools':[pin(p) for p in tools],
        'active_jobs_at_close':[],'push':False,'review':False,
        'limits':'Unchanged j1/-M6144, AS12GiB/RSS8GiB/wall1800s; native Sage; zero diagnostic streams for accepted Lean jobs.'}
    with path(BASE+'.json').open('x') as stream: json.dump(result,stream,indent=2);stream.write('\n')
    print(json.dumps({'batch':pin(BASE+'.json'),'notes':pin(BASE+'_NOTES.md'),'audit_entries':len(audit)}))

def verify(batch_sha,notes_sha,target):
    entry,_,checked,check,walk=checked_inputs()
    check(BASE+'.json',batch_sha);check(BASE+'_NOTES.md',notes_sha)
    batch=read(BASE+'.json');walk(batch)
    assert batch['batch']=='BATCH_063_TOOLING_001' and batch['active_jobs_at_close']==[]
    inputs=read(batch['audit']['source_inputs']['path'])
    for e in inputs['sources']: check(e['path'],e['sha256'])
    for e in inputs['reused']:
        check(e.get('current_source',e['source']),e['source_sha256']);check(e['artifact'],e['artifact_sha256'])
    result={'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-063',
        'checked':checked,'distinct_pinned_files':len(checked),
        'current_source_inputs':batch['audit']['exports']+batch['audit']['inherited_interfaces'],
        'active_jobs':[],'superseded':{},'recorded_supersessions':entry.get('recorded_supersessions'),
        'verifier_sha256':job.sha(Path(__file__))}
    assert not job.active()
    print(json.dumps({'receipt':write_receipt(target,result),'distinct_pinned_files':len(checked)}))

if __name__=='__main__':
    command=sys.argv[1]
    if command=='generator': generator()
    elif command=='predecessor': predecessor(sys.argv[2])
    elif command=='seal': seal()
    else:
        assert command=='verify' and len(sys.argv)==5
        verify(*sys.argv[2:])
