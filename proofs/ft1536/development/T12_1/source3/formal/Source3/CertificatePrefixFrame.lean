import Source3.CertificateAfterConversion

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.CertificatePrefixFrame
open C99ArrayReference (State)
open CertificateAfterConversion

theorem checked_writes :
    C99ProcedureFootprint.only FftProcedureFrames.interfaces FftProcedureFrames.permissions context code=true := by decide

def Within (base : Nat) (s : State) : Prop :=
  ∀ name∈context, ∀ p, s.arrays name=some p →
    p.block=0 ∧ base≤p.offset ∧ p.base+p.elementBytes*p.count≤base+CertificateWorkspace.bytes

theorem source_frame (base : Nat) (before : State) (result : C99ProcedureReference.Result)
    (pointers : Within base before)
    (source : C99ProcedureReference.Exec FftProcedurePrograms.program code before result)
    (block offset : Nat)
    (outside : block≠0 ∨ offset<base ∨ base+CertificateWorkspace.bytes≤offset)
    (tables : C99PointerFootprint.TablesOutside before block offset) :
    result.state.heap.bytes block offset=before.heap.bytes block offset := by
  have ho : C99ArrayFrame.Outside before context block offset := by
    intro name hn p hp
    obtain ⟨hb,hl,hh⟩ := pointers name hn p hp
    rw [hb]
    omega
  exact (C99ProcedureFootprint.body_frame FftProcedurePrograms.program FftProcedureFrames.interfaces
    FftProcedureFrames.permissions FftProcedureFrames.aligned FftProcedureFrames.closed
    code before result source context checked_writes block offset ho tables).2.2

end FT1536.Source3.CertificatePrefixFrame
