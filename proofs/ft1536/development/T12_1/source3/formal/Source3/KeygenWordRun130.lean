import Source3.KeygenWordSteps130

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenWordRun130
open C99CompactState115 (State reference)
open KeygenWordExec (Stmt)

abbrev Result := State×Option B20.C.Val

def result (out : Result) : C99ProcedureReference.Result :=
  ⟨reference out.1,match out.2 with | none => .normal | some value => .returned (some (C99ValueBridge.value value))⟩

/-- Finite source checking, with actual guards and returns. Fuel exhaustion,
    unsupported modular code or an unsupported increment return gives no witness. -/
def run : Nat → Stmt → State → Option Result
  | 0, _, _ => none
  | fuel+1, .modular code, before => (C99ScalarSteps130.run fuel code before).map (fun after => (after,none))
  | _+1, .assign name expr, before => (KeygenWordSteps130.assign before name expr).map (fun after => (after,none))
  | _+1, .store name index expr, before => (KeygenWordSteps130.store before name index expr).map (fun after => (after,none))
  | fuel+1, .seq first second, before => do
      let out ← run fuel first before
      match out.2 with
      | none => run fuel second out.1
      | some _ => pure out
  | fuel+1, .scope locals body, before => do
      let out ← run fuel body before
      pure (C99CompactState115.restoreScope before out.1 locals [],out.2)
  | fuel+1, .branch condition yes no, before => do
      let value ← KeygenWordCompute130.evaluate before condition
      if value.integer=0 then run fuel no before else run fuel yes before
  | fuel+1, .loop condition body increment, before => do
      let value ← KeygenWordCompute130.evaluate before condition
      if value.integer=0 then pure (before,none) else do
        let out ← run fuel body before
        match out.2 with
        | some _ => pure out
        | none => do
            let next ← run fuel increment out.1
            match next.2 with
            | some _ => none
            | none => run fuel (.loop condition body increment) next.1
  | _+1, .ret expr, before =>
      (KeygenWordCompute130.evaluate before expr).map (fun value => (before,some value))

end FT1536.Source3.KeygenWordRun130
