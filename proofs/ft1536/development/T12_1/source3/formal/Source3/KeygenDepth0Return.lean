import Source3.KeygenDepth0Call

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Source control, independently of the memory frame: every completed
   ternary_depth0 call returns the literal 1. Calls embedded in the body
   restore ordinary caller flow even when their own body returns. -/
namespace FT1536.Source3.KeygenDepth0Return
open C99ArrayReference (State)
open C99ProcedureReference (Result Flow)

def Allowed (flow : Flow) : Prop := flow=.normal ∨ flow=.returned (some (.int32 1))
def one : C99ArrayReference.Expr := .scalar (.literal .i32 1)
def procedureOnly : C99ProcedureReference.Stmt → Bool
  | .base _ | .call _ _ _ => true
  | .seq a b | .branch _ a b | .loop _ a b => procedureOnly a && procedureOnly b
  | .scope _ _ body => procedureOnly body
  | .ret (some e) => decide (e=one)
  | .ret none | .breakLoop | .continueLoop => false

theorem procedure_flow (code : C99ProcedureReference.Stmt) (before : State) (out : Result)
    (source : C99ProcedureReference.Exec KeygenSearchFft.program code before out)
    (checked : procedureOnly code=true) : Allowed out.flow := by
  induction source with
  | base | call | loopFalse | loopBreak => exact Or.inl rfl
  | seqNormal a b before middle out first second ih1 ih2 => exact ih2 (Bool.and_eq_true_iff.mp checked).2
  | seqExit a b before out first exit ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | scope locals pointers body before out inner ih => exact ih checked
  | branchTrue condition yes no before out v guard nonzero body ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | branchFalse condition yes no before out v guard zero body ih => exact ih (Bool.and_eq_true_iff.mp checked).2
  | loopNormal condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
    exact ih3 checked
  | loopContinue condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
    exact ih3 checked
  | loopReturn condition body increment before after v ret guard nonzero iteration ih =>
    exact ih (Bool.and_eq_true_iff.mp checked).1
  | returnVoid | breakLoop | continueLoop => cases checked
  | returnValue s e v value =>
    have he : e=one := of_decide_eq_true checked
    subst e
    cases value with
    | scalar e v source =>
      have hv := KeygenNttForwardExec.literal_value s .i32 1 v source
      subst v
      exact Or.inr rfl

def only : KeygenSearchExec.Stmt → Bool
  | .procedure code => procedureOnly code
  | .seq a b | .branch _ a b | .loop _ a b => only a && only b
  | .scope _ _ body => only body
  | _ => true

theorem source_flow (ctx : KeygenSearchContext.Context) (code : KeygenSearchExec.Stmt)
    (before : State) (out : Result) (source : KeygenSearchExec.Exec ctx code before out)
    (checked : only code=true) : Allowed out.flow := by
  induction source with
  | procedure code before out source => exact procedure_flow code before out source checked
  | logn | pointer | assign | store32 | store64 | move | small | loopFalse => exact Or.inl rfl
  | seqNormal a b before middle out head tail ih1 ih2 => exact ih2 (Bool.and_eq_true_iff.mp checked).2
  | seqExit a b before out head exit ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | scope locals pointers body before out inner ih => exact ih checked
  | branchTrue condition yes no before out v guard nonzero body ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | branchFalse condition yes no before out v guard zero body ih => exact ih (Bool.and_eq_true_iff.mp checked).2
  | loopNormal condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
    exact ih3 checked
  | loopReturn condition body increment before after v ret guard nonzero iteration ih =>
    exact ih (Bool.and_eq_true_iff.mp checked).1

def audit (i : Fin 5) : Option Bool := (KeygenDepth0Source.parsed i).map only
theorem audit0 : audit 0=some true := by decide
theorem audit1 : audit 1=some true := by decide
theorem audit2 : audit 2=some true := by decide
theorem audit3 : audit 3=some true := by decide
theorem audit4 : audit 4=some true := by decide
theorem audit_all (i : Fin 5) : audit i=some true := by
  fin_cases i
  · exact audit0
  · exact audit1
  · exact audit2
  · exact audit3
  · exact audit4
theorem part_checked (i : Fin 5) : only (KeygenDepth0Source.part i)=true := by
  have h := audit_all i
  rw [audit,KeygenDepth0Source.parsed_part] at h
  exact Option.some.inj h
theorem sequence_checked (a b : KeygenSearchExec.Stmt) (ha : only a=true) (hb : only b=true) :
    only (.seq a b)=true := Bool.and_eq_true_iff.mpr ⟨ha,hb⟩
theorem code_checked : only KeygenDepth0Source.code=true :=
  sequence_checked _ _ (part_checked 0) (sequence_checked _ _ (part_checked 1)
    (sequence_checked _ _ (part_checked 2) (sequence_checked _ _ (part_checked 3)
      (sequence_checked _ _ (part_checked 4) rfl))))

theorem return_one (ctx : KeygenSearchContext.Context) (before after : State)
    (v : C99IntegerReference.Value) (source : KeygenDepth0Call.Call ctx before after v) : v=.int32 1 := by
  cases source with
  | run entry out v binding body returned =>
    rcases out with ⟨state,flow⟩
    have control := source_flow ctx KeygenDepth0Source.code entry ⟨state,flow⟩ body code_checked
    cases returned
    rcases control with hn | hr
    · cases hn
    · cases hr
      rfl

end FT1536.Source3.KeygenDepth0Return
