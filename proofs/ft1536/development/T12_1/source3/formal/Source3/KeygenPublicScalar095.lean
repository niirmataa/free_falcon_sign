import Source3.C99ModularDeterminism095

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicScalar095
open C99IntegerReference (Value)
open C99ScalarDeterminism089 (Deterministic)
open KeygenPublicScalar

theorem name_eq (a b : Kind) : name a = name b ↔ a = b := by
  cases a <;> cases b <;> decide

theorem name_injective : Function.Injective name := fun a b equal => (name_eq a b).mp equal

theorem body_unique (calls : C99ModularReference.CallRelation) (deterministic : Deterministic calls)
    (kind : Kind) (args : List Value) (a b : Value) (first : Body calls kind args a) (second : Body calls kind args b) : a = b := by
  obtain ⟨_, out1, code1, returned1⟩ := first
  obtain ⟨_, out2, code2, returned2⟩ := second
  have same := C99ModularDeterminism095.execution calls deterministic _ _ out1 out2 code1 code2
  subst out2
  exact Option.some.inj (C99ProcedureDeterminism094.returned _ _ _ _ returned1 returned2)

theorem no_calls : Deterministic (fun _ _ _ => False) := by
  intro name args a b impossible
  exact impossible.elim

theorem leaf_name (n : C99ArrayReference.Name) (args : List Value) (v : Value) (source : Leaf n args v) :
    n ∈ [name .conv, name .add, name .sub, name .half, name .mul, name .rev] := by
  cases source with
  | run kind args v leaf source =>
      cases kind <;> simp_all [IsLeaf]

theorem leaf : Deterministic Leaf := by
  intro n args a b first second
  have invert : ∀ v, Leaf n args v → ∃ kind, name kind = n ∧ Body (fun _ _ _ => False) kind args v := by
    intro v source
    cases source with
    | run kind args v allowed body => exact ⟨kind, rfl, body⟩
  obtain ⟨ka, na, bodyA⟩ := invert a first
  obtain ⟨kb, nb, bodyB⟩ := invert b second
  have same := name_injective (na.trans nb.symm)
  subst kb
  exact body_unique _ no_calls ka args a b bodyA bodyB

theorem square_name (n : C99ArrayReference.Name) (args : List Value) (v : Value) (source : Square n args v) :
    n ∈ [name .conv, name .add, name .sub, name .half, name .mul, name .rev, name .square] := by
  cases source with
  | leaf n args v source => have member := leaf_name n args v source; simp_all only [List.mem_cons]; tauto
  | square => simp

theorem square : Deterministic Square := by
  intro n args a b first second
  have invert : ∀ v, Square n args v → Leaf n args v ∨ n = name .square ∧ Body Leaf .square args v := by
    intro v source
    cases source with
    | leaf n args v source => exact Or.inl source
    | square args v source => exact Or.inr ⟨rfl, source⟩
  rcases invert a first with la | ⟨na, sa⟩
  · rcases invert b second with lb | ⟨nb, sb⟩
    · exact leaf n args a b la lb
    · have impossible := leaf_name n args a la
      rw [nb] at impossible
      simp [name] at impossible
  · rcases invert b second with lb | ⟨nb, sb⟩
    · have impossible := leaf_name n args b lb
      rw [na] at impossible
      simp [name] at impossible
    · exact body_unique _ leaf .square args a b sa sb

theorem calls : Deterministic Call := by
  intro n args a b first second
  have invert : ∀ v, Call n args v → Square n args v ∨
      n = name .divB ∧ Body Square .divB args v ∨ n = name .divT ∧ Body Square .divT args v := by
    intro v source
    cases source with
    | square n args v source => exact Or.inl source
    | binary args v source => exact Or.inr (Or.inl ⟨rfl, source⟩)
    | ternary args v source => exact Or.inr (Or.inr ⟨rfl, source⟩)
  have squareNotB : ∀ v, Square (name .divB) args v → False := by
    intro v source
    have impossible := square_name (name .divB) args v source
    simp [name] at impossible
  have squareNotT : ∀ v, Square (name .divT) args v → False := by
    intro v source
    have impossible := square_name (name .divT) args v source
    simp [name] at impossible
  have binaryUnique := body_unique _ square .divB args a b
  have ternaryUnique := body_unique _ square .divT args a b
  have squareUnique := square n args a b
  have different : name .divB ≠ name .divT := by decide
  rcases invert a first with sa | ⟨na, ba⟩ | ⟨na, ta⟩
  all_goals rcases invert b second with sb | ⟨nb, bb⟩ | ⟨nb, tb⟩
  all_goals grind

end FT1536.Source3.KeygenPublicScalar095
