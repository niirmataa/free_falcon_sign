# Actual top initialization, generator scalar prefix and total modp_div178

Status: PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED.
Whole owner goal ACTIVE / NOT_COMPLETE.
Source commits: d44c1749, 7be74530, 858f3d36, a8d38870, 857c15cb.

SelectedTopStatics178 transports the actual prime object and REV10 through
both coefficient conversion and overlapping memmove, preserving their byte
reads and bindings. SelectedTopInit178.source constructs the original p,
p0i and R2 assignments using their source callees. The prime remains the
source-bound2147355649; p0i and R2 have their exact word-algorithm values.
SelectedGeneratorEntry178.binding constructs the original generator entry
at gm/igm scratch indices4766/5790, logn10/full1, and the actual g/p/p0i.
No whole-heap equality is assumed across earlier memory writes.

SelectedGeneratorInverse178.prefix_source executes the generator's original
three declaration statements and seven scalar/control statements through
igAssign. This includes R/R2, conversion of g into Montgomery form, the
inactive !full branch and the exact k++ condition. One square runs, and
k becomes12, including the increment associated with the false guard.
SelectedGeneratorInverseCall178.source constructs the actual ig assignment.
The output word is ModpDivTotal178.word r2 g1 p p0i r, with all arguments
bound to the same source-derived state.

ModpDivTotal178.source and source_exists are new constructive theorems for
the entire original modp_div body, with arbitrary32-bit word arguments and
an exact recursive output word. ModpDivLoopWord178.source proves all31
rounds, from signed index30 to the final−1. Each round executes the original
scope/declaration, two Montgomery calls, conditional bit-mask selection and
signed decrement. The final normalization and returned Montgomery call are
included. ScalarArgumentValues178 proves parameter conversion for the
actual int32 literal1; the source literal was not replaced by uint32 syntax.
This result concerns execution of the word algorithm. It does not assert
a new algebraic field-division specification or probability bound.

SelectedGeneratorInverse178.continue_generator still requires rowSelect,
kFromLogn, ifFull, squareLoop and topElements. Thus the complete generator
call, both top NTT calls and the later solver are not yet constructed.
SelectedGeneratorInverseFacts178 proves unchanged heap and exact ig/g/k
slots at this seam, by existing frame/slot lemmas on the actual execution.

All20 mathematical modules /170 named declarations passed full expression
DAG roundtrip and fresh safe kernel checking in audit257,20 sequential
processes. Only propext/Classical.choice/Quot.sound were allowed. Accepted
stdout/stderr are empty:0 errors/0 warnings. The facts module writes tiny
compilation-progress markers using IO; those markers are diagnostic only,
are never consumed as mathematical premises, and are not counted as
mathematical declarations. The separate failed GeneratorFactsProbe178 is
preserved as diagnostic evidence and excluded from the mathematical scope.
No new numerical experiment was required; all new arithmetic/source
claims are parametric or directly kernel proved. Existing STATIC evidence
is reused, and the paper's measured rate is not a premise.

History236-257 contains22 jobs and15 failed or mixed jobs. Eight compiler
failures concern constructor arguments, bounded-index projections, an unused
simp argument, signed-counter typing, a qualified helper name, parameter
conversion, excessive expression unfolding and optional-list selectors.
Their exact causes are retained in KEYGEN_TOP_INIT_178_FAILURES.json.
Seven controlled cancellations249-255 isolated a slow auxiliary-state
proof; no resource limit was increased. The concrete inverse call and full
prefix composition had already accepted. A progress probe identified heap
first; after its repair, another marker identified g_cell. The final proof
uses pure_heap on the proved execution and explicit outside-cell transitivity,
rather than reducing the complete selected state. It accepted in3.072s.
Earlier suspicion about the ig lookup alone was not confirmed and is
corrected explicitly in the retained failure ledger. No C/reference
semantics, mathematical condition or warning setting changed.

ENTRY178 verified62402 inherited paths; SHA256
fd38c2adea7a0b0dbd4da805d14ff6d4b408f58c12293bae13455e1cd6cc84bf.
Audit collection SHA256
f725bcb543633778572599b6ca30a53cd4c6c8874f257829e2d9a85747477ac2.
Receipt: KEYGEN_TOP_INIT_178.json.
Postseal: .build/topinit178/POSTSEAL_178.json.

| Owner point | Current status | Exact boundary |
| --- | --- | --- |
| Full source seed witness and positive mass | PARTIAL | Actual generator entry and prefix through ig, plus full modp_div execution, are now closed; table-writing loops and the remaining root/encoding path are still open. No complete emitted witness or unconditional Z>0. |
| Numerical first-attempt acceptance bound | OPEN | No numerical bound, including1/4, is established here. |
| Conditional coding and quantitative p_K | OPEN | Source encoding success and a concrete positive p_K remain unproved. |

The whole-law emitted-witness target remains corrected KeygenProbability134;
the old110 archive is unchanged. No IID, D1, F04 or empirical premise was
introduced. Measured8192/23628 and the distinct256/739 control remain
measurement material; exactly five do_sign obligations stay unchanged.
No independent review or push occurred; the full owner task remains active.

The exact modular initializer and generator prefix now execute from actual source facts.
The full solver and emitted packet remain open, so no positive probability bound is claimed.
The next proof constructs the generator's original table-writing loops on this same state.
