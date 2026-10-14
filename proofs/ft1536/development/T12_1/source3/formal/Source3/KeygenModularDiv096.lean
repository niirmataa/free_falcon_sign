import Source3.C99ModularLocalAgreement096

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenModularDiv096
open C99ArrayReference (State Name)
open C99IntegerReference (Value)
open C99ExpressionEnvironment (Agree)
open C99ModularReference

def names : List Name := ["a", "b", "p", "p0i", "R"].map String.toList

/-- The actual loop/body is read-set closed after its real declarations,
    including the scoped z2 declaration on every iteration. -/
theorem checked : C99ModularLocalAgreement096.checkedCode names divCode = true := by decide

theorem parameters_agree (s t : State) (a b p p0i r : Value) :
    Agree (bindParams s divParams [a, b, p, p0i, r]).locals
      (bindParams t divParams [a, b, p, p0i, r]).locals names := by
  intro name member
  change name ∈ ["a".toList, "b".toList, "p".toList, "p0i".toList, "R".toList] at member
  simp only [List.mem_cons, List.not_mem_nil, or_false] at member
  rcases member with rfl | rfl | rfl | rfl | rfl
  all_goals simp [bindParams, divParams, C99ArrayReference.bindValue, C99ScalarReference.set]

/-- The actual five-argument div body has a unique returned word even
    though its source relation existentially permits arbitrary base states.
    No primality, arithmetic division specification, or totality is used. -/
theorem source_unique (a b p p0i r x y : Value)
    (first : divBody [a, b, p, p0i, r] x) (second : divBody [a, b, p, p0i, r] y) : x = y := by
  obtain ⟨base1, after1, body1⟩ := first
  obtain ⟨base2, after2, body2⟩ := second
  have same := C99ModularLocalAgreement096.execution LeafCall KeygenModularLeaf096.leaf_calls
    names divCode _ _ _ _ checked (parameters_agree base1 base2 a b p p0i r) body1 body2
  exact Option.some.inj (C99ProcedureReference.Flow.returned.inj same.1)

end FT1536.Source3.KeygenModularDiv096
