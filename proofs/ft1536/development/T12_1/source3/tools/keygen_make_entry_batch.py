#!/usr/bin/env python3
"""Seal/verify047's recoverable B1.07 entry boundary; preserve015--046."""
from datetime import datetime, timezone
from pathlib import Path
import json
import subprocess
import sys

import job
from keygen_intermediate_batch import path, read, pin, committed, streams
from keygen_public_first_batch import write_receipt
from keygen_make_entry_audit_source import MODULES, INHERITED, declarations

BASE = 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_047'
ENTRY = '.build/levels_047/ENTRY_PINS_047.json'
ENTRY_SHA = '4418daa7485006b21aed48081e49da5939e10a53095edca72daee3b341822336'
CONTROL = '.build/jobs/keygen_make_entry_checks_047_001'
SAGE = 'sage/check_keygen_make_entry.sage'
CAUSES = {
    'keygen_make_objects_047_001': 'Fin projection needed an explicit reflexive natural bound; no freshness or extent domain changed.',
    'keygen_make_entry_047_001': 'Fin4/Fin6 projection inference needed an explicitly typed projection and a normalized index equality.',
    'keygen_ready_fast_047_001': 'Exact indexed constructor arguments and the quoted Lean variable constructor were needed; explicit signed ! comparison and boolean conversion were not yet normalized.',
    'keygen_ready_fast_047_002': 'The variable constructor keeps four arguments, including the source name; the guessed binding argument was a Value.',
    'keygen_ready_fast_047_003': 'An untyped simp-trans goal left the stored local cell metavariable unresolved; supply the exact typed cell equality.',
    'keygen_make_prologue_047_001': 'Harness timeout120s, no engine receipt. Record-update congr/funext diagnostic and all snapshots/streams retained; recovery found no active job. No invented completed exit/RSS.',
    'keygen_make_prologue_047_002': 'Simp changed String.toList syntax, structure predicates required their exact fields, and one nested allocation proof hit the unchanged2M heartbeats. Split into bounded typed heap equalities; no limit change.',
    'keygen_make_prologue_047_003': 'Deprecated if_pos/if_neg and an unnecessary sequence-focus combinator were rejected; replace by standard ite laws and clean tactic sequencing.',
    'keygen_make_sampling_047_001': 'Inline cap simp application did not parse; rewrite the exact cap result before pairing it.',
    'keygen_make_sampling_047_002': 'Missing whitespace before i at the comparison token boundary; no arithmetic or counter domain change.',
    'keygen_make_sampling_047_004': 'Dependent substitution eliminated the sampled alias; use the actual final after State.'}


def entry_checked():
    assert not job.active(), 'A proof job is active'
    assert job.sha(path(ENTRY)) == ENTRY_SHA
    entry = read(ENTRY)
    assert entry['batch'] == 'BATCH_015-046'
    assert entry['distinct_pinned_files'] == len(entry['checked']) == 8965
    assert entry['current_source_inputs'] == 700 and entry['active_jobs'] == [] and entry['superseded'] == {}
    for p, expected in entry['checked'].items():
        assert job.sha(path(p)) == expected, ('predecessor changed',p)
    return entry


def predecessor(target):
    entry = entry_checked()
    result = {'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-046',
        'checked':entry['checked'],'distinct_pinned_files':8965,'entry':pin(ENTRY),
        'active_jobs':[],'superseded':{},'verifier_sha256':job.sha(Path(__file__))}
    print(json.dumps({'predecessor_files':8965,'receipt':write_receipt(target,result)},indent=2))


def seal():
    assert not path(BASE+'.json').exists(), 'Never replace a historical pair'
    entry = entry_checked()
    head = subprocess.check_output(['git','rev-parse','HEAD'],cwd=job.REPO,text=True).strip()
    assert subprocess.check_output(['git','branch','--show-current'],cwd=job.REPO,text=True).strip() == 'main'
    preseal = read('.build/levels_047/PRESEAL.json')
    assert preseal['checked'] == entry['checked'] and preseal['verifier_sha256'] == job.sha(Path(__file__))
    cache = read('.build/cache/CACHE_INDEX.json')
    modules = []
    for name in MODULES+['KeygenMakeEntryAudit']:
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
    audit_dir = path(cache['Source3.KeygenMakeEntryAudit']['receipt']).parent
    audit = read(audit_dir/'MAKE_ENTRY_AUDIT.json')
    assert len(audit) == len({e['name'] for e in audit}) == len(declarations())+len(INHERITED)
    assert {e['name'] for e in audit} == set(declarations()) | {'FT1536.Source3.'+n for n in INHERITED}
    assert (audit_dir/'MAKE_ENTRY_AUDIT_ENTRIES.jsonl').read_text().count('\n') == len(audit)
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
    control_dir = path(CONTROL); controls = read(control_dir/'MAKE_ENTRY_CHECK.json')
    control_record = read(control_dir/'RECEIPTS.json')[0]
    assert control_record['accepted'] and control_record['clean_log'] and control_record['exit_code']==0
    committed(SAGE,head)
    assert job.sha(path(SAGE)) == job.sha(control_dir/SAGE) == control_record['source_sha256']
    assert controls['status']=='PASS_FINITE_SOURCE_CONTROLS' and len(controls['variants'])==10
    assert controls['prefix_cases_per_run']==20 and controls['readiness_cases_per_run']==6
    assert job.sha(control_dir/'MAKE_ENTRY_HEADERS.json') == controls['header_sha256']
    assert job.sha(control_dir/'MAKE_ENTRY_FIXTURE.json') == controls['fixture_sha256']
    assert job.sha(job.OLD/'inputs/source/PROFILE.json') == controls['profile_sha256']
    artifacts = []
    for variant in controls['variants']:
        assert len(variant['results'])==20 and len(variant['readiness_controls'])==6
        assert bool(variant['differences']) == (variant['variant']!='baseline')
        for p,expected in variant['artifacts'].items():
            assert job.sha(control_dir/p)==expected,p
            artifacts.append(pin(control_dir/p))
        for suffix in ['compile.stdout','compile.stderr','stderr']:
            assert (control_dir/(variant['mode']+'_'+variant['variant']+'.'+suffix)).stat().st_size==0
    source_pins=[]
    for name,expected in controls['source_pins'].items():
        p=job.REPO/'Extra/c'/name; assert job.sha(p)==expected,p; source_pins.append(pin(p))
    history=[]
    directories=sorted(set((job.BUILD/'jobs').glob('keygen_make_*_047_*')) |
        set((job.BUILD/'jobs').glob('keygen_ready_fast_047_*')))
    for directory in directories:
        inventory=read(directory/'SOURCE_INPUTS.json'); snapshots=[]
        for e in inventory['sources']:
            rel='formal/'+e['module'].replace('.','/')+'.lean' if 'module' in e else 'sage/'+Path(e['path']).name
            p=directory/rel; assert job.sha(p)==e['sha256'],p; snapshots.append(pin(p))
        receipt=directory/'RECEIPTS.json'
        if receipt.exists():
            records=read(receipt); status='FAILED_RETAINED' if any(not r['accepted'] for r in records) else 'ACCEPTED'
            interruption=None
        else:
            records=[]; status='INTERRUPTED_RETAINED'; interruption=pin(directory/'INTERRUPTED.json')
            assert read(interruption['path'])['exit_code'] is None
        assert (directory.name in CAUSES)==(status!='ACCEPTED'),directory.name
        wait=job.BUILD/'waits'/directory.name/'WAIT.jsonl'
        history.append({'job':directory.name,'status':status,'cause':CAUSES.get(directory.name),
            'receipt':pin(receipt) if records else None,'interruption':interruption,
            'wait_log':pin(wait) if wait.exists() else None,
            'source_inputs':pin(directory/'SOURCE_INPUTS.json'),'preflight':pin(directory/'PREFLIGHT.json'),
            'runner_snapshot':pin(directory/'RUNNER_SOURCE.py'),'execution_snapshot':pin(directory/'EXECUTION_SOURCE.py'),
            'snapshots':snapshots,'raw_files':[pin(p) for p in sorted((directory/'logs').iterdir()) if p.is_file()],
            'steps':[{'name':r['name'],'accepted':r['accepted'],'exit_code':r['exit_code'],
                'elapsed_s':r['elapsed_s'],'maxrss_kib':r['cumulative_child_maxrss_kib'],
                'source_sha256':r['source_sha256'],'logs':streams(directory,r)} for r in records],
            'accepted_products':[pin(p) for p in sorted((directory/'lib').rglob('*.olean')) if not p.is_symlink()],
            'products':[pin(p) for p in sorted(directory.iterdir()) if p.is_file() and p.name not in
                {'RECEIPTS.json','SOURCE_INPUTS.json','PREFLIGHT.json','RUNNER_SOURCE.py','EXECUTION_SOURCE.py'}]})
    assert {h['job'] for h in history if h['status']!='ACCEPTED'}==set(CAUSES)
    tools=['tools/job.py','tools/job_when_available.py','tools/keygen_make_entry_audit_source.py',
        'tools/keygen_make_entry_batch.py','tools/keygen_public_accepted_batch.py','tools/keygen_public_first_batch.py',
        'tools/keygen_intermediate_batch.py','formal/Source3/KeygenLevelsAudit.lean']
    for p in tools: committed(p,head)
    notes=path(BASE+'_NOTES.md');assert notes.exists()
    result={'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_047','stage':'B1.07',
        'window':'CLOSED_AT_RECOVERABLE_MIDPOINT','b1_07_acceptance':'NOT_MET','stage_result':'PARTIAL_PROOF',
        'status':'IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN','created_utc':datetime.now(timezone.utc).isoformat(),
        'harness':'GPT-6.1 Sol Fast / openai/gpt-6.1-sol-fast','runner_labels':'Historical runner labels are provenance only.',
        'proof_head':head,'notes':pin(notes),'entry_pins_receipt':pin(ENTRY),'predecessor_files':8965,
        'preseal_predecessor_receipt':pin('.build/levels_047/PRESEAL.json'),'superseded':{},'accepted_module_checks':modules,
        'current_final_audit_inputs':len(inputs['sources'])+len(inputs['reused']),
        'audit':{**pin(audit_dir/'MAKE_ENTRY_AUDIT.json'),'entries_jsonl':pin(audit_dir/'MAKE_ENTRY_AUDIT_ENTRIES.jsonl'),
            'receipt':pin(audit_dir/'RECEIPTS.json'),'source_inputs':pin(audit_dir/'SOURCE_INPUTS.json'),
            'generator':pin('tools/keygen_make_entry_audit_source.py'),'producer':pin('formal/Source3/KeygenMakeEntryAudit.lean'),
            'exports':len(audit),'named_declarations':len(declarations()),'inherited_interfaces':len(INHERITED),
            'full_terms':sum('term' in e['body'] for e in audit),'kernel_inductives':sum('constructors' in e['body'] for e in audit),
            'elisions':0,'allowed_axioms':['propext','Classical.choice','Quot.sound']},
        'sage':{'source':pin(SAGE),'receipt':pin(control_dir/'RECEIPTS.json'),'source_inputs':pin(control_dir/'SOURCE_INPUTS.json'),
            'result':pin(control_dir/'MAKE_ENTRY_CHECK.json'),'fixture':pin(control_dir/'MAKE_ENTRY_FIXTURE.json'),
            'header_binding':pin(control_dir/'MAKE_ENTRY_HEADERS.json'),'profile':pin(job.OLD/'inputs/source/PROFILE.json'),
            'source_files':source_pins,'artifacts':artifacts,'logs':streams(control_dir,control_record,True),
            'runs':10,'prefix_cases_per_run':20,'readiness_cases_per_run':6,'scope':controls['scope']},
        'attempt_details':history,'attempt_counts':{s:sum(h['status']==s for h in history)
            for s in ['ACCEPTED','FAILED_RETAINED','INTERRUPTED_RETAINED']},
        'contracts':{'allocation':'Chronological automatic declarations derive six extents/writability/uninitialized objects and physical separation; original caller memory has no coefficient allocation premise.',
            'prefix':'AlreadyReadyPrefix covers the complete active7805–7838 token stream, actual initialization/member/MKN reads and only the source seeded+flipped readiness path.',
            'sampling':'Source cap before setup; local reachable counts<=3000000 derive no wrap and abort BEFORE setup/sampling3000001. FirstSamples derives count1 and the SAME two sampled Bound1 vectors.'},
        'open_in_b1_07':['Full source rng_ready seed-acquisition/injection/flip paths and their frames.',
            'Whole-loop source syntax/branch/scopes, reachable counter invariant and chronological extraction of attempts.',
            'All six actual gates, complete same-material public/solver/certificate binding, no normal fallthrough and successful final break.',
            'Same accepted material at actual encoding-input memory and complete enclosing teardown; acceptance versus later capacity failure.'],
        'outside_scope':['B1.08–B1.11 codecs/emitted-to-fiber/final replay, B4/B5 laws/PRG/security, compiler/machine refinement and independent review.'],
        'tools':[pin(p) for p in tools],'source_commits':subprocess.check_output(['git','log','--reverse','--format=%H %s',
            '59384f2a..'+head,'--',str(job.ROOT.relative_to(job.REPO))],cwd=job.REPO,text=True).splitlines(),
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
    assert batch['batch']=='BATCH_047' and batch['superseded']=={} and batch['active_jobs_at_close']==[]
    assert batch['window']=='CLOSED_AT_RECOVERABLE_MIDPOINT' and batch['b1_07_acceptance']=='NOT_MET'
    assert batch['entry_pins_receipt']['sha256']==ENTRY_SHA
    for p,expected in entry_checked()['checked'].items(): check(p,expected)
    inputs=read(batch['audit']['source_inputs']['path'])
    for e in inputs['sources']: check(e['path'],e['sha256'])
    for e in inputs['reused']:
        check(e.get('current_source',e['source']),e['source_sha256']);check(e['artifact'],e['artifact_sha256'])
    assert not job.active()
    result={'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-047','checked':checked,
        'distinct_pinned_files':len(checked),'current_source_inputs':batch['current_final_audit_inputs'],
        'active_jobs':[],'superseded':{},'verifier_sha256':job.sha(Path(__file__))}
    print(json.dumps({**{k:v for k,v in result.items() if k!='checked'},'receipt':write_receipt(target,result)},indent=2))


if __name__=='__main__':
    if sys.argv[1:]==['seal']: seal()
    elif sys.argv[1:2]==['predecessor']:
        assert len(sys.argv)==3;predecessor(sys.argv[2])
    else:
        assert len(sys.argv)==5 and sys.argv[1]=='verify';verify(*sys.argv[2:])
