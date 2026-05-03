# Ternary-1536 Current State

Last updated UTC: 2026-05-03T23:08:17Z

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

## What We Can Say Now

Allowed:

    On the audit branch, the committed smoke test builds and verifies public API signatures.
    On the research branch, the committed FPEMU prototype builds and removes scalar FPU from implementation objects in the recorded scan.
    In the current research working tree, the split FPEMU backend has passed build/test/smoke/f,g 10k comparison so far.

Not allowed:

    This proves a security level.
    This proves constant-time behavior.
    This proves physical leakage resistance.
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
