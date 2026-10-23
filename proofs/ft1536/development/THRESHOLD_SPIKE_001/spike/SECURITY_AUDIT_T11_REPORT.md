# Security Review: src

## Scope

Standard static security audit of the exact current target/src snapshot.

- Scan mode: deep_repository
- Target kind: git_revision
- Target ID: target_sha256_5b0ae1943fc78a3e411ee02f4c41bc8fce33d63c75d8f62b013d02fe556c999a
- Revision: 914d299a77bc997cc3bd82472313752aadea5f3f
- Inventory strategy: repository
- Included paths: .
- Excluded paths: none
- Artifacts reviewed: bin/iso.rs, cmp.rs, cost.rs, ishare.rs, klein.rs, lib.rs, mpc_sign.rs, mul.rs, pedersen.rs, prss.rs, rejection.rs, select.rs, shake.rs, xof.rs
- Scan context: FT1536 research prototype; N=1536, q=18433, ring X^1536-X^768+1, ternary secret; not standard Falcon.

Limitations and exclusions:
- Dependencies including `ft1536_sys`, production deployments, the wider repository and other variants were outside source scope.
- Runtime reproduction and test execution were prohibited.
- Token usage total/input/cached was not exposed to this worker and is explicitly unmeasured.
- No application execution or external dependency validation.
- Out-of-scope deployment controls and ft1536_sys key lifecycle remain unknown.
- Complete source coverage does not imply the prototype is secure or cryptographically proven.

### Scan Summary

| Field | Value |
| --- | --- |
| Scan outcome | completed |
| Reportable DSS findings | 16 |
| Report instances | 16 |
| Report severity mix | medium: 10, low: 6 |
| Report confidence mix | high: 16 |
| Coverage | complete |
| Validation mode | Independent baseline and architecture review, focused protocol investigation, and one parent source validation per unique finding. |

Canonical artifacts: `scan-manifest.json`, `findings.json`, and `coverage.json`. This report is a deterministic projection of those files.

## Threat Model

Generated, source-backed model for the pinned 14-file Rust research prototype. It implements Shamir sharing over GF(256), Z_q (q=18433) and Z_P (2^61-1), Pedersen/VSS experiments, dealer and contribution aggregation, Beaver/re-share multiplication, MAC openings, PRSS-lite, rejection/Klein samplers, bit-shared SHAKE, and FT1536-specific signing helpers. `bin/iso.rs` is a local file-backed multi-process demo CLI, not a network service. FT1536 is N=1536 over X^1536-X^768+1 with q=18433 and is not standard Falcon (mpc_sign.rs:1-13). Distinct signing paths must not be conflated: seed/share ceremonies reconstruct complete secrets before calling the out-of-scope engine (lib.rs:2672-2759; mpc_sign.rs:901-919), while ishare paths keep aggregate trapdoor shares but remain semi-honest/research constructions (ishare.rs:1-25,1389-1526,3166-3302). No in-scope HTTP/network listener, authentication service, tenant model, production deployment manifest, or release workflow exists.

### Assets

- Complete 32-byte seeds, encoded secret keys, FT1536 trapdoor polynomials f,g,F,G, and the deterministic signing authority they confer (lib.rs:2672-2750; mpc_sign.rs:901-919; ishare.rs:1374-1380).
- Per-party shares and clear contributions over GF(256), Z_q and Z_P, plus participant identity, threshold and session bindings (lib.rs:120-185,312-339; mpc_sign.rs:15-19,173-202; ishare.rs:33-44,2798-2809).
- MAC key delta/shares, Beaver/authenticated triples, PRSS pair seeds/counters, masks, Gaussian noise and preprocessing freshness (lib.rs:447-520,1293-1455; prss.rs:16-130; ishare.rs:1610-1921).
- Pedersen commitments/blinds and the integrity/confidentiality link between commitments, exponent shares and arithmetic shares (pedersen.rs:39-163,241-365; ishare.rs:2157-2305).
- FT1536 NTRU relation fG-gF=q, coefficient bounds, ring/field correctness, sampler distribution, nonce/key derivation and signature equation integrity (mpc_sign.rs:380-444; ishare.rs:1924-2154,3101-3164).
- File-backed demo artifacts: share columns, deals, triples, masked messages, outputs, MAC/delta shares, commitments, audit logs and captured clear contribution transcripts (bin/iso.rs:79-104,287-415,495-680,940-1107,1112-1395).
- Snapshot identity: 14 regular `.rs` files, 722342 bytes, no symlink/special `.rs` files, deterministic inventory digest 67a6474900bdc7d42f853cb5945f0bc19ddf72e1a0261a89db444fbe7d6221f7.
- Complete seeds, party columns, nonces and derived material.
- FT1536 f/g/F/G contributions, shares, encoded keys and aggregate trapdoor.
- Threshold identities, x coordinates, k and share-consistency invariants.
- NTRU relation, F bounds, ring arithmetic, sampler distribution and signature integrity.
- Triples, MAC/delta state, PRSS seeds/counters/masks and opened control values.
- CLI workdir artifacts and secret-bearing process memory.

### Trust Boundaries

- Library caller -\> public cryptographic APIs: caller supplies messages, raw shares, coordinates, thresholds, RNG implementations, sampler parameters, contributions, weights and sometimes `delta_known`; shape checks are component-owned while party identity, RNG quality and lifecycle are often caller obligations (lib.rs:147-185; ishare.rs:493-520,2881-2946).
- Dealer/contributor -\> parties: dealer APIs see clear secret/triple/noise/trapdoor material; this is explicit test/dealer trust, not dealerless generation (lib.rs:170-185,477-500; pedersen.rs:118-141; ishare.rs:847-903,2175-2187,2688-2701).
- Participant contributions -\> aggregate DKG: one in-process caller receives all clear `PartyTrapdoorContribution` objects and RNGs; VSS binds configured coefficients after that boundary, while the aggregate NTRU relation is a separate offline check (ishare.rs:2798-3098,3101-3164).
- Party process -\> shared filesystem mailbox: all child roles use one caller-selected workdir; filenames and orchestration convention, not in-scope ACLs or authenticated IPC, enforce conceptual ownership (bin/iso.rs:81-168,287-467,495-680,940-1264).
- Coordinator/oracle -\> parties: the `dkg`/`dkg5` parents persist child stdout and reconstruct the full demo seed; these are explicit oracle moments but occur in runnable commands (bin/iso.rs:601-680,1030-1107).
- MAC-protected openings -\> participant: hidden-delta openers algebraically detect uncorrelated changes, but G2 stores `delta_known`, recomputes linear tags after multiplication and documents that it is not malicious-secure (ishare.rs:1610-1921,2671-2686,3174-3302).
- Pedersen VSS -\> public observer: byte VSS publishes curve commitments but uses byte-sized blinds; Z_P VSS is a distinct larger-domain construction. G2 defaults to only eight committed coefficients (pedersen.rs:39-163,241-365; ishare.rs:2175-2305,2688-2725).
- PRSS/restart boundary: single mode multiplexes virtual parties through one RNG; pairwise-labelled modes centrally hold an RNG slice and use modulo indexing. Pair seeds use prototype FNV-derived material and counters reset to zero without persistent session binding (prss.rs:16-130,265-315; ishare.rs:478-621,950-984).
- Sampler transcript boundary: clear/naive/fixed-window paths reveal attempts or indices; share-select paths create clear candidate/acceptance windows in the coordinator before resharing and open final x/found (rejection.rs:38-135; select.rs:211-238,1148-1308).
- Share-native SHAKE boundary: the permutation operates on raw `Vec<u8>` share rows and checks dimensions but not share authentication, redundant consistency or Boolean bitness (shake.rs:128-148,343-428,478-512).
- FT1536 engine boundary: ceremonies call external `ft1536_sys` key generation/parsing/sign/verify; its internals and destruction guarantees are outside the authorized source (lib.rs:2682-2759; mpc_sign.rs:901-919).
- Memory lifecycle boundary: several byte/MAC/Pedersen types zeroize, while copied seed arrays, raw share vectors and some Q/Z_P/contribution types lack uniform non-Clone/non-Debug zeroizing ownership (lib.rs:120-133,775-808,2729-2744; mpc_sign.rs:15-20; ishare.rs:36-41,2798-2809).
- CLI argv and caller-selected paths enter privileged local workflows (bin/iso.rs:40-104).
- Dealer/party/worker demos share one directory; atomic rename/timeouts do not authenticate participants (bin/iso.rs:285-415).
- In-process DKG receives every clear contribution/RNG and returns every aggregate column (ishare.rs:2796-3098).
- NTRU validation is separately callable and not type-bound to signing (ishare.rs:3101-3189).
- G2 state combines delta shares with public delta_known and re-derived MACs (ishare.rs:1713-1921,2671-2686).
- PRSS-lite centralizes RNGs/nonces, uses FNV-like derivation and resets counters on construction (prss.rs:16-74,97-131,291-315).
- Clear seed/sk ceremonies reconstruct a complete secret before calling out-of-scope ft1536_sys (lib.rs:2720-2759; mpc_sign.rs:901-920).
- Sampler coordinators sometimes compute acceptance in clear before sharing labels (select.rs:680-698,1148-1290).
- Z_P VSS bridges raw u128, Ristretto Scalar and modulo-P values under caller-sensitive bounds (pedersen.rs:225-367).

### Attacker Capabilities

- A malicious participant controls its own contribution, share, MAC share, randomness and timing but is not assumed to know honest-party memory, honest pair seeds or a genuinely hidden global MAC key.
- A lower-trust library caller can provide malformed dimensions, raw share rows, extreme integers, sampler parameters and an arbitrary `RngCore`; public-library reachability does not imply a network deployment.
- A local process/user able to invoke `iso` can choose workdir/file arguments. A peer with OS-authorized read/write access to that shared directory can inspect or replace artifacts; no remote access is assumed.
- A coordinator holding all contribution objects/RNGs/share columns already has broader authority than one participant; the model treats using that process as the participant boundary as the relevant failure, not as an external privilege escalation.
- A source reader can read literals in the snapshot, but no public-repository exposure, live credential validity or external service privilege is assumed.
- No unauthenticated web attacker, multi-tenant adversary, production GhostDB attacker or compromised release system is inferred because those surfaces are absent.
- One malicious participant controls its own contribution/share/RNG/restart/messages, not honest private state.
- A public-library caller controls arrays, parameters, encoded inputs, RNG implementations and optional modes; remote exposure is unknown.
- A local workdir reader/writer can observe or replace artifacts if host permissions allow.
- Operator-only oracle/test behavior does not itself cross a new privilege boundary.
- No attacker is assumed to control the OS, all parties, external dependencies or the external signing engine.

### Security Objectives

- No one participant or lower-trust coordinator receives the complete seed/trapdoor, all contributions, a threshold of private shares, or all pairwise randomness except at explicitly accepted ceremony/dealer moments.
- Authenticate and session-bind participants, contributions, filesystem messages, share matrices, expected public keys, commitments and openings before sensitive use.
- Keep DKG share generation distinct from proof of the aggregate NTRU relation; require the full Z_P relation check before treating a trapdoor as signing-authoritative.
- Use full-entropy Pedersen blinds and verify every coefficient whose integrity/confidentiality is relied on; sampled VSS coverage must not be represented as complete.
- Keep the global MAC key unknown to the attacker being detected, authenticate triples/results before use, and test correlated rather than only independent tampering.
- Use independent cryptographic randomness per real participant, bind PRSS seeds/counters to unique sessions, and prevent restart/replay reuse.
- Ensure sampler proposals and acceptance are distribution-correct, transcript-safe and fail closed on exhaustion.
- Validate share consistency and Boolean bitness before share-native Keccak/SHAKE; raw vector shape is insufficient.
- Preserve FT1536-specific N=1536, q=18433, X^1536-X^768+1, ternary-secret and encoding conventions rather than importing standard-Falcon assumptions.
- Return bounded errors for malformed public input rather than panicking, overflowing, indexing out of bounds or allocating without validated limits.
- Zeroize the actual secret-bearing allocation on success and every error path; avoid Clone/Copy/Debug/log persistence for secret state.
- Maintain the exact snapshot pin and stop rather than combine evidence across changed bytes.
- Preserve participant separation and keep complete trapdoors out of lower-trust coordinators.
- Bind identities, threshold, session, contributions, aggregate, NTRU result, message and signature.
- Use independent, cryptographic, domain-separated, restart-safe randomness and single-use preprocessing.
- Verify VSS, bounds and NTRU validity before signing.
- Keep global MAC delta hidden and authenticate triples/values before mutation.
- Match intended FT1536 arithmetic and sampling rather than stand-ins.
- Fail closed on malformed lengths, overflow, undersized product quorums and rejection exhaustion.
- Zeroize all secret representations and avoid Copy/Debug/Clone/logging for keys and shares.

### Assumptions

- User context: this is a research prototype, not a completed secure threshold implementation; 400/400 tests are not security proof.
- The authorized source is exactly the 14 pinned Rust files; dependencies and wider repositories are excluded except configuration/boundary context.
- No inherited SECURITY.md guidance or authoritative knowledge base was returned/supplied.
- The source explicitly labels many paths trusted-dealer, semi-honest, oracle, synthetic, PRSS-lite, sampled-VSS or retained/test-only; those limitations are preserved rather than reported automatically as vulnerabilities.
- Seed and secret-key ceremonies intentionally reconstruct full secrets in one process; they are not full MPC signing.
- Weighted DKG plus separate full Z_P NTRU checking is the documented composition. Absence of typestate is retained as hardening/contract risk where no attacker gain beyond abort was established.
- G2 `delta_known`, post-hoc MACs and eight-coefficient VSS are explicit research limitations. Correlated forgery is mechanically possible, but no valid fixed-key signature forgery or confidentiality gain was proved.
- Pairwise PRSS uses a custom non-production FNV construction, central virtual-party state and restart counters beginning at zero; no CDI/production secrecy claim is accepted.
- Share-native sampler windows create clear transcripts in their coordinator; this is a documented model limitation, while modulo bias and success-after-rejection exhaustion are separate observed defects.
- The external FT1536 engine's key parsing, verification and zeroization behavior remains unreviewed because it is outside scope.
- Static review did not execute binaries, tests, ceremonies or target code. All runtime consequences are source-trace conclusions.
- The final inventory recheck matched 14 files, 722342 bytes and digest 67a6474900bdc7d42f853cb5945f0bc19ddf72e1a0261a89db444fbe7d6221f7.
- Exact scope is the pinned 14-file, 722342-byte snapshot; digest 67a6474900bdc7d42f853cb5945f0bc19ddf72e1a0261a89db444fbe7d6221f7.
- No SECURITY.md guidance or knowledge base was returned.
- This is explicitly an incomplete FT1536 research prototype; 400/400 tests are not proof.
- Most party APIs are in-process simulations, not OS isolation.
- CLI DKG contribution disclosure and seed reconstruction are explicit oracle/test moments.
- Weighted DKG requires a separate NTRU check; known-delta MAC and partial VSS paths are retained models.
- PRSS-lite, deterministic Babai, simplified samplers, G_frag/XOF/NTT and synthetic signature paths carry explicit stand-in disclaimers.
- External ft1536_sys key lifecycle is out of scope.
- Full source coverage does not imply full security or a malicious-security proof.

## Findings

| Findings | Reports | Severity | Confidence | Detailed write-up |
| --- | --- | --- | --- | --- |
| Shamir multiplication accepts quorums too small for the product degree | [occ_1d762ae1e4dfe22398e8e7f2](#finding-1) | medium | high | occ_1d762ae1e4dfe22398e8e7f2: inline below |
| Authenticated multiplication accepts an unchecked Beaver `c` share | [occ_26f2f194bfd8436ce4fd0fbc](#finding-2) | medium | high | occ_26f2f194bfd8436ce4fd0fbc: inline below |
| Signing accepts unchecked DKG state and the optional NTRU validation is unauthenticated | [occ_2c5f4e1ae7379cb124b142a9](#finding-3) | medium | high | occ_2c5f4e1ae7379cb124b142a9: inline below |
| Same-width masks leak secret-dependent differences across repeated MPC openings | [occ_48ebb159fe848dfe6b7bf4a4](#finding-4) | medium | high | occ_48ebb159fe848dfe6b7bf4a4: inline below |
| Deterministic signing paths replace randomized lattice sampling and expose trapdoor-dependent outputs | [occ_5c95303dd7651ba286e674f4](#finding-5) | medium | high | occ_5c95303dd7651ba286e674f4: inline below |
| Byte-sized Pedersen blinding lets observers recover committed secret bytes | [byte-coefficient-vss](#finding-6) | medium | high | byte-coefficient-vss: inline below |
| G2 signing consumes trapdoor shares without enforcing their VSS commitments | [occ_6316865a92bfb5ee02499ff7](#finding-7) | medium | high | occ_6316865a92bfb5ee02499ff7: inline below |
| Centralized DKG and PRSS helpers expose every party's trapdoor inputs and randomness | [occ_726952cc3b3d417108a33a97](#finding-8) | medium | high | occ_726952cc3b3d417108a33a97: inline below |
| Exposed G2 MAC key and post-hoc product tags permit correlated forgeries | [occ_943b2452fd1f42039f76ff76](#finding-9) | medium | high | occ_943b2452fd1f42039f76ff76: inline below |
| Shared `iso` work directory collapses participant isolation and exposes quorum material | [occ_ebb7222c6faa1241a3a250a4](#finding-10) | medium | high | occ_ebb7222c6faa1241a3a250a4: inline below |
| Seed, reconstructed secret-key, and trapdoor material remains copyable and incompletely zeroized | [seed-copy](#finding-11) | low | high | seed-copy: inline below |
| Seed ceremony signs from unverified share rows without an expected-key binding | [seed-matrix](#finding-12) | low | high | seed-matrix: inline below |
| Share-native SHAKE accepts inconsistent and non-Boolean input shares | [shake256](#finding-13) | low | high | shake256: inline below |
| Malformed public cryptographic inputs can panic, abort, or overflow into invalid VSS state | [arithmetic-encoding](#finding-14) | low | high | arithmetic-encoding: inline below |
| Filename-only mailbox accepts replaced or replayed ceremony artifacts | [iso-protocol-artifacts](#finding-15) | low | high | iso-protocol-artifacts: inline below |
| Gaussian sampler biases proposals and returns rejected candidates as successful samples | [q16-q73](#finding-16) | low | high | q16-q73: inline below |

### Confidence Scale

| Label | Meaning |
| --- | --- |
| high | Direct evidence supports the finding with no material unresolved blocker. |
| medium | Evidence supports a plausible issue, but material runtime or reachability proof remains. |
| low | Evidence is incomplete and the item is retained only for explicit follow-up. |

<a id="finding-1"></a>

### [1] Shamir multiplication accepts quorums too small for the product degree

| Field | Value |
| --- | --- |
| Severity | medium |
| Confidence | high |
| Confidence rationale | The degree bound and missing n\>=2k-1 guard are directly established by source and algebra. |
| Category | Incorrect threshold arithmetic validation |
| CWE | CWE-682 |
| Affected lines | lib.rs:147, mul.rs:45, ishare.rs:142, ishare.rs:273, mpc_sign.rs:126 |

#### Summary

`mul_shamir_reshare()` and its Z_P/Z_q analogues accept `n >= k`, then interpolate pointwise products whose polynomial degree can be `2(k-1)`. With `k <= n < 2k-1`, the accepted quorum generally reconstructs the wrong product without an error.

#### Root Cause

The multiplication uses interpolation of pointwise products without enforcing the product polynomial's doubled degree. The quorum validator checks the input sharing threshold, not the minimum points required by this multiplication construction.

**Validation accepts only k points** — `ishare.rs:142-161`

The shared guard accepts every quorum with `n >= k`; it does not require enough points for a degree-`2(k-1)` product.

```rust
fn check_xs_p(xs: &[u16], k: u8) -> Result<usize> {
    if k < 2 {
        return Err(SpikeError::ThresholdTooLow);
    }
    if xs.is_empty() {
        return Err(SpikeError::EmptyXs);
    }
    if xs.len() < k as usize {
        return Err(SpikeError::NotEnoughPoints);
    }
    // ... distinct nonzero x checks ...
    Ok(xs.len())
}
```

**Pointwise products are interpolated with all n weights** — `mul.rs:66-74`

`u_i` evaluates the product polynomial at each point and Lagrange-weights it as though n points uniquely determined that product; this fails generally when `n < 2k-1`.

```rust
let mut c_shares = vec![0u8; n];
for i in 0..n {
    let u_i = local_weighted_product(xs, i, a_shares[i], b_shares[i])?;
    let dealt = shamir_share(rng, u_i, xs, k)?;
    for (j, sh) in dealt.into_iter().enumerate() {
        c_shares[j] ^= sh.share;
    }
}
Ok(c_shares)
```

#### Validation

Two degree-`k-1` Shamir polynomials multiply to degree at most `2(k-1)`, requiring at least `2k-1` evaluations for this direct interpolation. The source accepts fewer and has no alternate degree-reduction step.

Validation method: static algebraic validation

**Validation accepts only k points** — `ishare.rs:142-161`

The shared guard accepts every quorum with `n >= k`; it does not require enough points for a degree-`2(k-1)` product.

```rust
fn check_xs_p(xs: &[u16], k: u8) -> Result<usize> {
    if k < 2 {
        return Err(SpikeError::ThresholdTooLow);
    }
    if xs.is_empty() {
        return Err(SpikeError::EmptyXs);
    }
    if xs.len() < k as usize {
        return Err(SpikeError::NotEnoughPoints);
    }
    // ... distinct nonzero x checks ...
    Ok(xs.len())
}
```

**Pointwise products are interpolated with all n weights** — `mul.rs:66-74`

`u_i` evaluates the product polynomial at each point and Lagrange-weights it as though n points uniquely determined that product; this fails generally when `n < 2k-1`.

```rust
let mut c_shares = vec![0u8; n];
for i in 0..n {
    let u_i = local_weighted_product(xs, i, a_shares[i], b_shares[i])?;
    let dealt = shamir_share(rng, u_i, xs, k)?;
    for (j, sh) in dealt.into_iter().enumerate() {
        c_shares[j] ^= sh.share;
    }
}
Ok(c_shares)
```

Assertions:
- Tested 2-of-3 and 3-of-5 configurations satisfy the bound.
- k-of-k and k-of-(2k-2) inputs are accepted but generally wrong.

Limitations:
- No runtime counterexample was executed because the user prohibited tests.

#### Dataflow

reduced active xs -\> n\>=k guard -\> pointwise products -\> underdetermined interpolation -\> corrupted derived/signing value

- **Source:** active-party quorum after dropout

- **Sink:** shared multiplication output

- **Outcome:** silent arithmetic corruption

**Validation accepts only k points** — `ishare.rs:142-161`

The shared guard accepts every quorum with `n >= k`; it does not require enough points for a degree-`2(k-1)` product.

```rust
fn check_xs_p(xs: &[u16], k: u8) -> Result<usize> {
    if k < 2 {
        return Err(SpikeError::ThresholdTooLow);
    }
    if xs.is_empty() {
        return Err(SpikeError::EmptyXs);
    }
    if xs.len() < k as usize {
        return Err(SpikeError::NotEnoughPoints);
    }
    // ... distinct nonzero x checks ...
    Ok(xs.len())
}
```

**Pointwise products are interpolated with all n weights** — `mul.rs:66-74`

`u_i` evaluates the product polynomial at each point and Lagrange-weights it as though n points uniquely determined that product; this fails generally when `n < 2k-1`.

```rust
let mut c_shares = vec![0u8; n];
for i in 0..n {
    let u_i = local_weighted_product(xs, i, a_shares[i], b_shares[i])?;
    let dealt = shamir_share(rng, u_i, xs, k)?;
    for (j, sh) in dealt.into_iter().enumerate() {
        c_shares[j] ^= sh.share;
    }
}
Ok(c_shares)
```

#### Reachability

Requires an integration that dynamically invokes these routines with an accepted but undersized active quorum.

- **Attacker:** participant able to cause dropout or caller selecting an undersized quorum

- **Entry point:** mul_shamir_reshare and Z_P/Z_q analogues

- **Outcome:** invalid derived material or signatures

#### Severity

**Medium** — A participant-induced dropout can silently corrupt signing/key arithmetic; the tested 2-of-3 and 3-of-5 configurations are safe, so impact requires an unsupported quorum that the API nevertheless accepts.

Raise if deployed signing dynamically continues with k through 2k-2 parties; lower if setup enforces n=2k-1 and never permits dropouts.

Impact assessment:
- **Level:** medium
- **Why:** Integrity and availability fail silently in cryptographic arithmetic.

Likelihood assessment:
- **Level:** medium
- **Why:** Dropout handling is plausible, although fixed tested configurations are safe.

#### Remediation

Require at least 2k-1 points for this pointwise-product re-sharing construction or replace it with a correct degree-reduction/authenticated Beaver protocol; reject smaller active quorums before processing.

Tests:
- For k=2,n=2 and k=3,n=3/4, assert a fail-closed error rather than a product.
- For n=2k-1, compare reconstructed results with clear multiplication.

Preventive controls:
- Encode the supported n/k relation in setup state.
- Use authenticated Beaver/BGW degree reduction when k-point availability is required.

<a id="finding-2"></a>

### [2] Authenticated multiplication accepts an unchecked Beaver `c` share

| Field | Value |
| --- | --- |
| Severity | medium |
| Confidence | high |
| Confidence rationale | Direct dataflow shows c.mac is unused, c.share enters z, and the output MAC is recomputed. |
| Category | Missing cryptographic integrity check for Beaver triples |
| CWE | CWE-345 |
| Affected lines | ishare.rs:1722-1729, ishare.rs:1828-1845, ishare.rs:1848-1857, ishare.rs:1860-1872, ishare.rs:1878-1904, ishare.rs:1722, ishare.rs:1818, ishare.rs:1848, ishare.rs:1860, lib.rs:1656 |

#### Summary

`mul_auth_zp_with_triple()` authenticates only the opened `x-a` and `y-b` differences, then inserts `triple.c[i].share` without checking `c.mac` or proving `c=a*b`. A malicious preprocessing provider can offset `c`, and the function creates a fresh matching output MAC, so downstream opens accept the corrupted product.

#### Root Cause

The Beaver multiplication trusts `c.share` while discarding its supplied MAC and omits a sacrifice or other proof that `c=a*b`; post-hoc authentication cannot recover that lost invariant.

**Triple includes an authenticated c** — `ishare.rs:1722-1729`

The type carries `c.mac`, so the intended control exists in the input representation.

```rust
pub struct ZpAuthTriple {
    pub a: Vec<ZpMacShare>,
    pub b: Vec<ZpMacShare>,
    pub c: Vec<ZpMacShare>,
}
```

**Only a and b feed authenticated openings** — `ishare.rs:1848-1857`

No analogous validation reads `triple.c[i].mac` or proves the multiplication relation.

```rust
let eps_val: Vec<u64> = x.iter().zip(&triple.a).map(|(s, t)| p_sub(*s, t.share)).collect();
let eps_mac: Vec<u64> = x_mac.iter().zip(&triple.a).map(|(m, t)| p_sub(*m, t.mac)).collect();
let rho_val: Vec<u64> = y.iter().zip(&triple.b).map(|(s, t)| p_sub(*s, t.share)).collect();
let rho_mac: Vec<u64> = y_mac.iter().zip(&triple.b).map(|(m, t)| p_sub(*m, t.mac)).collect();
let eps = zp_open_with_mac_known_delta(xs, &eps_val, &eps_mac, dk)?;
let rho = zp_open_with_mac_known_delta(xs, &rho_val, &rho_mac, dk)?;
```

**Unchecked c enters result and gets a new MAC** — `ishare.rs:1860-1872`

An offset in `c.share` transfers directly into z, and a matching MAC is manufactured after the corruption.

```rust
let mut z = vec![0u64; n];
for i in 0..n {
    let t = p_add(triple.c[i].share, p_mul(eps_p, triple.b[i].share));
    let t = p_add(t, p_mul(rho_p, triple.a[i].share));
    z[i] = p_add(t, eps_rho);
}
let z_mac = zp_mac_linearity(&z, dk);
Ok((z, z_mac))
```

**Triple c carries a MAC** — `ishare.rs:1725-1730`

The supplied triple represents c with both value and authentication shares.

```rust
pub struct ZpAuthTriple {
    pub a: Vec<ZpMacShare>,
    pub b: Vec<ZpMacShare>,
    pub c: Vec<ZpMacShare>,
}
```

**c share affects output but c MAC is ignored** — `ishare.rs:1860-1872`

A corrupted `c.share` is incorporated into z; `c.mac` is never read, and the function authenticates the already-corrupted z with a fresh known-delta MAC.

```rust
let mut z = vec![0u64; n];
for i in 0..n {
    let t = p_add(triple.c[i].share, p_mul(eps_p, triple.b[i].share));
    let t = p_add(t, p_mul(rho_p, triple.a[i].share));
    z[i] = p_add(t, eps_rho);
}
let z_mac = zp_mac_linearity(&z, dk);
Ok((z, z_mac))
```

#### Validation

The product dataflow confirms that `c.share` affects the result while `c.mac` is never read, no `c=a*b` relation or sacrifice is enforced, and a fresh output MAC authenticates the resulting value. Honest immediate generation is counterevidence for current tests, not for the public supplied-triple boundary.

Validation method: static source trace and use check; static dataflow and use analysis

- **Status:** validated

**Triple includes an authenticated c** — `ishare.rs:1722-1729`

The type carries `c.mac`, so the intended control exists in the input representation.

```rust
pub struct ZpAuthTriple {
    pub a: Vec<ZpMacShare>,
    pub b: Vec<ZpMacShare>,
    pub c: Vec<ZpMacShare>,
}
```

**Only a and b feed authenticated openings** — `ishare.rs:1848-1857`

No analogous validation reads `triple.c[i].mac` or proves the multiplication relation.

```rust
let eps_val: Vec<u64> = x.iter().zip(&triple.a).map(|(s, t)| p_sub(*s, t.share)).collect();
let eps_mac: Vec<u64> = x_mac.iter().zip(&triple.a).map(|(m, t)| p_sub(*m, t.mac)).collect();
let rho_val: Vec<u64> = y.iter().zip(&triple.b).map(|(s, t)| p_sub(*s, t.share)).collect();
let rho_mac: Vec<u64> = y_mac.iter().zip(&triple.b).map(|(m, t)| p_sub(*m, t.mac)).collect();
let eps = zp_open_with_mac_known_delta(xs, &eps_val, &eps_mac, dk)?;
let rho = zp_open_with_mac_known_delta(xs, &rho_val, &rho_mac, dk)?;
```

**Unchecked c enters result and gets a new MAC** — `ishare.rs:1860-1872`

An offset in `c.share` transfers directly into z, and a matching MAC is manufactured after the corruption.

```rust
let mut z = vec![0u64; n];
for i in 0..n {
    let t = p_add(triple.c[i].share, p_mul(eps_p, triple.b[i].share));
    let t = p_add(t, p_mul(rho_p, triple.a[i].share));
    z[i] = p_add(t, eps_rho);
}
let z_mac = zp_mac_linearity(&z, dk);
Ok((z, z_mac))
```

**Triple c carries a MAC** — `ishare.rs:1725-1730`

The supplied triple represents c with both value and authentication shares.

```rust
pub struct ZpAuthTriple {
    pub a: Vec<ZpMacShare>,
    pub b: Vec<ZpMacShare>,
    pub c: Vec<ZpMacShare>,
}
```

**c share affects output but c MAC is ignored** — `ishare.rs:1860-1872`

A corrupted `c.share` is incorporated into z; `c.mac` is never read, and the function authenticates the already-corrupted z with a fresh known-delta MAC.

```rust
let mut z = vec![0u64; n];
for i in 0..n {
    let t = p_add(triple.c[i].share, p_mul(eps_p, triple.b[i].share));
    let t = p_add(t, p_mul(rho_p, triple.a[i].share));
    z[i] = p_add(t, eps_rho);
}
let z_mac = zp_mac_linearity(&z, dk);
Ok((z, z_mac))
```

Assertions:
- Changing c.share changes z.
- Fresh z_mac then matches the wrong z.

Counterevidence and remaining uncertainty:
- `i_poly_mul_ring_shares_auth` internally calls `generate_auth_triple_zp`, so that centralized path receives honest triples.
- The public primitive and any future distributed preprocessing boundary remain unprotected.

Limitations:
- No external preprocessing provider is implemented in scope.
- A malicious preprocessing boundary is required; immediate trusted generation is not vulnerable to external c tampering.

#### Dataflow

attacker-controlled triple.c.share -\> Beaver z formula -\> fresh z_mac -\> accepted downstream opening

- **Source:** caller-supplied ZpAuthTriple

- **Sink:** returned authenticated product

- **Outcome:** undetected arithmetic/signature corruption

**Triple c carries a MAC** — `ishare.rs:1725-1730`

The supplied triple represents c with both value and authentication shares.

```rust
pub struct ZpAuthTriple {
    pub a: Vec<ZpMacShare>,
    pub b: Vec<ZpMacShare>,
    pub c: Vec<ZpMacShare>,
}
```

**c share affects output but c MAC is ignored** — `ishare.rs:1860-1872`

A corrupted `c.share` is incorporated into z; `c.mac` is never read, and the function authenticates the already-corrupted z with a fresh known-delta MAC.

```rust
let mut z = vec![0u64; n];
for i in 0..n {
    let t = p_add(triple.c[i].share, p_mul(eps_p, triple.b[i].share));
    let t = p_add(t, p_mul(rho_p, triple.a[i].share));
    z[i] = p_add(t, eps_rho);
}
let z_mac = zp_mac_linearity(&z, dk);
Ok((z, z_mac))
```

**Triple includes an authenticated c** — `ishare.rs:1722-1729`

The type carries `c.mac`, so the intended control exists in the input representation.

```rust
pub struct ZpAuthTriple {
    pub a: Vec<ZpMacShare>,
    pub b: Vec<ZpMacShare>,
    pub c: Vec<ZpMacShare>,
}
```

**Unchecked c enters result and gets a new MAC** — `ishare.rs:1860-1872`

An offset in `c.share` transfers directly into z, and a matching MAC is manufactured after the corruption.

```rust
let mut z = vec![0u64; n];
for i in 0..n {
    let t = p_add(triple.c[i].share, p_mul(eps_p, triple.b[i].share));
    let t = p_add(t, p_mul(rho_p, triple.a[i].share));
    z[i] = p_add(t, eps_rho);
}
let z_mac = zp_mac_linearity(&z, dk);
Ok((z, z_mac))
```

#### Reachability

Requires control of a triple share supplied to the public primitive.

- **Attacker:** malicious participant or preprocessing provider

- **Entry point:** mul_auth_zp_with_triple

- **Outcome:** chosen offset in product

#### Severity

**Medium** — An attacker controlling preprocessing can corrupt signing arithmetic, but the in-scope wrapper generates honest triples centrally and no external preprocessing deployment is established.

Raise to high if triples cross a mutually distrustful preprocessing boundary in production; lower if the public primitive is made unreachable and triples are trusted by construction.

#### Remediation

Authenticate and sacrifice/batch-check triples before use, prove `c=a*b`, and propagate `c`'s existing MAC through the Beaver formula rather than recreating authentication after untrusted arithmetic.

Tests:
- Modify only one `c.share` and require abort.
- Modify `c.share` plus a correlated `c.mac` and require the sacrifice check to fail.
- Assert the multiplication implementation reads and combines `c.mac`.
- Change only `triple.c[party].share` and require MacFail before a result is returned.
- Supply a relation-invalid but internally tagged triple and require sacrifice failure.

Preventive controls:
- Opaque validated-triple type produced only by a consuming verification step.
- Transcript-bound random sacrifice challenges.
- Use an opaque verified-triple type.
- Propagate c's pre-existing MAC algebraically rather than reminting an output tag.

<a id="finding-3"></a>

### [3] Signing accepts unchecked DKG state and the optional NTRU validation is unauthenticated

| Field | Value |
| --- | --- |
| Severity | medium |
| Confidence | high |
| Confidence rationale | The DKG return, separate checker, and signer signature directly establish bypassable sequencing. |
| Category | Missing mandatory cryptographic state validation |
| CWE | CWE-345 |
| Affected lines | ishare.rs:3053-3098, ishare.rs:3123-3163, ishare.rs:3174-3185, ishare.rs:2881-2898, ishare.rs:3153-3163, ishare.rs:3174-3189, ishare.rs:3079-3098, ishare.rs:3123-3136, ishare.rs:3174-3183, ishare.rs:2881, ishare.rs:3079, ishare.rs:3153, ishare.rs:3174, ishare.rs:6480, ishare.rs:2881-2898, ishare.rs:3139-3164, ishare.rs:3174-3190, ishare.rs:3071-3098, ishare.rs:3174-3190, ishare.rs:6470-6507, proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:3053-3099 |

#### Summary

Weighted contribution DKG returns an ordinary signing-capable `G2Trapdoor` before enforcing `fG-gF=q`, and `mps4h_sign_shares_g2()` accepts that unchecked type directly. The detached boolean checker is caller-optional and uses semi-honest resharing plus an unauthenticated reconstructed delta, so a malicious setup participant can supply invalid state, bypass validation by omission, or tamper with its messages. An embedded negative case confirms a bad contribution survives DKG and is rejected only by the separate check.

#### Root Cause

Setup aggregation and signing share one unrestricted `G2Trapdoor` type: the mandatory NTRU relation is neither enforced during DKG nor encoded as an authenticated, transcript-bound capability required by signing.

**DKG accepts attacker-selected contribution polynomials** — `ishare.rs:2881-2898`

A malicious contributor can choose complete polynomial inputs; `vss_count` determines commitment coverage but does not impose the NTRU algebraic relation.

```rust
pub fn dkg_trapdoor_from_weighted_contributions<R: rand::RngCore>(
    rngs: &mut [R],
    contribs: &[PartyTrapdoorContribution],
    weights: &[u64],
    xs: &[u16],
    k: u8,
    delta_known: u64,
    vss_count: usize,
) -> Result<G2Trapdoor> {
    let n = check_xs_p(xs, k)?;
    if contribs.is_empty() || rngs.is_empty() || weights.len() != contribs.len() {
        return Err(SpikeError::PartyCountMismatch);
    }
    let n_vss = if vss_count == 0 { FT1536_N } else { vss_count.min(FT1536_N) };
```

**DKG returns sign-capable state after VSS and bound checks only** — `ishare.rs:3053-3098`

Commitment and range checks succeed for internally consistent but algebraically invalid contributions; the function still returns the ordinary signing state.

```rust
vss_verify_poly_shares(&vss_f, &vss_sh_f, xs)?;
vss_verify_poly_shares(&vss_g, &vss_sh_g, xs)?;
vss_verify_poly_shares(&vss_f_big, &vss_sh_fb, xs)?;
vss_verify_poly_shares(&vss_g_big, &vss_sh_gb, xs)?;
// ... MAC construction ...
validate_f_bound_shares(&mut rngs[0], &fb_acc, xs, k)?;
// ... delta shares ...
Ok(G2Trapdoor {
    td: ITrapdoorShares { f: f_acc, g: g_acc, f_big: fb_acc, g_big: gb_acc },
    // ...
    delta_known: dk,
})
```

**Required NTRU check is a separate optional boolean** — `ishare.rs:3153-3163`

The correct relation is available but returns a detached `bool`; it does not upgrade or bind the `G2Trapdoor` used later.

```rust
pub fn ntru_fg_gf_check_weighted_shares(
    rng: &mut impl rand::RngCore,
    td: &ITrapdoorShares,
    xs: &[u16],
    k: u8,
) -> Result<bool> {
    let d = ntru_fg_gf_open_delta(rng, td, xs, k)?;
    if d.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    Ok(d[0] == FT1536_Q as i64 && d[1..].iter().all(|&c| c == 0))
}
```

**Signing accepts unchecked G2Trapdoor directly** — `ishare.rs:3174-3189`

The sensitive operation repeats only shape and bound checks; it cannot tell whether the separate NTRU boolean was ever evaluated or accepted.

```rust
pub fn mps4h_sign_shares_g2(
    rng: &mut impl rand::RngCore,
    gt: &G2Trapdoor,
    t: &[u16],
    xs: &[u16],
    k: u8,
    bits_tf: u32,
    bits_tf_big: u32,
    gauss_sigma: Option<u8>,
) -> Result<(Vec<i64>, Vec<i64>, SignCost)> {
    if t.len() != FT1536_N { return Err(SpikeError::PartyCountMismatch); }
    check_xs_p(xs, k)?;
    validate_f_bound_shares(rng, &gt.td.f_big, xs, k)?;
```

**Relation check reconstructs unauthenticated result** — `ishare.rs:3123-3136`

The check uses semi-honest multiplication and directly opens the resulting shares without MAC, commitment binding, or commit-before-reveal.

```rust
pub fn ntru_fg_gf_open_delta(
    rng: &mut impl rand::RngCore,
    td: &ITrapdoorShares,
    xs: &[u16],
    k: u8,
) -> Result<Vec<i64>> {
    let fg = i_poly_mul_ring_shares(rng, &td.f, &td.g_big, xs, k)?;
    let gf = i_poly_mul_ring_shares(rng, &td.g, &td.f_big, xs, k)?;
    let diff: IPolyShares = fg.iter().zip(&gf)
        .map(|(a, b)| a.iter().zip(b).map(|(&x, &y)| p_sub(x, y)).collect())
        .collect();
    ireconstruct_poly_i64(&diff, xs)
}
```

**Signer accepts ordinary G2Trapdoor** — `ishare.rs:3174-3183`

No validated-trapdoor capability distinguishes a checked DKG result at the sensitive signing operation.

```rust
pub fn mps4h_sign_shares_g2(
    rng: &mut impl rand::RngCore,
    gt: &G2Trapdoor,
    t: &[u16],
    xs: &[u16],
    k: u8,
    bits_tf: u32,
    bits_tf_big: u32,
    gauss_sigma: Option<u8>,
) -> Result<(Vec<i64>, Vec<i64>, SignCost)> {
```

**DKG returns a normal G2Trapdoor** — `ishare.rs:3071-3079`

After VSS/range work, the constructor transitions directly to a sign-capable `G2Trapdoor` without the NTRU relation check.

```rust
validate_f_bound_shares(&mut rngs[0], &fb_acc, xs, k)?;
let delta = ZpDeltaShares {
    xs: xs.to_vec(),
    shares: ishare_val(&mut rngs[0], dk as i64, xs, k)?,
};
Ok(G2Trapdoor {
```

**Signer accepts G2Trapdoor directly** — `ishare.rs:3174-3189`

The signing entry point has no validated-state token or NTRU check and accepts the same type returned by unchecked DKG.

```rust
pub fn mps4h_sign_shares_g2(
    rng: &mut impl rand::RngCore,
    gt: &G2Trapdoor,
    t: &[u16],
    xs: &[u16],
    k: u8,
    bits_tf: u32,
    bits_tf_big: u32,
    gauss_sigma: Option<u8>,
) -> Result<(Vec<i64>, Vec<i64>, SignCost)> {
    if t.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    check_xs_p(xs, k)?;
```

**DKG returns G2Trapdoor** — `ishare.rs:2881-2898`

The setup API's successful state is the same `G2Trapdoor` type later consumed by signing.

```rust
pub fn dkg_trapdoor_from_weighted_contributions<R: rand::RngCore>(
    rngs: &mut [R],
    contribs: &[PartyTrapdoorContribution],
    weights: &[u64],
    xs: &[u16],
    k: u8,
    delta_known: u64,
    vss_count: usize,
) -> Result<G2Trapdoor> {
```

**Return path omits NTRU check** — `ishare.rs:3053-3098`

VSS and F-bound controls run, but the return is not conditioned on the full NTRU relation.

```rust
vss_verify_poly_shares(&vss_f, &vss_sh_f, xs)?;
vss_verify_poly_shares(&vss_g, &vss_sh_g, xs)?;
vss_verify_poly_shares(&vss_f_big, &vss_sh_fb, xs)?;
vss_verify_poly_shares(&vss_g_big, &vss_sh_gb, xs)?;
validate_f_bound_shares(&mut rngs[0], &fb_acc, xs, k)?;
Ok(G2Trapdoor { /* shares, VSS and delta */ })
```

**Signer accepts unchecked G2Trapdoor** — `ishare.rs:3174-3190`

Signing rechecks shape and F bound but cannot tell whether the NTRU checker ran.

```rust
pub fn mps4h_sign_shares_g2(
    rng: &mut impl rand::RngCore,
    gt: &G2Trapdoor,
    t: &[u16],
    xs: &[u16],
    k: u8,
    bits_tf: u32,
    bits_tf_big: u32,
    gauss_sigma: Option<u8>,
) -> Result<(Vec<i64>, Vec<i64>, SignCost)> {
    if t.len() != FT1536_N { return Err(SpikeError::PartyCountMismatch); }
    check_xs_p(xs, k)?;
    validate_f_bound_shares(rng, &gt.td.f_big, xs, k)?;
```

**Required relation check is optional** — `ishare.rs:3153-3164`

The strongest relation control returns a separate boolean and does not produce a validated state type.

```rust
pub fn ntru_fg_gf_check_weighted_shares(
    rng: &mut impl rand::RngCore,
    td: &ITrapdoorShares,
    xs: &[u16],
    k: u8,
) -> Result<bool> {
    let d = ntru_fg_gf_open_delta(rng, td, xs, k)?;
    if d.len() != FT1536_N { return Err(SpikeError::PartyCountMismatch); }
    Ok(d[0] == FT1536_Q as i64 && d[1..].iter().all(|&c| c == 0))
}
```

**DKG returns a signable object after F-bound only** — `ishare.rs:3071-3098`

The DKG operation returns the ordinary signing object without invoking or recording the NTRU relation check.

```rust
validate_f_bound_shares(&mut rngs[0], &fb_acc, xs, k)?;
let delta = ZpDeltaShares {
    xs: xs.to_vec(),
    shares: ishare_val(&mut rngs[0], dk as i64, xs, k)?,
};
Ok(G2Trapdoor {
    td: ITrapdoorShares { f: f_acc, g: g_acc, f_big: fb_acc, g_big: gb_acc },
    // ...
    delta,
    delta_known: dk,
})
```

**Signer accepts raw G2Trapdoor and checks only length, coordinates and F bound** — `ishare.rs:3174-3190`

No checked-state token or in-function relation validation separates unvalidated DKG output from the signing sink.

```rust
pub fn mps4h_sign_shares_g2(
    rng: &mut impl rand::RngCore,
    gt: &G2Trapdoor,
    t: &[u16],
    xs: &[u16],
    k: u8,
    bits_tf: u32,
    bits_tf_big: u32,
    gauss_sigma: Option<u8>,
) -> Result<(Vec<i64>, Vec<i64>, SignCost)> {
    if t.len() != FT1536_N { return Err(SpikeError::PartyCountMismatch); }
    check_xs_p(xs, k)?;
    validate_f_bound_shares(rng, &gt.td.f_big, xs, k)?;
```

**Test confirms bad contribution survives DKG** — `ishare.rs:6480-6507`

The negative test proves the invalid relation does not make DKG fail; rejection occurs only if a caller remembers the separate check.

```rust
gb0[0] = gb0[0].wrapping_add(1);
// ... build contribs ...
let gt = dkg_trapdoor_from_weighted_contributions(
    &mut rngs, &contribs, &[2, 1], &XS, K, DELTA, G2_VSS_SAMPLE,
).unwrap();
let ok = ntru_fg_gf_check_weighted_shares(&mut rngs[0], &gt.td, &XS, K).unwrap();
assert!(!ok, "zepsuty wkład G → fG−gF ≠ q (T10.4)");
```

**Signer accepts the same unchecked type** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:3174-3189`

Signing repeats the F bound but does not call the NTRU relation check or require a validated wrapper.

```rust
pub fn mps4h_sign_shares_g2(
    rng: &mut impl rand::RngCore,
    gt: &G2Trapdoor,
    t: &[u16],
    xs: &[u16],
    k: u8,
    bits_tf: u32,
    bits_tf_big: u32,
    gauss_sigma: Option<u8>,
) -> Result<(Vec<i64>, Vec<i64>, SignCost)> {
    if t.len() != FT1536_N { return Err(SpikeError::PartyCountMismatch); }
    check_xs_p(xs, k)?;
    validate_f_bound_shares(rng, &gt.td.f_big, xs, k)?;
```

**NTRU validation is a separate boolean call** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:3153-3164`

The check neither consumes nor upgrades the trapdoor and returning `false` does not invalidate the existing object.

```rust
pub fn ntru_fg_gf_check_weighted_shares(
    rng: &mut impl rand::RngCore,
    td: &ITrapdoorShares,
    xs: &[u16],
    k: u8,
) -> Result<bool> {
    let d = ntru_fg_gf_open_delta(rng, td, xs, k)?;
    if d.len() != FT1536_N { return Err(SpikeError::PartyCountMismatch); }
    Ok(d[0] == FT1536_Q as i64 && d[1..].iter().all(|&c| c == 0))
}
```

#### Validation

The DKG result can be passed directly to the public signer because successful NTRU validation produces no distinct state or type. The detached boolean check is both caller-optional and unauthenticated; documentation of the intended order and the independent F-bound check do not enforce the transition.

Validation method: static state-transition and call-graph review; static state-transition trace; static type and call-boundary trace

- **Status:** validated

**DKG accepts attacker-selected contribution polynomials** — `ishare.rs:2881-2898`

A malicious contributor can choose complete polynomial inputs; `vss_count` determines commitment coverage but does not impose the NTRU algebraic relation.

```rust
pub fn dkg_trapdoor_from_weighted_contributions<R: rand::RngCore>(
    rngs: &mut [R],
    contribs: &[PartyTrapdoorContribution],
    weights: &[u64],
    xs: &[u16],
    k: u8,
    delta_known: u64,
    vss_count: usize,
) -> Result<G2Trapdoor> {
    let n = check_xs_p(xs, k)?;
    if contribs.is_empty() || rngs.is_empty() || weights.len() != contribs.len() {
        return Err(SpikeError::PartyCountMismatch);
    }
    let n_vss = if vss_count == 0 { FT1536_N } else { vss_count.min(FT1536_N) };
```

**DKG returns sign-capable state after VSS and bound checks only** — `ishare.rs:3053-3098`

Commitment and range checks succeed for internally consistent but algebraically invalid contributions; the function still returns the ordinary signing state.

```rust
vss_verify_poly_shares(&vss_f, &vss_sh_f, xs)?;
vss_verify_poly_shares(&vss_g, &vss_sh_g, xs)?;
vss_verify_poly_shares(&vss_f_big, &vss_sh_fb, xs)?;
vss_verify_poly_shares(&vss_g_big, &vss_sh_gb, xs)?;
// ... MAC construction ...
validate_f_bound_shares(&mut rngs[0], &fb_acc, xs, k)?;
// ... delta shares ...
Ok(G2Trapdoor {
    td: ITrapdoorShares { f: f_acc, g: g_acc, f_big: fb_acc, g_big: gb_acc },
    // ...
    delta_known: dk,
})
```

**Required NTRU check is a separate optional boolean** — `ishare.rs:3153-3163`

The correct relation is available but returns a detached `bool`; it does not upgrade or bind the `G2Trapdoor` used later.

```rust
pub fn ntru_fg_gf_check_weighted_shares(
    rng: &mut impl rand::RngCore,
    td: &ITrapdoorShares,
    xs: &[u16],
    k: u8,
) -> Result<bool> {
    let d = ntru_fg_gf_open_delta(rng, td, xs, k)?;
    if d.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    Ok(d[0] == FT1536_Q as i64 && d[1..].iter().all(|&c| c == 0))
}
```

**Signing accepts unchecked G2Trapdoor directly** — `ishare.rs:3174-3189`

The sensitive operation repeats only shape and bound checks; it cannot tell whether the separate NTRU boolean was ever evaluated or accepted.

```rust
pub fn mps4h_sign_shares_g2(
    rng: &mut impl rand::RngCore,
    gt: &G2Trapdoor,
    t: &[u16],
    xs: &[u16],
    k: u8,
    bits_tf: u32,
    bits_tf_big: u32,
    gauss_sigma: Option<u8>,
) -> Result<(Vec<i64>, Vec<i64>, SignCost)> {
    if t.len() != FT1536_N { return Err(SpikeError::PartyCountMismatch); }
    check_xs_p(xs, k)?;
    validate_f_bound_shares(rng, &gt.td.f_big, xs, k)?;
```

**Relation check reconstructs unauthenticated result** — `ishare.rs:3123-3136`

The check uses semi-honest multiplication and directly opens the resulting shares without MAC, commitment binding, or commit-before-reveal.

```rust
pub fn ntru_fg_gf_open_delta(
    rng: &mut impl rand::RngCore,
    td: &ITrapdoorShares,
    xs: &[u16],
    k: u8,
) -> Result<Vec<i64>> {
    let fg = i_poly_mul_ring_shares(rng, &td.f, &td.g_big, xs, k)?;
    let gf = i_poly_mul_ring_shares(rng, &td.g, &td.f_big, xs, k)?;
    let diff: IPolyShares = fg.iter().zip(&gf)
        .map(|(a, b)| a.iter().zip(b).map(|(&x, &y)| p_sub(x, y)).collect())
        .collect();
    ireconstruct_poly_i64(&diff, xs)
}
```

**Signer accepts ordinary G2Trapdoor** — `ishare.rs:3174-3183`

No validated-trapdoor capability distinguishes a checked DKG result at the sensitive signing operation.

```rust
pub fn mps4h_sign_shares_g2(
    rng: &mut impl rand::RngCore,
    gt: &G2Trapdoor,
    t: &[u16],
    xs: &[u16],
    k: u8,
    bits_tf: u32,
    bits_tf_big: u32,
    gauss_sigma: Option<u8>,
) -> Result<(Vec<i64>, Vec<i64>, SignCost)> {
```

**DKG returns a normal G2Trapdoor** — `ishare.rs:3071-3079`

After VSS/range work, the constructor transitions directly to a sign-capable `G2Trapdoor` without the NTRU relation check.

```rust
validate_f_bound_shares(&mut rngs[0], &fb_acc, xs, k)?;
let delta = ZpDeltaShares {
    xs: xs.to_vec(),
    shares: ishare_val(&mut rngs[0], dk as i64, xs, k)?,
};
Ok(G2Trapdoor {
```

**Signer accepts G2Trapdoor directly** — `ishare.rs:3174-3189`

The signing entry point has no validated-state token or NTRU check and accepts the same type returned by unchecked DKG.

```rust
pub fn mps4h_sign_shares_g2(
    rng: &mut impl rand::RngCore,
    gt: &G2Trapdoor,
    t: &[u16],
    xs: &[u16],
    k: u8,
    bits_tf: u32,
    bits_tf_big: u32,
    gauss_sigma: Option<u8>,
) -> Result<(Vec<i64>, Vec<i64>, SignCost)> {
    if t.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    check_xs_p(xs, k)?;
```

**Return path omits NTRU check** — `ishare.rs:3053-3098`

VSS and F-bound controls run, but the return is not conditioned on the full NTRU relation.

```rust
vss_verify_poly_shares(&vss_f, &vss_sh_f, xs)?;
vss_verify_poly_shares(&vss_g, &vss_sh_g, xs)?;
vss_verify_poly_shares(&vss_f_big, &vss_sh_fb, xs)?;
vss_verify_poly_shares(&vss_g_big, &vss_sh_gb, xs)?;
validate_f_bound_shares(&mut rngs[0], &fb_acc, xs, k)?;
Ok(G2Trapdoor { /* shares, VSS and delta */ })
```

**Required relation check is optional** — `ishare.rs:3153-3164`

The strongest relation control returns a separate boolean and does not produce a validated state type.

```rust
pub fn ntru_fg_gf_check_weighted_shares(
    rng: &mut impl rand::RngCore,
    td: &ITrapdoorShares,
    xs: &[u16],
    k: u8,
) -> Result<bool> {
    let d = ntru_fg_gf_open_delta(rng, td, xs, k)?;
    if d.len() != FT1536_N { return Err(SpikeError::PartyCountMismatch); }
    Ok(d[0] == FT1536_Q as i64 && d[1..].iter().all(|&c| c == 0))
}
```

**Signer accepts unchecked G2Trapdoor** — `ishare.rs:3174-3190`

Signing rechecks shape and F bound but cannot tell whether the NTRU checker ran.

```rust
pub fn mps4h_sign_shares_g2(
    rng: &mut impl rand::RngCore,
    gt: &G2Trapdoor,
    t: &[u16],
    xs: &[u16],
    k: u8,
    bits_tf: u32,
    bits_tf_big: u32,
    gauss_sigma: Option<u8>,
) -> Result<(Vec<i64>, Vec<i64>, SignCost)> {
    if t.len() != FT1536_N { return Err(SpikeError::PartyCountMismatch); }
    check_xs_p(xs, k)?;
    validate_f_bound_shares(rng, &gt.td.f_big, xs, k)?;
```

**DKG returns a signable object after F-bound only** — `ishare.rs:3071-3098`

The DKG operation returns the ordinary signing object without invoking or recording the NTRU relation check.

```rust
validate_f_bound_shares(&mut rngs[0], &fb_acc, xs, k)?;
let delta = ZpDeltaShares {
    xs: xs.to_vec(),
    shares: ishare_val(&mut rngs[0], dk as i64, xs, k)?,
};
Ok(G2Trapdoor {
    td: ITrapdoorShares { f: f_acc, g: g_acc, f_big: fb_acc, g_big: gb_acc },
    // ...
    delta,
    delta_known: dk,
})
```

**Signer accepts raw G2Trapdoor and checks only length, coordinates and F bound** — `ishare.rs:3174-3190`

No checked-state token or in-function relation validation separates unvalidated DKG output from the signing sink.

```rust
pub fn mps4h_sign_shares_g2(
    rng: &mut impl rand::RngCore,
    gt: &G2Trapdoor,
    t: &[u16],
    xs: &[u16],
    k: u8,
    bits_tf: u32,
    bits_tf_big: u32,
    gauss_sigma: Option<u8>,
) -> Result<(Vec<i64>, Vec<i64>, SignCost)> {
    if t.len() != FT1536_N { return Err(SpikeError::PartyCountMismatch); }
    check_xs_p(xs, k)?;
    validate_f_bound_shares(rng, &gt.td.f_big, xs, k)?;
```

**Test confirms bad contribution survives DKG** — `ishare.rs:6480-6507`

The negative test proves the invalid relation does not make DKG fail; rejection occurs only if a caller remembers the separate check.

```rust
gb0[0] = gb0[0].wrapping_add(1);
// ... build contribs ...
let gt = dkg_trapdoor_from_weighted_contributions(
    &mut rngs, &contribs, &[2, 1], &XS, K, DELTA, G2_VSS_SAMPLE,
).unwrap();
let ok = ntru_fg_gf_check_weighted_shares(&mut rngs[0], &gt.td, &XS, K).unwrap();
assert!(!ok, "zepsuty wkład G → fG−gF ≠ q (T10.4)");
```

**Signer accepts the same unchecked type** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:3174-3189`

Signing repeats the F bound but does not call the NTRU relation check or require a validated wrapper.

```rust
pub fn mps4h_sign_shares_g2(
    rng: &mut impl rand::RngCore,
    gt: &G2Trapdoor,
    t: &[u16],
    xs: &[u16],
    k: u8,
    bits_tf: u32,
    bits_tf_big: u32,
    gauss_sigma: Option<u8>,
) -> Result<(Vec<i64>, Vec<i64>, SignCost)> {
    if t.len() != FT1536_N { return Err(SpikeError::PartyCountMismatch); }
    check_xs_p(xs, k)?;
    validate_f_bound_shares(rng, &gt.td.f_big, xs, k)?;
```

**NTRU validation is a separate boolean call** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:3153-3164`

The check neither consumes nor upgrades the trapdoor and returning `false` does not invalidate the existing object.

```rust
pub fn ntru_fg_gf_check_weighted_shares(
    rng: &mut impl rand::RngCore,
    td: &ITrapdoorShares,
    xs: &[u16],
    k: u8,
) -> Result<bool> {
    let d = ntru_fg_gf_open_delta(rng, td, xs, k)?;
    if d.len() != FT1536_N { return Err(SpikeError::PartyCountMismatch); }
    Ok(d[0] == FT1536_Q as i64 && d[1..].iter().all(|&c| c == 0))
}
```

Assertions:
- Pedersen VSS proves consistency with committed values, not the aggregate `fG-gF=q` relation.
- A relation-invalid but consistently committed contribution can reach `Ok(G2Trapdoor)` and the G2 signer.
- DKG itself does not call the relation check.
- The check accepts only raw share matrices and cannot verify their VSS commitments.
- The relation checker itself compares all coefficients correctly.
- Documentation tells callers to run it, but does not enforce the sequence.
- Invalid relation does not fail DKG.
- The checker returns a separable bool.
- Signer requires no proof of successful check.

Counterevidence and remaining uncertainty:
- Comments explicitly prescribe DKG followed by the offline checker.
- When called, the helper checks the full relation and returns false for invalid material.
- Comments explicitly instruct callers to compose weighted DKG with the offline check.
- The full checker correctly compares `[q,0,…,0]` when called.
- Documentation explicitly prescribes DKG plus offline relation check.
- The checker correctly rejects the embedded negative case.
- No deployed caller skipping the step is in scope.
- Documentation explicitly says production setup is DKG plus this offline check.
- The signer performs an independent F-bound check.

Limitations:
- Established impact is invalid signatures, malformed state, or denial of service.
- No verifier-accepted forgery or key disclosure from relation-invalid material was demonstrated.
- Documentation tells callers to run the check; this mitigates accidental misuse but does not enforce it or protect the check against an active participant.
- No deployed setup workflow was provided.
- No production orchestrator is within scope.
- No runtime test was executed; the embedded test was reviewed statically.
- Concrete availability impact depends on integration behavior.
- No higher-level in-scope wrapper was found that mandates ordering; external callers were outside scope.

#### Dataflow

malformed but shape/VSS-prefix/F-bound-consistent contribution -\> ordinary DKG `G2Trapdoor` -\> optional or tampered NTRU check -\> public G2 signer

- **Source:** weighted DKG contribution

- **Sink:** `mps4h_sign_shares_g2()`

- **Outcome:** invalid NTRU key state drives signature computation

**DKG returns a normal G2Trapdoor** — `ishare.rs:3071-3079`

After VSS/range work, the constructor transitions directly to a sign-capable `G2Trapdoor` without the NTRU relation check.

```rust
validate_f_bound_shares(&mut rngs[0], &fb_acc, xs, k)?;
let delta = ZpDeltaShares {
    xs: xs.to_vec(),
    shares: ishare_val(&mut rngs[0], dk as i64, xs, k)?,
};
Ok(G2Trapdoor {
```

**Signer accepts G2Trapdoor directly** — `ishare.rs:3174-3189`

The signing entry point has no validated-state token or NTRU check and accepts the same type returned by unchecked DKG.

```rust
pub fn mps4h_sign_shares_g2(
    rng: &mut impl rand::RngCore,
    gt: &G2Trapdoor,
    t: &[u16],
    xs: &[u16],
    k: u8,
    bits_tf: u32,
    bits_tf_big: u32,
    gauss_sigma: Option<u8>,
) -> Result<(Vec<i64>, Vec<i64>, SignCost)> {
    if t.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    check_xs_p(xs, k)?;
```

**DKG accepts attacker-selected contribution polynomials** — `ishare.rs:2881-2898`

A malicious contributor can choose complete polynomial inputs; `vss_count` determines commitment coverage but does not impose the NTRU algebraic relation.

```rust
pub fn dkg_trapdoor_from_weighted_contributions<R: rand::RngCore>(
    rngs: &mut [R],
    contribs: &[PartyTrapdoorContribution],
    weights: &[u64],
    xs: &[u16],
    k: u8,
    delta_known: u64,
    vss_count: usize,
) -> Result<G2Trapdoor> {
    let n = check_xs_p(xs, k)?;
    if contribs.is_empty() || rngs.is_empty() || weights.len() != contribs.len() {
        return Err(SpikeError::PartyCountMismatch);
    }
    let n_vss = if vss_count == 0 { FT1536_N } else { vss_count.min(FT1536_N) };
```

**DKG returns sign-capable state after VSS and bound checks only** — `ishare.rs:3053-3098`

Commitment and range checks succeed for internally consistent but algebraically invalid contributions; the function still returns the ordinary signing state.

```rust
vss_verify_poly_shares(&vss_f, &vss_sh_f, xs)?;
vss_verify_poly_shares(&vss_g, &vss_sh_g, xs)?;
vss_verify_poly_shares(&vss_f_big, &vss_sh_fb, xs)?;
vss_verify_poly_shares(&vss_g_big, &vss_sh_gb, xs)?;
// ... MAC construction ...
validate_f_bound_shares(&mut rngs[0], &fb_acc, xs, k)?;
// ... delta shares ...
Ok(G2Trapdoor {
    td: ITrapdoorShares { f: f_acc, g: g_acc, f_big: fb_acc, g_big: gb_acc },
    // ...
    delta_known: dk,
})
```

**Required NTRU check is a separate optional boolean** — `ishare.rs:3153-3163`

The correct relation is available but returns a detached `bool`; it does not upgrade or bind the `G2Trapdoor` used later.

```rust
pub fn ntru_fg_gf_check_weighted_shares(
    rng: &mut impl rand::RngCore,
    td: &ITrapdoorShares,
    xs: &[u16],
    k: u8,
) -> Result<bool> {
    let d = ntru_fg_gf_open_delta(rng, td, xs, k)?;
    if d.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    Ok(d[0] == FT1536_Q as i64 && d[1..].iter().all(|&c| c == 0))
}
```

**Signing accepts unchecked G2Trapdoor directly** — `ishare.rs:3174-3189`

The sensitive operation repeats only shape and bound checks; it cannot tell whether the separate NTRU boolean was ever evaluated or accepted.

```rust
pub fn mps4h_sign_shares_g2(
    rng: &mut impl rand::RngCore,
    gt: &G2Trapdoor,
    t: &[u16],
    xs: &[u16],
    k: u8,
    bits_tf: u32,
    bits_tf_big: u32,
    gauss_sigma: Option<u8>,
) -> Result<(Vec<i64>, Vec<i64>, SignCost)> {
    if t.len() != FT1536_N { return Err(SpikeError::PartyCountMismatch); }
    check_xs_p(xs, k)?;
    validate_f_bound_shares(rng, &gt.td.f_big, xs, k)?;
```

**DKG returns G2Trapdoor** — `ishare.rs:2881-2898`

The setup API's successful state is the same `G2Trapdoor` type later consumed by signing.

```rust
pub fn dkg_trapdoor_from_weighted_contributions<R: rand::RngCore>(
    rngs: &mut [R],
    contribs: &[PartyTrapdoorContribution],
    weights: &[u64],
    xs: &[u16],
    k: u8,
    delta_known: u64,
    vss_count: usize,
) -> Result<G2Trapdoor> {
```

**Return path omits NTRU check** — `ishare.rs:3053-3098`

VSS and F-bound controls run, but the return is not conditioned on the full NTRU relation.

```rust
vss_verify_poly_shares(&vss_f, &vss_sh_f, xs)?;
vss_verify_poly_shares(&vss_g, &vss_sh_g, xs)?;
vss_verify_poly_shares(&vss_f_big, &vss_sh_fb, xs)?;
vss_verify_poly_shares(&vss_g_big, &vss_sh_gb, xs)?;
validate_f_bound_shares(&mut rngs[0], &fb_acc, xs, k)?;
Ok(G2Trapdoor { /* shares, VSS and delta */ })
```

**Signer accepts unchecked G2Trapdoor** — `ishare.rs:3174-3190`

Signing rechecks shape and F bound but cannot tell whether the NTRU checker ran.

```rust
pub fn mps4h_sign_shares_g2(
    rng: &mut impl rand::RngCore,
    gt: &G2Trapdoor,
    t: &[u16],
    xs: &[u16],
    k: u8,
    bits_tf: u32,
    bits_tf_big: u32,
    gauss_sigma: Option<u8>,
) -> Result<(Vec<i64>, Vec<i64>, SignCost)> {
    if t.len() != FT1536_N { return Err(SpikeError::PartyCountMismatch); }
    check_xs_p(xs, k)?;
    validate_f_bound_shares(rng, &gt.td.f_big, xs, k)?;
```

**Required relation check is optional** — `ishare.rs:3153-3164`

The strongest relation control returns a separate boolean and does not produce a validated state type.

```rust
pub fn ntru_fg_gf_check_weighted_shares(
    rng: &mut impl rand::RngCore,
    td: &ITrapdoorShares,
    xs: &[u16],
    k: u8,
) -> Result<bool> {
    let d = ntru_fg_gf_open_delta(rng, td, xs, k)?;
    if d.len() != FT1536_N { return Err(SpikeError::PartyCountMismatch); }
    Ok(d[0] == FT1536_Q as i64 && d[1..].iter().all(|&c| c == 0))
}
```

**DKG returns a signable object after F-bound only** — `ishare.rs:3071-3098`

The DKG operation returns the ordinary signing object without invoking or recording the NTRU relation check.

```rust
validate_f_bound_shares(&mut rngs[0], &fb_acc, xs, k)?;
let delta = ZpDeltaShares {
    xs: xs.to_vec(),
    shares: ishare_val(&mut rngs[0], dk as i64, xs, k)?,
};
Ok(G2Trapdoor {
    td: ITrapdoorShares { f: f_acc, g: g_acc, f_big: fb_acc, g_big: gb_acc },
    // ...
    delta,
    delta_known: dk,
})
```

**Signer accepts raw G2Trapdoor and checks only length, coordinates and F bound** — `ishare.rs:3174-3190`

No checked-state token or in-function relation validation separates unvalidated DKG output from the signing sink.

```rust
pub fn mps4h_sign_shares_g2(
    rng: &mut impl rand::RngCore,
    gt: &G2Trapdoor,
    t: &[u16],
    xs: &[u16],
    k: u8,
    bits_tf: u32,
    bits_tf_big: u32,
    gauss_sigma: Option<u8>,
) -> Result<(Vec<i64>, Vec<i64>, SignCost)> {
    if t.len() != FT1536_N { return Err(SpikeError::PartyCountMismatch); }
    check_xs_p(xs, k)?;
    validate_f_bound_shares(rng, &gt.td.f_big, xs, k)?;
```

**Test confirms bad contribution survives DKG** — `ishare.rs:6480-6507`

The negative test proves the invalid relation does not make DKG fail; rejection occurs only if a caller remembers the separate check.

```rust
gb0[0] = gb0[0].wrapping_add(1);
// ... build contribs ...
let gt = dkg_trapdoor_from_weighted_contributions(
    &mut rngs, &contribs, &[2, 1], &XS, K, DELTA, G2_VSS_SAMPLE,
).unwrap();
let ok = ntru_fg_gf_check_weighted_shares(&mut rngs[0], &gt.td, &XS, K).unwrap();
assert!(!ok, "zepsuty wkład G → fG−gF ≠ q (T10.4)");
```

**Signer accepts the same unchecked type** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:3174-3189`

Signing repeats the F bound but does not call the NTRU relation check or require a validated wrapper.

```rust
pub fn mps4h_sign_shares_g2(
    rng: &mut impl rand::RngCore,
    gt: &G2Trapdoor,
    t: &[u16],
    xs: &[u16],
    k: u8,
    bits_tf: u32,
    bits_tf_big: u32,
    gauss_sigma: Option<u8>,
) -> Result<(Vec<i64>, Vec<i64>, SignCost)> {
    if t.len() != FT1536_N { return Err(SpikeError::PartyCountMismatch); }
    check_xs_p(xs, k)?;
    validate_f_bound_shares(rng, &gt.td.f_big, xs, k)?;
```

**NTRU validation is a separate boolean call** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:3153-3164`

The check neither consumes nor upgrades the trapdoor and returning `false` does not invalidate the existing object.

```rust
pub fn ntru_fg_gf_check_weighted_shares(
    rng: &mut impl rand::RngCore,
    td: &ITrapdoorShares,
    xs: &[u16],
    k: u8,
) -> Result<bool> {
    let d = ntru_fg_gf_open_delta(rng, td, xs, k)?;
    if d.len() != FT1536_N { return Err(SpikeError::PartyCountMismatch); }
    Ok(d[0] == FT1536_Q as i64 && d[1..].iter().all(|&c| c == 0))
}
```

#### Reachability

Requires a malicious or faulty setup contribution and an embedding that follows the type-allowed path without separately enforcing the documented check.

- **Attacker:** malicious trapdoor contributor

- **Entry point:** weighted contribution DKG

- **Outcome:** signing integrity failure, malformed output, or denial of service

Preconditions:
- Caller accepts participant contributions.
- Caller omits or ignores `ntru_fg_gf_check_weighted_shares`.

#### Severity

**Medium** — Invalid trapdoor material can cause persistent signing failure or attacker-influenced malformed state; the source does not establish signature forgery and documents the required offline sequence.

Raise if invalid relation material is shown to yield forgery or key leakage; lower if the type/API is changed so signing cannot receive unchecked state.

Impact assessment:
- **Level:** medium
- **Why:** Invalid key state can make signatures wrong or unavailable; valid-signature forgery was not established.

Likelihood assessment:
- **Level:** medium
- **Why:** Public APIs directly permit the unsafe sequence, although documentation describes the safe order.

#### Remediation

Return an opaque `UncheckedTrapdoor` from aggregation. Make an authenticated, commitment- and transcript-bound full NTRU verification consume it and return a privately constructible `ValidatedTrapdoor`; bind contributors, weights, qualified set, coordinates, threshold, session, shares and public key, represent failure as an error, and require only `ValidatedTrapdoor` at every signing entry point.

Tests:
- Prove relation-invalid DKG output cannot be passed to the signer.
- Alter one contribution and require finalization to fail before signing state exists.
- Bind validation to exact weights and participant transcript.
- Submit a full-VSS-consistent contribution set with `fG-gF != q` and assert setup produces no sign-capable object.
- Add compile-time/API tests ensuring `mps4h_sign_shares_g2()` cannot accept unchecked setup output.
- Prove a VSS-consistent wrong contribution cannot produce a value accepted by signing.
- Tamper multiplication and final opening messages during NTRU validation and require rejection.
- Bind validation to participant set, weights, commitments, public key, and session transcript.
- Corrupt one G coefficient and assert no sign-capable type is returned.
- Compile-time test that signing accepts only `ValidatedTrapdoor`.
- Alter one G coefficient and require DKG finalization to fail.
- Make it impossible at compile time to call the signer with unchecked state.
- Compile-time/API test: raw DKG output cannot be passed to signing.
- A bad contribution must make validation fail and produce no `ValidatedG2Trapdoor`.
- A valid weighted contribution set must transition to the validated type and sign normally.
- Prove at compile time or API level that the direct DKG result cannot be passed to signing.
- Feed a relation-invalid aggregate and assert no sign-capable object is produced.

Preventive controls:
- Typestate/capability transition for setup validation.
- Private fields preventing construction of validated state.
- Enforce full-coefficient commitment coverage for security-sensitive setup.
- Bind qualified-set/complaint decisions and the successful NTRU check to a transcript digest stored in verified state.
- Use authenticated multiplication with validated triples and commit-before-reveal openings.
- Encode security state transitions in Rust types rather than documentation.
- Bind participant IDs, ordered contribution digests, weights and session ID into validation.
- Represent failed relation checks as errors, not reusable false values.
- Centralize setup finalization and relation validation.
- Bind validation to the exact contribution set, weights, coordinates, threshold, and session.
- Bind contribution digests, VSS/F-bound results and relation-check transcript into the validated object.
- Keep unvalidated fields private.
- Require fail-closed error handling instead of bare booleans for key-validity checks.
- Bind roster, weights, commitments, public key and FT1536 parameters into the validation transcript.

<a id="finding-4"></a>

### [4] Same-width masks leak secret-dependent differences across repeated MPC openings

| Field | Value |
| --- | --- |
| Severity | medium |
| Confidence | high |
| Confidence rationale | Mask width, field modulus, centered reconstruction and repeated call sites are explicit; only downstream exploit magnitude remains uncertain. |
| Category | Insufficient statistical masking of MPC transcript |
| CWE | CWE-200, CWE-331 |
| Affected lines | ishare.rs:1163-1189, ishare.rs:2026-2053, ishare.rs:2123-2150, ishare.rs:2506-2545, ishare.rs:3188-3189, ishare.rs:1163-1186, ishare.rs:2003-2050, ishare.rs:2123-2154, ishare.rs:3183-3190, ishare.rs:1160-1186, ishare.rs:2026-2050, ishare.rs:2506-2545, proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:2031-2053 |

#### Summary

Rounding and `F`-bound paths open `d=X-r` while `X` and the uniform mask `r` occupy the same `W`-bit interval (`W≤48`) inside `Z_(2^61-1)`. With no ordinary field wrap, the support of `d` shifts with `X`—an extreme difference can determine an extreme operand—so even fresh, MAC-authenticated openings have an `X`-dependent distribution. G2 signing repeats this disclosure for long-lived `F` coefficients, allowing transcript constraints to accumulate.

#### Root Cause

An exactly W-bit mask is treated as statistically hiding a W-bit secret while their signed difference is opened in a much larger field. The protocol omits κ bits of statistical slack or an equivalent proven wrap/carry mechanism and repeats the construction on long-lived coefficients; authentication protects integrity but does not hide the operand-dependent distribution.

**Rounding opens difference against an exactly B-bit mask** — `ishare.rs:1163-1189`

The mask spans only `[0,2^B)`, and the protocol reconstructs the signed field difference. Without security slack, its distribution depends on `X`.

```rust
// 2. maska r ∈ [0, 2^W)
let mut r_p_shares = vec![0u64; n];
let mut pow2 = 1u64;
for _ in 0..w {
    let (mg, mp) = paired_bit_mask_prss_src(src, xs_p, xs_gf, k, cost)?;
    r_p_shares = r_p_shares.iter().zip(&mp)
        .map(|(a, b)| p_add(*a, p_mul(*b, pow2))).collect();
    r_bits_gf.push(mg);
    pow2 = p_mul(pow2, 2);
}
let d_shares: Vec<u64> = x_off.iter().zip(&r_p_shares)
    .map(|(a, b)| p_sub(*a, *b)).collect();
let d_i = ireconstruct_val(xs_p, &d_shares)?;
```

**F-bound proof repeats the same exact-width construction** — `ishare.rs:2026-2053`

The range proof sets `B=17` for fixed trapdoor coefficients and publicly obtains the same secret-shifted difference.

```rust
let x_off: Vec<u64> = v.iter().map(|&s| p_add(s, i64_to_p(off as i64))).collect();
// 2. maska r ∈ [0, 2^B)
let mut r_p_shares = vec![0u64; n];
for _ in 0..b {
    let (mg, mp) = paired_bit_mask_prss(rng, xs_p, xs_gf, k, cost)?;
    r_p_shares = r_p_shares.iter().zip(&mp)
        .map(|(a, c)| p_add(*a, p_mul(*c, pow2))).collect();
    r_bits_gf.push(mg);
    pow2 = p_mul(pow2, 2);
}
let d_shares: Vec<u64> = x_off.iter().zip(&r_p_shares)
    .map(|(a, c)| p_sub(*a, *c)).collect();
let d_i = ireconstruct_val(xs_p, &d_shares)?;
```

**G2 authenticates but still reveals the difference** — `ishare.rs:2506-2545`

The MAC prevents unauthenticated alteration but does not widen the mask or hide the reconstructed distribution.

```rust
// 2. maska r ∈ [0, 2^W) z MAC
// ... build B-bit r and its MAC ...
let d_mac_shares: Vec<ZpMacShare> = x_off.iter()
    .zip(&x_off_mac).zip(&r_p_shares).zip(&r_p_mac).zip(xs_p)
    .map(|((((xo, xm), rp), rm), &x)| ZpMacShare {
        x, share: p_sub(*xo, *rp), mac: p_sub(*xm, *rm),
    }).collect();
let d_i = zp_open_with_mac_hidden_delta(&d_mac_shares, delta, k)?;
```

**Every G2 signature reruns the bound proof** — `ishare.rs:3184-3189`

Each signing call emits fresh `d` samples shifted by the same long-lived `F` coefficients, enabling transcript accumulation.

```rust
if t.len() != FT1536_N {
    return Err(SpikeError::PartyCountMismatch);
}
check_xs_p(xs, k)?;
validate_f_bound_shares(rng, &gt.td.f_big, xs, k)?;
```

**Rounding mask has only B bits** — `ishare.rs:1163-1177`

The mask is assembled from exactly `B` bits, so its integer support is bounded to `[0,2^B)` rather than hiding `X` over the 61-bit field.

```rust
// 2. maska r ∈ [0, 2^W) — bity w GF(256) i Z_P, fold do udziału Z_P r
let mut r_bits_gf: Vec<GfBitShares> = Vec::with_capacity(w);
let mut r_p_shares = vec![0u64; n];
let mut pow2 = 1u64;
for _ in 0..w {
    let (mg, mp) = paired_bit_mask_prss_src(src, xs_p, xs_gf, k, cost)?;
    r_p_shares = r_p_shares
        .iter()
        .zip(&mp)
        .map(|(a, b)| p_add(*a, p_mul(*b, pow2)))
        .collect();
    r_bits_gf.push(mg);
    pow2 = p_mul(pow2, 2);
}
```

**Exact secret-minus-mask difference is opened** — `ishare.rs:1179-1189`

Reconstruction publishes `d`. Since both `X` and `r` are much smaller than `P`, the centered result is the exact integer difference whose support shifts with the secret.

```rust
// open d = X − r (maska — nie otwiera x)
let d_shares: Vec<u64> = x_off
    .iter()
    .zip(&r_p_shares)
    .map(|(a, b)| p_sub(*a, *b))
    .collect();
cost.bit_opens += 1;
let d_i = ireconstruct_val(xs_p, &d_shares)?;

// 3. X_bits = r + d_twos (width W+1), low W bitów = X
let d_twos = d_i.rem_euclid(1i64 << (w + 1)) as u64;
```

**F-bound proof repeats the same bounded-mask opening** — `ishare.rs:2026-2050`

The range proof applies the same construction to a fixed trapdoor coefficient `v`, leaking one new shifted-support sample per invocation.

```rust
let x_off: Vec<u64> = v.iter().map(|&s| p_add(s, i64_to_p(off as i64))).collect();

// 2. maska r ∈ [0, 2^B) — bity w GF(256) i Z_P (PRSS, T7.1)
let mut r_bits_gf: Vec<GfBitShares> = Vec::with_capacity(b);
let mut r_p_shares = vec![0u64; n];
let mut pow2 = 1u64;
for _ in 0..b {
    let (mg, mp) = paired_bit_mask_prss(rng, xs_p, xs_gf, k, cost)?;
    r_p_shares = r_p_shares
        .iter()
        .zip(&mp)
        .map(|(a, c)| p_add(*a, p_mul(*c, pow2)))
        .collect();
    r_bits_gf.push(mg);
    pow2 = p_mul(pow2, 2);
}
let d_shares: Vec<u64> = x_off
    .iter()
    .zip(&r_p_shares)
    .map(|(a, c)| p_sub(*a, *c))
    .collect();
cost.bit_opens += 1;
let d_i = ireconstruct_val(xs_p, &d_shares)?;
```

**Every G2 signature rechecks all F coefficients** — `ishare.rs:3183-3190`

The long-term `F` sharing is subjected to 1536 fresh secret-dependent openings for each signing invocation, enabling repeated-transcript narrowing.

```rust
if t.len() != FT1536_N {
    return Err(SpikeError::PartyCountMismatch);
}
check_xs_p(xs, k)?;
// T9.2: range proof max|F| < q/2 — druga linia obrony (obok deal/DKG).
validate_f_bound_shares(rng, &gt.td.f_big, xs, k)?;
let mut cost = SignCost::default();
```

**Same-width mask** — `ishare.rs:1160-1177`

`X` and `r` have the same W-bit range; no statistical slack is added.

```rust
let x_off: Vec<u64> = x_noised.iter().map(|&s| p_add(s, i64_to_p(off as i64))).collect();
let mut r_p_shares = vec![0u64; n];
for _ in 0..w {
    let (mg, mp) = paired_bit_mask_prss_src(src, xs_p, xs_gf, k, cost)?;
    r_p_shares = r_p_shares.iter().zip(&mp)
        .map(|(a, b)| p_add(*a, p_mul(*b, pow2))).collect();
    r_bits_gf.push(mg);
    pow2 = p_mul(pow2, 2);
}
```

**Difference is opened** — `ishare.rs:1179-1189`

Centered reconstruction exposes sign and magnitude of `X-r`, whose support shifts with secret `X`.

```rust
let d_shares: Vec<u64> = x_off.iter().zip(&r_p_shares)
    .map(|(a, b)| p_sub(*a, *b)).collect();
cost.bit_opens += 1;
let d_i = ireconstruct_val(xs_p, &d_shares)?;
let d_twos = d_i.rem_euclid(1i64 << (w + 1)) as u64;
```

**Range proof repeats disclosure** — `ishare.rs:2026-2050`

Every protected F coefficient uses the same shifted bounded-mask transcript.

```rust
let x_off: Vec<u64> = v.iter().map(|&s| p_add(s, i64_to_p(off as i64))).collect();
let d_shares: Vec<u64> = x_off.iter().zip(&r_p_shares)
    .map(|(a, c)| p_sub(*a, *c)).collect();
cost.bit_opens += 1;
let d_i = ireconstruct_val(xs_p, &d_shares)?;
```

**Authenticated path opens same value** — `ishare.rs:2528-2545`

The MAC authenticates but does not hide secret-dependent `d`.

```rust
let d_mac_shares: Vec<ZpMacShare> = x_off.iter().zip(&x_off_mac)
    .zip(&r_p_shares).zip(&r_p_mac).zip(xs_p)
    .map(|((((xo, xm), rp), rm), &x)| ZpMacShare {
        x, share: p_sub(*xo, *rp), mac: p_sub(*xm, *rm),
    }).collect();
let d_i = zp_open_with_mac_hidden_delta(&d_mac_shares, delta, k)?;
```

**Mask has exactly W secret bits** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:1163-1177`

The hidden operand `X` is W bits, and the mask is independently assembled from exactly W bits, leaving no wider statistical hiding domain.

```rust
// 2. maska r ∈ [0, 2^W)
let mut r_bits_gf: Vec<GfBitShares> = Vec::with_capacity(w);
let mut r_p_shares = vec![0u64; n];
let mut pow2 = 1u64;
for _ in 0..w {
    let (mg, mp) = paired_bit_mask_prss_src(src, xs_p, xs_gf, k, cost)?;
    r_p_shares = r_p_shares.iter().zip(&mp)
        .map(|(a, b)| p_add(*a, p_mul(*b, pow2))).collect();
    r_bits_gf.push(mg);
    pow2 = p_mul(pow2, 2);
}
```

**Exact masked difference is reconstructed** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:1179-1189`

Participants reconstruct `d=X-r`; because both terms are bounded below `2^W`, its signed value exposes an operand-dependent distribution before the two's-complement conversion.

```rust
let d_shares: Vec<u64> = x_off.iter().zip(&r_p_shares)
    .map(|(a, b)| p_sub(*a, *b)).collect();
cost.bit_opens += 1;
let d_i = ireconstruct_val(xs_p, &d_shares)?;
let d_twos = d_i.rem_euclid(1i64 << (w + 1)) as u64;
```

**G2 authenticates but still reveals the same difference** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:2528-2545`

The G2 path checks integrity of the opening but reveals the identical `X-r` value, so the MAC does not restore confidentiality.

```rust
let d_mac_shares: Vec<ZpMacShare> = x_off.iter()
    .zip(&x_off_mac).zip(&r_p_shares).zip(&r_p_mac).zip(xs_p)
    .map(|((((xo, xm), rp), rm), &x)| ZpMacShare {
        x, share: p_sub(*xo, *rp), mac: p_sub(*xm, *rm),
    }).collect();
cost.bit_opens += 1;
let d_i = zp_open_with_mac_hidden_delta(&d_mac_shares, delta, k)?;
let d_twos = d_i.rem_euclid(1i64 << (w + 1)) as u64;
```

#### Validation

For fixed X and no wrap, `d=X-r` ranges from `X-(2^W-1)` through `X`, so its support and probabilities depend on X. Every transcript constrains X and repeated fixed-coefficient openings accumulate information; practical recovery complexity and deployed transcript visibility remain unmeasured.

Validation method: Static arithmetic, transcript, and repeated-call-path analysis; static algebraic source trace

**Rounding opens difference against an exactly B-bit mask** — `ishare.rs:1163-1189`

The mask spans only `[0,2^B)`, and the protocol reconstructs the signed field difference. Without security slack, its distribution depends on `X`.

```rust
// 2. maska r ∈ [0, 2^W)
let mut r_p_shares = vec![0u64; n];
let mut pow2 = 1u64;
for _ in 0..w {
    let (mg, mp) = paired_bit_mask_prss_src(src, xs_p, xs_gf, k, cost)?;
    r_p_shares = r_p_shares.iter().zip(&mp)
        .map(|(a, b)| p_add(*a, p_mul(*b, pow2))).collect();
    r_bits_gf.push(mg);
    pow2 = p_mul(pow2, 2);
}
let d_shares: Vec<u64> = x_off.iter().zip(&r_p_shares)
    .map(|(a, b)| p_sub(*a, *b)).collect();
let d_i = ireconstruct_val(xs_p, &d_shares)?;
```

**F-bound proof repeats the same exact-width construction** — `ishare.rs:2026-2053`

The range proof sets `B=17` for fixed trapdoor coefficients and publicly obtains the same secret-shifted difference.

```rust
let x_off: Vec<u64> = v.iter().map(|&s| p_add(s, i64_to_p(off as i64))).collect();
// 2. maska r ∈ [0, 2^B)
let mut r_p_shares = vec![0u64; n];
for _ in 0..b {
    let (mg, mp) = paired_bit_mask_prss(rng, xs_p, xs_gf, k, cost)?;
    r_p_shares = r_p_shares.iter().zip(&mp)
        .map(|(a, c)| p_add(*a, p_mul(*c, pow2))).collect();
    r_bits_gf.push(mg);
    pow2 = p_mul(pow2, 2);
}
let d_shares: Vec<u64> = x_off.iter().zip(&r_p_shares)
    .map(|(a, c)| p_sub(*a, *c)).collect();
let d_i = ireconstruct_val(xs_p, &d_shares)?;
```

**G2 authenticates but still reveals the difference** — `ishare.rs:2506-2545`

The MAC prevents unauthenticated alteration but does not widen the mask or hide the reconstructed distribution.

```rust
// 2. maska r ∈ [0, 2^W) z MAC
// ... build B-bit r and its MAC ...
let d_mac_shares: Vec<ZpMacShare> = x_off.iter()
    .zip(&x_off_mac).zip(&r_p_shares).zip(&r_p_mac).zip(xs_p)
    .map(|((((xo, xm), rp), rm), &x)| ZpMacShare {
        x, share: p_sub(*xo, *rp), mac: p_sub(*xm, *rm),
    }).collect();
let d_i = zp_open_with_mac_hidden_delta(&d_mac_shares, delta, k)?;
```

**Every G2 signature reruns the bound proof** — `ishare.rs:3184-3189`

Each signing call emits fresh `d` samples shifted by the same long-lived `F` coefficients, enabling transcript accumulation.

```rust
if t.len() != FT1536_N {
    return Err(SpikeError::PartyCountMismatch);
}
check_xs_p(xs, k)?;
validate_f_bound_shares(rng, &gt.td.f_big, xs, k)?;
```

**Rounding mask has only B bits** — `ishare.rs:1163-1177`

The mask is assembled from exactly `B` bits, so its integer support is bounded to `[0,2^B)` rather than hiding `X` over the 61-bit field.

```rust
// 2. maska r ∈ [0, 2^W) — bity w GF(256) i Z_P, fold do udziału Z_P r
let mut r_bits_gf: Vec<GfBitShares> = Vec::with_capacity(w);
let mut r_p_shares = vec![0u64; n];
let mut pow2 = 1u64;
for _ in 0..w {
    let (mg, mp) = paired_bit_mask_prss_src(src, xs_p, xs_gf, k, cost)?;
    r_p_shares = r_p_shares
        .iter()
        .zip(&mp)
        .map(|(a, b)| p_add(*a, p_mul(*b, pow2)))
        .collect();
    r_bits_gf.push(mg);
    pow2 = p_mul(pow2, 2);
}
```

**Exact secret-minus-mask difference is opened** — `ishare.rs:1179-1189`

Reconstruction publishes `d`. Since both `X` and `r` are much smaller than `P`, the centered result is the exact integer difference whose support shifts with the secret.

```rust
// open d = X − r (maska — nie otwiera x)
let d_shares: Vec<u64> = x_off
    .iter()
    .zip(&r_p_shares)
    .map(|(a, b)| p_sub(*a, *b))
    .collect();
cost.bit_opens += 1;
let d_i = ireconstruct_val(xs_p, &d_shares)?;

// 3. X_bits = r + d_twos (width W+1), low W bitów = X
let d_twos = d_i.rem_euclid(1i64 << (w + 1)) as u64;
```

**F-bound proof repeats the same bounded-mask opening** — `ishare.rs:2026-2050`

The range proof applies the same construction to a fixed trapdoor coefficient `v`, leaking one new shifted-support sample per invocation.

```rust
let x_off: Vec<u64> = v.iter().map(|&s| p_add(s, i64_to_p(off as i64))).collect();

// 2. maska r ∈ [0, 2^B) — bity w GF(256) i Z_P (PRSS, T7.1)
let mut r_bits_gf: Vec<GfBitShares> = Vec::with_capacity(b);
let mut r_p_shares = vec![0u64; n];
let mut pow2 = 1u64;
for _ in 0..b {
    let (mg, mp) = paired_bit_mask_prss(rng, xs_p, xs_gf, k, cost)?;
    r_p_shares = r_p_shares
        .iter()
        .zip(&mp)
        .map(|(a, c)| p_add(*a, p_mul(*c, pow2)))
        .collect();
    r_bits_gf.push(mg);
    pow2 = p_mul(pow2, 2);
}
let d_shares: Vec<u64> = x_off
    .iter()
    .zip(&r_p_shares)
    .map(|(a, c)| p_sub(*a, *c))
    .collect();
cost.bit_opens += 1;
let d_i = ireconstruct_val(xs_p, &d_shares)?;
```

**Every G2 signature rechecks all F coefficients** — `ishare.rs:3183-3190`

The long-term `F` sharing is subjected to 1536 fresh secret-dependent openings for each signing invocation, enabling repeated-transcript narrowing.

```rust
if t.len() != FT1536_N {
    return Err(SpikeError::PartyCountMismatch);
}
check_xs_p(xs, k)?;
// T9.2: range proof max|F| < q/2 — druga linia obrony (obok deal/DKG).
validate_f_bound_shares(rng, &gt.td.f_big, xs, k)?;
let mut cost = SignCost::default();
```

**Same-width mask** — `ishare.rs:1160-1177`

`X` and `r` have the same W-bit range; no statistical slack is added.

```rust
let x_off: Vec<u64> = x_noised.iter().map(|&s| p_add(s, i64_to_p(off as i64))).collect();
let mut r_p_shares = vec![0u64; n];
for _ in 0..w {
    let (mg, mp) = paired_bit_mask_prss_src(src, xs_p, xs_gf, k, cost)?;
    r_p_shares = r_p_shares.iter().zip(&mp)
        .map(|(a, b)| p_add(*a, p_mul(*b, pow2))).collect();
    r_bits_gf.push(mg);
    pow2 = p_mul(pow2, 2);
}
```

**Difference is opened** — `ishare.rs:1179-1189`

Centered reconstruction exposes sign and magnitude of `X-r`, whose support shifts with secret `X`.

```rust
let d_shares: Vec<u64> = x_off.iter().zip(&r_p_shares)
    .map(|(a, b)| p_sub(*a, *b)).collect();
cost.bit_opens += 1;
let d_i = ireconstruct_val(xs_p, &d_shares)?;
let d_twos = d_i.rem_euclid(1i64 << (w + 1)) as u64;
```

**Authenticated path opens same value** — `ishare.rs:2528-2545`

The MAC authenticates but does not hide secret-dependent `d`.

```rust
let d_mac_shares: Vec<ZpMacShare> = x_off.iter().zip(&x_off_mac)
    .zip(&r_p_shares).zip(&r_p_mac).zip(xs_p)
    .map(|((((xo, xm), rp), rm), &x)| ZpMacShare {
        x, share: p_sub(*xo, *rp), mac: p_sub(*xm, *rm),
    }).collect();
let d_i = zp_open_with_mac_hidden_delta(&d_mac_shares, delta, k)?;
```

**Mask has exactly W secret bits** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:1163-1177`

The hidden operand `X` is W bits, and the mask is independently assembled from exactly W bits, leaving no wider statistical hiding domain.

```rust
// 2. maska r ∈ [0, 2^W)
let mut r_bits_gf: Vec<GfBitShares> = Vec::with_capacity(w);
let mut r_p_shares = vec![0u64; n];
let mut pow2 = 1u64;
for _ in 0..w {
    let (mg, mp) = paired_bit_mask_prss_src(src, xs_p, xs_gf, k, cost)?;
    r_p_shares = r_p_shares.iter().zip(&mp)
        .map(|(a, b)| p_add(*a, p_mul(*b, pow2))).collect();
    r_bits_gf.push(mg);
    pow2 = p_mul(pow2, 2);
}
```

**Exact masked difference is reconstructed** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:1179-1189`

Participants reconstruct `d=X-r`; because both terms are bounded below `2^W`, its signed value exposes an operand-dependent distribution before the two's-complement conversion.

```rust
let d_shares: Vec<u64> = x_off.iter().zip(&r_p_shares)
    .map(|(a, b)| p_sub(*a, *b)).collect();
cost.bit_opens += 1;
let d_i = ireconstruct_val(xs_p, &d_shares)?;
let d_twos = d_i.rem_euclid(1i64 << (w + 1)) as u64;
```

**G2 authenticates but still reveals the same difference** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:2528-2545`

The G2 path checks integrity of the opening but reveals the identical `X-r` value, so the MAC does not restore confidentiality.

```rust
let d_mac_shares: Vec<ZpMacShare> = x_off.iter()
    .zip(&x_off_mac).zip(&r_p_shares).zip(&r_p_mac).zip(xs_p)
    .map(|((((xo, xm), rp), rm), &x)| ZpMacShare {
        x, share: p_sub(*xo, *rp), mac: p_sub(*xm, *rm),
    }).collect();
cost.bit_opens += 1;
let d_i = zp_open_with_mac_hidden_delta(&d_mac_shares, delta, k)?;
let d_twos = d_i.rem_euclid(1i64 << (w + 1)) as u64;
```

Assertions:
- For ordinary non-wrapping cases, `d` is the signed integer `X-r`, whose support and distribution shift with X.
- MAC verification changes authenticity, not statistical hiding.
- Freshness alone does not make the shifted bounded distribution independent of `X`.
- The fixed `F` coefficients are reprocessed on every G2 signature.
- d is reconstructed publicly.
- The support of d changes with X.
- G-2 authenticates rather than hides d.
- The mask domain is not wider than the operand domain.
- MAC authentication changes integrity, not the distribution of the opened value.

Counterevidence and remaining uncertainty:
- The individual mask bits remain secret-shared and at least one honest contribution makes r uniform over its B-bit interval.
- No complete key-recovery exploit or multiprocess transcript implementation was demonstrated.
- One fresh mask normally prevents exact recovery from one transcript.
- At least one honest random contribution is still required for the assumed mask distribution.
- r remains unknown.
- No production deployment is established.

Limitations:
- Leakage magnitude and sample complexity are not quantified.
- No runtime transcript collection was performed.
- The current in-process caller already holds aggregate share arrays; cross-participant observation requires the intended distributed opening semantics.
- No runtime transcript was generated.
- Exact key-recovery sample complexity is not claimed.
- No runtime leakage experiment or end-to-end key-recovery attack was run.

#### Dataflow

fixed `F[j]` or secret-dependent X -\> subtract exact-width mask -\> public centered d -\> repeated constraint aggregation

- **Source:** long-term coefficient or rounding intermediate

- **Sink:** public reconstruction

- **Outcome:** progressive statistical disclosure

**Rounding opens difference against an exactly B-bit mask** — `ishare.rs:1163-1189`

The mask spans only `[0,2^B)`, and the protocol reconstructs the signed field difference. Without security slack, its distribution depends on `X`.

```rust
// 2. maska r ∈ [0, 2^W)
let mut r_p_shares = vec![0u64; n];
let mut pow2 = 1u64;
for _ in 0..w {
    let (mg, mp) = paired_bit_mask_prss_src(src, xs_p, xs_gf, k, cost)?;
    r_p_shares = r_p_shares.iter().zip(&mp)
        .map(|(a, b)| p_add(*a, p_mul(*b, pow2))).collect();
    r_bits_gf.push(mg);
    pow2 = p_mul(pow2, 2);
}
let d_shares: Vec<u64> = x_off.iter().zip(&r_p_shares)
    .map(|(a, b)| p_sub(*a, *b)).collect();
let d_i = ireconstruct_val(xs_p, &d_shares)?;
```

**F-bound proof repeats the same exact-width construction** — `ishare.rs:2026-2053`

The range proof sets `B=17` for fixed trapdoor coefficients and publicly obtains the same secret-shifted difference.

```rust
let x_off: Vec<u64> = v.iter().map(|&s| p_add(s, i64_to_p(off as i64))).collect();
// 2. maska r ∈ [0, 2^B)
let mut r_p_shares = vec![0u64; n];
for _ in 0..b {
    let (mg, mp) = paired_bit_mask_prss(rng, xs_p, xs_gf, k, cost)?;
    r_p_shares = r_p_shares.iter().zip(&mp)
        .map(|(a, c)| p_add(*a, p_mul(*c, pow2))).collect();
    r_bits_gf.push(mg);
    pow2 = p_mul(pow2, 2);
}
let d_shares: Vec<u64> = x_off.iter().zip(&r_p_shares)
    .map(|(a, c)| p_sub(*a, *c)).collect();
let d_i = ireconstruct_val(xs_p, &d_shares)?;
```

**G2 authenticates but still reveals the difference** — `ishare.rs:2506-2545`

The MAC prevents unauthenticated alteration but does not widen the mask or hide the reconstructed distribution.

```rust
// 2. maska r ∈ [0, 2^W) z MAC
// ... build B-bit r and its MAC ...
let d_mac_shares: Vec<ZpMacShare> = x_off.iter()
    .zip(&x_off_mac).zip(&r_p_shares).zip(&r_p_mac).zip(xs_p)
    .map(|((((xo, xm), rp), rm), &x)| ZpMacShare {
        x, share: p_sub(*xo, *rp), mac: p_sub(*xm, *rm),
    }).collect();
let d_i = zp_open_with_mac_hidden_delta(&d_mac_shares, delta, k)?;
```

**Every G2 signature reruns the bound proof** — `ishare.rs:3184-3189`

Each signing call emits fresh `d` samples shifted by the same long-lived `F` coefficients, enabling transcript accumulation.

```rust
if t.len() != FT1536_N {
    return Err(SpikeError::PartyCountMismatch);
}
check_xs_p(xs, k)?;
validate_f_bound_shares(rng, &gt.td.f_big, xs, k)?;
```

**F-bound proof repeats the same bounded-mask opening** — `ishare.rs:2026-2050`

The range proof applies the same construction to a fixed trapdoor coefficient `v`, leaking one new shifted-support sample per invocation.

```rust
let x_off: Vec<u64> = v.iter().map(|&s| p_add(s, i64_to_p(off as i64))).collect();

// 2. maska r ∈ [0, 2^B) — bity w GF(256) i Z_P (PRSS, T7.1)
let mut r_bits_gf: Vec<GfBitShares> = Vec::with_capacity(b);
let mut r_p_shares = vec![0u64; n];
let mut pow2 = 1u64;
for _ in 0..b {
    let (mg, mp) = paired_bit_mask_prss(rng, xs_p, xs_gf, k, cost)?;
    r_p_shares = r_p_shares
        .iter()
        .zip(&mp)
        .map(|(a, c)| p_add(*a, p_mul(*c, pow2)))
        .collect();
    r_bits_gf.push(mg);
    pow2 = p_mul(pow2, 2);
}
let d_shares: Vec<u64> = x_off
    .iter()
    .zip(&r_p_shares)
    .map(|(a, c)| p_sub(*a, *c))
    .collect();
cost.bit_opens += 1;
let d_i = ireconstruct_val(xs_p, &d_shares)?;
```

**Every G2 signature rechecks all F coefficients** — `ishare.rs:3183-3190`

The long-term `F` sharing is subjected to 1536 fresh secret-dependent openings for each signing invocation, enabling repeated-transcript narrowing.

```rust
if t.len() != FT1536_N {
    return Err(SpikeError::PartyCountMismatch);
}
check_xs_p(xs, k)?;
// T9.2: range proof max|F| < q/2 — druga linia obrony (obok deal/DKG).
validate_f_bound_shares(rng, &gt.td.f_big, xs, k)?;
let mut cost = SignCost::default();
```

**Same-width mask** — `ishare.rs:1160-1177`

`X` and `r` have the same W-bit range; no statistical slack is added.

```rust
let x_off: Vec<u64> = x_noised.iter().map(|&s| p_add(s, i64_to_p(off as i64))).collect();
let mut r_p_shares = vec![0u64; n];
for _ in 0..w {
    let (mg, mp) = paired_bit_mask_prss_src(src, xs_p, xs_gf, k, cost)?;
    r_p_shares = r_p_shares.iter().zip(&mp)
        .map(|(a, b)| p_add(*a, p_mul(*b, pow2))).collect();
    r_bits_gf.push(mg);
    pow2 = p_mul(pow2, 2);
}
```

**Difference is opened** — `ishare.rs:1179-1189`

Centered reconstruction exposes sign and magnitude of `X-r`, whose support shifts with secret `X`.

```rust
let d_shares: Vec<u64> = x_off.iter().zip(&r_p_shares)
    .map(|(a, b)| p_sub(*a, *b)).collect();
cost.bit_opens += 1;
let d_i = ireconstruct_val(xs_p, &d_shares)?;
let d_twos = d_i.rem_euclid(1i64 << (w + 1)) as u64;
```

**Range proof repeats disclosure** — `ishare.rs:2026-2050`

Every protected F coefficient uses the same shifted bounded-mask transcript.

```rust
let x_off: Vec<u64> = v.iter().map(|&s| p_add(s, i64_to_p(off as i64))).collect();
let d_shares: Vec<u64> = x_off.iter().zip(&r_p_shares)
    .map(|(a, c)| p_sub(*a, *c)).collect();
cost.bit_opens += 1;
let d_i = ireconstruct_val(xs_p, &d_shares)?;
```

**Authenticated path opens same value** — `ishare.rs:2528-2545`

The MAC authenticates but does not hide secret-dependent `d`.

```rust
let d_mac_shares: Vec<ZpMacShare> = x_off.iter().zip(&x_off_mac)
    .zip(&r_p_shares).zip(&r_p_mac).zip(xs_p)
    .map(|((((xo, xm), rp), rm), &x)| ZpMacShare {
        x, share: p_sub(*xo, *rp), mac: p_sub(*xm, *rm),
    }).collect();
let d_i = zp_open_with_mac_hidden_delta(&d_mac_shares, delta, k)?;
```

**Mask has exactly W secret bits** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:1163-1177`

The hidden operand `X` is W bits, and the mask is independently assembled from exactly W bits, leaving no wider statistical hiding domain.

```rust
// 2. maska r ∈ [0, 2^W)
let mut r_bits_gf: Vec<GfBitShares> = Vec::with_capacity(w);
let mut r_p_shares = vec![0u64; n];
let mut pow2 = 1u64;
for _ in 0..w {
    let (mg, mp) = paired_bit_mask_prss_src(src, xs_p, xs_gf, k, cost)?;
    r_p_shares = r_p_shares.iter().zip(&mp)
        .map(|(a, b)| p_add(*a, p_mul(*b, pow2))).collect();
    r_bits_gf.push(mg);
    pow2 = p_mul(pow2, 2);
}
```

**Exact masked difference is reconstructed** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:1179-1189`

Participants reconstruct `d=X-r`; because both terms are bounded below `2^W`, its signed value exposes an operand-dependent distribution before the two's-complement conversion.

```rust
let d_shares: Vec<u64> = x_off.iter().zip(&r_p_shares)
    .map(|(a, b)| p_sub(*a, *b)).collect();
cost.bit_opens += 1;
let d_i = ireconstruct_val(xs_p, &d_shares)?;
let d_twos = d_i.rem_euclid(1i64 << (w + 1)) as u64;
```

**G2 authenticates but still reveals the same difference** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:2528-2545`

The G2 path checks integrity of the opening but reveals the identical `X-r` value, so the MAC does not restore confidentiality.

```rust
let d_mac_shares: Vec<ZpMacShare> = x_off.iter()
    .zip(&x_off_mac).zip(&r_p_shares).zip(&r_p_mac).zip(xs_p)
    .map(|((((xo, xm), rp), rm), &x)| ZpMacShare {
        x, share: p_sub(*xo, *rp), mac: p_sub(*xm, *rm),
    }).collect();
cost.bit_opens += 1;
let d_i = zp_open_with_mac_hidden_delta(&d_mac_shares, delta, k)?;
let d_twos = d_i.rem_euclid(1i64 << (w + 1)) as u64;
```

#### Reachability

Requires a distributed embedding where a participant sees repeated openings; no transport is in scope.

- **Attacker:** protocol participant or transcript observer

- **Entry point:** bit-decomposition and F-bound openings

- **Outcome:** accumulated information about secrets

Preconditions:
- Same F sharing is reused.
- Observer sees repeated differences.
- Path used beyond isolated synthetic tests.
- Attacker observes openings.

Limitations:
- Prototype status reduces final severity.

#### Severity

**Medium** — The transcript violates the stated secrecy boundary and repeated openings can statistically reveal fixed trapdoor-dependent values, but the scoped source provides neither a deployed distributed transcript nor an end-to-end key-recovery demonstration.

Raise if transcript collection demonstrates practical recovery of `F` or signing intermediates; lower if a proof establishes statistical hiding under the exact field/range model or openings are confined to one trusted process.

Impact assessment:
- **Level:** high
- **Why:** Sufficient recovery of trapdoor values could undermine threshold confidentiality and signature security.

Likelihood assessment:
- **Level:** unknown
- **Why:** No sample-complexity or deployed transcript evidence is available.

#### Remediation

Use a proven statistically hiding bit-decomposition/range-proof protocol with a full-field or `B+κ` mask and explicit proven carry/wrap handling. Do not rerun a secret-dependent proof for the same long-term `F` on every signature; validate setup once and carry an opaque verified type.

Tests:
- Compare transcript distributions for multiple fixed secret values over large samples and require a bound consistent with the stated statistical security parameter.
- Add boundary tests around minimum/maximum X and field wrap cases under the revised protocol.
- Cache or bind a one-time verified F-bound state so signing does not re-open a proof for every signature.
- Generate transcripts for two distinct fixed secrets and statistically test that the opened distributions are indistinguishable at the target security level.
- Simulate repeated openings for a fixed coefficient and assert interval intersection does not narrow the secret.
- Assert the signing API consumes setup-validated `F` without re-running the range proof.
- Exhaustively compare reduced-width transcript distributions for every X and enforce the specified statistical-distance bound.
- Cover rounding, F-bound, and G-2 variants.
- For multiple fixed `X` values, statistically test that public transcript distributions are indistinguishable at the claimed security level.
- Assert range-proof and rounding outputs remain correct across wrap/carry boundaries without revealing exact signed differences.

Preventive controls:
- Document and enforce a concrete statistical security parameter κ.
- Require protocol proofs/tests for transcript privacy separately from arithmetic correctness and MAC integrity.
- Require a reviewed range-proof primitive rather than ad hoc masked opening.
- Document and enforce transcript privacy and session-use limits.
- Bind successful setup validation into a non-forgeable checked trapdoor type.
- Centralize masked bit decomposition in one reviewed primitive.
- Fix and document a statistical security parameter.
- Require a protocol proof and explicit leakage budget for every opened masked value.

<a id="finding-5"></a>

### [5] Deterministic signing paths replace randomized lattice sampling and expose trapdoor-dependent outputs

| Field | Value |
| --- | --- |
| Severity | medium |
| Confidence | high |
| Confidence rationale | The deterministic dataflow is explicit in source; confidence in exact cryptanalytic exploitability is lower and stated as a limitation. |
| Category | Use of deterministic non-cryptographic randomness substitute in lattice signature sampling |
| CWE | CWE-338 |
| Affected lines | mpc_sign.rs:1385-1399, mpc_sign.rs:1402-1424, mpc_sign.rs:1516-1555, ishare.rs:1398-1410, ishare.rs:1482-1497, ishare.rs:1522-1526 |

#### Summary

`sample_z_ffsampling()` has no RNG and deterministically rounds `t*f/q` and `-t*F/q` in the clear/share-ceremony signing paths. Separately, public share-signing APIs accept `gauss_sigma: None`, disable Gaussian perturbation, perform deterministic Babai-style rounding, and open `s1`/`s2`; comments identify the retained leak and tests produce engine-valid outputs. Correct verification, MPC masks that cancel, and norm bounds do not supply the randomized key-hiding distribution required for lattice signing.

#### Root Cause

Multiple public signing paths expose test/prototype nearest-plane rounding as a usable signing sampler: one sampler is intrinsically deterministic and another makes Gaussian noise optional. Both emit public signatures whose mathematical output retains deterministic trapdoor-dependent relationships.

**Sampler deterministically rounds secret products** — `mpc_sign.rs:1385-1399`

There is no fresh randomness input: public `t` and the long-term trapdoor uniquely determine both `z` polynomials.

```rust
pub fn sample_z_ffsampling(
    td: &TrapdoorClear,
    t: &[u16],
) -> Result<(Vec<i64>, Vec<i64>)> {
    if t.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    let t64 = poly_u16_centered_i64(t);
    let tf = mul_ring_i64_i64(&t64, &poly_u16_centered_i64(&td.f));
    let t_f_big = mul_ring_i64_i64(&t64, &poly_u16_centered_i64(&td.f_big));
    let z1: Vec<i64> = tf.iter().map(|&c| round_div_q_scalar(c)).collect();
    let z0: Vec<i64> = t_f_big.iter().map(|&c| -round_div_q_scalar(c)).collect();
    Ok((z0, z1))
}
```

**Clear signing consumes deterministic z values** — `mpc_sign.rs:1402-1424`

The deterministic secret-dependent values flow directly into the publicly returned signature polynomials.

```rust
pub fn trapdoor_sign_ffsampling(
    td: &TrapdoorClear,
    t: &[u16],
) -> Result<(QPoly, QPoly, u64)> {
    let (z0, z1) = sample_z_ffsampling(td, t)?;
    // ring products omitted
    let s1 = i64_to_qpoly(&s1_i);
    let s2 = i64_to_qpoly(&s2_i);
    let n = poly_norm2_centered(&s1) + poly_norm2_centered(&s2);
    Ok((s1, s2, n))
}
```

**Share ceremony reconstructs f,F and calls the same deterministic sampler** — `mpc_sign.rs:1532-1555`

The threshold-style ceremony invokes the same deterministic function and ultimately opens `s1` and `s2`; its RNG parameter does not randomize z.

```rust
let (z0, z1) = {
    let mut f_c = q_reconstruct_poly(&td.f, xs)?;
    let mut f_big_c = q_reconstruct_poly(&td.f_big, xs)?;
    let mut td_z = TrapdoorClear {
        f: std::mem::take(&mut f_c),
        g: vec![0u16; FT1536_N],
        f_big: std::mem::take(&mut f_big_c),
        g_big: vec![0u16; FT1536_N],
    };
    let r = sample_z_ffsampling(&td_z, t);
    // zeroization omitted
    r?
};
let (s1s, s2s) = trapdoor_sign_ffsampling_shares(rng, td, t, &z0, &z1, xs, k)?;
let s1 = q_reconstruct_poly(&s1s, xs)?;
let s2 = q_reconstruct_poly(&s2s, xs)?;
```

**Public API exposes deterministic mode** — `ishare.rs:1398-1410`

Any library caller can select the branch that the source calls a retained Babai leak.

```rust
/// `gauss_sigma`: `Some(σ)` = tajny szum DGDG(σ) w liczniku przed round
/// (T6/R-G2-1, domyślnie `T6_GAUSS_SIGMA_DEFAULT`); `None` = tor
/// deterministyczny (retained F2 — Babai leak pozostaje, tylko do testów).
pub fn mps4h_sign_shares(
    rng: &mut impl rand::RngCore,
    td: &ITrapdoorShares,
    t: &[u16],
    xs: &[u16],
    k: u8,
    bits_tf: u32,
    bits_tf_big: u32,
    gauss_sigma: Option<u8>,
) -> Result<(Vec<i64>, Vec<i64>, SignCost)> {
```

**None removes both noise polynomials** — `ishare.rs:1482-1497`

With `None`, the sampler performs deterministic rounding of the trapdoor-dependent `t·f` and `-t·F` shares.

```rust
let (g1, g0) = match gauss_sigma {
    Some(sigma) => (
        Some(prss_dgdg_poly_shares_src(src, sigma, xs, k, FT1536_N)?),
        Some(prss_dgdg_poly_shares_src(src, sigma, xs, k, FT1536_N)?),
    ),
    None => (None, None),
};

let t_f_big_neg: IPolyShares = t_f_big
    .iter()
    .map(|col| col.iter().map(|&s| p_sub(0, s)).collect())
    .collect();
let (z1, c1) = round_div_q_shares_src(src, &tf, xs, k, bits_tf, g1.as_ref())?;
let (z0, c2) = round_div_q_shares_src(src, &t_f_big_neg, xs, k, bits_tf_big, g0.as_ref())?;
```

**Deterministic result is opened** — `ishare.rs:1522-1526`

The basis-dependent deterministic computation crosses the public signature boundary.

```rust
// Open s1, s2 (podpis jawny) — to JEDYNE otwarcie w ścieżce sign.
let s1_i = ireconstruct_poly_i64(&s1, xs)?;
let s2_i = ireconstruct_poly_i64(&s2, xs)?;
let _ = (tg, t_g_big);
Ok((s1_i, s2_i, cost))
```

#### Validation

Both implementations have explicit deterministic dataflow into public signature components; the exact practical key-recovery attack and sample complexity remain unestablished.

Validation method: static source trace and API comparison

**Sampler deterministically rounds secret products** — `mpc_sign.rs:1385-1399`

There is no fresh randomness input: public `t` and the long-term trapdoor uniquely determine both `z` polynomials.

```rust
pub fn sample_z_ffsampling(
    td: &TrapdoorClear,
    t: &[u16],
) -> Result<(Vec<i64>, Vec<i64>)> {
    if t.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    let t64 = poly_u16_centered_i64(t);
    let tf = mul_ring_i64_i64(&t64, &poly_u16_centered_i64(&td.f));
    let t_f_big = mul_ring_i64_i64(&t64, &poly_u16_centered_i64(&td.f_big));
    let z1: Vec<i64> = tf.iter().map(|&c| round_div_q_scalar(c)).collect();
    let z0: Vec<i64> = t_f_big.iter().map(|&c| -round_div_q_scalar(c)).collect();
    Ok((z0, z1))
}
```

**Clear signing consumes deterministic z values** — `mpc_sign.rs:1402-1424`

The deterministic secret-dependent values flow directly into the publicly returned signature polynomials.

```rust
pub fn trapdoor_sign_ffsampling(
    td: &TrapdoorClear,
    t: &[u16],
) -> Result<(QPoly, QPoly, u64)> {
    let (z0, z1) = sample_z_ffsampling(td, t)?;
    // ring products omitted
    let s1 = i64_to_qpoly(&s1_i);
    let s2 = i64_to_qpoly(&s2_i);
    let n = poly_norm2_centered(&s1) + poly_norm2_centered(&s2);
    Ok((s1, s2, n))
}
```

**Share ceremony reconstructs f,F and calls the same deterministic sampler** — `mpc_sign.rs:1532-1555`

The threshold-style ceremony invokes the same deterministic function and ultimately opens `s1` and `s2`; its RNG parameter does not randomize z.

```rust
let (z0, z1) = {
    let mut f_c = q_reconstruct_poly(&td.f, xs)?;
    let mut f_big_c = q_reconstruct_poly(&td.f_big, xs)?;
    let mut td_z = TrapdoorClear {
        f: std::mem::take(&mut f_c),
        g: vec![0u16; FT1536_N],
        f_big: std::mem::take(&mut f_big_c),
        g_big: vec![0u16; FT1536_N],
    };
    let r = sample_z_ffsampling(&td_z, t);
    // zeroization omitted
    r?
};
let (s1s, s2s) = trapdoor_sign_ffsampling_shares(rng, td, t, &z0, &z1, xs, k)?;
let s1 = q_reconstruct_poly(&s1s, xs)?;
let s2 = q_reconstruct_poly(&s2s, xs)?;
```

**Public API exposes deterministic mode** — `ishare.rs:1398-1410`

Any library caller can select the branch that the source calls a retained Babai leak.

```rust
/// `gauss_sigma`: `Some(σ)` = tajny szum DGDG(σ) w liczniku przed round
/// (T6/R-G2-1, domyślnie `T6_GAUSS_SIGMA_DEFAULT`); `None` = tor
/// deterministyczny (retained F2 — Babai leak pozostaje, tylko do testów).
pub fn mps4h_sign_shares(
    rng: &mut impl rand::RngCore,
    td: &ITrapdoorShares,
    t: &[u16],
    xs: &[u16],
    k: u8,
    bits_tf: u32,
    bits_tf_big: u32,
    gauss_sigma: Option<u8>,
) -> Result<(Vec<i64>, Vec<i64>, SignCost)> {
```

**None removes both noise polynomials** — `ishare.rs:1482-1497`

With `None`, the sampler performs deterministic rounding of the trapdoor-dependent `t·f` and `-t·F` shares.

```rust
let (g1, g0) = match gauss_sigma {
    Some(sigma) => (
        Some(prss_dgdg_poly_shares_src(src, sigma, xs, k, FT1536_N)?),
        Some(prss_dgdg_poly_shares_src(src, sigma, xs, k, FT1536_N)?),
    ),
    None => (None, None),
};

let t_f_big_neg: IPolyShares = t_f_big
    .iter()
    .map(|col| col.iter().map(|&s| p_sub(0, s)).collect())
    .collect();
let (z1, c1) = round_div_q_shares_src(src, &tf, xs, k, bits_tf, g1.as_ref())?;
let (z0, c2) = round_div_q_shares_src(src, &t_f_big_neg, xs, k, bits_tf_big, g0.as_ref())?;
```

**Deterministic result is opened** — `ishare.rs:1522-1526`

The basis-dependent deterministic computation crosses the public signature boundary.

```rust
// Open s1, s2 (podpis jawny) — to JEDYNE otwarcie w ścieżce sign.
let s1_i = ireconstruct_poly_i64(&s1, xs)?;
let s2_i = ireconstruct_poly_i64(&s2, xs)?;
let _ = (tg, t_g_big);
Ok((s1_i, s2_i, cost))
```

Assertions:
- Fresh signing randomness cannot affect `z0`/`z1` in this path.
- Existing tests establish equation/norm/engine acceptance, not Gaussian distribution or multi-signature key hiding.
- `None` is public and not gated by `cfg(test)`.
- The output is deterministic for fixed target and trapdoor apart from internal masks that cancel.

Counterevidence and remaining uncertainty:
- Comments label the path level A and acknowledge simplified sampling elsewhere.
- No concrete FT1536 trapdoor-recovery proof or runtime reproduction was performed.

Limitations:
- The exact number of transcripts needed for exploitation is unknown.
- No runtime cryptanalysis or sample-count estimate was performed.
- The optional noisy path is not thereby proven secure.

#### Dataflow

public challenge `t` + long-term `f,F` -\> deterministic rounded `z0,z1` -\> ring products -\> public/opened `s1,s2`

- **Source:** Public per-signature challenge and fixed secret trapdoor

- **Sink:** Returned signature polynomials

- **Outcome:** Key-dependent deterministic transcript distribution

**Sampler deterministically rounds secret products** — `mpc_sign.rs:1385-1399`

There is no fresh randomness input: public `t` and the long-term trapdoor uniquely determine both `z` polynomials.

```rust
pub fn sample_z_ffsampling(
    td: &TrapdoorClear,
    t: &[u16],
) -> Result<(Vec<i64>, Vec<i64>)> {
    if t.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    let t64 = poly_u16_centered_i64(t);
    let tf = mul_ring_i64_i64(&t64, &poly_u16_centered_i64(&td.f));
    let t_f_big = mul_ring_i64_i64(&t64, &poly_u16_centered_i64(&td.f_big));
    let z1: Vec<i64> = tf.iter().map(|&c| round_div_q_scalar(c)).collect();
    let z0: Vec<i64> = t_f_big.iter().map(|&c| -round_div_q_scalar(c)).collect();
    Ok((z0, z1))
}
```

**Clear signing consumes deterministic z values** — `mpc_sign.rs:1402-1424`

The deterministic secret-dependent values flow directly into the publicly returned signature polynomials.

```rust
pub fn trapdoor_sign_ffsampling(
    td: &TrapdoorClear,
    t: &[u16],
) -> Result<(QPoly, QPoly, u64)> {
    let (z0, z1) = sample_z_ffsampling(td, t)?;
    // ring products omitted
    let s1 = i64_to_qpoly(&s1_i);
    let s2 = i64_to_qpoly(&s2_i);
    let n = poly_norm2_centered(&s1) + poly_norm2_centered(&s2);
    Ok((s1, s2, n))
}
```

**Share ceremony reconstructs f,F and calls the same deterministic sampler** — `mpc_sign.rs:1532-1555`

The threshold-style ceremony invokes the same deterministic function and ultimately opens `s1` and `s2`; its RNG parameter does not randomize z.

```rust
let (z0, z1) = {
    let mut f_c = q_reconstruct_poly(&td.f, xs)?;
    let mut f_big_c = q_reconstruct_poly(&td.f_big, xs)?;
    let mut td_z = TrapdoorClear {
        f: std::mem::take(&mut f_c),
        g: vec![0u16; FT1536_N],
        f_big: std::mem::take(&mut f_big_c),
        g_big: vec![0u16; FT1536_N],
    };
    let r = sample_z_ffsampling(&td_z, t);
    // zeroization omitted
    r?
};
let (s1s, s2s) = trapdoor_sign_ffsampling_shares(rng, td, t, &z0, &z1, xs, k)?;
let s1 = q_reconstruct_poly(&s1s, xs)?;
let s2 = q_reconstruct_poly(&s2s, xs)?;
```

#### Reachability

Public library signing methods directly expose this path; practical key recovery is not established.

- **Attacker:** Signature recipient or chosen-message caller

- **Entry point:** Repeated calls under one trapdoor

- **Outcome:** Loss of the intended key-hiding sampling guarantee

#### Severity

**Medium** — The wrong distribution and retained deterministic Babai branch can expose repeated key-dependent observations and invalidate the intended signing-security argument, but a concrete FT1536 basis-recovery exploit is not proved and the code is described as prototype/test-oriented.

Raise if multi-signature analysis demonstrates practical trapdoor recovery or a real deployment permits deterministic signing; lower only when deterministic branches are test-only and production signing requires a validated randomized sampler.

Impact assessment:
- **Level:** high
- **Why:** If exploitable, trapdoor recovery permits signature forgery; at minimum the claimed sampler security is absent.

Likelihood assessment:
- **Level:** unknown
- **Why:** Cryptanalytic extraction for this FT1536 prototype was not demonstrated.

#### Remediation

Remove deterministic/`None` sampler modes from externally usable signing APIs and gate any measurement helper to tests. Require a mandatory, analyzed FT1536 randomized discrete-Gaussian/preimage sampler with fresh independent party entropy, correct FFT3/LDL geometry, and fail-closed entropy/sampler validation.

Tests:
- Test distributional moments/tails against the specified sampler separately from equation and norm correctness.
- Assert independent entropy changes `z` for repeated identical key/challenge inputs while every output still verifies.
- Add a multi-signature leakage analysis/regression corpus for chosen and repeated messages.
- Compile-time test that production signing has no deterministic sampler variant.
- Repeated-signature statistical regression plus validation against the intended distribution, not only norm and verification checks.

Preventive controls:
- Keep correctness, norm, distribution and key-hiding tests as separate acceptance gates.
- Type or feature-gate level-A measurement helpers so production signing APIs cannot call them.
- Use a dedicated validated sampler type rather than `Option<u8>`.
- Fail closed if entropy or sampler validation is unavailable.

<a id="finding-6"></a>

### [6] Byte-sized Pedersen blinding lets observers recover committed secret bytes

| Field | Value |
| --- | --- |
| Severity | medium |
| Confidence | high |
| Confidence rationale | The exact coefficient domains and commitment equation are explicit in source; exhaustive recovery requires only 2^16 public point computations and no unverified deployment assumption for the cryptographic break. |
| Category | Insufficient entropy in cryptographic blinding |
| CWE | CWE-326 |
| Affected lines | pedersen.rs:39-45, pedersen.rs:97-115, pedersen.rs:119-141, bin/iso.rs:1407-1413, proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/pedersen.rs:96-103, proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/pedersen.rs:106-115, proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/pedersen.rs:118-129 |

#### Summary

The byte-oriented Pedersen VSS samples both message and blinding polynomial coefficients as `u8`. Every public coefficient commitment `a·G+r·H` therefore has at most 65,536 candidate pairs, allowing an observer to recover the committed byte by offline comparison; the runnable pipeline applies the construction to `seed[0]`.

#### Root Cause

Pedersen hiding requires a high-entropy unknown blinding scalar even when the message is small. This implementation restricts both message and blind coefficients to `u8` and embeds them directly in the public curve equation, reducing each coefficient opening to exhaustive comparison over 65,536 point pairs.

**Runnable pipeline commits the first seed byte** — `bin/iso.rs:1407-1413`

The CLI passes a genuine random seed byte into the weak byte-blinded commitment, establishing an in-scope consumer of the broken hiding property.

```rust
let mut seed = [0u8; 32];
std::fs::File::open("/dev/urandom").unwrap().read_exact(&mut seed).unwrap();

// 1) Pedersen: deal exp-shares + weryfikacja (H1)
let (comms, exp) = ft1536_threshold_spike::pedersen::deal_exp_shares(&mut StdRngOs, seed[0], &xs, k);
for sh in &exp {
    ft1536_threshold_spike::pedersen::verify_exp_share(sh, &comms).expect("pedersen verify");
}
```

**Secret and blind polynomials store byte coefficients** — `pedersen.rs:39-45`

Both the message and blinding polynomials are restricted to byte coefficients, limiting each constant term to 256 possibilities.

```rust
pub struct Poly {
    coeffs: Vec<u8>, // bajty 0..255 → Scalar
}

impl Poly {
    pub fn from_coeffs(coeffs: Vec<u8>) -> Self {
        Self { coeffs }
    }
```

**Random polynomial coefficients are sampled from eight bits** — `pedersen.rs:97-103`

The polynomial generator preserves a byte-sized constant and samples every other coefficient from only eight bits.

```rust
pub fn random_poly(rng: &mut impl RngCore, secret_byte: u8, k: u8) -> Poly {
    let mut coeffs = Vec::with_capacity(k as usize);
    coeffs.push(secret_byte);
    for _ in 1..k {
        coeffs.push((rng.next_u32() & 0xFF) as u8);
    }
    Poly::from_coeffs(coeffs)
}
```

**Dealer chooses the constant blind from one byte** — `pedersen.rs:119-129`

The constant blinding coefficient is explicitly reduced to eight bits before creating the public commitment.

```rust
pub fn deal_exp_shares(
    rng: &mut impl RngCore,
    secret_byte: u8,
    xs: &[u8],
    k: u8,
) -> (PedersenCommitments, Vec<ExpShare>) {
    assert!(k >= 2);
    let secret = random_poly(rng, secret_byte, k);
    let blind_byte = (rng.next_u32() & 0xFF) as u8;
    let blind = random_poly(rng, blind_byte, k);
    let comms = commit(&secret, &blind);
```

**Commitment embeds small coefficients directly as scalars** — `pedersen.rs:106-115`

For the constant commitment, an observer can enumerate every byte `a` and byte `r` and compare the resulting public point; discrete-log hardness does not protect this 2^16 search.

```rust
pub fn commit(secret: &Poly, blind: &Poly) -> PedersenCommitments {
    let h = pedersen_h();
    let cs = secret
        .coeffs
        .iter()
        .zip(blind.coeffs.iter())
        .map(|(&a, &r)| G * Scalar::from(a as u64) + h * Scalar::from(r as u64))
        .collect();
    PedersenCommitments { commitments: cs }
}
```

**Polynomial coefficients are one byte** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/pedersen.rs:96-103`

Every message or random polynomial coefficient has only 256 possibilities.

```rust
pub fn random_poly(rng: &mut impl RngCore, secret_byte: u8, k: u8) -> Poly {
    let mut coeffs = Vec::with_capacity(k as usize);
    coeffs.push(secret_byte);
    for _ in 1..k {
        coeffs.push((rng.next_u32() & 0xFF) as u8);
    }
    Poly::from_coeffs(coeffs)
}
```

**Blinding polynomial is seeded and sampled in the same byte domain** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/pedersen.rs:118-129`

The constant blinding coefficient and all higher blinding coefficients are limited to eight bits.

```rust
let secret = random_poly(rng, secret_byte, k);
let blind_byte = (rng.next_u32() & 0xFF) as u8;
let blind = random_poly(rng, blind_byte, k);
let comms = commit(&secret, &blind);
```

**Commitment exposes the small two-dimensional search** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/pedersen.rs:106-115`

An observer can enumerate every byte `a` and byte `r` and compare the resulting Ristretto point.

```rust
let cs = secret.coeffs.iter().zip(blind.coeffs.iter())
    .map(|(&a, &r)| G * Scalar::from(a as u64) + h * Scalar::from(r as u64))
    .collect();
```

#### Validation

Each public commitment has exactly 256 possible message coefficients times 256 possible blinding coefficients; independent generators do not prevent exhaustive comparison. The separate Z_P VSS uses a different wider domain and is outside this finding.

Validation method: Static cryptographic source analysis; static cryptographic search-space analysis

**Secret and blind polynomials store byte coefficients** — `pedersen.rs:39-45`

Both the message and blinding polynomials are restricted to byte coefficients, limiting each constant term to 256 possibilities.

```rust
pub struct Poly {
    coeffs: Vec<u8>, // bajty 0..255 → Scalar
}

impl Poly {
    pub fn from_coeffs(coeffs: Vec<u8>) -> Self {
        Self { coeffs }
    }
```

**Random polynomial coefficients are sampled from eight bits** — `pedersen.rs:97-103`

The polynomial generator preserves a byte-sized constant and samples every other coefficient from only eight bits.

```rust
pub fn random_poly(rng: &mut impl RngCore, secret_byte: u8, k: u8) -> Poly {
    let mut coeffs = Vec::with_capacity(k as usize);
    coeffs.push(secret_byte);
    for _ in 1..k {
        coeffs.push((rng.next_u32() & 0xFF) as u8);
    }
    Poly::from_coeffs(coeffs)
}
```

**Dealer chooses the constant blind from one byte** — `pedersen.rs:119-129`

The constant blinding coefficient is explicitly reduced to eight bits before creating the public commitment.

```rust
pub fn deal_exp_shares(
    rng: &mut impl RngCore,
    secret_byte: u8,
    xs: &[u8],
    k: u8,
) -> (PedersenCommitments, Vec<ExpShare>) {
    assert!(k >= 2);
    let secret = random_poly(rng, secret_byte, k);
    let blind_byte = (rng.next_u32() & 0xFF) as u8;
    let blind = random_poly(rng, blind_byte, k);
    let comms = commit(&secret, &blind);
```

**Commitment embeds small coefficients directly as scalars** — `pedersen.rs:106-115`

For the constant commitment, an observer can enumerate every byte `a` and byte `r` and compare the resulting public point; discrete-log hardness does not protect this 2^16 search.

```rust
pub fn commit(secret: &Poly, blind: &Poly) -> PedersenCommitments {
    let h = pedersen_h();
    let cs = secret
        .coeffs
        .iter()
        .zip(blind.coeffs.iter())
        .map(|(&a, &r)| G * Scalar::from(a as u64) + h * Scalar::from(r as u64))
        .collect();
    PedersenCommitments { commitments: cs }
}
```

**Runnable pipeline commits the first seed byte** — `bin/iso.rs:1407-1413`

The CLI passes a genuine random seed byte into the weak byte-blinded commitment, establishing an in-scope consumer of the broken hiding property.

```rust
let mut seed = [0u8; 32];
std::fs::File::open("/dev/urandom").unwrap().read_exact(&mut seed).unwrap();

// 1) Pedersen: deal exp-shares + weryfikacja (H1)
let (comms, exp) = ft1536_threshold_spike::pedersen::deal_exp_shares(&mut StdRngOs, seed[0], &xs, k);
for sh in &exp {
    ft1536_threshold_spike::pedersen::verify_exp_share(sh, &comms).expect("pedersen verify");
}
```

**Polynomial coefficients are one byte** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/pedersen.rs:96-103`

Every message or random polynomial coefficient has only 256 possibilities.

```rust
pub fn random_poly(rng: &mut impl RngCore, secret_byte: u8, k: u8) -> Poly {
    let mut coeffs = Vec::with_capacity(k as usize);
    coeffs.push(secret_byte);
    for _ in 1..k {
        coeffs.push((rng.next_u32() & 0xFF) as u8);
    }
    Poly::from_coeffs(coeffs)
}
```

**Blinding polynomial is seeded and sampled in the same byte domain** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/pedersen.rs:118-129`

The constant blinding coefficient and all higher blinding coefficients are limited to eight bits.

```rust
let secret = random_poly(rng, secret_byte, k);
let blind_byte = (rng.next_u32() & 0xFF) as u8;
let blind = random_poly(rng, blind_byte, k);
let comms = commit(&secret, &blind);
```

**Commitment exposes the small two-dimensional search** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/pedersen.rs:106-115`

An observer can enumerate every byte `a` and byte `r` and compare the resulting Ristretto point.

```rust
let cs = secret.coeffs.iter().zip(blind.coeffs.iter())
    .map(|(&a, &r)| G * Scalar::from(a as u64) + h * Scalar::from(r as u64))
    .collect();
```

Assertions:
- The constant secret has 256 candidates.
- The constant blind has 256 candidates.
- The public Ristretto point provides a direct candidate equality oracle.

Counterevidence and remaining uncertainty:
- `H` is derived with domain-separated SHA3-512, which does not enlarge the blind search space.
- The Z_P VSS path is not affected by this exact 2^16 enumeration.
- The module is explicitly a prototype.
- Ristretto points and canonical scalar parsing are otherwise used correctly.
- The separate Z_P VSS uses wider 61-bit coefficients and is not this finding.

Limitations:
- No enumeration program was executed, per the prohibition on target execution; the exhaustive attack follows directly from the public group equation.
- Enumeration was not executed per the no-runtime constraint.

#### Dataflow

secret byte and 8-bit blind -\> scalar embedding -\> public constant-term Ristretto commitment -\> 2^16 offline comparison

- **Source:** Public `PedersenCommitments`

- **Sink:** The constant-term commitment point

- **Outcome:** Recovery of the committed byte

**Commitment embeds small coefficients directly as scalars** — `pedersen.rs:106-115`

For the constant commitment, an observer can enumerate every byte `a` and byte `r` and compare the resulting public point; discrete-log hardness does not protect this 2^16 search.

```rust
pub fn commit(secret: &Poly, blind: &Poly) -> PedersenCommitments {
    let h = pedersen_h();
    let cs = secret
        .coeffs
        .iter()
        .zip(blind.coeffs.iter())
        .map(|(&a, &r)| G * Scalar::from(a as u64) + h * Scalar::from(r as u64))
        .collect();
    PedersenCommitments { commitments: cs }
}
```

**Runnable pipeline commits the first seed byte** — `bin/iso.rs:1407-1413`

The CLI passes a genuine random seed byte into the weak byte-blinded commitment, establishing an in-scope consumer of the broken hiding property.

```rust
let mut seed = [0u8; 32];
std::fs::File::open("/dev/urandom").unwrap().read_exact(&mut seed).unwrap();

// 1) Pedersen: deal exp-shares + weryfikacja (H1)
let (comms, exp) = ft1536_threshold_spike::pedersen::deal_exp_shares(&mut StdRngOs, seed[0], &xs, k);
for sh in &exp {
    ft1536_threshold_spike::pedersen::verify_exp_share(sh, &comms).expect("pedersen verify");
}
```

**Dealer chooses the constant blind from one byte** — `pedersen.rs:119-129`

The constant blinding coefficient is explicitly reduced to eight bits before creating the public commitment.

```rust
pub fn deal_exp_shares(
    rng: &mut impl RngCore,
    secret_byte: u8,
    xs: &[u8],
    k: u8,
) -> (PedersenCommitments, Vec<ExpShare>) {
    assert!(k >= 2);
    let secret = random_poly(rng, secret_byte, k);
    let blind_byte = (rng.next_u32() & 0xFF) as u8;
    let blind = random_poly(rng, blind_byte, k);
    let comms = commit(&secret, &blind);
```

**Polynomial coefficients are one byte** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/pedersen.rs:96-103`

Every message or random polynomial coefficient has only 256 possibilities.

```rust
pub fn random_poly(rng: &mut impl RngCore, secret_byte: u8, k: u8) -> Poly {
    let mut coeffs = Vec::with_capacity(k as usize);
    coeffs.push(secret_byte);
    for _ in 1..k {
        coeffs.push((rng.next_u32() & 0xFF) as u8);
    }
    Poly::from_coeffs(coeffs)
}
```

**Blinding polynomial is seeded and sampled in the same byte domain** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/pedersen.rs:118-129`

The constant blinding coefficient and all higher blinding coefficients are limited to eight bits.

```rust
let secret = random_poly(rng, secret_byte, k);
let blind_byte = (rng.next_u32() & 0xFF) as u8;
let blind = random_poly(rng, blind_byte, k);
let comms = commit(&secret, &blind);
```

**Commitment exposes the small two-dimensional search** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/pedersen.rs:106-115`

An observer can enumerate every byte `a` and byte `r` and compare the resulting Ristretto point.

```rust
let cs = secret.coeffs.iter().zip(blind.coeffs.iter())
    .map(|(&a, &r)| G * Scalar::from(a as u64) + h * Scalar::from(r as u64))
    .collect();
```

#### Reachability

Any caller or protocol observer that receives the public commitments can perform the comparison without participant credentials or discrete-log computation.

- **Attacker:** Observer of the public VSS commitment

- **Entry point:** `deal_exp_shares()` / `commit()` output

- **Outcome:** Disclosure of the committed seed or key byte

Limitations:
- The in-scope pipeline commits only `seed[0]`; disclosure of an entire seed requires repeated use of the same API.

#### Severity

**Medium** — The attack is offline, deterministic, and cheap once a commitment is visible, so likelihood is high. The in-scope runnable pipeline commits one seed byte and the API can be repeated bytewise, but no production deployment or full-seed commitment workflow is established.

Raise severity if the byte VSS is used across an entire production seed/key or its commitments are broadly exposed; lower it if the API remains an isolated non-security demonstration with no secret commitment consumers.

Impact assessment:
- **Level:** medium
- **Why:** The hiding property fails completely for each byte committed with this API; the runnable path demonstrates one real seed byte.

Likelihood assessment:
- **Level:** high
- **Why:** The search is fixed at 65,536 public computations.

#### Remediation

Use a uniformly sampled full-width Ristretto `Scalar` for every Pedersen blinding coefficient and keep it in a zeroizing scalar/canonical-byte representation. The secret byte may remain embedded as a scalar, but its blind must never be restricted to the message domain.

Tests:
- Commit each possible byte under independently sampled full-width blinds and verify that a search over all 2^16 byte/blind pairs cannot recover the message.
- Assert that serialized blinding coefficients carry full scalar entropy rather than `u8` values.
- Add a regression analysis ensuring the blinding space is at least the intended security level and cannot be exhaustively enumerated.
- Verify commitments and shares still round-trip with full-field blinds.

Preventive controls:
- Separate message encoding types from cryptographic blinding-scalar types.
- Require a cryptographically secure RNG at the Pedersen dealer boundary and sample with the curve library's scalar API.
- Do not reuse narrow message types for cryptographic randomness.

<a id="finding-7"></a>

### [7] G2 signing consumes trapdoor shares without enforcing their VSS commitments

| Field | Value |
| --- | --- |
| Severity | medium |
| Confidence | high |
| Confidence rationale | The fixed prefix length, absent verifier call, mutable public share fields and manual-only test pattern are direct source facts. |
| Category | Missing verification of cryptographic commitment |
| CWE | CWE-345 |
| Affected lines | ishare.rs:2175-2227, ishare.rs:2688-2725, ishare.rs:3174-3210, ishare.rs:3929-3958, proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:2268-2300, proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:2688-2725, proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:3174-3209 |

#### Summary

Integrated G2 setup commits only the first 8 of 1536 coefficients of each `f`, `g`, `F`, and `G` polynomial, and verification covers only that prefix. `mps4h_sign_shares_g2()` later consumes publicly mutable trapdoor matrices without re-running VSS, so suffix coefficients—and post-setup changes even to committed `g`/`G` shares—can enter signing without `CommitmentMismatch`.

#### Root Cause

VSS is treated as setup metadata rather than an invariant on the exact share matrices consumed online. Only a deterministic prefix is committed, the aggregate remains mutable through public fields, and the signing entry point does not revalidate or require a checked immutable representation.

**Only a caller-selected prefix receives commitments** — `ishare.rs:2194-2222`

All coefficients at or beyond `n_vss` are ordinary Shamir sharings with no commitment material, so later mutation cannot be checked by VSS.

```rust
let n_vss = if vss_count == 0 { FT1536_N } else { vss_count.min(FT1536_N) };
let mut values = Vec::with_capacity(FT1536_N);
let mut vss_vals = Vec::with_capacity(n_vss);
let mut vss_blinds = Vec::with_capacity(n_vss);
let mut commits = Vec::with_capacity(n_vss);
for (j, &c) in p.iter().enumerate() {
    if j < n_vss {
        let (com, sh) = crate::pedersen::zp_vss_deal(rng, i64_to_p(c as i64), xs, k);
        let mut vcol = vec![0u64; n];
        let mut vvcol = vec![0u128; n];
        let mut vbcol = vec![0u128; n];
        for (i, s) in sh.into_iter().enumerate() {
            vcol[i] = (s.share % I_P as u128) as u64;
            vvcol[i] = s.share;
            vbcol[i] = s.blind;
        }
        values.push(vcol);
        vss_vals.push(vvcol);
        vss_blinds.push(vbcol);
        commits.push(com);
    } else {
        values.push(ishare_val(rng, c as i64, xs, k)?);
    }
}
```

**G2 dealer fixes the committed prefix at eight coefficients** — `ishare.rs:2688-2725`

Setup verifies only the eight committed coefficients. This establishes initial consistency but does not bind the remaining 1528 coefficients or prevent post-setup replacement.

```rust
pub const G2_VSS_SAMPLE: usize = 8;

pub fn g2_deal_trapdoor(
    rng: &mut impl rand::RngCore,
    f16: &[i16],
    g16: &[i16],
    f_big16: &[i16],
    g_big16: &[i16],
    xs: &[u16],
    k: u8,
    delta_known: u64,
) -> Result<G2Trapdoor> {
    check_xs_p(xs, k)?;
    validate_f_bound(f_big16)?;
    let (f_vss_sh, vss_f) = ishare_poly_with_vss_count(rng, f16, xs, k, G2_VSS_SAMPLE)?;
    let (g_vss_sh, vss_g) = ishare_poly_with_vss_count(rng, g16, xs, k, G2_VSS_SAMPLE)?;
    let (fb_vss_sh, vss_f_big) = ishare_poly_with_vss_count(rng, f_big16, xs, k, G2_VSS_SAMPLE)?;
    let (gb_vss_sh, vss_g_big) = ishare_poly_with_vss_count(rng, g_big16, xs, k, G2_VSS_SAMPLE)?;
    vss_verify_poly_shares(&vss_f, &f_vss_sh, xs)?;
    vss_verify_poly_shares(&vss_g, &g_vss_sh, xs)?;
    vss_verify_poly_shares(&vss_f_big, &fb_vss_sh, xs)?;
    vss_verify_poly_shares(&vss_g_big, &gb_vss_sh, xs)?;
```

**Signer starts computation without verifying stored commitments** — `ishare.rs:3174-3210`

The online entry point validates dimensions and an `F` bound, then immediately consumes the share matrices; it never compares them with the VSS material stored beside them.

```rust
pub fn mps4h_sign_shares_g2(
    rng: &mut impl rand::RngCore,
    gt: &G2Trapdoor,
    t: &[u16],
    xs: &[u16],
    k: u8,
    bits_tf: u32,
    bits_tf_big: u32,
    gauss_sigma: Option<u8>,
) -> Result<(Vec<i64>, Vec<i64>, SignCost)> {
    if t.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    check_xs_p(xs, k)?;
    validate_f_bound_shares(rng, &gt.td.f_big, xs, k)?;
    let mut cost = SignCost::default();
    let t64: Vec<i64> = t.iter().map(|&c| {
        let q = FT1536_Q as i64;
        let v = c as i64;
        if v > q / 2 { v - q } else { v }
    }).collect();
    let tf = mul_ring_public_t_shares(&t64, &gt.td.f)?;
    let t_f_big = mul_ring_public_t_shares(&t64, &gt.td.f_big)?;
```

**Regression test checks VSS manually instead of through signing** — `ishare.rs:3929-3943`

The test title says “before sign,” but it calls only the verifier. It does not establish that `mps4h_sign_shares_g2()` enforces VSS itself.

```rust
fn g2_sign_forge_share_f_aborts() {
    let mut rng = StdRng::seed_from_u64(0x47_32_00_31);
    let seed = [0x42u8; 32];
    let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
    let (f16, g16, f_big16, g_big16) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
    let mut gt =
        g2_deal_trapdoor(&mut rng, &f16, &g16, &f_big16, &g_big16, &XS, K, DELTA).unwrap();
    gt.td.f[0][0] = p_add(gt.td.f[0][0], 1);
    gt.vss_sh_f.values = gt.td.f.clone();
    let vss_check = vss_verify_poly_shares(&gt.vss_f, &gt.vss_sh_f, &XS);
    assert_eq!(vss_check, Err(SpikeError::CommitmentMismatch));
}
```

**Only a caller-selected coefficient prefix is committed** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:2198-2225`

Coefficients outside `n_vss` become ordinary shares with no commitment binding.

```rust
let n_vss = if vss_count == 0 { FT1536_N } else { vss_count.min(FT1536_N) };
for (j, &c) in p.iter().enumerate() {
    if j < n_vss {
        let (com, sh) = crate::pedersen::zp_vss_deal(rng, i64_to_p(c as i64), xs, k);
        // ... store VSS evaluations ...
        commits.push(com);
    } else {
        values.push(ishare_val(rng, c as i64, xs, k)?);
    }
}
```

**Integrated G2 setup selects eight coefficients** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:2688-2720`

The standard integrated setup binds only 8/1536 coefficients of each trapdoor polynomial.

```rust
pub const G2_VSS_SAMPLE: usize = 8;
// ...
let (f_vss_sh, vss_f) = ishare_poly_with_vss_count(rng, f16, xs, k, G2_VSS_SAMPLE)?;
let (g_vss_sh, vss_g) = ishare_poly_with_vss_count(rng, g16, xs, k, G2_VSS_SAMPLE)?;
let (fb_vss_sh, vss_f_big) = ishare_poly_with_vss_count(rng, f_big16, xs, k, G2_VSS_SAMPLE)?;
let (gb_vss_sh, vss_g_big) = ishare_poly_with_vss_count(rng, g_big16, xs, k, G2_VSS_SAMPLE)?;
```

**Signing checks shape and F bound but not VSS** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:3174-3209`

No commitment verification binds the exact f/g/F/G arrays used by signing.

```rust
pub fn mps4h_sign_shares_g2(
    rng: &mut impl rand::RngCore,
    gt: &G2Trapdoor,
    t: &[u16],
    xs: &[u16],
    k: u8,
    bits_tf: u32,
    bits_tf_big: u32,
    gauss_sigma: Option<u8>,
) -> Result<(Vec<i64>, Vec<i64>, SignCost)> {
    if t.len() != FT1536_N { return Err(SpikeError::PartyCountMismatch); }
    check_xs_p(xs, k)?;
    validate_f_bound_shares(rng, &gt.td.f_big, xs, k)?;
    // consumes gt.td immediately afterward

```

#### Validation

Indices 8..1535 take the uncommitted branch, and the only VSS checks occur outside the signing entry point. Manual verifier calls in tests do not establish end-to-end enforcement; configurable full coverage (`vss_count=0`) exists but is not selected by the integrated G2 setup.

Validation method: Static setup-to-signing trace plus embedded-test reconciliation; static source trace

**Only a caller-selected prefix receives commitments** — `ishare.rs:2194-2222`

All coefficients at or beyond `n_vss` are ordinary Shamir sharings with no commitment material, so later mutation cannot be checked by VSS.

```rust
let n_vss = if vss_count == 0 { FT1536_N } else { vss_count.min(FT1536_N) };
let mut values = Vec::with_capacity(FT1536_N);
let mut vss_vals = Vec::with_capacity(n_vss);
let mut vss_blinds = Vec::with_capacity(n_vss);
let mut commits = Vec::with_capacity(n_vss);
for (j, &c) in p.iter().enumerate() {
    if j < n_vss {
        let (com, sh) = crate::pedersen::zp_vss_deal(rng, i64_to_p(c as i64), xs, k);
        let mut vcol = vec![0u64; n];
        let mut vvcol = vec![0u128; n];
        let mut vbcol = vec![0u128; n];
        for (i, s) in sh.into_iter().enumerate() {
            vcol[i] = (s.share % I_P as u128) as u64;
            vvcol[i] = s.share;
            vbcol[i] = s.blind;
        }
        values.push(vcol);
        vss_vals.push(vvcol);
        vss_blinds.push(vbcol);
        commits.push(com);
    } else {
        values.push(ishare_val(rng, c as i64, xs, k)?);
    }
}
```

**G2 dealer fixes the committed prefix at eight coefficients** — `ishare.rs:2688-2725`

Setup verifies only the eight committed coefficients. This establishes initial consistency but does not bind the remaining 1528 coefficients or prevent post-setup replacement.

```rust
pub const G2_VSS_SAMPLE: usize = 8;

pub fn g2_deal_trapdoor(
    rng: &mut impl rand::RngCore,
    f16: &[i16],
    g16: &[i16],
    f_big16: &[i16],
    g_big16: &[i16],
    xs: &[u16],
    k: u8,
    delta_known: u64,
) -> Result<G2Trapdoor> {
    check_xs_p(xs, k)?;
    validate_f_bound(f_big16)?;
    let (f_vss_sh, vss_f) = ishare_poly_with_vss_count(rng, f16, xs, k, G2_VSS_SAMPLE)?;
    let (g_vss_sh, vss_g) = ishare_poly_with_vss_count(rng, g16, xs, k, G2_VSS_SAMPLE)?;
    let (fb_vss_sh, vss_f_big) = ishare_poly_with_vss_count(rng, f_big16, xs, k, G2_VSS_SAMPLE)?;
    let (gb_vss_sh, vss_g_big) = ishare_poly_with_vss_count(rng, g_big16, xs, k, G2_VSS_SAMPLE)?;
    vss_verify_poly_shares(&vss_f, &f_vss_sh, xs)?;
    vss_verify_poly_shares(&vss_g, &g_vss_sh, xs)?;
    vss_verify_poly_shares(&vss_f_big, &fb_vss_sh, xs)?;
    vss_verify_poly_shares(&vss_g_big, &gb_vss_sh, xs)?;
```

**Signer starts computation without verifying stored commitments** — `ishare.rs:3174-3210`

The online entry point validates dimensions and an `F` bound, then immediately consumes the share matrices; it never compares them with the VSS material stored beside them.

```rust
pub fn mps4h_sign_shares_g2(
    rng: &mut impl rand::RngCore,
    gt: &G2Trapdoor,
    t: &[u16],
    xs: &[u16],
    k: u8,
    bits_tf: u32,
    bits_tf_big: u32,
    gauss_sigma: Option<u8>,
) -> Result<(Vec<i64>, Vec<i64>, SignCost)> {
    if t.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    check_xs_p(xs, k)?;
    validate_f_bound_shares(rng, &gt.td.f_big, xs, k)?;
    let mut cost = SignCost::default();
    let t64: Vec<i64> = t.iter().map(|&c| {
        let q = FT1536_Q as i64;
        let v = c as i64;
        if v > q / 2 { v - q } else { v }
    }).collect();
    let tf = mul_ring_public_t_shares(&t64, &gt.td.f)?;
    let t_f_big = mul_ring_public_t_shares(&t64, &gt.td.f_big)?;
```

**Regression test checks VSS manually instead of through signing** — `ishare.rs:3929-3943`

The test title says “before sign,” but it calls only the verifier. It does not establish that `mps4h_sign_shares_g2()` enforces VSS itself.

```rust
fn g2_sign_forge_share_f_aborts() {
    let mut rng = StdRng::seed_from_u64(0x47_32_00_31);
    let seed = [0x42u8; 32];
    let kp = Ft1536KeyPair::generate_from_seed(&seed).unwrap();
    let (f16, g16, f_big16, g_big16) = decode_sk_ft1536_i16(kp.secret_key()).unwrap();
    let mut gt =
        g2_deal_trapdoor(&mut rng, &f16, &g16, &f_big16, &g_big16, &XS, K, DELTA).unwrap();
    gt.td.f[0][0] = p_add(gt.td.f[0][0], 1);
    gt.vss_sh_f.values = gt.td.f.clone();
    let vss_check = vss_verify_poly_shares(&gt.vss_f, &gt.vss_sh_f, &XS);
    assert_eq!(vss_check, Err(SpikeError::CommitmentMismatch));
}
```

**Only a caller-selected coefficient prefix is committed** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:2198-2225`

Coefficients outside `n_vss` become ordinary shares with no commitment binding.

```rust
let n_vss = if vss_count == 0 { FT1536_N } else { vss_count.min(FT1536_N) };
for (j, &c) in p.iter().enumerate() {
    if j < n_vss {
        let (com, sh) = crate::pedersen::zp_vss_deal(rng, i64_to_p(c as i64), xs, k);
        // ... store VSS evaluations ...
        commits.push(com);
    } else {
        values.push(ishare_val(rng, c as i64, xs, k)?);
    }
}
```

**Integrated G2 setup selects eight coefficients** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:2688-2720`

The standard integrated setup binds only 8/1536 coefficients of each trapdoor polynomial.

```rust
pub const G2_VSS_SAMPLE: usize = 8;
// ...
let (f_vss_sh, vss_f) = ishare_poly_with_vss_count(rng, f16, xs, k, G2_VSS_SAMPLE)?;
let (g_vss_sh, vss_g) = ishare_poly_with_vss_count(rng, g16, xs, k, G2_VSS_SAMPLE)?;
let (fb_vss_sh, vss_f_big) = ishare_poly_with_vss_count(rng, f_big16, xs, k, G2_VSS_SAMPLE)?;
let (gb_vss_sh, vss_g_big) = ishare_poly_with_vss_count(rng, g_big16, xs, k, G2_VSS_SAMPLE)?;
```

**Signing checks shape and F bound but not VSS** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:3174-3209`

No commitment verification binds the exact f/g/F/G arrays used by signing.

```rust
pub fn mps4h_sign_shares_g2(
    rng: &mut impl rand::RngCore,
    gt: &G2Trapdoor,
    t: &[u16],
    xs: &[u16],
    k: u8,
    bits_tf: u32,
    bits_tf_big: u32,
    gauss_sigma: Option<u8>,
) -> Result<(Vec<i64>, Vec<i64>, SignCost)> {
    if t.len() != FT1536_N { return Err(SpikeError::PartyCountMismatch); }
    check_xs_p(xs, k)?;
    validate_f_bound_shares(rng, &gt.td.f_big, xs, k)?;
    // consumes gt.td immediately afterward

```

Assertions:
- Coefficients 8..1535 have no G2 dealer commitments.
- The signer does not call any VSS verifier.
- Tests manually invoke VSS and therefore do not prove end-to-end enforcement.

Counterevidence and remaining uncertainty:
- Setup verifies its committed prefix immediately after honest generation.
- `f` and `F` have separate MAC arrays that detect some uncorrelated changes.
- External signature verification can reject many corrupted results.
- Individual committed coefficients are checked correctly during setup.
- Passing `vss_count=0` in configurable DKG paths requests full coverage.

Limitations:
- The current API is monolithic; participant mutation requires an external transport/embedding.
- No runtime mutation test was executed.
- Actual cross-process share ownership is not enforced in this in-process model.

#### Dataflow

participant-owned trapdoor share -\> mutable `G2Trapdoor.td` matrix -\> no commitment verification -\> ring/sign arithmetic -\> corrupted `s1`/`s2`

- **Source:** altered participant share

- **Sink:** `mps4h_sign_shares_g2()` computation

- **Outcome:** faulted signing result without `CommitmentMismatch`

**G2 dealer fixes the committed prefix at eight coefficients** — `ishare.rs:2688-2725`

Setup verifies only the eight committed coefficients. This establishes initial consistency but does not bind the remaining 1528 coefficients or prevent post-setup replacement.

```rust
pub const G2_VSS_SAMPLE: usize = 8;

pub fn g2_deal_trapdoor(
    rng: &mut impl rand::RngCore,
    f16: &[i16],
    g16: &[i16],
    f_big16: &[i16],
    g_big16: &[i16],
    xs: &[u16],
    k: u8,
    delta_known: u64,
) -> Result<G2Trapdoor> {
    check_xs_p(xs, k)?;
    validate_f_bound(f_big16)?;
    let (f_vss_sh, vss_f) = ishare_poly_with_vss_count(rng, f16, xs, k, G2_VSS_SAMPLE)?;
    let (g_vss_sh, vss_g) = ishare_poly_with_vss_count(rng, g16, xs, k, G2_VSS_SAMPLE)?;
    let (fb_vss_sh, vss_f_big) = ishare_poly_with_vss_count(rng, f_big16, xs, k, G2_VSS_SAMPLE)?;
    let (gb_vss_sh, vss_g_big) = ishare_poly_with_vss_count(rng, g_big16, xs, k, G2_VSS_SAMPLE)?;
    vss_verify_poly_shares(&vss_f, &f_vss_sh, xs)?;
    vss_verify_poly_shares(&vss_g, &g_vss_sh, xs)?;
    vss_verify_poly_shares(&vss_f_big, &fb_vss_sh, xs)?;
    vss_verify_poly_shares(&vss_g_big, &gb_vss_sh, xs)?;
```

**Signer starts computation without verifying stored commitments** — `ishare.rs:3174-3210`

The online entry point validates dimensions and an `F` bound, then immediately consumes the share matrices; it never compares them with the VSS material stored beside them.

```rust
pub fn mps4h_sign_shares_g2(
    rng: &mut impl rand::RngCore,
    gt: &G2Trapdoor,
    t: &[u16],
    xs: &[u16],
    k: u8,
    bits_tf: u32,
    bits_tf_big: u32,
    gauss_sigma: Option<u8>,
) -> Result<(Vec<i64>, Vec<i64>, SignCost)> {
    if t.len() != FT1536_N {
        return Err(SpikeError::PartyCountMismatch);
    }
    check_xs_p(xs, k)?;
    validate_f_bound_shares(rng, &gt.td.f_big, xs, k)?;
    let mut cost = SignCost::default();
    let t64: Vec<i64> = t.iter().map(|&c| {
        let q = FT1536_Q as i64;
        let v = c as i64;
        if v > q / 2 { v - q } else { v }
    }).collect();
    let tf = mul_ring_public_t_shares(&t64, &gt.td.f)?;
    let t_f_big = mul_ring_public_t_shares(&t64, &gt.td.f_big)?;
```

**Only a caller-selected coefficient prefix is committed** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:2198-2225`

Coefficients outside `n_vss` become ordinary shares with no commitment binding.

```rust
let n_vss = if vss_count == 0 { FT1536_N } else { vss_count.min(FT1536_N) };
for (j, &c) in p.iter().enumerate() {
    if j < n_vss {
        let (com, sh) = crate::pedersen::zp_vss_deal(rng, i64_to_p(c as i64), xs, k);
        // ... store VSS evaluations ...
        commits.push(com);
    } else {
        values.push(ishare_val(rng, c as i64, xs, k)?);
    }
}
```

**Integrated G2 setup selects eight coefficients** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:2688-2720`

The standard integrated setup binds only 8/1536 coefficients of each trapdoor polynomial.

```rust
pub const G2_VSS_SAMPLE: usize = 8;
// ...
let (f_vss_sh, vss_f) = ishare_poly_with_vss_count(rng, f16, xs, k, G2_VSS_SAMPLE)?;
let (g_vss_sh, vss_g) = ishare_poly_with_vss_count(rng, g16, xs, k, G2_VSS_SAMPLE)?;
let (fb_vss_sh, vss_f_big) = ishare_poly_with_vss_count(rng, f_big16, xs, k, G2_VSS_SAMPLE)?;
let (gb_vss_sh, vss_g_big) = ishare_poly_with_vss_count(rng, g_big16, xs, k, G2_VSS_SAMPLE)?;
```

**Signing checks shape and F bound but not VSS** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:3174-3209`

No commitment verification binds the exact f/g/F/G arrays used by signing.

```rust
pub fn mps4h_sign_shares_g2(
    rng: &mut impl rand::RngCore,
    gt: &G2Trapdoor,
    t: &[u16],
    xs: &[u16],
    k: u8,
    bits_tf: u32,
    bits_tf_big: u32,
    gauss_sigma: Option<u8>,
) -> Result<(Vec<i64>, Vec<i64>, SignCost)> {
    if t.len() != FT1536_N { return Err(SpikeError::PartyCountMismatch); }
    check_xs_p(xs, k)?;
    validate_f_bound_shares(rng, &gt.td.f_big, xs, k)?;
    // consumes gt.td immediately afterward

```

#### Reachability

Requires an embedding in which a participant, dealer, or coordinator can supply or replace share matrices after setup; the in-scope implementation is monolithic and does not enforce independent ownership.

- **Attacker:** Malicious threshold participant or dealer, or a compromised coordinator able to modify trapdoor share matrices

- **Entry point:** online G2 trapdoor share aggregation

- **Outcome:** signer consumes unbound share

Preconditions:
- Participant can replace its indexed share after setup or target an uncommitted coefficient.

#### Severity

**Medium** — The missing binding can cause undetected corrupted signing output and denial of service. Severity is medium because participant mutation requires an external distributed embedding absent from this monolithic research snapshot, and external signature verification rejects many faults.

Raise severity if G2 shares cross an untrusted participant/transport boundary in repeated signing; lower if the signer accepts only an immutable fully verified opaque trapdoor.

Impact assessment:
- **Level:** medium
- **Why:** Undetected signing faults and denial of service are source-supported; key recovery is not.

Likelihood assessment:
- **Level:** unknown
- **Why:** No deployed participant transport exists in scope.

#### Remediation

Commit and verify all coefficients, or use a sound randomized batched commitment proof with quantified soundness. Make setup return an opaque immutable checked-trapdoor type bound to the exact per-party shares, authenticate `g` and `G` as well as `f` and `F`, and require online signing to verify or consume only that checked representation.

Tests:
- Mutate `g[100]` and `g_big[1000]`, call `mps4h_sign_shares_g2()` directly, and require `CommitmentMismatch`.
- Mutate a committed coefficient after setup and require the signing entry point—not a manually called verifier—to fail.
- Assert production setup cannot select partial fixed-prefix VSS coverage.
- Mutate coefficient index 8 or later and assert the signing call itself returns `CommitmentMismatch`.
- Mutate a committed g/G share after setup and assert the signing call rejects it.

Preventive controls:
- Bind commitment verification into the signing type system/API boundary.
- Do not expose mutable aggregate share matrices as public fields.
- Use full or cryptographically sampled batch verification, never a fixed prefix sold as a sample.
- Represent only fully validated trapdoors as sign-capable types.

<a id="finding-8"></a>

### [8] Centralized DKG and PRSS helpers expose every party's trapdoor inputs and randomness

| Field | Value |
| --- | --- |
| Severity | medium |
| Confidence | high |
| Confidence rationale | Direct API signatures, central loops, returned all-column state, centralized pair-seed construction, and persisted CLI contribution transcripts establish co-residence; deployment reachability remains uncertain. |
| Category | Threshold key-management boundary collapse |
| CWE | CWE-320, CWE-668 |
| Affected lines | ishare.rs:2803-2808, ishare.rs:2881-2898, ishare.rs:2932-2946, ishare.rs:3079-3098, ishare.rs:2881-2892, prss.rs:295-314, ishare.rs:956-980, bin/iso.rs:601-605, bin/iso.rs:629-669, bin/iso.rs:1030-1031, bin/iso.rs:1055-1093, bin/iso.rs:81-101, bin/iso.rs:1200-1255, ishare.rs:2881-2889, ishare.rs:2800-2809, ishare.rs:2932-2946, ishare.rs:2803, ishare.rs:2881, ishare.rs:2932, ishare.rs:3079, ishare.rs:229 |

#### Summary

The weighted contribution DKG receives every party's clear `f`, `g`, `F`, and `G` vectors and all RNG objects in one caller, which can sum the inputs and recover the complete aggregate trapdoor before sharing. Related PRSS helpers centralize every participant RNG and derive all pair seeds in one address space; the runnable `iso dkg`/`dkg5` flows also print and persist clear contributions before reconstructing the aggregate seed. A compromised coordinator or reader of those shared artifacts therefore defeats the stated participant-local and threshold boundaries.

#### Root Cause

Participant-local secret ownership is represented only by in-process objects and conventions: one caller owns all clear contribution vectors/RNGs, all-column state, and related centralized pair-seed construction before any sharing or isolation boundary is applied.

**Clear party contribution type** — `ishare.rs:2800-2809`

Each supposedly party-local secret contribution is a cloneable object with four public clear vectors.

```rust
/// Partia zna **wyłącznie** swój wkład. Pełny klucz f = Σ f_c
/// dokładna suma całkowita) **nie powstaje w clear** w torze
/// [`dkg_trapdoor_from_contributions`] — tam wyłącznie sumowane są udziały.
#[derive(Clone)]
pub struct PartyTrapdoorContribution {
    pub f: Vec<i16>,
    pub g: Vec<i16>,
    pub f_big: Vec<i16>,
    pub g_big: Vec<i16>,
}
```

**One API accepts all contributions and RNGs** — `ishare.rs:2881-2892`

One address space owns every clear contribution and nominal party RNG.

```rust
pub fn dkg_trapdoor_from_weighted_contributions<R: rand::RngCore>(
    rngs: &mut [R],
    contribs: &[PartyTrapdoorContribution],
    weights: &[u64],
    xs: &[u16],
    k: u8,
    delta_known: u64,
    vss_count: usize,
) -> Result<G2Trapdoor> {
    let n = check_xs_p(xs, k)?;
    if contribs.is_empty() || rngs.is_empty() || weights.len() != contribs.len() {
        return Err(SpikeError::PartyCountMismatch);
    }
```

**Coordinator reads every clear polynomial** — `ishare.rs:2932-2946`

Before sharing, the one caller iterates over and reads every clear summand, so it can compute the aggregate trapdoor itself.

```rust
for (ci, contrib) in contribs.iter().enumerate() {
    if contrib.f.len() != FT1536_N
        || contrib.g.len() != FT1536_N
        || contrib.f_big.len() != FT1536_N
        || contrib.g_big.len() != FT1536_N
    {
        return Err(SpikeError::PartyCountMismatch);
    }
    let rng = &mut rngs[ci % rngs.len()];
    let w = weights[ci];
    let (f_sh, f_v) = ishare_poly_with_vss_count(rng, &contrib.f, xs, k, n_vss)?;
    let (g_sh, g_v) = ishare_poly_with_vss_count(rng, &contrib.g, xs, k, n_vss)?;
    let (fb_sh, fb_v) = ishare_poly_with_vss_count(rng, &contrib.f_big, xs, k, n_vss)?;
    let (gb_sh, gb_v) = ishare_poly_with_vss_count(rng, &contrib.g_big, xs, k, n_vss)?;
```

**All share matrices returned** — `ishare.rs:3079-3098`

One signing object contains every party column for every trapdoor polynomial.

```rust
Ok(G2Trapdoor {
    td: ITrapdoorShares {
        f: f_acc,
        g: g_acc,
        f_big: fb_acc,
        g_big: gb_acc,
    },
    // ...
    delta_known: dk,
})
```

**Clear per-party trapdoor vectors are clonable public input** — `ishare.rs:2798-2809`

The security claim says each party knows only its own contribution, but the API representation is a clonable object containing all four clear polynomial vectors.

```rust
/// Partia zna **wyłącznie** swój wkład. Pełny klucz f = Σ f_c (mod i16,
/// dokładna suma całkowita) **nie powstaje w clear** w torze
/// [`dkg_trapdoor_from_contributions`] — tam wyłącznie sumowane są udziały.
#[derive(Clone)]
pub struct PartyTrapdoorContribution {
    pub f: Vec<i16>,
    pub g: Vec<i16>,
    pub f_big: Vec<i16>,
    pub g_big: Vec<i16>,
}
```

**One DKG caller supplies all party contributions and RNGs** — `ishare.rs:2881-2893`

The coordinator-facing entry point receives the complete contribution collection and the complete RNG collection in the same address space; it does not require one RNG per contribution.

```rust
pub fn dkg_trapdoor_from_weighted_contributions<R: rand::RngCore>(
    rngs: &mut [R],
    contribs: &[PartyTrapdoorContribution],
    weights: &[u64],
    xs: &[u16],
    k: u8,
    delta_known: u64,
    vss_count: usize,
) -> Result<G2Trapdoor> {
    let n = check_xs_p(xs, k)?;
    if contribs.is_empty() || rngs.is_empty() || weights.len() != contribs.len() {
        return Err(SpikeError::PartyCountMismatch);
    }
```

**Coordinator reads every clear vector and cycles caller-held RNGs** — `ishare.rs:2932-2946`

Before VSS exists, one process iterates and reads every participant's clear polynomials. Modulo indexing silently lets multiple claimed participants reuse a smaller caller-owned RNG set.

```rust
for (ci, contrib) in contribs.iter().enumerate() {
    if contrib.f.len() != FT1536_N
        || contrib.g.len() != FT1536_N
        || contrib.f_big.len() != FT1536_N
        || contrib.g_big.len() != FT1536_N
    {
        return Err(SpikeError::PartyCountMismatch);
    }
    let rng = &mut rngs[ci % rngs.len()];
    let w = weights[ci];
    let (f_sh, f_v) = ishare_poly_with_vss_count(rng, &contrib.f, xs, k, n_vss)?;
    let (g_sh, g_v) = ishare_poly_with_vss_count(rng, &contrib.g, xs, k, n_vss)?;
    let (fb_sh, fb_v) = ishare_poly_with_vss_count(rng, &contrib.f_big, xs, k, n_vss)?;
    let (gb_sh, gb_v) = ishare_poly_with_vss_count(rng, &contrib.g_big, xs, k, n_vss)?;
```

**One helper derives every nonce and pair seed and copies the full seed map** — `prss.rs:291-314`

The same caller consumes every party RNG, observes every nonce, constructs every pair seed, and installs a complete seed map in each virtual party stream, so pairwise custody is simulated rather than enforced.

```rust
pub fn pairwise_zero_streams<R: rand::RngCore>(rngs: &mut [R]) -> Vec<ZeroShareStream> {
    let n = rngs.len();
    let nonces: Vec<[u8; 8]> = rngs
        .iter_mut()
        .map(|r| {
            let mut nb = [0u8; 8];
            nb.copy_from_slice(&r.next_u64().to_le_bytes());
            nb
        })
        .collect();
    let build = || {
        let mut seeds = BTreeMap::new();
        for i in 0..n {
            for j in (i + 1)..n {
                seeds.insert((i, j), pair_seed(&nonces[i], &nonces[j]));
            }
        }
        seeds
    };
    (0..n).map(|me| ZeroShareStream::new(me, n, build())).collect()
}
```

**PRSS noise also reuses caller-held RNGs modulo the party count** — `ishare.rs:956-980`

The PRSS path accepts any nonempty RNG slice and reuses its members modulo the number of parties, so the promised independent per-party randomness is not an enforced invariant.

```rust
pub fn prss_dgdg_shares_pairwise<R: rand::RngCore>(
    rngs: &mut [R],
    sigma: u8,
    xs: &[u16],
    k: u8,
) -> Result<Vec<u64>> {
    let n = check_xs_p(xs, k)?;
    if rngs.is_empty() {
        return Err(SpikeError::PartyCountMismatch);
    }
    // ...
    for party in 0..n {
        let s = crate::rejection::sample_gaussian_q73_clear(
            &mut rngs[party % rngs.len()],
            w_i,
            s73_i,
        )
        .map_err(|_| SpikeError::WrongThreshold)?;
        let sh = ishare_val_unchecked(&mut rngs[party % rngs.len()], i64::from(s.x), xs, k);
```

**Party prints its complete random contribution** — `bin/iso.rs:601-605`

Each child serializes its complete 32-byte contribution to stdout before zeroization, transferring the secret to the parent process.

```rust
// jawny „moment" TYLKO dla oracle testowego: zapisz s_i (wkład)
// TT-30: wkład tylko na stdout (nie plik) — oracle w rodzicu
let hex: String = s_i.iter().map(|b| format!("{b:02x}")).collect();
println!("CONTRIB {p} {hex}");
s_i.zeroize();
```

**Parent persists all contributions and reconstructs the seed** — `bin/iso.rs:629-670`

The coordinator turns captured stdout into persistent `party*.out` files, reads every contribution, and reconstructs the aggregate seed; checking only for absence of `seed.bin` does not protect equivalent key material.

```rust
for (i, h) in handles.into_iter().enumerate() {
    let o = h.wait_with_output().unwrap();
    assert!(o.status.success(), "{}", String::from_utf8_lossy(&o.stderr));
    std::fs::write(workdir.join(format!("party{i}.out")), &o.stdout).unwrap();
    print!("{}", String::from_utf8_lossy(&o.stdout));
}
// ...
let mut seed = [0u8; 32];
for p in 0..3 {
    let log = std::fs::read_to_string(workdir.join(format!("party{p}.out"))).unwrap();
    for line in log.lines() {
        if let Some(rest) = line.strip_prefix(&format!("CONTRIB {p} ")) {
            let bytes = (0..32)
                .map(|i| u8::from_str_radix(&rest[i * 2..i * 2 + 2], 16).unwrap())
                .collect::<Vec<u8>>();
            for b in 0..32 {
                seed[b] ^= bytes[b];
            }
        }
    }
}
```

**One call receives all secrets and RNGs** — `ishare.rs:2881-2889`

The coordinator receives the complete contribution and randomness collections at the same entry point.

```rust
pub fn dkg_trapdoor_from_weighted_contributions<R: rand::RngCore>(
    rngs: &mut [R],
    contribs: &[PartyTrapdoorContribution],
    weights: &[u64],
    xs: &[u16],
    k: u8,
    delta_known: u64,
    vss_count: usize,
) -> Result<G2Trapdoor> {
```

**One call accepts every contribution and RNG** — `ishare.rs:2881-2889`

The coordinator calling this API necessarily owns the full contribution slice and every supplied RNG object.

```rust
pub fn dkg_trapdoor_from_weighted_contributions<R: rand::RngCore>(
    rngs: &mut [R],
    contribs: &[PartyTrapdoorContribution],
    weights: &[u64],
    xs: &[u16],
    k: u8,
    delta_known: u64,
    vss_count: usize,
) -> Result<G2Trapdoor> {
```

**Aggregate contains every party column** — `ishare.rs:3079-3098`

The same caller receives all aggregate share matrices, not one opaque party-local column.

```rust
Ok(G2Trapdoor {
    td: ITrapdoorShares {
        f: f_acc,
        g: g_acc,
        f_big: fb_acc,
        g_big: gb_acc,
    },
    f_mac,
    f_big_mac,
    vss_f,
    vss_g,
    vss_f_big,
    vss_g_big,
    vss_sh_f,
    vss_sh_g,
    vss_sh_f_big: vss_sh_fb,
    vss_sh_g_big: vss_sh_gb,
    delta,
    delta_known: dk,
})
```

#### Validation

Direct API signatures, public contribution fields, central loops, returned all-column state, centralized pair-seed construction, and persisted CLI transcripts establish co-residence. The new independent trace confirms that avoiding an explicit aggregate inside the helper does not stop its caller from summing clear inputs or reconstructing all returned columns; deployment reachability remains uncertain.

Validation method: Independent static source trace and semantic reconciliation; independent static source trace

- **Status:** validated

**Clear party contribution type** — `ishare.rs:2800-2809`

Each supposedly party-local secret contribution is a cloneable object with four public clear vectors.

```rust
/// Partia zna **wyłącznie** swój wkład. Pełny klucz f = Σ f_c
/// dokładna suma całkowita) **nie powstaje w clear** w torze
/// [`dkg_trapdoor_from_contributions`] — tam wyłącznie sumowane są udziały.
#[derive(Clone)]
pub struct PartyTrapdoorContribution {
    pub f: Vec<i16>,
    pub g: Vec<i16>,
    pub f_big: Vec<i16>,
    pub g_big: Vec<i16>,
}
```

**One API accepts all contributions and RNGs** — `ishare.rs:2881-2892`

One address space owns every clear contribution and nominal party RNG.

```rust
pub fn dkg_trapdoor_from_weighted_contributions<R: rand::RngCore>(
    rngs: &mut [R],
    contribs: &[PartyTrapdoorContribution],
    weights: &[u64],
    xs: &[u16],
    k: u8,
    delta_known: u64,
    vss_count: usize,
) -> Result<G2Trapdoor> {
    let n = check_xs_p(xs, k)?;
    if contribs.is_empty() || rngs.is_empty() || weights.len() != contribs.len() {
        return Err(SpikeError::PartyCountMismatch);
    }
```

**Coordinator reads every clear polynomial** — `ishare.rs:2932-2946`

Before sharing, the one caller iterates over and reads every clear summand, so it can compute the aggregate trapdoor itself.

```rust
for (ci, contrib) in contribs.iter().enumerate() {
    if contrib.f.len() != FT1536_N
        || contrib.g.len() != FT1536_N
        || contrib.f_big.len() != FT1536_N
        || contrib.g_big.len() != FT1536_N
    {
        return Err(SpikeError::PartyCountMismatch);
    }
    let rng = &mut rngs[ci % rngs.len()];
    let w = weights[ci];
    let (f_sh, f_v) = ishare_poly_with_vss_count(rng, &contrib.f, xs, k, n_vss)?;
    let (g_sh, g_v) = ishare_poly_with_vss_count(rng, &contrib.g, xs, k, n_vss)?;
    let (fb_sh, fb_v) = ishare_poly_with_vss_count(rng, &contrib.f_big, xs, k, n_vss)?;
    let (gb_sh, gb_v) = ishare_poly_with_vss_count(rng, &contrib.g_big, xs, k, n_vss)?;
```

**All share matrices returned** — `ishare.rs:3079-3098`

One signing object contains every party column for every trapdoor polynomial.

```rust
Ok(G2Trapdoor {
    td: ITrapdoorShares {
        f: f_acc,
        g: g_acc,
        f_big: fb_acc,
        g_big: gb_acc,
    },
    // ...
    delta_known: dk,
})
```

**Clear per-party trapdoor vectors are clonable public input** — `ishare.rs:2798-2809`

The security claim says each party knows only its own contribution, but the API representation is a clonable object containing all four clear polynomial vectors.

```rust
/// Partia zna **wyłącznie** swój wkład. Pełny klucz f = Σ f_c (mod i16,
/// dokładna suma całkowita) **nie powstaje w clear** w torze
/// [`dkg_trapdoor_from_contributions`] — tam wyłącznie sumowane są udziały.
#[derive(Clone)]
pub struct PartyTrapdoorContribution {
    pub f: Vec<i16>,
    pub g: Vec<i16>,
    pub f_big: Vec<i16>,
    pub g_big: Vec<i16>,
}
```

**One DKG caller supplies all party contributions and RNGs** — `ishare.rs:2881-2893`

The coordinator-facing entry point receives the complete contribution collection and the complete RNG collection in the same address space; it does not require one RNG per contribution.

```rust
pub fn dkg_trapdoor_from_weighted_contributions<R: rand::RngCore>(
    rngs: &mut [R],
    contribs: &[PartyTrapdoorContribution],
    weights: &[u64],
    xs: &[u16],
    k: u8,
    delta_known: u64,
    vss_count: usize,
) -> Result<G2Trapdoor> {
    let n = check_xs_p(xs, k)?;
    if contribs.is_empty() || rngs.is_empty() || weights.len() != contribs.len() {
        return Err(SpikeError::PartyCountMismatch);
    }
```

**Coordinator reads every clear vector and cycles caller-held RNGs** — `ishare.rs:2932-2946`

Before VSS exists, one process iterates and reads every participant's clear polynomials. Modulo indexing silently lets multiple claimed participants reuse a smaller caller-owned RNG set.

```rust
for (ci, contrib) in contribs.iter().enumerate() {
    if contrib.f.len() != FT1536_N
        || contrib.g.len() != FT1536_N
        || contrib.f_big.len() != FT1536_N
        || contrib.g_big.len() != FT1536_N
    {
        return Err(SpikeError::PartyCountMismatch);
    }
    let rng = &mut rngs[ci % rngs.len()];
    let w = weights[ci];
    let (f_sh, f_v) = ishare_poly_with_vss_count(rng, &contrib.f, xs, k, n_vss)?;
    let (g_sh, g_v) = ishare_poly_with_vss_count(rng, &contrib.g, xs, k, n_vss)?;
    let (fb_sh, fb_v) = ishare_poly_with_vss_count(rng, &contrib.f_big, xs, k, n_vss)?;
    let (gb_sh, gb_v) = ishare_poly_with_vss_count(rng, &contrib.g_big, xs, k, n_vss)?;
```

**One helper derives every nonce and pair seed and copies the full seed map** — `prss.rs:291-314`

The same caller consumes every party RNG, observes every nonce, constructs every pair seed, and installs a complete seed map in each virtual party stream, so pairwise custody is simulated rather than enforced.

```rust
pub fn pairwise_zero_streams<R: rand::RngCore>(rngs: &mut [R]) -> Vec<ZeroShareStream> {
    let n = rngs.len();
    let nonces: Vec<[u8; 8]> = rngs
        .iter_mut()
        .map(|r| {
            let mut nb = [0u8; 8];
            nb.copy_from_slice(&r.next_u64().to_le_bytes());
            nb
        })
        .collect();
    let build = || {
        let mut seeds = BTreeMap::new();
        for i in 0..n {
            for j in (i + 1)..n {
                seeds.insert((i, j), pair_seed(&nonces[i], &nonces[j]));
            }
        }
        seeds
    };
    (0..n).map(|me| ZeroShareStream::new(me, n, build())).collect()
}
```

**PRSS noise also reuses caller-held RNGs modulo the party count** — `ishare.rs:956-980`

The PRSS path accepts any nonempty RNG slice and reuses its members modulo the number of parties, so the promised independent per-party randomness is not an enforced invariant.

```rust
pub fn prss_dgdg_shares_pairwise<R: rand::RngCore>(
    rngs: &mut [R],
    sigma: u8,
    xs: &[u16],
    k: u8,
) -> Result<Vec<u64>> {
    let n = check_xs_p(xs, k)?;
    if rngs.is_empty() {
        return Err(SpikeError::PartyCountMismatch);
    }
    // ...
    for party in 0..n {
        let s = crate::rejection::sample_gaussian_q73_clear(
            &mut rngs[party % rngs.len()],
            w_i,
            s73_i,
        )
        .map_err(|_| SpikeError::WrongThreshold)?;
        let sh = ishare_val_unchecked(&mut rngs[party % rngs.len()], i64::from(s.x), xs, k);
```

**Party prints its complete random contribution** — `bin/iso.rs:601-605`

Each child serializes its complete 32-byte contribution to stdout before zeroization, transferring the secret to the parent process.

```rust
// jawny „moment" TYLKO dla oracle testowego: zapisz s_i (wkład)
// TT-30: wkład tylko na stdout (nie plik) — oracle w rodzicu
let hex: String = s_i.iter().map(|b| format!("{b:02x}")).collect();
println!("CONTRIB {p} {hex}");
s_i.zeroize();
```

**Parent persists all contributions and reconstructs the seed** — `bin/iso.rs:629-670`

The coordinator turns captured stdout into persistent `party*.out` files, reads every contribution, and reconstructs the aggregate seed; checking only for absence of `seed.bin` does not protect equivalent key material.

```rust
for (i, h) in handles.into_iter().enumerate() {
    let o = h.wait_with_output().unwrap();
    assert!(o.status.success(), "{}", String::from_utf8_lossy(&o.stderr));
    std::fs::write(workdir.join(format!("party{i}.out")), &o.stdout).unwrap();
    print!("{}", String::from_utf8_lossy(&o.stdout));
}
// ...
let mut seed = [0u8; 32];
for p in 0..3 {
    let log = std::fs::read_to_string(workdir.join(format!("party{p}.out"))).unwrap();
    for line in log.lines() {
        if let Some(rest) = line.strip_prefix(&format!("CONTRIB {p} ")) {
            let bytes = (0..32)
                .map(|i| u8::from_str_radix(&rest[i * 2..i * 2 + 2], 16).unwrap())
                .collect::<Vec<u8>>();
            for b in 0..32 {
                seed[b] ^= bytes[b];
            }
        }
    }
}
```

**One call receives all secrets and RNGs** — `ishare.rs:2881-2889`

The coordinator receives the complete contribution and randomness collections at the same entry point.

```rust
pub fn dkg_trapdoor_from_weighted_contributions<R: rand::RngCore>(
    rngs: &mut [R],
    contribs: &[PartyTrapdoorContribution],
    weights: &[u64],
    xs: &[u16],
    k: u8,
    delta_known: u64,
    vss_count: usize,
) -> Result<G2Trapdoor> {
```

**One call accepts every contribution and RNG** — `ishare.rs:2881-2889`

The coordinator calling this API necessarily owns the full contribution slice and every supplied RNG object.

```rust
pub fn dkg_trapdoor_from_weighted_contributions<R: rand::RngCore>(
    rngs: &mut [R],
    contribs: &[PartyTrapdoorContribution],
    weights: &[u64],
    xs: &[u16],
    k: u8,
    delta_known: u64,
    vss_count: usize,
) -> Result<G2Trapdoor> {
```

**Aggregate contains every party column** — `ishare.rs:3079-3098`

The same caller receives all aggregate share matrices, not one opaque party-local column.

```rust
Ok(G2Trapdoor {
    td: ITrapdoorShares {
        f: f_acc,
        g: g_acc,
        f_big: fb_acc,
        g_big: gb_acc,
    },
    f_mac,
    f_big_mac,
    vss_f,
    vss_g,
    vss_f_big,
    vss_g_big,
    vss_sh_f,
    vss_sh_g,
    vss_sh_f_big: vss_sh_fb,
    vss_sh_g_big: vss_sh_gb,
    delta,
    delta_known: dk,
})
```

Assertions:
- The DKG caller can read and sum every clear contribution using the formula documented by the code.
- The DKG function permits fewer RNGs than contributions and cycles them modulo the supplied length.
- The PRSS constructors centrally derive all nonces and all pairwise seeds.
- The runnable three-party and five-party DKG commands persist clear participant contributions and reconstruct the aggregate seed.
- All seed columns, preprocessing shares, and hidden-delta shares are colocated under caller-selected shared work directories without participant-specific access enforcement.
- The caller can compute each weighted aggregate polynomial directly.
- Separate RNG objects do not isolate their state or the contribution objects from their owner.
- One caller owns all clear contributions.
- One caller receives all aggregate party columns.

Counterevidence and remaining uncertainty:
- The prototype avoids reconstructing aggregate f/F after sharing and documents limitations; that does not isolate inputs or columns.
- The crate and functions explicitly identify themselves as research prototypes or virtual-party simulations.
- The returned DKG object contains shares, and downstream VSS detects inconsistent shares.
- No production deployment or remote coordinator exposure is established.

Limitations:
- No deployment established.
- No target code or ceremony was executed, per user instruction.
- The finding concerns the claimed participant-isolation boundary, not the mathematical correctness of honest in-process simulation.
- No production deployment or transport is in scope; this is an implementation/model boundary failure, not proof that the algebraic aggregation formula is wrong.
- The code is an explicitly in-process research prototype; no lower-trust deployed coordinator was established.

#### Dataflow

clear contributions and participant RNGs -\> coordinator-owned slices/CLI transcripts -\> central sharing and pair-seed derivation -\> aggregate trapdoor/all-column state

- **Source:** All parties' clear trapdoor contributions, RNG objects, or persisted contribution output

- **Sink:** Coordinator memory, G2Trapdoor share matrices, and shared ceremony artifacts

- **Outcome:** Complete trapdoor and pairwise-randomness recovery

**One call accepts every contribution and RNG** — `ishare.rs:2881-2889`

The coordinator calling this API necessarily owns the full contribution slice and every supplied RNG object.

```rust
pub fn dkg_trapdoor_from_weighted_contributions<R: rand::RngCore>(
    rngs: &mut [R],
    contribs: &[PartyTrapdoorContribution],
    weights: &[u64],
    xs: &[u16],
    k: u8,
    delta_known: u64,
    vss_count: usize,
) -> Result<G2Trapdoor> {
```

**Aggregate contains every party column** — `ishare.rs:3079-3098`

The same caller receives all aggregate share matrices, not one opaque party-local column.

```rust
Ok(G2Trapdoor {
    td: ITrapdoorShares {
        f: f_acc,
        g: g_acc,
        f_big: fb_acc,
        g_big: gb_acc,
    },
    f_mac,
    f_big_mac,
    vss_f,
    vss_g,
    vss_f_big,
    vss_g_big,
    vss_sh_f,
    vss_sh_g,
    vss_sh_f_big: vss_sh_fb,
    vss_sh_g_big: vss_sh_gb,
    delta,
    delta_known: dk,
})
```

**One API accepts all contributions and RNGs** — `ishare.rs:2881-2892`

One address space owns every clear contribution and nominal party RNG.

```rust
pub fn dkg_trapdoor_from_weighted_contributions<R: rand::RngCore>(
    rngs: &mut [R],
    contribs: &[PartyTrapdoorContribution],
    weights: &[u64],
    xs: &[u16],
    k: u8,
    delta_known: u64,
    vss_count: usize,
) -> Result<G2Trapdoor> {
    let n = check_xs_p(xs, k)?;
    if contribs.is_empty() || rngs.is_empty() || weights.len() != contribs.len() {
        return Err(SpikeError::PartyCountMismatch);
    }
```

**Coordinator reads every clear polynomial** — `ishare.rs:2932-2946`

Before sharing, the one caller iterates over and reads every clear summand, so it can compute the aggregate trapdoor itself.

```rust
for (ci, contrib) in contribs.iter().enumerate() {
    if contrib.f.len() != FT1536_N
        || contrib.g.len() != FT1536_N
        || contrib.f_big.len() != FT1536_N
        || contrib.g_big.len() != FT1536_N
    {
        return Err(SpikeError::PartyCountMismatch);
    }
    let rng = &mut rngs[ci % rngs.len()];
    let w = weights[ci];
    let (f_sh, f_v) = ishare_poly_with_vss_count(rng, &contrib.f, xs, k, n_vss)?;
    let (g_sh, g_v) = ishare_poly_with_vss_count(rng, &contrib.g, xs, k, n_vss)?;
    let (fb_sh, fb_v) = ishare_poly_with_vss_count(rng, &contrib.f_big, xs, k, n_vss)?;
    let (gb_sh, gb_v) = ishare_poly_with_vss_count(rng, &contrib.g_big, xs, k, n_vss)?;
```

**All share matrices returned** — `ishare.rs:3079-3098`

One signing object contains every party column for every trapdoor polynomial.

```rust
Ok(G2Trapdoor {
    td: ITrapdoorShares {
        f: f_acc,
        g: g_acc,
        f_big: fb_acc,
        g_big: gb_acc,
    },
    // ...
    delta_known: dk,
})
```

**One DKG caller supplies all party contributions and RNGs** — `ishare.rs:2881-2893`

The coordinator-facing entry point receives the complete contribution collection and the complete RNG collection in the same address space; it does not require one RNG per contribution.

```rust
pub fn dkg_trapdoor_from_weighted_contributions<R: rand::RngCore>(
    rngs: &mut [R],
    contribs: &[PartyTrapdoorContribution],
    weights: &[u64],
    xs: &[u16],
    k: u8,
    delta_known: u64,
    vss_count: usize,
) -> Result<G2Trapdoor> {
    let n = check_xs_p(xs, k)?;
    if contribs.is_empty() || rngs.is_empty() || weights.len() != contribs.len() {
        return Err(SpikeError::PartyCountMismatch);
    }
```

**Coordinator reads every clear vector and cycles caller-held RNGs** — `ishare.rs:2932-2946`

Before VSS exists, one process iterates and reads every participant's clear polynomials. Modulo indexing silently lets multiple claimed participants reuse a smaller caller-owned RNG set.

```rust
for (ci, contrib) in contribs.iter().enumerate() {
    if contrib.f.len() != FT1536_N
        || contrib.g.len() != FT1536_N
        || contrib.f_big.len() != FT1536_N
        || contrib.g_big.len() != FT1536_N
    {
        return Err(SpikeError::PartyCountMismatch);
    }
    let rng = &mut rngs[ci % rngs.len()];
    let w = weights[ci];
    let (f_sh, f_v) = ishare_poly_with_vss_count(rng, &contrib.f, xs, k, n_vss)?;
    let (g_sh, g_v) = ishare_poly_with_vss_count(rng, &contrib.g, xs, k, n_vss)?;
    let (fb_sh, fb_v) = ishare_poly_with_vss_count(rng, &contrib.f_big, xs, k, n_vss)?;
    let (gb_sh, gb_v) = ishare_poly_with_vss_count(rng, &contrib.g_big, xs, k, n_vss)?;
```

**One helper derives every nonce and pair seed and copies the full seed map** — `prss.rs:291-314`

The same caller consumes every party RNG, observes every nonce, constructs every pair seed, and installs a complete seed map in each virtual party stream, so pairwise custody is simulated rather than enforced.

```rust
pub fn pairwise_zero_streams<R: rand::RngCore>(rngs: &mut [R]) -> Vec<ZeroShareStream> {
    let n = rngs.len();
    let nonces: Vec<[u8; 8]> = rngs
        .iter_mut()
        .map(|r| {
            let mut nb = [0u8; 8];
            nb.copy_from_slice(&r.next_u64().to_le_bytes());
            nb
        })
        .collect();
    let build = || {
        let mut seeds = BTreeMap::new();
        for i in 0..n {
            for j in (i + 1)..n {
                seeds.insert((i, j), pair_seed(&nonces[i], &nonces[j]));
            }
        }
        seeds
    };
    (0..n).map(|me| ZeroShareStream::new(me, n, build())).collect()
}
```

**Clear party contribution type** — `ishare.rs:2800-2809`

Each supposedly party-local secret contribution is a cloneable object with four public clear vectors.

```rust
/// Partia zna **wyłącznie** swój wkład. Pełny klucz f = Σ f_c
/// dokładna suma całkowita) **nie powstaje w clear** w torze
/// [`dkg_trapdoor_from_contributions`] — tam wyłącznie sumowane są udziały.
#[derive(Clone)]
pub struct PartyTrapdoorContribution {
    pub f: Vec<i16>,
    pub g: Vec<i16>,
    pub f_big: Vec<i16>,
    pub g_big: Vec<i16>,
}
```

#### Reachability

Requires the in-process research helpers or shared artifact flow to be used as a boundary against a coordinator or peer that is not already trusted with all participant secrets.

- **Attacker:** Compromised coordinator or reader of shared ceremony artifacts

- **Entry point:** Weighted DKG, pairwise PRSS helpers, or `iso dkg`/`dkg5` workdir

- **Outcome:** Complete signing-key recovery and loss of threshold randomness isolation

Preconditions:
- The prototype helpers or shared workdir are used as the participant boundary.
- The coordinator or artifact reader is not authorized to know every contribution and RNG state.

Limitations:
- A fully trusted simulator already authorized for all logical-party state gains no additional privilege.
- The CLI contribution disclosure is an explicit oracle/test moment and is not used as independent impact evidence.

#### Severity

**Medium** — Impact is complete signing-key compromise and loss of PRSS compartmentalization, but these are explicit in-process research/prototype flows and no deployed lower-trust coordinator is established.

Raise to high if these helpers or CLI artifacts form a production participant boundary; lower only if the coordinator and artifact readers are explicitly fully trusted with every participant secret and RNG.

Impact assessment:
- **Level:** high
- **Why:** All contributions or all threshold columns reveal the aggregate signing trapdoor; centralized PRSS state defeats pairwise randomness compartmentalization.

Likelihood assessment:
- **Level:** unknown
- **Why:** No production distributed embedding is established.

#### Remediation

Generate each contribution and its sharing polynomial inside an isolated participant process or capability, and send the aggregator only authenticated commitments and recipient-specific shares—never clear contribution vectors or RNG state. Likewise derive PRSS pair state only at its endpoint parties and replace shared cleartext CLI artifacts with authenticated recipient-specific transport and isolation.

Tests:
- Assert each participant process can reach only its local contribution and one column.
- Reject mismatched participant/RNG ownership.
- Show one compromised process cannot reconstruct f/g/F/G.
- Run a multi-process DKG access audit proving each process reads only its own clear contribution and received shares.
- Assert that the coordinator API cannot accept or expose `PartyTrapdoorContribution` or party RNG objects.
- Run DKG with isolated party processes and assert the coordinator cannot access any clear contribution or k distinct output columns.
- Compile-time/API test: the coordinator-facing result exposes only public commitments/transcript data.

Preventive controls:
- Private zeroizing per-party containers.
- Session/contributor/recipient binding.
- Make secret contribution fields private, move-only, and zeroizing.
- Bind participant identity, session, weights, commitments, and transcript with authenticated messages.
- Use opaque party-local share types and authenticated point-to-point messages.
- Remove Clone and public fields from clear contribution containers.

<a id="finding-9"></a>

### [9] Exposed G2 MAC key and post-hoc product tags permit correlated forgeries

| Field | Value |
| --- | --- |
| Severity | medium |
| Confidence | high |
| Confidence rationale | The exposed field, linear MAC constructors, hidden-delta equation and final signing consumers directly prove the correlated forgery. |
| Category | Cryptographic MAC key exposure / improper signature verification |
| CWE | CWE-347, CWE-354, CWE-345 |
| Affected lines | ishare.rs:1748-1757, ishare.rs:1763-1787, ishare.rs:2671-2685, ishare.rs:3063-3098, ishare.rs:3274-3302, ishare.rs:1750, ishare.rs:1911, ishare.rs:2672, ishare.rs:3274, ishare.rs:1911-1921, ishare.rs:3274-3302, ishare.rs:1682-1710, ishare.rs:2672-2685, ishare.rs:3274-3301, ishare.rs:1675, ishare.rs:1748, ishare.rs:2671, ishare.rs:3063, ishare.rs:3274, ishare.rs:2672-2685, proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:1612-1625, proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:2671-2686 |

#### Summary

The G2 signing state exposes the complete `delta_known`, so a malicious participant can change a value share by Δ and its MAC share by `delta_known·Δ`; the Lagrange-weighted hidden-delta zero check still accepts. G2 signing also computes ring products before deriving fresh tags as `delta_known * product_share`, blessing already-untrusted arithmetic and allowing correlated corruption of masks, products, or final `s1`/`s2`. Value-only or MAC-only tests do not exercise this paired forgery; the distinct unchecked-Beaver-`c` preprocessing flaw remains tracked separately.

#### Root Cause

The global MAC key is participant-visible and tags are constructed linearly from current, potentially untrusted values—including after ring multiplication—so correlated value/MAC changes preserve the verifier equation.

**G2 object exposes the MAC key** — `ishare.rs:2671-2685`

Any participant/caller holding the signing object can read the global key needed to forge correlated MAC changes.

```rust
pub struct G2Trapdoor {
    pub td: ITrapdoorShares,
    pub f_mac: IPolyShares,
    pub f_big_mac: IPolyShares,
    // ...
    pub delta: ZpDeltaShares,
    pub delta_known: u64,
}
```

**MACs are public-key multiples of current shares** — `ishare.rs:1748-1757`

The attacker can compute a valid MAC adjustment for any chosen share adjustment.

```rust
pub fn zp_mac_linearity(val: &[u64], delta_known: u64) -> Vec<u64> {
    let dk = delta_known % I_P;
    val.iter().map(|&s| p_mul(dk, s)).collect()
}

pub fn zp_mac_poly_linearity(val: &IPolyShares, delta_known: u64) -> IPolyShares {
    val.iter().map(|col| zp_mac_linearity(col, delta_known)).collect()
}
```

**MAC is derived from already computed product shares** — `ishare.rs:1911-1921`

Authentication is added after unauthenticated multiplication with the exposed key.

```rust
pub fn i_poly_mul_ring_shares_mac(
    rng: &mut impl rand::RngCore,
    a: &IPolyShares,
    b: &IPolyShares,
    xs: &[u16],
    k: u8,
    delta_known: u64,
) -> Result<(IPolyShares, IPolyShares)> {
    let prod = i_poly_mul_ring_shares(rng, a, b, xs, k)?;
    let mac = zp_mac_poly_linearity(&prod, delta_known);
    Ok((prod, mac))
}
```

**Opening checks only the linear equation** — `ishare.rs:1773-1787`

Adding Δ to a value share and δΔ to its MAC leaves every checked difference unchanged.

```rust
let x = ireconstruct_val(xs, val_shares)?;
let dk = delta_known % I_P;
let mut zs = Vec::with_capacity(n);
for i in 0..n {
    let expect_mac = p_mul(dk, val_shares[i]);
    zs.push(p_sub(mac_shares[i], expect_mac));
}
let z = ireconstruct_val(xs, &zs)?;
if z != 0 {
    return Err(SpikeError::MacFail);
}
Ok(x)
```

**Signer authenticates products with the same public key** — `ishare.rs:3274-3302`

The signing outcome relies on MACs derived with the exposed scalar before hidden-delta openings.

```rust
let (z0f, z0f_mac) = i_poly_mul_ring_shares_mac(rng, &z0, &gt.td.f, xs, k, gt.delta_known)?;
// ...
s1_mac[i][p] = p_sub(
    p_add(z0g_mac[i][p], z1g_mac[i][p]),
    p_mul(gt.delta_known % I_P, i64_to_p(t64[i])),
);
// ...
let s1_i = zp_open_poly_with_mac_hidden_delta(&s1, &s1_mac, &gt.delta, k)?;
let s2_i = zp_open_poly_with_mac_hidden_delta(&s2, &s2_mac, &gt.delta, k)?;
```

**G2 signer selects post-hoc MAC multiplication** — `ishare.rs:3274-3278`

All four security-relevant ring products in the G2 signing entry path are routed through the cheaper helper rather than the authenticated-triple implementation.

```rust
let (z0f, z0f_mac) = i_poly_mul_ring_shares_mac(rng, &z0, &gt.td.f, xs, k, gt.delta_known)?;
let (z1f, z1f_mac) = i_poly_mul_ring_shares_mac(rng, &z1, &gt.td.f_big, xs, k, gt.delta_known)?;
let (z0g, z0g_mac) = i_poly_mul_ring_shares_mac(rng, &z0, &gt.td.g, xs, k, gt.delta_known)?;
let (z1g, z1g_mac) = i_poly_mul_ring_shares_mac(rng, &z1, &gt.td.g_big, xs, k, gt.delta_known)?;
```

**MAC is calculated from the already computed product** — `ishare.rs:1911-1921`

Any corruption already present in `prod` is copied into a matching MAC with the known scalar, so this step does not independently authenticate the multiplication.

```rust
pub fn i_poly_mul_ring_shares_mac(
    rng: &mut impl rand::RngCore,
    a: &IPolyShares,
    b: &IPolyShares,
    xs: &[u16],
    k: u8,
    delta_known: u64,
) -> Result<(IPolyShares, IPolyShares)> {
    let prod = i_poly_mul_ring_shares(rng, a, b, xs, k)?;
    let mac = zp_mac_poly_linearity(&prod, delta_known);
    Ok((prod, mac))
}
```

**Aggregate exposes the MAC scalar** — `ishare.rs:2672-2685`

The same aggregate that carries participant-indexed trapdoor shares also exposes `delta_known`, so it cannot serve as an unknown authentication secret at this boundary.

```rust
pub struct G2Trapdoor {
    pub td: ITrapdoorShares,
    pub f_mac: IPolyShares,
    pub f_big_mac: IPolyShares,
    pub vss_f: IPolyVss,
    pub vss_g: IPolyVss,
    pub vss_f_big: IPolyVss,
    pub vss_g_big: IPolyVss,
    pub vss_sh_f: IPolyVssShares,
    pub vss_sh_g: IPolyVssShares,
    pub vss_sh_f_big: IPolyVssShares,
    pub vss_sh_g_big: IPolyVssShares,
    pub delta: ZpDeltaShares,
    pub delta_known: u64,
}
```

**Final opening verifies only the linear relation** — `ishare.rs:1698-1710`

Because the post-hoc MAC reconstructs to `delta_known * x` and the delta shares reconstruct the same scalar, correlated value/MAC changes make `z` reconstruct to zero.

```rust
let val_shares: Vec<u64> = shares.iter().map(|s| s.share).collect();
let x = ireconstruct_val(&delta_shares.xs, &val_shares)?;
let mut zs: Vec<u64> = Vec::with_capacity(shares.len());
for (s, &d_i) in shares.iter().zip(&delta_shares.shares) {
    zs.push(p_sub(s.mac, p_mul(i64_to_p(x), d_i)));
}
let z = ireconstruct_val(&delta_shares.xs, &zs)?;
if z != 0 {
    return Err(SpikeError::MacFail);
}
Ok(x)
```

**Caller treats the opening as a ring-tamper check** — `ishare.rs:3299-3302`

The signer relies on this final check for ring-multiplication tamper detection, but the value and MAC reaching it were derived together.

```rust
// Open s1, s2 z kontrolą MAC (ukryte δ) — T9.3: tamper ring-mul → MacFail
let s1_i = zp_open_poly_with_mac_hidden_delta(&s1, &s1_mac, &gt.delta, k)?;
let s2_i = zp_open_poly_with_mac_hidden_delta(&s2, &s2_mac, &gt.delta, k)?;
Ok((s1_i, s2_i, cost))
```

**Aggregate object exposes MAC key** — `ishare.rs:2671-2685`

The object described as having hidden delta also exposes the complete key needed to forge correlated tags.

```rust
/// G-2 trapdoor: udziały + MAC f/F + VSS + ukryte δ.
pub struct G2Trapdoor {
    pub td: ITrapdoorShares,
    pub f_mac: IPolyShares,
    pub f_big_mac: IPolyShares,
    pub vss_f: IPolyVss,
    pub vss_g: IPolyVss,
    pub vss_f_big: IPolyVss,
    pub vss_g_big: IPolyVss,
    pub vss_sh_f: IPolyVssShares,
    pub vss_sh_g: IPolyVssShares,
    pub vss_sh_f_big: IPolyVssShares,
    pub vss_sh_g_big: IPolyVssShares,
    pub delta: ZpDeltaShares,
    pub delta_known: u64,
}
```

**Unauthenticated product gets a fresh tag** — `ishare.rs:1911-1921`

Authentication is created only after the semi-honest computation, so a corrupted result is treated as authentic.

```rust
pub fn i_poly_mul_ring_shares_mac(
    rng: &mut impl rand::RngCore,
    a: &IPolyShares,
    b: &IPolyShares,
    xs: &[u16],
    k: u8,
    delta_known: u64,
) -> Result<(IPolyShares, IPolyShares)> {
    let prod = i_poly_mul_ring_shares(rng, a, b, xs, k)?;
    let mac = zp_mac_poly_linearity(&prod, delta_known);
    Ok((prod, mac))
}
```

**Signing relies on post-hoc MACs** — `ishare.rs:3274-3301`

The final integrity decision consumes tags created from the just-computed results using the known global key.

```rust
let (z0f, z0f_mac) = i_poly_mul_ring_shares_mac(rng, &z0, &gt.td.f, xs, k, gt.delta_known)?;
let (z1f, z1f_mac) = i_poly_mul_ring_shares_mac(rng, &z1, &gt.td.f_big, xs, k, gt.delta_known)?;
let (z0g, z0g_mac) = i_poly_mul_ring_shares_mac(rng, &z0, &gt.td.g, xs, k, gt.delta_known)?;
let (z1g, z1g_mac) = i_poly_mul_ring_shares_mac(rng, &z1, &gt.td.g_big, xs, k, gt.delta_known)?;
// ...
let s1_i = zp_open_poly_with_mac_hidden_delta(&s1, &s1_mac, &gt.delta, k)?;
let s2_i = zp_open_poly_with_mac_hidden_delta(&s2, &s2_mac, &gt.delta, k)?;
```

**G2Trapdoor exposes the global MAC key** — `ishare.rs:2672-2686`

Every holder of the sign-capable trapdoor also learns the scalar needed to forge matching value/MAC changes.

```rust
pub struct G2Trapdoor {
    pub td: ITrapdoorShares,
    pub f_mac: IPolyShares,
    pub f_big_mac: IPolyShares,
    // ...
    pub delta: ZpDeltaShares,
    pub delta_known: u64,
}
```

**MAC is derived from the current share value** — `ishare.rs:1750-1760`

The code authenticates whatever value is present at MAC-generation time instead of checking it against previously established authentication state.

```rust
pub fn zp_mac_linearity(val: &[u64], delta_known: u64) -> Vec<u64> {
    let dk = delta_known % I_P;
    val.iter().map(|&s| p_mul(dk, s)).collect()
}

pub fn zp_mac_poly_linearity(val: &IPolyShares, delta_known: u64) -> IPolyShares {
    val.iter().map(|col| zp_mac_linearity(col, delta_known)).collect()
}
```

**Signer uses product-then-MAC path** — `ishare.rs:3275-3282`

The G2 signing path passes the exposed key into four computations that generate MACs from current products before final hidden-delta opening.

```rust
let (z0f, z0f_mac) = i_poly_mul_ring_shares_mac(rng, &z0, &gt.td.f, xs, k, gt.delta_known)?;
let (z1f, z1f_mac) = i_poly_mul_ring_shares_mac(rng, &z1, &gt.td.f_big, xs, k, gt.delta_known)?;
let (z0g, z0g_mac) = i_poly_mul_ring_shares_mac(rng, &z0, &gt.td.g, xs, k, gt.delta_known)?;
let (z1g, z1g_mac) = i_poly_mul_ring_shares_mac(rng, &z1, &gt.td.g_big, xs, k, gt.delta_known)?;
```

**Complete MAC scalar is public in the signing object** — `ishare.rs:2671-2685`

A participant or caller holding the G2 signing object can read the complete scalar needed to update a MAC consistently with any chosen share change.

```rust
pub struct G2Trapdoor {
    pub td: ITrapdoorShares,
    pub f_mac: IPolyShares,
    pub f_big_mac: IPolyShares,
    // ...
    pub delta: ZpDeltaShares,
    pub delta_known: u64,
}
```

**MACs are recomputed from values with the known scalar** — `ishare.rs:1748-1757`

The public construction exposes the exact transformation an attacker uses to preserve authentication after modifying a value share.

```rust
pub fn zp_mac_linearity(val: &[u64], delta_known: u64) -> Vec<u64> {
    let dk = delta_known % I_P;
    val.iter().map(|&s| p_mul(dk, s)).collect()
}

pub fn zp_mac_poly_linearity(val: &IPolyShares, delta_known: u64) -> IPolyShares {
    val.iter().map(|col| zp_mac_linearity(col, delta_known)).collect()
}
```

**Ring product is authenticated only after computation** — `ishare.rs:1907-1921`

Potentially manipulated multiplication results receive fresh matching tags instead of carrying authenticated preprocessing through the operation.

```rust
pub fn i_poly_mul_ring_shares_mac(
    rng: &mut impl rand::RngCore,
    a: &IPolyShares,
    b: &IPolyShares,
    xs: &[u16],
    k: u8,
    delta_known: u64,
) -> Result<(IPolyShares, IPolyShares)> {
    let prod = i_poly_mul_ring_shares(rng, a, b, xs, k)?;
    let mac = zp_mac_poly_linearity(&prod, delta_known);
    Ok((prod, mac))
}
```

**Final check verifies only the linear MAC equation** — `ishare.rs:1698-1710`

For a correlated change, reconstructed value and MAC shift by the same delta-scaled Lagrange term, leaving reconstructed `z` equal to zero.

```rust
let val_shares: Vec<u64> = shares.iter().map(|s| s.share).collect();
let x = ireconstruct_val(&delta_shares.xs, &val_shares)?;
let mut zs: Vec<u64> = Vec::with_capacity(shares.len());
for (s, &d_i) in shares.iter().zip(&delta_shares.shares) {
    zs.push(p_sub(s.mac, p_mul(i64_to_p(x), d_i)));
}
let z = ireconstruct_val(&delta_shares.xs, &zs)?;
if z != 0 { return Err(SpikeError::MacFail); }
Ok(x)
```

**G2 signing consumes post-computation MACs and opens final outputs** — `ishare.rs:3274-3302`

The forged relation reaches the security-sensitive signing output because the principal G2 signer uses the weak helper and relies on the same check for final acceptance.

```rust
let (z0f, z0f_mac) = i_poly_mul_ring_shares_mac(rng, &z0, &gt.td.f, xs, k, gt.delta_known)?;
let (z1f, z1f_mac) = i_poly_mul_ring_shares_mac(rng, &z1, &gt.td.f_big, xs, k, gt.delta_known)?;
// ... assemble s1/s2 and their MACs ...
let s1_i = zp_open_poly_with_mac_hidden_delta(&s1, &s1_mac, &gt.delta, k)?;
let s2_i = zp_open_poly_with_mac_hidden_delta(&s2, &s2_mac, &gt.delta, k)?;
```

**G2 object exposes the MAC scalar** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:2671-2686`

Any component receiving the signing object can read the scalar needed to create a matching tag for an arbitrary share change.

```rust
pub struct G2Trapdoor {
    pub td: ITrapdoorShares,
    pub f_mac: IPolyShares,
    pub f_big_mac: IPolyShares,
    // ... VSS and delta shares ...
    pub delta: ZpDeltaShares,
    pub delta_known: u64,
}
```

**Tags are directly recomputable from value shares** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:1748-1757`

The public helper implements exactly the correlated MAC adjustment available to a malicious participant that knows `delta_known`.

```rust
pub fn zp_mac_linearity(val: &[u64], delta_known: u64) -> Vec<u64> {
    let dk = delta_known % I_P;
    val.iter().map(|&s| p_mul(dk, s)).collect()
}
```

**Opening checks only the aggregate linear equation** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:1698-1710`

Paired changes `share += e` and `mac += delta_known*e` change both reconstructions consistently, leaving the reconstructed check value zero.

```rust
let val_shares: Vec<u64> = shares.iter().map(|s| s.share).collect();
let x = ireconstruct_val(&delta_shares.xs, &val_shares)?;
let mut zs: Vec<u64> = Vec::with_capacity(shares.len());
for (s, &d_i) in shares.iter().zip(&delta_shares.shares) {
    zs.push(p_sub(s.mac, p_mul(i64_to_p(x), d_i)));
}
let z = ireconstruct_val(&delta_shares.xs, &zs)?;
if z != 0 { return Err(SpikeError::MacFail); }
```

**Signer uses products tagged after unauthenticated multiplication** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:3274-3278`

The active signer uses the cheaper multiplication path whose output MAC is minted after the result exists, rather than preserving authenticated computation through verified triples.

```rust
let (z0f, z0f_mac) = i_poly_mul_ring_shares_mac(rng, &z0, &gt.td.f, xs, k, gt.delta_known)?;
let (z1f, z1f_mac) = i_poly_mul_ring_shares_mac(rng, &z1, &gt.td.f_big, xs, k, gt.delta_known)?;
let (z0g, z0g_mac) = i_poly_mul_ring_shares_mac(rng, &z0, &gt.td.g, xs, k, gt.delta_known)?;
let (z1g, z1g_mac) = i_poly_mul_ring_shares_mac(rng, &z1, &gt.td.g_big, xs, k, gt.delta_known)?;
```

#### Validation

The public δ field, directly recomputable linear tags, and hidden-delta equation prove that paired `(value+e, mac+δe)` changes preserve the checked residual, including under interpolation. A fresh tag over an already-untrusted product cannot establish honest multiplication; existing independent value-only or MAC-only tests do not cover this attack.

Validation method: Static source trace and algebraic validation of correlated edits and the active post-hoc ring-product path; static algebraic validation; static algebraic source trace

- **Status:** validated

**G2 object exposes the MAC key** — `ishare.rs:2671-2685`

Any participant/caller holding the signing object can read the global key needed to forge correlated MAC changes.

```rust
pub struct G2Trapdoor {
    pub td: ITrapdoorShares,
    pub f_mac: IPolyShares,
    pub f_big_mac: IPolyShares,
    // ...
    pub delta: ZpDeltaShares,
    pub delta_known: u64,
}
```

**MACs are public-key multiples of current shares** — `ishare.rs:1748-1757`

The attacker can compute a valid MAC adjustment for any chosen share adjustment.

```rust
pub fn zp_mac_linearity(val: &[u64], delta_known: u64) -> Vec<u64> {
    let dk = delta_known % I_P;
    val.iter().map(|&s| p_mul(dk, s)).collect()
}

pub fn zp_mac_poly_linearity(val: &IPolyShares, delta_known: u64) -> IPolyShares {
    val.iter().map(|col| zp_mac_linearity(col, delta_known)).collect()
}
```

**MAC is derived from already computed product shares** — `ishare.rs:1911-1921`

Authentication is added after unauthenticated multiplication with the exposed key.

```rust
pub fn i_poly_mul_ring_shares_mac(
    rng: &mut impl rand::RngCore,
    a: &IPolyShares,
    b: &IPolyShares,
    xs: &[u16],
    k: u8,
    delta_known: u64,
) -> Result<(IPolyShares, IPolyShares)> {
    let prod = i_poly_mul_ring_shares(rng, a, b, xs, k)?;
    let mac = zp_mac_poly_linearity(&prod, delta_known);
    Ok((prod, mac))
}
```

**Opening checks only the linear equation** — `ishare.rs:1773-1787`

Adding Δ to a value share and δΔ to its MAC leaves every checked difference unchanged.

```rust
let x = ireconstruct_val(xs, val_shares)?;
let dk = delta_known % I_P;
let mut zs = Vec::with_capacity(n);
for i in 0..n {
    let expect_mac = p_mul(dk, val_shares[i]);
    zs.push(p_sub(mac_shares[i], expect_mac));
}
let z = ireconstruct_val(xs, &zs)?;
if z != 0 {
    return Err(SpikeError::MacFail);
}
Ok(x)
```

**Signer authenticates products with the same public key** — `ishare.rs:3274-3302`

The signing outcome relies on MACs derived with the exposed scalar before hidden-delta openings.

```rust
let (z0f, z0f_mac) = i_poly_mul_ring_shares_mac(rng, &z0, &gt.td.f, xs, k, gt.delta_known)?;
// ...
s1_mac[i][p] = p_sub(
    p_add(z0g_mac[i][p], z1g_mac[i][p]),
    p_mul(gt.delta_known % I_P, i64_to_p(t64[i])),
);
// ...
let s1_i = zp_open_poly_with_mac_hidden_delta(&s1, &s1_mac, &gt.delta, k)?;
let s2_i = zp_open_poly_with_mac_hidden_delta(&s2, &s2_mac, &gt.delta, k)?;
```

**G2 signer selects post-hoc MAC multiplication** — `ishare.rs:3274-3278`

All four security-relevant ring products in the G2 signing entry path are routed through the cheaper helper rather than the authenticated-triple implementation.

```rust
let (z0f, z0f_mac) = i_poly_mul_ring_shares_mac(rng, &z0, &gt.td.f, xs, k, gt.delta_known)?;
let (z1f, z1f_mac) = i_poly_mul_ring_shares_mac(rng, &z1, &gt.td.f_big, xs, k, gt.delta_known)?;
let (z0g, z0g_mac) = i_poly_mul_ring_shares_mac(rng, &z0, &gt.td.g, xs, k, gt.delta_known)?;
let (z1g, z1g_mac) = i_poly_mul_ring_shares_mac(rng, &z1, &gt.td.g_big, xs, k, gt.delta_known)?;
```

**MAC is calculated from the already computed product** — `ishare.rs:1911-1921`

Any corruption already present in `prod` is copied into a matching MAC with the known scalar, so this step does not independently authenticate the multiplication.

```rust
pub fn i_poly_mul_ring_shares_mac(
    rng: &mut impl rand::RngCore,
    a: &IPolyShares,
    b: &IPolyShares,
    xs: &[u16],
    k: u8,
    delta_known: u64,
) -> Result<(IPolyShares, IPolyShares)> {
    let prod = i_poly_mul_ring_shares(rng, a, b, xs, k)?;
    let mac = zp_mac_poly_linearity(&prod, delta_known);
    Ok((prod, mac))
}
```

**Aggregate exposes the MAC scalar** — `ishare.rs:2672-2685`

The same aggregate that carries participant-indexed trapdoor shares also exposes `delta_known`, so it cannot serve as an unknown authentication secret at this boundary.

```rust
pub struct G2Trapdoor {
    pub td: ITrapdoorShares,
    pub f_mac: IPolyShares,
    pub f_big_mac: IPolyShares,
    pub vss_f: IPolyVss,
    pub vss_g: IPolyVss,
    pub vss_f_big: IPolyVss,
    pub vss_g_big: IPolyVss,
    pub vss_sh_f: IPolyVssShares,
    pub vss_sh_g: IPolyVssShares,
    pub vss_sh_f_big: IPolyVssShares,
    pub vss_sh_g_big: IPolyVssShares,
    pub delta: ZpDeltaShares,
    pub delta_known: u64,
}
```

**Final opening verifies only the linear relation** — `ishare.rs:1698-1710`

Because the post-hoc MAC reconstructs to `delta_known * x` and the delta shares reconstruct the same scalar, correlated value/MAC changes make `z` reconstruct to zero.

```rust
let val_shares: Vec<u64> = shares.iter().map(|s| s.share).collect();
let x = ireconstruct_val(&delta_shares.xs, &val_shares)?;
let mut zs: Vec<u64> = Vec::with_capacity(shares.len());
for (s, &d_i) in shares.iter().zip(&delta_shares.shares) {
    zs.push(p_sub(s.mac, p_mul(i64_to_p(x), d_i)));
}
let z = ireconstruct_val(&delta_shares.xs, &zs)?;
if z != 0 {
    return Err(SpikeError::MacFail);
}
Ok(x)
```

**Aggregate object exposes MAC key** — `ishare.rs:2671-2685`

The object described as having hidden delta also exposes the complete key needed to forge correlated tags.

```rust
/// G-2 trapdoor: udziały + MAC f/F + VSS + ukryte δ.
pub struct G2Trapdoor {
    pub td: ITrapdoorShares,
    pub f_mac: IPolyShares,
    pub f_big_mac: IPolyShares,
    pub vss_f: IPolyVss,
    pub vss_g: IPolyVss,
    pub vss_f_big: IPolyVss,
    pub vss_g_big: IPolyVss,
    pub vss_sh_f: IPolyVssShares,
    pub vss_sh_g: IPolyVssShares,
    pub vss_sh_f_big: IPolyVssShares,
    pub vss_sh_g_big: IPolyVssShares,
    pub delta: ZpDeltaShares,
    pub delta_known: u64,
}
```

**Unauthenticated product gets a fresh tag** — `ishare.rs:1911-1921`

Authentication is created only after the semi-honest computation, so a corrupted result is treated as authentic.

```rust
pub fn i_poly_mul_ring_shares_mac(
    rng: &mut impl rand::RngCore,
    a: &IPolyShares,
    b: &IPolyShares,
    xs: &[u16],
    k: u8,
    delta_known: u64,
) -> Result<(IPolyShares, IPolyShares)> {
    let prod = i_poly_mul_ring_shares(rng, a, b, xs, k)?;
    let mac = zp_mac_poly_linearity(&prod, delta_known);
    Ok((prod, mac))
}
```

**Signing relies on post-hoc MACs** — `ishare.rs:3274-3301`

The final integrity decision consumes tags created from the just-computed results using the known global key.

```rust
let (z0f, z0f_mac) = i_poly_mul_ring_shares_mac(rng, &z0, &gt.td.f, xs, k, gt.delta_known)?;
let (z1f, z1f_mac) = i_poly_mul_ring_shares_mac(rng, &z1, &gt.td.f_big, xs, k, gt.delta_known)?;
let (z0g, z0g_mac) = i_poly_mul_ring_shares_mac(rng, &z0, &gt.td.g, xs, k, gt.delta_known)?;
let (z1g, z1g_mac) = i_poly_mul_ring_shares_mac(rng, &z1, &gt.td.g_big, xs, k, gt.delta_known)?;
// ...
let s1_i = zp_open_poly_with_mac_hidden_delta(&s1, &s1_mac, &gt.delta, k)?;
let s2_i = zp_open_poly_with_mac_hidden_delta(&s2, &s2_mac, &gt.delta, k)?;
```

**G2Trapdoor exposes the global MAC key** — `ishare.rs:2672-2686`

Every holder of the sign-capable trapdoor also learns the scalar needed to forge matching value/MAC changes.

```rust
pub struct G2Trapdoor {
    pub td: ITrapdoorShares,
    pub f_mac: IPolyShares,
    pub f_big_mac: IPolyShares,
    // ...
    pub delta: ZpDeltaShares,
    pub delta_known: u64,
}
```

**MAC is derived from the current share value** — `ishare.rs:1750-1760`

The code authenticates whatever value is present at MAC-generation time instead of checking it against previously established authentication state.

```rust
pub fn zp_mac_linearity(val: &[u64], delta_known: u64) -> Vec<u64> {
    let dk = delta_known % I_P;
    val.iter().map(|&s| p_mul(dk, s)).collect()
}

pub fn zp_mac_poly_linearity(val: &IPolyShares, delta_known: u64) -> IPolyShares {
    val.iter().map(|col| zp_mac_linearity(col, delta_known)).collect()
}
```

**Signer uses product-then-MAC path** — `ishare.rs:3275-3282`

The G2 signing path passes the exposed key into four computations that generate MACs from current products before final hidden-delta opening.

```rust
let (z0f, z0f_mac) = i_poly_mul_ring_shares_mac(rng, &z0, &gt.td.f, xs, k, gt.delta_known)?;
let (z1f, z1f_mac) = i_poly_mul_ring_shares_mac(rng, &z1, &gt.td.f_big, xs, k, gt.delta_known)?;
let (z0g, z0g_mac) = i_poly_mul_ring_shares_mac(rng, &z0, &gt.td.g, xs, k, gt.delta_known)?;
let (z1g, z1g_mac) = i_poly_mul_ring_shares_mac(rng, &z1, &gt.td.g_big, xs, k, gt.delta_known)?;
```

**Complete MAC scalar is public in the signing object** — `ishare.rs:2671-2685`

A participant or caller holding the G2 signing object can read the complete scalar needed to update a MAC consistently with any chosen share change.

```rust
pub struct G2Trapdoor {
    pub td: ITrapdoorShares,
    pub f_mac: IPolyShares,
    pub f_big_mac: IPolyShares,
    // ...
    pub delta: ZpDeltaShares,
    pub delta_known: u64,
}
```

**MACs are recomputed from values with the known scalar** — `ishare.rs:1748-1757`

The public construction exposes the exact transformation an attacker uses to preserve authentication after modifying a value share.

```rust
pub fn zp_mac_linearity(val: &[u64], delta_known: u64) -> Vec<u64> {
    let dk = delta_known % I_P;
    val.iter().map(|&s| p_mul(dk, s)).collect()
}

pub fn zp_mac_poly_linearity(val: &IPolyShares, delta_known: u64) -> IPolyShares {
    val.iter().map(|col| zp_mac_linearity(col, delta_known)).collect()
}
```

**Final check verifies only the linear MAC equation** — `ishare.rs:1698-1710`

For a correlated change, reconstructed value and MAC shift by the same delta-scaled Lagrange term, leaving reconstructed `z` equal to zero.

```rust
let val_shares: Vec<u64> = shares.iter().map(|s| s.share).collect();
let x = ireconstruct_val(&delta_shares.xs, &val_shares)?;
let mut zs: Vec<u64> = Vec::with_capacity(shares.len());
for (s, &d_i) in shares.iter().zip(&delta_shares.shares) {
    zs.push(p_sub(s.mac, p_mul(i64_to_p(x), d_i)));
}
let z = ireconstruct_val(&delta_shares.xs, &zs)?;
if z != 0 { return Err(SpikeError::MacFail); }
Ok(x)
```

**G2 signing consumes post-computation MACs and opens final outputs** — `ishare.rs:3274-3302`

The forged relation reaches the security-sensitive signing output because the principal G2 signer uses the weak helper and relies on the same check for final acceptance.

```rust
let (z0f, z0f_mac) = i_poly_mul_ring_shares_mac(rng, &z0, &gt.td.f, xs, k, gt.delta_known)?;
let (z1f, z1f_mac) = i_poly_mul_ring_shares_mac(rng, &z1, &gt.td.f_big, xs, k, gt.delta_known)?;
// ... assemble s1/s2 and their MACs ...
let s1_i = zp_open_poly_with_mac_hidden_delta(&s1, &s1_mac, &gt.delta, k)?;
let s2_i = zp_open_poly_with_mac_hidden_delta(&s2, &s2_mac, &gt.delta, k)?;
```

**G2 object exposes the MAC scalar** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:2671-2686`

Any component receiving the signing object can read the scalar needed to create a matching tag for an arbitrary share change.

```rust
pub struct G2Trapdoor {
    pub td: ITrapdoorShares,
    pub f_mac: IPolyShares,
    pub f_big_mac: IPolyShares,
    // ... VSS and delta shares ...
    pub delta: ZpDeltaShares,
    pub delta_known: u64,
}
```

**Tags are directly recomputable from value shares** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:1748-1757`

The public helper implements exactly the correlated MAC adjustment available to a malicious participant that knows `delta_known`.

```rust
pub fn zp_mac_linearity(val: &[u64], delta_known: u64) -> Vec<u64> {
    let dk = delta_known % I_P;
    val.iter().map(|&s| p_mul(dk, s)).collect()
}
```

**Opening checks only the aggregate linear equation** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:1698-1710`

Paired changes `share += e` and `mac += delta_known*e` change both reconstructions consistently, leaving the reconstructed check value zero.

```rust
let val_shares: Vec<u64> = shares.iter().map(|s| s.share).collect();
let x = ireconstruct_val(&delta_shares.xs, &val_shares)?;
let mut zs: Vec<u64> = Vec::with_capacity(shares.len());
for (s, &d_i) in shares.iter().zip(&delta_shares.shares) {
    zs.push(p_sub(s.mac, p_mul(i64_to_p(x), d_i)));
}
let z = ireconstruct_val(&delta_shares.xs, &zs)?;
if z != 0 { return Err(SpikeError::MacFail); }
```

**Signer uses products tagged after unauthenticated multiplication** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:3274-3278`

The active signer uses the cheaper multiplication path whose output MAC is minted after the result exists, rather than preserving authenticated computation through verified triples.

```rust
let (z0f, z0f_mac) = i_poly_mul_ring_shares_mac(rng, &z0, &gt.td.f, xs, k, gt.delta_known)?;
let (z1f, z1f_mac) = i_poly_mul_ring_shares_mac(rng, &z1, &gt.td.f_big, xs, k, gt.delta_known)?;
let (z0g, z0g_mac) = i_poly_mul_ring_shares_mac(rng, &z0, &gt.td.g, xs, k, gt.delta_known)?;
let (z1g, z1g_mac) = i_poly_mul_ring_shares_mac(rng, &z1, &gt.td.g_big, xs, k, gt.delta_known)?;
```

Assertions:
- A coordinated value/MAC change preserves the zero residual checked at opening.
- Post-hoc authentication of an unauthenticated product cannot establish that the product was computed honestly.
- G2 signing does not call `i_poly_mul_ring_shares_auth()`.
- `i_poly_mul_ring_shares_mac()` creates the MAC after the unauthenticated product exists.
- `g` and `g_big` have no independently stored MAC fields analogous to `f_mac` and `f_big_mac`.
- Existing value-only or MAC-only mutation tests do not exercise correlated forgery.
- `triple.c[i].mac` is not read by the authenticated multiplication primitive.
- Hidden-delta opening is sound if delta is actually secret.
- G2 comments explicitly mark known delta as retained/test model.
- Complete delta is readable.
- The signer uses post-computation tags.
- Correlated changes preserve the equation.

Counterevidence and remaining uncertainty:
- Hidden-delta functions reject uncorrelated value-only or MAC-only mutations when δ is secret.
- The source labels this path a retained/test model.
- An external signature verifier may reject some corrupted `s1`/`s2` outputs.
- The module explicitly limits the construction to a semi-honest research model.
- No in-scope distributed transport exposes an intermediate product message; current calls are tests/in-process.
- Uncorrelated changes fail.
- Source disclaims malicious security.
- Independent value-only or MAC-only mutations are detected.
- A full authenticated-triple routine exists, but G2 signing does not use it for these products.

Limitations:
- No mutually distrustful production participant deployment was established.
- No runtime execution was performed, and the extent of attacker control over a verifier-accepted signature was not demonstrated.
- No binaries or tests were executed by instruction.
- The source does not prove unauthorized signature forgery; only integrity-control bypass and corrupted output are established.
- This is a real break of active integrity, but comments explicitly describe known-delta paths as retained test models.
- The prototype disclaimer constrains severity but does not make the advertised G2 tamper check effective.
- No runtime exploit or deployed service was established.
- No runtime forgery was executed per user restriction.

#### Dataflow

participant-visible δ plus attacker-influenced share or product -\> correlated value/MAC edit or post-hoc tag -\> hidden-delta opening -\> corrupted value accepted

- **Source:** complete MAC key plus attacker-modifiable share or multiplication contribution

- **Sink:** hidden-delta openings of masks and final `s1`/`s2`

- **Outcome:** undetected signing-component corruption

**G2Trapdoor exposes the global MAC key** — `ishare.rs:2672-2686`

Every holder of the sign-capable trapdoor also learns the scalar needed to forge matching value/MAC changes.

```rust
pub struct G2Trapdoor {
    pub td: ITrapdoorShares,
    pub f_mac: IPolyShares,
    pub f_big_mac: IPolyShares,
    // ...
    pub delta: ZpDeltaShares,
    pub delta_known: u64,
}
```

**Signer uses product-then-MAC path** — `ishare.rs:3275-3282`

The G2 signing path passes the exposed key into four computations that generate MACs from current products before final hidden-delta opening.

```rust
let (z0f, z0f_mac) = i_poly_mul_ring_shares_mac(rng, &z0, &gt.td.f, xs, k, gt.delta_known)?;
let (z1f, z1f_mac) = i_poly_mul_ring_shares_mac(rng, &z1, &gt.td.f_big, xs, k, gt.delta_known)?;
let (z0g, z0g_mac) = i_poly_mul_ring_shares_mac(rng, &z0, &gt.td.g, xs, k, gt.delta_known)?;
let (z1g, z1g_mac) = i_poly_mul_ring_shares_mac(rng, &z1, &gt.td.g_big, xs, k, gt.delta_known)?;
```

**G2 object exposes the MAC key** — `ishare.rs:2671-2685`

Any participant/caller holding the signing object can read the global key needed to forge correlated MAC changes.

```rust
pub struct G2Trapdoor {
    pub td: ITrapdoorShares,
    pub f_mac: IPolyShares,
    pub f_big_mac: IPolyShares,
    // ...
    pub delta: ZpDeltaShares,
    pub delta_known: u64,
}
```

**MACs are public-key multiples of current shares** — `ishare.rs:1748-1757`

The attacker can compute a valid MAC adjustment for any chosen share adjustment.

```rust
pub fn zp_mac_linearity(val: &[u64], delta_known: u64) -> Vec<u64> {
    let dk = delta_known % I_P;
    val.iter().map(|&s| p_mul(dk, s)).collect()
}

pub fn zp_mac_poly_linearity(val: &IPolyShares, delta_known: u64) -> IPolyShares {
    val.iter().map(|col| zp_mac_linearity(col, delta_known)).collect()
}
```

**MAC is derived from already computed product shares** — `ishare.rs:1911-1921`

Authentication is added after unauthenticated multiplication with the exposed key.

```rust
pub fn i_poly_mul_ring_shares_mac(
    rng: &mut impl rand::RngCore,
    a: &IPolyShares,
    b: &IPolyShares,
    xs: &[u16],
    k: u8,
    delta_known: u64,
) -> Result<(IPolyShares, IPolyShares)> {
    let prod = i_poly_mul_ring_shares(rng, a, b, xs, k)?;
    let mac = zp_mac_poly_linearity(&prod, delta_known);
    Ok((prod, mac))
}
```

**Opening checks only the linear equation** — `ishare.rs:1773-1787`

Adding Δ to a value share and δΔ to its MAC leaves every checked difference unchanged.

```rust
let x = ireconstruct_val(xs, val_shares)?;
let dk = delta_known % I_P;
let mut zs = Vec::with_capacity(n);
for i in 0..n {
    let expect_mac = p_mul(dk, val_shares[i]);
    zs.push(p_sub(mac_shares[i], expect_mac));
}
let z = ireconstruct_val(xs, &zs)?;
if z != 0 {
    return Err(SpikeError::MacFail);
}
Ok(x)
```

**Signer authenticates products with the same public key** — `ishare.rs:3274-3302`

The signing outcome relies on MACs derived with the exposed scalar before hidden-delta openings.

```rust
let (z0f, z0f_mac) = i_poly_mul_ring_shares_mac(rng, &z0, &gt.td.f, xs, k, gt.delta_known)?;
// ...
s1_mac[i][p] = p_sub(
    p_add(z0g_mac[i][p], z1g_mac[i][p]),
    p_mul(gt.delta_known % I_P, i64_to_p(t64[i])),
);
// ...
let s1_i = zp_open_poly_with_mac_hidden_delta(&s1, &s1_mac, &gt.delta, k)?;
let s2_i = zp_open_poly_with_mac_hidden_delta(&s2, &s2_mac, &gt.delta, k)?;
```

**G2 signer selects post-hoc MAC multiplication** — `ishare.rs:3274-3278`

All four security-relevant ring products in the G2 signing entry path are routed through the cheaper helper rather than the authenticated-triple implementation.

```rust
let (z0f, z0f_mac) = i_poly_mul_ring_shares_mac(rng, &z0, &gt.td.f, xs, k, gt.delta_known)?;
let (z1f, z1f_mac) = i_poly_mul_ring_shares_mac(rng, &z1, &gt.td.f_big, xs, k, gt.delta_known)?;
let (z0g, z0g_mac) = i_poly_mul_ring_shares_mac(rng, &z0, &gt.td.g, xs, k, gt.delta_known)?;
let (z1g, z1g_mac) = i_poly_mul_ring_shares_mac(rng, &z1, &gt.td.g_big, xs, k, gt.delta_known)?;
```

**MAC is calculated from the already computed product** — `ishare.rs:1911-1921`

Any corruption already present in `prod` is copied into a matching MAC with the known scalar, so this step does not independently authenticate the multiplication.

```rust
pub fn i_poly_mul_ring_shares_mac(
    rng: &mut impl rand::RngCore,
    a: &IPolyShares,
    b: &IPolyShares,
    xs: &[u16],
    k: u8,
    delta_known: u64,
) -> Result<(IPolyShares, IPolyShares)> {
    let prod = i_poly_mul_ring_shares(rng, a, b, xs, k)?;
    let mac = zp_mac_poly_linearity(&prod, delta_known);
    Ok((prod, mac))
}
```

**Final opening verifies only the linear relation** — `ishare.rs:1698-1710`

Because the post-hoc MAC reconstructs to `delta_known * x` and the delta shares reconstruct the same scalar, correlated value/MAC changes make `z` reconstruct to zero.

```rust
let val_shares: Vec<u64> = shares.iter().map(|s| s.share).collect();
let x = ireconstruct_val(&delta_shares.xs, &val_shares)?;
let mut zs: Vec<u64> = Vec::with_capacity(shares.len());
for (s, &d_i) in shares.iter().zip(&delta_shares.shares) {
    zs.push(p_sub(s.mac, p_mul(i64_to_p(x), d_i)));
}
let z = ireconstruct_val(&delta_shares.xs, &zs)?;
if z != 0 {
    return Err(SpikeError::MacFail);
}
Ok(x)
```

**Caller treats the opening as a ring-tamper check** — `ishare.rs:3299-3302`

The signer relies on this final check for ring-multiplication tamper detection, but the value and MAC reaching it were derived together.

```rust
// Open s1, s2 z kontrolą MAC (ukryte δ) — T9.3: tamper ring-mul → MacFail
let s1_i = zp_open_poly_with_mac_hidden_delta(&s1, &s1_mac, &gt.delta, k)?;
let s2_i = zp_open_poly_with_mac_hidden_delta(&s2, &s2_mac, &gt.delta, k)?;
Ok((s1_i, s2_i, cost))
```

**MAC is derived from the current share value** — `ishare.rs:1750-1760`

The code authenticates whatever value is present at MAC-generation time instead of checking it against previously established authentication state.

```rust
pub fn zp_mac_linearity(val: &[u64], delta_known: u64) -> Vec<u64> {
    let dk = delta_known % I_P;
    val.iter().map(|&s| p_mul(dk, s)).collect()
}

pub fn zp_mac_poly_linearity(val: &IPolyShares, delta_known: u64) -> IPolyShares {
    val.iter().map(|col| zp_mac_linearity(col, delta_known)).collect()
}
```

**Complete MAC scalar is public in the signing object** — `ishare.rs:2671-2685`

A participant or caller holding the G2 signing object can read the complete scalar needed to update a MAC consistently with any chosen share change.

```rust
pub struct G2Trapdoor {
    pub td: ITrapdoorShares,
    pub f_mac: IPolyShares,
    pub f_big_mac: IPolyShares,
    // ...
    pub delta: ZpDeltaShares,
    pub delta_known: u64,
}
```

**MACs are recomputed from values with the known scalar** — `ishare.rs:1748-1757`

The public construction exposes the exact transformation an attacker uses to preserve authentication after modifying a value share.

```rust
pub fn zp_mac_linearity(val: &[u64], delta_known: u64) -> Vec<u64> {
    let dk = delta_known % I_P;
    val.iter().map(|&s| p_mul(dk, s)).collect()
}

pub fn zp_mac_poly_linearity(val: &IPolyShares, delta_known: u64) -> IPolyShares {
    val.iter().map(|col| zp_mac_linearity(col, delta_known)).collect()
}
```

**Ring product is authenticated only after computation** — `ishare.rs:1907-1921`

Potentially manipulated multiplication results receive fresh matching tags instead of carrying authenticated preprocessing through the operation.

```rust
pub fn i_poly_mul_ring_shares_mac(
    rng: &mut impl rand::RngCore,
    a: &IPolyShares,
    b: &IPolyShares,
    xs: &[u16],
    k: u8,
    delta_known: u64,
) -> Result<(IPolyShares, IPolyShares)> {
    let prod = i_poly_mul_ring_shares(rng, a, b, xs, k)?;
    let mac = zp_mac_poly_linearity(&prod, delta_known);
    Ok((prod, mac))
}
```

**G2 signing consumes post-computation MACs and opens final outputs** — `ishare.rs:3274-3302`

The forged relation reaches the security-sensitive signing output because the principal G2 signer uses the weak helper and relies on the same check for final acceptance.

```rust
let (z0f, z0f_mac) = i_poly_mul_ring_shares_mac(rng, &z0, &gt.td.f, xs, k, gt.delta_known)?;
let (z1f, z1f_mac) = i_poly_mul_ring_shares_mac(rng, &z1, &gt.td.f_big, xs, k, gt.delta_known)?;
// ... assemble s1/s2 and their MACs ...
let s1_i = zp_open_poly_with_mac_hidden_delta(&s1, &s1_mac, &gt.delta, k)?;
let s2_i = zp_open_poly_with_mac_hidden_delta(&s2, &s2_mac, &gt.delta, k)?;
```

**G2 object exposes the MAC scalar** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:2671-2686`

Any component receiving the signing object can read the scalar needed to create a matching tag for an arbitrary share change.

```rust
pub struct G2Trapdoor {
    pub td: ITrapdoorShares,
    pub f_mac: IPolyShares,
    pub f_big_mac: IPolyShares,
    // ... VSS and delta shares ...
    pub delta: ZpDeltaShares,
    pub delta_known: u64,
}
```

**Tags are directly recomputable from value shares** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:1748-1757`

The public helper implements exactly the correlated MAC adjustment available to a malicious participant that knows `delta_known`.

```rust
pub fn zp_mac_linearity(val: &[u64], delta_known: u64) -> Vec<u64> {
    let dk = delta_known % I_P;
    val.iter().map(|&s| p_mul(dk, s)).collect()
}
```

**Opening checks only the aggregate linear equation** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:1698-1710`

Paired changes `share += e` and `mac += delta_known*e` change both reconstructions consistently, leaving the reconstructed check value zero.

```rust
let val_shares: Vec<u64> = shares.iter().map(|s| s.share).collect();
let x = ireconstruct_val(&delta_shares.xs, &val_shares)?;
let mut zs: Vec<u64> = Vec::with_capacity(shares.len());
for (s, &d_i) in shares.iter().zip(&delta_shares.shares) {
    zs.push(p_sub(s.mac, p_mul(i64_to_p(x), d_i)));
}
let z = ireconstruct_val(&delta_shares.xs, &zs)?;
if z != 0 { return Err(SpikeError::MacFail); }
```

**Signer uses products tagged after unauthenticated multiplication** — `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/src/ishare.rs:3274-3278`

The active signer uses the cheaper multiplication path whose output MAC is minted after the result exists, rather than preserving authenticated computation through verified triples.

```rust
let (z0f, z0f_mac) = i_poly_mul_ring_shares_mac(rng, &z0, &gt.td.f, xs, k, gt.delta_known)?;
let (z1f, z1f_mac) = i_poly_mul_ring_shares_mac(rng, &z1, &gt.td.f_big, xs, k, gt.delta_known)?;
let (z0g, z0g_mac) = i_poly_mul_ring_shares_mac(rng, &z0, &gt.td.g, xs, k, gt.delta_known)?;
let (z1g, z1g_mac) = i_poly_mul_ring_shares_mac(rng, &z1, &gt.td.g_big, xs, k, gt.delta_known)?;
```

#### Reachability

Requires a distributed embedding where a participant can alter a share/MAC pair or multiplication contribution; none is in scope.

- **Attacker:** Malicious below-threshold signing participant able to alter its submitted value/MAC pair or multiplication contribution

- **Entry point:** G2 share and product aggregation

- **Outcome:** tamper-detection bypass and corrupted output

Preconditions:
- Participant reads `delta_known` and influences an aggregated value.
- Multi-party G2 use
- Participant can alter own submitted pair

#### Severity

**Medium** — The broken control protects signature integrity and can accept active cheating, but the code explicitly labels this retained G-2 test model and no production participant deployment is established.

Raise to high if this MAC construction protects production signing against mutually distrustful participants; lower only if all holders of G2Trapdoor are fully trusted.

Impact assessment:
- **Level:** high
- **Why:** The malicious-tamper control can accept corrupted internal or signature components; external verification may still reject the final signature.

Likelihood assessment:
- **Level:** unknown
- **Why:** The in-scope snapshot has no distributed participant transport; current uses are monolithic tests.

#### Remediation

Remove `delta_known` from participant-visible state, generate the MAC key only as secret shares, and use a malicious-secure authenticated-sharing API that propagates authentication algebraically from already authenticated operands. Never compute a fresh tag over an already-untrusted multiplication result; validate/sacrifice preprocessing, bind it to the session, and enforce single use.

Tests:
- Apply `(share+Δ, mac+δΔ)` for one participant and require rejection.
- Assert no online participant API or serialized state reveals δ.
- Verify final s1/s2 MACs originate from authenticated operations under shared delta.
- Coordinated `(value+e, mac+delta*e)` tampering must fail.
- Tamper with an intermediate multiplication result before authentication and require the protocol to abort.
- Corrupt one `g` or `g_big` share and apply the matching `delta * epsilon` change to its MAC; assert the signer returns `MacFail`.
- Corrupt an intermediate product share plus a correlated MAC share; assert authenticated multiplication rejects it.
- Assert the production G2 entry point cannot call the regression-only post-hoc MAC helper.
- Modify a value share and its MAC by the matching `delta*Δ` and require rejection.
- Inject a corrupted reshare multiplication result before final opening and require rejection.
- Modify one share by e and its MAC by delta\*e; production opening must reject.
- Assert no participant-facing type exposes or reconstructs global delta.
- Correlated value+MAC tamper must yield `MacFail`.
- No participant-facing object may expose complete delta.
- Tampered ring-product authentication must abort.
- Modify one value share by `e` and its MAC by `delta*e`; the opening must reject.
- Tamper with `triple.c` and intermediate g/G products; final signing must fail before output.

Preventive controls:
- Session-bind batch opening challenges.
- Use malicious-secure authenticated preprocessing.
- Separate per-party state and batch-check MACs under a secret-shared key.
- Keep participant state separate so no sub-threshold participant can read the complete MAC key.
- Represent setup-validated authenticated shares with an opaque type that cannot be constructed from raw value vectors.
- Remove `delta_known` from participant-visible `G2Trapdoor` state.
- Separate test-only post-hoc MAC helpers behind test configuration.
- Use a malicious-secure authenticated-sharing API that cannot represent an untagged value.
- Keep triple generation, sacrifice, session binding, and single-use consumption explicit.
- Create MACs through MPC using shared delta.
- Carry authenticated values through every operation instead of re-tagging current values.
- Participant types carry only delta shares.
- Authenticated Beaver triples.
- Keep retained path test-only.
- Use a sign-capable type that never exposes the global MAC scalar.
- Forbid post-hoc MAC construction over untrusted nonlinear results.

<a id="finding-10"></a>

### [10] Shared `iso` work directory collapses participant isolation and exposes quorum material

| Field | Value |
| --- | --- |
| Severity | medium |
| Confidence | high |
| Confidence rationale | The shared path, predictable private filenames, same executable identity and reconstruction consumers are direct source facts; only deployment permissions are unknown. |
| Category | Improper filesystem permissions / missing participant isolation |
| CWE | CWE-732 |
| Affected lines | bin/iso.rs:1-10, bin/iso.rs:81-104, bin/iso.rs:201-219, bin/iso.rs:495-548, bin/iso.rs:1200-1255, bin/iso.rs:81-100, bin/iso.rs:287-315, bin/iso.rs:325-360, bin/iso.rs:1112-1126, bin/iso.rs:1200-1221 |

#### Summary

The `iso` harness claims that each party process holds only its own material, but the dealer, participants, mailbox and coordinator all use one caller-selected directory under the same process identity. It writes every seed column, recipient-specific DKG deal, Beaver triple, MAC share and delta share under predictable names using ambient permissions, without private modes, owner/file-type checks, no-follow/exclusive creation, source-owned ACLs, or authenticated IPC. A local process with directory access can collect threshold-many sibling files or replace protocol artifacts, collapsing the intended threshold boundary.

#### Root Cause

Process separation is represented only by predictable filenames in one caller-selected filesystem namespace. Ambient permissions and shared process identity do not establish party ownership, and the code does not enforce restrictive modes, safe file creation, per-party ACLs, or authenticated sender/recipient/session binding.

**Harness claims per-process share isolation** — `bin/iso.rs:1-10`

The intended boundary is explicit: a party or mailbox process should not possess other columns or a full seed.

```rust
//! Spike 008 — izolacja procesów (granica F-13).
//!
//! **PROTOTYP.** Role jako **osobne procesy**:
//! - `dealer` — zna seed, dzieli na kolumny, **wychodzi** (sekret z nim)
//! - `party`  — trzyma **tylko własną kolumnę** (PartyView)
//! - `mailbox` — widzi wyłącznie publiczne maski (d,e) i jawne otwarcia
//!
//! Twierdzenie (wąskie): po wyjściu dealera żaden z procesów `party`/`mailbox`
//! nie ma pełnego seeda ani cudzych kolumn. To **nie** jest próg FT ani
//! malicious-secure — model dealerski, semi-honest, jeden Beaver na demonstrację.
```

**Dealer writes every private column to one directory** — `bin/iso.rs:81-104`

All threshold columns are colocated under predictable names. No restrictive mode, ownership check or per-party root is created before the files become available.

```rust
let outdir = PathBuf::from(args.first().expect("outdir"));
std::fs::create_dir_all(&outdir).unwrap();
let mut seed = [0u8; 32];
let mut f = std::fs::File::open("/dev/urandom").unwrap();
f.read_exact(&mut seed).unwrap();
let xs = [1u8, 2, 3];
let k = 2u8;
let mut cols: Vec<Vec<u8>> = vec![vec![]; 3];
for b in seed.iter() {
    let shares = shamir_share(&mut StdRngOs, *b, &xs, k).unwrap();
    for (i, s) in shares.into_iter().enumerate() {
        cols[i].push(s.share);
    }
}
for (i, col) in cols.iter().enumerate() {
    let p = outdir.join(format!("col{i}.bin"));
    std::fs::write(&p, col).unwrap();
}
```

**Every party receives a path inside the same work directory** — `bin/iso.rs:201-219`

The coordinator launches the same executable under its inherited OS authority and hands every party the common directory, so process separation does not restrict sibling-file access.

```rust
let xs = ["1", "2", "3"];
let mut party_outs = Vec::new();
for (i, x) in xs.iter().enumerate() {
    let col = workdir.join(format!("col{i}.bin"));
    let p = Command::new(&exe)
        .args([
            "party",
            col.to_str().unwrap(),
            x,
            workdir.to_str().unwrap(),
        ])
        .stdout(Stdio::piped())
        .spawn()
        .unwrap()
        .wait_with_output()
        .unwrap();
    assert!(p.status.success());
    party_outs.push(String::from_utf8_lossy(&p.stdout).into_owned());
}
```

**Recipient-specific DKG shares are placed in the common mailbox** — `bin/iso.rs:515-548`

Private per-recipient evaluations and completed columns remain enumerable in the shared namespace, giving any participant with directory read access the same inputs used to assemble other parties' columns.

```rust
for (j, x) in xs.iter().enumerate() {
    let path = mailbox.join(format!("deal{p}_{x}.bin"));
    let tmp = mailbox.join(format!("deal{p}_{x}.tmp"));
    std::fs::write(&tmp, deals[j]).unwrap();
    std::fs::rename(&tmp, &path).unwrap();
}

let deadline = std::time::Instant::now() + std::time::Duration::from_secs(20);
loop {
    let ok = (0..3).all(|q| mailbox.join(format!("deal{q}_{}.bin", xs[p])).exists());
    if ok { break; }
    if std::time::Instant::now() > deadline { panic!("timeout waiting deals for party {p}"); }
    std::thread::sleep(std::time::Duration::from_millis(2));
}
let mut col = vec![0u8; 32];
for q in 0..3 {
    let bytes = audited_read(p, &workdir, &mailbox.join(format!("deal{q}_{}.bin", xs[p]))).unwrap();
    assert_eq!(bytes.len(), 32);
    for b in 0..32 { col[b] ^= bytes[b]; }
}
std::fs::write(workdir.join(format!("col{p}.bin")), &col).unwrap();
```

**Hidden-delta mode stores and reloads every delta share together** — `bin/iso.rs:1217-1255`

The comment equates absence of a full-delta file with secrecy, but one directory contains the entire reconstruction set and the opener demonstrates that all shares are readable together.

```rust
for (i, &d_i) in ds.shares.iter().enumerate() {
    let path = workdir.join(format!("delta{i}.bin"));
    let tmp = workdir.join(format!("delta{i}.tmp"));
    std::fs::write(&tmp, [d_i]).unwrap();
    std::fs::rename(&tmp, &path).unwrap();
}
// brak delta.txt — pełnego δ nie ma na dysku
println!("MAC_DEALER_HID_DONE");
}

fn cmd_mac_open_hid(args: &[String]) {
    let workdir = PathBuf::from(&args[0]);
    let mut shares = Vec::new();
    let mut delta_shares = Vec::new();
    for i in 0..3 {
        let b = std::fs::read(workdir.join(format!("mac{i}.bin"))).unwrap();
        shares.push(ft1536_threshold_spike::MacShare { x: [1u8, 2, 3][i], share: b[0], mac: b[1] });
        let d = std::fs::read(workdir.join(format!("delta{i}.bin"))).unwrap()[0];
        delta_shares.push(d);
    }
```

**Caller-selected directory uses ambient permissions** — `bin/iso.rs:81-100`

The caller controls the namespace and the code neither requires a fresh private directory nor applies restrictive modes before writing all party columns.

```rust
fn cmd_dealer(args: &[String]) {
    let outdir = PathBuf::from(args.first().expect("outdir"));
    std::fs::create_dir_all(&outdir).unwrap();
    // ... generate all party columns ...
    for (i, col) in cols.iter().enumerate() {
        let p = outdir.join(format!("col{i}.bin"));
        std::fs::write(&p, col).unwrap();
    }
}
```

**All columns and triples are co-located** — `bin/iso.rs:303-315`

A reader of the common directory can obtain every party-specific column and preprocessing share; filenames are not access controls.

```rust
for (i, col) in cols.iter().enumerate() {
    std::fs::write(outdir.join(format!("col{i}.bin")), col).unwrap();
}
for m in 0..G_MULS {
    let tri = generate_triple_shares(&mut StdRngOs, &xs, k).unwrap();
    for p in 0..3 {
        let payload = [tri.a[p], tri.b[p], tri.c[p]];
        std::fs::write(outdir.join(format!("trip{m}_{p}.bin")), payload).unwrap();
    }
}
std::fs::create_dir_all(outdir.join("mailbox")).unwrap();
```

**Workers read secrets from the same namespace** — `bin/iso.rs:325-360`

Each role relies only on a filename suffix inside the shared directory; no ownership, permission, no-follow or authenticated-writer check enforces party identity.

```rust
let workdir = PathBuf::from(&args[0]);
let p: usize = args[1].parse().unwrap();
let col = std::fs::read(workdir.join(format!("col{p}.bin"))).unwrap();
// ...
let trip = std::fs::read(workdir.join(format!("trip{m}_{p}.bin"))).unwrap();
// ...
std::fs::write(&de_tmp, [d_i, e_i]).unwrap();
```

**DKG private deals and aggregate columns share the directory** — `bin/iso.rs:520-548`

Atomic rename avoids partial writes but does not prevent another local principal from reading private deal columns or replacing files in the common mailbox.

```rust
for (j, x) in xs.iter().enumerate() {
    let path = mailbox.join(format!("deal{p}_{x}.bin"));
    let tmp = mailbox.join(format!("deal{p}_{x}.tmp"));
    std::fs::write(&tmp, deals[j]).unwrap();
    std::fs::rename(&tmp, &path).unwrap();
}
// ...
std::fs::write(workdir.join(format!("col{p}.bin")), &col).unwrap();
```

**MAC and delta shares are co-located** — `bin/iso.rs:1200-1221`

Every value/MAC share and enough delta shares for reconstruction are written under the same ambient-permission work directory.

```rust
let workdir = PathBuf::from(&args[0]);
std::fs::create_dir_all(workdir.join("mailbox")).unwrap();
// ...
std::fs::write(&tmp, [s.share, s.mac]).unwrap();
std::fs::rename(&tmp, &path).unwrap();
// ...
std::fs::write(&tmp, [d_i]).unwrap();
std::fs::rename(&tmp, &path).unwrap();
```

#### Validation

The dealer writes all shares into a caller-selected root, the coordinator launches each child with that root, and later routines reconstruct secrets from those colocated files. No ACL, distinct principal, sandbox or authenticated IPC control appears in scope.

Validation method: Static filesystem and subprocess authority trace

**Dealer writes every private column to one directory** — `bin/iso.rs:81-104`

All threshold columns are colocated under predictable names. No restrictive mode, ownership check or per-party root is created before the files become available.

```rust
let outdir = PathBuf::from(args.first().expect("outdir"));
std::fs::create_dir_all(&outdir).unwrap();
let mut seed = [0u8; 32];
let mut f = std::fs::File::open("/dev/urandom").unwrap();
f.read_exact(&mut seed).unwrap();
let xs = [1u8, 2, 3];
let k = 2u8;
let mut cols: Vec<Vec<u8>> = vec![vec![]; 3];
for b in seed.iter() {
    let shares = shamir_share(&mut StdRngOs, *b, &xs, k).unwrap();
    for (i, s) in shares.into_iter().enumerate() {
        cols[i].push(s.share);
    }
}
for (i, col) in cols.iter().enumerate() {
    let p = outdir.join(format!("col{i}.bin"));
    std::fs::write(&p, col).unwrap();
}
```

**Every party receives a path inside the same work directory** — `bin/iso.rs:201-219`

The coordinator launches the same executable under its inherited OS authority and hands every party the common directory, so process separation does not restrict sibling-file access.

```rust
let xs = ["1", "2", "3"];
let mut party_outs = Vec::new();
for (i, x) in xs.iter().enumerate() {
    let col = workdir.join(format!("col{i}.bin"));
    let p = Command::new(&exe)
        .args([
            "party",
            col.to_str().unwrap(),
            x,
            workdir.to_str().unwrap(),
        ])
        .stdout(Stdio::piped())
        .spawn()
        .unwrap()
        .wait_with_output()
        .unwrap();
    assert!(p.status.success());
    party_outs.push(String::from_utf8_lossy(&p.stdout).into_owned());
}
```

**Recipient-specific DKG shares are placed in the common mailbox** — `bin/iso.rs:515-548`

Private per-recipient evaluations and completed columns remain enumerable in the shared namespace, giving any participant with directory read access the same inputs used to assemble other parties' columns.

```rust
for (j, x) in xs.iter().enumerate() {
    let path = mailbox.join(format!("deal{p}_{x}.bin"));
    let tmp = mailbox.join(format!("deal{p}_{x}.tmp"));
    std::fs::write(&tmp, deals[j]).unwrap();
    std::fs::rename(&tmp, &path).unwrap();
}

let deadline = std::time::Instant::now() + std::time::Duration::from_secs(20);
loop {
    let ok = (0..3).all(|q| mailbox.join(format!("deal{q}_{}.bin", xs[p])).exists());
    if ok { break; }
    if std::time::Instant::now() > deadline { panic!("timeout waiting deals for party {p}"); }
    std::thread::sleep(std::time::Duration::from_millis(2));
}
let mut col = vec![0u8; 32];
for q in 0..3 {
    let bytes = audited_read(p, &workdir, &mailbox.join(format!("deal{q}_{}.bin", xs[p]))).unwrap();
    assert_eq!(bytes.len(), 32);
    for b in 0..32 { col[b] ^= bytes[b]; }
}
std::fs::write(workdir.join(format!("col{p}.bin")), &col).unwrap();
```

**Hidden-delta mode stores and reloads every delta share together** — `bin/iso.rs:1217-1255`

The comment equates absence of a full-delta file with secrecy, but one directory contains the entire reconstruction set and the opener demonstrates that all shares are readable together.

```rust
for (i, &d_i) in ds.shares.iter().enumerate() {
    let path = workdir.join(format!("delta{i}.bin"));
    let tmp = workdir.join(format!("delta{i}.tmp"));
    std::fs::write(&tmp, [d_i]).unwrap();
    std::fs::rename(&tmp, &path).unwrap();
}
// brak delta.txt — pełnego δ nie ma na dysku
println!("MAC_DEALER_HID_DONE");
}

fn cmd_mac_open_hid(args: &[String]) {
    let workdir = PathBuf::from(&args[0]);
    let mut shares = Vec::new();
    let mut delta_shares = Vec::new();
    for i in 0..3 {
        let b = std::fs::read(workdir.join(format!("mac{i}.bin"))).unwrap();
        shares.push(ft1536_threshold_spike::MacShare { x: [1u8, 2, 3][i], share: b[0], mac: b[1] });
        let d = std::fs::read(workdir.join(format!("delta{i}.bin"))).unwrap()[0];
        delta_shares.push(d);
    }
```

**Caller-selected directory uses ambient permissions** — `bin/iso.rs:81-100`

The caller controls the namespace and the code neither requires a fresh private directory nor applies restrictive modes before writing all party columns.

```rust
fn cmd_dealer(args: &[String]) {
    let outdir = PathBuf::from(args.first().expect("outdir"));
    std::fs::create_dir_all(&outdir).unwrap();
    // ... generate all party columns ...
    for (i, col) in cols.iter().enumerate() {
        let p = outdir.join(format!("col{i}.bin"));
        std::fs::write(&p, col).unwrap();
    }
}
```

**All columns and triples are co-located** — `bin/iso.rs:303-315`

A reader of the common directory can obtain every party-specific column and preprocessing share; filenames are not access controls.

```rust
for (i, col) in cols.iter().enumerate() {
    std::fs::write(outdir.join(format!("col{i}.bin")), col).unwrap();
}
for m in 0..G_MULS {
    let tri = generate_triple_shares(&mut StdRngOs, &xs, k).unwrap();
    for p in 0..3 {
        let payload = [tri.a[p], tri.b[p], tri.c[p]];
        std::fs::write(outdir.join(format!("trip{m}_{p}.bin")), payload).unwrap();
    }
}
std::fs::create_dir_all(outdir.join("mailbox")).unwrap();
```

**Workers read secrets from the same namespace** — `bin/iso.rs:325-360`

Each role relies only on a filename suffix inside the shared directory; no ownership, permission, no-follow or authenticated-writer check enforces party identity.

```rust
let workdir = PathBuf::from(&args[0]);
let p: usize = args[1].parse().unwrap();
let col = std::fs::read(workdir.join(format!("col{p}.bin"))).unwrap();
// ...
let trip = std::fs::read(workdir.join(format!("trip{m}_{p}.bin"))).unwrap();
// ...
std::fs::write(&de_tmp, [d_i, e_i]).unwrap();
```

**DKG private deals and aggregate columns share the directory** — `bin/iso.rs:520-548`

Atomic rename avoids partial writes but does not prevent another local principal from reading private deal columns or replacing files in the common mailbox.

```rust
for (j, x) in xs.iter().enumerate() {
    let path = mailbox.join(format!("deal{p}_{x}.bin"));
    let tmp = mailbox.join(format!("deal{p}_{x}.tmp"));
    std::fs::write(&tmp, deals[j]).unwrap();
    std::fs::rename(&tmp, &path).unwrap();
}
// ...
std::fs::write(workdir.join(format!("col{p}.bin")), &col).unwrap();
```

**MAC and delta shares are co-located** — `bin/iso.rs:1200-1221`

Every value/MAC share and enough delta shares for reconstruction are written under the same ambient-permission work directory.

```rust
let workdir = PathBuf::from(&args[0]);
std::fs::create_dir_all(workdir.join("mailbox")).unwrap();
// ...
std::fs::write(&tmp, [s.share, s.mac]).unwrap();
std::fs::rename(&tmp, &path).unwrap();
// ...
std::fs::write(&tmp, [d_i]).unwrap();
std::fs::rename(&tmp, &path).unwrap();
```

Assertions:
- A process able to read `workdir` can enumerate sibling columns and delta shares.
- In-memory zeroization does not erase the persisted share files.
- All party artifacts share one directory tree.
- Creation uses ambient OS permissions.
- Roles authenticate no reader/writer identity.

Counterevidence and remaining uncertainty:
- The binary is explicitly a prototype and semi-honest demonstration.
- An external launcher could impose distinct OS users, sandboxes and ACLs, but the source does not require or create them.
- Clear contribution logging/reconstruction in `dkg`/`dkg5` is a deliberate oracle and is not counted as a separate finding.
- Several writes use temp-file rename.
- Secret buffers are sometimes zeroized in memory.
- The binary is explicitly a prototype.
- Several writes use atomic temp-file rename, but that prevents partial reads rather than unauthorized access or replacement.
- Effective exploitability depends on the caller's umask, ACLs, and local deployment; no remote exposure is established.

Limitations:
- Actual deployment permissions were not supplied or inspected.
- No runtime ceremony was executed.
- Effective access depends on umask, ACLs and how the caller provisions the directory.
- No runtime permission test was executed.

#### Dataflow

dealer/party private shares -\> predictable common-directory files -\> sibling participant reads threshold set -\> reconstruction helper -\> full seed or MAC key

- **Source:** private share files belonging to other participants

- **Sink:** threshold reconstruction in the malicious participant

- **Outcome:** threshold confidentiality bypass

**Dealer writes every private column to one directory** — `bin/iso.rs:81-104`

All threshold columns are colocated under predictable names. No restrictive mode, ownership check or per-party root is created before the files become available.

```rust
let outdir = PathBuf::from(args.first().expect("outdir"));
std::fs::create_dir_all(&outdir).unwrap();
let mut seed = [0u8; 32];
let mut f = std::fs::File::open("/dev/urandom").unwrap();
f.read_exact(&mut seed).unwrap();
let xs = [1u8, 2, 3];
let k = 2u8;
let mut cols: Vec<Vec<u8>> = vec![vec![]; 3];
for b in seed.iter() {
    let shares = shamir_share(&mut StdRngOs, *b, &xs, k).unwrap();
    for (i, s) in shares.into_iter().enumerate() {
        cols[i].push(s.share);
    }
}
for (i, col) in cols.iter().enumerate() {
    let p = outdir.join(format!("col{i}.bin"));
    std::fs::write(&p, col).unwrap();
}
```

**Every party receives a path inside the same work directory** — `bin/iso.rs:201-219`

The coordinator launches the same executable under its inherited OS authority and hands every party the common directory, so process separation does not restrict sibling-file access.

```rust
let xs = ["1", "2", "3"];
let mut party_outs = Vec::new();
for (i, x) in xs.iter().enumerate() {
    let col = workdir.join(format!("col{i}.bin"));
    let p = Command::new(&exe)
        .args([
            "party",
            col.to_str().unwrap(),
            x,
            workdir.to_str().unwrap(),
        ])
        .stdout(Stdio::piped())
        .spawn()
        .unwrap()
        .wait_with_output()
        .unwrap();
    assert!(p.status.success());
    party_outs.push(String::from_utf8_lossy(&p.stdout).into_owned());
}
```

**Recipient-specific DKG shares are placed in the common mailbox** — `bin/iso.rs:515-548`

Private per-recipient evaluations and completed columns remain enumerable in the shared namespace, giving any participant with directory read access the same inputs used to assemble other parties' columns.

```rust
for (j, x) in xs.iter().enumerate() {
    let path = mailbox.join(format!("deal{p}_{x}.bin"));
    let tmp = mailbox.join(format!("deal{p}_{x}.tmp"));
    std::fs::write(&tmp, deals[j]).unwrap();
    std::fs::rename(&tmp, &path).unwrap();
}

let deadline = std::time::Instant::now() + std::time::Duration::from_secs(20);
loop {
    let ok = (0..3).all(|q| mailbox.join(format!("deal{q}_{}.bin", xs[p])).exists());
    if ok { break; }
    if std::time::Instant::now() > deadline { panic!("timeout waiting deals for party {p}"); }
    std::thread::sleep(std::time::Duration::from_millis(2));
}
let mut col = vec![0u8; 32];
for q in 0..3 {
    let bytes = audited_read(p, &workdir, &mailbox.join(format!("deal{q}_{}.bin", xs[p]))).unwrap();
    assert_eq!(bytes.len(), 32);
    for b in 0..32 { col[b] ^= bytes[b]; }
}
std::fs::write(workdir.join(format!("col{p}.bin")), &col).unwrap();
```

**Hidden-delta mode stores and reloads every delta share together** — `bin/iso.rs:1217-1255`

The comment equates absence of a full-delta file with secrecy, but one directory contains the entire reconstruction set and the opener demonstrates that all shares are readable together.

```rust
for (i, &d_i) in ds.shares.iter().enumerate() {
    let path = workdir.join(format!("delta{i}.bin"));
    let tmp = workdir.join(format!("delta{i}.tmp"));
    std::fs::write(&tmp, [d_i]).unwrap();
    std::fs::rename(&tmp, &path).unwrap();
}
// brak delta.txt — pełnego δ nie ma na dysku
println!("MAC_DEALER_HID_DONE");
}

fn cmd_mac_open_hid(args: &[String]) {
    let workdir = PathBuf::from(&args[0]);
    let mut shares = Vec::new();
    let mut delta_shares = Vec::new();
    for i in 0..3 {
        let b = std::fs::read(workdir.join(format!("mac{i}.bin"))).unwrap();
        shares.push(ft1536_threshold_spike::MacShare { x: [1u8, 2, 3][i], share: b[0], mac: b[1] });
        let d = std::fs::read(workdir.join(format!("delta{i}.bin"))).unwrap()[0];
        delta_shares.push(d);
    }
```

**Caller-selected directory uses ambient permissions** — `bin/iso.rs:81-100`

The caller controls the namespace and the code neither requires a fresh private directory nor applies restrictive modes before writing all party columns.

```rust
fn cmd_dealer(args: &[String]) {
    let outdir = PathBuf::from(args.first().expect("outdir"));
    std::fs::create_dir_all(&outdir).unwrap();
    // ... generate all party columns ...
    for (i, col) in cols.iter().enumerate() {
        let p = outdir.join(format!("col{i}.bin"));
        std::fs::write(&p, col).unwrap();
    }
}
```

**All columns and triples are co-located** — `bin/iso.rs:303-315`

A reader of the common directory can obtain every party-specific column and preprocessing share; filenames are not access controls.

```rust
for (i, col) in cols.iter().enumerate() {
    std::fs::write(outdir.join(format!("col{i}.bin")), col).unwrap();
}
for m in 0..G_MULS {
    let tri = generate_triple_shares(&mut StdRngOs, &xs, k).unwrap();
    for p in 0..3 {
        let payload = [tri.a[p], tri.b[p], tri.c[p]];
        std::fs::write(outdir.join(format!("trip{m}_{p}.bin")), payload).unwrap();
    }
}
std::fs::create_dir_all(outdir.join("mailbox")).unwrap();
```

**Workers read secrets from the same namespace** — `bin/iso.rs:325-360`

Each role relies only on a filename suffix inside the shared directory; no ownership, permission, no-follow or authenticated-writer check enforces party identity.

```rust
let workdir = PathBuf::from(&args[0]);
let p: usize = args[1].parse().unwrap();
let col = std::fs::read(workdir.join(format!("col{p}.bin"))).unwrap();
// ...
let trip = std::fs::read(workdir.join(format!("trip{m}_{p}.bin"))).unwrap();
// ...
std::fs::write(&de_tmp, [d_i, e_i]).unwrap();
```

**DKG private deals and aggregate columns share the directory** — `bin/iso.rs:520-548`

Atomic rename avoids partial writes but does not prevent another local principal from reading private deal columns or replacing files in the common mailbox.

```rust
for (j, x) in xs.iter().enumerate() {
    let path = mailbox.join(format!("deal{p}_{x}.bin"));
    let tmp = mailbox.join(format!("deal{p}_{x}.tmp"));
    std::fs::write(&tmp, deals[j]).unwrap();
    std::fs::rename(&tmp, &path).unwrap();
}
// ...
std::fs::write(workdir.join(format!("col{p}.bin")), &col).unwrap();
```

**MAC and delta shares are co-located** — `bin/iso.rs:1200-1221`

Every value/MAC share and enough delta shares for reconstruction are written under the same ambient-permission work directory.

```rust
let workdir = PathBuf::from(&args[0]);
std::fs::create_dir_all(workdir.join("mailbox")).unwrap();
// ...
std::fs::write(&tmp, [s.share, s.mac]).unwrap();
std::fs::rename(&tmp, &path).unwrap();
// ...
std::fs::write(&tmp, [d_i]).unwrap();
std::fs::rename(&tmp, &path).unwrap();
```

#### Reachability

Requires a local user or process to receive traverse/read or write access through the caller-selected directory, umask, ACLs, or shared identity; no remote exposure is established.

- **Attacker:** malicious participant process

- **Entry point:** common `iso` work directory

- **Outcome:** attacker obtains threshold-many private artifacts

Preconditions:
- Participants share OS filesystem authority or the directory is otherwise readable.
- Victim runs an `iso` workflow.
- Attacker has local filesystem access to the selected directory.

#### Severity

**Medium** — Reading sibling columns or delta shares can disclose complete threshold secrets, a high-impact result. Severity is medium because exploitation requires a local malicious participant/same-UID process and the binary is explicitly a semi-honest research demonstration; no production deployment or cross-user exposure is supplied.

Raise to high if the harness is deployed for mutually distrustful participants under a shared account or writable/readable common directory; lower if it is irreversibly test-only and each real participant uses authenticated IPC and a distinct OS security domain.

Impact assessment:
- **Level:** high
- **Why:** Threshold-many shares permit full seed or MAC-key reconstruction.

Likelihood assessment:
- **Level:** medium
- **Why:** The harness design naturally uses one user and directory, but it is explicitly a local research demo.

#### Remediation

Create a fresh private work root with mode 0700 and fail if it already exists; create secret files with exclusive 0600/no-follow semantics and validate owner and regular-file type before reads. Prefer distinct OS principals or sandboxes with per-party private roots and authenticated recipient-specific IPC, bind every message to session/round/sender/recipient, and remove secret-bearing artifacts after use.

Tests:
- Launch parties under separate principals and assert each cannot read any sibling column, deal, triple, MAC or delta file.
- Attempt cross-party mailbox substitution and assert authenticated IPC rejects it.
- After successful/failed ceremonies, assert secret-bearing files are absent or securely disposed.
- Run each CLI workflow under a permissive umask and assert every secret directory/file remains 0700/0600.
- Pre-create a symlink or conflicting mailbox file and require fail-closed behavior.
- Run workers under distinct OS identities and assert each cannot read another party's private directory.

Preventive controls:
- Model participant ownership in APIs so a process cannot receive aggregate share vectors.
- Require deployment-time isolation checks before any ceremony starts.
- Use authenticated channels instead of identity-by-filename.
- Separate party artifacts by OS identity and namespace.
- Authenticate protocol messages and bind them to session/round/sender.
- Retire or securely delete preprocessing/share files after use.

<a id="finding-11"></a>

### [11] Seed, reconstructed secret-key, and trapdoor material remains copyable and incompletely zeroized

| Field | Value |
| --- | --- |
| Severity | low |
| Confidence | high |
| Confidence rationale | Rust array assignment copies `[u8; 32]`; the source visibly zeroizes only the new variable and leaves the original outside a zeroizing owner. |
| Category | Incomplete clearing of secret memory |
| CWE | CWE-244, CWE-316 |
| Affected lines | lib.rs:2730-2744, lib.rs:775-808, mpc_sign.rs:15-20, ishare.rs:36-41, ishare.rs:2798-2809, mpc_sign.rs:15-20, ishare.rs:36-44, ishare.rs:2798-2809, lib.rs:775-808, ishare.rs:1374-1380, mpc_sign.rs:15, mpc_sign.rs:539, ishare.rs:34, ishare.rs:1374, ishare.rs:2671, ishare.rs:2803, shake.rs:77, mpc_sign.rs:539-553, mpc_sign.rs:901-919, ishare.rs:1374-1380, ishare.rs:2671-2686, ishare.rs:2803-2809, lib.rs:2729-2744 |

#### Summary

`sign_ceremony_v2_from_matrix()` reconstructs the full master seed into plain `[u8;32]`, copies it to `seed_z`, and zeroizes only the copy, leaving the original intact. A separate secret-key ceremony reconstructs a complete serialized key into an ordinary `Vec`, while aggregate G2/share and trapdoor-bearing containers are cloneable, copyable, debuggable, or dropped without uniform zeroization. These paths permit residual allocator copies and accidental disclosure.

#### Root Cause

Secret material is not created and retained in a single non-copyable zeroizing owner. One ceremony mistakes a `Copy` assignment for transfer, another reconstructs a complete encoded key in an ordinary vector, and share, contribution, aggregate G2, and trapdoor types permit ordinary copying, formatting, or destruction.

**Only a copied seed buffer is cleared** — `lib.rs:2730-2744`

`seed` holds the complete reconstructed secret. Assigning it to `seed_z` copies the array, so clearing `seed_z` does not clear the original stack object used for key generation.

```rust
let mut seed = [0u8; 32];
for (i, col) in seed_matrix.iter().enumerate() {
    let refs: Vec<&Share> = col.iter().collect();
    seed[i] = reconstruct(&refs)?;
    if col.len() < k as usize {
        return Err(SpikeError::NotEnoughPoints);
    }
}
let kp = Ft1536KeyPair::generate_from_seed(&seed)
    .map_err(|_| SpikeError::MacFail)?;
let mut seed_z = seed;
seed_z.zeroize();
let sig = Ft1536Signature::sign(&kp, msg).map_err(|_| SpikeError::MacFail)?;
```

**Ceremony wipes a copy instead of the reconstructed seed** — `lib.rs:2730-2744`

`[u8;32]` is `Copy`; assigning `seed` to `seed_z` duplicates the bytes. Zeroizing `seed_z` leaves the original reconstructed seed binding live until function exit.

```rust
let mut seed = [0u8; 32];
for (i, col) in seed_matrix.iter().enumerate() {
    let refs: Vec<&Share> = col.iter().collect();
    seed[i] = reconstruct(&refs)?;
    if col.len() < k as usize {
        return Err(SpikeError::NotEnoughPoints);
    }
}
let kp = Ft1536KeyPair::generate_from_seed(&seed)
    .map_err(|_| SpikeError::MacFail)?;
let mut seed_z = seed;
seed_z.zeroize();
let sig = Ft1536Signature::sign(&kp, msg).map_err(|_| SpikeError::MacFail)?;
```

**Q-ary secret share is debug-printable and copyable** — `mpc_sign.rs:15-20`

The derive set allows uncontrolled copies and formatted disclosure of a secret share, unlike older protected share types.

```rust
/// Udział wartości w Z_q (Shamir k-z-n). `x` = punkt, `share` w [0, q).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct QShare {
    pub x: u16,
    pub share: u16,
}
```

**Integer secret share is debug-printable and copyable** — `ishare.rs:36-44`

The scalar share and aggregate matrix use ordinary copyable/plain memory without a zeroizing lifetime.

```rust
/// Udział wartości całkowitej w Z_P (Shamir k-z-n). `share` w [0, P).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct IShare {
    pub x: u16,
    pub share: u64,
}

pub type IPolyShares = Vec<Vec<u64>>;
```

**Complete trapdoor contribution can be cloned and is not zeroized** — `ishare.rs:2798-2809`

A complete participant trapdoor contribution is explicitly cloneable and lacks `ZeroizeOnDrop`, leaving multiple heap copies outside controlled cleanup.

```rust
/// T8.3 — wkład jednej partii do DKG trapdoora (f_i, g_i, F_i, G_i).
///
/// Partia zna **wyłącznie** swój wkład. Pełny klucz f = Σ f_c (mod i16,
/// dokładna suma całkowita) **nie powstaje w clear** w torze
/// [`dkg_trapdoor_from_contributions`] — tam wyłącznie sumowane są udziały.
#[derive(Clone)]
pub struct PartyTrapdoorContribution {
    pub f: Vec<i16>,
    pub g: Vec<i16>,
    pub f_big: Vec<i16>,
    pub g_big: Vec<i16>,
}
```

**Only a copied seed is zeroized** — `lib.rs:2730-2744`

`[u8;32]` is `Copy`; `seed_z` is a second array, so zeroizing it does not erase `seed`, including on later error paths.

```rust
let mut seed = [0u8; 32];
for (i, col) in seed_matrix.iter().enumerate() {
    let refs: Vec<&Share> = col.iter().collect();
    seed[i] = reconstruct(&refs)?;
    if col.len() < k as usize {
        return Err(SpikeError::NotEnoughPoints);
    }
}
let kp = Ft1536KeyPair::generate_from_seed(&seed)
    .map_err(|_| SpikeError::MacFail)?;
let mut seed_z = seed;
seed_z.zeroize();
let sig = Ft1536Signature::sign(&kp, msg).map_err(|_| SpikeError::MacFail)?;
```

**Aggregate share buffers are cleared without erasure** — `lib.rs:775-808`

The function copies every party's share bytes into ordinary heap buffers; `clear()` drops lengths but does not overwrite backing allocations.

```rust
let mut seed_at: Vec<Vec<u8>> = (0..32)
    .map(|i| seed_shares[i].iter().map(|s| s.share).collect())
    .collect();
// ... secret-share computation ...
seed_at.clear();
```

**Trapdoor share container lacks zeroizing drop** — `ishare.rs:1374-1380`

Long-lived vectors containing all trapdoor share columns are dropped normally and remain publicly accessible.

```rust
/// Pułapka NTRU na udziałach Z_P (całkowite i16 — nie R_q).
pub struct ITrapdoorShares {
    pub f: IPolyShares,
    pub g: IPolyShares,
    pub f_big: IPolyShares,
    pub g_big: IPolyShares,
}
```

**Q shares are Copy and Debug** — `mpc_sign.rs:15-20`

Secret share values can be duplicated implicitly and formatted through Debug; no zeroizing drop can run for a Copy type.

```rust
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct QShare {
    pub x: u16,
    pub share: u16,
}
```

**Clear trapdoor contributions are Clone** — `ishare.rs:2803-2809`

A complete party contribution can be duplicated into additional heap buffers and has no zeroizing drop.

```rust
#[derive(Clone)]
pub struct PartyTrapdoorContribution {
    pub f: Vec<i16>,
    pub g: Vec<i16>,
    pub f_big: Vec<i16>,
    pub g_big: Vec<i16>,
}
```

**Clear and shared trapdoors are ordinary Vec containers** — `mpc_sign.rs:539-553`

Neither secret-bearing type implements Drop or derives zeroization, so their heap buffers are freed without an in-scope wipe.

```rust
pub struct TrapdoorShares {
    pub f: QPolyShares,
    pub g: QPolyShares,
    pub f_big: QPolyShares,
    pub g_big: QPolyShares,
}

pub struct TrapdoorClear {
    pub f: QPoly,
    pub g: QPoly,
    pub f_big: QPoly,
    pub g_big: QPoly,
}
```

**Ceremony reconstructs the complete key into an ordinary Vec** — `mpc_sign.rs:901-919`

The complete serialized secret exists in a non-zeroizing buffer; ownership is moved to an external type whose erasure behavior was outside the authorized source.

```rust
let mut sk = Vec::with_capacity(sk_matrix.len());
for col in sk_matrix {
    let refs: Vec<&crate::Share> = col.iter().collect();
    sk.push(crate::reconstruct(&refs)?);
}
let kp = ft1536_sys::Ft1536KeyPair::from_secret_key(sk, Vec::new())
    .map_err(|_| SpikeError::MacFail)?;
let sig = ft1536_sys::Ft1536Signature::sign(&kp, msg).map_err(|_| SpikeError::MacFail)?;
```

**Aggregate G2 object contains all party shares without an erasing Drop** — `ishare.rs:2671-2686`

Although ZpDeltaShares itself zeroizes, the trapdoor share matrices and related aggregates do not.

```rust
pub struct G2Trapdoor {
    pub td: ITrapdoorShares,
    pub f_mac: IPolyShares,
    pub f_big_mac: IPolyShares,
    // ... commitments and VSS share state ...
    pub delta: ZpDeltaShares,
    pub delta_known: u64,
}
```

#### Validation

The combined review covers seed material, shares, clear party contributions, trapdoor matrices, and Keccak share state: several remain Copy/Debug/Clone or use ordinary deallocation despite neighboring zeroizing types. Exploitation still requires a local memory, dump, swap, or logging disclosure channel.

Validation method: Static Rust ownership, derive, and destruction-lifecycle review; static trait and Drop review

**Only a copied seed buffer is cleared** — `lib.rs:2730-2744`

`seed` holds the complete reconstructed secret. Assigning it to `seed_z` copies the array, so clearing `seed_z` does not clear the original stack object used for key generation.

```rust
let mut seed = [0u8; 32];
for (i, col) in seed_matrix.iter().enumerate() {
    let refs: Vec<&Share> = col.iter().collect();
    seed[i] = reconstruct(&refs)?;
    if col.len() < k as usize {
        return Err(SpikeError::NotEnoughPoints);
    }
}
let kp = Ft1536KeyPair::generate_from_seed(&seed)
    .map_err(|_| SpikeError::MacFail)?;
let mut seed_z = seed;
seed_z.zeroize();
let sig = Ft1536Signature::sign(&kp, msg).map_err(|_| SpikeError::MacFail)?;
```

**Ceremony wipes a copy instead of the reconstructed seed** — `lib.rs:2730-2744`

`[u8;32]` is `Copy`; assigning `seed` to `seed_z` duplicates the bytes. Zeroizing `seed_z` leaves the original reconstructed seed binding live until function exit.

```rust
let mut seed = [0u8; 32];
for (i, col) in seed_matrix.iter().enumerate() {
    let refs: Vec<&Share> = col.iter().collect();
    seed[i] = reconstruct(&refs)?;
    if col.len() < k as usize {
        return Err(SpikeError::NotEnoughPoints);
    }
}
let kp = Ft1536KeyPair::generate_from_seed(&seed)
    .map_err(|_| SpikeError::MacFail)?;
let mut seed_z = seed;
seed_z.zeroize();
let sig = Ft1536Signature::sign(&kp, msg).map_err(|_| SpikeError::MacFail)?;
```

**Q-ary secret share is debug-printable and copyable** — `mpc_sign.rs:15-20`

The derive set allows uncontrolled copies and formatted disclosure of a secret share, unlike older protected share types.

```rust
/// Udział wartości w Z_q (Shamir k-z-n). `x` = punkt, `share` w [0, q).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct QShare {
    pub x: u16,
    pub share: u16,
}
```

**Integer secret share is debug-printable and copyable** — `ishare.rs:36-44`

The scalar share and aggregate matrix use ordinary copyable/plain memory without a zeroizing lifetime.

```rust
/// Udział wartości całkowitej w Z_P (Shamir k-z-n). `share` w [0, P).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct IShare {
    pub x: u16,
    pub share: u64,
}

pub type IPolyShares = Vec<Vec<u64>>;
```

**Complete trapdoor contribution can be cloned and is not zeroized** — `ishare.rs:2798-2809`

A complete participant trapdoor contribution is explicitly cloneable and lacks `ZeroizeOnDrop`, leaving multiple heap copies outside controlled cleanup.

```rust
/// T8.3 — wkład jednej partii do DKG trapdoora (f_i, g_i, F_i, G_i).
///
/// Partia zna **wyłącznie** swój wkład. Pełny klucz f = Σ f_c (mod i16,
/// dokładna suma całkowita) **nie powstaje w clear** w torze
/// [`dkg_trapdoor_from_contributions`] — tam wyłącznie sumowane są udziały.
#[derive(Clone)]
pub struct PartyTrapdoorContribution {
    pub f: Vec<i16>,
    pub g: Vec<i16>,
    pub f_big: Vec<i16>,
    pub g_big: Vec<i16>,
}
```

**Only a copied seed is zeroized** — `lib.rs:2730-2744`

`[u8;32]` is `Copy`; `seed_z` is a second array, so zeroizing it does not erase `seed`, including on later error paths.

```rust
let mut seed = [0u8; 32];
for (i, col) in seed_matrix.iter().enumerate() {
    let refs: Vec<&Share> = col.iter().collect();
    seed[i] = reconstruct(&refs)?;
    if col.len() < k as usize {
        return Err(SpikeError::NotEnoughPoints);
    }
}
let kp = Ft1536KeyPair::generate_from_seed(&seed)
    .map_err(|_| SpikeError::MacFail)?;
let mut seed_z = seed;
seed_z.zeroize();
let sig = Ft1536Signature::sign(&kp, msg).map_err(|_| SpikeError::MacFail)?;
```

**Aggregate share buffers are cleared without erasure** — `lib.rs:775-808`

The function copies every party's share bytes into ordinary heap buffers; `clear()` drops lengths but does not overwrite backing allocations.

```rust
let mut seed_at: Vec<Vec<u8>> = (0..32)
    .map(|i| seed_shares[i].iter().map(|s| s.share).collect())
    .collect();
// ... secret-share computation ...
seed_at.clear();
```

**Trapdoor share container lacks zeroizing drop** — `ishare.rs:1374-1380`

Long-lived vectors containing all trapdoor share columns are dropped normally and remain publicly accessible.

```rust
/// Pułapka NTRU na udziałach Z_P (całkowite i16 — nie R_q).
pub struct ITrapdoorShares {
    pub f: IPolyShares,
    pub g: IPolyShares,
    pub f_big: IPolyShares,
    pub g_big: IPolyShares,
}
```

**Q shares are Copy and Debug** — `mpc_sign.rs:15-20`

Secret share values can be duplicated implicitly and formatted through Debug; no zeroizing drop can run for a Copy type.

```rust
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct QShare {
    pub x: u16,
    pub share: u16,
}
```

**Clear trapdoor contributions are Clone** — `ishare.rs:2803-2809`

A complete party contribution can be duplicated into additional heap buffers and has no zeroizing drop.

```rust
#[derive(Clone)]
pub struct PartyTrapdoorContribution {
    pub f: Vec<i16>,
    pub g: Vec<i16>,
    pub f_big: Vec<i16>,
    pub g_big: Vec<i16>,
}
```

**Clear and shared trapdoors are ordinary Vec containers** — `mpc_sign.rs:539-553`

Neither secret-bearing type implements Drop or derives zeroization, so their heap buffers are freed without an in-scope wipe.

```rust
pub struct TrapdoorShares {
    pub f: QPolyShares,
    pub g: QPolyShares,
    pub f_big: QPolyShares,
    pub g_big: QPolyShares,
}

pub struct TrapdoorClear {
    pub f: QPoly,
    pub g: QPoly,
    pub f_big: QPoly,
    pub g_big: QPoly,
}
```

**Ceremony reconstructs the complete key into an ordinary Vec** — `mpc_sign.rs:901-919`

The complete serialized secret exists in a non-zeroizing buffer; ownership is moved to an external type whose erasure behavior was outside the authorized source.

```rust
let mut sk = Vec::with_capacity(sk_matrix.len());
for col in sk_matrix {
    let refs: Vec<&crate::Share> = col.iter().collect();
    sk.push(crate::reconstruct(&refs)?);
}
let kp = ft1536_sys::Ft1536KeyPair::from_secret_key(sk, Vec::new())
    .map_err(|_| SpikeError::MacFail)?;
let sig = ft1536_sys::Ft1536Signature::sign(&kp, msg).map_err(|_| SpikeError::MacFail)?;
```

**Aggregate G2 object contains all party shares without an erasing Drop** — `ishare.rs:2671-2686`

Although ZpDeltaShares itself zeroizes, the trapdoor share matrices and related aggregates do not.

```rust
pub struct G2Trapdoor {
    pub td: ITrapdoorShares,
    pub f_mac: IPolyShares,
    pub f_big_mac: IPolyShares,
    // ... commitments and VSS share state ...
    pub delta: ZpDeltaShares,
    pub delta_known: u64,
}
```

Assertions:
- `[u8; 32]` is copied by assignment.
- No subsequent `seed.zeroize()` or zeroizing wrapper exists.
- Zeroizing `seed_z` does not zeroize `seed`.
- `Debug`, `Clone`, and `Copy` introduce uncontrolled secret copies or formatting paths.
- `PartyTrapdoorContribution` has no in-scope zeroizing `Drop`.
- An early reconstruction/keygen/signing error can leave partial or complete seed material.
- Major trapdoor containers do not implement `ZeroizeOnDrop`.
- QShare/IShare are Copy+Debug.
- PartyTrapdoorContribution is Clone and not ZeroizeOnDrop.
- Major trapdoor/Keccak matrices lack zeroizing Drop.
- The secret-key ceremony reconstructs a complete serialized key into an ordinary `Vec`.
- The aggregate `G2Trapdoor` and cited Vec-backed trapdoor containers lack an erasing Drop.

Counterevidence and remaining uncertainty:
- The duplicate is cleared.
- The keypair is short-lived, though its external Drop behavior is out of scope.
- No unsafe Rust was found.
- No operational formatting of `QShare` or `IShare` was found; Clone/Debug are hardening gaps, while the copied seed is the directly validated erasure bug.
- Older `Share`, `MacShare`, delta and triple types do use `ZeroizeOnDrop`.
- The `iso` binary explicitly wipes selected local arrays.
- The external keypair implementation may zeroize its own state, but it is outside scope and cannot clear the original local seed copy.
- The external key-pair type may erase its own state, but its implementation is outside scope and does not establish erasure of the ordinary reconstructed input vector.
- The external keypair may zeroize its own state, but that does not clear the original local seed.
- No in-scope memory-disclosure primitive was found.

Limitations:
- No memory dump was taken; target execution was prohibited.
- No memory dump or compiler-level wipe test was run.
- An independent local memory-read or logging capability is required for exploitation.
- Compiler optimization can affect physical erasure; no memory dump was taken, and external `Ft1536KeyPair` destructor behavior is out of scope.
- Rust memory safety prevents out-of-bounds reads but not disclosure through legitimate memory/debug access; external engine cleanup is out of scope.
- The external key-pair destructor and compiler-level erasure of the reconstructed serialized key were not inspected.
- External `Ft1536KeyPair` drop behavior is outside scope.

#### Dataflow

seed, reconstructed serialized key, or trapdoor/share state -\> ordinary copied/debuggable non-zeroizing storage -\> memory dump, debugger, swap, allocator reuse, or formatting sink

- **Source:** full seed, reconstructed encoded secret key, trapdoor aggregates, and secret shares

- **Sink:** residual memory or diagnostics

- **Outcome:** key or share disclosure

**Q shares are Copy and Debug** — `mpc_sign.rs:15-20`

Secret share values can be duplicated implicitly and formatted through Debug; no zeroizing drop can run for a Copy type.

```rust
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct QShare {
    pub x: u16,
    pub share: u16,
}
```

**Clear trapdoor contributions are Clone** — `ishare.rs:2803-2809`

A complete party contribution can be duplicated into additional heap buffers and has no zeroizing drop.

```rust
#[derive(Clone)]
pub struct PartyTrapdoorContribution {
    pub f: Vec<i16>,
    pub g: Vec<i16>,
    pub f_big: Vec<i16>,
    pub g_big: Vec<i16>,
}
```

**Clear and shared trapdoors are ordinary Vec containers** — `mpc_sign.rs:539-553`

Neither secret-bearing type implements Drop or derives zeroization, so their heap buffers are freed without an in-scope wipe.

```rust
pub struct TrapdoorShares {
    pub f: QPolyShares,
    pub g: QPolyShares,
    pub f_big: QPolyShares,
    pub g_big: QPolyShares,
}

pub struct TrapdoorClear {
    pub f: QPoly,
    pub g: QPoly,
    pub f_big: QPoly,
    pub g_big: QPoly,
}
```

**Ceremony reconstructs the complete key into an ordinary Vec** — `mpc_sign.rs:901-919`

The complete serialized secret exists in a non-zeroizing buffer; ownership is moved to an external type whose erasure behavior was outside the authorized source.

```rust
let mut sk = Vec::with_capacity(sk_matrix.len());
for col in sk_matrix {
    let refs: Vec<&crate::Share> = col.iter().collect();
    sk.push(crate::reconstruct(&refs)?);
}
let kp = ft1536_sys::Ft1536KeyPair::from_secret_key(sk, Vec::new())
    .map_err(|_| SpikeError::MacFail)?;
let sig = ft1536_sys::Ft1536Signature::sign(&kp, msg).map_err(|_| SpikeError::MacFail)?;
```

**Aggregate G2 object contains all party shares without an erasing Drop** — `ishare.rs:2671-2686`

Although ZpDeltaShares itself zeroizes, the trapdoor share matrices and related aggregates do not.

```rust
pub struct G2Trapdoor {
    pub td: ITrapdoorShares,
    pub f_mac: IPolyShares,
    pub f_big_mac: IPolyShares,
    // ... commitments and VSS share state ...
    pub delta: ZpDeltaShares,
    pub delta_known: u64,
}
```

**Only a copied seed buffer is cleared** — `lib.rs:2730-2744`

`seed` holds the complete reconstructed secret. Assigning it to `seed_z` copies the array, so clearing `seed_z` does not clear the original stack object used for key generation.

```rust
let mut seed = [0u8; 32];
for (i, col) in seed_matrix.iter().enumerate() {
    let refs: Vec<&Share> = col.iter().collect();
    seed[i] = reconstruct(&refs)?;
    if col.len() < k as usize {
        return Err(SpikeError::NotEnoughPoints);
    }
}
let kp = Ft1536KeyPair::generate_from_seed(&seed)
    .map_err(|_| SpikeError::MacFail)?;
let mut seed_z = seed;
seed_z.zeroize();
let sig = Ft1536Signature::sign(&kp, msg).map_err(|_| SpikeError::MacFail)?;
```

**Ceremony wipes a copy instead of the reconstructed seed** — `lib.rs:2730-2744`

`[u8;32]` is `Copy`; assigning `seed` to `seed_z` duplicates the bytes. Zeroizing `seed_z` leaves the original reconstructed seed binding live until function exit.

```rust
let mut seed = [0u8; 32];
for (i, col) in seed_matrix.iter().enumerate() {
    let refs: Vec<&Share> = col.iter().collect();
    seed[i] = reconstruct(&refs)?;
    if col.len() < k as usize {
        return Err(SpikeError::NotEnoughPoints);
    }
}
let kp = Ft1536KeyPair::generate_from_seed(&seed)
    .map_err(|_| SpikeError::MacFail)?;
let mut seed_z = seed;
seed_z.zeroize();
let sig = Ft1536Signature::sign(&kp, msg).map_err(|_| SpikeError::MacFail)?;
```

**Q-ary secret share is debug-printable and copyable** — `mpc_sign.rs:15-20`

The derive set allows uncontrolled copies and formatted disclosure of a secret share, unlike older protected share types.

```rust
/// Udział wartości w Z_q (Shamir k-z-n). `x` = punkt, `share` w [0, q).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct QShare {
    pub x: u16,
    pub share: u16,
}
```

**Integer secret share is debug-printable and copyable** — `ishare.rs:36-44`

The scalar share and aggregate matrix use ordinary copyable/plain memory without a zeroizing lifetime.

```rust
/// Udział wartości całkowitej w Z_P (Shamir k-z-n). `share` w [0, P).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct IShare {
    pub x: u16,
    pub share: u64,
}

pub type IPolyShares = Vec<Vec<u64>>;
```

**Complete trapdoor contribution can be cloned and is not zeroized** — `ishare.rs:2798-2809`

A complete participant trapdoor contribution is explicitly cloneable and lacks `ZeroizeOnDrop`, leaving multiple heap copies outside controlled cleanup.

```rust
/// T8.3 — wkład jednej partii do DKG trapdoora (f_i, g_i, F_i, G_i).
///
/// Partia zna **wyłącznie** swój wkład. Pełny klucz f = Σ f_c (mod i16,
/// dokładna suma całkowita) **nie powstaje w clear** w torze
/// [`dkg_trapdoor_from_contributions`] — tam wyłącznie sumowane są udziały.
#[derive(Clone)]
pub struct PartyTrapdoorContribution {
    pub f: Vec<i16>,
    pub g: Vec<i16>,
    pub f_big: Vec<i16>,
    pub g_big: Vec<i16>,
}
```

#### Reachability

Requires a later local memory disclosure or an application formatting a secret Debug value.

- **Attacker:** local memory/log disclosure attacker

- **Entry point:** ceremony or trapdoor process state

- **Outcome:** key regeneration or share disclosure

#### Severity

**Low** — The consequence is full private-key recovery from a deterministic seed, but exploitation requires a separate local memory-read, crash-dump, debugger, or similar primitive; no remote memory disclosure is established.

Raise severity if the ceremony runs in a process exposed to crash dumps, core collection, unsafe extensions, or cross-tenant memory disclosure; lower it if compiler-verified erasure of the original is established.

Impact assessment:
- **Level:** high
- **Why:** The seed deterministically regenerates the full key.

Likelihood assessment:
- **Level:** low
- **Why:** A separate memory-disclosure primitive is required.

#### Remediation

Validate dimensions before reconstruction, create the original seed directly inside `Zeroizing<[u8;32]>`, and reconstruct serialized secret keys directly into a zeroizing owner that is cleared on every path. Pass secrets by borrow, implement `Zeroize`/`ZeroizeOnDrop` for every aggregate G2, share-matrix, contribution, and trapdoor-bearing allocation, remove unnecessary `Clone`, `Copy`, and secret-revealing `Debug`, and verify or wrap the external key-pair erasure contract.

Tests:
- Instrument the ceremony with a test-only zeroization wrapper that verifies the original backing object is cleared on success and every early return.
- Add a lint/review rule forbidding assignments from secret `Copy` arrays without an explicit zeroization plan.
- Use an instrumented allocator/test wrapper to confirm seed and contribution buffers are wiped on success and every error path.
- Add compile-fail checks that secret-share types do not implement `Copy`, `Clone`, or `Debug`.
- Exercise early-return paths after partial seed reconstruction and verify cleanup.
- Instrument secret buffers and verify erasure on success and every error return.
- Assert validation occurs before reconstructing any seed byte.
- Audit types to prevent `Debug`, `Copy`, or unrestricted `Clone` on secret-bearing structures.
- Compile-fail assertions that secret types do not implement Copy or Debug.
- Drop instrumentation verifying contribution/trapdoor buffers are overwritten.
- Instrument the reconstructed serialized-key buffer and aggregate G2/trapdoor containers to verify overwrite on success, error, and Drop.
- Use a testable zeroizing owner/drop hook and verify original backing bytes are cleared on success and injected errors.
- Add a source regression preventing `seed_z = seed` cleanup patterns.

Preventive controls:
- Use non-`Copy`, zeroizing secret types for seeds and private-key byte buffers.
- Adopt dedicated secret types with redacted formatting and zeroizing ownership.
- Review every new secret-bearing struct for clone/debug/drop policy.
- Keep memory-dump and core-dump generation disabled in security-sensitive deployments.
- Centralize secret-container types with zeroizing ownership.
- Disable or strictly control crash dumps for production ceremonies.
- Use Zeroizing wrappers for intermediate matrices.
- Redact all secret formatting and disable sensitive core dumps.
- Wrap external key construction behind an API that accepts a zeroizing buffer and documents ownership and erasure.
- Wrap all reconstructed seed/key buffers in zeroizing owners at creation.
- Audit trapdoor/share aggregate types for equivalent `ZeroizeOnDrop` coverage.

<a id="finding-12"></a>

### [12] Seed ceremony signs from unverified share rows without an expected-key binding

| Field | Value |
| --- | --- |
| Severity | low |
| Confidence | high |
| Confidence rationale | The missing calls and absent expected-key parameter are direct source facts; actual caller behavior outside scope limits impact confidence, not the control gap. |
| Category | Missing authenticity validation for threshold shares |
| CWE | CWE-345 |
| Affected lines | lib.rs:244-279, lib.rs:2721-2750, mpc_sign.rs:99-118, mpc_sign.rs:201-215, mpc_sign.rs:901-920, mpc_sign.rs:1520-1555 |

#### Summary

Seed and secret-key signing ceremonies reconstruct raw share matrices without authenticating a common participant set, session, threshold or established public key. The seed path omits consistency checks and expected-key binding; `sign_ceremony_sk_shares()` accepts no threshold at all, and q-ary helpers used by the trapdoor ceremony accept a single share.

#### Root Cause

The ceremony treats any reconstructable matrix as authoritative seed material. It omits share authenticity/consistency and setup/session binding, then makes the derived key part of the output instead of enforcing an already established identity.

**Ceremony reconstructs rows and returns a newly derived public key** — `lib.rs:2721-2750`

Each row is reconstructed without the existing consistency control or a common participant-set check, and the function accepts no expected public key before signing.

```rust
pub fn sign_ceremony_v2_from_matrix(
    seed_matrix: &[Vec<Share>],
    k: u8,
    msg: &[u8],
) -> Result<SignCeremonyV2> {
    if seed_matrix.len() != 32 {
        return Err(SpikeError::PartyCountMismatch);
    }
    let mut seed = [0u8; 32];
    for (i, col) in seed_matrix.iter().enumerate() {
        let refs: Vec<&Share> = col.iter().collect();
        seed[i] = reconstruct(&refs)?;
        if col.len() < k as usize {
            return Err(SpikeError::NotEnoughPoints);
        }
    }
    let kp = Ft1536KeyPair::generate_from_seed(&seed)
        .map_err(|_| SpikeError::MacFail)?;
    // ... sign ...
    let public_key = kp.public_key.clone();
    Ok(SignCeremonyV2 { sig_bytes: sig.bytes, nonce: sig.nonce, public_key })
}
```

**A redundant-share consistency verifier exists** — `lib.rs:244-253`

The crate has a control that checks threshold count and share-coordinate consistency, but the seed ceremony does not call it for any row.

```rust
pub fn verify_consistency(shares: &[&Share], k: u8) -> Result<()> {
    if shares.len() < k as usize {
        return Err(SpikeError::InsufficientShares);
    }
    validate_xs(&shares.iter().map(|s| s.x).collect::<Vec<_>>(), k)?;
```

**Secret-key ceremony reconstructs any nonempty share rows** — `mpc_sign.rs:901-919`

The public ceremony has no `k`, participant set, VSS/MAC transcript or expected public key; a one-share row reaches secret-key parsing as a purported ceremony result.

```rust
pub fn sign_ceremony_sk_shares(
    sk_matrix: &[Vec<crate::Share>],
    msg: &[u8],
) -> Result<(Vec<u8>, [u8; 40], Vec<u8>)> {
    let mut sk = Vec::with_capacity(sk_matrix.len());
    for col in sk_matrix {
        let refs: Vec<&crate::Share> = col.iter().collect();
        sk.push(crate::reconstruct(&refs)?);
    }
    let kp = ft1536_sys::Ft1536KeyPair::from_secret_key(sk, Vec::new())
        .map_err(|_| SpikeError::MacFail)?;
    let sig = ft1536_sys::Ft1536Signature::sign(&kp, msg).map_err(|_| SpikeError::MacFail)?;
    let pk = kp.public_key.clone();
    Ok((sig.bytes, sig.nonce, pk))
}
```

#### Validation

The ceremony was compared with the crate's consistency verifier and its parameters; no VSS/MAC/transcript or expected-key input exists.

Validation method: Static API and control comparison

**Ceremony reconstructs rows and returns a newly derived public key** — `lib.rs:2721-2750`

Each row is reconstructed without the existing consistency control or a common participant-set check, and the function accepts no expected public key before signing.

```rust
pub fn sign_ceremony_v2_from_matrix(
    seed_matrix: &[Vec<Share>],
    k: u8,
    msg: &[u8],
) -> Result<SignCeremonyV2> {
    if seed_matrix.len() != 32 {
        return Err(SpikeError::PartyCountMismatch);
    }
    let mut seed = [0u8; 32];
    for (i, col) in seed_matrix.iter().enumerate() {
        let refs: Vec<&Share> = col.iter().collect();
        seed[i] = reconstruct(&refs)?;
        if col.len() < k as usize {
            return Err(SpikeError::NotEnoughPoints);
        }
    }
    let kp = Ft1536KeyPair::generate_from_seed(&seed)
        .map_err(|_| SpikeError::MacFail)?;
    // ... sign ...
    let public_key = kp.public_key.clone();
    Ok(SignCeremonyV2 { sig_bytes: sig.bytes, nonce: sig.nonce, public_key })
}
```

**A redundant-share consistency verifier exists** — `lib.rs:244-253`

The crate has a control that checks threshold count and share-coordinate consistency, but the seed ceremony does not call it for any row.

```rust
pub fn verify_consistency(shares: &[&Share], k: u8) -> Result<()> {
    if shares.len() < k as usize {
        return Err(SpikeError::InsufficientShares);
    }
    validate_xs(&shares.iter().map(|s| s.x).collect::<Vec<_>>(), k)?;
```

**Secret-key ceremony reconstructs any nonempty share rows** — `mpc_sign.rs:901-919`

The public ceremony has no `k`, participant set, VSS/MAC transcript or expected public key; a one-share row reaches secret-key parsing as a purported ceremony result.

```rust
pub fn sign_ceremony_sk_shares(
    sk_matrix: &[Vec<crate::Share>],
    msg: &[u8],
) -> Result<(Vec<u8>, [u8; 40], Vec<u8>)> {
    let mut sk = Vec::with_capacity(sk_matrix.len());
    for col in sk_matrix {
        let refs: Vec<&crate::Share> = col.iter().collect();
        sk.push(crate::reconstruct(&refs)?);
    }
    let kp = ft1536_sys::Ft1536KeyPair::from_secret_key(sk, Vec::new())
        .map_err(|_| SpikeError::MacFail)?;
    let sig = ft1536_sys::Ft1536Signature::sign(&kp, msg).map_err(|_| SpikeError::MacFail)?;
    let pk = kp.public_key.clone();
    Ok((sig.bytes, sig.nonce, pk))
}
```

Assertions:
- Row reconstruction precedes the threshold-length check.
- `verify_consistency` is not invoked.
- No expected public key is accepted.

Counterevidence and remaining uncertainty:
- The ceremony documents that the full seed exists in one process.
- Matrix length and minimum row length are checked.
- The crate-level threat model is semi-honest.

Limitations:
- No external caller contract was available in scope.

#### Dataflow

participant share -\> unchecked row reconstruction -\> deterministic keygen -\> signature plus caller-trusted derived public key

- **Source:** Participant-supplied seed share matrix

- **Sink:** `Ft1536KeyPair::generate_from_seed()`

- **Outcome:** Key substitution or ceremony denial of service

**Ceremony reconstructs rows and returns a newly derived public key** — `lib.rs:2721-2750`

Each row is reconstructed without the existing consistency control or a common participant-set check, and the function accepts no expected public key before signing.

```rust
pub fn sign_ceremony_v2_from_matrix(
    seed_matrix: &[Vec<Share>],
    k: u8,
    msg: &[u8],
) -> Result<SignCeremonyV2> {
    if seed_matrix.len() != 32 {
        return Err(SpikeError::PartyCountMismatch);
    }
    let mut seed = [0u8; 32];
    for (i, col) in seed_matrix.iter().enumerate() {
        let refs: Vec<&Share> = col.iter().collect();
        seed[i] = reconstruct(&refs)?;
        if col.len() < k as usize {
            return Err(SpikeError::NotEnoughPoints);
        }
    }
    let kp = Ft1536KeyPair::generate_from_seed(&seed)
        .map_err(|_| SpikeError::MacFail)?;
    // ... sign ...
    let public_key = kp.public_key.clone();
    Ok(SignCeremonyV2 { sig_bytes: sig.bytes, nonce: sig.nonce, public_key })
}
```

**Secret-key ceremony reconstructs any nonempty share rows** — `mpc_sign.rs:901-919`

The public ceremony has no `k`, participant set, VSS/MAC transcript or expected public key; a one-share row reaches secret-key parsing as a purported ceremony result.

```rust
pub fn sign_ceremony_sk_shares(
    sk_matrix: &[Vec<crate::Share>],
    msg: &[u8],
) -> Result<(Vec<u8>, [u8; 40], Vec<u8>)> {
    let mut sk = Vec::with_capacity(sk_matrix.len());
    for col in sk_matrix {
        let refs: Vec<&crate::Share> = col.iter().collect();
        sk.push(crate::reconstruct(&refs)?);
    }
    let kp = ft1536_sys::Ft1536KeyPair::from_secret_key(sk, Vec::new())
        .map_err(|_| SpikeError::MacFail)?;
    let sig = ft1536_sys::Ft1536Signature::sign(&kp, msg).map_err(|_| SpikeError::MacFail)?;
    let pk = kp.public_key.clone();
    Ok((sig.bytes, sig.nonce, pk))
}
```

#### Reachability

Requires a malicious participant/caller controlling a share and a consumer that lacks an external immutable public-key check.

- **Attacker:** Malicious threshold participant

- **Entry point:** `sign_ceremony_v2_from_matrix()`

- **Outcome:** Signing under an unintended key or abort

#### Severity

**Low** — The source-backed outcome is key substitution for callers that trust the returned public key, or denial of service for callers pinned to the correct key. The module explicitly assumes a semi-honest prototype and no deployed identity-binding workflow is established.

Raise severity if callers use the returned public key as an authenticated identity or if the ceremony is exposed to malicious participants; lower or reject if an external immutable transcript validates every row and pins the expected public key before this function is called.

Impact assessment:
- **Level:** medium
- **Why:** A caller trusting the returned key can accept substitution; a pinned caller sees DoS.

Likelihood assessment:
- **Level:** low
- **Why:** The source assumes semi-honest participants and external workflow is unknown.

#### Remediation

Authenticate and session-bind every seed row, enforce the exact participant x-set and threshold before reconstruction, call consistency/VSS checks, and require the generated public key to match an immutable expected key or setup transcript before signing.

Tests:
- Mutate one share while preserving all lengths and require rejection before key generation.
- Reject mixed participant x-sets, cross-session shares and expected-public-key mismatch.

Preventive controls:
- Represent verified ceremony inputs with a typestate that cannot be constructed from raw share matrices alone.

<a id="finding-13"></a>

### [13] Share-native SHAKE accepts inconsistent and non-Boolean input shares

| Field | Value |
| --- | --- |
| Severity | low |
| Confidence | high |
| Confidence rationale | The public alias, shape-only guards and general GF multiplication are explicit in source; deployment reachability is the limiting uncertainty. |
| Category | Missing integrity and type validation for cryptographic shares |
| CWE | CWE-345 |
| Affected lines | shake.rs:128-148, shake.rs:343-353, shake.rs:356-428, shake.rs:478-512, lib.rs:2874-2898 |

#### Summary

`shake256_shares()` accepts public `Vec<u8>` rows after checking only their lengths. It does not verify redundant-share consistency or prove that each reconstructed field element is 0 or 1 before the Keccak circuit treats it as a Boolean wire; key- and nonce-derivation wrappers forward caller-supplied seed-bit rows to this boundary.

#### Root Cause

`BitShares` carries no invariant and the SHAKE entry point checks only dimensions. General GF(256) values and inconsistent redundant shares therefore enter a circuit whose algebra is correct only for Boolean wires.

**Key derivation forwards external seed-bit rows** — `shake.rs:485-512`

The wrapper exposes the shape-only SHAKE boundary directly to caller-supplied seed shares.

```rust
pub fn derive_key_material_shake(
    rng: &mut impl rand::RngCore,
    seed_bits: &[BitShares],
    out_len: usize,
    xs: &[u8],
    k: u8,
) -> Result<Vec<BitShares>> {
    validate_xs(xs, k)?;
    let n = xs.len();
    if seed_bits.len() != 32 * 8 { return Err(SpikeError::PartyCountMismatch); }
    for row in seed_bits {
        if row.len() != n { return Err(SpikeError::PartyCountMismatch); }
    }
    // ... prepend public domain ...
    input_bits.extend(seed_bits.iter().cloned());
    shake256_shares(rng, &input_bits, out_len, xs, k)
}
```

**SHAKE validates row shape but not share bitness or consistency** — `shake.rs:365-383`

Caller-controlled rows pass after dimension checks; no consistency, MAC/VSS or Boolean constraint is applied before absorption.

```rust
pub fn shake256_shares(
    rng: &mut impl rand::RngCore,
    input_bits: &[BitShares],
    out_len: usize,
    xs: &[u8],
    k: u8,
) -> Result<Vec<BitShares>> {
    validate_xs(xs, k)?;
    let n = xs.len();
    for row in input_bits {
        if row.len() != n {
            return Err(SpikeError::PartyCountMismatch);
        }
    }
    let in_bits_len = input_bits.len();
    if in_bits_len % 8 != 0 {
        return Err(SpikeError::PartyCountMismatch);
    }
```

**Bit reconstruction returns any GF(256) element** — `shake.rs:131-148`

The helper uses only the first `k` shares and never rejects reconstructed values outside `{0,1}` or disagreement from redundant shares.

```rust
fn reconstruct_bit(xs: &[u8], shares: &[u8], k: u8) -> Result<u8> {
    let t = k as usize;
    if shares.len() != xs.len() { return Err(SpikeError::PartyCountMismatch); }
    if t > shares.len() || t < 1 { return Err(SpikeError::NotEnoughPoints); }
    let xs_k = &xs[..t];
    let mut acc = 0u8;
    for i in 0..t {
        let lam = lagrange_at_zero(xs_k, i)?;
        acc ^= gf_mul(lam, shares[i]);
    }
    Ok(acc)
}
```

#### Validation

Caller-supplied seed bits were traced into SHAKE; neither wrapper nor core enforces share consistency, authentication or `b*(b-1)=0`.

Validation method: Static type/invariant and dataflow review

**Key derivation forwards external seed-bit rows** — `shake.rs:485-512`

The wrapper exposes the shape-only SHAKE boundary directly to caller-supplied seed shares.

```rust
pub fn derive_key_material_shake(
    rng: &mut impl rand::RngCore,
    seed_bits: &[BitShares],
    out_len: usize,
    xs: &[u8],
    k: u8,
) -> Result<Vec<BitShares>> {
    validate_xs(xs, k)?;
    let n = xs.len();
    if seed_bits.len() != 32 * 8 { return Err(SpikeError::PartyCountMismatch); }
    for row in seed_bits {
        if row.len() != n { return Err(SpikeError::PartyCountMismatch); }
    }
    // ... prepend public domain ...
    input_bits.extend(seed_bits.iter().cloned());
    shake256_shares(rng, &input_bits, out_len, xs, k)
}
```

**SHAKE validates row shape but not share bitness or consistency** — `shake.rs:365-383`

Caller-controlled rows pass after dimension checks; no consistency, MAC/VSS or Boolean constraint is applied before absorption.

```rust
pub fn shake256_shares(
    rng: &mut impl rand::RngCore,
    input_bits: &[BitShares],
    out_len: usize,
    xs: &[u8],
    k: u8,
) -> Result<Vec<BitShares>> {
    validate_xs(xs, k)?;
    let n = xs.len();
    for row in input_bits {
        if row.len() != n {
            return Err(SpikeError::PartyCountMismatch);
        }
    }
    let in_bits_len = input_bits.len();
    if in_bits_len % 8 != 0 {
        return Err(SpikeError::PartyCountMismatch);
    }
```

**Bit reconstruction returns any GF(256) element** — `shake.rs:131-148`

The helper uses only the first `k` shares and never rejects reconstructed values outside `{0,1}` or disagreement from redundant shares.

```rust
fn reconstruct_bit(xs: &[u8], shares: &[u8], k: u8) -> Result<u8> {
    let t = k as usize;
    if shares.len() != xs.len() { return Err(SpikeError::PartyCountMismatch); }
    if t > shares.len() || t < 1 { return Err(SpikeError::NotEnoughPoints); }
    let xs_k = &xs[..t];
    let mut acc = 0u8;
    for i in 0..t {
        let lam = lagrange_at_zero(xs_k, i)?;
        acc ^= gf_mul(lam, shares[i]);
    }
    Ok(acc)
}
```

Assertions:
- `BitShares` is publicly constructible `Vec<u8>`.
- Row length is the only per-row check.
- Non-bit field elements are accepted by GF arithmetic.

Counterevidence and remaining uncertainty:
- Local dealer helpers generate honest 0/1 shares.
- The module is a semi-honest prototype.
- No remote raw-share endpoint is present.

Limitations:
- No malicious-share execution was performed.

#### Dataflow

participant BitShares -\> shape-only wrapper -\> share Keccak -\> derived key/nonce shares

- **Source:** Caller-controlled bit-share rows

- **Sink:** Keccak state

- **Outcome:** Silent corruption or bias of derived cryptographic material

**Key derivation forwards external seed-bit rows** — `shake.rs:485-512`

The wrapper exposes the shape-only SHAKE boundary directly to caller-supplied seed shares.

```rust
pub fn derive_key_material_shake(
    rng: &mut impl rand::RngCore,
    seed_bits: &[BitShares],
    out_len: usize,
    xs: &[u8],
    k: u8,
) -> Result<Vec<BitShares>> {
    validate_xs(xs, k)?;
    let n = xs.len();
    if seed_bits.len() != 32 * 8 { return Err(SpikeError::PartyCountMismatch); }
    for row in seed_bits {
        if row.len() != n { return Err(SpikeError::PartyCountMismatch); }
    }
    // ... prepend public domain ...
    input_bits.extend(seed_bits.iter().cloned());
    shake256_shares(rng, &input_bits, out_len, xs, k)
}
```

**SHAKE validates row shape but not share bitness or consistency** — `shake.rs:365-383`

Caller-controlled rows pass after dimension checks; no consistency, MAC/VSS or Boolean constraint is applied before absorption.

```rust
pub fn shake256_shares(
    rng: &mut impl rand::RngCore,
    input_bits: &[BitShares],
    out_len: usize,
    xs: &[u8],
    k: u8,
) -> Result<Vec<BitShares>> {
    validate_xs(xs, k)?;
    let n = xs.len();
    for row in input_bits {
        if row.len() != n {
            return Err(SpikeError::PartyCountMismatch);
        }
    }
    let in_bits_len = input_bits.len();
    if in_bits_len % 8 != 0 {
        return Err(SpikeError::PartyCountMismatch);
    }
```

#### Reachability

Requires a caller or participant able to supply raw BitShares to a public library API.

- **Attacker:** Malicious threshold participant/library caller

- **Entry point:** `derive_key_material_shake`, `derive_nonce_shake`, or `shake256_shares`

- **Outcome:** Corrupted derivation result or denial of service

#### Severity

**Low** — A malicious participant can silently corrupt derived key material or nonces and cause bias or denial of service. The affected component is explicitly semi-honest/dealer-generated prototype code, and no network endpoint or fixed-key forgery is established.

Raise severity if raw BitShares cross a real malicious-participant boundary in production derivation/signing; lower it if an authenticated bit-share layer is always enforced externally.

Impact assessment:
- **Level:** medium
- **Why:** Derived key/nonce integrity can fail silently, but a valid fixed-key forgery is not shown.

Likelihood assessment:
- **Level:** low
- **Why:** Current honest helpers generate valid shares and deployment is absent.

#### Remediation

Replace the public alias with an authenticated `BitShare` type. Before the first Keccak round, verify participant/session binding, redundant-share consistency, and the shared constraint `b*(b-1)=0` for every input wire.

Tests:
- Reject a consistent sharing of field value 2.
- Reject one altered redundant share and rows mixed across participant sets/sessions before any Keccak round.

Preventive controls:
- Make raw `Vec<u8>` construction private and use authenticated multiplication throughout share Keccak.

<a id="finding-14"></a>

### [14] Malformed public cryptographic inputs can panic, abort, or overflow into invalid VSS state

| Field | Value |
| --- | --- |
| Severity | low |
| Confidence | high |
| Confidence rationale | Assertions, unchecked indexing and the `i64::MIN` overflow are direct source evidence; only deployment reachability is uncertain. |
| Category | Malformed-input panic and numeric overflow |
| CWE | CWE-248, CWE-190 |
| Affected lines | mpc_sign.rs:234-250, mpc_sign.rs:434-444, mpc_sign.rs:645-650, ishare.rs:248-259, ishare.rs:3308-3314, select.rs:219-238, select.rs:680-699, prss.rs:62-73, pedersen.rs:119-138, rejection.rs:59-63, mpc_sign.rs:234, mpc_sign.rs:434, mpc_sign.rs:642, pedersen.rs:266, pedersen.rs:326, ishare.rs:142, ishare.rs:2188, mpc_sign.rs:234-249, mpc_sign.rs:434-444 |

#### Summary

Exported arithmetic, encoding, PRF, Pedersen/VSS, rejection, selection, and verification helpers encode caller contracts with assertions, unchecked indexing/slicing, modulo, `unwrap()`, or unchecked arithmetic. Triggers include malformed polynomial/signature lengths, oversized PRF output, invalid thresholds/ranges/windows/points, out-of-range coefficients, `i64::MIN`, and large VSS x/k values; outcomes include host termination and release-mode wrapping that can invalidate commitment verification.

#### Root Cause

Public slice-, integer-, threshold-, coordinate-, range-, and VSS-parameter APIs rely on implicit caller correctness instead of checked preconditions, validated fixed-size types, and checked modular arithmetic, creating independently reachable panic and overflow instances.

**Signature equation indexes caller slices as fixed 1536-vectors** — `mpc_sign.rs:434-444`

Although `s2` and `h` hit assertion guards in the helper, short `s1` or `t` slices are indexed without validation and panic rather than returning `false` or `Err`.

```rust
pub fn verify_sign_equation(s1: &[u16], s2: &[u16], h: &[u16], t: &[u16]) -> bool {
    let s2h = q_poly_mul_ring_clear(s2, h);
    for i in 0..FT1536_N {
        let lhs = q_sub(s2h[i], s1[i]);
        if lhs != t[i] {
            return false;
        }
    }
    true
}
```

**Public multiplication asserts operand lengths** — `mpc_sign.rs:234-250`

Caller-controlled wrong lengths trigger an assertion panic at a public arithmetic boundary.

```rust
pub fn q_poly_mul_ring_clear(a: &[u16], b: &[u16]) -> QPoly {
    assert_eq!(a.len(), FT1536_N);
    assert_eq!(b.len(), FT1536_N);
    let n = FT1536_N;
    let mut acc = vec![0u16; n];
    // ...
    acc
}
```

**Rounding negates `i64::MIN`** — `ishare.rs:3308-3314`

For `i64::MIN`, `-v` overflows; debug builds panic and release behavior is not a fail-closed error contract.

```rust
pub fn round_half_away_i64(v: i64) -> i64 {
    let q = FT1536_Q as i64;
    if v >= 0 {
        (v + q / 2) / q
    } else {
        -(((-v) + q / 2) / q)
    }
}
```

**PRF second block is sliced by unbounded remaining length** — `prss.rs:62-73`

For `out.len() > 64`, `rest > 32` and `block2[..rest]` indexes beyond the 32-byte block, causing a panic from caller-controlled output length.

```rust
pub fn prf_bytes(seed: &PairwiseSeed, counter: u64, out: &mut [u8]) {
    let mut buf = [0u8; 40];
    buf[..32].copy_from_slice(&seed.key);
    buf[32..].copy_from_slice(&counter.to_le_bytes());
    let block = hash256(&[&buf, b"prf"]);
    let n = out.len().min(32);
    out[..n].copy_from_slice(&block[..n]);
    if out.len() > 32 {
        let block2 = hash256(&[&buf, b"prf2"]);
        let rest = out.len() - 32;
        out[32..].copy_from_slice(&block2[..rest]);
    }
}
```

**Pedersen dealer asserts and unwraps public parameters** — `pedersen.rs:119-138`

The exported constructor aborts instead of returning an error for `k < 2` or any zero participant coordinate.

```rust
pub fn deal_exp_shares(
    rng: &mut impl RngCore,
    secret_byte: u8,
    xs: &[u8],
    k: u8,
) -> (PedersenCommitments, Vec<ExpShare>) {
    assert!(k >= 2);
    let a = random_poly(rng, secret_byte, k);
    let b = random_poly(rng, (rng.next_u32() & 0xFF) as u8, k);
    let comms = commit(&a, &b);
    let shares = xs
        .iter()
        .map(|&x| {
            let sx = scalar_x(x).unwrap();
            let s = a.eval_scalar(sx);
            let t = b.eval_scalar(sx);
            ExpShare { x, s: scalar_to_bytes(&s), t: scalar_to_bytes(&t) }
        })
        .collect();
```

**Uniform range helper does not validate its interval** — `rejection.rs:59-63`

An invalid or overflowing interval can make `span` zero, so `% span` panics instead of failing closed.

```rust
/// Jednostajne na [lo, hi] (helper testowy).
pub fn uniform_range_pub(rng: &mut impl rand::RngCore, lo: i32, hi: i32) -> i32 {
    let span = (hi - lo + 1) as u32;
    lo + (rng.next_u32() % span) as i32
}
```

**Bool verifier forwards unchecked slices** — `mpc_sign.rs:436-444`

The public verifier appears to return false on failure but reaches assertions and unchecked indexing for short or long attacker-supplied vectors.

```rust
pub fn verify_sign_equation(s1: &[u16], s2: &[u16], h: &[u16], t: &[u16]) -> bool {
    let prod = q_poly_mul_ring_clear(s2, h);
    for i in 0..FT1536_N {
        if q_sub(prod[i], s1[i]) != t[i] {
            return false;
        }
    }
    true
}
```

**Ring multiplication asserts exact lengths** — `mpc_sign.rs:234-237`

Malformed public slices terminate the process before a recoverable error can be returned.

```rust
pub fn q_poly_mul_ring_clear(a: &[u16], b: &[u16]) -> QPoly {
    assert_eq!(a.len(), FT1536_N);
    assert_eq!(b.len(), FT1536_N);
```

**Z_P sharing guard permits large u16 points and thresholds** — `ishare.rs:142-161`

The public wrapper validates distinct nonzero points but does not enforce the smaller k/x bounds assumed by raw VSS evaluation.

```rust
fn check_xs_p(xs: &[u16], k: u8) -> Result<usize> {
    if k < 2 { return Err(SpikeError::ThresholdTooLow); }
    if xs.is_empty() { return Err(SpikeError::EmptyXs); }
    if xs.len() < k as usize { return Err(SpikeError::NotEnoughPoints); }
    let mut seen = std::collections::HashSet::new();
    for &x in xs {
        if x == 0 || (x as u64) >= I_P { return Err(SpikeError::XZero); }
        if !seen.insert(x) { return Err(SpikeError::DuplicateX); }
    }
    Ok(xs.len())
}
```

**Raw polynomial evaluation uses unchecked u128 arithmetic** — `pedersen.rs:266-275`

Both the term multiplication, sum and power update can exceed u128; debug builds panic and release builds wrap.

```rust
fn zp_eval_poly_raw(coeffs: &[u64], x: u64) -> u128 {
    let mut acc = 0u128;
    let mut xp = 1u128;
    for &c in coeffs {
        acc += (c % ZP_MODULUS) as u128 * xp;
        xp *= x as u128;
    }
    acc
}
```

**Public verifier lacks length guards** — `mpc_sign.rs:434-444`

All four vectors are caller supplied; no exact-length validation occurs before multiplication or fixed indexing.

```rust
pub fn verify_sign_equation(s1: &[u16], s2: &[u16], h: &[u16], t: &[u16]) -> bool {
    let s2h = q_poly_mul_ring_clear(s2, h);
    for i in 0..FT1536_N {
        let lhs = q_sub(s2h[i], s1[i]);
        if lhs != t[i] {
            return false;
        }
    }
    true
}
```

**Ring multiply asserts caller lengths** — `mpc_sign.rs:234-249`

Malformed `s2` or `h` triggers `assert_eq!`; malformed `s1` or `t` later triggers bounds indexing in the caller.

```rust
pub fn q_poly_mul_ring_clear(a: &[u16], b: &[u16]) -> QPoly {
    assert_eq!(a.len(), FT1536_N);
    assert_eq!(b.len(), FT1536_N);
    let n = FT1536_N;
    let mut acc = vec![0u16; n];
    for i in 0..n {
        if a[i] == 0 { continue; }
        for j in 0..n {
            if b[j] == 0 { continue; }
            add_monomial(&mut acc, i + j, q_mul(a[i], b[j]));
        }
    }
    acc
}
```

#### Validation

Every retained API instance has a concrete malformed value reaching a panic, abort, or unchecked overflow without an in-scope boundary. Large VSS x/k configurations additionally wrap in release builds and can produce invalid proof values; normal fixed small configurations are counterevidence only for reachability.

Validation method: Static malformed-input review across public library boundaries; static control-flow trace; static numeric-bound analysis

**Signature equation indexes caller slices as fixed 1536-vectors** — `mpc_sign.rs:434-444`

Although `s2` and `h` hit assertion guards in the helper, short `s1` or `t` slices are indexed without validation and panic rather than returning `false` or `Err`.

```rust
pub fn verify_sign_equation(s1: &[u16], s2: &[u16], h: &[u16], t: &[u16]) -> bool {
    let s2h = q_poly_mul_ring_clear(s2, h);
    for i in 0..FT1536_N {
        let lhs = q_sub(s2h[i], s1[i]);
        if lhs != t[i] {
            return false;
        }
    }
    true
}
```

**Public multiplication asserts operand lengths** — `mpc_sign.rs:234-250`

Caller-controlled wrong lengths trigger an assertion panic at a public arithmetic boundary.

```rust
pub fn q_poly_mul_ring_clear(a: &[u16], b: &[u16]) -> QPoly {
    assert_eq!(a.len(), FT1536_N);
    assert_eq!(b.len(), FT1536_N);
    let n = FT1536_N;
    let mut acc = vec![0u16; n];
    // ...
    acc
}
```

**Rounding negates `i64::MIN`** — `ishare.rs:3308-3314`

For `i64::MIN`, `-v` overflows; debug builds panic and release behavior is not a fail-closed error contract.

```rust
pub fn round_half_away_i64(v: i64) -> i64 {
    let q = FT1536_Q as i64;
    if v >= 0 {
        (v + q / 2) / q
    } else {
        -(((-v) + q / 2) / q)
    }
}
```

**PRF second block is sliced by unbounded remaining length** — `prss.rs:62-73`

For `out.len() > 64`, `rest > 32` and `block2[..rest]` indexes beyond the 32-byte block, causing a panic from caller-controlled output length.

```rust
pub fn prf_bytes(seed: &PairwiseSeed, counter: u64, out: &mut [u8]) {
    let mut buf = [0u8; 40];
    buf[..32].copy_from_slice(&seed.key);
    buf[32..].copy_from_slice(&counter.to_le_bytes());
    let block = hash256(&[&buf, b"prf"]);
    let n = out.len().min(32);
    out[..n].copy_from_slice(&block[..n]);
    if out.len() > 32 {
        let block2 = hash256(&[&buf, b"prf2"]);
        let rest = out.len() - 32;
        out[32..].copy_from_slice(&block2[..rest]);
    }
}
```

**Pedersen dealer asserts and unwraps public parameters** — `pedersen.rs:119-138`

The exported constructor aborts instead of returning an error for `k < 2` or any zero participant coordinate.

```rust
pub fn deal_exp_shares(
    rng: &mut impl RngCore,
    secret_byte: u8,
    xs: &[u8],
    k: u8,
) -> (PedersenCommitments, Vec<ExpShare>) {
    assert!(k >= 2);
    let a = random_poly(rng, secret_byte, k);
    let b = random_poly(rng, (rng.next_u32() & 0xFF) as u8, k);
    let comms = commit(&a, &b);
    let shares = xs
        .iter()
        .map(|&x| {
            let sx = scalar_x(x).unwrap();
            let s = a.eval_scalar(sx);
            let t = b.eval_scalar(sx);
            ExpShare { x, s: scalar_to_bytes(&s), t: scalar_to_bytes(&t) }
        })
        .collect();
```

**Uniform range helper does not validate its interval** — `rejection.rs:59-63`

An invalid or overflowing interval can make `span` zero, so `% span` panics instead of failing closed.

```rust
/// Jednostajne na [lo, hi] (helper testowy).
pub fn uniform_range_pub(rng: &mut impl rand::RngCore, lo: i32, hi: i32) -> i32 {
    let span = (hi - lo + 1) as u32;
    lo + (rng.next_u32() % span) as i32
}
```

**Bool verifier forwards unchecked slices** — `mpc_sign.rs:436-444`

The public verifier appears to return false on failure but reaches assertions and unchecked indexing for short or long attacker-supplied vectors.

```rust
pub fn verify_sign_equation(s1: &[u16], s2: &[u16], h: &[u16], t: &[u16]) -> bool {
    let prod = q_poly_mul_ring_clear(s2, h);
    for i in 0..FT1536_N {
        if q_sub(prod[i], s1[i]) != t[i] {
            return false;
        }
    }
    true
}
```

**Ring multiplication asserts exact lengths** — `mpc_sign.rs:234-237`

Malformed public slices terminate the process before a recoverable error can be returned.

```rust
pub fn q_poly_mul_ring_clear(a: &[u16], b: &[u16]) -> QPoly {
    assert_eq!(a.len(), FT1536_N);
    assert_eq!(b.len(), FT1536_N);
```

**Z_P sharing guard permits large u16 points and thresholds** — `ishare.rs:142-161`

The public wrapper validates distinct nonzero points but does not enforce the smaller k/x bounds assumed by raw VSS evaluation.

```rust
fn check_xs_p(xs: &[u16], k: u8) -> Result<usize> {
    if k < 2 { return Err(SpikeError::ThresholdTooLow); }
    if xs.is_empty() { return Err(SpikeError::EmptyXs); }
    if xs.len() < k as usize { return Err(SpikeError::NotEnoughPoints); }
    let mut seen = std::collections::HashSet::new();
    for &x in xs {
        if x == 0 || (x as u64) >= I_P { return Err(SpikeError::XZero); }
        if !seen.insert(x) { return Err(SpikeError::DuplicateX); }
    }
    Ok(xs.len())
}
```

**Raw polynomial evaluation uses unchecked u128 arithmetic** — `pedersen.rs:266-275`

Both the term multiplication, sum and power update can exceed u128; debug builds panic and release builds wrap.

```rust
fn zp_eval_poly_raw(coeffs: &[u64], x: u64) -> u128 {
    let mut acc = 0u128;
    let mut xp = 1u128;
    for &c in coeffs {
        acc += (c % ZP_MODULUS) as u128 * xp;
        xp *= x as u128;
    }
    acc
}
```

**Public verifier lacks length guards** — `mpc_sign.rs:434-444`

All four vectors are caller supplied; no exact-length validation occurs before multiplication or fixed indexing.

```rust
pub fn verify_sign_equation(s1: &[u16], s2: &[u16], h: &[u16], t: &[u16]) -> bool {
    let s2h = q_poly_mul_ring_clear(s2, h);
    for i in 0..FT1536_N {
        let lhs = q_sub(s2h[i], s1[i]);
        if lhs != t[i] {
            return false;
        }
    }
    true
}
```

**Ring multiply asserts caller lengths** — `mpc_sign.rs:234-249`

Malformed `s2` or `h` triggers `assert_eq!`; malformed `s1` or `t` later triggers bounds indexing in the caller.

```rust
pub fn q_poly_mul_ring_clear(a: &[u16], b: &[u16]) -> QPoly {
    assert_eq!(a.len(), FT1536_N);
    assert_eq!(b.len(), FT1536_N);
    let n = FT1536_N;
    let mut acc = vec![0u16; n];
    for i in 0..n {
        if a[i] == 0 { continue; }
        for j in 0..n {
            if b[j] == 0 { continue; }
            add_monomial(&mut acc, i + j, q_mul(a[i], b[j]));
        }
    }
    acc
}
```

Assertions:
- Short `s1` or `t` panics in `verify_sign_equation`.
- Wrong ring operands panic by assertion.
- `i64::MIN` overflows during negation.
- An output length of 65 makes `block2[..33]` out of bounds.
- `scalar_x(0)` returns `None`, which is unwrapped.
- A zero `span` reaches modulo by zero.
- verify_sign_equation is public and returns bool.
- q_poly_mul_ring_clear panics on non-1536 inputs.
- Normal xs=\[1,2,3\], k=2 examples fit.
- Overflow behavior differs between debug panic and release wrapping.

Counterevidence and remaining uncertainty:
- Normal in-tree callers use fixed-size inputs.
- No remote exposure is established.
- Several neighboring decoders already return `Option`/`Result`.
- Current internal callers use short buffers and fixed nonzero points.
- The uniform range function is documented as a test helper.
- No remotely exposed service exists in scope.
- The external engine verification wrapper is separate and may validate encodings.
- No remote listener is in scope.

Limitations:
- No panicking input was executed.
- The consulted `panic=abort` setting is configuration context, not an affected location.
- Actual embedding/recovery behavior is not supplied.
- No in-scope network service calls the helpers; the external engine verifier is separate.
- No remote or participant-controlled parameter negotiation was established.
- No panic was executed by user instruction.

#### Dataflow

malformed public length/threshold/coordinate/range/integer/VSS parameters -\> unchecked helper operation -\> panic/abort or wrapped proof values -\> denial of service or invalid commitment verification

- **Source:** public library parameters

- **Sink:** assertion, bounds check, unwrap, modulo by zero, or overflow

- **Outcome:** host denial of service or invalid VSS state

**Bool verifier forwards unchecked slices** — `mpc_sign.rs:436-444`

The public verifier appears to return false on failure but reaches assertions and unchecked indexing for short or long attacker-supplied vectors.

```rust
pub fn verify_sign_equation(s1: &[u16], s2: &[u16], h: &[u16], t: &[u16]) -> bool {
    let prod = q_poly_mul_ring_clear(s2, h);
    for i in 0..FT1536_N {
        if q_sub(prod[i], s1[i]) != t[i] {
            return false;
        }
    }
    true
}
```

**Ring multiplication asserts exact lengths** — `mpc_sign.rs:234-237`

Malformed public slices terminate the process before a recoverable error can be returned.

```rust
pub fn q_poly_mul_ring_clear(a: &[u16], b: &[u16]) -> QPoly {
    assert_eq!(a.len(), FT1536_N);
    assert_eq!(b.len(), FT1536_N);
```

**Z_P sharing guard permits large u16 points and thresholds** — `ishare.rs:142-161`

The public wrapper validates distinct nonzero points but does not enforce the smaller k/x bounds assumed by raw VSS evaluation.

```rust
fn check_xs_p(xs: &[u16], k: u8) -> Result<usize> {
    if k < 2 { return Err(SpikeError::ThresholdTooLow); }
    if xs.is_empty() { return Err(SpikeError::EmptyXs); }
    if xs.len() < k as usize { return Err(SpikeError::NotEnoughPoints); }
    let mut seen = std::collections::HashSet::new();
    for &x in xs {
        if x == 0 || (x as u64) >= I_P { return Err(SpikeError::XZero); }
        if !seen.insert(x) { return Err(SpikeError::DuplicateX); }
    }
    Ok(xs.len())
}
```

**Raw polynomial evaluation uses unchecked u128 arithmetic** — `pedersen.rs:266-275`

Both the term multiplication, sum and power update can exceed u128; debug builds panic and release builds wrap.

```rust
fn zp_eval_poly_raw(coeffs: &[u64], x: u64) -> u128 {
    let mut acc = 0u128;
    let mut xp = 1u128;
    for &c in coeffs {
        acc += (c % ZP_MODULUS) as u128 * xp;
        xp *= x as u128;
    }
    acc
}
```

**Signature equation indexes caller slices as fixed 1536-vectors** — `mpc_sign.rs:434-444`

Although `s2` and `h` hit assertion guards in the helper, short `s1` or `t` slices are indexed without validation and panic rather than returning `false` or `Err`.

```rust
pub fn verify_sign_equation(s1: &[u16], s2: &[u16], h: &[u16], t: &[u16]) -> bool {
    let s2h = q_poly_mul_ring_clear(s2, h);
    for i in 0..FT1536_N {
        let lhs = q_sub(s2h[i], s1[i]);
        if lhs != t[i] {
            return false;
        }
    }
    true
}
```

**Public multiplication asserts operand lengths** — `mpc_sign.rs:234-250`

Caller-controlled wrong lengths trigger an assertion panic at a public arithmetic boundary.

```rust
pub fn q_poly_mul_ring_clear(a: &[u16], b: &[u16]) -> QPoly {
    assert_eq!(a.len(), FT1536_N);
    assert_eq!(b.len(), FT1536_N);
    let n = FT1536_N;
    let mut acc = vec![0u16; n];
    // ...
    acc
}
```

**Rounding negates `i64::MIN`** — `ishare.rs:3308-3314`

For `i64::MIN`, `-v` overflows; debug builds panic and release behavior is not a fail-closed error contract.

```rust
pub fn round_half_away_i64(v: i64) -> i64 {
    let q = FT1536_Q as i64;
    if v >= 0 {
        (v + q / 2) / q
    } else {
        -(((-v) + q / 2) / q)
    }
}
```

**PRF second block is sliced by unbounded remaining length** — `prss.rs:62-73`

For `out.len() > 64`, `rest > 32` and `block2[..rest]` indexes beyond the 32-byte block, causing a panic from caller-controlled output length.

```rust
pub fn prf_bytes(seed: &PairwiseSeed, counter: u64, out: &mut [u8]) {
    let mut buf = [0u8; 40];
    buf[..32].copy_from_slice(&seed.key);
    buf[32..].copy_from_slice(&counter.to_le_bytes());
    let block = hash256(&[&buf, b"prf"]);
    let n = out.len().min(32);
    out[..n].copy_from_slice(&block[..n]);
    if out.len() > 32 {
        let block2 = hash256(&[&buf, b"prf2"]);
        let rest = out.len() - 32;
        out[32..].copy_from_slice(&block2[..rest]);
    }
}
```

**Pedersen dealer asserts and unwraps public parameters** — `pedersen.rs:119-138`

The exported constructor aborts instead of returning an error for `k < 2` or any zero participant coordinate.

```rust
pub fn deal_exp_shares(
    rng: &mut impl RngCore,
    secret_byte: u8,
    xs: &[u8],
    k: u8,
) -> (PedersenCommitments, Vec<ExpShare>) {
    assert!(k >= 2);
    let a = random_poly(rng, secret_byte, k);
    let b = random_poly(rng, (rng.next_u32() & 0xFF) as u8, k);
    let comms = commit(&a, &b);
    let shares = xs
        .iter()
        .map(|&x| {
            let sx = scalar_x(x).unwrap();
            let s = a.eval_scalar(sx);
            let t = b.eval_scalar(sx);
            ExpShare { x, s: scalar_to_bytes(&s), t: scalar_to_bytes(&t) }
        })
        .collect();
```

**Uniform range helper does not validate its interval** — `rejection.rs:59-63`

An invalid or overflowing interval can make `span` zero, so `% span` panics instead of failing closed.

```rust
/// Jednostajne na [lo, hi] (helper testowy).
pub fn uniform_range_pub(rng: &mut impl rand::RngCore, lo: i32, hi: i32) -> i32 {
    let span = (hi - lo + 1) as u32;
    lo + (rng.next_u32() % span) as i32
}
```

**Public verifier lacks length guards** — `mpc_sign.rs:434-444`

All four vectors are caller supplied; no exact-length validation occurs before multiplication or fixed indexing.

```rust
pub fn verify_sign_equation(s1: &[u16], s2: &[u16], h: &[u16], t: &[u16]) -> bool {
    let s2h = q_poly_mul_ring_clear(s2, h);
    for i in 0..FT1536_N {
        let lhs = q_sub(s2h[i], s1[i]);
        if lhs != t[i] {
            return false;
        }
    }
    true
}
```

**Ring multiply asserts caller lengths** — `mpc_sign.rs:234-249`

Malformed `s2` or `h` triggers `assert_eq!`; malformed `s1` or `t` later triggers bounds indexing in the caller.

```rust
pub fn q_poly_mul_ring_clear(a: &[u16], b: &[u16]) -> QPoly {
    assert_eq!(a.len(), FT1536_N);
    assert_eq!(b.len(), FT1536_N);
    let n = FT1536_N;
    let mut acc = vec![0u16; n];
    for i in 0..n {
        if a[i] == 0 { continue; }
        for j in 0..n {
            if b[j] == 0 { continue; }
            add_monomial(&mut acc, i + j, q_mul(a[i], b[j]));
        }
    }
    acc
}
```

#### Reachability

Requires an embedding to expose any cited API to lower-trust input without validation or panic isolation; no network endpoint is established.

- **Attacker:** malformed-input library caller

- **Entry point:** public cryptographic helper

- **Outcome:** process or operation termination

#### Severity

**Low** — A public-library caller can trigger denial of service with malformed values, but no network/service exposure or cross-tenant boundary is established and normal internal callers generally provide fixed-size data.

Raise severity if these APIs are reachable from unauthenticated or lower-trust inputs in a long-lived service; lower it if all calls are statically wrapped by validated fixed-size types and panic isolation.

Impact assessment:
- **Level:** low
- **Why:** Availability is directly affected; release-mode VSS overflow can also corrupt setup integrity, with no production exposure established.

Likelihood assessment:
- **Level:** unknown
- **Why:** No embedding service exposure is in scope.

#### Remediation

Audit every exported cryptographic boundary and replace assertions, unchecked indexing/slicing, modulo-by-unchecked values, `unwrap()`, and overflowing arithmetic with explicit checks returning typed `Result`. Use validated fixed-size/newtype inputs; enforce proven x/k bounds; evaluate VSS polynomials with checked modular arithmetic in one defined field; and generate arbitrary PRF output through counter/domain-separated blocks.

Tests:
- Pass zero-, short- and overlong vectors to every public polynomial/encoding/verification API and require `Err`/`false` without unwind.
- Pass `i64::MIN` to rounding and require a bounded error.
- Call `prf_bytes()` with lengths 0, 32, 64, 65 and a large bounded length; assert no panic and correct result/error.
- Pass `k < 2` and `x = 0` to Pedersen dealing; assert typed errors.
- Fuzz public size/range/coordinate inputs under a no-panic invariant.
- Pass lengths 0,1,1535,1537 and assert false/Err without panic.
- Exercise maximum allowed x/k and assert a deterministic error without panic or wrapping.
- Property-test checked evaluation against modular reference arithmetic.
- Pass lengths 0, N-1, and N+1 for every argument under `catch_unwind`; require controlled rejection with no panic.
- Fuzz the public verifier over arbitrary vector lengths.

Preventive controls:
- Fuzz all public parsing/arithmetic boundaries under `catch_unwind` and forbid panics.
- Use newtypes for 1536-coefficient polynomials and validated sampler parameters.
- Avoid `assert!`, `unwrap()`, unchecked indexing and unchecked arithmetic on exported input boundaries.
- Document maximum allocation/work limits and enforce them before processing.
- Keep test-only helpers private or clearly feature-gated.
- Separate checked public wrappers from private fixed-size helpers.
- Prefer fixed-size array types where dimensions are invariant.
- Define and enforce a proven safe parameter envelope.
- Avoid raw integer field bridges; evaluate modulo the intended field.
- Use checked polynomial newtypes with enforced length.
- Keep panic-free parsers/verifiers at untrusted boundaries.

<a id="finding-15"></a>

### [15] Filename-only mailbox accepts replaced or replayed ceremony artifacts

| Field | Value |
| --- | --- |
| Severity | low |
| Confidence | high |
| Confidence rationale | Source directly shows predictable filenames, unauthenticated reads and only aggregate consistency; deployment exposure is the principal uncertainty. |
| Category | Missing authenticity and freshness validation for protocol messages |
| CWE | CWE-345 |
| Affected lines | bin/iso.rs:520-591, bin/iso.rs:636-652, bin/iso.rs:953-1022, lib.rs:1859-1882 |

#### Summary

The `iso` workers accept DKG deals, multiplication shares, Beaver masks, columns, MAC shares and delta shares from predictable files using only existence/length checks. Atomic rename prevents partial reads but does not bind sender, recipient, session or round cryptographically; a writable peer can replace a contributor's complete polynomial consistently so aggregate consistency still passes.

#### Root Cause

Protocol identity and freshness are encoded only in mutable filenames. The reader verifies size and sometimes aggregate polynomial consistency, but never authenticates the sender or binds artifacts to a unique session/transcript.

**Predictable DKG files are accepted without authentication** — `bin/iso.rs:520-546`

The receiver trusts the claimed sender encoded in a filename and a 32-byte length. No signature, MAC, session ID or replay state binds the payload to that sender.

```rust
for (j, x) in xs.iter().enumerate() {
    let path = mailbox.join(format!("deal{p}_{x}.bin"));
    let tmp = mailbox.join(format!("deal{p}_{x}.tmp"));
    std::fs::write(&tmp, deals[j]).unwrap();
    std::fs::rename(&tmp, &path).unwrap();
}
// ...
for q in 0..3 {
    let bytes = audited_read(p, &workdir, &mailbox.join(format!("deal{q}_{}.bin", xs[p]))).unwrap();
    assert_eq!(bytes.len(), 32);
    for b in 0..32 {
        col[b] ^= bytes[b];
    }
}
```

**Later consistency validates shape, not sender authenticity** — `bin/iso.rs:636-652`

A coherent replacement polynomial yields consistent aggregate columns, so this check does not prove which participant authored the replaced contribution.

```rust
for b in 0..32 {
    let shares: Vec<ft1536_threshold_spike::Share> = (0..3)
        .map(|p| {
            let c = std::fs::read(workdir.join(format!("col{p}.bin"))).unwrap();
            ft1536_threshold_spike::Share { x: [1u8, 2, 3][p], share: c[b] }
        })
        .collect();
    let refs: Vec<&_> = shares.iter().collect();
    if ft1536_threshold_spike::verify_consistency(&refs, 2).is_err() {
        std::process::exit(3);
    }
}
```

#### Validation

Reads from DKG and multiplication mailboxes were traced to their checks; no signature, keyed MAC, session identifier, monotonic counter or create-new replay guard is present.

Validation method: Static protocol-message trace

**Predictable DKG files are accepted without authentication** — `bin/iso.rs:520-546`

The receiver trusts the claimed sender encoded in a filename and a 32-byte length. No signature, MAC, session ID or replay state binds the payload to that sender.

```rust
for (j, x) in xs.iter().enumerate() {
    let path = mailbox.join(format!("deal{p}_{x}.bin"));
    let tmp = mailbox.join(format!("deal{p}_{x}.tmp"));
    std::fs::write(&tmp, deals[j]).unwrap();
    std::fs::rename(&tmp, &path).unwrap();
}
// ...
for q in 0..3 {
    let bytes = audited_read(p, &workdir, &mailbox.join(format!("deal{q}_{}.bin", xs[p]))).unwrap();
    assert_eq!(bytes.len(), 32);
    for b in 0..32 {
        col[b] ^= bytes[b];
    }
}
```

**Later consistency validates shape, not sender authenticity** — `bin/iso.rs:636-652`

A coherent replacement polynomial yields consistent aggregate columns, so this check does not prove which participant authored the replaced contribution.

```rust
for b in 0..32 {
    let shares: Vec<ft1536_threshold_spike::Share> = (0..3)
        .map(|p| {
            let c = std::fs::read(workdir.join(format!("col{p}.bin"))).unwrap();
            ft1536_threshold_spike::Share { x: [1u8, 2, 3][p], share: c[b] }
        })
        .collect();
    let refs: Vec<&_> = shares.iter().collect();
    if ft1536_threshold_spike::verify_consistency(&refs, 2).is_err() {
        std::process::exit(3);
    }
}
```

Assertions:
- A peer with write access can create the expected filename.
- Coherent replacement survives aggregate consistency.

Counterevidence and remaining uncertainty:
- Temporary-file rename reduces partial-write races.
- Startup removes the workdir and payload lengths are checked.
- The binary explicitly describes a prototype/semi-honest model.

Limitations:
- No filesystem attack was executed.

#### Dataflow

attacker-written predictable file -\> length-checked read -\> share aggregation -\> aggregate consistency -\> derived seed/output

- **Source:** Shared writable mailbox

- **Sink:** DKG/multiplication share aggregation

- **Outcome:** Unauthenticated contribution substitution or replay

**Predictable DKG files are accepted without authentication** — `bin/iso.rs:520-546`

The receiver trusts the claimed sender encoded in a filename and a 32-byte length. No signature, MAC, session ID or replay state binds the payload to that sender.

```rust
for (j, x) in xs.iter().enumerate() {
    let path = mailbox.join(format!("deal{p}_{x}.bin"));
    let tmp = mailbox.join(format!("deal{p}_{x}.tmp"));
    std::fs::write(&tmp, deals[j]).unwrap();
    std::fs::rename(&tmp, &path).unwrap();
}
// ...
for q in 0..3 {
    let bytes = audited_read(p, &workdir, &mailbox.join(format!("deal{q}_{}.bin", xs[p]))).unwrap();
    assert_eq!(bytes.len(), 32);
    for b in 0..32 {
        col[b] ^= bytes[b];
    }
}
```

**Later consistency validates shape, not sender authenticity** — `bin/iso.rs:636-652`

A coherent replacement polynomial yields consistent aggregate columns, so this check does not prove which participant authored the replaced contribution.

```rust
for b in 0..32 {
    let shares: Vec<ft1536_threshold_spike::Share> = (0..3)
        .map(|p| {
            let c = std::fs::read(workdir.join(format!("col{p}.bin"))).unwrap();
            ft1536_threshold_spike::Share { x: [1u8, 2, 3][p], share: c[b] }
        })
        .collect();
    let refs: Vec<&_> = shares.iter().collect();
    if ft1536_threshold_spike::verify_consistency(&refs, 2).is_err() {
        std::process::exit(3);
    }
}
```

#### Reachability

Requires local write access to the shared ceremony workdir while a demo runs.

- **Attacker:** Malicious local participant or filesystem peer

- **Entry point:** `iso` mailbox files

- **Outcome:** Key substitution, corrupted computation, or denial of service

#### Severity

**Low** — A malicious local participant with shared-workdir write access can substitute or replay protocol state and cause key substitution or invalid computation. The path is an explicitly semi-honest local prototype with no production deployment or remote exposure, which substantially limits likelihood and supported impact.

Raise severity if these file mailboxes are used across mutually distrustful production participants; lower or reject if the workdir is proven exclusive to a fully trusted single-user test harness.

Impact assessment:
- **Level:** high
- **Why:** A coherent replacement can change the shared seed or protocol result.

Likelihood assessment:
- **Level:** low
- **Why:** The path is local, prototype-only, and requires shared-workdir write access.

#### Remediation

Authenticate every artifact over protocol version, session ID, sender, recipient, type, round and payload; reject duplicates/stale messages and use protected participant-specific IPC or create-new files rather than trusting shared mutable names.

Tests:
- Replace every evaluation from one claimed sender with a fresh coherent polynomial and assert rejection on authentication, not only consistency.
- Replay a valid artifact from a prior session and require rejection.

Preventive controls:
- Use per-participant signing/MAC keys and transcript hashes.
- Separate private channels from public broadcast artifacts.

<a id="finding-16"></a>

### [16] Gaussian sampler biases proposals and returns rejected candidates as successful samples

| Field | Value |
| --- | --- |
| Severity | low |
| Confidence | high |
| Confidence rationale | The biased modulo reduction and `Ok` return after a failed acceptance predicate are direct source facts, and downstream consumers use `s.x` without an exhaustion status. |
| Category | Insufficiently random values / fail-open rejection sampling |
| CWE | CWE-331, CWE-754 |
| Affected lines | rejection.rs:59-66, rejection.rs:693-719, rejection.rs:1006-1030, ishare.rs:950-1009, ishare.rs:3221-3239, rejection.rs:696, rejection.rs:1007, ishare.rs:956, ishare.rs:988, rejection.rs:696-719, ishare.rs:987-1005 |

#### Summary

`uniform_range_pub()` maps `u32` output with `% span`, biasing every non-divisor proposal range, and both Result-returning Q16/Q73 samplers return `Ok` with the last rejected candidate after 10,001 failed attempts. The DGDG paths consume that `x` without an acceptance flag and can feed it into the optional G2 signing noise path.

#### Root Cause

The proposal generator uses modulo reduction instead of unbiased bounded sampling, and the rejection loop conflates exhaustion with acceptance by returning the last rejected proposal as `Ok`. Downstream APIs carry only `x` and attempts, so the protocol cannot recover the missing acceptance decision.

**Proposal range uses biased modulo reduction** — `rejection.rs:59-66`

For the usual span `2*w+1`, modulo reduction is biased unless the span divides `2^32`, so proposal probabilities do not match the declared uniform source.

```rust
pub fn uniform_range_pub(rng: &mut impl rand::RngCore, lo: i32, hi: i32) -> i32 {
    let span = (hi - lo + 1) as u32;
    lo + (rng.next_u32() % span) as i32
}
```

**Q73 cap returns an unaccepted candidate as success** — `rejection.rs:1007-1030`

The cap branch executes only after `u < wt` was false, yet returns the rejected `x` with `Ok`, making exhaustion indistinguishable from acceptance.

```rust
pub fn sample_gaussian_q73_clear(
    rng: &mut impl rand::RngCore,
    w: i32,
    sigma_q73: u128,
) -> Result<SampleOutcome, GaussQError> {
    // guards omitted
    let mut attempts = 0u32;
    loop {
        attempts = attempts.saturating_add(1);
        let x = uniform_range_pub(rng, -w, w);
        let wt = gauss_weight_q73(x, sigma_q73);
        let u = uniform_q73_pub(rng);
        if u < wt {
            return Ok(SampleOutcome { x, attempts });
        }
        if attempts > 10_000 {
            return Ok(SampleOutcome { x, attempts });
        }
    }
}
```

**DGDG reshares the returned value without checking acceptance** — `ishare.rs:970-983`

The downstream protocol treats every `Ok` value as valid Gaussian noise and has no acceptance/exhaustion indicator to reject the fail-open candidate.

```rust
for party in 0..n {
    let s = crate::rejection::sample_gaussian_q73_clear(
        &mut rngs[party % rngs.len()],
        w_i,
        s73_i,
    )
    .map_err(|_| SpikeError::WrongThreshold)?;
    let sh = ishare_val_unchecked(&mut rngs[party % rngs.len()], i64::from(s.x), xs, k);
    for (a, v) in acc.iter_mut().zip(sh) {
        *a = p_add(*a, v);
    }
}
```

**DGDG share generation consumes the returned x** — `ishare.rs:988-1005`

DGDG generation treats the returned last candidate as an accepted Gaussian contribution and shares it into signing noise.

```rust
for party in 0..n {
    let s = crate::rejection::sample_gaussian_q73_clear(src.party_rng(party), w_i, s73_i)
        .map_err(|_| SpikeError::WrongThreshold)?;
    let sh = ishare_val_unchecked(src.party_rng(party), i64::from(s.x), xs, k);
    for (a, v) in acc.iter_mut().zip(sh) {
        *a = p_add(*a, v);
    }
}
```

**Q16 cap returns Ok** — `rejection.rs:707-718`

After a failed acceptance predicate, exhaustion returns the rejected `x` through the indistinguishable success variant.

```rust
loop {
    attempts = attempts.saturating_add(1);
    let x = uniform_range_pub(rng, -w, w);
    let wt = gauss_weight_q(x, sigma_q);
    let u = (rng.next_u32() as u64) & (GAUSS_Q_ONE - 1);
    if u < wt {
        return Ok(SampleOutcome { x, attempts });
    }
    if attempts > 10_000 {
        return Ok(SampleOutcome { x, attempts });
    }
}
```

**Q73 cap returns Ok** — `rejection.rs:1018-1029`

The signing-relevant Q73 sampler has the same fail-open return.

```rust
loop {
    attempts = attempts.saturating_add(1);
    let x = uniform_range_pub(rng, -w, w);
    let wt = gauss_weight_q73(x, sigma_q73);
    let u = uniform_q73_pub(rng);
    if u < wt {
        return Ok(SampleOutcome { x, attempts });
    }
    if attempts > 10_000 {
        return Ok(SampleOutcome { x, attempts });
    }
}
```

**PRSS noise consumes every Ok sample** — `ishare.rs:994-1005`

No accepted/exhausted flag exists, so the rejected cap value becomes a participant's noise contribution.

```rust
for party in 0..n {
    let s = crate::rejection::sample_gaussian_q73_clear(src.party_rng(party), w_i, s73_i)
        .map_err(|_| SpikeError::WrongThreshold)?;
    let sh = ishare_val_unchecked(src.party_rng(party), i64::from(s.x), xs, k);
    for (a, v) in acc.iter_mut().zip(sh) {
        *a = p_add(*a, v);
    }
}
```

#### Validation

The sampler review confirms both biased proposal/weight construction and a fail-open attempt cap: Q16 and Q73 paths can return the last rejected candidate as `Ok`, and the Q73 result reaches DGDG signing-noise generation. Honest-parameter exhaustion remains extremely unlikely.

Validation method: Static control-flow and distribution review; static branch and consumer trace

**Proposal range uses biased modulo reduction** — `rejection.rs:59-66`

For the usual span `2*w+1`, modulo reduction is biased unless the span divides `2^32`, so proposal probabilities do not match the declared uniform source.

```rust
pub fn uniform_range_pub(rng: &mut impl rand::RngCore, lo: i32, hi: i32) -> i32 {
    let span = (hi - lo + 1) as u32;
    lo + (rng.next_u32() % span) as i32
}
```

**Q73 cap returns an unaccepted candidate as success** — `rejection.rs:1007-1030`

The cap branch executes only after `u < wt` was false, yet returns the rejected `x` with `Ok`, making exhaustion indistinguishable from acceptance.

```rust
pub fn sample_gaussian_q73_clear(
    rng: &mut impl rand::RngCore,
    w: i32,
    sigma_q73: u128,
) -> Result<SampleOutcome, GaussQError> {
    // guards omitted
    let mut attempts = 0u32;
    loop {
        attempts = attempts.saturating_add(1);
        let x = uniform_range_pub(rng, -w, w);
        let wt = gauss_weight_q73(x, sigma_q73);
        let u = uniform_q73_pub(rng);
        if u < wt {
            return Ok(SampleOutcome { x, attempts });
        }
        if attempts > 10_000 {
            return Ok(SampleOutcome { x, attempts });
        }
    }
}
```

**DGDG reshares the returned value without checking acceptance** — `ishare.rs:970-983`

The downstream protocol treats every `Ok` value as valid Gaussian noise and has no acceptance/exhaustion indicator to reject the fail-open candidate.

```rust
for party in 0..n {
    let s = crate::rejection::sample_gaussian_q73_clear(
        &mut rngs[party % rngs.len()],
        w_i,
        s73_i,
    )
    .map_err(|_| SpikeError::WrongThreshold)?;
    let sh = ishare_val_unchecked(&mut rngs[party % rngs.len()], i64::from(s.x), xs, k);
    for (a, v) in acc.iter_mut().zip(sh) {
        *a = p_add(*a, v);
    }
}
```

**DGDG share generation consumes the returned x** — `ishare.rs:988-1005`

DGDG generation treats the returned last candidate as an accepted Gaussian contribution and shares it into signing noise.

```rust
for party in 0..n {
    let s = crate::rejection::sample_gaussian_q73_clear(src.party_rng(party), w_i, s73_i)
        .map_err(|_| SpikeError::WrongThreshold)?;
    let sh = ishare_val_unchecked(src.party_rng(party), i64::from(s.x), xs, k);
    for (a, v) in acc.iter_mut().zip(sh) {
        *a = p_add(*a, v);
    }
}
```

**Q16 cap returns Ok** — `rejection.rs:707-718`

After a failed acceptance predicate, exhaustion returns the rejected `x` through the indistinguishable success variant.

```rust
loop {
    attempts = attempts.saturating_add(1);
    let x = uniform_range_pub(rng, -w, w);
    let wt = gauss_weight_q(x, sigma_q);
    let u = (rng.next_u32() as u64) & (GAUSS_Q_ONE - 1);
    if u < wt {
        return Ok(SampleOutcome { x, attempts });
    }
    if attempts > 10_000 {
        return Ok(SampleOutcome { x, attempts });
    }
}
```

**Q73 cap returns Ok** — `rejection.rs:1018-1029`

The signing-relevant Q73 sampler has the same fail-open return.

```rust
loop {
    attempts = attempts.saturating_add(1);
    let x = uniform_range_pub(rng, -w, w);
    let wt = gauss_weight_q73(x, sigma_q73);
    let u = uniform_q73_pub(rng);
    if u < wt {
        return Ok(SampleOutcome { x, attempts });
    }
    if attempts > 10_000 {
        return Ok(SampleOutcome { x, attempts });
    }
}
```

**PRSS noise consumes every Ok sample** — `ishare.rs:994-1005`

No accepted/exhausted flag exists, so the rejected cap value becomes a participant's noise contribution.

```rust
for party in 0..n {
    let s = crate::rejection::sample_gaussian_q73_clear(src.party_rng(party), w_i, s73_i)
        .map_err(|_| SpikeError::WrongThreshold)?;
    let sh = ishare_val_unchecked(src.party_rng(party), i64::from(s.x), xs, k);
    for (a, v) in acc.iter_mut().zip(sh) {
        *a = p_add(*a, v);
    }
}
```

Assertions:
- The cap branch returns after a rejection.
- `GaussQError` has no exhaustion variant.
- DGDG consumes `s.x` directly.
- The last x may have weight zero or a failed u comparison.
- Honest supported parameters make 10,001 consecutive rejections extremely unlikely.

Counterevidence and remaining uncertainty:
- Default derived windows make 10,001 consecutive honest-RNG rejections extremely unlikely.
- The 73-bit acceptance threshold itself uses 73 random bits.
- The sampler is explicitly prototype code.
- With intended sigma/window and honest RNG, exhaustion is extremely unlikely.
- The code is a prototype.

Limitations:
- No runtime distribution experiment or target execution was performed.
- An adversary controlling the RNG already has broad sample influence; no practical honest-parameter exhaustion rate was measured.
- No deterministic failing RNG was executed by user instruction.

#### Dataflow

RNG/parameters -\> biased proposal and failed accept loop -\> `Ok(SampleOutcome)` -\> DGDG shares -\> optional signing noise

- **Source:** Caller-supplied RNG and sampler parameters

- **Sink:** DGDG noise shares

- **Outcome:** Out-of-distribution value accepted as protocol noise

**Proposal range uses biased modulo reduction** — `rejection.rs:59-66`

For the usual span `2*w+1`, modulo reduction is biased unless the span divides `2^32`, so proposal probabilities do not match the declared uniform source.

```rust
pub fn uniform_range_pub(rng: &mut impl rand::RngCore, lo: i32, hi: i32) -> i32 {
    let span = (hi - lo + 1) as u32;
    lo + (rng.next_u32() % span) as i32
}
```

**Q73 cap returns an unaccepted candidate as success** — `rejection.rs:1007-1030`

The cap branch executes only after `u < wt` was false, yet returns the rejected `x` with `Ok`, making exhaustion indistinguishable from acceptance.

```rust
pub fn sample_gaussian_q73_clear(
    rng: &mut impl rand::RngCore,
    w: i32,
    sigma_q73: u128,
) -> Result<SampleOutcome, GaussQError> {
    // guards omitted
    let mut attempts = 0u32;
    loop {
        attempts = attempts.saturating_add(1);
        let x = uniform_range_pub(rng, -w, w);
        let wt = gauss_weight_q73(x, sigma_q73);
        let u = uniform_q73_pub(rng);
        if u < wt {
            return Ok(SampleOutcome { x, attempts });
        }
        if attempts > 10_000 {
            return Ok(SampleOutcome { x, attempts });
        }
    }
}
```

**DGDG reshares the returned value without checking acceptance** — `ishare.rs:970-983`

The downstream protocol treats every `Ok` value as valid Gaussian noise and has no acceptance/exhaustion indicator to reject the fail-open candidate.

```rust
for party in 0..n {
    let s = crate::rejection::sample_gaussian_q73_clear(
        &mut rngs[party % rngs.len()],
        w_i,
        s73_i,
    )
    .map_err(|_| SpikeError::WrongThreshold)?;
    let sh = ishare_val_unchecked(&mut rngs[party % rngs.len()], i64::from(s.x), xs, k);
    for (a, v) in acc.iter_mut().zip(sh) {
        *a = p_add(*a, v);
    }
}
```

**DGDG share generation consumes the returned x** — `ishare.rs:988-1005`

DGDG generation treats the returned last candidate as an accepted Gaussian contribution and shares it into signing noise.

```rust
for party in 0..n {
    let s = crate::rejection::sample_gaussian_q73_clear(src.party_rng(party), w_i, s73_i)
        .map_err(|_| SpikeError::WrongThreshold)?;
    let sh = ishare_val_unchecked(src.party_rng(party), i64::from(s.x), xs, k);
    for (a, v) in acc.iter_mut().zip(sh) {
        *a = p_add(*a, v);
    }
}
```

**Q73 cap returns Ok** — `rejection.rs:1018-1029`

The signing-relevant Q73 sampler has the same fail-open return.

```rust
loop {
    attempts = attempts.saturating_add(1);
    let x = uniform_range_pub(rng, -w, w);
    let wt = gauss_weight_q73(x, sigma_q73);
    let u = uniform_q73_pub(rng);
    if u < wt {
        return Ok(SampleOutcome { x, attempts });
    }
    if attempts > 10_000 {
        return Ok(SampleOutcome { x, attempts });
    }
}
```

**PRSS noise consumes every Ok sample** — `ishare.rs:994-1005`

No accepted/exhausted flag exists, so the rejected cap value becomes a participant's noise contribution.

```rust
for party in 0..n {
    let s = crate::rejection::sample_gaussian_q73_clear(src.party_rng(party), w_i, s73_i)
        .map_err(|_| SpikeError::WrongThreshold)?;
    let sh = ishare_val_unchecked(src.party_rng(party), i64::from(s.x), xs, k);
    for (a, v) in acc.iter_mut().zip(sh) {
        *a = p_add(*a, v);
    }
}
```

#### Reachability

A library caller can supply an arbitrary `RngCore`; honest default parameters make accidental exhaustion unlikely.

- **Attacker:** Caller controlling RNG or entropy-source failure

- **Entry point:** `sample_gaussian_q73_clear()` and DGDG wrappers

- **Outcome:** Biased or rejected noise enters computation

#### Severity

**Low** — The implementation violates the claimed Gaussian distribution and can fail open under adversarial or faulty RNG behavior. Default small windows make exhaustion extremely unlikely and the source is a research prototype, so concrete production leakage or forgery is not established.

Raise severity if this sampler is used for production signing noise or measurements establish exploitable statistical leakage; lower it if all affected paths remain non-security test oracles.

Impact assessment:
- **Level:** medium
- **Why:** Distribution assumptions are invalidated and signing can fail or become statistically distinguishable, but no key recovery is proved.

Likelihood assessment:
- **Level:** low
- **Why:** Exhaustion is negligible for documented honest defaults; modulo bias always exists but may be small.

#### Remediation

Use unbiased bounded-integer rejection sampling for proposal generation and add an `AttemptsExhausted` error returned at the cap. Propagate exhaustion as a transcript-safe abort/retry through DGDG and signing.

Tests:
- Use a deterministic RNG that forces every acceptance test to fail and assert `AttemptsExhausted` with no returned sample.
- Property-test non-power-of-two ranges for unbiased bounded sampling and ensure every successful sample corresponds to a satisfied acceptance predicate.
- Use a deterministic RNG that always fails acceptance and assert an exhaustion error.
- Assert DGDG/signing aborts on sampler exhaustion.
- Use an RNG that always produces rejection and require an exhaustion error at the cap for Q16 and Q73.
- Assert every successful sample corresponds to a satisfied acceptance predicate.

Preventive controls:
- Use a reviewed discrete-Gaussian sampler with a documented statistical-distance bound.
- Keep acceptance/exhaustion state explicit in result types.
- Make exhaustion an explicit error variant.
- Validate supported windows/sigma and monitor rejection caps without revealing secret-dependent attempt counts.
- Use a result type that distinguishes accepted, exhausted, and invalid-parameter states.
- Fix production signing parameters internally.

---

## Podsumowanie właściciela / audytora (wpięte po odczycie)

**Źródło skarbu:** materiał wewnętrzny (audyt bezpieczeństwa — poza repo)  
**Snapshot:** 14 plików `.rs`, digest `67a6474900bdc7d42f853cb5945f0bc19ddf72e1a0261a89db444fbe7d6221f7`.  
**16 findings** (10 medium, 6 low, confidence high, coverage complete).

### Kolejność napraw (T12 wg severity + wpływ)

| Pri | # | Finding | Dlaczego pierwsze |
|---|---|---|---|
| P0 | **1** | Shamir mul: brak `n ≥ 2k−1` | **Cichy zły wynik** mnożenia — psuje poprawność bez błędu |
| P0 | **6** | Byte-sized Pedersen blinds | Obserwator **odzyskuje sekret** z commitments |
| P1 | **2** | Niesprawdzony Beaver `c` w auth mul | Fałszywe triple → fałszywe mnożenie |
| P1 | **3** | Signing bez sprawdzenia DKG + NTRU nieuwierzytelniony | Typ nie wiąże check→sign |
| P1 | **9** | Jawny δ G2 + post-hoc MAC → skorelowane fałszerstwa | |
| P2 | **4** | Maski tej samej szerokości — wyciek z powtórzeń | |
| P2 | **5** | Deterministyczny sampling zamiast losowego (Eflipy) | A4 z audytu wewnętrznego |
| P2 | **7** | G2 signing bez VSS commitments | |
| P2 | **8** | Centralizowany DKG/PRSS (T7/T8 = in-process) | |
| P2 | **10** | Wspólny workdir `iso` | |
| P3 | 11–16 | zeroizacja, seed ceremony, SHAKE bitness, panic, mailbox, bias | |

### Czego audyt NIE podważa (zachowaj)

- Złoto: `Ft1536Signature::verify==true` z s2 z udziałów — **potwierdzone**.
- Codec bit-exact vs silnik — **potwierdzony**.
- Retained / stand-in disclaimery — audyt je **uznał** za jawne ograniczenia.
- „400/400 ≠ security proof” — audyt wprost to napisał.

### Trzy zdania skarbu

1. **Wykazano:** 16 realnych luk (m.in. quorum mul za małe, Pedersen blinds
   za krótkie, jawny δ, brak typestate DKG→sign).
2. **Najbliższy brak:** T12 — naprawy P0/P1 (#1, #6, #2, #3, #9).
3. **NIE implikuje:** że złoto jest fałszywe — jest prawdziwe, ale
   **fundamenty** wymagają napraw przed jakimkolwiek „próg FT”.
