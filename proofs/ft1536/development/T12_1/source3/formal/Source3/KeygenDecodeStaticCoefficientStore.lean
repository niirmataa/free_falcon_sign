import Source3.KeygenDecodeStaticMagnitude
import Source3.KeygenDecodeStaticSigned

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Actual source sign branch and physical SAME-word int16 store, including
   promoted negation of the -32768 endpoint and arbitrary old destination. -/
namespace FT1536.Source3.KeygenDecodeStaticCoefficientStore
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeStaticReady KeygenDecodeStaticCertified KeygenCodecStaticBitInverse

def magnitudeWord (input : BitVec 16) : BitVec 16 := BitVec.ofNat 16 (magnitude input)
def after (s : State) (ptr : ArrayPointer) (input : BitVec 16) : State :=
  ⟨KeygenDecodeWrite16.overwrite s.heap ptr input,s.locals,s.buf⟩

theorem recovered (input : BitVec 16) :
    (if sign input then -magnitudeWord input else magnitudeWord input)=input := by
  have original := congrArg (BitVec.ofInt 16) (signed_magnitude input)
  rw [BitVec.ofInt_toInt] at original
  by_cases yes : sign input=true
  · simpa only [yes,ite_true,BitVec.ofInt_neg,BitVec.ofInt_natCast,magnitudeWord] using original
  · simpa only [yes,Bool.false_eq_true,ite_false,BitVec.ofInt_natCast,magnitudeWord] using original

theorem source_store (args : Args) (s : State) (u : Nat) (dst atWord : ArrayPointer) (input : BitVec 16)
    (cursor : Cell "u" .uint64 (.uint64 (BitVec.ofNat 64 u)) s.locals)
    (signCell : Cell "sign" .uint32 (.uint32 (BitVec.ofNat 32 (sign input).toNat)) s.locals)
    (low : Cell "lo" .uint32 (.uint32 (BitVec.ofNat 32 (magnitude input))) s.locals)
    (held : s.locals.x=some dst) (advance : PointerAdd dst u atWord)
    (allocated : Allocated s.heap atWord) (width : atWord.elementBytes=2)
    (writable : s.heap.writable atWord.block=true) :
    Checked args KeygenDecodeStaticBinding.node085 s (after s atWord input) .normal ∧
      Store16 s.heap atWord input (after s atWord input).heap := by
  have boundU : u<2^64 := by
    cases advance
    have inbounds := allocated.2.2.1
    have extent := allocated.2.2.2.1
    have finite := allocated.2.2.2.2
    have positive := allocated.1
    dsimp only at inbounds extent finite positive
    have countBound : dst.count≤dst.base+dst.elementBytes*dst.count := by
      have mul := Nat.le_mul_of_pos_left dst.count positive
      omega
    omega
  have indexCalc : KeygenDecodeCalculation.Computes args s.heap s.buf s.locals (.variable "u".toList)
      (.uint64 (BitVec.ofNat 64 u)) :=
    .scalar _ _ _ (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) cursor
  have atIndex : PointerAdd dst (C99IntegerReference.Value.uint64 (BitVec.ofNat 64 u)).integer.toNat atWord := by
    rw [KeygenCodecNoneCursor.unsigned_nat64 u boundU]
    exact advance
  have nonnegative : 0≤(C99IntegerReference.Value.uint64 (BitVec.ofNat 64 u)).integer := by
    rw [KeygenCodecNoneCursor.unsigned_nat64 u boundU]; omega
  have signCalc : KeygenDecodeCalculation.Computes args s.heap s.buf s.locals KeygenDecodeStaticBinding.guard085
      (.uint32 (BitVec.ofNat 32 (sign input).toNat)) :=
    .scalar _ _ _ (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) signCell
  have same : withLocals s s.locals=s := by cases s; rfl
  have original := recovered input
  have full : Checked args KeygenDecodeStaticBinding.node085 s (after s atWord input) .normal := by
    by_cases negative : sign input=true
    · have stored : BitVec.ofInt 16 (KeygenDecodeStaticSigned.negated (magnitudeWord input)).integer=input := by
        rw [KeygenDecodeStaticSigned.negative_store]
        simpa only [negative,ite_true] using original
      have raw := KeygenDecodeStaticCertifiedStore.store args s (.variable "u".toList)
        (.unary .neg (.cast .i16 (.variable "lo".toList))) s.locals s.locals dst atWord _
        (KeygenDecodeStaticSigned.negated (magnitudeWord input)) held (.pure _ _ _ indexCalc) nonnegative atIndex
        (.pure _ _ _ (KeygenDecodeStaticSigned.negative_calculation args s (magnitude input) (magnitude_bound input) low))
        allocated width writable
      rw [stored] at raw
      have store : Checked args KeygenDecodeStaticBinding.node077 s (after s atWord input) .normal := raw
      have inside : Checked args KeygenDecodeStaticBinding.node079 s (after s atWord input) .normal :=
        seq args _ _ s (after s atWord input) (after s atWord input) .normal store (skip args _)
      have wrapped : Checked args KeygenDecodeStaticBinding.node080 s (after s atWord input) .normal := by
        have source := scope args KeygenDecodeStaticBinding.node079 s (after s atWord input) .normal (by intro impossible; cases impossible) inside
        rw [empty_scope _ _ _ rfl] at source
        exact source
      exact branch_true args KeygenDecodeStaticBinding.guard085 KeygenDecodeStaticBinding.node080 KeygenDecodeStaticBinding.node084
        s (after s atWord input) .normal _ s.locals (.pure _ _ _ signCalc)
        (by rw [negative]; decide +kernel) (by rw [same]; exact wrapped)
    · have stored : BitVec.ofInt 16 (KeygenDecodeStaticSigned.narrow (magnitudeWord input)).integer=input := by
        rw [KeygenDecodeStaticSigned.positive_store]
        simpa only [negative,Bool.false_eq_true,ite_false] using original
      have raw := KeygenDecodeStaticCertifiedStore.store args s (.variable "u".toList)
        (.cast .i16 (.variable "lo".toList)) s.locals s.locals dst atWord _
        (KeygenDecodeStaticSigned.narrow (magnitudeWord input)) held (.pure _ _ _ indexCalc) nonnegative atIndex
        (.pure _ _ _ (KeygenDecodeStaticSigned.positive_calculation args s (magnitude input) (magnitude_bound input) low))
        allocated width writable
      rw [stored] at raw
      have store : Checked args KeygenDecodeStaticBinding.node081 s (after s atWord input) .normal := raw
      have inside : Checked args KeygenDecodeStaticBinding.node083 s (after s atWord input) .normal :=
        seq args _ _ s (after s atWord input) (after s atWord input) .normal store (skip args _)
      have wrapped : Checked args KeygenDecodeStaticBinding.node084 s (after s atWord input) .normal := by
        have source := scope args KeygenDecodeStaticBinding.node083 s (after s atWord input) .normal (by intro impossible; cases impossible) inside
        rw [empty_scope _ _ _ rfl] at source
        exact source
      have zero : sign input=false := Bool.eq_false_iff.mpr negative
      exact branch_false args KeygenDecodeStaticBinding.guard085 KeygenDecodeStaticBinding.node080 KeygenDecodeStaticBinding.node084
        s (after s atWord input) .normal _ s.locals (.pure _ _ _ signCalc)
        (by rw [zero]; decide +kernel) (by rw [same]; exact wrapped)
  exact ⟨full,KeygenDecodeWrite16.exists_store _ _ _ allocated width writable⟩

end FT1536.Source3.KeygenDecodeStaticCoefficientStore
