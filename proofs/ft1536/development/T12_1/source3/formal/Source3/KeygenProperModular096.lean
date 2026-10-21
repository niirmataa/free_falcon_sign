import Source3.KeygenModularDiv096
import Source3.KeygenModularRx096

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenProperModular096
open C99ArrayReference (Name)
open C99IntegerReference (Value)
open C99ModularReference

/-- The three composite source bodies require their actual arities. Scalar
    leaf FunctionExec already checks its own full parameter binding. The
    modp_Rx row is part of the decision-A stratum extension (2026-10-21). -/
def Arity (name : Name) (count : Nat) : Prop :=
  (name = "modp_R2".toList → count = 2) ∧ (name = "modp_div".toList → count = 5) ∧
    (name = "modp_Rx".toList → count = 4)

def Call (name : Name) (args : List Value) (out : Value) : Prop := ModCall name args out ∧ Arity name args.length

theorem two (args : List Value) (size : args.length = 2) : ∃ a b, args = [a, b] := by
  cases args with
  | nil => cases size
  | cons a tail =>
      cases tail with
      | nil => cases size
      | cons b rest =>
          have empty : rest.length = 0 := by simp only [List.length_cons] at size; omega
          have same : rest = [] := by simpa using empty
          subst rest
          exact ⟨a, b, rfl⟩

theorem four (args : List Value) (size : args.length = 4) : ∃ a b c d, args = [a, b, c, d] := by
  cases args with
  | nil => cases size
  | cons a tail =>
      cases tail with
      | nil => cases size
      | cons b tail =>
          cases tail with
          | nil => cases size
          | cons c tail =>
              cases tail with
              | nil => cases size
              | cons d rest =>
                  have empty : rest.length = 0 := by simp only [List.length_cons] at size; omega
                  have same : rest = [] := by simpa using empty
                  subst rest
                  exact ⟨a, b, c, d, rfl⟩

theorem five (args : List Value) (size : args.length = 5) : ∃ a b c d e, args = [a, b, c, d, e] := by
  cases args with
  | nil => cases size
  | cons a tail =>
      cases tail with
      | nil => cases size
      | cons b tail =>
          cases tail with
          | nil => cases size
          | cons c tail =>
              cases tail with
              | nil => cases size
              | cons d tail =>
                  cases tail with
                  | nil => cases size
                  | cons e rest =>
                      have empty : rest.length = 0 := by simp only [List.length_cons] at size; omega
                      have same : rest = [] := by simpa using empty
                      subst rest
                      exact ⟨a, b, c, d, e, rfl⟩

theorem calls : C99ScalarDeterminism089.Deterministic Call := by
  intro name args x y first second
  obtain ⟨first, arity⟩ := first
  obtain ⟨second, _⟩ := second
  have unique := C99ScalarDeterminism089.function_unique C99Frontend.noCalls C99ScalarCallsDeterminism089.no_calls
  cases first <;> cases second
  case r2.r2 =>
    obtain ⟨a, b, rfl⟩ := two args (arity.1 rfl)
    exact KeygenModularLeaf096.r2_unique a b x y (by assumption) (by assumption)
  case div.div =>
    obtain ⟨a, b, p, p0i, r, rfl⟩ := five args (arity.2.1 rfl)
    exact KeygenModularDiv096.source_unique a b p p0i r x y (by assumption) (by assumption)
  case rx.rx =>
    obtain ⟨a, b, c, d, rfl⟩ := four args (arity.2.2 rfl)
    exact KeygenModularRx096.source_unique a b c d x y (by assumption) (by assumption)
  all_goals exact unique _ _ _ _ (by assumption) (by assumption)

theorem source (name : Name) (args : List Value) (out : Value) (call : Call name args out) : ModCall name args out := call.1

theorem of_source (name : Name) (args : List Value) (out : Value) (arity : Arity name args.length)
    (call : ModCall name args out) : Call name args out := ⟨call, arity⟩

end FT1536.Source3.KeygenProperModular096
