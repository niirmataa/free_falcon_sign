"""Seal only public V02 evidence in W/output; no Git or author writes."""
import hashlib
import json
import os
from pathlib import Path
import shutil

W = Path(__file__).resolve().parents[1]
R = W.parents[4]
IN = W/'inputs'
O = W/'output'
RUN = W/'run'
PIN_REPORT = 'ce3cad727ce44894cf633085f87b001cca742a7fe3a0a6dc2c750d6f5ac051e5'
PIN_OUTPUTS = 'af60f1b43843160ded4b977bbdc4ae42d5547a42937ec254f40be8b755f4e44e'


def sha(p):
    h=hashlib.sha256()
    with p.open('rb') as f:
        for data in iter(lambda:f.read(1024*1024),b''):
            h.update(data)
    return h.hexdigest()


def emit(name, data):
    p=O/name
    assert not p.exists(),p
    p.parent.mkdir(parents=True,exist_ok=True)
    p.write_text(json.dumps(data,indent=2,sort_keys=True,ensure_ascii=False)+'\n')


def copy(src, name):
    assert src.is_file() and not src.is_symlink(),src
    to=O/name
    assert not to.exists(),to
    to.parent.mkdir(parents=True,exist_ok=True)
    shutil.copyfile(src,to)
    assert sha(src)==sha(to),name


def tree(src, dst):
    for p in sorted(src.rglob('*')):
        if p.is_file():
            copy(p, dst/p.relative_to(src))


assert O.is_dir() and not (O/'REVIEW_OUTPUTS.sha256').exists()
final=json.loads((RUN/'own_final_001/receipt.json').read_text())
fresh=json.loads((RUN/'fresh_replay_audit.json').read_text())
history=json.loads((RUN/'history_audit.json').read_text())
integrity=json.loads((RUN/'input_verification_final.json').read_text())
assert final['result']=='PASS' and len(final['steps'])==10
assert fresh['status']=='PASS' and len(fresh['semantic_matches'])==16
assert integrity['status']=='PASS' and integrity['pins']['report']==PIN_REPORT
assert integrity['pins']['outputs']==PIN_OUTPUTS
assert sha(IN/'subject/REPORT.md') == PIN_REPORT
assert sha(IN/'subject/OUTPUTS.sha256') == PIN_OUTPUTS

for name in ('check_inputs.py','audit_subject_history.py','audit_fresh_replay.py','build_review_package.py'):
    copy(RUN/name,Path('sources')/name)
for name in ('check_words.sage','check_pinned.c','ReviewChecks.lean','make_mutations.py','run_final.py'):
    copy(RUN/'own_controls'/name,Path('sources')/name)
copy(RUN/'v02_fresh_001/receipt.json',Path('evidence/replay/receipt.json'))
tree(RUN/'v02_fresh_001/logs',Path('evidence/replay/logs'))
for name in ('CONTROL_RESULT.json','LE_CONTROL_RESULT.json','SCALAR_CONTROL_RESULT.json',
             'CONTROL_RECEIPTS.json','LE_CONTROL_RECEIPTS.json','SCALAR_CONTROL_RECEIPTS.json',
             'word_oracle.json','le_oracle.json','scalar_oracle.json','TRANSPORT_MATCH.json',
             'SOURCE_TRANSPORT.json','SCALAR_TRANSPORT.json'):
    copy(RUN/'v02_fresh_001/build'/name,Path('evidence/replay/semantic')/name)
for m in fresh['semantic_matches']:
    if m['path'].startswith('build/') and m['path'] not in ('build/'+x for x in (
            'CONTROL_RESULT.json','LE_CONTROL_RESULT.json','SCALAR_CONTROL_RESULT.json',
            'word_oracle.json','le_oracle.json','scalar_oracle.json','TRANSPORT_MATCH.json')):
        p=RUN/'v02_fresh_001'/m['path']
        copy(p,Path('evidence/replay/semantic')/Path(m['path']).name)
copy(RUN/'v02_fresh_001/build/toolchain/PORTABLE_GATE.json',Path('evidence/replay/PORTABLE_GATE.json'))
for name in ('v02_fresh_001.controller.stdout','v02_fresh_001.controller.stderr',
             'fresh_replay_audit_002.stdout','fresh_replay_audit_002.stderr',
             'history_audit.stdout','history_audit.stderr',
             'input_verification_005.stdout','input_verification_005.stderr',
             'input_verification_final.stdout','input_verification_final.stderr'):
    copy(RUN/name,Path('evidence')/name)
for name in ('input_verification.json','input_verification_after.json','input_verification_final.json',
             'history_audit.json','fresh_replay_audit.json'):
    copy(RUN/name,Path('evidence')/name)
copy(RUN/'own_final_001/receipt.json',Path('evidence/own_final/receipt.json'))
tree(RUN/'own_final_001/logs',Path('evidence/own_final/logs'))
for name in ('review_vectors.tsv','sage_result.json','sign.tsv','shift.tsv','rounding.tsv','invalid_shift.tsv'):
    copy(RUN/'own_final_001/build'/name,Path('evidence/own_final')/name)
for name in ('own_final_001.controller.stdout','own_final_001.controller.stderr'):
    copy(RUN/name,Path('evidence/own_final')/name)

# Preserve all own failed stdout/stderr and exact Sage/Lean source snapshots.
for name in ('own_sage_001','own_sage_002','own_sage_003','own_sage_004','own_sage_005',
             'own_lean_001','own_lean_002','own_lean_003'):
    d=RUN/name
    source=d/'source'
    tree(source,Path('evidence/failed_attempts')/name/'source')
    for p in sorted(d.iterdir()):
        if p.is_file():
            copy(p,Path('evidence/failed_attempts')/name/p.name)
    if (d/'build/review_vectors.tsv').is_file():
        copy(d/'build/review_vectors.tsv',Path('evidence/failed_attempts')/name/'review_vectors.tsv')
for name in ('own_c_001','own_c_asan_001'):
    d=RUN/name
    tree(d/'source',Path('evidence/failed_attempts')/name/'source')
    for p in sorted(d.iterdir()):
        if p.is_file():copy(p,Path('evidence/failed_attempts')/name/p.name)
for name in ('input_verification.stderr','input_verification_002.stderr',
             'input_verification_003.stderr','input_verification_004.stdout',
             'input_verification_004.stderr','fresh_replay_audit.stderr'):
    copy(RUN/name,Path('evidence/failed_attempts/organizers')/name)
tree(RUN/'own_mutations_001',Path('evidence/failed_attempts/own_mutations_001'))

# Absolute original paths bind the 30,626 byte-identical public input files.
input_lines=[]
for line in (IN/'MANIFEST.sha256').read_text().splitlines():
    h,name=line.split('  ',1)
    p=IN/name
    assert not p.is_symlink() and sha(p)==h
    input_lines.append(f'{h}  {p}\n')
for p in (IN/'MANIFEST.sha256',IN/'ORIGINS.json',IN/'BOUND_INPUTS.json',
          R/'proofs/ft1536/batches/B20_001/reviews/V02/REVIEW_TASK.md',
          R/'proofs/ft1536/batches/B20_001/tasks/P02/TASK.md',
          R/'proofs/ft1536/batches/B20_001/PACKAGE.sha256',
          R/'proofs/ft1536/documents/FT1536_ODBIOR_B20_V02_P02_V2_2026-09-29.md'):
    input_lines.append(f'{sha(p)}  {p}\n')
assert len(input_lines)==30633
(O/'INPUTS.sha256').write_text(''.join(input_lines))

emit('INTEGRITY.json',{'status':'PASS','before_after':integrity,'history_audit':history,
                       'input_count':len(input_lines),'source_report_sha256':PIN_REPORT,
                       'source_outputs_sha256':PIN_OUTPUTS,'source_head':integrity['head'],
                       'old_final_head':'UNRECORDED'})
emit('REPLAY_CHECKS.json',{'status':'FRESH_REPLAY_PASS','audit':fresh,
                           'fresh_receipt_path':'evidence/replay/receipt.json',
                           'full_replays_this_review':1,
                           'historical_asan_new_in_fresh':False})
emit('NUMERIC_CHECKS.json',{'status':'PASS_DIAGNOSTIC_ONLY',
                            'oracle':json.loads((RUN/'own_final_001/build/sage_result.json').read_text()),
                            'ubsan_rows':1437,'asan_ubsan_rows':1437,
                            'source_to_result_sha256':final['source_before']['check_words.sage'],
                            'vector_sha256':final['products']['review_vectors.tsv'],
                            'negative_exit_codes':{s['name']:s['exit_code'] for s in final['steps'] if s['name'].startswith('negative_')},
                            'formal_consumer':'none: diagnostic Sage; Lean proves restricted word execution independently'})
axioms=json.loads((IN/'subject/AXIOMS.json').read_text())
lean=(RUN/'own_final_001/logs/005_lean.stdout').read_text()
assert 'sorryAx' not in lean and lean.count('depends on axioms:')==6
assert 'V02.no_add_dispatch' in lean
emit('AXIOMS.json',{'status':'PASS_SCOPED','producer_theorems_scanned':axioms['theorems_scanned'],
                    'producer_primary_exports':13,'producer_axiom_sets':axioms['distinct_axiom_sets'],
                    'producer_target_axioms':axioms['target_axioms'],
                    'reviewer_axioms_printed':6,'reviewer_lean_log_sha256':sha(RUN/'own_final_001/logs/005_lean.stdout'),
                    'reviewer_no_sorryAx':True,'reviewer_lean_exit':0,
                    'historical_terms_truncated':51,'supplemental_terms_full':20,
                    'scope':'replayed export scan plus independent printed terms and no-add countertest'})
emit('EXECUTION_RECEIPTS.json',{'status':'PASS','full_replay_receipt':'evidence/replay/receipt.json',
                                'own_final_receipt':'evidence/own_final/receipt.json',
                                'own_final_steps':len(final['steps']),
                                'source_before':final['source_before'],
                                'source_after':final['source_after'],
                                'normal_memory_limit_bytes':8*1024**3,
                                'asan_shadow_exception':True,
                                'all_jobs_complete':True,
                                'original_author_W_unchanged':True})
sage_runs=[]
for n in range(1,6):
    d=RUN/f'own_sage_{n:03d}'
    sage_runs.append({'id':f'own_sage_{n:03d}',
                      'source_sha256':sha(d/'source/check_words.sage'),
                      'exit_code':int((d/'exit.code').read_text().strip()),
                      'stdout_sha256':sha(d/'log.stdout'),
                      'stderr_sha256':sha(d/'log.stderr'),
                      'preserved':'evidence/failed_attempts/'+f'own_sage_{n:03d}'})
sage_runs.append({'id':'own_final_001_sage','source_sha256':final['source_before']['check_words.sage'],
                  'exit_code':final['steps'][0]['exit_code'],'preparser':True,
                  'raw_log':'evidence/own_final/logs/000_sage.stdout',
                  'receipt':'evidence/own_final/receipt.json'})
emit('SAGE_RUNS.json',{'status':'FINAL_EXIT_0','runs':sage_runs,'author_sage_runs_not_substituted':True,
                       'domains':['ZZ','QQ'],'formal_premise':False})

scope=('LE64 load/store in abstract CExec with legal LP64 memory; kernel-backed '
       'BitVec execution of neg/double/half (all words), pack (packDomain), '
       'rint (exponent<=1072), floor (same, except raw -0); three shift-domain '
       'instances. Conditional sub theorem is vacuous with present shiftCalls '
       '(reviewer proves no AddCallObligation instance). Full add/mul/div/sqrt '
       'real-error, real-rint, caller domains, all finite inputs and C-to-machine '
       'remain OPEN. P02 remains PARTIAL_PROOF; 6 overwritten historical child '
       'streams and unrecorded old final HEAD remain explicit.')
emit('REVIEW_RESULT.json',{
    'review_id':'B20_001_V02_WORD_FPEMU_REFINEMENT',
    'source_task':'B20_001_P02_WORD_FPEMU_REFINEMENT',
    'source_report_sha256':PIN_REPORT,'source_outputs_sha256':PIN_OUTPUTS,
    'source_head':integrity['head'],'old_source_final_head':'UNRECORDED',
    'reviewer_model':'openai/gpt-6-sol','reviewer_session':'ses_f12645f4effei2l7zDf6rzsuJN',
    'reviewer_context':'fresh V02 owner-started window; no subagent or relay',
    'author_proof_model':'openai/gpt-6-astra-fast',
    'author_supplement_model':'openai/gpt-6-sol',
    'same_model_as_packager':True,'separate_session_and_context_from_packager':True,
    'verdict':'PASS_SCOPED_REVIEW','verdict_scope':scope,
    'source_status':'PARTIAL_PROOF','owner_accepted':False,'source_changed':False,
    'proved_exports_consumable':['B20.Word.load_store_le_refines','B20.Word.load_le_refines',
        'B20.Fpr.neg_execution','B20.Fpr.double_execution','B20.Fpr.half_execution',
        'B20.Fpr.pack_execution','B20.Fpr.rint_execution','B20.Fpr.floor_execution',
        'B20.Fpr.rint_ursh_domain','B20.Fpr.floor_irsh_domain',
        'B20.Fpr.rint_ulsh_domain (with he2)'],
    'conditional_export_not_instantiated':'B20.Fpr.sub_refines_via_add_obligation',
    'missing_types_open':['fpr_add/mul/div/sqrt real-error and source refinement',
        'AddCallObligation instance under a correct dispatcher','real nearest-even rint',
        'caller→Domain for future consumers','raw -0 floor disposition',
        'full C frontend and C→machine'],
    'full_fresh_replays':1,'semantic_matches':16,'own_sage_c_cases':1437,
    'jobs_complete':True,'push_authorized':False})

(O/'HANDOFF.md').write_text('''# V02 final handoff

TASK_ID=B20_001_V02_WORD_FPEMU_REFINEMENT;status=COMPLETE_FOR_COORDINATOR_REVIEW.
VERDICT=PASS_SCOPED_REVIEW for P02 PARTIAL_PROOF ONLY; `REVIEW.md` and
`REVIEW_RESULT.json` are the exact scoped statement. Model=openai/gpt-6-sol,
session=ses_f12645f4effei2l7zDf6rzsuJN, fresh V02 context. Same model as
supplement packager in another session (reported, not concealed); proof author
Astra Fast. Owner acceptance=false. New package source HEAD=
41216bb8d61004bb941a8d1b276f43346df11ce8; old final HEAD UNRECORDED.
REPORT ce3cad727ce44894cf633085f87b001cca742a7fe3a0a6dc2c750d6f5ac051e5;
OUTPUTS af60f1b43843160ded4b977bbdc4ae42d5547a42937ec254f40be8b755f4e44e.

All reviewer jobs completed: own fresh 43/43, 16 semantic matches, 45 child
commands; own Sage/C/Lean receipt-complete 10/10 expected exits, 1437 C
cases per UBSan and ASan. Six overwritten old child paths and missing old
final HEAD are not repaired. Conditional sub has an impossible premise under
the frozen dispatcher; real arithmetic/rint/caller domain remain open.
All writes in V02 W, no Git/push or frozen author changes. Full external
REVIEW.md and REVIEW_OUTPUTS.sha256 hashes are appended to W/HANDOFF.md
after seal; they cannot be embedded in this self-hashed bundle.
''')

members=[]
for p in sorted(O.rglob('*')):
    if p.is_file():
        rel=p.relative_to(O).as_posix()
        assert rel!='REVIEW_OUTPUTS.sha256' and not p.is_symlink()
        members.append(f'{sha(p)}  {rel}\n')
assert len(members)>200
(O/'REVIEW_OUTPUTS.sha256').write_text(''.join(members))
print(json.dumps({'output_members':len(members),'review_sha256':sha(O/'REVIEW.md'),
                  'review_outputs_sha256':sha(O/'REVIEW_OUTPUTS.sha256'),
                  'input_members':len(input_lines),'full_replay':43,'own_final':10},sort_keys=True))
