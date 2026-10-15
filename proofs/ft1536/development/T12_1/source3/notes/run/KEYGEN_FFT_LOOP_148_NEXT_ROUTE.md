#148 continuation — generic first pass and actual rt2 FFT

NEW actual caller state: SelectedFftFComplete148.after. The entire original
first rt1 FFT CALL is proved, including body and return to KeyGen. Caller
locals/arrays/globals/tables equal reference NormalizedSmall136.after.
continue_norm exposes the original rt2 call followed by FftShape138.remaining.
Corrected search lift: SelectedFftFComplete148.extended.

NEW second callee entry: SelectedFftGBinding148.bound, with actual Bind from
the returned caller. Params a=SelectedFftGInput148.base, logn10/full1; global
and readonly table environments come from the actual caller. Its represented
1536-word input is SelectedFftGInput148.values, derived from the accepted141
source snapshot plus full outside-rt1 frame. It is exact ACTUAL memory, not
an assumed native image. Do not claim a new equality to ConvertedWords136.gWord
without proving one. Base block31,index1536,count35840,width8; logical byte
span[12288,24576). First output is SelectedTripling148.finalValues at block31,
index0; preserve it while rt2 writes its own span.

Next149 should generalize the simple FIRST FFT pass once for arbitrary legal
buffer contents/pointer: source reads a[u],a[u+hn], computes
real=fpr_add(a0,fpr_mul(a1,W1R)),imag=fpr_mul(a1,W1I), then two writes and u++.
Derive its pointer bounds and exact vector/frame, then induct over768 steps.
Do not repeat the old25 numerical chunks from138. Use FprWordExpressions140,
C99WordBuffer140/C99TwoWordBuffer146 and the scalar/loop machinery. Caller
constants W1R/W1I must be derived from the original function-global binding.

After the generic first pass, reuse FftOuterStep144/FftOuterInduction144 with
an eight-pass schedule from t768,m2 to t3,m512 (the existing schedule starts
after the first pass; prove the full finite Plan with its side conditions).
Then reuse FftTriplingInduction148.source for all256 tripling iterations.
Its Fixed includes exact buffer/table/constant facts; counters are u=3*k,
v=2*(512+k). FftTriplingSetup148 supplies original v declaration, u0/v1024
initialization and branch shape. Scope restoration and final guards remain
part of the complete source proof. The source body is parametric and can
serve rt2 once ordinary caller facts are derived.

Actual function/call interfaces: GeneratedFft138Syntax.function/source,
SelectedFftGBinding148.binding, C99ProcedureReference.Exec.call and
ReturnValue.voidEnd / Receive.discard. FftShape138.caller_shape binds both
calls in the original KeygenSmallShape136.remaining. Do not accidentally
use old110 semantics; current assembly target is134/extended133.

Proof engineering: expose large body outputs existentially before control
updates (FftTriplingBody148.source), rather than reducing a concrete symbolic
heap through every counter lemma. Use explicit constructor arguments and
small metadata/frame lemmas. Audit partitions keep original checks/limits;
exact declaration coverage is required. No numeric-image oracle or raised
limits. Whole success-mass program remains ACTIVE; full KeyGen and positive
mass open, no push/workers/schedules/IID/F04,new axioms; measured/five do_sign
unchanged. All148 sealed evidence is immutable.
