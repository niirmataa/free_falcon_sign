# Literal prefix/source/model binding

Candidate17-file pin56974571… i wszystkie wejścia są sprawdzone. Relevant
falcon-sign/falcon-fft/fpr-emulated.c mają identyczne bytes z ROOT. Odwrócenie
przypiętego FLOOR patcha odtwarza dokładny poprzedni header; poza fpr_floor
wszystkie header functions/macros/tables pozostają byte-identical. Active
preprocessing wykazał22 transitive prefix functions i unreachable floor/
sampler/PRNG/loader. Nie utożsamiono funkcji przez samą nazwę.

Model C99/GCC14.2/Linux LP64: uint64 wrapping, int/uint16 widths, signed shift
i pack są jawne. Source primitive proofs ROOT/NORMALIZED mają odpowiednie
domains; source fft/canonical18432 error closure jest nowym argumentem.
Nie deklaruje się verified GCC lub kompletnego C heap.

TargetWord functions są source-normalized integer transducers. Literal
backend helpers są byte-identical konsumowanym źródłom proof modelu.
Of/dyadic, div55, FFT3 stage order,4mul+2add/sub complex product i per-word
scale zachowują source order/zero/sign behavior. Independent oracle jest
oddzielny: exact QQ product tych samych values oraz direct RBF256 polynomial
evaluation/Phi remainder we wszystkich768 slots.

## Cut i obserwacje

checks/prerequisites.inc zawiera dokładne MKN/samplerZ/skoff definitions.
checks/target_prefix.inc jest literalnym1848–1892, z rename do_sign→
target_prefix_slice, domknięciem scopes przy cut i void-discard nieużytych
post-cut params/pointers. Nie przestawia copy/mul/scale, nie dodaje zero-loop
t1 lub source guards. Full diff/spans są przypięte. Nie jest nowym runtime API.

Harness nie zawiera całego do_sign; NULL callback nigdy nie jest dereferenced
i nie ma fikcyjnego samplera do kończenia Sign. Source slice kończy się przed
1897. Obs_of/FFT/inverse/copy/mul/scale wywołują original primitive dokładnie
raz. Pełne O/F/I/C/M/S snapshots obejmują wszystkie1536 words każdego vectora.
Observer copy sprawdza real source t1=t0, readonly basis input i frame są
sprawdzane. Whole24576 key, hm, s1/s2/context i tmp suffix są porównywane.

## Domains i kontrolne membership

11 synthetic cases: canonical zero,max18432,alternating,dense deterministic,
edge/sparse units0/767/768/1535, cancellation i raw signed-zero basis. W
coefficient fixtures g=G=0, więc determinant0≠q: nie są P_key/emitted keys.
Source prefix ma silniejszą local domain przy samych capped source-basis
facts; tak interpretujemy te kontrole. Raw word fixture ma tylko rounding
reference bez coefficient provenance. Nie generowano kluczy.

Preflight odrzuca noncanonical/negative/short challenges, nonfinite/oversized
basis i nielegalne aliases przed native call. Mutations wykonują zmienione
operacje/input/copy order w modelu, nie tylko filtrują expected logs. Invalid
old2047 error certificate jest osobnym proof-domain rejection, nie C failure
lub emitted counterexample. No-op ma również native receipt. Normal i
ASan/UBSan logs są pełne; LSan nie jest deklarowany.

Kernel wspiera canonical/of/NI word/value, determinant/numerator identities,
Phi counts/energy, layer composition, source partial-operation order i frame.
FFT twiddle/weight/error proof, real/complex inequalities i C/heap instancja
są uniwersalną analityczną częścią mixed proof. Same constants w Lean lub
finite oracle tests nie są uzasadnieniem globalnego numerical theorem.
