import Source3.KeygenCertificateReadonly080

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCertificateAt080
open C99ArrayReference (State)
open C99MemoryReference
open C99IntegerReference (Value)
open KeygenSearchContext (Context)
open KeygenMakeWorkspaceRelocation
open KeygenMakeWorkspaceBridge (swapState relocateCtx)
open KeygenMakeCertRelocation (CallAt SpaceAt)

theorem workspace (ctx : Context) (s : State)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx)
    (scratch : KeygenMkgm3Layout.Legal s.heap ctx.scratch)
    (space : SpaceAt ctx.scratch.block s.heap) :
    KeygenMakeCertMaterial.LegalWorkspace (swapState ctx.scratch.block s)
      (relocateCtx ctx.scratch.block ctx) :=
  KeygenMakeWorkspaceBridge.legalWorkspace_of_shape _ _
    (KeygenMakeWorkspaceAllocation.shape_relocated ctx.scratch.block ctx shape)
    (KeygenMakeWorkspaceAllocation.legal_relocated ctx.scratch.block ctx s.heap scratch)
    (relocated_scratch_block ctx.scratch)
    ((KeygenMakeCertRelocation.spaceAt_iff ctx.scratch.block s.heap).mp space)

/-- Relocation transports the source-derived frame back to every actual
    foreign block, including actual block0 and the static table blocks. -/
theorem call_frame (ctx : Context) (before after : State) (v : Value) (ret : Bool)
    (call : CallAt ctx.scratch.block ctx before after v ret)
    (dimensions : KeygenMakeSearchPrefix.Dimensions before)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx)
    (scratch : KeygenMkgm3Layout.Legal before.heap ctx.scratch)
    (space : SpaceAt ctx.scratch.block before.heap)
    (block : Nat) (separate : block≠ctx.scratch.block) :
    ShakeExtractFrame.SameBlock before.heap after.heap block := by
  have not0 : swapBlock ctx.scratch.block block≠0 := by
    intro equal
    have back := congrArg (swapBlock ctx.scratch.block) equal
    rw [swapBlock_self,swapBlock_zero] at back
    exact separate back
  have moved := KeygenCertificateReadonly080.call_same_block (relocateCtx ctx.scratch.block ctx)
    (swapState ctx.scratch.block before) (swapState ctx.scratch.block after) v ret call
    ((KeygenMakeCertRelocation.dimensions_swapState ctx.scratch.block before).mpr dimensions)
    (workspace ctx before shape scratch space) (swapBlock ctx.scratch.block block) not0
  refine ⟨size_function_swap_back ctx.scratch.block before.heap after.heap moved.1,
    writable_function_swap_back ctx.scratch.block before.heap after.heap moved.2.1,?_⟩
  intro offset
  have bytes := moved.2.2 offset
  change (swap ctx.scratch.block after.heap).bytes (swapBlock ctx.scratch.block block) offset=
    (swap ctx.scratch.block before.heap).bytes (swapBlock ctx.scratch.block block) offset at bytes
  simpa only [swap_bytes,swapBlock_self] using bytes

/-- No certificate outcome is supplied: both accepted and rejected source
    calls retain the caller object and immutable prime/reversal tables. -/
theorem entry_frame (ctx : Context) (before after : State) (v : Value) (ret : Bool)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx before input h primes rev)
    (dimensions : KeygenMakeSearchPrefix.Dimensions before)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx)
    (space : SpaceAt ctx.scratch.block before.heap)
    (call : CallAt ctx.scratch.block ctx before after v ret) :
    KeygenMakeRetryTransport.EntryFrame ctx before.heap after.heap primes rev := by
  have primeSeparate : primes.block≠ctx.scratch.block := by
    intro equal
    have readonly := initial.primeObject.2.2.2.1
    rw [equal,initial.scratch.2.2.2.2.2] at readonly
    cases readonly
  have revSeparate : rev.block≠ctx.scratch.block := by
    intro equal
    have readonly := initial.revSource.1
    rw [equal,initial.scratch.2.2.2.2.2] at readonly
    cases readonly
  have objectFrame := call_frame ctx before after v ret call dimensions shape initial.scratch
    space ctx.object.block (Ne.symm initial.contextScratch)
  have primeFrame := call_frame ctx before after v ret call dimensions shape initial.scratch
    space primes.block primeSeparate
  have revFrame := call_frame ctx before after v ret call dimensions shape initial.scratch
    space rev.block revSeparate
  exact ⟨objectFrame.1,objectFrame.2.1,fun offset _ => objectFrame.2.2 offset,
    primeFrame.2.2,revFrame.2.2⟩

theorem space_preserved (ctx : Context) (before after : Memory) (primes rev : ArrayPointer)
    (frame : KeygenMakeRetryTransport.EntryFrame ctx before after primes rev)
    (space : SpaceAt ctx.scratch.block before) : SpaceAt ctx.scratch.block after := by
  change C99Automatic32.align4 (after.size ctx.scratch.block)+4<2^64
  rw [frame.sizes]
  exact space

end FT1536.Source3.KeygenCertificateAt080
