# GPT-ASTRA — H3_NODE2: pierwszy split_deep → Adj → LDL_dim2

Data: 2026-09-19. Autor projektu: Niirmata.
Kontynuacja tej samej rozmowy po niezależnie odebranym H3_NODE3.

## 0. Jedno zadanie i granica poziomu

Domknij dokładny następny typ z NODE3/NEXT_INTERFACE: **SplitDeep(logn9)
→ Adj(logn8,full0) → LDL_dim2(logn8,full0)** dla trzech source diagonal
branches każdej root branch i wszystkich 128 częstotliwości. Razem 2×3×128
lokalnych pozycji, objętych jednym uniform rational record c2.

NODE3 ma H3_NODE3_PROVED_FOR_PINNED_MODEL, niezależny replay123/123,
21 modułów/115 twierdzeń (16 nowych). Eksportuje dodatnie real pivots,
actual imaginary words i mocniejsze source-to-H correlations. Nowe zadanie
ma je rzeczywiście skonsumować, a nie zastąpić przez niepowiązane przedziały.

To **pierwszy poziom binarny po NODE3**, nie twierdzenie o wszystkich
niższych levels. Nowy parametryczny step lemma jest przydatny, lecz jego
lokalna instancja nie jest automatycznie pełnym tree proof. Wykonaj pracę
do raportu, freeze i standardowego replayu, z rzeczywistym statusem wyniku.

## 1. Katalog i przypięte wejścia

```text
REPO = /home/footfalcon/free_falcon_sign
W = REPO/proofs/ft1536/work/FT1536_H3_NODE2_RUN_001
IN = W/inputs/bootstrap
TASK = /home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_H3_NODE2_2026-09-19.md
BASE = afa52d89be2f21208ac3135e74a1a60fc66d52c4
```

Przeczytaj REPO/AGENTS i W/AGENTS. Potwierdź cwd, rzeczywisty sandbox tylko
W i brak drugiego wykonawcy. REPO ma wcześniejszy checkout/indeks; źródłem
zadania jest IN/source, nie REPO/Extra/c. Nie operuj na Git lub branch refs.

`proofs/ft1536/background/H3_NODE2_2026-09-19/` ma 118 publicznych
oryginałów Git i ORIGINS/README, czyli 120 członków manifestu. IN jest
identyczną kopią. **Zewnętrzny SHA-256 IN/MANIFEST.sha256:**

```text
f92dbaa6f4262f2cce5d4bd27e002da0f684f87a92fef8619bee226221782178
```

Zweryfikuj cały manifest, dokładny zbiór plików i proweniencję:

| Wejście w IN | SHA-256 |
|---|---|
| CANDIDATE.sha256 | `2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a` |
| NODE3/REPORT.md | `00cff5cd09b8eb083cbb32943f853911b77710781f76016c4adb9e7938e0ff97` |
| NODE3/OUTPUTS.sha256 | `a4a4116bcf1bbbdd5e73c49cf15828f81fa2eb6d7e05f6b9f81a06a2b6b7dd72` |
| NODE3/NEXT_INTERFACE.md | `30b87b92450a5bc9eec127b6ca2da6f40d7bef484c383ae375584efb3a790eff` |
| NODE3/NODE3_CERTIFICATE.json | `ed7944b9a015437b527e1c82813e4aa8779af3764bb7a298538f6d753a884ea5` |
| NODE3/ANALYTIC_PROOF.md | `181cbabf6f2648cd241cc482fad7519dd9068465675227299faaa667d434116e` |
| NODE3/NODE3_FRAME.md | `f6c3d6a95c5a42c579f0e190dca3f2750d8534fd931f6667c607ec75342d2a95` |
| NODE3/artifacts/numeric_certificate.json | `43259f399382f58e8c472b036a66c7bd110aa8c92693995bb5091ac83d088bb3` |
| NODE3/scripts/node_model.py | `424824df4f906ae7d70e09136c3bf72cfd3eefa16da7a1ab0bc80ebf5c52013e` |
| ROOT/ANALYTIC_PROOF.md | `e2caa8b9d7996a241bee2e6bb8a478eadf031279860cdaf586daa3473ed69ef7` |
| ROOT/artifacts/numeric_certificate.json | `5190ddf21d676ebf1045a35c29b9600b26ee461aa86b58e0d2012d6db8564c10` |
| source/falcon-fft.c | `06b573b636ae368dcda3eb4d89c3936ab31272123440d0d5362317e55d9ac063` |
| source/falcon-sign.c | `eee8d7dc503e007cb76bcc157094b2a2de481075ac3f67426848f7a8cae6efd8` |
| source/fpr-emulated.c | `7cb06c9ea8f8bfc205a207cd73af367d299005d4bfec26333ced702f1c024e5f` |
| source/fpr-emulated.h | `242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa` |
| review/VALIDATION.sha256 | `af44c49b29eb564a71a0f98abe9a592926a7229030917fffe606ea1d6e27e670` |

To projekcja wejść, nie pełny stary replay tree. Wybrane członki etapów
sprawdzono wobec ich OUTPUTS, legacy wobec LEGACY_CONTEXT. Oryginalne
manifesty zachowują własne bazy. Kontrolery adaptuj w W z pinami/diffami;
nie uruchamiaj ich w bootstrapie. Nowy replay nie może wymagać starego W,
Dokumenty/H/USB ani tymczasowego worktree prowadzącego.

## 2. P_key, profil i konsumowany rekord

N1536, q18433, Phi=X^1536-X^768+1, sigma768, B2093922385, MODE1/FPEMU,
dokładne flagi Makefile; M0 caller4096/nonce40,16 attempts, jeden K_seed[E]
i parametryczny cel. P_key ma DOKŁADNIE definicję ROOT: Key4 to cztery
Int^1536 vectors, ternary f/g, caps2047 F/G, exact NTRU, rzeczywisty Gate00_C.
Konsumuj source-analytic Emitted_C + same STATIC decode → P_key w jego zakresie.

Nie dopisuj positivity nowego node, small imaginary, małego L, center boundu
lub norm acceptance do P_key. Można dowieść pomocniczego twierdzenia na
nadzbiorze, ale trzeba wykazać, że rzeczywiste wejścia go spełniają.

NODE3 eksportuje arrays t0,d11,d22 po512 słów, real j/imag j+256 oraz L10/L20/L21.
Branch0: real dolne granice1/4 dla t0 i1/8 dla pivots; imag t0=+0, pivots≤1/256.
Branch1: real lower16 dla t0 i8 dla pivots; imag odpowiednio≤32,33,34.
Pełne upper/error/intermediate bounds są w NODE3_CERTIFICATE.

**Zachowaj również silniejszy rekord:** actual-input Hermitian H≥lambda I,
near-equal offdiagonal moduli, exact-H pivots d,d2≥lambda, real source errors
≤64U*h i≤65536U*h, L21 error≤1024U*h/d oraz wspólne tau=Im(t0), do którego
odnoszą się imaginary output errors. U=2^-48, eta=2^-900 mają konkretne domeny.
Nie przypisuj samym osobnym endpointom całego znaczenia tego rekordu.

## 3. Dokładny kwantyfikowany cel

Zachowaj operacyjny typ poprzednika:

```text
exists c2 : Node2Constants,
  ValidConstants2(c2) and
  forall p : Key4, P_key(p) -> forall b : Fin2, forall k : Fin3,
    let N := Node3Slice_C(p,b);
    let v := select(k,[N.t0,N.d11,N.d22]);
    let (s0,s1) := SplitDeep_C(v,9);
    let u1 := Adj_C(s1,8,0);
    Defined(SplitDeep_C;Adj_C;LDL_dim2_C(s0,u1,s0,8,0)) and
    forall f : Fin128,
      Node2Certificate(c2,b,k,f,s0,u1,LDL_dim2_C(s0,u1,s0,8,0),
        ExactSplitAndSchur(select(k,ExactNode3Diagonals(p,b)),f)).
```

Jeden jawny racjonalny c2 może zawierać ustalone pola(b,k), lecz żadna stała
nie zależy od wybranego klucza, frequency sample albo historii testów.
ValidConstants2 wymaga dodatnich lower bounds dzielników/pivotów,
skończonych upper bounds oraz nonnegative error budgets.

Node2Certificate obejmuje: defined każdej source instruction, finite words,
positive real denominator s0 i computed d11, klasy FPR, bound nowego L,
oddzielne real/imag errors oraz błędy wobec NIEZALEŻNEGO exact binary
split/Schur. ExactNode3Diagonals to dokładne pivots poprzedniego reference,
nie aktualne source words ani definicja przez pożądany wynik.

Żadna potrzebna numerical premise nie może pozostać założona w pełnym
pozytywnym wyniku. Conditional helper z założonym marginem jest wartościowy,
ale bez instancjacji na P_key daje PARTIAL_PROOF.

## 4. Rzeczywisty program, mapa i reference

Zwiąż źródła co najmniej:
- falcon-fft.c1326–1370: split_deep, używany tutaj logn9 path;
- fpr-emulated.h165–174: rzeczywisty fpr_half;
- falcon-fft.c1260–1271: direct div obu components przez real denominator;
- falcon-sign.c505–530: subtractive LDL_dim2;
- falcon-sign.c598–647 i651–701: inner chronology i trzy wywołania z depth1.

Na tym poziomie SplitDeep paruje parent slots2f,2f+1 (imag+256), używa
conjugate square twiddle z indeksu256+f, a child ma256 words: real f/imag f+128.
Wyprowadź mapę parent/child roots i dokładne scaling1/2, zamiast opierać
się wyłącznie na długości tablicy lub roundtripie transformacji.

Source oblicza add i half do s0, sub i complex mul przez twiddle, następnie
half do s1. Dopiero potem Adj oraz LDL_dim2(s0,u1,s0). Source L jest
per-component div; source d11 to muladj, neg/add. Zachowaj znaki, kolejność
i repeated const alias g00=g11. Nie podstawiaj harmonic pivot do definicji C.

Independent exact reference używa REALNYCH exact Node3 diagonals. Dla
dwóch dodatnich spectral values a,b wyprowadź w właściwej konwencji
binary pivots `(a+b)/2` i `2ab/(a+b)` oraz exact multiplier. To tożsamości
odniesienia, nie numerical source bounds ani implementacja stable LDL.

## 5. Najważniejszy obowiązek: positivity z powiązanych real/imag danych

Nie zakładaj, że same NODE3 boxes wystarczają. Branch1 ma np. real lower8
oraz imag bound34; takie niezależne przedziały dopuszczają szerszą klasę
niż rzeczywiste source outputs. Przekroczenie boundu w tej szerszej klasie
nie jest automatycznie kontrprzykładem P_key.

Przydatny dokładny lokalny punkt odniesienia dla wejść
`v_a=r_a+i*tau_a`, `v_b=r_b+i*tau_b` i unit twiddle:

```text
h=(r_a+r_b)/2,
|u1_exact|²=((r_a-r_b)²+(tau_a-tau_b)²)/4,
h²-|u1_exact|²=r_a*r_b-(tau_a-tau_b)²/4.
```

Najpierw potwierdź te wzory dla fizycznej mapy, potem rozlicz source rounding.
Wyprowadź dodatni margin z REALNYCH eksportowanych korelacji albo nowego
upstream refinementu. Nie ignoruj różnicy tau między parowanymi slots,
nie zastępuj source input przez jego real part i nie zakładaj nowej małości.

Jeżeli potrzebne są ciaśniejsze imaginary bounds ROOT/NODE3, wolno je
udowodnić tutaj z przypiętych instrukcji i wcześniej rozliczonych faz.
Np. sprawdź osobne imaginary contribution root muladj/neg/add oraz
przenoszenie tau do pivotów NODE3, zamiast używać wyłącznie normowego
Schur error. To NOWY lemat w nowym W: pełny dowód, domena, piny, kontrola;
nie nadpisuj dawnych certyfikatów i nie deklaruj lepszej liczby z samych próbek.

Jeśli relacyjny argument nie zamyka marginu, podaj najmocniejszy dowiedziony
interfejs oraz dokładny brakujący typ. Nie wymuszaj positivity przez zmianę
programu, dodanie guardu lub wycięcie inconvenient P_key.

## 6. FPEMU half i kolejność uzasadniania domen

ROOT/NODE3 add/sub/mul mają input cap2^100, U=2^-48,eta=2^-900;
NODE3 div ma dodatni normal denominator w[1/16,2^35]. Każde zastosowanie
musi mieć wcześniej wykazaną domenę. Jeśli nowy zakres jest szerszy,
rozszerz source contract z dowodem pack/exponent0/underflow, nie samą etykietą.

**fpr_half wymaga własnej source semantyki.** Nie utożsamiaj go z RN(x/2)
na wszystkich bit patterns. Rozlicz oba zera, exponent0, granicę najmniejszej
normalnej liczby i możliwość powstania subnormal outputu. Stary H3 zawiera
diagnostykę tego backendu. Ograniczenie domeny wymaga dowodu dla każdego
rzeczywistego wejścia; sam typ fpr nie daje normalności.

Nie przenoś automatycznie raw-preservation `sub(x,+0)` z argumentu NODE3,
jeśli po half nie wykazano tej samej klasy x. W ledgerze odróżniaj exact
value error i zmianę raw zero/subnormal bits. Source-to-H comparison jest
obiektem dowodu, a nie patchującą projekcją runtime.

Porządek: poprawna domena split inputs → defined split/Adj → dodatni real s0
przed division → bound L i muladj → dodatni computed d11 z błędem.
Nie uzasadniaj wcześniejszej instrukcji przyszłym pivotem albo finite output.
Wyprowadź intermediate caps przed użyciem ostrzejszych error contracts.

## 7. Frame, chronologia i eksport

NODE3 outputs są certyfikowane w chwili końca dim3. Prześledź rzeczywiste
trzy split_deep/inner calls i scratch reuse: kiedy wybrane t0,d11,d22 są
odczytywane, które wcześniejsze stores je zachowują i kiedy ich lifetime się kończy.

ffLDL_inner(logn8) wykonuje własny pierwszy split/niższą rekurencję PRZED
lokalnym dim2. Node2Slice jest wydzieloną funkcją numeryczną. Jej poprawność
oraz frame dla defined prefixes docierających do dim2 nie dowodzą totalności
tej wcześniejszej rekurencji. Zachowaj również branch0 przed root dim2.

W NEXT_INTERFACE eksportuj nowe d00=s0,d11,L dla wszystkich(b,k), physical
layout, real/imag/error bounds i relacje nadające się do dalszej indukcji.
Podaj pełny następny typ dla niższego split_deep/inner. Jeśli powstanie
parametryczny binary step invariant, zachowaj go wraz z rzeczywiście
udowodnioną instancją; pełny remaining tree wymaga osobnej kompozycji.

Initial targets pozostają odrębne. ORDERED_REACH ma wykazać NumericCenter
przed konsumpcją ZERO_SCALAR366+2^-20, także pre-dss i norm-rejected attempts.
Fault0 nie dostaje residual-closeness. Sampler law i straty redukcji są osobne.

## 8. Kontrole i wynik negatywny

Uniwersalny argument może być mixed analytical/kernel, z jawnie rozliczonymi
upstream contracts i source bindingiem. Pokaż pełne typy/termy/implicits/axioms
nowych Lean oraz dokładne certyfikaty. Finite checks nie zastępują kwantyfikatorów.

C normal/ASan/UBSan + niezależny exact dyadic/QQ/RBF/RIF oracle obejmują
wszystkie 2×3×128 pozycje w publicznych synthetic controls, contrast widma,
pary o różnych imaginary components, phase/Adj, real-slot div, cancellation,
half zero/subnormal boundaries, alias/frame i scratch reuse. Host double nie
jest jedynym oracle. Cases spoza domeny zatrzymuj przed nielegalnym C call.

Mutacje: usunięcie imag przed split, pominięcie `(tau_a-tau_b)²` w marginie,
idealne half zamiast backendu na granicy, wrong root/phase/Adj, complex zamiast
real denominator, idealny harmonic pivot zamiast source sequence, opuszczony
rounding term lub nieuzasadniona stara div-domain. Wykrywaj różnicę wartości/
warunków, nie etykietę. No-op ma przechodzić.

Rozdziel: niewystarczalność luźnych bounds, kontrmodel lokalnego nadzbioru,
kontrprzykład P_key dla tezy§3 i rzeczywiście emitted/Sign reachable case.
P_key witness może obalić nową tezę§3 bez dowodu Emitted; nie jest wtedy
automatycznie required-domain kontrprzykładem globalnego H3/M0. Membership
udowadniaj publicznie/symbolicznie, bez generowania/odczytu prywatnych danych.

## 9. Wykonanie i artefakty

Zapis tylko W, bootstrap i source read-only. AGENTS nie jest sandboxem:
potwierdź rzeczywisty zakres. HOME/TMPDIR/DOT_SAGE/LEAN_PATH/cache/olean/bin
pod W, jeden wykonawca, skończone wall/CPU limits. GCC14.2/C99/LP64,
Sage10.9 (`sage plik.py ...`), Lean4.34/Std `-j1 -M2048`/8GiB;
ASan z osobnym shadow mode. Bez instalacji/sieci/innych agentów/Git.
Bez KeyGen/private loadera/Sign/nowych kluczy/prywatnych seedów/współczynników,
.private/private_extraction. Kontrole tylko na publicznych syntetycznych danych.

Nie zmieniaj C, parametrów, guards lub M0. Nowe/edytowane Lean: pełne czyste
logi, bez sorry/admit/native_decide, lokalnego aksjomatu wniosku i wyciszania
ostrzeżeń. Zależności z pinami i rebuildem; adaptacje w nowych kopiach z diffem.
Zachowaj wszystkie nieudane próby, polecenia/cwd/limity/exit codes/streams.

Wymagane: REPORT.md, RESULT.json, CLAIM.md, NODE2_CERTIFICATE.json,
BOUND_LEDGER.json/.md, SOURCE_MODEL_BINDING.md, REUSED_RESULTS.md,
OBLIGATIONS.json, NEXT_INTERFACE.md, formalne źródła/certyfikaty/checkery,
INPUTS.sha256, TOOLCHAIN.txt, COMMANDS.log, OUTPUT_SCOPE.md, REPLAY.md,
OUTPUTS.sha256. Ledger minimum: NODE3_CONSUMPTION, UPSTREAM_REFINEMENT,
SPLIT_DEEP_MAP, HALF_DOMAIN_ERROR, SPLIT_DEEP_ERROR, PAIRED_REAL_IMAG_MARGIN,
FIRST_DIVISOR, NODE2_MULTIPLIER, NODE2_SCHUR, IMAGINARY_PROPAGATION,
NODE2_FRAME, LOWER_TREE_OPEN, INITIAL_TARGETS_OPEN, ORDERED_REACH_OPEN.

Standard: `python3 -B scripts/replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256`.
Sprawdź external pin i cały manifest przed utworzeniem nowego DEST pod tmp.
Pełny rebuild konsumowanych dowodów/kontroli bez starych olean/bin/cache.
`artifacts/fresh_replay.json` zawiera matches(path,sha256), związane z OUTPUTS;
rehearsal ma osobną kotwicę bez cyklu hashów. Po freeze standard replay
z finalnym pinem, zapis tylko do DEST. Frozen report/result/manifest niezmienne.

## 10. Warunek końca i flagi

- `H3_NODE2_PROVED_FOR_PINNED_MODEL`: cały typ§3, pierwszy poziom logn8 po
  split logn9, jeden jawny c2, wszystkie numerical/domain premises rozliczone.
- `PARTIAL_PROOF`: konkretne nowe lematy i dokładne brakujące typy/nierówności.
- `COUNTEREXAMPLE_REQUIRED_DOMAIN` / `COUNTEREXAMPLE_EXTENDED_DOMAIN`:
  jawna relacja do tezy§3/P_key oraz osobno do emitted support.
- `EXECUTION_BLOCKED`: rzeczywista przeszkoda techniczna, zachowane logi.

Nawet przy pozytywnym lokalnym wyniku: H3_range_proved=false,
global_reachability_proved=false, full_internal_tree_proved=false,
sampler_law_proved=false, security_reduction_proved=false.
baseline_source_integrated=true, source_changed=false,
new_source_patch_integrated=false, protocol_wrapper_integrated=false,
owner_accepted=false. Pole full_node2_theorem_kernelized ma odzwierciedlać
rzeczywisty zakres, a NODE2 level musi być jawne w RESULT.

Podaj REPORT/OUTPUTS SHA-256, dokładną tezę, stałe i warstwy dowodu,
co nowego zamknięto oraz pełny następny typ. Prowadzący wykona niezależny
odbiór/import/commit. Zakończ na przekazaniu; nie zaczynaj kolejnego etapu.
