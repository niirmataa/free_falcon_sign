#!/usr/bin/env python3
"""Seal/verify061's virtual-legal repair + loop-chronology midpoint, preserving015--060."""
from contextlib import redirect_stdout
from datetime import datetime, timezone
from io import StringIO
from pathlib import Path
import json
import shutil
import subprocess
import sys

import job
import keygen_make_loop_chronology_audit as producer
from keygen_intermediate_batch import path, read, pin, committed, streams
from keygen_public_first_batch import write_receipt

BASE='notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_061'
ENTRY='.build/levels_061/ENTRY_PINS_061.json'
ENTRY_SHA='73aba5d666c51df49b1baacb094115d161e69a3ccbe38b711773941a5cbad96c'
SAGE='sage/check_keygen_make_loop_chronology.sage'
MODULES=['KeygenMakeInvocation','KeygenMakeLoopChronology']
AUDIT_MODULE='KeygenMakeLoopChronologyAudit'
PRESEAL='.build/levels_061/PRESEAL.json'
REFERENCE='../../../../../Extra/c/falcon-keygen.c'
PREDECESSOR_COUNT=12050
PREDECESSOR_INPUTS=186
REPAIR_REASON=('VirtualLegal repair (2026-10-11 cross-lane catch, kernel-confirmed impossibility '
    'of the 060 all-`Nat` shape): the map legality class is restricted to the finite live-block '
    'set `Env.live`, the pointer uniqueness proofs are transferred and their consumers '
    '(small_site_material/Invocation.encoded and the dependent invocation theorems) are '
    're-elaborated and re-audited in this batch; the 060 bytes remain pinned in their sealed '
    'BATCH_060 pair and job snapshots.')
SUPERSEDED={
    str((job.ROOT/'formal/Source3/KeygenMakeInvocation.lean').resolve()):
        'c644d0edd5eeb23dd7893bc88e83a0d9560b8ee899d54318c65baadc1ffbf2d2',
    str((job.ROOT/'.build/cache/Source3/KeygenMakeInvocation.olean').resolve()):
        '73f6a844d55dffa78dd68ea59520e565fc85a25996906515c62938718c438f7f'}
CAUSES={
    'keygen_make_invocation_legal_061_001':'Guard rejection at PREFLIGHT with no source bytes: the parallel lane Lean process in proofs/ft1536/work/FT1536_PREMISE_AUDIT_20261011_001 was active. Environment race per the handoff note, not a pin mismatch; retried as keygen_make_invocation_legal_061_001_slot_retry_001.',
    'keygen_make_invocation_legal_061_001_slot_retry_001':'First elaboration of the VirtualLegal repair REJECTED (retained): the Fin constructor in the trap refutation needed an explicit map type (the S05 witness shape `let g : Nat -> Fin (2^64)`), `congrArg Fin.val` needed that named map, and two lambda binders were unused under the linter (fixed with `_` names).',
    'keygen_make_loop_chronology_061_001':'First elaboration of the loop-chronology module REJECTED (retained): unused simp arguments and unsolved prologue-cell goals (the ite chains need the whole def chain with literal disequalities), `(congrArg Result.flow _).elim` (no `Eq.elim`; `cases` instead), the reserved-word `prefix` binder clash (060 trap class), the `induction`-versus-`cases` binder-slot distinction and the entry-frame first-state binder.',
    'keygen_make_loop_chronology_061_002':'Second elaboration REJECTED (retained): `prepared_local` lives in KeygenMakeSearchPrefix (not KeygenMakeSampling), `convert_self` needs its value argument explicit, index-filling constructor arguments bind nothing under `cases` (names at those slots are discarded), and the `Prefix.run` alternative expects 9 names including the index-determined events/out slots.',
    'keygen_make_loop_chronology_061_003':'Third elaboration REJECTED (retained): the ready_arrays_other disequalities must be stated at the evaluated char-list normal form (`n != [s,k,e]`) to match the unfolded ite conditions.',
    'keygen_make_loop_chronology_audit_061_001':'The generated audit module was REJECTED (retained): its INHERITED list carried the stale KeygenMakeSampling.prepared_local name. Producer fixed; the rejected generated module is retained in the job snapshot and the accepted one regenerated canonically.',
    'keygen_make_loop_chronology_sage_061_001':'Job aborted at source copy with no source bytes: the sage source path was passed with a redundant `sage/` prefix (job.py resolves sage sources under sage/). Runner-argument slip, retried as keygen_make_loop_chronology_sage_061_002.'}

def entry_checked():
    assert not job.active(),'A proof job is active'
    assert job.sha(path(ENTRY))==ENTRY_SHA
    entry=read(ENTRY)
    assert entry['batch']=='BATCH_015-060'
    assert entry['distinct_pinned_files']==len(entry['checked'])==PREDECESSOR_COUNT
    assert entry['current_source_inputs']==PREDECESSOR_INPUTS and entry['active_jobs']==[] and entry['superseded']=={}
    superseded={}
    for p,expected in entry['checked'].items():
        actual=job.sha(path(p))
        if actual==expected: continue
        assert p in SUPERSEDED and SUPERSEDED[p]==expected,('predecessor changed',p)
        superseded[p]={'superseded_sha256':expected,'current_sha256':actual,'reason':REPAIR_REASON}
    assert set(superseded)==set(SUPERSEDED),('unexpected supersession set',sorted(superseded))
    return entry,superseded

def predecessor(target):
    entry,superseded=entry_checked()
    result={'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-060','checked':entry['checked'],
        'distinct_pinned_files':PREDECESSOR_COUNT,'entry':pin(ENTRY),'active_jobs':[],'superseded':superseded,
        'verifier_sha256':job.sha(Path(__file__))}
    print(json.dumps({'predecessor_files':PREDECESSOR_COUNT,'superseded':superseded,
        'receipt':write_receipt(target,result)},indent=2))

def generator_check():
    dest=path('.build/levels_061/audit_generator')
    dest.mkdir(parents=True,exist_ok=False)
    for name in producer.MODULES+['KeygenLevelsAudit']:
        target=dest/'formal/Source3'/(name+'.lean');target.parent.mkdir(parents=True,exist_ok=True)
        shutil.copyfile(path('formal/Source3/'+name+'.lean'),target)
    original=producer.ROOT;printed=StringIO()
    try:
        producer.ROOT=dest
        with redirect_stdout(printed): producer.main()
    finally: producer.ROOT=original
    target=dest/'formal/Source3/KeygenMakeLoopChronologyAudit.lean'
    source=path('formal/Source3/KeygenMakeLoopChronologyAudit.lean')
    assert source.read_bytes()==target.read_bytes()
    result={'utc':datetime.now(timezone.utc).isoformat(),'status':'BYTE_EXACT_AUDIT_PRODUCER_REPRODUCTION',
        'producer':pin('tools/keygen_make_loop_chronology_audit.py'),'source':pin(source),
        'reproduced':pin(target),'generator_output':printed.getvalue()}
    print(json.dumps(write_receipt('.build/levels_061/GENERATOR_CHECK.json',result),indent=2))

def seal():
    assert not path(BASE+'.json').exists(),'Never replace a historical pair'
    entry,superseded=entry_checked()
    head=subprocess.check_output(['git','rev-parse','HEAD'],cwd=job.REPO,text=True).strip()
    assert subprocess.check_output(['git','branch','--show-current'],cwd=job.REPO,text=True).strip()=='main'
    preseal=read(PRESEAL)
    assert preseal['checked']==entry['checked'] and preseal['verifier_sha256']==job.sha(Path(__file__))
    assert preseal['superseded']==superseded
    generated=read('.build/levels_061/GENERATOR_CHECK.json')
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
    for directory in sorted((job.BUILD/'jobs').glob('keygen_make_loop_chronology_sage_061_*')):
        if (directory/'CERT_CONTROL_CHECK.json').exists(): sage_dir=directory
    assert sage_dir is not None,'missing sage controls job'
    controls=read(sage_dir/'CERT_CONTROL_CHECK.json');record=read(sage_dir/'RECEIPTS.json')[0]
    assert record['accepted'] and record['clean_log'] and record['exit_code']==0
    assert job.sha(path(SAGE))==job.sha(sage_dir/SAGE)==record['source_sha256']
    assert controls['status']=='PASS_SCRIPTED_LOOP_CHRONOLOGY_CONTROLS'
    assert controls['baseline_pass'] and controls['mutations_all_detected']
    reference=path(REFERENCE)
    history=[];directories=sorted((job.BUILD/'jobs').glob('keygen_make*_061_*'),
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
    waits=[pin(p) for p in sorted((job.BUILD/'waits').glob('keygen_make*_061_*/WAIT.jsonl'))]
    tools=['tools/job.py','tools/job_when_available.py','tools/keygen_make_loop_chronology_audit.py',
        'tools/keygen_make_loop_chronology_batch.py','tools/keygen_intermediate_batch.py',
        'tools/keygen_public_first_batch.py','formal/Source3/KeygenLevelsAudit.lean',SAGE]
    for p in tools: committed(p,head)
    committed(REFERENCE,head)
    notes=path(BASE+'_NOTES.md');assert notes.exists()
    result={'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_061','stage':'B1.07',
        'window':'CLOSED_AT_RECOVERABLE_MIDPOINT','b1_07_acceptance':'NOT_MET',
        'stage_result':'PARTIAL_PROOF','status':'IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN',
        'created_utc':datetime.now(timezone.utc).isoformat(),
        'harness':'MiMo V2.6 Pro / xiaomi-token-plan-ams','runner_labels':'Historical labels remain provenance.',
        'proof_head':head,'notes':pin(notes),'entry_pins_receipt':pin(ENTRY),
        'predecessor_files':PREDECESSOR_COUNT,'superseded':superseded,
        'repair':{'finding':'VirtualLegal impossibility (cross-lane, kernel-confirmed): the 060 shape quantified boundedness and distinctness of the virtual address map over ALL Nat block identifiers, an injection Nat -> Fin (2^64); every consumer (Invocation.encoded, invocation_gate/invocation_certificate success paths, small_site_material) was vacuous.',
            'fix':'VirtualLegal is restricted to the finite live-block set (Env.live: six automatic objects, five external argument objects, fk object and scratch); canonical_word_eq/read_unique/small_site_material are transferred with live-block membership side conditions; achievability witnesses virtualLegal_identity/virtualLegal_exists; the refutation no_global_virtual_legal pins the trap kernel-side.',
            'dependent_validation':'ALL consumers re-elaborated and re-audited in this batch (KeygenMakeInvocation full declarations incl. invocation_flow/invocation_teardown/invocation_gate/invocation_certificate and the codec call-site records); earlier batches scanned: no earlier module consumes VirtualLegal/Invocation.encoded or carries the all-Nat legality pattern (the only prior consumer is the sealed 060 audit, preserved byte-identical as history); the consumed INHERITED closure of earlier batches is re-checked by the 061 audit entries.',
            's05_cross_lane':'formal/BoundedAddressObstruction017.lean exports no_global_virtual_legal/no_bounded_nat_injection/finite_map_control (read-only pin, not imported); S05 notes/ROM_INVOCATION_AUDIT_017.md is the finding record.'},
        'accepted_module_checks':modules,
        'audit':{**pin(audit_dir/'SEARCH_AUDIT.json'),'entries_jsonl':pin(audit_dir/'SEARCH_AUDIT_ENTRIES.jsonl'),
            'receipt':pin(audit_dir/'RECEIPTS.json'),'source_inputs':pin(audit_dir/'SOURCE_INPUTS.json'),
            'producer':pin('formal/Source3/KeygenMakeLoopChronologyAudit.lean'),
            'generator':pin('tools/keygen_make_loop_chronology_audit.py'),
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
        'generator_reproduction':pin('.build/levels_061/GENERATOR_CHECK.json'),
        'slot_waits':waits,
        'attempt_details':history,
        'attempt_counts':{s:sum(h['status']==s for h in history)
            for s in ['ACCEPTED','FAILED_RETAINED','PRESTEP_ABORTED_RETAINED','INTERRUPTED_RETAINED']},
        'contracts':{'finite_live_map_legality':'VirtualLegal live vb constrains the LP64 virtual address map only on the finite live-block set (bounded + pairwise distinct there); no_global_virtual_legal pins that the unqualified all-Nat shape is unsatisfiable, and virtualLegal_identity/virtualLegal_exists show the restricted class is achievable.',
            'pointer_uniqueness_transferred':'canonical_word_eq/read_unique/small_site_material hold for canonical pointers whose blocks are live (inputOf_mem_live/publicOf_mem_live/skePtr_mem_live place the invocation blocks in Env.live); the source tie at a segment call site gains the honest srcLive side condition.',
            'loop_chronology_composition':'loop_tail_cells and loop_retry_entry fold the per-retry transport over the whole LoopTrace: on the successful edge the rejected attempts chain to the accepted final attempt, carrying TailCells, the Initial/legal/static facts, the entry frame and the advanced loop counter (i+attempts.length) to the loop output state.',
            'tail_cells_derivation':'entry_tail_cells derives the TailCells class at the loop entry (external argument cells and comp from the executed binding, logn/ter/n profile cells from the prologue under the pinned M0 profile, the six automatic-object cells from the declaration allocation); attempt_tail_cells carries it through every attempt instance; tail_cells_of_loop lands it at the accepted-break state (the encoding-tail entry).',
            'composed_export':'loop_tail_entry composes the loop-trace chronology of the per-retry transport with the TailCells derivation at the accepted-break state.'},
        'open_in_b1_07':['The codec bodies and their write frames are B1.08/09: the exact encoded lengths, the persistence of the stored length words and of the source arrays through later encoder calls, and the bytewise round-trips.',
            'small_site_material now carries the honest side condition site.src.block in Env.live; a downstream derivation of that liveness from the write-then-read history of the ske cells (rather than the readable-word hypothesis) stays with the codec persistence item.',
            'Residue pin of the plan phrase "globals/common call ID/snapshots": the globals, snapshots, bad-flag lifetime and shared call material are instantiated (cert_package_of_call) and tied to the same invocation (invocation_certificate); if the phrase intends an EXPLICIT identifier value beyond the shared derivation, that composition stays OPEN with its intended shape and is not derived or assumed here.'],
        'outside_scope':['B1.08-B1.11 codec bodies/emitted-to-fiber/final replay, B4/B5 probability/availability/PRG/security, OS/Windows/compiler/machine refinement, CT and independent review.'],
        'tools':[pin(p) for p in tools],
        'source_commits':subprocess.check_output(['git','log','--reverse','--format=%H %s',
            '69989f77..'+head,'--',str(job.ROOT.relative_to(job.REPO))],cwd=job.REPO,text=True).splitlines(),
        'origin_main_observed':subprocess.check_output(['git','rev-parse','origin/main'],cwd=job.REPO,text=True).strip(),
        'active_jobs_at_close':[],'push_by_this_worker':False,'review_or_stages_import':False,
        'limits':'Unchanged Lean j1/-M6144,AS12GiB/RSS8GiB,wall1800s,maxHeartbeats2000000,print200000;0/0 streams,Sage preparser. No inherited source or job limits raised.'}
    assert not job.active()
    with path(BASE+'.json').open('x') as stream: json.dump(result,stream,indent=2);stream.write('\n')
    print(json.dumps({'batch':pin(BASE+'.json'),'notes':pin(notes),'audit_entries':len(audit),
        'attempts':len(history),'attempt_counts':result['attempt_counts'],
        'superseded':sorted(superseded)},indent=2))

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
    assert batch['batch']=='BATCH_061' and batch['active_jobs_at_close']==[]
    assert batch['window']=='CLOSED_AT_RECOVERABLE_MIDPOINT' and batch['b1_07_acceptance']=='NOT_MET'
    assert batch['entry_pins_receipt']['sha256']==ENTRY_SHA
    entry,superseded=entry_checked()
    assert batch['superseded']==superseded
    for p,expected in entry['checked'].items():
        check(p,superseded[p]['current_sha256'] if p in superseded else expected)
    inputs=read(batch['audit']['source_inputs']['path'])
    for e in inputs['sources']: check(e['path'],e['sha256'])
    for e in inputs['reused']:
        check(e.get('current_source',e['source']),e['source_sha256']);check(e['artifact'],e['artifact_sha256'])
    assert not job.active()
    result={'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-061','checked':checked,
        'distinct_pinned_files':len(checked),'current_source_inputs':batch['audit']['exports']+
            batch['audit']['inherited_interfaces'],'active_jobs':[],'superseded':superseded,
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
