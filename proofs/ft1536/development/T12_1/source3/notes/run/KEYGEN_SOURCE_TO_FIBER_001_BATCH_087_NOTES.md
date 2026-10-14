# BATCH087 — KeyGen law boundary

2026-10-14. **BLOCKED_SOURCE_LAW_BINDING / NOT_REVIEWED; Acceptance NOT MET.**
Main report: `KEYGEN_LAW_087_REPORT.md`. Exact requested actual byte-game
and key-law equality remain OPEN. The new algebra and obstruction results
are `PROVED_KERNEL_SCOPED`, not a source-law realization or security theorem.
Source proof commit: `e0c991bb` (two mathematical modules, no push).

## Checks and evidence

- Entry verifies all 22,434 POSTSEAL086 pins; `ENTRY.json` records base
  HEAD `b9496334ad2c7993cf337f44140d3caf0bd63c1a`.
- Candidate manifest checked in full: 17 source files and eight lexical
  regions from live `Extra/c`, plus source/game/scope inputs and the exact
  Lean serializer source. `KEYGEN_LAW_087_SOURCE_MAP.json` is evidence of
  byte identity and source inspection, not proof of source-law adequacy.
- Two proof modules contain 35 named mathematical declarations, of which
  21 are theorems. There are no new axioms or unfinished-proof declarations.
- Final coherent job **key_law087_017**: two proof modules plus audit,
  **3/3 exit 0, empty stdout and stderr**. All 35 mathematical declarations
  have full types, full term graphs, and transitive axiom lists contained in
  `{propext, Classical.choice, Quot.sound}`.
- Dependencies: exactly the existing F04 scope of 166 pinned source/product
  pairs; excluded #166 stays excluded, and the previously documented #156
  exception is unchanged. No dependency replay or new independent review.
- One Lean process at a time; pinned `pre_sign086_job.py` runner,
  `-j1 -M6144`, `warningAsError=true`, no-network bwrap, original memory/time
  bounds, durable job directories. No linter suppression or raised proof,
  recursion, exponentiation, or pretty-printer limits.
- No new numerical experiment was needed: the universal claims and exact
  small counterexample are proved by Lean. Python organizes hashes, pins,
  snapshots, counts and receipts; it is not mathematical evidence.

## Full term audit representation

The unchanged pretty-printer budget could not expand a large tactic proof.
A naive JSON tree then duplicated shared subterms and exceeded the memory
budget. Neither refusal was bypassed by raising limits or omitting proofs.

The final audit uses a DAG with all expression nodes, child indices, exact
name/level encodings, and a root index. It serializes to JSON, deserializes
the JSON, reconstructs the expression, and checks both the term's
definitional equality and its inferred type against the loaded declaration.
Nonsemantic `mdata` annotations are stripped on reconstruction; binder
information, universes, names, literals, applications, lets and projections
are retained. Full type text still rejects truncation. Standard-axiom
checks concern the mathematical declarations and their transitive proofs.

The audit-only serializer code is generated from the pinned toolchain's
name/level primitives (with their Apache 2.0 attribution), plus
`tools/key_law087_expr_dag.lean`. It contains no network/evaluator code.
The exact audit source is reproduced by `key_law087_evidence.py audit`.
Large raw term graphs remain in `.build/jobs/key_law087_017/`, pinned by the
batch receipt; they are not duplicated in Git. Serializer helpers are
audit tooling, not additional mathematical exports among the 35.

## Every retained job

| Job suffix | Actual result / cause |
| --- | --- |
| 001 | Sandbox refusal before Lean: NETLINK_ROUTE; retry used the same runner's own bwrap isolation |
| 002 | Proof edit errors: unused simp argument and already-closed impossible branches |
| 003 | First mathematical module accepted, 0/0 |
| 004 | First module accepted; closed large exponent refused and unreduced Law projection |
| 005 | First module accepted; large exponent still reached normalization |
| 006 | First module accepted; definitional enumeration hit recursion limit |
| 007 | First module accepted; closed-power elaboration still reached exponent threshold |
| 008 | First module accepted; explicit parameters alone did not avoid it |
| 009 | Both mathematical modules accepted, 0/0; pretty-term audit truncated |
| 010 | Both accepted; audit used reserved identifier `syntax` |
| 011 | Both accepted; ordinary import did not expose private serializer names |
| 012 | Both accepted; `import all` requires `module` |
| 013 | Both accepted; module-mode audit cannot import legacy non-module proofs |
| 014 | Both accepted; expanded JSON tree hit memory budget |
| 015 | Both accepted; DAG early-return scope and constructor layout errors |
| 016 | Both accepted; nested return still escaped to the visitor's result |
| 017 | Both modules and full DAG/axiom audit accepted, 3/3, 0/0 |

17 job directories, 15 failed or mixed; partial accepted steps are not
relabeled as fully accepted jobs. Every raw log, source snapshot and receipt
is retained. Lean's generated error-recovery terms in rejected organizer
compiles are not accepted proof evidence. The final audit rejects extra
axioms and the final streams are empty.

Two preseal source-map drafts and their exact generator versions were
preserved before updating the generator's failure accounting and audit
format. They are historical metadata, not the final source map; final
evidence includes them without editing or adopting their obsolete live-path
generator pins as current pins. No historical 084–086 receipt was changed.

## Self-review, proofreading, and acceptance

The self-review reconstructs the four seed cases and the normalized masses
from their definitions; checks zero success mass; and verifies the support
argument's target is the **full pre-gate** candidate space. It explicitly
does not transfer that cardinal obstruction to the accepted-key law.
A2 is already in scope, and no claim that it is absent is made.
The source record distinguishes system-seed acquisition, deterministic
SHAKE extraction, rejection loops, gate acceptance, encoding, and return 1.

Conservative proofreading covers only the new modules, report, these notes,
and live checkpoint additions: terminology, references, counts and claims
of scope. No mathematical-token changes were made by proofreading.
Unresolved issues are substantive source-law obligations in report section 5,
not corrected by wording. This is author self-review, not independent review.

The do_sign slot remains exactly the owner's five items. Actual-C
`e2 = k^32 - 1` is not newly proved. No new premise, reviewer, worker,
relay, push, import, tag, migration or production C edit.

Seal commands (executed only after the final accepted job and notes):

```sh
python3 -B proofs/ft1536/development/T12_1/source3/tools/key_law087_evidence.py seal key_law087_017
python3 -B proofs/ft1536/development/T12_1/source3/tools/key_law087_evidence.py postseal RECEIPT_SHA256
```

Receipt: `KEYGEN_SOURCE_TO_FIBER_001_BATCH_087.json`; postseal:
`.build/key_law087/POSTSEAL_087.json`. Exact final hashes are in the live
checkpoint and `KEYGEN_LAW_087_FINAL.md`, which are written after sealing.
Postseal is an integrity result, not acceptance of the KeyGen-law target.
