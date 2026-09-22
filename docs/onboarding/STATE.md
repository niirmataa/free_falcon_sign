# Stan projektu — punkt wejścia

**Snapshot: 2026-09-22, około04:33 CEST**, repo HEAD przed utworzeniem tego
zestawu: `7d567bd992ef040dc79ebf0c47aa6a8fff7a3758`.
Stan procesów jest ulotny: sprawdź go ponownie przed pracą. Ten dokument
aktualizujemy po odbiorze etapu, zmianie wykonawcy lub decyzji właściciela.

Główna kolejka zadań i kryteria: [ROADMAP](ROADMAP.md).
Bieżąca Astra = **T01**, poprawki MiMo = **S01**, dudect = **S02**.

## Decyzje właściciela

- **Publikacja czegokolwiek na GitHub wstrzymana**, aż MiMo poprawi
  FT_FAMILY_SCALING i poprawiona wersja przejdzie pozytywny niezależny odbiór.
  Późniejszy push nadal wymaga osobnego polecenia. Przy tym snapshotcie main
  był11 commitów przed origin/main; sprawdź aktualny Git, nie kopiuj tej liczby.
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

H6P: niezależny replay **197/197**,73.819s;48 modułów Lean/327 twierdzeń,
26 nowych. Osobne QQ/RBF768 sprawdzenie rachunku. V<5462457,E<1095.
Dowód mieszany source/analytical/kernel; nie pełna kernelizacja kompilatora/C.
Nie daje universal Safe16, real-PRNG bridge, retry composition, integer recovery
ani Sign→Verify. Pełne exact rationals są istotne dla końcowego wykładnika.

Raport i odbiór:
- [H6P REPORT](../../proofs/ft1536/stages/FT1536_H6P_REFERENCE_BAD_EVENT_RUN_001/REPORT.md)
- [H6P validation](../../proofs/ft1536/validation/2026-09-22-h6p-reference-bad-event/README.md)

## Aktywne zadanie Astry — NIE STARTUJ DRUGIEGO WYKONAWCY

`FT1536_IID_RETRY_COMPOSITION_RUN_001`, przygotowanie `c4e9d35`.

- W: `proofs/ft1536/work/FT1536_IID_RETRY_COMPOSITION_RUN_001/`.
- [TASK w repo](../../proofs/ft1536/documents/FT1536_ZADANIE_ASTRA_IID_RETRY_COMPOSITION_2026-09-22.md).
- TASK SHA: `f773b8f31f7d307850ee3d1eb948bb05ceacee5589d5c4971e3eaee34c5bed97`.
- Bootstrap SHA: `daa95bc07516271ff897f95af11b3c90950ccb1a7dc20f0f3da5e994785a46b8`;
  1270 plików/1268 origins; BASE `1ba7ae07c17d135fc8eff4aac7b56f8c2b3bc88c`.
- Cel: od jednego legalnego post-H2P entry wyprowadzić re-entry/fresh-tail,
  actual16-attempt scheduler/norm/codec, WholeRegionBad, coupling i zasoby.
- Przy snapshotcie: **IN_PROGRESS, nieodebrane**. Istnieją formal/scripts/logs
  oraz robocze STOPPED_COMPOSITION/RESOURCE_BOUND; brak końcowego REPORT/OUTPUTS.
  Robocza liczba2^-80 nie jest jeszcze odebranym twierdzeniem.

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
