# Public NTT group loops162

Status: PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED.
Owner task ACTIVE / NOT_COMPLETE. Sources1b4cb08a and51294a1e.

PublicGroupHead162.source executes the original group declarations,
reads the actual gm_square[m+u1] word and assigns v2=v1+ht. Its result
supplies PublicMiddleLoop161.Fixed without assuming any twiddle value.
PublicScopedFrame162 strengthens the existing local-write frame to account
for restoration at scope exit; no execution semantics is changed.
PublicGroupBody162.source initializes v and consumes the full inner-loop
execution, then restores v2/s. PublicGroupInvariant162 transfers the
initialized table through the data writes using disjoint physical blocks.
PublicGroupLoop162.source constructs all remaining groups, including
u1++ and v1+=t, reaching u1=m and v1=m*(2*ht)=1536 under the stated Fixed
domain. The same body is reused for every group.

Five modules/24 declarations passed full DAG roundtrip and fresh safe
kernel checks in five sequential audit processes (job125), standard
axioms only. Accepted jobs121(head),122(scoped frame),124(body/invariant/
loop) and125 have0 errors/0 warnings and empty stdout/stderr. Mixed121/122
and failed123 are retained with causes. No changed resource limits,
reference semantics, production C, empirical premise, new Sage numerical
certificate, independent review, or push.

Incoming161 postseal SHA256:
371df6a3f5cf78611f9a7db110bdd77830123f831cc442d4887d02583d35900f.
ENTRY162 SHA256:
d56a17110ad2be2c2a867eb2bc6f41a8a7f5e28720678627bebb20bd195f2652,
56188 inherited paths verified. Exact evidence and postseal are in
KEYGEN_PUBLIC_GROUPS_162.json and .build/groups162/POSTSEAL_162.json.

OPEN: eight outer rounds, tripling, actual caller bindings/composition,
public suffix/nonzero/inverse, root solver, certificate/codecs, G(seed*),
and concrete positive acceptance/coding/whole-law bounds. Corrected134,
measured wording and the five do_sign items remain unchanged.

The complete group loop now follows from actual statement executions and
explicit caller-memory domains. The next missing control layer is the
outer eight-round loop, after which tripling and concrete caller assembly
remain. No full successful-seed witness or positive probability bound is
claimed by this scoped result.
