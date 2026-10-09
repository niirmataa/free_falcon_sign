#!/usr/bin/env python3
"""Seal/verify BATCH_039, retaining the complete unchanged015–038 closure."""
from datetime import datetime, timezone
import json
from pathlib import Path
import subprocess
import sys

import job
from keygen_intermediate_batch import path, read, pin, committed, streams
from keygen_public_input_audit_source import MODULES, INHERITED, declarations

BASE = 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_039'
ENTRY = '.build/levels_039/ENTRY_PINS_039.json'
ENTRY_SHA = 'cb73d864e35991b4815d930a370e70d383057a30657508a825b6c04265593044'
PRESEAL = '.build/levels_039/PRESEAL_PREDECESSOR_002.json'
CONTROL = '.build/jobs/keygen_public_input_checks_039_004'
SAGE = 'sage/check_keygen_public_input.sage'


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
    assert entry['distinct_pinned_files'] == 6438 and entry['current_source_inputs'] == 607
    assert entry['active_jobs'] == [] and entry['superseded'] == {}
    for p, expected in entry['checked'].items():
        assert job.sha(path(p)) == expected, ('predecessor changed', p)
    result = {'utc':datetime.now(timezone.utc).isoformat(), 'batch':'BATCH_015-038',
        'checked':entry['checked'], 'distinct_pinned_files':6438, 'current_source_inputs':607,
        'entry':pin(ENTRY), 'active_jobs':[], 'superseded':{}, 'verifier_sha256':job.sha(Path(__file__))}
    print(json.dumps({'predecessor_files':6438, 'receipt':write_receipt(receipt, result)}, indent=2))


def seal():
    assert not path(BASE+'.json').exists(), 'Never replace a historical pair'
    assert not job.active(), 'A proof job is active'
    head = subprocess.check_output(['git','rev-parse','HEAD'], cwd=job.REPO, text=True).strip()
    assert subprocess.check_output(['git','branch','--show-current'], cwd=job.REPO, text=True).strip() == 'main'
    assert job.sha(path(ENTRY)) == ENTRY_SHA
    entry = read(ENTRY)
    assert read(PRESEAL)['checked'] == entry['checked']
    assert job.sha(path('.build/levels_039/PRESEAL_VERIFIER_001.py')) == read('.build/levels_039/PRESEAL_PREDECESSOR.json')['verifier_sha256']
    for p, expected in entry['checked'].items():
        assert job.sha(path(p)) == expected, ('predecessor changed', p)
    cache = read('.build/cache/CACHE_INDEX.json')
    accepted = {}; modules = []
    for name in MODULES+['KeygenPublicInputAudit','KeygenPublicInputProbe']:
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
        modules.append({'module':module, 'role':'parser diagnostic only' if name.endswith('Probe') else 'proof/audit',
            'source':pin(source), 'snapshot':pin(snapshot), 'artifact':pin(artifact), 'cache_artifact':pin(current['artifact']),
            'receipt':pin(receipt), 'source_inputs':pin(directory/'SOURCE_INPUTS.json'), 'logs':streams(directory,record,True),
            'imports':current.get('imports',{}), 'elapsed_s':record['elapsed_s'], 'maxrss_kib':record['cumulative_child_maxrss_kib']})
    audit_dir = path(cache['Source3.KeygenPublicInputAudit']['receipt']).parent
    audit = read(audit_dir/'PUBLIC_INPUT_AUDIT.json')
    expected_names = set(declarations()) | set(INHERITED)
    assert len(audit) == len({e['name'] for e in audit}) == len(expected_names)
    assert {e['name'] for e in audit} == expected_names
    assert (audit_dir/'PUBLIC_INPUT_AUDIT_ENTRIES.jsonl').read_text().count('\n') == len(audit)
    for e in audit:
        assert set(e['axioms']) <= {'propext','Classical.choice','Quot.sound'}, e['name']
        assert '⋯' not in json.dumps(e,ensure_ascii=False), e['name']
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
    control_dir = path(CONTROL); controls = read(control_dir/'PUBLIC_INPUT_CHECK.json')
    control_record = read(control_dir/'RECEIPTS.json')[0]
    assert control_record['accepted'] and control_record['clean_log'] and control_record['exit_code'] == 0
    committed(SAGE,head)
    assert job.sha(path(SAGE)) == job.sha(control_dir/SAGE) == control_record['source_sha256']
    assert controls['status'] == 'PASS_FINITE_SOURCE_CONTROLS' and len(controls['variants']) == 12
    assert controls['split_evaluations'] == 96
    assert job.sha(control_dir/'PUBLIC_INPUT_FIXTURE.json') == controls['fixture_sha256']
    profile = job.OLD/'inputs/source/PROFILE.json'
    assert job.sha(profile) == controls['profile_sha256']
    source_pins = []
    for name, expected in controls['source_pins'].items():
        p = job.REPO/'Extra/c'/name
        assert job.sha(p) == expected, p
        source_pins.append(pin(p))
    headers = read(control_dir/'PUBLIC_INPUT_HEADERS.json')
    assert job.sha(control_dir/'PUBLIC_INPUT_HEADERS.json') == controls['header_binding_sha256']
    assert headers['actual_source_pins'] == controls['source_pins']
    assert headers['historical_m0_pins'] == controls['historical_m0_pins']
    assert headers['differences'] == controls['header_differences'] == {'fpr-emulated.h':{
        'm0':'242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa',
        'actual':'6b897d6c217ef25a322e3b5c3d9488b9d6b8d0e369a710d8fce2259f24e6d84f'}}
    artifacts = [pin(control_dir/'PUBLIC_INPUT_FIXTURE.json'),pin(control_dir/'PUBLIC_INPUT_HEADERS.json')]
    for variant in controls['variants']:
        assert variant['counts'] == {'C':16,'F':16,'T':8,'M':8}
        assert bool(variant['differences']) == (variant['variant'] != 'baseline')
        for p, expected in variant['artifacts'].items():
            p = control_dir/p
            assert job.sha(p) == expected, p
            artifacts.append(pin(p))
    directories = sorted((job.BUILD/'jobs').glob('keygen_public_*_039_*'))
    products = {}
    for directory in directories:
        assert (directory/'RECEIPTS.json').exists(), ('unaccounted receipt-less attempt',directory)
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
                assert key in products, ('missing immutable old source/product pair',key)
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
            'launcher':'direct serial tools/job.py, no relay/worker', 'snapshots':snapshots, 'steps':steps,
            'accepted_products':[p for p in products.values() if path(p['receipt']['path']).parent == directory],
            'products':[pin(p) for p in sorted(directory.iterdir()) if p.is_file() and p.suffix in {'.json','.jsonl','.c','.stdout','.stderr','.txt'}
                and p.name not in {'RECEIPTS.json','SOURCE_INPUTS.json','PREFLIGHT.json'}]})
    tools = ['tools/job.py','tools/keygen_public_input_audit_source.py','tools/keygen_public_input_batch.py',
        'tools/keygen_public_input_verifier_history.py',
        'tools/keygen_public_forward_audit_source.py','tools/keygen_public_forward_batch.py',
        'tools/keygen_intermediate_batch.py','formal/Source3/KeygenLevelsAudit.lean']
    for p in tools:
        committed(p,head)
    notes = path(BASE+'_NOTES.md'); assert notes.exists()
    output = {'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_039','stage':'B1.06',
        'window':'CLOSED_AT_RECOVERABLE_MIDPOINT','b1_06_acceptance':'NOT_MET','stage_result':'PARTIAL_PROOF',
        'status':'IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN',
        'harness':'GPT-6.1 Sol Fast / openai/gpt-6.1-sol-fast',
        'runner_labels':'Historical session/model constants are provenance, not this window attribution.',
        'created_utc':datetime.now(timezone.utc).isoformat(),'proof_head':head,'notes':pin(notes),
        'entry_pins_receipt':pin(ENTRY),'predecessor_files':6438,'superseded':{},
        'preseal_predecessor_receipt':pin(PRESEAL),'accepted_modules':accepted,'accepted_module_checks':modules,
        'earlier_preseal':{'receipt':pin('.build/levels_039/PRESEAL_PREDECESSOR.json'),
            'verifier_source':pin('.build/levels_039/PRESEAL_VERIFIER_001.py'),
            'recovery_input':pin('.build/levels_039/SEAL_VERIFIER_HEADER_DECISION_001.py'),
            'recovery_generator':pin('tools/keygen_public_input_verifier_history.py'),
            'scope':'Old organizer bytes recovered by exact reversible header-decision changes and matched to the original receipt SHA; old receipt/pins unchanged.'},
        'current_final_audit_inputs':len(inputs['sources'])+len(inputs['reused']),
        'audit':{**pin(audit_dir/'PUBLIC_INPUT_AUDIT.json'),'entries_jsonl':pin(audit_dir/'PUBLIC_INPUT_AUDIT_ENTRIES.jsonl'),
            'receipt':pin(audit_dir/'RECEIPTS.json'),'source_inputs':pin(audit_dir/'SOURCE_INPUTS.json'),
            'exports':len(audit),'generator':pin('tools/keygen_public_input_audit_source.py'),
            'producer':pin('formal/Source3/KeygenPublicInputAudit.lean'),
            'covered_named_source_declarations':len(declarations()),'inherited_interfaces':len(INHERITED),
            'full_terms':sum('term' in e['body'] for e in audit),
            'kernel_inductives_with_constructor_types':sum('constructors' in e['body'] for e in audit),
            'elisions':0,'allowed_axioms':['propext','Classical.choice','Quot.sound']},
        'sage':{'source':pin(SAGE),'receipt':pin(control_dir/'RECEIPTS.json'),
            'source_inputs':pin(control_dir/'SOURCE_INPUTS.json'),'result':pin(control_dir/'PUBLIC_INPUT_CHECK.json'),
            'profile':pin(profile),'reference_source_location':'Extra/c','source_files':source_pins,
            'actual_include_binding':pin(control_dir/'PUBLIC_INPUT_HEADERS.json'),'header_differences':controls['header_differences'],
            'logs':streams(control_dir,control_record,True),'artifacts':artifacts,'runs':12,'mutations_per_mode':5,
            'exact_split_evaluations':96,'scope':controls['scope']},
        'attempt_details':history,'attempt_counts':{status:sum(e['status']==status for e in history)
            for status in ['ACCEPTED','FAILED_RETAINED']},
        'within_window_earlier_product_resolution':list(resolutions.values()),
        'contracts':{
            'same_material_conversion':'SAME3072 signed f/g conversions derive initialized canonical ORDINARY coefficients equal to the reductions of the retained MODE1-bounded original Vec, preserving original input cells and the uninitialized tail of t.',
            'caller_domains':'SAME complete compute execution derives MKN1536/q18433,actual3072-cell t allocation/Fresh separation/empty tail,parameter Bind and both complete mq_NTT canonical images at an interior midpoint,with final t disposal tied to the observed result. No canonical/image/range premise.',
            'legal_boundary':'Legal M0 profile,typed allocated f/g/h,actual material/bounds1,h-input nonaliasing,h descriptor extent1536,empty scalar globals,live/disjoint static table objects and finite fixed-program source execution remain explicit. Whole KeyGen supplies these later; no source correctness is assumed.',
            'first_values':'Independent source add/sub/Montgomery expression value contracts. SAME first-butterfly body derives x+y*z and x+y-y*z in the physical low/high cells,together with both actual chronological stores.',
            'polynomial':'First split coefficients and evaluations of the ORIGINAL CoefficientQuotient.polynomial(Relation.reduceVec original),including both x^768=root and x^768=1-root branches,are kernel identities. source_original_coefficients consumes original reduced input cells and local first-body entry/table-word facts,not a complete transform theorem.',
            'boundary':'One midpoint; B1.06 Acceptance NOT MET; B1.05 stays032; B1.07 not entered. No full first-loop/radix2/triple physical-value composition,nonzero/inverse/public equations,emitted/KeyGen/compiler/laws/PRG/security/review.'},
        'open_in_b1_06':[
            'Item2: derive actual first-pass entry/seed r from SAME complete forward/generator execution; fold768 first butterflies with the ORIGINAL input polynomial and preserve source/table/material frames.',
            'Item2: all radix2/triple value invariants and physical KeygenPublicRoots.point ordering; universal1536 original-f/g CoefficientQuotient evaluations,not canonicality or finite controls.',
            'Item3: SAME successful public path all1536 nonzero tests,actual division/inverse/normalization to canonical h; no assumed round-trip.',
            'Item4: construct fInv via nonzero evaluations/proved evaluation isomorphism and BOTH SAME-material mulRq equations.'],
        'tools':[pin(p) for p in tools],
        'source_commits':subprocess.check_output(['git','log','--reverse','--format=%H %s','a066e446..'+head,
            '--',str(job.ROOT.relative_to(job.REPO))],cwd=job.REPO,text=True).splitlines(),
        'active_jobs_at_close':[],'push_by_this_worker':False,
        'limits':'Unchanged Lean j1/-M6144,AS12GiB/RSS8GiB,wall1800s,maxHeartbeats2000000,print200000;0/0 proof streams,Sage standard preparser ZZ.'}
    with path(BASE+'.json').open('x') as stream:
        json.dump(output,stream,indent=2); stream.write('\n')
    print(json.dumps({'batch':pin(BASE+'.json'),'notes':pin(notes),'modules':len(modules),'audit':output['audit'],
        'attempts':len(history),'attempt_counts':output['attempt_counts'],'inputs':output['current_final_audit_inputs'],
        'within_window_resolutions':len(resolutions)},indent=2))


def verify(batch_sha, notes_sha, receipt):
    checked = {}
    def check(p, expected):
        p = path(p); actual = job.sha(p)
        assert actual == expected, (str(p),expected,actual)
        checked[str(p)] = actual
    def walk(value):
        if isinstance(value,dict):
            if 'path' in value and 'sha256' in value:
                check(value['path'],value['sha256'])
            for child in value.values(): walk(child)
        elif isinstance(value,list):
            for child in value: walk(child)
    check(BASE+'.json',batch_sha); check(BASE+'_NOTES.md',notes_sha)
    batch = read(BASE+'.json'); walk(batch)
    assert batch['batch']=='BATCH_039' and batch['superseded']=={} and batch['active_jobs_at_close']==[]
    assert batch['entry_pins_receipt']['sha256'] == ENTRY_SHA
    for p, expected in read(ENTRY)['checked'].items(): check(p,expected)
    inputs = read(batch['audit']['source_inputs']['path'])
    for e in inputs['sources']: check(e['path'],e['sha256'])
    for e in inputs['reused']:
        check(e.get('current_source',e['source']),e['source_sha256']); check(e['artifact'],e['artifact_sha256'])
    assert not job.active(), 'A proof job is active'
    result = {'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-039','checked':checked,
        'distinct_pinned_files':len(checked),'current_source_inputs':batch['current_final_audit_inputs'],
        'active_jobs':[],'superseded':{},'verifier_sha256':job.sha(Path(__file__))}
    print(json.dumps({**{k:v for k,v in result.items() if k!='checked'},'receipt':write_receipt(receipt,result)},indent=2))


if __name__ == '__main__':
    if sys.argv[1:] == ['seal']: seal()
    elif sys.argv[1:2] == ['predecessor']:
        assert len(sys.argv)==3; predecessor(sys.argv[2])
    else:
        assert len(sys.argv)==5 and sys.argv[1]=='verify'; verify(*sys.argv[2:])
