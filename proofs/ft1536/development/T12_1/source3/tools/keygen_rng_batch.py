#!/usr/bin/env python3
"""Seal/verify048's full-readiness midpoint; never replace015--047 bytes."""
from datetime import datetime, timezone
from pathlib import Path
import json
import subprocess
import sys

import job
from keygen_intermediate_batch import path, read, pin, committed, streams
from keygen_public_first_batch import write_receipt
from keygen_rng_audit_source import MODULES, INHERITED, declarations

BASE = 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_048'
ENTRY = '.build/levels_048/ENTRY_PINS_048.json'
ENTRY_SHA = 'f0864f27ce86fa1d1b3c81f8f8bc27f78cd1c1f43a3a1c77d5cc4b2731084256'
CONTROL = '.build/jobs/keygen_rng_checks_048_004'
SAGE = 'sage/check_keygen_rng_ready.sage'
CAUSES = {
    'shake_seed_memory_048_001': 'Comparison whitespace, record-update layout and explicit pointer-offset arithmetic; no read or extent domain changed.',
    'shake_seed_memory_048_002': 'Record field layout and using the modular scalar layer required by the existing frame theorem.',
    'shake_seed_memory_048_003': 'The source scalar assignment needed the actual modular assign constructor, not a base-array assignment outside readOnly.',
    'shake_seed_program_048_001': 'The existing syntax type is B20.C.Ty, not Scalar.Ty. Retain cascading elaboration errors; no source proof marker was inserted.',
    'keygen_entropy_source_048_001': 'An indexed event parameter is eliminated by cases; use the actual remaining constructor binders.',
    'keygen_rng_reference_048_001': 'Multiline grouped case syntax needed separate alternatives.',
    'keygen_rng_reference_048_002': 'The remaining multiline entropy alternatives needed separate cases.',
    'keygen_rng_frame_048_001': 'Explicit boolean-and parentheses, TmpOutside unfolding, bindPointer namespace and exact indexed caller binders.',
    'keygen_rng_frame_048_002': 'Normalize the projected State arrays equality and the actual remaining Call constructor binders.',
    'keygen_ready_result_048_001': 'Indexed binders/literal elimination and tmp-scope dependent elimination required a raw-result inversion followed by normalization.',
    'keygen_ready_result_048_002': 'Change the projected Result.flow equality to its exact field before subst.',
    'keygen_make_ready_048_001': 'Exact indexed gate binders and an explicitly counted-State profile prevent inference from selecting the pre-counter State.',
    'keygen_make_ready_048_002': 'Use a typed caller-locals equality instead of a simp-only rewrite through the opaque ready/count projection.',
    'keygen_make_ready_sampling_048_001': 'prefix is a reserved Lean syntax keyword; renamed the local facts binder. The first module in this failed directory was accepted.',
    'keygen_rng_adequacy_048_001': 'The reference scalar Expr has no DecidableEq. Decide the parsed CLogic tree, then prove its reference lowering by reflexivity.',
    'keygen_rng_checks_048_001': 'Native Sage ZZ literal-region metadata needed explicit JSON integer conversion; no compiler/run started.',
    'keygen_rng_checks_048_002': 'The diagnostic selected prefix set n without observing it; retain -Werror and add an actual n observation, not warning suppression.'}


def entry_checked():
    assert not job.active(), 'A proof job is active'
    assert job.sha(path(ENTRY)) == ENTRY_SHA
    entry = read(ENTRY)
    assert entry['batch'] == 'BATCH_015-047'
    assert entry['distinct_pinned_files'] == len(entry['checked']) == 9257
    assert entry['current_source_inputs'] == 706 and entry['active_jobs'] == [] and entry['superseded'] == {}
    for p, expected in entry['checked'].items():
        assert job.sha(path(p)) == expected, ('predecessor changed',p)
    return entry


def predecessor(target):
    entry = entry_checked()
    result = {'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-047',
        'checked':entry['checked'],'distinct_pinned_files':9257,'entry':pin(ENTRY),
        'active_jobs':[],'superseded':{},'verifier_sha256':job.sha(Path(__file__))}
    print(json.dumps({'predecessor_files':9257,'receipt':write_receipt(target,result)},indent=2))


def seal():
    assert not path(BASE+'.json').exists(), 'Never replace a historical pair'
    entry = entry_checked()
    head = subprocess.check_output(['git','rev-parse','HEAD'],cwd=job.REPO,text=True).strip()
    assert subprocess.check_output(['git','branch','--show-current'],cwd=job.REPO,text=True).strip() == 'main'
    preseal = read('.build/levels_048/PRESEAL.json')
    assert preseal['checked'] == entry['checked'] and preseal['verifier_sha256'] == job.sha(Path(__file__))
    cache = read('.build/cache/CACHE_INDEX.json')
    modules = []
    for name in MODULES+['KeygenRngAudit']:
        module = 'Source3.'+name; current = cache[module]
        source = path(current['source']); directory = path(current['receipt']).parent
        committed(source,head)
        record = next(r for r in read(current['receipt']) if r['name'] == module.replace('.','_'))
        assert record['accepted'] and record['clean_log'] and record['exit_code'] == 0
        assert record['forbidden_proof_markers'] == [] and record['cumulative_child_maxrss_kib'] <= 8*1024*1024
        snapshot = directory/'formal/Source3'/(name+'.lean'); artifact = directory/'lib/Source3'/(name+'.olean')
        assert job.sha(source) == job.sha(snapshot) == record['source_sha256'] == current['source_sha256']
        assert job.sha(artifact) == job.sha(path(current['artifact'])) == record['olean_sha256'] == current['artifact_sha256']
        for imported, expected in current.get('imports',{}).items():
            if imported in cache: assert cache[imported]['artifact_sha256'] == expected,(module,imported)
        modules.append({'module':module,'source':pin(source),'snapshot':pin(snapshot),'artifact':pin(artifact),
            'cache_artifact':pin(current['artifact']),'receipt':pin(current['receipt']),
            'source_inputs':pin(directory/'SOURCE_INPUTS.json'),'logs':streams(directory,record,True),
            'imports':current.get('imports',{}),'elapsed_s':record['elapsed_s'],'maxrss_kib':record['cumulative_child_maxrss_kib']})
    audit_dir = path(cache['Source3.KeygenRngAudit']['receipt']).parent
    audit = read(audit_dir/'RNG_AUDIT.json')
    assert len(audit) == len({e['name'] for e in audit}) == len(declarations())+len(INHERITED)
    assert {e['name'] for e in audit} == set(declarations()) | {'FT1536.Source3.'+n for n in INHERITED}
    assert (audit_dir/'RNG_AUDIT_ENTRIES.jsonl').read_text().count('\n') == len(audit)
    for e in audit:
        assert set(e['axioms']) <= {'propext','Classical.choice','Quot.sound'},e['name']
        assert '⋯' not in json.dumps(e,ensure_ascii=False),e['name']
        if e['body']['kind']=='definition_or_theorem': assert e['body']['term'],e['name']
        else: assert e['body']['kind']=='kernel_inductive' and e['body']['constructors'],e['name']
    inputs = read(audit_dir/'SOURCE_INPUTS.json')
    for e in inputs['sources']: assert job.sha(path(e['path'])) == e['sha256'],e['path']
    for e in inputs['reused']:
        assert job.sha(path(e.get('current_source',e['source']))) == e['source_sha256'],e['module']
        assert job.sha(path(e['artifact'])) == e['artifact_sha256'],e['module']
    control_dir = path(CONTROL); controls = read(control_dir/'RNG_READY_CHECK.json')
    control_record = read(control_dir/'RECEIPTS.json')[0]
    assert control_record['accepted'] and control_record['clean_log'] and control_record['exit_code']==0
    committed(SAGE,head)
    assert job.sha(path(SAGE)) == job.sha(control_dir/SAGE) == control_record['source_sha256']
    assert controls['status']=='PASS_FINITE_SOURCE_CONTROLS' and len(controls['variants'])==14
    assert [controls[k] for k in ['ready_cases_per_run','set_seed_cases_per_run','entropy_cases_per_run']]==[35,18,10]
    assert job.sha(control_dir/'RNG_SOURCE_BINDING.json') == controls['binding_sha256']
    assert job.sha(control_dir/'RNG_PUBLIC_FIXTURE.json') == controls['fixture_sha256']
    assert job.sha(job.OLD/'inputs/source/PROFILE.json') == controls['profile_sha256']
    binding = read(control_dir/'RNG_SOURCE_BINDING.json')
    assert job.sha(path('formal/Source3/KeygenEntropySource.lean')) == binding['frng_literal_sha256']
    assert binding['source_pins']==controls['source_pins']
    assert binding['linux_macro_values']=={'USE_URANDOM':'1','USE_WIN32_RAND':'0','O_RDONLY':'00','EINTR':'4'}
    artifacts = []
    for variant in controls['variants']:
        assert variant['counts']=={'L':1,'R':35,'S':18,'E':10} and len(variant['results'])==64
        assert bool(variant['differences']) == (variant['variant']!='baseline')
        for p,expected in variant['artifacts'].items():
            assert job.sha(control_dir/p)==expected,p
            artifacts.append(pin(control_dir/p))
        for suffix in ['compile.stdout','compile.stderr','stderr']:
            assert (control_dir/(variant['mode']+'_'+variant['variant']+'.'+suffix)).stat().st_size==0
    for p,expected in controls['extra_artifacts'].items():
        assert job.sha(control_dir/p)==expected,p;artifacts.append(pin(control_dir/p))
    source_pins=[]
    for name,expected in controls['source_pins'].items():
        p=job.REPO/'Extra/c'/name; assert job.sha(p)==expected,p;source_pins.append(pin(p))
    patterns=['shake_seed_*_048_*','keygen_entropy_source_048_*','keygen_rng_*_048_*',
              'keygen_ready_result_048_*','keygen_make_ready*_048_*']
    directories=sorted({p for pattern in patterns for p in (job.BUILD/'jobs').glob(pattern)})
    history=[]
    for directory in directories:
        inventory=read(directory/'SOURCE_INPUTS.json');snapshots=[]
        for e in inventory['sources']:
            rel='formal/'+e['module'].replace('.','/')+'.lean' if 'module' in e else 'sage/'+Path(e['path']).name
            p=directory/rel;assert job.sha(p)==e['sha256'],p;snapshots.append(pin(p))
        records=read(directory/'RECEIPTS.json');status='FAILED_RETAINED' if any(not r['accepted'] for r in records) else 'ACCEPTED'
        assert (directory.name in CAUSES)==(status!='ACCEPTED'),directory.name
        wait=job.BUILD/'waits'/directory.name/'WAIT.jsonl'
        history.append({'job':directory.name,'status':status,'cause':CAUSES.get(directory.name),
            'receipt':pin(directory/'RECEIPTS.json'),'wait_log':pin(wait),'source_inputs':pin(directory/'SOURCE_INPUTS.json'),
            'preflight':pin(directory/'PREFLIGHT.json'),'runner_snapshot':pin(directory/'RUNNER_SOURCE.py'),
            'execution_snapshot':pin(directory/'EXECUTION_SOURCE.py'),'snapshots':snapshots,
            'raw_files':[pin(p) for p in sorted((directory/'logs').iterdir()) if p.is_file()],
            'steps':[{'name':r['name'],'accepted':r['accepted'],'exit_code':r['exit_code'],
                'elapsed_s':r['elapsed_s'],'maxrss_kib':r['cumulative_child_maxrss_kib'],
                'source_sha256':r['source_sha256'],'logs':streams(directory,r)} for r in records],
            'accepted_products':[pin(p) for p in sorted((directory/'lib').rglob('*.olean')) if not p.is_symlink()],
            'products':[pin(p) for p in sorted(directory.iterdir()) if p.is_file() and p.name not in
                {'RECEIPTS.json','SOURCE_INPUTS.json','PREFLIGHT.json','RUNNER_SOURCE.py','EXECUTION_SOURCE.py'}]})
    assert {h['job'] for h in history if h['status']!='ACCEPTED'}==set(CAUSES)
    tools=['tools/job.py','tools/job_when_available.py','tools/keygen_rng_audit_source.py',
        'tools/keygen_rng_batch.py','tools/keygen_make_entry_batch.py','tools/keygen_public_first_batch.py',
        'tools/keygen_intermediate_batch.py','formal/Source3/KeygenLevelsAudit.lean']
    for p in tools: committed(p,head)
    notes=path(BASE+'_NOTES.md');assert notes.exists()
    result={'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_048','stage':'B1.07',
        'window':'CLOSED_AT_RECOVERABLE_MIDPOINT','b1_07_acceptance':'NOT_MET','stage_result':'PARTIAL_PROOF',
        'status':'IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN','created_utc':datetime.now(timezone.utc).isoformat(),
        'harness':'GPT-6.1 Sol Fast / openai/gpt-6.1-sol-fast','runner_labels':'Historical runner labels are provenance only.',
        'proof_head':head,'notes':pin(notes),'entry_pins_receipt':pin(ENTRY),'predecessor_files':9257,
        'preseal_predecessor_receipt':pin('.build/levels_048/PRESEAL.json'),'superseded':{},'accepted_module_checks':modules,
        'current_final_audit_inputs':len(inputs['sources'])+len(inputs['reused']),
        'audit':{**pin(audit_dir/'RNG_AUDIT.json'),'entries_jsonl':pin(audit_dir/'RNG_AUDIT_ENTRIES.jsonl'),
            'receipt':pin(audit_dir/'RECEIPTS.json'),'source_inputs':pin(audit_dir/'SOURCE_INPUTS.json'),
            'generator':pin('tools/keygen_rng_audit_source.py'),'producer':pin('formal/Source3/KeygenRngAudit.lean'),
            'exports':len(audit),'named_declarations':len(declarations()),'inherited_interfaces':len(INHERITED),
            'full_terms':sum('term' in e['body'] for e in audit),'kernel_inductives':sum('constructors' in e['body'] for e in audit),
            'elisions':0,'allowed_axioms':['propext','Classical.choice','Quot.sound']},
        'sage':{'source':pin(SAGE),'receipt':pin(control_dir/'RECEIPTS.json'),'source_inputs':pin(control_dir/'SOURCE_INPUTS.json'),
            'result':pin(control_dir/'RNG_READY_CHECK.json'),'fixture':pin(control_dir/'RNG_PUBLIC_FIXTURE.json'),
            'source_binding':pin(control_dir/'RNG_SOURCE_BINDING.json'),'profile':pin(job.OLD/'inputs/source/PROFILE.json'),
            'source_files':source_pins,'artifacts':artifacts,'logs':streams(control_dir,control_record,True),
            'runs':14,'layout_cases_per_run':1,'ready_cases_per_run':35,'set_seed_cases_per_run':18,
            'entropy_cases_per_run':10,'scope':controls['scope']},
        'attempt_details':history,'attempt_counts':{s:sum(h['status']==s for h in history) for s in ['ACCEPTED','FAILED_RETAINED']},
        'contracts':{'rng':'Complete fixed init/inject/flip/set_seed/rng_ready source control. Every finite ready call returns0 or1; return1 derives nonzero signed flags. Both Fresh tmp32 lifetimes and frames are source consequences.',
            'entropy':'Finite Linux open/read/errno/close observations with bounded byte writes, errors/EINTR/short/zero reads. External POSIX-style interface, NOT an OS/availability/uniformity/PRG proof.',
            'prefix':'Complete active7805–7838 prefix derives counter0/Initial/profile/static/scratch facts on every normal readiness path; no already-ready subset or unchanged-heap premise.',
            'sampling':'SAME first cap/setup and actual f/g sampler calls derive count1 and both stored Bound1 vectors from Original; no extra reachable-count premise.'},
        'open_in_b1_07':['Complete enclosing make syntax/scopes/ternary branch/call destinations and full automatic-object teardown.',
            'Full-loop reachable counter invariant/chronological attempts/no normal fallthrough/final accepted break and length<=3000000.',
            'All six SAME actual gates,046 public material/equations,032 solver and complete mandatory certificate with actual entry facts/call ID/snapshots/frames/bad lifetime.',
            'Final accepted material at actual encoding-input memory; acceptance versus later output-capacity failure.'],
        'outside_scope':['B1.08–B1.11 codecs/emitted-to-fiber/final replay, B4/B5 laws/PRG/security, Windows/OS/compiler/machine refinement, CT and independent review.'],
        'tools':[pin(p) for p in tools],'source_commits':subprocess.check_output(['git','log','--reverse','--format=%H %s',
            '1d1ff14e..'+head,'--',str(job.ROOT.relative_to(job.REPO))],cwd=job.REPO,text=True).splitlines(),
        'active_jobs_at_close':[],'push_by_this_worker':False,'review_or_stages_import':False,
        'limits':'Unchanged Lean j1/-M6144,AS12GiB/RSS8GiB,wall1800s,maxHeartbeats2000000,print200000;0/0 proof streams,Sage preparser.'}
    assert not job.active()
    with path(BASE+'.json').open('x') as stream: json.dump(result,stream,indent=2);stream.write('\n')
    print(json.dumps({'batch':pin(BASE+'.json'),'notes':pin(notes),'audit_entries':len(audit),
        'attempts':len(history),'attempt_counts':result['attempt_counts'],'literal_inputs':result['current_final_audit_inputs']},indent=2))


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
    assert batch['batch']=='BATCH_048' and batch['superseded']=={} and batch['active_jobs_at_close']==[]
    assert batch['window']=='CLOSED_AT_RECOVERABLE_MIDPOINT' and batch['b1_07_acceptance']=='NOT_MET'
    assert batch['entry_pins_receipt']['sha256']==ENTRY_SHA
    for p,expected in entry_checked()['checked'].items(): check(p,expected)
    inputs=read(batch['audit']['source_inputs']['path'])
    for e in inputs['sources']: check(e['path'],e['sha256'])
    for e in inputs['reused']:
        check(e.get('current_source',e['source']),e['source_sha256']);check(e['artifact'],e['artifact_sha256'])
    assert not job.active()
    result={'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-048','checked':checked,
        'distinct_pinned_files':len(checked),'current_source_inputs':batch['current_final_audit_inputs'],
        'active_jobs':[],'superseded':{},'verifier_sha256':job.sha(Path(__file__))}
    print(json.dumps({**{k:v for k,v in result.items() if k!='checked'},'receipt':write_receipt(target,result)},indent=2))


if __name__=='__main__':
    if sys.argv[1:]==['seal']: seal()
    elif sys.argv[1:2]==['predecessor']:
        assert len(sys.argv)==3;predecessor(sys.argv[2])
    else:
        assert len(sys.argv)==5 and sys.argv[1]=='verify';verify(*sys.argv[2:])
