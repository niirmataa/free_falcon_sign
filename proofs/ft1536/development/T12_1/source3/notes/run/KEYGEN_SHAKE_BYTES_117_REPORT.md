# 117 — source execution of SHAKE byte helpers

2026-10-14. **PROVED_KERNEL_SCOPED / NOT_REVIEWED**. The continuous three-point
KeyGen program remains ACTIVE / NOT COMPLETE. No complete G(seed*) witness,
positive law110 normalizer, numerical acceptance or coding mass is asserted.

`ShakeDecodeCompute117.decode_sound` constructs the ORIGINAL
`ShakeSeedMemory.Decode` from finite execution of dec64le: actual declaration,
pointer assignment, eight guarded unsigned-byte reads, casts, shifts and ORs.
The scalar expression is definitionally the pinned source decodeExpr. This
does not replace dec64le with an aligned word load; the byte access semantics
remain visible and checked.

`ShakeEncodeCompute117.invoke_sound` constructs the ORIGINAL
`ShakeEncode.Invoke`, including its typed argument entry, declaration, pointer
assignment and all eight source byte stores. Conversion uses the previously
proved Cell.converted_reference bridge. Every store checks allocation, byte
width and writability; caller locals/pointers are restored by the call result.

`ShakeXorCompute117.invoke_sound` constructs the ORIGINAL
`ShakeSeedMemory.XorCall`: actual entry, declaration/initialization of u,
condition, source dec64le, word load, unsigned XOR, word store, increment and
loop. All scalar operations use existing source-sound calculations. Finite
fuel is only an execution-witness search bound; None is not interpreted as a
proof of source failure, nonreturn or impossibility.

Ten closed kernel controls check decoded/encoded little-endian words and their
source witnesses, a valid unaligned byte decode, rejection by an aligned word
load, enforcement of a seven-byte object boundary, a readonly destination,
and one concrete xor call with its original source witness. Source fixture
data is small synthetic word data. No probability experiment or new numerical
estimator was performed; these are kernel propositions, not empirical tests.

Four mathematical modules plus audit form a coherent5/5 clean closure. Final
audit job keygen_shake117_007 checks56 named declarations, full term/type DAG
roundtrips and only propext/Classical.choice/Quot.sound, with logs0/0. Accepted
module receipts002/003/006 are individually pinned and rechecked by the seal;
the audit imports their exact artifacts. Seven jobs, five failed/mixed, all
retained with causes: missing DecidableEq on the reference expression, abstract
cast conversion, automatic reduction of known prologue binds, a monadic bind
rewrite, and a definitionally equal record update. No limits/lint relaxed.

Entry verified all28890 pins from116; parent postseal
de8687c6bf87d5c5b4c903b6820276e40f36a9b9c7c907891e886e60f797b693.
117 ENTRY_PINS:2280a3c629c373bae1b93a8f7311ffc3036837778596763ecd33410bf06af81d.
The local24-round Process witness from116 remains sealed and unchanged.

Next: instantiate the complete init/inject/flip/extract source grammars with
these helpers and116 Process, then attach the SAME actual seed/prefix and
MODE1 sampling. The solver/gates/final-packet obligations remain in the
whole-program TODO. No new assumptions, IID, F04 substitution, paper promotion,
production changes, push, schedule, migration or independent review claim.
Exactly five do_sign obligations remain unchanged. Continue after postseal.
