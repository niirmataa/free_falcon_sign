import Source3.KeygenMakeDimensions125

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenMakePrefix125
open C99CompactState115 (State reference)

theorem declaration_result (before after : State) (blocks : Fin 6 → Nat)
    (computed : KeygenMakeFresh125.run before blocks=some after) : after=KeygenMakeDeclare125.declared before blocks := by
  unfold KeygenMakeFresh125.run at computed
  split at computed
  · exact (Option.some.inj computed).symm
  · cases computed

theorem not_one (state : C99ArrayReference.State) : KeygenReadyFast.NotTest state 1 (.int32 0) := by
  exact .logicalNot _ (.int32 1) (.variable "$member".toList .int32 (.int32 1)
    (by simp [C99ScalarReference.set]))

def entry (env : KeygenMakeInvocation.Env) (before : State) : State :=
  C99CompactState115.bindPointer (C99CompactState115.bindValue
    (C99CompactState115.bindPointer (C99CompactState115.bindPointer
      (C99CompactState115.bindPointer (C99CompactState115.bindPointer (C99CompactState115.base before)
        "pubkey_len".toList env.args.pubkeyLen) "pubkey".toList env.args.pubkey)
      "privkey_len".toList env.args.privkeyLen) "privkey".toList env.args.privkey)
    "comp".toList .i32 (.i32 env.args.comp)) "fk".toList env.args.fk

theorem header_computed (env : KeygenMakeInvocation.Env) (before : State) :
    C99CompactBinding115.external before KeygenMakeArguments.params (KeygenMakeArguments.values env.args)=
      some (entry env before) := rfl

theorem header_source (env : KeygenMakeInvocation.Env) (before : State) :
    KeygenMakeArguments.Bind (reference before) KeygenMakeArguments.params (KeygenMakeArguments.values env.args)
      (reference (entry env before)) :=
  C99CompactBinding115.external_sound before (entry env before) _ _ (header_computed env before)

def run (env : KeygenMakeInvocation.Env) (before : State) (shakeFuel fuel : Nat) : Option State := do
  let objects ← KeygenMakeFresh125.run (entry env before) env.blocks
  let dimensioned ← KeygenMakeDimensions125.run env.ctx (KeygenMakeDimensions125.counted objects)
  KeygenPublicInput124.ready env.ctx dimensioned shakeFuel fuel

theorem run_sound (env : KeygenMakeInvocation.Env) (before after : State) (shakeFuel fuel : Nat)
    (computed : run env before shakeFuel fuel=some after) :
    KeygenMakeArguments.PrefixInvocation env.args env.ctx (reference before) env.blocks [] ⟨reference after,.normal⟩ := by
  let bound := entry env before
  obtain ⟨objects,allocated,rest⟩ := Option.bind_eq_some_iff.mp computed
  obtain ⟨dimensioned,dimensions,ready⟩ := Option.bind_eq_some_iff.mp rest
  have exactObjects := declaration_result bound objects env.blocks allocated
  subst objects
  have declarations := KeygenMakeFresh125.run_sound bound _ env.blocks allocated
  have call := KeygenPublicInput124.ready_sound env.ctx dimensioned after shakeFuel fuel ready
  refine .run (reference bound) [] ⟨reference after,.normal⟩
    (header_source env before) ?_
  exact .run _ _ (reference dimensioned) [] ⟨reference after,.normal⟩ declarations
    (KeygenMakeDimensions125.count_source bound env.blocks)
    (KeygenMakeDimensions125.run_sound env.ctx _ dimensioned dimensions)
    (.normal [] (reference after) 1 (.int32 0) call (not_one (reference after)) rfl)

end FT1536.Source3.KeygenMakePrefix125
