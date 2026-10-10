#!/usr/bin/env python3
"""Seal/verify060's invocation midpoint, preserving015--059."""
from contextlib import redirect_stdout
from datetime import datetime, timezone
from io import StringIO
from pathlib import Path
import json
import shutil
import subprocess
import sys

import job
import keygen_make_invocation_audit as producer
from keygen_intermediate_batch import path, read, pin, committed, streams
from keygen_public_first_batch import write_receipt

BASE='notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_060'
ENTRY='.build/levels_060/ENTRY_PINS_060.json'
ENTRY_SHA='10df0c1d908576c425c94bfba5d6fde4c6901c2496ad61e37f7737758eb32033'
SAGE='sage/check_keygen_make_invocation.sage'
MODULES=['KeygenMakeInvocation']
AUDIT_MODULE='KeygenMakeInvocationAudit'
PRESEAL='.build/levels_060/PRESEAL.json'
REFERENCE='../../../../../Extra/c/falcon-keygen.c'
CAUSES={
    'keygen_make_invocation_060_001':'First elaboration rejected: the Prop-valued call-site structures could not project their data fields (`SmallSite.src`/`PublicSite.klen` need a Type-valued structure), the `skeBind` statement shape missed its assignment operator, `ReadPointer` elimination named one binder too many, the canonical-pointer proof used deprecated `if_neg` simp arguments and mis-normalized the offset equalities, and the `public`/`prefix` field and pattern names are keywords, cascading parse failures over the invocation section. Rejected snapshot retained.',
    'keygen_make_invocation_060_002':'Second elaboration rejected at parse: the unspaced `4≤i` binder type tokenizes as the imported `≤i` token under the pinned Mathlib/Std notation table (spaced `4 ≤ i` parses; the probe isolates `≤i` adjacency as the only failing form), aborting the `Segments` inductive and cascading autoImplicit errors. Rejected snapshot retained.',
    'keygen_make_invocation_060_003':'Third elaboration rejected: `rfl` over the two segment-loop `Head` constructors needs the Segments tables/arrays preservation lemmas, the `bindSkbuf` cell rewrite needed `ite_false` after the condition reduced to `False`, the `encoding_exit` single-statement case refuted the flow disjunction instead of eliminating the impossible `Head retOne` index, and the `Invocation` case patterns counted the index-determined `events` binder. Rejected snapshot retained.',
    'keygen_make_invocation_060_004':'Fourth elaboration rejected: `case` alternative names do not reach index-determined constructor binders (the segment constructors expose only three slots, so `run` shifted onto the flow equation and the `Segments` proof stayed unnamed), and the accepted-attempt pattern renamed the gate result beyond its slots. Rejected snapshot retained.',
    'keygen_make_invocation_060_005':'Fifth elaboration rejected: the `cases`-with patterns for `AttemptExec` mis-slotted `earlyRejected`/`throughCertificate` (the index result binder naming differs between the two constructors), leaving the rejection equation and the gate argument unbound. Fixed by `induction ... with`, which names the full binder telescope. Rejected snapshot retained.',
    'keygen_make_invocation_audit_060_001':'Guard rejection at PREFLIGHT with no source bytes: the global `job.active()` probe saw the parallel S05 lane s Lean process in its own work tree. Environment race per the handoff note, not a pin mismatch; the audit re-ran as keygen_make_invocation_audit_060_002.',
    'keygen_make_invocation_sage_060_001':'Scripted controls run REJECTED (exit 1, retained): two control-logic defects found by the run itself - the transcription order check matched the first `return 1;` anywhere in the reference file instead of the encoding-tail region, and the truncated-address variant was indistinguishable under modulo-2^64 word equality. Both fixed (monotonic cursor scan; exact sub-2^64 word equality); all bytes of this attempt retained.'}

def entry_checked():
    assert not job.active(),'A proof job is active'
    assert job.sha(path(ENTRY))==ENTRY_SHA
    entry=read(ENTRY)
    assert entry['batch']=='BATCH_015-059'
    assert entry['distinct_pinned_files']==len(entry['checked'])==11950
    assert entry['current_source_inputs']==342 and entry['active_jobs']==[] and entry['superseded']=={}
    for p,expected in entry['checked'].items(): assert job.sha(path(p))==expected,('predecessor changed',p)
    return entry

def predecessor(target):
    entry=entry_checked()
    result={'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-059','checked':entry['checked'],
        'distinct_pinned_files':11950,'entry':pin(ENTRY),'active_jobs':[],'superseded':{},
        'verifier_sha256':job.sha(Path(__file__))}
    print(json.dumps({'predecessor_files':11950,'receipt':write_receipt(target,result)},indent=2))

def generator_check():
    dest=path('.build/levels_060/audit_generator')
    dest.mkdir(parents=True,exist_ok=False)
    for name in producer.MODULES+['KeygenLevelsAudit']:
        target=dest/'formal/Source3'/(name+'.lean');target.parent.mkdir(parents=True,exist_ok=True)
        shutil.copyfile(path('formal/Source3/'+name+'.lean'),target)
    original=producer.ROOT;printed=StringIO()
    try:
        producer.ROOT=dest
        with redirect_stdout(printed): producer.main()
    finally: producer.ROOT=original
    target=dest/'formal/Source3/KeygenMakeInvocationAudit.lean'
    source=path('formal/Source3/KeygenMakeInvocationAudit.lean')
    assert source.read_bytes()==target.read_bytes()
    result={'utc':datetime.now(timezone.utc).isoformat(),'status':'BYTE_EXACT_AUDIT_PRODUCER_REPRODUCTION',
        'producer':pin('tools/keygen_make_invocation_audit.py'),'source':pin(source),
        'reproduced':pin(target),'generator_output':printed.getvalue()}
    print(json.dumps(write_receipt('.build/levels_060/GENERATOR_CHECK.json',result),indent=2))

def seal():
    assert not path(BASE+'.json').exists(),'Never replace a historical pair'
    entry=entry_checked()
    head=subprocess.check_output(['git','rev-parse','HEAD'],cwd=job.REPO,text=True).strip()
    assert subprocess.check_output(['git','branch','--show-current'],cwd=job.REPO,text=True).strip()=='main'
    preseal=read(PRESEAL)
    assert preseal['checked']==entry['checked'] and preseal['verifier_sha256']==job.sha(Path(__file__))
    generated=read('.build/levels_060/GENERATOR_CHECK.json')
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
    for directory in sorted((job.BUILD/'jobs').glob('keygen_make_invocation_sage_060_*')):
        if (directory/'CERT_CONTROL_CHECK.json').exists(): sage_dir=directory
    assert sage_dir is not None,'missing sage controls job'
    controls=read(sage_dir/'CERT_CONTROL_CHECK.json');record=read(sage_dir/'RECEIPTS.json')[0]
    assert record['accepted'] and record['clean_log'] and record['exit_code']==0
    assert job.sha(path(SAGE))==job.sha(sage_dir/SAGE)==record['source_sha256']
    assert controls['status']=='PASS_SCRIPTED_INVOCATION_CONTROLS'
    assert controls['baseline_pass'] and controls['mutations_all_detected']
    reference=path(REFERENCE)
    history=[];directories=sorted((job.BUILD/'jobs').glob('keygen_make_invocation*_060_*'),
        key=lambda d: read(d/'RECEIPTS.json')[0]['start'] if (d/'RECEIPTS.json').exists()
            else read(d/'PREFLIGHT.json')['utc'])
    for directory in directories:
        if not (directory/'RECEIPTS.json').exists():
            step_receipts=sorted((directory/'logs').glob('*.receipt.json'))
            history.append({'job':directory.name,
                'status':'INTERRUPTED_RETAINED' if step_receipts else 'PRESTEP_ABORTED_RETAINED',
                'cause':CAUSES.get(directory.name),'receipt':None,
                'step_receipts':[pin(p) for p in step_receipts],
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
        if h['status'] in {'FAILED_RETAINED','PRESTEP_ABORTED_RETAINED','INTERRUPTED_RETAINED'} and not h['cause']:
            h['cause']='Retained failure without a sealed cause entry; see raw logs.'
    tools=['tools/job.py','tools/job_when_available.py','tools/keygen_make_invocation_audit.py',
        'tools/keygen_make_invocation_batch.py','tools/keygen_intermediate_batch.py',
        'tools/keygen_public_first_batch.py','formal/Source3/KeygenLevelsAudit.lean',SAGE]
    for p in tools: committed(p,head)
    committed(REFERENCE,head)
    notes=path(BASE+'_NOTES.md');assert notes.exists()
    result={'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_060','stage':'B1.07',
        'window':'CLOSED_AT_RECOVERABLE_MIDPOINT','b1_07_acceptance':'NOT_MET',
        'stage_result':'PARTIAL_PROOF','status':'IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN',
        'created_utc':datetime.now(timezone.utc).isoformat(),
        'harness':'MiMo V2.6 Pro / xiaomi-token-plan-ams','runner_labels':'Historical labels remain provenance.',
        'proof_head':head,'notes':pin(notes),'entry_pins_receipt':pin(ENTRY),'predecessor_files':11950,
        'superseded':{},'accepted_module_checks':modules,
        'audit':{**pin(audit_dir/'SEARCH_AUDIT.json'),'entries_jsonl':pin(audit_dir/'SEARCH_AUDIT_ENTRIES.jsonl'),
            'receipt':pin(audit_dir/'RECEIPTS.json'),'source_inputs':pin(audit_dir/'SOURCE_INPUTS.json'),
            'producer':pin('formal/Source3/KeygenMakeInvocationAudit.lean'),
            'generator':pin('tools/keygen_make_invocation_audit.py'),
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
        'generator_reproduction':pin('.build/levels_060/GENERATOR_CHECK.json'),
        'attempt_details':history,
        'attempt_counts':{s:sum(h['status']==s for h in history)
            for s in ['ACCEPTED','FAILED_RETAINED','PRESTEP_ABORTED_RETAINED','INTERRUPTED_RETAINED']},
        'contracts':{'tail_statement_machine':'tail_source pins the 18 statements of KeygenMakeProgram.encoding as one kernel list equality (privkeyLenRead/skbufAssign/capacityReturn/skHeader/skoffOne/skeBind0-3/secretLoop/privkeyLenWrite/pubkeyLenRead/capacityReturn/pkHeader/publicDispatch/zeroCapacity/pubkeyLenWrite/retOne); Head executes each statement form on the caller state and Encoding sequences them in source order with the non-normal exit edges.',
            'encoder_call_sites':'SmallSite/PublicSite are the actual falcon_encode_small/falcon_encode_18433/falcon_encode_12289 call boundaries with their evaluated argument cells (skbuf/klen/skoff/comp/ter/logn, the ske[i] pointer read and the h cell) and their open return value/heap effect; small_site_material ties the segment source argument to the material array through write-then-read pointer uniqueness (read_unique/canonical_word_eq) under the legal virtual map.',
            'output_capacity_events':'The four output-capacity edges (private klen<1 twice, segment elen==0, public klen==0) are named return-0 constructors of the machine; tail_exit/encoding_exit characterize every tail execution as ending in return 1 or one of those four edges.',
            'complete_teardown':'Invocation composes the argument binding, readiness prefix, capped attempt loop and the encoding tail with KeygenMakeLifetime.close on EVERY return edge (including the attempt-cap edge); invocation_flow and invocation_teardown export the return characterization and the disposal of all six automatic blocks.',
            'same_invocation_certificate':'invocation_gate extracts the accepted mandatory leaf-certificate gate of the final attempt (the profile-false skip is impossible under the gate profile) and invocation_certificate/CertPackage tie the complete certificate package (pinned globals, prefix/reverse snapshots, bad-flag lifetime, shared call material) to the SAME whole invocation.'},
        'open_in_b1_07':['The loop-trace chronology composition of the per-retry transport stays at gate level; the TailCells entry facts of the encoding tail are the named explicit input class of this step and their derivation across rejected attempts remains with that item.',
            'The codec bodies and their write frames are B1.08/09: the exact encoded lengths, the persistence of the stored length words and of the source arrays through later encoder calls, and the bytewise round-trips.',
            'Residue pin of the plan phrase "globals/common call ID/snapshots": the globals, snapshots, bad-flag lifetime and shared call material are instantiated (cert_package_of_call) and tied to the same invocation (invocation_certificate); if the phrase intends an EXPLICIT identifier value beyond the shared derivation, that composition stays OPEN with its intended shape and is not derived or assumed here.'],
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
    assert batch['batch']=='BATCH_060' and batch['superseded']=={} and batch['active_jobs_at_close']==[]
    assert batch['window']=='CLOSED_AT_RECOVERABLE_MIDPOINT' and batch['b1_07_acceptance']=='NOT_MET'
    assert batch['entry_pins_receipt']['sha256']==ENTRY_SHA
    for p,expected in entry_checked()['checked'].items(): check(p,expected)
    inputs=read(batch['audit']['source_inputs']['path'])
    for e in inputs['sources']: check(e['path'],e['sha256'])
    for e in inputs['reused']:
        check(e.get('current_source',e['source']),e['source_sha256']);check(e['artifact'],e['artifact_sha256'])
    assert not job.active()
    result={'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-060','checked':checked,
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
