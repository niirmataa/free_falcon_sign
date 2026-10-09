#!/usr/bin/env python3
"""Seal/verify BATCH_041 with the unchanged015–040 closure and every attempt."""
from datetime import datetime, timezone
from pathlib import Path
import json
import subprocess
import sys

import job
from keygen_intermediate_batch import path, read, pin, committed, streams
from keygen_public_first_audit_source import MODULES, INHERITED, declarations

BASE = 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_041'
ENTRY = '.build/levels_041/ENTRY_PINS_041.json'
ENTRY_SHA = 'd544a10f8f23325d47e6082ffd0332b242ad625cb87cb8a9b9ef66ab7673f183'
PRESEAL = '.build/levels_041/PRESEAL.json'
CONTROL = '.build/jobs/keygen_public_first_checks_041_003'
SAGE = 'sage/check_keygen_public_first.sage'
FAILURES = {
    'keygen_public_first_invocation_041_001': 'Types is indexed by the whole State; transport its fields across allocation, not the structure term.',
    'keygen_public_radix_values_041_001': 'Destructuring a1 removed the Local fact subsequently needed by local_value; retain a separate copy for the declaration witness.',
    'keygen_public_radix_fold_041_001': 'simp only needs and_self after the conjunction rewrite; normalize Nat.add_assoc before the matching u64 conversion.',
    'keygen_public_split_order_041_001': 'SplitPolynomial accepted; TripleOrder zero branch retained the associativity goal after simp; ring closes it.',
    'keygen_public_first_checks_041_001': 'Mutation anchor also occurred outside mq_NTT_ternary; strict once guard rejected it before C compilation. Scope the mutation to that body.',
    'keygen_public_first_checks_041_002': 'Rejected C mutation left fC2 unused under -Werror. Swap both C contributions to retain a clean diagnostic mutation; do not suppress warnings.'}


def write_receipt(target, value):
    target = path(target)
    assert target.is_relative_to(job.BUILD.resolve()), target
    with target.open('x') as stream:
        json.dump(value, stream, indent=2)
        stream.write('\n')
    return pin(target)


def entry_checked():
    assert not job.active(), 'A proof job is active'
    assert job.sha(path(ENTRY)) == ENTRY_SHA
    entry = read(ENTRY)
    assert entry['distinct_pinned_files'] == len(entry['checked']) == 7113
    assert entry['predecessor_files'] == 7048 and entry['predecessor_literal_bindings'] == 621
    assert entry['active_jobs'] == [] and entry['superseded'] == {}
    for p, expected in entry['checked'].items():
        assert job.sha(path(p)) == expected, ('predecessor changed', p)
    return entry


def predecessor(target):
    entry = entry_checked()
    result = {'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-040',
        'checked':entry['checked'],'distinct_pinned_files':7113,'entry':pin(ENTRY),
        'active_jobs':[],'superseded':{},'verifier_sha256':job.sha(Path(__file__))}
    print(json.dumps({'predecessor_files':7113,'receipt':write_receipt(target,result)},indent=2))


def seal():
    assert not path(BASE+'.json').exists(), 'Never replace a historical pair'
    entry = entry_checked()
    head = subprocess.check_output(['git','rev-parse','HEAD'],cwd=job.REPO,text=True).strip()
    assert subprocess.check_output(['git','branch','--show-current'],cwd=job.REPO,text=True).strip() == 'main'
    assert read(PRESEAL)['checked'] == entry['checked']
    assert read(PRESEAL)['verifier_sha256'] == job.sha(Path(__file__))
    cache = read('.build/cache/CACHE_INDEX.json')
    modules = []
    for name in MODULES+['KeygenPublicFirstAudit']:
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
    audit_dir = path(cache['Source3.KeygenPublicFirstAudit']['receipt']).parent
    audit = read(audit_dir/'PUBLIC_FIRST_AUDIT.json')
    assert len(audit) == len({e['name'] for e in audit}) == len(declarations())+len(INHERITED) == 436
    assert {e['name'] for e in audit} == set(declarations()) | set(INHERITED)
    assert (audit_dir/'PUBLIC_FIRST_AUDIT_ENTRIES.jsonl').read_text().count('\n') == len(audit)
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
    control_dir = path(CONTROL); controls = read(control_dir/'PUBLIC_FIRST_CHECK.json')
    control_record = read(control_dir/'RECEIPTS.json')[0]
    assert control_record['accepted'] and control_record['clean_log'] and control_record['exit_code'] == 0
    committed(SAGE,head)
    assert job.sha(path(SAGE)) == job.sha(control_dir/SAGE) == control_record['source_sha256']
    assert controls['status'] == 'PASS_FINITE_SOURCE_CONTROLS' and len(controls['variants']) == 12
    assert controls['original_polynomial_evaluations'] == 12288
    assert job.sha(control_dir/'PUBLIC_FIRST_FIXTURE.json') == controls['fixture_sha256']
    profile = job.OLD/'inputs/source/PROFILE.json'
    assert job.sha(profile) == controls['profile_sha256']
    assert job.sha(control_dir/'PUBLIC_FIRST_HEADERS.json') == controls['header_binding_sha256']
    headers = read(control_dir/'PUBLIC_FIRST_HEADERS.json')
    assert headers['actual_source_pins'] == controls['source_pins']
    assert headers['differences'] == {'fpr-emulated.h':{
        'm0':'242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa',
        'actual':'6b897d6c217ef25a322e3b5c3d9488b9d6b8d0e369a710d8fce2259f24e6d84f'}}
    source_pins = []
    for name, expected in controls['source_pins'].items():
        p = job.REPO/'Extra/c'/name
        assert job.sha(p) == expected, p
        source_pins.append(pin(p))
    artifacts = [pin(control_dir/'PUBLIC_FIRST_FIXTURE.json'),pin(control_dir/'PUBLIC_FIRST_HEADERS.json')]
    for variant in controls['variants']:
        assert variant['counts'] == {'C':8,'F':8,'R':64,'T':8,'D':8,'M':8}
        assert bool(variant['differences']) == (variant['variant'] != 'baseline')
        for p, expected in variant['artifacts'].items():
            p = control_dir/p
            assert job.sha(p) == expected, p
            artifacts.append(pin(p))
    history = []
    directories = sorted((job.BUILD/'jobs').glob('keygen_public_*_041_*'))
    assert len(directories) == 16
    for directory in directories:
        assert (directory/'RECEIPTS.json').exists(), ('receipt-less attempt',directory)
        records = read(directory/'RECEIPTS.json'); inventory = read(directory/'SOURCE_INPUTS.json')
        snapshots = []
        for e in inventory['sources']:
            rel = 'formal/'+e['module'].replace('.','/')+'.lean' if 'module' in e else 'sage/'+Path(e['path']).name
            p = directory/rel
            assert job.sha(p) == e['sha256'], p
            snapshots.append(pin(p))
        for e in inventory['reused']:
            assert job.sha(path(e.get('current_source',e['source']))) == e['source_sha256'], ('superseded source',directory,e['module'])
            assert job.sha(path(e['artifact'])) == e['artifact_sha256'], ('superseded artifact',directory,e['module'])
        products = []
        for r in records:
            if 'olean_sha256' in r:
                module = r['name'].replace('Source3_','Source3.',1)
                artifact = directory/'lib'/(module.replace('.','/')+'.olean')
                snapshot = directory/'formal'/(module.replace('.','/')+'.lean')
                assert job.sha(artifact) == r['olean_sha256'] and job.sha(snapshot) == r['source_sha256']
                products.append(pin(artifact))
        status = 'FAILED_RETAINED' if any(not r['accepted'] for r in records) else 'ACCEPTED'
        assert (directory.name in FAILURES) == (status == 'FAILED_RETAINED'), directory.name
        history.append({'job':directory.name,'status':status,'cause':FAILURES.get(directory.name),
            'receipt':pin(directory/'RECEIPTS.json'),'source_inputs':pin(directory/'SOURCE_INPUTS.json'),
            'preflight':pin(directory/'PREFLIGHT.json'),'runner_snapshot':pin(directory/'RUNNER_SOURCE.py'),
            'execution_snapshot':pin(directory/'EXECUTION_SOURCE.py'),
            'wait_log':pin(job.BUILD/'waits'/directory.name/'WAIT.jsonl'),
            'snapshots':snapshots,'accepted_products':products,
            'steps':[{'name':r['name'],'accepted':r['accepted'],'exit_code':r['exit_code'],
                'elapsed_s':r['elapsed_s'],'maxrss_kib':r['cumulative_child_maxrss_kib'],
                'source_sha256':r['source_sha256'],'logs':streams(directory,r)} for r in records],
            'products':[pin(p) for p in sorted(directory.iterdir()) if p.is_file() and p.suffix in {'.json','.jsonl','.c','.d','.stdout','.stderr','.txt'}
                and p.name not in {'RECEIPTS.json','SOURCE_INPUTS.json','PREFLIGHT.json'}]})
    tools = ['tools/job.py','tools/job_when_available.py','tools/keygen_public_first_audit_source.py',
        'tools/keygen_public_first_batch.py','tools/keygen_public_input_audit_source.py',
        'tools/keygen_public_input_batch.py','tools/keygen_intermediate_batch.py','formal/Source3/KeygenLevelsAudit.lean']
    for p in tools: committed(p,head)
    notes = path(BASE+'_NOTES.md'); assert notes.exists()
    result = {'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_041','stage':'B1.06',
        'window':'CLOSED_AT_RECOVERABLE_MIDPOINT','b1_06_acceptance':'NOT_MET','stage_result':'PARTIAL_PROOF',
        'status':'IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN',
        'harness':'GPT-6 Astra Ultrafast / openai/gpt-6-astra-ultrafast',
        'runner_labels':'Historical runner session/model constants are provenance, not the041 worker attribution.',
        'created_utc':datetime.now(timezone.utc).isoformat(),'proof_head':head,'notes':pin(notes),
        'entry_pins_receipt':pin(ENTRY),'predecessor_files':7113,'preseal_predecessor_receipt':pin(PRESEAL),
        'superseded':{},'accepted_module_checks':modules,'current_final_audit_inputs':len(inputs['sources'])+len(inputs['reused']),
        'audit':{**pin(audit_dir/'PUBLIC_FIRST_AUDIT.json'),'entries_jsonl':pin(audit_dir/'PUBLIC_FIRST_AUDIT_ENTRIES.jsonl'),
            'receipt':pin(audit_dir/'RECEIPTS.json'),'source_inputs':pin(audit_dir/'SOURCE_INPUTS.json'),
            'generator':pin('tools/keygen_public_first_audit_source.py'),'producer':pin('formal/Source3/KeygenPublicFirstAudit.lean'),
            'exports':len(audit),'named_declarations':len(declarations()),'inherited_interfaces':len(INHERITED),
            'full_terms':sum('term' in e['body'] for e in audit),'kernel_inductives':sum('constructors' in e['body'] for e in audit),
            'elisions':0,'allowed_axioms':['propext','Classical.choice','Quot.sound']},
        'sage':{'source':pin(SAGE),'receipt':pin(control_dir/'RECEIPTS.json'),'source_inputs':pin(control_dir/'SOURCE_INPUTS.json'),
            'result':pin(control_dir/'PUBLIC_FIRST_CHECK.json'),'profile':pin(profile),'source_files':source_pins,
            'actual_include_binding':pin(control_dir/'PUBLIC_FIRST_HEADERS.json'),'header_differences':headers['differences'],
            'logs':streams(control_dir,control_record,True),'artifacts':artifacts,'runs':12,'mutations_per_mode':5,
            'original_polynomial_evaluations':12288,'scope':controls['scope']},
        'attempt_details':history,'attempt_counts':{status:sum(e['status']==status for e in history) for status in ['ACCEPTED','FAILED_RETAINED']},
        'contracts':{
            'first_domains':'Full forward declarations/allocations/dimensions/generator Call/Bind/aliases/seed/counter derive the first-loop Inv0, Inv768 and SAME suffix/disposal link from the SAME converted original cells.',
            'same_public':'KeygenPublicFirstMaterial.source_same_material derives BOTH original converted f/g and first-fold outcomes from the SAME complete compute execution, legal profile/memory/material/bounds1/static-table liveness. h/g and t/f plus real3072-cell t lifetime are explicit.',
            'radix':'Actual radix butterfly and whole INNER v-loop produce low/high remainder-polynomial coefficient images and preserve every untouched physical cell; outer-row caller domains remain explicit.',
            'physical_order':'Universal public-field triple identities at KeygenPublicRoots.point for every i:Fin1536. They concern the three block coefficients; source triple execution and equality with the ORIGINAL f/g polynomial are not established.'},
        'open_in_b1_06':[
            'Item2: derive outer radix row/stage domains and generated-table frames from the SAME continuation; compose all u1/m iterations, t*m=1536 and source twiddle indices.',
            'Item2: propagate the ORIGINAL CoefficientQuotient polynomial invariant through all eight public radix stages using the public-field root tree; existing v-loop remainder images do not supply this composition.',
            'Item2: execute triple body and whole loop, derive scaled w/x/x2, chronological stores and frames, then combine the physical-order identities into universal1536 original-f/g evaluations.',
            'Item3 AFTER evaluations: SAME successful path all1536 nonzero tests,division,actual inverse/normalization and canonical h; no assumed round-trip.',
            'Item4 AFTER evaluations/item3: fInv from nonzero evaluations/proved evaluation isomorphism and BOTH SAME-material mulRq equations.'],
        'tools':[pin(p) for p in tools],
        'source_commits':subprocess.check_output(['git','log','--reverse','--format=%H %s','7a5bf47c..'+head,
            '--',str(job.ROOT.relative_to(job.REPO))],cwd=job.REPO,text=True).splitlines(),
        'active_jobs_at_close':[],'push_by_this_worker':False,'review_or_stages_import':False,
        'limits':'Unchanged Lean j1/-M6144,AS12GiB/RSS8GiB,wall1800s,maxHeartbeats2000000,print200000;0/0 proof streams,Sage standard preparser ZZ.'}
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
    assert batch['batch'] == 'BATCH_041' and batch['superseded'] == {} and batch['active_jobs_at_close'] == []
    assert batch['entry_pins_receipt']['sha256'] == ENTRY_SHA
    for p, expected in entry_checked()['checked'].items(): check(p,expected)
    inputs = read(batch['audit']['source_inputs']['path'])
    for e in inputs['sources']: check(e['path'],e['sha256'])
    for e in inputs['reused']:
        check(e.get('current_source',e['source']),e['source_sha256']); check(e['artifact'],e['artifact_sha256'])
    assert not job.active(), 'A proof job is active'
    result = {'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-041','checked':checked,
        'distinct_pinned_files':len(checked),'current_source_inputs':batch['current_final_audit_inputs'],
        'active_jobs':[],'superseded':{},'verifier_sha256':job.sha(Path(__file__))}
    print(json.dumps({**{k:v for k,v in result.items() if k!='checked'},'receipt':write_receipt(target,result)},indent=2))


if __name__ == '__main__':
    if sys.argv[1:] == ['seal']: seal()
    elif sys.argv[1:2] == ['predecessor']:
        assert len(sys.argv) == 3; predecessor(sys.argv[2])
    else:
        assert len(sys.argv) == 5 and sys.argv[1] == 'verify'; verify(*sys.argv[2:])
