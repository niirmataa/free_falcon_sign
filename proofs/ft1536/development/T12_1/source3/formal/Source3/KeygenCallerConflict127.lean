import Source3.ActualRefill126

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCallerConflict127
open C99MemoryReference

/-- The active certificate representation reserves readonly FFT block1.
    Swapping scratch2 with0 leaves block1 unchanged. -/
theorem no_certificate_at_two (caller after : Memory) (args : CertificateFunctionReference.Arguments)
    (trace : List (BitVec 64)) (events : List CertificateEffects.Event) (ret : Bool)
    (writable : caller.writable 1=true) :
    ¬KeygenMakeCertRelocation.ExecAt 2 args caller after trace events ret := by
  intro execution
  have bound : 0<(FftTableSources.words .square).length := by
    rw [FftTableSources.words_length]
    decide
  have readonly := (execution.1.2 .square 0 bound).2
  change caller.writable 1=false at readonly
  rw [writable] at readonly
  cases readonly

theorem old_base_writable : (C99CompactState115.reference KeygenCallerData123.base).heap.writable 1=true := by
  change (C99FiniteMemory114.memory KeygenCallerData123.heap).writable 1=true
  rw [KeygenCallerMemory123.permissions,KeygenCallerShape123.external_permissions]
  decide

theorem old_base_not_certificate (after : Memory) (args : CertificateFunctionReference.Arguments)
    (trace : List (BitVec 64)) (events : List CertificateEffects.Event) (ret : Bool) :
    ¬KeygenMakeCertRelocation.ExecAt KeygenCallerData123.env.ctx.scratch.block args
      (C99CompactState115.reference KeygenCallerData123.base).heap after trace events ret :=
  no_certificate_at_two _ after args trace events ret old_base_writable

end FT1536.Source3.KeygenCallerConflict127
