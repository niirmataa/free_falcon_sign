import Source3.KeygenSecretInvocation081
import Source3.KeygenSecretLocal081

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenOutputMemory081
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env inputOf publicOf)

/-- Initial output objects are live and separate where later writes must
    preserve the other buffer/length cell. No output length or bytes appear. -/
structure Legal (env : Env) (caller : State) : Prop where
  privateLive : 0<caller.heap.size env.args.privkey.block
  privateLengthLive : 0<caller.heap.size env.args.privkeyLen.block
  publicLive : 0<caller.heap.size env.args.pubkey.block
  publicLengthLive : 0<caller.heap.size env.args.pubkeyLen.block
  privateLength : env.args.privkey.block≠env.args.privkeyLen.block
  privatePublic : env.args.privkey.block≠env.args.pubkey.block
  privatePublicLength : env.args.privkey.block≠env.args.pubkeyLen.block
  lengthPublic : env.args.privkeyLen.block≠env.args.pubkey.block
  lengthPublicLength : env.args.privkeyLen.block≠env.args.pubkeyLen.block
  publicLength : env.args.pubkey.block≠env.args.pubkeyLen.block

theorem bound_heap (env : Env) (caller : State) (out : Result)
    (frontier : KeygenMakeAssembly080.Frontier env caller out) : frontier.bound.heap=caller.heap := by
  rw [KeygenMakeArguments.bind_exact caller env.args frontier.bound frontier.binding]
  rfl

theorem external (env : Env) (caller : State) (out : Result)
    (frontier : KeygenMakeAssembly080.Frontier env caller out) (block : Nat)
    (live : 0<caller.heap.size block) : ∀ slot : Fin 6, block≠env.blocks slot := by
  intro slot equal
  have empty := KeygenMakeLifetime.prefix_empty env.ctx frontier.bound env.blocks frontier.events
    ⟨frontier.entry,.normal⟩ frontier.ready slot
  rw [bound_heap env caller out frontier,←equal] at empty
  omega

theorem internal (env : Env) (caller : State) (out : Result)
    (frontier : KeygenMakeAssembly080.Frontier env caller out) :
    ∀ a b : Fin 6, a≠b → env.blocks a≠env.blocks b := by
  have allocation : KeygenMakeObjects.Exec 0 (KeygenMakePrologue.projectionStart frontier.bound)
      env.blocks (KeygenMakePrologue.declared frontier.bound env.blocks) := by
    cases frontier.ready with
    | run objects initialized dimensioned events result declarations counter dimensions gate =>
      have equal : objects=KeygenMakePrologue.declared frontier.bound env.blocks := by cases declarations; rfl
      subst objects
      exact KeygenMakePrologue.allocation_projection frontier.bound _ env.blocks declarations
  intro a b different
  exact KeygenMakeObjects.distinct 0 _ _ env.blocks allocation a b (by omega) (by omega) different

theorem separation (env : Env) (caller : State) (out : Result)
    (frontier : KeygenMakeAssembly080.Frontier env caller out) (legal : Legal env caller) :
    KeygenSecretLocal081.Separation env := by
  have priv := external env caller out frontier env.args.privkey.block legal.privateLive
  have len := external env caller out frontier env.args.privkeyLen.block legal.privateLengthLive
  have distinct := internal env caller out frontier
  refine ⟨?_,?_,priv 5,legal.privateLength,legal.privatePublic,legal.privatePublicLength,
    legal.lengthPublic,legal.lengthPublicLength,Ne.symm (priv 4),distinct 4 5 (by decide),Ne.symm (len 4)⟩
  · intro slot
    exact Ne.symm (priv ⟨slot.val,by have bound:=slot.isLt; omega⟩)
  · intro slot
    apply distinct ⟨slot.val,by have bound:=slot.isLt; omega⟩ 5
    intro equal
    have values := congrArg Fin.val equal
    have bound := slot.isLt
    simp only [show (5 : Fin 6).val=5 from rfl] at values
    omega

/-- Allocation and source metadata frames derive legality of all FOUR
    serialization arrays at the actual accepted-loop output. -/
theorem material_legal (env : Env) (caller : State) (out : Result) (primes rev : ArrayPointer)
    (frontier : KeygenMakeAssembly080.Frontier env caller out)
    (legal : KeygenMakeAssembly080.LegalEntry env caller primes rev) :
    KeygenInt16FourMaterial076.Legal frontier.loopOut.state.heap (inputOf env) := by
  have boundEq := KeygenMakeArguments.bind_exact caller env.args frontier.bound frontier.binding
  have original : KeygenMakeEntry.Original env.ctx frontier.bound primes rev := by rw [boundEq]; exact legal.original
  have shape : KeygenMakeWorkspaceBridge.Shape env.ctx := ⟨legal.workspaceExtent,legal.workspaceAligned⟩
  have space : KeygenMakeCertRelocation.SpaceAt env.ctx.scratch.block frontier.entry.heap := by
    change C99Automatic32.align4 (frontier.entry.heap.size env.ctx.scratch.block)+4<2^64
    rw [KeygenEntryAt080.scratch_size env.ctx frontier.bound frontier.entry env.blocks primes rev frontier.events original frontier.ready,
      bound_heap env caller out frontier]
    exact legal.workspaceSpace
  have facts := KeygenEntryAt080.entry_facts env.ctx frontier.bound frontier.entry env.blocks primes rev frontier.events original frontier.ready
  have remaining := KeygenMakeLoopChronology.entry_remaining env frontier.bound frontier.entry primes rev frontier.events original frontier.ready
  have frame := (KeygenLoopMaterial080.material env.ctx frontier.entry frontier.loopOut frontier.attempts frontier.loop
    (inputOf env) (publicOf env) primes rev shape 0 remaining facts space frontier.loopNormal).2
  intro slot
  have before : KeygenPublicInputMaterial.Legal frontier.entry.heap (inputOf env slot) :=
    KeygenMakeStatementMachine.legal_of_pointer frontier.entry.heap env.blocks
      ⟨slot.val,Nat.lt_trans slot.isLt (by decide : 4<6)⟩
      (by change slot.val<5; exact Nat.lt_trans slot.isLt (by decide : 4<5)) (facts.initial.allocated slot)
  exact KeygenMakeAttemptSpine.legal_same_size _ _ _ frame.sizes.symm before

theorem after_return (env : Env) (caller : State) (out : Result)
    (frontier : KeygenMakeAssembly080.Frontier env caller out) (legal : Legal env caller)
    (packet : List (BitVec 8))
    (observed : KeygenSecretObserved081.ObservedSecret env.args.privkey env.args.privkeyLen frontier.tailOut.state.heap packet) :
    KeygenSecretObserved081.ObservedSecret env.args.privkey env.args.privkeyLen out.state.heap packet := by
  rw [frontier.output]
  exact KeygenSecretObserved081.preserved _ _ _ _ packet
    (KeygenMakeLifetime.close_outside frontier.bound env.blocks frontier.tailOut env.args.privkey.block
      (fun slot => Ne.symm (external env caller out frontier _ legal.privateLive slot)))
    (KeygenMakeLifetime.close_outside frontier.bound env.blocks frontier.tailOut env.args.privkeyLen.block
      (fun slot => Ne.symm (external env caller out frontier _ legal.privateLengthLive slot))) observed

end FT1536.Source3.KeygenOutputMemory081
