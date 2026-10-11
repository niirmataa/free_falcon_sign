#!/usr/bin/env python3
"""Seal/verify062's reachable-state certificate-premise repair and ske-cell
liveness, preserving015--061 and the recorded supersessions."""
from contextlib import redirect_stdout
from datetime import datetime, timezone
from io import StringIO
from pathlib import Path
import json
import shutil
import subprocess
import sys

import job
import keygen_make_certificate_premises_audit as producer
from keygen_intermediate_batch import path, read, pin, committed, streams
from keygen_public_first_batch import write_receipt

BASE='notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_062'
ENTRY='.build/levels_062/ENTRY_PINS_062.json'
ENTRY_SHA='e6f33de2b0bdf4172750eea00c9af550b88b73cdf14d629ab508b82082ad7a54'
SAGE='sage/check_keygen_make_certificate_premises.sage'
MODULES=['KeygenMakeCertificatePremises','KeygenMakeSkeCells']
AUDIT_MODULE='KeygenMakeCertificatePremisesAudit'
PRESEAL='.build/levels_062/PRESEAL.json'
REFERENCE='../../../../../Extra/c/falcon-keygen.c'
PREDECESSOR_COUNT=12164
PREDECESSOR_INPUTS=333
RECORDED_SUPERSESSIONS=2
SUPERSEDED={}
CAUSES={
    'keygen_make_certificate_premises_062_001':'First elaboration of the two repair modules REJECTED (retained): the index-filling `cases` binder of `AttemptExec.throughCertificate` binds nothing (the gateOut slot is the result index), the workspace bridge helper lives in KeygenMakeCertMaterial (not KeygenMakeCertCall), and unused signature binders tripped the linter.',
    'keygen_make_certificate_premises_062_002':'Second elaboration: the premises module ACCEPTED; the ske-cells module REJECTED (retained): unopened KeygenMakeInvocation names, the invalid `⟨s with ...⟩` anonymous-constructor syntax (structure update needs `{s with ...}`), and the index-filling `Load64.load` pattern binders (4 visible binders, not 6).',
    'keygen_make_ske_cells_062_003':'Third elaboration REJECTED (retained): `List.mem_cons_self`/`List.mem_cons_of_mem` take implicit arguments in this Mathlib closure; the explicit applications were invalid. Replaced with the `List.mem_cons.mpr` forms.'}

def entry_checked():
    assert not job.active(),'A proof job is active'
    assert job.sha(path(ENTRY))==ENTRY_SHA
    entry=read(ENTRY)
    assert entry['batch']=='BATCH_015-061'
    assert entry['distinct_pinned_files']==len(entry['checked'])==PREDECESSOR_COUNT
    assert entry['current_source_inputs']==PREDECESSOR_INPUTS and entry['active_jobs']==[]
    assert len(entry['superseded'])==RECORDED_SUPERSESSIONS,sorted(entry['superseded'])
    superseded={}
    for p,expected in entry['checked'].items():
        actual=job.sha(path(p))
        if actual==expected: continue
        assert p in SUPERSEDED and SUPERSEDED[p]==expected,('predecessor changed',p)
        superseded[p]={'superseded_sha256':expected,'current_sha256':actual,'reason':'see batch receipt'}
    assert set(superseded)==set(SUPERSEDED),('unexpected supersession set',sorted(superseded))
    return entry,superseded

def predecessor(target):
    entry,superseded=entry_checked()
    result={'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-062','checked':entry['checked'],
        'distinct_pinned_files':PREDECESSOR_COUNT,'entry':pin(ENTRY),'active_jobs':[],'superseded':superseded,
        'recorded_supersessions':entry['superseded'],'verifier_sha256':job.sha(Path(__file__))}
    print(json.dumps({'predecessor_files':PREDECESSOR_COUNT,'superseded':superseded,
        'receipt':write_receipt(target,result)},indent=2))

def generator_check():
    dest=path('.build/levels_062/audit_generator')
    dest.mkdir(parents=True,exist_ok=False)
    for name in producer.MODULES+['KeygenLevelsAudit']:
        target=dest/'formal/Source3'/(name+'.lean');target.parent.mkdir(parents=True,exist_ok=True)
        shutil.copyfile(path('formal/Source3/'+name+'.lean'),target)
    original=producer.ROOT;printed=StringIO()
    try:
        producer.ROOT=dest
        with redirect_stdout(printed): producer.main()
    finally:
        producer.ROOT=original
    target=dest/'formal/Source3/KeygenMakeCertificatePremisesAudit.lean'
    source=path('formal/Source3/KeygenMakeCertificatePremisesAudit.lean')
    assert source.read_bytes()==target.read_bytes()
    result={'utc':datetime.now(timezone.utc).isoformat(),'status':'BYTE_EXACT_AUDIT_PRODUCER_REPRODUCTION',
        'producer':pin('tools/keygen_make_certificate_premises_audit.py'),'source':pin(source),
        'reproduced':pin(target),'generator_output':printed.getvalue()}
    print(json.dumps(write_receipt('.build/levels_062/GENERATOR_CHECK.json',result),indent=2))

def seal():
    assert not path(BASE+'.json').exists(),'Never replace a historical pair'
    entry,superseded=entry_checked()
    head=subprocess.check_output(['git','rev-parse','HEAD'],cwd=job.REPO,text=True).strip()
    assert subprocess.check_output(['git','branch','--show-current'],cwd=job.REPO,text=True).strip()=='main'
    preseal=read(PRESEAL)
    assert preseal['checked']==entry['checked'] and preseal['verifier_sha256']==job.sha(Path(__file__))
    assert preseal['superseded']==superseded
    generated=read('.build/levels_062/GENERATOR_CHECK.json')
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
    for directory in sorted((job.BUILD/'jobs').glob('keygen_make_certificate_premises_sage_062_*')):
        if (directory/'CERT_CONTROL_CHECK.json').exists(): sage_dir=directory
    assert sage_dir is not None,'missing sage controls job'
    controls=read(sage_dir/'CERT_CONTROL_CHECK.json');record=read(sage_dir/'RECEIPTS.json')[0]
    assert record['accepted'] and record['clean_log'] and record['exit_code']==0
    assert job.sha(path(SAGE))==job.sha(sage_dir/SAGE)==record['source_sha256']
    assert controls['status']=='PASS_SCRIPTED_CERTIFICATE_PREMISE_CONTROLS'
    assert controls['baseline_pass'] and controls['mutations_all_detected']
    reference=path(REFERENCE)
    history=[];directories=sorted((job.BUILD/'jobs').glob('keygen_make*_062_*'),
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
    waits=[pin(p) for p in sorted((job.BUILD/'waits').glob('keygen_make*_062_*/WAIT.jsonl'))]
    tools=['tools/job.py','tools/job_when_available.py','tools/keygen_make_certificate_premises_audit.py',
        'tools/keygen_make_certificate_premises_batch.py','tools/keygen_intermediate_batch.py',
        'tools/keygen_public_first_batch.py','formal/Source3/KeygenLevelsAudit.lean',SAGE]
    for p in tools: committed(p,head)
    committed(REFERENCE,head)
    notes=path(BASE+'_NOTES.md');assert notes.exists()
    result={'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_062','stage':'B1.07',
        'window':'CLOSED_AT_RECOVERABLE_MIDPOINT','b1_07_acceptance':'NOT_MET',
        'stage_result':'PARTIAL_PROOF','status':'IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN',
        'created_utc':datetime.now(timezone.utc).isoformat(),
        'harness':'MiMo V2.6 Pro / xiaomi-token-plan-ams','runner_labels':'Historical labels remain provenance.',
        'proof_head':head,'notes':pin(notes),'entry_pins_receipt':pin(ENTRY),
        'predecessor_files':PREDECESSOR_COUNT,'superseded':superseded,
        'recorded_supersessions':entry['superseded'],
        'repair':{'finding':'The 060/061 `invocation_certificate` consumed the two global quantifiers `(s : State) → Dimensions s` and `(s : State) → LegalWorkspace s env.ctx`. The first is UNSATISFIABLE (kernel refutation `empty_locals_not_dimensions`/`no_global_dimensions`, mirroring the S05 cross-lane witness GlobalDimensionsObstruction017 at commit ef354c48, pinned read-only and never imported), so the success branch of the theorem was vacuous.',
            'fix':'Both quantifiers are replaced with reachable-state derivations along the execution chronology: `attempt_gate_dimensions`/`attempt_gate_reachable` transport the `Remaining` instance to the certificate-gate state of one accepted attempt and `loop_gate_reachable` folds that transport over the whole capped loop (entry facts from `entry_of_allocation`/`entry_dimensions`/`entry_remaining`); `gate_workspace` derives `LegalWorkspace` at the same reachable state from the transported scratch legality and automatic-object space (`space_of_frame`), the allocation `Shape` and the gate bind bridge (`workspace_scratch_block` fixes ctx.scratch.block=0 per bind).',
            'exports':'`invocation_certificate_reachable` (decomposition level) and `invocation_certificate_of_entry` (whole-invocation level) conclude the accepted certificate call and its complete `CertPackage` with premises reduced to reachable entry facts (`Original` + space at the readiness-prefix boundary, the workspace `Shape`, the named `CertEntryFrame` residual) -- no all-state quantifier, no codec premise.',
            's05_cross_lane':'formal/GlobalDimensionsObstruction017.lean exports no_global_dimensions/empty_locals_not_dimensions (read-only pin of commit ef354c48, not imported); the in-module kernel mirror pins the trap the way 061 pinned no_global_virtual_legal.'},
        'ske_cells':{'class':'SkeCellWord -- the write-then-read content of the ske cell of segment i (the LP64 word of the material pointer); created by `ske_word_of_bind` at the executed ske[i] store and transported by `ske_word_of_store_frame`/`load64_of_store_frame` across foreign-cell stores.',
            'derived_liveness':'`small_site_src_live` derives `site.src.block in env.live` from the cell history plus the PINNED explicit live-set extension (map legality on site.src.block::env.live, the 061 module prescription "consumers needing a further block extend the live set explicitly"); `small_site_material_extended` supersedes the 061 side condition with the derived tie `site.src = inputOf env i`; `small_site_legal_exists` is the achievability witness of the extension class.',
            'alias_note':'Word-level aliasing outside the live set is real: VirtualLegal leaves such blocks unconstrained, so the extension is explicit and required, never hidden.'},
        'accepted_module_checks':modules,
        'audit':{**pin(audit_dir/'SEARCH_AUDIT.json'),'entries_jsonl':pin(audit_dir/'SEARCH_AUDIT_ENTRIES.jsonl'),
            'receipt':pin(audit_dir/'RECEIPTS.json'),'source_inputs':pin(audit_dir/'SOURCE_INPUTS.json'),
            'producer':pin('formal/Source3/KeygenMakeCertificatePremisesAudit.lean'),
            'generator':pin('tools/keygen_make_certificate_premises_audit.py'),
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
        'generator_reproduction':pin('.build/levels_062/GENERATOR_CHECK.json'),
        'slot_waits':waits,
        'attempt_details':history,
        'attempt_counts':{s:sum(h['status']==s for h in history)
            for s in ['ACCEPTED','FAILED_RETAINED','PRESTEP_ABORTED_RETAINED','INTERRUPTED_RETAINED']},
        'contracts':{'reachable_gate_dimensions':'The certificate-gate state of an accepted attempt carries the DERIVED `Dimensions` instance: the `Remaining` counter transports through the sampled prefix (`attempt_gate_dimensions`) and the whole loop chronology (`loop_gate_reachable`), starting from the allocation-derived entry facts.',
            'reachable_workspace':'`LegalWorkspace` at the gate state is CONSTRUCTED by `gate_workspace` from the transported scratch legality + automatic-object space + the bind bridge block numbering + the allocation Shape; the all-state quantifier is never used.',
            'premise_repair_export':'`invocation_certificate_reachable`/`invocation_certificate_of_entry` keep the exact `invocation_certificate` conclusion with reachable entry premises; every remaining premise class is reachable and achievable.',
            'trap_pin':'`no_global_dimensions`/`empty_locals_not_dimensions` pin the impossible-premise class kernel-side in the repaired module.',
            'derived_liveness':'`small_site_src_live` derives `site.src.block in env.live` from the ske cell history + the explicit live-set extension; `small_site_material_extended` replaces the 061 side condition.'},
        'open_in_b1_07':['The concrete statement-chain extraction of `SkeCellWord` at the four call sites (the nine pre-loop statements reaching the four-segment loop entry) and the persistence of the cell words through the earlier codec calls of segments 1-3 stay with the codec write-frame item (B1.08/09); the store-level creation/transport and the derived liveness are closed here.',
            'The codec bodies and their write frames are B1.08/09: the exact encoded lengths, the persistence of the stored length words and of the source arrays through later encoder calls, and the bytewise round-trips.',
            'Residue pin of the plan phrase "globals/common call ID/snapshots": instantiated and tied to the same invocation (060/061); an EXPLICIT identifier value beyond the shared derivation stays OPEN with its intended shape.',
            'The literal refutation status of the all-state `LegalWorkspace` quantifier is not consumed: the repair replaces it with the reachable derivation `gate_workspace` either way.'],
        'outside_scope':['B1.08-B1.11 codec bodies/emitted-to-fiber/final replay, B4/B5 probability/availability/PRG/security, OS/Windows/compiler/machine refinement, CT and independent review.'],
        'tools':[pin(p) for p in tools],
        'source_commits':subprocess.check_output(['git','log','--reverse','--format=%H %s',
            '09491ff4..'+head,'--',str(job.ROOT.relative_to(job.REPO))],cwd=job.REPO,text=True).splitlines(),
        'origin_main_observed':subprocess.check_output(['git','rev-parse','origin/main'],cwd=job.REPO,text=True).strip(),
        'active_jobs_at_close':[],'push_by_this_worker':False,'review_or_stages_import':False,
        'limits':'Unchanged Lean j1/-M6144,AS12GiB/RSS8GiB,wall1800s,maxHeartbeats2000000,print200000;0/0 streams,Sage preparser. No inherited source or job limits raised.'}
    assert not job.active()
    with path(BASE+'.json').open('x') as stream: json.dump(result,stream,indent=2);stream.write('\n')
    print(json.dumps({'batch':pin(BASE+'.json'),'notes':pin(notes),'audit_entries':len(audit),
        'attempts':len(history),'attempt_counts':result['attempt_counts'],
        'superseded':sorted(superseded),'recorded_supersessions':len(entry['superseded'])},indent=2))

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
    assert batch['batch']=='BATCH_062' and batch['active_jobs_at_close']==[]
    assert batch['window']=='CLOSED_AT_RECOVERABLE_MIDPOINT' and batch['b1_07_acceptance']=='NOT_MET'
    assert batch['entry_pins_receipt']['sha256']==ENTRY_SHA
    entry,superseded=entry_checked()
    assert batch['superseded']==superseded
    assert batch['recorded_supersessions']==entry['superseded']
    for p,expected in entry['checked'].items():
        check(p,superseded[p]['current_sha256'] if p in superseded else expected)
    inputs=read(batch['audit']['source_inputs']['path'])
    for e in inputs['sources']: check(e['path'],e['sha256'])
    for e in inputs['reused']:
        check(e.get('current_source',e['source']),e['source_sha256']);check(e['artifact'],e['artifact_sha256'])
    assert not job.active()
    result={'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-062','checked':checked,
        'distinct_pinned_files':len(checked),'current_source_inputs':batch['audit']['exports']+
            batch['audit']['inherited_interfaces'],'active_jobs':[],'superseded':superseded,
        'recorded_supersessions':entry['superseded'],'verifier_sha256':job.sha(Path(__file__))}
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
