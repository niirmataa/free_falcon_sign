import Source3.FprSqrtSyntax132
import Source3.C99CompactScalar115
import Source3.C99HeaderSound

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FprSqrtCompute132
open C99CompactCells115 (Locals Cell environment)
open C99CompactScalar115 (evaluate step run declareOne)
open FprSqrtSyntax132 (Code condition increment iteration loop lower)
open B20.C (Val)
open C99ValueBridge (value)

abbrev calls := FprPrimitives.headerCalls
abbrev referenceCalls := C99Frontend.headerCalls

def returning : List CLogic.Stmt → Locals → Option Val
  | [], _ => none
  | .ret expr::_, before => evaluate calls before expr
  | code::rest, before => do returning rest (← step calls before code)

theorem returning_sound (code : List CLogic.Stmt) (before : Locals) (out : Val)
    (computed : returning code before=some out) :
    C99ScalarReference.Exec referenceCalls (environment before) (C99Frontend.scalars code) (.returned (value out)) := by
  induction code generalizing before with
  | nil => cases computed
  | cons first rest ih =>
      cases first with
      | ret expr =>
          exact .seqReturn _ _ _ _ (.ret _ _ _
            (C99CompactScalar115.evaluate_sound _ _ C99HeaderSound.header_sound before expr out computed))
      | declare ty names | assign name expr | update name op expr =>
          simp only [returning] at computed
          obtain ⟨middle,head,tail⟩ := Option.bind_eq_some_iff.mp computed
          exact .seqNormal _ _ _ _ _
            (C99CompactScalar115.step_sound _ _ C99HeaderSound.header_sound before middle _ head) (ih middle tail)

def one (code : Code) (before : Locals) : Option Locals := do
  let inner ← run calls before code.round
  step calls (C99NameMap115.restore before inner (FprPrimitives.scalarDecls code.round)) increment

theorem one_sound (code : Code) (before after : Locals) (computed : one code before=some after) :
    C99ScalarReference.Exec referenceCalls (environment before) (iteration code) (.normal (environment after)) := by
  obtain ⟨inner,body,update⟩ := Option.bind_eq_some_iff.mp computed
  have source := C99CompactScalar115.run_sound _ _ C99HeaderSound.header_sound before inner code.round body
  have block := C99ScalarReference.Exec.blockNormal _ _ (FprPrimitives.scalarDecls code.round) _ source
  rw [← C99CompactCells115.environment_restore] at block
  exact .seqNormal _ _ _ _ _ block
    (C99CompactScalar115.step_sound _ _ C99HeaderSound.header_sound _ after increment update)

def iterateLoop (code : Code) : Nat → Locals → Option Locals
  | 0, _ => none
  | fuel+1, before => do
      let test ← evaluate calls before condition
      if CLogic.truth test then iterateLoop code fuel (← one code before) else some before

theorem repeat_sound (code : Code) (fuel : Nat) (before after : Locals)
    (computed : iterateLoop code fuel before=some after) :
    C99ScalarReference.Exec referenceCalls (environment before)
      (.while (C99Frontend.expression condition) (iteration code)) (.normal (environment after)) := by
  induction fuel generalizing before with
  | zero => cases computed
  | succ fuel ih =>
      obtain ⟨test,guard,rest⟩ := Option.bind_eq_some_iff.mp computed
      have evaluated := C99CompactScalar115.evaluate_sound _ _ C99HeaderSound.header_sound before condition test guard
      by_cases truth : CLogic.truth test=true
      · have nonzero : (value test).integer≠0 := by simpa [C99ExpressionSound.truth_value] using truth
        have continued : (one code before).bind (iterateLoop code fuel)=some after := by simpa [truth] using rest
        obtain ⟨middle,first,tail⟩ := Option.bind_eq_some_iff.mp continued
        exact .whileTrue _ _ _ _ _ _ evaluated nonzero (one_sound code before middle first) (ih middle tail)
      · have zero : (value test).integer=0 := by simpa [C99ExpressionSound.truth_value] using truth
        have same : before=after := Option.some.inj (by simpa [truth] using rest)
        subst after
        exact .whileFalse _ _ _ _ evaluated zero

def scopedLoop (code : Code) (fuel : Nat) (before : Locals) : Option Locals := do
  let initialized ← step calls (declareOne before .i32 ['i']) (.assign ['i'] (.literal .i32 0))
  let after ← iterateLoop code fuel initialized
  pure (C99NameMap115.restore before after [['i']])

theorem scoped_loop_sound (code : Code) (fuel : Nat) (before after : Locals)
    (computed : scopedLoop code fuel before=some after) :
    C99ScalarReference.Exec referenceCalls (environment before) (loop code) (.normal (environment after)) := by
  obtain ⟨initialized,initial,rest⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨last,repeated,result⟩ := Option.bind_eq_some_iff.mp rest
  have same := Option.some.inj result
  subst after
  rw [C99CompactCells115.environment_restore]
  exact .blockNormal _ _ _ _ (.seqNormal _ _ _ _ _
    (C99CompactScalar115.declareOne_sound referenceCalls before .i32 ['i'])
    (.seqNormal _ _ _ _ _
      (C99CompactScalar115.step_sound _ _ C99HeaderSound.header_sound _ initialized _ initial)
      (repeat_sound code fuel initialized last repeated)))

def initial (x : Val) : Locals := C99NameMap115.put [] ['x'] (Cell.converted .u64 x)

def execute (code : Code) (fuel : Nat) (x : Val) : Option Val := do
  let before ← run calls (initial x) code.pre
  let after ← scopedLoop code fuel before
  let out ← returning code.tail after
  pure (B20.C.cast .u64 out)

theorem execute_sound (code : Code) (fuel : Nat) (x out : Val)
    (computed : execute code fuel x=some out) :
    C99ScalarReference.FunctionExec referenceCalls (lower code) [value x] (value out) := by
  obtain ⟨before,pre,rest⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨after,looped,rest⟩ := Option.bind_eq_some_iff.mp rest
  obtain ⟨raw,returned,result⟩ := Option.bind_eq_some_iff.mp rest
  have same := Option.some.inj result
  subst out
  rw [C99ValueBridge.cast_matches]
  refine .call _ (environment (initial x)) (value raw) ?_ ?_
  · change C99ScalarReference.BindArgs [(C99IntegerReference.Ty.uint64,['x'])] [value x] _
    rw [initial,C99CompactCells115.environment_put,Cell.converted_reference]
    exact .cons _ _ _ _ _ _ .nil
  · exact .seqNormal _ _ _ _ _
      (C99CompactScalar115.run_sound _ _ C99HeaderSound.header_sound (initial x) before code.pre pre)
      (.seqNormal _ _ _ _ _ (scoped_loop_sound code fuel before after looped)
        (returning_sound code.tail after raw returned))

end FT1536.Source3.FprSqrtCompute132
