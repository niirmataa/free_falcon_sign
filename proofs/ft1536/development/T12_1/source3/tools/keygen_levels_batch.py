#!/usr/bin/env python3
"""Seal the BATCH_024 expanded B1.05 midpoint; integrity, not review."""
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import subprocess

import job
from keygen_ntt_batch import ROOT,REPO,sha,pin,read,streams
from keygen_levels_audit_source import MODULES,INHERITED,declarations

OUT=ROOT/'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_024.json'

def committed(path,head):
    data=subprocess.check_output(['git','show',head+':'+str(path.relative_to(REPO))],cwd=REPO)
    assert hashlib.sha256(data).hexdigest()==sha(path),path

def main():
    assert not OUT.exists(),'Never overwrite a historical batch receipt'
    assert not job.active(),'A proof job is active'
    assert subprocess.check_output(['git','branch','--show-current'],cwd=REPO,text=True).strip()=='main'
    head=subprocess.check_output(['git','rev-parse','HEAD'],cwd=REPO,text=True).strip()
    preflight=read('.build/levels_024/PREFLIGHT.json')
    assert len(preflight['checked'])==2595 and preflight['current_source_inputs']==445
    for path,expected in preflight['checked'].items(): assert sha(path)==expected,path
    cache=read('.build/cache/CACHE_INDEX.json');accepted=[]
    for name in MODULES+['KeygenLevelsAudit']:
        module='Source3.'+name;entry=cache[module]
        source,receipt=Path(entry['source']),Path(entry['receipt']);directory=receipt.parent
        assert sha(source)==entry['source_sha256'];committed(source,head)
        records=json.loads(receipt.read_text());record=next(r for r in records if r['name']==module.replace('.','_'))
        assert record['accepted'] and record['clean_log'] and record['exit_code']==0
        assert not record['forbidden_proof_markers'] and record['cumulative_child_maxrss_kib']<=8*1024*1024
        snapshot=directory/'formal/Source3'/(name+'.lean');artifact=directory/'lib/Source3'/(name+'.olean')
        assert sha(snapshot)==sha(source)==record['source_sha256']
        assert sha(artifact)==sha(entry['artifact'])==record['olean_sha256']==entry['artifact_sha256']
        for imported,expected in entry.get('imports',{}).items():
            if imported in cache: assert cache[imported]['artifact_sha256']==expected,(module,imported)
        accepted.append({'module':module,'source':pin(source),'snapshot':pin(snapshot),'artifact':pin(artifact),
            'receipt':pin(receipt),'source_inputs':pin(directory/'SOURCE_INPUTS.json'),'job':directory.name,
            'logs':streams(directory,record),'imports':entry.get('imports',{}),'elapsed_s':record['elapsed_s'],
            'maxrss_kib':record['cumulative_child_maxrss_kib'],'all_steps_in_job_accepted':all(r['accepted'] for r in records)})
    audit_dir=Path(cache['Source3.KeygenLevelsAudit']['receipt']).parent
    audit=json.loads((audit_dir/'LEVELS_AUDIT.json').read_text());new=set(declarations())
    assert len(audit)==len({e['name'] for e in audit})==len(new)+len(INHERITED)
    assert new<={e['name'] for e in audit}
    for entry in audit:
        assert set(entry['axioms'])<={'propext','Classical.choice','Quot.sound'}
        assert '⋯' not in json.dumps(entry,ensure_ascii=False)
    inventory=json.loads((audit_dir/'SOURCE_INPUTS.json').read_text())
    for e in inventory['sources']: assert sha(e['path'])==e['sha256'],e.get('module')
    for e in inventory['reused']:
        assert sha(e.get('current_source',e['source']))==e['source_sha256'],e['module']
        assert sha(e['artifact'])==e['artifact_sha256'],e['module']
    input_count=len(inventory['sources'])+len(inventory['reused'])
    directory=ROOT/'.build/jobs/keygen_levels_checks_024_002'
    record=json.loads((directory/'RECEIPTS.json').read_text())[0]
    assert record['accepted'] and record['clean_log'] and record['exit_code']==0
    source=ROOT/'sage/check_keygen_levels.sage';committed(source,head)
    assert sha(source)==sha(directory/'sage'/source.name)==record['source_sha256']
    controls=json.loads((directory/'LEVELS_CHECK.json').read_text());assert len(controls['variants'])==14
    assert sha(directory/'PUBLIC_FIXTURE.json')==controls['fixture_sha256']
    assert sha(job.OLD/'inputs/source/PROFILE.json')==controls['profile_sha256']
    for name,expected in controls['source_pins'].items(): assert sha(job.OLD/'inputs/source'/name)==expected
    artifacts=[pin(directory/'PUBLIC_FIXTURE.json')]
    for variant in controls['variants']:
        assert bool(variant['differences'])==(variant['variant']!='baseline')
        assert variant['counts']=={'L':1,'Z':35,'N':38,'R':5,'T':10,'Q':15}
        for path,expected in variant['artifacts'].items():
            path=directory/path;assert sha(path)==expected,path
            artifacts.append(pin(path))
    sage={'job':directory.name,'source':pin(source),'snapshot':pin(directory/'sage'/source.name),
        'receipt':pin(directory/'RECEIPTS.json'),'source_inputs':pin(directory/'SOURCE_INPUTS.json'),
        'result':pin(directory/'LEVELS_CHECK.json'),'logs':streams(directory,record),'artifacts':artifacts}
    history=[]
    superseded={
        'keygen_zint_leaves_024_001':'NormFrame step was a binary-only helper, not the active M0 gate. Current ZintLeaves remains checked after rebuild; the binary helper snapshot is retained but superseded.',
        'keygen_active_norm_024_001':'Parsed raw-norm gate used the generic scalar table, which lacks fpr_lt. Not accepted as complete operational closure; replaced by explicit C99CompareObjects.Exec in _002.',
    }
    for directory in sorted((ROOT/'.build/jobs').glob('*_024_*')):
        records=json.loads((directory/'RECEIPTS.json').read_text());inputs=json.loads((directory/'SOURCE_INPUTS.json').read_text())
        snapshots=[]
        for entry in inputs['sources']:
            rel='formal/'+entry['module'].replace('.','/')+'.lean' if 'module' in entry else 'sage/'+Path(entry['path']).name
            snapshot=directory/rel;assert sha(snapshot)==entry['sha256'];snapshots.append(pin(snapshot))
        steps=[]
        for record in records:
            step={'name':record['name'],'runner_accepted':record['accepted'],'clean_log':record['clean_log'],
                'source_sha256':record['source_sha256'],'elapsed_s':record['elapsed_s'],
                'maxrss_kib':record['cumulative_child_maxrss_kib'],'logs':streams(directory,record)}
            if not record['accepted']:
                text=(directory/record['stdout']).read_text()+(directory/record['stderr']).read_text()
                step['failure_excerpt']=[line for line in text.splitlines() if 'error' in line.lower() or 'Assertion' in line][:8]
            steps.append(step)
        status='ACCEPTED_SUPERSEDED_SCOPE' if directory.name in superseded else (
            'ACCEPTED' if all(r['accepted'] for r in records) else 'FAILED_RETAINED')
        record={'job':directory.name,'status':status,'preflight':pin(directory/'PREFLIGHT.json'),
            'receipt':pin(directory/'RECEIPTS.json'),'source_inputs':pin(directory/'SOURCE_INPUTS.json'),
            'snapshots':snapshots,'steps':steps,'products':[pin(p) for p in sorted(directory.iterdir()) if p.is_file()
                and p.suffix in {'.json','.c','.stdout','.stderr'} and p.name not in {'PREFLIGHT.json','SOURCE_INPUTS.json','RECEIPTS.json'}]}
        if directory.name in superseded: record['scope_correction']=superseded[directory.name]
        wait=ROOT/'.build/waits'/directory.name/'WAIT.jsonl'
        if wait.exists(): record['wait']=pin(wait)
        history.append(record)
    counts={s:sum(e['status']==s for e in history) for s in ['ACCEPTED','FAILED_RETAINED','ACCEPTED_SUPERSEDED_SCOPE']}
    predecessors={path:expected for path,expected in preflight['checked'].items()
        if '/notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_' in path and Path(path).name.endswith(('.json','_NOTES.md'))}
    result={'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_024','stage':'B1.05',
        'created_utc':datetime.now(timezone.utc).isoformat(),'window':'CLOSED_AT_RECOVERABLE_MIDPOINT',
        'b1_05_acceptance':'NOT_MET','stage_result':'PARTIAL_PROOF','status':'IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN',
        'harness':'GPT-6 Astra Ultrafast / openai/gpt-6-astra-ultrafast','runner_note':'Historical runner labels are provenance.',
        'runner':pin('tools/job.py'),'waiter':pin('tools/job_when_available.py'),'organizer':pin(Path(__file__).resolve()),
        'organizer_helpers':pin('tools/keygen_ntt_batch.py'),'verifier':pin('tools/keygen_levels_verify.py'),
        'audit_source_generator':pin('tools/keygen_levels_audit_source.py'),
        'audit_generator_template':pin('formal/Source3/KeygenSmallBoundsAudit.lean'),
        'preflight':pin('.build/levels_024/PREFLIGHT.json'),'preflight_program':pin('tools/keygen_search_verify.py'),
        'preflight_files_checked':2595,'preflight_current_inputs':445,'input_pins':predecessors,'proof_head':head,
        'accepted_module_checks':accepted,'current_final_audit_inputs':input_count,
        'contracts':{
            'search_dependencies':'Complete inverse ternary NTT and fixed all-depth forward/inverse/generator calls with derived byte frames; complete make_fg_ternary_top with actual prime-member reads and memmove; seven complete bigint leaves.',
            'sampled_material':'Complete mod2_res_ternary with local b[96], memset, all switch cases/fallthrough and actual return; both actual caller gates, including rejection paths, preserve sampled f/g Bound1 on the same heap via sampled_material.',
            'norm':'Active raw FFT/FPEMU norm computation and gate preserve disjoint f/g. Comparator executes the real object-copy helper, not a missing entry in the generic scalar table.',
            'entry_boundary':'Existing typed sampler Layout/global/profile/n1536 and legal object bindings remain explicit; search static tables and scratch separation are local inputs. Norm bound initialization and its connection to preceding gates remain open.',
            'open':'Full deepest/intermediate, make_fg_step/CRT/Bezout and remaining intermediate dependencies; root solver post-decrement loop, actual member/alias/static/profile/validation bindings; complete sampled-material transport through GS/public/search. B1.05 Acceptance NOT MET.'},
        'audit':{**pin(audit_dir/'LEVELS_AUDIT.json'),'receipt':pin(audit_dir/'RECEIPTS.json'),
            'source_inputs':pin(audit_dir/'SOURCE_INPUTS.json'),'exports':len(audit),'new_declarations':len(new),
            'full_pretty_terms':sum('term' in e['body'] for e in audit),
            'kernel_inductives_with_constructor_types':sum(e['body']['kind']=='kernel_inductive' for e in audit),
            'allowed_axioms':['propext','Classical.choice','Quot.sound'],'elisions':0,
            'generator':'formal/Source3/KeygenLevelsAudit.lean','independent_review':False},
        'sage':sage,'attempt_history':history,'attempt_counts':counts,
        'retained_failures':'Failed deriving/type-composition/compiler-warning attempts retained. Both superseded norm routes are explicit; _active_norm_024_001 is not evidence of a complete call closure. Current comparator uses existing inhabited source execution.',
        'limits':'Unchanged Lean-j1/-M6144, maxRecDepth32768/maxHeartbeats2000000, wall1800s, AS12GiB/RSS8GiB, warnings as errors, pp.maxSteps200000. Sage standard preparser.',
        'build_scope':'Changed/new dependency closure, full new-declaration audit and targeted finite controls. No unchanged broad replay or independent review.',
        'next_owner_stage':'Resume B1.05 checkpoint section6; complete remaining deepest/intermediate dependencies, root caller and whole material transport. B1.06 not entered.',
        'git':{'branch':'main','author':'niirmataa','writer_lock':'proofs/ft1536/work/archive.lock',
            'source_commits':['4f787baf','60eb842b','dfff8cd4',head],'push':'none; owner signal required','foreign_changes':'preserved'},
        'active_jobs_at_close':[]}
    with OUT.open('x') as stream: json.dump(result,stream,indent=2);stream.write('\n')
    print(json.dumps({'batch_sha256':sha(OUT),'modules':len(accepted),'exports':len(audit),'attempts':len(history),
        'counts':counts,'current_final_audit_inputs':input_count,'max_accepted_rss_kib':max(e['maxrss_kib'] for e in accepted)},indent=2))

if __name__=='__main__':
    main()
