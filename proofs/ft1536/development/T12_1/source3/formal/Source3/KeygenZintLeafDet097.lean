import Source3.KeygenBinaryDeterminism097

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenZintLeafDet097
open C99ArrayReference (State)
open C99IntegerReference (Value)
open KeygenZintLeaves

theorem add_checked : KeygenWordArity096.checkedCode (code .add) = true := by decide
theorem sub_checked : KeygenWordArity096.checkedCode (code .sub) = true := by decide
theorem mul_checked : KeygenWordArity096.checkedCode (code .mul) = true := by decide
theorem addMul_checked : KeygenWordArity096.checkedCode (code .addMul) = true := by decide
theorem shift_checked : KeygenWordArity096.checkedCode (code .shift) = true := by decide
theorem reduce_checked : KeygenWordArity096.checkedCode (code .reduce) = true := by decide
theorem compare_checked : KeygenWordArity096.checkedCode (code .compare) = true := by decide

theorem body_checked (kind : Kind) : KeygenWordArity096.checkedCode (code kind) = true := by
  cases kind
  · exact add_checked
  · exact sub_checked
  · exact mul_checked
  · exact addMul_checked
  · exact shift_checked
  · exact reduce_checked
  · exact compare_checked

theorem call_unique (kind : Kind) (before a b : State) (args : List C99ArrayReference.Arg) (x y : Option Value)
    (first : Call kind before args a x) (second : Call kind before args b y) : a = b ∧ x = y := by
  cases first with
  | run entry1 out1 x binding1 source1 returned1 =>
      cases second with
      | run entry2 out2 y binding2 source2 returned2 =>
          have entries := C99ArrayDeterminism089.parameters before _ args entry1 entry2 binding1 binding2
          subst entry2
          have outcomes := KeygenWordArity096.execution _ entry1 out1 out2 (body_checked kind) source1 source2
          cases outcomes
          exact ⟨rfl, C99ProcedureDeterminism094.returned _ _ x y returned1 returned2⟩

end FT1536.Source3.KeygenZintLeafDet097
