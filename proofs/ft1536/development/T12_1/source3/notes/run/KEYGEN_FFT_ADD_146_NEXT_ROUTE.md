#146 continuation — original tripling loads, full body and loop

Actual endpoint is STILL SelectedFftMiddle144.after, all middle passes
closed; full1/logn10,n1536,hn768,t3,m512, exact symbolic image. No full
tripling iteration has executed in146. Start u0/v1024,256 steps u+=3,v+=2,
end u768/v1536. Current source fragments are FftTripleShape145.

All thirteen macro sites now have proved source rules:
- FftTripleCalls145.mul i (i:Fin6), source parts12/13/14,16/17/18;
- FftTripleCalls145.square, part15 xr/xi, exact sqr/sub/mul/double order;
- FftTripleAddCalls146.local_source i, parts19/20/21;
- FftTripleStore146.source_and_image i, parts22/23/24.
Local calls need ordinary input cells (MUL also declared output cells).
The store adapter derives pointer/address/allocation from typed u/hn,
u+2<hn,2*hn<=n,n<2^64,width/capacity,writability,array binding and a complete
Represents buffer. It returns original source execution, exact two-update
vector image and full caller/metadata/outside-byte frame. No opaque execution
premise. Store i uses realSlot=u+i and imagSlot=u+i+hn. Read-set guards
outside fpct_re/fpct_im are already derived.

Next147: source-declare the20 loop-local cells (parts0..3), load six input
words (parts4..9) and cubic xr/xi (10/11), then compose these source macros
in EXACT order. Initial input load0 uses u rather than u+0, and load1 uses
u+hn rather than u+0+hn; use the correct source AST. Remaining load offsets
match the store slots. Cubic pair512+k for u=3*k,v=1024+2*k,k<256; use generic
FftGroupTwiddle143.lookup with .cubic and FftTableWord139, never expand the
entire table. Caller cubic binding and readonly pins are already in144.

Pure word route for one body:
B0=mul(B,Q),B1=mul(B0,W2),B2=mul(B0,W4); Q2=source_sqr(Q);
C0=mul(C,Q2),C1=mul(C0,W2),C2=mul(C0,W4);
D0=add(B0,C0),D1=add(B1,C2),D2=add(B2,C1);
store add(A,D0),add(A,D1),add(A,D2), in that source order.
Transport actual W2R/W2I/W4R/W4I caller cells from the source-bound context.
Do not use real algebra or an assumed native numeric output to simplify this.

Prove the full body with abstract input/table/constant words once; preserve
all body-local scope restoration and the six-write buffer invariant. Then
induct on k, deriving u+2<hn from u=3*k,k<256. C99SmallLiteral146.update
handles source uint64 updates by signed literals2/3; no new arithmetic rule
is needed. Initial v uses source uint64 cast/left shift by uint32 logn10.
Branch full1 and final false guard remain part of the execution proof.

State-conversion trap: use explicit cell_at state/name/word after heap-only
record updates. Prove write transport for abstract operation kind or abstract
words first; specializing .add prematurely caused deep FPR reduction in002/003.
No limits were raised. Generic pair image/frame helpers are FpcPairBuffer146;
C99TwoWordBuffer146 allows aliased slots and retains original write order.

The optional generic expander failure from145 is retained and unused; direct
source-site equalities suffice. No numeric image is assumed. After tripling,
use FftMiddleContinuation144.body and actual function call/receive; then rt2
and later KeyGen. Whole three-point program ACTIVE under corrected134,
frozen110zero unchanged. One job/Lean, fixed limits,0/0, failures, small main
commits/no push, postseal, no workers/schedules, measured/five do_sign fixed.
