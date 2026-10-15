import Source3.FprSqrtEight132
import Source3.FprSqrtMissing131
import Source3.KeygenNormLanguage094

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- A new versioned source closure, never a redefinition of frozen110.
   The added case executes the pinned C body with its original header calls. -/
namespace FT1536.Source3.FprScalarClosure132
open C99IntegerReference (Value)

def calls (name : B20.C.Name) (args : List Value) (out : Value) : Prop :=
  if name="fpr_sqrt".toList then FprSqrtEight132.SourceCall args out
  else KeygenSearchExec.ScalarCall name args out

theorem previous (name : B20.C.Name) (args : List Value) (out : Value)
    (source : KeygenSearchExec.ScalarCall name args out) : calls name args out := by
  by_cases named : name="fpr_sqrt".toList
  · subst name
    exact (FprSqrtMissing131.no_call args out source).elim
  · simpa only [calls,ite_eq_right named] using source

theorem unchanged (name : B20.C.Name) (args : List Value) (out : Value)
    (other : name≠"fpr_sqrt".toList) : calls name args out ↔ KeygenSearchExec.ScalarCall name args out := by
  simp only [calls,ite_eq_right other]

theorem deterministic : C99ScalarDeterminism089.Deterministic calls := by
  intro name args a b first second
  by_cases named : name="fpr_sqrt".toList
  · simp only [calls,named,ite_true] at first second
    exact FprSqrtEight132.unique args a b first second
  · simp only [calls,ite_eq_right named] at first second
    exact KeygenNormLanguage094.scalar_calls name args a b first second

theorem sqrt_eight : calls "fpr_sqrt".toList [.uint64 FprSqrtEight132.input] (.uint64 FprSqrtEight132.output) :=
  FprSqrtEight132.source

theorem strict_extension :
    calls "fpr_sqrt".toList [.uint64 FprSqrtEight132.input] (.uint64 FprSqrtEight132.output) ∧
    ¬KeygenSearchExec.ScalarCall "fpr_sqrt".toList [.uint64 FprSqrtEight132.input] (.uint64 FprSqrtEight132.output) :=
  ⟨sqrt_eight,FprSqrtMissing131.no_call _ _⟩

end FT1536.Source3.FprScalarClosure132
