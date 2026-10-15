import Source3.KeygenBoundModel135

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenBoundFrame135
open C99CompactState115 (State)
open KeygenBoundModel135

theorem frame (mc : B20.C.Scalar.Calls) (fuel : Nat) (code : KeygenSearchExec.Stmt)
    (before after : State) (computed : run mc fuel code before=some after) :
    after={before with locals := after.locals} := by
  induction fuel generalizing code before after with
  | zero => cases computed
  | succ fuel ih =>
    cases code with
    | procedure code =>
      cases code <;> try (solve | cases computed)
      case base base =>
        cases base <;> try (solve | cases computed)
        case skip =>
          have same := Option.some.inj computed
          subst after
          rfl
    | assign name expr =>
      obtain ⟨cell,declared,rest⟩ := Option.bind_eq_some_iff.mp computed
      obtain ⟨value,evaluated,result⟩ := Option.bind_eq_some_iff.mp rest
      have same := Option.some.inj result
      subst after
      rfl
    | seq first second =>
      obtain ⟨middle,head,tail⟩ := Option.bind_eq_some_iff.mp computed
      have firstFrame := ih first before middle head
      have secondFrame := ih second middle after tail
      rw [firstFrame] at secondFrame
      exact secondFrame
    | logn | pointer | store | move | small | scope | branch | loop => cases computed

end FT1536.Source3.KeygenBoundFrame135
