# FT1536 H3_RANGE — częściowy wynik źródłowy

Data zadania:2026-09-19. Autor projektu: Niirmata. Wykonawca: GPT-ASTRA.
W: `/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_H3_RANGE_RUN_001`.

## 1. Werdykt

**PARTIAL_PROOF. Nie domknięto uniwersalnego H3_RANGE dla emitted-KeyGen
support i wszystkich osiągalnych historii Sign. Nie wykazano kontrprzykładu
w tej required domain.**

Dostarczono nowe kernelowe lematy floor/proposal/ordered residual, source
call-order projection i dokładnie sklasyfikowane lokalne wyniki negatywne.
Najważniejsze nowe rozróżnienie: sam numeric C_mu i finite(mu) nie wystarczają
do refinementu floor na wszystkich dopuszczonych bit patterns, ponieważ
rzeczywiste `fpr_floor(-0)=-1`, a mathematical floor0. Potrzebny jest również
reachable-zero/domain invariant. Nie dowiedziono, że−0 jest osiągalne z
Emitted_C; nie jest to ogłoszenie required-domain overflow lub forgery.

## 2. Przypięta baza i zachowany cel

TASK SHA-256:
`7eb75c4f19c32c1a20a3ec7677ef75293132e9238b8dd64cfff1f4d4f34607e0`.
Bootstrap MANIFEST:
`f9ea278838e9d1f8f959100175f56c62217997ff25611fccc0b9353dd9fcfe40`.
Sprawdzono **52/52** członków,50 publicznych original records i17 źródeł;
zestaw jest dokładny i read-only. Pochodzenie BASE:
`f5266765c5f0733fb3ab6a5e2906aa44d15e17f7`.
Źródłowy manifest pozostaje
`2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a`.

Zachowano N1536, q18433, Phi=X^1536−X^768+1, sigma768, B2093922385,
FPEMU/full ternary MODE1, M0 caller4096, nonce40,16 outer attempts,
jeden wspólny K_seed[E] i parametryczny cel. Nie użyto starego Extra/c
ani nie zmieniano branch/index/refs. Aktywny baseline jest już zintegrowany.

Cel pozostaje dokładnie:

```
Reach_call_C(E,sk,pk,tau,a,j,S,mu,sigma) ->
 -2147483283<=floor(exact_value(mu))<=2147483281,
 source floor=mathematical floor, long->int exact;
 z in[-365,366] and INT32_MIN<=s+z<=INT32_MAX.
```

Reach odnosi się do pełnego source successful-KeyGen output i rzeczywistego
M0 prefixu, także prób później odrzuconych przez dss/fault/norm. Nie dodano
Q<B ani założeń o przyszłych bezpiecznych calls do definicji osiągalności.

## 3. Nowy lokalny kontrakt FPEMU/floor

Floor.lean dowodzi dla wszystkich bit-field values e<=1053 i f<2^52,
z wyłączeniem negativezero, równości field-normalized source floor i exact
dyadic floor. Low exponents, positivezero i niezerowe subnormals są rozliczone
osobno. Signed mantissa mieści się w int64, masked shifts0..63, a finalny
cast/s+z są bezpieczne przy wymaganym C_mu. Model i ręcznie wyprowadzona
bit-field translacja C są wyraźnie oddzielone od kernelowej części dowodu.

Nowe universal local `complete_local_lift` ma jawne CenterClass i k<=365;
nie jest mylone z brakującym Reach→CenterClass. Pełne typy/term są w Types.stdout.

**Rozstrzygnięte syntetyczne przypadki:**
- source floor−0=−1 przy guardach finite/positive sigma i faultNONE;
  kernel potwierdza lokalny brak implikacji guards→floor refinement;
- s+z przy tym−1 nadal mieści się w int32 — nie raportuje się tu overflow;
- mul(2^-1022,3/4) daje0 zamiast gradual binary64 wartości3*2^-1024,
  naruszając universal u|x|+2^-1075 error budget;
- half na granicy normal/subnormal i inne exponent0 operacje wymagają
  specyficznego backendu, nie kompletnego IEEE założonego z nazwy.

Są to extended-domain diagnostics. Test negzero w source terminalu i
bezpośrednim aktywnym samplerze nie nadaje mu emitted/whole-Sign reachability.
Wszystkie testy FPR mają niezależny exact dyadic/integer oracle, nie host-double.

## 4. Proposal i kolejność wykonania

Comparator.lean dowodzi źródłowych64/128-bit unsigned porównań z wrapem.
Pełne2560 threshold pairs zostały sparsowane niezależnie i związane z C dumpem.
Kernel sprawdza maxima banków **29,59,118,235,365**, uniwersalny scan bound
i first-eligible selector. Stąd z∈[-365,366], z uwzględnieniem found/fault.
Tabela długości512 nie została potraktowana jako max returned k.

Wyprowadzono root/depth1/inner source dataflow: right subtree, korekta lewego
centrum przez już zwrócone residuum, split/merge, potem ponowne product/subtract.
Na terminalu pierwsze wywołanie dotyczy r1 z IW1I*sigma, następne r0+half(r1)
ze stored sigma, a wynik jest residuum. Layout kernelowo daje3072 calls,
first leaf18431 i kolejność1→0. Normalizer zmienia1536 leaf words;16896 internal
words nie jest nim zastępowanych.

Nowe OrderedResidual lemmas używają jawnych signed error terms. Następne
centrum jest ograniczane z wcześniejszego residuum, NIE z przyszłego wyniku
tego samego call. Przy zerowych błędach lokalny terminal odzyskuje366/549,
ale nie ogłoszono549 jako boundu całego root residual. Fault0-return jest
osobną gałęzią, nie próbką Gaussa blisko centrum.

Pełne synthetic source runs baseline/minusL/fault/noop (po3072 calls) i
terminalnegzero(2) zgadzają się bitowo z wykonywalną projekcją: requests,
sigmas, returns i final buffers. Normal i ASan/UBSan są zgodne. Zmiana
terminalnej skali lub znaku correction jest rzeczywiście wykrywana.

## 5. Klucz/drzewo, majorant i konkretna pozostała luka

Source success route wymaga solve_NTRU i obu poly_big_to_small na F,G.
Nowy lokalny kernel checked_key_coefficients rozlicza cap±2047; pełnej
definicji Emitted_C nie zastąpiono tym samym capem ani arbitrary loader key.
Nie założono idealnego reduced Babai quotient<=1/2 dla source floating path.

Sage sprawdza exact Schur/NTRU identities. Root target cancellation t0+t1L
jest poprawna algebraicznie, lecz actual center t0+r1L zawiera(r1−t1)L.
Nowy dokładny count monomial contributions daje2304 i coefficient bound
`86930620416/18433` dla idealnego c*F/q przy source caps. Nie jest to bound
actual FFT buffer lub wszystkich centrów; machine/split transfer jest otwarty.

**Nowy source-local witness niewystarczalności leaves:** synthetic inner node
z stored widths równymi H4 endpoints, t0=t1=0 i L=2^32. Pierwsze dwa bezpieczne
zwroty prowadzą przez oryginalną rekurencję do następnego centrum
**12884901888** (bits4208000000000000), poza C_mu. Kontrola kończy się przed
niebezpiecznym narrowing. Ten tree nie jest KeyGen/loader output, więc nie
obala required-domain H3; pokazuje dokładnie, dlaczego same leaves nie domykają
internal-center premise.

H4 stored endpoints oraz terminalną skalę sprawdzono teraz rzeczywistym
FPEMU z exact RN oracle (a nie tylko dawnym fpr-double). Dss endpoint controls
zgadzają się z3f455555c49559f4..3fd203d2c1ca3682. Nie jest to uniform proof
monotonicity/domeny całego backendu lub wszystkich internal LDL operations.
T5 i jego historical numerical leaf results zachowują swoje własne zakresy.

**Najbliższy brakujący typ:**

```
forall E,sk,pk,tau,a,j,S,mu,sigma,
 Reach_call_C(E,sk,pk,tau,a,j,S,mu,sigma) -> CenterClass(mu).
```

Potrzebne są: reachable FPR-class/zero invariant, uniform certyfikat actual
subtractive LDL pivots/L (plus exact/machine relation) oraz ordered propagation
przez źródłowe targets, wszystkie split/merge i prior returns. C_mu, internal
multiplier bounds i errors są nadal celami, nie parametrami „pełnego H3”.
Operacyjny Reach jest opisany bez takich przesłanek w REACHABILITY.md;
pełny C/KeyGen/loader refinement nie został kernelowo domknięty. To także
jawna pozostała część source bindingu, nie ukryte zakończone twierdzenie.

## 6. Weryfikacja, odtwarzanie i wynik w ledgerze M0

-8 modułów (6 dowodowych+Audit/Types),49 nowych deklaracji theorem,
  czyste finalne logi; bez sorry/admit/native_decide/lokalnych aksjomatów.
  Standardowe propext, Classical.choice, Quot.sound. Audit.stdout:
  `e81b8bde8f56f3f362399ead82d010662e65dd13eb34814a8053854562172fbd`.
  Types.stdout:
  `1834f39d46440db882156af3a6a00f1e4e9881f52483b0f6aadf81f6825b4142`.
-112 primitive/guard/table/width jobs na tryb normal/sanitizer,83 dokładne
  comparisons sklasyfikowane przez oracle,18 floor boundary words i15 selector
  endpoints w osobnym harnessie; pełne output/error streams są zachowane.
-12290 callback comparisons na tryb order controls, wliczając no-op i2-call
  synthetic terminal. Plus jawny3rd-center leaf-gap witness. To kontrola
  source projection, nie kampania KeyGen lub prywatnego Sign.
-Mutacje endpointu floor, rounding direction, CDF zero threshold, terminal
  scale, correction sign i pominięcia rzeczywistego błędu są wykrywane
  przez zmienione wartości/trace, nie etykiety. No-op przechodzi.
-Fresh rehearsal **96/96 matches PASS**, z kernel rebuild i ASan/UBSan.
  Standardowy replay wymaga finalnego zewnętrznego OUTPUTS hash, zapisuje tylko
  nowy DEST, nie wymaga Dokumenty/H ani poprzednich W.

Pierwszy rehearsal przeszedł kontrole/kernel, lecz nie wygenerował receipt
bootstrap wymagany przez ledger. Auditor został uzupełniony o ponowną pełną
weryfikację52 członków i reprodukcję receipt. Nowy seed002 przeszedł całość;
historia zachowana. To błąd pakowania, nie kontrprzykład matematyczny.

W M0 row H3_RANGE pozostaje **OPEN / PARTIAL_PROOF**. Nowe fakty zamykają
lokalny proposal support i doprecyzowują poprawny floor/domain interface,
source order oraz error-aware terminal recurrence. Nie ustawiają H3 arithmetic,
H1R/FFO/H6/R5T/M7 jako unconditional ani security_reduction_proved.

## 7. Wykonanie i przekazanie

Sandbox: tylko W writable, bootstrap i source read-only; cache/HOME/TMPDIR/
DOT_SAGE/LEAN_PATH pod W. GCC14.2/C99/LP64, Lean4.34/Std -j1 -M2048/8GiB,
Sage10.9. ASan miał odrębny shadow-address tryb, wall/CPU limits skończone.
Nie użyto sekretów, nowych kluczy/KeyGen, Sign z kluczem, instalacji, sieci,
innych agentów ani operacji Git. Nie dodano guardu ani nie zmieniono źródeł.

`baseline_source_integrated=true`, `source_changed=false`,
`new_source_patch_integrated=false`, `protocol_wrapper_integrated=false`,
`owner_accepted=false`, `security_reduction_proved=false`.
Nie przepisywano historycznych flag starszych pakietów.

Następna rekomendacja: udowodnić źródłowy reachable FPR-domain/negative-zero
invariant dla active calls, wraz z necessary internal-LDL certificates,
tak aby rzeczywiście zinstancjować Reach→CenterClass. Gdy potrzebna poprawka C,
jej wersja i wpływ na law/abort wymagają osobnego zadania. Obecny pakiet kończy
się na częściowym H3_RANGE; prowadzący wykonuje odbiór/import/commit.
