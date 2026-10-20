import Source3.C99CountedWords
import Source3.KeygenSmallOutput

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Source scalar gate/store value of the MODE1 sampler. No distribution or
   RNG assumption is used. The enclosing sampler loop must supply this
   executed comparison, cast/subtraction and actual store. -/
namespace FT1536.Source3.KeygenTernaryBound
open C99IntegerReference

theorem source_branch : (Pinned.keygenLines.drop 4775).take 4 =
    ["\t\t\tif (x < 3U) {\n","\t\t\t\tv[u] = (int16_t)((int)x - 1);\n",
     "\t\t\t\tbreak;\n","\t\t\t}\n"] := by decide

theorem source_gate (x : BitVec 32) (value : Value)
    (source : CompareExec .lt (.uint32 x) (.uint32 3) value) (accepted : value.integer≠0) : x.toNat<3 := by
  have he := C99CountedWords.comparison_result .lt (.uint32 x) (.uint32 3) value source
  change value=C99ScalarReference.boolean
    (compare .lt (convert (Value.uint32 x).type (Value.uint32 x).integer).integer 3) at he
  rw [C99CountedWords.convert_self] at he
  by_contra outside
  have hnot : ¬(x.toNat : Int)<3 := by omega
  rw [he] at accepted
  simp [C99IntegerReference.compare,Value.integer,hnot,C99ScalarReference.boolean] at accepted

theorem trit_cases (x : BitVec 32) (bound : x.toNat<3) : x=0 ∨ x=1 ∨ x=2 := by
  have h : x.toNat=0 ∨ x.toNat=1 ∨ x.toNat=2 := by omega
  rcases h with h | h | h
  · left; exact BitVec.eq_of_toNat_eq h
  · right; left; exact BitVec.eq_of_toNat_eq h
  · right; right; exact BitVec.eq_of_toNat_eq h

theorem source_coefficient (x : BitVec 32) (value : Value) (bound : x.toNat<3)
    (source : ArithmeticExec .minus (convert .int32 (Value.uint32 x).integer) (.int32 1) value) :
    -1≤value.integer ∧ value.integer≤1 := by
  rcases trit_cases x bound with rfl | rfl | rfl
  all_goals
    have he := ((arithmetic_iff _ _ _ _).mp source).2
    subst value
    constructor <;> decide

theorem stored_integer (x : BitVec 32) (value gate : Value)
    (condition : CompareExec .lt (.uint32 x) (.uint32 3) gate) (accepted : gate.integer≠0)
    (source : ArithmeticExec .minus (convert .int32 (Value.uint32 x).integer) (.int32 1) value) :
    (BitVec.ofInt 16 value.integer).toInt=value.integer ∧ -1≤value.integer ∧ value.integer≤1 := by
  have bounds := source_coefficient x value (source_gate x gate condition accepted) source
  exact ⟨KeygenSmallOutput.narrowed_exact value.integer (by dsimp [KeygenSmallOutput.accepted]; omega),bounds⟩

end FT1536.Source3.KeygenTernaryBound
