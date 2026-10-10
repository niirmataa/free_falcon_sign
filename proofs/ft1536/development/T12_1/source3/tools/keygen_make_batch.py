#!/usr/bin/env python3
"""Seal/verify049's whole-syntax/ready-failure midpoint; preserve015--048."""
from datetime import datetime, timezone
from pathlib import Path
import json
import subprocess
import sys

import job
from keygen_intermediate_batch import path, read, pin, committed, streams
from keygen_public_first_batch import write_receipt
from keygen_make_audit_source import MODULES, INHERITED, declarations

BASE='notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_049'
ENTRY='.build/levels_049/ENTRY_PINS_049.json'
ENTRY_SHA='3fea9435f3f6638bfced299058df18f8cb2842798cd8ce6ec774ef1c2754d909'
RECOVERY='.build/levels_049/RECOVERY_005.json'
RECOVERY_SHA='a17a27f1f89707e77e89e9c14f8619dbfc102aaab7439b361d2d02f6b38fc91b'
CACHE_RECOVERY='.build/levels_049/RECOVERY_CACHE_ALIASES.json'
CACHE_RECOVERY_SHA='d1ad5b880cb55023672b87450ce9285676543aaa4af89b6629fc0e5cd9cd4780'
GENERATED='.build/levels_049/GENERATOR_CHECK.json'
GENERATED_SHA='73187e5c9f4a57abfb1763d131dc5bc6b47f287d124590f99cc490a24c1f959d'
CONTROL='.build/jobs/keygen_make_controls_049_002'
SAGE='sage/check_keygen_make_control.sage'
INTERRUPTED='keygen_make_program_049_005'
CAUSES={
    'keygen_make_syntax_049_001':'Reserved public/postfix keywords caused cascading syntax errors; no accepted product.',
    'keygen_make_syntax_049_002':'Nested List Expr equality derivation and clause indentation; changed to explicit argument-list tree, no source outcome assumed.',
    'keygen_make_program_049_001':'Whole direct parser reduction reached unchanged recursion/memory limits; ordinary meta interpreter panic retained.',
    'keygen_make_program_049_002':'Generated list literal had whitespace before .map; the rejected token producer is retained.',
    'keygen_make_program_049_003':'Tokens accepted, monolithic Binding meta reduction hit memory limits.',
    'keygen_make_program_049_004':'Generic String.toNat? and predicate reducibility prevented kernel reflection. Used the existing scalar numeral parser and reducible equality predicates.',
    'keygen_make_program_049_006':'Monolithic Binding hit unchanged meta memory limit after server recovery.',
    'keygen_make_program_049_007':'Ordinary interpreter memory exception; complete source reduction not forced through.',
    'keygen_make_program_049_008':'Progress retained through node013; nested-expression meta interpreter memory exception.',
    'keygen_make_program_049_009':'Reflexivity alone did not solve the interpreter-memory problem; source snapshot retained.',
    'keygen_make_program_049_010':'Part00 accepted, Part01 nested bound expression hit memory limit.',
    'keygen_make_program_049_011':'Own parser fuel was lowered64 to24 with necessary own dependency rebuilds; Part01 still failed. No inherited source/proof/job limit changed.',
    'keygen_make_program_049_012':'Progress through guard040 localizes the failure to the actual bound expression.',
    'keygen_make_expression_probe_049_002':'Native parser diagnostic agrees with the expected bound AST, but reflexivity meta reduction exceeds memory; diagnostic is not a proof.',
    'keygen_make_program_049_013':'All bounded Binding parts accepted with decide +kernel, then Program meta evaluation failed.',
    'keygen_make_program_049_014':'Reserved variable helper keyword exposed after switching to kernel reduction; cascading error output and memory diagnostic retained.',
    'keygen_make_lifetime_049_001':'Explicit scalar restore unfolding and indexed-constructor binder counts needed; no warning suppression.',
    'keygen_make_lifetime_049_002':'Use the dependent inferred Result after indexed elimination, not an eliminated out binder.',
    'keygen_make_controls_049_001':'The cap-region organizer missed the actual return0 after the conditional directive; no C compile/run occurred.',
    'keygen_make_audit_049_001':'The complete readiness/sampling module must be explicitly imported for its inherited type/term audit.'}


def entry_checked():
    assert not job.active(), 'A proof job is active'
    assert job.sha(path(ENTRY))==ENTRY_SHA
    entry=read(ENTRY)
    assert entry['batch']=='BATCH_015-048'
    assert entry['distinct_pinned_files']==len(entry['checked'])==9871
    assert entry['current_source_inputs']==718 and entry['active_jobs']==[] and entry['superseded']=={}
    for p,expected in entry['checked'].items(): assert job.sha(path(p))==expected,('predecessor changed',p)
    return entry


def predecessor(target):
    entry=entry_checked()
    result={'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-048',
        'checked':entry['checked'],'distinct_pinned_files':9871,'entry':pin(ENTRY),
        'active_jobs':[],'superseded':{},'verifier_sha256':job.sha(Path(__file__))}
    print(json.dumps({'predecessor_files':9871,'receipt':write_receipt(target,result)},indent=2))


def recovery_checked():
    assert job.sha(path(RECOVERY))==RECOVERY_SHA
    assert job.sha(path(CACHE_RECOVERY))==CACHE_RECOVERY_SHA
    recovery=read(RECOVERY);aliases=read(CACHE_RECOVERY)
    assert recovery['active_jobs']==[] and len(recovery['completed_steps'])==3
    assert recovery['interrupted_exit_code'] is recovery['interrupted_maxrss_kib'] is None
    assert len(aliases['changes'])==2 and aliases['active_jobs']==[]
    for p,expected in recovery['pins'].items():
        if p in aliases['changes']:
            change=aliases['changes'][p]
            assert path(p).is_relative_to(job.BUILD/'cache/Source3')
            assert path(p).name in {'KeygenMakeSyntax.olean','KeygenMakeGrammar.olean'}
            assert expected==change['old_sha256']==change['retained_original']['sha256']
            assert job.sha(path(change['retained_original']['path']))==expected
            assert path(change['retained_original']['path']).parent==job.BUILD/'jobs'/INTERRUPTED/'lib/Source3'
            assert path(change['current_alias']['path'])==path(p)
            assert job.sha(path(p))==change['current_alias']['sha256']
        else: assert job.sha(path(p))==expected,p
    return recovery,aliases


def seal():
    assert not path(BASE+'.json').exists(), 'Never replace a historical pair'
    entry=entry_checked()
    head=subprocess.check_output(['git','rev-parse','HEAD'],cwd=job.REPO,text=True).strip()
    assert subprocess.check_output(['git','branch','--show-current'],cwd=job.REPO,text=True).strip()=='main'
    preseal=read('.build/levels_049/PRESEAL.json')
    assert preseal['checked']==entry['checked'] and preseal['verifier_sha256']==job.sha(Path(__file__))
    assert job.sha(path(GENERATED))==GENERATED_SHA
    recovery,aliases=recovery_checked()
    generated=read(GENERATED)
    assert generated['status']=='BYTE_EXACT_GENERATOR_REPRODUCTION' and generated['files']==14
    for p,expected in generated['pins'].items(): assert job.sha(path(p))==expected,p
    cache=read('.build/cache/CACHE_INDEX.json');modules=[]
    for name in MODULES+['KeygenMakeAudit']:
        module='Source3.'+name;current=cache[module];source=path(current['source']);directory=path(current['receipt']).parent
        committed(source,head)
        record=next(r for r in read(current['receipt']) if r['name']==module.replace('.','_'))
        assert record['accepted'] and record['clean_log'] and record['exit_code']==0
        assert record['forbidden_proof_markers']==[] and record['cumulative_child_maxrss_kib']<=8*1024*1024
        snapshot=directory/'formal/Source3'/(name+'.lean');artifact=directory/'lib/Source3'/(name+'.olean')
        assert job.sha(source)==job.sha(snapshot)==record['source_sha256']==current['source_sha256']
        assert job.sha(artifact)==job.sha(path(current['artifact']))==record['olean_sha256']==current['artifact_sha256']
        for imported,expected in current.get('imports',{}).items():
            if imported in cache: assert cache[imported]['artifact_sha256']==expected,(module,imported)
        modules.append({'module':module,'source':pin(source),'snapshot':pin(snapshot),'artifact':pin(artifact),
            'cache_artifact':pin(current['artifact']),'receipt':pin(current['receipt']),
            'source_inputs':pin(directory/'SOURCE_INPUTS.json'),'logs':streams(directory,record,True),
            'imports':current.get('imports',{}),'elapsed_s':record['elapsed_s'],'maxrss_kib':record['cumulative_child_maxrss_kib']})
    audit_dir=path(cache['Source3.KeygenMakeAudit']['receipt']).parent;audit=read(audit_dir/'MAKE_AUDIT.json')
    assert len(audit)==len({e['name'] for e in audit})==len(declarations())+len(INHERITED)==1241
    assert {e['name'] for e in audit}==set(declarations())|{'FT1536.Source3.'+n for n in INHERITED}
    assert (audit_dir/'MAKE_AUDIT_ENTRIES.jsonl').read_text().count('\n')==len(audit)
    for e in audit:
        assert set(e['axioms'])<={'propext','Classical.choice','Quot.sound'},e['name']
        assert '⋯' not in json.dumps(e,ensure_ascii=False),e['name']
        if e['body']['kind']=='definition_or_theorem': assert e['body']['term'],e['name']
        else: assert e['body']['kind']=='kernel_inductive' and e['body']['constructors'],e['name']
    inputs=read(audit_dir/'SOURCE_INPUTS.json')
    for e in inputs['sources']: assert job.sha(path(e['path']))==e['sha256'],e['path']
    for e in inputs['reused']:
        assert job.sha(path(e.get('current_source',e['source'])))==e['source_sha256'],e['module']
        assert job.sha(path(e['artifact']))==e['artifact_sha256'],e['module']
    controls=read(path(CONTROL)/'MAKE_CONTROL_CHECK.json');control_record=read(path(CONTROL)/'RECEIPTS.json')[0]
    assert control_record['accepted'] and control_record['clean_log'] and control_record['exit_code']==0
    committed(SAGE,head)
    assert job.sha(path(SAGE))==job.sha(path(CONTROL)/SAGE)==control_record['source_sha256']
    assert controls['status']=='PASS_SCRIPTED_CALLER_CONTROLS' and controls['runs']==12 and controls['cases_per_run']==14
    assert job.sha(path(CONTROL)/'MAKE_PUBLIC_FIXTURE.json')==controls['fixture_sha256']
    assert job.sha(job.OLD/'inputs/source/PROFILE.json')==controls['profile_sha256']
    artifacts=[]
    for variant in controls['variants']:
        assert len(variant['results'])==14 and bool(variant['differences'])==(variant['variant']!='baseline')
        for p,expected in variant['artifacts'].items():
            assert job.sha(path(CONTROL)/p)==expected,p;artifacts.append(pin(path(CONTROL)/p))
    source_pins=[]
    for name,expected in controls['source_pins'].items():
        p=job.REPO/'Extra/c'/name;assert job.sha(p)==expected,p;source_pins.append(pin(p))
    patterns=['keygen_make_*_049_*'];directories=sorted({p for pattern in patterns for p in (job.BUILD/'jobs').glob(pattern)})
    history=[]
    for directory in directories:
        inventory=read(directory/'SOURCE_INPUTS.json');snapshots=[]
        for e in inventory['sources']:
            rel='formal/'+e['module'].replace('.','/')+'.lean' if 'module' in e else 'sage/'+Path(e['path']).name
            p=directory/rel;assert job.sha(p)==e['sha256'],p;snapshots.append(pin(p))
        if directory.name==INTERRUPTED:
            assert not (directory/'RECEIPTS.json').exists()
            records=[]
            for step in recovery['completed_steps']:
                record_path=path(step['engine_receipt']);r=read(record_path)
                assert r['accepted'] and r['clean_log'] and r['exit_code']==0
                records.append(r)
            status='INTERRUPTED_RETAINED';cause='Owner-reported server restart during Binding; three genuine completed engine receipts survive. Driver aggregate and unfinished child exit/time/RSS are absent and NOT fabricated.'
            receipt=None;wait=None
        else:
            records=read(directory/'RECEIPTS.json')
            status='FAILED_RETAINED' if any(not r['accepted'] for r in records) else 'ACCEPTED'
            assert (directory.name in CAUSES)==(status!='ACCEPTED'),directory.name
            cause=CAUSES.get(directory.name);receipt=pin(directory/'RECEIPTS.json')
            wait=pin(job.BUILD/'waits'/directory.name/'WAIT.jsonl')
        history.append({'job':directory.name,'status':status,'cause':cause,'receipt':receipt,'wait_log':wait,
            'source_inputs':pin(directory/'SOURCE_INPUTS.json'),'preflight':pin(directory/'PREFLIGHT.json'),
            'runner_snapshot':pin(directory/'RUNNER_SOURCE.py'),'execution_snapshot':pin(directory/'EXECUTION_SOURCE.py'),
            'snapshots':snapshots,'raw_files':[pin(p) for p in sorted((directory/'logs').iterdir()) if p.is_file()],
            'steps':[{'name':r['name'],'accepted':r['accepted'],'exit_code':r['exit_code'],'elapsed_s':r['elapsed_s'],
                'maxrss_kib':r['cumulative_child_maxrss_kib'],'logs':streams(directory,r)} for r in records],
            'accepted_products':[pin(p) for p in sorted((directory/'lib').rglob('*.olean')) if not p.is_symlink()],
            'products':[pin(p) for p in sorted(directory.iterdir()) if p.is_file() and p.name not in
                {'RECEIPTS.json','SOURCE_INPUTS.json','PREFLIGHT.json','RUNNER_SOURCE.py','EXECUTION_SOURCE.py'}]})
    assert {h['job'] for h in history if h['status']=='FAILED_RETAINED'}==set(CAUSES)
    tools=['tools/job.py','tools/job_when_available.py','tools/keygen_make_tokens.py','tools/keygen_make_binding.py',
        'tools/keygen_make_audit_source.py','tools/keygen_make_batch.py','tools/keygen_intermediate_batch.py',
        'tools/keygen_public_first_batch.py','formal/Source3/KeygenLevelsAudit.lean']
    for p in tools: committed(p,head)
    notes=path(BASE+'_NOTES.md');assert notes.exists()
    result={'task':'KEYGEN_SOURCE_TO_FIBER_001','batch':'BATCH_049','stage':'B1.07',
        'window':'CLOSED_AT_RECOVERABLE_MIDPOINT','b1_07_acceptance':'NOT_MET','stage_result':'PARTIAL_PROOF',
        'status':'IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN','created_utc':datetime.now(timezone.utc).isoformat(),
        'harness':'GPT-6.1 Sol Fast / openai/gpt-6.1-sol-fast','runner_labels':'Historical labels remain provenance.',
        'proof_head':head,'notes':pin(notes),'entry_pins_receipt':pin(ENTRY),'predecessor_files':9871,
        'preseal_predecessor_receipt':pin('.build/levels_049/PRESEAL.json'),'superseded':{},'accepted_module_checks':modules,
        'current_final_audit_inputs':len(inputs['sources'])+len(inputs['reused']),
        'audit':{**pin(audit_dir/'MAKE_AUDIT.json'),'entries_jsonl':pin(audit_dir/'MAKE_AUDIT_ENTRIES.jsonl'),
            'receipt':pin(audit_dir/'RECEIPTS.json'),'source_inputs':pin(audit_dir/'SOURCE_INPUTS.json'),
            'producer':pin('formal/Source3/KeygenMakeAudit.lean'),'generator':pin('tools/keygen_make_audit_source.py'),
            'exports':len(audit),'new_declarations':len(declarations()),'inherited_interfaces':len(INHERITED),
            'full_terms':sum('term' in e['body'] for e in audit),'kernel_inductives':sum('constructors' in e['body'] for e in audit),
            'elisions':0,'allowed_axioms':['propext','Classical.choice','Quot.sound']},
        'sage':{'source':pin(SAGE),'receipt':pin(path(CONTROL)/'RECEIPTS.json'),
            'source_inputs':pin(path(CONTROL)/'SOURCE_INPUTS.json'),'result':pin(path(CONTROL)/'MAKE_CONTROL_CHECK.json'),
            'fixture':pin(path(CONTROL)/'MAKE_PUBLIC_FIXTURE.json'),'profile':pin(job.OLD/'inputs/source/PROFILE.json'),
            'source_files':source_pins,'artifacts':artifacts,'logs':streams(path(CONTROL),control_record,True),
            'runs':12,'cases_per_run':14,'scope':controls['scope']},
        'generator_reproduction':pin(GENERATED),'generated_files':[pin(p) for p in generated['pins']],
        'restart_recovery':pin(RECOVERY),'recovered_pins':[pin(p) for p in recovery['pins']],
        'restart_cache_alias_reconciliation':pin(CACHE_RECOVERY),
        'own_unsealed_cache_alias_changes':aliases['changes'],
        'attempt_details':history,'attempt_counts':{s:sum(h['status']==s for h in history)
            for s in ['ACCEPTED','FAILED_RETAINED','INTERRUPTED_RETAINED']},
        'contracts':{'syntax':'Whole407-line active source,13 checked lexical pieces,1194 tokens,303 compositional nodes. Exact header/scopes/both runtime arms/seven subchecks for six gate groups/complete encoding-call tail. Syntax, not an assumed execution oracle.',
            'lifetime':'Actual outer names/restore operation, all six dead blocks on the COMPLETE048 readiness failure prefix; no callback for later body and no whole-success or codec rule.',
            'controls':'Complete source CALLER with explicitly mocked context/cryptographic callees/codecs and public counter injection. Finite chronological/pointer controls, not real KeyGen, mathematical gates, whole source completeness or a probability law.'},
        'open_in_b1_07':['Whole argument/destination/legal layout and every later-return scope binding beyond the checked readiness-failure edge.',
            'Global reachable count invariant, actual chronological attempt extraction/no normal fallthrough/final break and length<=3000000.',
            'All six SAME source-executed gates,046 public equations,032 solver and complete mandatory certificate with derived entry/common call ID/snapshots/frames/bad lifetime.',
            'Certificate block0 layout/global environment must be transported from the actual scratch descriptor, not added as a correctness premise.',
            'Accepted f/g/F/G/h at ACTUAL encoding inputs and every make teardown; acceptance distinct from capacity failure.'],
        'outside_scope':['B1.08–B1.11 codec bodies/emitted-to-fiber/final replay, B4/B5 laws/availability/PRG/security, OS/Windows/compiler/machine refinement, CT and independent review.'],
        'tools':[pin(p) for p in tools],'source_commits':subprocess.check_output(['git','log','--reverse','--format=%H %s',
            '915178a1..'+head,'--',str(job.ROOT.relative_to(job.REPO))],cwd=job.REPO,text=True).splitlines(),
        'origin_main_observed':subprocess.check_output(['git','rev-parse','origin/main'],cwd=job.REPO,text=True).strip(),
        'active_jobs_at_close':[],'push_by_this_worker':False,'review_or_stages_import':False,
        'limits':'Unchanged Lean j1/-M6144,AS12GiB/RSS8GiB,wall1800s,maxHeartbeats2000000,print200000;0/0 proof streams,Sage preparser. Own expression-parser fuel lowered64→24; complete fixed-source syntax still checked.'}
    assert not job.active()
    with path(BASE+'.json').open('x') as stream: json.dump(result,stream,indent=2);stream.write('\n')
    print(json.dumps({'batch':pin(BASE+'.json'),'notes':pin(notes),'audit_entries':len(audit),
        'attempts':len(history),'attempt_counts':result['attempt_counts'],
        'literal_inputs':result['current_final_audit_inputs']},indent=2))


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
    assert batch['batch']=='BATCH_049' and batch['superseded']=={} and batch['active_jobs_at_close']==[]
    assert batch['window']=='CLOSED_AT_RECOVERABLE_MIDPOINT' and batch['b1_07_acceptance']=='NOT_MET'
    assert batch['entry_pins_receipt']['sha256']==ENTRY_SHA
    recovery_checked()
    for p,expected in entry_checked()['checked'].items(): check(p,expected)
    inputs=read(batch['audit']['source_inputs']['path'])
    for e in inputs['sources']: check(e['path'],e['sha256'])
    for e in inputs['reused']:
        check(e.get('current_source',e['source']),e['source_sha256']);check(e['artifact'],e['artifact_sha256'])
    assert not job.active()
    result={'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_015-049','checked':checked,
        'distinct_pinned_files':len(checked),'current_source_inputs':batch['current_final_audit_inputs'],
        'active_jobs':[],'superseded':{},'verifier_sha256':job.sha(Path(__file__))}
    print(json.dumps({**{k:v for k,v in result.items() if k!='checked'},'receipt':write_receipt(target,result)},indent=2))


if __name__=='__main__':
    if sys.argv[1:]==['seal']: seal()
    elif sys.argv[1:2]==['predecessor']:
        assert len(sys.argv)==3;predecessor(sys.argv[2])
    else:
        assert len(sys.argv)==5 and sys.argv[1]=='verify';verify(*sys.argv[2:])
