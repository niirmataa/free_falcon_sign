# Jeden początkowy ReadyRetryEntry

Cut: po defined return `falcon_hash_to_point` w sign3325, przed counter3327.
Nie obejmuje wykonania entropy/KeyGen/nonce/H2P prefixu. Caller guards3315–3323
zostały już przejście; nie są ponawiane wewnątrz regionu.

`ReadyRetryEntry(e)` zawiera tylko bieżące, lokalne fakty:

- PC3327, N1536,q18433,logn10,ter1,MODE1/FPEMU,comp=STATIC=1,
  SIGN_MAX_ATTEMPTS16 i literalny Makefile-O; wyłączone diagnostic probes.
- Legal emitted/same-STATIC decoded normalized `sk`, z konsumowanych
  NORMALIZED/LEFT/TARGETS/H6P required-domain contracts. Dotyczy tego jednego
  kontekstu, nie dowodzi acceptance każdego możliwego P_key przez bramki.
- `hm[0..1535]` canonical0..18432, wszystkie te elementy initialized. Jest
  to defined-return H2P range z TARGETS/CALLER_BINDING; bez rozkładu H2P.
- LegalTargetBuffers: sk24576 fpr words196608 bytes readonly, tmp10752 words
  86016 bytes writable, stack hm/s1/s2 po3072 slots, live typed aligned
  contexts, writable nonnull sig extent4096. Restrict/disjointness, brak
  concurrent mutation i ważne lifetimes do return. Stare tmp/s1/s2 nie muszą
  zawierać poprawnych targets. Sig nie jest query-NULL interfejsem encodera.
- `fs` controls/sk/tmp pointers i normalized key są owned/stable. `fs->rng`
  to legalny flipped SHAKE512 squeezing state: rate72, 0<=dptr<=72,
  initialized permutation/buffer state tam, gdzie następny read go wymaga.
  Legalność pochodzi z caller/rng_ready3130–3145 i source SHAKE API, nie
  z założenia świeżości lub niezależności jego56-byte outputs.
- Legal entry PAST niezależna od nowego idealnego tape zdefiniowanego przez
  grę. Może zawierać latent normalized key, canonical hm i opaque rng state.
  Nie zawiera current unread ideal bytes, future tape ani future norm success.

Nie ma tu `forall future entries`, Safe16, root return, norm acceptance,
pozytywnego return ani desired probability boundu. Lokalny counter i prng
jeszcze nie zostały zainicjalizowane; na tym cut NIE istnieje initial block
bieżącej próby do doliczenia drugi raz.

Źródłowe rozmiary/offsets i legalność target operations są z przypiętego
TARGETS/MEMORY_FRAME. M0 definiuje fixed nonce40 framing i single K_seed[E].
Nonce jest już ustalony poza cut; dopisanie go do publicznej obserwacji po
tym samym entry zachowuje coupling. Nie ponownie warunkujemy na Verify.
