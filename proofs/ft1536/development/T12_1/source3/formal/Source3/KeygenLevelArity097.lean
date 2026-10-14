import Source3.KeygenLevelReads097

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenLevelArity097
open C99ArrayReference (State)
open C99ModularArity096 (checkedCode)

theorem forward : checkedCode KeygenNttForwardPrograms.forwardBody = true := by decide
theorem generate : checkedCode KeygenMkgm3Program.code = true := by decide
theorem inverse_size : checkedCode KeygenLevelNtt.sizeCode = true := by decide
theorem inverse_mixed : checkedCode KeygenLevelNtt.mixedCode = true := by decide
theorem inverse0 : checkedCode (KeygenLevelNtt.part 0) = true := by decide
theorem inverse1 : checkedCode (KeygenLevelNtt.part 1) = true := by decide
theorem inverse2 : checkedCode (KeygenLevelNtt.part 2) = true := by decide
theorem inverse3 : checkedCode (KeygenLevelNtt.part 3) = true := by decide
theorem inverse4 : checkedCode (KeygenLevelNtt.part 4) = true := by decide

theorem chain (codes : List C99ModularReference.Stmt) (checked : ∀ code ∈ codes, checkedCode code = true) :
    checkedCode (C99ModularParser.chain codes) = true := by
  induction codes with
  | nil => rfl
  | cons code rest ih => exact Bool.and_eq_true_iff.mpr ⟨checked code (by simp), ih (fun c member => checked c (by simp [member]))⟩

theorem inverse : checkedCode KeygenLevelNtt.inverse = true := by
  apply chain
  intro code member
  simp only [List.mem_cons, List.not_mem_nil, or_false] at member
  rcases member with rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact inverse_size
  · exact inverse_mixed
  · exact inverse0
  · exact inverse1
  · exact inverse2
  · exact inverse3
  · exact inverse4

theorem body (kind : KeygenLevelCalls.Kind) : checkedCode (KeygenLevelCalls.body kind) = true := by
  cases kind
  · exact forward
  · exact inverse
  · exact generate

theorem call_unique (kind : KeygenLevelCalls.Kind) (before a b : State) (args : List KeygenLevelCalls.Arg)
    (checked : KeygenLevelReads097.checkedArgs args = true)
    (first : KeygenLevelCalls.Call kind before args a) (second : KeygenLevelCalls.Call kind before args b) : a = b := by
  cases first with
  | run entry1 out1 binding1 source1 returned1 =>
      cases second with
      | run entry2 out2 binding2 source2 returned2 =>
          have entries := KeygenLevelReads097.parameters before _ args entry1 entry2 checked binding1 binding2
          subst entry2
          have outcomes := C99ModularArity096.execution_unique _ entry1 out1 out2 (body kind) source1 source2
          cases outcomes
          rfl

end FT1536.Source3.KeygenLevelArity097
