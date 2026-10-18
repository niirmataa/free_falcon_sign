# Selected inverse generator and first pass172

Status: PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED.
Whole owner task ACTIVE / NOT_COMPLETE.
Source commits d0f797b2,04389300,aa8a9f7d.

PublicInverseEntry172 verifies the inverse parameter lists and constructs
its wrapper, with inverseT execution explicitly still required.
PublicInverseBody172 constructs the original declarations, automatic arrays,
dynamic generator branch, igm aliases and scope exits from generator/tail
executions. PublicInverseDomains172 discharges generator execution using
the complete166 theorem and derives every inverse-tail input from readable
writable data and fresh arrays. No generated-table values are assumed.

The triple modules construct the original nine local declarations, four
loads, five product assignments and three stores, with restored caller
locals and initialized memory. The complete 512-iteration loop reuses
the existing counter update proof, includes its w/u/v initialization,
and preserves the domains needed by the remaining code.
SelectedInversePrefix172.generator_source and triples_source instantiate
both regions on the actual SelectedQuotient171.after state.
continue_inverse requires exactly the still-unproved original remaining
inverse code, covering reverse radix, first-root inverse and normalization;
it is not claimed as an unconditional full inverse theorem.

All 14 modules / 99 named declarations passed full expression-DAG
roundtrip and fresh safe kernel checking in audit186, 14 sequential
processes, standard propext/Classical.choice/Quot.sound only.
Jobs178–186 accepted every module with empty stdout/stderr, 0 errors
and 0 warnings; no failed proof job. Existing word/generator/frame/loop
proofs were reused, with no new numerical certificate or Sage premise.
An orchestration syntax error occurred before any shell call while
preparing later drafts; it did not launch a job or modify proof evidence.

ENTRY172 verified 59024 inherited paths, SHA256:
21f74d21c750459ce843736285cff79f2143e1f861eab9e662d19bc406e54e3d.
Audit collection SHA256:
526ef30ccda034f00cacf98396ca902d6e1d93a9124c088d1a791c1df06aa035.
Evidence: KEYGEN_INVERSE_TRIPLES_172.json and
.build/inverse172/POSTSEAL_172.json.

OPEN: eight reverse radix stages, the 768 first-root inverse butterflies,
1536 normalization stores, full public return1, root solver, certificate/
codecs and the complete corrected134 emitted witness. Z>0 and numerical
acceptance/coding/p_K bounds remain open. Old110, measured wording and the
five do_sign obligations are unchanged. No C/reference semantics,
resource limits, review status, worker count or push changed.

The selected inverse now has its generator and complete first pass.
Its remaining three regions and the final KeyGen witness are still open.
No positive probability bound is inferred from this prefix.
