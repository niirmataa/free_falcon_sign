# BATCH086 — signing preparation and honest assembly boundary

`PREPARATION_PROVED_KERNEL_SCOPED / NOT_REVIEWED`.
Whole objective: **NOT ACHIEVED / BLOCKED_SINGLE_SLOT_ASSEMBLY**.
See `PRE_DO_SIGN_086_REPORT.md` for the exact missing implication and the
DS-MATERIAL through DS-HYBRID signing obligations. This is the explicit
wall requested by the owner, not an integrity failure or proof of insecurity.

The new Lean interface `PointwiseStageGoal` names the reply law, actual
attempt shape and four pointwise roads. Its conditional model consumer
uses the pinned ROM construction and reduction, without an arbitrary
keyIdent gate or PRG premise. Its weight functions remain OPEN for source
realization; it is not exported as a theorem about the implementation.
The prepared unconditioned route has `e2=attemptFactor^32-1<2^-32` only
under that exact goal.

Source decisions: 17 manifest-checked C files, 23 pinned function regions;
challenge before outer retry, cap16, sample-then-norm-test, fatal sampler
fault exits immediately, encoding once after success. `sampler_large` has
an internal rejection loop without a fixed bit bound. These observations
select the unconditioned outer attempt target but do not discharge
`ReplyShape`, `AttemptShape` or the actual-code error bound.

Final `pre_sign086_003`: 2/2 clean compiles, stdout/stderr 0/0, 8 new
declarations (5 theorems), 11 complete audited entries (3 inherited).
Allowed axioms only `propext`, `Classical.choice`, `Quot.sound`.
Exactly 166 F04 source/product pairs checked before compiling; historical
accepted exceptions preserved, no new suppressions. `_001` failed on the
BoxPair namespace; `_002` compiled the proof but refused truncated audit
printing. Both retained; `_003` enables complete proof printing without
changing proof limits. No do_sign theorem, new C code, reviewer, import,
migration or push.

Replay from source3:

```sh
python3 -B tools/pre_sign086_job.py UNIQUE_LABEL Source3.SignRealizationObligations086 Source3.SignRealization086Audit
```

Source pin generator: `tools/pin_do_sign086.py` (exclusive output creation).
Seal: `tools/pre_sign086_seal.py seal`, then `postseal RECEIPT_SHA256`.
Prior 084/085 artifacts and statuses are immutable.
