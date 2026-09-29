#!/usr/bin/env python3
"""Generate truthful v2 handoff metadata from verified pinned history + actual fresh replay."""
from pathlib import Path
import datetime,hashlib,json,shutil

W=Path(__file__).resolve().parents[1];O=W/'output';REPO=W.parents[3];P=O/'predecessor'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
stamp=lambda:datetime.datetime.now(datetime.timezone.utc).isoformat()
def save(name,obj):(O/name).write_text(json.dumps(obj,indent=2,sort_keys=True,ensure_ascii=False)+'\n')
def head():
    g=REPO/'.git';ref=(g/'HEAD').read_text().strip()
    assert ref=='ref: refs/heads/main',ref
    s=(g/'refs/heads/main').read_text().strip()
    assert len(s)==40 and all(c in '0123456789abcdef' for c in s)
    return s

assert sha(REPO/'proofs/ft1536/documents/FT1536_ZADANIE_P02_FREEZE_CLOSURE_2026-09-29.md')=='ce02389fffec9edf11c5f2430d9e8b7081f612d63ec3f38f761ac97773db259e'
assert sha(O/'inputs/task/TASK.md')=='9954a8b1b2a73a4f3e475ab45bb7bfe8b9a646b109a8989659a61aa933e5ef1f'
assert sha(O/'context/B20/reviews/V02/REVIEW_TASK.md')=='cfd4d2eb1e4806a6772b6013ad34a6d9d086b906a4bf9cd96f81dc1e0fa4a382'
assert sha(O/'inputs/MATERIALIZED.sha256')=='d70316d8450015aba6980a8c521f9979046b1983e6d6dcef5400f864abeef03b'
assert (W/'run/prepare_replay.exit').read_text().strip()=='0'
assert (W/'run/check_replay.exit').read_text().strip()=='0'
rep=json.loads((O/'REPLAY_RESULT.json').read_text())
hist=json.loads((O/'HISTORY_BINDING.json').read_text())
assert rep['status']=='FRESH_REPLAY_PASS' and rep['steps']==43 and len(rep['matched_semantics'])==16
assert hist['total_steps']==144 and hist['raw_step_logs']==288 and len(hist['overwritten_child_logs_byte_equivalents'])==6
snapshot={'branch':'main','head':head(),'utc':stamp(),'read_method':'direct read-only .git/HEAD and refs/heads/main; no git commands',
          'source_base':'ef62824a10a69962dc8347410ee3f424bfa2b12e',
          'packaging_base':'dda4a2a3ec4854e438914a16110cd6ed4cd2f927',
          'old_freeze_final_head':'UNRECORDED (not inferred from source_base, start or snapshot)',
          'interpretation':'current main HEAD at successor package preparation, not old 2026-09-25 freeze HEAD'}
save('HEAD_CONTEXT.json',snapshot)
for n in ['ASSUMPTIONS.json','AXIOMS.json','CLAIM.md','GOAL_SPEC.md','GOAL_SPEC.json',
          'FORMAL_EXPORTS.json','NEXT_INTERFACE.md','FAILED_ROUTES.md','formal_printed_types.txt']:
    assert not (O/n).exists()
    shutil.copyfile(P/n,O/n)
source_text=(P/'SOURCE_MODEL_BINDING.md').read_text()
(O/'SOURCE_MODEL_BINDING.md').write_text(source_text+'\n## Successor v2 closure\nSource17 i stary output byte-identical; nowy runner dotyczy wyłącznie organizacji, cache pin verification i ścieżek. '+
 'formal/ 32/32 odziedziczonych modułów plus dwa odpowiadające receiptowi replay_001 audyty. '+
 'Własne Lean rebuilt w run; real arithmetic/dispatcher contracts nadal OPEN.\n')
result=json.loads((P/'RESULT.json').read_text())
result.update({'schema':'B20_P02_RESULT_V2','task_id':'B20_001_P02_WORD_FPEMU_REFINEMENT',
               'packaging_task_id':'FT1536_P02_FREEZE_CLOSURE_RUN_001','revision':'v2',
               'predecessor_report_sha256':sha(P/'REPORT.md'),'predecessor_outputs_sha256':sha(P/'OUTPUTS.sha256'),
               'source_base':'ef62824a10a69962dc8347410ee3f424bfa2b12e',
               'new_package_head':snapshot['head'],'new_package_head_read_utc':snapshot['utc'],
               'old_final_head':'UNRECORDED','complete_for_review':True,'status':'PARTIAL_PROOF',
               'independent_review_performed':False,'owner_accepted':False,'source_changed':False,
               'fresh_replay':{'job':'replay_evidence/fresh_003','steps':43,'all_exit_zero':True,'sources_unchanged':True,'semantic_matches':16,
                               'build_plan_modules':34,'supplemental_full_print_audit':1},
               'historical_child_overwrites':6,'historical_original_overwritten_log_path_provenance_restored':False})
save('RESULT.json',result)
closure={'schema':'P02_FREEZE_CLOSURE_V2','packaging_task_id':'FT1536_P02_FREEZE_CLOSURE_RUN_001',
         'parent_task_id':result['task_id'],'revision':'v2',
         'predecessor':{'report_sha256':sha(P/'REPORT.md'),'outputs_sha256':sha(P/'OUTPUTS.sha256'),'output_files':68},
         'F1':{'state':'CLOSED','original_runner':'replay/original_job.py','portable_runner':'replay/job.py',
               'diff':'replay/RUNNER_DELTA.diff','toolchain_diff':'replay/TOOLCHAIN_DELTA.diff',
               'preflight':'INPUTS.sha256 and external predecessor OUTPUTS and optional successor OUTPUTS; no PRIOR_W source reads',
               'semantic_plan_correction':'For four generator products SEMANTIC_FILES producer_step=3 denotes pipeline completion; REPLAY_RESULT lists exact earlier producing step 1/2 and argv. No semantic hash changed.'},
         'F2':{'state':'CLOSED_FOR_KERNEL_BUILD_AND_SUPPLEMENTAL_FULL_PRINT; historical AuditTerms print truncated',
               'audit_modules':['formal/AuditExports.lean','formal/AuditTerms.lean'],
               'sha256':hist['audit_module_pins'],'history':'HISTORY_BINDING.json runs snapshots + replay_evidence/fresh_003/logs/040.stdout,041.stdout',
               'printed_types_axioms':'predecessor/formal_printed_types.txt and predecessor/AXIOMS.json (489-name historical scan)',
               'full_printing_limitation':'historical AuditTerms #print output includes 51 omitted ⋯; retained without rewriting history',
               'full_terms':'formal/AuditTermsFull.lean + replay_evidence/fresh_003/logs/042.stdout, zero omissions, fresh kernel dependencies'},
         'F3':{'state':'CLOSED_FOR_BYTE_CLOSURE_WITH_PROVENANCE_LIMIT',
               'nine_history_receipts':'HISTORY_BINDING.json','runs':9,'steps':144,'raw_step_logs':288,
               'child_command_receipts':len(hist['child_commands']),
               'overwritten_child_log_paths':6,'byte_equivalents':'OVERWRITTEN_LOGS.json',
               'original_replay_001_child_log_path_provenance':'NOT_RECOVERABLE; overwritten bytes retained and equivalent bytes from other pinned runs separately sealed',
               'earlier_attempts':'FAILED_HISTORY_INDEX.json, evidence/earlier_routes/; binaries/caches/unrelated copied upstream snapshots omitted',
               'new_child_logs':'replay_evidence/fresh_003/logs/child/{word,le,scalar}/ snapshot before basename reuse'},
         'F4':{'state':'NEW_HEAD_BOUND_OLD_UNRECORDED','new_head':snapshot['head'],'new_head_utc':snapshot['utc'],
               'old_final_head':'UNRECORDED','source_base':snapshot['source_base'],'package_base':snapshot['packaging_base'],
               'record':'HEAD_CONTEXT.json'},
         'replay':'REPLAY_RESULT.json', 'owner_accepted':False, 'new_mathematical_claim':False}
save('FREEZE_CLOSURE.json',closure)
(O/'FREEZE_CLOSURE.md').write_text('''# P02 — rozliczenie F1–F4 (successor v2)

F1 CLOSED: oryginalny runner byte-exact `replay/original_job.py`; przenośny `replay/job.py`, pełny `RUNNER_DELTA.diff`, nowy bez-Git gate i `TOOLCHAIN_DELTA.diff`. Bez żywego PRIOR_W/src/run. Preflight INPUTS i dwa external piny.
Predeclared SEMANTIC_FILES wskazał koniec pipeline (krok3) przy czterech plikach generowanych wcześniej; `REPLAY_RESULT.json` koryguje pole realnego producenta na krok1/2 z argv/exit, zachowując wcześniej przypięte hash/baseline.

F2 CLOSED dla 34 kernelowych buildów: 32 sealed proof sources i dwa Audit moduły bajtowo zgodne z `replay_001` source_before. ProbeFreezeScan źródło i log związane z `freeze_scan` (nie dodawane do BUILD_PLAN). Historyczne pełne **typy** i aksjomaty 489 nazw przypięte; historyczny wydruk AuditTerms ma 51 znaków `⋯` i pozostaje niekompletnym wydrukiem. Osobny, źródłowo przypięty `formal/AuditTermsFull.lean` jest krokiem43 świeżego replayu, z pełnym wydrukiem 20 terms (0 `⋯`) bez zmiany dowodów.

F3 BYTE CLOSURE WITH PROVENANCE LIMIT: 9 receiptów, 144 kroków i 288 krokowych stdout/stderr, 76 child commands, źródła oraz publiczne tekstowe failed attempts przypięte. Sześć oryginalnych child log pathów w replay_001 zostało nadpisanych przez późniejszy kontroler. `OVERWRITTEN_LOGS.json` zawiera hash-równe bajty z innych przypiętych przebiegów; pierwotnej ścieżki/proweniencji nie można odzyskać. Nowy runner snapshotuje własne child raw logs osobno dla word/LE/scalar przed nadpisaniem nazw.

F4 NEW_HEAD_BOUND: rzeczywisty `main` z read-only `.git/HEAD` i ref w `HEAD_CONTEXT.json`; historyczny końcowy HEAD starego freezu nieudokumentowany, nie myli się z SOURCE_BASE. Zakres PARTIAL_PROOF zachowany; V02 decyduje o niezależnym odbiorze.
''')
prior_runs=json.loads((P/'EXECUTION_RECEIPTS.json').read_text())
save('EXECUTION_RECEIPTS.json',{'schema':'B20_P02_EXECUTION_RECEIPTS_V2','predecessor_receipts_sha256':sha(P/'EXECUTION_RECEIPTS.json'),
                                'history':prior_runs,'history_binding':'HISTORY_BINDING.json',
                                'fresh_run':{'path':'replay_evidence/fresh_003/receipt.json','exit_code':0,'steps':43},
                                'preceding_trials':[{'path':'replay_evidence/fresh_001/receipt.json','exit_code':0,'steps':42},
                                                    {'path':'replay_evidence/fresh_002/receipt.json','exit_code':0,'steps':43}],
                                'historical_overwritten_child_logs':'OVERWRITTEN_LOGS.json','owner_accepted':False})
old_sage=json.loads((P/'SAGE_RUNS.json').read_text())
save('SAGE_RUNS.json',{'schema':'B20_P02_SAGE_RUNS_V2','original':old_sage,
   'fresh':{'word':'replay_evidence/fresh_003/logs/child/word/CONTROL_RECEIPTS.json',
            'le':'replay_evidence/fresh_003/logs/child/le/LE_CONTROL_RECEIPTS.json',
            'scalar':'replay_evidence/fresh_003/logs/child/scalar/SCALAR_CONTROL_RECEIPTS.json',
            'invocations':'sage checks/word_helpers.sage, sage checks/little_endian.sage, sage checks/scalar.sage',
            'preparser':True,'diagnostic_not_kernel_premise':True}})
(O/'COMMANDS.log').write_text((P/'COMMANDS.log').read_text()+
 '\n# Successor v2 commands and exact argv/log/hash for every step: replay_evidence/fresh_003/receipt.json\n'+
 'python3 -B output/replay/job.py fresh_003 --inputs-sha256 '+sha(O/'INPUTS.sha256')+'\n'+
 'python3 -B run/check_replay.py fresh_003 # matches actual bytes and raw receipts\n'+
 'No Git/push/model/subagent execution by packaging agent.\n')
(O/'REPORT.md').write_text(f'''# B20/P02 — successor v2: uzupełniony freeze przed V02

**COMPLETE_FOR_REVIEW / PARTIAL_PROOF (zakres starego P02).** packaging_task_id=FT1536_P02_FREEZE_CLOSURE_RUN_001. Projekt Niirmata; Falcon Project / Thomas Pornin, licencje bez zmiany. Autor wcześniejszych twierdzeń GPT-6 Astra Fast / `ses_f33f9f0afffeLad43JuCwKBDk2`; autor suplementu organizacyjnego GPT-6 Sol / `ses_f13139bc5ffeFI41laN8mgF1PA` (kontekst kontynuowany po T03-B, nie nowy niezależny V02).

## Piny i replay

Oryginalny REPORT `{sha(P/'REPORT.md')}`, OUTPUTS `{sha(P/'OUTPUTS.sha256')}`; zachowano 68/68 identycznych outputów. Bootstrap `088b407a3be937a49b1a23d4305e83641123d9770040d78b4a43b7cabe14c65f`, nowy static INPUTS `{sha(O/'INPUTS.sha256')}`. Source17 `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985`, SOURCE_BASE `ef62824a10a69962dc8347410ee3f424bfa2b12e`. Bieżący `main` HEAD successor `{snapshot['head']}` odczytany {snapshot['utc']} bez uruchamiania Git. Stary *final* HEAD jest nieudokumentowany.
P02 TASK `9954a8b1b2a73a4f3e475ab45bb7bfe8b9a646b109a8989659a61aa933e5ef1f`, V02 TASK `cfd4d2eb1e4806a6772b6013ad34a6d9d086b906a4bf9cd96f81dc1e0fa4a382`, oba w closure i bez zmiany historycznych danych.

Portable full fresh `run/fresh_003`: **43/43 exit0, 34/34 Lean z BUILD_PLAN (w tym 2 audyty) + pełny audit terms, 16/16 bajtowych semantic matches**, source before/after unchanged; `REPLAY_RESULT.json`, raw logs/receipt i child streams bez kolizji, `replay_evidence/fresh_003/`. Wcześniejsze `fresh_001` 42/42 i 15/15 oraz `fresh_002` 43/43 i 16/16 zachowane osobno; ostatnia korekta runnera preflight naprawiła rozróżnienie top-level OUTPUTS od zagnieżdżonego `predecessor/OUTPUTS.sha256`. Gate sprawdza 9 przypiętych bibliotek P01 i cache; używa direct RO HEAD, historycznych manifestów source/cache i pełnych hashy, bez sieci lub Git. Oracles wykonane rzeczywistym `sage *.sage` z preparserem. Normal word 12288+4 mutants, LE 3072+3, scalar 19721 in/21352 obs+5 mutants; ASan word/LE/scalar są osobnymi *historycznymi* zakończonymi receiptami, bez roszczenia o nowe sanitarne przebiegi.

## F1–F4 i uczciwa granica

F1: sealed original runner + portable runner/diff; przed DEST waliduje piny i exact-set. F2: wszystkie 34 źródła BUILD_PLAN mają producenta i kernel build; dwie brakujące wersje audit odpowiadają dokładnie replay_001. Scan 489 nazw typów/aksjomatów jest historyczny i przypięty; `AuditTerms` historyczny #print ma **51 truncation glyphs `⋯`**, lecz nowy dodatkowy pełny wydruk 20 terms (`logs/042.stdout`) ma zero skrótów i czysty log. F3: w pakiecie 9 historycznych receiptów/144 kroki/288 surowych logów kroków, child command logs i wcześniejsze tekstowe failed routes. Sześć logów child replay_001 ma nadpisaną oryginalną ścieżkę; hash-identyczne bajty z innych przypiętych runów zapisano osobno; pierwotna proweniencja ścieżki nie odzyskana. Nowy runner przechowuje child logs osobno dla każdej kontroli. F4: jednoznaczny *nowy* HEAD powyżej, bez fikcji starego. Szczegóły `FREEZE_CLOSURE.md/.json`, `OVERWRITTEN_LOGS.json`, `HISTORY_BINDING.json`.

## Rzeczywisty zakres matematyczny

LE64 source binding i shift helpers w przyjętym zakresie P01, literal-BitVec neg/double/half/pack/rint/floor z domenami, conditional sub **tylko z przesłanką AddCallObligation**. Frozen `shiftCalls` ma wyłącznie 3 shift callees: fpr_add nie jest wykonywane przez nie jako napisany dispatcher. Raw −0 floor daje −1; pełne real-rint, arytmetyka add/mul/div/sqrt z real-error/caller domains, C→machine/full C frontend pozostają OPEN. Brak nowego twierdzenia source-level Sign/security, source_changed=false, owner_accepted=false; niezależny V02 dopiero nastąpi. Kolejny krok: koordynator sprawdza piny i przygotowuje ręczny start V02, bez automatycznego promowania P02 do pełnego dowodu.

Wszystkie moje joby zakończone. Bez Git/push i zmian frozen starego W.
''')
(O/'HANDOFF.md').write_text(f'''# P02 v2 — finalny handoff do koordynatora i V02

- parent task_id=B20_001_P02_WORD_FPEMU_REFINEMENT; packaging_task_id=FT1536_P02_FREEZE_CLOSURE_RUN_001; pair=V02; status COMPLETE_FOR_REVIEW/PARTIAL_PROOF.
- Model GPT-6 Sol (`openai/gpt-6-sol`), sesja `ses_f13139bc5ffeFI41laN8mgF1PA`, kontekst kontynuowany po T03-B, nie niezależny V02.
- HEAD *nowego pakietu* `{snapshot['head']}` (main, UTC `{snapshot['utc']}`), stary final HEAD UNRECORDED; source_base `ef62824a10a69962dc8347410ee3f424bfa2b12e`.
- Poprzednik REPORT `{sha(P/'REPORT.md')}`; OUTPUTS `{sha(P/'OUTPUTS.sha256')}`. INPUTS nowy `{sha(O/'INPUTS.sha256')}`.
- F1–F4 `FREEZE_CLOSURE.md/.json`; 6 historycznie nadpisanych child log pathów: `OVERWRITTEN_LOGS.json`. Nie ukrywać ograniczenia.
- Final fresh replay 43/43 exit0, 16/16 matches, 34 plan modules + pełny dodatkowy audit; oddzielne historyczne ASan receipts związane; wszystkie własne joby zakończone. owner_accepted=false, independent_review=false, full arithmetic contracts OPEN.
- Wynik, SOURCE_MODEL_BINDING, REPLAY, full raw logs i sam manifest OUTPUTS pod tym output/; koordynator po odbiorze integralności przygotowuje V02.
''')
print('SUCCESSOR_METADATA_READY',snapshot['head'],sha(O/'REPORT.md'),flush=True)
