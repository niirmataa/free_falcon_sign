# Stan projektu — punkt wejścia

**Aktualizacja2026-09-22:** T01 niezależnie odebrany w `a2cdf317`;
następnie właściciel poprosił o zadanie korekt S01 przed publikacją.
Historyczne obserwacje procesów/dudect poniżej pochodzą z około04:33 CEST.
Stan procesów jest ulotny: sprawdź go ponownie przed pracą. Ten dokument
aktualizujemy po odbiorze etapu, zmianie wykonawcy lub decyzji właściciela.

Główna kolejka zadań i kryteria: [ROADMAP](ROADMAP.md).
Astra: **T01 REVIEWED**, następny **T02 PLANNED**; osobny MiMo = **T03**,
poprawki Family = **S01 PREPARED_OWNER_START_AFTER_HANDOFF**, dudect = **S02**.

## Decyzje właściciela

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
  i ręcznego polecenia. T03 jest osobnym przygotowanym zadaniem MiMo.
- Granica: nie ma boundu Bad|success bez success denominatoru. Real PRNG,H2P,
  whole real Sign,integer recovery,Sign→Verify/security/CT pozostają otwarte.

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
wskazuje **T03 / one-root REFERENCE_INTEGER_RECOVERY**, PREPARED_OWNER_START,
osobny nowy W i jednego ręcznego wykonawcę. S01 i blokada publikacji pozostają
otwarte. Nieuruchomiony szkic CORRECTIONS_RUN_002 zachowano lokalnie jako anulowany.

**Nowsze polecenie właściciela po odbiorze T01:** przygotować zadanie MiMo,
które domknie Family przed push. [CURRENT_FAMILY_TASK](../../proofs/ft1536/CURRENT_FAMILY_TASK.md)
wskazuje nowy **CORRECTIONS_RUN_003**,197 przypiętych wejść i handoff do istniejącego
okna MiMo. Uwzględniono znaleziony nowszy autorski FAMILY_SCALING_2026-09-22_RUN_002
jako UNREVIEWED snapshot (42 pliki,manifest5ee71952…); R4 nadal deklarowane OPEN.
W czasie przygotowania widziano procesy kampanii estymatora we własnym W;
nie zatrzymano ich ani nie uruchomiono kolejnego workera. Start S01 następuje
po kontrolowanym handoffie bieżących prac MiMo. T03 zachowuje swoje W i TASK;
brak nowego końcowego handoffu/odbioru T03. Publikacja nadal wstrzymana.

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
