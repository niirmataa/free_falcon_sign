#!/usr/bin/env python3
"""Seal BATCH_021's source-bound small-output midpoint; integrity, not review."""
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import re
import subprocess

import job
from keygen_ntt_batch import ROOT, REPO, sha, pin, read, streams

OUT = ROOT/'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_021.json'
MODULES = ['KeygenSmallSource','KeygenSmallStep','KeygenSmallBounds','KeygenSmallCalls',
           'KeygenTernaryStore','KeygenSmallBoundsAudit']


def committed(path, head):
    data = subprocess.check_output(['git','show',head+':'+str(path.relative_to(REPO))],cwd=REPO)
    assert hashlib.sha256(data).hexdigest() == sha(path), path


def main():
    assert not OUT.exists(), 'Never overwrite a historical batch receipt'
    assert not job.active(), 'A proof job is still active'
    assert subprocess.check_output(['git','branch','--show-current'],cwd=REPO,text=True).strip() == 'main'
    head = subprocess.check_output(['git','rev-parse','HEAD'],cwd=REPO,text=True).strip()
    preflight = read('.build/bounds_021/PREFLIGHT.json')
    assert len(preflight['checked']) == 1594 and preflight['current_source_inputs'] == 409
    for path, expected in preflight['checked'].items():
        assert sha(path) == expected, path
    cache = read('.build/cache/CACHE_INDEX.json')
    accepted = []
    for name in MODULES:
        module = 'Source3.'+name
        entry = cache[module]
        source, receipt = Path(entry['source']), Path(entry['receipt'])
        assert sha(source) == entry['source_sha256'], module
        committed(source,head)
        directory = receipt.parent
        records = json.loads(receipt.read_text())
        record = next(r for r in records if r['name'] == module.replace('.','_'))
        assert record['accepted'] and record['clean_log'] and record['exit_code'] == 0
        assert not record['forbidden_proof_markers']
        assert record['cumulative_child_maxrss_kib'] <= 8*1024*1024
        snapshot = directory/'formal/Source3'/(name+'.lean')
        artifact = directory/'lib/Source3'/(name+'.olean')
        assert sha(snapshot) == sha(source) == record['source_sha256']
        assert sha(artifact) == sha(entry['artifact']) == record['olean_sha256'] == entry['artifact_sha256']
        for imported, expected in entry.get('imports',{}).items():
            if imported in cache:
                assert cache[imported]['artifact_sha256'] == expected, (module,imported)
        accepted.append({'module':module,'source':pin(source),'snapshot':pin(snapshot),
            'artifact':pin(artifact),'receipt':pin(receipt),'source_inputs':pin(directory/'SOURCE_INPUTS.json'),
            'job':directory.name,'logs':streams(directory,record),'imports':entry.get('imports',{}),
            'elapsed_s':record['elapsed_s'],'maxrss_kib':record['cumulative_child_maxrss_kib']})

    audit_dir = ROOT/'.build/jobs/keygen_small_audit_021_001'
    audit = json.loads((audit_dir/'SMALL_BOUNDS_AUDIT.json').read_text())
    assert len(audit) == len({e['name'] for e in audit}) == 107
    for entry in audit:
        assert set(entry['axioms']) <= {'propext','Classical.choice','Quot.sound'}
        assert '⋯' not in json.dumps(entry,ensure_ascii=False)
    assert sum('term' in e['body'] for e in audit) == 97
    assert sum(e['body']['kind'] == 'kernel_inductive' for e in audit) == 10
    new_names = set()
    for name in MODULES[:-1]:
        text = (ROOT/'formal/Source3'/(name+'.lean')).read_text()
        new_names.update('FT1536.Source3.'+name+'.'+n for n in
            re.findall(r'^\s*(?:def|theorem|structure|inductive)\s+(\w+)',text,re.M))
    assert len(new_names) == 98 and new_names <= {e['name'] for e in audit}
    inventory = json.loads((audit_dir/'SOURCE_INPUTS.json').read_text())
    for entry in inventory['sources']:
        assert sha(entry['path']) == entry['sha256'], entry.get('module')
    for entry in inventory['reused']:
        assert sha(entry.get('current_source',entry['source'])) == entry['source_sha256'], entry['module']
        assert sha(entry['artifact']) == entry['artifact_sha256'], entry['module']
    assert len(inventory['sources'])+len(inventory['reused']) == 415

    sage = []
    for label, source, product in [
        ('keygen_small_checks_021_001','check_keygen_small_bounds.sage','SMALL_BOUNDS_CHECK.json'),
        ('keygen_solver_graph_021_003','inventory_keygen_solver_graph.sage','SOLVER_GRAPH.json')]:
        directory = ROOT/'.build/jobs'/label
        record = json.loads((directory/'RECEIPTS.json').read_text())[0]
        assert record['accepted'] and record['clean_log'] and record['exit_code'] == 0
        assert sha(ROOT/'sage'/source) == sha(directory/'sage'/source) == record['source_sha256']
        committed(ROOT/'sage'/source,head)
        result = json.loads((directory/product).read_text())
        artifacts = []
        if product == 'SMALL_BOUNDS_CHECK.json':
            assert len(result['variants']) == 14 and result['small_cases'] == 36 and result['sampler_cases'] == 24
            for variant in result['variants']:
                assert bool(variant['small_differences'] or variant['sampler_differences']) == (variant['variant']!='baseline')
                for path, expected in variant['artifacts'].items():
                    path = directory/path
                    assert sha(path) == expected, path
                    artifacts.append(pin(path))
        else:
            assert result['counts'] == {'unpruned_solver':99,'top_M0_solver_overapproximation':92,'sampler':6}
            assert sha(job.OLD/'inputs/source/PROFILE.json') == result['profile_sha256']
            for name, expected in result['source_files'].items():
                assert sha(job.OLD/'inputs/source'/name) == expected, name
            for unit in result['units']:
                assert sha(directory/unit['dump']) == unit['dump_sha256']
                artifacts.append(pin(directory/unit['dump']))
                for suffix in ['stdout','stderr']:
                    path = directory/(unit['unit'][:-2]+'.'+suffix)
                    assert sha(path) == unit[suffix+'_sha256'] and path.stat().st_size == 0
                    artifacts.append(pin(path))
            assert sha(directory/'GCC_VERSION.txt') == result['compiler_version_sha256']
            artifacts.append(pin(directory/'GCC_VERSION.txt'))
        sage.append({'job':label,'source':pin('sage/'+source),'snapshot':pin(directory/'sage'/source),
            'receipt':pin(directory/'RECEIPTS.json'),'source_inputs':pin(directory/'SOURCE_INPUTS.json'),
            'result':pin(directory/product),'logs':streams(directory,record),'artifacts':artifacts})

    history = []
    for directory in sorted((ROOT/'.build/jobs').glob('*_021_*')):
        inputs = json.loads((directory/'SOURCE_INPUTS.json').read_text())
        snapshots = []
        for entry in inputs['sources']:
            rel = 'formal/'+entry['module'].replace('.','/')+'.lean' if 'module' in entry else 'sage/'+Path(entry['path']).name
            snapshot = directory/rel
            assert sha(snapshot) == entry['sha256'], snapshot
            snapshots.append(pin(snapshot))
        records = json.loads((directory/'RECEIPTS.json').read_text())
        steps = []
        for record in records:
            step = {'name':record['name'],'accepted':record['accepted'],'clean_log':record['clean_log'],
                'source_sha256':record['source_sha256'],'elapsed_s':record['elapsed_s'],
                'maxrss_kib':record['cumulative_child_maxrss_kib'],'logs':streams(directory,record)}
            if not record['accepted']:
                text = (directory/record['stdout']).read_text()+(directory/record['stderr']).read_text()
                step['failure_excerpt'] = [s for s in text.splitlines() if 'error' in s.lower() or 'TypeError' in s][:8]
            steps.append(step)
        evidence = {'job':directory.name,'receipt':pin(directory/'RECEIPTS.json'),
            'source_inputs':pin(directory/'SOURCE_INPUTS.json'),'preflight':pin(directory/'PREFLIGHT.json'),
            'snapshots':snapshots,'steps':steps,'status':'ACCEPTED' if all(r['accepted'] for r in records) else 'FAILED_RETAINED',
            'products':[pin(p) for p in sorted(directory.glob('*.json'))
                if p.name not in {'SOURCE_INPUTS.json','RECEIPTS.json','PREFLIGHT.json'}]}
        wait = ROOT/'.build/waits'/directory.name/'WAIT.jsonl'
        if wait.exists():
            evidence['wait'] = pin(wait)
        history.append(evidence)
    assert len(history) == 18 and sum(e['status']=='FAILED_RETAINED' for e in history) == 9
    predecessors = {}
    for number in ['015','016','017','018','019','020']:
        for suffix in ['.json','_NOTES.md']:
            path = 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_'+number+suffix
            predecessors[path] = preflight['checked'][str(ROOT/path)]
    result = {'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_021','stage':'B1.05',
        'created_utc':datetime.now(timezone.utc).isoformat(),'window':'CLOSED_AT_RECOVERABLE_MIDPOINT',
        'b1_05_acceptance':'NOT_MET','stage_result':'PARTIAL_PROOF',
        'status':'IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN',
        'harness':'GPT-6 Astra Ultrafast / openai/gpt-6-astra-ultrafast',
        'runner_note':'Historical runner model/session labels retained as provenance; unchanged serial guarded execution.',
        'runner':pin('tools/job.py'),'waiter':pin('tools/job_when_available.py'),
        'organizer':pin(Path(__file__).resolve()),'organizer_helpers':pin('tools/keygen_ntt_batch.py'),
        'preflight':pin('.build/bounds_021/PREFLIGHT.json'),'preflight_program':pin('.build/bounds_021/preflight.py'),
        'preflight_files_checked':1594,'preflight_current_inputs':409,'input_pins':predecessors,
        'proof_head':head,'accepted_module_checks':accepted,'current_final_audit_inputs':415,
        'contracts':{
            'small_body':'Complete parsed poly_big_to_small execution, M0 logn10/ter1 and destination binding/width imply same-output Represents and Bound2047. Source MKN, u initialization, every guard/increment/store and return are derived; no bound premise.',
            'plain_callee':'Fixed zint_one_to_plain parsed load/update prefix and signed32 local-object byte read, with checked little-endian object roundtrip; no return-value oracle.',
            'call_frame':'Actual Bind/nonzero converted return yield successful bounded writes. A disjoint byte frame preserves the same first output through the second write trace.',
            'ternary_tail':'Post-refill source x extraction/rb shift/rbits decrement, actual comparison, narrow store and break yield a Store16 witness with coefficient in [-1,1]. Rejected draw preserves heap. This does not derive the full f/g Vec yet.',
            'graph':'99-node unpruned/92-node top-M0-selected transitive compiler graph and6-node sampler closure. Deeper runtime branches are a conservative overapproximation. Inventory only; not formal source execution or a completeness premise.',
            'open':'Complete solver/search fixed-body execution; actual member/pointer/profile arguments and both short-circuit output calls; complete MODE1 refill/loops with fk->rng/get_rng_u64/shake_extract/Keccak and earlier-material preservation; consume BATCH_020 validation on the same four vectors.'},
        'audit':{**pin(audit_dir/'SMALL_BOUNDS_AUDIT.json'),'receipt':pin(audit_dir/'RECEIPTS.json'),
            'source_inputs':pin(audit_dir/'SOURCE_INPUTS.json'),'exports':107,'new_declarations':98,
            'full_pretty_terms':97,'kernel_inductives_with_constructor_types':10,
            'allowed_axioms':['propext','Classical.choice','Quot.sound'],'elisions':0,
            'generator':'formal/Source3/KeygenSmallBoundsAudit.lean','independent_review':False},
        'sage':sage,'graph_note':pin('notes/run/KEYGEN_SOLVER_GRAPH_021.md'),'attempt_history':history,
        'retained_failures':'Nine failed attempts: unavailable optional tactic import; reserved identifier/record-layout errors; parser probes revealing missing int32_t spelling; ambiguous constructor type; induction/field elaboration fixes; Sage Integer JSON conversion. All snapshots/logs retained. The unavailable tactic was replaced by an existing kernel byte-roundtrip export.',
        'limits':'Unchanged Lean-j1/-M6144, maxRecDepth32768/maxHeartbeats2000000, wall1800s, AS12GiB/RSS8GiB, warnings as errors. pp.maxSteps200000 only for printing. Standard-preparser Sage. Shell waits timeout0.',
        'build_scope':'Six new Lean modules and their exact pinned reused inputs; no changed historical dependency or unchanged full-project replay.',
        'next_owner_stage':'Resume B1.05 at checkpoint section6. Full source solver/sampler/caller binding remains; B1.06 not entered.',
        'git':{'branch':'main','author':'niirmataa','writer_lock':'proofs/ft1536/work/archive.lock',
            'source_commits':['f17fe9b2','8b55f52f',head],'push':'none; owner signal required','foreign_changes':'preserved'},
        'active_jobs_at_close':[]}
    with OUT.open('x') as stream:
        json.dump(result,stream,indent=2)
        stream.write('\n')
    print(json.dumps({'batch_sha256':sha(OUT),'modules':len(accepted),'exports':len(audit),
        'attempts':len(history),'failures':9,'current_final_audit_inputs':415,
        'max_accepted_rss_kib':max(e['maxrss_kib'] for e in accepted)},indent=2))


if __name__ == '__main__':
    main()
