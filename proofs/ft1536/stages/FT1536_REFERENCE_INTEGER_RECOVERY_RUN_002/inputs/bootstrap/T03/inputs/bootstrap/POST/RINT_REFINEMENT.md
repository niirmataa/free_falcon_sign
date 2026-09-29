# fpr_rint: actual source words → nearest-even int64

Source fpr-emulated.h99–115, fpr_ursh19–23 i ulsh33–37. Domain: raw word
with encoded exponent ex≤1072 (zatem finite, |value|<2^50). Caller iFFT bound
4572095+1/128<2^23 spełnia go z dużym zapasem; nie wystarcza samo finite.

## Mask i legalne instrukcje

s=x>>63∈{0,1}, f=x low52. Unsigned shifts/OR/AND tworzą
m=2^62+f*2^10∈[2^62,2^63), e=1085-ex∈[13,1085]. x>>52≤4095,
cast int jest exact; e-64∈[-51,1021] jest signed32-safe. Cast uint32 i >>31
wybierają mask allones dokładnie gdy e<64. e&63∈[0,63]; także63-(e&63)
jest legalnym count. Helpers split shift przy32: n>>5∈{0,1}, każdy faktyczny
shift ma count0..32, końcowy0..31. Unsigned left shifts/wrap są zdefiniowane.

Jeśli ex<1022, e≥64, mask zeruje m. Wszystkie kolejne d,dd,increment są0;
wynik int64 jest0, poprawny dla |value|<1/2. Dotyczy także obu raw zeros
i wszystkich subnormals; nie użyto floor theorem ani host libm.

## Rounding dla1022≤ex≤1072

Teraz e∈[13,63], mask zachowuje m i |value(x)|=m/2^e. Zapisz
m=q*den+r,den=2^e,0≤r<den,scale=2^(63-e). Unsigned d=(m*scale) mod2^64 to
`(q mod2)*2^63+r*scale` (RintBits.discarded_word).
dd=(d low32) OR ((d>>32)&(2^29−1)) jest0 iff low61 bits d=0.
dd|(-dd) unsigned ma top bit1 iff dd≠0. W f=(d>>61)|sticky,
bit2 jest q parity,bit1 half,bit0 discarded-lower/sticky. Lookup0xC8
zwiększa q iff 2r>den albo 2r=den i q jest odd. Osiem cases i low61 relation
sprawdza kernel increment_rule; magnitude_is_nearest składa quotient/remainder
z rzeczywistym discarded word. nearest_error/tie_even dają error≤1/2 i even tie.

q<2^50 i increment≤1, więc nowy m≤2^50. Cast int64 exact, xor ze signed−s
jest GCC two's-complement identity: dla s0 q, dla s1 ~q=−q−1. Końcowe+s
nie overflowuje; wynik−q ma symetryczne nearest-even semantics. Shift/rounding
oraz signed reconstruction to osobne argumenty, nie utożsamienie bit-definedness
z nearest semantics dla dowolnego exponent. Nie rozszerzamy theorem do ex>1072.

## Caller i narrowing

|val(t)|≤585228161/128. |w−val(t)|≤1/2 i integer w dają
**−4572095≤w≤4572095**. Kernel rint_word_bound_consumer sprawdza ten krok
dla dowolnej dodatniej dyadic denominator, a nie zakłada desired caller bound.
Margin do2^63:9223372036850203713. W int64 nie ma overflow.
Signed16 cast to osobny GCC implementation-defined decode, opisany w PRECAST.

32224 raw-word cases obejmują każdy exponent0..1072, oba znaki, mantissa
boundaries, halves±1/2,±3/2,−32768.5,32767.5 i sąsiednie raw words. C normal
i sanitizer są bit-identical z literal model i independent exact-Fraction
nearest-even oracle. Cztery poza-domain words zatrzymano PRZED native call.
Finite tests nie zastępują powyższego uniwersalnego bit/dyadic argumentu.
