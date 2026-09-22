# Główna ścieżka twierdzeń i jawny rejestr zadań FT1536

Wersja planu: **2026-09-22 / 1**. To żywy plan prowadzącego, oparty na
[M0 TARGET_TYPE](../../proofs/ft1536/stages/FT1536_M0_CONTRACT_RUN_001/TARGET_TYPE.md)
i [M0 HOP_LEDGER](../../proofs/ft1536/stages/FT1536_M0_CONTRACT_RUN_001/HOP_LEDGER.md).
Nie zmienia zamrożonego M0 ani statusów starych raportów. Stan pracy na żywo:
[STATE](STATE.md). Szczegółowe źródła fundamentów: [PROOF_MAP](PROOF_MAP.md).

## 1. Cel główny

Zbudować instancję parametrycznego **M7 dla klasycznego EUF-CMA/direct-output
ROM**, wiążąc rzeczywisty profil C z dokładnymi grami, wspólnym prawem klucza,
obserwowanymi bajtami i budżetami przeciwnika. Wynik ma wskazywać jawne
założenia kryptograficzne, kierunki porównań, straty i koszty reduktora.

To nie obietnica bezwarunkowego bezpieczeństwa. MT-ISIS i właściwości PRG
pozostaną jawnymi założeniami; trzeba udowodnić poprawność redukcji do nich.
Koszt ataku z estymatora nie zastępuje takiej redukcji. Publiczny bit-XOF/H2P,
QROM, wdrożenie wrappera i CT mają osobne zadania.

## 2. Graf głównych twierdzeń

```text
L_RHO → L_NTT → L_V ------------------------------------→ ekstrakcja M6
                    M0: gra, jeden K_seed[E], framing, zasoby
                     │
ROOT/NODE/TOWER/RAW → NORMALIZED → TARGETS → ORDERED+LEFT
                     │                        │
                     └──────────→ POST ←──────┘
SCALAR_IID → SCALAR_GAUSSIAN → ORDERED_JOINT → H6P
                                              │
                                 T01 IID_RETRY (W TOKU)
                                              │
             T02 RNG/zasoby ────┬──── T03 integer/correctness
                               │
               T04 prefix/API + T05 geometria/prawo globalne
                               │
                  T06 rzeczywiste bajty / complete kernels
                               │
            T07 ideal norm/retry ↔ T08 image/R5T fresh freeze
                               │
                 T09 wspólne image kernels/transfer
                               │
         T10 public sampler + T11 freshness + T12 ROM simulator
                               │
              T13 indexed extraction/MT-ISIS/resources
                               │
                       T14 kompozycja M7
```

Strzałki pokazują zależności dowodowe, nie pozwolenie na pominięcie kosztów.
Kolejność hybryd bezpieczeństwa określa ordered ledger M0, nie kolejność
wykonywania prac. T02 można badać równolegle matematycznie z T03, ale zadania
uruchamia właściciel, każde we własnym W. T07/T08 nie mogą zakładać nawzajem
swoich nieudowodnionych wyników: interfejsy trzeba rozdzielić przed startem.

## 3. Fundamenty już odebrane — nie wykonywać od początku

| ID | Zespół wyników | Status i granica |
|---|---|---|
| F01 | L_RHO/L_NTT/L_V | PROVED w przypiętym modelu: accepted bytes→witness; brak odwrotnej implikacji z samego L_V |
| F02 | M0 | Kontrakt zdefiniowany; auxiliary capacity/framing proved; końcowy theorem nadal cel |
| F03 | ROOT_LDL/NODE3/NODE2/BINARY_TOWER/RAW_ASSEMBLY | Source arithmetic/domain/layout certificates w ich zakresach |
| F04 | STABLE_NORMALIZATION/INITIAL_TARGETS | Emitted normalized widths i canonical target prefix; all-P_key gate gap zachowany |
| F05 | ORDERED_REACH + LEFT_ROOT_TRANSFER | Pełne ordered NumericCenter przez późniejszą kompozycję; historyczny ORDERED pozostaje PARTIAL |
| F06 | SOURCE_POSTPROCESSING_AND_PRECAST | Operational suffix/bytes proved; historyczny status PARTIAL, universal Safe16 otwarte |
| F07 | SCALAR_KERNEL_IID/SCALAR_GAUSSIAN | Conditional scalar law, świeży unread tail, local directed comparison; IID only |
| F08 | ORDERED_JOINT_KERNEL |3072-call adaptive law, positive-prefix closure, resource bounds i POST pushforward; one root |
| F09 | H6P_REFERENCE_BAD_EVENT | Q_S≤2^-119, P_IID≤2^-84 dla joint obu pre-narrow vectors, one root; mixed proof |

Dokładne statusy, piny i świadectwa odbioru są w katalogu stages/validation.
F01–F09 to grupy orientacyjne; nie jeden zbiorczy nowy status PROVED.

## 4. Rejestr dalszych zadań — główny tor

**Statusy:** `PREPARED_OWNER_START` = przypięty TASK/W gotowy, czeka na ręczny start;
`IN_PROGRESS` = istnieje wyznaczony wykonawca; `PLANNED` = cel
zaplanowany, bez upoważnienia do startu; `REVIEWED` dopiero po niezależnym
odbiorze. Zależność oznacza wymagany interfejs, nie pozwolenie na założenie tezy.

| ID / status | Dokładny cel i wejścia | Wyjście wymagane do odbioru | Zależności |
|---|---|---|---|
| **T01 IN_PROGRESS — IID_RETRY_COMPOSITION** | Actual post-H2P region, reached entries,16 attempts, reset/fault/norm/codec; F04–F09 | Source-bound applicability H6P przy każdej osiągniętej próbie, WholeRegionBad, coupling, a.s. IID region return i zasoby. Kandydat≤2^-80 dopiero po dowodzie | F04–F09; obecny TASK |
| **T02 PLANNED — PRNG_REAL_TO_IID_BUFFER** | Dokładny root SHAKE32→stream i state56/ChaCha/refills/getters; skończone ghost budgets | Jawne gry, resource-indexed assumptions i reduktory/hybrid losses; zachowana wspólna historia, init/discards/abandoned tails. Nie „448-bit security” | T01 resources, F02,F07,F08 |
| **T03 PREPARED_OWNER_START — REFERENCE_INTEGER_RECOVERY** | Source rounded sampler/basis/iFFT/rint oraz independent reference integer object; osobny one-root TASK MiMo | Warunki i dowód recovery/congruence/rounding gap; wyprowadzone, a nie założone. Osobno Safe16, centered extraction i norm compatibility; partial/counterexample możliwe | F03–F09; T01 do rozszerzenia na retries |
| **T04 PLANNED — PREFIX_AND_API_BINDING** | Pominięty przez T01 prefix: context/loader/rng_ready/nonce/H2P, usługi E i actual source outcomes | Dokładny zasięg definedness/termination/abort, legal ReadyRetryEntry z API i joint randomness interfaces. Brak ukrytego all-success lub IID premise | F02–F05,T01; T02 dla real-law claims |
| **T05 PLANNED — GLOBAL_REFERENCE_GEOMETRY** | Actual parameters/tree/rounding oraz wybrane ordered reference law | Most do zadeklarowanego ideal coset Gaussian, z błędami/geometrią/secret dependence; Q_S/Q_stop nie stają się nim przez nazwę | F08,F09,T03; historyczny FULL_GEOMETRY |
| **T06 PLANNED — COMPLETE_OBSERVED_BYTE_KERNELS** | Source/production/reference kernels, retries, bytes i bot outcomes | Jeden kompletny history-uniform consumer od funkcjonującego API do wskazanego prawa obserwacji; Sign→Verify tylko po T03 i właściwym center/norm bridge | T01–T05,F01,F02,F06 |
| **T07 PLANNED — IDEAL_NORM_RETRY** | Ideal16-attempt kernel G16 i strict norm acceptance | Porównanie G16→Gacc, acceptance mass i empty-coset/bot accounting dla wymaganych h,c/historii; bez podmiany przez continuous chi-square heurystykę | T05, dokładny interfejs T08 |
| **T08 PLANNED — IMAGE_R5T_CONSISTENT_FREEZE** | Historyczne T2C3/T5/R5T, właściwa populacja K_seed/Emitted i accepted image P_h^B | Nowy spójny immutable pakiet i uniform image theorem z rzeczywistymi przesłankami; stare rozbieżne hashe zachowane; fixed-key nie podmieniony na population | F02; jawna niezależna definicja accepted reference z T05/T07 |
| **T09 PLANNED — IMAGE_COMMON_KERNEL_TRANSFER** | R_fresh/S_fresh, to samo K_seed,E,nonce,bot,bytes i image bound | Właściwa absolute continuity/kierunek miary, wspólne pełne kernels, history-adaptive transfer i jego loss | T06–T08; H1R/image ledger |
| **T10 PLANNED — BOUNDED_PUBLIC_SAMPLER** | Publiczne D^B bez sekretu, transport bajtowy | Konkretny bounded public algorithm, jego distribution error/cost i rozłączny timeout/budget ownership | T05–T08,F02 |
| **T11 PLANNED — ROM_FRESHNESS** | Jeden klucz, r40, wspólna tablica H, adaptive queries i abort observations | Collision/prequery coupling z właściwym uniform nonce hop i kosztami; bez conditioning na brak kolizji za darmo | T02,T04,F02; interfejs T06 |
| **T12 PLANNED — CLASSICAL_ROM_SIMULATOR** | Public sampler, freshness, kompletne observed kernels | Simulator z SeenSign także dla aborts, programowaniem i ≤Q_H+1 indexed targets; pełne koszty i błędy | T09–T11,F02 |
| **T13 PLANNED — INDEXED_MT_EXTRACTION** | M6 simulator + L_V i dokładna gra MT-ISIS | Accepted forgery→świadek TEGO SAMEGO target index; jawna assumption MT i t_B,w_B,L_B. Nie potrzebuje inverse encoding do tego kierunku | T12,F01,F02 |
| **T14 PLANNED — M7_FINAL_COMPOSITION** | Wszystkie zatwierdzone certificates/hops/resources | Instancja M0ReductionTarget: jawny końcowy wzór, raz p_K, brak double-count, scope klasycznego ROM; lista pozostających assumptions | T02–T13 |

**Najbliższa kolejność prowadzącego:** odebrać T01, następnie dopracować TASK
T02; T03 ma już osobny przygotowany one-root TASK dla MiMo. Nie jest to obietnica wyniku T01
ani automatyczny start T02. Każdy wiersz może wymagać kilku checkpointów.

### Obowiązkowy krok przy rozwijaniu T05/T06/T09/T14

Stary M0 ledger zawiera H3_LIKELIHOOD(P→M) i H1R(M→Q), natomiast nowe
F07–F09 dostarczają inne jawne reference processes i directed bounds.
Przed kompozycją trzeba napisać **mapę stary wiersz→nowy certyfikat**, wskazać
wiersze zastępowane, pozostające oraz niepokrywające się koszty. Nie sumować
obu tras „na wszelki wypadek” ani uznawać nowego one-root boundu za kompletne
M2/M3. Aktualny proof path może zmienić postać końcowego ledgeru tylko jawnie.

## 5. Tory równoległe i cele poza pierwszym M7

| ID / status | Cel | Warunek odbioru / zależności |
|---|---|---|
| S01 CHANGES_REQUIRED — MiMo family scaling | Poprawki R1–R7 już zapisanej pracy | Nowa wersja + pełny niezależny odbiór; warunek właściciela przed jakąkolwiek publikacją |
| S02 DEFERRED_OWNER_START — dudect RUN_002 |10h scalar timing na FLOOR_CT | Świeży preflight, pełne raw/controls/replications; interpretacja scoped, brak sygnału≠CT proof; bez proof jobs równolegle |
| S03 PLANNED — M0_WRAPPER_INTEGRATION | r40/STATIC4096 i API/framing deployment | Osobne upoważnienie integracji, source/tests/refinement; obecny stary CLI nie jest wrapperem M0 |
| S04 PLANNED — PUBLIC_XOF_H2P | Real public bit-output SHAKE/H2P vs pierwszy direct-output ROM | Jawna publiczna gra, domain interactions/private use i loss; nie darmowa domain separation |
| S05 PLANNED — QROM | Quantum oracle/reduction target | Osobny cel i proof assumptions; nie przenosić klasycznej symulacji bez dowodu |
| S06 PLANNED — ATTACK_ESTIMATES | Diagnostic P1/P2/subfield costs | Poprawne gry/metriki/populacje, pinned estimator, pełne inputs/outputs; zależy od S01; nie proof security |
| S07 PLANNED — FULL_IMPLEMENTATION_CT | Zakres rzeczywistej implementacji/kompilacji/platformy | Osobny threat model i dowody/kontrole; dudect ani floor patch nie domykają całości |
| S08 PLANNED — PLATFORM_BINDING | Usługi OS/entropy/lifetimes do publicznego E | Jawne założenia/środowisko/refinement; theorem modelu E nie jest automatycznie theorem dowolnego OS |

S03/S08 są potrzebne do odpowiednio szerokiego claimu wdrożeniowego; S04/S05
rozszerzają model pierwszego M7. S01 jest bramką publikacji z decyzji właściciela,
nie przesłanką matematyczną H6P. Nowe profile FT768/FT3072 są badaniami poza
gotowością aktualnego FT1536; dalsze zadania dopisuj po odbiorze S01.

**Rozwinięcie T03 do ręcznego startu MiMo:**
[wskaźnik W/pinów i pełnego TASK](../../proofs/ft1536/CURRENT_MIMO_TASK.md).
Zakres jednego root pozwala badać ten obowiązek niezależnie od aktywnego T01
Astry. S01 pozostaje osobnym obowiązkiem korekt i bramką publikacji.

## 6. Jak rozwijamy wpis, zamiast wymyślać nowy plan co sesję

Każdy nowy TASK zaczyna się od `ROADMAP_ID=Txx/Sxx` i zawiera:

1. **Twierdzenie docelowe:** kwantyfikatory, entry/domain, probability game,
   from-law/to-law, metric/direction, observations i zasoby.
2. **Przesłanki:** lista odebranych certificates z pinami; oddzielnie nowe
   obowiązki i założenia kryptograficzne. Brak wpisywania celu jako premise.
3. **Artefakty:** claim/certificate/ledger/source bindings, formal/checkers,
   exact inputs, controls, failed routes i replay protocol.
4. **Kryterium odbioru:** co pozwala na PROVED w określonym zakresie; czego brak
   oznacza PARTIAL lub BLOCKED; membership dla counterexample.
5. **Ownership:** jeden wykonawca, nowy W, start przez właściciela i handoff.
6. **Consumer:** następny wiersz planu, który faktycznie użyje wyniku.

T01 ma już frozen zadanie sprzed wprowadzenia ROADMAP_ID; mapowanie zapisano
tutaj, bez przepisywania jego pinów. W razie potrzeby podział: T02.1,T02.2 itd.
Parent pozostaje otwarty, dopóki suma subclaims nie zamknie jego interfejsu.
Po partial nie przechodź dalej przez założenie brakującego lematu.

## 7. Zmiana planu i statusu

Zmianę zapisuj w tym dokumencie w lokalnym commicie: data, stary wpis, powód,
nowe zależności, wpływ na twierdzenie i polecenie właściciela jeśli wymagane.
Zamrożonych raportów nie aktualizuj. Po odbiorze dopisz do wiersza link do
checkpointu, exact status, validation i commit; STATE oraz CURRENT_TASK
muszą wskazywać ten sam aktywny etap.

### Dziennik

- 2026-09-22/v1: scalono istniejący M0 ledger i najnowszy łańcuch H3/H6P
  w jawny rejestr F01–F09,T01–T14,S01–S08 na polecenie właściciela.
  T01 pozostaje aktywnym zadaniem; niczego nowego nie uruchomiono.
- 2026-09-22: właściciel doprecyzował, że pilot MiMo ma być nowym obowiązkiem
  głównego toru, nie korektami Family. Wybrano T03 one-root, własny W/TASK,
  bez zakładania wyniku T01. Anulowany szkic S01 pozostał lokalnym materiałem.
- 2026-09-22: odbiór matematyczny i replay zwrotów właściciel powierza innemu
  modelowi; ten prowadzący przygotowuje zadania oraz prompty odbioru.
