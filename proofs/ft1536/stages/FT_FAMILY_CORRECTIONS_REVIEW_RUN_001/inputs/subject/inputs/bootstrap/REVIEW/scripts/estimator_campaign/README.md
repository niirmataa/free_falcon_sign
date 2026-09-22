# Estimator campaign — NOT_RUN

The pinned campaign skeleton is `run_campaign.sage`. It was **not executed**
for this deliverable; the results table in the paper says NOT_RUN in every
cost cell. This matches the review requirement: a full estimator campaign is
allowed only after the problems are correctly defined (ATTACK_PROBLEMS.md),
and before execution the table must read NOT_RUN.

Open modeling points that must be closed before the first run:

1. `ntru_type='circulant'` of the estimator versus the `Phi_{3N}` tower ring
   (`X^N - X^(N/2) + 1`): confirm the estimator's structure assumptions or
   document the mapping/loss.
2. P2 semantics: SIS estimate vs the inhomogeneous (coset) search at threshold
   `B_N`; report the "find any vector below B_N in the coset" cost and its
   model, not a generic SIS number.
3. `sigma_N` for FT768/FT3072 is an output of the scenario-B design step, not
   an input to be guessed; P2 for those N stays NOT_RUN until pinned.

Record for any future run (mandatory): estimator git SHA, sage version,
command lines, full stdout/stderr, all inputs as JSON, and every returned
field including errors and omitted attacks.
