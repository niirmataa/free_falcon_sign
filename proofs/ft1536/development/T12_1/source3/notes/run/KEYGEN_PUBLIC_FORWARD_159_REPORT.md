# Constructive forward call layer and ternary body wrapper159

Status at this checkpoint:
PARTIAL_PROOF / IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN.
This is a recoverable midpoint of the public-computation window, not a
successful public call, not G(seed*) and not the owner acceptance.
Whole owner task ACTIVE / NOT_COMPLETE.

## 0. Closed this window

### 0.1 Window158 conversion chain sealed into source commits

The accepted window-158 chain (jobs keygen_publicinput158_001-011, failures
001/002/003/005/007/010 retained in KEYGEN_PUBLIC_INPUT_158_FAILURES.json)
was committed unchanged as three local commits:
a253ce47 (PublicNat158/PublicConvertBody158/PublicConvertFrame158),
3326e294 (PublicConvertInvariant158/PublicConvertLoop158/
SelectedPublicConvert158), cacf2393 (SelectedPublicBounds158/
SelectedPublicTail158/SelectedPublicNttEntry158). Entry pins unchanged:
`.build/public158/ENTRY_PINS.json`, 55659 pins, SHA256
528dbf18337a1e33322eac63ff99a9ba5008fc03449c1751483dcec7b9130290.

### 0.2 PublicForwardEntry159 - constructive caller-side forward calls

`PublicForwardEntry159` constructs the actual mq_NTT call executions on the
converted entry state. `clean/outer/entryT` compute the exact parameter
binding states; `forward_bind`/`forwardT_bind` build the two real Bind
derivations (a pointer argument at zero, logn10 and the signed ternary1),
`wrapper_body` executes the original wrapper: the ternary dispatch takes its
ternary arm and the void return ends in normal flow. `source_call` gives the
generic call execution; `h_exec`/`t_exec` instantiate it for the actual h
and t invocations at SelectedPublicConvert158.after and at the intermediate
post-h state.

Each theorem is parameterized over the actual mq_NTT_ternary body execution
`Exec KeygenPublicSource.program [] (KeygenPublicSource.code .forwardT)
(entryT s a) <bodyState,.normal>`. No generated table, NTT evaluation or
success value is assumed or concluded here.

### 0.3 PublicForwardBody159 - complete mq_NTT_ternary wrapper body

`PublicForwardBody159` executes the complete forwardT body on explicit
intermediate states (KeygenNttForwardExec-style env/ready naming):
u64 dimension and u32 residue declarations, both automatic gm/igm arrays of
2048 words, pointer aliases, the actual MKN shift n=1536 and hn=768
assignments (Eval chains constructed from the pinned operators), the
logn<=9 dispatch with its false verdict, and the dynamic arm: the mq_mkgm3
call with its real parameters followed by both gm aliases. Automatic arrays
are disposed by the two scope exits.

`source` is parameterized over exactly two open callee regions: the
mq_mkgm3 body execution (`code .generate` from `generateEntry`) and the
complete tail execution (`KeygenPublicForwardProgram.tail` from the alias
state). Freshness of the two automatic blocks and their capacities remain
explicit premises.

## 1. Open obligations, in execution-plan order

1. `PublicForwardGenerate159`: the complete mq_mkgm3 body (fixed g/ig
   powers, the 256-iteration bit-reversed write loop with rev10 helper
   calls, the 256- and 255-iteration lower loops and the final division
   store) and its gm/igm write trace. All scalar helper calls are
   constructible through PublicLeafSource157/PublicRevSource157.
2. `PublicForwardPasses159`: the full tail = first pass (768 butterflies),
   the eight intermediate doubling rounds and the 512-iteration degree
   tripling. Initialized-cell invariants suffice for execution; semantic
   conclusions stay with the existing extractive consumers
   (KeygenPublicFirstInvocation/KeygenPublicEvaluationCalls).
3. Compose both calls with `KeygenPublicInputCalls.forward_other` frames
   (h preserved through the t call and conversely), then execute the suffix
   (fragment 1537 10): every t[u] nonzero test, the actual mq_div_18433
   stores, the mq_iNTT call and return 1; discharge
   SelectedPublicStart157.continue_call.
4. After the public call returns nonzero: the root-solver obligation of
   SelectedAttemptPrefix156.continue_search (`KeygenRootSource.Call`,
   i.e. solve_NTRU_deepest/intermediate executions), then the certificate
   gate and the codec encoding tail (KeygenMakeProgram.encoding with the
   KeygenSecretTailSource081 bodies). Only then the whole emitted packet and
   G(seed*) = KeygenByteGame134.evaluate env input seed* = some (.inr packet)
   can be instantiated for KeygenSuccessMass134.positive_iff_witness /
   success_lower_of_witness (Z >= 2^-256).

**G(seed*) is NOT proved in this window.** Beyond the public call itself,
item 4's root solver, certificate and codec stages are still unbuilt; no
root call, certificate outcome or codec fact was assumed here.

## 2. Validation and retained failures

Seven jobs, all retained (runner tools/job111.py, one Lean process, -j1
-M6144, unchanged limits):

- 001 failed: standard tools/job.py cache lane lacks the window-158
  artifacts (they live in the lane cache of tools/job111.py); retained.
- 002 failed: wrong anonymous constructor at Bind scalar values; retained.
- 003 accepted: Source3.PublicForwardEntry159, 0/0 logs.
- 004/005 failed: unused state parameter and Exec.pointer argument order,
  then the arraysBody conclusion naming the inner state; retained.
- 006 accepted: Source3.PublicForwardBody159, 0/0 logs.
- 007 accepted: two isolated audit processes
  (KeygenKernel159AuditV2Part000/001), 0/0 logs.

Exact causes are in KEYGEN_PUBLIC_FORWARD_159_FAILURES.json. No source-C
counterexample or integrity failure was found. Technical note: the editor
write tool reported success while several note files failed to reach this
external filesystem; those files were rewritten through the shell and
verified present. This is a tooling event, not a mathematical result.

Audit collection: 50 declarations over the two new mathematical modules,
full expression-DAG roundtrip, fresh safe kernel definition at the original
type, standard three axioms only, no elisions. `.build/public159/
AUDIT_COLLECTION.json` SHA256
4c3ae08248583fdf3b6055af694ce9045885e6c26cdb36821ff99194ce0ddad4;
aggregate `AUDIT_159.json` SHA256
c9006882da78a8eded008ee891888413f55669b8d1a9da913120b89b382debe4.

No Sage control was run in this window (no numeric claim is made here);
it remains part of the eventual window close. No independent review.

## 3. Pins

- PublicForwardEntry159.lean SHA256
  11dcbeda2b5e65299e561fd219f87b91f35e8c8bab6c38c4894918955caa2b7d.
- PublicForwardBody159.lean SHA256
  6f50af5374bfe5520bcd893b581f8316fbd52c9f3cfd3e7c8a5bb4832eab360b.
- Accepted job receipts: 003 d02c0721a1388608d195c10ab037d76394c0e4073bf649ff79ef4e1fb21cd861,
  006 1491cc1bb2a1951114eee2869ab696015791cd2770e232d44aaf40c16ffeaf62,
  007 dda9930ee764cfb2950d65b37cc8f6a75211e09854d8919cb4c34805ace40f07.
- Audit plan `.build/public159/ISOLATED_AUDIT_V2_PLAN.json` SHA256
  ec4c996a5e67349c75ce254ce3b49beb1edec9dc1f8ab42dd2e00a08f189e982.
- Local source commits without push: a253ce47, 3326e294, cacf2393,
  125a1b41, edab7a12.

## 4. Resume protocol

1. Verify ENTRY_PINS (55659 pins, 528dbf18...) and the postseal pin file
   `.build/public159/POSTSEAL_159.json`; confirm no live owned job.
2. Resume item 1: PublicForwardGenerate159. The mkgm3 body is lines
   823-885 of pinned falcon-vrfy.c; k=logn=10 makes the first while loop
   empty; the main write loop is 256 iterations with rev10 calls;
   capacities and freshness come from PublicForwardBody159's premises.
3. Then item 2 (tail passes) reusing the extractive fold invariants
   (KeygenPublicFirstFold/KeygenPublicUpperLoops/KeygenPublicTripleFold) as
   the constructive loop invariants; do not introduce an NTT oracle.
4. Small local commits without push, retained failures, 0/0 accepted logs,
   one guarded job at a time via tools/job111.py with unique labels
   keygen_publicforward159_*; postseal at the next recoverable checkpoint.

# CONTINUATION batch — ordered plan steps 1a-c, named wall

Status: PARTIAL_PROOF / IN_PROGRESS / NOT_REVIEWED. G(seed*) is NOT proved.

## Step table

| Step (ordered plan) | Status at this close |
|---|---|
| 1a. Forward call layer (h/t calls over the ternary body) | DONE — PublicForwardEntry159 accepted (job 003) |
| 1b. mq_NTT_ternary wrapper body (declarations, gm/igm arrays, MKN, dynamic generator call, aliases) | DONE — PublicForwardBody159 accepted (job 006); open premises: mq_mkgm3 body + tail |
| 1c. mq_mkgm3 generator head (decls, g init, k=logn, post-increment square loop, ig=div) | DONE — PublicGenerateHead159 accepted (job 014); continuation over the generator suffix |
| 1d. mq_mkgm3 generator suffix (logn==1 branch, else arm, 256/256/255 loops, final stores) | WALL POINT — shape fully decomposed (probe 008, DIAGNOSTIC, 31264-byte pin), not constructed |
| 2. tail passes (fragment 1001 61: first pass 768, eight intermediate rounds, tripling 512) | OPEN — not started |
| 3. suffix fragment 1537 10 (nonzero tests, mq_div_18433 stores, mq_iNTT call, return 1) + packet emit | OPEN — not started |
| 4. root solver (solve_NTRU_deepest/intermediate) + certificate gate + codec tails | OPEN — not started (historically separate windows) |
| 5. G(seed*) = KeygenByteGame134.evaluate = some (.inr packet) => Z >= 2^-256 | OPEN — requires 1d+2+3+4 |

## The named wall

The wall is construction volume, not a mathematical obstruction and not an
integrity event. The exact next unbuilt construct is the constructive
execution of `KeygenPublicTableSeed.suffix` (falcon-vrfy.c lines 837-884 of
mq_mkgm3): its parsed shape is fully pinned by the retained probe
`keygen_publicforward159_008` (stdout:
`.build/jobs/keygen_publicforward159_008/logs/Source3_PublicGenerateProbe159.stdout`);
the loop invariants are the value-free Written-range facts described in
NEXT_ROUTE. After it, the tail passes and fragment 1537 10 follow the same
pattern, and steps 4-5 add the root solver, certificate and codec stages.
Each region is window-sized at this project's historical pace (windows
125-158 delivered roughly one such region each), so steps 1d-5 comprise at
least ten further window-sized constructions.

## Continuation validation

Fifteen jobs retained (001/002/004/005/008/009/010/011/013 failed or
diagnostic; 003/006/007/012/014/015 accepted), causes in
KEYGEN_PUBLIC_FORWARD_159_FAILURES.json; accepted logs all 0/0; limits
unchanged; one Lean process. Audit sets: 50 declarations over
PublicForwardEntry159/PublicForwardBody159 (job 007) and 19 declarations
over PublicGenerateHead159 (job 015), full DAG roundtrip, fresh kernel
definitions, standard three axioms only. No Sage control, no independent
review. Postseal pins: `.build/public159/POSTSEAL_159.json` (sha
ccd05f39988fc963d38139928cacd17a307659dc2db74bbae97d51b0f2ea6299) and
`.build/public159b/POSTSEAL_159B.json` (sha
1558cd5b1ffc98f8d8d3c78e96667e9a66a648cd3b813b122befefd87efe367c).
Local commits without push: a253ce47, 3326e294, cacf2393, 125a1b41,
edab7a12, 3e735378, e40477f9.
