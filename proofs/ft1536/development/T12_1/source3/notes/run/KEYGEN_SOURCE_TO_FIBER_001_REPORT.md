# KEYGEN_SOURCE_TO_FIBER_001 — final reference contract

## Exact final theorem and premise boundary

Namespace: `FT1536.Source3.KeygenSourceToFiber001`.

```lean
theorem emitted_to_actual_fiber
    (env : Env) (caller : State) (out : Result) (primes rev : ArrayPointer)
    (rootLegal : KeygenMakeAssembly080.LegalEntry env caller primes rev)
    (buffers : KeygenOutputMemory081.Legal env caller)
    (comp : env.args.comp = 1) (capacity : BitVec 64)
    (publicLegal : KeygenPublicEntry082.Legal env caller capacity)
    (source : PinnedExec env caller out) (success : Success out) :
    ∃ result : Output env caller out, Contract result
```

`PinnedExec` is definitionally `KeygenSecretInvocation081.PinnedExec`;
`Success` is exactly `out.flow = .returned (some (.int32 1))`.
The complete type, full proof term and transitive axioms are retained in
`.build/jobs/keygen_contract084_003/SEARCH_AUDIT.json`. This is a proved
conditional execution theorem, not a proof of successful execution or
termination. No unproved mathematical equation, solver correctness,
serializer round-trip, certificate acceptance, or arbitrary-callee
correctness is an input. Legal memory/profile, finite actual-read address
legality, source execution and observed success are the reference domain.

`actual_observed_fiber` has the same arguments, followed by `sk`, `pk`
and `Emitted env out sk pk`, and yields one result with `Contract result`
and both actual byte equalities. The contract supplies both decodes,
the same source certificate, three equations, fiber coordinates and
Gaussian reindexing, secret/public lengths and final call bound. The
underlying output retains the source-derived rejected-prefix/accepted-last
chronology and its certificate/material witness.

## Acceptance and evidence

| Stage | Status |
| --- | --- |
| B1.07–09 | Independently `PASS_SCOPED`; unchanged 079–083 evidence |
| B1.10 | Reference Acceptance MET; `PROVED_KERNEL_SCOPED / NOT_REVIEWED` for the new consolidation |
| B1.11 | Current owner's scoped evidence Acceptance MET; consolidation `NOT_REVIEWED` |
| Full historical-world replay | **Not performed**; `full_b1_11_replay=false` |
| Whole implementation security | Not established |

The Daybreak review rebuilt 45/45 modules, audited 243 entries and rejected
five deliberate mutations after five passing controls. Its 974 historical
dependencies are consumed through checked source/product pins. The 084
addition compiled 2/2 modules and audited 11 declarations with clean 0/0
logs; both failed jobs are retained. No new reviewer was started.
Reproduction, job histories and exact pin maps are in the paired
BATCH_084/085 receipts and notes, with postseals under
`.build/pre_do_sign084/`. New work is separate from stages import and review.

## Consumption and limitations

This contract can be consumed for every admitted successful execution. It
does **not** identify a distribution `muKey` with the actual conditional
emitted-key distribution: there is no probability law in its theorem type.
The input event also distinguishes successful loop acceptance from output
capacity failure after acceptance. Probability transport must respect that
distinction and the generator/entropy model.

The fiber result says nothing about the real `do_sign` output law, sampler
faults, unbounded internal rejection sampling, physical int16 recovery,
signature packet/verifier transport or a computational hybrid of honest
signing. F04 variant A supplies a uniform ROM challenge in the specified
game, not a theorem about all implementation bytes. The single-do_sign-slot
request is therefore a separate assembly obligation; this report makes no
claim that the deterministic keygen theorem closes those boundaries.

Local contract commit: `029d679c`. No push, migration, reviewer, stages
import, owner acceptance or security acceptance is performed here.
