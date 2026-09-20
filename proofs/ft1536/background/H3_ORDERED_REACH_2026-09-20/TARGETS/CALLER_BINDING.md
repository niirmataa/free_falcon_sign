# Hash-to-point i legalne wejścia kolejnych Sign attempts

Teza target prefixu jest deterministyczna i kwantyfikuje po WSZYSTKICH
canonical c, niezależnie od ich rozkładu i klucza. Nie wymaga uniform RO,
SHAKE indifferentiability, przyszłej Q<B lub successful Sign.

## Defined-return H2P range

falcon-enc.c564–592, q18433/logn10: n=3<<9=1536,
lim=65536−65536%18433=55299. Z dwóch unsigned bytes powstaje w∈[0,65535].
Jeżeli w<lim, source zapisuje `(uint16_t)(w%q)` i zmniejsza n. Modulo daje
0≤w%18433≤18432<65536, więc narrowing jest exact. Indukcja po written
prefix length N−n daje canonicality każdej zapisanej pozycji. Jeśli defined
call zwraca, n=0 i wszystkie1536 positions są canonical.

To conditional range binding; nie dowód zakończenia stream rejection,
rozkładu challenge lub braku bias. Nie uruchamiano H2P/SHAKE/PRNG.
Kernel TargetWords formalizuje modulo/uint16 bound i exact conversion.

## Actual caller and scope

Sign source3325 tworzy hm przed outer loop3330. W każdym attempt:
PRNG init i fault reset3355–3359 następują przed do_sign3372–3373.
Target prefix nie odczytuje coins/context i nie wywołuje samp callback.
Cut jest przed1897; future norm check3388 następuje dopiero po całym do_sign.
Dlatego jego wynik nie może być premise obliczenia targets.

Normalized certificate i decoded same sk dostarczają actual basis/tree
przy legalnym entry. Dla KAŻDEGO takiego entry (także po norm-rejected
attempt) canonical hm i legal buffers wystarczają do bieżącego theorem.
HM/key preservation przez ten prefix jest dowiedzione. Propagacja wszystkich
entry premises przez jeszcze nieudowodnione sampling/postprocessing między
attemptami pozostaje osobnym obowiązkiem; nie ogłoszono totality wszystkich
Sign attempts, absence faults lub termination rejection.

K_seed[E], p_K, cap16, framing/obserwacje M0 i source success/abort semantics
pozostają bez dodatkowych warunków. Silniejszy local target theorem może
użyć samych coefficient/source-basis facts i legal memory, bez emitted
membership; native synthetic controls należą właśnie do takich domains.
