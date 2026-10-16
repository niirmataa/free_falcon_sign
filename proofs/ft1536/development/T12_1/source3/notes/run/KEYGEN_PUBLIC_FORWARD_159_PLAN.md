# Actual forward invocation executions and public-input tail159

Initial status IN_PROGRESS / NOT_REVIEWED. Entry158 accepted through
SelectedPublicNttEntry158 (jobs keygen_publicinput158_001-011, failures
001/002/003/005/007/010 retained in KEYGEN_PUBLIC_INPUT_158_FAILURES.json).
Entry pins unchanged: `.build/public158/ENTRY_PINS.json`, 55659 pins,
SHA256 528dbf18337a1e33322eac63ff99a9ba5008fc03449c1751483dcec7b9130290.

From SelectedPublicConvert158.after (conversion complete, logn10/ternary1/
n1536/q18433, h/t bound, globals/tables retained) construct the remaining
execution `SelectedPublicConvert158.remaining` = hForward ++ tForward ++
suffix (fragment 1537 10): the two actual mq_NTT invocations, then the
nonzero tests, mq_div_18433 stores, inverse NTT and return 1.

Construction order:

1. PublicForwardEntry159: constructive caller-side call executions for both
   forward invocations (parameter binding, original ternary dispatch, void
   return), each parameterized over the actual mq_NTT_ternary body execution.
2. PublicForwardBody159: the complete mq_NTT_ternary body from its declared
   dimensions/residues, both automatic gm/igm arrays, dynamic mq_mkgm3 call
   and both aliases, parameterized over the generator and tail executions.
3. PublicForwardGenerate159: the complete mq_mkgm3 body (fixed loops and
   helper calls) and its gm/igm write trace.
4. PublicForwardPasses159: the full tail (first pass 768 butterflies,
   intermediate doubling rounds, degree tripling 512 butterflies) with
   initialized-cell invariants; no canonical twiddle or NTT oracle.
5. Compose h/t calls with forward_other frames, execute the suffix, derive
   return 1 and discharge SelectedPublicStart157.continue_call.
6. Only after the public call returns nonzero: root-solver obligation of
   SelectedAttemptPrefix156.continue_search; then certificate, encoding,
   whole emitted packet and positive mass (G(seed*), Z >= 2^-256).

Helper modules are added in small steps as needed. Keep the full owner goal
active. No IID/D1/F04/empirical premises, no new axioms or higher limits.
One Lean job/process, standard Sage, retained failures, 0/0 accepted logs,
small local commits without push and postseal. Corrected134, frozen110
history, measured wording and five do_sign unchanged.
