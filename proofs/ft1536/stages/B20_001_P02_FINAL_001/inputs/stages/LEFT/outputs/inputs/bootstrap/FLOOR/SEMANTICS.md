# Semantyka raw-word floor i definedness wszystkich Word64

Model: C99, GCC14.2.0-19, x86_64 Linux LP64, CHAR_BIT8, int32, long/int64
64-bit two's complement. Signed right shift jest arithmetic shift wybranego
GCC. UInt→signed conversion tego builda zachowuje low bits z two's-complement
decode. To jawne implementation-defined facts, nie twierdzenie o dowolnym C ABI.

Dla raw x∈[0,2^64): s=x>>63∈{0,1}, e=(x>>52)&2047∈[0,2047], f=x mod2^52.
Literalny rawMant=((x<<10)|2^62)&(2^63−1) ma wartość2^62+1024f, w przedziale
[2^62,2^63−1024]. Unsigned left shift zawija modulo2^64 zgodnie z C.
Pierwszy cast int64 jest exact, bo rawMant<2^63.

Source `(xi ^ -(int64_t)s)+s` daje m lub−m. Przy s1 intermediate~m leży
między−2^63+1023 a−2^62−1, a dodanie1 jest legalne. Final signed xi jest
ściśle między−2^63 i2^63. Nie ma INT64_MIN negation lub signed overflow.
Int cast(x>>52) mieści się w0..4095, potem maskowanie daje e.

cc=1085−e∈[−962,1085], 63−cc=e−1022∈[−1022,1025]; oba int expressions są
zdefiniowane. Dla negative cc, `cc&63` w wybranym two's-complement modelu
jest cc mod64. Count n∈0..63. fpr_irsh używa conditional right32 z maską
0/−1 (n>>5∈{0,1}), potem right(n&31), gdzie0..31. Wszystkie shifts mają
legalne counts; signed results pozostają int64. Integer interpretation
to floor-division xi/2^n, także dla ujemnego xi. Kernel irsh_eq rozlicza
dwa etapy, nie tylko przypadek n<32.

Flag b=((uint32_t)(63−cc))>>31 jest0/1, równoważnie1 iff e<1022.
Źródłowy signed XOR/AND selector wybiera shifted gdy b0, −s gdy b1.
Wartość long zawsze jest signed64; dla LP64 końcowy int64→long jest exact.
NaN/Inf raw exponent2047 nie wywołuje hardware FP: cc=−962, masked count62,
ten sam integer program ma zdefiniowany wynik. Nie nazywamy go IEEE floor.

## Candidate

Prefix jest identyczny. `mask=-(uint64_t)b` jest unsigned0 albo2^64−1,
`-s` w drugim operandzie również unsigned0/all-ones. Konwersja shifted
int64→uint64 daje modulo2^64. Dwa AND i OR wybierają te same result bits:

```
(shifted_bits & ~mask) | ((-s mod2^64) & mask).
```

Mask complement dotyczy dokładnie64 bitów. Żadna z tych instrukcji nie ma
signed overflow; wszystkie unsigned operations są total. Końcowy cast
uint64→int64 jest implementation-defined GCC two's-complement decode.
Selected result to bit encoding starej wartości signed64, więc long value
i bits są identyczne. Nie potrzebujemy ani nie zakładamy inline asm identity.

Semantic C prefix/bit selection binding jest opisany oddzielnie od kernelu;
kernel dowodzi wszystkich powyższych range/representation lemmas w modelu.
Nie ogłoszono zweryfikowanego front-endu GCC lub kompletnego interpretera C.

## Niezależny oracle

Oracle używa tylko exact integer quotient/ceil: jeśli e<1022, wynik−s;
inaczej n=(61−(e mod64)) mod64 i magnitude=(2^52+f)*1024, po czym positive
floor quotient lub negative ceil quotient. Nie wykonuje C XOR/mask helper,
signed shift ani hardware double floor na NaN/Inf. NumericCenter jest
osobno kontrolowane niezależną exact dyadic interpretation.
