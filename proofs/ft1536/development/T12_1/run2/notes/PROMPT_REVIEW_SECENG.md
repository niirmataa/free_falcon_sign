# PROMPT — independent SECURITY-ENGINEERING review (for the owner's security reviewer)

Role: INDEPENDENT REVIEWER (owner-designated). You review; you do NOT
commit to the project's index, do NOT import to stages, do NOT touch
other lanes. Write your report in YOUR OWN work directory (e.g.
`proofs/ft1536/work/FT1536_SECENG_REVIEW_001/`) with `REVIEW.md`,
`REVIEW_RESULT.json` and INPUTS/OUTPUTS sha256 lists. Verdict vocabulary:
`PASS_SCOPED` / `CHANGES_REQUIRED` (numbered E1..En with file:line) /
`FAIL`. Fresh eyes are the point — treat all project notes as CLAIMS TO
VERIFY, not as authority.

Target commit: current `main` (record the SHA). Materials (all under
`proofs/ft1536/` unless noted):

## 1. Attack the claims (reasoning-level)

- `documents/FT1536_PAPER_OUTLINE_2026-10-06.md` and the draft paper
  `paper/main.tex` + `paper/sec_*.tex` (19pp v0.1) with companion
  `paper/SOURCES.md` (claim -> source pins).
- The assembled claim: `development/T12_1/run2/formal/Assembly.lean`
  (conditional theorem + `tape_game_hop*`), `AssemblyComp.lean` +
  `CompPrg.lean` (computational seam, P_tau public simulation),
  `AdvPrg.lean` (the recorded death of the statistical route).
- Review record you may read as EVIDENCE (not authority):
  `work/FT1536_B2B5_COMPUTATIONAL_REVIEW_001..003/`.
Find: overclaiming, scope inflation, wording an attacker could quote,
assumptions smuggled as facts, numbers presented without their caps.

## 2. Audit `Extra/c` as production C (implementation-level)

Pinned corpus: `Extra/c/` (the FT1536 profile; `frng.c` pinned
sha256 `4b1289ad...c644`), with lineage copies in `Reference_Implemention/`
and `Optimized_Implemention/` (falcon512/768/1024). The formal campaign
covers semantics of selected bodies; YOUR scope is implementation
SECURITY:
- memory safety (the `falcon_prng_get_bytes` family — known finding
  F-001 in `documents/FT1536_C_CODE_FINDINGS_2026-10-02.md`: memcpy
  from buffer start while consuming from `p->ptr` — VERIFY it and hunt
  for siblings);
- secret handling (seed/key material lifetimes, `memset` of secrets,
  uninitialized reads), integer/size handling in the bigint and FFT
  paths, error-path behavior;
- side channels beyond the recorded Floor-CT work (timing/branches on
  secrets in signing paths — cf. `fpr-emulated` floor-CT equivalence
  recorded in project docs);
- the PRNG/nonce/rejection-sampling paths (`falcon-sign.c` sampler,
  `frng.c`, `shake.c`) for bias/reuse/wrap hazards.
Deliverable: numbered findings with severity (CRITICAL/HIGH/MEDIUM/LOW/
INFORMATIONAL), exact file:line, exploitability note, and a fix sketch.
Disprove F-001 if you can — we prefer being wrong early.

## 3. Paper wording under attack

For every headline claim in `paper/`, write the strongest possible
skeptical response (a reviewer's or an adversary's). Flag any sentence
whose literal reading exceeds the theorem's scope (the paper carries
CLOSED/IN-FLIGHT/OPEN labels and a reading convention - check they do
the work).

## Honesty rules

- No security theater: findings must be reproducible from the bytes.
- Distinguish PROVEN gaps (contradiction, bug) from STYLE preferences.
- The project's known boundaries (ROM assumption, PRF-ChaCha20
  assumption, A1 no-leakage interface, A2 seed boundary, A3/A4 byte
  bridge out of scope, no QROM claim) are RECORDED - do not re-report
  them as findings, but DO check they are stated where they must be.

Polish summary at the end for the owner: what an attacker could actually
do with today's artifact, and the three most valuable hardenings.
