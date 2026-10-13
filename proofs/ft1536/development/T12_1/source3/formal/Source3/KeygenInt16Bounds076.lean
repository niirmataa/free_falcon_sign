import Source3.KeygenInt16Construct076
import Source3.KeygenCodecStaticSmallLength

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Consume the EXISTING source-derived f/g/F/G bounds. Numeric codec
   budgets and NONE carrier are consequences, not new codec assumptions. -/
namespace FT1536.Source3.KeygenInt16Bounds076
open KeygenInt16Vector076 KeygenInt16Representation076
open KeygenCodecStaticLength KeygenCodecStaticCoefficient

theorem coefficient_bound (v : Geometry.Vec) (B : Int) (bound : KeygenIntegerLift.Bound v B) (i : Fin 1536) :
    |coefficient v i|≤B := by
  by_cases low : i.val<768
  · let j : Fin 768 := ⟨i.val,low⟩
    have same : lowIndex j=i := by apply Fin.ext; rfl
    rw [←same,coefficient_low]
    exact (bound j).1
  · let j : Fin 768 := ⟨i.val-768,by have bound:=i.isLt; omega⟩
    have same : highIndex j=i := by apply Fin.ext; dsimp [highIndex,j]; omega
    rw [←same,coefficient_high]
    exact (bound j).2

theorem word_bound (v : Geometry.Vec) (B : Int) (nonnegative : 0≤B) (small : B≤32767)
    (bound : KeygenIntegerLift.Bound v B) (i : Fin 1536) : |(words v i).toInt|≤B := by
  rw [word_integer v (bound_signed v B nonnegative small bound)]
  exact coefficient_bound v B bound i

theorem none_carrier (v : Geometry.Vec) (B : Int) (nonnegative : 0≤B) (small : B≤9216)
    (bound : KeygenIntegerLift.Bound v B) : KeygenDecodeNonePairs.CarrierList (wordList v) := by
  intro input member
  obtain ⟨i,same⟩ := List.mem_ofFn.mp member
  subst input
  have range := abs_le.mp (word_bound v B nonnegative (by omega) bound i)
  unfold KeygenDecodeNoneScalar.Carrier
  constructor <;> omega

theorem magnitude_abs (n : Int) : magnitude n=|n| := by
  unfold magnitude
  by_cases negative : n<0
  · simp only [negative,ite_true,abs_of_neg negative]
  · simp only [negative,ite_false,abs_of_nonneg (by omega : 0≤n)]

theorem low_magnitude (v : Geometry.Vec) (B : Int) (nonnegative : 0≤B) (small : B<256)
    (bound : KeygenIntegerLift.Bound v B) : KeygenCodecStaticSmallLength.LowMagnitude (wordList v) := by
  intro input member
  obtain ⟨i,same⟩ := List.mem_ofFn.mp member
  subst input
  rw [magnitude_abs]
  exact lt_of_le_of_lt (word_bound v B nonnegative (by omega) bound i) small

theorem fg_length (v : Geometry.Vec) (bound : KeygenIntegerLift.Bound v 1) : byteLength (wordList v)=1920 :=
  KeygenCodecStaticSmallLength.small_profile _ (wordList_length v)
    (low_magnitude v 1 (by decide +kernel) (by decide +kernel) bound)

theorem total_upper17 (inputs : List (BitVec 16))
    (cost : ∀ input, input∈inputs → bitCost input≤17) : totalBits inputs≤17*inputs.length := by
  induction inputs with
  | nil => rfl
  | cons input rest ih =>
    have first := cost input (List.mem_cons_self)
    have tail := ih (fun value member => cost value (List.mem_cons_of_mem input member))
    simp only [totalBits,List.length_cons]
    omega

theorem big_length (v : Geometry.Vec) (bound : KeygenIntegerLift.Bound v 2047) : byteLength (wordList v)≤3264 := by
  have total : totalBits (wordList v)≤17*(wordList v).length := by
    apply total_upper17
    intro input member
    obtain ⟨i,same⟩ := List.mem_ofFn.mp member
    subst input
    have magnitudeBound := word_bound v 2047 (by decide +kernel) (by decide +kernel) bound i
    rw [KeygenCodecStaticSmallLength.cost_value,magnitude_abs]
    have positive := abs_nonneg (words v i).toInt
    omega
  rw [wordList_length] at total
  unfold byteLength
  omega

end FT1536.Source3.KeygenInt16Bounds076
