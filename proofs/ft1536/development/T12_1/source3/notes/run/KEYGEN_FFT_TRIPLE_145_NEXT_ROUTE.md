#145 continuation — ADD variants, generic tripling body, then loop

Actual endpoint still SelectedFftMiddle144.after, with exact symbolic image
SelectedFftMiddle144.finalValues. t3,m512,n1536,hn768,full1,logn10. No new
actual tripling iteration has executed in145. Branch full1 and initialization
u0/v1024 must still be source-proved. Loop256 steps: u+=3,v+=2, endsu768/v1536.

Reusable proved macro exports:
- FpcMulClosed145.source: arbitrary names/words, exact local MUL, typed
  Entry, declared outputs, noncollision with macro temps, distinct outputs.
- FftTripleCalls145.mul i: six ORIGINAL source parts12/13/14,16/17/18;
  only input typed cells and output declaration witnesses remain arguments.
- FpcSqrClosed145.source: arbitrary-name in-place square, exact original
  sqr/sub/mul/double order. FftTripleCalls145.square binds source part15
  xr/xi and only needs its two incoming typed word cells.
- All these preserve heap and all caller locals except specified outputs;
  temporary scopes are restored. Do not equate SQR with MUL by real algebra.

FftTripleShape145 exposes code/yes/parts/initial/loop/loopBody/statements/part,
branch test full, loop test u<hn and original increments. Its part order:
0..3 local declarations;4..9 six input array loads;10/11 cubic xr/xi loads;
12..14 B multiplications;15 square xr/xi;16..18 C multiplications;
19 B0+=C0;20 B1+=C2;21 B2+=C1;
22/23/24 final ADD pair stores at u,u+1,u+2 and their +hn imaginary slots.

Next146: derive generic local in-place ADD and generic ADD pair-store rules
for these exact six sites.140 pair-store helpers have fixed middle-loop
input names; generalize or bind them explicitly, not by assumed renaming.
Use145's macro strategy: derive caller-cell values, source arithmetic once,
ordered writes, then restore scope. Six buffer slots require u+2<hn; derive
this from u=3*k,k<256,hn768. Cubic pair is512+k (word indicesv,v+1 with
v=1024+2*k); last words1534/1535. Reuse FftTableWord139 and the abstract
FftGroupTwiddle143.lookup for cubic, avoiding whole-table normalization.

After six input loads and two cubic loads, compose MUL/SQR/ADD in the exact
source order and expose six updated buffer words. Prove buffer/frame once,
then induct over256 iterations. Source increments add signed literals3/2
to uint64 controls; derive original mixed arithmetic, not assumed counters.
Constants fpr_W2R/W2I/W4R/W4I are actual caller locals and globals; transport
their values from the source-bound context before use. Heap remains untouched
until final pair stores. Preserve full scope and original final false guard.

Optional generic FpcMulBinding145 was unaccepted and archived in
.build/ffttriple145/rejected_source, NOT a dependency. Direct six-site
mul_shape is sufficient and accepted. C99MapMIndex145/ C99MacroExpand145
are proved abstract helpers only. Do not repeat expensive generic expansion
reduction or claim that optional equality was proved. Failed002/003/006/008
retain the resource history; no limits were increased.

Full first FFT then returns through its actual call binding/receive; rt2 and
later KeyGen remain. No native numeric snapshot premise; future literal-image
checks require a proved equality to the symbolic recurrence. Whole success-
mass program stays ACTIVE under corrected134, frozen110zero unchanged.
One job/Lean,0/0,fixed limits, all failures, small commits/no push, postseal,
no workers/schedules, measured paper and exactly five do_sign items fixed.
