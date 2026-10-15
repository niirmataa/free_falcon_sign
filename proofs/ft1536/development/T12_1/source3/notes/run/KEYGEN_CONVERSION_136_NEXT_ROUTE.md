# Next route after136 — source-exact FPR execution for raw FFT

Read-only preparation while the conversion jobs run; no137 proof is claimed.
The next actual caller state is the completed second poly_small_to_fp call.
The remaining raw-norm syntax is KeygenSmallShape136.remaining, followed by
KeygenNormFrame.Gate; GS and solver/certificate/codecs follow later.

Existing source-backed arithmetic assets:
- C99PrimitiveExists.add_sound/mul_sound/div_sound connect the original
  FprPrimitives evaluators to C99Frontend.primitiveCall.
- FprAllTotal.all_pinned_fpr_words_defined closes all raw64-bit add/mul/div
  definedness, using FprAddTotal, FprMulTotal and FprDivTotal. This is already
  a theorem, not a new premise. FprScaledBridge.sound covers checked of/scaled.
- FprHeaderTotal has explicit packWord/ulshWord/urshWord and source equalities.
  FprAddDecode has explicit exponent/sign/mantissa forms; FprAddCombine and
  FprMulSuffix currently expose existential outputs, not a fast public result.
- FprSmallSigned discharges signed exponent arithmetic ranges; source C
  guards must stay present or be removed only through a proved erasure.

Potential efficient route: a source-exact totalized word interpreter/circuit
with a generic conditional erasure theorem (whenever original computation
is defined, the fast result agrees), closed by the EXISTING primitive totality.
Alternatively derive explicit output formulas through the current prefix,
combine, normalization and packing proofs. Do not assume that a host IEEE
operation or a formula extracted from a proof has the right source result;
any fast evaluator needs its own kernel equality/soundness theorem. A checked
partial evaluator with retained guards is also legitimate. No resource-limit
increase or change of source arithmetic, and no universal real-error theorem
is implied by word execution. Signed/exponent hypotheses must be discharged.

The forward raw FFT primarily needs add/sub/mul/neg/half/double and fixed
constants; inverse norm/GS adds division. Fixed header wrappers can compose
already source-proved primitive calls. Keep actual table bytes, buffer views,
loop guards and full state frames. Existing Smallints* historical results
mostly establish source→property; never use them as source existence.

This is still the owner KeyGen witness path. Paper remains measured, no IID,
F04 signing marginal or new assumption; five do_sign obligations unchanged.
