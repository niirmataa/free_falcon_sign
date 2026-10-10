#!/usr/bin/env python3
"""Reconcile live S05 documentation only after the scoped evidence is sealed."""
from pathlib import Path
import json,hashlib
S=Path(__file__).resolve().parent.parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
receipt=json.loads((S/'notes/LOCAL_LEAVES_017_RECEIPT.json').read_text())
checks=json.loads((S/'notes/LOCAL_LEAVES_017_CHECKS.json').read_text())
assert receipt['closed'].startswith('All actual PairLeaves and CubeLeaf instances.')
assert checks['finite_rows']==61441
def write(name,value):
 p=S/'notes'/name;assert not p.exists();p.write_text(json.dumps(value,indent=2)+'\n')
q=json.loads((S/'notes/KERNEL_QUEUE_016.json').read_text());q['date']='2026-10-11'
q['previous']={'path':'notes/KERNEL_QUEUE_016.json','sha256':sha(S/'notes/KERNEL_QUEUE_016.json')}
for z in q['selected_path']:
 if z['id']=='K-KEY-INSTANCE':
  z['remaining']+='; pinned18a3ffe3 has two kernel-refuted global premises (VirtualLegal and Dimensions). A newer repaired pin must be checked before use.'
 if z['id']=='K-LOCAL-TABLE-LEAVES-017':
  z['status']='KERNEL_ACTUAL_INSTANCES_FILLED';z['available']='Actual PairLeaves(actual tables) and CubeLeaf, every literal row checked; exact code/CDF law, normalizers, central mass and density.';z['remaining']='No local pair/cube field remains. Operational execution and emitted-source coverage belong to separate obligations.'
 if z['id']=='K-SAMPLER-007':
  z['status']='KERNEL_ACTUAL_REFERENCE_SAMPLER_ANALYTIC_CERTIFICATE';z['available']='Concrete finite-tape code, all-h AC and actual four local analytic witnesses; threshold257-bit and totalCDF268-bit facts.';z['remaining']='Operational runtime/memory/call cost and optimized implementation equivalence; logical tape/slot counts alone do not discharge Q-RESC.'
 if z['id']=='K-FULL-MOMENT-007':
  z['status']='KERNEL_ACTUAL_CODE_MOMENT_UNDER_EXACT_M';z['available']='ActualInterface017: second<=1+2^-47, full modeled failures, every state/public initial and same covered key law. No PairLeaves/CubeLeaf input remains.';z['remaining']='Actual emitted-key source coverage of(M); do not replace it with a crypto assumption or forall-h claim.'
q['closed_scoped_step']={'id':'K-LOCAL-LEAVES-017','status':'KERNEL_ACTUAL_PAIR_AND_CUBE_INSTANCES','audited_exports':checks['audited_exports'],
 'finite_rows':61441,'scope':'Sampler moment under exact(M); two independent pinned source-model obstructions; not QROM security or source/API/cost closure.'}
write('KERNEL_QUEUE_017.json',q)
artifacts=[]
for m in checks['modules']:
 obstacle=m['module'] in {'BoundedAddressObstruction017','GlobalDimensionsObstruction017'}
 artifacts.append({'artifact':{'path':m['source'],'sha256':m['source_sha256']},'condition_class':'proof_obligation',
  'conditions':['Q-KEY','Q-BIND'] if obstacle else ['Q-SAMPLER','Q-RESC'] if m['module']=='TableWidths017' else ['Q-SAMPLER'],
  'audited_exports':m['audited_exports'],'status':'KERNEL_OBSTRUCTION_FOR_PINNED_TYPE' if obstacle else 'KERNEL_IN_EXACT_STATED_SCOPE'})
write('CERTIFICATE_CLASSES_017.json',{'id':'S05_CLASSES_017','previous':{'path':'notes/CERTIFICATE_CLASSES_016.json','sha256':sha(S/'notes/CERTIFICATE_CLASSES_016.json')},
 'artifacts':artifacts,'actual_local_fields':[{'name':n,'class':'proof_obligation','condition':'Q-SAMPLER','status':'KERNEL_INSTANCE_FILLED'} for n in ['PairLeaves.rejection','PairLeaves.raw','PairLeaves.zero_mass','CubeLeaf']],
 'remaining_M':{'class':'proof_obligation','status':'EXPLICIT_INPUT_NOT_SOURCE_DISCHARGED','meaning':'OneK>0 before all challenges and exactly the three stated temperatures;014 supplies sufficient geometry under actual equations and H>=991.'},
 'Q_RESC':{'class':'proof_obligation','status':'OPEN_OPERATIONAL_COST','available':'fixed logical tape/slots, exact scalar widths and proof compilation costs; no execution-cost theorem'},
 'model':{'class':'model','description':'same independent fair finite bit tape and same full finite Sign response law, including all modeled failures'},
 'new_cryptographic_assumptions':[],'model_changes':[],'full_QROM_claim':False})
cost=receipt['proof_costs'];p=S/'notes/LOCAL_LEAVES_017_CHECKPOINT.md';assert not p.exists()
p.write_text(f'''# S05 — LOCAL_LEAVES017: checkpoint warunkowy

Status: **PARTIAL_PROOF / WARUNKOWY / NOT_REVIEWED**. Domknięto lokalne
obowiązki analityczne rzeczywistej referencji samplera; nie ogłoszono QROM.

Wszystkie cztery pola 016 mają teraz rzeczywiste świadki kernelowe:
`PairLeaves.rejection`, `raw`, `zero_mass` i `CubeLeaf`. Dokładne prawo
CDF/modulo i surowej próby pary jest wyprowadzone z kodu. Pełny certyfikat
sprawdza 61 441 wierszy, w tym 30 721 wag CDF i 61 441 progów; rekurencja Gaussa
obejmuje 30 721 stanów. Żaden wiersz nie został pominięty po limitach pamięci.

`ActualInterface017.initial_certificate` daje **J≪P oraz ΣJ²/P≤1+2^-47**
dla publicznego initial pod dokładnym (M). Certyfikat obejmuje każdy stan;
`key_law_under_cover` zachowuje to samo pokryte prawo kluczy. Cztery lokalne
pola nie są już przesłankami tego eksportu. M nadal jest jawną przesłanką.
AC dla każdego h, również bez (M), pochodzi z 016. P zawiera pełne modelowane
porażki, choć J(none)=0. Nie rekonstruuje się historii zapytań kwantowych.

Sprawdzono **{checks['audited_exports']} audytowanych eksportów** w dokładnych
typach, w tym 5 kontroli liczbowych i 5 lematów dwóch przeszkód źródłowych.
Dochodzi pełny generowany świadek wierszy i 5 jego eksportów składających.
Świeży build strukturalny/finalny reużywa przypięte, osobno skompilowane
świadki skończone. To kontrola autora, nie niezależny odbiór.

Zachowane granice: pełny emitted KeyGen→M/source harmonic, Sign/API/PRG,
koszt wykonania i zgodność zoptymalizowanej implementacji oraz mechanizmy
QROM pozostają OPEN. Nie podano poziomów bezpieczeństwa. h=0 i Dyadic
nie awansują automatycznie do kernela, a cel forall-h pozostaje osobny.

## Koszt i odtwarzalność

Suma zmierzonych czasów poszczególnych wybranych kompilacji skończonych:
{cost['finite_module_elapsed_sum_seconds']:.3f}s; to suma czasów procesów,
nie czas całej kampanii ani koszt samplera. Świeża closure strukturalna:
{cost['fresh_structural_elapsed_sum_seconds']:.3f}s. Pełne limity, pomiary
i brakujące próbki RSS są w `LOCAL_LEAVES_017_RECEIPT.json`.

Logiczna taśma 24 662 538 240 bitów i 24 084 480 miejsc propozycji z 016 nie są
liczbą rzeczywistych operacji/czasem/pamięcią. Doprecyzowano kernelowo:
terminalny CDF potrzebuje 268 bitów, środkowy próg to 2^256 i potrzebuje 257
bitów lub równoważnej reprezentacji pełnej akceptacji.

Źródła dużych świadków odtwarzają generatory z `LARGE_ARTIFACTS_017.json`.
Kanoniczny JSON oddziela koszt generacji od treści certyfikatu; ponowna
generacja odtworzyła wszystkie 9 źródeł danych bajt w bajt. Historyczny
JSON 001 z czasem wykonania pozostaje zachowany.

## Niewygodne wyniki

Bloki 128 wierszy i później niektóre bloki 8 przekraczały pamięć reduktora.
Mniejsze moduły 16 bloków nie naprawiły problemu pojedynczego bloku.
Wybrano indywidualne twierdzenia wierszy, zachowując sprawdzony prefiks.
Limity per compiler pozostały bez zmian; zachowano wszystkie próby,
diagnostyczne #eval nie są dowodami. Sealed lista: `LOCAL_LEAVES_017_ATTEMPTS.json`.

W pinie ROM 18a3ffe3 kernelowo wykryto dwie niezależne niemożliwe przesłanki:
globalne VirtualLegal (iniekcja Nat w skończone adresy) oraz globalne
Dimensions (sprzeczne ze stanem o pustych locals). Dokładny zakres i piny
są w `ROM_INVOCATION_AUDIT_017.md` i suplemencie001. Sampler 017 nie
konsumuje tych pustych przesłanek. Naprawy należą do wykonawcy ROM.

## Co wynik zmienia i co dalej

Łańcuch od konkretnych publicznych liczb i bitów do małego pełnego momentu
nie ma już czterech lokalnych luk 016. Wąskie gardła są teraz jawne:
zasoby/wykonanie, źródłowe pokrycie M i późniejsza redukcja kwantowa.
Następny duży pakiet: `TODO_COST_AND_SOURCE_018.md`; mapa murów:
`KERNEL_QUEUE_017.json`, klasy: `CERTIFICATE_CLASSES_017.json`.

Źródłowe checkpointy 017: 2ae6e140,77a65116,6d7b15df,ef354c48,7143b71b;
końcowy commit dokumentów identyfikuje Git. Brak push i zmian statusów T12.1/B20.
''')
tex=S/'notes/LOCAL_LEAVES_017.tex';x=tex.read_text()
x=x.replace('\\textbf{DRAFT / WERYFIKACJA WSZYSTKICH WIERSZY W TOKU / WARUNKOWY.}',
 '\\textbf{PARTIAL PROOF / WARUNKOWY / NOT REVIEWED.}')
x=x.replace('Niniejszy tekst opisuje składany wynik017. Dopóki nie istnieje czysty\nreceipt \\code{ActualInterface017}, tezy o wszystkich literałach i finalnym\nmomencie nie mają statusu ukończonego kernela.',
 'Wszystkie literały i finalny \\code{ActualInterface017} mają czysty build\nkernelowy. Cztery lokalne obowiązki016 zostały wypełnione; dokładny(M)\npozostaje jawną przesłanką, bez źródłowej instancji całego prawa kluczy.')
x=x.replace('Docelowy eksport017 po pełnym czystym buildzie','Kernelowy eksport017 pod dokładnym (M)')
tex.write_text(x)
readme=S/'README.md';x=readme.read_text();start=x.index('**Pakiet017 w toku');end=x.index('**Najnowszy pakiet — [IMPLEMENTATION-016]',start)
new='''**Najnowszy pakiet — [LOCAL_LEAVES017](notes/LOCAL_LEAVES_017_CHECKPOINT.md):**
Wszystkie cztery lokalne pola 016 mają kernelowe instancje dla rzeczywistych
tablic i kodu. Sprawdzono61441 wierszy; dokładne CDF/modulo i prawo pary
nie są założeniami. `ActualInterface017` daje pełne **J≪P i moment≤1+2^-47
pod dokładnym (M)**, dla każdego stanu/publicznego initial i tego samego
pokrytego prawa kluczy. Źródłowe pokrycie M, Sign/PRG, koszt wykonania oraz
mechanizmy QROM pozostają OPEN. [Pełne zdanie](notes/LOCAL_LEAVES_017.tex),
[następny duży TODO018](notes/TODO_COST_AND_SOURCE_018.md).
Osobno kernelowo wykryto dwie niemożliwe przesłanki pinu ROM 18a3ffe3:
[VirtualLegal](notes/ROM_INVOCATION_AUDIT_017.md) i
[Dimensions](notes/ROM_INVOCATION_AUDIT_017_SUPPLEMENT_001.md).

'''
x=x[:start]+new+x[end:];x=x.replace('**Najnowszy pakiet — [IMPLEMENTATION-016]','**Checkpoint — [IMPLEMENTATION-016]')
x=x.replace('**PairLeaves/CubeLeaf nadal nie mają kernelowych\ninstancji**; Sage potwierdza marginesy.','**W016 PairLeaves/CubeLeaf nie miały kernelowych\ninstancji;017 dostarcza je dla rzeczywistych tablic.**')
x=x.replace('notes/CERTIFICATE_CLASSES_016.json','notes/CERTIFICATE_CLASSES_017.json').replace('notes/KERNEL_QUEUE_016.json','notes/KERNEL_QUEUE_017.json')
x=x.replace('016: cały kod → moment pod lokalnymi PairLeaves/CubeLeaf; instancje tych pól oraz emitted prawo OPEN.',
 '017: rzeczywiste PairLeaves/CubeLeaf wypełnione i cały kod → moment≤1+2^-47 pod dokładnym (M). Emitted prawo i pokrycie(M) OPEN.')
x=x.replace('| To samo źródłowe h i prawo kluczy | 011: kernelowy lokalny material bridge i warunkowy konstruktor emitted law; pełna source/codec instancja OPEN |',
 '| To samo źródłowe h i prawo kluczy | 011: kernelowe interfejsy, pełna source/codec instancja OPEN.017: dwie kernelowe przeszkody w pinie18a3ffe3 (globalne VirtualLegal/Dimensions), wymagające naprawionego pinu i lokalnych świadków |')
readme.write_text(x)
todo=S/'notes/TODO_LOCAL_LEAVES_017.md';x=todo.read_text().replace('status IN_PROGRESS/WARUNKOWY.','status CLOSED_SCOPED/WARUNKOWY/NOT_REVIEWED.')
x=x.replace('- [ ]','- [x]')
x+='\nZamknięcie017: pełny wybrany świadek61441 wierszy, aggregate, ActualInterface017\ni świeży finalny replay przeszły. Cztery lokalne pola są wypełnione;\npozostają M/source coverage, wykonanie/koszt i QROM. Powyższe wpisy „w toku”\nopisują zachowane wcześniejsze granice przebiegu, nie aktualny stan.\n'
todo.write_text(x)
print('Closed live S05 documentation after verified final interface; no upstream edits.')
