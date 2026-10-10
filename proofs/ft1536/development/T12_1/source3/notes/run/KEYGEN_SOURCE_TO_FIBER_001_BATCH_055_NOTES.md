# BATCH_055 — ONE material witness: solver-call h frame and both equations

**B1.07: PARTIAL_PROOF / Acceptance NOT MET / NOT_REVIEWED.**
**Package: IN_PROGRESS / WORKING_NOT_FROZEN.**
2026-10-10, MiMo V2.6 Pro (`xiaomi-token-plan-ams`).
**CLOSED_AT_RECOVERABLE_MIDPOINT.** Exactly one close in this owner-started
window. B1.05/032 and B1.06/046 unchanged; B1.08/B4/B5 NOT entered.
Historical runner/session labels remain provenance.

## 1. Entry pins BEFORE edits/jobs

BATCH_015–054: **11459 distinct pins / 234 interface bindings**, no
supersession or active job, verified with the sealed 054 pair
(`922f51b3…`/`26261221…`) into `.build/levels_055/ENTRY_PINS_055.json`
(`4e850fee…`). All 015–054 source/product/report/failed bytes unchanged.
New proof sources use NEW modules; no inherited module is edited. The entry
verification preceded all edits and jobs.

**Named anomaly (retained, NOT repaired here):** the working tree of
`formal/Source3/KeygenMakeCertAudit.lean` (`cad35f72…`) is the byte-exact
generator output pinned by the whole BATCH_015–055 chain, while `git HEAD`
still carries the pre-generation variant `bdd0dca0…` (committed 15:30:57,
before the final audit promotion at 15:31 in the 051 window). Every entry
verify checks the pinned bytes and passes; the file is left untouched and
uncommitted in this window (later windows correctly refuse to sweep it into
their pathspecs). Owner decision wanted: a dedicated provenance commit or an
explicit note; no history rewrite.

## 2. Exact operational scope — the one material witness

One new proof module and its generated internal audit were accepted 0/0, in
unchanged plan order (§34.1 item 1 first):

1. `KeygenMakeMaterialWitness`: **the solver-call h frame**. The accepted
   `solve_NTRU` call keeps every byte of the h block (`solver_h_same`): its
   writes stay in F/G and the scratch. The frame is composed from the search
   frame (`KeygenRootSearch.frame` on protected blocks), the output-gate
   write decomposition (`gate_writes` + a generic `Writes` outside-bytes
   induction) and the four-leg validation body: generation
   (`KeygenMkgm3Frame.outside_bytes`), conversion (a new `Trace`
   outside-bytes induction over the store frames), transforms
   (`sequence_frame`'s `Frame`) and the read-only final check
   (`read_only_heap`). `h_represented_solver` transports the public h
   representation across any same-block execution.
2. **ONE material with BOTH equations** (`Witness`): `witness_at_solver`
   joins the 046 public equations (h·f=g over Rq and the f-inverse equation)
   with the exact integer NTRU equation fG−gF=18433 on ONE material over the
   same physical f/g/F/G/h arrays, from the accepted solver call
   (`KeygenRootCaller.success`) plus the public material — no equation,
   certificate or codec fact is a premise. `public_material_equations`
   derives the 046 material at the public gate on the actual caller arrays
   with the h-side separation/legality facts as explicit local inputs of the
   `LegalWorkspace` class.
3. **Physical material through the encoding tail**: `certificate_material_block`
   (any block outside workspace block0 and the static table blocks 1/2 keeps
   its bytes through the accepted certificate call: `CallerFrame` + region/
   table conditions + the beyond-extent leave) and `witness_represented`
   give `attempt_witness`: the sixth gate preserves the witness to
   `EncodingInputs` at the accepted-break state. `encoding_position` ties the
   18-statement encoding tail (`outer.drop 15`, kernel-checked) to the caller
   syntax right after the attempt loop; the reference C transcription control
   checks the tail's five encoder inputs `ske[0..3]=f,g,F,G` and `h`. The
   tail's codec bodies are B1.08/09 and are NOT entered.

### Exact exported claims and REAL premises

`Witness heap input pub` is the one-material statement; the join and the
frame consume the certificate call execution, the caller cells and the h
block separation as explicit inputs. The chain is now: 046 public material
(gate 4) → accepted solver call with the h frame (gate 5) → one material
with both equations → certificate frame (gate 6) → encoding-tail input
boundary. The attempt-level spine over a single `AttemptExec` derivation and
the entry facts from the allocation remain the named next step.

## 3. Internal complete-term audit — no independent review

**One proof+audit 0/0**, unchanged runner/proof/print limits: audit entries
= new declarations + inspected inherited interfaces: **109 entries = 18 new
declarations + 91 inherited interfaces**, **87 complete terms + 22 kernel
inductives**, standard axioms only, zero elisions. Solver/public/certificate
interfaces are consumed at their pinned types or inspected; the complete
transitive closures are not re-audited. Not a review.

## 4. Native Sage finite PUBLIC scripted controls — explicit mocks

`sage/check_keygen_make_material_witness.sage` (preparser, ZZ): 5 baseline
families × 4 mutations, all mutations detected: the solver-call h frame
(solver writes h, solver writes f, scratch collision, table collision), the
one-material equation join (swapped F/G, wrong residual, reversed public
equation, wrong inverse), the certificate frame (block0 material, table1
material, region offset inside, table2 material), the encoding-tail boundary
(wrong loop index, wrong tail length, tail overlapping the loop, missing
public array) and the reference-C transcription (solver argument order,
public argument order, encode segment drift, public encode drift).
**EXPLICIT MOCK SEMANTICS**: no real KeyGen, sampler, solver, certificate or
codec result, no private key, no probability or law claim. These supplement,
never replace, the kernel proofs.

## 5. Retained attempts and traps

All failed snapshots from this window are retained with recorded causes:
two rejected elaboration snapshots (002: five interface errors — a missing
generation-source argument in the mkgm3 outside-bytes call, Result/State
confusion in `sequence_frame`/`gate_writes`, an argument-order mismatch at
the validation call site and missing block arguments in the small-write
frames; 003: one residual missing block argument), one rejected elaboration
snapshot (005: `KeygenMakeWorkspaceTables` unreachable through the earlier
import list) and two Sage runs (001: the mutation phrasing of four families
evaluated the corrupted check without its negation — fifteen mutated
variants reported undetected; 002: the tail-overlap mutation phrased as a
fact instead of a failing check). No proof/job/print limit was raised; max
RSS well below the unchanged 8GiB ceiling; no interruption or active job at
close. The `KeygenMakeCertAudit.lean` git/pin divergence of §1 is retained
as an open anomaly, not repaired.

## 6. Remaining B1.07 in unchanged plan order — resume 35R

1. **Attempt-level spine on one `AttemptExec`:** bind all six gates on ONE
   attempt derivation with the entry facts derived from the allocation; the
   h-side separations (`legalH`/`hTables`/`liveTables`, solver `hProtected`)
   are explicit local inputs here and must be discharged from allocation
   freshness (statement-machine step).
2. **Retry frames/whole invocation:** the solver-call h frame on the
   REJECTED edges (partial output-gate writes), `Initial`/legal/static
   transport for every retry instance, general typed execution, every later
   return and the gate-time `ReadTmp` tie; the loop-trace chronology
   transport (`Sampled`/`Remaining`) stays at the gate level.
3. **Statement-machine extraction:** tying the C call site
   `(fpr *)fk->tmp` to `ExecAt` (temp_size body, `falcon_keygen_new`
   prologue, the gate call), the actual globals/common call ID/snapshots
   composition and the b-not-1/2 side condition of the pinned transport.
   Codecs remain B1.08/09; no IID/p_accept/availability law follows.
