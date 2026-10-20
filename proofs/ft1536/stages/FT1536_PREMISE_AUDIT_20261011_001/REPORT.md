# T12.1 — audyt przesłanek Source3 i krótki przegląd run2

Data właściciela: **2026-10-11, Europe/Warsaw**. Czasy receiptów są w UTC.
Zakres źródłowy: **`ef354c48226ac6bcf6193efa70289698a4a61d6a`**.
W: `proofs/ft1536/work/FT1536_PREMISE_AUDIT_20261011_001`.

**Werdykt główny: incomplete, with the smallest missing implication.**
Potwierdzono niemożliwe zestawy przesłanek i próżniowe eksporty. Nie wykazano
spełnialności wszystkich pozostałych interfejsów ani osiągalności wszystkich
konstruktorów. Ten checkpoint jest **REPORT_ONLY / CONFIRMED_VACUITY /
OPEN_SUSPECTS**, bez ogólnego PASS, REVIEWED lub owner acceptance.

Najważniejsze: oprócz dwóch znanych przeszkód (`VirtualLegal` i globalne
`Dimensions`) audyt dowiódł dwóch dalszych blokad: globalny `LegalWorkspace`
wyklucza każdy rzeczywisty binding certyfikatu, a `UniformChallengeAt` jest
niemożliwe dla obecnego samplera ze skończoną taśmą uczciwych bitów.
Nie są to błędy kernela Lean ani wykazane błędy implementacji C. Są to
poprawne implikacje o pustych domenach wejściowych, które nie mogą uzasadniać
oczekiwanej interpretacji źródłowej lub probabilistycznej.

## 1. Zamrożony zakres i granice kompletności

Zapisano wszystkie **761 śledzonych plików Lean Source3** oraz **148 run2**.
W drzewie roboczym istniała już niezatwierdzona naprawa `KeygenMakeInvocation`
i nowy `KeygenMakeLoopChronology`; nie włączono ich do badanego commita.
`LIVE_DRIFT.json` zachowuje ich odrębność. Repozytorium przesunęło się podczas
pracy wskutek cudzej pracy S05; nie zmieniło to przypiętej bazy audytu.

Inwentaryzator odczytał rzeczywiste typy z Lean, włącznie z niejawnymi
argumentami, przesłankami konstruktorów i odwołaniami do stałych:

| Czynność | Wynik | Czego ten wynik nie dowodzi |
|---|---:|---|
| Source3: jawnie nazwane publiczne deklaracje z indeksu źródłowego | 13864 / 13968 rozpoznane w środowisku | 104 pozostałe deklaracje pomocniczych audytów/emiterów/prob są wymienione w COVERAGE; nie zostały uznane za poprawne na podstawie braku typu |
| run2: krótki przegląd z pełnym spisem źródeł | 1264 / 2676 typów rozpoznanych w zbudowanej closure | Nie jest to pełny przegląd matematyczny wszystkich modułów run2 |
| Rejestr rodzin predykatów, struktur i induktywów | 1032: Source3 913, run2 119 | Większość nadal wymaga rzeczywistego świadka lub osobnego dowodu niemożliwości |
| Rejestr konstruktorów | 1598 | Sam istnienie konstruktora nie dowodzi spełnialności jego argumentów |
| Lekki test `omega` | 8897 sygnatur Source3 + 2 kontrole | Brak dodatkowego refutation nie jest SAT; test nie rozwija dowolnych definicji ani nie rozstrzyga logiki wyższego rzędu |
| Kontrole testu `omega` | sprzeczne `n < n`: wykryte; `n < 10`: nierozstrzygnięte | Dane „possible counterexample” solvera nie są świadkami modeli korpusu |
| Nieużyte przesłanki dowodowe | 2 `_hexec` | Nieużycie argumentu nie oznacza, że argument jest zawsze prawdziwy |
| Własna kompilacja closure run2 | 67 modułów, exit 0, czyste logi | Nie jest pełnym świeżym rebuildem Source3 |
| Nowe próby + świeży replay | 3 moduły, exit 0, czyste logi; źródła i stdout identyczne | Nie jest osobnym odbiorem innego modelu |

Rejestr `PREMISE_MATRIX.tsv` ma **1011 SUSPECT, 9 TRIVIAL, 2 IMPOSSIBLE,
9 OK i 1 VACUOUS**. To klasyfikacje rodzin; F02/F03 są dodatkowo konfliktami
konkretnych kwantyfikatorów i zestawów argumentów eksportów, dlatego nie
sprowadzają się do oznaczenia całej lokalnej rodziny jako IMPOSSIBLE.
**SUSPECT oznacza tu otwarty obowiązek audytu, a nie 1011 zgłoszonych błędów.**
`all_impossible_premises_found=false` i `feasibility_complete=false` są
celowymi polami wyniku. Nie ma podstaw do zdania „znaleziono już wszystkie”.

`PREMISE_MATRIX.json.gz` zawiera cytaty, pełne typy, piny i bezpośrednich
konsumentów każdej wpisanej rodziny. `EXPORT_PREMISES.json.gz` zawiera 8177
rozpoznanych eksportów z pełną listą argumentów. `BRANCH_MATRIX.json.gz`
oddziela wynik konstruktorów od rodzin. 3668 wpisów w
`DEFINITION_BRANCH_CANDIDATES.json.gz` to jawnie oznaczone **kandydaty
leksykalne**, również obejmujące pomocnicze definicje; nie są pełnym
semantycznym pokryciem wszystkich gałęzi `match`.

## 2. Potwierdzone przeszkody

### F01 — IMPOSSIBLE / VACUOUS: globalny VirtualLegal

Źródło: `source3/formal/Source3/KeygenMakeInvocation.lean:103`, SHA-256
`c644d0edd5eeb23dd7893bc88e83a0d9560b8ee899d54318c65baadc1ffbf2d2`.

```lean
structure VirtualLegal (vb : Nat → Nat) : Prop where
  bounded : ∀ block, vb block < 2^64
  distinct : ∀ b c : Nat, vb b = vb c → b = c
```

Mapa `n ↦ ⟨vb n, bounded n⟩` byłaby iniekcją `Nat → Fin (2^64)`.
`Source3Probes.no_virtual_legal` importuje dokładną definicję korpusu i
dochodzi do sprzeczności przez zasadę szufladkową.

Bezpośrednio dotyczą tego `canonical_word_eq`, `read_unique`,
`small_site_material` oraz argument `legal` konstruktora `Invocation.encoded`.
Własny `invocation_only_failure` dowodzi silniejszej diagnozy tego snapshotu:
**każdy obiekt Invocation zwraca 0**. Stąd
`no_successful_invocation` wyklucza argumenty `source` + `success` eksportów
`invocation_gate` i `invocation_certificate`.

Nie wykluczono istnienia gałęzi `capped`; nie skonstruowano jej pełnego
świadka. `invocation_flow` i `invocation_teardown` zachowują możliwy sens dla
tej gałęzi, zatem nie należy ogłaszać całego typu Invocation pustym.
To niezależne odtworzenie znanego znaleziska międzytorowego, nie roszczenie
do jego pierwszeństwa.

### F02 — IMPOSSIBLE: wymiary poprawne w każdym stanie

Źródło: ten sam plik, `invocation_certificate:696`:

```lean
(dimensions : (s : State) → KeygenMakeSearchPrefix.Dimensions s)
```

`Dimensions s` wymaga między innymi
`s.locals "logn".toList = some (.uint32, some (.uint32 10))`.
Stan o pustych lokalnych komórkach należy do typu State. Instancjacja
uniwersalnej przesłanki tym stanem daje `none = some ...`.
`no_all_state_dimensions` jest kernelowym dowodem niemożliwości.

Kontrola `dimensions_inhabited` daje konkretny stan z `n=1536`, `logn=10`,
`ter=1`. **Lokalne Dimensions nie jest niemożliwe**. Błąd jest w kwantyfikacji
po wszystkich stanach, nie w wartościach profilu. Znalezisko było już
zapisane w S05 `GlobalDimensionsObstruction017`; tutaj powiązano je z
dokładnym eksportem badanego snapshotu.

### F03 — VACUOUS: globalny LegalWorkspace wyklucza wykonywany certyfikat

Definicja: `KeygenMakeCertMaterial.lean:28`, SHA-256
`fd5a4702e6b5be8c463a8f95e404532f6741e404e5b25caedd51719e0eb8709c`.
Eksport: `KeygenMakeAttemptSpine.lean:469`, SHA-256
`1841f223d6483db56a4e57e8b0448cb71e0ac6a6a8b469b74784e679837b9b1a`.

```lean
def LegalWorkspace (s : State) (ctx : Context) : Prop :=
  ∀ args, CertBind s ctx args → CertificateFrameEntry.Legal args.base s.heap

-- attempt_spine oraz invocation_certificate:
(workspace : (s : State) → LegalWorkspace s ctx)
```

Dowód `certbind_readonly` pokazuje, że dowolny istniejący CertBind zachowuje
się po ustawieniu wszystkich praw zapisu w heap na `false`: binding używa
lokalnych komórek oraz odczytów, a te nie wymagają writable. Tymczasem
CertificateFrameEntry.Legal wymaga `heap.writable 0 = true`.
Otrzymano dokładną równoważność:

```text
(∀ s, LegalWorkspace s ctx) ↔ (∀ s args, ¬ CertBind s ctx args).
```

Następnie `all_workspace_excludes_call` wyklucza każdy `Call ctx ...`,
a `attempt_spine_premises_impossible` wyprowadza False z **faktycznych
przesłanek eksportu**: Remaining + AttemptExec + accepted break + globalne
workspace. Korzysta z `accepted_spine`, który wyciąga Call z tej samej
derywacji. `EntryFacts` nie jest nawet potrzebne do sprzeczności.

To **nowa niezależna blokada względem F01/F02**: pozostaje w attempt_spine,
nawet gdy naprawi się mapę adresów i wymiary w Invocation.

Ważne rozróżnienie: globalne workspace samo nie jest fałszywe dla każdego
ctx. Gdy `ctx.scratch.block ≠ 0`, CertBind jest niemożliwe z definicji
workspace bridge i uniwersalna przesłanka jest prawdziwa z pustej domeny
(`workspace_vacuous_nonzero_scratch`). Właśnie dlatego raport podaje
sprzeczność **zestawu argumentów** i nie oznacza całego LegalWorkspace
jako IMPOSSIBLE. Lokalne użycia w `accepted_certificate`, `spine_witness`,
`attempt_witness`, `cert_package_of_call` nie są objęte tym globalnym zarzutem.

### F04 — IMPOSSIBLE / VACUOUS: dokładna jednostajność ze stałej taśmy bitowej

Źródła run2:

- `Run2/Games.lean:92`, SHA `cebab37bc69a1bcad927ef430e0f789715e1a3baa8fcf1a47a63bba9cf02f95c`;
- `Run2/LawBinding.lean:21`, SHA `83a1d393262792bc3b60f1952941ca3310ad99a15d4eb52d51b138b678335356`;
- `HacGlue.lean:116`, SHA `df81199ba5b9441140864a7ffba81d560cb9a2af64b596d29979175761a94ee7`.

```lean
structure Sampler where
  bits : Nat
  code : Rq → State → Bytes → Nonce → (Fin bits → Bool) → Rq × Option BoxVec

samplerLaw S h st m r := Law.uniform.map (S.code h st m r)
UniformChallengeAt S := ∀ h st m r,
  UniformChallenge (JointDecomp.marginal (samplerLaw S h st m r))
```

Dla deterministycznej mapy między skończonymi zbiorami, która przenosi
rozkład jednostajny na jednostajny, liczność celu dzieli liczność źródła.
Własny `uniform_map_card_dvd` dowodzi tego na używanym w repo typie Law:
masa włókna wynosi `k / card α`; porównanie z `1 / card β` daje
`card α = card β * k`.

Tutaj źródło ma `2^S.bits` elementów, a `Rq` ma `18433^1536` elementów.
Pierwsza liczba 18433 musiałaby dzielić potęgę dwójki, więc również 2.
Kernel odrzuca to. `no_uniform_challenge_at` instancjuje rzeczywisty
UniformChallengeAt przy konkretnych `h`, `initial`, pustej wiadomości i
40-bajtowym zerowym nonce; nie używa pustej dziedziny świata.

**Żaden obecny Sampler nie spełnia tego interfejsu.** Bezpośrednie eksporty:

- cztery `HacGlue.localJointCertificate_of_*` z argumentem `huc`;
- `ONoneGeometry.localJointCertificate_of_attemptFactor`;
- pięć wariantów `Assembly` wymienionych w `FINDINGS.json`;
- dwa warianty końcowe `AdvPrg` z `huc`.

Pełna lista 12 nazw jest w `FINDINGS.json`. Starsza deklaracja w
B4_SYNTHESIS, że `UniformChallengeAt` zostało „delivered”, nie może być
skonsumowana dla tego typu Sampler. Samo
`VerifyBind.UniformChallenge (Law.uniform : Law Rq)` ma świadka (`rfl`).
Model abstrakcyjnego ROM nie jest obalony; niemożliwa jest jego dokładna
realizacja przez ten skończony fair-bit interfejs.

Nie rozszerzam zarzutu na poprawiony eksport
`AssemblyComp.advMT_ge_of_public_sim_stream_win`: jego typ nie zawiera huc
i dotyczy publicznej symulacji. Nie dowodzi to również niemożliwości dowolnego
LocalJointCertificate z dodatnim błędem przybliżenia.

## 3. Dodatkowe warunki i kontrole

| ID / klasa | Dokładny zakres | Znaczenie |
|---|---|---|
| F05 / SUSPECT, warunkowa sprzeczność kernelowa | `TowerWhole A c target`, `A z ≠ c`, `0 < fl`, `∀ x, fl ≤ target x` | TowerWhole wymusza `target z=0` poza włóknem. Globalny dodatni floor jest wtedy niemożliwy. Nie obalono samego `machineStage_of_absErr_floor`, które nie zakłada dodatniości fl; nie wolno bez mostu zamieniać dodatniej wartości skalara FPR w dolne ograniczenie wszystkich wag rozkładu. |
| F06 / IMPOSSIBLE w małym delta | `ChaCha20PRFBound (frngTapeLaw seedLaw n) delta` oraz `delta < 1-2^448/2^n` | Kernelowa reekspozycja znanej przeszkody `chacha20PRFBound_delta_ge`. Dla długiej taśmy małe statystyczne delta jest niemożliwe. Nie dotyczy automatycznie klasowo ograniczonego CompPRGBound. |
| TRIVIAL / pusta klasa testów | `CompPRGBound ∅ tau delta`, dowolne delta | Zawsze prawdziwe, lecz `CompWinCert ∅ ...` jest niemożliwe. Obecny konsument wymaga tego certyfikatu, więc kontrola potwierdza zachowanie bramki, nie zgłasza luki w poprawionym eksporcie. |
| TRIVIAL / brak ewaluacji | `KeygenPublicTableStore.EvalWord s (.load32 name index) z`, dowolne z | KeygenPublicWord.Eval nie ma konstruktora load32. Warunek mówi jedynie „jeżeli wyrażenie się ewaluuje”; nie zapewnia istnienia ewaluacji. Wszystkich konsumentów wpisano do macierzy. |
| TRIVIAL / zerowa długość | `KeygenNttCells.Cells heap p 0 a` | Kwantyfikacja `∀ i < 0` jest pusta. Nie jest to błąd użyć z jawnym dodatnim rozmiarem. |
| TRIVIAL / sześć zamkniętych twierdzeń | HeaderCompleteness, PrimitiveCompleteness, CertificateFunctionSyntax.Bound oraz trzy StableBinaryRefinementGoal | Mają bezwarunkowe dowody; kompilacja samej definicji nie była tu podstawą werdyktu. Ich osobne przesłanki byłyby logicznie zbędne. Dowody i aksjomaty odczytano. |
| SUSPECT / dwa nieużyte `_hexec` | `StableBinary.source_preserves_prior_bad`, `source_preserves_any_nonzero_bad` | Wynik wynika już z proof-bearing `State l m` i sticky-bad invariant. `_hexec` nie występuje po beta-redukcji termu. To nie znaczy, że run=some s jest zawsze prawdziwe; należy właściwie opisać, skąd pochodzi invariant. |
| OK / świadkowie lokalni | Dimensions, Allocated, Load64, Canonical, trzy poprawne układy pamięci, CertificateFrameEntry.Legal | Świadkowie obalają podejrzenie globalnej pustki tych rodzin. Nie wykazują wspólnej osiągalności z rzeczywistego KeyGen. |
| OK / kontrola gałęzi | `CertificateGate.unprofiled` przy pustych locals | Gałąź jest globalnie osiągalna. Jej wykluczenie pod profilem M0 jest zamierzonym ograniczeniem, a nie błędem podobnym do VirtualLegal. |
| IMPOSSIBLE / kontrola pustego typu | `Law Empty` | Normalizacja masy wyklucza rozkład na pustym typie. Nie wolno utożsamiać tego z pustą rodziną wszystkich istniejących Law α. |

## 4. Mapa liści i ukrytych założeń

W `EXPORT_PREMISES.json.gz` każdy rozpoznany argument jest odczytany z typu
Lean, nie z komentarza. Jego nazwa, rodzaj proof/data, pełny typ i użyte stałe
są zachowane. W `PREMISE_MATRIX.json.gz` wskazano źródło definicji i
konsumentów. Definicja interfejsu **nie zastępuje jego realizacji**.

| Rodzina liści | Podstawa / obowiązek |
|---|---|
| Zamknięte fakty parsowania i sześć zamkniętych predykatów | Wewnętrzne twierdzenia; konkretne nazwy i standardowe aksjomaty w PositiveControls |
| Typy pamięci, lokalne legalności, zakresy, profile i rozłączności | Jawne warunki modelu/kontraktu. Ich rzeczywisty producent i wspólna spełnialność nadal wymagają świadków; F01–F03 pokazują, że samo nazwanie warunku nie wystarcza |
| Exec, Call, LoopTrace, zapisane przebiegi, accepted/success | Jawne relacje interfejsu wykonania. Ich przyjęcie nie dowodzi istnienia, terminacji ani dodatniego prawdopodobieństwa sukcesu |
| UniformChallenge kontra UniformChallengeAt | Pierwszy jest spełnialnym abstrakcyjnym założeniem świata; drugi jest niemożliwym mostem do aktualnego Sampler |
| ReplyShape, AttemptShape, StageRoad, floor, wiązania bajtów i wag | Udokumentowane interfejsy realizacji. Pozostają otwarte; F05 ogranicza możliwy sposób ich łączenia |
| CompPRGBound, CompWinCert, cost, KeyLawBinding i hkey | Jawne interfejsy obliczeniowe/powiązania praw. Pusta klasa lub fałszywy keyIdent same nie dają obu wymaganych argumentów konsumenta |
| Lean/Mathlib | Zapisane źródła, wersje i artefakty. Wszystkie nowe rozstrzygające dowody korzystają wyłącznie z propext, Classical.choice, Quot.sound lub ich podzbiorów |

Nie utworzono nowych aksjomatów, nie użyto `native_decide`, nie wyciszano
ostrzeżeń. Rejestr nie awansuje nieudowodnionej realizacji interfejsu do
„założenia świata” tylko po to, aby nadać jej OK. Pozycje bez takiego
uzasadnienia zostają SUSPECT. Nie przeprowadzono pełnego audytu wszystkich
zewnętrznych modułów Mathlib ani całego łańcucha kompilator–C–maszyna.

## 5. Proponowane naprawy — NIE zastosowano

1. **F01:** legalność na rzeczywistym skończonym zbiorze żywych bloków,
   konstruktywny świadek mapy i dowód przynależności wszystkich używanych
   wskaźników. Osobno sprawdzić osiągalność kompletnej gałęzi encoded;
   świadek samej poprawionej VirtualLegal nie wystarcza. Naprawa już obecna
   w cudzym drzewie roboczym wymaga własnego przypięcia i odbioru §40.1.
2. **F02/F03:** przenieść niezmienniki po tej samej rzeczywistej derywacji
   pętli do konkretnego rawState przy certyfikacie. Zastąpić globalne
   `∀ s : State` lokalnym argumentem albo twierdzeniem ograniczonym do
   osiągalnych stanów z jawnym producentem. Nie naprawiać problemu przez
   dołożenie nowej nazwy do tej samej fałszywej przesłanki.
3. **F04:** wybrać jawnie zmianę modelu: oddzielne losowanie wyzwania ROM
   spoza taśmy samplera, taśma o nieograniczonej długości z odpowiednim
   rachunkiem terminacji/zasobów, albo przybliżona jednostajność z
   niezerowym błędem warstwy pierwszej. Przepisać typy i wszystkie 12
   konsumentów; nie zastępować dowodu etykietą A2. Koszty i hprg muszą
   odpowiadać wybranemu wariantowi.
4. **F05:** floor ograniczyć do właściwego supportu lub sformułować
   punktowe względne oszacowanie; oddzielnie potraktować zera poza włóknem.
5. **F06 i kontrole TRIVIAL:** zachować rozróżnienie statystyczne/obliczeniowe,
   membership w CompWinCert i jawne wymaganie istnienia Eval tam, gdzie
   potrzebna jest totalność. Dla `_hexec` opisać invariant zakodowany w typie
   lub usunąć zbędny argument w osobnej naprawie, z przeglądem konsumentów.
6. **Pozostałe SUSPECT:** najpierw świadek pełnego Initial/EntryFacts wraz
   z legalną skończoną pamięcią i statycznymi tabelami, następnie świadkowie
   accepted/capped/rejected trace i wspólna realizacja StageRoad. Każdy
   status OK powinien wskazywać własny świadek, nie tylko nazwę konstruktora.

## 6. Dowody, receipty i historia prób

Rozstrzygające źródła to `formal/Source3Probes.lean`,
`formal/Run2Probes.lean`, `formal/PositiveControls.lean`.
Końcowe receipty: `source3_probes_004`, `run2_probes_003`,
`positive_controls_002`. `fresh_replay_001/REPLAY_RESULT.json` potwierdza
ponowne wykonanie wszystkich trzech modułów na świeżych kopiach bibliotek,
z identycznymi źródłami i stdout. `AUDIT_PAIR.json` wiąże piny, wyniki,
baseline i dokładny scope; OUTPUTS pieczętuje raport i cały wynik.

Source3 oparto na zweryfikowanym powiązaniu **771 źródeł i artefaktów**;
przebudowano dodatkowo KeygenMandatory, lecz nie cały korpus. Stwierdzono
trzy historycznie niezgodne hashe bezpośrednich importów w cache:
KeygenZintProbe→KeygenZintCall, KeygenPinProbe→KeygenSourceLines oraz
KeygenTokenPinProbe→KeygenSourceLines. Wszystkie trzy moduły są wyłączone
z importu audytu; zachowano opis w DEPENDENCY_CHECK. Nie zmieniano cache
ani nie naprawiano cudzych receiptów.

Wczesne nieudane próby są zachowane z pełnymi stdout/stderr i snapshotami:
błędy składni/typów własnych prób, niewłaściwy kontekst IO przy metadanych,
jedna zła nazwa API opcji, brak namespace-closure w izolowanej bibliotece
run2 oraz błędy tworzenia wątków przy limicie przestrzeni adresowej. Końcowy
runner używa jednego wątku, wyłączonej asynchronicznej elaboracji,
limitu Lean 6144 MiB i osobnego limitu przestrzeni wirtualnej 24 GiB.
Nie są to wyciszenia ostrzeżeń. Maksymalny RSS rozstrzygających nowych
modułów pozostaje poniżej 4 GiB. Wczesne `sorryAx` generowane przez błędy
elaboracji są częścią odrzuconych logów, nigdy podstawą werdyktu.

Nowy checkpoint archiwizuje wyłącznie audyt. Nie wykonano zmian formalnych
toru głównego, statusów T12.1/B20, napraw, migracji, uruchomienia innego
workera/modelu ani push. Nie jest to sealed odbiór autora przez osobnego
recenzenta; „para” oznacza tu raport i receipt audytu, jak para notatek/JSON
BATCH, nie fikcyjnego drugiego recenzenta.

## 7. Ocena dla właściciela

Audyt znalazł przeszkody, które zwykły czysty build mógł ukryć. Najbardziej
istotna nowa diagnoza run2 wymaga zmiany interfejsu probabilistycznego,
nie dopisania kolejnego lematu do istniejącej fałszywej przesłanki. W Source3
naprawa samego VirtualLegal nie usuwa globalnego LegalWorkspace.

Do paper i dalszej kompozycji nie należy przenosić objętych zarzutem
eksportów jako wyników o rzeczywistym wykonaniu. Następny konkretny krok
to naprawy F01–F04 w §40.1 i niezależny recheck ich pełnych zestawów
przesłanek, równolegle z domknięciem jawnej listy SUSPECT. Ten raport
zachowuje niewygodne wyniki oraz dokładną granicę tego, czego jeszcze nie
wykazano; **nie zamyka celu „wszystkie przesłanki sprawdzone”**.
