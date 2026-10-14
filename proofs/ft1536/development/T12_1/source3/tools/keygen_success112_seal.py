#!/usr/bin/env python3
"""Seal the partial success-mass window, without claiming a population bound."""
from pathlib import Path
import fcntl
import hashlib
import json
import subprocess
import sys
import job111 as job
import pre_sign_evidence084 as evidence
import keygen_success112_audit as audit

ROOT, REPO = evidence.ROOT, evidence.REPO
BUILD = ROOT / '.build/success112'
PARENT = ROOT / '.build/key_law088/POSTSEAL_111.json'
PARENT_SHA = '0476066da04edb02c2009a6d0fdc7a9286b9e08f8100d3cd5c7c87cd161a6a65'
RECEIPT = ROOT / 'notes/run/KEYGEN_SUCCESS_112.json'


def inherited():
    evidence.check(PARENT, PARENT_SHA)
    checked = json.loads(PARENT.read_text())['checked']
    assert len(checked) == 27064
    for path, digest in checked.items():
        evidence.check(path, digest)
    return checked


def entry():
    prior = ROOT / 'notes/run/KEYGEN_WHOLE_LAW_FINAL_001.json'
    evidence.check(prior, 'def7ba6f8dbe64e8decf3856e9c02d33fb55bd8e83ee3a4ca5a09df167cfb750')
    value = json.loads(prior.read_text())
    post = Path(value['final_postseal']['path'])
    evidence.check(post, value['final_postseal']['sha256'])
    old = json.loads(post.read_text())
    mutable = {str(ROOT/'WORK_STATE.md'), str(ROOT/'notes/run/KEYGEN_RESIDUE_CHECKPOINT.md')}
    snapshots = []
    for path, expected in old['checked'].items():
        if path in mutable:
            rel = str(Path(path).relative_to(REPO))
            payload = subprocess.check_output(['git','show',old['head']+':'+rel],cwd=REPO)
            assert hashlib.sha256(payload).hexdigest() == expected, ('HISTORICAL_SNAPSHOT_MISMATCH', rel)
            snapshots.append({'file':path,'historical_head':old['head'],'historical_sha256':expected,
                'current_sha256':evidence.sha(path),'reason':'Authorized new112 window updates this live view; historical committed bytes verified, not repinned.'})
        else:
            evidence.check(path, expected)
    return evidence.write(BUILD/'ENTRY.json',{'status':'PASS_INCOMING_PROOFS_AND_PRIOR_COMMITTED_SNAPSHOT',
        'prior_final':evidence.pin(prior),'prior_final_postseal':evidence.pin(post),
        'checked_prior_files':len(old['checked']),'live_snapshot_checks':snapshots,
        'immutable_parent':evidence.pin(PARENT),'numeric_acceptance_bound_proved':False})


def seal():
    inherited()
    assert not job.active(),job.active()
    entry_record=json.loads((BUILD/'ENTRY.json').read_text())
    assert entry_record['status']=='PASS_INCOMING_PROOFS_AND_PRIOR_COMMITTED_SNAPSHOT'
    final=ROOT/'.build/jobs/keygen_success112_008'
    rows=json.loads((final/'RECEIPTS.json').read_text())
    assert len(rows)==5
    for row in rows:
        assert row['accepted'] and row['exit_code']==0 and row['clean_log'] and not row['forbidden_proof_markers']
        assert (final/row['stdout']).stat().st_size==(final/row['stderr']).stat().st_size==0
        evidence.check(ROOT/'formal/Source3'/(row['name'][8:]+'.lean'),row['source_sha256'])
    audited=json.loads((final/'SEARCH_AUDIT.json').read_text())
    assert len(audited)==34 and {r['name'] for r in audited}==set(audit.names())
    for row in audited:
        assert set(row['axioms'])<={'propext','Classical.choice','Quot.sound'}
        assert '⋯' not in json.dumps(row,ensure_ascii=False)
        if row['body']['kind']!='kernel_inductive':
            assert row['body']['kind']=='full_expression_dag_json' and row['body']['roundtrip_term_and_type_checked']
    pins=[evidence.pin(ROOT/'formal/Source3'/(m+'.lean')) for m in audit.MODULES+['KeygenSuccess112Audit']]
    for row in json.loads((final/'SOURCE_INPUTS.json').read_text())['reused']:
        source=row.get('current_source',row['source'])
        evidence.check(source,row['source_sha256']);evidence.check(row['artifact'],row['artifact_sha256'])
        pins += [evidence.pin(source),evidence.pin(row['artifact'])]
    inputs=json.loads((ROOT/'notes/run/KEYGEN_SUCCESS_112_INPUTS.json').read_text())
    for row in inputs['inputs']:
        evidence.check(REPO/row['path'],row['sha256']);pins.append(evidence.pin(REPO/row['path']))
    search=json.loads((BUILD/'H3_EXPORT_SEARCH.json').read_text())
    assert len(search['sources'])==606 and not search['acceptance_name_matches']
    for row in search['source_pins']:
        evidence.check(row['path'],row['sha256']);pins.append(evidence.pin(row['path']))
    control=ROOT/'.build/jobs/keygen_success112_007'
    rec=json.loads((control/'RECEIPTS.json').read_text())[0]
    assert rec['accepted'] and rec['clean_log'] and rec['exit_code']==0
    assert (control/rec['stdout']).stat().st_size==(control/rec['stderr']).stat().st_size==0
    evidence.check(ROOT/'sage/keygen_success112_controls.sage',rec['source_sha256'])
    result=json.loads((control/'SUCCESS112_CONTROLS.json').read_text())
    assert result['status']=='PASS_EXACT_AUXILIARY_CONTROLS_ONLY'
    assert result['new_keygen_runs']==0 and not result['population_probability_lower_bound_proved']
    assert (BUILD/'COMPUTATION_VALIDATION.stdout').read_text().startswith('valid legacy version 1 evidence record;')
    assert (BUILD/'COMPUTATION_VALIDATION.stderr').stat().st_size==0
    for rel in ['tools/job111.py','tools/keygen_success112_audit.py','tools/keygen_success112_seal.py',
        'sage/keygen_success112_controls.sage','notes/run/KEYGEN_SUCCESS_112_PLAN.md',
        'notes/run/KEYGEN_SUCCESS_112_REPORT.md','notes/run/KEYGEN_SUCCESS_112_INPUTS.json',
        'notes/run/KEYGEN_SUCCESS_112_COMPUTATION.json','notes/run/KEYGEN_SUCCESS_112_FAILURES.json',
        '.build/success112/ENTRY.json','.build/success112/H3_EXPORT_SEARCH.json',
        'notes/run/KEYGEN_WHOLE_LAW_FINAL_001.json','.build/key_law088/FINAL_POSTSEAL_001.json',
        '.build/success112/COMPUTATION_VALIDATION.stdout','.build/success112/COMPUTATION_VALIDATION.stderr',
        '.build/jobs/keygen_success112_007/SUCCESS112_CONTROLS.json']:
        pins.append(evidence.pin(ROOT/rel))
    causes=json.loads((ROOT/'notes/run/KEYGEN_SUCCESS_112_FAILURES.json').read_text());history=[]
    for i in range(1,9):
        label=f'keygen_success112_{i:03d}'
        steps=json.loads((ROOT/'.build/jobs'/label/'RECEIPTS.json').read_text())
        failed=any(not step['accepted'] for step in steps)
        assert failed==(label in causes)
        history.append({'job':label,'failed_or_mixed':failed,'cause':causes.get(label),'files':evidence.job_files(label)})
    return evidence.write(RECEIPT,{'stage':'112','status':'PARTIAL_PROOF / NOT_REVIEWED',
        'owner_task':'NOT_COMPLETE: NUMERICAL_P_ACCEPT_LOWER_BOUND_OPEN',
        'witness_implication_proved':True,'first_attempt_source_monotonicity_proved':True,
        'concrete_kernel_success_seed':False,'numeric_p_accept_lower_bound_proved':False,
        'unconditional_positive_p_K_proved':False,'F04_is_KeyGen_marginal':False,
        'empirical_is_premise':False,'new_keygen_runs':0,'new_assumptions':False,
        'do_sign_slot_items':5,'paper_changed':False,'independent_review':False,'push':False,
        'previous_postseal':evidence.pin(PARENT),'evidence':pins,'history':history,
        'mathematical_declarations':audit.names(),'final_job':'keygen_success112_008',
        'counts':{'new_mathematical_modules':4,'new_declarations':31,'audited_declarations':34,
            'final_clean_modules':5,'jobs':8,'failed_jobs':2,'sage_clean_control_jobs':1}})


def postseal(expected):
    checked=dict(inherited())
    def add(path,digest):
        path=str(Path(path).resolve());evidence.check(path,digest)
        assert path not in checked or checked[path]==digest,('CONFLICTING_PIN',path)
        checked[path]=digest
    def walk(value):
        if isinstance(value,dict):
            if 'path' in value and 'sha256' in value:add(value['path'],value['sha256'])
            for child in value.values():walk(child)
        elif isinstance(value,list):
            for child in value:walk(child)
    add(PARENT,PARENT_SHA);add(RECEIPT,expected);walk(json.loads(RECEIPT.read_text()))
    assert not job.active(),job.active()
    return evidence.write(BUILD/'POSTSEAL_112.json',{'status':'PASS_INTEGRITY; NUMERICAL_ACCEPTANCE_OPEN',
        'checked':checked,'distinct_pinned_files':len(checked),'numeric_p_accept_lower_bound_proved':False,
        'concrete_kernel_success_seed':False,'independent_review':False,'push':False})


if __name__=='__main__':
    with (ROOT/'.build/JOB.lock').open('a') as lock:
        fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
        if sys.argv[1:]==['entry']:result=entry()
        elif sys.argv[1:]==['seal']:result=seal()
        elif len(sys.argv)==3 and sys.argv[1]=='postseal':result=postseal(sys.argv[2])
        else:raise SystemExit('entry | seal | postseal RECEIPT_SHA256')
        print(json.dumps(result))
