#!/usr/bin/env python3
"""Seal/verify059's statement-machine midpoint, preserving015--058."""
from contextlib import redirect_stdout
from datetime import datetime, timezone
from io import StringIO
from pathlib import Path
import json
import shutil
import subprocess
import sys

import job
import keygen_make_statement_machine_audit as producer
from keygen_intermediate_batch import path, read, pin, committed, streams
from keygen_public_first_batch import write_receipt

BASE='notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_059'
ENTRY='.build/levels_059/ENTRY_PINS_059.json'
ENTRY_SHA='c143c1dbf7dcdf50663d78e45a51b72966c2e753b90c61faa217fc7bda37862e'
SAGE='sage/check_keygen_make_statement_machine.sage'
MODULES=['KeygenMakeStatementMachine']
AUDIT_MODULE='KeygenMakeStatementMachineAudit'
PRESEAL='.build/levels_059/PRESEAL.json'
REFERENCE='../../../../../Extra/c/falcon-keygen.c'
CAUSES={
    'keygen_make_statement_machine_059_001':'First elaboration rejected: the pinned-table liveness leg failed dependent elimination of `Load64` at the DEFINED table word index (the documented determined-index trap), the scratch-free rewrite ran in the wrong direction at the `scratchOf` block equality, the fpr-cast span `decide` could not close over the free block variable, the relocated `CertBind` application dropped the `entered` state argument, the per-element `Allocated` extent was rewritten to literal widths before `exact`, the block-size transport asked for a function equality where the call frame supplies a pointwise one, the scratch-liveness rewrite at block0 rewrote both sides, the simp-normalized material-block separations no longer matched the pointer projection, and the accepted-package tuple components were consumed in the wrong order. Rejected snapshot retained.',
    'keygen_make_statement_machine_059_002':'Second elaboration rejected: the definitional fpr-cast span `rfl` timed out in whnf over the free block variable and its downstream `rw` chain closed early, and the reverse-snapshot existential bound an unused `snapshot` variable flagged by the unused-variable linter. Both fixed by composing the existing `scratch_extent`/`bridge_of_extent` exports (no arithmetic reduction) and by dropping the unused binder. Rejected snapshot retained.',
    'keygen_make_statement_machine_audit_059_001':'Audit elaboration REJECTED (retained step record logs/Source3_KeygenMakeStatementMachineAudit.receipt.json: exit 1, 761s): the inherited interface list named `FT1536.Source3.KeygenSearchPrefix.Dimensions`, an unknown constant (the real interface is `KeygenMakeSearchPrefix.Dimensions`). The job driver then lost its final RECEIPTS.json write to a harness restart; every byte of the attempt (step receipt, raw logs, snapshots) is retained and the corrected audit runs as keygen_make_statement_machine_audit_059_002.',
    'keygen_make_statement_machine_sage_059_001':'Scripted controls run REJECTED (exit 1): the reference-source locator walked eight parent levels and stopped one level short of the repository root, so `Extra/c/falcon-keygen.c` was not found from the job sandbox. The locator range was fixed to twelve levels and the controls re-run as keygen_make_statement_machine_sage_059_002; all bytes of this attempt retained.'}

def entry_checked():
    assert not job.active(),'A proof job is active'
    assert job.sha(path(ENTRY))==ENTRY_SHA
    entry=read(ENTRY)
    assert entry['batch']=='BATCH_015-058'
    assert entry['distinct_pinned_files']==len(entry['checked'])==11874
    assert entry['current_source_inputs']==261 and entry['active_jobs']==[] and entry['superseded']=={}
    for p,expected in entry['checked'].items(): assert job.sha(path(p))==expected,('predecessor changed',p)
    return entry

def predecessor(target):
    entry=entry_checked()
    result={'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-058','checked':entry['checked'],
        'distinct_pinned_files':11874,'entry':pin(ENTRY),'active_jobs':[],'superseded':{},
        'verifier_sha256':job.sha(Path(__file__))}
    print(json.dumps({'predecessor_files':11874,'receipt':write_receipt(target,result)},indent=2))

def generator_check():
    dest=path('.build/levels_059/audit_generator')
    dest.mkdir(parents=True,exist_ok=False)
    for name in producer.MODULES+['KeygenLevelsAudit']:
        target=dest/'formal/Source3'/(name+'.lean');target.parent.mkdir(parents=True,exist_ok=True)
        shutil.copyfile(path('formal/Source3/'+name+'.lean'),target)
    original=producer.ROOT;printed=StringIO()
    try:
        producer.ROOT=dest
        with redirect_stdout(printed): producer.main()
    finally: producer.ROOT=original
    target=dest/'formal/Source3/KeygenMakeStatementMachineAudit.lean'
    source=path('formal/Source3/KeygenMakeStatementMachineAudit.lean')
    assert source.read_bytes()==target.read_bytes()
    result={'utc':datetime.now(timezone.utc).isoformat(),'status':'BYTE_EXACT_AUDIT_PRODUCER_REPRODUCTION',
        'producer':pin('tools/keygen_make_statement_machine_audit.py'),'source':pin(source),
        'reproduced':pin(target),'generator_output':printed.getvalue()}
    print(json.dumps(write_receipt('.build/levels_059/GENERATOR_CHECK.json',result),indent=2))

def seal():
    assert not path(BASE+'.json').exists(),'Never replace a historical pair'
    entry=entry_checked()
    head=subprocess.check_output(['git','rev-parse','HEAD'],cwd=job.REPO,text=True).strip()
    assert subprocess.check_output(['git','branch','--show-current'],cwd=job.REPO,text=True).strip()=='main'
    preseal=read(PRESEAL)
    assert preseal['checked']==entry['checked'] and preseal['verifier_sha256']==job.sha(Path(__file__))
    generated=read('.build/levels_059/GENERATOR_CHECK.json')
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
        snapshot=directory/'formal/Source3'/(name+'.olean');artifact=directory/'lib/Source3'/(name+'.olean')
        assert job.sha(source)==job.sha(snapshot)==record['source_sha256']==current['source_sha256']
        assert job.sha(artifact)==job.sha(path(current['artifact']))==record['artifact_sha256']==current['artifact_sha256']
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
    for directory in sorted((job.BUILD/'jobs').glob('keygen_make_statement_machine_sage_059_*')):
        sage_dir=directory
    assert sage_dir is not None,'missing sage controls job'
    controls=read(sage_dir/'CERT_CONTROL_CHECK.json');record=read(sage_dir/'RECEIPTS.json')[0]
    assert record['accepted'] and record['clean_log'] and record['exit_code']==0
    assert job.sha(path(SAGE))==job.sha(sage_dir/SAGE)==record['source_sha256']
    assert controls['status']=='PASS_SCRIPTED_STATEMENT_MACHINE_CONTROLS'
    assert controls['baseline_pass'] and controls['mutations_all_detected']
    reference=path(REFERENCE)
    history=[];directories=sorted((job.BUILD/'jobs').glob('keygen_make_statement_machine*_059_*'),
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
    tools=['tools/job.py','tools/job_when_available.py','tools/keygen_make_statement_machine_audit.py',
        'tools/keygen_make_statement_machine_batch.py','tools/keygen_intermediate_batch.py',
        'tools/keygen_public_first_batch.py','formal/Source3/KeygenLevelsAudit.lean',SAGE]
    for p in tools: committed(p,head)
    committed(REFERENCE,head)
    notes=path(BASE+'_NOTES.md');assert notes.exists()
    result={'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_059','stage':'B1.07',
        'window':'CLOSED_AT_RECOVERABLE_MIDPOINT','b1_07_acceptance':'NOT_MET',
        'stage_result':'PARTIAL_PROOF','status':'IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN',
        'created_utc':datetime.now(timezone.utc).isoformat(),
        'harness':'MiMo V2.6 Pro / xiaomi-token-plan-ams','runner_labels':'Historical labels remain provenance.',
        'proof_head':head,'notes':pin(notes),'entry_pins_receipt':pin(ENTRY),'predecessor_files':11874,
        'superseded':{},'accepted_module_checks':modules,
        'audit':{**pin(audit_dir/'SEARCH_AUDIT.json'),'entries_jsonl':pin(audit_dir/'SEARCH_AUDIT_ENTRIES.jsonl'),
            'receipt':pin(audit_dir/'RECEIPTS.json'),'source_inputs':pin(audit_dir/'SOURCE_INPUTS.json'),
            'producer':pin('formal/Source3/KeygenMakeStatementMachineAudit.lean'),
            'generator':pin('tools/keygen_make_statement_machine_audit.py'),
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
        'generator_reproduction':pin('.build/levels_059/GENERATOR_CHECK.json'),
        'attempt_details':history,
        'attempt_counts':{s:sum(h['status']==s for h in history)
            for s in ['ACCEPTED','FAILED_RETAINED','PRESTEP_ABORTED_RETAINED','INTERRUPTED_RETAINED']},
        'contracts':{'call_site_extraction':'call_site_bridge ties the C call-site `(fpr *)fk->tmp` fpr cast of the bound scratch to the certificate workspace view of the machine at the scratch block (temp_size reservation = workspace extent, scratch_extent_exact/scratch_extent_workspace/fprCast_scratch_span); certBindAt_of_allocation/callAt_of_allocation bind the caller cells plus the executed allocation binding to CertBindAt/CallAt/ExecAt at the actual scratch block.',
            'freshness_side_condition':'binding_scratch_free discharges the b-not-1/2 side condition of the pinned transport from allocation freshness (a fresh malloc block is separated from the live pinned table blocks 1/2, pinned_block_live/pinned_one_live/pinned_two_live); objects_table_free gives the same for the six automatic arrays.',
            'call_same_block':'THE general call frame on a foreign block: the certificate body keeps every byte of any block outside the model workspace block0 and the static table blocks 1/2 on BOTH return values (live bytes via CertificateFunctionFrame.source_frame with the M0 table-block inversion tablesOutside_nonTable, beyond-size bytes via leave_bytes); cert_entry_frame discharges the CertEntryFrame residual of the retry transport at the three entry blocks.',
            'entry_facts':'entry_facts_of_allocation discharges every EntryFacts residual from allocation freshness (legalF/legalG/legalH from the fresh array allocations, hTables/hProtected from fresh_separate against staticLive/scratch liveness, blocks/pubBlocks against the workspace block0 through the executed binding and blocks 1/2 through pinned liveness); scratch_block_of_call derives the canonical block0 shape from the call bridge field.',
            'certificate_instantiation':'cert_package_of_call instantiates the complete mandatory certificate at the actual caller call with its pinned globals (FftGlobalScalars.environment through FftGlobalMemory.environment), the common call material (768-word gate trace and good event stream of the same call), the stored leaf words, the bad-flag lifetime and the prefix/reverse source snapshots.'},
        'open_in_b1_07':['Whole-invocation statement-machine execution of the gate call at the actual encoding call sites (the C call-site/ExecAt tie is composed at the binding level; the enclosing typed expression/statement execution of the call statement, output-capacity events and complete teardown remain open).',
            'The loop-trace chronology composition of the per-retry transport stays at gate level (one attempt at a time).',
            'Exact reading of the plan phrase "globals/common call ID/snapshots": the certificate globals, common call material and source snapshots are instantiated; any further intended call-identifier composition stays to be pinned with the enclosing invocation.'],
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
    assert batch['batch']=='BATCH_059' and batch['superseded']=={} and batch['active_jobs_at_close']==[]
    assert batch['window']=='CLOSED_AT_RECOVERABLE_MIDPOINT' and batch['b1_07_acceptance']=='NOT_MET'
    assert batch['entry_pins_receipt']['sha256']==ENTRY_SHA
    for p,expected in entry_checked()['checked'].items(): check(p,expected)
    inputs=read(batch['audit']['source_inputs']['path'])
    for e in inputs['sources']: check(e['path'],e['sha256'])
    for e in inputs['reused']:
        check(e.get('current_source',e['source']),e['source_sha256']);check(e['artifact'],e['artifact_sha256'])
    assert not job.active()
    result={'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-059','checked':checked,
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
