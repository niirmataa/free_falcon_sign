# Next: kernel numerical image certificates

Verify152 into ENTRY_PINS. No source loop replay: actual endpoint stays
SelectedRawNorm151.after; numerical gate remains OPEN.

Use SelectedFftImages152.{f_source,g_source,norm_source,obligation}.
They preserve the exact original numerical target while eliminating
per-word replay of all earlier updates within a pass. Middle recurrence
is only7/8 pass boundaries; certify each boundary to avoid recomputing
all earlier literal arithmetic under every later output.

Candidate source: .build/jobs/keygen_fftvalues152_009/FFT152_CANDIDATES.json
SHA3e9da927968cec19503661809c41af3402da104bfad29c2f041e59204b24d891.
Each f/g dictionary has input,first,middle0_at24,middle0..7,triple.
Norm proposal4704131856579166192; bound4737176763271429578. All are
Sage/native CONTROL values until the exact Lean equality is proved.

Suggested certificate order:
1. SelectedFftBuffer141.values = f.middle0_at24 and
   SelectedFftGInput148.values = g.input, from the actual pinned captured
   initialized byte trees. Do not assume these equalities from matching C.
2. fFirstGroup = f.middle0 via FftGroupValues152.pointwise for360
   iterations at24; gFirst = g.first via FftFirstClosed152.source.
3. Seven/eight FftOuterValues152.image boundaries against middle vectors.
4. FftTriplingValues152.image against final vectors.
5. Ordered norm-word accumulator151 and exact original comparator.

Use a shared finite vector/chunk checker with a proved correctness lemma;
generate only data and kernel computations. Begin with a bounded chunk
to measure existing limits; no native_decide, higher limits or new premises.
Reuse finite first-pass operation cases if repeated ternary inputs inflate
computation. Raw compare is C99CompareObjects/FprCompare.spec, not a host
float comparison. Explicitly retain every failed job and its source.

All152 sealed artifacts immutable.73 declarations/21 audit processes,
failures001/003/005/007 preserved,0/0 accepted logs. Full witness and
positive mass bounds remain open under corrected134; five do_sign and
measured wording unchanged. No push/new worker/schedule.
