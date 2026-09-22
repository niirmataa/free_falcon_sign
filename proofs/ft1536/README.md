# FT1536 — wersjonowane punkty kontrolne dowodów

**Standard nowych rachunków2026-09-22:** autorytatywne pliki `.sage`
uruchamiane `sage lemma.sage` z preparserem. [Przypięte uzupełnienie](documents/FT1536_ZASADA_RACHUNKU_SAGEMATH_2026-09-22.md)
obejmuje nowe checkery i niezakończone T02.1/T03/S01; Python organizuje
wykonanie/manifesty/logi. Historyczne raporty i piny zachowują swój zakres.

Nowa sesja: [START_HERE](../../START_HERE.md).
**Główna ścieżka twierdzeń i jawna lista dalszych zadań:**
[ROADMAP](../../docs/onboarding/ROADMAP.md). Ten indeks opisuje checkpointy;
ROADMAP określa zależności i kryteria następnych prac.

To archiwum ukończonych etapów FT1536 w docelowym `free_falcon_sign`.
Każdy wpis `catalog/*.json` wskazuje konkretny raport, zewnętrzny pin
OUTPUTS oraz niezmienione bajty objęte tym manifestem.

Źródła projektu zachowują ścieżkę `Extra/c`; `FT1536` jest nazwą profilu/builda.
Kopie źródeł wewnątrz checkpointów dokumentują badane wersje i umożliwiają
replay. Integracja zaakceptowanej poprawki do źródeł odbywa się osobnym
commitem w `Extra/c`, bez przemianowania historycznego katalogu Extra.

**Aktywny build na main:** Extra/c zawiera teraz dokładnego kandydata L_RHO +
FLOOR_CT, manifest `56974571...`, użytego przez nowsze H3. Wcześniejsze
L_NTT/L_V/M0 zachowują własne piny i jawny transport. Komendy i pełna tożsamość:
[główny README](../../README.md) oraz
[proweniencja aktywnego builda](../../provenance/FT1536_ACTIVE_BUILD.md).

## Mapa dalszych działań

**[Zamrożony punkt pracy po M0](stages/FT1536_POST_M0_FREEZE_RUN_001/REPORT.md)**
jest obszernym zapisem stanu na aktywnym buildzie main `2959064`: źródła,
osiągnięcia, T2C3/T5, kontrakt M0, graf zależności i dalsze obowiązki.
Pakiet ma 211 członków OUTPUTS i 198 publicznych wejść Git, manifest
`c3efdcff510983a143946d43ab456656090061cd5b9b4b6847abc7f141c0cfa3`.
Jest checkpointem dokumentacyjnym (`replay=none`); obecnie archiwum zawiera
także dwadzieścia osiem etapów badawczych i audytowych, w tym późniejsze H3_RANGE,
H3_ZERO_SCALAR, H3_ROOT_LDL, H3_NODE3, H3_NODE2, BINARY_TOWER, audyt FPEMU,
FLOOR_CT, RAW_ASSEMBLY, STABLE_NORMALIZATION, INITIAL_TARGETS, ORDERED_REACH
i LEFT_ROOT_CORRELATED_TRANSFER, SOURCE_POSTPROCESSING_AND_PRECAST, SCALAR_KERNEL_IID
i SCALAR_GAUSSIAN_COMPARISON, ORDERED_JOINT_KERNEL, H6P_REFERENCE_BAD_EVENT
oraz przegląd FT_FAMILY_SCALING i IID_RETRY_COMPOSITION.

[Mapa po domknięciu L_V — 2026-09-19](documents/FT1536_MAPA_DALSZYCH_DZIALAN_PO_LV_2026-09-19.md)
przedstawia zależności i proponowaną kolejność: dokładny kontrakt gry,
osiągalność H3, pełne prawo Sign i bajty, spójna konsumpcja R5T, ciaśniejszy
transfer chi-square, symulacja ROM i końcowa kompozycja. Jest materiałem
do omówienia przed wyborem następnego zadania Astry.

Po omówieniu właściciel wybrał pojemność **4096 bajtów payloadu Sign**
(nonce 40 bajtów osobno) oraz **parametryczny** cel redukcji.
[Zlecenie M0](documents/FT1536_ZADANIE_ASTRA_M0_CONTRACT_2026-09-19.md)
zakończyło się wynikiem
[M0_CONTRACT_DEFINED_FOR_PINNED_CANDIDATE](stages/FT1536_M0_CONTRACT_RUN_001/REPORT.md).
Kontrakt, 22-wierszowy ledger i dowód payloadu STATIC <=3160 są gotowe.
Następny interfejs źródłowy to [H3](stages/FT1536_M0_CONTRACT_RUN_001/H3_INTERFACE.md).
M0 nie jest jeszcze dowodem końcowej redukcji ani integracją opakowania.

**Odebrany H3_RANGE:** [raport częściowy](stages/FT1536_H3_RANGE_RUN_001/REPORT.md)
zachowuje `PARTIAL_PROOF`. Niezależny replay odtworzył 96/96 plików i 49
twierdzeń. Lokalny proposal/floor/residual interface jest sprawdzony, a
`Reach_call_C -> CenterClass` pozostaje otwarty. [Odbiór](validation/2026-09-19-h3/README.md)
rozlicza negative zero, underflow oraz granice syntetycznych kontroli.
[Zlecenie](documents/FT1536_ZADANIE_ASTRA_H3_RANGE_2026-09-19.md) i
[publiczne wejścia](background/H3_RANGE_2026-09-19/README.md) zachowują piny.

**Odebrany H3_ZERO_SCALAR:** [wynik lokalny](stages/FT1536_H3_ZERO_SCALAR_RUN_001/REPORT.md)
ma status `H3_ZERO_SCALAR_PROVED_FOR_PINNED_MODEL`, z mieszaną warstwą
Lean/analityczny dowód źródłowy. Domknięto zero-aware floor/cast/s+z i
of/sub z E_r=E_res=2^-20 dla wszystkich NumericCenter, także obu zer
i subnormals. [Niezależny odbiór](validation/2026-09-19-zero-scalar/README.md):
95/95 plików, 17 modułów i 97 twierdzeń (48 nowych).
Na tym etapie `Reach_call_C -> NumericCenter` i prawo samplera pozostawały
otwarte; późniejszy LEFT_ROOT domyka pierwszy typ dla certyfikowanych legalnych
root/caller finite prefixes. Prawo samplera pozostaje odrębnym obowiązkiem.
[Zlecenie](documents/FT1536_ZADANIE_ASTRA_H3_ZERO_SCALAR_2026-09-19.md) oraz
[bootstrap](background/H3_ZERO_SCALAR_2026-09-19/README.md) zachowują piny.

**Odebrany H3_ROOT_LDL:** [raport](stages/FT1536_H3_ROOT_LDL_RUN_001/REPORT.md)
ma status `H3_ROOT_LDL_PROVED_FOR_PINNED_MODEL`. Wyprowadzono source
FFT/Gram, dodatni root denominator, L i subtractive Schur z
`32<Re(D_C)<2^31`, `abs(Im(D_C))<32`, wraz z conditional root frame.
[Niezależny odbiór](validation/2026-09-19-root-ldl/README.md): 131/131 plików,
17 modułów i 99 twierdzeń (17 nowych); pełna kompozycja jest mieszana
analityczna/kernelowa. [NEXT_INTERFACE](stages/FT1536_H3_ROOT_LDL_RUN_001/NEXT_INTERFACE.md)
określa dalszy certyfikat split_top/LDL_dim3 dla obu branches.

**Odebrany H3_NODE3:** [raport](stages/FT1536_H3_NODE3_RUN_001/REPORT.md)
ma status `H3_NODE3_PROVED_FOR_PINNED_MODEL`: jeden c3 dla obu branches
i wszystkich 256 slots, dodatnie pivots, L10/L20<2 i L21<4, osobne errors
i imaginary bounds, nowa domena div[1/16,2^35] oraz frame.
[Odbiór](validation/2026-09-19-node3/README.md): 123/123 plików, 21 modułów,
115 twierdzeń (16 nowych), z jawnym mixed proof scope.
[NEXT_INTERFACE](stages/FT1536_H3_NODE3_RUN_001/NEXT_INTERFACE.md) eksportuje
sześć diagonal branches do pierwszego split_deep/inner LDL2.

**Odebrany H3_NODE2:** [raport](stages/FT1536_H3_NODE2_RUN_001/REPORT.md)
ma status `H3_NODE2_PROVED_FOR_PINNED_MODEL`, dokładnie dla split9/LDL8,
2×3×128 positions. Nowe wyniki obejmują |Im(root D_C)|<1, kernelowy half
na wszystkich finite words i dodatnie computed pivots.
[Odbiór](validation/2026-09-19-node2/README.md): 160/160 plików, 26 modułów,
131 twierdzeń (16 nowych), z jawnym mixed proof scope.
[NEXT_INTERFACE](stages/FT1536_H3_NODE2_RUN_001/NEXT_INTERFACE.md) podaje
level7 i warunki dalszej kompozycji parametrycznego binary step.

**Odebrany BINARY_TOWER:** [raport](stages/FT1536_H3_BINARY_TOWER_RUN_001/REPORT.md)
ma status `H3_BINARY_TOWER_PROVED_FOR_PINNED_MODEL`: wszystkie levels7–1
oraz actual defined terminating execution12 raw inner7 subtrees.
[Odbiór](validation/2026-09-20-binary-tower/README.md):175/175 plików,
30 modułów,147 twierdzeń (16 nowych), mixed analytical/kernel scope.
[NEXT_INTERFACE](stages/FT1536_H3_BINARY_TOWER_RUN_001/NEXT_INTERFACE.md)
zachowuje pełny raw-loader assembly, stable normalization, targets i Reach
jako dalsze odrębne obowiązki.

**Odebrany audyt FPEMU:** [raport](stages/FT1536_FPEMU_AUDIT_RUN_001/REPORT.md)
ma status `CONFIRMED_ISSUE` w zakresie generic numeric fpr_lt(-0,+0)=1
i operand-dependent compiled floor branch przy GCC14.2/-O, również w Sign.
[Niezależny odbiór](validation/2026-09-20-fpemu-audit/README.md): 29/29 plików,
140225 scalar cases i 250 delta cases na tryb normal/ASan+UBSan, 29 historycznych
modułów Lean. W tamtym zamrożonym audycie dudect/ctgrind miały NOT_RUN.
[Bieżąca macierz wpływu](validation/2026-09-20-fpemu-audit/CURRENT_IMPACT.md)
rozlicza późniejszy NODE2 i BINARY_TOWER. Nie znaleziono kontrprzykładu do
badanych lokalnych arithmetic contracts; source pozostaje niezmienione.

**Późniejsza kampania dudect zakończona:** [raport baseline](background/FPEMU_FLOOR_CT_2026-09-20/DUD/REPORT.md)
zapisuje3 rundy/36 prób+6 controls,7h59m42s. Floor:9/9 LEAKAGE_FOUND;
pozostałe9 kontrastów:27/27 NO_LEAKAGE_EVIDENCE_YET; controls poprawne.
[Ponowne przeliczenie raw](background/FPEMU_FLOOR_CT_2026-09-20/DUD/RECEIPT_REVIEW.json)
odtworzyło wszystkie102 stany testów każdej partii dla9 floor probes i6 controls.
To [projekcja wejściowa](background/FPEMU_FLOOR_CT_2026-09-20/README.md),
nie pełny import raw wszystkich42 prób ani proof CT współdzielonego hosta.

**Odebrany kandydat FLOOR_CT:** [raport](stages/FT1536_FPEMU_FLOOR_CT_RUN_001/REPORT.md)
ma status `FLOOR_CT_CANDIDATE_VALIDATED_FOR_PINNED_BUILD`: all-word bit-equivalence
i definedness w jawnym GCC/LP64 modelu, pięć real machine regions i prespecified
A/B (baseline9/9 wykryć, candidate9/9 bez sygnału, controls6/6+6/6).
[Odbiór](validation/2026-09-20-floor-ct/README.md):235/235 plików,8 modułów,
41 twierdzeń (15 nowych),1065562 przypadki w normal/sanitizers i pełna
rekalkulacja9771 partii A/B. Nowy17-file pin56974571… jest w
stage/candidate; późniejsza integracja do Extra/c jest opisana w proweniencji
aktywnego buildu. Archiwalny baseline nadal ma pin2553358f…. Historyczne
source_integrated=false i zakresy twierdzeń pozostają niezmienione.

**Odebrany RAW_ASSEMBLY:** [raport](stages/FT1536_H3_RAW_ASSEMBLY_RUN_001/REPORT.md)
domyka actual raw prefix do powrotu ffLDL_fft3:6144 basis,18432 raw tree,
source order/totality/frame i emitted corollary. [Odbiór](validation/2026-09-20-raw-assembly/README.md):
195/195 plików,33 moduły,180 twierdzeń (33 nowych), mixed analytical/kernel scope.
Źródła mają pin56974571…; pełny normalized loader pozostaje odrębny.
[Uwagi do następnego typu](validation/2026-09-20-raw-assembly/NEXT_SCOPE.md)
rozdzielają P_key/raw computation od narrow stable gate acceptance i wymagają
źródłowego bridge obowiązkowego certificate udanego KeyGen.

**Odebrany STABLE_NORMALIZATION:** [raport](stages/FT1536_H3_STABLE_NORMALIZATION_RUN_001/REPORT.md)
domyka emitted gate bridge, actual1536 stored widths, source sqrt54/div/scaling
i preserved L/basis. [Odbiór](validation/2026-09-20-stable-normalization/README.md):
262/262 plików,40 modułów,230 twierdzeń (50 nowych), mixed proof boundary.
Stored sigma²∈(1.7763,575.9999), paired∈(2.3684,767.9999), literal dss obu
klas>1/1536. All-P_key definedness jest proved, narrow gate acceptance nadal
OPEN_NOT_DISPROVED. Source success event/K_seed pozostają te same.
Następne typy to INITIAL_TARGETS oraz osobny ORDERED_REACH→NumericCenter.

**Odebrany INITIAL_TARGETS:** [raport](stages/FT1536_H3_INITIAL_TARGETS_RUN_001/REPORT.md)
domyka actual target prefix1849–1892 dla wszystkich canonical c, nowy FFT18432
error<1/8192, oba reference/error layers i normalized-key frame.
[Odbiór](validation/2026-09-20-initial-targets/README.md):219/219 plików,
21 modułów,129 twierdzeń (30 nowych). Duża majoranta frequency t0 nie jest
scalar-center counterexample. Następny typ to ordered source Reach→NumericCenter.

**Odebrany ORDERED_REACH:** [raport](stages/FT1536_H3_ORDERED_REACH_RUN_001/REPORT.md)
zachowuje **PARTIAL_PROOF**. Pierwsza wykonywana prawa gałąź root ma forward
NumericCenter dla1536 active positions, finite |mu|<=156276714, przed floor.
[Odbiór](validation/2026-09-20-ordered-reach/README.md):225/225 plików,
28 modułów,179 twierdzeń (23 nowe), mixed analytical/kernel scope. Rozliczono
normal returns, rejection/nonreturn, sticky fault i conditional memory frames.
W tym pakiecie pozostał otwarty [LEFT_ROOT_CORRELATED_TRANSFER](stages/FT1536_H3_ORDERED_REACH_RUN_001/NEXT_INTERFACE.md),
wymagający source weighted residual/metric/root-gain bridge oraz zamkniętej lewej
gałęzi. Niezamknięta luźna majoranta nie jest błędem C ani required-domain
counterexample. [Zlecenie](documents/FT1536_ZADANIE_ASTRA_H3_ORDERED_REACH_2026-09-20.md)
i [bootstrap](background/H3_ORDERED_REACH_2026-09-20/README.md) zachowują piny.

**Odebrany LEFT_ROOT_CORRELATED_TRANSFER:** [raport](stages/FT1536_H3_LEFT_ROOT_CORRELATED_TRANSFER_RUN_001/REPORT.md)
domyka source bank/A2 budgets, raw-L/stable-D factor<6, right residual/root gain
i wszystkie left active centers. Kompozycja daje
**H3_ORDERED_NUMERIC_CENTER_PROVED_FOR_EMITTED_PINNED_MODEL**:
finite |mu|<=937866518, margins1209616765/1209616764, także raw−0.
[Odbiór](validation/2026-09-21-left-root-transfer/README.md):228/228 plików,
31 modułów,206 twierdzeń (27 nowych), normal/ASan/UBSan,700 terminal cases
i19968 local metric checks. Mixed source analytical/kernel boundary jest jawny;
historia ORDERED pozostajePARTIAL. [Zlecenie](documents/FT1536_ZADANIE_ASTRA_H3_LEFT_ROOT_CORRELATED_TRANSFER_2026-09-20.md)
i [579 wejść](background/H3_LEFT_ROOT_CORRELATED_TRANSFER_2026-09-20/README.md) zachowują piny.

**Następne obowiązki:** [SOURCE_POSTPROCESSING_AND_PRECAST oraz SOURCE_SAMPLER_LAW](stages/FT1536_H3_LEFT_ROOT_CORRELATED_TRANSFER_RUN_001/NEXT_INTERFACE.md).
Pierwszy dotyczy basis products/iFFT/rint/narrowing/bytes; drugi joint source
law i jego strat. Current-center proof nie daje whole Sign termination ani
pre-cast safety przez przyszłe norm acceptance.

**Odebrany SOURCE_POSTPROCESSING_AND_PRECAST:** [raport](stages/FT1536_H3_SOURCE_POSTPROCESSING_AND_PRECAST_RUN_001/REPORT.md)
zachowuje **PARTIAL_PROOF**, z subclaim
**H3_SOURCE_POSTPROCESSING_DEFINED_FOR_EMITTED_PINNED_MODEL**.
[Odbiór](validation/2026-09-21-postprocessing/README.md):616/616 plików,
102 moduły,795 twierdzeń (32 nowe),59 cases/build,32224 rint words i pełne
65536 signed16 codec values. Source iFFT error<=1/128, |w|<=4572095, exact
narrowing/stored norm/STATIC bytes. Uniwersalny Safe16 nadal OPEN_NOT_DISPROVED;
local65536→0 nie jest required-domain witness. [Następny typ](stages/FT1536_H3_SOURCE_POSTPROCESSING_AND_PRECAST_RUN_001/NEXT_INTERFACE.md):
SOURCE_SAMPLER_LAW/H6P, joint BadPrecast i osobny reference-integer/Sign→Verify bridge.

**Odebrany SCALAR_KERNEL_IID:** [raport](stages/FT1536_H3_SCALAR_KERNEL_IID_RUN_001/REPORT.md)
domyka exact scalar CDF/BerExp/rejection kernel **w jawnej grze IID_BUFFER**,
A>=1/256, PMF w_y/A, conditional fresh tail oraz tail/mean/resource bounds.
[Odbiór](validation/2026-09-21-scalar-kernel-iid/README.md):364/364 plików,
32 moduły,208 twierdzeń (37 nowych),4096 ptrs i54 exact PMFs. Pierwszy timeout
startu Sage zachowany. [Następne interfejsy](stages/FT1536_H3_SCALAR_KERNEL_IID_RUN_001/NEXT_INTERFACE.md)
rozdzielają PRNG_REAL_TO_IID_BUFFER, SCALAR_GAUSSIAN_COMPARISON i joint H6P;
idealizacja refill nie jest dowodem realnego PRNG lub whole Sign law.

**Odebrany SCALAR_GAUSSIAN_COMPARISON:** [raport](stages/FT1536_H3_SCALAR_GAUSSIAN_COMPARISON_RUN_001/REPORT.md)
daje w IID_BUFFER **TV(K_C,G)<=2^-36,chi2(K_C||G)<=2^-60**, dla G na całym Z
z actual mu/sigma words. Reverse chi2(G||K_C)=∞ ma jawny support reason.
[Odbiór](validation/2026-09-21-scalar-gaussian/README.md):516/516 plików,
36 modułów,234 twierdzenia (26 nowych),source-domain/normalizer/tail certificates,
101 rigorous comparisons i zachowane63 nominal overruns/scoped countermodels.
Ordered/shared-history composition z jawnymi reference exits znajduje się niżej;
sam lokalny bound nie jest whole-call loss,η_pre ani dowodem realnego PRNG.

**Odebrany ORDERED_JOINT_KERNEL:** [raport](stages/FT1536_H3_ORDERED_JOINT_KERNEL_RUN_001/REPORT.md)
domyka actual3072-call adaptive root law **w IID_BUFFER**, positive-prefix source
closure, a.s. root return, joint N/Y/revealed-byte law i zasoby.
[Odbiór](validation/2026-09-22-ordered-joint/README.md):359/359 plików,
114 modułów,884 twierdzenia (37 nowych),normal/sanitizer controls i exact QQ trees.
Dla jawnych Q_S/Q_stop: **TV(P,Q)<=2^-25,chi2(P||Q)<2^-48**, support exit<2^-50.
Q_S nie jest na ogół Q_stop conditioned on whole-call survival; reverse
chi2(Q_stop||P)=∞. E[T]<=24576, Pr[T>49152]<2^-1024, bez nowego source abortu.
Deterministic POST pushforward daje [typed H6P transfer](stages/FT1536_H3_ORDERED_JOINT_KERNEL_RUN_001/H6P_INTERFACE.md),
którego reference q domyka kolejny checkpoint poniżej. Realny PRNG,
retry/whole-call composition, universal Safe16 i Sign→Verify pozostają osobne.

**Odebrany H6P_REFERENCE_BAD_EVENT:** [raport](stages/FT1536_H6P_REFERENCE_BAD_EVENT_RUN_001/REPORT.md)
daje uniform **Q_S(BadPrecast)<=2^-119, P_IID(BadPrecast)<=2^-84 dla ONE ROOT**,
obu pre-narrow vectors i legalnej entry PAST. Source coefficientwise proxy
V<5462457 i pełny E<1095,conditional MGF z normalizerami/support cost,6144
signed tails oraz właściwy kierunek JOINT transfer są rozliczone.
[Odbiór](validation/2026-09-22-h6p-reference-bad-event/README.md):197/197,
73.819s,48 modułów/327 twierdzeń (26 nowych),pełne logs i niezależne QQ/RBF768
sprawdzenie arytmetyki. Zachowano coarse error≈3.681e9 jako luźny failed bound.
Późniejszy **IID_RETRY_COMPOSITION** poniżej domyka actual cap16/reached entries/
filtration i postprocessing w jednym regionie IID; whole real Sign nadal otwarty.

**T01 REVIEWED — PASS_SCOPED_REVIEW:**
[IID_RETRY_COMPOSITION](stages/FT1536_IID_RETRY_COMPOSITION_RUN_001/REPORT.md)
domyka jeden legalny post-H2P cap16 region w G_retry_IID:
**WholeRegionBad<=2^-80**,re-entry/fresh-tail,checked-precast coupling oraz
exact STATIC payload<=3160. Wspólny event H daje jednocześnie6352 blocks/
26017792 bytes i pozostałe budgets, z failure<2^-1020. Bad obejmuje obie
vectors również po norm rejection; bound nie jest conditional-on-success.
[Niezależny model wybrany przez właściciela](validation/2026-09-22-iid-retry-independent/README.md)
wykonał492/492,662.514s i review A–F,120 modułów/922 twierdzenia/26 nowych.
Prowadzący archiwizuje ten przekazany werdykt i pełne receipts, bez nowego
własnego review matematycznego/replayu. Dwa stale live INPUTS mają dokładne
sealed kopie; failed routes/overlap i mixed proof boundary zachowane.
[CURRENT_REVIEW_TASK](CURRENT_REVIEW_TASK.md) wiąże zewnętrzne piny odbioru;
[zlecenie](documents/FT1536_ZADANIE_ASTRA_IID_RETRY_COMPOSITION_2026-09-22.md)
i [1270 wejść](background/IID_RETRY_COMPOSITION_2026-09-22/README.md) pozostają
niezmienne. Następny T02 dotyczy real SHAKE/ChaCha→IID; H2P/whole real Sign,
integer recovery,Sign→Verify/security/CT są nadal osobnymi obowiązkami.

**Małe zadanie T02.1 dla kolejnego modelu:**
[CURRENT_SMALL_TASK](CURRENT_SMALL_TASK.md),39 przypiętych wejść,własny W.
Cel to deterministic init56/refill4096,actual Word layout,counter/frame i
consumer zasobów T01; pełny PRNG→IID bridge pozostaje OPEN. Niezależne od
S01/T03,ręczny start właściciela i późniejszy odbiór przez inny model.

**Zachowane opracowanie FT_FAMILY_SCALING modelu MiMo:**
[pakiet, PDF i wyniki](stages/FT_FAMILY_SCALING_REVIEW_RUN_001/README.md)
oraz [niezależna recenzja](stages/FT_FAMILY_SCALING_REVIEW_RUN_001/REPORT.md).
Status **RESEARCH_REVIEW_CHANGES_REQUIRED**. Potwierdzono4 moduły Lean,
14 nazwanych twierdzeń,5 odtworzonych JSON/CSV i12 kontroli portu FFT.
Zachowano43 manifest-listed pliki autora wraz z oryginalnym manifestem,
PDF/LaTeX, kodem i logami. Recenzja wskazuje m.in. kierunek redukcji, definicję
celów ROM, brakujące F przy trapdoor recovery, odrzucony SIS w szkielecie
estymatora oraz ujemny idealny test hipotezy chi-square.
[Indeks odbioru](validation/2026-09-22-ft-family/README.md) wiąże piny i zakres.
Archiwizacja obejmuje wartościowy wynik wymagający poprawek; nie podnosi go
do dowodu bezpieczeństwa lub gotowości FT768/FT3072. Dokumentacyjny
`replay=none` nie usuwa zachowanych niezależnych kontroli.

**Korekty S01 przygotowane na polecenie właściciela:**
[CURRENT_FAMILY_TASK](CURRENT_FAMILY_TASK.md) wskazuje nowy CORRECTIONS_RUN_003,
197 przypiętych wejść i istniejącą nowszą wersję autora jako nieodebrany input.
Zadanie domyka R1–R7 z old→new diffs i spójnym PDF/kodem/replayem; dopuszcza
jawne wycofanie wadliwego runnera R4 bez nowej kampanii. Ręczny start MiMo po
handoffie bieżących prac. Pozytywny odbiór innego modelu nadal warunkiem publikacji.

**Handoff MiMo/T03 — PARTIAL_PROOF / FROZEN_AWAITING_REVIEW:**
[CURRENT_MIMO_TASK](CURRENT_MIMO_TASK.md) wskazuje one-root reference integer
recovery. Autor deklaruje A/reference+mapping,C/rounding lemma,D conditional;
B-gap≈6086.4 pozostaje OPEN.85 OUTPUTS mają zgodne piny przekazane przez
właściciela. [Przygotowany odbiór](CURRENT_REVIEW_TASK.md) wymaga innego modelu,
własnego fresh replayu,rachunku `sage lemma.sage` i kontroli zmian freeze/portu.
[Kontrola prowadzącego](background/T03_REVIEW_PREPARATION_2026-09-22/README.md)
jest wyłącznie integralnościowa; subclaims nie otrzymały statusu REVIEWED.

Mapa pokazuje również całe historyczne ścieżki T2C3 i T5. Szczegółowe
publiczne opracowania z zachowanymi pinami:

- [ciągłość K0, uporządkowanej bazy i etapów T2C3](documents/FT1536_AUDYT_CIAGLOSCI_KLUCZA_BAZY_T2C3_2026-09-17.md);
- [późniejsza weryfikacja uzasadnienia D11E2](documents/FT1536_WERYFIKACJA_UZASADNIENIA_D11E2_2026-09-17.md);
- [mapa twierdzeń T2C3/T5 i ich publicznego pakietu](documents/FT1536_PAPER_TEZA_MAPA_DOWODOW_2026-09-17.md).

T2C3 dotyczy idealnego obrazu po ostrym obcięciu dla jednej kanonicznej
instancji; T5 jest odrębnym pure/untruncated twierdzeniem dla każdego
successful-KeyGen output. Datowane opracowania zachowują historyczny zakres;
aktualne domknięcie L_V kandydata opisuje tabela i sekcja poniżej.

## Układ

- `stages/<id>/`: wyłącznie OUTPUTS.sha256 i jego członkowie; bez cache,
  nieprzypiętego ogona dziennika i roboczych binariów;
- `objects/<sha256>`: publiczne wejścia wymienione w INPUTS, deduplikowane
  po treści; oryginalne ścieżki są zachowane w katalogu jako proweniencja;
- `catalog/<id>.json`: piny, status, mapa INPUTS i przepis replayu;
- `documents/`: czytelne kopie zleceń i notatek; historia istnieje w Git;
- `tools/archive.py`: import, odczytowa weryfikacja i izolowany replay;
- `work/`, `replay-work/`: lokalne, ignorowane obszary robocze.

Historycznych INPUTS, raportów i skryptów nie przepisuje się, aby zmienić
ich ścieżki. Weryfikator używa mapy oryginalne wejście → obiekt w repo.
Weryfikacja archiwum nie potrzebuje oryginalnych katalogów Dokumenty/H/USB.
Nie jest ona nowym dowodem matematycznym: raport zachowuje swój zakres i werdykt.

## Weryfikacja po pobraniu repo

### Zapisane etapy

| Etap | Werdykt / zakres | Commit checkpointu |
|---|---|---|
| L_V-STATIC | kontrprzykład do ustalonego Ext0 | `0b7cc0d` |
| Odbiór Blue | niezależne potwierdzenie kontrprzykładu | `bf4fb40` |
| L_RHO | poprawna normalizacja całej dziedziny int16 w przypiętym modelu | `5c2cdcc` |
| L_NTT | lokalne kontrakty i certyfikaty; globalna kompozycja częściowa | `1d78645` |
| L_NTT_GLOBAL | globalny inverse; na tym etapie forward_product pozostawało otwarte | `d67228d` |
| [L_NTT_FORWARD](stages/FT1536_L_NTT_FORWARD_RUN_001/REPORT.md) | **L_NTT_PROVED_FOR_PINNED_MODEL** — forward, iloczyn i pełna kompozycja | `71bbb35` |
| [L_V_BRIDGE](stages/FT1536_L_V_BRIDGE_RUN_001/REPORT.md) | **L_V_PROVED_FOR_PINNED_MODEL** — pełny most bajtowy Verify → Ext0 dla kandydata | `17f8f8b` |
| [M0](stages/FT1536_M0_CONTRACT_RUN_001/REPORT.md) | **M0_CONTRACT_DEFINED_FOR_PINNED_CANDIDATE** — gra, budżety, framing i dowód pojemności | `95f8015` |
| [H3_RANGE](stages/FT1536_H3_RANGE_RUN_001/REPORT.md) | **PARTIAL_PROOF** — lokalne floor/proposal/residual; globalna osiągalność otwarta | `cb99e67` |
| [H3_ZERO_SCALAR](stages/FT1536_H3_ZERO_SCALAR_RUN_001/REPORT.md) | **H3_ZERO_SCALAR_PROVED_FOR_PINNED_MODEL** — lokalny zero-aware most, błąd 2^-20; mieszany dowód | `9a76ecf` |
| [H3_ROOT_LDL](stages/FT1536_H3_ROOT_LDL_RUN_001/REPORT.md) | **H3_ROOT_LDL_PROVED_FOR_PINNED_MODEL** — source FFT/Gram, dodatni subtractive root pivot i frame; mieszany dowód | `3d6bf58` |
| [H3_NODE3](stages/FT1536_H3_NODE3_RUN_001/REPORT.md) | **H3_NODE3_PROVED_FOR_PINNED_MODEL** — uniform split_top/Adj/LDL3, obie branches i 256 slots; mieszany dowód | `afa52d8` |
| [H3_NODE2](stages/FT1536_H3_NODE2_RUN_001/REPORT.md) | **H3_NODE2_PROVED_FOR_PINNED_MODEL** — pierwszy binary level8, half i upstream imaginary refinement; mieszany dowód | `b27a055` |
| [FPEMU audit](stages/FT1536_FPEMU_AUDIT_RUN_001/REPORT.md) | **CONFIRMED_ISSUE** — generic signed-zero compare i compiled floor branch; timing NOT_RUN | `8bbab81` |
| [BINARY_TOWER](stages/FT1536_H3_BINARY_TOWER_RUN_001/REPORT.md) | **H3_BINARY_TOWER_PROVED_FOR_PINNED_MODEL** — levels7–1 i12 total raw subtrees; mieszany dowód | `1a04145` |
| [FLOOR_CT](stages/FT1536_FPEMU_FLOOR_CT_RUN_001/REPORT.md) | **FLOOR_CT_CANDIDATE_VALIDATED_FOR_PINNED_BUILD** — bit-preserving patch i kwalifikowana walidacja buildu; osobna integracja | `6ed89ca` |
| [RAW_ASSEMBLY](stages/FT1536_H3_RAW_ASSEMBLY_RUN_001/REPORT.md) | **H3_RAW_ASSEMBLY_PROVED_FOR_PINNED_MODEL** — pełny raw prefix, source transport i emitted corollary; mieszany dowód | `a53d723` |
| [STABLE_NORMALIZATION](stages/FT1536_H3_STABLE_NORMALIZATION_RUN_001/REPORT.md) | **H3_STABLE_NORMALIZATION_PROVED_FOR_EMITTED_PINNED_MODEL** — actual widths/gates i source sqrt/div; mieszany dowód | `6c233cd` |
| [INITIAL_TARGETS](stages/FT1536_H3_INITIAL_TARGETS_RUN_001/REPORT.md) | **H3_INITIAL_TARGETS_PROVED_FOR_EMITTED_PINNED_MODEL** — canonical target prefix, source errors i frame; mieszany dowód | `99ceb98` |
| [ORDERED_REACH](stages/FT1536_H3_ORDERED_REACH_RUN_001/REPORT.md) | **PARTIAL_PROOF** — right-root finite-prefix NumericCenter, outcome/frame; left correlated transfer otwarty | `7664277` |
| [LEFT_ROOT_CORRELATED_TRANSFER](stages/FT1536_H3_LEFT_ROOT_CORRELATED_TRANSFER_RUN_001/REPORT.md) | **H3_LEFT_ROOT_CORRELATED_TRANSFER_PROVED_FOR_EMITTED_PINNED_MODEL** — left transfer i kompozycja pełnego zero-aware root/caller finite-prefix NumericCenter; mieszany dowód | `fbf4a5c` |
| [SOURCE_POSTPROCESSING_AND_PRECAST](stages/FT1536_H3_SOURCE_POSTPROCESSING_AND_PRECAST_RUN_001/REPORT.md) | **PARTIAL_PROOF** — operational suffix/iFFT/rint/norm/bytes domknięte; uniwersalny Safe16 otwarty | `481e62b` |
| [SCALAR_KERNEL_IID](stages/FT1536_H3_SCALAR_KERNEL_IID_RUN_001/REPORT.md) | **H3_SCALAR_KERNEL_PROVED_FOR_PINNED_IID_BUFFER_MODEL** — exact conditional kernel, A>=1/256 i fresh-tail/resources; real-PRNG bridge otwarty | `6f1f34c` |
| [SCALAR_GAUSSIAN_COMPARISON](stages/FT1536_H3_SCALAR_GAUSSIAN_COMPARISON_RUN_001/REPORT.md) | **H3_SCALAR_GAUSSIAN_COMPARISON_BOUND_PROVED_FOR_PINNED_IID_BUFFER_MODEL** — local TV/forward chi2; reverse∞ i joint scope jawne | `64af4cb` |
| [ORDERED_JOINT_KERNEL](stages/FT1536_H3_ORDERED_JOINT_KERNEL_RUN_001/REPORT.md) | **H3_ORDERED_JOINT_KERNEL_PROVED_FOR_PINNED_IID_BUFFER_MODEL** — adaptive root/source closure, directed comparison/resources/POST transfer; reference BadPrecast probability otwarte | `22e6dd4` |
| [FT_FAMILY_SCALING review](stages/FT_FAMILY_SCALING_REVIEW_RUN_001/REPORT.md) | **RESEARCH_REVIEW_CHANGES_REQUIRED** — zachowany pakiet MiMo, sprawdzone lemmas/layout/obliczenia; korekty game/reduction i zakresów | `0c1ddc1` |
| [H6P_REFERENCE_BAD_EVENT](stages/FT1536_H6P_REFERENCE_BAD_EVENT_RUN_001/REPORT.md) | **H6P_REFERENCE_BAD_EVENT_BOUND_PROVED_FOR_PINNED_IID_BUFFER_MODEL** — source map/V/E/MGF i joint tail Q_S<=2^-119, one-root IID<=2^-84 | `1ba7ae0` |
| [IID_RETRY_COMPOSITION / T01](stages/FT1536_IID_RETRY_COMPOSITION_RUN_001/REPORT.md) | **IID_RETRY_COMPOSITION_PROVED_FOR_PINNED_IID_BUFFER_MODEL** — one post-H2P cap16 IID region,WholeRegionBad<=2^-80,coupling/resources/bytes; independent PASS_SCOPED_REVIEW | `a2cdf317` |

Identyfikatory starszych lokalnych commitów są rozliczone w
[mapie historii publikacji](history/README.md).

### Aktualny wynik L_NTT

Checkpoint FORWARD domyka ostatnią globalną przesłankę poprzedniej kompozycji.
W `formal/Complete.lean` końcowe twierdzenie ma postać:

```text
FT1536Forward.L_NTT : ∀ h r c,
  CanonVec h → CanonVec r → CanonVec c →
  pipelineC h r c = (product h r, subtract (product h r) c).
```

Iloczyn pozostaje niezależnym iloczynem współczynnikowym z `remMonomial`.
Dowiedziono ewaluacji forward w fizycznym porządku `3i+j`, `forward_product`,
zakresów oraz podstawienia L_RHO dla wszystkich signed int16.
Pełne typy i termy dowodowe są w
[AuditTypes.stdout](stages/FT1536_L_NTT_FORWARD_RUN_001/logs/final/AuditTypes.stdout).
Powiązanie z C99/GCC/LP64 i warunki buforów określa
[CLAIM](stages/FT1536_L_NTT_FORWARD_RUN_001/CLAIM.md).

Odbiór odtworzył **63 moduły, 472 twierdzenia (109 nowych)** i **217/217**
plików znaczeniowych ze świeżej kopii archiwum:
[zapis kontroli FORWARD](validation/2026-09-18-forward/README.md).

### Aktualny wynik L_V

[Zadanie mostu L_V](documents/FT1536_ZADANIE_ASTRA_L_V_BRIDGE_2026-09-19.md)
zostało domknięte w checkpointcie **L_V_BRIDGE**. Dla wszystkich canonical h,c
i legalnych skończonych ciągów bajtów b w przypiętym modelu:

```text
V_CAND(h,c,b)=1 =>
  s(b) i Ext0 są zdefiniowane,
  z1+h*z2=c modulo(q,Phi),
  Q(z1,z2)<2093922385,
  gdzie (z1,z2)=Ext0(h,c,b)=(center_q(c-h*s(b)),s(b)).
```

Dowód konsumuje L_NTT_rho i domyka centrowanie C, znak Ext0, dokładną normę
int64, ścisły próg, dekodery NONE/STATIC, guards i przygotowanie klucza.
Obejmuje uint32 wrap dowolnie długiego skończonego unary i narrowing GCC;
nie dodaje limitu 2049 bajtów. Eksporty formalne: `L_V_BYTES`, `L_V_LOADED`,
`L_V_SOURCE`; [dokładna teza i model](stages/FT1536_L_V_BRIDGE_RUN_001/CLAIM.md).

Odbiór odtworzył **73 moduły, 570 twierdzeń (104 nowe), 402/402 pliki**,
w tym kontrole C/Lean/Sage i ASan/UBSan:
[zapis kontroli L_V](validation/2026-09-19-lv/README.md).

`full_L_V_proved=true` dotyczy wyłącznie kandydata `falcon-vrfy.c` o SHA-256
`3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42`.
Historyczny raport zachowuje wykonawcze `source_integrated=false` i
`owner_accepted=false`; późniejsza integracja tego dokładnego kandydata
na main jest odrębnym zdarzeniem opisanym w proweniencji aktywnego builda.
Historyczny kontrprzykład S17 i wcześniejsze wyniki częściowe zachowują swoje
zakresy. Pełne L_V nie zamyka samplera, rozkładu kluczy, EUF-CMA, MT-ISIS
ani warunkowych transferów strat redukcji.

### Kontrakt i pojemność po M0

[GAME](stages/FT1536_M0_CONTRACT_RUN_001/GAME.md),
[RESOURCE_MODEL](stages/FT1536_M0_CONTRACT_RUN_001/RESOURCE_MODEL.md) i
[HOP_LEDGER](stages/FT1536_M0_CONTRACT_RUN_001/HOP_LEDGER.md) definiują
parametryczny klasyczny cel EUF-CMA. Własne obowiązki źródłowe i rozkładowe
mają jawne statusy; `security_reduction_proved=false`.

Nowy [dowód pojemności](stages/FT1536_M0_CONTRACT_RUN_001/CAPACITY.md) daje
po zdefiniowanym source norm acceptance payload STATIC <=3160 bajtów,
więc wybrany bufor 4096 wystarcza. Syntetyczny short vector wymaga 3156:
stare pojemności 2049 i 3073 nie wystarczają uniwersalnie. Nonce40 jest osobno.
[Odbiór M0](validation/2026-09-19-m0/README.md) odtworzył 273/273 pliki,
67 modułów i 535 twierdzeń (43 nowe), wraz z normal/ASan/UBSan.

### Wynik częściowy H3_RANGE

Lokalne wyniki obejmują support propozycji `[-365,366]`, floor refinement
w jawnej domenie, right-before-left i 3072 calls oraz error-aware residual
lemmas. `fpr_floor(-0)=-1` narusza mathematical-floor equality, lecz samo nie
powoduje overflow s+z. Przykłady underflow wymagają modelu rzeczywistego FPEMU.
Nie wykazano osiągalności tych syntetycznych przypadków z emitted KeyGen.

[REACHABILITY](stages/FT1536_H3_RANGE_RUN_001/REACHABILITY.md) i
[ledger](stages/FT1536_H3_RANGE_RUN_001/BOUND_LEDGER.md) zachowują pełny cel:
zero/domain invariant, internal LDL pivots/L, machine-error transfer i
emitted/loader refinement pozostawały tam otwarte; późniejsze etapy powyżej
domykają wskazane nowe interfejsy, zachowując historyczny status. Odbiór odtworzył 8 modułów,
49 nowych twierdzeń oraz 96/96 plików; [receipts](validation/2026-09-19-h3/README.md).

Odtwarzanie z czystego checkoutu Git i ukrytymi oryginałami sprawdzono
2026-09-18: [zapis kontroli](validation/2026-09-18/README.md).

Z katalogu głównego repo, Python 3.11 lub nowszy (biblioteka standardowa):

```sh
python3 -B proofs/ft1536/tools/archive.py list
python3 -B proofs/ft1536/tools/archive.py verify
python3 -B -m unittest discover -s proofs/ft1536/tests -v
```

Polecenie verify sprawdza zewnętrzne piny w katalogu, wszystkie członki
OUTPUTS, dokładny zbiór plików archiwum oraz wszystkie zarchiwizowane INPUTS.
Nie traktuje zgodnych hashy jako potwierdzenia pełnego L_V.

## Odtwarzanie obliczeń

Przykład dla lokalnego L_RHO:

```sh
python3 -B proofs/ft1536/tools/archive.py replay FT1536_L_RHO_RUN_001 --run replay-001 --hide-originals
```

Analogicznie dla `FT1536_LV_STATIC_RUN_001`, `FT1536_L_NTT_RUN_001`,
`FT1536_L_NTT_GLOBAL_RUN_001`, `FT1536_L_NTT_FORWARD_RUN_001`
i `FT1536_L_V_BRIDGE_RUN_001`, `FT1536_M0_CONTRACT_RUN_001`
oraz `FT1536_H3_RANGE_RUN_001`, `FT1536_H3_ZERO_SCALAR_RUN_001`
i `FT1536_H3_ROOT_LDL_RUN_001`, `FT1536_H3_NODE3_RUN_001`
oraz `FT1536_H3_NODE2_RUN_001`, `FT1536_FPEMU_AUDIT_RUN_001`
i `FT1536_H3_BINARY_TOWER_RUN_001`, `FT1536_FPEMU_FLOOR_CT_RUN_001`
oraz `FT1536_H3_RAW_ASSEMBLY_RUN_001`, `FT1536_H3_STABLE_NORMALIZATION_RUN_001`
i `FT1536_H3_INITIAL_TARGETS_RUN_001`, `FT1536_H3_ORDERED_REACH_RUN_001`
oraz `FT1536_H3_LEFT_ROOT_CORRELATED_TRANSFER_RUN_001`.
Wpis katalogu określa właściwy punkt wejścia. Odbiór Blue jest archiwum
recenzji i receipts; nie ma zadeklarowanego pojedynczego pełnego runnera.

Runner tworzy świeżą kopię pod `replay-work/<id>/<run>/`, przywraca roboczy
COMMANDS wyłącznie z zamrożonego prefiksu, a następnie uruchamia przypięty
skrypt replayu z oczekiwanym hashem OUTPUTS. Root sandboxa jest read-only,
zapis dozwolony tylko w tej świeżej kopii, sieć odłączona. Opcja
`--hide-originals` dodatkowo ukrywa historyczne Dokumenty i H, jeśli istnieją.
Katalog uruchomienia musi być nowy. Wszystkie logi i wynik pozostają w nim,
również przy błędzie lub przekroczeniu limitu. Archiwum pozostaje read-only.

Wynik operacji zawiera status historycznej tezy osobno od wyniku replayu:
udane odtworzenie `PARTIAL_PROOF` nadal jest wynikiem częściowym.

### Przypięte środowisko

Pełne replaye wymagają Linux x86_64 LP64, GCC 14.2.0, Python 3, bwrap,
SageMath 10.9 i Lean 4.34.0/Std. Zachowane skrypty używają ścieżek:

```text
/home/footfalcon/.local/bin/sage
/home/footfalcon/miniforge3/envs/sage/bin/python
/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean
```

Te narzędzia i ich środowiska trzeba udostępnić pod zapisanymi ścieżkami.
Repo nie zawiera dystrybucji kompilatorów ani menedżerów pakietów i niczego
nie instaluje. Inne wersje lub mapowanie narzędzi trzeba opisać jako osobną
konfigurację odtworzenia, zachowując oryginalne piny.

## Import następnego etapu

Po zakończeniu pracy, zamrożeniu OUTPUTS i otrzymaniu hashy w przekazaniu:

```sh
python3 -B proofs/ft1536/tools/archive.py import /ABSOLUTE/COMPLETED_STAGE \
  --manifest-sha MANIFEST_SHA256 --report-sha REPORT_SHA256 \
  --replay standard
python3 -B proofs/ft1536/tools/archive.py verify COMPLETED_STAGE
```

`standard` oznacza sprawdzony protokół `scripts/replay.py DEST OUTPUTS_SHA`,
z DEST pod tmp świeżej kopii. Dla dawnego L_V użyj `--replay lv-static`;
dla GLOBAL z jego przepisem pre-freeze `--replay global-crt`, a dla pakietu
bez takiego runnera `--replay none`. Przed wyborem protokołu
przeczytaj REPLAY danego etapu. Inne nazwy raportu/JSON podaje się przez
`--report` i `--result`.

Jeżeli standardowy pakiet przechowuje historyczny receipt w innej lokalizacji,
podaj `--replay-receipt RELATIVE_PATH`, np. `artifacts/rehearsal/REPLAY_RESULT.json`.
Ścieżka i wszystkie wskazane wyniki muszą być zapieczętowane przez OUTPUTS.
Obsługiwane są zarówno rekordy path/sha256, jak i expected/actual/match;
w drugim formacie wymagane są zgodne hashe i dosłowne match=true. Każdy
świeży wynik jest nadal sprawdzany bajtowo z archiwum, bez zmiany starego pakietu.

Adapter `global-crt` pomija w świeżym seed wyłącznie dawny podkatalog replay/
i metadane jego odtworzenia, które skrypt tworzy ponownie. Pominięcia są
wymienione w receipt. Wrapper przed wykonaniem weryfikuje pełne archiwum,
a po wykonaniu porównuje cały wykaz i bajty plików znaczeniowych ze
**zarchiwizowanym** receipt. Sam nowy napis PASS nie wystarcza.

Importer kopiuje tylko jawne członki manifestu i publiczne zadeklarowane
wejścia, weryfikuje hashe, odrzuca symlinki i ucieczki ścieżek. Nie nadpisuje
etapu inną wersją: nowy wynik wymaga nowego identyfikatora. Powtórzenie
identycznego importu tylko sprawdza już zapisany checkpoint.

Zlecenie/notatkę można dołączyć czytelną kopią:

```sh
python3 -B proofs/ft1536/tools/archive.py document /ABSOLUTE/TASK.md --sha SHA256
```

## Commit po każdym zakończonym zadaniu

1. Sprawdzić raport, status i piny. Zachować dokładnie `PROVED`,
   `PARTIAL_PROOF`, kontrprzykład albo blokadę — bez zmiany znaczenia.
2. Zaimportować zamknięty pakiet oraz zlecenie; uruchomić verify.
3. Wykonać kontrole właściwe dla nowych narzędzi lub zmienionego replayu.
4. Sprawdzić `git status`, diff roboczy/staged i `git log --oneline -10`.
5. Dodać wyłącznie pliki danego etapu i utworzyć osobny commit, np.
   `proof: record L_NTT partial proof checkpoint`.
6. Podać hash commita obok hashy raportu i OUTPUTS w przekazaniu użytkownikowi.

Docelowa gałąź to lokalny **main**. Jeśli checkpoint powstał na innej gałęzi,
po sprawdzeniu przenieś go fast-forward, o ile historia na to pozwala.
Przy zajętym roboczym indeksie użyj osobnego worktree do operacji na main.
Rozbieżnej historii nie nadpisuj. Push pozostaje osobnym poleceniem właściciela.

Nowe zadania mogą używać `proofs/ft1536/work/<id>/` jako sandboxa obliczeń.
Ta robocza zawartość jest ignorowana; po zakończeniu zadania importer zapisze
jej zamrożony zakres pod stages/, a następny commit obejmie ten checkpoint.

Przy wcześniejszych staged zmianach używać dokładnych pathspeców i
`git commit --only -- <własne ścieżki>`. Jeden wykonawca operuje na indeksie.
Obecnie prowadzący sesję wykonuje commit po sprawdzeniu raportu Astry.
Jeśli obowiązek przejmie Astra, musi otrzymać ten zakres i odpowiedni dostęp
do repo; sandbox samego obliczenia nadal powinien obejmować tylko jego W.

Commit checkpointu nie integruje kandydata z Extra/c ani nie nadaje
owner acceptance. Każde kolejne zadanie dodaje się po zamknięciu
odpowiedniego punktu kontrolnego. Aktywnego drzewa nie migruje się podczas
zapisu przez wykonawcę.
