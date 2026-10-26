# R1 complete second-step CRT section — checkpoint 591

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber work
remains IN_PROGRESS; continue after this intermediate local checkpoint.

The no-premise source export now constructs the actual d2 prefix through
part3, including both complete original rebuildCRT calls for fs and gs.
Each call executes xlen2/num256 declarations, initial tmp[0] store from the
actual first prime-table row, row1 co-reduction, both modulus limb writes
and signed normalization. Both full512-word normalized fs/gs images and all
four128-word fd/gd product columns belong to the same final output. Earlier
products survive both CRT calls, and the first normalized array survives
the second call. Caller cells/arrays and the concrete outer domains remain
available for the additional-prime continuation.

No successful execution, desired CRT result or caller memory image is a
premise of the headline theorem. The587 input images, readonly PRIMES3
object, allocation/capacity and separation domains are discharged along
the constructed prefix. An old initialized tmp word is not required: the
actual source store creates it. Generic engines cover the complete original
seven-argument CRT call/body and the normalization walk for any bounded
coefficient count and positive bounded limb stride, with flat images,
terminal counters/pointers, modulus preservation and outside-read keeps.
The final formulas describe executed words, including normalization branch
choice,31-bit limb masks and source borrow/carry behavior.

Canonical keygen_secondcrt208_591 accepted14/14, exit0, diagnostics0/0,
warningAsError, markers/suppressions0. Lean time44.842s; maximum cumulative
child RSS3802316 KiB. Six original interfaces and42 axiom results checked;
only propext, Classical.choice and Quot.sound or subsets. Original limits
unchanged. Independent review NOT_RUN.

Thirteen local attempts retain two failures: an unused positive hypothesis
in a row-index geometry lemma (the limb bounds already implied it), and a
reserved prefix theorem name. The redundant hypothesis was removed from
the geometry statement, strengthening it; the real positive-stride walk
domain remains. These are syntax/clean-log failures, not mathematical
counterexamples or resource failures. No suppression or failed cache
product occurred. All raw logs/snapshots and inherited findings remain.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after, zero missing/changed. All246 predecessor590
bindings verified before/after. Python organizes jobs/hashes only. No
re-baseline, production C change, migration, stages, reviewer start or push.

Next592: generic multi-limb unsigned/signed reduction, followed by the actual
additional-prime Rx/generator/lower-size forward/products and full d2 return.
Later d levels/root/certificate/codec and full B1 stay open. No mathematical
CRT, centered-representative, NTT or root law is claimed. Full KeyGen/Sign/
compiler/security and unconditional positivity/probability remain open;
Old110/measured/five do_sign retain their previous scope.
