# 116 — actual SHAKE process_block: finite execution and concrete source call

2026-10-14. **PROVED_KERNEL_SCOPED / NOT_REVIEWED**. The whole three-point program remains
ACTIVE / NOT COMPLETE / NOT_REVIEWED. No law110 seed-success or probability
lower bound follows from this intermediate stage alone.

The new finite interpreter executes the pinned process_block AST. Read calls
are precisely actual A/RC array reads with pointer arithmetic and Load64;
source scalar expressions/statements, stores, lexical scopes, sequencing and
loops produce the ORIGINAL ShakeBlock.Exec. Successful finite evaluation is
sound. Fuel exhaustion supplies no nonreturn, source-failure or impossibility
claim. Process validates all24 pinned readonly RC words and runs the actual
body at the original blockEntry, returning only its heap to the caller.

The public synthetic counter9 fixture is extracted from immutable113_005.
Only its first process_block input/output A arrays are used:25 words each.
The local state has an448-byte context block, A at byte224, and a separate
readonly192-byte RC block. Other context bytes are a fixed local fixture;
this stage does not claim actual seed initialization reaches this whole state.
Sage checks the sealed event provenance and exact little-endian word/byte
extraction. Native observations supply candidate literal values, not premises
of the mathematical source-call theorem.

An untrusted Lean VM generator proposes normalized intermediate states for
12 double rounds. Each of49 source fragments per double round is independently
checked with decide +kernel against the finite interpreter, including full
memory and typed local state. Increment and guard checks, source sequence/scope
composition and the loop constructors join the588 fragments. The result is
ShakeBlockReplay116.source_process, a closed concrete witness for the original
ShakeExtractSource.Process relation, with all24 source rounds and exact output.
No native_decide, SHAKE idealization, new callee axiom or empirical probability
premise is used. The generator itself is not the proof.

Whole-block kernel reduction006 exhausted6144MiB (exit134,35.676s). It remains
preserved. The successful bounded route keeps the same kernel and resource
limits; each double-round module took about64-68s. Other failed attempts are
small type/rewrite issues retained in KEYGEN_SHAKE_116_FAILURES.json. The final
audit uses streaming output to avoid retaining every JSON row in memory; full
term/type DAG roundtrips and allowed-axiom checks are unchanged.

Generated fixture/state certificates are persistent pinned artifacts; generators,
composition, small sources, replay recipe and hashes are versioned. No private
key or seed packet is committed. See KEYGEN_SHAKE_116_REPLAY.md. Parent115
postseal5d08a2cbf7af83e48e0dca6b5ddfe3aeb4c314e48dd623a3acd00eda55782e30
(28633pins);116 ENTRY b35cec1cd464a84b8a1a907a7863038c5146c99673ac9ef1225c98209b75c889.
Source commitsb88e7f6f andd0ca23a3. Final composition/audit job116_014 passed2/2
in2.47s/6.53s, logs0/0. Its pinned imported closure contains18 accepted new
mathematical modules; with composition and audit,20/20 coherent modules are
clean. The streaming audit checks1291 named mathematical declarations, full
term/type DAG roundtrips and only propext/Classical.choice/Quot.sound. Fourteen
jobs, five failed/mixed, all retained; generator010 and fixture013 are also
clean. No already accepted round was needlessly rerun for the final audit.
Fresh Sage fixture013 exactly reproduces the used module,
b305810b3f681cd8efc3d2f69961c2bd539db7a0df1a09895405117312530cfe.

Next: actual dec64le/enc64le/xor_block computations with source soundness,
init/inject/flip/extract, MODE1 sampling, gates/solver and final emitted bytes
for the SAME seed experiment. An open performance route serializes literal
byte tries before checking future blocks; it has not been tested. The kernel
source witness G(seed*) and Z>0 remain OPEN, as do numeric acceptance and
conditional coding. Paper remains measured and exactly five do_sign obligations
remain unchanged. No push, new schedules, production edits or review claim.
