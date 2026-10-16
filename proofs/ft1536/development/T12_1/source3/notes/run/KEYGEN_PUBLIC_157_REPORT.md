# Constructive public scalar closure and actual entry157

Status after final audit and seal:
PROVED_KERNEL_SCOPED_PUBLIC_SCALARS_ENTRY / PUBLIC_CALL_OPEN / NOT_REVIEWED.
Whole owner task ACTIVE / NOT_COMPLETE. This is an intermediate public-call
checkpoint, not completion of falcon_compute_public or its nonzero gate.

The existing public library largely derives arithmetic and polynomial facts
from an assumed source execution. This stage supplies constructive source
execution rules for the eight scalar helpers used on the pinned ternary
path, and derives the actual public-call binding and fresh-buffer/setup
prefix from156's accepted sampled state. It reuses the old checked models,
source parses and range lemmas rather than replacing their semantics.

## Constructive scalar rules

PublicLinearSource157 lifts the existing scalar reference execution into
the original modular body. PublicLeafSource157 constructs conv/add/sub/
half/mul bodies from their checked word models; PublicArgumentSource157
preserves the actual caller argument conversions, including signed literals
and uint16 promotions. PublicSquareSource157 supplies mq_montysqr through
its original multiplication call.

PublicDivisionExpr157 and PublicDivisionChain157 check operand initialization
and construct the existing19-assignment addition chain followed by its final
multiplication. PublicDivisionSource157.source proves mq_div_18433 for the
exact word algorithm, without a supplied Body execution or nonzero premise.
This is word execution, not an assertion that division by zero is a field
inverse; the public caller's zero test remains a separate source obligation.

PublicNormalSource157 composes scalar prefixes and source sequence grouping.
PublicRevSource157 constructs the original ten-iteration rev10 using the
existing symbolic round/guard/increment models. PublicCalls157.sound gives
the source-call soundness needed by subsequent executable/public loop
certificates for all eight helpers. The adapter deliberately has no binary
mq_div_12289 implementation; the actual selected profile is ternary1.
The original source relations and their binary branch are unchanged.

## Actual caller and entry state

SelectedPublicBinding157.source binds h/f/g/logn/ternary from
SelectedAttemptPrefix156.publicInput. It derives the input pointers and
fixed caller locals through the actual sampled/norm prefix. In particular,
caller ter has unsigned32 type and is converted to the signed32 ternary
parameter; this conversion is explicit.

SelectedPublicMemory157.fresh proves block32 is genuinely fresh after both
norm gates. It starts from a checked absent block in the pre-norm compact
heap and uses the existing source stability theorem, including preservation
of readonly bytes. Freshness is not postulated from a guessed unused ID.

PublicSetupSource157 constructs the original MKN and modulus setup. The
signed shift of ternary1 is handled by the reference signed-left rule with
its concrete safety proof, rather than treated as an unsigned shift.
SelectedPublicStart157 derives the real declarations, automatic t array
of3072 uint16 elements, and n=1536/q=18433 setup. Its ready state and f/g/h/t
bindings are explicit. continue_body/continue_call restore the original
array lifetime and call structure conditional on the still-missing suffix
execution and return. They do not assert public-call success.

## Validation

Entry156 verified54931 pins. Sixteen mathematical modules expose131 named
declarations. Final audit017 checks every declaration's full expression-DAG
roundtrip, fresh safe kernel definition at the original type and standard
three axioms, in16 sequential processes with131 commands and unchanged
limits. Accepted stdout/stderr are0/0. Final collection/receipt/postseal
determine completion; this remains author verification, not independent review.

Source commits50335c7c/791d4d34/f4a147ec/e5cb4d77 are local main checkpoints, without push.
All17 jobs are retained. Failed/mixed001/002/003/008/009/011/013 are recorded
with causes: constructor binder order, State/Result wrapper, opaque finite
membership predicate, explicit return conversion/import, normalized name
equality, reserved identifier, and explicit signed-safety/declaration-frame
proofs. These were elaboration or proof-construction issues; no source-C
counterexample or ignored integrity failure was found.

Standard Sage job016 uses exact ZZ arithmetic, reads the original division
chain from the pinned C, and compares eight helper outputs for164 boundary/
diagnostic input pairs against that same C translation unit. The probe
includes falcon-vrfy.c; section garbage collection drops unrelated exports
at link time. The compiler command, sources, input/output and binary are
pinned. These finite controls are auxiliary, not a probability, field-range
or full-public-success premise.

## Remaining public execution and whole goal

Continue from SelectedPublicStart157.ready through signed input conversion,
both forward NTTs, the actual nonzero tests/divisions, inverse NTT and return1.
Public helper arithmetic is available, but these array executions are not
yet constructed. The root solver, certificate and final encoders follow.
No complete emitted-packet witness or concrete positive Z, p_accept,
conditional coding or p_K bound is claimed.

Corrected134 remains the active law; frozen110's missing-sqrt model diagnostic
is preserved and is not a zero-success claim about real C. Paper wording
stays measured, exactly five do_sign obligations stay unchanged. No IID/D1/
F04 identification, new axiom, worker, schedule, source-C change or push.
