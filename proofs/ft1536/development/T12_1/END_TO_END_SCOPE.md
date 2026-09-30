# T12.1 — end-to-end scope, modeling decisions and the path to the theorem

Status: **OWNER-APPROVED SCOPE 2026-09-30**. This document is the explicit
path from the current partial packages to the end-to-end security statement
about the real FT1536 implementation. It records the three owner modeling
decisions, the explicit assumptions ledger, the missing-implication ladder
with owners, and the ordered first steps. Every later claim must trace to
this scope; anything not covered here is out of scope until added.

Motivation: the 2026-09-30 independent archive audit found the reduction
core sound (no counterexample) but correctly identified the missing
implication

    real C KeyGen/Sign/Verify/PRNG  ==>  formal runEUF game with the same law

together with a concrete public sampler `S` and a proof of
`LocalJointCertificate S e`. This document fixes the target shape so that
neither constants nor assumptions can be absorbed silently.

## 1. Target statement (fixed shape)

With `q_s` signing queries and `AdvMT` the MT-ISIS advantage:

    AdvEUF <= min{1, eps_coll^cond + Phi((1 + e^cond)^q_s - 1, AdvMT)}
                 + Delta_PRG

- `eps_coll^cond` — collision/single-key error probability under the
  **conditional** key law (decision D1) and the **real** generator
  (decision D2);
- `e^cond` — the proven certificate constant (decision D3), satisfying
  `second(Law) <= 1 + e^cond`;
- `Delta_PRG` — statistical distance of the real PRG output from uniform on
  the consumed bit-length; **or** `Adv_PRG` if and only if route (b) of D2
  is taken (see below). Exactly one of the two terms appears, never zero
  without a proof.

Accounting identities to be proven, not assumed (REFINED 2026-10-01 after
pinning the exact types — the earlier one-line form was blurred; see
`run2/notes/S3_E_PROVENANCE.md`):

- `e` bounds `second sim honestCO <= 1 + e`
  (`Divergence.second j p = sum j^2/p = chi^2 + 1`) for the FULL `(c,o)`
  law of one fresh `S.run` call INCLUDING its hit/miss split — the SIGN
  sampler's law, not the key law;
- `delta < 1.27e-24` (CenteringClosure, `single_change_modular`, Arb
  interval [1.2660684e-24, 1.2678251e-24]) bounds the probability that a
  POSITIVE Sign reply is rejected — a miss-probability bound, NOT a chi^2
  bound; the **delta -> e composition is the missing B4 bridge**;
- the key-law conditioning (D1, measured `p_accept = 0.34671`) shapes
  `SigmaMath.muH muKey` — which law the MT-ISIS hardness is assumed for —
  not a numeric factor of `e`;
- conservative kernel transfers (to be proven) for the fallback route:
  pointwise `(1+-d)` multiplicative bounds give `second <= (1+d)^2`
  (`e <= (1+d)^2-1`); conditioning `second (j|A) p <= second j p /
  (mass j A)^2`; hit/miss mass transfer. The intended primary route is a
  DIRECT analysis of the emitted law (the heavy analytic paths).

## 2. Owner modeling decisions (2026-09-30)

- **D1 — KeyGen with restarts, CONDITIONAL.** The public-key law is
  `muH := Law(real C KeyGen | success)` — the real key *is* the output of
  the first successful attempt. Consequence: every probability/second-moment
  constant propagates through conditioning (factor `1/P(success)` unless
  re-derived).
- **D1 refinement (2026-09-30, after owner challenge).** Conditioning is
  the only truthful model and the canonical EUF-CMA completion of a
  fallible KeyGen (repeat-until-success); its law is exactly
  `Law(attempt | accepted)`. Three sharpenings, load-bearing:
  (i) the conditioning event is **per-attempt certificate acceptance**
  (the emitted key is the first accepted attempt), NOT call-level success;
  the attempt cap is availability only and does not shape the emitted-key
  law — the factor is `1/p_accept`;
  (ii) A1 is elevated to a THEOREM-HYPOTHESIS rank (like the PRG
  assumption): acceptance correlates with the secret material, so any
  observable retry trace is secret-dependent leakage; if retries are
  observable in a deployment, the conditional law alone is insufficient;
  (iii) vacuity guard: `e^cond` grows like `1/p_accept`; if `p_accept` is
  small the theorem may become vacuous — that is an honest FINDING to
  report, never to be smoothed over.
  Rejected alternatives, recorded: unconditional law with an explicit
  bottom key (non-standard, weaker); unconditional sampler law ignoring
  conditioning (FALSE security — the adversary never sees rejected
  material).
- **D2 — real PRNG.** The theorem is stated over the actual generator, not
  an idealized random source. **Route decided on the record 2026-09-30
  (owner approval "trasa B --> TAK"), after S2 identification: route (b).**
  S2 finding: the generator is the portable Falcon PRNG of `Extra/c/frng.c`
  (ChaCha20 stream, seeded by a SHAKE-256 instance over `/dev/urandom` or
  CryptGenRandom plus user seed; SSE2/AES-NI variants share the same law).
  Statistical route (a) is therefore closed by measurement: a ChaCha20
  stream has statistical distance ~1 from uniform at real output lengths.
  Route (b): the bound carries `Adv_PRG(ChaCha20)` explicitly and the
  certificate constant `e^unconditional` is computed for a uniform bit
  stream (its natural measure), with A2 at the entropy boundary. Silent
  idealization remains forbidden: measuring the certificate under the ideal
  measure while claiming the real generator is the exact failure mode this
  scope exists to prevent.
- **D3 — the constant is PROVEN as `e`, not assumed.** The numerical value
  currently estimated around `1.27e-24` (exact provenance to be pinned in
  S3) becomes `e` only through a rigorous upper bound on `second - 1` of the
  **conditional, real-generator** law. Until that proof exists, the number
  is an estimate and must not be cited as a parameter.

## 3. Explicit assumptions ledger (assumed, not proven; each needs a home)

- **A1 — no timing/attempt-count leakage from KeyGen.** Keys are generated
  offline; the adversary does not observe the number of restarts. **Rank:
  theorem hypothesis on par with the PRG assumption** (D1 refinement (ii)):
  certificate acceptance correlates with the secret material, so any
  observable retry trace is secret-dependent leakage. (If this is ever
  relaxed, the restart count becomes leakage and D1 needs redoing.)
- **A2 — seed uniformity.** The seed is uniform and independent of the
  adversary (hardware entropy source idealized at the seed boundary only).
- **A3 — `verdict` = `Relation.Verify`.** The formal verdict function
  coincides with the semantic verifier on all byte inputs (bridge B3).
- **A4 — serialization round-trip.** Byte encoding/decoding used by the
  game is injective and consistent with the C serializers (bridge B3).
- **A5 — machine model scope.** LP64 word semantics with wrapping as
  modeled (source3's contracts); no fault/side-channel security claimed.

## 4. Missing-implication ladder (the path)

- **B1 — key law binding.** `muH = Law(real C KeyGen | success)`.
  Owner: source3 (`KEYGEN_SOURCE_TO_FIBER_001`, IN_PROGRESS: Montgomery
  contracts done from source, FFT leaf frames bound, NTRU equation bridge
  open). Plus: extraction of `P(success)` from the restart loop.
- **B2 — PRG identification and accounting.** Identify the real generator
  from the pinned sources; choose D2 route (a) or (b); prove the `Delta_PRG`
  or `Adv_PRG` decomposition of the bound. Owner: unassigned (needs source
  read over Extra/c + BINBIND material) — first concrete probe S2.
- **B3 — game/implementation binding.** `verdict = Relation.Verify`,
  serialization (A3/A4), Verify-path bytes. Owner: BINBIND/FftBind lane
  (partial: FftBind semantics and byte machines exist).
- **B4 — statistical certificate.** `LocalJointCertificate S e` with a
  concrete public `S` and proven `e^cond` (D3). Machinery ready in the
  T12.1 chain: two-sided Cramer window (`windowSandwich`), twisted sector
  mass, A2 tower bounds (error 2^-48), `all_keys_delta_of_conv_cert`.
  Owner: this lane (run2/T12.1).
- **B5 — assembly.** Instantiate `ConcreteReduction` with B1-B4, state and
  prove `end_to_end_assembled_theorem_statement` (the declaration the audit
  found missing). Owner: this lane, after B1-B4.

### Cross-lane map and contracts (one ladder, separate execution)

Lanes keep separate working directories and never edit each other's files;
they meet **only** at this document and at named lemma contracts. Shared
target, independent execution.

- **source3 (Astra) = rung B1 — the critical path.** Contract B1 must
  deliver to B4/B5: (i) the key law bound to real execution (restart loop
  semantics), (ii) `P(success)` and the per-attempt failure structure from
  the `for(;;)` F/G loop (`falcon-keygen.c:6221`) and the solver loop
  (`:4015`), (iii) the source NTRU-equation bridge (their open item), (iv)
  emitted-byte ties. This lane's remaining work already points there.
- **BINBIND/FftBind = rung B3** (verdict/serialization/Verify-path bytes).
- **t5 (flat/reject) = B1/B4 support** — rejection/failure-rate statistics
  feeding `P(success)` and the sampler's law.
- **SOL 6.1 audit (T03, coordinator) = scope reconciliation.** Its findings
  are reconciled INTO this document; any contradiction with the target
  shape (Section 1) is an owner decision recorded here, not a silent edit.
- **this lane (run2/T12.1) = B4 + B5** (statistical certificate and
  assembly), plus S1-S3 groundwork.

### Relation to the original T12.1 math task (nothing dropped)

The end-to-end scope EXTENDS the math task; the EUF-CMA -> MT-ISIS
conditional lemma is its core, not a casualty. Mapping of the three
original goals:

- *kernel conditional lemma EUF-CMA -> MT-ISIS* — assembled in abstract
  form in `Run2/ConcreteReduction` (audit: no counterexample); what remains
  is exactly its instantiation B4/B5 (`S`, `e` for the real law);
- *full mathematical law of Sign* — the MT-side law (`Phi`, `AdvMT`) and
  the sampler law feeding B4 (partially built: block law, tails, delta
  chain);
- *public simulation* — the reduction construction (`Games`, `MgfProduct`,
  `FinalDelta`, partially built).

The target statement of Section 1 IS the EUF-CMA -> MT-ISIS bound made
real; without the bridge the lemma holds about an abstract sampler, and
without the lemma the bridge connects to nothing.

### Track coordination (owner decision 2026-09-30)

This lane's lead coordinates the end-to-end track: executor prompts (the
adapted B1 prompt lives in `run2/notes/PROMPT_KEYGEN_FIBER_B1_ADAPTED.md`),
rung contracts, SOL 6.1 audit reconciliation into this document, review
task preparation. Owner keeps modeling decisions, executor starts and
push signals. The legacy coordinator's tooling (`archive.py`, pin/receipt
mechanics) stays as tooling regardless of role. Formal retirement of the
legacy coordinator process is an owner edit in AGENTS/STATE (those files
carry foreign active changes and are not touched from this lane).

## 5. Ordered first steps

- **S1 — extract `p_accept`** (the per-attempt acceptance of the mandatory
  certificate — the D1-refined conditioning event) and the call-level
  availability `1-(1-p_accept)^cap` from the pinned sources (the `for(;;)`
  F/G loop `falcon-keygen.c:6221`, solver loop `:4015`, and the built-in
  FG_PROBE acceptance machinery as the measurement hint). Feeds D1
  accounting and B4's constant propagation.
- **S2 — identify the real PRG** (algorithm, seed width, consumed
  bit-length per key/signature) and decide D2 route (a)/(b) on the record.
- **S3 — pin the provenance of the `~1.27e-24` constant** and state the
  conditional chi-square lemma (`second` under conditioning, factor
  `1/P(success)`), kernel-side, as the first B4 rung.
- **S4 — reroute this lane's window** to S1-S3 + B4/B5. The certHi/certLo
  QQ numeric closure is **suspended** until the shape of `e` (D3
  accounting) is settled, so that margins are not polished for a parameter
  that may not be the bound's `e`.

## 6. Explicitly out of scope

- Timing, cache and fault side channels; hardware entropy quality beyond
  A2; multi-user/adaptive security beyond the single-instance game; any
  claim of "security" without the decomposition of Section 1.

## 7. Version-skew ledger (2026-09-30, owner catch: the M0 floor-CT skew)

- **The pinned M0 profile carries the PRE-FIX `fpr-emulated.h`**
  (`m0_source/fpr-emulated.h` sha256 `242a7027d854e1317a3382f198271c69d4
  0f4b34e80192ff896a42a65c83edfa` = the FLOOR_CT baseline header), while
  live `Extra/c` and the dudect RUN_002 campaign carry the CANDIDATE
  (`6b897d6c217ef25a322e3b5c3d9488b9d6b8d0e369a710d8fce2259f24e6d84f`).
  The delta is exactly `fpr_floor`'s final signed XOR-select replaced by an
  unsigned selection (FT1536_FPEMU_FLOOR_CT_RUN_001, PATCH.diff); the other
  16 source files are byte-identical.
- **Consequence for the value-level claims (B1-B5): none.** The patch is
  bit-preserving over ALL 2^64 raw words, kernel-proven
  (`formal/FloorWord.lean`: `FloorCT.candidate_bit_equivalence`,
  `FloorCT.all_word64_equivalence`) — key law, `p_accept`, NTRU equations,
  encodings and `e` are identical on both versions. REUSE this equivalence
  as the version bridge; do not re-prove value facts per version.
- **Consequence for leakage claims: version matters.** M0 has the
  operand-dependent floor; the fix + dudect RUN_002
  (NO_LEAKAGE_EVIDENCE_YET, exploratory, explicitly not a CT proof) are
  the CT-side evidence on the candidate. Side channels stay out of scope
  (A1); any timing-sensitive deployment must build the CANDIDATE bytes,
  and the bit-equivalence bridge carries this theorem over unchanged.
- This skew also vindicates the B1 rule "do not substitute live Extra/c
  for the pinned profile": `m0_source` differs from `Extra/c` in exactly
  this one file.
