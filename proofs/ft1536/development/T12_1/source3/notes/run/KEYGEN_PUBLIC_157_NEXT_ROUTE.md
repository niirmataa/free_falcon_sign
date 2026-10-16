# Continue actual public computation after157

Verify the157 receipt/postseal into the next ENTRY_PINS and inspect live
processes. Start at `SelectedPublicStart157.ready`; its actual binding,
dimension declarations, fresh block32 for t[3072], MKN n1536 and q18433
branch are proved. `continue_body` and `continue_call` request the original
remaining public statements and return, preserving array disposal. They
are conditional continuations, not a successful public call.

The remaining source order is:

1. `KeygenPublicInputProgram.conversion`:1536 signed int16 f/g loads,
   mq_conv_small, and unsigned16 stores to t/h.
2. hForward and tForward, including original ternary dispatch, dynamic
   mq_mkgm3 table generation and all forward NTT stages.
3. Every t[u] nonzero test, original mq_div_18433 store, inverse NTT,
   return1 and disposal of t's automatic allocation.

`PublicCalls157.sound` supplies exact source-call rules for conv/add/sub/
half/mul/square/div18433/rev10, including actual argument conversions.
The old public library's forward/radix/triple/inverse polynomial and range
lemmas mostly take Exec as input: do not mistake them for execution
existence. Reuse their syntax, exact word formulas and frames while
constructing the required executions. The q12289 binary path remains outside
this selected ternary execution; no original relation was changed.

Actual caller/state references:

- SelectedPublicBinding157.before = SelectedAttemptPrefix156.publicInput.
- f/g = KeygenMakeEntry.input KeygenFullData127.env.blocks slots0/1;
  h = KeygenMakeEntry.publicPointer env.blocks.
- bound is the actual parameter-bound compute entry, including unsigned
  caller ter1 to signed callee ternary1 conversion.
- SelectedPublicStart157.entered/ready contain t at block32, count3072,
  width2. Freshness follows from a checked absent pre-norm block and
  source readonly preservation, not an assumed fresh address.

Next derive the actual f/g input words at this state from the normalized
sampler blocks and source norm frames; do not insert native snapshots.
Likewise derive writable allocation for h/t. Conversion may fill previously
uninitialized output cells, so do not assume a full initial output image.
Source integer promotions distinguish signed f/g from unsigned h/t.

The selected public path's MKN uses a signed left shift of ternary1.
PublicSetupSource157 proves its concrete safety directly. A future generic
evaluator that only admits unsigned left shifts must not silently replace
this prefix or turn its missing coverage into a claim of C failure.

Only after the public call returns nonzero should the root-solver obligation
of SelectedAttemptPrefix156.continue_search be discharged. Certificate,
encoding, whole emitted packet and positive mass still follow. Preserve
corrected134/frozen110 history, measured wording and five do_sign items;
no IID/D1/F04 or empirical premises. One Lean process, standard Sage,
retained failures,0/0 accepted logs, small local commits without push and
postseal remain mandatory.
