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
