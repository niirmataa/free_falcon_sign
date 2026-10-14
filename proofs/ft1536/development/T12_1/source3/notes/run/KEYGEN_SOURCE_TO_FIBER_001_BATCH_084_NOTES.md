# BATCH084 — B1.10 reference contract

Date: 2026-10-14. `PROVED_KERNEL_SCOPED / NOT_REVIEWED`.
Acceptance: **MET in the reference scope**. This is author acceptance of
the contract, not owner acceptance or a new independent verdict.

The new `Source3.KeygenSourceToFiber001` consolidates the unchanged 083
adapter. `PinnedExec` is the existing source relation; `Success` means the
observed return is 1; `Emitted` reads both final buffers and their lengths.
None of those definitions contains a desired equation, decoded key,
certificate acceptance, or a codec postcondition.

`emitted_to_actual_fiber` has exactly the following inputs: `env`, `caller`,
`out`, `primes`, `rev`; `KeygenMakeAssembly080.LegalEntry`; legal output
buffers; `comp=1`; a public capacity and its original-memory legality;
`PinnedExec env caller out`; `Success out`. Its conclusion is one
`KeygenPublicComplete082.Output` with `Contract`. `actual_observed_fiber`
adds arbitrary `sk`, `pk` and their actual `Emitted` observations and proves
their equality to the same output's packets.

| Contract item | Content |
| --- | --- |
| Same material | Four decoded vectors, public h, fInv, all three equations in `Output.secret.laws` |
| Same certificate | Source certificate call with actual memory/material and chronological call identifier |
| Observed packets | Secret header 0xaa; all four independently padded segments; public header 0x8a |
| Lengths | Secret 7681–10369 and public 2881, derived from execution |
| Attempts | `Output.secret.frontier.base.finalCertificate` gives rejected prefix and accepted last attempt; `callBound` gives 1–3000000 |
| Fiber | ActualNTRUFiber coordinates for every c and exact Gaussian reindexing for every real a |

The proof introduces no new mathematical premise. Legal memory (including
the inherited finite actual-pointer-read domain), defined execution and
observed success remain explicit. It proves neither that successful
execution exists nor a probability law, acceptance probability, compiler
transport, or signing/security theorem. In particular a deterministic
fiber contract is not a proof that arbitrary `muKey` equals the actual
conditional key-generation law.

Input: requested base `e8edf9f0b7115d92862c10b9c490d0d8acf1323d`;
actual start `25fda8f00a4324630bc21d1f5d629e6ea5acb7d9`. The two intervening
commits change S05 and record the independent B1 review; the 21798 input
pins remain identical. Entry evidence: `.build/pre_do_sign084/ENTRY_CHECK.json`.
Daybreak report/result pins: `b4df4d69026bd115e2b484114a02d838cba96ab17b732f303466c972fb0ac711`
and `ee08045320d754083f4cd3da4c2c6f1b9107bd603f073b7a357e084cdc2ea28d`.

Final job `keygen_contract084_003`: 2/2 accepted, stdout/stderr 0/0.
`KeygenContract084Audit` records full types, terms/constructor types and
axioms for all 11 named declarations (three theorems), without truncation.
Only `propext`, `Classical.choice`, `Quot.sound` are allowed.
Retained failures: `_001` sandbox refusal before Lean; `_002` a dependent
alias lacked its explicit `Output` argument. No counterexample was found
or claimed. Replay command, from source3:

```sh
python3 -B tools/job079.py lean UNIQUE_LABEL Source3.KeygenSourceToFiber001 Source3.KeygenContract084Audit
```

Sealing: `python3 -B tools/pre_sign_evidence084.py contract`, then
`postseal 084 RECEIPT_SHA256`. The historical 083 receipt keeps its
PREPARED label. No push, independent reviewer, migration or production-C edit.
