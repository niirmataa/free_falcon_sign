# B2/B5 — corrections E1–E5: public simulation, certified cost, key-law transport

Date: 2026-10-06. Workspace: `proofs/ft1536/development/T12_1/run2/`.
Owned sources: `formal/CompPrg.lean`, `formal/AssemblyComp.lean`, this note.
Contract: `notes/PROMPT_B2B5_COMPUTATIONAL.md`, commit `f6561725`, SHA256
`4a162827dfe7dd6e37019b9021d476c951e7d288ba4ac15f78aacc7241aa47cb`.
Review: `proofs/ft1536/work/FT1536_B2B5_COMPUTATIONAL_REVIEW_001/REVIEW.md`, §7.

## Status and correction of the previous claim

**E1–E5 implemented; AUTHOR_CHECKS_PASS_AWAITING_INDEPENDENT_REVIEW.**
Final owned modules build **0 errors / 0 warnings**, with empty logs.
The full real/honest EUF-CMA computational assembly is **OPEN**.

The previous assertion that the entire B2/B5 seam was closed is withdrawn.
The proved stream experiment is **public simulation**, not honest Sign.
The historical work-state is preserved in commit `e961ca9f` and in
`.build/b2b5_e1e5_001/inputs/B2B5_COMPUTATIONAL_WORK_STATE.pre_review.md`
(SHA256 `076f5c77f9280dbb0b2e83ee1ae8915746e7e493145ac9f008a81f8fe9f70408`).
Its 64 audit entries were **52 explicit definitions/theorems + four
constructors/recursors in CompPrg**, and eight explicit declarations in
AssemblyComp; they were not 64 explicit source declarations.

## E1 — exact experiment and principal result

`CompPrg.AdvPublicSimStream` replaces the misleading name `AdvEUFStream`.
`streamGame` draws one tape and uses `signSimAt`: public `S.code`, fresh
nonce, ROM programming, and abort on an occupied ROM entry. Key, adversary
coins, nonces, fresh ROM responses and adaptive message choices remain in
`streamCont`. `Games.runEUF` instead uses `signHonest` / `freshHonest`.

Let

```text
X       = Fin (beta.qs * S.bits) -> Bool
muE     = SigmaMath.muH muEmitted
muM     = SigmaMath.muH muKey
P_tau   = AdvPublicSimStream beta muE A S tau
P_U     = AdvPublicSimStream beta muE A S Law.uniform
b_E     = Games.AdvMT (beta.qh+1) muE (Reduction.build beta A S)
b_M     = Games.AdvMT (beta.qh+1) muM (Reduction.build beta A S)
```

The exact proved chain is

```text
|P_tau - P_U| <= deltaPRG       stream_game_hop_abs, using CompWinCert
P_U = Pr[lazyGame ... = true]  streamGame_uniform, Dist.same_event
    = b_E                     streamGame_uniform_eq_advMT / concrete_lazy_game_binding
b_E = b_M                     rewrite by binding.identify hkey
P_tau <= b_M + deltaPRG        public_sim_stream_bound
b_M >= max 0 (epsilon_stream - deltaPRG)
                              advMT_ge_of_public_sim_stream_win
                              when epsilon_stream <= P_tau
```

This direct, clipped bound is the **principal** reduction form for this
experiment. Each computational export also returns the certified cost line.
`public_sim_stream_hardness_substitution` substitutes a bound on the same
`b_M`. All five assembly exports explicitly name `public_sim`.

`public_sim_stream_phi_weakening` and
`advMT_ge_of_public_sim_stream_win_phi_weakening` retain the Phi-shaped
consequences with **arbitrary D >= 0**. They use `b <= phi D b` only to
weaken the direct bound. D is not a consumed B4 second-moment certificate;
even D=0 is permitted independently of S. The old four stream-assembly
exports were replaced, rather than kept under misleading end-to-end names.

### Missing honest-Sign interface (still OPEN)

The target real-signing claim needs a tape-driven **honest** continuation
`R : X -> Run2.Dist Bool`, source-bound to the signer, with a proved binding

```lean
((Dist.draw (Law.uniform : Law X)).bind R).Same
  (Games.runEUF beta muEmitted A false)
```

and its own `CompWinCert C cost (winFun R (fun b => b = true)) ...`.
The computational hop would then land on **H = Games.AdvEUF beta muEmitted A**.
The already-existing honest comparison is

```text
LocalJointCertificate S e
  -> H <= min 1 (epsColl beta + phi ((1+e)^beta.qs-1) b_E)
```

via `Run2.concrete_euf_cma_to_mt_isis`: local absolute continuity and the
second moment, `StoppedComparison`, `stopped_euf_to_concrete_mt`, and
stopping loss. B4 must provide this actual certificate. A real binding with
additional approximation error must account for that error explicitly.
Neither `samplerLawAt ... uniform = samplerLaw ...` nor the public-simulator
identity supplies this honest binding. This correction does not discharge
it or A2/A3/A4.

## E2 — one computational predicate and an actual resource contract

**Assumption sentence:** the public-simulation bound is conditional on
`CompPRGBound C tau deltaPRG`, over an admitted class of randomized tape
tests, together with `CompWinCert` for the actual `streamWinTest beta muE A S`.

```text
CompPRGBound C tau deltaPRG := forall t in C, compTestAdv tau t <= deltaPRG
compTestAdv tau t = |sum x, (tau.mass x - uniform.mass x) * t.run x|
cost (streamWinTest beta muE A S) <= T(A) + q * blockCost
q = AdvPrg.chachaBlocksTotal beta S
```

All three stream hops and all five assembly exports take the full
`CompWinCert C cost (streamWinTest beta muE A S) TA blockCost q`. Its `mem`
feeds the hop; its `costLine` is returned as a conjunct. Membership alone
does not satisfy these signatures. Cost and the class are parameters;
there is no new machine-cost or ChaCha20-security proof.

`comp_game_hop_abs` is the low-level probability lemma derived directly
from the predicate and membership, by finite expectation composition.
`Assembly.bind_draw_event` supplies that composition, not a TV bound.
The statistical hop, `AdvPRG` and `TV` are not intermediaries of the exports.

The horizon is `n = beta.qs * S.bits`; `beta.qs` is a record field. Uniform
windows factor independently, including zero-query/zero-width cases.
The mathematical one-tape experiment does not itself identify a single
ChaCha instance with C's concatenation of reinitialized signing instances.
Concrete generator binding, seeding/nonce dependence and byte addressing
remain source/operational obligations.

## E3 — concrete law transport, preserving B1.10's exact-type slot

```text
KeyLawBinding keyIdent muEmitted muKey : Prop
  identify : keyIdent -> muEmitted = muKey
```

The stream experiment and its cost certificate use `muEmitted`; MT uses
`muKey`. `public_sim_stream_bound` rewrites the latter using
`binding.identify hkey`. Both `binding` and `hkey` are necessary to this
transport. Setting `keyIdent := True` still requires the concrete equality
between the two laws; it cannot identify arbitrary unequal laws. B1.10 must
instantiate its exact proposition and prove its connection to these laws.
The name `muEmitted` alone is not a source binding. No source3 result is
claimed to have been instantiated here.

## E4 — exact inverse, domain and clipped dominance

For D >= 0, b in [0,1], and a <= 1, the ordinary-real formula is

```text
f(D,a) = 0                         if a <= D/(1+D)
         a - sqrt(D*a*(1-a))       if D/(1+D) < a <= 1.
```

The upper branch has nonnegative radicand. In Lean the definition remains
`phiInv D a = max 0 (a - Real.sqrt (D*a*(1-a)))`; `Real.sqrt` is total and
zero on negative arguments. `phiInv_piecewise` proves the displayed form.
`phi_inv_le` proves inversion, `phiInv_at_phi` proves exact equality
`phiInv D (phi D b) = b`, and `phiInv_at_phi_zero` gives the boundary zero.

For the public-simulation weakening, `a = epsilon_stream-deltaPRG-epsColl`.
Its export proves a <= 1 and retains the cost conjunct; a can be negative.
`phiInv_le_clipped_direct` proves

```text
phiInv D (epsilon_stream-deltaPRG-epsColl)
  <= max 0 (epsilon_stream-deltaPRG),     provided epsColl >= 0.
```

The raw unclipped RHS need not dominate: epsilon=0, deltaPRG=1, epsColl=0,
D=0 gives -1 versus inverse 0. The formula never asserts an inverse for a>1.

## E5 — API and audit convention

The three undocumented/nonexistent indicator-conversion names have been
removed from code comments. `CompPRGBoundEvent` is a separate event-form
definition; no conversion theorem is claimed. Complete new audits list
every explicit definition/theorem/structure type plus each structure's
constructor, recursor and projections. Counts and exact names are recorded
in `.build/b2b5_e1e5_001/audit/INVENTORY.json`.

Final API audit: **79/79 names** — CompPrg: 54 explicit declarations
(including two structure types) + nine constructors/recursors/projections;
AssemblyComp: 13 explicit declarations (including one structure type) + three
constructors/recursors/projections. All use only subsets of
`{propext, Classical.choice, Quot.sound}`. No requested name is missing.

## Author verification and retained attempts

Runtime evidence: `.build/b2b5_e1e5_001/`. All generated audit sources,
HOME/TMPDIR, builds, logs and receipts live there. The guard is a byte-exact
copy of `tools/original/run_lean_guarded.sh`; no project oleans were copied.
The dependency closure has 66 local modules, with pinned archived sources.
Inherited Lean 4.34.0 (commit `293d5d0c0c3f3dded4688b3ccd6a33939ac5102b`)
and Mathlib cache (HEAD `5ed2965256430c3649e86755f9576b54eca72435`) are
recorded in `inputs/ENVIRONMENT.json`.

- `clean_001`: all 64 dependencies and CompPrg rebuilt successfully.
  AssemblyComp had two name-resolution mismatches: the namespace-local
  `add_le_add_right` orders addition differently. Both were corrected by
  direct linear arithmetic. Source snapshots and full failed logs retained.
- `own_002`: both owned modules exit 0, **empty logs (0 errors/0 warnings)**.
- `own_003`: both exit 0, empty logs, after a comment-only clarification.
  `own_004` is the final source-bound rebuild after correcting the reverse
  hop's description: both exit 0, empty logs. Both earlier snapshots remain.
- `audits_001`, then final `audits_002`: each **4/4 exit 0, 0 errors/0 warnings**.
  Complete API audit
  63+16 names; nine regression declarations with standard axioms only;
  150 dependency answers with checked assertions. All 30 TV-dependency
  answers are false. Certificate membership/cost projections and key-law
  binding are present in their intended export dependency graphs.
- `Run2.FiniteDist` retains its inherited informational `Try this: ring_nf`;
  its dependency log is not empty. No warning suppression or source edit.
- Kernel regression controls cover the True-only bypass, membership without
  cost, class restriction versus TV, the inverse equivalence, negative levels
  and failure of unclipped dominance. The dependency audit checks actual
  certificate/key-binding usage and absence of TV intermediaries.
- The first metadata summarizer excluded apostrophes in two valid Lean
  names. Its failure and script are retained in `receipts/summary_001/`;
  corrected parsing matches every raw audit entry. No Lean change or rerun
  was needed for this receipt-parser correction.

Final selected evidence is **66/66 rebuilt modules + four audits = 70/70
successful steps**: 64 fresh dependency builds from `clean_001`, then the
two final owned builds from `own_004`, then `audits_002`. Selected-step
elapsed time: 102.569 s. Every current source, retained source snapshot,
log and olean matches its receipt; all 64 read-only dependency pins match.
The raw/code-only scan of all 66 final sources has zero unfinished-proof
markers. `FINAL_EVIDENCE_002.json` records the selection rather than disguising
the initial failed assembly build as successful.

Reproduction commands from run2 (the prepare step requires a fresh runtime):

```sh
python3 -B .build/b2b5_e1e5_001/rebuild.py prepare
python3 -B .build/b2b5_e1e5_001/rebuild.py build clean_001
python3 -B .build/b2b5_e1e5_001/rebuild.py build own_004 --own
python3 -B .build/b2b5_e1e5_001/make_audits.py
python3 -B .build/b2b5_e1e5_001/rebuild.py build audits_002 \
  --source audit/CompPrgCompleteAudit.lean --source audit/AssemblyCompCompleteAudit.lean \
  --source audit/CorrectionControls.lean --source audit/DependencyAudit.lean
```

Existing run IDs preserve their artifacts and reject overwriting receipts.
Each stored command uses the copied guard with 900 s compile / 1800 s wait.
The inherited informational dependency log is separate from the empty
owned-module logs; neither warnings nor errors were suppressed.

### Final SHA256 pins

| Artifact (relative to run2 unless noted) | SHA256 |
|---|---|
| `formal/CompPrg.lean` | `0b80f096cb6af0d77ef1762f58301af76dc94569e5c5cbcfeb690cc921876f3b` |
| `formal/AssemblyComp.lean` | `b6112bef9c093439acdd7ee01b9aefa8f797b18738140e99306f045d25795929` |
| `.build/b2b5_e1e5_001/FINAL_EVIDENCE_002.json` | `bf623c6a271e82e4566b48a7ddfdc86249903ff4f7d0ca151be0ace565937a89` |
| `receipts/own_004/RECEIPT.json` (runtime-relative) | `8f704425f975b8a5c96ffc62d3636a9228cd966ff57e41329f0f05ee89275fc7` |
| `receipts/audits_002/RECEIPT.json` (runtime-relative) | `41f9b152843caa9f58b25cfb82998d6db30321f5fb8efa8fca1e01a8f8298752` |

Source checkpoint scope: exactly these three owned files on main, as
`niirmataa`, local only under this task's NO-push contract. This is an
author correction checkpoint, not REVIEWED or a stages import.

## Ocena dla właściciela

Najważniejsza poprawka to prawdziwy zakres: mamy warunkową redukcję **gry
publicznego symulatora** i dokładne odwrócenie Phi. Koszt testu oraz
identyfikacja wskazanych praw klucza są teraz obecne w typach i konsumowane.
To usuwa pozorne założenia poprzedniego eksportu. Most od uczciwego Sign
oraz użycie jego certyfikatu drugiego momentu pozostają otwarte; samo
osłabienie przez Phi ich nie zastępuje. Następny krok: niezależny odbiór
zmienionych typów, a następnie właściwy montaż uczciwej gry.
