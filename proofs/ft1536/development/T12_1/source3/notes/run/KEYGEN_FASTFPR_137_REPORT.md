#137 — source-exact explicit FPR operations for raw FFT

2026-10-15. PROVED_KERNEL_SCOPED / NOT_REVIEWED. Owner program ACTIVE.
No completed raw FFT, whole KeyGen witness or positive success-mass bound.
The reference semantics and corrected law134 are unchanged: this improves
computation while proving its exact connection to the frozen source bodies.

FprMulMantissa137.source_result/source_x/source_y identify the unsigned
25-bit-limb prefix by kernel definitional equality for ALL x/y words.
FprMulSuffix137.source strengthens the original signed/packing suffix with
an explicit result using already proved C arithmetic guards. FprMulFast137
execution/model/source prove the whole original multiply returns word x y
for every pair of64-bit inputs, with no host IEEE operation or value oracle.

FprAddSwap137, FprAddCombine137, FprNormSteps137/FprNormFast137 and
FprAddTail137 likewise expose exact swap/alignment, six normalization steps
and rounding/packing results. Signed32 range obligations are discharged,
not erased. FprAddFast137.execution/model/source close the whole source add
for ALL x/y. These are word-semantic theorems, not universal real-error bounds.

FprHeaderEval137 proves actual parameter/global binding and source-body
execution; FprHeaderCells137 normalizes only proved same-type conversions.
FprHeadersFast137 closes neg/sub/sqr/half/double on arbitrary64-bit operands,
including the exact source behavior on raw edge patterns. The generic small
subtraction wrapper avoids expanding the large add term in a kernel proof;
its call premise is concretely closed by the already-proved add source.
FprFastCalls137.sound gives a fixed computable source-sound call table for
these seven operations and the existing ternary of(-1/0/1) cases.

FftScalarCoverage137.forward_source_covered checks names/arities throughout
the actual parsed falcon_FFT3 body, including expanded FPC macros. It does NOT
assert initialized loads, pointer safety, termination, or a complete FFT
execution; those remain the next concrete source obligations. FPC macros
appear as compound array statements with local scope, so the checker must
support those statements rather than assuming a macro result.

Sage017 passes exact ZZ controls on208deterministic pairs (144boundary pairs
plus64specified bit-pattern pairs), for all seven operations. Results agree
with both independent source-style integer algorithms and compiled pinned
portable fpr-emulated.c/header under113profile flags, with LP64 checked.
Compiler/native stderr is empty and saved; this finite evidence is auxiliary,
not a premise of the universal proofs or any distribution claim. Input SHA
ef0a1ece6834be536aa839866dc1df5db80e03487fa48e1f52a28b155f491c0a.
001's partial-evaluation printout is diagnostic only, never a proof premise.

Final018 audit15/15;15math+15audit=30/30coherent modules,89named declarations,
full DAG/kernel-safe type checks,standard3axioms only,0/0. Collection
05f25942821095305f03a6bdcd62c27c75f47d79123e49ce740ef79cdc155023.
18jobs; seven failed/mixed004/008/010/011/012/013/014 preserved with causes:
reserved name/import, opaque arithmetic aliases, residual reflexive goals,
compact-cell conversions, projection-rewrite order, deep subtraction term,
and a definitionally equal residual hypothesis. No warning suppression or
resource-limit increase. Source commitsfab1f6fd,778e8c81,4c7591a1.

ENTRYb624deb028ff3a8dba0885e2469cabbdbda4e641cee94efe4848561007ab35d6
verified136postbbd5976e0c21fbfc9b4cab81e25eafdf31c3e6a4140429e20e404cfa3d2444ef.
Next exact forward FFT on NormalizedSmall136.after, then raw/GS gates,
public/solver/certificate/codecs and full seed witness/mass instantiations.
No frozen source edits, push,review,worker or schedules. Paper measured,
five do_sign unchanged; no IID/F04 or new assumption.
