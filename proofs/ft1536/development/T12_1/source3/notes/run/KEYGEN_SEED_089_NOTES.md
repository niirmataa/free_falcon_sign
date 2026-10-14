# 089 — exact partial source seeding and derived caller facts

2026-10-14. **PROVED_KERNEL_SCOPED / NOT_REVIEWED** for this checkpoint;
the whole actual-KeyGen law task remains **ACTIVE / NOT COMPLETE**.
Parent: POSTSEAL088/A
`7557e64922b0876e7d610dd33441635a82f1c68eac2ab7502ab631a8d27dd54b`.
No per-attempt D1 shortcut, IID premise or new cryptographic assumption.

## Actual constructed object

`KeygenSeedEntry089` represents one supplied 32-byte seed in a fresh input
object and binds the public `falcon_keygen_set_seed(fk, seed, 32, 1)`
header, arguments and actual source body. It retains the same resulting
state as the input to the complete source KeyGen trace. This is the explicit
replacement-seed API boundary; it is not yet a theorem identifying the
default system-entropy path or an operating-system error distribution.

`KeygenSeedFunction089.seedPart env base block seed : Part State` is an
**exact mathematical partial function**, with source execution as its
domain. A state is selected only after proving all completed source runs
have the same resulting state. It is not a supplied execution family, an
arbitrary successful-trace selector, an ideal SHAKE function, or an assumed
termination theorem. Its construction is noncomputable; no new executable
interpreter or numerical probability evaluator is claimed.

`KeygenSeedClosure089.partial_source_spec` states both directions against
the actual fixed-body `KeygenRngReference.Exec` at the supplied arguments,
allowing an arbitrary event list in the statement. Empty entropy history
and the void return are then **derived** from the replace=1 path, rather
than imposed as restrictions on a hypothetical execution. The reset/inject
branch returns before the remix and later injection statements.

`KeygenSeedDomain089.seeded_domain` derives the existing B1 legal caller
domain after source seeding from that domain before seeding and a dead
input seed block. It uses proved heap effects, not legal-output fields on
sampled executions. RNG and flag changes preserve the M0 profile, static
tables, scratch domain, output objects and public length/capacity domain.
This transport does not prove complete source execution exists for every
legal-domain record; concrete caller allocation and definedness still need
their own treatment.

`KeygenSeedFlags089.seeded_flags` derives physical `Load32` observations
`seeded=1` and `flipped=0` from the actual two stores and their nonoverlap.
Neither flag value is a premise. The next readiness proof can use these
facts to exclude an additional entropy draw on this explicit API path.

## Determinism actually discharged

The checkpoint proves uniqueness of completed executions for:

- scalar expressions/statements/functions, with a local callee interface;
- the fixed header, primitive, scaled/of and prefix FPEMU call tables,
  discharging that interface for the actual source scalar calls;
- pointer evaluation and byte/word writes, fills and memory operations;
- the full array/control/function-call natural semantics with a fixed
  function table, including recursive calls and finite loop derivations;
- SHAKE's actual `process_block`, `dec64le`, `xor_block`, and
  init/inject/flip source semantics;
- the actual replace=1 set_seed sequence and its returned caller state.

These are determinism results, not independence, uniform-output,
termination, bijectivity or cryptographic-security results. SHAKE's code
and byte reads are used; no ideal permutation is substituted.

The XOR proof uses the actual scalar-only modular statement shapes. It
does not assert determinism for arbitrary ill-arity modular calls: the old
composite modular bodies quantify over a base state, so their actual
arity/source domains must be respected when extending the proof to KeyGen.
No frozen relation was modified to make such a broader claim true.

## Verification and preserved attempts

Final coherent job **keygen_seed089_025**: **14/14**, empty stdout and
stderr, 13 mathematical modules plus a full type/term-DAG/axiom audit of
**122 named declarations**. Standard axioms only. Original resource limits,
warningAsError, no-network bwrap, one-job lock and immutable job products
remain; no warning suppression or limit increase.

25 job directories, 40 module steps, 27 accepted steps; **13 failed or
mixed jobs**, all snapshots/receipts/raw logs preserved. Exact causes are
in `KEYGEN_SEED_089_FAILURES.json`: parser/reserved-name issues, tactic rule
scope, missing import, dependent case patterns, and explicit state/heap
projection requirements. Partial successful steps inside a mixed job do
not make that job accepted. The longest final module is the general
init/inject/flip determinism proof; its final accepted stream is clean.

The audit uses the previously checked full expression-DAG serializer,
including decode/reconstruction checks against each loaded term and type.
Large logs, artifacts and term graphs remain in durable `.build/jobs/`,
with exact pins. There was no new numerical experiment; Python only
organizes source inventories, logs, hashes and receipts.

## Self-review and continuation

Self-review distinguishes fixed-heap packet uniqueness (088/A), source
seeding-state uniqueness (089), and the still-missing uniqueness of a
complete source KeyGen outcome. It checks that the partial function's
existential domain is not a positivity or termination premise. Caller
transport and flag values are conclusions of source proofs. This is
author self-review, not independent acceptance; proofreading covers only
the new sources and current notes.

Remaining dependencies stay explicit: readiness after seeding, actual
SHAKE extraction and `get_rng_u64` temporary-object relocation, the full
stateful sampler and KeyGen closure, concrete caller/definedness scope,
whole input-to-outcome production, success normalization/existence and
final packet-to-model law binding. The default automatic entropy path must
be reconciled with the declared seed boundary without inventing an OS
failure probability. The outer cap is not an inner-loop termination proof.

The whole TODO remains active across this checkpoint. All five do_sign
items remain unchanged; actual-C e2 is not newly proved. No push, reviewer,
relay, migration, production C edit, tag or stages import.
