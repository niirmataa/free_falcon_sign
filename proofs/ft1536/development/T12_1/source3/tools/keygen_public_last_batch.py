#!/usr/bin/env python3
"""Seal/verify BATCH_035, retaining all BATCH_015–034 and attempt bytes."""
from datetime import datetime, timezone
import json
from pathlib import Path
import subprocess
import sys

import job
from keygen_intermediate_batch import path, read, pin, committed, streams
from keygen_public_last_audit_source import MODULES, INHERITED, declarations

BASE = 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_035'
ENTRY = '.build/levels_035/ENTRY_PINS_035.json'
ENTRY_SHA = '7a9f11c2eb138bd33182dea526d396e6b774a4c68adcace10b90ae6436f953cf'
PRESEAL = '.build/levels_035/PRESEAL_PREDECESSOR.json'
CONTROL = '.build/jobs/keygen_public_last_checks_035_003'


def seal():
    assert not path(BASE+'.json').exists(), 'Never replace a historical pair'
    assert not job.active()
    head = subprocess.check_output(['git','rev-parse','HEAD'],cwd=job.REPO,text=True).strip()
    assert subprocess.check_output(['git','branch','--show-current'],cwd=job.REPO,text=True).strip() == 'main'
    assert job.sha(path(ENTRY)) == ENTRY_SHA
    entry = read(ENTRY)
    assert entry['distinct_pinned_files'] == 5674 and entry['active_jobs'] == [] and entry['superseded'] == {}
    assert read(PRESEAL)['checked'] == entry['checked']
    for p,expected in entry['checked'].items():
        assert job.sha(path(p)) == expected, ('predecessor changed',p)
    cache = read('.build/cache/CACHE_INDEX.json')
    accepted = {}; modules = []
    for name in MODULES+['KeygenPublicLastAudit']:
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
    audit_dir = Path(cache['Source3.KeygenPublicLastAudit']['receipt']).parent
    audit = read(audit_dir/'PUBLIC_LAST_AUDIT.json')
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
    control_dir = path(CONTROL); controls = read(control_dir/'PUBLIC_LAST_CHECK.json')
    record = read(control_dir/'RECEIPTS.json')[0]
    assert record['accepted'] and record['clean_log'] and record['exit_code'] == 0
    sage_source = 'sage/check_keygen_public_last_row.sage'; committed(sage_source,head)
    assert job.sha(path(sage_source)) == job.sha(control_dir/sage_source) == record['source_sha256']
    assert len(controls['variants']) == 12
    assert job.sha(control_dir/'PUBLIC_LAST_FIXTURE.json') == controls['fixture_sha256']
    assert job.sha(job.OLD/'inputs/source/PROFILE.json') == controls['profile_sha256']
    control_artifacts = [pin(control_dir/'PUBLIC_LAST_FIXTURE.json')]
    for variant in controls['variants']:
        pairs = 255 if variant['variant'] == 'skips_last_pair' else 256
        assert variant['counts'] == {'P':pairs,'T':1,'L':2050,'C':256,'S':255}
        assert bool(variant['detected_differences']) == (variant['variant'] != 'baseline')
        for p,expected in variant['artifacts'].items():
            p = control_dir/p; assert job.sha(p) == expected,p
            control_artifacts.append(pin(p))
    source_pins = []
    for name,expected in controls['source_pins'].items():
        p = job.OLD/'inputs/source'/name; assert job.sha(p) == expected,p
        source_pins.append(pin(p))
    directories = sorted((job.BUILD/'jobs').glob('keygen_public_*_035_*'))
    # run_cmd-only audit sources can have identical oleans. Historical
    # provenance therefore requires BOTH source and artifact digests.
    products = {}
    for directory in directories:
        assert (directory/'RECEIPTS.json').exists(), ('unaccounted receipt-less attempt',directory)
        for r in read(directory/'RECEIPTS.json'):
            if 'olean_sha256' not in r: continue
            module = r['name'].replace('Source3_','Source3.',1)
            artifact = directory/'lib'/(module.replace('.','/')+'.olean')
            snapshot = directory/'formal'/(module.replace('.','/')+'.lean')
            assert job.sha(artifact) == r['olean_sha256'] and job.sha(snapshot) == r['source_sha256']
            products[(module,r['olean_sha256'],r['source_sha256'])] = {'artifact':pin(artifact),'source_snapshot':pin(snapshot),
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
                key = (e['module'],e['artifact_sha256'],e['source_sha256'])
                assert key in products, ('missing immutable old source/product pair',key)
                resolved = products[key]; assert resolved['source_snapshot']['sha256'] == e['source_sha256']
                resolutions['@'.join(key)] = {'module':e['module'],
                    'recorded_source_path':str(current_source),'recorded_source_sha256':e['source_sha256'],
                    'recorded_artifact_path':str(artifact),'recorded_artifact_sha256':e['artifact_sha256'],**resolved}
        status = 'FAILED_RETAINED' if any(not r['accepted'] for r in records) else 'ACCEPTED'
        steps = [{'name':r['name'],'accepted_by_runner':r['accepted'],'exit_code':r['exit_code'],
            'elapsed_s':r['elapsed_s'],'maxrss_kib':r['cumulative_child_maxrss_kib'],
            'source_sha256':r['source_sha256'],'logs':streams(directory,r)} for r in records]
        history.append({'job':directory.name,'status':status,'receipt':pin(directory/'RECEIPTS.json'),
            'source_inputs':pin(directory/'SOURCE_INPUTS.json'),'preflight':pin(directory/'PREFLIGHT.json'),
            'wait_log':pin(job.BUILD/'waits'/directory.name/'WAIT.jsonl'),
            'snapshots':snapshots,'steps':steps,
            'accepted_products':[p for p in products.values() if path(p['receipt']['path']).parent == directory],
            'products':[pin(p) for p in sorted(directory.iterdir()) if p.is_file() and p.suffix in {'.json','.jsonl','.c','.stdout','.stderr'}
                and p.name not in {'RECEIPTS.json','SOURCE_INPUTS.json','PREFLIGHT.json'}]})
    tools = ['tools/job.py','tools/job_when_available.py','tools/keygen_public_last_audit_source.py',
        'tools/keygen_public_last_batch.py','tools/keygen_public_tables_batch.py',
        'tools/keygen_intermediate_batch.py','formal/Source3/KeygenLevelsAudit.lean']
    for p in tools: committed(p,head)
    notes = path(BASE+'_NOTES.md'); assert notes.exists()
    output = {'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_035','stage':'B1.06',
        'window':'CLOSED_AT_RECOVERABLE_MIDPOINT','b1_06_acceptance':'NOT_MET','stage_result':'PARTIAL_PROOF',
        'status':'IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN',
        'harness':'GPT-6 Astra / openai/gpt-6-astra','runner_labels':'Historical session constants, not a new worker/session.',
        'created_utc':datetime.now(timezone.utc).isoformat(),'proof_head':head,'notes':pin(notes),
        'entry_pins_receipt':pin(ENTRY),'predecessor_files':5674,'superseded':{},'preseal_predecessor_receipt':pin(PRESEAL),
        'accepted_modules':accepted,'accepted_module_checks':modules,
        'current_final_audit_inputs':len(inputs['sources'])+len(inputs['reused']),
        'audit':{**pin(audit_dir/'PUBLIC_LAST_AUDIT.json'),'receipt':pin(audit_dir/'RECEIPTS.json'),
            'source_inputs':pin(audit_dir/'SOURCE_INPUTS.json'),'exports':len(audit),
            'generator':pin('tools/keygen_public_last_audit_source.py'),'producer':pin('formal/Source3/KeygenPublicLastAudit.lean'),
            'covered_named_source_declarations':len(declarations()),'inherited_interfaces':len(INHERITED),
            'full_terms':sum('term' in e['body'] for e in audit),
            'kernel_inductives_with_constructor_types':sum('constructors' in e['body'] for e in audit),
            'elisions':0,'allowed_axioms':['propext','Classical.choice','Quot.sound']},
        'sage':{'source':pin(sage_source),'receipt':pin(control_dir/'RECEIPTS.json'),
            'source_inputs':pin(control_dir/'SOURCE_INPUTS.json'),'result':pin(control_dir/'PUBLIC_LAST_CHECK.json'),
            'profile':pin(job.OLD/'inputs/source/PROFILE.json'),'source_files':source_pins,'logs':streams(control_dir,record,True),
            'artifacts':control_artifacts,'runs':12,'mutations_per_mode':5,'scope':controls['scope']},
        'attempt_details':history,'attempt_counts':{status:sum(e['status']==status for e in history)
            for status in ['ACCEPTED','FAILED_RETAINED']},
        'within_window_earlier_product_resolution':list(resolutions.values()),
        'packaging_failure':pin('.build/levels_035/SEAL_001_FAILURE.json'),
        'failed_packaging_tool':pin('.build/levels_035/SEAL_001_TOOL.py'),
        'contracts':{
            'last_row':'SAME complete generator execution and local logn10/pointer-width/separation domains derive k1/b512/u0, all256 paired-store iterations, BOTH canonical scaled physical images512..1023, terminal u512, byte/allocation frame, original logn and remaining source suffix. No generated image or loop outcome premise.',
            'upward_bodies':'Complete parsed cube and square bodies derive BOTH per-cell row updates from their explicit local child-cell/counter/pointer domains, including uint16 promotion, actual Montgomery calls and cross-table frames. These domains remain to be supplied by enclosing source-loop composition.',
            'boundary':'B1.06 Acceptance NOT MET; B1.05 remains BATCH_032. No full generated tables/automatic lifetime, public NTTs, nonzero/fInv/SAME-material equations, full KeyGen/emitted/security or independent review.'},
        'open_in_b1_06':['Compose actual k=logn-2/u initializations and both upward loops from source_last_row, deriving every child-cell/counter domain and retaining SAME memory.',
            'Actual gm0 copy and exceptional igm0=radix/(2*firstRoot-1); full BOTH table images and automatic-array/caller layout.',
            'Actual f/g conversions and complete forward NTT canonical/evaluation refinement in physical root order.',
            'Successful public source execution yields all nonzero tests, division, actual inverse/normalization and canonical h.',
            'Construct fInv through evaluation isomorphism and derive BOTH Relation.mulRq equations for SAME f/g/h.'],
        'later':['B1.07 whole caller/attempt control','B1.08–B1.11 codecs/emitted-to-fiber/final replay/owner-arranged review'],
        'tools':[pin(p) for p in tools],
        'source_commits':subprocess.check_output(['git','log','--reverse','--format=%H %s','a235e16b..'+head,
            '--',str(job.ROOT.relative_to(job.REPO))],cwd=job.REPO,text=True).splitlines(),
        'active_jobs_at_close':[],'push_by_this_worker':False,
        'limits':'Unchanged Lean j1/-M6144,AS12GiB/RSS8GiB,wall1800s,maxHeartbeats2000000,print200000; 0/0 proof streams,Sage standard preparser ZZ.'}
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
    result={'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_035','checked':checked,
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
