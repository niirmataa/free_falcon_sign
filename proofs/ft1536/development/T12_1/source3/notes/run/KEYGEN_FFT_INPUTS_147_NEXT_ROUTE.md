#147 continuation — original tripling loop and first FFT completion

Actual execution endpoint is still SelectedFftMiddle144.after: all middle
passes closed, n1536,hn768,t3,m512,full1,logn10. Stage147 proves one generic
COMPLETE tripling body; no actual loop iteration is claimed until its caller
setup and induction are instantiated. No numeric snapshot is assumed.

Main export: FftTripleBody147.source_and_image. Context carries the ordinary
write-buffer context (inside u+2<hn,length2*hn<=n,word bound,width/capacity,
writability,array binding,typed u/hn), q<2048, v=2*q, cubic alias/pinned memory,
and four typed source constant cells. The theorem executes the ORIGINAL
scope with20 locals and25 statements: four declarations,eight loads,ten local
macros andthree pair-store macros. Output restores ALL caller locals/arrays/
globals/tables, updates exactly the six words, carries the exact symbolic
vector recurrence and full metadata/outside-buffer byte frame.

The actual input/table prefix is FftTripleInputs147.source. All incoming
macro cells are derived from buffer/table reads; destination declarations
are propagated by C99Declared147. FftTripleArithmetic147.source composes the
ten local macros with exact FPR order. A Python generator emits symbolic
proof syntax only; its output replay is byte-identical and pinned. Every
step, cell fact, output formula and source site is checked by Lean.
FftTripleLocal147.source covers source statements0..21; FftTripleWrites147
source_and_image covers22..24. C99ScopeFrame147.restored identifies the
entire scope-restored state. Do not replace SQR with real algebra or reorder
B1+C2 / B2+C1; rounding order remains literal.

Next148: derive the original full branch and its v declaration/for-clause
initializers u0 and v=(size_t)1<<logn=1024. Original u is uint64; logn is
uint32 with value10. The loop uses u<hn, u+=3, v+=2;256 iterations end at
u768,v1536. For ghost index k, use u=3*k and v=2*(512+k); k<256 derives
u+2<768 and q=512+k<2048. C99SmallLiteral146.update handles literals3/2;
use explicit Fin constructors if numeral projections obstruct AST matching.

Build a loop invariant carrying the represented vector, root metadata,
readonly cubic pins, actual constant cells, hn768 and the two counter cells.
Instantiate the generic body once per induction step; its full frame
preserves counters and constants before source increments. Restore the
branch v scope at exit and retain the original final false guard. Do not
replay256 concrete bodies. Obtain the selected caller constants from144's
proved frame and actual source-bound snapshot: W2R=0xbfe0000000000000,
W2I=0x3febb67ae8584caa,W4R=0xbfe0000000000000,W4I=0xbfebb67ae8584caa.
Prove their cells; these literals are not new assumptions.

Then use FftMiddleContinuation144.body to close the first FFT function body,
and its actual call binding/receive to return to the KeyGen caller. rt2 and
later KeyGen still remain. Prefer generic first-pass/whole-FFT reuse for rt2
rather than the old768-step numeric-certificate sequence. Later numeric
images require a proof of equality to the symbolic recurrence.

Performance lessons: avoid whole-state metadata rfl on a long symbolic
arithmetic trace; use heap/frame lemmas. An abstract-word Entry factory and
explicit state/data parameters avoid inferring huge table expressions from
projected states. Keep generated source synchronized with its generator and
assert textual replacements. Audit failures/changes are recorded in147's
FAILURES; the audit template and resource limits were never increased.

Whole success-mass program ACTIVE under corrected134; frozen110zero and
measured paper preserved, five do_sign items unchanged. One job/Lean,0/0,
fixed limits,all failed attempts,small local main commits/no push,no workers/
schedules. Source commits from unrelated S05 on shared main are not ours.
