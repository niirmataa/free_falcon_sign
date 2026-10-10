#!/usr/bin/env python3
"""Seal/verify050's pre-certificate search midpoint, preserving015--049."""
from contextlib import redirect_stdout
from datetime import datetime, timezone
from io import StringIO
from pathlib import Path
import json
import shutil
import subprocess
import sys

import job
import keygen_make_search_audit as producer
from keygen_intermediate_batch import path, read, pin, committed, streams
from keygen_public_first_batch import write_receipt

BASE='notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_050'
ENTRY='.build/levels_050/ENTRY_PINS_050.json'
ENTRY_SHA='667972dc8ecd9030625c0a7bbb09a8299e1a72e38ea63df9359369bf0dcb6587'
CONTROL='.build/jobs/keygen_make_search_controls_050_003'
SAGE='sage/check_keygen_make_search.sage'
CAUSES={
    'keygen_make_entry_050_001':'Wrong Header/Object field names and nested elimination indentation; rejected before any accepted product.',
    'keygen_make_entry_050_002':'Broad argument-proof meta reduction exceeded memory. Fixed constructor elimination and explicit scalar conversion close the same type; limits unchanged.',
    'keygen_make_entry_050_003':'The converted cell needs an explicitly typed Ty.int32 rather than an ambiguous dotted constructor.',
    'keygen_make_entry_050_004':'Arguments accepted; LocalFrame rejected n!=dst tokenization, unavailable contains lemma and reserved prefix name. Compiler-generated rejected declaration diagnostics are retained; no accepted incomplete term.',
    'keygen_make_search_prefix_050_001':'The prepared declaration frame needs the explicit C99ValueBridge.type reduction.',
    'keygen_make_search_trace_050_001':'A tactic-block comma associated the tuple incorrectly; use an explicit abort implication proof.',
    'keygen_make_search_material_050_001':'The closed Result.flow must be reduced before matching the raw continue edge.',
    'keygen_make_public_call_050_001':'Induction varies the signed context and indexed Address elimination removes fixed name/index binders; infer the actual context and use seven remaining binders.',
    'keygen_make_search_controls_050_001':'GCC -Werror rejected storing an automatic scratch address in a global diagnostic slot. The public fixture now has static scratch lifetime; no warning is suppressed.'}

def entry_checked():
    assert not job.active(),'A proof job is active'
    assert job.sha(path(ENTRY))==ENTRY_SHA
    entry=read(ENTRY)
    assert entry['batch']=='BATCH_015-049'
    assert entry['distinct_pinned_files']==len(entry['checked'])==10483
    assert entry['current_source_inputs']==739 and entry['active_jobs']==[] and entry['superseded']=={}
    for p,expected in entry['checked'].items(): assert job.sha(path(p))==expected,('predecessor changed',p)
    return entry

def predecessor(target):
    entry=entry_checked()
    result={'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-049','checked':entry['checked'],
        'distinct_pinned_files':10483,'entry':pin(ENTRY),'active_jobs':[],'superseded':{},
        'verifier_sha256':job.sha(Path(__file__))}
    print(json.dumps({'predecessor_files':10483,'receipt':write_receipt(target,result)},indent=2))

def generator_check():
    dest=path('.build/levels_050/audit_generator')
    dest.mkdir(parents=True,exist_ok=False)
    names=producer.MODULES+['KeygenLevelsAudit']
    pins=[]
    for name in names:
        source=job.ROOT/'formal/Source3'/(name+'.lean');target=dest/'formal/Source3'/(name+'.lean')
        target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(source,target)
        assert job.sha(source)==job.sha(target)
        pins.extend([pin(source),pin(target)])
    original=producer.ROOT;printed=StringIO()
    try:
        producer.ROOT=dest
        with redirect_stdout(printed): producer.main()
    finally: producer.ROOT=original
    target=dest/'formal/Source3/KeygenMakeSearchAudit.lean'
    source=path('formal/Source3/KeygenMakeSearchAudit.lean')
    assert source.read_bytes()==target.read_bytes()
    result={'utc':datetime.now(timezone.utc).isoformat(),'status':'BYTE_EXACT_AUDIT_PRODUCER_REPRODUCTION',
        'producer':pin('tools/keygen_make_search_audit.py'),'input_copies':pins,
        'source':pin(source),'reproduced':pin(target),'generator_output':printed.getvalue()}
    print(json.dumps(write_receipt('.build/levels_050/GENERATOR_CHECK.json',result),indent=2))

def seal():
    assert not path(BASE+'.json').exists(),'Never replace a historical pair'
    entry=entry_checked()
    head=subprocess.check_output(['git','rev-parse','HEAD'],cwd=job.REPO,text=True).strip()
    assert subprocess.check_output(['git','branch','--show-current'],cwd=job.REPO,text=True).strip()=='main'
    preseal=read('.build/levels_050/PRESEAL.json')
    assert preseal['checked']==entry['checked'] and preseal['verifier_sha256']==job.sha(Path(__file__))
    generated=read('.build/levels_050/GENERATOR_CHECK.json')
    assert generated['status']=='BYTE_EXACT_AUDIT_PRODUCER_REPRODUCTION'
    for item in generated['input_copies']+[generated['producer'],generated['source'],generated['reproduced']]:
        assert job.sha(path(item['path']))==item['sha256'],item['path']
    cache=read('.build/cache/CACHE_INDEX.json');modules=[]
    for name in producer.MODULES+['KeygenMakeSearchAudit']:
        module='Source3.'+name;current=cache[module];source=path(current['source']);directory=path(current['receipt']).parent
        committed(source,head)
        record=next(r for r in read(current['receipt']) if r['name']==module.replace('.','_'))
        assert record['accepted'] and record['clean_log'] and record['exit_code']==0
        assert record['forbidden_proof_markers']==[] and record['cumulative_child_maxrss_kib']<=8*1024*1024
        snapshot=directory/'formal/Source3'/(name+'.lean');artifact=directory/'lib/Source3'/(name+'.olean')
        assert job.sha(source)==job.sha(snapshot)==record['source_sha256']==current['source_sha256']
        assert job.sha(artifact)==job.sha(path(current['artifact']))==record['olean_sha256']==current['artifact_sha256']
        for imported,expected in current.get('imports',{}).items():
            if imported in cache: assert cache[imported]['artifact_sha256']==expected,(module,imported)
        modules.append({'module':module,'source':pin(source),'snapshot':pin(snapshot),'artifact':pin(artifact),
            'cache_artifact':pin(current['artifact']),'receipt':pin(current['receipt']),
            'source_inputs':pin(directory/'SOURCE_INPUTS.json'),'logs':streams(directory,record,True),
            'imports':current.get('imports',{}),'elapsed_s':record['elapsed_s'],'maxrss_kib':record['cumulative_child_maxrss_kib']})
    audit_dir=path(cache['Source3.KeygenMakeSearchAudit']['receipt']).parent;audit=read(audit_dir/'SEARCH_AUDIT.json')
    assert len(audit)==len({e['name'] for e in audit})==len(producer.declarations())+len(producer.INHERITED)==117
    assert {e['name'] for e in audit}==set(producer.declarations())|{'FT1536.Source3.'+n for n in producer.INHERITED}
    assert (audit_dir/'SEARCH_AUDIT_ENTRIES.jsonl').read_text().count('\n')==len(audit)
    for e in audit:
        assert set(e['axioms'])<={'propext','Classical.choice','Quot.sound'},e['name']
        assert '⋯' not in json.dumps(e,ensure_ascii=False),e['name']
        if e['body']['kind']=='definition_or_theorem': assert e['body']['term'],e['name']
        else: assert e['body']['kind']=='kernel_inductive' and e['body']['constructors'],e['name']
    inputs=read(audit_dir/'SOURCE_INPUTS.json')
    for e in inputs['sources']: assert job.sha(path(e['path']))==e['sha256'],e['path']
    for e in inputs['reused']:
        assert job.sha(path(e.get('current_source',e['source'])))==e['source_sha256'],e['module']
        assert job.sha(path(e['artifact']))==e['artifact_sha256'],e['module']
    controls=read(path(CONTROL)/'SEARCH_CONTROL_CHECK.json');record=read(path(CONTROL)/'RECEIPTS.json')[0]
    assert record['accepted'] and record['clean_log'] and record['exit_code']==0
    committed(SAGE,head)
    assert job.sha(path(SAGE))==job.sha(path(CONTROL)/SAGE)==record['source_sha256']
    assert controls['status']=='PASS_SCRIPTED_SEARCH_CONTROLS' and controls['runs']==14 and controls['cases_per_run']==17
    assert controls['mutations_per_mode']==6
    assert job.sha(path(CONTROL)/'SEARCH_PUBLIC_FIXTURE.json')==controls['fixture_sha256']
    assert job.sha(path('sage/check_keygen_make_control.sage'))==controls['reused_mock_source_sha256']
    assert job.sha(job.OLD/'inputs/source/PROFILE.json')==controls['profile_sha256']
    artifacts=[]
    for variant in controls['variants']:
        assert len(variant['results'])==17 and bool(variant['differences'])==(variant['variant']!='baseline')
        for p,expected in variant['artifacts'].items():
            assert job.sha(path(CONTROL)/p)==expected,p;artifacts.append(pin(path(CONTROL)/p))
    source_pins=[]
    for name,expected in controls['source_pins'].items():
        p=job.REPO/'Extra/c'/name;assert job.sha(p)==expected,p;source_pins.append(pin(p))
    history=[]
    directories=sorted((job.BUILD/'jobs').glob('keygen_make_*_050_*'),key=lambda d: read(d/'RECEIPTS.json')[0]['start'])
    for directory in directories:
        inventory=read(directory/'SOURCE_INPUTS.json');snapshots=[]
        for e in inventory['sources']:
            rel='formal/'+e['module'].replace('.','/')+'.lean' if 'module' in e else 'sage/'+Path(e['path']).name
            p=directory/rel;assert job.sha(p)==e['sha256'],p;snapshots.append(pin(p))
        records=read(directory/'RECEIPTS.json')
        status='FAILED_RETAINED' if any(not r['accepted'] for r in records) else 'ACCEPTED'
        assert (directory.name in CAUSES)==(status!='ACCEPTED'),directory.name
        history.append({'job':directory.name,'status':status,'cause':CAUSES.get(directory.name),
            'receipt':pin(directory/'RECEIPTS.json'),'wait_log':pin(job.BUILD/'waits'/directory.name/'WAIT.jsonl'),
            'source_inputs':pin(directory/'SOURCE_INPUTS.json'),'preflight':pin(directory/'PREFLIGHT.json'),
            'runner_snapshot':pin(directory/'RUNNER_SOURCE.py'),'execution_snapshot':pin(directory/'EXECUTION_SOURCE.py'),
            'snapshots':snapshots,'raw_files':[pin(p) for p in sorted((directory/'logs').iterdir()) if p.is_file()],
            'steps':[{'name':r['name'],'accepted':r['accepted'],'exit_code':r['exit_code'],'start':r['start'],'stop':r['stop'],
                'elapsed_s':r['elapsed_s'],'maxrss_kib':r['cumulative_child_maxrss_kib'],'logs':streams(directory,r)} for r in records],
            'accepted_products':[pin(p) for p in sorted((directory/'lib').rglob('*.olean')) if not p.is_symlink()],
            'products':[pin(p) for p in sorted(directory.iterdir()) if p.is_file() and p.name not in
                {'RECEIPTS.json','SOURCE_INPUTS.json','PREFLIGHT.json','RUNNER_SOURCE.py','EXECUTION_SOURCE.py'}]})
    assert {h['job'] for h in history if h['status']=='FAILED_RETAINED'}==set(CAUSES)
    assert len(history)==17 and sum(len(h['steps']) for h in history)==18
    tools=['tools/job.py','tools/job_when_available.py','tools/keygen_make_search_audit.py','tools/keygen_make_search_batch.py',
        'tools/keygen_intermediate_batch.py','tools/keygen_public_first_batch.py','formal/Source3/KeygenLevelsAudit.lean']
    for p in tools: committed(p,head)
    notes=path(BASE+'_NOTES.md');assert notes.exists()
    result={'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_050','stage':'B1.07',
        'window':'CLOSED_AT_RECOVERABLE_MIDPOINT','b1_07_acceptance':'NOT_MET','stage_result':'PARTIAL_PROOF',
        'status':'IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN','created_utc':datetime.now(timezone.utc).isoformat(),
        'harness':'GPT-6.1 Sol Fast / openai/gpt-6.1-sol-fast','runner_labels':'Historical labels remain provenance.',
        'proof_head':head,'notes':pin(notes),'entry_pins_receipt':pin(ENTRY),'predecessor_files':10483,
        'preseal_predecessor_receipt':pin('.build/levels_050/PRESEAL.json'),'superseded':{},'accepted_module_checks':modules,
        'current_final_audit_inputs':len(inputs['sources'])+len(inputs['reused']),
        'audit':{**pin(audit_dir/'SEARCH_AUDIT.json'),'entries_jsonl':pin(audit_dir/'SEARCH_AUDIT_ENTRIES.jsonl'),
            'receipt':pin(audit_dir/'RECEIPTS.json'),'source_inputs':pin(audit_dir/'SOURCE_INPUTS.json'),
            'producer':pin('formal/Source3/KeygenMakeSearchAudit.lean'),'generator':pin('tools/keygen_make_search_audit.py'),
            'exports':len(audit),'new_declarations':len(producer.declarations()),'inherited_interfaces':len(producer.INHERITED),
            'full_terms':sum('term' in e['body'] for e in audit),'kernel_inductives':sum('constructors' in e['body'] for e in audit),
            'elisions':0,'allowed_axioms':['propext','Classical.choice','Quot.sound']},
        'sage':{'source':pin(SAGE),'receipt':pin(path(CONTROL)/'RECEIPTS.json'),
            'source_inputs':pin(path(CONTROL)/'SOURCE_INPUTS.json'),'result':pin(path(CONTROL)/'SEARCH_CONTROL_CHECK.json'),
            'fixture':pin(path(CONTROL)/'SEARCH_PUBLIC_FIXTURE.json'),'profile':pin(job.OLD/'inputs/source/PROFILE.json'),
            'reused_mock_source':pin('sage/check_keygen_make_control.sage'),'source_files':source_pins,'artifacts':artifacts,
            'logs':streams(path(CONTROL),record,True),'runs':14,'cases_per_run':17,'mutations_per_mode':6,'scope':controls['scope']},
        'generator_reproduction':pin('.build/levels_050/GENERATOR_CHECK.json'),'generated_inputs':generated['input_copies'],
        'reproduced_producer':generated['reproduced'],'attempt_details':history,
        'attempt_counts':{s:sum(h['status']==s for h in history) for s in ['ACCEPTED','FAILED_RETAINED']},
        'contracts':{'arguments':'Actual six typed arguments/SAME049 header, no remaining-body oracle.',
            'chronology':'Counter0 from complete048 readiness; actual five-gate sampled prefixes, preceding continues/consecutive numbers/length<=3000000. Exhaustion3000001 is not sampled. Normal STOP is BEFORE the certificate, not accepted/break/whole loop.',
            'material':'Source032 NTRU and retained physical f/g/F/G at first pre-certificate boundary, no dimension rerun. Later instances retain the local Initial obligation.',
            'public':'Source046 consumed at actual Call with derived binding/nonzero->success. Legal arrays, small represented f/g and static live/separation facts remain LOCAL inputs, not final B1.07 premises.',
            'lifetime':'Actual cap-return search prefix plus six-object outer teardown; not every later return or accepted encoding.'},
        'open_in_b1_07':['Complete normal whole invocation/source refinement beyond composed fragments, globals and every later-return scope.',
            'Initial and public legal/static/input identity transport for all retries on the SAME chronological derivation.',
            'Sixth mandatory certificate: derive general scratch/block0 relocation, actual global environment/common call ID/snapshots/bad lifetime; no scratch-block0/certificate-correctness premise.',
            'Certificate rejection retries/final accepted break/no full-body normal fallthrough and final AttemptAccepted/Rejected/LoopSucceeded/successful_loop_last_attempt.',
            'SAME public h preservation through solver/certificate, joint equations/certificate witness and physical accepted f/g/F/G/h at actual encoding-input memory; all later teardown.'],
        'outside_scope':['B1.08–B1.11 codec bodies/emitted-to-fiber/final replay, B4/B5 probability/availability/PRG/security, OS/Windows/compiler/machine refinement, CT and independent review.'],
        'tools':[pin(p) for p in tools],'source_commits':subprocess.check_output(['git','log','--reverse','--format=%H %s',
            'c6c05ec1..'+head,'--',str(job.ROOT.relative_to(job.REPO))],cwd=job.REPO,text=True).splitlines(),
        'origin_main_observed':subprocess.check_output(['git','rev-parse','origin/main'],cwd=job.REPO,text=True).strip(),
        'active_jobs_at_close':[],'push_by_this_worker':False,'review_or_stages_import':False,
        'limits':'Unchanged Lean j1/-M6144,AS12GiB/RSS8GiB,wall1800s,maxHeartbeats2000000,print200000;0/0 streams,Sage preparser. No inherited source or job limits raised.'}
    assert not job.active()
    with path(BASE+'.json').open('x') as stream: json.dump(result,stream,indent=2);stream.write('\n')
    print(json.dumps({'batch':pin(BASE+'.json'),'notes':pin(notes),'audit_entries':len(audit),
        'attempts':len(history),'attempt_counts':result['attempt_counts'],'literal_inputs':result['current_final_audit_inputs']},indent=2))

def verify(batch_sha,notes_sha,target):
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
    check(BASE+'.json',batch_sha);check(BASE+'_NOTES.md',notes_sha)
    batch=read(BASE+'.json');walk(batch)
    assert batch['batch']=='BATCH_050' and batch['superseded']=={} and batch['active_jobs_at_close']==[]
    assert batch['window']=='CLOSED_AT_RECOVERABLE_MIDPOINT' and batch['b1_07_acceptance']=='NOT_MET'
    assert batch['entry_pins_receipt']['sha256']==ENTRY_SHA
    for p,expected in entry_checked()['checked'].items(): check(p,expected)
    inputs=read(batch['audit']['source_inputs']['path'])
    for e in inputs['sources']: check(e['path'],e['sha256'])
    for e in inputs['reused']:
        check(e.get('current_source',e['source']),e['source_sha256']);check(e['artifact'],e['artifact_sha256'])
    assert not job.active()
    result={'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-050','checked':checked,
        'distinct_pinned_files':len(checked),'current_source_inputs':batch['current_final_audit_inputs'],
        'active_jobs':[],'superseded':{},'verifier_sha256':job.sha(Path(__file__))}
    print(json.dumps({**{k:v for k,v in result.items() if k!='checked'},'receipt':write_receipt(target,result)},indent=2))

if __name__=='__main__':
    if sys.argv[1:]==['seal']: seal()
    elif sys.argv[1:]==['generator']: generator_check()
    elif sys.argv[1:2]==['predecessor']:
        assert len(sys.argv)==3;predecessor(sys.argv[2])
    else:
        assert len(sys.argv)==5 and sys.argv[1]=='verify';verify(*sys.argv[2:])
