#140 — source-certified straight-line butterfly execution

Continue the original owner program from sealed139 / HEAD959a3127, using
NormalizedFftMiddle139.after (v=8). Full KeyGen and positive-mass goals remain
open. No source/reference/law revision is proposed.

Primary route: compile the fixed straight-line butterfly AST into composed
state actions with a source-execution proof attached to every constructor.
Atoms retain existing source-sound scalar/array checks; sequence and scope
constructors compose them with exact local/pointer restoration. Generate a
literal certificate and kernel-prove its code is the original butterfly body.
A prefix checker then invokes the compiled action under every original
loop guard, with the existing complete normalization frames. This stages
repeated AST dispatch out of the concrete evaluation; it does not erase
arithmetic/address guards or replace word operations with native premises.

First discriminating check: certify the original4-iteration pilot with this
checker and compare cost against139's40.560s/5890136KiB. If useful, certify
larger prefixes from the actual v=8 endpoint. If the cost persists, retain
the result and strengthen to a four-word/four-write source rule or a proved
state projection; the slower4-iteration route stays available. No arbitrary
global attempt quota or resource-limit increase.

One proof/computation at a time, standard Sage preparser for finite controls,
accepted logs0/0, all failures with causes, small local commits/no push,
postseal after a scoped result. No workers, schedules, IID/F04/D1 or added
assumptions. Measured paper and exactly five do_sign items stay unchanged.

## Owner steering after005: one parametric butterfly, not a certificate series

The owner explicitly highlighted the cost of certifying many individual
butterflies and requested a single parametric invariant-preservation lemma
followed by instantiation. The staged checker is a partial optimization:
its soundness is parametric, but it still evaluates each concrete instance.
Do not launch a large series of concrete-prefix certificates.

Preserve the useful result: the same4-iteration pilot improved from40.560s
to10.288s; a new16-iteration prefix from v=8 passed005 in49.801s. Thus the
first24 iterations have accepted component proofs, but the full composed
24-prefix has not yet been exported. The current goal is the stronger
four-input-word/twiddle/index theorem with exact four writes, untouched
memory and scopes, all source index/address conditions derived at the caller,
and source-proved bit-level FPR operations. Next derive the loop invariant
and instantiate that theorem, without interpreting the complete AST anew
for every instance. No IEEE-real or independence assumption is introduced.
