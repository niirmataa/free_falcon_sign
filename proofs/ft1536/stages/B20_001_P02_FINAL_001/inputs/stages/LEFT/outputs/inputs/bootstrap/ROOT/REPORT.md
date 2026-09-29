# FT1536 H3_ROOT_LDL — certyfikat źródłowego korzenia

Data:2026-09-19. Autor projektu: Niirmata. Wykonawca: GPT-ASTRA.
W: `/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_H3_ROOT_LDL_RUN_001`.

## 1. Werdykt

**H3_ROOT_LDL_PROVED_FOR_PINNED_MODEL.** Domknięto zadany numeryczny
RootCertificate dla całego emitted-KeyGen support, poprzez jawny nadzbiór
P_key i source roundtrip tego samego sk. FFT/Gram, dodatni divisor,
bezpośrednie divisions, finite L, dodatnie subtractive D_C, jego imaginary
error i conditional root frame są rozliczone. Numerical premises nie
pozostawiono jako assumptions potrzebnych do końcowego wniosku.

Zakres dowodu jest **mieszany**: kernelowe integer lemmas/modele i frame
composition, uniwersalny analityczny source/domain/error argument oraz
exact QQ/polynomial/RBF certificates. Pełnego theorem RootCertificate
i C/compiler semantics nie skernelizowano. Kernel audit conditional
consumers nie jest przedstawiany jako usunięcie ich jawnych przesłanek.

Nie wynika stąd poprawność wszystkich wcześniejszych/późniejszych subtrees,
initial targets, global Reach lub prawa samplera. Wszystkie odpowiednie
flagi pozostają false, zgodnie z§8.

## 2. Piny, profil i źródła

- TASK: `792e4f012e3fd2c0a744d1d6cd8449858386f1c19958c6a8a4ceabdeca561693`.
- Bootstrap MANIFEST: `f1f5aee612f7f1651ec79a5e716a8f6d2963b5121566e80c7335ce0bf32dac73`.
- BASE: `9a76ecfd72d83e131d79299f0249bca1efdf9468`.
- Candidate manifest: `2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a`.
- Zweryfikowano106/106 członków i104 publiczne ORIGINS; źródła17/17 byte-identical.
  INPUTS/provenance obejmują110 publicznych records z TASK/AGENTS/manifestem.

N1536/q18433/Phi=X^1536−X^768+1/sigma768/B2093922385, MODE1/FPEMU i dokładne
Makefile flags. M0 caller4096, nonce40 osobno,16 outer attempts, jeden
K_seed[E] warunkowany sukcesem CAŁEGO KeyGen oraz parametryczny cel pozostają
tym samym kontraktem. Źródłem jest bootstrap, nie bieżące Extra/c/index.

## 3. Dokładna teza i stałe

```
forall E,sk,pk,p,
 Emitted_C(E,sk,pk) -> SourceDecodeSameSTATIC(sk)=p -> P_key(p);
forall p, P_key(p) -> Defined(RootSlice_C(p)) and RootCertificate(p).
```

E jest legalnym środowiskiem M0, sk/pk finite byte strings, p=(f,g,F,G)
czterema Int^1536 vectors. P_key to ternary f/g, caps2047 dla F/G, exact NTRU
i rzeczywisty mandatory Gate00_C; EMITTED_BINDING dowodzi ich z source paths.
Nie zawiera małego L, desired errors/pivots, NumericCenter ani Babai boundu.
API/model premises to legalne buffers/lifetimes/disjoint outputs, fixed
GCC14.2/C99/LP64 integer semantics i operacyjny defined source execution.

RootSlice realizuje of/FFT3, B=[[g,−f],[G,−F]], root Gram i ORYGINALNE
LDL_dim2: L przez div każdego componentu, D przez muladj/neg/add. Exact
A,C,J,L=C/A,D=q²/A są niezależnymi ring evaluations w frequency map
`r=1+6*rev8(j)+1536k`, slot i=3j+k, real i/imag i+768, bez normalization1/N.

| Wielkość | Jednostajny wynik dla wszystkich768 frequency slots |
|---|---|
| FFT component error f/g | <2^-26 |
| FFT component error F/G | <2^-15 |
| Gram errors względem A,C,J | odpowiednio <1/1024, complex norm<1, <1024 |
| g00_C real | 1/2≤g00_C<2^23; positive normal |
| g10_C complex norm | <2^35 |
| g11_C real | 1/8<g11_C<2^45; positive normal |
| g00_C/g11_C imaginary bits | dokładnie+0 |
| L_C complex norm / error względem C/A | <2^25 / <2^14 |
| Re(D_C) | **32<Re(D_C)<2^31**, positive normal |
| abs(Im(D_C)) | **<32**, finite; nie założono exact0 |
| complex norm(D_C−q²/A) | <2^22 |

FFT absolute component bounds:1536+2^-26 i3144192+2^-15. L i imag D mają
finite normal/zero classes, zgodne z source bit semantics. Defined reciprocal
1/g00_C jest positive normal w[2^-23,2]; rzeczywiste L nadal używa dwóch div.
Pełny rekord maszynowo czytelny: ROOT_CERTIFICATE.json. Stałe są konserwatywne,
bez wymagania dowolnie narzuconego małego L lub minimalnego absolute error.

## 4. Co domknęło dodatniość subtractive D

ANALYTIC_PROOF rozszerza source phase analysis add do operand cap2^100,
wyprowadza osobne mul/div domain/error contracts i rozlicza exp0/clamp.
Stosuje u=2^-48, eta=2^-900 jako jawne majoranty, nie complete IEEE model.
ZERO E2^-20 z domain exponent≤1054 nie zostało przeniesione do root g11.

Najważniejszy krok zachowuje exact Gram obliczonej FFT macierzy:
`a=|fhat|²+|ghat|²`, `c=Ghat conj(ghat)+Fhat conj(fhat)`,
`j=|Fhat|²+|Ghat|²`, `v=fhat Ghat−ghat Fhat`.
Exact identity `aj−|c|²=|v|²`, |v−q|<1 oraz Cauchy wiążą cancellation,
zamiast używać niezależnego pessimistic interval boxu. Source Gram errors
są≤8u*a,8u*j,8u*sqrt(aj), a cała rzeczywista source Schur operacja spełnia
`|D_C−|v|²/a|≤256u*j`. QQ certificate sprawdza dodatni margin powyżej32.

Luźniejszy końcowy absolute error2^22 wobec q²/A NIE dowodzi sam dodatniości.
Tę własność daje skorelowana tożsamość przy computed FFT matrix z rozliczonym
rounding. Również imaginary error pochodzi z całej complex kompozycji.

## 5. Emitted membership i frame

Source caps są checked stores, nie statystyką klucza. Końcowy NTRU verifier
solve_NTRU działa już po caps: p=2147355649, primitive source generator
1907584673. Certyfikat sprawdza1024 table entries,2359296 symbolic coefficient
weights i1536 distinct Phi roots. Equality modp plus integer remainder
bound18883585<p daje exact NTRU. Successful STATIC serializers i source
decoder zachowują wszystkie cztery vectors tego samego sk.

Keygen gate/loader używają tych samych of/FFT/znaków/Gram. Sześć par helperów
signer/keygen jest token-identical po usunięciu komentarzy/suffixu. Mandatory
gate sprawdza real g00≥1/2 po rekurencji; fallback nie zeruje sticky bad.
Source frame wiąże te słowa z original root Gram, a nie z samą nazwą normy.

Chronologia rzeczywistego loadera zachowana: split g00 i pierwsze subtree,
dopiero root dim2. Dla KAŻDEGO defined prefixu docierającego do root call
udowodniono brak zapisu do root g00/g10/g11. RootSlice nie implikuje, że cała
wcześniejsza rekurencja ma legalne numerical domains. ROOT_FRAME rozlicza
write footprints, tree18432 i scratch sizes oraz oddzielne allocations.

## 6. Weryfikacja i replay

- Lean4.34/Std: **17 modułów,99 twierdzeń,17 nowych**;11 inherited modules
  byte-identical i rebuild ze źródeł. Wszystkie końcowe logi czyste.
- Pełne types/implicits/terms NOWYCH twierdzeń: RootTypes.stdout SHA
  `c03bb52755801f71bd1c9ecb1ab22c2849bdab2545a7ca5c1b1ee57eeb00b8e7`.
  RootAudit.stdout SHA `41df3f1212d4da9941ba3cfe7a7fc0e95d56a4adfb3fd174f2b2ad66586d4dcf`.
  Tylko propext/Classical.choice/Quot.sound; bez lokalnych aksjomatów wniosku.
- FFT checker obejmuje **1179648** symbolic coefficient weights całegoN1536,
  RBF256 sprawdza wszystkie użyte twiddles. Nowe QQ recurrences nie zakładają
  historical correctly-rounded backend premise.
- C normal i ASan/UBSan:334 scalar pairs;768 root spectral slots; dwa pełne
  publiczne polinomowe cases, po13824 output words; trzy first-subtree/frame
  cases i dozwolony input alias. Wszystkie raw bits zgodne z modelem.
- Lean mul/div wykonane na334 parach zgadzają się bitowo z C/literal model.
- Independent RBF oracle:6208 FFT components, all768 sparse slots i8 dense
  slots; exact dyadic stage comparisons. Mutacje FFT/Gram/div/sub error,
  conjugation, reciprocal replacement oraz E2^-20 poza domeną wykryte.
  No-op XOR0 przechodzi. Przykładowy niezerowy imag D_C z synthetic dense
  case1, slot9: raw `be40000000000000` (−2^-27). Nie jest to emitted witness.
- **Fresh rehearsal PASS131/131**, z pełnym rebuildem, bez starych olean/bin/
  cache. Po freeze standard replay wymaga końcowego zewnętrznego OUTPUTS pin.
  Receipt i matches są związane manifestem; standardowy wynik pozostaje
  w nowym DEST, bez przepisywania frozen report.

Kontrole nie są dowodem uniwersalności przez same próby. Complete symbolic
maps i analytic soundness argument są opisane osobno. Pinned proof text
skopiowany przez replay nie staje się przez byte equality kernel-certified.

## 7. Próby odrzucone i zakres wykonania

Zachowano pełne logs/COMMANDS i wersje attempts: brakujący transitive import,
Sage cwd/import-path diagnostics, unused simp warnings/IO.getArgs w nowych
Lean, poprawione przed finalem. Pierwszy rigorous dense oracle przez Hornera
dał interval wrapping do±7.96e132 — zbyt szerokie enclosure, nie counterexample
FPEMU. Zastąpiono go niezależną sumą przy rigorous unit roots; kontrola PASS.
W trakcie audytu doprecyzowano propagację tiny terms (8eta i lower bound
sqrt(j/a)); nie wymuszano IEEE lub small-L premise dla PASS.

Rzeczywisty bwrap/EROFS probe potwierdził W-only zapis i readonly bootstrap;
source jest readonly w kolejnych jobach. Executor lock, skończone limity,
Lean -j1 -M2048/8GiB, osobny ASan shadow mode; HOME/TMPDIR/DOT_SAGE/cache podW.
Nie uruchamiano KeyGen/private loadera/Sign, nie czytano kluczy/seedów,
nie używano sieci/instalacji/innych agentów/Git. NTT(X) to publiczny helper,
nie key generation. Oryginalne atrybucje Falcon/Pornin pozostają w źródłach.

## 8. Handoff i dalszy typ

NEXT_INTERFACE eksportuje obie root branches/L i pełny następny cel:

```
exists c3 : Node3Constants, ValidConstants(c3) and
 forall p : Key4, P_key(p) -> forall b : Fin2,
  let v := if b=0 then RootSlice_C(p).g00 else RootSlice_C(p).d11;
  let (t0,t1,t2) := SplitTop_C(v,10);
  let u1 := Adj_C(t1,9,0); let u2 := Adj_C(t2,9,0);
  Defined(SplitTop_C;Adj_C;LDL_dim3_C(t0,u1,t0,u2,u1,t0,9,0)) and
  forall j : Fin256,
   Node3Certificate(c3,j,t0,u1,u2,LDL_dim3_C(...),
     ExactSplitAndSchur(if b=0 then A(p) else q²/A(p),j)).
```

Pełne znaczenie rekordu c3 i Node3Certificate, bez numerical premise w
poprzedniku, opisuje NEXT_INTERFACE. Potem pozostają split_deep/internal
tree, INITIAL_TARGETS i ORDERED_REACH konsumujące ZERO_SCALAR dopiero po
NumericCenter. Imaginary errors i real-slot denominators wymagają dalszego
propagowania; fault0 nie ma closeness. Sampler-law/H1R/FFO/R5T/M7 odrębnie.

H3_range_proved=false; global_reachability_proved=false;
full_internal_tree_proved=false; sampler_law_proved=false;
security_reduction_proved=false; baseline_source_integrated=true;
source_changed=false; new_source_patch_integrated=false;
protocol_wrapper_integrated=false; owner_accepted=false.

Pakiet jest checkpointem root proof, nie integracją źródeł lub owner acceptance.
Odbiór, import i commit wykonuje prowadzący. Nie rozpoczęto kolejnego etapu.
