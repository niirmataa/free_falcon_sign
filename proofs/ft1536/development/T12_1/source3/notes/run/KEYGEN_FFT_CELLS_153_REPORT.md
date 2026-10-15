# Kernel FFT values and first raw-norm acceptance153

Status after successful final audit; seal and postseal recorded separately:
PROVED_KERNEL_SCOPED_RAW_NORM_ACCEPT / NOT_REVIEWED.
Whole owner task ACTIVE / NOT_COMPLETE; all three success-mass goals remain open.

`SelectedNormGate153.source` proves that the ACTUAL first raw-norm stage
accepts, from `reference SelectedBound135.after` to
`SelectedRawNorm151.after` with normal flow. Its comparison premise has
been discharged by `SelectedNormGate153.accepted`. The source execution
endpoint and the original floating-point operation order are unchanged.
This is a selected-execution theorem, not a population probability bound.

## Exact result and composition

`SelectedNumericFft153.f_source` and `g_source` identify both actual FFT
images with the certified literal vectors. `images` carries those vectors
in the actual caller heap. `norm_source` rewrites the original ordered
norm into a sum over these same vectors.

`SelectedNormGate153.sum_word` proves the undoubled accumulator word
4699628256951795696. `norm_word` proves the final raw-norm word
4704131856579166192 (0x41486efffffffff0), compared with the previously
source-proved bound word 4737176763271429578 (0x41bdd52ae5073dca).
These are 64-bit FPEMU encodings, not probabilities or unencoded real values.
`accepted` checks the original `FprCompare.spec` result equals 1.
`continue_gs` composes this acceptance with the source-bound initialization;
its remaining premise is exactly the original `KeygenAttemptNorm133.GS`
execution starting at `SelectedRawNorm151.after`.

The finite certificates use one general `FiniteWordVector153.complete`
lemma, exact source-to-indexed FFT rewrites, and one `NormTrace153.source`
induction. They do not execute every source butterfly again. Balanced
`WordTree153` literal lookup avoids the growing cost of indexing long
literal Arrays. All resource limits are unchanged.

The primary certificate chain contains two 1536-word input equalities
(12 checks of width 256), 1280 active twiddle words (40 checks of width 32),
19 numeric FFT stages (468 checks), and 1536 ordered norm transitions
(24 checks of width 64). Every numeric equality is kernel checked.
Direct-row twiddle lookup is proved equal to the original table parser;
inactive indices retain the original lookup. Literal tables are therefore
not substituted on an assumed equality.

## Evidence and retained attempts

Entry152 verifies 46376 inherited pins. Primary mathematical sources:
213 modules, 711 named declarations. Final audit job
`keygen_fftcells153_026` uses 213 sequential Lean processes and 711 separate
commands, one command per declaration within its mathematical module.
All 213 processes passed, with maximum RSS 4133032 KiB. The audit preserves
the full expression-DAG roundtrip, fresh safe kernel
definition at the original type, standard three-axiom check and resource
limits. `AUDIT_COLLECTION.json` records exact ordered coverage; seal requires
every accepted stdout/stderr to be 0/0. This is an author audit, not an
independent review. The final receipt and postseal are authoritative for
completion of these checks.

Source commits: acf448e9, d645432d, b5b7c54f; local main, no push.
All 26 jobs are retained. Failed or mixed jobs and causes:

- 001: missing whitespace caused the `<=i` notation to parse as InitialSeg.
- 006: the second 256-word Array check reached the unchanged -M6144 limit;
  smaller probes and the complete width-64 Array route passed in 007/008.
  The primary balanced-tree route subsequently passed at width 256.
- 025: an Init-only module lacked `Lean.Elab.Command` for the audit's
  `run_cmd`. Versioned V2 audit sources add that import only; the old
  sources, plan, output and failure remain preserved.

Sage jobs 003/010/015/021 use the standard preparser and exact word
arithmetic, producing candidates and checks. The earlier Array route and
unused probes remain diagnostic history. The primary kernel chain uses
the balanced-tree inputs, certified twiddles, all 19 stage equalities and
the checked norm trace. Sage/native agreement is auxiliary evidence, never
a theorem premise. Generator recipes, manifests, job sources, artifacts
and logs are pinned by the receipt.

## Remaining scope

GS, solver, final emitted packet, certificate and codecs still require the
selected source witness. No concrete `Z > 0`, numerical `p_accept` lower
bound, conditional encoding bound or numerical `p_K` bound is established
by this stage. The next source obligation is described in
`KEYGEN_FFT_CELLS_153_NEXT_ROUTE.md`.

The active whole-law target remains corrected `KeygenProbability134`.
Frozen law110's zero-mass diagnostic records its missing-sqrt model
coverage defect; it is not a claim of failure of the real C implementation.
No old/new whole-law equality is asserted. Paper wording remains measured,
with no IID, D1 or F04 identification. Exactly five do_sign obligations
remain unchanged. No new worker, schedule, source-C modification or push.
