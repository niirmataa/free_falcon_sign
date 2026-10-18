# Eight public NTT middle rounds163

Status: PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED.
Owner task ACTIVE / NOT_COMPLETE. Sources41138d1d and65963ace.

PublicRoundSetup163 constructs the actual declaration, ht=t>>1 and zero
counter assignments; PublicRoundBody163 consumes the group-loop theorem,
executes t=ht and restores the scoped locals. The scalar shift proofs
C99OuterScalar144.half_word and C99ControlShift142.double_word are reused
at their common integer-semantics interface. The FPR procedure execution
relation is not substituted for the public uint16 execution relation.

PublicRoundLoop163.actual_plan proves all finite schedule side conditions
in the kernel; source proves the general schedule induction and
eight_rounds instantiates all8 rounds from t768/m2 to t3/m512.
PublicMiddleStart163.source includes the original t=hn and m=2 assignments;
continue_section preserves the exact original association with tripling.
Initialized input/table words and the outside-block byte frame survive.
These are constructive source theorems over explicit Arrays/slot domains,
not yet the complete selected caller invocation or a KeyGen seed witness.

Six modules/35 declarations passed full expression-DAG roundtrip and fresh
safe kernel checks (job129,6 sequential processes), standard axioms only.
Accepted126(context),127(setup/body),128(scalar/loop/start) and129 all have
empty stdout/stderr,0 errors/0 warnings. Mixed126/127 are preserved with
causes. No changed resource limits, source C, reference semantics,
empirical premise, independent review or push. The finite8-step numeric
schedule is proved directly by the kernel; no new Sage numerical
certificate or probability claim is made.

Incoming162 postseal SHA256:
c274f6c47ba3fe95b3b8e885a49f7836ea70a63cc9327256a7f65530f2b3c2fc.
ENTRY163 SHA256:
c45bf7832964b1de652fac815b12727427546ee94ce139017972301e93869b61,
56374 inherited paths checked. Exact evidence and postseal are in
KEYGEN_PUBLIC_ROUNDS_163.json and .build/rounds163/POSTSEAL_163.json.

OPEN: tripling512 and actual caller composition; second forward call,
public nonzero/division/inverse/return, root solver, certificate/codecs,
G(seed*) and concrete positive acceptance/coding/whole-law bounds.
Corrected134, measured wording and all five do_sign items remain unchanged.

All eight middle rounds now have source executions derived from the
previous group and butterfly theorems. The nearest missing pass is the
512-step tripling and its assembly with the concrete caller state. No
complete emitted-key witness or positive numerical mass is claimed here.
