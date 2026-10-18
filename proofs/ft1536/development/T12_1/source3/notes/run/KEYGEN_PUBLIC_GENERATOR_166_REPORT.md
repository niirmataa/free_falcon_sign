# Complete public table generator166

Status: PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED.
Owner task ACTIVE / NOT_COMPLETE. Source commits f7e94213 and eee7e933.

PublicGeneratePrefix166 constructs the row prologue from the existing
scalar rules, including b declaration, x/ix copies and four Montgomery
assignments. PublicGenerateEntry166 derives every RowEntry field from
the actual KeygenPublicTableSeed.ready state. PublicGenerateComplete166
composes the existing159 head, proves the false logn==1 branch, consumes
the existing row/upper/square loops and restores b before afterRows, as
required by the original C scope. The result is one complete execution
of code.generate, WrittenRange0..1024 on both tables and a readability/
metadata frame. Only legal Tables and the actual logn10 profile are inputs;
no table-value or generator-execution premise remains.

Three modules/14 declarations passed full expression-DAG roundtrip and
fresh safe kernel audit (job139, three sequential processes), standard
axioms only. Jobs138/139 have empty stdout/stderr,0 errors/0 warnings;
no failed proof job. A preparatory entry checker used a wrong literal
file count; ENTRY_ATTEMPTS.json retains it. The actual frozen manifest
hash and all57036 inherited paths then verified; no integrity failure
or source modification was found. No limits, C/reference semantics,
probabilistic premises, independent review or push changed.

ENTRY166 SHA256:
9fb546191769f9149a9513adf4925d1381b575956e86c63b9aca000cd43e8bc4.
Audit collection SHA256:
b3b4f63f884000126b2e08f66e508801f4ca4c9892ad05ba2f4a0a61ca0dda63.
Exact evidence/postseal: KEYGEN_PUBLIC_GENERATOR_166.json and
.build/generator166/POSTSEAL_166.json.

OPEN: actual fresh-array/caller domains and both forward calls; public
nonzero/division/inverse/return, root solver, certificate/codecs, G(seed*)
and concrete positive acceptance/coding/whole-law bounds. Corrected134,
measured wording and the five do_sign obligations remain unchanged.

The complete generator now has a constructive execution theorem, using
the earlier159 loops unchanged. The next step is to derive its buffer
conditions and the tail conditions at the actual call state. A complete
selected-key witness and positive probability bounds are not yet proved.
