# B1 staged roadmap — one stage per window (context discipline)

Coordination doc (2026-10-02). Astra's `source3/notes/run/
KEYGEN_SOURCE_TO_FIBER_001_EXECUTION_PLAN.md` already defines the stage
seams (B1.01-B1.06, each with an Acceptance block). This roadmap adds the
WINDOW discipline so no session ever runs into its context wall.

## Iron rules (every B1 window)

1. **One stage per window.** Start: read `PROMPT_B1_CONTINUATION.md`, the
   EXECUTION_PLAN (your stage), and `KEYGEN_RESIDUE_CHECKPOINT.md`.
   Work ONLY your stage. Finish at its **Acceptance** block — not earlier,
   not beyond.
2. **Close cleanly at Acceptance:** update
   `KEYGEN_RESIDUE_CHECKPOINT.md` (overwriting with the extended state:
   closed items with pins/hashes/receipts, in-flight with exact types,
   remaining in plan order, traps met), add the batch receipt
   (`notes/run/*_BATCH_*.json` + `*_NOTES.md` pair), local commit, and end
   with the Polish handoff summary. The window then CLOSES (it is not a
   failure — it is the design).
3. **Context budget:** treat ~250k tokens as the soft ceiling. If a stage
   runs long, freeze at a recoverable mid-point: write the checkpoint with
   the exact remaining obligations and close — the next window resumes.
   NEVER run a stage into the wall.
4. All other lane rules unchanged (pinned M0 bytes, zero unfinished-proof
   markers, defs-first, guarded 0/0 builds, failed attempts preserved,
   no push, one Git writer).

## Stages (each = one window)

| Stage | Content (see EXECUTION_PLAN §3) | Size | Notes |
|---|---|---|---|
| **B1.00** (current window) | freeze: close the in-flight batch, checkpoint, exit | small | the 450k window — rescue first |
| **B1.01** | NTT word algebra adapter (`ZMod 2147355649`, radix 2^31 scale in the type, Montgomery-vs-ordinary distinction, PRIMES3/p0i source binding) | small | good warm-up window |
| **B1.02** | forward-NTT source grammar + full body execution (`modp_NTT3_ext`, wrapper bound separately) | BIG | grammar extensions only as needed; commit syntax/control separate from invariants |
| **B1.03** | twiddle-table generation + memory layout (`modp_mkgm3`, order-9216/4608 proof OBLIGATION not assumption, `igm=ft` alias overwrite) | medium-heavy | large finite-table certs via generator/pin (LARGE_ARTIFACTS pattern) |
| **B1.04** | NTT canonical range + polynomial evaluation (6 sub-proofs: first pass, radix-2, triple pass, REV10 permutation, CoefficientQuotient relation, 1536 distinct roots of Phi) | heavy | commit passes as separate recoverable steps |
| **B1.05** | solver call graph -> exact integer NTRU (`poly_big_to_small`, MODE1 sampler bounds 1, material preservation, `exact_ntru_of_modular_check` with residual 37748737) | heavy | no `solver_correct` premise may remain |

### Proposal 2026-10-08: named B1.05 sub-stages (owner-suggested)

B1.05 runs long (BATCH_023-026 and counting). Suggested named sub-stages
mirroring the owner's 2026-10-08 window order, for context discipline:

| Sub-stage | Content | Status |
|---|---|---|
| **B1.05a** — signed/reduction CRT family | call-capable word layer, CRT-family bodies, member-access tokenization, complete zint_rebuild_CRT parse/execution, co-reduce/reduce family with bitcast + `#define M` macro scope | **CLOSED** (BATCH_025/026) |
| **B1.05b** — Bezout + extraction + big-to-fpr | zint_bezout (ternary `?:`, memcpy/memset `sizeof *element`), bitlength, zint_get_top, poly_max_bitlength, poly_big_to_fp, scaled polynomial subtraction, complete make_fg | open |
| **B1.05c** — binary make_fg_step + closure + Acceptance | make_fg_step with mkgm2/NTT2 binary bodies and stride-one macros, solve_NTRU_deepest/intermediate/root closure, sampled f/g and full material transport, B1.05 Acceptance | open |
| **B1.06** | public computation + inverse (`falcon_compute_public` ternary branch, `mulRq` equations, `fInv` witness from nonzero evaluations) | medium-heavy | B3 exports only after exact-type inspection |

After B1.06: the B4 premises `hshape`/`AttemptShape` materials and the
`O-NONE` inputs get discharged (see `run2/notes/B4_SYNTHESIS.md` argument
list), then the B5 assembly.

## Launch lines

Rescue (the current 450k window):
```
Zamknij bieżącą partię TERAZ. Zapisz rozwinięty checkpoint do
KEYGEN_RESIDUE_CHECKPOINT.md (domknięte z pinami, w połowie z dokładnymi
typami, pozostałe wg kolejności EXECUTION_PLAN, pułapki), dodaj receipt
batcha, commit lokalny, i zakończ raportem. Okno ma się zamknąć godnie.
```

Each stage window:
```
Przeczytaj i wykonaj WYŁĄCZNIE krok B1.0N z:
proofs/ft1536/development/T12_1/run2/notes/PROMPT_B1_CONTINUATION.md
+ source3/notes/run/KEYGEN_SOURCE_TO_FIBER_001_EXECUTION_PLAN.md (sekcja
kroku) + KEYGEN_RESIDUE_CHECKPOINT.md. Zamknięcie okna przy Acceptance
kroku ze świeżym checkpointem (żelazne zasady w
run2/notes/B1_STAGED_ROADMAP.md).
```
