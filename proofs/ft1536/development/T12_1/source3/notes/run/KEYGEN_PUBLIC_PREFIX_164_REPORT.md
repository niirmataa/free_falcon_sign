# Readability and composed public NTT prefix164

Status: PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED.
Owner task ACTIVE / NOT_COMPLETE. Source commit47b9efc1.

PublicInitializedFrame164 proves that a legal Store16 cannot erase an
initialized byte or make an initialized uint16 word unreadable, even when
locations overlap. The result preserves object extents and writability,
then lifts by induction through the original supported statements. It
asserts readability, not equality of rewritten values; it excludes calls,
pointer mutation and automatic allocation through the checked language.

PublicTailPrefix164.source reuses the complete first-pass theorem160 and
middle-section theorem163. The readability theorem supplies transport of
the generated table through the first pass, while the scoped local frame
transports caller slots. The result is the exact composed prefix with
Arrays, n1536, logn10, u768, declared v/w and unchanged pointer bindings.
continue_tail joins an eventual tripling execution to the original whole
KeygenPublicForwardProgram.tail. Actual caller-domain instantiation and
tripling remain open; no full KeyGen witness is claimed.

Two modules/12 declarations passed full expression-DAG roundtrip and fresh
safe kernel audit (job131,2 sequential processes), standard axioms only.
Jobs130/131 have empty stdout/stderr and0 errors/0 warnings; no failed job
in this checkpoint. No source C, reference semantics, limits, independent
review or push changed. This structural memory/source result needs no new
numeric certificate and makes no probabilistic claim.

Incoming163 postseal SHA256:
be681226bf11d89558771275bf417817e9c71c25f7aeba9c67f97d14078705dc.
ENTRY164 SHA256:
2a0ad77a967af026b7ad47c06911ebeca985bc862fa12b31ab2a303ba5a66331,
56600 inherited paths checked. Exact evidence and postseal are in
KEYGEN_PUBLIC_PREFIX_164.json and .build/tail164/POSTSEAL_164.json.

OPEN:512 triple butterflies and actual caller composition; full public
suffix, solver, certificate/codecs, G(seed*) and all concrete positive
probability bounds. Corrected134, measured wording and five do_sign
obligations remain unchanged. The next internal checkpoint165 handles the
tripling body; this is an explicit split of the continuing region2.

The first and middle passes now form one source execution with the
readability and scalar domains required by the remaining pass. The next
missing execution is the512-step tripling and its concrete caller assembly.
The full successful seed and positive mass remain unproved.
