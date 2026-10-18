# Next176: actual make_fg from the selected deepest entry

Verify175 into ENTRY176 and inspect live processes before starting one Lean.
Use SelectedMakeFgEntry175.entry as the actual make_fg state: data is
scratch block31 at word index670, logn10/ter1/depth10/out_ntt0, and f/g
are exactly SelectedSamplerWords158.fValues/gValues. The memory is the
post-public source state; do not substitute an earlier full heap.

First exact obligation:
  KeygenMakeFgSource.Exec (KeygenMakeFgSource.code .make)
    SelectedMakeFgEntry175.entry out
with the original void return. SelectedMakeFgEntry175.source_call then
builds the deepest .make instruction. SelectedDeepestPrefix175.continue_body
combines it with the declarations/configuration/workspace prefix and the
still-required chain [part3,part4].

Pinned C: Extra/c/falcon-keygen.c lines5685–5731.
Existing source split: KeygenMakeFgSource.part .make0/1/2/3.
- Declare n/u, ft/gt/p0/d/primes.
- Compute MKN=1536, ft=data, gt=ft+n, choose PRIMES3, load p0, execute both
  int16→modp_set stores for all1536 coefficients.
- Exclude the depth==0 && out_ntt branch using actual depth10/out_ntt0.
- Execute make_fg_ternary_top with out_ntt true (depth>1), then the original
  make_fg_step loop d=1..9 with exact in/out_ntt controls.
The top and step source definitions already exist; their execution must
be constructed, not supplied as a solver_correct or transform assumption.
Static values, pointer domains and arithmetic callees have existing proofs.

After make_fg: original deepest part3 performs CRT and Bezout;
part4 sets q=18433, checks both zint_mul_small carries and returns1.
Then root search requires intermediate calls, ternary depth0, member gate
and validation. Keep all source return/failure tests. A mathematical
solution or a native candidate does not establish those source executions.

Use balanced finite-map certificates where finite data are necessary;
dense-array kernel reduction was resource-heavy in170. Reuse existing
parametric word/loop/frame proofs and original synthetic seed9 evidence.
Sage calculations remain auxiliary until their kernel/source bindings pass.
Continue certificate/encoding and the emitted-witness consumers134 only
after their premises are actually closed. Numerical acceptance and coding
bounds remain separate and open; measured and five do_sign stay unchanged.
One job111 process, standard limits, retained failures, clean accepted logs,
small local commits, postseal and no push.

Last proof job210 is the full audit. Next unused numeric suffix211.
