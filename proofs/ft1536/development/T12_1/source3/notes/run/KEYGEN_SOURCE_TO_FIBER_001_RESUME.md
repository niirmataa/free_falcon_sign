# KEYGEN_SOURCE_TO_FIBER_001 — pause and resume record

Status: PAUSED_OWNER_REQUEST / IN_PROGRESS / NOT_REVIEWED.
Worker: GPT-6 Astra / openai/gpt-6-astra.
Session: ses_f12636605ffeL1FZg4teLUwUf5.
Workspace: proofs/ft1536/development/T12_1/source3.

The owner paused work after reporting API problems and possible reduced
performance. Do not restart proof jobs until the owner resumes work.

## Saved state

Published own batch001 commits:
- 724835338f83b2a77b5f97507281fc29ec16412e: integer lift, conversion bytes,
  material representation and the internal ActualNTRUFiber composition.
- 10d8c17caa73d73a5eaa58427f4ba07031b1b89c: Gate00 byte execution and suffix
  return-snapshot/lifetime adapter.
- 89e7b88566811dcceaec2e6a2b9ccdf47e16b444: fresh replay, diagnostics and
  explicit remaining source obligations.

The last push by this worker was precisely
`89e7b88566811dcceaec2e6a2b9ccdf47e16b444:refs/heads/main`, advancing the
remote from adc72c36 to89e7b885. Only that own commit was outgoing; the first
two own commits and the other workstream's ancestors were already published.

The first internal batch remains an internal result, not the requested full
successful-KeyGen theorem. The exact acceptance target and allowed premises
are in KEYGEN_SOURCE_TO_FIBER_001_PLAN.md. Receipt:
KEYGEN_SOURCE_TO_FIBER_001_BATCH_001.json, SHA256
6efc894f0002e24d4c596e03b1dc0811c90a3fba97b6013c367d2177ddaa2527.

## Last job and unchanged draft sources

Job `.build/jobs/keygen_prefix_workspace_002` is complete:

| Module | Result | Source SHA256 |
|---|---|---|
| C99InitializationTrace | exit0, accepted/clean,1.217s | 4bcfbde0fb633592a61706f023bda2a6f35217e01fb032c4ebba5c6c6bf51b15 |
| CertificateWorkspace | exit1, failed elaboration,1.317s | deff7edce564fab0e266430fe889b8bcc9193f44fa23a0568a5da35490b51416 |
| FprPrefixCalls | not reached | 64c953a5330c979f7869d597e3c01cc11f2d3c8a7e1c4d8b8fb07fecf73869af |

RECEIPTS.json SHA256:
72566dbfcc6e0b682e926049c7065a73f5ca75c0e90ede0151b72b4940ac35dc.
Raw stdout/stderr and source snapshots remain in that job directory.
The earlier `keygen_workspace_001` preflight rejected concurrent execution
while the owner's separate Lean audit was active; retain it too.

The failures in CertificateWorkspace.initialized_bad_readable are:
1. Two `decide` goals at line50 still contain the local pointer record `p`.
   Normalize the goals explicitly to `0 < 4` and `0 < 1` before deciding.
2. The line53 proof leaves `(some (le32 b)).isSome` rather than `true`.
   Normalize the read equation to the actual `bad` offset and use
   Option.isSome_iff_exists directly, or explicitly reduce that Boolean.

These are proposed next edits, not applied or checked fixes. FprPrefixCalls
also still needs its first compilation and source/parser checks.

## Resume order

1. Re-read the current owner instruction and this W's AGENTS. Check shared
   Git status and active jobs; do not resume another worker's workstream.
2. Repair the two local elaboration issues, then run a new uniquely named
   job for CertificateWorkspace and FprPrefixCalls. C99InitializationTrace
   already has a checked cached product. Preserve the failed job unchanged.
3. Continue the full certificate prefix. Its actual execution must derive
   the memory trace used by CertificateWorkspace.after_root_copy. The generic
   trace property is not a substitute for the required source callee contracts.
4. Continue the full caller, encodings, source modular/public/inverse contracts
   and the final composition. Do not finish the package at a helper boundary.

All runtime, HOME/TMPDIR/cache and logs remain under source3/.build. Keep the
existing Lean/Sage limits and one proof job at a time. No private KeyGen or
real key generation. Work subagents are permitted; the owner decides review
startup. New source/docs/commits use English; conversation remains Polish.
Use three-own-commit push batches and never publish foreign pending ancestors.
The pause checkpoint is the first local commit of the next batch.

## Read-only NTT development research (not a checked proof)

The permitted development subagent completed in
ses_f0c5fabdeffev78HCO16VcQbpK. It ran no proof jobs, edited no files and
issued no review verdict. Its proposed invariant is saved here for later
implementation and checking; it does not discharge the source NTT contract.

For keygen let K=ZMod2147355649, R=2^31=127999 in K, and
zeta=1907584673^2 in K. The actual table builder at logn10/full1 squares
the literal generator once. Let rev_s be s-bit reversal and
e(k)=6*floor(k/2)+1+4*(k mod2). Proposed table identities:

```
gm[512+j] = R*zeta^(e(rev_9(j)))                    (j<512)
gm[2^s+j] = R*zeta^(3*2^(8-s)*e(rev_s(j)))          (s<=8, j<2^s)
gm[0] = gm[1] = R*zeta^768
rho[3*j+c] = zeta^(e(rev_9(j))+1536*c)              (c<3)
```

The required fixed-literal root certificate is
`zeta^1536-zeta^768+1=0`; comments about root order are not a proof.
For stages1<=s<=9 put t_s=3*2^(9-s) and
beta_sj=zeta^(t_s*e(rev_s(j))). The proposed loop invariant is

```
A_s[j*t_s+v] = sum(k=0..2^s-1, a[v+k*t_s]*beta_sj^k).
```

Source locations: table builder keygen2957–3035; initial transform pass
3066–3077; binary passes3082–3105; final tripling3111–3134. The final
solver comparison is7359–7396. gm starts at tmp+4*n; inverse-table storage
initially overlaps ft, but ft is overwritten before the forward transforms.

The word-level Montgomery target should state both canonical range and
`out*2^31=a*b` in ZMod p. Account for wrapping of `z*p0i` before masking
the low31 bits. Transform arrays remain in ordinary-residue scale because
the twiddles carry R; final z and r each carry R^-1. Equality of those
source words therefore yields the pointwise NTRU evaluation equation.

Suggested algebraic path: prove the binary/cubic butterfly inverses and
transform injectivity, then reuse CoefficientQuotient polynomial evaluation
at roots of Phi to transport multiplication. The existing integer-lift
consumer expects exactly the coefficientwise zero residue modulo2147355649.

Public mq_NTT/mq_iNTT uses the same proposed ordering at logn10, with
Kq=ZMod18433, Rq=2^16=10237, zetaq=25^2=625. It needs separate source
word-arithmetic bindings. Source locations in falcon-vrfy.c: table805–885,
forward1001–1060, inverse1089–1157, public computation1522–1546. The final
inverse scaling is Rq/1536. Derive the public equation from the actual
division/nonzero checks; construct fInv mathematically through the inverse
transform of the pointwise inverses. Neither equation is currently a proved
postcondition of source KeyGen.
