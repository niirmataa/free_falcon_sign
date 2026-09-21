# SCALAR_KERNEL_IID — dokładna teza

Autor projektu: Niirmata. Docelowy status tego ograniczonego etapu:
**H3_SCALAR_KERNEL_PROVED_FOR_PINNED_IID_BUFFER_MODEL**.

Gra jest jawnie **IID_BUFFER** z RANDOMNESS_MODEL: świeże niezależne uniform
4096-byte blocks, oryginalne get_u64/get_u8 i cały oryginalny scalar kernel.
Twierdzenie jest warunkowe względem legalnej PAST filtracji, nie wartości
nieprzeczytanego bufora. Nie jest twierdzeniem o pseudolosowości ChaCha/SHAKE.

Dla każdego fixed NumericCenter mu WORD, actual normalized stored/paired
sigma WORD, legalnego typed context z faultNONE i ptr0..4095, oraz każdej
legalnej PAST historii o dodatnim prawdopodobieństwie w IID_BUFFER:

1. Literal CDF atom masses to n_j,k/2^128; jeden wspólny U128 dla wszystkich
   banków. Bank j zależy tylko od ustalonego source dss, nie od nowych bytes.
2. Source iteration ma5 getters,33 zwrócone bytes. Dla output y=s+z(k,b):
   w_y=n_j,k/2^129 * Beta_C(x_C(k,b)), z dokładnym integer Beta z BEREXP.
3. A=Σ_y w_y spełnia **1/256≤A≤1**, wyprowadzone przez source positive atom,
   bez założenia exp accuracy lub A>0. To uniwersalny bound wymaganej domeny.
4. Pr_IID[N=n,Y=y|PAST]=(1-A)^(n-1)w_y (n≥1);
   Pr_IID[Y=y|PAST]=w_y/A;
   Pr_IID[N>m|PAST]=(1-A)^m≤(255/256)^m;
   Pr_IID[N=∞|PAST]=0 i E_IID[N|PAST]=1/A≤256.
5. Dokładny post-context pointer/refill/drop schedule jest funkcją entry ptr
   i N. Unread tail oraz przyszłe blocks po finite return pozostają conditional
   IID względem ujawnionej przeszłości. To consumer do adaptacyjnych następnych
   calls, nie założenie niezależności ich unconditional marginals.

Required source entry pochodzi z LEFT NumericCenter i NORMALIZED width
certificates. Local argument jest szerszy: zero-aware NumericCenter,
positive finite sigma z derived dss<1 i found bank; typ obejmuje required
entries bez dodania key gate. Wszystkie source arithmetic/guard domains
instancjonują ORDERED; source trunc/expm/high-word refinements są tutaj jawne.

Dowód mixed: Lean integer/count/finite-geometric lemmas, exact QQ certificates,
uniwersalny analityczny source/probability argument. Product probability measure,
conditional independence i countable stopping-time argument nie są mechanizowane
w Lean/Std; fully_kernelized=false,C_compiler_verified=false.

Osobno OPEN: PRNG_REAL_TO_IID_BUFFER, Gaussian comparison, pełna ordered joint
law/H6P, joint BadPrecast/Safe16, reference recovery/Sign→Verify, whole Sign
termination/security/CT. POST pozostaje PARTIAL_PROOF. Nie zmieniono programu,
P_key/Emitted/K_seed[E]/M0, success event lub source abortów. A.s. w IID nie
jest all-tapes termination ani proofem realnego source sampler law.
