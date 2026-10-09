#!/usr/bin/env python3
"""Seal/verify BATCH_034 without changing BATCH_015–033 or failed histories."""
from datetime import datetime, timezone
import json
from pathlib import Path
import subprocess
import sys

import job
from keygen_intermediate_batch import path, read, pin, committed, streams
from keygen_public_tables_audit_source import MODULES, INHERITED, declarations

BASE = 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_034'
ENTRY = '.build/levels_034/ENTRY_PINS_034.json'
ENTRY_SHA = '53d81c7181148871c32177a3af7a7dbe80e960096fbeb8b1d7ce16ac5cf3cc9a'
PRESEAL = '.build/levels_034/PRESEAL_PREDECESSOR.json'
CONTROL = '.build/jobs/keygen_public_tables_checks_034_001'


def seal():
    assert not path(BASE+'.json').exists(), 'Never replace a historical pair'
    assert not job.active()
    head = subprocess.check_output(['git','rev-parse','HEAD'],cwd=job.REPO,text=True).strip()
    assert subprocess.check_output(['git','branch','--show-current'],cwd=job.REPO,text=True).strip() == 'main'
    assert job.sha(path(ENTRY)) == ENTRY_SHA
    entry = read(ENTRY)
    assert entry['distinct_pinned_files'] == 5308 and entry['active_jobs'] == [] and entry['superseded'] == {}
    assert read(PRESEAL)['checked'] == entry['checked']
    for p,expected in entry['checked'].items():
        assert job.sha(path(p)) == expected, ('predecessor changed',p)
    cache = read('.build/cache/CACHE_INDEX.json')
    accepted = {}; modules = []
    for name in MODULES+['KeygenPublicTablesAudit']:
        module = 'Source3.'+name; current = cache[module]
        source = Path(current['source']); receipt = Path(current['receipt']); directory = receipt.parent
        committed(source,head)
        record = next(r for r in read(receipt) if r['name'] == module.replace('.','_'))
        assert record['accepted'] and record['clean_log'] and record['exit_code'] == 0
        assert record['forbidden_proof_markers'] == [] and record['cumulative_child_maxrss_kib'] <= 8*1024*1024
        snapshot = directory/'formal/Source3'/(name+'.lean'); artifact = directory/'lib/Source3'/(name+'.olean')
        assert job.sha(source) == job.sha(snapshot) == record['source_sha256'] == current['source_sha256']
        assert job.sha(artifact) == job.sha(Path(current['artifact'])) == record['olean_sha256'] == current['artifact_sha256']
        for imported,expected in current.get('imports',{}).items():
            if imported in cache: assert cache[imported]['artifact_sha256'] == expected, (module,imported)
        accepted[name] = pin(source)
        modules.append({'module':module,'source':pin(source),'snapshot':pin(snapshot),'artifact':pin(artifact),
            'receipt':pin(receipt),'source_inputs':pin(directory/'SOURCE_INPUTS.json'),'logs':streams(directory,record,True),
            'imports':current.get('imports',{}),'elapsed_s':record['elapsed_s'],'maxrss_kib':record['cumulative_child_maxrss_kib']})
    audit_dir = Path(cache['Source3.KeygenPublicTablesAudit']['receipt']).parent
    audit = read(audit_dir/'PUBLIC_TABLES_AUDIT.json')
    assert len(audit) == len({e['name'] for e in audit}) == len(declarations())+len(INHERITED)
    assert set(declarations()) <= {e['name'] for e in audit}
    for e in audit:
        assert set(e['axioms']) <= {'propext','Classical.choice','Quot.sound'}
        assert '⋯' not in json.dumps(e,ensure_ascii=False)
    inputs = read(audit_dir/'SOURCE_INPUTS.json')
    for e in inputs['sources']: assert job.sha(path(e['path'])) == e['sha256']
    for e in inputs['reused']:
        assert job.sha(path(e.get('current_source',e['source']))) == e['source_sha256']
        assert job.sha(path(e['artifact'])) == e['artifact_sha256']
    control_dir = path(CONTROL); controls = read(control_dir/'PUBLIC_TABLES_CHECK.json')
    record = read(control_dir/'RECEIPTS.json')[0]
    assert record['accepted'] and record['clean_log'] and record['exit_code'] == 0
    sage_source = 'sage/check_keygen_public_tables.sage'; committed(sage_source,head)
    assert job.sha(path(sage_source)) == job.sha(control_dir/sage_source) == record['source_sha256']
    assert len(controls['variants']) == 8
    assert job.sha(control_dir/'PUBLIC_TABLES_FIXTURE.json') == controls['fixture_sha256']
    assert job.sha(job.OLD/'inputs/source/PROFILE.json') == controls['profile_sha256']
    control_artifacts = [pin(control_dir/'PUBLIC_TABLES_FIXTURE.json')]
    for variant in controls['variants']:
        assert variant['counts'] == {'R':1025,'K':1,'S':1,'G':2050}
        assert bool(variant['detected_differences']) == (variant['variant'] != 'baseline')
        for p,expected in variant['artifacts'].items():
            p = control_dir/p; assert job.sha(p) == expected,p
            control_artifacts.append(pin(p))
    source_pins = []
    for name,expected in controls['source_pins'].items():
        p = job.OLD/'inputs/source'/name; assert job.sha(p) == expected,p
        source_pins.append(pin(p))
    directories = sorted((job.BUILD/'jobs').glob('keygen_public_*_034_*'))
    # Cache paths are mutable. Resolve every superseded within-window reused
    # product to its original immutable job output and matching snapshot.
    products = {}
    for directory in directories:
        assert (directory/'RECEIPTS.json').exists(), ('unaccounted receipt-less attempt',directory)
        for r in read(directory/'RECEIPTS.json'):
            if 'olean_sha256' not in r: continue
            module = r['name'].replace('Source3_','Source3.',1)
            artifact = directory/'lib'/(module.replace('.','/')+'.olean')
            snapshot = directory/'formal'/(module.replace('.','/')+'.lean')
            assert job.sha(artifact) == r['olean_sha256'] and job.sha(snapshot) == r['source_sha256']
            products[(module,r['olean_sha256'])] = {'artifact':pin(artifact),'source_snapshot':pin(snapshot),
                'receipt':pin(directory/'RECEIPTS.json')}
    history = []; resolutions = {}
    for directory in directories:
        records = read(directory/'RECEIPTS.json'); inventory = read(directory/'SOURCE_INPUTS.json'); snapshots = []
        for e in inventory['sources']:
            rel = 'formal/'+e['module'].replace('.','/')+'.lean' if 'module' in e else 'sage/'+Path(e['path']).name
            p = directory/rel; assert job.sha(p) == e['sha256'],p
            snapshots.append(pin(p))
        for e in inventory['reused']:
            current_source = path(e.get('current_source',e['source'])); artifact = path(e['artifact'])
            if job.sha(current_source) != e['source_sha256'] or job.sha(artifact) != e['artifact_sha256']:
                key = (e['module'],e['artifact_sha256']); assert key in products, ('missing immutable old product',key)
                resolved = products[key]; assert resolved['source_snapshot']['sha256'] == e['source_sha256']
                resolutions[e['module']+'@'+e['artifact_sha256']] = {'module':e['module'],
                    'recorded_source_path':str(current_source),'recorded_source_sha256':e['source_sha256'],
                    'recorded_artifact_path':str(artifact),'recorded_artifact_sha256':e['artifact_sha256'],**resolved}
        diagnostic = directory.name == 'keygen_public_rev_probe_034_002'
        status = 'FAILED_RETAINED' if any(not r['accepted'] for r in records) else ('DIAGNOSTIC_NOT_PROOF' if diagnostic else 'ACCEPTED')
        steps = [{'name':r['name'],'accepted_by_runner':r['accepted'],'exit_code':r['exit_code'],
            'elapsed_s':r['elapsed_s'],'maxrss_kib':r['cumulative_child_maxrss_kib'],
            'source_sha256':r['source_sha256'],'logs':streams(directory,r)} for r in records]
        history.append({'job':directory.name,'status':status,'receipt':pin(directory/'RECEIPTS.json'),
            'source_inputs':pin(directory/'SOURCE_INPUTS.json'),'preflight':pin(directory/'PREFLIGHT.json'),
            'snapshots':snapshots,'steps':steps,
            'accepted_products':[p for key,p in products.items() if Path(path(p['receipt']['path'])).parent == directory],
            'products':[pin(p) for p in sorted(directory.iterdir()) if p.is_file() and p.suffix in {'.json','.jsonl','.c','.stdout','.stderr'}
                and p.name not in {'RECEIPTS.json','SOURCE_INPUTS.json','PREFLIGHT.json'}]})
    tools = ['tools/job.py','tools/job_when_available.py','tools/keygen_public_rev_certificate.py',
        'tools/keygen_public_tables_audit_source.py','tools/keygen_public_tables_batch.py',
        'tools/keygen_public_batch.py','tools/keygen_intermediate_batch.py',
        'formal/Source3/KeygenLevelsAudit.lean','formal/Source3/KeygenPublicRevProbe.lean']
    for p in tools: committed(p,head)
    notes = path(BASE+'_NOTES.md'); assert notes.exists()
    output = {'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_034','stage':'B1.06',
        'window':'CLOSED_AT_RECOVERABLE_MIDPOINT','b1_06_acceptance':'NOT_MET','stage_result':'PARTIAL_PROOF',
        'status':'IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN',
        'harness':'GPT-6.1 Sol Fast / openai/gpt-6.1-sol-fast','runner_labels':'Historical constants, not current attribution.',
        'created_utc':datetime.now(timezone.utc).isoformat(),'proof_head':head,'notes':pin(notes),
        'entry_pins_receipt':pin(ENTRY),'predecessor_files':5308,'superseded':{},'preseal_predecessor_receipt':pin(PRESEAL),
        'accepted_modules':accepted,'accepted_module_checks':modules,
        'current_final_audit_inputs':len(inputs['sources'])+len(inputs['reused']),
        'audit':{**pin(audit_dir/'PUBLIC_TABLES_AUDIT.json'),'receipt':pin(audit_dir/'RECEIPTS.json'),
            'source_inputs':pin(audit_dir/'SOURCE_INPUTS.json'),'exports':len(audit),
            'generator':pin('tools/keygen_public_tables_audit_source.py'),'producer':pin('formal/Source3/KeygenPublicTablesAudit.lean'),
            'covered_named_source_declarations':len(declarations()),'inherited_interfaces':len(INHERITED),
            'full_terms':sum('term' in e['body'] for e in audit),
            'kernel_inductives_with_constructor_types':sum('constructors' in e['body'] for e in audit),
            'elisions':0,'allowed_axioms':['propext','Classical.choice','Quot.sound']},
        'sage':{'source':pin(sage_source),'receipt':pin(control_dir/'RECEIPTS.json'),
            'source_inputs':pin(control_dir/'SOURCE_INPUTS.json'),'result':pin(control_dir/'PUBLIC_TABLES_CHECK.json'),
            'profile':pin(job.OLD/'inputs/source/PROFILE.json'),'source_files':source_pins,'logs':streams(control_dir,record,True),
            'artifacts':control_artifacts,'runs':8,'mutations_per_mode':3,'scope':controls['scope']},
        'attempt_details':history,'attempt_counts':{status:sum(e['status']==status for e in history)
            for status in ['ACCEPTED','FAILED_RETAINED','DIAGNOSTIC_NOT_PROOF']},
        'within_window_earlier_product_resolution':list(resolutions.values()),
        'contracts':{
            'rev':'Complete actual rev10 Body and observed return derive ten-iteration uint32 result. All1024 reached-domain inputs kernel-bound to bitrev10; source2*u specializes to reverse9. No static solver table substitutes for function execution.',
            'generator':'SAME complete mq_mkgm3 logn10 execution derives real prefix and else last-row entry; canonical/scaled g/ig/x/ix/g2/g4/ig2/ig4. Actual k++ squares once and leaves12. No generated table image is supplied or yet concluded.',
            'cells':'Uint16 narrowing/promotion/written-cell reads and same-array/separated-table byte frames are proved local adapters. They do NOT populate complete gm/igm tables.',
            'boundary':'B1.06 Acceptance NOT MET; B1.05 remains BATCH_032. No full generated tables/public transforms/nonzero/fInv/SAME-material equations, full KeyGen/emitted/security or independent review.'},
        'open_in_b1_06':['Remaining source last-row entry: derive k1/b512/u0, all paired writes and actual rev10 argument conversions with exponent/canonical/byte invariants for BOTH tables.',
            'Derive cubing/upward rows and copy gm0; exceptional igm0 equals radix/(2*firstRoot-1), not inverse(firstRoot). Compose complete legal layout/automatic lifetime/table images.',
            'Actual signed f/g conversion and complete forward NTT canonical/evaluation refinement with physical order.',
            'SAME successful public execution yields all nonzero tests and division; actual inverse/normalization gives canonical h.',
            'Construct fInv and derive both Relation.mulRq equations for SAME retained f/g/h.'],
        'later':['B1.07 whole caller/attempt control','B1.08–B1.11 codecs/emitted-to-fiber/final replay/owner-arranged review'],
        'tools':[pin(p) for p in tools],
        'source_commits':subprocess.check_output(['git','log','--reverse','--format=%H %s','736a6e19..'+head,
            '--',str(job.ROOT.relative_to(job.REPO))],cwd=job.REPO,text=True).splitlines(),
        'active_jobs_at_close':[],'push_by_this_worker':False,
        'limits':'Unchanged Lean j1/-M6144,AS12GiB/RSS8GiB,wall1800s,maxHeartbeats2000000,print200000; 0/0 proof streams, Sage standard preparser ZZ.'}
    with path(BASE+'.json').open('x') as stream: json.dump(output,stream,indent=2); stream.write('\n')
    print(json.dumps({'batch':pin(BASE+'.json'),'notes':pin(notes),'modules':len(modules),'audited':len(audit),
        'attempts':len(history),'inputs':output['current_final_audit_inputs'],'within_window_resolutions':len(resolutions)},indent=2))


def verify(batch_sha, notes_sha, receipt):
    checked = {}
    def check(p, expected):
        p=path(p); actual=job.sha(p); assert actual == expected,(str(p),expected,actual)
        checked[str(p)] = actual
    def walk(value):
        if isinstance(value,dict):
            if 'path' in value and 'sha256' in value: check(value['path'],value['sha256'])
            for child in value.values(): walk(child)
        elif isinstance(value,list):
            for child in value: walk(child)
    check(BASE+'.json',batch_sha); check(BASE+'_NOTES.md',notes_sha)
    batch=read(BASE+'.json'); walk(batch)
    for p,expected in read(batch['entry_pins_receipt']['path'])['checked'].items(): check(p,expected)
    inputs=read(batch['audit']['source_inputs']['path'])
    for e in inputs['sources']: check(e['path'],e['sha256'])
    for e in inputs['reused']:
        check(e.get('current_source',e['source']),e['source_sha256']); check(e['artifact'],e['artifact_sha256'])
    assert not job.active()
    result={'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_034','checked':checked,
        'distinct_pinned_files':len(checked),'current_source_inputs':batch['current_final_audit_inputs'],
        'active_jobs':[],'superseded':{},'verifier_sha256':job.sha(Path(__file__))}
    target=path(receipt); assert target.is_relative_to(job.BUILD.resolve())
    with target.open('x') as stream: json.dump(result,stream,indent=2); stream.write('\n')
    print(json.dumps({**{k:v for k,v in result.items() if k!='checked'},'receipt':pin(target)},indent=2))


if __name__ == '__main__':
    if sys.argv[1:] == ['seal']: seal()
    else:
        assert len(sys.argv)==5 and sys.argv[1]=='verify'
        verify(*sys.argv[2:])
