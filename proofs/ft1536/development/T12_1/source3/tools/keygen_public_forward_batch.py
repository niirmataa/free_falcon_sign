#!/usr/bin/env python3
"""Seal/verify BATCH_038 and its unchanged BATCH_015-037 predecessor closure."""
from datetime import datetime, timezone
import json
from pathlib import Path
import subprocess
import sys

import job
from keygen_intermediate_batch import path, read, pin, committed, streams
from keygen_public_forward_audit_source import MODULES, INHERITED, declarations

BASE = 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_038'
ENTRY = '.build/levels_038/ENTRY_PINS_038.json'
ENTRY_SHA = '528cb839354dcae245061f90acdbc72070b49161e442d8c4fc38112a12c0f8cb'
PRESEAL = '.build/levels_038/PRESEAL_PREDECESSOR.json'
CONTROL = '.build/jobs/keygen_public_forward_checks_038_002'
SAGE = 'sage/check_keygen_public_forward.sage'


def write_receipt(target, value):
    target = path(target)
    assert target.is_relative_to(job.BUILD.resolve()), target
    with target.open('x') as stream:
        json.dump(value, stream, indent=2)
        stream.write('\n')
    return pin(target)


def predecessor(receipt):
    assert not job.active(), 'A proof job is active'
    assert job.sha(path(ENTRY)) == ENTRY_SHA
    entry = read(ENTRY)
    assert entry['distinct_pinned_files'] == 6141 and entry['active_jobs'] == [] and entry['superseded'] == {}
    for p, expected in entry['checked'].items():
        assert job.sha(path(p)) == expected, ('predecessor changed', p)
    result = {'utc':datetime.now(timezone.utc).isoformat(), 'batch':'BATCH_015-037',
        'checked':entry['checked'], 'distinct_pinned_files':6141, 'current_source_inputs':596,
        'entry':pin(ENTRY), 'active_jobs':[], 'superseded':{}, 'verifier_sha256':job.sha(Path(__file__))}
    print(json.dumps({'predecessor_files':6141, 'receipt':write_receipt(receipt, result)}, indent=2))


def seal():
    assert not path(BASE+'.json').exists(), 'Never replace a historical pair'
    assert not job.active(), 'A proof job is active'
    head = subprocess.check_output(['git','rev-parse','HEAD'], cwd=job.REPO, text=True).strip()
    assert subprocess.check_output(['git','branch','--show-current'], cwd=job.REPO, text=True).strip() == 'main'
    assert job.sha(path(ENTRY)) == ENTRY_SHA
    entry = read(ENTRY)
    assert read(PRESEAL)['checked'] == entry['checked']
    for p, expected in entry['checked'].items():
        assert job.sha(path(p)) == expected, ('predecessor changed', p)
    cache = read('.build/cache/CACHE_INDEX.json')
    accepted = {}; modules = []
    for name in MODULES+['KeygenPublicForwardAudit']:
        module = 'Source3.'+name
        current = cache[module]
        source = path(current['source']); receipt = path(current['receipt']); directory = receipt.parent
        committed(source, head)
        record = next(r for r in read(receipt) if r['name'] == module.replace('.','_'))
        assert record['accepted'] and record['clean_log'] and record['exit_code'] == 0
        assert record['forbidden_proof_markers'] == [] and record['cumulative_child_maxrss_kib'] <= 8*1024*1024
        snapshot = directory/'formal/Source3'/(name+'.lean'); artifact = directory/'lib/Source3'/(name+'.olean')
        assert job.sha(source) == job.sha(snapshot) == record['source_sha256'] == current['source_sha256']
        assert job.sha(artifact) == job.sha(path(current['artifact'])) == record['olean_sha256'] == current['artifact_sha256']
        for imported, expected in current.get('imports',{}).items():
            if imported in cache:
                assert cache[imported]['artifact_sha256'] == expected, (module, imported)
        accepted[name] = pin(source)
        modules.append({'module':module, 'source':pin(source), 'snapshot':pin(snapshot), 'artifact':pin(artifact),
            'cache_artifact':pin(current['artifact']), 'receipt':pin(receipt),
            'source_inputs':pin(directory/'SOURCE_INPUTS.json'), 'logs':streams(directory, record, True),
            'imports':current.get('imports',{}), 'elapsed_s':record['elapsed_s'],
            'maxrss_kib':record['cumulative_child_maxrss_kib']})
    audit_dir = path(cache['Source3.KeygenPublicForwardAudit']['receipt']).parent
    audit = read(audit_dir/'PUBLIC_FORWARD_AUDIT.json')
    expected_names = set(declarations()) | {'FT1536.Source3.'+n for n in INHERITED}
    assert len(audit) == len({e['name'] for e in audit}) == len(expected_names)
    assert {e['name'] for e in audit} == expected_names
    assert (audit_dir/'PUBLIC_FORWARD_AUDIT_ENTRIES.jsonl').read_text().count('\n') == len(audit)
    for e in audit:
        assert set(e['axioms']) <= {'propext','Classical.choice','Quot.sound'}, e['name']
        assert '⋯' not in json.dumps(e, ensure_ascii=False), e['name']
        if e['body']['kind'] == 'definition_or_theorem':
            assert e['body']['term'], e['name']
        else:
            assert e['body']['kind'] == 'kernel_inductive' and e['body']['constructors'], e['name']
    inputs = read(audit_dir/'SOURCE_INPUTS.json')
    for e in inputs['sources']:
        assert job.sha(path(e['path'])) == e['sha256'], e['path']
    for e in inputs['reused']:
        assert job.sha(path(e.get('current_source',e['source']))) == e['source_sha256'], e['module']
        assert job.sha(path(e['artifact'])) == e['artifact_sha256'], e['module']
    control_dir = path(CONTROL)
    controls = read(control_dir/'PUBLIC_FORWARD_CHECK.json')
    control_record = read(control_dir/'RECEIPTS.json')[0]
    assert control_record['accepted'] and control_record['clean_log'] and control_record['exit_code'] == 0
    committed(SAGE, head)
    assert job.sha(path(SAGE)) == job.sha(control_dir/SAGE) == control_record['source_sha256']
    assert controls['status'] == 'PASS_FINITE_SOURCE_CONTROLS' and len(controls['variants']) == 12
    assert job.sha(control_dir/'PUBLIC_FORWARD_FIXTURE.json') == controls['fixture_sha256']
    assert job.sha(job.OLD/'inputs/source/PROFILE.json') == controls['profile_sha256']
    control_artifacts = [pin(control_dir/'PUBLIC_FORWARD_FIXTURE.json')]
    for variant in controls['variants']:
        assert variant['counts'] == {'G':10,'D':100,'M':10}
        assert len(variant['metrics']) == 10
        assert bool(variant['detected_differences']) == (variant['variant'] != 'baseline')
        if variant['variant'] == 'baseline':
            assert all(m[1:] == [15360,0,0,1025,0,0,60000,60000] for m in variant['metrics'])
        for p, expected in variant['artifacts'].items():
            p = control_dir/p
            assert job.sha(p) == expected, p
            control_artifacts.append(pin(p))
    source_pins = []
    for name, expected in controls['source_pins'].items():
        p = job.OLD/'inputs/source'/name
        assert job.sha(p) == expected, p
        source_pins.append(pin(p))

    directories = sorted((job.BUILD/'jobs').glob('keygen_public_*_038_*'))
    products = {}
    for directory in directories:
        assert (directory/'RECEIPTS.json').exists(), ('unaccounted receipt-less attempt', directory)
        for r in read(directory/'RECEIPTS.json'):
            if 'olean_sha256' not in r:
                continue
            module = r['name'].replace('Source3_','Source3.',1)
            artifact = directory/'lib'/(module.replace('.','/')+'.olean')
            snapshot = directory/'formal'/(module.replace('.','/')+'.lean')
            assert job.sha(artifact) == r['olean_sha256'] and job.sha(snapshot) == r['source_sha256']
            products[(module,r['olean_sha256'],r['source_sha256'])] = {
                'artifact':pin(artifact), 'source_snapshot':pin(snapshot), 'receipt':pin(directory/'RECEIPTS.json')}
    history = []; resolutions = {}
    for directory in directories:
        records = read(directory/'RECEIPTS.json'); inventory = read(directory/'SOURCE_INPUTS.json'); snapshots = []
        for e in inventory['sources']:
            rel = 'formal/'+e['module'].replace('.','/')+'.lean' if 'module' in e else 'sage/'+Path(e['path']).name
            p = directory/rel
            assert job.sha(p) == e['sha256'], p
            snapshots.append(pin(p))
        for e in inventory['reused']:
            current_source = path(e.get('current_source',e['source'])); artifact = path(e['artifact'])
            if job.sha(current_source) != e['source_sha256'] or job.sha(artifact) != e['artifact_sha256']:
                key = (e['module'],e['artifact_sha256'],e['source_sha256'])
                assert key in products, ('missing immutable old source/product pair', key)
                resolutions['@'.join(key)] = {'module':e['module'], 'recorded_source_path':str(current_source),
                    'recorded_source_sha256':e['source_sha256'], 'recorded_artifact_path':str(artifact),
                    'recorded_artifact_sha256':e['artifact_sha256'], **products[key]}
        status = 'FAILED_RETAINED' if any(not r['accepted'] for r in records) else 'ACCEPTED'
        steps = [{'name':r['name'], 'accepted_by_runner':r['accepted'], 'exit_code':r['exit_code'],
            'elapsed_s':r['elapsed_s'], 'maxrss_kib':r['cumulative_child_maxrss_kib'],
            'source_sha256':r['source_sha256'], 'logs':streams(directory,r)} for r in records]
        history.append({'job':directory.name, 'status':status, 'receipt':pin(directory/'RECEIPTS.json'),
            'source_inputs':pin(directory/'SOURCE_INPUTS.json'), 'preflight':pin(directory/'PREFLIGHT.json'),
            'runner_snapshot':pin(directory/'RUNNER_SOURCE.py'), 'execution_snapshot':pin(directory/'EXECUTION_SOURCE.py'),
            'launcher':'direct serial tools/job.py, no wait/relay/worker', 'snapshots':snapshots, 'steps':steps,
            'accepted_products':[p for p in products.values() if path(p['receipt']['path']).parent == directory],
            'products':[pin(p) for p in sorted(directory.iterdir()) if p.is_file() and p.suffix in {'.json','.jsonl','.c','.stdout','.stderr'}
                and p.name not in {'RECEIPTS.json','SOURCE_INPUTS.json','PREFLIGHT.json'}]})
    tools = ['tools/job.py', 'tools/keygen_public_forward_audit_source.py', 'tools/keygen_public_forward_batch.py',
        'tools/keygen_public_upper_batch.py', 'tools/keygen_intermediate_batch.py', 'formal/Source3/KeygenLevelsAudit.lean']
    for p in tools:
        committed(p, head)
    notes = path(BASE+'_NOTES.md')
    assert notes.exists()
    output = {'task':'KEYGEN_SOURCE_TO_FIBER_001', 'batch':'BATCH_038', 'stage':'B1.06',
        'window':'CLOSED_AT_RECOVERABLE_MIDPOINT', 'b1_06_acceptance':'NOT_MET', 'stage_result':'PARTIAL_PROOF',
        'status':'IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN',
        'harness':'GPT-6.1 Sol Fast / openai/gpt-6.1-sol-fast',
        'runner_labels':'Historical session/model constants are provenance, not this window attribution.',
        'created_utc':datetime.now(timezone.utc).isoformat(), 'proof_head':head, 'notes':pin(notes),
        'entry_pins_receipt':pin(ENTRY), 'predecessor_files':6141, 'superseded':{},
        'preseal_predecessor_receipt':pin(PRESEAL), 'accepted_modules':accepted, 'accepted_module_checks':modules,
        'current_final_audit_inputs':len(inputs['sources'])+len(inputs['reused']),
        'audit':{**pin(audit_dir/'PUBLIC_FORWARD_AUDIT.json'), 'entries_jsonl':pin(audit_dir/'PUBLIC_FORWARD_AUDIT_ENTRIES.jsonl'),
            'receipt':pin(audit_dir/'RECEIPTS.json'), 'source_inputs':pin(audit_dir/'SOURCE_INPUTS.json'), 'exports':len(audit),
            'generator':pin('tools/keygen_public_forward_audit_source.py'), 'producer':pin('formal/Source3/KeygenPublicForwardAudit.lean'),
            'covered_named_source_declarations':len(declarations()), 'inherited_interfaces':len(INHERITED),
            'full_terms':sum('term' in e['body'] for e in audit),
            'kernel_inductives_with_constructor_types':sum('constructors' in e['body'] for e in audit),
            'elisions':0, 'allowed_axioms':['propext','Classical.choice','Quot.sound']},
        'sage':{'source':pin(SAGE), 'receipt':pin(control_dir/'RECEIPTS.json'),
            'source_inputs':pin(control_dir/'SOURCE_INPUTS.json'), 'result':pin(control_dir/'PUBLIC_FORWARD_CHECK.json'),
            'profile':pin(job.OLD/'inputs/source/PROFILE.json'), 'source_files':source_pins,
            'logs':streams(control_dir,control_record,True), 'artifacts':control_artifacts,
            'runs':12, 'mutations_per_mode':5, 'scope':controls['scope']},
        'attempt_details':history, 'attempt_counts':{status:sum(e['status']==status for e in history)
            for status in ['ACCEPTED','FAILED_RETAINED']}, 'within_window_earlier_product_resolution':list(resolutions.values()),
        'contracts':{
            'canonical_forward':'SAME complete mq_NTT dispatch/ternary execution at logn10 derives all1536 initialized canonical unsigned16 output cells, with explicit original input Domain/Initialized and residue-global local caller domains. No generated table image or NTT-correctness premise.',
            'tables_and_lifetimes':'Actual generator Call parameter binding consumes source_complete_tables; canonical gm aliases and uninitialized holes are derived, both automatic arrays are allocated/disposed, input block is live and distinct by the actual Fresh premises.',
            'range_not_evaluation':'All three complete passes use source-derived add/sub/Montgomery/square/store ranges. This is canonical range, NOT polynomial evaluations, nonzero, an inverse round-trip or either public equation.',
            'input_seam':'Original SAME f/g conversion must derive Domain/Initialized (or Image plus actual extent) and the actual global-range domain in the caller. Domain covers every defined forward-addressable load, not only an abstract1536-vector.',
            'boundary':'B1.06 Acceptance NOT MET; B1.05 stays BATCH_032; B1.07 not entered. Full KeyGen/emitted-to-fiber/compiler/laws/PRG/security/review are outside.'},
        'open_in_b1_06':[
            '16.1 item2: SAME original f/g conversion, caller binding of input/global range domains, all forward pass evaluation invariants and physical KeygenPublicRoots.point/CoefficientQuotient polynomial evaluations.',
            '16.1 item3: SAME successful public execution implies all1536 nonzero tests, division and actual inverse transform/normalization to canonical h; no assumed round-trip.',
            '16.1 item4: construct fInv via nonzero evaluations/proven evaluation isomorphism, derive BOTH mulRq equations for SAME f/g/h.',
            '16.1 item5: inherited BATCH_036 seal ceremony retained; current midpoint audit/controls/closure required separately.'],
        'entry_command_errata':'Owner approved correct BATCH_036 pair hashes for unchanged 036 verifier plus separate full037 re-hash; historical17R command retained with append-only errata.',
        'tools':[pin(p) for p in tools],
        'source_commits':subprocess.check_output(['git','log','--reverse','--format=%H %s',entry['head']+'..'+head,
            '--',str(job.ROOT.relative_to(job.REPO))],cwd=job.REPO,text=True).splitlines(),
        'active_jobs_at_close':[], 'push_by_this_worker':False,
        'limits':'Unchanged Lean j1/-M6144,AS12GiB/RSS8GiB,wall1800s,maxHeartbeats2000000,print200000; 0/0 proof streams,Sage standard preparser ZZ.'}
    with path(BASE+'.json').open('x') as stream:
        json.dump(output, stream, indent=2)
        stream.write('\n')
    print(json.dumps({'batch':pin(BASE+'.json'), 'notes':pin(notes), 'modules':len(modules), 'audited':len(audit),
        'attempts':len(history), 'inputs':output['current_final_audit_inputs'], 'within_window_resolutions':len(resolutions)}, indent=2))


def verify(batch_sha, notes_sha, receipt):
    checked = {}
    def check(p, expected):
        p = path(p); actual = job.sha(p)
        assert actual == expected, (str(p), expected, actual)
        checked[str(p)] = actual
    def walk(value):
        if isinstance(value,dict):
            if 'path' in value and 'sha256' in value:
                check(value['path'],value['sha256'])
            for child in value.values():
                walk(child)
        elif isinstance(value,list):
            for child in value:
                walk(child)
    check(BASE+'.json',batch_sha); check(BASE+'_NOTES.md',notes_sha)
    batch = read(BASE+'.json'); walk(batch)
    assert batch['batch']=='BATCH_038' and batch['superseded']=={} and batch['active_jobs_at_close']==[]
    assert batch['entry_pins_receipt']['sha256'] == ENTRY_SHA
    for p, expected in read(ENTRY)['checked'].items():
        check(p, expected)
    inputs = read(batch['audit']['source_inputs']['path'])
    for e in inputs['sources']:
        check(e['path'],e['sha256'])
    for e in inputs['reused']:
        check(e.get('current_source',e['source']),e['source_sha256'])
        check(e['artifact'],e['artifact_sha256'])
    assert not job.active(), 'A proof job is active'
    result = {'utc':datetime.now(timezone.utc).isoformat(), 'batch':'BATCH_015-038', 'checked':checked,
        'distinct_pinned_files':len(checked), 'current_source_inputs':batch['current_final_audit_inputs'],
        'active_jobs':[], 'superseded':{}, 'verifier_sha256':job.sha(Path(__file__))}
    print(json.dumps({**{k:v for k,v in result.items() if k!='checked'},
        'receipt':write_receipt(receipt,result)}, indent=2))


if __name__ == '__main__':
    if sys.argv[1:] == ['seal']:
        seal()
    elif sys.argv[1:2] == ['predecessor']:
        assert len(sys.argv)==3
        predecessor(sys.argv[2])
    else:
        assert len(sys.argv)==5 and sys.argv[1]=='verify'
        verify(*sys.argv[2:])
