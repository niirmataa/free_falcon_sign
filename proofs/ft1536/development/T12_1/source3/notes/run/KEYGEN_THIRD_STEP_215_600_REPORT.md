# R1 d=3 level entry, lengths and layout/move prefix with real proofs — checkpoint 600

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall B1 is IN_PROGRESS.
Owner decision 2026-10-27: Source3 modules are produced with real proofs,
zero markers, or not at all; scratch stays in .build. Window 600 closes
the third make_fg_step call of the make_fg d loop (the d=3 level entry
and complete layout/move prefix). The window name "further d levels and
layouts" from WORK_STATE/report 599 is advanced by this first further
level; the d=3 body and levels d=4..9 follow in later windows.

The third call executes at the actual loop counter d=3, after the
accepted SecondStepReturn212 second-step return, the counted d=2→3
increment and the taken next guard d<depth. Its parameter words are the
executed argument words of the original call statement: data=ft,
logn=logn-d=10-3=7, depth=d=3, ter=1, in_ntt=1 and
out_ntt=((d+1)<depth || out_ntt)=(4<10)=1 (the source disjunct is
evaluated, not assumed). ThirdStepEntry215 binds those words into the
fresh callee scope and preserves both 384-word input images of the d=2
output rows at the entry heap.

The level prefix executes the original declarations, the n/hn
assignments n=2^7=128, hn=64, the ter branch and the actual table
reads: slen=MAX_BL_SMALL3[depth=3]=3 and tlen=MAX_BL_SMALL3[4]=6 from
Load64 reads of the real MAX_BL_SMALL3 object (the index-4 read with
value 6 is new and kernel checked; index 3 is reused from the sealed
d=2 work). The seven pointer binds then build the actual d=3 layout:
fd=data=ft at index 670, gd=fd+hn*tlen=fd+384 (1054), fs=gd+384
(1438), gs=fs+n*slen=fs+384 (1822), gm=gs+384 (2206), igm=gm+n
(2334), t1=igm+n (2462). The overlapping memmove copies 2*n*slen=768
words (3072 bytes) from data to fs exactly as the source statement
prescribes; its executed-word input image is the accepted d=2 output
image (the 384 fWords at fd and the 384 gWords at gd), and the moved
fs/gs rows carry the same words with all outside reads preserved. The
composed part-0/part-1 run reaches the post-move state with both moved
384-word images; the concrete source theorem chains this prefix from
the accepted second step with composed heap stability, the table
bindings and the new table reads.

Executed: 7 modules. Validated: canonical keygen_thirdstep215_600
accepted 7/7, exit 0, diagnostics 0/0, warningAsError; ten checked
public interfaces and 14 axiom results using only propext/
Classical.choice/Quot.sound. Lean time 36.331s; maximum cumulative
child RSS 4839124 KiB. Original limits and internal network isolation
unchanged (bwrap --unshare-net, -j1, -M6144). Independent review:
NOT_RUN.

Ten local attempts retain six failures: 001 arithmetic-step operand
values transcribed as uint64 instead of the evaluated uint32 pairs and
a missing Exec open; 002 an opaque have-name for the advance state
hiding defeq in the data/logn/depth transports; 004 the generic-state
table bindings not reducible to the closed entry term (promoted to
explicit hypotheses, discharged by the concrete source); 006 an extra
closing parenthesis in count_source and elem/element defeq conversions
refused inside simpa-using; 007 simpa-using placed in term context
(parse failures) and 008 the residual parenthesis. No mathematical
counterexample, resource failure, suppression or failed lane-cache
artifact occurred. Every raw snapshot/log remains retained under
.build/jobs/keygen_dlevel600_*; the permanent 195 bodyHeap/stepState
defect remains unused; sealed predecessors and original syntax
bindings are unchanged.

Traps recorded for later windows: (1) a generic-state parameter cannot
reduce caller table bindings (MAX_BL_SMALL3/PRIMES3) to the closed
entry term — pass them as hypotheses and discharge at the concrete
chain state; (2) the C99IntegerReference.ArithmeticExec.step operands
are the evaluated value words (.uint32 pairs for uint32 cells), not
uint64 casts; (3) simpa-using refuses the StepCopyBody190.elem vs
KeygenSmallOutput.element delta conversion in its final step — use
explicit rfl bridges (load_elem/load_element) instead.

ENTRY_PINS 00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; predecessor 599 evidence 113/113
and predecessor 597 evidence 133/133 bindings verified before and
after the first and the last 600 proof job. Fresh entry/predecessor
checks completed before the first proof job and again after the
canonical replay. Python handles scaffolding/jobs/hashes; all source
arithmetic/execution is kernel checked. No re-baseline, production C
change, migration, stages, reviewer start or push (four commits were
waiting at entry and this checkpoint is a fifth). This checkpoint is a
local source commit, not an independent acceptance of the overall
package.

Not proved and not implied: no part of the d=3 body (first-prime
marches, generator, CRT walk, additional primes u=3..5, products) is
executed; the moved rows are consumed by nothing yet. No mathematical
CRT/centering/Montgomery/integer/NTT/root/table law, no desired
output, certificate or equation claim. Levels d=4..9 of the d loop,
the full d=3 body, root/certificate/codec and full B1 remain open.
Full KeyGen/Sign/compiler/security and unconditional
positivity/probability remain open. Old110/measured/five do_sign keep
their previous scope. WORK_STATE records the exact next proof route
(d=3 body first-prime layer); no push was made.
