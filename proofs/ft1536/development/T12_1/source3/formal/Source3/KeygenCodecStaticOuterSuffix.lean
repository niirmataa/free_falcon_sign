import Source3.KeygenCodecStaticOuterState

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The low suffix of the complete actual normal outer-loop fold.
   No bound on the full uint32 accumulator is introduced. -/
namespace FT1536.Source3.KeygenCodecStaticOuterSuffix
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecStaticIteration KeygenCodecStaticOuterState
open KeygenCodecStaticSuffix (low)

def nextLow (p suffix : Nat) (n : Int) : Nat :=
  KeygenCodecStaticUnaryInvariant.finishLow (KeygenCodecStaticCoefficient.magnitude n/256+1).toNat
    ((p+9)%8) ((suffix*512+(KeygenCodecStaticLow9.packed n).toNat)%2^((p+9)%8))

def suffixFold : List (BitVec 16) → Nat → Nat → Nat
  | [],_,suffix => suffix
  | input::rest,p,suffix => suffixFold rest (nextPending p input.toInt) (nextLow p suffix input.toInt)

theorem next_low (p : Nat) (word : BitVec 32) (n : Int) (small : p<8) :
    low (nextWord p word n) (nextPending p n)=nextLow p (low word p) n := by
  have residue : low ((word <<< 9) ||| KeygenCodecStaticLow9.packed n) ((p+9)%8)=
      low ((word <<< 9) ||| KeygenCodecStaticLow9.packed n) (p+9)%2^((p+9)%8) := by
    unfold low
    rw [Nat.mod_mod_of_dvd _ (Nat.pow_dvd_pow 2 (Nat.mod_le _ _))]
  unfold nextWord nextPending
  rw [←KeygenCodecStaticUnaryInvariant.finish_pending _ ((p+9)%8) _ (Nat.mod_lt _ (by decide +kernel)),
    KeygenCodecStaticUnaryInvariant.finish_low _ ((p+9)%8) _ (Nat.mod_lt _ (by decide +kernel)),residue]
  rw [KeygenCodecStaticSuffix.low_append word (KeygenCodecStaticLow9.packed n) p 9
    (by omega) (KeygenCodecStaticLow9.packed_bound n)]
  rfl

theorem fold_low (inputs : List (BitVec 16)) (p : Nat) (word : BitVec 32) (small : p<8) :
    low (fold inputs p word).2 (fold inputs p word).1=suffixFold inputs p (low word p) := by
  induction inputs generalizing p word with
  | nil => rfl
  | cons input rest ih =>
    rw [fold,suffixFold,ih (nextPending p input.toInt) (nextWord p word input.toInt)
      (Nat.mod_lt _ (by decide +kernel)),next_low p word input.toInt small]

/-- The word, pending count, terminal n0 and suffix are conclusions of
    one and the same complete normal source outer-loop execution. -/
theorem source_low_suffix (args : Args) (s t : State)
    (init : KeygenCodecStaticInit.Initialized args s)
    (source : Exec args KeygenCodecStaticBinding.node102 s t .normal) :
    ∃ inputs : List (BitVec 16), inputs.length=1536 ∧ KeygenCodecStaticOuterControl.Remaining 0 t.locals ∧
      KeygenCodecStaticPending.Cell (fold inputs 0 0).1 t.locals ∧
      KeygenCodecStaticUnaryInvariant.Acc (fold inputs 0 0).2 t.locals ∧
      (fold inputs 0 0).1<8 ∧
      low (fold inputs 0 0).2 (fold inputs 0 0).1=suffixFold inputs 0 0 := by
  obtain ⟨inputs,length,terminal,pending,word⟩ := initialized_state args s t init source
  exact ⟨inputs,length,terminal,pending,word,fold_pending inputs 0 0 (by decide +kernel),
    by simpa only [show low (0 : BitVec 32) 0=0 by decide +kernel] using fold_low inputs 0 0 (by decide +kernel)⟩

end FT1536.Source3.KeygenCodecStaticOuterSuffix
