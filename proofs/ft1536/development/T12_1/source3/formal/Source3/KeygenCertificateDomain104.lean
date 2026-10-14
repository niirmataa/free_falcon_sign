import Source3.KeygenCertificateFunction104

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCertificateDomain104
open C99MemoryReference
open C99ArrayReference (State)
open CertificateFunctionReference (Arguments)
open KeygenSearchContext (Context)

theorem arguments (ctx : Context) (before : State) (a b : Arguments)
    (first : KeygenMakeWorkspaceBridge.Cells before ctx a) (second : KeygenMakeWorkspaceBridge.Cells before ctx b)
    (baseA : a.base = ctx.scratch.offset) (baseB : b.base = ctx.scratch.offset) : a = b := by
  apply KeygenMakeCertRelocation.args_ext a b
  · exact baseA.trans baseB.symm
  · exact Option.some.inj (first.fCell.symm.trans second.fCell)
  · exact Option.some.inj (first.gCell.symm.trans second.gCell)
  · exact Option.some.inj (first.bigFCell.symm.trans second.bigFCell)
  · exact Option.some.inj (first.bigGCell.symm.trans second.bigGCell)
  · simpa using first.lognCell.symm.trans second.lognCell
  · simpa using first.terCell.symm.trans second.terCell

theorem profile (ctx : Context) (before : State) (args : Arguments)
    (cells : KeygenMakeWorkspaceBridge.Cells before ctx args)
    (dimensions : KeygenMakeSearchPrefix.Dimensions before) : CertificateFunctionReference.Profile args := by
  refine ⟨?_, ?_⟩
  · simpa using cells.lognCell.symm.trans dimensions.2.1
  · simpa using cells.terCell.symm.trans dimensions.2.2

theorem function_space (args : Arguments) (environment : CertificateFunctionReference.Environment)
    (before after : Memory) (trace : List (BitVec 64)) (events : List CertificateEffects.Event) (ret : Bool)
    (source : CertificateFunctionReference.Exec args environment before after trace events ret) :
    C99Automatic32.Space before := by
  cases source <;> assumption

theorem space (block : Nat) (args : Arguments) (before after : Memory)
    (trace : List (BitVec 64)) (events : List CertificateEffects.Event) (ret : Bool)
    (source : KeygenMakeCertRelocation.ExecAt block args before after trace events ret) :
    C99Automatic32.Space (KeygenMakeWorkspaceRelocation.swap block before) := by
  exact function_space _ _ _ _ _ _ _ source.2

theorem frame (ctx : Context) (before after : State) (args : Arguments)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx)
    (scratch : KeygenMkgm3Layout.Legal before.heap ctx.scratch)
    (base : args.base = ctx.scratch.offset)
    (trace : List (BitVec 64)) (events : List CertificateEffects.Event) (ret : Bool)
    (source : KeygenMakeCertRelocation.ExecAt ctx.scratch.block args before.heap after.heap trace events ret) :
    CertificateFrameEntry.Legal args.base (KeygenMakeWorkspaceRelocation.swap ctx.scratch.block before.heap) := by
  apply KeygenMakeWorkspaceBridge.legal_of_shape
    (KeygenMakeWorkspaceBridge.swapState ctx.scratch.block before)
    (KeygenMakeWorkspaceBridge.relocateCtx ctx.scratch.block ctx)
    (KeygenMakeWorkspaceBridge.swapArgs ctx.scratch.block args)
  · exact KeygenMakeWorkspaceAllocation.shape_relocated ctx.scratch.block ctx shape
  · exact KeygenMakeWorkspaceAllocation.legal_relocated ctx.scratch.block ctx before.heap scratch
  · exact KeygenMakeWorkspaceRelocation.swapBlock_self_zero ctx.scratch.block
  · exact space ctx.scratch.block args before.heap after.heap trace events ret source
  · exact base

end FT1536.Source3.KeygenCertificateDomain104
