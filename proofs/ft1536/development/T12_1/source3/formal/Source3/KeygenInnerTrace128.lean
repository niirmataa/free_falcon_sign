import Source3.KeygenRefillTrace128

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenInnerTrace128
open C99CompactState115 (State reference)
open ShakeProcessEvents128 (Proposal Result Event All)

def run (ctx : ShakeExtractSource.Layout) (propose : Proposal) (rngFuel block : Nat) : Nat → State → Option Result
  | 0, _ => none
  | fuel+1, before => do
      let (refilled,headEvents) ← KeygenRefillTrace128.refill ctx propose rngFuel block before
      let (next,accepted) ← KeygenSamplerTail121.tail refilled
      if accepted then pure (next,headEvents) else do
        let (after,tailEvents) ← run ctx propose rngFuel block fuel next
        pure (after,headEvents++tailEvents)

theorem run_sound (ctx : ShakeExtractSource.Layout) (propose : Proposal) (rngFuel block fuel : Nat)
    (before after : State) (events : List Event)
    (computed : run ctx propose rngFuel block fuel before=some (after,events)) (checked : All ctx events) :
    KeygenSamplerSource.Inner ctx (reference before) (reference after) := by
  induction fuel generalizing before after events with
  | zero => cases computed
  | succ fuel ih =>
      obtain ⟨headResult,refill,rest⟩ := Option.bind_eq_some_iff.mp computed
      rcases headResult with ⟨refilled,headEvents⟩
      dsimp only at rest
      obtain ⟨tailResult,tail,rest⟩ := Option.bind_eq_some_iff.mp rest
      rcases tailResult with ⟨next,accepted⟩
      cases accepted with
      | true =>
          obtain ⟨sameState,sameEvents⟩ := Prod.mk.inj (Option.some.inj rest)
          subst after
          subst events
          exact .accepted (reference before) (reference refilled) (reference next)
            (KeygenRefillTrace128.refill_sound ctx propose rngFuel block before refilled headEvents refill checked)
            (KeygenSamplerTail121.tail_sound refilled next true tail)
      | false =>
          dsimp only at rest
          obtain ⟨following,iteration,result⟩ := Option.bind_eq_some_iff.mp rest
          rcases following with ⟨last,tailEvents⟩
          obtain ⟨sameState,sameEvents⟩ := Prod.mk.inj (Option.some.inj result)
          subst after
          subst events
          exact .rejected (reference before) (reference refilled) (reference next) (reference last)
            (KeygenRefillTrace128.refill_sound ctx propose rngFuel block before refilled headEvents refill
              (ShakeProcessEvents128.left ctx _ _ checked))
            (KeygenSamplerTail121.tail_sound refilled next false tail)
            (ih next last tailEvents iteration (ShakeProcessEvents128.right ctx _ _ checked))

end FT1536.Source3.KeygenInnerTrace128
