# 109 — fixed seeded whole-call outcome constructor

Continue the owner task after108. Actual representation is canonical env,
constructed before a fixed caller heap. The caller carries the existing
approved memory/domain data and a fresh32-byte replacement-seed input;
it supplies no future trace, success, law equality or per-attempt law.

1. Normalize the raw actual prefix/loop/encoding/teardown source chain to
   the old consumer Trace in BOTH directions, including failure tags.
   Derive Addresses for the success branch from108, do not assume it.
2. Derive same bound/prefix state, loop outcome, tail outcome and failure
   class for any two finite executions of the SAME seed. Include exact
   packet observation uniqueness. No fresh randomness enters at retries.
3. Construct the seed-indexed whole output: all defined returns become
   observed failure/success outcomes; absence of ANY finite defined seed+
   invocation trace is a distinct noDefinedReturn outcome. Classical choice
   may select a witness only after observable uniqueness is proved; never
   select a successful trace or take an arbitrary execution family as input.
4. Expose full source correspondence, cap and same decoded certificate/fiber
   facts, plus zero readiness-failure mass on the actual replacement-seeded
   path. Nonreturn/undefined absence is not renamed a proved infinite run.
5. Next push A2 uniform32-byte seed through this constructor; condition only
   on whole-call byte success, keep zero mass explicit, and bind SAME decoded
   joint/model/public laws. AssemblyComp is generic in the joint key law;
   no equality with the refuted D1 single-attempt replacement is required.

Fresh automatic entropy uses32bytes in pinned C too. Its successful-byte
boundary must be related explicitly to replacement seeding; no probability
of POSIX open/read success, EINTR, short reads or zero-read loops is invented.
Resumed/mixed contexts are distinct games. Five do_sign items unchanged.

Checkpoint109 outcome: raw-source/consumer trace correspondence preserves
outputs and failure tags both ways; same-seed whole observation is unique.
evaluate constructs the whole outcome from existence of any finite actual
execution, with choice proved observationally irrelevant. It has no input
execution family. Source success retains SAME decoded/certificate/fiber
facts; readiness failure and extra entropy events are absent on this
replacement path. No termination or POSIX availability law is asserted.
Next:110 actual seed pushforward and normalization, then model binding.
