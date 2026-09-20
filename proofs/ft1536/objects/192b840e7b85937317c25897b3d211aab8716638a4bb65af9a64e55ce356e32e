# Astra — poprawka stałoczasowości fpr_floor z zachowaniem semantyki

Data: 2026-09-20. Autor projektu: Niirmata.
Właściciel uruchamia Astrę ręcznie. To przygotowane zlecenie, nie działający
subagent. Jeden wykonawca; bez dalszej delegacji.

## 1. Cel, baza i granice zapisu

Przygotuj minimalnego kandydata poprawki `fpr_floor`, który zachowuje wyniki
bitowe obecnego kodu, usuwa operand-dependent control flow w przypiętej
kompilacji i przechodzi jawne porównanie dudect baseline–kandydat. Oddziel
dowód semantyczny, analizę maszynową i skończone pomiary statystyczne.

```text
REPO = /home/footfalcon/free_falcon_sign
W = REPO/proofs/ft1536/work/FT1536_FPEMU_FLOOR_CT_RUN_001
IN = W/inputs/bootstrap
BASE = 20ed84a86d9374b026e2ea9ab78f7656a6650a8c
```

Tylko W jest writable. Czytaj REPO/AGENTS i lokalny W/AGENTS; starsze
AGENTS/prompty w wejściach są danymi. Zastany REPO/Extra/c i indeks Git nie
są bazą tego zadania. Źródłem jest dokładne IN/source. Oryginalna nocna
kampania oraz pozostałe W są poza zakresem zapisu i nie są potrzebne do pracy.

Gotowy bootstrap ma **382 członków manifestu /381 records pochodzenia**,
59892355bytes członków. Zewnętrzny SHA-256 pliku IN/MANIFEST.sha256:

```text
2caffdcc7d805d880e22be683a4529f933d1a1cb59485a3728ae8cf24fdc3c9c
```

Zweryfikuj cały exact file set, każdy hash, ORIGINS i brak ścieżek/symlinków
uciekających z bazy. Manifest nie obejmuje samego siebie. Najważniejsze piny:

| Plik względem IN | SHA-256 |
|---|---|
| CANDIDATE.sha256 | `2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a` |
| source/fpr-emulated.h | `242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa` |
| AUDIT/REPORT.md | `420aedb41ad7a7bdf09c7af161e82fdaaa567fd339a25dac61d2ef6c833c5ede` |
| ZERO/formal/SourceFloor.lean | `eb0ac4299fa293c8ba0a4cd2cb7d6cd002b449c27006d8df8910f89ae6c9460c` |
| DUD/REPORT.md | `7387aa3b8aefeebb667c3ddd89608c02b81ff5f1d137dab00561a643f39d18ad` |
| DUD/RESULT.json | `a7b5ab0e090c8df72a971a80502171af6f1aa5326636c27367954cc5e14b8ec4` |
| DUD/RECEIPT_REVIEW.json | `b6b93a306823d314de38fe376a1489ba20ba40a57ba9baa70a4e422aca8f73d8` |
| vendor/dudect.h | `3fb3b2bd7f9e17ae34b7c92518c1311c67342c56facc80da925d85f121b649da` |
| harness/benchmark.c | `dd06a9f8f310c6de2ed1778c0abbdaa31eecf2690f7b06a422b638e0e3649b64` |

## 2. Punkt wyjścia i znaczenie istniejących wyników

AUDIT/FINDINGS i TIMING_REVIEW: GCC14.2/-O wyemitował gałąź zależną od
encoded exponent<1022, czyli dla finite danych od |x|<1/2. Występuje ona
w scalar wrapperze oraz w oryginalnym falcon-sign TU: BerExp, sampler
i sampler_large. Komentarz Makefile „CT-safe” oraz CT_BEREXP nie są dowodem
stałego czasu primitive ani całego Sign.

Nocny dudect zakończył wszystkie3 rundy w7h59m42s na CPU9:
- trzy kontrasty floor wykryły sygnał w9/9 próbach; końcowe max|t|≈118–150;
- pozostałe9 kontrastów: NO_LEAKAGE_EVIDENCE_YET w27/27, bez proof CT;
- positive controls3/3 wykrywały różnicę, negative3/3 bez sygnału, po33–35mln
  nieprzyciętych próbek na klasę; host był współdzielony, częstotliwość zmienna.

DUD/ zawiera wszystkie42 receipts i snapshots. Prowadzący ponownie
przeliczył z raw gzip wszystkie per-batch stany102 testów dla9 floor probes
i6 controls; wszystkie15 odtworzyło się dokładnie. Był to ten sam przypięty
silnik w trybie --replay, nie nowy pomiar ani niezależna metoda statystyczna.
Pełne raw9 floor i3 positive controls są w bootstrapie. Duże raw3 negative
controls oraz raw/stdout27 pozostałych prób mają jawną zewnętrzną inventory;
nie są członkami bootstrapu. W tej sesji pracuj na dostarczonej projekcji
i własnych nowych kontrolach. Nie nazywaj jej pełnym archiwum całej kampanii.

## 3. Dopuszczalny patch

Skopiuj17 wejściowych źródeł do W/candidate/source. IN i baseline są RO.
Domyślny zakres: wyłącznie ciało `fpr_floor` w fpr-emulated.h. Minimalny
lokalny helper lub compiler barrier w tym samym pliku jest dopuszczalny,
jeżeli jest konieczny, uzasadniony i objęty modelem/analizą zależności.
Zachowaj sygnaturę i kontrakty callerów oraz pokaż dokładny unified diff.

Wszystkie pozostałe16 plików pozostają byte-identical; Makefile/flags,
fpr_lt, half, sampler, parametry i tablice nie są przedmiotem tej poprawki.
Zachowaj historyczną atrybucję Falcon/Pornin i oznacz wkład FT1536.
Nie integruj patcha do REPO/Extra/c, worktree main lub historycznych stages.

Główny profil pozostaje GCC14.2.0-19/C99/Linux x86_64 LP64, dokładne
`-W -Wall -O` i makra z IN/source/Makefile. Nie zastępuj naprawy zmianą -O,
march/LTO, pragma/attribute ukrywającym inną optymalizację, samym noinline
w harnessie, wyciszeniem ostrzeżeń, opóźnianiem zależnym od danych lub zmianą
obserwowanych operand classes. Nie używaj timing reads, secret-indexed tables
lub hardware double floor zamiast kontraktu FPEMU.

Preferuj portable C. Jeśli potrzebny jest minimalny GCC compiler barrier:
opisz dokładnie jego template, operands/clobbers, semantykę identity,
warunki LP64/architektury i wpływ na portability. Nie zakładaj identity
arbitralnego inline asm jako aksjomatu wyniku. Rozlicz związek z konkretnymi
instrukcjami i zachowaniem GCC; wynik może dotyczyć tylko tego builda.

## 4. Równoważność — obowiązek centralny

Pełny cel to bit-exact replacement na **wszystkich2^64 input words** dla
jawnego modelu C99/GCC/LP64, nie tylko dwóch fixtures lub positive normals:

```text
∀ raw : Word64,
  Defined_LP64(floor_old, raw) ∧ Defined_LP64(floor_candidate, raw)
  ∧ result_long_bits(floor_candidate, raw) = result_long_bits(floor_old, raw).
```

Ustal i udowodnij range/representation facts obu programów: int/long/int64,
unsigned wrap, masks, signed right shift w wybranym modelu GCC, count ranges,
casts i brak nowego UB. NaN/Inf words są tutaj surowymi bitami, nie argumentem
twierdzenia o matematycznej funkcji floor. Nie wykonuj dla nich niedozwolonych
konwersji hardware FP w oracle.

W ZERO/formal/SourceFloor.lean jest literalny raw model `floorC`; jego
NumericCenter consumer ma już proof. `Floor.lean/floorParts` ma ograniczony
kontrakt wykładników i Nat subtraction — nie rozszerzaj go bez dowodu na
wszystkie Word64. Zwiąż własny nowy model z rzeczywistym starym i nowym C,
zamiast definiować candidate jako old i dowodzić refleksyjnego równania.

W szczególności zachowaj:
- `floor(+0)=0`, **`floor(-0)=-1`**;
- zachowanie raw subnormals i wszystkich granic exponent/shift;
- dla NumericCenter `floor_candidate = floorVal − eps0`, z eps0=1 tylko
  dla raw negative zero, oraz istniejące source_floor_range/C_INT_BRIDGE.

NumericCenter oznacza finite Word64 o wartości
`-2147483283 ≤ val(x) < 2147483282`. Zachowaj zero-aware kontrakt ZERO i
jego pozostałe przesłanki. Nie „naprawiaj” -0 do matematycznego floor0;
byłaby to odrębna zmiana semantyki i modelu Sign.

Udowodnij relację old/candidate w Lean4.34/Std na odpowiadających modelach,
z jawnym source bindingiem. Jeśli uniwersalne2^64 pozostanie otwarte, podaj
dokładnie udowodnioną domenę i status partial; testy nie zastępują tej tezy.
Nowe/edytowane moduły: czysty pełny log, types/terms/#print axioms; bez
sorry/admit/native_decide/Lean.ofReduceBool i aksjomatu wniosku. Reused źródła
przypnij i przebuduj; adaptacje w nowych kopiach z diffem. Nie twierdź, że
modelowy proof formalnie zweryfikował GCC lub całą semantykę C.

## 5. Niezależne kontrole semantyczne

Użyj exact integer/dyadic oracle i osobno literalnego baseline C. Porównaj
baseline, candidate i model na obu znakach, wszystkich2048 exponent values
z uzasadnionym zestawem skrajnych/tie/carry mantissas oraz co najmniej10^6
reprodukowalnych publicznych Word64. Uwzględnij exponent1021/1022, cc=0/31/32/
63/64 oraz negative cc, ±0, min/max subnormal/normal, integer boundaries
i końce NumericCenter. Seed to jawna stała testowa, nie sekret projektu.

Uruchom te same fixtures w normal C oraz ASan/UBSan; source-definedness
raw-word floor rozlicz przed testami. Host double i dwa warianty tych samych
instrukcji nie są jedynym oracle. Sprawdź istniejący publiczny fpemu_smoke.
Dodaj meaningful mutation controls: błędna obsługa -0, nieprawidłowy
shift/mask boundary i no-op. Nie wywołuj KeyGen/private loader/Sign lub
pełnego test_falcon. Zachowaj również nieudane kandydaty i ich wyniki.

## 6. Wygenerowany kod — rzeczywisty zakres CT

Zbuduj osobno baseline i candidate z identycznymi aktywnymi flags, bez
sanitizerów w timing build. Zachowaj argv, include/source binding, versions,
preprocessed/dependency evidence, .o/.s/disassembly i hashes. Binaria/cache
są robocze pod W; do freeze zachowaj reprodukowalne źródła i receipts.

Przeanalizuj scalar wrapper oraz **oryginalny falcon-sign.c TU**, z jego
rzeczywistymi inline call sites w BerExp, sampler i sampler_large. Zrób
inwentaryzację wszystkich aktywnych floor calls. Nie wystarczy usunąć `js`
w jednym wrapperze: wyklucz każdy operand-dependent conditional jump,
indirect target i memory index w całej poprawionej operacji i jej helpers.
Rozróżnij stałe/publiczne branches/loop counters od zależnych od raw input.
Sprawdź również wprowadzenie instrukcji o zależnej latencji, np. integer div.

Wymagany jest konkretny code/taint argument dla tych bajtów maszynowych,
nie grep jednej mnemoniki lub samo source maskowanie. Nie przypisuj temu
proof wszystkich mikroarchitektur, wszystkich kompilatorów lub całego
samplera/Sign. Rejection loops, PRNG/refill i caller reachability są odrębne.

## 7. Prespecified dudect A/B — osobny bounded runner

Użyj niezmienionego IN/vendor/dudect.h, commit
`dc269651fb2567e46755cfb2a13d3875592968b5`. IN/harness/benchmark.c i targets.c
pozostają identyczne dla obu wariantów; różni się wyłącznie header kandydata
w include path. Zachowaj klasy0..4, generator, warmup, chunk64, batch100000,
sink i thresholds silnika. Nie zmieniaj liczby operacji na callback.

Stary prepare.py przypina stary manifest, a launch.py uruchamia starą8h
kampanię; nie stosuj ich jako gotowego buildera kandydata. Napisz w W nowy
driver A/B z jawnie przypiętymi wejściami i reuse/diff względem harnessu.
Mechanika lossless raw logging/ACK z campaign.py może być skonsumowana po
przeglądzie; nie modyfikuj IN ani starego runu.

Plan potwierdzający ustal **przed jego pierwszym pomiarem**, po zamrożeniu
finalnego candidate hash:

1. Trzy rundy r=0,1,2; cases w kolejności1,0,2,3,4 (positive control,
   negative floor, positive fixed floor, negative fixed floor, randomized
   signed floor). Każdy case na baseline i candidate.
2. Dla r0/r2 kolejność baseline→candidate, dla r1 candidate→baseline.
   Oba warianty otrzymują tę samą publiczną kolejność `order_for(r,case)`
   z przypiętego harnessu; każda runda ma inny public order.
3. Każda próba≤60s, globalny budżet kampanii≤1800s obejmujący zapis/obsługę;
   jeden worker naraz, batch watchdog120s. Silnik kończy próbę na swoim
   LEAKAGE_FOUND; pozostały harmonogram zachowuje się bez strojenia.
4. Dla candidate floor i obu negative controls wymagane co najmniej10^6
   nieprzyciętych próbek na klasę, o ile wcześniej nie znaleziono sygnału.
   Zapisuj rzeczywiste n0/n1, wszystkie102 stany testów, percentiles,
   warunki stopu i pełny stdout/stderr/raw, nie tylko końcowe max|t|.
5. Positive controls muszą wykrywać różnicę; współczesny baseline floor
   powinien odtworzyć znany sygnał. Negative-control leakage, zbyt małe n,
   brak baseline sensitivity lub interference oznacza INCONCLUSIVE danego
   porównania. Nie wybieraj korzystnej rundy i nie kasuj nieudanych prób.

Przed pomiarami zakończ własne kompilacje/Lean/replaye. Zapisz aktualną
topologię, affinity/non-SMT core, governor/turbo/frequency, CPU/microcode/
kernel, zasilanie i obciążenie przed/po. CPU9 historycznie był non-SMT,
ale nowy wybór potwierdź. Udokumentuj, czy host jest współdzielony; samo
taskset nie jest rezerwacją rdzenia. Nie wykonuj uprzywilejowanych trwałych
zmian OS. Jeśli realny sandbox/host nie pozwala na wiarygodny pomiar,
zakończ semantykę i analizę assemblera z timing NOT_RUN/INCONCLUSIVE.

Pomiary wykonuj przez rzeczywisty sandbox W-only writable, network-off;
ewentualny czasowy inhibitor sleep/idle ma własny receipt i cleanup.
Ogranicz zapis logów jak w baseline2MiB/s poza timed region, zachowując
wszystkie próbki. Nie zostawiaj nieograniczonego procesu po handoffie.
Eksploracyjne wcześniejsze warianty mają osobne receipts; nie przerabiaj
wyniku już wykonanego potwierdzającego planu na PASS przez retry/zmianę progu.

## 8. Wpływ na dowody, interfejsy i law

IMPACT_MATRIX ma rozliczać L_RHO/L_NTT/L_V, M0, ZERO, ROOT, NODE3, NODE2,
BINARY_TOWER i otwarte loader/normalization/targets/Reach/Sign-law.
Wskaż użycia floor oraz lemmas niezależne od niego. Header hash zmieni się:
stare certyfikaty pozostają prawdziwymi zapisami starego pinu; transport do
nowego wymaga jawnego bridge, nie podmiany hashy w historycznym raporcie.

Udowodnij/uzasadnij, w jakim zakresie bit-equivalence i brak nowych effects
zachowują source outputs, error/abort branches i pobór losowości przy tych
samych publicznie modelowanych coins. Osobno oceń K_seed conditioning,
Sign-law i resource/cost/ABI/portability. Nie zakładaj identycznego runtime
z identyczności wyniku. M0 wyłącza timing z obserwacji; nie dopisuj nowego
epsilon, nowej gwarancji CT lub dowodu całego schematu.

Known fpr_lt(-0,+0)=1 pozostaje osobnym ustaleniem audytu. Nie rozszerzaj
tego patcha na naprawę comparatora, -0, half, sampler-law albo proof Reach.

## 9. Wykonanie, replay i artefakty

AGENTS nie jest sandboxem. Potwierdź rzeczywisty W-only write scope;
IN/baseline RO, candidate/source writable. HOME/TMPDIR/DOT_SAGE/LEAN_PATH,
cache/olean/bin pod W. Skończone limity; normal8GiB, Lean4.34/Std -j1 -M2048,
ASan osobno z przestrzenią shadow (LSan nie deklaruj, jeśli detect_leaks=0).
Sage10.9 przez `sage plik.py ...`, jeśli potrzebny. Bez instalacji, sieci,
Git, innych agentów, sekretów/.private/private_extraction, nowych kluczy,
prywatnych seedów/współczynników oraz KeyGen/private loader/Sign.

Wymagane:
- REPORT.md, RESULT.json, CLAIM.md, PATCH.diff, candidate/CANDIDATE.sha256
  (17 nazw względem candidate/source) i pełna kopia candidate/source;
- SEMANTICS.md, EQUIVALENCE.md, SOURCE_MODEL_BINDING.md, formalne źródła
  i pełne types/terms/axioms/logs, REUSED_RESULTS.md;
- ASSEMBLY_REVIEW.md + machine-readable call-site/control-flow ledger,
  SEMANTIC_CHECKS.json, MUTATION_CONTROLS.json, IMPACT_MATRIX.md;
- TIMING_PLAN.json, TIMING_REPORT.md, wszystkie run/control receipts,
  surowe dane, ich format/order/hashes i strumieniowy checker replay;
- INPUTS.sha256, TOOLCHAIN.txt, COMMANDS.log, OUTPUT_SCOPE.md, REPLAY.md,
  SEMANTIC_FILES.json, OUTPUTS.sha256; ścisły manifest bez przypadkowych
  cache/olean/bin/sekretów, z pełnym zachowaniem prób nieudanych.

Duże raw/log streams zachowaj bezstratnie w częściach≤32MiB, z kolejnością,
całkowitym rozmiarem i SHA-256 pełnego strumienia oraz reprodukowalnym
reassemblerem/checkerem. To podział przechowywania, nie subsampling lub
odrzucanie outliers. Umożliwia późniejszy byte-exact checkpoint Git.

Standard: `python3 -B scripts/replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256`.
Przed nowym DEST sprawdź external pin i cały manifest. Fresh build/Lean
oraz deterministyczne kontrole mają semantic matches(path,sha256); porównuj
również statystyki odtworzone z zapisanych raw. Ponowne fizyczne pomiary są
osobnym trybem, nie obietnicą identycznych czasów/t-statistics. Nie uruchamiaj
ich automatycznie w standardowym replayu. Rehearsal ma osobną kotwicę bez
hash cycle; po freeze zapis tylko do nowego DEST, bez dopisywania do pakietu.

## 10. Kryteria statusu i handoff

`FLOOR_CT_CANDIDATE_VALIDATED_FOR_PINNED_BUILD` wymaga łącznie:
1. jawnej all-Word64 source-model równoważności i definedness, z kernelowym
   dowodem relacji i właściwym source bindingiem;
2. normal/ASan/UBSan + niezależnego oracle/mutation checks;
3. usunięcia operand-dependent control-flow/memory w wrapperze i wszystkich
   rzeczywistych floor sites przypiętego builda, z pełnym ledgerem;
4. trzech porównań/rund w niezmienionych klasach, poprawnych controls,
   odtworzonego baseline signal, bez sygnału candidate przy wymaganym n;
5. nowego pinu, impact/transport matrix, manifestów i fresh replay.

Ten status jest kwalifikowaną walidacją jednego kandydata/buildu, nie proof
stałego czasu hardware, całego backendu lub Sign. Wynik na współdzielonym
hoście ma jawny exploratory timing scope.

Przy brakach: `PARTIAL_CANDIDATE` z dokładnymi proved/open domains lub
timing NOT_RUN/INCONCLUSIVE; `CANDIDATE_REJECTED` z reproducerem konkretnej
wady; `EXECUTION_BLOCKED` z rzeczywistym logiem przeszkody. Brak sygnału
sam w sobie nie pozwala nadać pełnego statusu.

RESULT osobno zapisuje: candidate_source_changed, changed_files,
all_word64_equivalence_proved, source_definedness_proved,
compiled_floor_control_flow_fixed, semantic_checks, sanitizer_checks,
timing_status, timing_host_scope, baseline_signal_reproduced,
candidate_signal_detected, proof_kind i compiler_binding_scope.
Ponadto production_source_changed=false, new_source_patch_integrated=false,
owner_accepted=false, full_backend_ct_proved=false, full_sign_ct_proved=false,
H3_range_proved=false, global_reachability_proved=false,
sampler_law_proved=false, security_reduction_proved=false.

Zakończ raportem po polsku: dokładny patch i zakres, dowód/różnice, wyniki
kontroli i A/B, ograniczenia oraz REPORT/OUTPUTS SHA-256. Prowadzący wykona
niezależny odbiór i osobno rozstrzygnie integrację. Zakończ na handoffie.
