#140 — one parametric source butterfly and symbolic buffer invariant

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. The whole owner three-point
KeyGen success-mass program remains ACTIVE / NOT COMPLETE. No production C,
reference semantics or law134 definition changed. Frozen110 and its zero-mass
result131 remain unchanged.

## Primary result

FftButterflyClosed140.source proves the ENTIRE original middle FFT butterfly
once, for arbitrary four input words, two twiddle words and surrounding
states satisfying the explicit source entry conditions. The output is exactly
four ordered C99WordStore140.write updates. Every outer and macro temporary
cell is restored; arrays, globals, tables, object sizes and permissions are
unchanged. other_byte preserves every byte outside the four write ranges.

The exact source entry is FftLoadExec140.Entry: the original four Pointer
judgments, four incoming Load64 facts, writable destination objects and typed
sr/si cells. Allocation and word width follow from those reads. These are
ordinary C preconditions that the loop caller must discharge, not assumed
outputs, callee contracts or probabilistic hypotheses. The original index
expressions remain v, v+hn, v+ht, v+ht+hn.

FftButterflyBuffer140.source_and_invariant combines that source execution
with preservation of C99WordBuffer140.Represents for arbitrary buffer length,
contents and selected indices. nextValues is the exact four-index update
using the source-proved FPEMU word operations. C99FourWordBuffer140 preserves
the ordered update semantics even when selected indices alias. Distinct
array indices have disjoint eight-byte ranges by C99WordBuffer140.separate.
No ideal real FFT identity or rounding approximation replaces C arithmetic.

## Source derivation

- FftLoadShape140.body_source binds the complete body to the existing parsed
  source AST; it also identifies each load and destination index expression.
- FftMulClosed140.source/in_butterfly executes the original complex multiply
  for arbitrary operand words, with all six temporary cells restored.
- FftPairClosed140.source/in_butterfly executes both original ADD/SUB macros,
  with two ordered legal stores each and a complete remaining-byte frame.
- FftLoadExec140.source supplies all four incoming reads. The final composition
  is FftButterflyExec140 and the scope equality is FftButterflyClosed140.
- C99WordStore140.source/finite gives the exact byte update and its equality
  with the finite memory writer. C99WordRead140.here/outside proves reading
  the written word and preservation of disjoint reads.
- Environment, pointer and heap transport are proved generally. In particular,
  FftFourWrites140 composes abstract output words before instantiating nested
  FPR formulas, avoiding kernel recursion without increasing limits.

## Preserved earlier route and owner steering

The initial straight-line certified checker remains valid evidence. Its
same four-iteration pilot took10.288s /5253580KiB versus139's40.560s /
5890136KiB. A16-iteration continuation from the actual v=8 endpoint passed005
in49.801s; GeneratedFft140Middle16.after contains the resulting v=24 snapshot.
These are diagnostics and a concrete prefix, not a general resource bound.

The owner then requested one parametric butterfly/invariant instead of a
large series of concrete certifications. The primary result above implements
that change. No large concrete-prefix series was launched afterward. The
next work instantiates the proved invariant in the source loop by induction.

## Evidence

ENTRY140 c0774dd1bf5a344e758d2c72b73cf4b561ffbdfa347683ff5153a00a0413efa7
verified all40997 inherited pins from139postseal
36cc2d43f8a317d40dd1a69e01b8b1d48d4100985f187d0db0c7c0faef6eaa84.
Source commits: d6810991, e3843238, 7bb1f01b, 825a1ec2, 0d7be325.
Generated sources are reproduced by tracked recipes and pinned from immutable
job outputs. No push, independent review or owner acceptance is claimed.

36 mathematical modules plus36 isolated audits:72 accepted module records,
239 named declarations. All accepted logs are0/0; only propext,
Classical.choice and Quot.sound occur. Full expression DAG roundtrip plus
kernel fresh safe-definition checking at original declared types and options;
final job032. Audit collection SHA
104ca504033b1f5f9ae4ab6f45b707c7547ad636ce3400de40c5fb1f504b2eae.
This is self-audit, not an independent review.

Standard-preparser Sage031 checks40 finite boundary/deterministic word cases
with exact ZZ arithmetic and a native probe containing the exact pinned C
butterfly body. It compares all four outputs and verifies the remaining1532
array words. Result SHA
3a467f79ff9b50bbacdf2df86d59f24eee1708325306fd16286b74a5c6fc867f;
2.369s,0/0. This is auxiliary finite consistency evidence, not a premise of
the parametric theorem or any probability bound.

All32jobs are retained. Fourteen failed/mixed jobs
006/008/009/010/011/013/015/016/021/022/023/024/026/030 have explicit causes
in KEYGEN_BUTTERFLY_140_FAILURES.json. Recursion failures were resolved by
abstraction, never raised limits. The initial attribution of021's recursion
location is explicitly corrected in022. Linter and probe-generator errors
were fixed rather than suppressed.

## Remaining owner obligations

Actual loop instantiation is NOT complete: derive source index/counter/guard
facts, prove the caller buffer representation, induct through the remaining
iterations and close the original false guard. Then middle/tripling/rt2 FFT,
raw/GS/public/solver/certificate/codecs and the full emitted KeyGen witness
still remain. No concrete Z>0, p_accept lower bound or p_K lower bound is
newly instantiated here. S1 stays measured, with no IID/F04/D1 shortcut.
Exactly five do_sign items are unchanged. See
KEYGEN_BUTTERFLY_140_PARAMETRIC_CONTINUATION.md for the precise next route.
