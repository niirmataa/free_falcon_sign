# Parametric public NTT middle inner loops161

Status: PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED.
Owner task ACTIVE / NOT_COMPLETE. Source commits12878be1 and80405a4a.

PublicWordSteps161 reuses the established modular scalar source rules for
addition, subtraction and address arithmetic, plus legal uint16 loads and
stores. PublicMiddleReads161 executes the declarations, both loads and
twiddle multiplication; PublicMiddleWrites161 executes both modular stores
and preserves all prior initialized cells and every byte outside a.block.
PublicMiddleBody161.source composes the SAME original midInnerBody,
restores both scoped locals, and proves the complete memory/locals frame.
PublicMiddleLoop161.source constructs the entire original inner loop from
start to stop, with guard/increment and explicit Fixed/USlot domains.
The bound stop+ht<=1536 supplies every read/write domain; no canonical
residue, generated-twiddle value, transform property or success premise is
introduced. The common body is proved once and reused by induction.

Five modules/32 declarations passed full expression-DAG roundtrip and
fresh safe kernel audit, five sequential processes in job120. Standard
axioms only; accepted jobs113/114/115/118(body)/119 and all audit processes
have empty stdout/stderr,0 errors and0 warnings. Failed116/117 and mixed118
are retained with causes. No limits, reference semantics or production C
changed; no Sage numerical certificate is asserted or needed for these
structural source-execution statements. No independent review or push.

Incoming postseal160: f5c8066f5a402a3d1163eec7e4711afe4e87aac43a17e8445d74d59a0848732f.
ENTRY161: 2cff3d18e96c9b0f15a1dbd37e911761e6f41dcd4eea8e2809a34f9b485bc0c3,
55965 inherited paths verified. Exact current receipts and postseal are
KEYGEN_PUBLIC_MIDDLE_161.json and .build/middle161/POSTSEAL_161.json.

OPEN: group prologue/loop, eight outer rounds, tripling, actual caller
composition; full public suffix, root solver, certificate/codecs, G(seed*)
and quantitative acceptance/coding/whole-law bounds. Corrected134 remains
the target. The paper remains measured; five do_sign items unchanged.

The modular middle butterfly and its complete inner loop are now proved
from explicit source-memory and scalar-slot domains. The next missing
composition is the group loop with its generated-table read, followed by
the outer rounds. These results do not yet establish a successful seed or
a positive numerical probability bound.
