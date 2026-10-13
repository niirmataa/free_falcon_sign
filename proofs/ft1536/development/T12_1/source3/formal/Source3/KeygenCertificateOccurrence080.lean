import Source3.KeygenCertificateAt080

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCertificateOccurrence080
open C99MemoryReference
open C99ArrayReference (State)
open C99IntegerReference (Value)
open KeygenSearchContext (Context)
open CertificateFunctionWitness (layout)
open KeygenMakeWorkspaceBridge (swapState relocateCtx swapArgs)
open KeygenMakeCertRelocation (CallAt SpaceAt)

/-- One call contains its own source execution, globals, gate trace, event
    stream and a single source witness used by BOTH snapshot and flag facts. -/
structure CanonicalOccurrence (ctx : Context) (before after : State) where
  args : CertificateFunctionReference.Arguments
  gateTrace : List (BitVec 64)
  events : List CertificateEffects.Event
  bind : KeygenMakeCertCall.CertBind before ctx args
  source : CertificateM0Environment.Exec args before.heap after.heap gateTrace events true
  syntaxBound : CertificateFunctionSyntax.Bound
  stored : CertificateFunctionOutcome.StoredBounds args before.heap after.heap
  dead : ∀ word : BitVec 32, ¬Load32 after.heap (C99Automatic32.pointer before.heap) word
  witness : CertificateFunctionWitness.Witness args before.heap after.heap gateTrace events true
  count : gateTrace.length=768
  good : ∀ event∈events, CertificateEffects.Good event
  clear : StableBinaryByteView.flagRead (C99MemoryBridge.encode witness.edge)
    (layout args before.heap).bad=some 0
  topState : CertificateEffects.State
  reverseState : CertificateEffects.State
  words : Fin 768 → BitVec 64
  top : CertificateTop.Exec (layout args before.heap) ⟨witness.gate,[]⟩ (CertificateEffects.decode topState)
  reverse : CertificateReverse.Finished (layout args before.heap) CertificateQSquared.word
    (CertificateEffects.decode topState) (CertificateEffects.decode reverseState)
  scan : CertificateScan.Exec (layout args before.heap) 0 (CertificateEffects.decode reverseState)
    ⟨witness.edge,events⟩
  firstSnapshot : CertificateReverse.Snapshot (layout args before.heap) words topState
  reverseSnapshot : CertificateReverse.Snapshot (layout args before.heap) words reverseState
  division : ∀ i : Fin 768,
    CertificateAtoms.read (layout args before.heap) (CertificateEffects.encode ⟨witness.edge,events⟩) i.val=some (words i) ∧
    ∃ raw, C99Frontend.primitiveCall "fpr_div".toList
      [.uint64 CertificateQSquared.word,.uint64 (words i)] (.uint64 raw) ∧
      CertificateAtoms.read (layout args before.heap) (CertificateEffects.encode ⟨witness.edge,events⟩)
        (1535-i.val)=some raw ∧ Run2.KeygenLeafGate.positive raw=true

theorem canonical (ctx : Context) (before after : State) (v : Value)
    (call : KeygenMakeCertCall.Call ctx before after v true)
    (dimensions : KeygenMakeSearchPrefix.Dimensions before)
    (workspace : KeygenMakeCertMaterial.LegalWorkspace before ctx) :
    Nonempty (CanonicalOccurrence ctx before after) := by
  cases call with
  | run args bind afterMem gateTrace events ret body v bit =>
    have profile := KeygenMakeCertCall.bind_callee_profile before ctx args bind dimensions
    have legal := workspace args bind
    obtain ⟨witness,count,positive,good,clear,leaves⟩ := CertificateFunctionWitness.accepted args
      FftGlobalMemory.environment before.heap afterMem gateTrace events profile legal body.2
    obtain ⟨topState,reverseState,words,top,reverse,scan,first,second,frame,division⟩ :=
      CertificateSuffix001Outcome.reverse_order (layout args before.heap) witness.gate witness.edge events
        witness.wellFormed witness.suffixLegal witness.suffix
    exact ⟨⟨args,gateTrace,events,bind,body,CertificateFunctionSyntax.bound,
      CertificateReturnedWords.accepted_stored_words args FftGlobalMemory.environment before.heap afterMem
        gateTrace events profile legal body.2,
      CertificateFunctionReference.bad_dead_after_return args FftGlobalMemory.environment before.heap afterMem
        gateTrace events true body.2,
      witness,count,good,clear,topState,reverseState,words,top,reverse,scan,first,second,division⟩⟩

def Package (ctx : Context) (before after : State) : Prop :=
  ∃ occurrence : CanonicalOccurrence (relocateCtx ctx.scratch.block ctx)
      (swapState ctx.scratch.block before) (swapState ctx.scratch.block after),
    KeygenMakeCertRelocation.StoredBoundsAt ctx.scratch.block (swapArgs ctx.scratch.block occurrence.args)
      before.heap after.heap ∧ KeygenMakeCertRelocation.DeadAt ctx.scratch.block before.heap after.heap

/-- The same source call, full source-linked snapshots, immutable globals,
    stored leaf bounds and flag lifetime in the actual relocated heap. -/
theorem from_call (ctx : Context) (before after : State) (v : Value)
    (call : CallAt ctx.scratch.block ctx before after v true)
    (dimensions : KeygenMakeSearchPrefix.Dimensions before)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx)
    (scratch : KeygenMkgm3Layout.Legal before.heap ctx.scratch)
    (space : SpaceAt ctx.scratch.block before.heap) : Package ctx before after := by
  obtain ⟨occurrence⟩ := canonical (relocateCtx ctx.scratch.block ctx)
    (swapState ctx.scratch.block before) (swapState ctx.scratch.block after) v call
    ((KeygenMakeCertRelocation.dimensions_swapState ctx.scratch.block before).mpr dimensions)
    (KeygenCertificateAt080.workspace ctx before shape scratch space)
  refine ⟨occurrence,?_,(KeygenMakeCertRelocation.deadAt_iff ctx.scratch.block before.heap after.heap).mpr occurrence.dead⟩
  apply (KeygenMakeCertRelocation.storedBoundsAt_iff ctx.scratch.block
    (swapArgs ctx.scratch.block occurrence.args) before.heap after.heap).mpr
  rw [KeygenMakeCertRelocation.swapArgs_swapArgs]
  exact occurrence.stored

end FT1536.Source3.KeygenCertificateOccurrence080
