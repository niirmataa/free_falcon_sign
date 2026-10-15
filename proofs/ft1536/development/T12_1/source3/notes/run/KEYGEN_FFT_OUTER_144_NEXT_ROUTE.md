#144 continuation — source degree tripling, then full first FFT

ACTUAL next reference state: SelectedFftMiddle144.after. It represents
SelectedFftMiddle144.finalValues exactly (nested pure word recurrence,
not a literal numeric heap). All eight original middle outer passes closed;
t3,m512,hn768,n1536,tmin3,full1,logn10. IMPORTANT: actual logn=10, not9.
The erroneous new9 lemma was rejected in008; actual sealed input always had10.
C macro MKN=(1+2*full)<<(logn-full). Tripling starts v=1<<logn=1024.

Existing exports:
- SelectedFftMiddle144.complete_loop_source: original outerLoop from
  reference SelectedFftMiddleStart139.setup to after, including final guard.
- after_context: root pointer base block31,index0,count35840,width8,
  binding, hn cell, write permission, readonly table pins and numeric bounds.
- SelectedFftMiddleContext144: n/minimum/full/logn/cubic_binding plus
  arrays/globals/tables/metadata/outside-byte frame relative to actual v24.
- FftMiddleContinuation144.body: prove Exec of seq tripling(base skip)
  from after to out, obtaining the entire first FFT function body from
  reference SelectedFftFStart138.bound. This is a continuation rule, not
  a completed FFT or KeyGen witness.

Next145: bind the original full branch and tripling loop in
Extra/c/falcon-fft.c lines817-848. full1 makes its condition true. The loop
starts u0,v1024, takes256 iterations with u+=3,v+=2 and stops u768,v1536.
Each iteration reads six buffer words and cubic pair512+k (k0..255),
executes six FPC_MUL, one FPC_SQR, three scalar FPC_ADD and three final
pair-store FPC_ADD macros, writing six positions. Last table word indices
1534/1535; cubic has4096 words. Scope restoration and globals remain exact.

Keep the owner's compression principle: prove the tripling body once for
arbitrary legal indices/words, then induct.140's FPR word functions and
source scalar rules are universal, but its composite MUL/ADD/SUB source
shapes use specific middle-loop variable names. Generalize macro execution
or prove source-bound generic versions; do not assume a renaming theorem
or replay256 long concrete bodies. Reuse full-word invariants and generic
store/byte frames, not just numerical diagnostic images.

FftGroupTwiddle143.lookup is generic over a list. Reuse it for the cubic
source pair lookup; do not normalize the whole parsed table. FftTableWord139
loaded/even/odd supports either table. Actual cubic alias is already proved.
Array width/capacity and all six slot bounds must be derived at the caller.

After the first FFT body closes, use the actual source call binding/receive
to return to the KeyGen caller, then rt2. Prefer a generic first-pass/whole
FFT theorem for rt2 rather than repeating the old768-iteration numerical
certificate series. Source-fast div and later Gram-Schmidt/gate/solver/
certificate/codecs still need the full witness route. Exact numeric image
transport must be proved before using any native snapshot at a gate.

The complete three-point success-mass goal stays ACTIVE under corrected134;
frozen110zero unchanged. No IID/F04/D1 or measurement premise. One job/Lean,
fixed limits,0/0, retained failures, small main commits/no push, postseal,
no workers/schedules, unchanged measured wording and five do_sign items.
All144 evidence is immutable after seal; never print giant dataBlock lines.
