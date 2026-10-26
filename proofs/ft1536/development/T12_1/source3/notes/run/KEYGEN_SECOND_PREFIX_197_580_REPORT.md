# R1 intermediate checkpoint 580: actual d=2 lengths, layout and memmove

2026-10-26. **PROVED_KERNEL_SCOPED / NOT_REVIEWED**.
Overall owner goal remains **IN_PROGRESS**; this is an intermediate local
checkpoint, not a final handoff or a context freeze. The owner explicitly
instructed continued work to completion. No push or subagents.

WYKONANE: four proof modules and one original-type/axiom audit.
PRZETESTOWANE: keygen_secondprefix197_580, **5/5 accepted**, exit 0,
diagnostics **0/0**, warningAsError, markers [], no linter suppression.
NIEZALEZNIE ODEBRANE: NOT_RUN / NOT_REVIEWED.

SecondStepLengths197 derives actual Load64 reads of small3[2]=2 and
small3[3]=3 after the complete first step, using the readonly byte/metadata
frame. The row-3 source read is checked in the pinned original finite
memory and transported through the accepted root/first-step frames.
The original ternary length branch executes slen=2, tlen=3 and selects
PRIMES3 at the same concrete second-call entry reached by 579.

SecondStepLayout197 executes every original pointer assignment with
output stride hn*tlen=128*3=384 and input stride n*slen=256*2=512.
All pointers have block31/base0/count71680/width4; indices are:
fd670, gd1054, fs1438, gs1950, gm2462, igm2718, t12974.
These are new d=2 pointers, not the earlier d=1 layout.

SecondStepMove197 constructs the exact original 4096-byte memmove.
Its source consists of all 512 first-step fd words followed by all 512
gd words, derived from job579's complete interleaved images. Destination
fs[0..1023] overlaps the source region; the proof uses the actual snapshot
memmove semantics and does not assume memcpy separation. Allocation,
extent, writability, source initialization and the source byte-count
expression are discharged. The same output has the complete moved fs
and gs 512-word images with the respective original word functions.
The original input region is not claimed unchanged after the overlap.

SecondStepPrefix197 composes the second call's actual parts0/1, including
declarations, n=256, hn=128, length/table branch, seven pointer bindings
and memmove. Its headline source constructs an actual first-step run,
the next six-argument Bind, this full prefix and both moved images without
assuming the target prefix execution or image.

Canonical command:

```sh
python3 -B tools/job111.py lean keygen_secondprefix197_580 \
  Source3.SecondStepLengths197 Source3.SecondStepLayout197 \
  Source3.SecondStepMove197 Source3.SecondStepPrefix197 \
  Source3.SecondStepPrefixAudit197
```

Elapsed sum 23.618s; cumulative child maxRSS 4778704 KiB. Proof stdout/
stderr and audit stderr are empty; audit stdout retains 8 original types
and eleven axiom results, all exactly propext/Classical.choice/Quot.sound.
Limits and bwrap isolation unchanged: -j1/-M6144, maxHeartbeats2000000,
maxRecDepth32768, AS12GiB/RSS8GiB/wall1800s, warningAsError.
No competing process in canonical PREFLIGHT. No Sage computation required:
all new claims are source-execution/word/metadata composition.

ENTRY_PINS 00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673, 0 missing / 0 changed before/after. Job579 evidence bindings
260/260 before/after; no re-baseline or edits to pinned predecessors.
Full pins: KEYGEN_SECOND_PREFIX_197_580.json.

Two failed/partial local attempts among four are retained with all raw
snapshots/receipts/logs in .build/step580 and the FAILURES register:

- attempt001: unchanged-limit isDefEq timeouts at the withS→t_source
  memory boundary and final heap change, total287.102s. Static/readonly
  read lemmas compiled. Explicit withS heap/read/array/cell bridges and
  abstract pointer-heap projection repair it; accepted lengths9.485s.
- attempt003: input image proof leaves old/new fd aliases opaque under
  simpa only. Normalize both aliases to the same ft pointer. No arithmetic
  or semantic change; attempt004 accepts all five modules.

Attempts002/004 accepted, logs0/0. No mathematical counterexample, raised
limit, failed canonical lane job or failed lane cache product. Historical
65+58+4, bodyHeap finding and all 575–579 retained registers are unchanged.

Continue immediately with suffix581: the d=2 prime-loop/generator/NTT
and multi-limb reduction/CRT obligations. The new pointer/moved-image
exports are the concrete input; no loop result is assumed. Later d levels,
root/certificate/codec, closed-form NTT/root/table laws, compiler correctness,
full KeyGen/Sign and unconditional Z>0/p_accept/p_K/Z>=2^-256 remain OPEN.
Old110, measured wording and five do_sign obligations are unchanged.
No stages import, migration, production C edit or independent acceptance.
Foreign run2 pin-reference and threshold prompt remain untouched.
Ten waiting commits plus this local checkpoint = eleven, without push.
