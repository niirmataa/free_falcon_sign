#!/usr/bin/env python3
"""Seal/verify052's workspace-relocation midpoint, preserving015--051."""
from contextlib import redirect_stdout
from datetime import datetime, timezone
from io import StringIO
from pathlib import Path
import json
import shutil
import subprocess
import sys

import job
import keygen_make_workspace_audit as producer
from keygen_intermediate_batch import path, read, pin, committed, streams
from keygen_public_first_batch import write_receipt

BASE='notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_052'
ENTRY='.build/levels_052/ENTRY_PINS_052.json'
ENTRY_SHA='bd2d5a2dce91626469a78463c6965b07f844dbda8e288408cb04886117fbcf35'
SAGE='sage/check_keygen_make_workspace.sage'
MODULES=['KeygenMakeWorkspaceRelocation','KeygenMakeWorkspaceBridge',
    'KeygenMakeWorkspaceTables','KeygenMakeWorkspaceExtent']
AUDIT_MODULE='KeygenMakeWorkspaceAudit'
PRESEAL='.build/levels_052/PRESEAL.json'
REFERENCE='../../../../../Extra/c/falcon-keygen.c'
CAUSES={
    'keygen_make_workspace_relocation_052_001':'First draft used whole-memory equalities where function-field equalities were required and a leftover transport stub; several frame rewritings missed the double swapBlock normalization. Rejected snapshot retained.',
    'keygen_make_workspace_relocation_052_002':'Remaining projection parenthesis slips (swapPtr b p.block vs (swapPtr b p).block), a single-instance rw in the memcpy copy component and a leftover goal after rw closed the relocation-of-extent goal. Rejected snapshot retained.',
    'keygen_make_workspace_bridge_052_001':'Structure-instance literals with projection values failed to parse in this toolchain and the bridge iff had a reversed congrArg direction; switching to explicit constructor forms. Rejected snapshot retained.',
    'keygen_make_workspace_bridge_052_002':'Unused simp arguments on the pointer transport chains and the Option.map rewrite order in the state relocation; parse of the with-forms replaced by where-forms. Rejected snapshot retained.',
    'keygen_make_workspace_bridge_052_003':'omega could not prove the workspace extent goal through the nonlinear elementBytes*count products; substituting the pinned width first restores linearity. Rejected snapshot retained.',
    'keygen_make_workspace_tables_052_001':'Option.some.inj needs the equality orientation of its result type and the outer ite split has two branches; the extra third branch was rejected. Rejected snapshot retained.',
    'keygen_make_workspace_tables_052_002':'One leftover no-goal bullet after the nested split closed the none inversion. Rejected snapshot retained.',
    'keygen_make_workspace_extent_052_001':'The candidate count literal was wrong and List.maximum lacked the Decidable synthesis in this configuration; the fold-max formulation closes the same kernel fact. Rejected snapshot retained.',
    'keygen_make_workspace_sage_052_001':'The transcription-drift entry recorded the baseline comparison instead of a mutated transcription; the control now perturbs the extracted statements and requires detection. Rejected run retained.'}

def entry_checked():
    assert not job.active(),'A proof job is active'
    assert job.sha(path(ENTRY))==ENTRY_SHA
    entry=read(ENTRY)
    assert entry['batch']=='BATCH_015-051'
    assert entry['distinct_pinned_files']==len(entry['checked'])==11149
    assert entry['current_source_inputs']==126 and entry['active_jobs']==[] and entry['superseded']=={}
    for p,expected in entry['checked'].items(): assert job.sha(path(p))==expected,('predecessor changed',p)
    return entry

def predecessor(target):
    entry=entry_checked()
    result={'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-051','checked':entry['checked'],
        'distinct_pinned_files':11149,'entry':pin(ENTRY),'active_jobs':[],'superseded':{},
        'verifier_sha256':job.sha(Path(__file__))}
    print(json.dumps({'predecessor_files':11149,'receipt':write_receipt(target,result)},indent=2))

def generator_check():
    dest=path('.build/levels_052/audit_generator')
    dest.mkdir(parents=True,exist_ok=False)
    for name in producer.MODULES+['KeygenLevelsAudit']:
        target=dest/'formal/Source3'/(name+'.lean');target.parent.mkdir(parents=True,exist_ok=True)
        shutil.copyfile(path('formal/Source3/'+name+'.lean'),target)
    original=producer.ROOT;printed=StringIO()
    try:
        producer.ROOT=dest
        with redirect_stdout(printed): producer.main()
    finally: producer.ROOT=original
    target=dest/'formal/Source3/KeygenMakeWorkspaceAudit.lean'
    source=path('formal/Source3/KeygenMakeWorkspaceAudit.lean')
    assert source.read_bytes()==target.read_bytes()
    result={'utc':datetime.now(timezone.utc).isoformat(),'status':'BYTE_EXACT_AUDIT_PRODUCER_REPRODUCTION',
        'producer':pin('tools/keygen_make_workspace_audit.py'),'source':pin(source),'reproduced':pin(target),
        'generator_output':printed.getvalue()}
    print(json.dumps(write_receipt('.build/levels_052/GENERATOR_CHECK.json',result),indent=2))

def seal():
    assert not path(BASE+'.json').exists(),'Never replace a historical pair'
    entry=entry_checked()
    head=subprocess.check_output(['git','rev-parse','HEAD'],cwd=job.REPO,text=True).strip()
    assert subprocess.check_output(['git','branch','--show-current'],cwd=job.REPO,text=True).strip()=='main'
    preseal=read(PRESEAL)
    assert preseal['checked']==entry['checked'] and preseal['verifier_sha256']==job.sha(Path(__file__))
    generated=read('.build/levels_052/GENERATOR_CHECK.json')
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
        assert job.sha(artifact)==job.sha(path(current['artifact']))==record['artifact_sha256']==current['artifact_sha256']
        for imported,expected in current.get('imports',{}).items():
            assert cache[imported]['artifact_sha256']==expected,(module,imported)
        modules.append({'module':module,'source':pin(source),'snapshot':pin(snapshot),'artifact':pin(artifact),
            'cache_artifact':pin(current['artifact']),'receipt':pin(current['receipt']),
            'source_inputs':pin(directory/'SOURCE_INPUTS.json'),'logs':streams(directory,record,True),
            'imports':current.get('imports',{}),'elapsed_s':record['elapsed_s'],
            'maxrss_kib':record['cumulative_child_maxrss_kib']})
    audit_dir=path(cache['Source3.KeygenMakeWorkspaceAudit']['receipt']).parent;audit=read(audit_dir/'SEARCH_AUDIT.json')
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
    for directory in sorted((job.BUILD/'jobs').glob('keygen_make_workspace_sage_052_*')):
        sage_dir=directory
    assert sage_dir is not None,'missing sage controls job'
    controls=read(sage_dir/'CERT_CONTROL_CHECK.json');record=read(sage_dir/'RECEIPTS.json')[0]
    assert record['accepted'] and record['clean_log'] and record['exit_code']==0
    assert job.sha(path(SAGE))==job.sha(sage_dir/SAGE)==record['source_sha256']
    assert controls['status']=='PASS_SCRIPTED_WORKSPACE_CONTROLS'
    assert controls['baseline_pass'] and controls['mutations_all_detected']
    reference=path(REFERENCE)
    history=[];directories=sorted((job.BUILD/'jobs').glob('keygen_make_*_052_*'),
        key=lambda d: read(d/'RECEIPTS.json')[0]['start'])
    for directory in directories:
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
        if h['status']=='FAILED_RETAINED' and not h['cause']:
            h['cause']='Retained failure without a sealed cause entry; see raw logs.'
    tools=['tools/job.py','tools/job_when_available.py','tools/keygen_make_workspace_audit.py',
        'tools/keygen_make_workspace_batch.py','tools/keygen_intermediate_batch.py',
        'tools/keygen_public_first_batch.py','formal/Source3/KeygenLevelsAudit.lean',SAGE]
    for p in tools: committed(p,head)
    committed(REFERENCE,head)
    notes=path(BASE+'_NOTES.md');assert notes.exists()
    result={'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_052','stage':'B1.07',
        'window':'CLOSED_AT_RECOVERABLE_MIDPOINT','b1_07_acceptance':'NOT_MET',
        'stage_result':'PARTIAL_PROOF','status':'IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN',
        'created_utc':datetime.now(timezone.utc).isoformat(),
        'harness':'MiMo V2.6 Pro / xiaomi-token-plan-ams','runner_labels':'Historical labels remain provenance.',
        'proof_head':head,'notes':pin(notes),'entry_pins_receipt':pin(ENTRY),'predecessor_files':11149,
        'superseded':{},'accepted_module_checks':modules,
        'audit':{**pin(audit_dir/'SEARCH_AUDIT.json'),'entries_jsonl':pin(audit_dir/'SEARCH_AUDIT_ENTRIES.jsonl'),
            'receipt':pin(audit_dir/'RECEIPTS.json'),'source_inputs':pin(audit_dir/'SOURCE_INPUTS.json'),
            'producer':pin('formal/Source3/KeygenMakeWorkspaceAudit.lean'),
            'generator':pin('tools/keygen_make_workspace_audit.py'),
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
        'generator_reproduction':pin('.build/levels_052/GENERATOR_CHECK.json'),
        'attempt_details':history,
        'attempt_counts':{s:sum(h['status']==s for h in history) for s in ['ACCEPTED','FAILED_RETAINED']},
        'contracts':{'relocation':'A block transposition moves the general fk->tmp scratch descriptor into the certificate block0; Allocated/Load/Store/Memcpy/Initialized/Preserves/Steps are preserved and reflected (iff).',
            'bridge':'workspacePointer base 0 = fprCast p iff (p.block=0 and base=p.offset and extent p/8=35840); after relocation the block condition is derived, and the extent condition is discharged by the pinned workspace reservation.',
            'binding':'CertBind is assembled from the caller cell bindings plus source facts (Shape extent/alignment, block0); cert_bind_relocated derives it in the canonical relocated world with NO bridge input.',
            'tables':'The M0 table dispatch puts the static tables exactly in blocks 1 and 2 (split inversion); CallerFrame is consumed on any other live foreign block, including workspace block0.',
            'extent':'The pinned temp_size reservation candidate equals CertificateWorkspace.bytes (286720 bytes =35840 fpr words) and dominates every other mirrored candidate of the body at (logn=10, ternary=1).'},
        'open_in_b1_07':['Deriving the Shape extent/alignment facts from the enclosing allocation execution (temp_size + fk->tmp malloc binding in the caller world); the reservation witness is now exact but not yet extracted from a source execution.',
            'Transport of the certificate body derivation (CertificateM0Environment.Exec, hence Call/CertificateGate) across the block relocation, or a block-generalized certificate layout; this is the only step between the discharged bridge and the relocated six-gate composition.',
            'Solver-call h frame and full six-gate SAME-h/equation composition on one material witness; accepted physical material through the encoding tail (B1.08/09 codec bodies).',
            'Initial/legal/static frame transport for every retry instance, whole enclosing invocation composition for all later returns, and actual globals/common call ID/snapshots composition beyond the pinned Pinned input.'],
        'outside_scope':['B1.08–B1.11 codec bodies/emitted-to-fiber/final replay, B4/B5 probability/availability/PRG/security, OS/Windows/compiler/machine refinement, CT and independent review.'],
        'tools':[pin(p) for p in tools],
        'source_commits':subprocess.check_output(['git','log','--reverse','--format=%H %s',
            '2d2cdf52..'+head,'--',str(job.ROOT.relative_to(job.REPO))],cwd=job.REPO,text=True).splitlines(),
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
    assert batch['batch']=='BATCH_052' and batch['superseded']=={} and batch['active_jobs_at_close']==[]
    assert batch['window']=='CLOSED_AT_RECOVERABLE_MIDPOINT' and batch['b1_07_acceptance']=='NOT_MET'
    assert batch['entry_pins_receipt']['sha256']==ENTRY_SHA
    for p,expected in entry_checked()['checked'].items(): check(p,expected)
    inputs=read(batch['audit']['source_inputs']['path'])
    for e in inputs['sources']: check(e['path'],e['sha256'])
    for e in inputs['reused']:
        check(e.get('current_source',e['source']),e['source_sha256']);check(e['artifact'],e['artifact_sha256'])
    assert not job.active()
    result={'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-052','checked':checked,
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
        verify(*sys.argv[2:])
