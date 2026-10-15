# Indexed FFT values152

Status: PROVED_KERNEL_SCOPED_VALUE_REWRITE / NUMERIC_CERTIFICATES_OPEN /
NOT_REVIEWED after final audit/seal. Whole owner task ACTIVE / NOT_COMPLETE.

The152 lemmas replace nested functional update recurrences by exact indexed
expressions, without changing any source arithmetic or the numerical gate.
DisjointVectorPass152.pointwise and its bounded version prove the general
independent-update rule. VectorRegion152 transports local dependence across
a region. These are ordinary kernel lemmas with explicit structural premises,
instantiated and discharged for the actual FFT index families below.

FftFirstClosed152.source gives the first-pass vector directly.
FftGroupValues152.pointwise/source cover complete and partial butterfly
groups, including the actual rt1 continuation from v24.
FftOuterValues152.source and FftPassValues152.source replace all middle
passes using the original schedules/table indices.
FftTriplingValues152.source replaces the256-iteration tripling vector by
one indexed original tripling operation. Original rounded ADD/MUL/SQR
order and exact input words are preserved; no real-arithmetic substitution.

SelectedFftImages152.f_source/g_source equate the ACTUAL previously proved
FFT images with these new expressions. source_images transports both to
the actual SelectedRawNorm151.after heap. norm_source and obligation prove
exact equality/equivalence with the original still-open norm comparison.
The actual source execution endpoint remains151;152 changes representation
for finite checking, not the required gate or success event.

All13 mathematical modules have clean accepted logs. Job010 audits73
declarations in21 sequential processes with unchanged full DAG roundtrip,
fresh safe kernel definitions, standard3axioms and resource limits. Ten
jobs; failed/mixed001/003/005/007 retained with elaboration/arithmetic
causes. Source commits7ba52070/4c594e79/509f6067.

Sage009 computes exact ZZ word operations, all first/middle/tripling passes
and all intermediate vectors. Sequential and indexed evaluations agree
at every pass; both final vectors agree with the pinned151 native candidate.
Twelve vectors per buffer include input, first, middle0_at24, middle0..7,
and triple. Candidate SHA256
3e9da927968cec19503661809c41af3402da104bfad29c2f041e59204b24d891.
Norm proposal remains4704131856579166192 against4737176763271429578.
These candidates are auxiliary and are NOT premises of the Lean theorems.
Concrete image equalities and the accepted norm gate still need kernel
certificates; no direct whole-expression retry or resource increase.

Next certify actual captured input vectors, then each indexed pass against
its proposed literal vector, using one shared checker/lemma and bounded
chunks as needed. Finally certify ordered norm accumulation and comparison.
GS/division/solver/emission/certificate/codecs and concrete positive
Z/p_accept/coding/p_K remain open. Corrected134, frozen110zero history,
measured wording and exactly five do_sign obligations unchanged.
No push, independent review, new worker, schedule, axiom, IID or F04.
