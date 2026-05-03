# Ternary-1536 Workflow

Last updated UTC: 2026-05-03T22:43:51Z

This repository separates ternary-1536 work into two local branches:

    audit-ternary1536
    research-ternary1536

## Branch Roles

### audit-ternary1536

Current local head:

    870932c827bb9d8555a4c6c169a1e1f8e8de01e7

Purpose:

    reproducible tests
    branch-generated results
    minimal conclusions from observed outputs
    no copied historical CSV/log data
    no security-level declarations from tests alone

Audit material lives under:

    audit/ternary1536

### research-ternary1536

Current local head:

    287a2a376eee4eb91b423f1f620e1426ed36fa04

Purpose:

    FPEMU experiments
    FFT3 leakage research
    backend comparisons
    open questions
    not audit evidence unless rerun and committed as branch-generated result

Research material lives under:

    research/ternary1536

## Main Branch Policy

The main branch should describe the workflow and current branch roles only. It should not contain copied test outputs or large research artifacts.

## Extra/c Policy

Do not use the dirty working tree under:

    Extra/c

as audit evidence. Audit/research branches use separate worktrees and their own committed sources.

## Standard Test Philosophy

Each accepted result should record:

    commit hash
    exact command
    source hashes
    machine-readable summary
    short minimal interpretation

Allowed conclusion shape:

    On commit X, command Y produced result Z.

Avoid conclusion shape:

    This proves N bits of security.
    This proves constant-time behavior.
    This proves physical leakage resistance.
