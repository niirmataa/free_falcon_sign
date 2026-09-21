# Teza i status — SOURCE_POSTPROCESSING_AND_PRECAST

Autor projektu: Niirmata. Status główny **PARTIAL_PROOF**. Subclaim operacyjny:
**H3_SOURCE_POSTPROCESSING_DEFINED_FOR_EMITTED_PINNED_MODEL**.

Niech H będzie rzeczywistą skończoną historią przypiętego programu FT1536,
z kluczem Emitted/same-STATIC decode/normalized, canonical c i legalną
pamięcią/context/byte-read interface z LEFT, w której ffSampling_fft3:1897
wrócił. Nie zakładamy przyszłego norm acceptance, Safe16 ani zakończenia
samplera dla każdej taśmy. Konsumujemy udowodnione forward fault exclusion
wyłącznie dla tej domeny.

**Dla każdego takiego H** deterministyczny suffix1902–1934 jest defined,
kończy się, zachowuje frame i realizuje mapę POSTPROCESSING_MAP. W szczególności
source iFFT error względem określonej tam inverse-evaluation jest ≤1/128,
|t0_i|,|t1_i|≤4572095+1/128 i source rint daje nearest-ties-even int64
w1,w2 o |w|≤4572095. Actual stored values to narrow16(w), także poza Safe16.
Mowa o source word rounding, nie o odzyskaniu niezależnego lattice integer.

Norma sprawdza Q(narrow16(w1),narrow16(w2))<2093922385 dokładnie. Po acceptance,
legalny caller M0 STATIC/cap4096 emituje dokładnie 0xaa||Encode8(s2), bez paddingu
do4096, o długości≤3160 (nonce40 osobno). Source decoder odtwarza całe s2,
zużywając dokładnie body length. Caller/retry/failure/frame podano oddzielnie.

**Nie domknięto uniwersalnego Safe16 wymaganych H.** Zachowanie wartości przez
oba casts jest równoważne joint Safe16. Zapisano joint BadPrecast per-attempt
i finite-union whole-call, bez oszacowania prawdopodobieństwa. Nie zmieniono
P_key, Emitted, K_seed[E], M0, kodu ani success event. Duży uniform bound nie
jest kontrprzykładem. Syntetyczny lokalny wrap witness nie ma required membership.

Nie twierdzimy reference integer recovery, Sign→Verify, prawa samplera,
whole Sign/H2P/PRNG/rejection termination, redukcji/security lub whole CT.
Dowód jest mixed analytical/kernel; kompilator C i pełna source heap semantics
nie są mechanicznie zweryfikowane. Szczegółowe flagi są w certyfikacie.
