# Actual ternary-top memory prefix177

Status: PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED.
Whole owner goal ACTIVE / NOT_COMPLETE.
Source commits: 2266e504, 241b5bfd, cd50d521, d4ac0145.

SelectedTopPrefix177.source constructs the actual first13 statements of
make_fg_ternary_top at SelectedMakeFgTopEntry176.entry: declarations,
n=1536/dn=1024/tn=512, all six pointer assignments and memmove.
The six scratch word indices are670/1182/1694/3230/4766/5790, in block31,
width4, count71680. The memmove copies12288 bytes from offset2680 to6776;
its source and destination overlap. MemmoveWord177.source constructs the
operation from the full pre-call snapshot, with actual object bounds,
initialization and writability. No disjointness condition is invented.

SelectedTopMove177.f_image and g_image prove that both complete1536-word
converted sampler arrays now reside at fs/gs. The after-memory bytes outside
[6776,19064) remain equal to the pre-call bytes; sizes and writability remain
unchanged. SelectedTopPrefix177 records the actual logn/out_ntt/n/dn/tn
cells. SelectedTopMove177.continue_body composes this proved prefix with
an explicitly required execution of the untouched remaining source body.
It does not assert that the generator, transforms, solver or KeyGen succeed.

Source binding is checked in stages: MakeFgTopBytes177 binds the exact
pinned C lines; Lex177 and Normalize177 prove the actual lexer and sizeof/
type-normalization results; Parse177 proves equality to the original parser;
Shape177 identifies the exact prefix and retains the exact remaining body.
These equations avoid repeating the large parser reduction within kernel
shape comparisons. The two diagnostic modules only serialize syntax/tokens;
their output is not a trusted premise and is excluded from the math count.

All13 mathematical modules /98 named declarations passed full expression
DAG roundtrip and fresh safe kernel checks in audit235, in13 sequential
processes. Only propext/Classical.choice/Quot.sound were allowed.
Every accepted stdout/stderr is empty:0 errors/0 warnings. No new numerical
certificate was needed; finite size and address checks are kernel proofs.
No source C or reference semantics changed, no warning was suppressed, and
no resource limit was raised. No independent review or push occurred.

Jobs226-235 are retained: ten jobs, seven failed or mixed jobs
226/227/228/229/230/232/233. The first two exposed local simplification
issues. The next three exceeded the unchanged kernel memory limit while
reducing the complete parser. Job232 accepted lexer/normalizer/parser
bindings and prefix checking, but shape composition still unfolded the
original parser; explicit transport through the proved normalized parse
resolved this in233. Job233 then exposed only state-alias and pointer-index
transports, corrected in234. The failure ledger preserves exact causes.

ENTRY177 verified61827 inherited paths; SHA256
8bd468101f8d1f351264b166a1cc12c48a152ead887d5c29c54b25d284a4e7c1.
Audit collection SHA256
f9de5428e2bed5a36db470db343fa6433483099a9f6c5ebb6ae620c5878892c8.
Receipt: KEYGEN_TOP_MEMORY_177.json.
Postseal: .build/top177/POSTSEAL_177.json.

| Owner point | Current status | Exact boundary |
| --- | --- | --- |
| Full source seed witness and positive mass | PARTIAL | Source sampler, norms, public computation and root/deepest entry are inherited; make_fg conversion176 and ternary-top memory prefix177 are now closed. No full emitted witness or instantiated positive-mass theorem. |
| Numerical first-attempt acceptance bound | OPEN | No numerical bound, including1/4, is established by this checkpoint. Measurement is not a premise. |
| Conditional coding and quantitative p_K | OPEN | Full source encoding success and concrete positive p_K remain unproved. |

The remaining source obligations are the top scalar initializers/generator/
NTTs/triple products, the nine make_fg_step calls, CRT/Bezout/carry tests,
intermediate/depth0/root validation and certificate/codecs. The emitted
witness target remains corrected KeygenProbability134; old110 stays frozen.
No unconditional Z>0 follows yet. No IID/D1/F04 shortcut or empirical premise
was introduced. The paper retains measured8192/23628 and the separate256/739
control; exactly five do_sign obligations remain unchanged.

The actual ternary-top preparation and overlapping copy are now kernel proved.
The complete solver and emitted packet remain open, so no probability bound is claimed.
The next proof starts at the original prime initializer on the exact copied state.
