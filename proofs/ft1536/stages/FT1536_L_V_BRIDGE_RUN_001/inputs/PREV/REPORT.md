# FT1536 — FORWARD_CRT i domknięcie L_NTT

Autor projektu: Niirmata. Wykonawca: GPT-ASTRA. Data zadania:2026-09-18.
W: `/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_L_NTT_FORWARD_RUN_001`.

## 1. Werdykt

**L_NTT_PROVED_FOR_PINNED_MODEL.** Domknięto globalny forward w rzeczywistym
porządku bufora, `forward_product` dla niezmienionego iloczynu współczynnikowego
i końcową kompozycję źródłową. Wyprowadzono p,d, zakresy oraz podstawienie L_RHO.

Końcowy lemat jest sprawdzony przez Lean i ma tylko trzy przesłanki canonical:

```text
FT1536Forward.L_NTT : ∀ h r c,
  CanonVec h → CanonVec r → CanonVec c →
  pipelineC h r c = (product h r, subtract (product h r) c).
```

Nie ma pozostawionego parametru `forward_product`, globalnej ewaluacji,
inwariantu ani równoważności modeli. Pełny typ z implicit/typeclass arguments
i proof term są w `logs/final/AuditTypes.stdout`, linie72–110. W samym proof
term widać podstawienie nowego `FT1536Forward.forward_product` do istniejącego
`FT1536Global.L_NTT_pending_forward`.

Wynik dotyczy przypiętych modeli i zachowanego jawnego bindingu C99/GCC/LP64,
przy legalnych buforach określonych w CLAIM. Nie jest wynikiem pełnego L_V.
`source_integrated=false`, `owner_accepted=false`, `full_L_V_proved=false`.

## 2. Baza i niezmienność przedmiotu dowodu

- Zadanie SHA-256:
  `c25ef7c8ec9f066326e8f6f4a97760082f24d625e584a079e25c6dd75e237c9c`.
- PREV to checkpoint `stages/FT1536_L_NTT_GLOBAL_RUN_001`, report:
  `d5e5dc7cc65f2d12ade4e1928cc705b947e0203657decac59b352ff8fd1d56e8`, OUTPUTS:
  `6095dbfbb616d901e5a7991f608b94bbd7c916167f16baf7d2f50fc3e353b129`.
- falcon-vrfy.c:
  `3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42`.
- Manifest17 plików źródła:
  `2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a`.

Sprawdzono piny i55 faktycznie konsumowanych kopii. Wszystkie16 modułów PREV
pozostają bajtowo identyczne, w tym SourceModel, ForwardProgress, InverseGlobal,
Pipeline i niezależny product/remMonomial. Żaden olean/cache z poprzednich etapów
nie zastąpił sprawdzenia źródeł. Nie wznowiono ich runnerów w archiwach.

N=1536, q=18433, Phi=X^1536−X^768+1, Q, B i full ternary secret/COMP_STATIC
pozostają te same. H jest przygotowane przez NTT/tomonty z czynnikiem Montgomery;
p,d są ordinary canonical coefficients. Dziedzina obejmuje wszystkie canonical
h,r,c, nie tylko wyjścia KeyGen.

Jedyna nowa adaptacja historycznej kopii to aliasy if_pos/if_neg w Rho.lean.
Oryginał `daa68021e0f5bac53cf0384a5e10b0537eb6a8ca9d02f0f2970c6ff6eefc7fe8`
pozostaje w inputs/RHO. Nowa kopia ma hash
`3fc6f1106bde82d3c5657da11e2c2a781486163491adf5617e6d39db43f15fd2`.
Definicje i tezy są identyczne; diff i automatyczna kontrola transformacji
są zachowane. Wszystkie12 twierdzeń RHO ponownie sprawdzono bez ostrzeżeń.

## 3. Nowy globalny forward

1. **Skończone sumy:** Sums/Evaluation budują niezależną ewaluację
   `Σ a[k]*z^k modq`, dowodzą linearności, split i zgodności z List.ofFn/foldl.
   Redukcja modulo każdego źródłowego store jest zachowana.
2. **Root:** root_coefficients daje ewaluacyjne twierdzenie o obu połowach
   długości768, z etykietami14649 i1−14649.
3. **Split:** split_layout łączy numer pary, pairAddr, gm[m+u1], znak dziecka
   i fizyczny blockBase. binary_block_eval dowodzi zachowania ewaluacji przez
   konkretny etap sekwencyjnych stores, konsumując ukończone prefix/layout facts.
4. **Osiem etapów:** middle_eval jest indukcją po faktycznym forwardSchedule;
   nie zastępuje forwardMiddle idealną transformacją. Łączy wszystkie stany
   od stopnia768 do3.
5. **Węzły i cubic:** nowy, kernelowo sprawdzony certyfikat wiąże wszystkie1536
   węzłów z fizycznym indeksem gmAt, etykietami ośmiu przodków, PhiZero oraz
   współczynnikami1,z,z² rzeczywistego cubic expression. Nie dodaje nowych
   literalnych tablic. Soundness szybkiego potęgowania i checkera jest dowiedziona.
   Source-expression soundness przenosi stałe na wszystkie dane wejściowe.

Wynik:

```text
∀ canonical v, ∀b<512, ∀j<3,
 forwardC(v)[3b+j]
 = sum(k=0..1535, v[k]*(ordinary(gmAt(512+b))*14648^j)^k) mod18433.
```

Współrzędne3b+j i wszystkie użyte etykiety są częścią dowodu, nie przesłanką.
Eksport `node_zero` daje zera Phi. Szczegółowe inwarianty i ich zależności:
INVARIANTS.md; połączenie z liniami C: SOURCE_MODEL_BINDING.md.

## 4. Iloczyn, lift i pełna kompozycja

Monomials.remMonomial_eval dowodzi dla każdego wymaganego stopnia0..3070
zachowania ewaluacji przez dokładnie historyczną redukcję:

```
k<1536        : X^k
1536<=k<2304  : X^(k-768)-X^(k-1536)
2304<=k<=3070 : -X^(k-2304).
```

Używa równań z^1536≡z^768−1 i z^2304≡−1. productCoefficient_eq wiąże
pomocniczą notację sum z oryginalnym coefficient product. Dystrybucja,
zamiana skończonych sum i z^(i+j)=z^i*z^j dają multiplicativity ewaluacji.

Canonicalizację liftu usuwa eval_mod_coeff, a rozkład każdej pozycji
`i=3*(i/3)+(i%3)` przenosi wynik na równość całych wektorów:

```text
FT1536Forward.forward_product : ∀h r,
 liftForward(product h r)=pointMul(liftForward h)(liftForward r).
```

To twierdzenie obejmuje wszystkie wektory całkowite i nie ma hipotezy
o ewaluacji lub globalnej poprawności. Odziedziczony inverse_forward domyka
Pipeline. Osobne L_NTT_p, L_NTT_d i L_NTT_ranges podają wymagane p,d i zakresy.
pipeline_intermediate_ranges oraz point_prefix_range rozliczają stany helperów.

Na końcu product_canonical_inputs i rho_contract dają L_NTT_rho:
przy canonical h,c i wszystkich signed int16 s,
`pipelineC h (rhoVec s) c=(product h s,subtract(product h s)c)`.
Nie utożsamia się tej arytmetycznej konsekwencji z poprawnością parsera/normy.

## 5. Kontrole i niezależne odtworzenie

- Lean4.34.0/Std, commit293d5d0c0c3f3dded4688b3ccd6a33939ac5102b;
  GCC14.2.0/x86_64-linux-gnu/C99; Sage10.9, Python Sage3.14.7;
  Python systemowy3.13.5. Pełne wersje i strumienie: TOOLCHAIN.txt.
- **63 moduły,472 twierdzenia:**351 z GLOBAL,12 z RHO,109 nowych.
  Wszystkie finalne logi czyste. Standardowe aksjomaty tylko propext,
  Classical.choice, Quot.sound. Bez sorry/admit/native_decide/lokalnych aksjomatów.
- Audit.stdout SHA-256:
  `2591ec617b95ebbe1045bf38aa3b69cc03c19689c6bf1e94d5ec0ad6c694864c`.
  Pełne typy/proof terms AuditTypes.stdout:
  `a134885875d2ad71ba00a67b2dec8e3e1f491bae91b47d8593697c710635af66`.
- Mały niezależny oracle Sage:15 węzłów wyznaczonych zamkniętą formułą625,
  15 root labels,120 binary labels,11 stopni remMonomial przy granicach
  i165 ewaluacji zredukowanych monomianów.
- Wykryto5 zmian: word+1, zły fizyczny indeks, znak split, slot cubic,
  znak najwyższej gałęzi remMonomial. No-op przeszedł. CheckerControls
  sprawdza reakcje kernelowo; Sage niezależnie odrzuca złą redukcję.
- Dwa nowe syntetyczne przypadki source pipeline, bez instrumentacji C:
  canonical_dense i rho_boundaries. Sage liczy niezależny iloczyn modulo Phi;
  p,d zgadzają się we wszystkich6144 współczynnikach.
- **Świeży rehearsal PASS:217/217 plików znaczeniowych identycznych**,
  bez przeniesienia olean/binariów/cache i bez wymagania Dokumenty/H.
  Pełne294 pliki receipts/strumieni zachowano w artifacts/rehearsal/.
- Standardowy interfejs replay wymaga zewnętrznego SHA OUTPUTS i nowego DEST
  pod tmp; sprawdza manifest przed wykonaniem, zapisuje DEST/REPLAY_RESULT.json
  z identyczną listą matches. Rehearsal ma osobną jawną kotwicę, bez cyklu hashy.
  Kontrole protokołu obejmują pin, zmienione bajty, traversal, symlink i duplikat.

Kontrole są dowodami bindingu i odtwarzalności. Uniwersalna teza wynika
z dowodów kernelowych, nie z liczby przypadków lub przejścia testów.
Nie ponowiono szerokiej kampanii prymitywów ani inverse.

## 6. Wykonanie i historia prób

Sandbox sprawdzono rzeczywistym O_WRONLY bez zapisu bajtów: tylko W writable,
repo AGENTS, stages i dokument zadania EROFS. Joby miały read-only root/source,
write bind W, własne HOME/TMPDIR/DOT_SAGE/LEAN_PATH, bez sieci.
Stosowano8GiB address space, Lean `-j1 -M2048`, skończone limity per job.
Nie użyto innych agentów, instalacji, sekretów, nowych kluczy ani operacji Git.

Nieudane próby zachowano. Dwa zbyt szerokie uproszczenia powodowały kosztowną
elaborację; poprawiono normalizację emod i użyto jawnej kompozycji równości.
Pierwszy well-founded helper powFast blokował redukcję decide; zastąpiono
wyłącznie nowy helper strukturalnym powFuel i dowiedziono jego poprawności.
Pozostałe błędy były lokalnymi błędami taktyk/nazw. Nie zmieniono żadnego
konsumowanego modelu, by ułatwić tezę. Timeouty/błędy nie zostały nazwane
kontrprzykładami; końcowe źródła i logi są od nich oddzielone w OUTPUT_SCOPE.

## 7. Zamknięcie etapu i dalszy krok

Macierz26 pozycji pokazuje odziedziczone inverse/range/prefix/lift i nowe
FORWARD_GLOBAL, PRODUCT, SUBTRACT, RHO_SUBSTITUTION oraz pełne L_NTT.
W zakresie L_NTT nie pozostał blokujący globalny obowiązek.

Prowadzący sesję powinien odebrać pakiet, zweryfikować zewnętrzne piny,
zaimportować go z `--replay standard` i wykonać osobny checkpoint commit.
Następny matematyczny etap: domknąć pozostały most L_V dla tego samego
kandydata — centrowanie C, dokładność Q i ścisły próg B wraz z parserem.
Ten raport kończy się przed tym etapem i przed integracją źródeł.

Dokładna teza: CLAIM.md. Wyprowadzenie: INVARIANTS.md. Konsumpcja:
REUSED_RESULTS.md. Wynik maszynowy: RESULT.json. Replay: REPLAY.md.
Zamrożony zakres i prefiks dziennika: OUTPUT_SCOPE.md / OUTPUTS.sha256.
