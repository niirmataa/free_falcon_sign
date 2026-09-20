# FT1536 H3_ZERO_SCALAR — lokalny most z jawnym −0

Data zadania:2026-09-19. Autor projektu: Niirmata. Wykonawca: GPT-ASTRA.
W: `/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_H3_ZERO_SCALAR_RUN_001`.

## 1. Werdykt i warstwy dowodu

**H3_ZERO_SCALAR_PROVED_FOR_PINNED_MODEL**, w pełnej zadanej lokalnej domenie
NumericCenter, z konkretnymi `E_r=E_res=1/1048576`.

Wynik ma **mieszany charakter dowodowy**:
- A: kernelowy zero-aware floor/exponent/cast/s+z z jawnym C integer bindingiem;
- OF_EXACT i normalize/sticky/pack: kernelowe source-normalized transducery;
- B: uniwersalny analityczny dowód błędów rzeczywistych of/sub po wszystkich
  source branches, oparty na powyższych lematach i dokładnym certyfikacie klas;
- r/delta: pełna analityczna analiza przypadków oraz kernelowe endpoint facts;
- C: kernelowe rho/exact-residual/ordered lemmas z analitycznie rozliczoną
  source-error przesłanką i konkretnym E_res.

**Nie twierdzę, że kompletne SOURCE_ADD_ERROR zostało skernelizowane.**
Lean konsument CONSUME_SUB_RESIDUAL jawnie przyjmuje SUB_RESIDUAL_CONTRACT;
ten upstream kontrakt jest dowiedziony analitycznie w ANALYTIC_PROOF, nie
przez testy, sorry lub aksjomat. Raport/audit/replay zachowują to rozróżnienie.

H3_range_proved=false, global_reachability_proved=false, sampler_law_proved=false.
Nowy wynik nie zastępuje starego H3_RANGE ani M0 i nie rozstrzyga osiągalności−0.

## 2. Piny i dziedzina

TASK: `0c039d00fdb229b909e6eee76b53ecb340a02c3c3b1b0cc3203bcf1332bf9fdd`.
Bootstrap MANIFEST: `e8eb2b091e9396d08afbdd3f8b4adebbebf97e7a0890306c5cf07c8e7beb4099`.
Sprawdzono73/73 członków,71 original records oraz17 źródeł kandydata
o manifeście2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a.
Baza:cb99e67ae6f7cfa1c79be23d70c8fbfbe6874f13. Bootstrap/source read-only.

NumericCenter definiuje niezależne finite val(x), także exponent0 i obu zer:

```
Word64(x) and finite(x) and -2147483283<=val(x)<2147483282.
```

Nie zawiera NotNegZero, normalności ani poprawności floor. ValueDomain
używa pełnej exact dyadic interpretacji valueNum/2^1074. Dopiero z niej
wyprowadza exponent<=1053, przed użyciem starego low-exponent mathFloor.
Sześć konsumowanych modułów H3 pozostało byte-identical i zostało odbudowane
ze źródeł. Stare olean/cache nie były inputami proof. Helpery i ich layout
są opisane w REUSED_RESULTS i reuse_layout.json.

N1536/q18433/Phi=X^1536−X^768+1/sigma768/B2093922385, MODE1/FPEMU oraz
M0 caller4096, nonce40,16 attempts i parametryczny cel są bez zmian.

## 3. Co nowego domknięto w A

SourceFloor.floorC jest integer/bit modelem instrukcji źródła: raw mantissa
shift/mask, sign selection, cc/shift i uint32 końcowa maska. Nie jest
zdefiniowany przez pożądaną prawą stronę. Kernel wyprowadza:

```
s_C(x)=floor(val(x))-eps0(x),
eps0=1 dokładnie dla raw0x8000000000000000, inaczej0.
```

Stąd long→int jest dokładne i każdy source successful proposal z∈[-365,366]
daje zdefiniowane int32 s_C+z. Nie potrzeba usuwania−0: source s=−1 leży
wewnątrz bezpiecznej domeny. Mathematical-floor equality wciąż wymaga
x≠−0, co jest jawnie odróżnione od poprawnej zero-aware formuły i integer safety.
Old CenterClass implikuje NumericCenter; na nowej domenie jest równoważny
wykluczeniu−0. Historyczna teza nie została przepisana.

## 4. B — konkretny lokalny błąd FPEMU

OF_EXACT dowodzi exact signed32 conversion przez rzeczywisty normalize,
sticky shrink i pack (sc0), z legalnością pośrednich int64 operations.

ANALYTIC_PROOF.§2 dowodzi SOURCE_ADD_ERROR dla wszystkich finite words
z encoded exponents<=1054. Ten zakres obejmuje x z NumericCenter oraz
of(s_C),of(s_C+z). Dla lambda=2^(e_max−1078)<=2^-24:

```
exp0 decode error <2^-1022 (dwa operands razem),
alignment sticky error <=lambda,
normalize exact; shrink9 error <=4lambda,
pack rounding error <=8lambda, albo underflow <2^-1022;
total <=13*2^-24+2^-1021 <2^-20.
```

Nie założono ogólnego IEEE u|x|+eta. Rozliczono rzeczywiste half-value
wewnętrzne odczytanie subnormal przez add, source flush, signed zeros,
rounding0xC8 i cancellation. Output exponent<=1056, więc finite; wynik jest
normal albo signed zero. Sub to source sign flip drugiego argumentu.
Nieznanych symbolicznych błędów nie przyjęto jako twierdzenia.

Uniwersalnie po całej lokalnej domenie:

```
r_C=sub_C(x,of_C(s_C)), res_C=sub_C(x,of_C(s_C+z)) finite,
|val(r_C)-(val(x)-s_C)| <=1/1048576,
|val(res_C)-(val(x)-(s_C+z))| <=1/1048576.
```

Exact certificate obejmuje64 leading-bit interval classes normalizera,
8 rounding remainders,32 nonzero signed32 magnitude ranks i60135 exponent/
shift classes. Fraction variables są objęte uniwersalnymi inequalities,
nie skończoną kampanią enumeracji wejść. Normalizer/sticky/pack kernels są
sprawdzone w Lean; całe przypisanie source phases do error sum jest analityczne.

## 5. R/delta i residuum do następnej indukcji

Dokładne rho=val(x)−s_C∈[0,1], a endpoint1 jest poprawny. Wyspecjalizowana
source case analysis daje również **val(r_C),val(delta_C)∈[0,1]**; ich bits
to+0 albo positive normal, nigdy−0 lub subnormal. Same±E nie wystarczyłyby
do tego mocniejszego wniosku, dlatego jest dowiedziony osobno.

- +0: s=0, r_C=+0, delta_C=1;
- −0: s=−1, r_C=1, delta_C=+0;
- −2^-1074: r_C także1, więc maszynowy endpoint1 nie jest wyłączny dla−0;
- res_C może być−0, np. x=−0,z=1. Zero bits nie zostały ukryte przez porównanie wartości.

Z rho∈[0,1] i z∈[-365,366] nadal wynika exact bound366, bez zwiększania go:
`|val(res_C)|<=366+1/1048576`. Nowy ORDERED_ZERO_TERMINAL ma podstawione
E_res; E_half/E_add są jawne dla kolejnych operacji/domen poza tym scalar
bridge. Indukcja używa wcześniejszego bezpiecznego center i return do
następnego center, nie przyszłego return do własnego floor. Closeness nie
jest stosowane do sticky/fault0.

Dla−0 shifted output support to[-366,365], a dla+0 [-365,366]. To nie jest
automatyczna równość source scalar law. Endpointy r/delta, finiteness,
truncated support i błąd wymagają własnego distribution/acceptance bridge.

## 6. Kontrole i audyt

GCC14.2/C99/LP64, Sage10.9, Lean4.34/Std -j1 -M2048/8GiB; pełne wersje
w TOOLCHAIN.txt. Kontrole C używają oryginalnego fpr-emulated.c/headera,
nie ARM lub fpr-double.

- 17 modułów z audytami, 97 twierdzeń: 49 odziedziczonych i 48 nowych.
  Wszystkie końcowe logi czyste, bez sorry/admit/native_decide. Standardowe
  propext/Classical.choice/Quot.sound; jawne pełne typy i termy.
- ZeroAudit.stdout hash: `1df2ca8c9554a03a9b55da35d20e57b589d263f6c53f29983c125fbb15a414c4`.
  ZeroTypes.stdout: `01d47e8e8ea35076c7eb866a68a91df08f7afc483205ffd99df8882837b890ca`.
- 246 publicznych raw patterns, 1160 par w NumericCenter i 70 poza domeną,
  zatrzymanych przed potencjalnie nielegalnym signed sum. Oba zera,
  subnormals, granice normalności, okolice integers i endpoints, z−365/366.
- Raw bits C, literalnego modelu i Lean source-normalized modelu zgadzają
  się. Exact dyadic oracle mierzy wartości/błędy niezależnie od host double.
  Normal i ASan/UBSan identyczne.
- 3480 source add-transcripts: wszystkie przypisane phase bounds zgodne;
  28 underflow branches, 383 zero-mantissa branches. Największy zaobserwowany
  residual error2^-45 jest diagnostyką, nie uniwersalną stałą wybraną z testów.
- Mutacje eps0, floor→trunc, rho<1, omitted rounding/underflow allowance
  i przesunięty integer endpoint są wykryte na rzeczywistych wartościach.
  No-op przechodzi. Nie wykonano signed overflow dla negatywnych kontroli.
- Fresh rehearsal **95/95 matches PASS**, z kernel rebuild, wszystkimi
  kontrolami i ASan/UBSan; bez olean/cache i bez zależności od Dokumenty/H.
  Po freeze standardowy replay wymaga finalnego zewnętrznego hasha OUTPUTS.

## 7. Granice i następny lemat

Zamknięto A/B/C lokalnego zadania w zakresie mixed proof powyżej. Pełne
kernelowe skomponowanie source-add error oraz r/delta case analysis może
być osobnym dalszym formalization checkpointem; nie zostało zadeklarowane
jako ukończone przez sam audit conditional consumers.

Globalny obowiązek pozostaje:

```
forall E,sk,pk,history,attempt,call,state,mu_bits,sigma_bits,
 Reach_call_C(E,sk,pk,history,attempt,call,state,mu_bits,sigma_bits) ->
 NumericCenter(mu_bits).
```

Jest to pełny kwantyfikowany cel w operacyjnej semantyce
`inputs/bootstrap/H3/REACHABILITY.md`, nie już istniejąca deklaracja Lean.
Typy argumentów: E jest legalnym środowiskiem M0, sk/pk skończonymi ciągami
bajtów, history skończoną historią tego środowiska, attempt∈{1,…,16},
call∈Nat, state typowanym stanem C (pamięć/pc/stack/contexts/fault),
mu_bits/sigma_bits∈Word64. Emitted membership, zgodność tego samego klucza,
historia i defined prefix są wymaganiami Reach, nie dodatkowymi założeniami
numerycznymi wniosku. Brak ukrytej przesłanki norm acceptance lub NotNegZero.

Wiązanie emitted keys, loadera, internal LDL, FFT/split/merge i ordered
globalnych błędów nie zostało domknięte w tym zadaniu. Stare H3_RANGE/floor
equality pozostaje open. Nowe A/B/C nie dowodzą prawa samplera ani H1R/FFO/
R5T/M7; nie przydzielono nowej globalnej straty lub abortu.

H3_range_proved=false; global_reachability_proved=false; sampler_law_proved=false;
baseline_source_integrated=true; source_changed=false; new_source_patch_integrated=false;
protocol_wrapper_integrated=false; owner_accepted=false; security_reduction_proved=false.

Nie wykonywano KeyGen/Sign, nie czytano kluczy/seedów/sekretów, nie używano
sieci, instalacji, innych agentów ani Git. Bootstrap i source były read-only,
zapisy/cache tylko pod W. Nie poprawiono programu, by uzyskać wynik.
Nieudane własne elaboracje zachowano poza finalnym zakresem; stare piny
pozostały niezmienione. Odbiór/import/commit wykonuje prowadzący sesję.
