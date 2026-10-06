# KEYGEN_SOURCE_TO_FIBER_001 — residue checkpoint (expanded)

Package status: **IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN**.
Checkpoint written2026-10-06 at the close of the owner-scoped window
**B1.03 stage (b): modp_R2 value law**. Stage (b) is CLOSED; this window
ends here under staged-roadmap iron rules1/2. The next owner window is
**(c), row laws**. The whole B1.03 remains open until its table/layout
Acceptance is met. Harness: **GPT-6 Astra Ultrafast**
(`openai/gpt-6-astra-ultrafast`); the runner retains historical labels.
Receipt pair: `KEYGEN_SOURCE_TO_FIBER_001_BATCH_016.json` + `_016_NOTES.md`.
This live checkpoint supersedes BATCH_015's expanded checkpoint; the
historical checkpoint and its pins remain in Git/BATCH_015.

## 1. Closed this window — commits, modules, evidence

Local source commits on `main`: **`b3941188`** (generic word law) and
**`1856d911`** (source refinement, contracts, audit and Sage controls).
This checkpoint and BATCH_016 form the final documentation commit.
No push; no independent review. Exact paths and the shared
`proofs/ft1536/work/archive.lock` were used for each Git writer window.

| Component | Kernel-checked result | Accepted job |
|---|---|---|
| `KeygenModpR2Word` | Canonical `2^62 mod p` and explicit `R*R` scale for every odd `2^30 < p < 2^31` with valid `p0i`. Invariant after n squares: `R*2^(2^n)`. Exact low-bit mask, no overflow in the halving sum, parity correction and range. No primality assumption. | `keygen_modp_r2_word_002`,1.618s |
| `KeygenModpR2Exec` | The existing `GenExec LeafCall r2Code` consumes the declaration, `modp_R`, addition, five squarings, halving assignment and return. `source_exact` returns the same word algorithm; `body_exists`/`source_exists` construct executions for arbitrary parameters/base state. | `keygen_modp_r2_exec_004`,14.598s |
| `KeygenModpR2` | `source_contract`, `parsed_contract`, `call_contract`; M0 `initialized_value_law` derives the inverse condition from executed `modp_ninv31`; `initialized_to_montgomery` proves the scalar conversion `a -> R*a`. | `keygen_modp_r2_contract_001`,2.720s |
| `KeygenModpR2Audit` | Actual types/terms/axioms of20 definitions/exports (4 definitions,16 theorems). Zero elisions; only `propext`, `Classical.choice`, `Quot.sound` or subsets. Internal audit only. | `keygen_modp_r2_audit_005`,1.167s |

### 1.1 Exact contract and premise boundary

For `p p0i : BitVec 32`, the general contract consumes:

```text
2^30 < p.toNat
p.toNat < 2^31
p.toNat % 2 = 1
2^31 divides p.toNat*p0i.toNat+1
KeygenModpR2Exec.SourceExec p p0i v
```

It concludes `∃ out, v = .uint32 out ∧ Contract p out`, where:

```text
Contract p out :=
  out.toNat < p.toNat ∧
  out.toNat = 2^62 % p.toNat ∧
  value p out = radix p * radix p       -- ZMod p.toNat; radix = 2^31
```

`SourceExec` is the existing `r2Body [.uint32 p, .uint32 p0i] v`, not a
new execution definition with arithmetic conclusions built in.
`parsed_contract` uses the existing `r2_source_bound` for region2575/24.
For M0, `initialized_value_law` needs only the actual source initializer
and `ModCall "modp_R2"` derivations, and obtains the arithmetic domain
facts internally for `KeygenNinv31.prime = 2147355649`.
The conversion lemma is scalar; gm rows/stores are the next stage.

### 1.2 Pins and validation

Before work: BATCH_013/014/015 matched their committed bytes. All360
current source inputs of `keygen_rev10_cert_004` matched; the seven
differences from `keygen_mkgm3_frontend_011` are exactly the documented
BATCH_014 repairs. No baseline reference/parser/consumer source changed.
The new modules were checked in dependency order, without replaying the
unchanged old35-module closure.

- BATCH_015 JSON: `b5bb63f5ddfb423ff6a4742dfd2893bcc7587b4cb50f51877b9b3910285be134`;
  notes: `aec981ffab3f9065ac10d6d99f4f931ceccd852f237382e3b0240b64fbe53cd8`.
- REV10 job RECEIPTS: `778fa00df3128ef824b7ef853aedda5f6119dc9b72aeffc0aba3c1290f7e909c`;
  SOURCE_INPUTS: `f0059207c93cb832acee4b7aefe99016d7e0e93f2c22d08edea77491a87a9ae2`.
- Runner: `3bc29bf7aef246bcd49bcd1bafe0120f26225252f505208a9563d76919cafba5`, unchanged.
- `KeygenModpR2Word.lean`: `d9e0500f9f4ab2bd7c5fb706550d7488767673b385b54059454a4182313cd33d`.
- `KeygenModpR2Exec.lean`: `1b3393fd05cd123fc1e4144c4c79692f6682b5888d2110fdf13a6ac3d8b7f3e6`.
- `KeygenModpR2.lean`: `77197fc66349ac0c02a13052eb8e379c7c25eba6b90d4af23a05018c0003d233`.
- `KeygenModpR2Audit.lean`: `48ab598bbbb5d4d5f66eee452d4e1fdb5ed27f7f7f0920a6c2c60e3f07aaed08`.
- Audit output: `.build/jobs/keygen_modp_r2_audit_005/MODP_R2_AUDIT.json`,
  `ab90b96085180b7d1868e405a9456f6b75528d4db491bbc178b8f0ac06af6ade`.

The paired BATCH_016 JSON records every accepted job's source, RECEIPTS,
SOURCE_INPUTS, olean and log pins. All accepted stdout/stderr are0/0
bytes; proof limits and warning handling are unchanged. Audit pretty-
printing uses a separate output budget, not a larger proof budget.

Sage/C diagnostic `keygen_modp_r2_checks_001` passed in2.521s:7 public
odd moduli, both halving parities, normal/UBSan,3 detected mutations in
each mode. These56 finite observations supplement the kernel theorem.
Result SHA256 `49c8f1b35cdb7561290779e0fd5d3ee20e0bc10b2289ab1e4ca7d00cf3171018`.
Raw generated C/child logs/binaries remain in the durable job directory.

## 2. In flight — exact types and state

**Nothing in flight; no owned proof job remains. Stage (b) is complete.**
The source-bound `modp_R2` result and scalar Montgomery conversion have
checked inhabitants with the premise boundary above. No unresolved draft
or missing type remains inside this owner-scoped stage.

Retained FAILED attempts: `keygen_modp_r2_word_001`, `exec_001..003`,
`audit_001/002/004` (all with the same `keygen_modp_r2_` prefix).
`audit_003` was accepted for types/axioms but its5 elided proof-term
prints are **superseded partial output**, not the final complete-term
audit. `_005` closes that output issue. All snapshots/receipts/raw logs
remain; BATCH_016 records the reasons and hashes.

## 3. Remaining work — execution-plan order

1. **B1.03 stage (c), next owner window:** per-row exponent/order laws,
   canonical ranges and Montgomery scales from actual `modp_mkgm3` stores.
   Use `KeygenModpR2.initialized_value_law` / `initialized_to_montgomery`
   alongside the already-checked generator orders and REV10 certificate.
2. **B1.03 remaining layout:** `igm=ft` overwrite with preservation of gm
   and original source material; derive extents and non-overlap from the
   caller buffer layout. Full Acceptance remains initialized source gm
   words with canonical ranges and exact scaled root identities.
3. **B1.04:** NTT canonical range and polynomial evaluation, its6 planned
   sub-proofs. `t*m=n` belongs there and only there.
4. **B1.05–B1.11:** solver/public equations, whole caller/attempt/gates,
   codecs, emitted-to-fiber composition, final replay and owner review.

The `modp_div` value law is not claimed; its body binding remains checked
and its value is not required for the gm words. No solver/serializer
correctness, desired NTRU/certificate result, source completeness or
arbitrary callee contract may become a final premise.

## 4. Traps — preserve earlier1–48; new49–53

Earlier traps remain in the historical checkpoints/BATCH_013–015. In
particular: bounded parse slices and glue through facts, full changed
descendant closure in one job, one-instance `rw`, `Nat.add` recursion on
its second argument, and implicit-argument core lemmas still apply.

49. Normalize a BitVec literal's `toNat` to a natural numeral before
    `omega`. Its raw expression may otherwise be treated as an atom.
50. A dependent `GenExec.seqNormal` constructor cannot infer an
    intermediate state solely from postponed proof holes; provide that
    state explicitly. Similarly specify the new word in `setZ_params`.
51. Recursive-tail `simpa` can expose `List.append` on only one side while
    the other retains `++`. Normalize `HAppend.hAppend` and `Append.append`
    explicitly, in addition to the local list definition.
52. `ConstantInfo.value?` defaults to definitions only; for theorem terms
    request `allowOpaque := true`. In this audit's `TermElabM`, direct IO
    action lifting works; unqualified `liftIO` is not available.
53. Successful compilation does not imply complete pretty-printed terms.
    Check for elisions explicitly. `_003` retained5, `_004` rejected one
    remaining oversized `pp.all` rendering; `_005` uses ordinary notation
    with proofs/full names/universes and passes the explicit elision guard.

## 5. Carried checked facts

- **REV10 exactness CLOSED** in BATCH_015 / `29e6372b`:
  `KeygenRev10Cert.rawTable_exact : rawTable = some ((List.range 1024).map bitrev10)`.
  Source pin `9fd2b27e1138f88e686513f8814d53c23c421caab2fe430353ba2bba89dfb69b`.
  The32-entry model chunks and11 source slices of at most8 pinned lines
  are unchanged. Earlier failed attempts/generator pins remain recorded.
- B1.03 callee bindings (`r2_source_bound`, corrected `div_source_bound`,
  `KeygenMkgm3Program.source_bound`), generator orders9216/4608 and the
  `modp_R` value law remain closed.
- B1.02 whole forward-body execution/counters/positions, B1.01 word
  adapter, coefficient conversion/material preservation, solver-check
  suffix, certificate and STABLE_BINARY_004 scoped results are unchanged.

## 6. Resume protocol

1. Read live `WORK_STATE.md`, this checkpoint, the stage's EXECUTION_PLAN
   and `run2/notes/B1_STAGED_ROADMAP.md`. Start **(c)** only on the next
   owner instruction; do not repeat stage (b).
2. Verify BATCH_016 sources and accepted RECEIPTS/SOURCE_INPUTS/audit pins,
   with BATCH_015/REV10 as the predecessor. Check current ownership/jobs.
3. Use unique labels and `tools/job_when_available.py`, one guarded job
   at a time, unchanged limits, clean0/0 logs. Rebuild all cached
   descendants if a dependency changes. Current new closure is
   `KeygenModpR2Word -> KeygenModpR2Exec -> KeygenModpR2 -> KeygenModpR2Audit`.
4. Make small local exact-path commits on `main` with one Git writer;
   publication waits for a separate explicit owner signal.

`emitted_to_actual_fiber` remains uninhabited. Nothing here is REVIEWED.
