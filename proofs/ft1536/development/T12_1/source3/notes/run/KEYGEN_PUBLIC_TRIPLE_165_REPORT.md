# Complete public NTT tail165

Status: PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED.
Owner task ACTIVE / NOT_COMPLETE. Source commits d25d4d59,42d46fa6,ad0d0f06.

The shared PublicU32Locals165 rules construct original assignments using
already proved modular callees. PublicTripleShape165.source_shape checks
the complete declaration/read/product/write split against the pinned body.
The four real loads, seven modular assignments and three stores are
constructed once by Declare/Reads/Products/Writes/Body165; all scoped
locals are restored and initialized words remain readable.
PublicTripleLoop165.source inducts over all512 iterations, executes the
actual guards/increments and ends at u1536/v1024. PublicTripleStart165
constructs w from the real gm_square[1] load and initializes u0/v512 using
the existing shift/subtraction proofs. PublicFullTail165.source composes
all three original passes into KeygenPublicForwardProgram.tail.

Explicit Arrays/TailEntry/cubic-binding and declared-cell domains remain.
The actual complete generator call, fresh automatic arrays and concrete
caller domains still must be supplied from the selected seed state; this
result is not G(seed*) or a complete public-call success. Existing159
row/upper/square store loops are reused; their caller prologue/dispatch
composition is the next task, not another reproof of those loops.

Eleven modules/52 declarations passed full expression-DAG roundtrip and
fresh safe kernel audit (job137,11 sequential processes), standard axioms
only. Accepted133(7 modules),134(body),135(loop),136(start/full tail) and137
have empty stdout/stderr and0 errors/0 warnings. Failed132 and mixed134/135
are retained with causes; no limits, C sources, reference semantics,
probabilistic premises, independent review or push changed. No new Sage
numeric certificate is asserted: these are structural source proofs and
kernel-certified finite counters.

Incoming164 postseal SHA256:
4dbc43974e5b37e3edf11383d38e571ea0cee8660b5db2d13ea0451375feed1e.
ENTRY165 SHA256:
461c220125c60bdb8bdc67adbe3124dbc559c4ff8848ee79145fecaba3ed6fda,
56685 inherited paths checked. Exact evidence/postseal are in
KEYGEN_PUBLIC_TRIPLE_165.json and .build/triple165/POSTSEAL_165.json.

OPEN: complete generator/caller composition, both actual forward calls,
public nonzero/division/inverse/return, root solver, certificate/codecs,
G(seed*) and concrete positive acceptance/coding/whole-law bounds.
Corrected134, measured wording and five do_sign items remain unchanged.

The original first, middle and triple passes now have one constructive
source-execution theorem over explicit caller domains. The next missing
step is deriving those domains and the complete generator execution for
the actual selected invocation. The full emitted-packet witness and
positive probability bounds remain open.
