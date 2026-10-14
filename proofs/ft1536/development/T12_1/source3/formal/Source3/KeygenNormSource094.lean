import Source3.KeygenNormLanguage094

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenNormSource094
open C99ArrayReference (State)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)

theorem bound_checked : KeygenNormLanguage094.checkedCode KeygenAttemptNorm.boundCode = true := by decide
theorem raw_checked : KeygenNormLanguage094.checkedCode KeygenNormFrame.code = true := by decide
theorem head_checked : KeygenNormLanguage094.checkedCode KeygenAttemptNorm.headCode = true := by decide
theorem tail_checked : KeygenNormLanguage094.checkedCode KeygenAttemptNorm.tailCode = true := by decide

theorem bound_unique (ctx : Context) (before : State) (a b : Result)
    (first : KeygenSearchExec.Exec ctx KeygenAttemptNorm.boundCode before a)
    (second : KeygenSearchExec.Exec ctx KeygenAttemptNorm.boundCode before b) : a = b :=
  KeygenNormLanguage094.execution ctx _ before a b bound_checked first second

theorem raw_computation_unique (ctx : Context) (before : State) (a b : Result)
    (first : KeygenSearchExec.Exec ctx KeygenNormFrame.code before a)
    (second : KeygenSearchExec.Exec ctx KeygenNormFrame.code before b) : a = b :=
  KeygenNormLanguage094.execution ctx _ before a b raw_checked first second

theorem head_unique (ctx : Context) (before : State) (a b : Result)
    (first : KeygenSearchExec.Exec ctx KeygenAttemptNorm.headCode before a)
    (second : KeygenSearchExec.Exec ctx KeygenAttemptNorm.headCode before b) : a = b :=
  KeygenNormLanguage094.execution ctx _ before a b head_checked first second

theorem tail_unique (ctx : Context) (before : State) (a b : Result)
    (first : KeygenSearchExec.Exec ctx KeygenAttemptNorm.tailCode before a)
    (second : KeygenSearchExec.Exec ctx KeygenAttemptNorm.tailCode before b) : a = b :=
  KeygenNormLanguage094.execution ctx _ before a b tail_checked first second

theorem scaling_unique (before a b : State) (args : List C99ArrayReference.Arg)
    (first : KeygenAttemptFft.Call before args a) (second : KeygenAttemptFft.Call before args b) : a = b := by
  cases first
  cases second
  grind only [C99ArrayDeterminism089.parameters, C99ProcedureDeterminism094.execution]

theorem compare_unique (before : State) (a b : Value)
    (first : KeygenNormFrame.Compare before a) (second : KeygenNormFrame.Compare before b) : a = b := by
  cases first
  cases second
  grind only [C99ScalarCallsDeterminism089.array_scalar, → C99CompareObjects.exact_result]

theorem gate_unique (before : State) (a b : Result)
    (first : KeygenNormFrame.Gate before a) (second : KeygenNormFrame.Gate before b) : a = b := by
  cases first <;> cases second
  all_goals grind only [compare_unique]

theorem raw_unique (ctx : Context) (before : State) (a b : Result)
    (first : KeygenNormFrame.Exec ctx before a) (second : KeygenNormFrame.Exec ctx before b) : a = b := by
  cases first
  cases second
  grind only [raw_computation_unique, gate_unique]

theorem gs_unique (ctx : Context) (before : State) (a b : Result)
    (first : KeygenAttemptNorm.GS ctx before a) (second : KeygenAttemptNorm.GS ctx before b) : a = b := by
  cases first
  cases second
  grind only [head_unique, scaling_unique, tail_unique, gate_unique]

theorem norm_unique (ctx : Context) (before : State) (a b : Result)
    (first : KeygenAttemptNorm.Exec ctx before a) (second : KeygenAttemptNorm.Exec ctx before b) : a = b := by
  cases first <;> cases second
  all_goals grind only [bound_unique, raw_unique, gs_unique]

/-- Actual word/FPEMU execution, retaining rejection and normal results.
    No real FFT correctness or rounding-error premise is supplied. -/
noncomputable def norm (ctx : Context) (before : State) : Part Result where
  Dom := ∃ out, KeygenAttemptNorm.Exec ctx before out
  get domain := Classical.choose domain

theorem norm_spec (ctx : Context) (before : State) (out : Result) :
    out ∈ norm ctx before ↔ KeygenAttemptNorm.Exec ctx before out := by
  constructor
  · rintro ⟨domain, equal⟩
    have source := Classical.choose_spec domain
    rw [← equal]
    exact source
  · intro source
    let domain : ∃ result, KeygenAttemptNorm.Exec ctx before result := ⟨out, source⟩
    exact ⟨domain, norm_unique ctx before (Classical.choose domain) out (Classical.choose_spec domain) source⟩

end FT1536.Source3.KeygenNormSource094
