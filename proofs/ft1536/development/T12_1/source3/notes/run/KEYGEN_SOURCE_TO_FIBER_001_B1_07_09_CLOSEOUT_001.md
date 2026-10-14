# Keygen B1.07–B1.09 assembly closeout (batches 079–083)

Date: 2026-10-14. Status: required owner items 1–4 complete in the pinned
C99/GCC LP64 reference and explicit legal-memory/capacity domain,
`PROVED_KERNEL_SCOPED / NOT_REVIEWED`. B1.07, B1.08 and B1.09
reference-scope Acceptance is met. Optional item 5 has a prepared kernel
adapter to the existing fiber; formal B1.10 acceptance and B1.11 fresh
closure replay/mutations/independent review remain open. This is an author
closeout, not an independent review.

## Results and exact interfaces

| Owner item | Evidence | Result |
| --- | --- | --- |
| 1. Accepted attempt to serialization | `formal/Source3/KeygenAcceptedMaterial079.lean`, `KeygenAttemptSerialization079.lean`; batch 079 receipt | The accepted state, workspace, nine-statement heap frame and f/g/F/G/h at four actual codec calls are connected. Batch 079 alone was conditional and did not meet B1.07 Acceptance. |
| 2. Workspace, relocation, call identity and lifetime | `formal/Source3/KeygenPinnedInvocation080.lean:15-56`; batch 080 receipt | `successful_frontier` takes legal initial memory/profile, a pinned source execution and observed return 1; it does not take an intermediate workspace bridge, certificate result, codec result, encoded length or frame as a premise. B1.07 Acceptance met in the stated domain. |
| 3. Complete secret packet | `formal/Source3/KeygenSecretComplete081.lean:39-98`; batch 081 receipt | `observed_secret` establishes the final secret packet after public serialization and teardown, with header `0xaa`, all four vectors and one source certificate. `actual_observed_decode` consumes independently observed bytes; 7681–10369 is a derived length bound. B1.08 Acceptance met. |
| 4. Public packet and joint output | `formal/Source3/KeygenPublicComplete082.lean:13-70`; batch 082 receipt | `observed_pair` joins both final outputs to the same accepted material and certificate. `actual_observed_pair` consumes independently observed secret and public bytes, derives their decodes, public length 2881 and secret length bounds. Initial public capacity and writable-buffer legality remain visible premises. B1.09 Acceptance met. |
| 5. Optional fiber adapter | `formal/Source3/KeygenEmittedFiber083.lean:25-69`; batch 083 receipt | `from_output` transports the source-derived NTRU, public and inverse equations to the existing `ActualNTRUFiber` coordinate formula and Gaussian reindexing. `emitted_to_actual_fiber` and `actual_observed_fiber` use the same joint output. Adapter prepared; B1.10 contract acceptance and B1.11 are not claimed. |

The final root theorems assume a pinned execution of the fixed source bodies,
the explicit legal input memory and buffers, `comp = 1`, public capacity
legality where needed, and an observed return value 1. They do not establish
that an attempt succeeds or that the real keygen terminates successfully.
They derive codec outcomes, lengths and frames from the source/body
development rather than taking those outcomes as extra premises. The finite
actual-read pointer legality inherited by the memory model remains an
explicit scope condition.

## Receipts, postseal checks and commits

The SHA-256 values below were recomputed from the current bytes. Postseal
artifacts are retained in `.build/levels_NNN/` and are not Git source files.
All batch receipts and notes remain paired and unchanged.

| Batch | Scope and local commits | Receipt SHA-256 | Postseal pins / SHA-256 |
| --- | --- | --- | --- |
| 079 | Conditional bridge; `57b956ac` | `615d177f63baed0659ddc639959d448c4ddc9c6261640f520fdbe0356213663d` | 20,759 / `b220c61289c1b2797ad9a2d50f9eb248eb1253c2045b7bc2db7a36531f6ba1ab` |
| 080 | B1.07 accepted; `7ef4062b`, `b373a0fe`, guard record `fad3b329` | `33ed9062757d33b00a84bc0ea532d42db4d834e3118560244fb0abd3bfc6bbfd` | 21,222 / `a023fccf386deda4651b8ae82e92e2de9c6084cec4a1328dd38a9b4fdcfbc673` |
| 081 | B1.08 accepted; `5816f6b9`, `4cbe1263` | `80391f19b2fa9b829773a367291154f06049197364dc0d9b6dd82940dc2f1b75` | 21,621 / `723df7752d02d7b7919203b5dd5486d3af8cf2f895db4a9deb9c2e22c7722ad1` |
| 082 | B1.09 accepted; `0f960005`, `28b55829` | `a72155c715932406d7195036c1932a13f3629aad71a6a225012c7cc43141571b` | 21,758 / `b2961b900211b4776da3901112d7aa745c5b85ed6ddfa3f3c7a79072ed3f4b6c` |
| 083 | Fiber preparation and coherent audit; `1387b8c1`, guard record `dd77c496` | `ff6410db4bf653a7727e4df3ff741c5580dad240bb2959166c44a0d8893f565d` | 21,798 / `c030bfa32b6b45d7ddabc2a5b1582ed9aef225df6078c68f320e047bdf98218b` |

The final postseal reports 21,759 incoming pins verified, 21,798 distinct
pinned files, all new declarations coherently audited, selected native logs
clean, no active jobs and no push. Its `full_b1_11_replay` field is false.
Across 079–083 there are 44 new proof modules, 228 named declarations and
158 named theorems. The final coherent audit covers 243 distinct entries
(215 full terms, 28 kernel inductives), including 15 inherited boundary
declarations. Its only recorded axioms are `propext`, `Classical.choice` and
`Quot.sound`. The audit JSON is
`.build/jobs/keygen_fiber_083_002/SEARCH_AUDIT.json`, SHA-256
`a63e58f6ab4b0533d921906b07287213e78b7fa4b54187ada2f0e167ef1003a2`.
No new `sorry`, `admit`, `native_decide`, axiom or warning suppression was
introduced by this assembly.

The first 083 seal invocation refused entry because a separate S05/QROM
Lean process occupied the single proof slot. The preserved
`.build/levels_083/SEAL_REFUSAL_001.json` records
`REFUSED_ACTIVE_FOREIGN_PROOF_JOB_AT_ENTRY`, no manifest written and no
integrity mismatch. The later seal and postseal succeeded without relaxing
the guard. Prior failed or superseded attempts in 079–082 remain pinned in
their batch histories.

## Boundary and next step

This closes the required source key-material and observed-packet assembly.
It strengthens the keygen input available to the B1 realization lane, but
does not discharge the honest-Sign bridge (arrows 1–2 of
`../run2/notes/B4_SYNTHESIS.md:305-313`): `do_sign`, `ReplyShape`,
`AttemptShape`, `keyIdent` and the local joint-certificate consumption still
need their own source binding. It also proves no key-law probability,
acceptance probability, PRG/compiler step, QROM claim or security property of
the actual signing code. Arrows 3–4 are separate conditional mathematical
results and are not upgraded by this checkpoint.

Next: a new, explicitly scoped B1.10 window can consolidate the adapter into
the final contract; B1.11 must separately run fresh dependency closure
replay, mutations and independent review. Keep 079's conditional status and
083's prepared status in the historical receipts; do not rewrite them as full
acceptance.
