#!/usr/bin/env python3
"""Seal/verify BATCH_030 without superseding any BATCH_015–029 pin."""
from datetime import datetime, timezone
import json
from pathlib import Path
import subprocess
import sys

import job
from keygen_intermediate_batch import path, read, pin, committed, streams
from keygen_root_audit_source import MODULES, INHERITED, declarations

BASE = 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_030'
ENTRY = '.build/levels_030/ENTRY_PINS_030.json'
ENTRY_SHA = '081d46659ff070cf49dc92446b8b84f3d694372b77c586b9c51120ba21133c6a'
PRESEAL = '.build/levels_030/PRESEAL_PREDECESSOR.json'
PRESEAL_SHA = 'e0a9ebcb4465c8f2a2ffb03a0d64ff478b8f5af5814e824957eb6ca6507313e3'
CONTROL_JOB = '.build/jobs/keygen_root_checks_030_001'


def seal():
    assert not path(BASE+'.json').exists(), 'Never overwrite a historical pair'
    assert not job.active(), 'A proof job is active'
    head = subprocess.check_output(['git','rev-parse','HEAD'],cwd=job.REPO,text=True).strip()
    assert subprocess.check_output(['git','branch','--show-current'],cwd=job.REPO,text=True).strip() == 'main'
    assert job.sha(path(ENTRY)) == ENTRY_SHA and job.sha(path(PRESEAL)) == PRESEAL_SHA
    entry = read(ENTRY)
    assert entry['distinct_pinned_files'] == 4243 and entry['active_jobs'] == []
    assert read(PRESEAL)['checked'] == entry['checked']
    for p, expected in entry['checked'].items():
        assert job.sha(path(p)) == expected, ('predecessor changed',p)
    cache = read('.build/cache/CACHE_INDEX.json')
    accepted = {}; modules = []
    for name in MODULES+['KeygenRootAudit']:
        module = 'Source3.'+name
        current = cache[module]
        source = Path(current['source']); receipt = Path(current['receipt']); directory = receipt.parent
        committed(source,head)
        record = next(r for r in read(receipt) if r['name'] == module.replace('.','_'))
        assert record['accepted'] and record['clean_log'] and record['exit_code'] == 0
        assert record['forbidden_proof_markers'] == [] and record['cumulative_child_maxrss_kib'] <= 8*1024*1024
        snapshot = directory/'formal/Source3'/(name+'.lean')
        artifact = directory/'lib/Source3'/(name+'.olean')
        assert job.sha(source) == job.sha(snapshot) == record['source_sha256'] == current['source_sha256']
        assert job.sha(artifact) == job.sha(Path(current['artifact'])) == record['olean_sha256'] == current['artifact_sha256']
        for imported, expected in current.get('imports',{}).items():
            if imported in cache:
                assert cache[imported]['artifact_sha256'] == expected, (module,imported)
        accepted[name] = {'source':str(source.relative_to(job.ROOT)),'sha256':job.sha(source)}
        modules.append({'module':module,'source':pin(source),'snapshot':pin(snapshot),'artifact':pin(artifact),
            'receipt':pin(receipt),'source_inputs':pin(directory/'SOURCE_INPUTS.json'),'logs':streams(directory,record,True),
            'imports':current.get('imports',{}),'elapsed_s':record['elapsed_s'],'maxrss_kib':record['cumulative_child_maxrss_kib']})
    audit_dir = Path(cache['Source3.KeygenRootAudit']['receipt']).parent
    audit = read(audit_dir/'ROOT_AUDIT.json')
    assert len(audit) == len({e['name'] for e in audit}) == len(declarations())+len(INHERITED)
    assert set(declarations()) <= {e['name'] for e in audit}
    for e in audit:
        assert set(e['axioms']) <= {'propext','Classical.choice','Quot.sound'}
        assert '⋯' not in json.dumps(e,ensure_ascii=False)
    inputs = read(audit_dir/'SOURCE_INPUTS.json')
    for e in inputs['sources']:
        assert job.sha(path(e['path'])) == e['sha256']
    for e in inputs['reused']:
        assert job.sha(path(e.get('current_source',e['source']))) == e['source_sha256']
        assert job.sha(path(e['artifact'])) == e['artifact_sha256']
    controls_dir = path(CONTROL_JOB)
    controls = read(controls_dir/'ROOT_CHECK.json')
    record = read(controls_dir/'RECEIPTS.json')[0]
    assert record['accepted'] and record['clean_log'] and record['exit_code'] == 0
    sage_source = 'sage/check_keygen_root.sage'
    committed(sage_source,head)
    assert job.sha(path(sage_source)) == job.sha(controls_dir/sage_source) == record['source_sha256']
    assert len(controls['variants']) == 10 and controls['synthetic_mode1_successes'] == 9
    assert job.sha(controls_dir/'PUBLIC_FIXTURE.json') == controls['fixture_sha256']
    assert job.sha(job.OLD/'inputs/source/PROFILE.json') == controls['profile_sha256']
    control_artifacts = [pin(controls_dir/'PUBLIC_FIXTURE.json')]
    for variant in controls['variants']:
        assert len(variant['results']) == 14
        assert bool(variant['differences']) == (variant['variant'] != 'baseline')
        for p, expected in variant['artifacts'].items():
            p = controls_dir/p
            assert job.sha(p) == expected, p
            control_artifacts.append(pin(p))
    source_pins = []
    for name, expected in controls['source_pins'].items():
        p = job.OLD/'inputs/source'/name
        assert job.sha(p) == expected, p
        source_pins.append(pin(p))
    history = []
    for directory in sorted((job.BUILD/'jobs').glob('keygen_root_*_030_*')):
        assert (directory/'RECEIPTS.json').exists(), ('unaccounted receipt-less attempt',directory)
        records = read(directory/'RECEIPTS.json'); inventory = read(directory/'SOURCE_INPUTS.json')
        snapshots = []
        for e in inventory['sources']:
            rel = 'formal/'+e['module'].replace('.','/')+'.lean' if 'module' in e else 'sage/'+Path(e['path']).name
            p = directory/rel
            assert job.sha(p) == e['sha256'], p
            snapshots.append(pin(p))
        steps = []
        for r in records:
            logs = streams(directory,r)
            steps.append({'name':r['name'],'accepted_by_runner':r['accepted'],'exit_code':r['exit_code'],
                'elapsed_s':r['elapsed_s'],'maxrss_kib':r['cumulative_child_maxrss_kib'],'source_sha256':r['source_sha256'],'logs':logs})
        status = 'FAILED_RETAINED' if any(not r['accepted'] for r in records) else 'ACCEPTED'
        if directory.name == 'keygen_root_search_030_004':
            status = 'SUPERSEDED_SOURCE_ORDER'
        history.append({'job':directory.name,'status':status,'receipt':pin(directory/'RECEIPTS.json'),
            'source_inputs':pin(directory/'SOURCE_INPUTS.json'),'preflight':pin(directory/'PREFLIGHT.json'),
            'snapshots':snapshots,'steps':steps,'products':[pin(p) for p in sorted(directory.iterdir())
                if p.is_file() and p.suffix in {'.json','.jsonl','.c','.stdout','.stderr'}
                and p.name not in {'RECEIPTS.json','SOURCE_INPUTS.json','PREFLIGHT.json'}]})
    tools = ['tools/job.py','tools/job_when_available.py','tools/keygen_root_audit_source.py',
        'tools/keygen_root_batch.py','tools/keygen_intermediate_batch.py','tools/keygen_intermediate_audit_source.py',
        'formal/Source3/KeygenLevelsAudit.lean']
    for p in tools:
        committed(p,head)
    notes = path(BASE+'_NOTES.md'); assert notes.exists()
    output = {'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_030','stage':'B1.05c',
        'window':'CLOSED_AT_RECOVERABLE_MIDPOINT','b1_05_acceptance':'NOT_MET',
        'status':'IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN','stage_result':'PARTIAL_PROOF',
        'harness':'GPT-6 Astra Ultrafast / openai/gpt-6-astra-ultrafast',
        'created_utc':datetime.now(timezone.utc).isoformat(),'proof_head':head,'notes':pin(notes),
        'entry_pins_receipt':pin(ENTRY),'predecessor_files':4243,'superseded':{},
        'preseal_predecessor_receipt':pin(PRESEAL),'accepted_modules':accepted,'accepted_module_checks':modules,
        'current_final_audit_inputs':len(inputs['sources'])+len(inputs['reused']),
        'audit':{**pin(audit_dir/'ROOT_AUDIT.json'),'receipt':pin(audit_dir/'RECEIPTS.json'),
            'source_inputs':pin(audit_dir/'SOURCE_INPUTS.json'),'exports':len(audit),
            'generator':pin('tools/keygen_root_audit_source.py'),'producer':pin('formal/Source3/KeygenRootAudit.lean'),
            'covered_source_declarations':len(declarations()),'inherited_interfaces':len(INHERITED),
            'full_terms':sum('term' in e['body'] for e in audit),
            'kernel_inductives_with_constructor_types':sum('constructors' in e['body'] for e in audit),
            'elisions':0,'allowed_axioms':['propext','Classical.choice','Quot.sound']},
        'sage':{'source':pin(sage_source),'receipt':pin(controls_dir/'RECEIPTS.json'),
            'source_inputs':pin(controls_dir/'SOURCE_INPUTS.json'),'result':pin(controls_dir/'ROOT_CHECK.json'),
            'profile':pin(job.OLD/'inputs/source/PROFILE.json'),'source_files':source_pins,
            'logs':streams(controls_dir,record,True),'artifacts':control_artifacts,
            'runs':10,'cases_per_run':14,'mode1_range_successes_per_baseline':9,'mutations_per_mode':4},
        'attempt_details':history,'attempt_counts':{status:sum(e['status']==status for e in history) for status in
            ['ACCEPTED','FAILED_RETAINED','SUPERSEDED_SOURCE_ORDER']},
        'contracts':{
            'root_search':'Pinned 55-line M0 search prefix, actual profile dispatch, descending depth calls 9..1 and terminal zero; complete fixed deepest/intermediate/depth0 source calls and material preservation.',
            'static_transport':'Allocation metadata and readonly bytes derived through the fixed helper closure; prime/size/REV10 objects and scratch legality transport from the input.',
            'root_caller':'Actual five-pointer Bind and observed return1 imply same retained caller material, F/G Bound2047 and exact integer NTRU, from legal memory and incoming f/g Represents plus Bound1. Every legacy Validation field is derived.',
            'boundary':'The complete sampled f/g arrival before solve_NTRU is not yet proved. Incoming f/g representation and Bound1 are explicit local premises, so B1.05 Acceptance remains NOT_MET. M0 reference source execution, not compiler/termination/probability or review.'},
        'open':['Bind the sampler caller to the actual fk->rng subobject, profile and initial static environment.',
            'Compose sampled material through resultant gates, raw bound initialization/norm and full GS computation/gate.',
            'Bind complete active falcon_compute_public and its fixed callees for material preservation, including the automatic t object.',
            'Instantiate RootCaller.Legal and its incoming f/g Represents/Bound1 from the same full attempt prefix; close B1.05 Acceptance without assuming a frame or source completeness. B1.06 not entered.'],
        'tools':[pin(p) for p in tools],
        'source_commits':subprocess.check_output(['git','log','--reverse','--format=%H %s','dc681cb7..'+head,
            '--',str(job.ROOT.relative_to(job.REPO))],cwd=job.REPO,text=True).splitlines(),
        'active_jobs_at_close':[],'push_by_this_worker':False,
        'limits':'Unchanged Lean j1/-M6144, AS12GiB/RSS8GiB, wall1800s, maxHeartbeats2000000, clean streams; Sage standard preparser ZZ.'}
    with path(BASE+'.json').open('x') as stream:
        json.dump(output,stream,indent=2); stream.write('\n')
    print(json.dumps({'batch':pin(BASE+'.json'),'notes':pin(notes),'modules':len(modules),
        'audited':len(audit),'attempts':len(history),'inputs':output['current_final_audit_inputs']},indent=2))


def verify(batch_sha, notes_sha, receipt):
    checked = {}
    def check(p, expected):
        p=path(p); actual=job.sha(p)
        assert actual == expected, (str(p),expected,actual)
        checked[str(p)] = actual
    def walk(value):
        if isinstance(value,dict):
            if 'path' in value and 'sha256' in value: check(value['path'],value['sha256'])
            for child in value.values(): walk(child)
        elif isinstance(value,list):
            for child in value: walk(child)
    check(BASE+'.json',batch_sha); check(BASE+'_NOTES.md',notes_sha)
    batch=read(BASE+'.json'); walk(batch)
    for p, expected in read(batch['entry_pins_receipt']['path'])['checked'].items(): check(p,expected)
    inputs=read(batch['audit']['source_inputs']['path'])
    for e in inputs['sources']: check(e['path'],e['sha256'])
    for e in inputs['reused']:
        check(e.get('current_source',e['source']),e['source_sha256']); check(e['artifact'],e['artifact_sha256'])
    assert not job.active()
    result={'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_030','checked':checked,
        'distinct_pinned_files':len(checked),'current_source_inputs':batch['current_final_audit_inputs'],
        'active_jobs':[],'superseded':{},'verifier_sha256':job.sha(Path(__file__))}
    target=path(receipt); assert target.is_relative_to(job.BUILD.resolve())
    with target.open('x') as stream:
        json.dump(result,stream,indent=2); stream.write('\n')
    print(json.dumps({**{k:v for k,v in result.items() if k!='checked'},'receipt':pin(target)},indent=2))


if __name__ == '__main__':
    if sys.argv[1:] == ['seal']:
        seal()
    else:
        assert len(sys.argv)==5 and sys.argv[1]=='verify'
        verify(*sys.argv[2:])
