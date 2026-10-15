import Source3.KeygenWordRunSound130

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenWordEndpoints130
open C99CompactState115 (State reference)
open KeygenWordExec (Stmt Exec)

def normal (fuel : Nat) (code : Stmt) (before : State) : Option State := do
  let out ← KeygenWordRun130.run fuel code before
  match out.2 with | none => some out.1 | some _ => none

theorem normal_sound (fuel : Nat) (code : Stmt) (before after : State)
    (computed : normal fuel code before=some after) :
    Exec code (reference before) ⟨reference after,.normal⟩ := by
  obtain ⟨out,source,rest⟩ := Option.bind_eq_some_iff.mp computed
  rcases out with ⟨last,returned⟩
  dsimp only at rest
  cases returned with
  | some returned => cases rest
  | none =>
      have same := Option.some.inj rest
      subst after
      exact KeygenWordRunSound130.sound fuel code before (last,none) source

def returned (fuel : Nat) (code : Stmt) (before : State) : Option (State×B20.C.Val) := do
  let out ← KeygenWordRun130.run fuel code before
  match out.2 with | none => none | some value => some (out.1,value)

theorem returned_sound (fuel : Nat) (code : Stmt) (before after : State) (value : B20.C.Val)
    (computed : returned fuel code before=some (after,value)) :
    Exec code (reference before) ⟨reference after,.returned (some (C99ValueBridge.value value))⟩ := by
  obtain ⟨out,source,rest⟩ := Option.bind_eq_some_iff.mp computed
  rcases out with ⟨last,result⟩
  dsimp only at rest
  cases result with
  | none => cases rest
  | some result =>
      obtain ⟨sameState,sameValue⟩ := Prod.mk.inj (Option.some.inj rest)
      subst after value
      exact KeygenWordRunSound130.sound fuel code before (last,some result) source

end FT1536.Source3.KeygenWordEndpoints130
