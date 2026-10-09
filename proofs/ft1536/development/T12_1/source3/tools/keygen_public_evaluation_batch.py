#!/usr/bin/env python3
"""Seal/verify BATCH_042, preserving015–041 and all042 attempts verbatim."""
from datetime import datetime, timezone
from pathlib import Path
import json
import subprocess
import sys

import job
from keygen_intermediate_batch import path, read, pin, committed, streams
from keygen_public_first_batch import write_receipt
from keygen_public_evaluation_audit_source import MODULES, INHERITED, declarations

BASE = 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_042'
ENTRY = '.build/levels_042/ENTRY_PINS_042.json'
ENTRY_SHA = '9d32b6d8b6d4ed3636da57a34c92bee066d6fd4d126b7889b017e8fe774aedc2'
PRESEAL = '.build/levels_042/PRESEAL.json'
CONTROL = '.build/jobs/keygen_public_evaluation_checks_042_002'
SAGE = 'sage/check_keygen_public_evaluation.sage'
INTERRUPTED = 'keygen_public_radix_polynomial_042_001'
INTERRUPTION = '.build/levels_042/INTERRUPTED_POLYNOMIAL_001.json'
FAILURES = {
    'keygen_public_radix_program_042_001': 'SizeOps: reserved variable identifier and unsimplified generic bindValue initializer.',
    'keygen_public_radix_row_042_001': 'Reserved initialize identifier; replace the own local proof name.',
    'keygen_public_radix_rows_042_001': 'Explicit Option Value witness needed for the post-row v declaration.',
    'keygen_public_radix_rows_042_002': 'UnnecessarySeqFocus linter; use sequenced tactics without suppression.',
    'keygen_public_radix_polynomial_042_002': 'Implicit coefficient congruence and an imprecise block-base match exhausted the unchanged heartbeat limit. Exact natural-index rewrites and explicit evaluation types close003.',
    'keygen_public_radix_polynomial_042_003': 'Polynomial and TripleProgram accepted; TripleExpr used bare numeral word arguments instead of the exact named modulus/inverse words.',
    'keygen_public_triple_values_042_001': 'TripleExpr/ValueLists accepted; TripleValues needed complete membership simplification, total getD statements instead of missing Inhabited, explicit Known pairs and declaration-local transport.',
    'keygen_public_triple_fold_042_001': 'Overbroad counter convert and opaque Cells simplification; exact index rewrite and pointwise cell proof fix the goals.',
    'keygen_public_evaluation_checks_042_001': 'All arithmetic assertions reached serialization; two Sage Integer metadata literals were not JSON serializable. Convert those fields with int; preserve001.'}


def entry_checked():
    assert not job.active(), 'A proof job is active'
    assert job.sha(path(ENTRY)) == ENTRY_SHA
    entry = read(ENTRY)
    assert entry['batch'] == 'BATCH_015-041'
    assert entry['distinct_pinned_files'] == len(entry['checked']) == 7417
    assert entry['current_source_inputs'] == 633 and entry['active_jobs'] == [] and entry['superseded'] == {}
    for p, expected in entry['checked'].items():
        assert job.sha(path(p)) == expected, ('predecessor changed', p)
    return entry


def predecessor(target):
    entry = entry_checked()
    result = {'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-041',
        'checked':entry['checked'],'distinct_pinned_files':7417,'entry':pin(ENTRY),
        'active_jobs':[],'superseded':{},'verifier_sha256':job.sha(Path(__file__))}
    print(json.dumps({'predecessor_files':7417,'receipt':write_receipt(target,result)},indent=2))


def seal():
    assert not path(BASE+'.json').exists(), 'Never replace a historical pair'
    entry = entry_checked()
    head = subprocess.check_output(['git','rev-parse','HEAD'],cwd=job.REPO,text=True).strip()
    assert subprocess.check_output(['git','branch','--show-current'],cwd=job.REPO,text=True).strip() == 'main'
    assert read(PRESEAL)['checked'] == entry['checked']
    assert read(PRESEAL)['verifier_sha256'] == job.sha(Path(__file__))
    cache = read('.build/cache/CACHE_INDEX.json')
    modules = []
    for name in MODULES+['KeygenPublicEvaluationAudit']:
        module = 'Source3.'+name
        current = cache[module]
        source = path(current['source']); receipt = path(current['receipt']); directory = receipt.parent
        committed(source,head)
        record = next(r for r in read(receipt) if r['name'] == module.replace('.','_'))
        assert record['accepted'] and record['clean_log'] and record['exit_code'] == 0
        assert record['forbidden_proof_markers'] == [] and record['cumulative_child_maxrss_kib'] <= 8*1024*1024
        snapshot = directory/'formal/Source3'/(name+'.lean'); artifact = directory/'lib/Source3'/(name+'.olean')
        assert job.sha(source) == job.sha(snapshot) == record['source_sha256'] == current['source_sha256']
        assert job.sha(artifact) == job.sha(path(current['artifact'])) == record['olean_sha256'] == current['artifact_sha256']
        for imported, expected in current.get('imports',{}).items():
            if imported in cache: assert cache[imported]['artifact_sha256'] == expected, (module,imported)
        modules.append({'module':module,'source':pin(source),'snapshot':pin(snapshot),'artifact':pin(artifact),
            'cache_artifact':pin(current['artifact']),'receipt':pin(receipt),'source_inputs':pin(directory/'SOURCE_INPUTS.json'),
            'logs':streams(directory,record,True),'imports':current.get('imports',{}),
            'elapsed_s':record['elapsed_s'],'maxrss_kib':record['cumulative_child_maxrss_kib']})
    audit_dir = path(cache['Source3.KeygenPublicEvaluationAudit']['receipt']).parent
    audit = read(audit_dir/'PUBLIC_EVALUATION_AUDIT.json')
    assert len(audit) == len({e['name'] for e in audit}) == len(declarations())+len(INHERITED) == 607
    assert {e['name'] for e in audit} == set(declarations()) | set(INHERITED)
    assert (audit_dir/'PUBLIC_EVALUATION_AUDIT_ENTRIES.jsonl').read_text().count('\n') == len(audit)
    for e in audit:
        assert set(e['axioms']) <= {'propext','Classical.choice','Quot.sound'}, e['name']
        assert '⋯' not in json.dumps(e,ensure_ascii=False), e['name']
        if e['body']['kind'] == 'definition_or_theorem': assert e['body']['term'], e['name']
        else: assert e['body']['kind'] == 'kernel_inductive' and e['body']['constructors'], e['name']
    inputs = read(audit_dir/'SOURCE_INPUTS.json')
    for e in inputs['sources']: assert job.sha(path(e['path'])) == e['sha256'], e['path']
    for e in inputs['reused']:
        assert job.sha(path(e.get('current_source',e['source']))) == e['source_sha256'], e['module']
        assert job.sha(path(e['artifact'])) == e['artifact_sha256'], e['module']
    control_dir = path(CONTROL); controls = read(control_dir/'PUBLIC_EVALUATION_CHECK.json')
    control_record = read(control_dir/'RECEIPTS.json')[0]
    assert control_record['accepted'] and control_record['clean_log'] and control_record['exit_code'] == 0
    committed(SAGE,head)
    assert job.sha(path(SAGE)) == job.sha(control_dir/SAGE) == control_record['source_sha256']
    assert controls['status'] == 'PASS_FINITE_INVARIANT_CONTROLS'
    assert (controls['physical_evaluations'],controls['block_remainders'],controls['root_tree_laws']) == (122880,8176,13824)
    assert controls['vectors'] == 8 and controls['inherited_C_UBSan_runs_rehashed'] == 12 and controls['new_C_executions'] == 0
    assert len(controls['negative_controls']) == 8
    for name in ['wrong_order_detected','wrong_scale_detected']:
        assert any(v[name] for v in controls['negative_controls'])
    inherited_controls = []
    for p, expected in controls['predecessor_pins'].items():
        assert job.sha(path(p)) == expected, p
        inherited_controls.append(pin(p))
    source_pins = []
    for name, expected in controls['source_pins'].items():
        p = job.REPO/'Extra/c'/name
        assert job.sha(p) == expected, p
        source_pins.append(pin(p))
    history = []
    directories = sorted((job.BUILD/'jobs').glob('keygen_public_*_042_*'))
    for directory in directories:
        inventory = read(directory/'SOURCE_INPUTS.json')
        snapshots = []
        for e in inventory['sources']:
            rel = 'formal/'+e['module'].replace('.','/')+'.lean' if 'module' in e else 'sage/'+Path(e['path']).name
            p = directory/rel
            assert job.sha(p) == e['sha256'], p
            snapshots.append(pin(p))
        for e in inventory['reused']:
            assert job.sha(path(e.get('current_source',e['source']))) == e['source_sha256'], ('superseded source',directory,e['module'])
            assert job.sha(path(e['artifact'])) == e['artifact_sha256'], ('superseded artifact',directory,e['module'])
        interrupted = directory.name == INTERRUPTED
        if interrupted:
            assert not (directory/'RECEIPTS.json').exists()
            assert read(INTERRUPTION)['status'] == 'INTERRUPTED_BY_TOOL_TIMEOUT'
            records = []; status = 'INTERRUPTED_RETAINED'
        else:
            records = read(directory/'RECEIPTS.json')
            status = 'FAILED_RETAINED' if any(not r['accepted'] for r in records) else 'ACCEPTED'
            assert (directory.name in FAILURES) == (status == 'FAILED_RETAINED'), directory.name
        products = []
        for r in records:
            if 'olean_sha256' in r:
                module = r['name'].replace('Source3_','Source3.',1)
                artifact = directory/'lib'/(module.replace('.','/')+'.olean')
                snapshot = directory/'formal'/(module.replace('.','/')+'.lean')
                assert job.sha(artifact) == r['olean_sha256'] and job.sha(snapshot) == r['source_sha256']
                products.append(pin(artifact))
        wait = job.BUILD/'waits'/directory.name/'WAIT.jsonl'
        history.append({'job':directory.name,'status':status,'cause':FAILURES.get(directory.name),
            'receipt':pin(directory/'RECEIPTS.json') if not interrupted else None,
            'interruption':pin(INTERRUPTION) if interrupted else None,
            'source_inputs':pin(directory/'SOURCE_INPUTS.json'),'preflight':pin(directory/'PREFLIGHT.json'),
            'runner_snapshot':pin(directory/'RUNNER_SOURCE.py'),'execution_snapshot':pin(directory/'EXECUTION_SOURCE.py'),
            'wait_log':pin(wait) if wait.exists() else None,'snapshots':snapshots,'accepted_products':products,
            'raw_files':[pin(p) for p in sorted((directory/'logs').iterdir()) if p.is_file()],
            'steps':[{'name':r['name'],'accepted':r['accepted'],'exit_code':r['exit_code'],
                'elapsed_s':r['elapsed_s'],'maxrss_kib':r['cumulative_child_maxrss_kib'],
                'source_sha256':r['source_sha256'],'logs':streams(directory,r)} for r in records],
            'products':[pin(p) for p in sorted(directory.iterdir()) if p.is_file() and p.suffix in {'.json','.jsonl','.txt'}
                and p.name not in {'RECEIPTS.json','SOURCE_INPUTS.json','PREFLIGHT.json'}]})
    assert {h['job'] for h in history if h['status']=='FAILED_RETAINED'} == set(FAILURES)
    assert [h['job'] for h in history if h['status']=='INTERRUPTED_RETAINED'] == [INTERRUPTED]
    tools = ['tools/job.py','tools/job_when_available.py','tools/keygen_public_evaluation_audit_source.py',
        'tools/keygen_public_evaluation_batch.py','tools/keygen_public_first_audit_source.py',
        'tools/keygen_public_first_batch.py','tools/keygen_intermediate_batch.py','formal/Source3/KeygenLevelsAudit.lean']
    for p in tools: committed(p,head)
    notes = path(BASE+'_NOTES.md'); assert notes.exists()
    result = {'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_042','stage':'B1.06',
        'window':'CLOSED_AT_RECOVERABLE_MIDPOINT','b1_06_acceptance':'NOT_MET','stage_result':'PARTIAL_PROOF',
        'status':'IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN',
        'harness':'GPT-6 Astra Ultrafast / openai/gpt-6-astra-ultrafast',
        'runner_labels':'Historical runner model/session constants are provenance, not the042 worker attribution.',
        'created_utc':datetime.now(timezone.utc).isoformat(),'proof_head':head,'notes':pin(notes),
        'entry_pins_receipt':pin(ENTRY),'predecessor_files':7417,'preseal_predecessor_receipt':pin(PRESEAL),
        'superseded':{},'accepted_module_checks':modules,'current_final_audit_inputs':len(inputs['sources'])+len(inputs['reused']),
        'audit':{**pin(audit_dir/'PUBLIC_EVALUATION_AUDIT.json'),'entries_jsonl':pin(audit_dir/'PUBLIC_EVALUATION_AUDIT_ENTRIES.jsonl'),
            'receipt':pin(audit_dir/'RECEIPTS.json'),'source_inputs':pin(audit_dir/'SOURCE_INPUTS.json'),
            'generator':pin('tools/keygen_public_evaluation_audit_source.py'),'producer':pin('formal/Source3/KeygenPublicEvaluationAudit.lean'),
            'exports':len(audit),'named_declarations':len(declarations()),'inherited_interfaces':len(INHERITED),
            'full_terms':sum('term' in e['body'] for e in audit),'kernel_inductives':sum('constructors' in e['body'] for e in audit),
            'elisions':0,'allowed_axioms':['propext','Classical.choice','Quot.sound']},
        'sage':{'source':pin(SAGE),'receipt':pin(control_dir/'RECEIPTS.json'),'source_inputs':pin(control_dir/'SOURCE_INPUTS.json'),
            'result':pin(control_dir/'PUBLIC_EVALUATION_CHECK.json'),'source_files':source_pins,'inherited_controls':inherited_controls,
            'logs':streams(control_dir,control_record,True),'physical_evaluations':122880,'block_remainders':8176,'root_tree_laws':13824,
            'new_C_executions':0,'inherited_C_UBSan_runs_rehashed':12,'scope':controls['scope']},
        'attempt_details':history,'attempt_counts':{s:sum(h['status']==s for h in history)
            for s in ['ACCEPTED','FAILED_RETAINED','INTERRUPTED_RETAINED']},
        'contracts':{
            'outer_radix':'All executed rows/stages derive headers, m+j twiddles, counters, t*m=1536, full1536 images and writable-table frames from the SAME complete invocation.',
            'polynomial':'The q18433 root tree and exact recursive row/stage images preserve the ORIGINAL CoefficientQuotient polynomial at every assigned physical root.',
            'triple':'Actual512-body loop derives scaled w/x/x2, ordinary values, chronological stores, untouched-cell/table frames and final physical order.',
            'full_forward':'KeygenPublicEvaluation.source_complete: all i:Fin1536 output cells equal evaluations of the ORIGINAL reduced polynomial; only actual profile/a binding/original converted cells/full Exec are premises.',
            'same_material':'KeygenPublicEvaluationMaterial.source_same_material: SAME complete public conversion/invocation derives h/g at afterH and t/f at afterT, actual suffix and final t disposal. Legal/profile/material/bounds1/nonalias/static-table-liveness are explicit enclosing-KeyGen obligations.'},
        'open_in_b1_06':[
            'Item2 source evaluations DONE. The two evaluation arrays are at their respective forward-return states; expose/preserve h/g across the t call at the common afterT seam for the pointwise consumer.',
            'Item3 NEXT: SAME successful public path all1536 nonzero tests, division, actual inverse/normalization and canonical h; derive the suffix header/frame domains rather than assume an image or round-trip.',
            'Item4 THEN: fInv from nonzero evaluations/proved evaluation isomorphism; BOTH SAME f/g/h mulRq equations.'],
        'tools':[pin(p) for p in tools],
        'source_commits':subprocess.check_output(['git','log','--reverse','--format=%H %s','83a297eb..'+head,
            '--',str(job.ROOT.relative_to(job.REPO))],cwd=job.REPO,text=True).splitlines(),
        'active_jobs_at_close':[],'push_by_this_worker':False,'review_or_stages_import':False,
        'limits':'Unchanged Lean j1/-M6144,AS12GiB/RSS8GiB,wall1800s,maxHeartbeats2000000,print200000;0/0 proof streams,Sage standard preparser.'}
    assert not job.active(), 'A proof job is active'
    with path(BASE+'.json').open('x') as stream:
        json.dump(result,stream,indent=2); stream.write('\n')
    print(json.dumps({'batch':pin(BASE+'.json'),'notes':pin(notes),'modules':len(modules),
        'audit_entries':len(audit),'attempts':len(history),'attempt_counts':result['attempt_counts'],
        'literal_inputs':result['current_final_audit_inputs']},indent=2))


def verify(batch_sha, notes_sha, target):
    checked = {}
    def check(p, expected):
        p = path(p); actual = job.sha(p)
        assert actual == expected, (str(p),expected,actual)
        if str(p) in checked: assert checked[str(p)] == expected
        checked[str(p)] = actual
    def walk(value):
        if isinstance(value,dict):
            if 'path' in value and 'sha256' in value: check(value['path'],value['sha256'])
            for child in value.values(): walk(child)
        elif isinstance(value,list):
            for child in value: walk(child)
    check(BASE+'.json',batch_sha); check(BASE+'_NOTES.md',notes_sha)
    batch = read(BASE+'.json'); walk(batch)
    assert batch['batch']=='BATCH_042' and batch['superseded']=={} and batch['active_jobs_at_close']==[]
    assert batch['entry_pins_receipt']['sha256']==ENTRY_SHA
    for p, expected in entry_checked()['checked'].items(): check(p,expected)
    inputs = read(batch['audit']['source_inputs']['path'])
    for e in inputs['sources']: check(e['path'],e['sha256'])
    for e in inputs['reused']:
        check(e.get('current_source',e['source']),e['source_sha256']); check(e['artifact'],e['artifact_sha256'])
    assert not job.active(), 'A proof job is active'
    result = {'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-042','checked':checked,
        'distinct_pinned_files':len(checked),'current_source_inputs':batch['current_final_audit_inputs'],
        'active_jobs':[],'superseded':{},'verifier_sha256':job.sha(Path(__file__))}
    print(json.dumps({**{k:v for k,v in result.items() if k!='checked'},'receipt':write_receipt(target,result)},indent=2))


if __name__ == '__main__':
    if sys.argv[1:] == ['seal']: seal()
    elif sys.argv[1:2] == ['predecessor']:
        assert len(sys.argv)==3; predecessor(sys.argv[2])
    else:
        assert len(sys.argv)==5 and sys.argv[1]=='verify'; verify(*sys.argv[2:])
