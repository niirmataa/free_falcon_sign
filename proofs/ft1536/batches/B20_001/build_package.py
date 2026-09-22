#!/usr/bin/env python3
"""Generate/verify task documents and empty workspaces; never run proof jobs."""
import argparse
import hashlib
import json
from pathlib import Path
import re

B = Path(__file__).resolve().parent
REPO = B.parents[3]
ROOT = REPO/'proofs/ft1536'
WORK = ROOT/'work/B20_001'
SOURCE_BASE = 'ef62824a10a69962dc8347410ee3f424bfa2b12e'
STAGES = {
 'M0':'FT1536_M0_CONTRACT_RUN_001','LV':'FT1536_L_V_BRIDGE_RUN_001',
 'POST':'FT1536_H3_SOURCE_POSTPROCESSING_AND_PRECAST_RUN_001',
 'SCALAR':'FT1536_H3_SCALAR_KERNEL_IID_RUN_001',
 'GAUSS':'FT1536_H3_SCALAR_GAUSSIAN_COMPARISON_RUN_001',
 'JOINT':'FT1536_H3_ORDERED_JOINT_KERNEL_RUN_001',
 'H6P':'FT1536_H6P_REFERENCE_BAD_EVENT_RUN_001',
 'T01':'FT1536_IID_RETRY_COMPOSITION_RUN_001',
 'T03':'FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001',
 'TARGETS':'FT1536_H3_INITIAL_TARGETS_RUN_001',
 'NORMALIZED':'FT1536_H3_STABLE_NORMALIZATION_RUN_001',
 'LEFT':'FT1536_H3_LEFT_ROOT_CORRELATED_TRANSFER_RUN_001'}
MATHLIB = '5ed2965256430c3649e86755f9576b54eca72435'

def sha(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def jb(x): return (json.dumps(x,ensure_ascii=False,indent=2)+'\n').encode()
def put(p,data):
    p=Path(p);data=data.encode() if isinstance(data,str) else data
    p.parent.mkdir(parents=True,exist_ok=True)
    if p.exists():
        assert p.read_bytes()==data, f'Refusing to overwrite {p}'
    else:p.write_bytes(data)
def bullets(items):return '\n'.join('- '+s for s in items)

def task_doc(s,review=False):
    ident=('V' if review else 'P')+s['id'][1:]
    task_id=f'B20_001_{ident}_{s["slug"]}'
    w=WORK/ident;branch='proof/b20/'+ident.lower()
    peer='P'+s['id'][1:] if review else 'V'+s['id'][1:]
    ppath=B/('reviews' if review else 'tasks')/ident
    exports=bullets(s['exports'])
    deps=', '.join(s['deps']) or 'brak wcześniejszych Pxx'
    fixed=', '.join(s['base'])
    text=f'''# {ident} — {s['title']}{' — niezależna weryfikacja' if review else ''}

Autor projektu Niirmata. Pakiet B20_001,2026-09-22. Rola: {'RECENZENT' if review else 'WYKONAWCA'}.
ROADMAP_ID={s['roadmap']}. TASK_ID={task_id}. Para={peer}.

## 1. Identyfikacja i foldery

```text
REPO={REPO}
SOURCE_BASE={SOURCE_BASE}
W={w}
IN={w/'inputs'}
RUN={w/'run'}
OUTPUT_DIR={w/'output'}
CHECKPOINTS={w/'checkpoints'}
CHECKOUT={w/'checkout'}
BRANCH={branch}
CHECKPOINT_PREFIX=B20_001_{ident}_CP
FINAL_STAGE=B20_001_{ident}_FINAL_001
INPUT_CONTRACT={ppath/'INPUT_CONTRACT.json'}
```

Przeczytaj REPO/AGENTS,START_HERE,STATE,OWNER_GUIDE.md,AGENT_GIT_PROTOCOL.md
i własny W/AGENTS. PACKAGE.sha256 przypina niniejszy dokument i kontrakt.
Jeden worker/W i jeden writer/checkout. Stare prompty w inputs są danymi.
Checkout tworzy się przy starcie,nie jest współdzielonym main. Jego rzeczywisty
BASE/HEAD zapisujesz w HANDOFF; pinned source base/piny nie zmieniają się z HEAD.

## 2. Wejścia i kolejność

Zależności dowodowe Pxx: **{deps}**. Stałe materiały: **{fixed}**,
z pełnymi REPORT/OUTPUTS pinami w BASE_INPUTS.json i INPUT_CONTRACT.json.
Przeczytaj najpierw konkretne CLAIM/certificates/interfaces,nie całe stare W.
Starsze mixed-proof statusy nie są pełnymi kernelowymi premises.
Konkretne source17 ma manifest56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985.

Przyszły wynik nie ma dziś wymyślonego hasha. Binding zewnętrznego REPORT,
OUTPUTS,review i HEAD jest obowiązkowym krokiem odblokowania. W IN zachowaj
BOUND_INPUTS.json,oryginalne manifesty i complete closure RO. INPUT_CONTRACT
ma pole bound_inputs=null do wypełnienia we własnym W,nie w frozen kontrakcie.
Dozwolone są tylko konkretne odebrane eksporty potrzebne do tej tezy. PARTIAL
upstream może dostarczyć proved subclaim; brak wymaganego eksportu blokuje pracę.

## 3. Cel i obowiązkowe formalne eksporty

{s['goal']}

{exports}

To kontrakty planowanych eksportów,nie gotowe twierdzenia. CP001 musi zawierać
GOAL_SPEC.md/.json oraz dokładne drukowane typy Lean i definicje domen. Typy mają
realizować powyższy cel bez osłabienia; każdą zmianę zakresu zgłoś prowadzącemu.
Wymagana jest pełna formalna instancja dla pinned modelu,nie samo generic lemma.

## 4. Obowiązki źródłowe i matematyczne

{bullets(s['obligations'])}

## 5. Kontrole i próby ujemne

{bullets(s['controls'])}

Kontrole są dodatkiem do proofu. Required-domain counterexample ma dowód
membership; synthetic/extended witness oznacz osobno. Zachowaj każdą
nieudaną trasę,luźny bound i brakujący typ.

## 6. Stos i wykonanie

Obowiązkowo Lean4.34.0 + Mathlib4@{MATHLIB} i SageMath10.9.
Toolchain closure określa TOOLCHAIN_PINS.json. P01 przygotowuje zweryfikowany
bootstrap; proof/build/replay są network-off. Biblioteka bez pinów/receiptu
nie staje się formalną przesłanką. Nowa matematyka: `sage lemma.sage`,preparser,
ZZ/QQ/rigorous intervals i formalny Lean consumer certyfikatów. Python tylko
organizuje wykonanie. Nie ma analitycznej ścieżki zastępczej do PROVED.

W-only sandbox; HOME/TMPDIR/TMP/TEMP/DOT_SAGE/XDG/cache/build pod W. Bez
systemowego tmp/tmpfs. Single-worker8GiB,Lean-j1/-M2048; limity wall per krok
muszą być jawne w COMMANDS (domyślnie1800s,uzasadniona zmiana zapisana przed runem).
ASan osobno jeśli wymagany. Nie koliduj z dudect; nie uruchamiaj innych modeli,
relay,KeyGen/pełnego Sign/nowych sekretów lub nieprzypiętej sieci/instalacji.

Każdy run: nowy DEST,readonly snapshot źródła,hash przed/po,real argv/cwd,
toolchain,start/stop/exit,raw stdout/stderr,output hashes. Fresh replay usuwa
wszystkie produkty przed producerem,również semantic-only/PDF/cache.

## 7. Lokalne commity i handoff

Sam zapisujesz milestones jako niirmataa na **{branch}**,we własnym CHECKOUT.
Instrukcja i zatwierdzony email: AGENT_GIT_PROTOCOL.md. W work/ są pliki robocze;
commit obejmuje immutable checkpoint przez archive.py do stages/catalog/objects.
CP001=kontrakt/typy/input binding,CP002=sprawdzone lemmas/negative routes,
CP003=pełna kompozycja/replay albo dokładny blocker. Dodatkowe CP mają nowe ID.
FINAL_001 dopiero po freeze. Nie nadpisuj starego checkpointu.

Allowlist: `proofs/ft1536/stages/B20_001_{ident}_CP*/`,
`proofs/ft1536/stages/B20_001_{ident}_FINAL_001/`,odpowiadające catalog JSON
oraz wyłącznie objects/<sha> wymienione przez te katalogi. Nie commituj
cudzego stage,globalnych indeksów,produkcji Extra/c,cache/bin/olean/pyc/sekretów.
Sprawdź dokładne staged bytes. Bez automatycznego push,amend/reset/rebase cudzego
stanu lub pomijania hooks. Main integruje jeden prowadzący po odbiorze.

Każdy checkpoint podaje source pins,HEAD,scope,status,proved exports i missing
types. W finalnym handoffie pełne SHA REPORT/OUTPUTS (lub REVIEW/REVIEW_OUTPUTS),
branch/HEAD,komendy i stan jobów. Zakończ własne joby; owner_accepted=false.

## 8. Kryterium i następny consumer

{s['limit']}

PROVED wymaga wszystkich eksportów wymaganych w deklarowanym zastosowaniu,
konkretnych premises,clean kernel proof i source bindingu. W innym razie
PARTIAL_PROOF/BLOCKED/counterexample z dokładnym powodem. Brak obliczenia nie
jest zerowym błędem,a brak źródłowego lematu nie jest założeniem do pominięcia.
Następny consumer i przypięte zależności są w INDEX.json; {'ten Vxx kończy odbiór '+peer if review else 'frozen handoff trafia najpierw do '+peer}.
'''
    if review:
        text+=f'''
## 9. Twoja niezależna weryfikacja {peer}

Odbierasz dokładnie {peer},nie poprzedni podobny run. Twoje podstawowe pytanie:
**{s['review_focus']}**

1. Weryfikuj zewnętrzne piny producenta i jego own-review/sources; sampler
   stdout PASS lub zgodne cert JSON nie zastępują sprawdzenia theorem terms.
2. Porównaj GOAL_SPEC/drukowany typ z sekcją3 i przejrzyj wszystkie zależne
   assumptions,definicje legal input oraz konkretne source instancje.
3. Zbuduj projekt od zera,bez author cache/olean/bin. Zweryfikuj źródła Mathlib,
   użyte theorem axioms i faktyczne importy; brak native_decide/Lean.ofReduceBool,
   sorry/admit/aksjomatu celu/wyciszania warnings.
4. Wykonaj własny fresh replay,zapewniając brak copied targets/no-op false matches.
   Wszystkie required i reklamowane semantic steps mają osobną ocenę.
5. Niezależnie sprawdź kluczowe liczby w `.sage` oraz ich formalne certificates;
   odtwórz powyższe negative controls i dodaj celowy kontrtest błędnej przesłanki.
6. Nie naprawiaj frozen autora dla PASS. Poprawkę/transport adapter zapisz poza nim
   z diffem. Nie zmieniaj oczekiwanego outputu po ujrzeniu wyniku.
7. Przed freeze potwierdź source→receipt→output hashes swoich checkerów oraz
   dokładne wersje failed prób. Sprawdź,że producer inputs pozostały niezmienione.

Artefakty Vxx: REVIEW.md,REVIEW_RESULT.json,CHECKLIST.md,GOAL_TYPE_AUDIT.md,
AXIOMS.json,SOURCE_BINDING_AUDIT.md,INTEGRITY.json,NUMERIC_CHECKS.json,
REPLAY_CHECKS.json,EXECUTION_RECEIPTS.json,SAGE_RUNS.json,FAILED_ROUTES.md,
own formal/checker sources,raw logs,INPUTS.sha256,REVIEW_OUTPUTS.sha256,HANDOFF.
Do checkpoint importu można użyć REVIEW.md jako report i wyniku z jawnym
result/status; protokół opisuje adapter manifestu bez zmiany sealed review.

Werdykt: PASS_SCOPED_REVIEW tylko po pełnym formalnym uzasadnieniu danego scope;
inaczej CHANGES_REQUIRED/INTEGRITY_FAIL/REPLAY_FAIL/EXECUTION_BLOCKED.
Wynik PARTIAL nie może odblokować brakującej przesłanki następnego zadania.
'''
    else:
        text+='''
## 9. Artefakty autora

REPORT.md,RESULT.json,CLAIM.md,GOAL_SPEC.md/.json,FORMAL_EXPORTS.json,
ASSUMPTIONS.json,SOURCE_MODEL_BINDING.md,INPUTS.sha256,TOOLCHAIN.txt,
COMMANDS.log,EXECUTION_RECEIPTS.json,SAGE_RUNS.json,CERTIFICATES/ i formal/,
AXIOMS.json,FAILED_ROUTES.md,NEXT_INTERFACE.md,REPLAY.md,SEMANTIC_FILES.json,
OUTPUT_SCOPE.md,OUTPUTS.sha256,HANDOFF.md. Output manifest nie obejmuje siebie.
W FORMAL_EXPORTS:pełny typ,nazwa,plik/source SHA,proof term/axioms receipt,
status i konkretni consumers. Części zamknięte i otwarte są oddzielone.
Po compile/replay nie zmieniaj kodu bez nowego runu i receiptu.
'''
    return text

def build():
    specs=json.loads((B/'specs.json').read_text());assert len(specs)==20
    aliases={}
    for alias,stage in STAGES.items():
        r=json.loads((ROOT/'catalog'/f'{stage}.json').read_text())
        assert sha(ROOT/'stages'/stage/r['report'])==r['report_sha256']
        assert sha(ROOT/'stages'/stage/'OUTPUTS.sha256')==r['manifest_sha256']
        aliases[alias]={'stage':stage,'path':str(ROOT/'stages'/stage),'report':r['report'],
                        'report_sha256':r['report_sha256'],'outputs_sha256':r['manifest_sha256'],
                        'historical_status':r['claimed_status'],'formal_reuse':'only reviewed exact exports; mixed prose is formalization debt'}
    put(B/'BASE_INPUTS.json',jb({'source_base_commit':SOURCE_BASE,'stages':aliases,
        'source17_manifest_sha256':'56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985',
        'source17_manifest_path':str(ROOT/'background/MIMO_INTEGER_RECOVERY_2026-09-22/CANDIDATE.sha256'),
        'external_pending':{'T02.1_REVIEWED_HANDOFF':{'status':'AT_REVIEW_PER_OWNER','report_sha256':None,'outputs_sha256':None,'review_sha256':None}}}))
    proto=(REPO/'docs/onboarding/AGENT_EXECUTION_AND_REVIEW_PROTOCOL.md').read_text()
    proto=proto.replace('(BATCH_20_REQUIREMENTS.md)','(../../../../docs/onboarding/BATCH_20_REQUIREMENTS.md)')
    put(B/'AGENT_GIT_PROTOCOL.md',proto)
    entries=[]
    for s in specs:
        for review in (False,True):
            ident=('V' if review else 'P')+s['id'][1:]
            folder=B/('reviews' if review else 'tasks')/ident
            filename='REVIEW_TASK.md' if review else 'TASK.md'
            put(folder/filename,task_doc(s,review))
            contract={'id':ident,'task_id':f'B20_001_{ident}_{s["slug"]}',
                      'role':'reviewer' if review else 'author','producer':s['id'] if review else None,
                      'fixed_base_inputs':{k:aliases[k] for k in s['base']},
                      'upstream_tasks':s['deps'],'external_required':s.get('external',[]),
                      'required_goal_exports':s['exports'],'bound_inputs':None,
                      'binding_rule':'copy verified frozen dependencies into W/inputs; write BOUND_INPUTS there; never edit this contract or invent pending hashes',
                      'for_review_required':['producer REPORT/OUTPUTS external pins','producer HEAD','formal export/axiom/source binding inventory'] if review else []}
            put(folder/'INPUT_CONTRACT.json',jb(contract))
            put(folder/'AGENTS.md',f'# {ident} / {contract["task_id"]}\n\nCzytaj {filename},INPUT_CONTRACT.json i ../../AGENT_GIT_PROTOCOL.md.\nRola={contract["role"]}; model/kontekst zapisuje właściciel/worker przy starcie.\nWszystkie nowe pliki pod {WORK/ident}; własna branch proof/b20/{ident.lower()}.\nProof: Lean4+Mathlib kernel; Sage przez sage lemma.sage; brak mixed-proof shortcut.\nLokalne milestone commity jako niirmataa,tylko własny allowlist; bez push.\n')
            state='BLOCKED_PRODUCER_FREEZE' if review else ('READY_BOOTSTRAP_OWNER_START' if not s['deps'] else 'BLOCKED_UPSTREAM_EXPORTS')
            entries.append({'id':ident,'task_id':contract['task_id'],'role':contract['role'],'roadmap':s['roadmap'],
                'title':s['title'],'document':str((folder/filename).relative_to(B)),
                'document_sha256':sha(folder/filename),'input_contract':str((folder/'INPUT_CONTRACT.json').relative_to(B)),
                'workspace':str(WORK/ident),'checkout':str(WORK/ident/'checkout'),'branch':'proof/b20/'+ident.lower(),
                'paired':('P' if review else 'V')+ident[1:],'dependencies':([s['id']] if review else s['deps']),
                'external_required':s.get('external',[]),'initial_execution_status':state})
    put(B/'INDEX.json',jb({'schema':'B20_INDEX_V1','package':'B20_001','documents_status':'PREPARED','authors':20,'reviewers':20,'source_base_commit':SOURCE_BASE,'entries':entries}))
    put(B/'STATUS.json',jb({'schema':'B20_LIVE_STATUS_V1','note':'Mutable coordinator registry; not included in PACKAGE.sha256. Update only after real handoff/binding.','tasks':{e['id']:{'status':e['initial_execution_status'],'model':None,'context':None,'head':None,'bound_inputs_sha256':None,'final_report_sha256':None,'final_outputs_sha256':None,'review_verdict':None} for e in entries}}))
    immutable=[p for p in B.rglob('*') if p.is_file() and p.name not in ('STATUS.json','PACKAGE.sha256') and '__pycache__' not in p.parts]
    raw=''.join(sha(p)+'  '+str(p.relative_to(B))+'\n' for p in sorted(immutable))
    put(B/'PACKAGE.sha256',raw)
    package_sha=sha(B/'PACKAGE.sha256')
    for e in entries:
        w=WORK/e['id']
        for name in ('inputs','run','output','checkpoints','home','cache','tmp'):(w/name).mkdir(parents=True,exist_ok=True)
        put(w/'AGENTS.md',f'''# {e['id']} — {e['task_id']}

ROLE={e['role']}; INITIAL_STATUS={e['initial_execution_status']}.
TASK={B/e['document']}
TASK_SHA256={e['document_sha256']}
PACKAGE_MANIFEST_SHA256={package_sha}
W={w}
CHECKOUT={e['checkout']}
BRANCH={e['branch']}

Czytaj REPO/AGENTS,START_HERE,STATE i powyższy TASK oraz OWNER_GUIDE i
AGENT_GIT_PROTOCOL. Jeden worker; model/kontekst ma być zapisany przy starcie.
Inputy muszą być bound/RO; zależne zadanie nie startuje z placeholder pinem.
Lean4+Mathlib kernel; autorytatywny rachunek Sage przez sage lemma.sage.
Własne milestone commity jako niirmataa we własnym checkout/branch; bez push.
Nie modyfikuj frozen źródeł/innych W/globalnego main lub istniejących checkpointów.
''')
    print(json.dumps({'status':'PREPARED','author_tasks':20,'review_tasks':20,'workspaces':40,'package_sha256':package_sha},indent=2))

def verify():
    specs=json.loads((B/'specs.json').read_text());index=json.loads((B/'INDEX.json').read_text())
    ids={s['id'] for s in specs};assert ids=={f'P{i:02d}' for i in range(1,21)}
    seen=set()
    for s in specs:
        assert set(s['deps'])<=seen,(s['id'],s['deps'])
        assert s['goal'] and len(s['exports'])>=3 and len(s['obligations'])>=4 and len(s['controls'])>=2
        seen.add(s['id'])
    rows={}
    for line in (B/'PACKAGE.sha256').read_text().splitlines():
        h,n=line.split('  ',1);assert re.fullmatch('[0-9a-f]{64}',h) and n not in rows
        assert not Path(n).is_absolute() and '..' not in Path(n).parts
        assert sha(B/n)==h,n;rows[n]=h
    actual={str(p.relative_to(B)) for p in B.rglob('*') if p.is_file() and p.name not in ('STATUS.json','PACKAGE.sha256') and '__pycache__' not in p.parts}
    assert actual==set(rows)
    assert len(index['entries'])==40 and len({e['id'] for e in index['entries']})==40
    for e in index['entries']:
        assert sha(B/e['document'])==e['document_sha256']
        assert (Path(e['workspace'])/'AGENTS.md').is_file()
        for n in ('inputs','run','output','checkpoints','home','cache','tmp'):assert (Path(e['workspace'])/n).is_dir()
        assert 'native_decide' in (B/'AGENT_GIT_PROTOCOL.md').read_text()
    print(json.dumps({'result':'PASS_B20_COUNTS_DAG_PINS_AND_FOLDERS','authors':20,'reviewers':20,'workspaces':40,'immutable_files':len(rows),'package_sha256':sha(B/'PACKAGE.sha256'),'proof_jobs_started':False},indent=2))

if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('action',choices=['build','verify']);args=p.parse_args()
    build() if args.action=='build' else verify()
