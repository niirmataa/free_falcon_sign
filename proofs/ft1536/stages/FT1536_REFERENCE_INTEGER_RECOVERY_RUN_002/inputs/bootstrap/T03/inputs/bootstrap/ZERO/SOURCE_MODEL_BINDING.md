# H3_ZERO_SCALAR — zakres C/model/proof

Źródła to dokładne17 plików bootstrap z BASEcb99e67ae6f7cfa1c79be23d70c8fbfbe6874f13.
Nie zmieniono guards, signed zero, arytmetyki ani parametrów. Spans/hashes:
artifacts/source_binding.json. Toolchain GCC14.2/C99/Linux x86_64 LP64,
portable active C FPEMU. Nie użyto gałęzi ARM lub fpr-double jako semantyki.

## Literalny i source-normalized model

scripts/fp_literal.py odtwarza uint32/64 masks, shifts, xor/OR, signed64
shifts, FPR_NORM64, FPR pack, scaled(sc0), add/sub oraz floor. Każdy unsigned
wrap jest jawny. Python integer right shift odpowiada arithmetic shift
wybranego GCC dla signed64; nie ogłaszamy gwarancji wszystkich implementacji C99.

Modele Lean redukują maski znanych0/1 do równoważnych gałęzi, zachowując
cały rzeczywisty integer transducer. Te redukcje są częścią jawnego bindingu,
nie definicją wyniku przez idealną arytmetykę lub pożądany error bound.

### floor117–133

rawMant jest dosłownym uint64 shift10/mod64, ORbit62 i ANDlow63.
raw_mantissa dowodzi2^62+1024*frac. Sign t jest0/1; `(xi^-t)+t` to ±xi,
bez overflow ponieważ2^62<=xi<2^63. `fpr_irsh` wykonuje conditional right32
i right(n&31), zatem arithmetic shift n∈[0,63], czyli signed integer ediv2^n.
Końcowe xor-mask wybiera−t gdy unsigned sign test `(63-cc)` jest1, inaczej
shifted. SourceFloor.floorC zachowuje cc=1085−e i cc&63/uint32 sign test;
nie jest definicją floorVal−eps0. Kernel wyprowadza dopiero tę równość.

### FPR_NORM64 / scaled151–204

Każde maskowane przesunięcie k∈{32,16,8,4,2,1} jest równoważne nstep,
przy m<2^(64−k). W aktywnej gałęzi m*2^k nie przekracza uint64; nieaktywne
unsigned shift może zawijać i jest odmaskowane, co jest legalne. E adjustment
to−63+Σnt*k = −sum(active shifts). Kernel normalizer_bounds sprawdza
całą domenę m<2^64; nie korzysta z próbek klucza.

OF_EXACT dotyczy sc=0 i signed32, dokładnie fpr_of(s), fpr_of(s+z).
Absolute value w int64 i corrective mask są legalne, bo nie ma−2^63.
Po normalize shift>=32 nie ginie żaden użyteczny bit w shrink9/pack2;
ofC(0)=+0. PackOf zachowuje source-normalized instrukcje, nie używa idealnego
encoder-oracle do zdefiniowania ofC.

### add449–556 / sub151–156 / pack39–55

LiteralAdd.addC wykonuje ten sam magnitude/sign-tie swap, exponent0 hidden
bit handling, alignment z drop>=60 i sticky, signed mantissa sum/difference,
normalize, shrink9, underflow clamp i rounding0xC8. Normalized Nat subtraction
jest równoważne unsigned64: ANALYTIC_PROOF§2.3 wyprowadza nieujemność T
z sort/alignment i pokazuje, że modulo nie zmienia końcowego T.
packNormal odpowiada actual bit assembly w udowodnionej normalnej gałęzi;
pozostała gałąź daje dokładne signed-zero bits. sub zmienia sign operand2,
nie canonicalizuje jego zera. All locals/shifts/casts są zdefiniowane w
przedziałach wykazanych w ANALYTIC_PROOF, bez założenia complete IEEE.

ValueDomain.val jest niezależną dyadyczną interpretacją wejścia. Przy
NumericCenter i signed32 of inputs exponents<=1054; to domena analitycznego
SOURCE_ADD_ERROR. Decode exp0, alignment, shrink i pack mają wyprowadzone
osobne boundy, składane do E_r=E_res=2^-20. Nie sprawdza się jedynie,
czy kilka testów zmieściło się w arbitralnie wybranym E.

## Granica kernelizacji

Kernel: NumericCenter/exponent, raw mantissa/floor, zero-aware formula,
integer bridge, exact rho/residual, normalize/sticky/pack lemmas, exact of,
budżet liczbowy oraz typed ordered consumers. **Nie ma pełnego kernelowego
proof `∀x z,NumericCenter→SUB_RESIDUAL_CONTRACT`.** Ten dokładny universal
contract ma dowód analityczny po wszystkich fazach źródła w ANALYTIC_PROOF.
Typed Lean consumers jawnie przyjmują go jako argument; nie użyto aksjomatu,
sorry ani pozornego theorem hiding. C-to-model translation i cały mixed proof
nie są dowodem zweryfikowanego GCC.

## Kontrole powiązania

checks/scalar.c dołącza oryginalny header i aktywne fpr-emulated.c. Wykonuje
wyłącznie publiczne scalar words/integers. Nie ma KeyGen, prywatnego loadera,
Sign, PRNG seedu, instrumentacji guards ani zmiany źródeł.
1160 par wewnątrz domeny porównano raw-bitowo z literal Python i Lean model;
70 par poza domeną zatrzymano przed potencjalnym nielegalnym signed sum.
Normal i ASan/UBSan zgadzają się. Kontrole3480 add-transcripts sprawdzają
przypisanie KAŻDEGO error summand do rzeczywistych intermediate values.
R/delta zeros są sprawdzane bitowo, nie tylko przez val(-0)=val(+0).

Mutacje dotyczą rzeczywistych równań/allowances: eps0 pominięte, floor→trunc,
rho<1, zero pack-round/underflow allowance, endpoint przesunięty o1.
Witnessy błędów są w controls/phase_controls. No-op x xor0 zachowuje raw bits.
Finite controls są bindingiem, nie zastępują uniwersalnego argumentu.
