# Stan projektu — punkt wejścia

**Aktualizacja2026-09-22:** T01 niezależnie odebrany w `a2cdf317`;
następnie właściciel poprosił o zadanie korekt S01 przed publikacją.
Po nim przygotowano na jego prośbę małe T02.1 dla kolejnego ręcznie wybranego modelu.
Najnowszy handoff: Muse Spark1.3Free przekazał **PASS_SCOPED_REVIEW** dla
T03 PARTIAL_PROOF. Archiwizacja wykazała różne hashe3 checkerów recenzenta
w dziennikach versus frozen źródła: **REVIEW_RECEIVED_SAGE_BINDING_PENDING**.
Następnie właściciel wybrał ponowny pełny odbiór przez inny model:
**REVIEW_002 PREPARED_OWNER_START**,T03 **FROZEN_AWAITING_REVIEW**.
Mały suplement zastąpiono; prowadzący przygotował1429 przypiętych wejść.
Nowszy zwrot: **S01 COMPLETE_FOR_REVIEW / FROZEN_AWAITING_REVIEW**,
osobny niezależny odbiór przygotowany. Właściciel potwierdził także częściowy
run estymatora S06/RUN_001 —70 zapisanych komórek NTRU,bez finalnego freeze.
**Aktualna decyzja wykonawcza:** właściciel polecił temu prowadzącemu
osobiście ocenić S01 i S06. Oba odbiory zakończono z **CHANGES_REQUIRED**,
recenzent GPT-6 Astra; S06 obejmuje częściowy snapshot,nie pełne120 komórek. Właściciel
zapowiedział gotowy handoff recenzji T03 i wyniku T02.1 po zakończeniu S01.
To jawny wyjątek od wcześniejszego podziału ról,bez delegacji/relay.
Historyczne obserwacje procesów/dudect poniżej pochodzą z około04:33 CEST.
Stan procesów jest ulotny: sprawdź go ponownie przed pracą. Ten dokument
aktualizujemy po odbiorze etapu, zmianie wykonawcy lub decyzji właściciela.

Główna kolejka zadań i kryteria: [ROADMAP](ROADMAP.md).
Astra: **T01 REVIEWED**, pełny **T02 OPEN**, podzadanie **T02.1 PREPARED_OWNER_START**;
osobny MiMo = **T03 FROZEN_AWAITING_REVIEW / REVIEW_002 PREPARED_OWNER_START**,
poprawki Family = **S01 CHANGES_REQUIRED**, dudect = **S02**,
estymator = **S06 CHANGES_REQUIRED / PARTIAL_DIAGNOSTIC**, oryginalny run w pauzie.

## Decyzje właściciela

- Nowy obowiązkowy standard rachunku: **pliki `.sage`, uruchomienie
  `sage lemma.sage` z preparserem SageMath**. Dotyczy nowych rachunków/checkerów
  i niezakończonych S01/T03/T02.1 przez
  [przypięte uzupełnienie](../../proofs/ft1536/documents/FT1536_ZASADA_RACHUNKU_SAGEMATH_2026-09-22.md).
  `.py` organizuje procesy/manifesty/logi. Pierwotne TASK/bootstrap oraz stare
  wyniki pozostają niezmienne. Właściciel przekazuje zasadę obecnym wykonawcom;
  prowadzący nie uruchamia ich ponownie.
- Aktualny podział ról: prowadzący przygotowuje zadania i prompty do odbioru.
  **Weryfikację i replay zwrotów wykonuje inny niezależny model wskazany przez
  właściciela**. Nowe wyniki czekają na jego raport; ten prowadzący nie wykonuje
  ich odbioru automatycznie. Starsze opisane niżej odbiory są faktami historycznymi.
- **Publikacja czegokolwiek na GitHub wstrzymana**, aż MiMo poprawi
  FT_FAMILY_SCALING i poprawiona wersja przejdzie pozytywny niezależny odbiór.
  Późniejszy push nadal wymaga osobnego polecenia. Aktualny dystans do origin
  odczytuj z Git; lokalny checkpoint nie oznacza publikacji.
- Jeden wykonawca danego W. Właściciel uruchamia/przekazuje zadania jawnie.
  Nie używaj `opencode run --session` jako sposobu wklejenia do otwartego czatu:
  uruchamia to oddzielnego wykonawcę.
- Etapy/logi/cache/skrypty wyłącznie pod kanonicznym repo; żadnego systemowego tmp.
- Dudect: **10h, rano przed wyjściem właściciela do pracy, po jego sygnale**.
  Brak automatycznego timera. Pomiar bez równoległej Astry/kompilacji/replayów.

## Najnowsze odebrane wyniki

| Etap / commit | Faktycznie odebrany zakres |
|---|---|
| SCALAR_GAUSSIAN `64af4cb` | IID_BUFFER, lokalnie TV(K,G)≤2^-36, chi2(K\|\|G)≤2^-60; reverse chi2 nieskończone |
| ORDERED_JOINT `22e6dd4` | Dokładne adaptacyjne3072 calls jednego root, closure/fresh-tail, TV≤2^-25, forward chi2<2^-48, zasoby |
| H6P_REFERENCE_BAD_EVENT `1ba7ae0` | Uniform joint BadPrecast OBU pre-narrow vectors: Q_S≤2^-119, one-root P_IID≤2^-84 |
| IID_RETRY_COMPOSITION / T01 `a2cdf317` | Niezależny PASS_SCOPED_REVIEW: one post-H2P cap16 region G_retry_IID, WholeRegionBad≤2^-80,coupling,wspólne resources,STATIC bytes |

H6P: niezależny replay **197/197**,73.819s;48 modułów Lean/327 twierdzeń,
26 nowych. Osobne QQ/RBF768 sprawdzenie rachunku. V<5462457,E<1095.
Dowód mieszany source/analytical/kernel; nie pełna kernelizacja kompilatora/C.
Sam H6P nie daje universal Safe16, real-PRNG bridge, retry composition, integer recovery
ani Sign→Verify. Pełne exact rationals są istotne dla końcowego wykładnika.

Raport i odbiór:
- [H6P REPORT](../../proofs/ft1536/stages/FT1536_H6P_REFERENCE_BAD_EVENT_RUN_001/REPORT.md)
- [H6P validation](../../proofs/ft1536/validation/2026-09-22-h6p-reference-bad-event/README.md)

## T01 — REVIEWED po niezależnym odbiorze

`FT1536_IID_RETRY_COMPOSITION_RUN_001`, przygotowanie `c4e9d35`.

- W: `proofs/ft1536/work/FT1536_IID_RETRY_COMPOSITION_RUN_001/`.
- [TASK w repo](../../proofs/ft1536/documents/FT1536_ZADANIE_ASTRA_IID_RETRY_COMPOSITION_2026-09-22.md).
- TASK SHA: `f773b8f31f7d307850ee3d1eb948bb05ceacee5589d5c4971e3eaee34c5bed97`.
- Bootstrap SHA: `daa95bc07516271ff897f95af11b3c90950ccb1a7dc20f0f3da5e994785a46b8`;
  1270 plików/1268 origins; BASE `1ba7ae07c17d135fc8eff4aac7b56f8c2b3bc88c`.
- Cel: od jednego legalnego post-H2P entry wyprowadzić re-entry/fresh-tail,
  actual16-attempt scheduler/norm/codec, WholeRegionBad, coupling i zasoby.
- Właściciel przekazał **PASS_SCOPED_REVIEW** od innego niezależnego modelu.
  Jego własny świeży replay:492/492,exit0,662.514s. Review A–F potwierdził
  post-H2P G_retry_IID cap16,WholeRegionBad<=2^-80,coupling,6352 blocks/
  26017792 bytes na wspólnym event H,tail<2^-1020 i exact STATIC<=3160.
  Formalizacja120 modułów/922 twierdzenia/26 nowych; mixed source/analytical/kernel.
- REPORT SHA `b7164dbbee02db248ea43adce1d63ae0a38ed4493a566c5acd3a2f507db14590`;
  OUTPUTS SHA `3d68249f4f0e017f32eb7edeb0d90f5c4a6cd6b4b9f93307cec6919439525074`.
- [Archiwum niezależnego odbioru](../../proofs/ft1536/validation/2026-09-22-iid-retry-independent/README.md)
  zachowuje raport,oryginalny manifest12 plików,492 semantic results i pełne
  dostępne logi/receipts. REVIEW SHA
  `8523b1ea63faabdf2d78c602ccf1a5f7aaceba9c71ecc3ee6032c1add02344ec`;
  REVIEW_OUTPUTS SHA `5072eacae41c4eedf6184484385076a5447b538a2f646166e3dc5d872a7ca318`.
- Prowadzący wykonał import/pin-byte binding i Git; bez powtórnego własnego
  odbioru matematycznego/replayu. Dwa stale live INPUTS mają zgodne sealed kopie;
  failed routes/overlap i strict-tail convention zachowano. owner_accepted=false.
- Autor i recenzent zakończyli obliczenia. Nie wznawiaj ich W ani relay.
  T02 można teraz przygotować z odebranych zasobów; start wymaga nowego TASK/W
  i ręcznego polecenia. T03 oczekuje na nowy pełny odbiór przez inny model.
- Granica: nie ma boundu Bad|success bez success denominatoru. Real PRNG,H2P,
  whole real Sign,integer recovery,Sign→Verify/security/CT pozostają otwarte.

## T03 — PARTIAL_PROOF, ponowny odbiór innym modelem przygotowany

`FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001`,one-root,autor MiMo2.6Pro.
[CURRENT_MIMO_TASK](../../proofs/ft1536/CURRENT_MIMO_TASK.md) wiąże pierwotne
TASK/bootstrap i [nowy REVIEW_002](../../proofs/ft1536/CURRENT_REVIEW_TASK.md).
Właściciel przekazał zakończony odbiór Muse Spark1.3Free. Oryginalne pakiety
zarchiwizowano z niezmiennymi pinami. Później właściciel wybrał pełną ponowną
weryfikację przez model inny niż Muse i autor MiMo; nowy W czeka na ręczny start.

- REPORT SHA `e01a09789091c9c9322f9727263503063c94441a68ff5f30af952bcc4417785c`;
  OUTPUTS SHA `0cafdbb2c746043380081052951cb6438643f6a1765a98028a065fa57b7df6de`.
- **Przekazany scoped PASS:** A niezależna integralna reference i mapping3072/
  congruence; C rounding-gap lemma; D conditional consumer. B≈6086.4008 nie
  osiąga `<1/2`; Safe16/center/norm/bytes otwarte. Status REVIEWED wstrzymany
  do rozliczenia niespójności dokumentacji wykonań recenzenta.
- [Archiwum odbioru](../../proofs/ft1536/validation/2026-09-22-integer-recovery-independent/README.md):
  32 członków review,11 zapisanych semantic files i dostępne logi własnego
  replayu recenzenta11/11,exit0,około12s. Prowadzący związał je z bajtami,
  bez nowego wykonania replayu/matematyki. Author stage85 OUTPUTS/29 INPUTS;
  materializacja closure1278 plików rozlicza bootstrap,POLICY i alias TASK.
- REVIEW SHA `0d9402eeef00994a54cf58fb656092501bf599b13c10a9fead7b94d2b82c6e36`;
  REVIEW_OUTPUTS SHA `9ba196b04a95ec2fa4dadda06d6dabc50c99a2313f6a370e488e9065cb423ccd`.
- Blocker:3 hashe `.sage` w COMMANDS/sage_inputs_sha/REPORT są inne niż w
  REVIEW_OUTPUTS i plikach. [BINDING_CHECK](../../proofs/ft1536/validation/2026-09-22-integer-recovery-independent/BINDING_CHECK.json)
  zachowuje obie wersje hashy. Historyczna rozbieżność pozostaje jawna.
- Bieżący plan: **FT1536_REFERENCE_INTEGER_INDEPENDENT_REVIEW_002** we własnym W,
  pełna własna ocena A–D,fresh replay i nowe `.sage` z kompletnym bindingiem.
  Read-only bundle1429 plików (subject1364,prior62,context3),SHA
  `8019bda3cee5752d797fd9497d10086ff707f2c4a5739965c7aa48aa210c31e7`.
  [Przygotowanie/origins](../../proofs/ft1536/background/T03_SECOND_REVIEW_2026-09-22/README.md).
  Wcześniejszy nieuruchomiony suplement ma SUPERSEDED_OWNER_REREVIEW.
  Nowy poprawny odbiór ma samodzielną podstawę,nie wymaga pozorowanego
  odtworzenia nieznanych historycznych wersji Muse. Prowadzący nie uruchomił recenzenta.
- Recenzent rozliczył v3→v4/5 plików,wiersze Z versus cały JSON i fixture counts
  (20110 różnych słów/60384 wykonania). Niewygodne wyniki/uwagi zachowane.
  B-gap fix pozostaje kolejnym proponowanym tranche po domknięciu odbioru.

## Małe T02.1 — osobny model, ręczny start

[CURRENT_SMALL_TASK](../../proofs/ft1536/CURRENT_SMALL_TASK.md) wskazuje
`FT1536_PRNG_LAYOUT_COUNTER_RUN_001`,39 przypiętych wejść i nowy W.
Cel: source-bound deterministic init56,ChaCha block/refill4096,counter/frame
i przeliczenie odebranego T01 resource envelope. Bez assumed IID init bytes
lub dowodzenia kryptografii całego SHAKE/ChaCha hopu. T02 pozostaje OPEN.
Zadanie jest niezależne od S01/T03 i ma własnego jednego wykonawcę wybranego
przez właściciela; prowadzący przygotował pliki, nie uruchomił modelu.

### Incydent dwóch wykonawców

CLI z PATH to OpenCode2.0.12, podczas gdy okna właściciela używały
`/home/footfalcon/.opencode/bin/opencode`1.18.31. Kopie sesji miały takie same
ID i nazwy w odrębnych magazynach. Pierwsza wysyłka trafiła do2.x i przerwała
się na permission. Następne `run --session` w1.18.31 uruchomiło model w tle;
po wznowieniu okna właściciela wystąpiły nakładające się wykonania tego samego W.

Własny background PID593062 zatrzymano SIGINT; przy snapshotcie pozostało
okno Astry PID596312. Numery PID nie są trwałą identyfikacją. **Przekaźnik
`FT1536_SESSION_RELAY_2026-09-22/relay.py` jest zablokowany**, również callback.
Nie odblokowuj go automatycznie. Handoff przez plik i istniejącą sesję właściciela.
Pełna kontrola świeżego replayu po zakończeniu ma szczególne znaczenie po overlap.

Sesja Astry: `ses_f4f1aa5e4ffed4MiXn4d8dtwEj`, „Audyt wznowienia FT1536 i zakres
T01 oraz T03”. Prowadzący: `ses_f4f4e545cffeG2sZ5xvZEyTbi5`, „Przegląd i scalenie
historii Falcon FT1536 readonly”. **ID samo nie wystarcza do ustalenia instancji.**
Historia osiągnęła około900k tokenów/krok; nowe etapy zaleca się rozpoczynać
w świeżym małym kontekście po kontrolowanym przekazaniu, bez drugiego workera.

## MiMo — materiał zachowany, poprawki wymagane

`FT_FAMILY_SCALING_REVIEW_RUN_001`, commit `0c1ddc1`, status
**RESEARCH_REVIEW_CHANGES_REQUIRED**. Autorzy: projekt Niirmata, opracowanie MiMo.
Sprawdzone4 moduły Lean/14 nazwanych twierdzeń,5 JSON/CSV i12 FFT-port cases.
[Recenzja R1–R7](../../proofs/ft1536/stages/FT_FAMILY_SCALING_REVIEW_RUN_001/REPORT.md):
kierunek redukcji; definicja losowych celów ROM i zależność prób; brak F przy
trapdoor completion; homogeneous SIS w szkielecie P2; idealna hipoteza chi-square;
spójność statusu proposed FFT bound; lokalna tabela high-water16384 zamiast15360.
Nie zastępuj poprawkami zamrożonych bajtów. Nowa wersja wymaga osobnego odbioru.
Nie ma w tym snapshotcie pozytywnego odbioru poprawek. Nie uruchamiaj MiMo sam.

Aktualizacja przygotowania2026-09-22: właściciel wybrał dla MiMo NOWY obowiązek
głównego toru, odrębny od korekt Family. [CURRENT_MIMO_TASK](../../proofs/ft1536/CURRENT_MIMO_TASK.md)
wskazuje **T03 / one-root REFERENCE_INTEGER_RECOVERY**. Przygotowane wcześniej
W zwrócono jako PARTIAL_PROOF; właściciel zgłosił już gotową kolejną recenzję
T03,której handoff/piny przekaże po odbiorze S01.
S01 i blokada publikacji pozostają
otwarte. Nieuruchomiony szkic CORRECTIONS_RUN_002 zachowano lokalnie jako anulowany.

**Zwrot S01 CORRECTIONS_RUN_003:** właściciel przekazał
FT_FAMILY_CORRECTIONS_COMPLETE_FOR_REVIEW. [CURRENT_FAMILY_TASK](../../proofs/ft1536/CURRENT_FAMILY_TASK.md)
wiąże TASK/bootstrap i [osobny prompt odbioru](../../proofs/ft1536/CURRENT_FAMILY_REVIEW_TASK.md).
Właściciel wskazał później tego prowadzącego jako recenzenta. W:
`proofs/ft1536/work/FT_FAMILY_CORRECTIONS_INDEPENDENT_REVIEW_001`.

**Późniejszy własny odbiór na polecenie właściciela:** GPT-6 Astra zakończył
review z CHANGES_REQUIRED. [Raport i archiwum](../../proofs/ft1536/validation/2026-09-22-family-corrections-independent/README.md),
[minimalne poprawki](../../proofs/ft1536/stages/FT_FAMILY_CORRECTIONS_REVIEW_RUN_001/REQUIRED_CORRECTIONS.md).
I1:R1 typ oracles/nierówności Adv i zakres N3; I2:R5 claim≈1e-305 nie wynika
z autorskiego Arb256 (≈1.06e-82,written endpoints width1e-50). Core tail
2^-40<tail<2^-28 poprawny. Własny replay18/18,16/16 exit0,354.775s i PDF9 stron
potwierdzone; raw controller exit1 jawnie rozlicza tylko transportowe pole
source_header FFT JSON. Dwa udane własne `.sage`,13 R4 mocks,4/14 Lean.
REVIEW SHA `6cb263741571922d9326decb7f22cc2713532658cee69bd9a46354423a415dc4`;
REVIEW_OUTPUTS SHA `7ad83392a6c31762b791517935ccb5f6d042b8f0eac90970f1e7e02f031d1982`.
Joby zakończone,publikacyjna bramka korekt niespełniona. S06 nie był wykonany
ani oceniony tym review. Własne failed attempts recenzenta zachowane.

- REPORT SHA `7d2f17cc51126b6dbb03279d7c876c460aa9f48bb581f63b9f512f87adee485d`;
  OUTPUTS SHA `9e093536dfd684f83ca9bc361049e00064f3d60848f8ecc999aa5481398c397e`.
- Na etapie przygotowania prowadzący sprawdził100 outputs,197 bootstrap
  members,source17 i zapisany postfreeze autora. Właściwy własny odbiór
  wykonano następnie na nowe polecenie właściciela i opisano powyżej.
- Read-only bundle323 plików,7.6MB; [origins/przygotowanie](../../proofs/ft1536/background/FAMILY_CORRECTIONS_REVIEW_2026-09-22/README.md).
  Plan odbioru obejmował R1–R7,wycofanie R4,ujemny R5,proposed R6,tabelę/PDF,
  stale-result guard,semantic-only steps,stary hash lemma_controls i sealed .pyc.
- Author COMPLETE nie znosi bramki publikacji. Wymagany pozytywny niezależny
  scoped review,a później osobne polecenie push. T03 REVIEW_002 ma odrębne W.

## S06 — niezależny odbiór częściowego runu: CHANGES_REQUIRED

[Pełny odbiór i piny](../../proofs/ft1536/validation/2026-09-22-family-estimator-independent/README.md)
wykonał GPT-6 Astra po S01,na to samo bezpośrednie polecenie właściciela.
Pięć natywnych `.sage`:12 model rows/pola,21 exact moments +mean checks,
132 cost values+12 error rows,3 wybrane NTRU usvp samples i kontrtest agregatora.
Wymagane E1:subfield n=N/2 (kod używaN),E2:rop/log2 i grouping modeli,
E3:MATZOV/EMPTY/inf/repair accounting,E4:weakest-link i multi-target convention.
Joby zakończone,oryginalnej kampanii nie wznowiono. Nie jest to pełny replay70/120.
REVIEW SHA `49fabdfaff749a54a651b9d11e8d56dbc118762fcfe25fdb3c3d32a95c327fdf`;
REVIEW_OUTPUTS SHA `f1605f5f4d1418248dff5725559c310b973bd90dcf775380b84e83f860de73df`.

W: `proofs/ft1536/work/FT_FAMILY_SEC_ESTIMATE_2026-09-22_RUN_001`.
STATUS=`DIAGNOSTIC_NOT_CANDIDATE_READY`; RESUME_STATE opisuje pauzę i wznowienie
na polecenie właściciela. Odczyt2026-09-22: ntru_grid.ndjson ma71 rekordów,
z czego1 metadata +70 zapisanych komórek: FT76824,FT153624,FT307222.
Docelowa siatka120 obejmuje także kotwice Falcon; brak finalnego report.md
i OUTPUTS.sha256. To rzeczywiste zapisane oszacowania,jeszcze nie odebrany freeze.
Snapshot hash siatki: `3f766b1a4f46080f99422f2f7f7c8c270708bc949e25ed01f9a482df95bab4d3`.

S01 estimator_campaign_executed_in_this_task=false nie przeczy temu osobnemu
runowi. Wyniki mają zakres model-dependent/diagnostic; aktualny SCOPE wymienia
otwarte modeling/population/lift obligations. Pełne domknięcie kampanii wymaga
napraw z odbioru oraz handoffu z pinami i kompletnymi wynikami. Komendy env-python z
RESUME_STATE nie traktuj jako nowego polecenia startu; nowe rachunki stosują
obowiązujący tryb Sage. Prowadzący nie wznawiał ani nie zatrzymywał kampanii.

## Build i dudect

Extra/c: aktywny kandydat L_RHO+FLOOR_CT, manifest17 plików
`56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985`.
FLOOR_CT zintegrowany w `fe6f92a`; fpr_floor zachowuje floor(-0)=-1.
F01 numeric fpr_lt(-0,+0)=1 nie jest ogólnie naprawione.

RUN_002: przy snapshotcie **STATIC_READY_TIMING_DEFERRED**, usługa inactive,
MainPID0, brak długiego runu. Budżet36000s. Najnowsze preparation attempt005,
SHA `dc8e400802efcb25e745f175508950f093a83be2c3ddfd77937d98eebc12a268`.
Kanoniczny alias W na NVMe; wymagane87.3125GiB, przy przygotowaniu około219.6GiB
wolnego. [Instrukcja magazynu/startu](../../provenance/FT1536_DATA_STORAGE.md).
Przed startem ponownie sprawdź UUID, AC, miejsce, koniec innych prac i fresh
preflight. Nie uruchamiaj tylko dlatego, że przeczytałeś tę instrukcję.

## Co aktualizować po zmianie stanu

Po odebraniu retry zaktualizuj powyższą sekcję, CURRENT_TASK i indeks dowodów.
Po poprawkach MiMo zapisz dokładny wynik odbioru, a nie samo „model skończył”.
Po uruchomieniu dudect podaj faktyczny RUN/start/deadline, nie planowaną godzinę.
Nowy model ma odróżnić snapshot od stanu procesów na żywo.
