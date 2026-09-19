# H3_ZERO_SCALAR — nowy lokalny kontrakt

Autor projektu: Niirmata. Aktywne źródła C/FPEMU są niezmienione, manifest
`2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a`.
Model: GCC14.2/C99/Linux x86_64 LP64; aktywna gałąź portable C FPEMU.

## Definicje niezależne od wyniku

Word64 x ma dokładną wartość dyadyczną val(x) określoną przez standardowe
pola wejściowego finite binary64, w tym exponent0 i oba zera. To interpretacja
wejścia, NIE założenie IEEE arithmetic backendu. W Lean val=valueNum/D,
D=2^1074. Definicja obsługuje wszystkie finite exponents, bez Nat-subtraction
poza domeną starego mathFloor.

```
NumericCenter(x) := Word64(x) and finite(x) and
                   -2147483283 <= val(x) <2147483282.
eps0(x) := 1 if x=0x8000000000000000 else0.
s_C := source fpr_floor_C(x).
r_C := sub_C(x,of_C(s_C)).
res_C(x,z) := sub_C(x,of_C(s_C+z)).
delta_C(x) := sub_C(of_C(1),r_C(x)).
```

NumericCenter NIE zawiera NotNegZero, normalności lub poprawności floor.
source floor/of/add/sub są wykonywalnymi integer/bit transducerami, nie
definicjami przez dowodzone prawe strony. Literalna transkrypcja:
scripts/fp_literal.py; source-normalized Lean: SourceFloor/PackOf/LiteralAdd.

## A — kernel z jawną translacją C

Dla każdego NumericCenter x:

```
exponent(x)<=1053
s_C(x)=floor(val(x))-eps0(x)
long->int jest dokładne
forall z in[-365,366], INT32_MIN<=s_C(x)+z<=INT32_MAX.
```

Mathematical-floor equality zachodzi iff x≠−0 w tej domenie. Oba zera
spełniają NumericCenter. Stare CenterClass jest dokładnie węższym interfejsem
wykluczającym−0; nie przepisano jego definicji ani historycznego H3_RANGE.

## B — uniwersalny dowód analityczny wsparty kernelowymi lematami

Konkretnie E_r=E_res=1/1048576 (<1/4). Dla WSZYSTKICH NumericCenter x
i WSZYSTKICH z∈[−365,366]:

```
of_C(s_C),of_C(s_C+z) dokładnie reprezentują te signed32 integers;
r_C,res_C są finite;
abs(val(r_C)-(val(x)-s_C)) <= E_r;
abs(val(res_C)-(val(x)-(s_C+z))) <= E_res.
```

Uniwersalny source-add proof rozlicza decode exp0, alignment sticky, sześć
normalizing shifts, shrink9, pack/round i clamp underflow. Nie pozostawia
symbolicznego E z założoną żądaną nierównością. Szczegóły: ANALYTIC_PROOF.md;
exact class certificate i lematy BitErrors/PackOf/ErrorArithmetic.

**Zakres formalizacji:** dokładność of i lokalne integer lemmas są kernelowe;
kompletne SOURCE_ADD_ERROR oraz wyspecjalizowane r/delta case analysis są
analityczne. Nie twierdzimy, że cała uniwersalna nierówność sub_C została
skernelizowana. W Lean SUB_CENTER_CONTRACT/SUB_RESIDUAL_CONTRACT są precyzyjnymi
typami tej tezy, nie aksjomatami. Ich konsument ujawnia analityczny kontrakt
jako argument, a ANALYTIC_PROOF rozlicza go dla wszystkich wejść domeny.

Ponadto r_C oraz delta_C są +0 albo positive normal, ich wartości należą
do[0,1]. Endpoint1 jest też osiągany dla niezerowych x, np.−2^-1074.
res_C może być−0 (np. x=−0,z=1); nie canonicalizujemy source zeros.

## C — konsumowalny wynik residuum

Dokładne rho=val(x)−s_C spełnia0<=rho<=1. Z tego, bez zwiększania366:

```
abs(val(x)-(s_C+z))<=366,
abs(val(res_C(x,z)))<=366+1/1048576.
```

Nowy ORDERED_ZERO_TERMINAL podstawia wyprowadzone E_res; E_half/E_add
pozostają jawne w dalszym source-prefix użyciu. Nie używa się przyszłego
return do uzasadnienia jego center ani closeness dla fault0.

## Status i odrębne dalsze obowiązki

`H3_ZERO_SCALAR_PROVED_FOR_PINNED_MODEL` oznacza powyższy lokalny, mieszany
kernelowo/analityczny kontrakt. Nie oznacza globalnego Reach ani scalar law.
H3_range_proved=false; global_reachability_proved=false; sampler_law_proved=false.
Baseline_source_integrated=true; source_changed=false; new_source_patch_integrated=false;
protocol_wrapper_integrated=false; owner_accepted=false; security_reduction_proved=false.

N/q/Phi/sigma/B, MODE1, M0 caller4096/r40 i parametryczny cel pozostają te same.
Przyszły `Reach_call_C(...) -> NumericCenter(mu)` oraz poprawne spożycie
zero-aware kernelu przez dowód prawa samplera są osobnymi zadaniami.
