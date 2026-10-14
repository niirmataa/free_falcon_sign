import Source3.SelectedCap126

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenAttemptSetup126
open C99CompactState115 (State reference bindPointer)
open C99CompactPointer115 (noCalls)
open KeygenSearchContext (Context)

def rtDeclared (before : State) : State :=
  KeygenMakeDeclare125.declare
    (C99CompactPointer115.declarePointer (C99CompactPointer115.declarePointer
      (C99CompactPointer115.declarePointer before "rt1".toList) "rt2".toList) "rt3".toList)
    .u64 ["norm".toList,"bound".toList]

theorem reference_declared (before : State) :
    reference (rtDeclared before)=KeygenCallerInit.rtDeclared (reference before) := by
  unfold rtDeclared
  rw [KeygenMakeDeclare125.reference_declare,C99CompactPointer115.declarePointer_reference,
    C99CompactPointer115.declarePointer_reference,C99CompactPointer115.declarePointer_reference]
  unfold C99DeclarationStatements.effect KeygenCallerInit.rtDeclared
  congr 1
  funext name
  by_cases first : name="rt1".toList <;> by_cases second : name="rt2".toList <;> by_cases third : name="rt3".toList
  all_goals simp_all [KeygenCallerInit.rtNames]

def Guard (ctx : Context) (before : State) : Prop :=
  KeygenRngOps124.ReadGuard ctx before ∧ KeygenSearchContext.PointerLegal ctx ∧
  C99FiniteRead114.read64 before.heap (KeygenSearchContext.field ctx 432 8)=some (KeygenSearchContext.pointerWord ctx) ∧
  KeygenSearchMemory.Cast ctx.scratch 8 (KeygenSearchMemory.view ctx.scratch 8)

instance guardDecidable (ctx : Context) (before : State) : Decidable (Guard ctx before) := by
  unfold Guard KeygenSearchContext.PointerLegal KeygenSearchMemory.Cast
  infer_instance

theorem pointer_source (ctx : Context) (before : State) (checked : Guard ctx before) :
    KeygenSearchExec.EvalPointer ctx (reference before) (.cast 8 .tmp) (KeygenSearchMemory.view ctx.scratch 8) :=
  .cast 8 .tmp ctx.scratch _
    (.tmp _ (.read checked.1.1 checked.1.2 checked.2.1
      (C99FiniteRead114.read64_sound before.heap _ _ checked.2.2.1))) checked.2.2.2

def run (ctx : Context) (before : State) : Option State := do
  let declared := rtDeclared before
  if Guard ctx declared then
    let first := bindPointer declared "rt1".toList (KeygenSearchMemory.view ctx.scratch 8)
    let q ← C99CompactPointer115.pointer noCalls first "rt1".toList (.var "n".toList)
    let second := bindPointer first "rt2".toList q
    let r ← C99CompactPointer115.pointer noCalls second "rt2".toList (.var "n".toList)
    pure (bindPointer second "rt3".toList r)
  else none

theorem run_sound (ctx : Context) (before after : State) (computed : run ctx before=some after) :
    KeygenCallerInit.Setup ctx (reference before) (reference after) := by
  unfold run at computed
  dsimp only at computed
  split at computed
  next checked =>
    obtain ⟨q,addressQ,rest⟩ := Option.bind_eq_some_iff.mp computed
    obtain ⟨r,addressR,result⟩ := Option.bind_eq_some_iff.mp rest
    have same := Option.some.inj result
    subst after
    rw [C99CompactState115.reference_bindPointer,C99CompactState115.reference_bindPointer,
      C99CompactState115.reference_bindPointer,reference_declared]
    refine .run (KeygenSearchMemory.view ctx.scratch 8) q r ?_ ?_ ?_
    · have source := pointer_source ctx (rtDeclared before) checked
      rw [reference_declared] at source
      exact source
    · have source := C99CompactPointer115.pointer_sound noCalls (C99CompactPointer115.noCalls_sound _)
        (bindPointer (rtDeclared before) "rt1".toList (KeygenSearchMemory.view ctx.scratch 8))
        "rt1".toList (.var "n".toList) q addressQ
      rw [C99CompactState115.reference_bindPointer,reference_declared] at source
      exact source
    · have source := C99CompactPointer115.pointer_sound noCalls (C99CompactPointer115.noCalls_sound _)
        (bindPointer (bindPointer (rtDeclared before) "rt1".toList (KeygenSearchMemory.view ctx.scratch 8)) "rt2".toList q)
        "rt2".toList (.var "n".toList) r addressR
      rw [C99CompactState115.reference_bindPointer,C99CompactState115.reference_bindPointer,reference_declared] at source
      exact source
  next rejected => cases computed

end FT1536.Source3.KeygenAttemptSetup126
