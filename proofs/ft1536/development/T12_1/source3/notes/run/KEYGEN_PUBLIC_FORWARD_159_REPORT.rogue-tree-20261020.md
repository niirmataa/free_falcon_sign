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

### 0.2 PublicForwardEntry159 — constructive caller-side forward calls

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
(entryT s a) ⟨bodyState,.normal⟩`. No generated table, NTT evaluation or
success value is assumed or concluded here.

### 0.3 PublicForwardBody159 — complete mq_NTT_ternary wrapper body

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
items 4's root solver, certificate and codec stages are still unbuilt; no
root call, certificate outcome or codec fact was assumed here.

## 2. Validation and retained failures

Seven jobs, all retained (runner tools/job111.py, one Lean process, `-j1
-M6144`, unchanged limits):

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
counterexample or integrity failure was found; one earlier scratch note file
was rewritten after a failed editor write and is recorded here for honesty.

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
   (KeygenPublicFirstFold/KeygenPublicUpper*/KeygenPublicTriple*) as the
   constructive loop invariants; do not introduce an NTT oracle.
4. Small local commits without push, retained failures, 0/0 accepted logs,
   one guarded job at a time via tools/job111.py with unique labels
   keygen_publicforward159_*; postseal at the next recoverable checkpoint.
