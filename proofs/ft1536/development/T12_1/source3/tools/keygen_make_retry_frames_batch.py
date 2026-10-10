#!/usr/bin/env python3
"""Seal/verify057's retry-frame midpoint, preserving015--056."""
from contextlib import redirect_stdout
from datetime import datetime, timezone
from io import StringIO
from pathlib import Path
import json
import shutil
import subprocess
import sys

import job
import keygen_make_retry_frames_audit as producer
from keygen_intermediate_batch import path, read, pin, committed, streams
from keygen_public_first_batch import write_receipt

BASE='notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_057'
ENTRY='.build/levels_057/ENTRY_PINS_057.json'
ENTRY_SHA='8b6ae47403ae6d7e549d5eccba6e6d5a27e0feac2cc2e0551212eff20047ac0b'
SAGE='sage/check_keygen_make_retry_frames.sage'
MODULES=['KeygenMakeRetryFrames']
AUDIT_MODULE='KeygenMakeRetryFramesAudit'
PRESEAL='.build/levels_057/PRESEAL.json'
REFERENCE='../../../../../Extra/c/falcon-keygen.c'
CAUSES={
    'keygen_make_retry_frames_057_001':'First elaboration rejected: the small_frame induction reintroduced the names/block/offset binders that were already bound as theorem parameters, the store16 and call_bytes steps had the block-separation orientation reversed, the bind_heap state was pinned to the wrong endpoint, the Condition constructor names were qualified one level too shallow, and the search_profile object-block protection was passed the generic block. Rejected snapshot retained.',
    'keygen_make_retry_frames_057_002':'Second elaboration rejected: the Pointer.add case pattern listed nine binders for the constructor surface used here, the seqNormal/loopNormal transports rewrote the binding in the wrong direction, and the entry heap bridge was missing. Rejected snapshot retained.',
    'keygen_make_retry_frames_057_003':'Third elaboration rejected: the Evaluate case patterns named the determined before-field (not a binder), the ready_caller export was namespaced under the source module, the source_trace Inputs record needed the returned-state rebuild, and the validation-frame scratch separation was reversed. Rejected snapshot retained.',
    'keygen_make_retry_frames_057_004':'Fourth elaboration rejected: the refine with trailing metavariables mis-assigned the Caller table field and the flag binder of the second Evaluate case was again not a binder. Rejected snapshot retained.',
    'keygen_make_retry_frames_057_005':'Fifth elaboration rejected: the passed-guard case named the determined flag binder and the callerOut anonymous constructor failed to elaborate under refine; both were rewritten in the pinned style. Rejected snapshot retained.',
    'keygen_make_retry_frames_057_006':'Prestep aborted before elaboration: the diagnostic ProbeEvaluate scratch module had been cached by the previous probe run and its edited source mismatched the cache index, so the runner stopped with a stale-source-cache assertion. The cache entry was removed canonically, the probe source deleted (both probe runs remain retained under their own job directories) and the module then built clean. Rejected prestep retained.',
    'keygen_make_retry_frames_audit_057_001':'Audit generation rejected: two constructor names (Condition.call/negate) were listed as inherited exports and the audit template rejects bodyless declarations. The producer list was corrected to the Condition type. Rejected snapshot retained.',
    'keygen_make_retry_frames_audit_057_002':'Audit generation rejected on the uncorrected producer output after the first edit failed to apply; regenerated from the corrected producer and accepted in run 003. Rejected snapshot retained.',
    'keygen_make_retry_frames_sage_057_001':'Scripted controls FAIL retained: the transcription family indexed a normalized multi-line rejection shape that does not occur verbatim in the reference C. The needle family was rephrased around single-line anchors. Rejected run retained.',
    'keygen_make_retry_frames_sage_057_002':'Scripted controls FAIL retained: four mutation conventions were wrong (the dropped-edge family was vacuous over a shorter edge list, the partial-write baseline wrote a non-destination block, the validated-0 edge was not required by the edge-set check, and the rejection mutation was compared against a whole-file needle that survived elsewhere). All four checks were strengthened. Rejected run retained.',
    'keygen_make_retry_frames_sage_057_003':'Scripted controls FAIL retained: the rejection-drift mutation was still detected through a later return-0 occurrence, so the transcription predicate was scoped to the conversion-rejection window. Rejected run retained.'}

def entry_checked():
    assert not job.active(),'A proof job is active'
    assert job.sha(path(ENTRY))==ENTRY_SHA
    entry=read(ENTRY)
    assert entry['batch']=='BATCH_015-056'
    assert entry['distinct_pinned_files']==len(entry['checked'])==11642
    assert entry['current_source_inputs']==164 and entry['active_jobs']==[] and entry['superseded']=={}
    for p,expected in entry['checked'].items(): assert job.sha(path(p))==expected,('predecessor changed',p)
    return entry

def predecessor(target):
    entry=entry_checked()
    result={'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-056','checked':entry['checked'],
        'distinct_pinned_files':11642,'entry':pin(ENTRY),'active_jobs':[],'superseded':{},
        'verifier_sha256':job.sha(Path(__file__))}
    print(json.dumps({'predecessor_files':11642,'receipt':write_receipt(target,result)},indent=2))

def generator_check():
    dest=path('.build/levels_057/audit_generator')
    dest.mkdir(parents=True,exist_ok=False)
    for name in producer.MODULES+['KeygenLevelsAudit']:
        target=dest/'formal/Source3'/(name+'.lean');target.parent.mkdir(parents=True,exist_ok=True)
        shutil.copyfile(path('formal/Source3/'+name+'.lean'),target)
    original=producer.ROOT;printed=StringIO()
    try:
        producer.ROOT=dest
        with redirect_stdout(printed): producer.main()
    finally: producer.ROOT=original
    target=dest/'formal/Source3/KeygenMakeRetryFramesAudit.lean'
    source=path('formal/Source3/KeygenMakeRetryFramesAudit.lean')
    assert source.read_bytes()==target.read_bytes()
    result={'utc':datetime.now(timezone.utc).isoformat(),'status':'BYTE_EXACT_AUDIT_PRODUCER_REPRODUCTION',
        'producer':pin('tools/keygen_make_retry_frames_audit.py'),'source':pin(source),
        'reproduced':pin(target),'generator_output':printed.getvalue()}
    print(json.dumps(write_receipt('.build/levels_057/GENERATOR_CHECK.json',result),indent=2))

def seal():
    assert not path(BASE+'.json').exists(),'Never replace a historical pair'
    entry=entry_checked()
    head=subprocess.check_output(['git','rev-parse','HEAD'],cwd=job.REPO,text=True).strip()
    assert subprocess.check_output(['git','branch','--show-current'],cwd=job.REPO,text=True).strip()=='main'
    preseal=read(PRESEAL)
    assert preseal['checked']==entry['checked'] and preseal['verifier_sha256']==job.sha(Path(__file__))
    generated=read('.build/levels_057/GENERATOR_CHECK.json')
    assert generated['status']=='BYTE_EXACT_AUDIT_PRODUCER_REPRODUCTION'
    assert job.sha(path(generated['source']['path']))==generated['source']['sha256']
    cache=read('.build/cache/CACHE_INDEX.json');modules=[]
    for name in producer.MODULES+['KeygenLevelsAudit']:
        module='Source3.'+name;current=cache[module];source=path(current['source'])
        directory=path(current['receipt']).parent
        committed(source,head)
        record=next(r for r in read(current['receipt']) if r['name']==module.replace('.','_'))
        assert record['accepted'] and record['clean_log'] and record['exit_code']==0
        assert record['forbidden_proof_markers']==[] and record['cumulative_child_maxrss_kib']<=8*1024*1024
        snapshot=directory/'formal/Source3'/(name+'.lean');artifact=directory/'lib/Source3'/(name+'.olean')
        assert job.sha(source)==job.sha(snapshot)==record['source_sha256']==current['source_sha256']
        assert job.sha(artifact)==job.sha(path(current['artifact']))==record['olean_sha256']==current['artifact_sha256']
        for imported,expected in current.get('imports',{}).items():
            if imported in cache:
                assert cache[imported]['artifact_sha256']==expected,(module,imported)
        modules.append({'module':module,'source':pin(source),'snapshot':pin(snapshot),'artifact':pin(artifact),
            'cache_artifact':pin(current['artifact']),'receipt':pin(current['receipt']),
            'source_inputs':pin(directory/'SOURCE_INPUTS.json'),'logs':streams(directory,record,True),
            'imports':current.get('imports',{}),'elapsed_s':record['elapsed_s'],
            'maxrss_kib':record['cumulative_child_maxrss_kib']})
    audit_dir=path(cache['Source3.'+AUDIT_MODULE]['receipt']).parent;audit=read(audit_dir/'SEARCH_AUDIT.json')
    expected=len(producer.declarations())+len(producer.INHERITED)
    assert len(audit)==len({e['name'] for e in audit})==expected
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
    sage_dir=None
    for directory in sorted((job.BUILD/'jobs').glob('keygen_make_retry_frames_sage_057_*')):
        sage_dir=directory
    assert sage_dir is not None,'missing sage controls job'
    controls=read(sage_dir/'CERT_CONTROL_CHECK.json');record=read(sage_dir/'RECEIPTS.json')[0]
    assert record['accepted'] and record['clean_log'] and record['exit_code']==0
    assert job.sha(path(SAGE))==job.sha(sage_dir/SAGE)==record['source_sha256']
    assert controls['status']=='PASS_SCRIPTED_RETRY_FRAME_CONTROLS'
    assert controls['baseline_pass'] and controls['mutations_all_detected']
    reference=path(REFERENCE)
    history=[];directories=sorted((job.BUILD/'jobs').glob('keygen_make_retry_frames*_057_*'),
        key=lambda d: read(d/'RECEIPTS.json')[0]['start'] if (d/'RECEIPTS.json').exists()
            else read(d/'PREFLIGHT.json')['utc'])
    for directory in directories:
        if not (directory/'RECEIPTS.json').exists():
            history.append({'job':directory.name,'status':'PRESTEP_ABORTED_RETAINED',
                'cause':CAUSES.get(directory.name),'receipt':None,
                'preflight':pin(directory/'PREFLIGHT.json'),
                'runner_snapshot':pin(directory/'RUNNER_SOURCE.py')
                    if (directory/'RUNNER_SOURCE.py').exists() else None,
                'execution_snapshot':pin(directory/'EXECUTION_SOURCE.py')
                    if (directory/'EXECUTION_SOURCE.py').exists() else None,
                'snapshots':[],'raw_files':[],'steps':[],'accepted_products':[],
                'products':[pin(p) for p in sorted(directory.iterdir())
                    if p.is_file() and p.name not in {'PREFLIGHT.json','RUNNER_SOURCE.py','EXECUTION_SOURCE.py'}]})
            continue
        inventory=read(directory/'SOURCE_INPUTS.json');snapshots=[]
        for e in inventory['sources']:
            rel='formal/'+e['module'].replace('.','/')+'.lean' if 'module' in e else 'sage/'+Path(e['path']).name
            p=directory/rel;assert job.sha(p)==e['sha256'],p;snapshots.append(pin(p))
        records=read(directory/'RECEIPTS.json')
        status='FAILED_RETAINED' if any(not r['accepted'] for r in records) else 'ACCEPTED'
        history.append({'job':directory.name,'status':status,'cause':CAUSES.get(directory.name),
            'receipt':pin(directory/'RECEIPTS.json'),'source_inputs':pin(directory/'SOURCE_INPUTS.json'),
            'preflight':pin(directory/'PREFLIGHT.json'),'runner_snapshot':pin(directory/'RUNNER_SOURCE.py'),
            'execution_snapshot':pin(directory/'EXECUTION_SOURCE.py'),'snapshots':snapshots,
            'raw_files':[pin(p) for p in sorted((directory/'logs').iterdir()) if p.is_file()],
            'steps':[{'name':r['name'],'accepted':r['accepted'],'exit_code':r['exit_code'],'start':r['start'],
                'stop':r['stop'],'elapsed_s':r['elapsed_s'],'maxrss_kib':r['cumulative_child_maxrss_kib'],
                'logs':streams(directory,r)} for r in records],
            'accepted_products':[pin(p) for p in sorted((directory/'lib').rglob('*.olean')) if not p.is_symlink()],
            'products':[pin(p) for p in sorted(directory.iterdir()) if p.is_file() and p.name not in
                {'RECEIPTS.json','SOURCE_INPUTS.json','PREFLIGHT.json','RUNNER_SOURCE.py','EXECUTION_SOURCE.py'}]})
    for h in history:
        if h['status'] in {'FAILED_RETAINED','PRESTEP_ABORTED_RETAINED'} and not h['cause']:
            h['cause']='Retained failure without a sealed cause entry; see raw logs.'
    tools=['tools/job.py','tools/job_when_available.py','tools/keygen_make_retry_frames_audit.py',
        'tools/keygen_make_retry_frames_batch.py','tools/keygen_intermediate_batch.py',
        'tools/keygen_public_first_batch.py','formal/Source3/KeygenLevelsAudit.lean',SAGE]
    for p in tools: committed(p,head)
    committed(REFERENCE,head)
    notes=path(BASE+'_NOTES.md');assert notes.exists()
    result={'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_057','stage':'B1.07',
        'window':'CLOSED_AT_RECOVERABLE_MIDPOINT','b1_07_acceptance':'NOT_MET',
        'stage_result':'PARTIAL_PROOF','status':'IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN',
        'created_utc':datetime.now(timezone.utc).isoformat(),
        'harness':'MiMo V2.6 Pro / xiaomi-token-plan-ams','runner_labels':'Historical labels remain provenance.',
        'proof_head':head,'notes':pin(notes),'entry_pins_receipt':pin(ENTRY),'predecessor_files':11642,
        'superseded':{},'accepted_module_checks':modules,
        'audit':{**pin(audit_dir/'SEARCH_AUDIT.json'),'entries_jsonl':pin(audit_dir/'SEARCH_AUDIT_ENTRIES.jsonl'),
            'receipt':pin(audit_dir/'RECEIPTS.json'),'source_inputs':pin(audit_dir/'SOURCE_INPUTS.json'),
            'producer':pin('formal/Source3/KeygenMakeRetryFramesAudit.lean'),
            'generator':pin('tools/keygen_make_retry_frames_audit.py'),
            'exports':len(audit),'new_declarations':len(producer.declarations()),
            'inherited_interfaces':len(producer.INHERITED),
            'full_terms':sum('term' in e['body'] for e in audit),
            'kernel_inductives':sum('constructors' in e['body'] for e in audit),'elisions':0,
            'allowed_axioms':['propext','Classical.choice','Quot.sound']},
        'sage':{'source':pin(SAGE),'receipt':pin(sage_dir/'RECEIPTS.json'),
            'source_inputs':pin(sage_dir/'SOURCE_INPUTS.json'),'result':pin(sage_dir/'CERT_CONTROL_CHECK.json'),
            'reference_c_source':pin(reference),
            'runs':1,'cases_per_run':controls['cases_per_run'],'mutation_kinds':controls['mutation_kinds'],
            'scope':controls['scope']},
        'generator_reproduction':pin('.build/levels_057/GENERATOR_CHECK.json'),
        'attempt_details':history,
        'attempt_counts':{s:sum(h['status']==s for h in history)
            for s in ['ACCEPTED','FAILED_RETAINED','PRESTEP_ABORTED_RETAINED']},
        'contracts':{'rejected_edge_h_frame':'solver_frame holds on EVERY solver edge: early search rejection, the failed output gate (guard calls plus the state-preserving return-0 body) and the validation suffix on either return; solver_h_frame instantiates it at the public h block with the named protected-block and F/G separations.',
            'partial_output_gate_writes':'call_bytes/gate_frame confine the conversion writes to the F/G destination blocks even when the conversion loop stops half way (writesOnly footprint over the small body); the failed-guard edge may leave a partial F or G column and still keeps every other byte.',
            'validation_body_frame':'validation_frame re-derives the four-leg validation suffix frame (generation, conversion trace, transform sequence, read-only final check) from the raw KeygenRootValidationSource legs with NO accepted-flow premise, so the zero-return edge keeps every byte outside the scratch block.',
            'residuals':'The per-retry Initial/legal/static transport, the gate-time ReadTmp tie from the executed fk->tmp binding and the statement-machine extraction remain open; the loop-trace chronology transport stays at the gate level.'},
        'open_in_b1_07':['Retry transport: the Initial/legal/static transport for every retry instance (the per-retry transport of entry_of_allocation across the whole attempt), general typed execution, every later return and the gate-time ReadTmp tie from the executed fk->tmp binding; the loop-trace chronology transport stays at the gate level.',
            'Statement-machine extraction of the call/allocation binding (temp_size body, falcon_keygen_new prologue, the gate call), the actual globals/common call ID/snapshots composition and the b-not-1/2 side condition of the pinned transport; that step also discharges the residual h-side/material-block/workspace inputs from allocation freshness.',
            'Same h/equation material across the whole enclosing invocation to the actual encoding call sites and complete teardown; the encoding-tail codec bodies (B1.08/09) and output-capacity events remain outside.'],
        'outside_scope':['B1.08-B1.11 codec bodies/emitted-to-fiber/final replay, B4/B5 probability/availability/PRG/security, OS/Windows/compiler/machine refinement, CT and independent review.'],
        'tools':[pin(p) for p in tools],
        'source_commits':subprocess.check_output(['git','log','--reverse','--format=%H %s',
            'c0e26975..'+head,'--',str(job.ROOT.relative_to(job.REPO))],cwd=job.REPO,text=True).splitlines(),
        'origin_main_observed':subprocess.check_output(['git','rev-parse','origin/main'],cwd=job.REPO,text=True).strip(),
        'active_jobs_at_close':[],'push_by_this_worker':False,'review_or_stages_import':False,
        'limits':'Unchanged Lean j1/-M6144,AS12GiB/RSS8GiB,wall1800s,maxHeartbeats2000000,print200000;0/0 streams,Sage preparser. No inherited source or job limits raised.'}
    assert not job.active()
    with path(BASE+'.json').open('x') as stream: json.dump(result,stream,indent=2);stream.write('\n')
    print(json.dumps({'batch':pin(BASE+'.json'),'notes':pin(notes),'audit_entries':len(audit),
        'attempts':len(history),'attempt_counts':result['attempt_counts']},indent=2))

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
    assert batch['batch']=='BATCH_057' and batch['superseded']=={} and batch['active_jobs_at_close']==[]
    assert batch['window']=='CLOSED_AT_RECOVERABLE_MIDPOINT' and batch['b1_07_acceptance']=='NOT_MET'
    assert batch['entry_pins_receipt']['sha256']==ENTRY_SHA
    for p,expected in entry_checked()['checked'].items(): check(p,expected)
    inputs=read(batch['audit']['source_inputs']['path'])
    for e in inputs['sources']: check(e['path'],e['sha256'])
    for e in inputs['reused']:
        check(e.get('current_source',e['source']),e['source_sha256']);check(e['artifact'],e['artifact_sha256'])
    assert not job.active()
    result={'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-057','checked':checked,
        'distinct_pinned_files':len(checked),'current_source_inputs':batch['audit']['exports']+
            batch['audit']['inherited_interfaces'],'active_jobs':[],'superseded':{},
        'verifier_sha256':job.sha(Path(__file__))}
    print(json.dumps({**{k:v for k,v in result.items() if k!='checked'},'receipt':write_receipt(target,result)},indent=2))

if __name__=='__main__':
    command=sys.argv[1] if len(sys.argv)>1 else ''
    if command=='seal': seal()
    elif command=='generator': generator_check()
    elif command=='predecessor':
        assert len(sys.argv)==3;predecessor(sys.argv[2])
    else:
        assert command=='verify' and len(sys.argv)==5,('unexpected',sys.argv)
        verify(sys.argv[2],sys.argv[3],sys.argv[4])
