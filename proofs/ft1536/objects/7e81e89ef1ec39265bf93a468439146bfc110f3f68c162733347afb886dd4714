# Estimator campaign — NOT_RUN (guarded interface, R4 repair)

The active runner `run_campaign.sage` in this directory is the R4-repaired
interface of TASK `FT_FAMILY_SCALING_CORRECTIONS_RUN_003` (S01).  The
historical, unchanged copy of the runner that routed homogeneous
`SIS.estimate` to the P2 cell lives in `../historical/` and is labelled
**INVALID_FOR_P2 / NOT_RUN** (see `../historical/INVALID_FOR_P2.md`).

State of this deliverable: **NOT_RUN**.  No estimator backend was imported or
executed (`estimator_campaign_executed_in_this_task=false`); every cost cell
of the paper and `CLAIMS.md` remains `NOT_RUN`.  The instrumented mock tests
in `../test_r4_routing.py` exercise the guards only (they prove the absence of
backend calls and the detection of a false SIS→P2 routing; they are not
measurements).

Guards, in order:

1. Without a premises record the runner writes an explicit
   `NOT_RUN_MODEL_UNRESOLVED` record for every cell and exits (3) — the
   backend is never imported.
2. A premises record must contain: `estimator_commit` (40-hex SHA),
   `modeling_points_closed` (both `circulant_vs_phi3n` and
   `p2_coset_threshold_semantics`), and a `model_mapping` entry with
   `model_kind`, `estimator_symbol` and `mapping_sha` (64-hex) for every
   problem/N cell.  Any gap is a validation rejection (4) before any call.
3. Any P2 mapping whose model is SIS-family (by `model_kind` or by estimator
   symbol) is rejected as `INVALID_MODEL_SIS_FOR_P2`.  P2 requires
   `model_kind == ISIS_COSET` (the inhomogeneous coset search of
   `ATTACK_PROBLEMS.md` §2).
4. Only after (1)–(3) may `--allow-backend` reach the single late-import call
   site; every call is appended to the `backend_calls` audit list.

Open modeling points that must be closed in the premises before any future
run (unchanged from the review requirement):

1. `ntru_type='circulant'` of the estimator versus the `Phi_{3N}` ring
   (`X^N - X^(N/2) + 1`): confirm the estimator's structure assumptions or
   document the mapping/loss (`circulant_vs_phi3n`).
2. P2 semantics: the inhomogeneous (coset) search at threshold `B_N` over
   ROM-table targets with the union-bound accounting of
   `ATTACK_PROBLEMS.md` §2 (`p2_coset_threshold_semantics`).
3. `sigma_N` for FT768/FT3072 is an output of the scenario-B design step;
   P2 for those N stays `NOT_RUN_MODEL_UNRESOLVED` until pinned.

Record for any future run (mandatory): estimator git SHA, sage version,
command lines, full stdout/stderr, all inputs as JSON, and every returned
field including errors and omitted attacks.
