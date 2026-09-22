# FREE Falcon — FT1536

FT1536 is an experimental full-ternary-secret signature research project
developed by **Niirmata**, continuing the historical **Falcon EXTRA / ternary**
implementation. This repository contains the implementation, source-bound
proof checkpoints, their evidence, and reproducible replay tools.

**New contributor or fresh model session:** [START_HERE](START_HERE.md).
The [current state](docs/onboarding/STATE.md), [theorem path and task register](docs/onboarding/ROADMAP.md),
[proof map](docs/onboarding/PROOF_MAP.md) and [handoff protocol](docs/onboarding/HANDOFF.md)
provide a compact entry point without loading the entire conversation history.

Maintainer's canonical local checkout: **`/home/footfalcon/free_falcon_sign`**,
on `main`. Builds, proof work and Git publication are performed from this
durable directory. Project checkouts and evidence are not stored in system
`/tmp`; [local storage provenance](provenance/FT1536_LOCAL_REPOSITORY.md)
records the consolidation and preservation of the earlier staged checkout.

## Active FT1536 build on `main`

**[Source: `Extra/c/`](Extra/c/) — the exact L_RHO + FLOOR_CT candidate used by
the newer H3 checkpoints, with FPEMU and adaptive CDF.**

```sh
make FT1536
make check-FT1536
```

CLI output: **`.build/FT1536/ft1536`**. Linux, GCC, GNU Make and Python 3.11+
are required. Every build verifies the
[17-file candidate manifest](provenance/ft1536-candidate.sha256), SHA-256
`56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985`.
See [active-build provenance](provenance/FT1536_ACTIVE_BUILD.md).

**Current status — 2026-09-21:** **L_RHO, the complete L_NTT pipeline and the
byte-level L_V verifier bridge are proved for the pinned corrected candidate
and its explicit C model.** M0 now defines the protocol/game/resource contract
and proves the STATIC capacity bound. **H3_ZERO_SCALAR proves the local
zero-aware floor/cast/residual interface**, using kernel and universal
analytical source proofs. **H3_ROOT_LDL certifies the source FFT/Gram and
subtractive LDL root** for the emitted-key domain. **H3_NODE3 extends this
to split_top and both first-level LDL3 branches**, with explicit real/imaginary
and error bounds. **H3_NODE2 certifies the first binary level** and adds
kernel-checked finite-word half semantics plus an upstream imaginary bound.
**H3_BINARY_TOWER certifies the remaining binary levels7–1 and twelve raw
recursive subtrees**, including defined terminating execution in the declared model.
**H3_RAW_ASSEMBLY composes the complete raw loader/tree prefix** through the
return of ffLDL_fft3, before stable leaf replacement and normalization.
**H3_STABLE_NORMALIZATION certifies the subsequent source widths and
normalization for emitted keys**, with a source-derived stable-gate bridge.
**H3_INITIAL_TARGETS certifies the actual target preparation before sampling**,
for every canonical challenge, with explicit source FFT and rounding bounds.
**H3_ORDERED_REACH proves a finite-prefix center bound for the first executed
right root branch. H3_LEFT_ROOT_CORRELATED_TRANSFER closes the left branch
and composes zero-aware NumericCenter for all active pre-floor points from
certified legal root/caller entries.** Source postprocessing is now defined
and mapped after actual sampling return, with source iFFT/rint and exact STATIC
bytes. Universal int16 value preservation, sampler law, whole Sign termination
and end-to-end security remain open research objectives.

**FPEMU audit — confirmed historical baseline issues:** numeric `fpr_lt(-0,+0)`
returns 1, and the older XOR floor selector compiled to an operand-dependent
branch under GCC14.2/-O, including in `sampler_large` and BerExp. The floor
selector is now replaced by the reviewed FLOOR_CT candidate; the generic
signed-zero comparison issue remains separately scoped. The
[independent audit review](proofs/ft1536/validation/2026-09-20-fpemu-audit/README.md)
records the exact scope; timing tools were **NOT_RUN in that frozen audit**.
The subsequent [official pinned dudect harness](tests/ft1536/dudect/README.md)
provides public scalar contrasts, controls, full raw records and an eight-hour
campaign controller. Its [short preflight](provenance/checks/2026-09-20-dudect-preflight/README.md)
includes arithmetic/domain checks and exact raw-statistics replay.
This shared-host scalar experiment does not establish an emitted-domain attack
or an end-to-end constant-time property; ctgrind remains unrun.

The [completed baseline campaign](proofs/ft1536/background/FPEMU_FLOOR_CT_2026-09-20/DUD/REPORT.md)
ran three rounds (36 target trials plus6 controls) in7h59m42s. All nine floor
probes detected a timing signal; the other27 trials had no leakage evidence.
All controls behaved as expected. The [selected raw-data recalculation](proofs/ft1536/background/FPEMU_FLOOR_CT_2026-09-20/DUD/RECEIPT_REVIEW.json)
reproduced every per-batch test state for9 floor probes and6 controls.
This is a scoped input projection, with an explicit external raw inventory.

**Validated floor candidate:** [FLOOR_CT](proofs/ft1536/stages/FT1536_FPEMU_FLOOR_CT_RUN_001/REPORT.md)
replaces the final selection with unsigned AND/OR, preserving all raw-word
results, including negative zero. The candidate passed source-model equivalence,
five compiled-region reviews and prespecified A/B (baseline9/9 signals,
candidate9/9 without detected signal; all controls passed).
[Independent review](proofs/ft1536/validation/2026-09-20-floor-ct/README.md)
reproduced **235/235 files,8 modules/41 theorems and all9771 A/B batches**.
The [candidate sources](proofs/ft1536/stages/FT1536_FPEMU_FLOOR_CT_RUN_001/candidate/source/)
have manifest `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985`.
This exact archived candidate is now integrated into the default Extra/c build.
[Integration provenance](provenance/FT1536_ACTIVE_BUILD.md) records the source
identity; its CT evidence remains scoped to the pinned build and exploratory
shared-host measurements.

The [H3_RAW_ASSEMBLY result](proofs/ft1536/stages/FT1536_H3_RAW_ASSEMBLY_RUN_001/REPORT.md)
establishes the complete raw prefix:6144 source basis words and18432 tree
words, with actual termination, source order, frame and an emitted corollary.
[Independent review](proofs/ft1536/validation/2026-09-20-raw-assembly/README.md)
reproduced195/195 files,33 modules and180 theorems (33 new).
Its analytical/kernel boundary is explicit. The [next-stage scope](proofs/ft1536/validation/2026-09-20-raw-assembly/NEXT_SCOPE.md)
separates stable computation/normalization from acceptance of the narrower
stable leaf gates, which need their source-bound emitted certificate.

The [STABLE_NORMALIZATION result](proofs/ft1536/stages/FT1536_H3_STABLE_NORMALIZATION_RUN_001/REPORT.md)
closes1536 actual stored widths, source sqrt54/div/scaling and preservation
of16896 internal L and6144 basis words for emitted keys. Squared stored widths
are in(1.7763,575.9999), paired squared widths in(2.3684,767.9999); the literal sigma-only
dss satisfies the final bank coefficient. [Independent review](proofs/ft1536/validation/2026-09-20-stable-normalization/README.md)
reproduced262/262 files and40 modules/230 theorems (50 new).
All-P_key computational definedness is proved separately; narrow gate
acceptance for all P_key remains open, without changing the key law.

The [INITIAL_TARGETS result](proofs/ft1536/stages/FT1536_H3_INITIAL_TARGETS_RUN_001/REPORT.md)
closes the do_sign prefix before ffSampling_fft3 for all canonical challenges.
It proves the FFT challenge error<1/8192, literal reciprocal/basis operations,
both target error layers and normalized-key preservation.
[Independent review](proofs/ft1536/validation/2026-09-20-initial-targets/README.md)
reproduced219/219 files,21 modules/129 theorems (30 new). The large frequency
t0 bound is recorded explicitly; scalar NumericCenter required the later ordered proof.

The [ORDERED_REACH result](proofs/ft1536/stages/FT1536_H3_ORDERED_REACH_RUN_001/REPORT.md)
is **PARTIAL_PROOF**: all1536 active positions of the first executed right
root branch have finite |mu|<=156276714, before each scalar floor/cast.
[Independent review](proofs/ft1536/validation/2026-09-20-ordered-reach/README.md)
reproduced225/225 files,28 modules/179 theorems (23 new), with explicit
normal/fault/nonreturn semantics and conditional memory frames. Its then-open
[LEFT_ROOT_CORRELATED_TRANSFER](proofs/ft1536/stages/FT1536_H3_ORDERED_REACH_RUN_001/NEXT_INTERFACE.md)
required a source-certified weighted residual/root-gain bridge and a closed
left-branch invariant. The failed loose-bound route is retained; it is not
a required-domain counterexample or a demonstrated C defect.

The [LEFT_ROOT_CORRELATED_TRANSFER result](proofs/ft1536/stages/FT1536_H3_LEFT_ROOT_CORRELATED_TRANSFER_RUN_001/REPORT.md)
closes that gap with source bank/A2 budgets, raw-L/stable-D metric factor<6,
right-residual reconstruction and actual root gain. It composes
**H3_ORDERED_NUMERIC_CENTER_PROVED_FOR_EMITTED_PINNED_MODEL**:
finite **|mu|<=937866518**, margins1209616765/1209616764, including raw negative zero.
[Independent review](proofs/ft1536/validation/2026-09-21-left-root-transfer/README.md)
reproduced228/228 files,31 modules/206 theorems (27 new), native/sanitizer controls,
700 terminal/bank cases and19968 local metric checks. The universal argument
is explicitly mixed analytical/kernel. Historical ORDERED retains PARTIAL_PROOF.

The [next interfaces](proofs/ft1536/stages/FT1536_H3_LEFT_ROOT_CORRELATED_TRANSFER_RUN_001/NEXT_INTERFACE.md)
are **SOURCE_POSTPROCESSING_AND_PRECAST** and **SOURCE_SAMPLER_LAW**: actual
basis products/iFFT/rint/narrowing/bytes, followed separately by source joint law
and its losses. Conditional caller frames do not establish whole Sign totality.

The [SOURCE_POSTPROCESSING_AND_PRECAST result](proofs/ft1536/stages/FT1536_H3_SOURCE_POSTPROCESSING_AND_PRECAST_RUN_001/REPORT.md)
is **PARTIAL_PROOF**, with operational subclaim
**H3_SOURCE_POSTPROCESSING_DEFINED_FOR_EMITTED_PINNED_MODEL**.
[Independent review](proofs/ft1536/validation/2026-09-21-postprocessing/README.md)
reproduced616/616 files,102 modules/795 theorems (32 new),59 native cases per
normal/sanitizer build,32224 rint words and all65536 signed16 codec values.
Source iFFT error<=1/128 and |rint result|<=4572095 establish the actual
operational map, including narrowing and STATIC bytes. Universal Safe16 remains
open; the local65536→0 witness has no emitted-history membership.
The next interface is [SOURCE_SAMPLER_LAW/H6P](proofs/ft1536/stages/FT1536_H3_SOURCE_POSTPROCESSING_AND_PRECAST_RUN_001/NEXT_INTERFACE.md),
with joint BadPrecast and a separate reference-integer/Sign→Verify bridge.

The [SCALAR_KERNEL_IID result](proofs/ft1536/stages/FT1536_H3_SCALAR_KERNEL_IID_RUN_001/REPORT.md)
proves the exact scalar CDF/BerExp/rejection law **in the explicit IID_BUFFER
game**, with A>=1/256, returned PMF w_y/A, conditional fresh tail and
Pr[N>m|PAST]<=(255/256)^m. [Independent review](proofs/ft1536/validation/2026-09-21-scalar-kernel-iid/README.md)
reproduced364/364 files,32 modules/208 theorems (37 new),4096 buffer positions
and54 exact PMFs; the initial tool-startup timeout is retained. Gaussian comparison
is now provided below; the real-PRNG bridge and joint BadPrecast remain open.

The [SCALAR_GAUSSIAN_COMPARISON result](proofs/ft1536/stages/FT1536_H3_SCALAR_GAUSSIAN_COMPARISON_RUN_001/REPORT.md)
establishes **TV(K_C,G)<=2^-36 and chi2(K_C||G)<=2^-60 in IID_BUFFER**, for the
untruncated scalar Gaussian with actual input-word mean and variance.
Reverse chi2(G||K_C) is infinite because of the support gap.
[Independent review](proofs/ft1536/validation/2026-09-21-scalar-gaussian/README.md)
reproduced516/516 files,36 modules/234 theorems (26 new), with source-domain,
normalizer and tail certificates.63 nominal remainder overruns and scoped
countermodels are retained. Its adaptive ordered composition is provided below;
local bounds alone do not establish joint BadPrecast or real-PRNG security.

The [ORDERED_JOINT_KERNEL result](proofs/ft1536/stages/FT1536_H3_ORDERED_JOINT_KERNEL_RUN_001/REPORT.md)
proves the actual3072-call adaptive root law **in IID_BUFFER**, positive-prefix
source closure, a.s. root return and resource bounds. Its explicit Q_S/Q_stop
references satisfy **TV(P,Q)<=2^-25, chi2(P||Q)<2^-48**, with support exit<2^-50.
[Independent review](proofs/ft1536/validation/2026-09-22-ordered-joint/README.md)
reproduced359/359 files,114 modules/884 theorems (37 new), native/sanitizer
controls and exact adaptive-tree checks. Local support conditioning differs
from whole-call survival conditioning; reverse chi2 against Q_stop is infinite.
The deterministic POST pushforward yields a typed [H6P event transfer](proofs/ft1536/stages/FT1536_H3_ORDERED_JOINT_KERNEL_RUN_001/H6P_INTERFACE.md).
Its reference joint BadPrecast probability now has the upper bound reported
in H6P below; the real-PRNG bridge and retry/whole-Sign composition remain separate obligations.

The [H6P_REFERENCE_BAD_EVENT result](proofs/ft1536/stages/FT1536_H6P_REFERENCE_BAD_EVENT_RUN_001/REPORT.md)
proves **Q_S(BadPrecast)<=2^-119 and P_IID(BadPrecast)<=2^-84 for ONE ROOT**,
uniformly over required entries and legal past histories, for both pre-narrow
vectors. Source variance proxy<5462457, full rounding error<1095, discrete
normalizers, adaptive MGF and rint ties are explicitly accounted for.
[Independent review](proofs/ft1536/validation/2026-09-22-h6p-reference-bad-event/README.md)
reproduced197/197 files in73.819s,48 modules/327 theorems (26 new), with a
separate rational/RBF768 verification of the final bounds. The next obligation
is **IID_RETRY_COMPOSITION**; small one-root probability does not establish
universal Safe16, real-PRNG security, integer recovery or Sign→Verify.

**IID_RETRY_COMPOSITION: frozen handoff awaiting independent review.**
The author reports a region bound<=2^-80 and492/492 replay matches. These are
unverified handoff claims, not an accepted checkpoint. The
[review prompt and pinned handoff](proofs/ft1536/CURRENT_REVIEW_TASK.md)
are ready for another model selected by the owner. [CURRENT_TASK](proofs/ft1536/CURRENT_TASK.md)
retains the task/input pins; the completed worker must not be restarted.

The separate [FT family scaling research by MiMo](proofs/ft1536/stages/FT_FAMILY_SCALING_REVIEW_RUN_001/README.md)
is preserved with its [PDF manuscript](proofs/ft1536/stages/FT_FAMILY_SCALING_REVIEW_RUN_001/paper/main.pdf),
Lean sources, scripts and results. [Independent review](proofs/ft1536/stages/FT_FAMILY_SCALING_REVIEW_RUN_001/REPORT.md)
confirmed4 Lean modules/14 named theorems,5 reproduced JSON/CSV files and12
FFT-port cases, while identifying corrections to attack-game/reduction definitions
and claim consistency. Status: **RESEARCH_REVIEW_CHANGES_REQUIRED**; this is
research evidence for planned FT768/FT3072, not their implementation or security certification.

The [owner-run MiMo proof task](proofs/ft1536/CURRENT_MIMO_TASK.md) addresses
T03: one-root reference integer recovery, with pinned inputs and explicit
PROVED/PARTIAL criteria. It is separate from Astra's active retry task and
from the still-required Family corrections.

The [historical deferred preparation](provenance/checks/2026-09-20-dudect-floor-ct-ready/README.md)
is retained. The [current floor-ct launcher](tests/ft1536/dudect/README.md)
supports the owner's **ten-hour RUN_002** budget, with fresh controls before
service launch and matching controller/systemd limits. Actual campaign status
is recorded by RUN/RESULT in its local work directory. The [ten-hour preparation](provenance/checks/2026-09-22-dudect-ten-hour-preparation/README.md)
requires87.3125GiB free for complete logs and reserve. The prepared RUN_002
now uses the [NVMe data volume](provenance/FT1536_DATA_STORAGE.md), with about219.6GiB
free at setup, through its canonical work-directory alias. The current plan
is a manual morning start before the owner leaves for work, after his signal;
the [refreshed morning preparation](provenance/checks/2026-09-22-dudect-morning-preparation/README.md)
retains the ten-hour budget and awaits physical preflight.

The current build integrates the corrected verifier, SHA-256
`3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42`.
The original S17 remains a hash-pinned historical reference with its recorded
counterexample. Historical checkpoint flags describe their execution-time
state; the subsequent source integration is recorded separately.

Start here:
- **[Research paper / specification — Draft 0.2 (PDF)](docs/paper/FT1536_specyfikacja_v0.2.pdf)** — [snapshot and provenance](docs/paper/README.md); covers the frozen post-M0 state.
- **[Frozen post-M0 research state: full proof map, decisions and next obligations](proofs/ft1536/stages/FT1536_POST_M0_FREEZE_RUN_001/REPORT.md)**
- [Proof archive and latest results](proofs/ft1536/README.md)
- [FT768/FT1536/FT3072 scaling study and review](proofs/ft1536/stages/FT_FAMILY_SCALING_REVIEW_RUN_001/README.md)
- [Detailed post-L_V roadmap and T2C3/T5 dependency map](proofs/ft1536/documents/FT1536_MAPA_DALSZYCH_DZIALAN_PO_LV_2026-09-19.md)
- [M0 protocol and security game](proofs/ft1536/stages/FT1536_M0_CONTRACT_RUN_001/GAME.md)
- [M0 capacity proof](proofs/ft1536/stages/FT1536_M0_CONTRACT_RUN_001/CAPACITY.md)

## Build details

The source path remains **`Extra/c/`**. **FT1536** names the selected build/profile.

Outputs:

```text
.build/FT1536/ft1536       signature CLI, retaining the historical command syntax
.build/FT1536/test_falcon historical test executable
.build/FT1536/latest.json build/check receipt and paths to full logs
```

Each build verifies all 17 source hashes, copies those exact sources into a
fresh out-of-tree build directory, and uses the pinned Makefile profile with
explicit C99. The receipt records compiler details, flags and binary hashes.
The source files in `Extra/c` are not edited by the build.

`check-FT1536` runs finite FPEMU arithmetic checks, the CLI usage path, and
the known public verifier regression. It does not run KeyGen or read private
key material. The larger historical `test_falcon` program is built separately;
its full key-generation/signing benchmark is not part of this focused check.

The recorded proof model is **GCC 14.2.0 / C99 / Linux x86_64 LP64**.
Builds with a different toolchain are recorded as such and do not automatically
inherit the source-bound proof results.
The [active-candidate integration check](provenance/checks/2026-09-19-candidate/README.md)
preserves the executed commands, results and full build/check streams.

## Source identity and historical correction

The current `Extra/c` is the **exact 17-file L_RHO + FLOOR_CT candidate**, selected as
the working build on `main`. Its authoritative file list is
[`provenance/ft1536-candidate.sha256`](provenance/ft1536-candidate.sha256).
The prior [S17 baseline and its integration history](provenance/FT1536_S17.md)
remain available with their original manifest.

| Research-profile property | Value |
|---|---|
| Degree / modulus | `N=1536`, `q=18433` |
| Ring polynomial | `X^1536-X^768+1` |
| API parameters | `logn=10`, `ternary=1` |
| Secret profile | full ternary secret; raw proposal coefficients in `{-1,0,1}` |
| Arithmetic backend | integer-emulated FPR / FPEMU |
| Honest signature encoding | `FALCON_COMP_STATIC` |
| Squared-norm bound | `B=2093922385`, strict comparison `<B` |
| KeyGen/sign attempt limits | `3000000` / `16` |

Successful keys are conditioned on the actual KeyGen checks. The proof
statements identify their own exact distributions, domains and source versions.

The original S17 accepted a public synthetic witness for which the fixed
extractor `Ext0` was not short. **The current build incorporates L_RHO and
rejects that witness**, with canonical preNTT0=16866 and exact norm43058711057.
This finite regression checks the corrected behavior; the universal result
is supplied by the source-bound L_V proof, within its declared model.

The verifier correction relative to S17 is in `falcon-vrfy.c`:
[snapshot](proofs/ft1536/stages/FT1536_L_RHO_RUN_001/candidate/),
[exact patch](proofs/ft1536/stages/FT1536_L_RHO_RUN_001/candidate.patch).
The subsequent [FLOOR_CT patch](proofs/ft1536/stages/FT1536_FPEMU_FLOOR_CT_RUN_001/PATCH.diff)
changes only the floor body in `fpr-emulated.h`; all other15 source files remain
identical to S17. Earlier proof snapshots preserve their own source versions.

| Version / interface | Current role |
|---|---|
| `Extra/c`, L_RHO + FLOOR_CT manifest `56974571…` | **Active/default build on main**, identical to the candidate used by newer H3 checkpoints |
| Archived L_RHO manifest `2553358f…` | Previous default and preserved dudect baseline; source of L_NTT/L_V/M0 before explicit transport |
| Historical S17, manifest `03eaa0dd…` | Reference snapshot in the archive and Git history; recorded counterexample to Ext0 shortness |
| M0 `r40-static4096-parametric-v1` | Defined caller/game contract; its protocol wrapper is not integrated |

The historical CLI still has a 2049-byte signing buffer and accepts external
nonces of variable length. M0 selects a 4096-byte honest payload buffer and
requires exactly 40 nonce bytes. Those caller requirements are explicit
integration work; changing their description does not change the old CLI.

## Proof progress

| Checkpoint | Established scope | Status |
|---|---|---|
| [L_V-STATIC](proofs/ft1536/stages/FT1536_LV_STATIC_RUN_001/REPORT.md) | Counterexample to shortness for the fixed `Ext0` on original S17 | `COUNTEREXAMPLE_REQUIRED_DOMAIN` |
| [Independent Blue review](proofs/ft1536/stages/FT1536_LV_STATIC_ODBIOR_BLUE_001/DAYBREAK_REVIEW.md) | Independently checked counterexample and its stated limits | `CONFIRMED_COUNTEREXAMPLE_REQUIRED_DOMAIN` |
| [L_RHO](proofs/ft1536/stages/FT1536_L_RHO_RUN_001/REPORT.md) | Canonical normalization for every signed int16 in the pinned candidate/model | `L_RHO_PROVED_FOR_PINNED_MODEL` |
| [L_NTT](proofs/ft1536/stages/FT1536_L_NTT_RUN_001/REPORT.md) | Word contracts, dynamic tables, local blocks and conditional composition | `PARTIAL_PROOF` |
| [L_NTT_GLOBAL](proofs/ft1536/stages/FT1536_L_NTT_GLOBAL_RUN_001/REPORT.md) | In-place prefix/frame reasoning, canonical ranges, global inverse and lifted inverse interface | `PARTIAL_PROOF` |
| [L_NTT_FORWARD](proofs/ft1536/stages/FT1536_L_NTT_FORWARD_RUN_001/REPORT.md) | Global evaluation in physical order, coefficient product, full NTT composition and rho substitution | `L_NTT_PROVED_FOR_PINNED_MODEL` |
| [L_V_BRIDGE](proofs/ft1536/stages/FT1536_L_V_BRIDGE_RUN_001/REPORT.md) | Both byte decoders, loader/guards, centering, exact norm and extraction from every accepted payload in the declared domain | `L_V_PROVED_FOR_PINNED_MODEL` |
| [M0](proofs/ft1536/stages/FT1536_M0_CONTRACT_RUN_001/REPORT.md) | Protocol/game contract, resource ledger, framing and STATIC capacity | `M0_CONTRACT_DEFINED_FOR_PINNED_CANDIDATE` |
| [H3_RANGE](proofs/ft1536/stages/FT1536_H3_RANGE_RUN_001/REPORT.md) | Local floor/proposal/residual proofs, source-order controls and explicit signed-zero/underflow diagnostics; global reachability open | `PARTIAL_PROOF` |
| [H3_ZERO_SCALAR](proofs/ft1536/stages/FT1536_H3_ZERO_SCALAR_RUN_001/REPORT.md) | All NumericCenter words, including both zeros/subnormals: floor/cast/s+z, exact of, source sub error and residual bound; mixed kernel/analytical proof | `H3_ZERO_SCALAR_PROVED_FOR_PINNED_MODEL` |
| [H3_ROOT_LDL](proofs/ft1536/stages/FT1536_H3_ROOT_LDL_RUN_001/REPORT.md) | Emitted-key FFT/Gram and actual subtractive LDL root, positive real divisor/pivot, multiplier/error bounds and conditional frame; mixed proof | `H3_ROOT_LDL_PROVED_FOR_PINNED_MODEL` |
| [H3_NODE3](proofs/ft1536/stages/FT1536_H3_NODE3_RUN_001/REPORT.md) | Uniform split_top/Adj/LDL3 certificate for both root branches and all 256 slots each; positive pivots, multipliers, real/imaginary errors and frame; mixed proof | `H3_NODE3_PROVED_FOR_PINNED_MODEL` |
| [H3_NODE2](proofs/ft1536/stages/FT1536_H3_NODE2_RUN_001/REPORT.md) | First split_deep9/LDL8 level, all 2×3×128 positions; finite-word half proof, refined imaginary envelope and positive pivots; mixed proof | `H3_NODE2_PROVED_FOR_PINNED_MODEL` |
| [H3_BINARY_TOWER](proofs/ft1536/stages/FT1536_H3_BINARY_TOWER_RUN_001/REPORT.md) | All remaining levels7–1, uniform numerical invariant and actual terminating execution of12 raw inner7 subtrees; mixed proof | `H3_BINARY_TOWER_PROVED_FOR_PINNED_MODEL` |
| [FPEMU audit](proofs/ft1536/stages/FT1536_FPEMU_AUDIT_RUN_001/REPORT.md) | Generic numeric comparison of signed zeros and operand-dependent compiled floor branch; finite arithmetic/sanitizer audit, no timing measurements | `CONFIRMED_ISSUE` |
| [FLOOR_CT candidate](proofs/ft1536/stages/FT1536_FPEMU_FLOOR_CT_RUN_001/REPORT.md) | All-word bit-preserving floor replacement, pinned machine-code review and exploratory A/B; archived candidate, separate source integration | `FLOOR_CT_CANDIDATE_VALIDATED_FOR_PINNED_BUILD` |
| [H3_RAW_ASSEMBLY](proofs/ft1536/stages/FT1536_H3_RAW_ASSEMBLY_RUN_001/REPORT.md) | Complete raw loader/tree prefix, actual source composition and emitted corollary; mixed proof on the archived floor candidate | `H3_RAW_ASSEMBLY_PROVED_FOR_PINNED_MODEL` |
| [H3_STABLE_NORMALIZATION](proofs/ft1536/stages/FT1536_H3_STABLE_NORMALIZATION_RUN_001/REPORT.md) | Emitted stable-gate bridge, actual normalized widths, sqrt/div/scaling and preserved basis/internal L; mixed proof | `H3_STABLE_NORMALIZATION_PROVED_FOR_EMITTED_PINNED_MODEL` |
| [H3_INITIAL_TARGETS](proofs/ft1536/stages/FT1536_H3_INITIAL_TARGETS_RUN_001/REPORT.md) | Actual target prefix for all canonical challenges, source FFT/reciprocal/basis errors and key frame; mixed proof | `H3_INITIAL_TARGETS_PROVED_FOR_EMITTED_PINNED_MODEL` |
| [H3_ORDERED_REACH](proofs/ft1536/stages/FT1536_H3_ORDERED_REACH_RUN_001/REPORT.md) | Right-root finite-prefix NumericCenter, scalar outcome separation and conditional frames; left correlated transfer open; mixed proof | `PARTIAL_PROOF` |
| [H3_LEFT_ROOT_CORRELATED_TRANSFER](proofs/ft1536/stages/FT1536_H3_LEFT_ROOT_CORRELATED_TRANSFER_RUN_001/REPORT.md) | Source bank/A2/metric/root transfer and closed left invariant; composes full zero-aware root/caller finite-prefix NumericCenter; mixed proof | `H3_LEFT_ROOT_CORRELATED_TRANSFER_PROVED_FOR_EMITTED_PINNED_MODEL` |
| [SOURCE_POSTPROCESSING_AND_PRECAST](proofs/ft1536/stages/FT1536_H3_SOURCE_POSTPROCESSING_AND_PRECAST_RUN_001/REPORT.md) | Defined post-return suffix, source iFFT/rint, exact narrowing/norm/STATIC bytes; universal Safe16 open | `PARTIAL_PROOF` |
| [SCALAR_KERNEL_IID](proofs/ft1536/stages/FT1536_H3_SCALAR_KERNEL_IID_RUN_001/REPORT.md) | Exact conditional scalar law, A>=1/256, IID termination/tail and buffer/resource interface; real-PRNG bridge open | `H3_SCALAR_KERNEL_PROVED_FOR_PINNED_IID_BUFFER_MODEL` |
| [SCALAR_GAUSSIAN_COMPARISON](proofs/ft1536/stages/FT1536_H3_SCALAR_GAUSSIAN_COMPARISON_RUN_001/REPORT.md) | Uniform local TV/forward chi-square bounds to untruncated Gaussian in IID_BUFFER; reverse chi-square infinite; ordered composition below | `H3_SCALAR_GAUSSIAN_COMPARISON_BOUND_PROVED_FOR_PINNED_IID_BUFFER_MODEL` |
| [ORDERED_JOINT_KERNEL](proofs/ft1536/stages/FT1536_H3_ORDERED_JOINT_KERNEL_RUN_001/REPORT.md) | Exact adaptive root law, source closure, directed joint comparison, resources and POST event transfer in IID_BUFFER; reference BadPrecast probability open | `H3_ORDERED_JOINT_KERNEL_PROVED_FOR_PINNED_IID_BUFFER_MODEL` |
| [H6P_REFERENCE_BAD_EVENT](proofs/ft1536/stages/FT1536_H6P_REFERENCE_BAD_EVENT_RUN_001/REPORT.md) | Source-instantiated joint tail for both pre-narrow vectors: Q_S<=2^-119, one-root IID<=2^-84; retry and real-PRNG bridge separate | `H6P_REFERENCE_BAD_EVENT_BOUND_PROVED_FOR_PINNED_IID_BUFFER_MODEL` |

The completed L_V bridge establishes, for all canonical h,c and legal finite
payloads b in the pinned GCC14.2.0/C99/Linux x86_64 LP64 model:

```text
V_CAND(h,c,b)=1 =>
  Ext0(h,c,b)=(z1,z2) is defined,
  z1+h*z2=c modulo(q,Phi),
  Q(z1,z2)<2093922385.
```

This includes NONE and STATIC, signed narrowing and finite unary-counter wrap.
The adversary is not limited to the honest signing buffer. The source/model
binding and legal memory/API conditions are part of the claim; a verified
C compiler is not claimed.

Independent archive replays reproduced **217/217** semantic files for full
L_NTT, **402/402** for L_V and **273/273** for M0. L_V checks 73 modules and
570 theorems (104 new); M0 checks its selected dependency closure of 67 modules
and 535 theorems (43 new). These counts include reused results and are not
additive totals of distinct project theorems.

### M0: protocol and capacity

- One shared key from the actual seed-expanded KeyGen law conditioned on
  successful completion of the whole call.
- Classical ordinary EUF-CMA in direct-output ROM, with observable aborts.
- Exactly 40 nonce bytes; variable-length honest STATIC payload, capacity 4096.
- Parametric resources `Q_s,Q_H,t,w,L`; no concrete security level selected.
- **After defined source norm acceptance, STATIC payload <=3160 bytes**, header
  included and nonce excluded. A public synthetic short vector needs 3156 bytes;
  actual C controls show that 2049 and 3073 fail while 4096 passes round-trip
  and canary checks, including ASan/UBSan.

M0 is a completed contract with limited mathematical results, not a completed
security reduction. Its [22-row ledger](proofs/ft1536/stages/FT1536_M0_CONTRACT_RUN_001/HOP_LEDGER.md)
records the remaining assumptions and proof obligations.

### Preserved T2C3 and T5 results

| Historical result | Scope |
|---|---|
| T2C3: `E_h*^Q < 2^-89` | One canonical key; ideal image after the strict norm cutoff |
| T5: pure graph-dual theta `<2^-40` | Every successful output of the specified KeyGen; untruncated theorem, with its own `delta_key=0` |

The [continuity audit](proofs/ft1536/documents/FT1536_AUDYT_CIAGLOSCI_KLUCZA_BAZY_T2C3_2026-09-17.md),
[later D11E2 review](proofs/ft1536/documents/FT1536_WERYFIKACJA_UZASADNIENIA_D11E2_2026-09-17.md)
and [T2C3/T5 proof map](proofs/ft1536/documents/FT1536_PAPER_TEZA_MAPA_DOWODOW_2026-09-17.md)
show their dependency paths and exact scopes. The current population sharp-tail
R5T argument is a separate conditional result requiring a consistent new
package and final consumption. T5 alone does not supply that truncated bound.

### H3 progression and next mathematical frontier

The [H3 interface](proofs/ft1536/stages/FT1536_M0_CONTRACT_RUN_001/H3_INTERFACE.md)
targets center reachability before `fpr_floor -> int` and `s+z` for emitted
keys and reachable signing histories. The roadmap then connects the complete
source signing law, pre-cast/byte/retry behavior, R5T, public simulation and ROM
composition. The zero-aware root/caller finite-prefix goal is now composed
by LEFT_ROOT; source postprocessing/pre-cast and source sampler law are the
next interfaces. The checkpoints below preserve their historical scopes.
The [H3_RANGE partial result](proofs/ft1536/stages/FT1536_H3_RANGE_RUN_001/REPORT.md)
has an independent **96/96-file replay, 8 Lean modules and 49 new theorems**.
It establishes local proposal support and conditional floor/residual interfaces.
The actual backend gives `fpr_floor(-0)=-1`; this breaks mathematical-floor
equality but does not by itself overflow `s+z`. Synthetic underflow diagnostics
also rule out an unrestricted IEEE error model. Their reachability from emitted
keys has not been established. That historical package's global obligation is
`Reach_call_C(...) -> CenterClass(mu)`, including internal LDL and machine-error
bounds; see the [ledger](proofs/ft1536/stages/FT1536_H3_RANGE_RUN_001/BOUND_LEDGER.md).

The subsequent [H3_ZERO_SCALAR result](proofs/ft1536/stages/FT1536_H3_ZERO_SCALAR_RUN_001/REPORT.md)
closes the local interface for every finite word with
`-2147483283 <= val(x) < 2147483282`, including both zeros and subnormals.
It proves `s_C=floor(val(x))-eps0(x)`, exact integer conversions, safe `s_C+z`,
and concrete source-subtraction errors `E_r=E_res=2^-20`.
The machine residual is bounded by `366+2^-20`; r/delta lie in [0,1].
Full source-add error composition and r/delta case analysis are analytical,
supported by kernel lemmas, with this distinction explicit in the
[independent review](proofs/ft1536/validation/2026-09-19-zero-scalar/README.md).
Replay reproduced **95/95 files, 17 Lean modules and 97 theorems (48 new)**.
Its exported goal `Reach_call_C(...) -> NumericCenter(mu)` is now established
for certified legal root/caller finite prefixes by LEFT_ROOT; sampler-law
consumption remains a separate obligation.

The [H3_ROOT_LDL result](proofs/ft1536/stages/FT1536_H3_ROOT_LDL_RUN_001/REPORT.md)
now establishes a uniform source-bound certificate for key FFTs, root Gram
inputs and the actual subtractive 2x2 LDL root over the emitted-key domain.
In particular, `1/2 <= g00_C < 2^23`, `|L_C| < 2^25`,
`32 < Re(D_C) < 2^31` and `|Im(D_C)| < 32`.
Positivity uses the correlated determinant of the computed FFT Gram with
explicit rounding errors. The frame statement applies to defined prefixes
reaching the root call; it does not establish the entire earlier subtree.
[Independent review](proofs/ft1536/validation/2026-09-19-root-ldl/README.md)
reproduced **131/131 files, 17 modules and 99 theorems (17 new)**, preserving
the mixed analytical/kernel scope. The next interface is
[split_top to LDL_dim3](proofs/ft1536/stages/FT1536_H3_ROOT_LDL_RUN_001/NEXT_INTERFACE.md)
for both branches, followed by the lower tree and ordered center reachability.

The [H3_NODE3 result](proofs/ft1536/stages/FT1536_H3_NODE3_RUN_001/REPORT.md)
now closes `split_top -> Adj -> LDL_dim3` on both root branches and all 256
physical frequencies each. Its single rational c3 gives positive real pivot
lower bounds 1/8 and 8, multiplier norms `|L10|,|L20|<2`, `|L21|<4`,
separate imaginary/error bounds and a proved div domain `[1/16,2^35]`.
The [independent review](proofs/ft1536/validation/2026-09-19-node3/README.md)
reproduced **123/123 files, 21 modules and 115 theorems (16 new)**.
Full source composition remains explicitly analytical/kernel mixed.
The [next interface](proofs/ft1536/stages/FT1536_H3_NODE3_RUN_001/NEXT_INTERFACE.md)
is the first split_deep/Adj/LDL2 level for six diagonal branches, with 128
frequencies each; the lower tree and global Reach remain separate obligations.

The [H3_NODE2 result](proofs/ft1536/stages/FT1536_H3_NODE2_RUN_001/REPORT.md)
closes the first `split_deep(logn9) -> Adj -> LDL_dim2(logn8)` level for
all six groups and 128 frequencies each. New results include
`|Im(D_ROOT_C)|<1`, a kernel-checked `fpr_half` value error `<=2^-1023`
for every finite word, and positive computed pivot lower bounds 1/32 and 2.
The [independent review](proofs/ft1536/validation/2026-09-19-node2/README.md)
reproduced **160/160 files, 26 modules and 131 theorems (16 new)**.
The remaining [binary recursion interface](proofs/ft1536/stages/FT1536_H3_NODE2_RUN_001/NEXT_INTERFACE.md)
starts at split8/LDL7; a local isolated slice is distinct from total execution
of its earlier recursive calls.

The [H3_BINARY_TOWER result](proofs/ft1536/stages/FT1536_H3_BINARY_TOWER_RUN_001/REPORT.md)
closes both layers for all remaining levels7–1: 1524 nodes and 768 complex
positions per level, plus the actual defined terminating execution of12 raw
inner7 subtrees. It establishes 10752 internal L words and1536 raw leaves,
with stronger INIT bounds and a source transfer using the loss I²/m.
[Independent review](proofs/ft1536/validation/2026-09-20-binary-tower/README.md)
reproduced **175/175 files, 30 modules and147 theorems (16 new)**.
The [next mathematical interface](proofs/ft1536/stages/FT1536_H3_BINARY_TOWER_RUN_001/NEXT_INTERFACE.md)
is full raw-loader/tree assembly, followed separately by stable leaf
replacement/normalization, initial targets and ordered Reach.

### Remaining obligations beyond the verifier

- **C-to-model correspondence:** the certificates concern explicit models
  and pinned source translations. Independent review must also examine
  conversions, ranges, evaluation order and buffer assumptions. A clean
  Lean axiom list alone does not establish this correspondence or formalize GCC.
- **Complete EUF-CMA argument:** source-to-ideal sampler correspondence,
  observable aborts, simulation and MT-ISIS hardness for the correct key
  distribution remain separate obligations after verifier soundness.
- **Concrete reduction quality:** the earlier linear TV route is conservative.
  A conditional chi-square comparison of full response kernels can instead use
  `Delta=(1+e)^n-1` and a direct success-event bound. With hypothetical
  `e=2^-106`, `n=2^20` and simulated success `<=2^-128`, this comparison gives
  roughly `2^-86`, versus the linear TV contribution `2^-34`. This is a
  conditional comparison of one hop, not 52 recovered bits of whole-scheme
  security. Kernel identity, metric direction, other losses and resource
  bounds must be proved for the actual games.

The [M0 target type](proofs/ft1536/stages/FT1536_M0_CONTRACT_RUN_001/TARGET_TYPE.md)
and [current roadmap](proofs/ft1536/documents/FT1536_MAPA_DALSZYCH_DZIALAN_PO_LV_2026-09-19.md)
state the required direction and dependencies. The earlier
[proof-target document](proofs/ft1536/documents/FT1536_CEL_DOWODU_I_PIERWSZY_LEMAT_2026-09-17.md)
is preserved as dated history; its then-open L_V is now resolved for the
corrected candidate, and its TV table is not a construction-security barrier.

## FPEMU

The baseline includes `Extra/c/fpr-emulated.c` and `fpr-emulated.h`: an
integer-emulated FPR backend with the FT1536/ternary FFT3 adaptations,
constants and associated routines. The arithmetic core is adapted from
Falcon Round3 FPEMU, as described in the source headers.

The Makefile selects `FPR_IMPL="fpr-emulated.h"` and links `fpr-emulated.o`.
These exact files are also preserved in the proof snapshots. Their presence
and finite arithmetic checks are distinct from a complete proof of the
FPEMU/FFT/sampler path; the current NTT work concerns modular integer arithmetic.

The [completed FPEMU audit](proofs/ft1536/stages/FT1536_FPEMU_AUDIT_RUN_001/REPORT.md)
has an independent **29/29-file replay**, including 140225 scalar and 250
actual-delta cases per normal/ASan+UBSan mode, 29 historical Lean modules,
and original-TU assembly reconstruction. It confirms the signed-zero
comparison issue and the data-dependent floor branch described above.
No counterexample to the tested ZERO/ROOT/NODE3 numerical contracts was
found; finite coverage is not a proof of the entire backend.

The [current impact assessment](proofs/ft1536/validation/2026-09-20-fpemu-audit/CURRENT_IMPACT.md)
maps these findings to the later NODE2 result and BINARY_TOWER assignment.
The latter retains its arithmetic/domain obligations; CT review and a
controlled, version-pinned timing campaign are separate next steps.
The audit's [timing review](proofs/ft1536/stages/FT1536_FPEMU_AUDIT_RUN_001/TIMING_REVIEW.md)
records **NOT_RUN** for dudect/ctgrind and gives a follow-up measurement protocol.

## Verify and replay the evidence

Archive integrity and tooling tests:

```sh
python3 -B proofs/ft1536/tools/archive.py verify
python3 -B -m unittest discover -s proofs/ft1536/tests -v
```

Example full replay in a fresh working copy:

```sh
python3 -B proofs/ft1536/tools/archive.py replay FT1536_M0_CONTRACT_RUN_001 --run local-001 --timeout 1200 --hide-originals
```

Full replay requires the recorded Linux/GCC/Sage/Lean environment and paths;
see the [proof workflow and toolchain requirements](proofs/ft1536/README.md).
The archive contains the declared public inputs, rather than requiring the
original research directories or USB disk for verification.

[Repository replay validation](proofs/ft1536/validation/2026-09-18/README.md)
reproduced 10, 64, 98 and 103 semantic files for the four executable checkpoints
from a clean Git checkout with the original Dokumenty/H directories hidden.
Replaying a partial proof preserves its partial status.

Later maintainer replays and their exact scopes:
[full L_NTT](proofs/ft1536/validation/2026-09-18-forward/README.md),
[L_V](proofs/ft1536/validation/2026-09-19-lv/README.md),
[M0](proofs/ft1536/validation/2026-09-19-m0/README.md),
[H3 partial](proofs/ft1536/validation/2026-09-19-h3/README.md),
[H3 zero-aware scalar](proofs/ft1536/validation/2026-09-19-zero-scalar/README.md),
[H3 root LDL](proofs/ft1536/validation/2026-09-19-root-ldl/README.md),
[H3 NODE3](proofs/ft1536/validation/2026-09-19-node3/README.md),
[H3 NODE2](proofs/ft1536/validation/2026-09-19-node2/README.md),
[FPEMU audit](proofs/ft1536/validation/2026-09-20-fpemu-audit/README.md),
[BINARY_TOWER](proofs/ft1536/validation/2026-09-20-binary-tower/README.md),
[FLOOR_CT](proofs/ft1536/validation/2026-09-20-floor-ct/README.md),
[RAW_ASSEMBLY](proofs/ft1536/validation/2026-09-20-raw-assembly/README.md),
[STABLE_NORMALIZATION](proofs/ft1536/validation/2026-09-20-stable-normalization/README.md),
[INITIAL_TARGETS](proofs/ft1536/validation/2026-09-20-initial-targets/README.md),
[ORDERED_REACH partial](proofs/ft1536/validation/2026-09-20-ordered-reach/README.md),
[LEFT_ROOT and composed NumericCenter](proofs/ft1536/validation/2026-09-21-left-root-transfer/README.md).
The independent Blue review has archived evidence, rather than a single
declared full replay runner.

## Research workflow

The [post-M0 documentary checkpoint](proofs/ft1536/stages/FT1536_POST_M0_FREEZE_RUN_001/REPORT.md)
is anchored to the active-build commit `2959064`. Its STATE, dependency graph,
checkpoint inventory and public Git inputs are sealed by
[`OUTPUTS.sha256`](proofs/ft1536/stages/FT1536_POST_M0_FREEZE_RUN_001/OUTPUTS.sha256),
with the external manifest pin in the [catalog](proofs/ft1536/catalog/FT1536_POST_M0_FREEZE_RUN_001.json).
It is a resumable state record, not an additional security theorem.

Finished tasks receive separate commits after their report, manifest and
scope are checked. Frozen evidence is archived under `proofs/ft1536/stages/`;
active computation uses the ignored `proofs/ft1536/work/` area.
Implementation integration is an explicit step separate from recording a proof.

Historical reports may cite local commit IDs from before publication. The
[commit identity map](proofs/ft1536/history/README.md) gives the corresponding
public commits with identical Git trees and unchanged file SHA-256 pins.

## Attribution and history

FT1536 research and development are led by **Niirmata**. The project retains
the historical Falcon EXTRA code lineage and credits **Thomas Pornin and the
Falcon authors** for the original implementation and algebraic foundation.
Original source attribution and MIT notices are retained.

The [earlier README](docs/history/README_before_S17_integration_2026-09-18.md)
preserves the older functional checkpoints and benchmarks in their original
context. FT1536 is experimental research, distinct from standardized Falcon /
FN-DSA parameter sets; this project does not speak for their authors.
