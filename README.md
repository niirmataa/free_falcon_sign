# FREE Falcon — FT1536

FT1536 is an experimental full-ternary-secret signature research project
developed by **Niirmata**, continuing the historical **Falcon EXTRA / ternary**
implementation. This repository contains the implementation, source-bound
proof checkpoints, their evidence, and reproducible replay tools.

**Current status — 2026-09-19:** **L_RHO, the complete L_NTT pipeline and the
byte-level L_V verifier bridge are proved for the pinned corrected candidate
and its explicit C model.** M0 now defines the protocol/game/resource contract
and proves the STATIC capacity bound. End-to-end security remains an open
research objective.

The owner-selected **S17 reference baseline is in `Extra/c/`, including FPEMU
and adaptive CDF tables**. S17 and the corrected L_RHO candidate are distinct
source versions: the positive L_V theorem belongs to the candidate snapshot;
S17 retains the recorded normalization counterexample.

Start here:
- [Proof archive and latest results](proofs/ft1536/README.md)
- [Detailed post-L_V roadmap and T2C3/T5 dependency map](proofs/ft1536/documents/FT1536_MAPA_DALSZYCH_DZIALAN_PO_LV_2026-09-19.md)
- [M0 protocol and security game](proofs/ft1536/stages/FT1536_M0_CONTRACT_RUN_001/GAME.md)
- [M0 capacity proof](proofs/ft1536/stages/FT1536_M0_CONTRACT_RUN_001/CAPACITY.md)

## Build FT1536

The source path remains **`Extra/c/`**. **FT1536** names the selected build/profile.

From the repository root on Linux, with GCC, GNU Make and Python 3.11+:

```sh
make FT1536
make check-FT1536
```

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
The [S17 integration check](provenance/checks/2026-09-19-s17/README.md)
preserves the executed commands, results and full build/check streams.

## Source baseline and known verifier issue

The current `Extra/c` is the **exact S17 baseline**, selected by the project
owner. Its authoritative file list is
[`provenance/ft1536-s17.sha256`](provenance/ft1536-s17.sha256).
See [integration and provenance](provenance/FT1536_S17.md).

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

**S17 retains the documented normalization defect:** for the existing
public synthetic witness, original Verify accepts while the fixed extractor
`Ext0` is not short. The focused regression deliberately reproduces this
known result. It is not a new successful-security test or a demonstrated
HashToPoint preimage / efficient EUF-CMA forgery.

The separately pinned **L_RHO candidate** corrects that local normalization
and rejects this witness. It differs from S17 only in `falcon-vrfy.c` and is
available in the [candidate snapshot](proofs/ft1536/stages/FT1536_L_RHO_RUN_001/candidate/)
and its [exact patch](proofs/ft1536/stages/FT1536_L_RHO_RUN_001/candidate.patch).
That correction is **not integrated into the S17 baseline in `Extra/c`**.

| Version / interface | Current role |
|---|---|
| `Extra/c`, S17 manifest `03eaa0dd…` | Exact historical reference and default build; recorded counterexample to Ext0 shortness |
| L_RHO candidate, manifest `2553358f…` | Corrected verifier snapshot used by the completed L_RHO/L_NTT/L_V proofs |
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

### Next mathematical frontier

The [H3 interface](proofs/ft1536/stages/FT1536_M0_CONTRACT_RUN_001/H3_INTERFACE.md)
targets center reachability before `fpr_floor -> int` and `s+z` for emitted
keys and reachable signing histories. The roadmap then connects the complete
source signing law, pre-cast/byte/retry behavior, R5T, public simulation and ROM
composition. New mathematical tasks are explicit checkpoints.

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
[M0](proofs/ft1536/validation/2026-09-19-m0/README.md).
The independent Blue review has archived evidence, rather than a single
declared full replay runner.

## Research workflow

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
