# Ternary-1536 Current State

Last updated UTC: 2026-05-06T08:13:48Z

This file is the short main-branch status page. It does not contain copied CSV/log data.

## Current Candidate Parameters

    ring: Z[x] / Phi_4608(x)
    polynomial: x^1536 - x^768 + 1
    N: 1536
    conductor m: 4608
    q: 18433
    current ternary bound2: 160982450
    keygen bound scale: 105/100

These parameters are tracked in the audit/research branch sources, not inferred from old logs.

## Branches

    audit-ternary1536
    research-ternary1536

Audit branch local head:

    870932c827bb9d8555a4c6c169a1e1f8e8de01e7

Research branch local head:

    287a2a376eee4eb91b423f1f620e1426ed36fa04

## Audit Branch Status

Location in branch:

    audit/ternary1536

Purpose:

    stable candidate path
    branch-generated tests
    minimal conclusions from observed outputs
    no copied historical CSV/log evidence
    no security-level declarations from tests alone

Committed audit evidence so far:

    make completed
    test_falcon completed
    public API 20 keys x 100 signatures completed
    generated signatures: 2000
    verify pass: 2000
    verify failures: 0

This is a smoke result, not a security claim.

## Research Branch Status

Location in branch:

    research/ternary1536/fpemu

Purpose:

    FPEMU backend research
    FFT3 leakage/backend experiments
    not audit evidence unless separately rerun and committed as evidence

Committed research evidence so far:

    FPEMU prototype build completed
    test_falcon completed
    scalar FPU count for implementation objects recorded as zero

Active uncommitted research work:

    split FPEMU backend into fpr.h, fpr.c, fpr_tables_binary.c, fpr_tables_ternary.c
    make completed
    test_falcon completed
    public API 20 x 100 completed with 2000/2000 verify
    scalar FPU count for sign/fft/keygen/fpr/tables/falcon: 0
    split FPEMU f,g 10k summary matched current-double control exactly
    split FPEMU f,g 10k histogram matched current-double control exactly

The split backend is not committed yet. It is being kept in the research worktree until the stage is closed.

## Empirical Snapshot

This section is a short public pointer to the current research state. It is intentionally not a security claim.

Current measured keygen distribution:

    sample count: 100000 accepted keygens
    raw dataset sha256: 9a76dfd107c8d92dcac7274d535501cd75f7510da7f327f8a8d27f0b9861eab1
    stddev_f: 3.373701125763167931
    stddev_g: 3.374115793156731106
    max_abs_f: 19
    max_abs_g: 20
    keygen attempts per accepted key: 1.70084

Current signature smoke distribution:

    generated signatures: 100000
    verify pass: 100000
    verify failures: 0
    mean encoded signature size: about 1983 bytes
    maximum observed norm/bound ratio: about 0.9184

Current subfield/norm-down worksheet:

    all 7 index-2 subfields were enumerated and tested
    worst index-2 margin over GH: +3.659349022 bits
    worst index-2 ratio over GH: 12.634958516
    below GH in the 100k run: 0 / 100000
    index-3 and index-6 sanity checks had larger margins

Index-2 mechanism note:

    The index-2 case is the critical subfield case because it has the smallest relative-norm degree.
    For Phi_4608 there are 7 order-2 subgroups in (Z/4608Z)^*, and all 7 were tested.
    In the tested measured-sigma distribution, the relative norm N_{L/K}(f) grows enough that the k=2 target is above GH instead of below it.
    Higher k cases grow faster and are treated as sanity checks, not as the bottleneck.

Expected questions:

    Q: Is this a formal proof?
    A: No. It is implementation evidence plus a model worksheet.

    Q: Were only convenient index-2 subfields selected?
    A: No. All 7 order-2 subgroups of (Z/4608Z)^* were enumerated and tested.

    Q: Why is index 2 the critical case?
    A: It has the smallest relative-norm degree. If the k=2 target is already above GH, higher k cases grow faster and are not expected to be the bottleneck.

    Q: What is the actual mechanism?
    A: The subfields are not ignored. The tested mechanism is that the relative norm of the measured-sigma secret is not short in the subfield lattice.

    Q: Does the 100k run prove all future keys behave the same?
    A: No. It supports the model and found no counterexample in this run.

    Q: Did the larger measured keygen sigma make signatures unusable?
    A: Not in this build snapshot. The 100k signature smoke had 100000 verifies, 0 verify failures, and about 1983 bytes mean encoded signature size.

    Q: What would invalidate this conclusion?
    A: A different attack model that isolates useful structure despite the above-GH relative-norm target, a bad implementation path, or evidence that another algebraic/hybrid/dual shortcut is cheaper.

Minimal interpretation:

    The tested relative-norm subfield shortcuts did not produce a short target in this 100k run.
    This is empirical and model evidence, not a proof that no subfield attack exists.

Current estimator worksheet:

    tool: SageMath + lattice-estimator
    model: NTRU/circulant key-recovery
    n: 1536
    q: 18433
    Xs = Xe: measured-sigma discrete Gaussian proxy
    lowest completed measured-sigma row in the current worksheet: 2^446.2

Minimal interpretation:

    The estimator worksheet is heuristic evidence for this model only.
    It is not a formal security level declaration.

## What We Can Say Now

Allowed:

    On the audit branch, the committed smoke test builds and verifies public API signatures.
    On the research branch, the committed FPEMU prototype builds and removes scalar FPU from implementation objects in the recorded scan.
    In the current research working tree, the split FPEMU backend has passed build/test/smoke/f,g 10k comparison so far.
    Current empirical worksheets do not show a tested subfield shortcut.

Not allowed:

    This proves a security level.
    This proves constant-time behavior.
    This proves physical leakage resistance.
    This closes all algebraic, hybrid, dual, or implementation attacks.
    This is production ready.

## Standard Evidence Rule

Each accepted result should record:

    commit hash
    exact command
    source hashes
    machine-readable summary
    short minimal interpretation

## Extra/c Policy

Do not use the dirty working tree under:

    Extra/c

as audit evidence. Audit/research branches use separate worktrees and their own committed sources.
