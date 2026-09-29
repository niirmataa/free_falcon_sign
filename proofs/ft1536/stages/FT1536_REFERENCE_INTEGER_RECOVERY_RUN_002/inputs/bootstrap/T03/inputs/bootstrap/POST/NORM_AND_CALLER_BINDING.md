# Norma przechowanych arrays, caller i retry

Po suffix1934 source3374 sprawdza sticky tsc.fault. W required completed domain
LEFT wyklucza go forward; nie jest to retrospektywny dowód bezpieczeństwa
suffixu na dowolnym faulted tape. Następny source3388 czyta tylko s1/s2 int16.

LV/Norm64 oraz nowy SourceBytes.stored_norm dają:

```
short_ok ⇔ Q(s1,s2)<2093922385,
Q=Σ_i(s1_i²+s2_i²)+Σ_i<768(s1_i*s1_(i+768)+s2_i*s2_(i+768)).
```

Każdy int32 product ma magnitude≤2^30;4608 kolejnych int64 partial sums
ma magnitude≤4947802324992<2^63. Brak signed overflow, strict `<` bez zmiany
progu. Podstawienie s=narrow16(w) jest zawsze dozwolone; podstawienie s=w
wymaga Safe16. Nie utożsamiamy wide-integer norm z normą stored arrays.

Jeżeli norm rejection: source wraca do następnej próby. sign_loop_attempts
zaczyna0, unsigned increments1..16 przed próbami; po16 ukończonych rejections
kolejny increment17 spełnia guard i zwraca0 bez siedemnastego do_sign.
Counter nie zbliża się do uint32 wrap. PRNG init/sampler calls następują
zgodnie z source; nie zakłada się niezależności prób lub tail probability.
Inner nonreturn pozostaje nonreturn, nie source0 i nie dodatkowa próba.

Po pierwszej accepted stored norm branch3411–3421 wywołuje literal STATIC
encode_small(sig+1,cap−1,q18433,s2,logn10). M0 CAPACITY_3160 i
STATIC_FITS_4096 są konsumowane dla TEGO s2 i stored norm. Body≤3159,
header+body≤3160<4096, więc M0 buffer4096 nie powoduje capacity failure.
Positive length/guard count wynika z M0; exact bytes i decoder inverse są
nowym source-analytical proofem STATIC_BYTES. Header0xaa jest dopisany tylko
na sukcesie. Historyczny CLI2049 oraz original wrapper nie są modyfikowane;
accepted synthetic M0 witness payload3156 nie mieści się w2049/3073.

Dla mniejszych legalnych capacities source może zwrócić0 z partial body
writes i bez header store. Wymagana legalna writable sig extent, nonnull
jeżeli wykonywana jest arithmetic sig+1; out=NULL raw encoder query nie
legalizuje NULL signing API. Norm rejection nie dotyka sig (encode nieosiągnięty).

Corollary o finite caller prefix: dla każdego osiągniętego, legalnego
ukończonego sampling return suffix kończy się zgodnie z mapą; po faultNONE
następuje exact stored norm branch, a po pierwszym acceptance exact framed bytes.
Nie jest to dowód zakończenia H2P, PRNG, rejection lub całego API. Nie jest
to Sign→Verify: byte round-trip odtwarza s2, lecz congruence/reference integer
oraz center/norm compatibility względem h,c pozostają osobnym obowiązkiem.
