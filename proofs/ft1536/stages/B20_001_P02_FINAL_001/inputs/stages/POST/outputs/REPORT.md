# FT1536 — SOURCE_POSTPROCESSING_AND_PRECAST

Autor projektu: **Niirmata**. Data etapu: 2026-09-21.

## Werdykt

**PARTIAL_PROOF**. Dowiedziony subclaim operacyjny:
**H3_SOURCE_POSTPROCESSING_DEFINED_FOR_EMITTED_PINNED_MODEL**.
Uniwersalny **Safe16 required completed histories pozostaje OPEN, nie obalony**.
Nie ma required-domain counterexample ani oszacowania joint BadPrecast.

Teza jest warunkowa na rzeczywisty return ffSampling_fft3:1897 w odebranej
emitted/same-STATIC/canonical/normalized/legal-context domenie. Nie zakłada
Safe16 lub przyszłego norm acceptance, nie twierdzi termination samplera.

## Wykazane

1. Whole-root returned residual bounds po OBU branches, z source-L/stable-D
   correlations: |x|<2^35,|y|≤115184881. Root correction/sub błędy jawne.
   Full exact source-basis reference energy≤10436770873344; nie right-only bound.
2. Literal suffix1902–1934: preserved copies, basis[g,-f,G,-F], source CM/add,
   ternary stores bez binary hm-minus/negacji. Source primitive domains<2^100
   wyprowadzone przed instructions. Actual post-frequency modulus≤89531345.
3. Source iFFT cubic/8binary/terminal/rounded inverse768, full layout/frame/
   signed-zero/subnormal/Half/double domains. Mathematical inverse coefficient
   bound4572095, source error≤1/128, actual words≤4572095+1/128.
4. Source rint shift/mask/sticky0xC8/nearest-ties-even/signed reconstruction:
   |w1|,|w2|≤4572095, int64 margin9223372036850203713. Nie floor substitution.
5. Actual signed16 stores=narrow16(w) w deklarowanym GCC modelu. Preservation
   iff joint Safe16. Zdefiniowano per-attempt i whole-call BadPrecast bez η_pre.
6. Exact norm stored arrays, strict B2093922385, no int32/int64 overflow;
   M0 capacity≤3160 po acceptance. Nowy universal STATIC byte-stream/value
   refinement i actual decoder round-trip, także−32768. Header0xaa dopiero
   po sukcesie; partial writes/capacity/query/canaries rozliczone, nonce40 osobno.
7. Deterministic suffix termination i memory frame. Retry/fault/nonreturn
   scope oddzielony od zakończenia całego source API i od Sign→Verify.

## Otwarte i negatywne wyniki

Uniform bound4572095 nie implikuje[-32768,32767], ale nie jest witness.
Actual local suffix fixture65536→0,stored Q0 pokazuje, dlaczego future norm
nie dowodzi precast preservation. Jego basis determinant0≠q; brak P_key/Emitted/
sampler-history membership. Nie zgłaszamy na tej podstawie błędu produkcyjnego.
Reference integer recovery/integrality/tie-gap/congruence i Sign→Verify są
osobno OPEN. Sampling law/joint probability, whole termination,security,
ROM/QROM/reduction i whole CT nie zostały dowiedzione.

Zachowano failed Lean/lint drafts, import failure i zbyt szerokie iterated
RBF enclosures (poprawione przez exact modular phase exponents), początkowy
luźny rint cap i błędne możliwe rozumowania. Szczegóły FAILED_ROUTES.md.

## Kontrole i odtwarzanie

- Lean4.34/Std: **102 modules,795 theorems,32 nowych**, full new types/terms,
  axioms audit, wszystkie final logs clean; standardowe3 axioms, bez sorry/
  admit/native_decide/Lean.ofReduceBool/warning suppression.
- **59 publicznych fixture cases w każdym buildzie normal i ASan/UBSan**,
  dokładna zgodność words/snapshots/int64/int16/norm/bytes/length/canaries.
- 32 224 rint words, wszystkie 65 536 signed16 values w codec controls;
  strict norm B−1/B/B+1 i M0 length3156 witness.
- 10 pełnych inverse vectors ×1536 coefficients przez independent direct
  RBF256 root-sum oracle; QQ/symbolic certificates są uniform proof support.
- 13 wykonanych meaningful model mutations +noop; 4 preflight domain stops
  przed native invocation. Testy nie zastępują universal proofs/Safe16/law.
- **Fresh RO-package rehearsal PASS 616/616 semantic
  path/SHA matches**, pełny rebuild bez project cache/olean/bin, originals
  Dokumenty/stages ukryte, source/inputs RO, sieć odłączona, jeden bounded worker.
- Wrong external pin rzeczywiście odrzucony PRZED utworzeniem DEST.
  Final standard replay przyjmuje zewnętrzny OUTPUTS hash; recipe w REPLAY.md.

Proof kind: **mixed kernel + universal analytical source proof**.
Real metric/iFFT induction, byte loop simulation, C heap/compiler binding mają
jawną analityczną granicę; fully_kernelized=false,C_compiler_verified=false.
Nie użyto obserwowanego fixture maximum jako uniform mathematical bound.

## Piny i zakres

Bootstrap897 members/895 origins/16420007 bytes, manifest
`ae0b43d2c9ce7b88e63e2d81be97e04dcbd45bbab827cf63f9339828df147cff`.
BASE `fbf4a5c23e36d7089dca563e70b58db886959d1a`.
Candidate17-file manifest
`56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985`.
SOURCE_POSTPROCESSING_CERTIFICATE.json SHA-256:
`157bde62850b24c4f2505d19b5adc0cd82cbe875c7db6874c6ec857cbf2344ef`.
Fresh anchor SHA-256: `949b54eb97b3b2ac9ad8026e3b13ed4e64aa7b3fbb1c804c06b92163d051a379`.

source_changed=false,production_source_changed=false,
new_source_patch_integrated=false,owner_accepted=false. Brak Git/importu/
integracji, KeyGen/private API/nowych keys/seeds/sekretów lub dudect. Nocny
RUN_002 prowadzącego nie został uruchomiony. Raport i OUTPUTS mają zewnętrzne
hashe przekazane na końcu; manifest nie hashuje samego siebie.

## Podsumowanie dla właściciela

**Osiągnięcie:** wiemy teraz dokładnie, jak ukończone próbkowanie przechodzi
przez iFFT, zaokrąglenie, zapis16-bitowy, normę i faktycznie zwracane bajty.
Ta część ma dowód określonej mapy i zakończenia w przypiętej domenie.

**Co nie wyszło:** nie wykazano, że każdy szeroki integer wynik mieści się
w int16. To brak dowodu Safe16, a nie required-domain kontrprzykład. Rounding
aktualnego source word nie dowodzi też zgodności z niezależnym lattice integer.

**Znaczenie:** dalszy dowód może operować na dokładnym źródłowym zdarzeniu
BadPrecast i rzeczywistych bajtach, bez ukrytego założenia, że casts są exact
lub że norm acceptance naprawia utratę wartości.

**Następny krok:** SOURCE_SAMPLER_LAW/H6P — actual ordered joint law, poprawny
joint BadPrecast/retry consumer i osobny reference-integer/sign correctness
bridge. Żadnego wymyślonego epsilon lub nowego abortu; NEXT_INTERFACE ma typ.
Własne bounded obliczenia kończą się na handoffie.
