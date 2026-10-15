#143 continuation — original outer-pass setup and induction

Actual endpoint is still SelectedFftOuterControl142.after: t384,m4,n1536,
hn768,tmin3, original array/table bindings and readonly pins; exact symbolic
input image SelectedFftLoop141.finalValues. No later actual pass is claimed.
Read142_NEXT_ROUTE for exact frames and scope-restored locals.

New universal tools:
- FftGroupExec143.Entry(s,m,u,start,ht): typed m/u1/v1/ht, m+u<1024,
  start+ht<2^64, actual square-table array alias and pinned memory.
- FftGroupSource143.source: original whole group body, ht butterflies,
  exact vector recurrence and full-local/metadata/outside-buffer frame.
- FftGroupsInvariant143.Fixed(s,base,n,hn,m,t,ht,hm): width8,capacity,
  2*hn<=n,t=ht+ht,hm*t<=hn,m+hm<=1024,n<2^64; actual a/table bindings,
  m/t/ht/hm/hn cells, permission and readonly table pins.
- FftGroupsInduction143.source: original whole group loop from u<=hm,
  u1=u,v1=u*t and represented input; output u1=hm,v1=hm*t and exact
  FftGroupsInduction143.values(...,hm-u,u,input), plus Fixed and frame.

Next144: prove outer declarations ht/hm/u1/v1, source right shifts
ht=t>>1,hm=m>>1 and for-clause initializers u1=0,v1=0 generically. The
statement assignments use array-language .assign with scalar expression;
for-clause assignments use .base(.scalar(.assign...)). Do not conflate them.
C99ControlShift142 has source unsigned left shifts; add a source-correct
right-shift lemma and derive actual ht/hm from natural divisibility/ranges.
Instantiate143 with next t384,m4,ht192,hm2. Original outer composition is
FftReferenceCompose141.outer, t assignment via C99ControlCells142.array_copy,
m increment via C99ControlShift142.double. Restore scope before m update.

Prefer one parametric outer-step theorem and induction over all remaining
seven passes; do not launch a per-group/per-butterfly certificate series.
Arithmetic invariant m*t=1536 with even t/m derives hm*t=768 and pointer
bounds; stop t3,m512. A finite schedule control is not a source theorem.
Transport arbitrary other locals through group Frame before outer scope
restoration. Preserve table bindings and readonly pin theorem.

Large-table lesson: prove list getD lookup abstractly, instantiate afterward.
Never normalize the complete parsed table in a kernel rfl. Avoid expanding
symbolic FPR formulas when equating states; abstract output words first.
Expose local let aliases and record heap projections before restricted simp.
No printed megabyte generated dataBlock lines; no increased limits.

The route to an exact numeric snapshot must later be proved, not assumed
from native C controls. Source-fast div, tripling,rt2 FFT and later keygen
steps remain open. Full three-point success-mass goal is ACTIVE under the
explicit corrected134 law; old110zero is unchanged. One worker/job,0/0,
all failures, small local main commits/no push, postseal, no schedules,
measured and five do_sign items fixed. All143 sealed files are immutable.
