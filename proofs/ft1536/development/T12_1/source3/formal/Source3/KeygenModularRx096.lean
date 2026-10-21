import Source3.C99ModularLocalAgreement096
import Source3.KeygenModularLeaf096

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenModularRx096
open C99ArrayReference (State Name)
open C99IntegerReference (Value)
open C99ExpressionEnvironment (Agree)
open C99ModularReference

def names : List Name := ["x", "p", "p0i", "R2"].map String.toList

/-- The actual loop/body is read-set closed after its real declarations
    (i, then r/z), the same discipline as the div body. -/
theorem checked : C99ModularLocalAgreement096.checkedCode names rxCode = true := by decide

theorem parameters_agree (s t : State) (a b c d : Value) :
    Agree (bindParams s rxParams [a, b, c, d]).locals
      (bindParams t rxParams [a, b, c, d]).locals names := by
  intro name member
  change name ∈ ["x".toList, "p".toList, "p0i".toList, "R2".toList] at member
  simp only [List.mem_cons, List.not_mem_nil, or_false] at member
  rcases member with rfl | rfl | rfl | rfl
  all_goals simp [bindParams, rxParams, C99ArrayReference.bindValue, C99ScalarReference.set]

/-- The actual four-argument modp_Rx body has a unique returned word even
    though its source relation existentially permits arbitrary base states.
    No Montgomery law, loop invariant or totality is used. -/
theorem source_unique (a b c d x y : Value)
    (first : rxBody [a, b, c, d] x) (second : rxBody [a, b, c, d] y) : x = y := by
  obtain ⟨base1, after1, body1⟩ := first
  obtain ⟨base2, after2, body2⟩ := second
  have same := C99ModularLocalAgreement096.execution LeafCall KeygenModularLeaf096.leaf_calls
    names rxCode _ _ _ _ checked (parameters_agree base1 base2 a b c d) body1 body2
  exact Option.some.inj (C99ProcedureReference.Flow.returned.inj same.1)

end FT1536.Source3.KeygenModularRx096
