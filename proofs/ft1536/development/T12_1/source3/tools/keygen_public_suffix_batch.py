#!/usr/bin/env python3
"""Seal/verify BATCH_043 without changing any BATCH_015–042 byte."""
from datetime import datetime, timezone
from pathlib import Path
import json
import subprocess
import sys

import job
from keygen_intermediate_batch import path, read, pin, committed, streams
from keygen_public_first_batch import write_receipt
from keygen_public_suffix_audit_source import MODULES, INHERITED, declarations

BASE = 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_043'
ENTRY = '.build/levels_043/ENTRY_PINS_043.json'
ENTRY_SHA = 'c18dc2c83083d0cd3b9d26a5600c09c2c0ee957138fade852b1816430675f8ab'
PRESEAL = '.build/levels_043/PRESEAL.json'
SAGE = 'sage/check_keygen_public_suffix.sage'
CONTROL = '.build/jobs/keygen_public_suffix_checks_043_001'
CAUSES = {
    'keygen_public_suffix_atoms_043_001': 'Explicit Bool false equality and unsigned-promotion argument are needed; remove the unused simp argument.',
    'keygen_public_suffix_atoms_043_002': 'The numeric zero conversion needs a precisely typed equality, not a generic convert_self rewrite.',
    'keygen_public_suffix_atoms_043_003': 'Explicit convert_self still does not match the reduced numeric zero expression; use the exact numeric equality.',
    'keygen_public_suffix_body_043_001': 'After conversions the zero comparison requires a precisely typed change, not an overbroad simplification.',
    'keygen_public_suffix_body_043_002': 'Atoms accepted; whitespace is required around variable i in the less-than syntax.',
    'keygen_public_suffix_body_043_003': 'Dependent elimination of a scoped Result requires generalizing its flow and carrying the normal-flow equation.',
    'keygen_public_suffix_body_043_004': 'Skip elimination substitutes the final state; use after rather than the eliminated last binder.',
    'keygen_public_suffix_body_043_005': 'Variable-dependent footprint goals require the exact empty-writes lemma; dependent if rewrites use simp rather than rw.',
    'keygen_public_suffix_body_043_006': 'Body accepted; initialize the h image pointwise rather than simplifying an opaque Cells function argument.',
    'keygen_public_suffix_loop_043_001': 'Loop accepted; the original-polynomial value definition needs the explicit FT1536.Run2 namespace.',
    'keygen_public_successful_suffix_043_001': 'Polynomial values need noncomputable; rewrite the complete Fin index equality, not a natural value inside its dependent proof.'}


def entry_checked():
    assert not job.active(), 'A proof job is active'
    assert job.sha(path(ENTRY)) == ENTRY_SHA
    entry = read(ENTRY)
    assert entry['batch'] == 'BATCH_015-042'
    assert entry['distinct_pinned_files'] == len(entry['checked']) == 7747
    assert entry['current_source_inputs'] == 652 and entry['active_jobs'] == [] and entry['superseded'] == {}
    for p, expected in entry['checked'].items():
        assert job.sha(path(p)) == expected, ('predecessor changed', p)
    return entry


def predecessor(target):
    entry = entry_checked()
    result = {'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-042',
        'checked':entry['checked'],'distinct_pinned_files':7747,'entry':pin(ENTRY),
        'active_jobs':[],'superseded':{},'verifier_sha256':job.sha(Path(__file__))}
    print(json.dumps({'predecessor_files':7747,'receipt':write_receipt(target,result)},indent=2))


def seal():
    assert not path(BASE+'.json').exists(), 'Never replace a historical pair'
    entry = entry_checked()
    head = subprocess.check_output(['git','rev-parse','HEAD'],cwd=job.REPO,text=True).strip()
    assert subprocess.check_output(['git','branch','--show-current'],cwd=job.REPO,text=True).strip() == 'main'
    assert read(PRESEAL)['checked'] == entry['checked']
    assert read(PRESEAL)['verifier_sha256'] == job.sha(Path(__file__))
    cache = read('.build/cache/CACHE_INDEX.json')
    modules = []
    for name in MODULES+['KeygenPublicSuffixAudit']:
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
    audit_dir = path(cache['Source3.KeygenPublicSuffixAudit']['receipt']).parent
    audit = read(audit_dir/'PUBLIC_SUFFIX_AUDIT.json')
    assert len(audit) == len({e['name'] for e in audit}) == len(declarations())+len(INHERITED)
    assert {e['name'] for e in audit} == set(declarations()) | set(INHERITED)
    assert (audit_dir/'PUBLIC_SUFFIX_AUDIT_ENTRIES.jsonl').read_text().count('\n') == len(audit)
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
    control_dir = path(CONTROL); controls = read(control_dir/'PUBLIC_SUFFIX_CHECK.json')
    control_record = read(control_dir/'RECEIPTS.json')[0]
    assert control_record['accepted'] and control_record['clean_log'] and control_record['exit_code'] == 0
    committed(SAGE,head)
    assert job.sha(path(SAGE)) == job.sha(control_dir/SAGE) == control_record['source_sha256']
    assert controls['status'] == 'PASS_FINITE_SOURCE_CONTROLS' and controls['pairs'] == 8
    assert controls['successful_pairs'] == 7
    assert controls['baseline_tests_per_mode'] == 10753 and controls['baseline_quotients_per_mode'] == 10752
    assert job.sha(control_dir/'PUBLIC_SUFFIX_HEADERS.json') == controls['header_binding_sha256']
    assert job.sha(control_dir/'PUBLIC_SUFFIX_FIXTURE.json') == controls['fixture_sha256']
    assert job.sha(job.OLD/'inputs/source/PROFILE.json') == controls['profile_sha256']
    assert len(controls['variants']) == 12
    control_artifacts = []
    for variant in controls['variants']:
        assert bool(variant['differences']) == (variant['variant'] != 'baseline')
        for p, expected in variant['artifacts'].items():
            assert job.sha(control_dir/p) == expected, p
            control_artifacts.append(pin(control_dir/p))
        for stream in ['compile.stdout','compile.stderr','stderr']:
            assert (control_dir/(variant['mode']+'_'+variant['variant']+'.'+stream)).stat().st_size == 0
    source_pins = []
    for name, expected in controls['source_pins'].items():
        p = job.REPO/'Extra/c'/name
        assert job.sha(p) == expected, p
        source_pins.append(pin(p))
    history = []
    for directory in sorted((job.BUILD/'jobs').glob('keygen_public_*_043_*')):
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
        records = read(directory/'RECEIPTS.json')
        status = 'FAILED_RETAINED' if any(not r['accepted'] for r in records) else 'ACCEPTED'
        assert (directory.name in CAUSES) == (status == 'FAILED_RETAINED'), directory.name
        products = []
        for r in records:
            if 'olean_sha256' in r:
                module = r['name'].replace('Source3_','Source3.',1)
                artifact = directory/'lib'/(module.replace('.','/')+'.olean')
                snapshot = directory/'formal'/(module.replace('.','/')+'.lean')
                assert job.sha(artifact) == r['olean_sha256'] and job.sha(snapshot) == r['source_sha256']
                products.append(pin(artifact))
        wait = job.BUILD/'waits'/directory.name/'WAIT.jsonl'
        history.append({'job':directory.name,'status':status,'cause':CAUSES.get(directory.name),
            'receipt':pin(directory/'RECEIPTS.json'),'source_inputs':pin(directory/'SOURCE_INPUTS.json'),
            'preflight':pin(directory/'PREFLIGHT.json'),'runner_snapshot':pin(directory/'RUNNER_SOURCE.py'),
            'execution_snapshot':pin(directory/'EXECUTION_SOURCE.py'),'wait_log':pin(wait),
            'snapshots':snapshots,'accepted_products':products,
            'raw_files':[pin(p) for p in sorted((directory/'logs').iterdir()) if p.is_file()],
            'steps':[{'name':r['name'],'accepted':r['accepted'],'exit_code':r['exit_code'],
                'elapsed_s':r['elapsed_s'],'maxrss_kib':r['cumulative_child_maxrss_kib'],
                'source_sha256':r['source_sha256'],'logs':streams(directory,r)} for r in records],
            'products':[pin(p) for p in sorted(directory.iterdir()) if p.is_file() and p.name not in
                {'RECEIPTS.json','SOURCE_INPUTS.json','PREFLIGHT.json','RUNNER_SOURCE.py','EXECUTION_SOURCE.py'}]})
    assert {h['job'] for h in history if h['status']=='FAILED_RETAINED'} == set(CAUSES)
    tools = ['tools/job.py','tools/job_when_available.py','tools/keygen_public_suffix_audit_source.py',
        'tools/keygen_public_suffix_batch.py','tools/keygen_public_evaluation_audit_source.py',
        'tools/keygen_public_evaluation_batch.py','tools/keygen_public_first_batch.py',
        'tools/keygen_intermediate_batch.py','formal/Source3/KeygenLevelsAudit.lean']
    for p in tools: committed(p,head)
    notes = path(BASE+'_NOTES.md'); assert notes.exists()
    result = {'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_043','stage':'B1.06',
        'window':'CLOSED_AT_RECOVERABLE_MIDPOINT','b1_06_acceptance':'NOT_MET','stage_result':'PARTIAL_PROOF',
        'status':'IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN',
        'harness':'GPT-6.1 Sol Fast / openai/gpt-6.1-sol-fast',
        'runner_labels':'Historical runner model/session constants are provenance, not the043 worker attribution.',
        'created_utc':datetime.now(timezone.utc).isoformat(),'proof_head':head,'notes':pin(notes),
        'entry_pins_receipt':pin(ENTRY),'predecessor_files':7747,'preseal_predecessor_receipt':pin(PRESEAL),
        'superseded':{},'accepted_module_checks':modules,'current_final_audit_inputs':len(inputs['sources'])+len(inputs['reused']),
        'audit':{**pin(audit_dir/'PUBLIC_SUFFIX_AUDIT.json'),'entries_jsonl':pin(audit_dir/'PUBLIC_SUFFIX_AUDIT_ENTRIES.jsonl'),
            'receipt':pin(audit_dir/'RECEIPTS.json'),'source_inputs':pin(audit_dir/'SOURCE_INPUTS.json'),
            'generator':pin('tools/keygen_public_suffix_audit_source.py'),'producer':pin('formal/Source3/KeygenPublicSuffixAudit.lean'),
            'exports':len(audit),'named_declarations':len(declarations()),'inherited_interfaces':len(INHERITED),
            'full_terms':sum('term' in e['body'] for e in audit),'kernel_inductives':sum('constructors' in e['body'] for e in audit),
            'elisions':0,'allowed_axioms':['propext','Classical.choice','Quot.sound']},
        'sage':{'source':pin(SAGE),'receipt':pin(control_dir/'RECEIPTS.json'),'source_inputs':pin(control_dir/'SOURCE_INPUTS.json'),
            'result':pin(control_dir/'PUBLIC_SUFFIX_CHECK.json'),'source_files':source_pins,'artifacts':control_artifacts,
            'fixture':pin(control_dir/'PUBLIC_SUFFIX_FIXTURE.json'),'header_binding':pin(control_dir/'PUBLIC_SUFFIX_HEADERS.json'),
            'profile':pin(job.OLD/'inputs/source/PROFILE.json'),
            'logs':streams(control_dir,control_record,True),'pairs':8,'runs':12,
            'baseline_tests_per_mode':controls['baseline_tests_per_mode'],
            'baseline_quotients_per_mode':controls['baseline_quotients_per_mode'],'scope':controls['scope']},
        'attempt_details':history,'attempt_counts':{s:sum(h['status']==s for h in history) for s in ['ACCEPTED','FAILED_RETAINED']},
        'contracts':{
            'common_afterT':'The complete source call derives both ORIGINAL evaluation arrays at the SAME afterT, with actual f/g/t/h bindings and n1536/q18433/u1536/logn10/ternary1.',
            'tests':'The complete loop either returns source failure0 or tests all1536 original f evaluations as nonzero; no input nonzero premise.',
            'division':'The actual chronological stores yield all1536 canonical g/f cells and preserve every t/f cell at the actual inverse-call entry.',
            'headline':'KeygenPublicSuccessfulSuffix.source_same_material consumes legal/profile/material/bounds1/nonalias/static-table-liveness and actual successful compute Exec; it retains the SAME actual inverse execution and final t disposal, without inverse correctness.'},
        'open_in_b1_06':[
            'Item3: prove the actual inverse/normalization and final canonical h from the retained SAME inverse execution and derived quotient entry.',
            'Item4 THEN: construct fInv via nonzero evaluations/proved evaluation isomorphism and conclude BOTH SAME-material mulRq equations.'],
        'explicit_legal_memory':'The new common-state frame explicitly requires static tables not aliasing the h output block. Enclosing KeyGen must derive it; it is not an evaluation/nonzero/correctness premise.',
        'tools':[pin(p) for p in tools],
        'source_commits':subprocess.check_output(['git','log','--reverse','--format=%H %s','52c4ebeb..'+head,
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
    assert batch['batch']=='BATCH_043' and batch['superseded']=={} and batch['active_jobs_at_close']==[]
    assert batch['entry_pins_receipt']['sha256']==ENTRY_SHA
    for p, expected in entry_checked()['checked'].items(): check(p,expected)
    inputs = read(batch['audit']['source_inputs']['path'])
    for e in inputs['sources']: check(e['path'],e['sha256'])
    for e in inputs['reused']:
        check(e.get('current_source',e['source']),e['source_sha256']); check(e['artifact'],e['artifact_sha256'])
    assert not job.active(), 'A proof job is active'
    result = {'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-043','checked':checked,
        'distinct_pinned_files':len(checked),'current_source_inputs':batch['current_final_audit_inputs'],
        'active_jobs':[],'superseded':{},'verifier_sha256':job.sha(Path(__file__))}
    print(json.dumps({**{k:v for k,v in result.items() if k!='checked'},'receipt':write_receipt(target,result)},indent=2))


if __name__ == '__main__':
    if sys.argv[1:] == ['seal']: seal()
    elif sys.argv[1:2] == ['predecessor']:
        assert len(sys.argv)==3; predecessor(sys.argv[2])
    else:
        assert len(sys.argv)==5 and sys.argv[1]=='verify'; verify(*sys.argv[2:])
