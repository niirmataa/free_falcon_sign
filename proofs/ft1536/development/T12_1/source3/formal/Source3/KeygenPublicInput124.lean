import Source3.KeygenRngRun124

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicInput124
open C99CompactState115 (State reference)
open C99CompactPointer115 (noCalls)
open KeygenSeedEntry089 (Seed)
open KeygenSearchContext (Context)
open KeygenRngRun124 (run run_sound referenceResult)

def seed (env : KeygenMakeInvocation.Env) (before : State) (block : Nat) (bytes : Seed)
    (shakeFuel fuel : Nat) : Option State := do
  let (after,result) ← run env.ctx shakeFuel fuel KeygenRngProgram.setSeedCode
    (KeygenInputBytes124.entered env before block bytes)
  if result=some none then pure {KeygenInputBytes124.caller before block bytes with heap := after.heap} else none

theorem seed_sound (env : KeygenMakeInvocation.Env) (before after : State) (block : Nat) (bytes : Seed)
    (shakeFuel fuel : Nat) (computed : seed env before block bytes shakeFuel fuel=some after) :
    KeygenSeedEntry089.Seeded env (reference before) block bytes (reference after) := by
  obtain ⟨result,body,rest⟩ := Option.bind_eq_some_iff.mp computed
  rcases result with ⟨middle,returned⟩
  dsimp only at rest
  split at rest
  next exited =>
    subst returned
    have same := Option.some.inj rest
    subst after
    rw [C99CompactState115.reference_heap (KeygenInputBytes124.caller before block bytes) middle.heap,
      KeygenInputBytes124.source_caller]
    have source := run_sound env.ctx shakeFuel fuel KeygenRngProgram.setSeedCode
      (KeygenInputBytes124.entered env before block bytes) (middle,some none) body
    rw [KeygenInputBytes124.source_entry] at source
    exact .run _ ⟨reference middle,.returned none⟩ (KeygenSeedEntry089.binding env (reference before) block bytes) source rfl
  next rejected => cases rest

def ready (ctx : Context) (before : State) (shakeFuel fuel : Nat) : Option State := do
  let entry ← C99CompactBinding115.bind noCalls before KeygenRngReference.readyParams KeygenRngReference.readyArguments
  let (after,result) ← run ctx shakeFuel fuel KeygenRngProgram.readyCode entry
  if result=some (some 1) then pure {before with heap := after.heap} else none

theorem ready_sound (ctx : Context) (before after : State) (shakeFuel fuel : Nat)
    (computed : ready ctx before shakeFuel fuel=some after) :
    KeygenRngReference.Call ctx (reference before) [] (reference after) (.int32 1) := by
  obtain ⟨entry,binding,rest⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨result,body,rest⟩ := Option.bind_eq_some_iff.mp rest
  rcases result with ⟨middle,returned⟩
  dsimp only at rest
  split at rest
  next exited =>
    subst returned
    have same := Option.some.inj rest
    subst after
    rw [C99CompactState115.reference_heap before middle.heap]
    refine .run (reference entry) [] (referenceResult (middle,some (some 1))) (.int32 1)
      (C99CompactBinding115.bind_sound noCalls (C99CompactPointer115.noCalls_sound _) before entry
        KeygenRngReference.readyParams KeygenRngReference.readyArguments binding)
      (run_sound ctx shakeFuel fuel KeygenRngProgram.readyCode entry (middle,some (some 1)) body) ?_
    exact .value _ _
  next rejected => cases rest

end FT1536.Source3.KeygenPublicInput124
