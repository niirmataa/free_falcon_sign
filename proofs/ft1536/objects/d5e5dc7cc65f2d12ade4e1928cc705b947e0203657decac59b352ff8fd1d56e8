# FT1536 L_NTT_GLOBAL — raport GPT-ASTRA

Data zadania: 2026-09-18. Autor projektu: Niirmata.
W: `/home/footfalcon/Dokumenty/FT1536_L_NTT_GLOBAL_RUN_001`.

## 1. Werdykt

**PARTIAL_PROOF. Domknięto globalny INVERSE_GLOBAL konkretnego modelu
sekwencyjnych pętli in-place i zinstancjowano inverse_forward. FORWARD_GLOBAL
i forward_product pozostają otwarte, więc pełne L_NTT nie jest dowiedzione.**

To nowy globalny wynik względem poprzedniego PARTIAL_PROOF, nie tylko ponowne
sprawdzenie lokalnych macierzy. Nie znaleziono kontrprzykładu w canonical
dziedzinie. Ograniczone testy nie rozstrzygają brakującej uniwersalnej tezy.

`source_integrated=false`, `owner_accepted=false`, `full_L_V_proved=false`.
Źródło, N,q,Phi,Q,B, dziedziny i profil full ternary secret/COMP_STATIC zachowano.

## 2. Przypięta baza

- źródło falcon-vrfy.c:
  `3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42`;
- manifest17 plików kandydata L_RHO:
  `2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a`;
- PREV/REPORT:
  `b89d618d7c1d3992fa1a9ea0ae8c84dcc348448f035905b87a03c37e20dfd650`;
- PREV/OUTPUTS:
  `f23358ce0426f04196bbd8fd4e814afb2b14541c6df13854a67c994f6074771f`;
- zadanie GLOBAL:
  `e2fae27504e275d769b939ddecf429dfcec8c4461f0ed9d420f6cb3a5380313a`.

38 wybranych wejść, ich kopie i piny: INPUTS.sha256 / inputs/provenance.json.
Poprzednie W/PREV/RHO i oryginalne wejścia pozostały read-only.
Jedyny dostosowany formalny import: alias Words `Int.ofNat_nonneg` zastąpiony
`Int.natCast_nonneg`; diff i hashe w formal/Deps/Words.patch oraz
artifacts/formal_adaptations.json. Nietknięte wejście pozostało w inputs/formal/.

## 3. Główne nowe dowody

### A. Rzeczywiste stany i prefiksy

Buffer.lean modeluje każde store, odczyty ze starego snapshotu i rekurencję
runSteps. Indukcja obejmuje każdy prefiks, nie tylko stan po idealnym etapie.
Layouts.lean dowodzi injectivity, dekodowania, cover1536 współczynników,
legalności adresów i guardów/harmonogramów ośmiu etapów. SourceModel.lean
instancjuje konkretne helpery i temporaries forward/inverse, zachowując
canonical range całych przebiegów. Stages.point_prefix obejmuje scaling
i pętle tomonty/montPoint/subtract. Szczegóły: INVARIANTS.md i SOURCE_MODEL_BINDING.md.

### B. Globalny inverse — domknięty

Expressions.lean dowodzi soundness checkera liniowych source expressions
dla wszystkich canonical danych. Ich zgodność z sześcioma operatorami źródła
jest definicyjna. BlockChecks konsumuje wszystkie1024 wiersze rzeczywistych
dynamicznych tabel; unitRow_id wiąże lookup z indeksem. Nie ma nieznanej
macierzy lub globalnej odwrotności jako założenia checkera.

Stages.lean składa te lokalne wyniki z dowodem rzeczywistego wykonania
in-place. InverseGlobal.lean dowodzi reverse traversal i przenosi skalę
3·2^8·2=1536; ni6187 daje ordinary18421 i usuwa ten czynnik.

Sprawdzone pełne tezy (namespace FT1536Global):

```text
inverseMem_forwardMem : ∀ s, CanonMem s → inverseMem(forwardMem s)=s
inverseC_forwardC : ∀ v, CanonVec v → inverseC(forwardC v)=v
inverse_forward : ∀ v, liftInverse(liftForward v)=canonical v
```

Są to instancje konkretnych modeli pętli. Żadna z tych końcowych tez nie
przyjmuje poprawności forward/inverse, inwariantu globalnego, source/model
equivalence ani poprawności iloczynu jako dodatkowego argumentu.
Jawny C→model binding ma charakter translacji dla przypiętego C99/LP64;
nie jest to dowód poprawności kompilatora. Rozdzielenie tego bindingu,
kernel proof i obserwacji wykonania zachowano w dokumentacji.

### C. Forward i kompozycja — nowy postęp, nadal częściowo

ForwardProgress.lean dowodzi pierwszych768 par jako współczynników dwóch
reszt z etykietami14649 i1−14649 oraz A±sB dla każdego pełnego binary stage
w rzeczywistych adresach. Nie złożono tych faktów w globalny inwariant CRT
wszystkich ośmiu poziomów i cubic.

Pipeline.lean dowodzi równoważności source-loop tomonty/montPoint/subtract
z konsumowaną kompozycją. Lift jawnie dopasowuje Fin1536→Int do canonical C.
W `L_NTT_pending_forward` pozostała **jedna** globalna przesłanka:

```text
∀ h r, liftForward(product h r)=pointMul(liftForward h)(liftForward r).
```

Odwrotność jest już podstawiona z nowego dowodu. Pełny typ twierdzenia,
łącznie z tą przesłanką i canonical h/r/c, jest w logs/final/Audit.stdout.
`#print axioms` nie jest używany do ukrycia tego warunku.

## 4. Dokładnie otwarte obowiązki

1. **FORWARD_GLOBAL:** dla każdego canonical v, i<512, j<3:
   `forwardC(v)[3i+j]=Σ_k v[k]*(alpha_i*14648^j)^k mod18433`,
   gdzie alpha_i=ordinary gm[512+i]. Najbliższa luka to indukcyjne powiązanie
   lokalnych A±sB z globalnymi resztami modulo X^t−tau, zgodnie z etykietami
   drzewa i fizycznymi adresami, następnie końcowa ewaluacja cubic.
2. **PRODUCT / forward_product:** z powyższej ewaluacji, zer Phi i
   zachowanej współczynnikowej definicji remMonomial wyprowadzić
   multiplicativity, jawnie rozliczając canonicalizację liftu.
3. Wyniki p,d i **RHO_SUBSTITUTION** pozostają zależne od PRODUCT.

Nie zmieniono celu L_NTT na roundtrip. Nie nadano L_NTT_PROVED_FOR_PINNED_MODEL.
OBLIGATIONS.json pokazuje delty wszystkich16 wcześniejszych pozycji i nowe
obowiązki bufora, zakresów, liftu i source-expression soundness.

## 5. Weryfikacja

- Lean4.34.0 / Std, commit293d5d0c0c3f3dded4688b3ccd6a33939ac5102b.
- 18 modułów, 351 twierdzeń:186 konsumowanych i165 nowych.
  Wszystkie finalne logi czyste; dopuszczone aksjomaty tylko propext,
  Classical.choice, Quot.sound. Bez sorry/admit/native_decide/lokalnych aksjomatów.
- Audit.stdout SHA-256:
  `a15c29db3a739600168af1659ed840492e1ef239849937dace1c76b8d61451f4`.
- GCC14.2.0 / x86_64-linux-gnu, C99. Sage10.9, Python Sage3.14.7;
  Python systemowy3.13.5. Pełne wersje i wyjścia: TOOLCHAIN.txt.
- Dwa jawne syntetyczne canonical wektory: gęsty wzór kwadratowy i sparse
  wartości18432 na granicach bloków. 104 pełne snapshoty na przypadek,
  razem208/319488 współczynników C=Lean. Endpoints plain=observer.
- Sage niezależnie sprawdził202 prefiksy przez ordinary macierze oraz
  wszystkie1536 współrzędnych forward dla każdego z dwóch przypadków,
  przez ewaluację wielomianu w podanym fizycznym porządku.
- Cztery rzeczywiste mutanty wykryte: spójna zamiana etykiet forward/inverse,
  zamiana cubic outputs1/2, błędne ni, odczyt po pierwszym store. No-op przeszedł.
  Pierwszy mutant zachowuje roundtrip, ale ma błędny forward — dodatkowa
  kontrola nie ogranicza się do samej odwracalności.
- Świeży replay:103/103 pliki znaczeniowe identyczne, bez przeniesienia
  olean/binariów/cache. REPLAY.md i artifacts/replay_result.json.

To kontrole nowego bindingu, nie ponowienie szerokiej kampanii PREV i nie
uniwersalny dowód forward. Pełne stdout/stderr, argv, kody i limity zachowano.

## 6. Historia prób i ograniczenia zasobów

Początkowe błędy elaboracji i deprecated aliases naprawiono w nowych plikach;
próby zachowano poza finalnym zakresem. Przy4GiB Lean zgłaszał
`failed to create thread: Resource temporarily unavailable`;8GiB oraz
`-j1 -M2048` rozwiązały problem. Pierwszy interpreter trace z chain closures
przekroczył120s; materializacja stanu przy wykonaniu importowanych kroków
rozwiązała problem bez zmiany dowodzonych funkcji. Parser audit początkowo
nie rozpoznawał dopisków universe w nazwach standardowych aksjomatów;
poprawiono parser, zachowano receipts i wykonano ponownie czysty audit.
Żadne z tych zdarzeń nie jest kontrprzykładem matematycznym.

Budżety i sandbox: zapis wyłącznie W, source read-only, bez sieci;
RLIMIT_AS8GiB, Lean heap2048MiB, jawne wall/CPU limity do240s per job.
Nie użyto innych agentów, instalacji, nowych kluczy, prywatnych danych,
commitów, podpisów ani publikacji. Nie zmieniono historycznych statusów.

## 7. Jedna następna rekomendacja

Kontynuować **FORWARD_GLOBAL** od coefficient-level `binary_coefficients`:
udowodnić inwariant reszt w drzewie CRT przez osiem source stages i cubic,
a następnie wyprowadzić forward_product dla istniejącego remMonomial.
Gotowe inverse_forward i source pipeline bridge należy bez zmian konsumować
w kolejnym, osobnym obszarze zapisu.

Zakres i zamrożony prefiks dziennika: OUTPUT_SCOPE.md.
Maszynowy werdykt: RESULT.json. Piny końcowych bajtów: OUTPUTS.sha256.
