#!/usr/bin/env python3
"""Seal BATCH_022's recoverable execution midpoint; integrity, not review."""
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import re
import subprocess

import job
from keygen_ntt_batch import ROOT, REPO, sha, pin, read, streams
from keygen_execution_audit_source import MODULES

OUT = ROOT/'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_022.json'

def committed(path, head):
    data = subprocess.check_output(['git','show',head+':'+str(path.relative_to(REPO))],cwd=REPO)
    assert hashlib.sha256(data).hexdigest()==sha(path),path

def main():
    assert not OUT.exists(), 'Never overwrite a historical batch receipt'
    assert not job.active(), 'A proof job is still active'
    assert subprocess.check_output(['git','branch','--show-current'],cwd=REPO,text=True).strip()=='main'
    head=subprocess.check_output(['git','rev-parse','HEAD'],cwd=REPO,text=True).strip()
    preflight=read('.build/execution_022/PREFLIGHT.json')
    assert len(preflight['checked'])==1840 and preflight['current_source_inputs']==415
    for path,expected in preflight['checked'].items():
        assert sha(path)==expected,path
    cache=read('.build/cache/CACHE_INDEX.json')
    accepted=[]
    for name in MODULES+['KeygenExecutionAudit']:
        module='Source3.'+name
        entry=cache[module]
        source,receipt=Path(entry['source']),Path(entry['receipt'])
        assert sha(source)==entry['source_sha256'],module
        committed(source,head)
        directory=receipt.parent
        records=json.loads(receipt.read_text())
        record=next(r for r in records if r['name']==module.replace('.','_'))
        assert record['accepted'] and record['clean_log'] and record['exit_code']==0
        assert not record['forbidden_proof_markers']
        assert record['cumulative_child_maxrss_kib']<=8*1024*1024
        snapshot=directory/'formal/Source3'/(name+'.lean')
        artifact=directory/'lib/Source3'/(name+'.olean')
        assert sha(snapshot)==sha(source)==record['source_sha256']
        assert sha(artifact)==sha(entry['artifact'])==record['olean_sha256']==entry['artifact_sha256']
        for imported,expected in entry.get('imports',{}).items():
            if imported in cache:
                assert cache[imported]['artifact_sha256']==expected,(module,imported)
        accepted.append({'module':module,'source':pin(source),'snapshot':pin(snapshot),'artifact':pin(artifact),
            'receipt':pin(receipt),'source_inputs':pin(directory/'SOURCE_INPUTS.json'),'job':directory.name,
            'logs':streams(directory,record),'imports':entry.get('imports',{}),
            'elapsed_s':record['elapsed_s'],'maxrss_kib':record['cumulative_child_maxrss_kib'],
            'all_steps_in_job_accepted':all(r['accepted'] for r in records)})

    audit_dir=ROOT/'.build/jobs/keygen_execution_audit_022_001'
    audit=json.loads((audit_dir/'EXECUTION_AUDIT.json').read_text())
    assert len(audit)==len({e['name'] for e in audit})==423
    for entry in audit:
        assert set(entry['axioms'])<={'propext','Classical.choice','Quot.sound'}
        assert '⋯' not in json.dumps(entry,ensure_ascii=False)
    assert sum('term' in e['body'] for e in audit)==393
    assert sum(e['body']['kind']=='kernel_inductive' for e in audit)==30
    new_names=set()
    for name in MODULES:
        text=(ROOT/'formal/Source3'/(name+'.lean')).read_text()
        new_names.update('FT1536.Source3.'+name+'.'+n for n in
            re.findall(r'^\s*(?:def|theorem|structure|inductive)\s+(\w+)',text,re.M))
    assert len(new_names)==409 and new_names<={e['name'] for e in audit}
    inventory=json.loads((audit_dir/'SOURCE_INPUTS.json').read_text())
    for entry in inventory['sources']:
        assert sha(entry['path'])==entry['sha256'],entry.get('module')
    for entry in inventory['reused']:
        assert sha(entry.get('current_source',entry['source']))==entry['source_sha256'],entry['module']
        assert sha(entry['artifact'])==entry['artifact_sha256'],entry['module']
    assert len(inventory['sources'])+len(inventory['reused'])==433

    sage=[]
    for label,source,product,generated in [
        ('keygen_shake_source_022_001','generate_shake_source.sage','SHAKE_SOURCE.json','ShakeSource.lean'),
        ('keygen_shake_block_generate_022_001','generate_shake_block.sage','SHAKE_BLOCK_SOURCE.json','ShakeBlockProgram.lean'),
        ('keygen_shake_rc_generate_022_002','generate_shake_rc.sage','SHAKE_RC_SOURCE.json','ShakeRcBinding.lean'),
        ('keygen_sampler_checks_022_002','check_keygen_sampler_refill.sage','SAMPLER_REFILL_CHECK.json',None)]:
        directory=ROOT/'.build/jobs'/label
        record=json.loads((directory/'RECEIPTS.json').read_text())[0]
        assert record['accepted'] and record['clean_log'] and record['exit_code']==0
        assert sha(ROOT/'sage'/source)==sha(directory/'sage'/source)==record['source_sha256']
        committed(ROOT/'sage'/source,head)
        result=json.loads((directory/product).read_text())
        artifacts=[]
        if generated:
            assert sha(directory/generated)==sha(ROOT/'formal/Source3'/generated)==result['generated_sha256']
            artifacts.append(pin(directory/generated))
        else:
            assert len(result['variants'])==14 and result['permutation_cases']==8 and result['sampler_cases']==24
            assert sha(job.OLD/'inputs/source/PROFILE.json')==result['profile_sha256']
            for name,expected in result['source_pins'].items():
                assert sha(job.OLD/'inputs/source'/name)==expected,name
            for variant in result['variants']:
                assert bool(variant['permutation_differences'] or variant['sampler_differences'])==(variant['variant']!='baseline')
                for path,expected in variant['artifacts'].items():
                    path=directory/path
                    assert sha(path)==expected,path
                    artifacts.append(pin(path))
        sage.append({'job':label,'source':pin('sage/'+source),'snapshot':pin(directory/'sage'/source),
            'receipt':pin(directory/'RECEIPTS.json'),'source_inputs':pin(directory/'SOURCE_INPUTS.json'),
            'result':pin(directory/product),'logs':streams(directory,record),'artifacts':artifacts})

    history=[]
    for directory in sorted((ROOT/'.build/jobs').glob('*_022_*')):
        common={'job':directory.name,'preflight':pin(directory/'PREFLIGHT.json')}
        receipt=directory/'RECEIPTS.json'
        if not receipt.exists():
            assert directory.name=='keygen_shake_rc_binding_022_001'
            assert not (directory/'SOURCE_INPUTS.json').exists()
            common.update(status='PREFLIGHT_REFUSAL_NO_RECEIPT',
                retained=[pin(directory/name) for name in ['RUNNER_SOURCE.py','EXECUTION_SOURCE.py']],
                note=pin('.build/execution_022/PREFLIGHT_REFUSAL.md'))
        else:
            inputs=json.loads((directory/'SOURCE_INPUTS.json').read_text())
            snapshots=[]
            for entry in inputs['sources']:
                rel='formal/'+entry['module'].replace('.','/')+'.lean' if 'module' in entry else 'sage/'+Path(entry['path']).name
                snapshot=directory/rel
                assert sha(snapshot)==entry['sha256'],snapshot
                snapshots.append(pin(snapshot))
            records=json.loads(receipt.read_text())
            steps=[]
            for record in records:
                step={'name':record['name'],'accepted':record['accepted'],'clean_log':record['clean_log'],
                    'source_sha256':record['source_sha256'],'elapsed_s':record['elapsed_s'],
                    'maxrss_kib':record['cumulative_child_maxrss_kib'],'logs':streams(directory,record)}
                if not record['accepted']:
                    text=(directory/record['stdout']).read_text()+(directory/record['stderr']).read_text()
                    step['failure_excerpt']=[s for s in text.splitlines() if any(x in s.lower() for x in ['error','panic','memory'])][:8]
                steps.append(step)
            common.update(receipt=pin(receipt),source_inputs=pin(directory/'SOURCE_INPUTS.json'),snapshots=snapshots,
                steps=steps,status='ACCEPTED' if all(r['accepted'] for r in records) else 'FAILED_RETAINED',
                products=[pin(p) for p in sorted(directory.glob('*.json')) if p.name not in {'SOURCE_INPUTS.json','RECEIPTS.json','PREFLIGHT.json'}])
            diagnostic=directory/'SHAKE_BINDING_PROGRESS.txt'
            if diagnostic.exists():
                common['diagnostic_progress']=pin(diagnostic)
            diagnostic=directory/'SHAKE_RC_PROGRESS.txt'
            if diagnostic.exists():
                common['diagnostic_progress']=pin(diagnostic)
        wait=ROOT/'.build/waits'/directory.name/'WAIT.jsonl'
        if wait.exists(): common['wait']=pin(wait)
        history.append(common)
    assert len(history)==45
    assert sum(e['status']=='FAILED_RETAINED' for e in history)==23
    assert sum(e['status']=='PREFLIGHT_REFUSAL_NO_RECEIPT' for e in history)==1
    predecessors={}
    for number in ['015','016','017','018','019','020','021']:
        for suffix in ['.json','_NOTES.md']:
            path='notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_'+number+suffix
            predecessors[path]=preflight['checked'][str(ROOT/path)]
    result={'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_022','stage':'B1.05',
        'created_utc':datetime.now(timezone.utc).isoformat(),'window':'CLOSED_AT_RECOVERABLE_MIDPOINT',
        'b1_05_acceptance':'NOT_MET','stage_result':'PARTIAL_PROOF',
        'status':'IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN',
        'harness':'GPT-6 Astra Ultrafast / openai/gpt-6-astra-ultrafast',
        'runner_note':'Historical runner model/session labels are provenance. Unchanged guarded serial execution.',
        'runner':pin('tools/job.py'),'waiter':pin('tools/job_when_available.py'),
        'organizer':pin(Path(__file__).resolve()),'organizer_helpers':pin('tools/keygen_ntt_batch.py'),
        'audit_source_generator':pin('tools/keygen_execution_audit_source.py'),
        'audit_generator_template':pin('formal/Source3/KeygenSmallBoundsAudit.lean'),
        'preflight':pin('.build/execution_022/PREFLIGHT.json'),'preflight_program':pin('.build/execution_022/preflight.py'),
        'preflight_files_checked':1840,'preflight_current_inputs':415,'input_pins':predecessors,
        'proof_head':head,'accepted_module_checks':accepted,'current_final_audit_inputs':433,
        'contracts':{
            'output_gate':'Actual parsed7342--7346 short-circuit gate, fixed small-output calls, derived n/v bindings and F/G Bound2047 on retained bytes. Typed Context and root caller entry remain explicit.',
            'refill':'Fixed full process_block, enc64le and shake_extract bodies; all24 RC words source bound. Actual LE get_rng_u64 local object, extract8, same-byte Load64 and teardown. Derived protected-object frames; no arbitrary RNG call or IID premise.',
            'sampler':'Complete finite MODE1 loops, rejection/refill, counter increments and1536 stores imply Represents and Bound1. Legal typed rng Layout, n1536, live disjoint output object and destination binding/width remain entry inputs.',
            'two_calls':'Actual v/n parameter binding for both calls and protected-object frame give f/g with Bound1 on the same final heap. The typed fk-to-rng subobject resolution is an enclosing caller obligation.',
            'validation':'gate_validated derives F/G bounds and passes the same four vectors to BATCH_020, concluding exact integer NTRU and retained material. Incoming f/g Represents/Bound1 and inherited legal/source validation bindings remain explicit local inputs.',
            'open':'Complete92-node active solver/search operational closure and root source caller. Derive context/member/scratch/PRIMES3 bindings; transport sampled f/g through actual search and intervening gates; supply existing generator/conversion/NTT validation entry without extra source-completeness or correctness premises.'},
        'audit':{**pin(audit_dir/'EXECUTION_AUDIT.json'),'receipt':pin(audit_dir/'RECEIPTS.json'),
            'source_inputs':pin(audit_dir/'SOURCE_INPUTS.json'),'exports':423,'new_declarations':409,
            'full_pretty_terms':393,'kernel_inductives_with_constructor_types':30,
            'allowed_axioms':['propext','Classical.choice','Quot.sound'],'elisions':0,
            'generator':'formal/Source3/KeygenExecutionAudit.lean','independent_review':False},
        'sage':sage,'attempt_history':history,
        'retained_failures':'23 failed jobs and one stale-cache preflight refusal; full snapshots/raw streams retained when the runner reached them. Monolithic source/RC reductions exhausted budgets; chunked parse equalities and congrArg composition resolved them. Explicitly record missing receipt/streams of the preflight refusal.',
        'limits':'Unchanged Lean-j1/-M6144, maxRecDepth32768/maxHeartbeats2000000, wall1800s, AS12GiB/RSS8GiB, warnings as errors. pp.maxSteps200000 for printing. Sage standard preparser, shell waits timeout0.',
        'build_scope':'18 new Lean modules with the complete current433-input inventory; affected descendants rebuilt. No unchanged full-project replay, independent review or compiler theorem.',
        'next_owner_stage':'Resume B1.05 section6: full solver/search/caller execution and sampled-material transport. B1.06 not entered.',
        'git':{'branch':'main','author':'niirmataa','writer_lock':'proofs/ft1536/work/archive.lock',
            'source_commits':['7a1d5bc2','e617e098','9f0e5ef8'],'push':'none; owner signal required','foreign_changes':'preserved'},
        'active_jobs_at_close':[]}
    with OUT.open('x') as stream:
        json.dump(result,stream,indent=2)
        stream.write('\n')
    print(json.dumps({'batch_sha256':sha(OUT),'modules':len(accepted),'exports':len(audit),
        'attempts':len(history),'failed_jobs':23,'preflight_refusals':1,'current_final_audit_inputs':433,
        'max_accepted_rss_kib':max(e['maxrss_kib'] for e in accepted)},indent=2))

if __name__=='__main__':
    main()
