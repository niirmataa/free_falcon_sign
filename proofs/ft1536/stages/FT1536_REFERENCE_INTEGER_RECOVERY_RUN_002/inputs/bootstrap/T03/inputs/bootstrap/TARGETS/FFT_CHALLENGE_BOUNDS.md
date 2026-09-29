# Nowy whole-domain FFT certificate dla canonical cap18432

Źródło: active falcon_FFT3,10,full1, pinned candidate. Przesłanka jest
0≤c_i≤18432 dla wszystkich1536 inputs, bez rozkładu lub centered mapping.
Conversion uint16→int→int64 jest exact; OF_EXACT obejmuje18432.

ROOT dostarcza SOURCE add/sub/mul contracts na finite |operands|≤2^100:
U=2^-48,eta=2^-900, relative/absolute local majorants. Nie zakładamy complete
IEEE. Output jest finite normal albo signed zero. Half/sqrt nie są użyte
przez ten target FFT; double występuje w małym twiddle FPC_SQR domain.

## 1. Wszystkie weights, tablice i stages

Fresh RBF256 sprawdził255 square pairs,256 cubic pairs i6 fixed components,
każdy component error<eps=2^-50. Source bytes tables/header i relevant C
bodies są związane z ROOT; sole floor change jest unreachable w prefixie.

Symboliczny IDEAL operator przenosi1536 independent coefficient variables.
Pierwszy fold łączy disjoint supports j,j+768, osiem square stages wykonuje
rozłączne butterflies A±wB, końcowy cubic stage ma3 disjoint supports.
Sprawdzono WSZYSTKIE **1179648 weights** na768 physical outputs. Każda waga
jest ζ_j^i. Zbiór roots i conjugates to dokładnie1536 roots Phi, bez1/N.
Linearity dotyczy ideal shadow operator; rounded source jest wiązany osobną
indukcją błędów, nie testem unit vectors.

## 2. Parametryczna recurrence i actual cap18432

M oznacza modulus exact ideal value, e component error. Dla źródłowego
complex multiplication przez unit twiddle z component error d:

```
CM(M,e,d) = 2Md + 2e(1+d) + 6U(M+e)(1+d) + 4eta.
```

Input coefficient bound K:
first fold M=2K, e=K*eps+4U*K*(1+eps)+3eta.
Każdy z8 square stages ma p=CM(M,e,eps),
e_next=e+p+U*(2M+e+p)+eta, M_next=2M.
Każdy stage ma384 butterflies; first fold768, cubic256 triples.

Po squares M=512K. Source cubic B0 i B1/B2 mają errors
CM(M,e,eps) i CM(M,CM(M,e,eps),eps).
Source x² twiddle error to CM(1,eps,eps); C0,C1/C2 mają analogiczne
CM(M,e,x²error),CM(M,CM(M,e,x²error),eps). Następnie źródłowo sumuje się
B+C i A+(B+C), dokładnie jak w source. Wszystkie exact QQ expressions i
każdy stage/branch są zapisane w artifacts/numeric_certificate.json.

Nowa instancja **K=18432** daje component error **<1/8192** i ideal modulus
≤1536*18432=28311552. Źródłowy component ma bound28311552+1/8192,
a norm bound28311552+2/8192. Nie użyto starego2047 constant1/32768 dla c.
Recomputed recurrence majorant dla18432 przekracza1/32768; kontrola odrzuca
tę ekstrapolację jako wadliwy proof certificate, nie jako C counterexample.

## 3. Domains PRZED operations

Przy input component≤M+e i twiddle≤1+d scalar product output≤
(1+U)(M+e)(1+d)+eta, a add/sub input-sum/result ma podany w certificate bound
2(1+U)*product+eta. Sprawdzono je przed kolejnymi source operations.
Wszystkie FFT operands/intermediates są **<2^28**, głęboko wewnątrz2^100.
Source twiddle square używa normal/zero product<2, więc double jest exact.
Final cubic additions mają finite operands z wcześniejszych CM records.

Finite indexed loops, legal shifts/arrays i contracts oznaczają defined
terminating actual FFT. Zero/cancellation nie wymagają dodatkowej hipotezy:
local contracts mają absolute eta i output class normal/signed zero.
Ten argument działa dla każdego canonical c, także zależnego od klucza.

Do key basis nadal konsumuje się źródłowe ROOT bounds dla coefficient1
i2047: component errors2^-26 i2^-15, exact moduli1536 i3144192. Recomputed
parametric checks potwierdzają ich zakres; nowa c instancja jest osobna.
Nie zakładamy exact determinant q dla rounded FFT basis.
