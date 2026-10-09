#!/usr/bin/env python3
"""Seal/verify BATCH_033; preserve BATCH_015–032 and every failed attempt."""
from datetime import datetime, timezone
import json
from pathlib import Path
import subprocess
import sys

import job
from keygen_intermediate_batch import path, read, pin, committed, streams
from keygen_public_audit_source import MODULES, INHERITED, declarations

BASE = 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_033'
ENTRY = '.build/levels_033/ENTRY_PINS_033.json'
ENTRY_SHA = '0173a014e06b217e3e47053148de2fe410749a0d29d929c2e0d46b7fb0249ba5'
PRESEAL = '.build/levels_033/PRESEAL_PREDECESSOR.json'
CONTROL_JOB = '.build/jobs/keygen_public_checks_033_002'


def seal():
    assert not path(BASE+'.json').exists(), 'Never replace a historical pair'
    assert not job.active(), 'Proof job still active'
    head = subprocess.check_output(['git','rev-parse','HEAD'],cwd=job.REPO,text=True).strip()
    assert subprocess.check_output(['git','branch','--show-current'],cwd=job.REPO,text=True).strip() == 'main'
    assert job.sha(path(ENTRY)) == ENTRY_SHA
    entry = read(ENTRY)
    assert entry['distinct_pinned_files'] == 5019 and entry['active_jobs'] == [] and entry['superseded'] == {}
    assert read(PRESEAL)['checked'] == entry['checked']
    for p,expected in entry['checked'].items():
        assert job.sha(path(p)) == expected, ('predecessor changed',p)
    cache = read('.build/cache/CACHE_INDEX.json')
    accepted = {}; modules = []
    for name in MODULES+['KeygenPublicAudit']:
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
    audit_dir = Path(cache['Source3.KeygenPublicAudit']['receipt']).parent
    audit = read(audit_dir/'PUBLIC_AUDIT.json')
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
    controls_dir = path(CONTROL_JOB); controls = read(controls_dir/'PUBLIC_CHECK.json')
    record = read(controls_dir/'RECEIPTS.json')[0]
    assert record['accepted'] and record['clean_log'] and record['exit_code'] == 0
    sage_source = 'sage/check_keygen_public.sage'; committed(sage_source,head)
    assert job.sha(path(sage_source)) == job.sha(controls_dir/sage_source) == record['source_sha256']
    assert len(controls['variants']) == 14
    assert job.sha(controls_dir/'PUBLIC_FIXTURE.json') == controls['fixture_sha256']
    assert job.sha(job.OLD/'inputs/source/PROFILE.json') == controls['profile_sha256']
    control_artifacts = [pin(controls_dir/'PUBLIC_FIXTURE.json')]
    for variant in controls['variants']:
        assert variant['counts'] == {'S':18433,'C':18433,'G':2048,'T':7,'I':7,'P':4}
        assert bool(variant['detected_differences']) == (variant['variant'] != 'baseline')
        for p,expected in variant['artifacts'].items():
            p = controls_dir/p; assert job.sha(p) == expected,p
            control_artifacts.append(pin(p))
    source_pins = []
    for name,expected in controls['source_pins'].items():
        p = job.OLD/'inputs/source'/name; assert job.sha(p) == expected,p
        source_pins.append(pin(p))
    history = []
    for directory in sorted((job.BUILD/'jobs').glob('keygen_public_*_033_*')):
        if not (directory/'RECEIPTS.json').exists():
            assert directory.name == 'keygen_public_division_033_001', ('unaccounted receipt-less attempt',directory)
            interruption = read(directory/'HARNESS_INTERRUPTION.json')
            assert interruption['event'] == 'EXTERNAL_TOOL_TIMEOUT_120_SECONDS' and interruption['accepted'] is False
            inventory = read(directory/'SOURCE_INPUTS.json')
            for e in inventory['sources']:
                snapshot = directory/'formal'/(e['module'].replace('.','/')+'.lean')
                assert job.sha(snapshot) == e['sha256'],snapshot
            files = [pin(p) for p in sorted(directory.rglob('*')) if p.is_file() and not p.is_symlink()]
            history.append({'job':directory.name,'status':'EXTERNAL_INTERRUPTION_NO_RECEIPT','files':files,
                'reason':interruption,'receipt':'ABSENT_NOT_RECONSTRUCTED'})
            continue
        records = read(directory/'RECEIPTS.json'); inventory = read(directory/'SOURCE_INPUTS.json'); snapshots = []
        for e in inventory['sources']:
            rel = 'formal/'+e['module'].replace('.','/')+'.lean' if 'module' in e else 'sage/'+Path(e['path']).name
            p = directory/rel; assert job.sha(p) == e['sha256'],p
            snapshots.append(pin(p))
        steps = [{'name':r['name'],'accepted_by_runner':r['accepted'],'exit_code':r['exit_code'],
            'elapsed_s':r['elapsed_s'],'maxrss_kib':r['cumulative_child_maxrss_kib'],
            'source_sha256':r['source_sha256'],'logs':streams(directory,r)} for r in records]
        history.append({'job':directory.name,'status':'FAILED_RETAINED' if any(not r['accepted'] for r in records) else 'ACCEPTED',
            'receipt':pin(directory/'RECEIPTS.json'),'source_inputs':pin(directory/'SOURCE_INPUTS.json'),
            'preflight':pin(directory/'PREFLIGHT.json'),'snapshots':snapshots,'steps':steps,
            'products':[pin(p) for p in sorted(directory.iterdir()) if p.is_file() and p.suffix in {'.json','.jsonl','.c','.stdout','.stderr'}
                and p.name not in {'RECEIPTS.json','SOURCE_INPUTS.json','PREFLIGHT.json'}]})
    tools = ['tools/job.py','tools/job_when_available.py','tools/keygen_public_audit_source.py',
        'tools/keygen_public_batch.py','tools/keygen_caller_batch.py','tools/keygen_intermediate_batch.py',
        'formal/Source3/KeygenLevelsAudit.lean']
    for p in tools: committed(p,head)
    notes = path(BASE+'_NOTES.md'); assert notes.exists()
    output = {'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_033','stage':'B1.06',
        'window':'CLOSED_AT_RECOVERABLE_MIDPOINT','b1_06_acceptance':'NOT_MET','stage_result':'PARTIAL_PROOF',
        'status':'IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN',
        'harness':'GPT-6.1 Sol Fast / openai/gpt-6.1-sol-fast','runner_labels':'Historical constants, not current attribution.',
        'created_utc':datetime.now(timezone.utc).isoformat(),'proof_head':head,'notes':pin(notes),
        'entry_pins_receipt':pin(ENTRY),'predecessor_files':5019,'superseded':{},'preseal_predecessor_receipt':pin(PRESEAL),
        'accepted_modules':accepted,'accepted_module_checks':modules,
        'current_final_audit_inputs':len(inputs['sources'])+len(inputs['reused']),
        'audit':{**pin(audit_dir/'PUBLIC_AUDIT.json'),'receipt':pin(audit_dir/'RECEIPTS.json'),
            'source_inputs':pin(audit_dir/'SOURCE_INPUTS.json'),'exports':len(audit),
            'generator':pin('tools/keygen_public_audit_source.py'),'producer':pin('formal/Source3/KeygenPublicAudit.lean'),
            'covered_named_source_declarations':len(declarations()),'inherited_interfaces':len(INHERITED),
            'full_terms':sum('term' in e['body'] for e in audit),
            'kernel_inductives_with_constructor_types':sum('constructors' in e['body'] for e in audit),
            'elisions':0,'allowed_axioms':['propext','Classical.choice','Quot.sound']},
        'sage':{'source':pin(sage_source),'receipt':pin(controls_dir/'RECEIPTS.json'),
            'source_inputs':pin(controls_dir/'SOURCE_INPUTS.json'),'result':pin(controls_dir/'PUBLIC_CHECK.json'),
            'profile':pin(job.OLD/'inputs/source/PROFILE.json'),'source_files':source_pins,'logs':streams(controls_dir,record,True),
            'artifacts':control_artifacts,'runs':14,'mutations_per_mode':6,'scope':controls['scope']},
        'attempt_details':history,'attempt_counts':{status:sum(e['status']==status for e in history)
            for status in ['ACCEPTED','FAILED_RETAINED','EXTERNAL_INTERRUPTION_NO_RECEIPT']},
        'contracts':{
            'scalar':'Actual fixed mq Call, canonical caller-domain words, signed input domain or nonzero divisor where stated, imply exact word/range/field laws. Radix2^16 and signed literal parameter conversions explicit.',
            'division':'Complete mq_div_18433 Body/19-node source chain/actual return conversion yield canonical x/y and multiplication identity for canonical x,y and nonzero y. No division-correctness premise.',
            'geometry':'Source literal25, prime18433, exact generator/root orders9216/4608,1536 distinct Phi roots and coefficient injectivity. Mathematical geometry ONLY: no initialized gm/igm memory or executed-transform theorem.',
            'boundary':'B1.06 Acceptance NOT MET. No source public/inverse equations for SAME retained f/g/h, no fInv witness or complete KeyGen/emitted/security claim. B1.05 Acceptance remains BATCH_032; B1.07 not entered.'},
        'open_in_b1_06':['Refine actual public rev10 execution to bitrev10; derive dynamic mq_mkgm3 gm/igm canonical/scaled row words from actual stores and layout.',
            'Bind canonical conversion and forward-evaluation refinement for SAME source f/g, with actual physical permutation.',
            'Derive all nonzero tests and pointwise division on successful public execution; actual inverse-transform refinement and canonical h.',
            'Construct fInv and prove both Relation.mulRq equations for SAME retained caller material.'],
        'later':['B1.07 whole caller/attempt control','B1.08–B1.11 codecs/emitted-to-fiber/final replay/owner-arranged review'],
        'tools':[pin(p) for p in tools],'source_commits':subprocess.check_output(['git','log','--reverse','--format=%H %s',
            '98a4abf6..'+head,'--',str(job.ROOT.relative_to(job.REPO))],cwd=job.REPO,text=True).splitlines(),
        'active_jobs_at_close':[],'push_by_this_worker':False,
        'limits':'Unchanged Lean j1/-M6144,AS12GiB/RSS8GiB,wall1800s,maxHeartbeats2000000,print200000; inherited exponentiation threshold32768 in root certificate;0/0 streams,Sage standard preparser ZZ/residue rings.'}
    with path(BASE+'.json').open('x') as stream: json.dump(output,stream,indent=2); stream.write('\n')
    print(json.dumps({'batch':pin(BASE+'.json'),'notes':pin(notes),'modules':len(modules),'audited':len(audit),
        'attempts':len(history),'inputs':output['current_final_audit_inputs']},indent=2))


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
    result={'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_033','checked':checked,
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
