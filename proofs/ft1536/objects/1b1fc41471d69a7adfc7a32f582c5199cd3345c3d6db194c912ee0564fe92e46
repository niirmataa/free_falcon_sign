import Source3.CertificateAfterConversion
import Source3.C99HeapOnly

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.CertificateGramPrefix
open C99ArrayReference (State)
open C99ProcedureReference (Stmt Exec Result)

def linear : Stmt → List Stmt
  | .seq a b => a::linear b
  | .base .skip => []
  | a => [a]
def atoms : List Stmt := linear ((CertificateAfterConversion.parseRegion 7721 21).getD (.base .skip))
def headCode : Stmt := C99HeapOnly.fold atoms (.base .skip)
def tailCode : Stmt := (CertificateAfterConversion.parseRegion 7742 4).getD (.base .skip)

theorem head_source : CertificateAfterConversion.parseRegion 7721 21=some headCode := by decide
theorem tail_source : CertificateAfterConversion.parseRegion 7742 4=some tailCode := by decide
theorem full_source : CertificateAfterConversion.code=C99HeapOnly.fold atoms tailCode := by decide
theorem checked_atoms : atoms.all C99HeapOnly.only=true := by decide

theorem source_split (before : State) (result : Result)
    (source : Exec FftProcedurePrograms.program CertificateAfterConversion.code before result) :
    ∃ middle, Exec FftProcedurePrograms.program headCode before ⟨middle,.normal⟩ ∧
      middle={before with heap := middle.heap} ∧
      Exec FftProcedurePrograms.program tailCode middle result := by
  rw [full_source] at source
  obtain ⟨middle,head,tail⟩ := C99HeapOnly.before_tail FftProcedurePrograms.program atoms tailCode before result checked_atoms source
  have he := congrArg Result.state (C99HeapOnly.result_frame FftProcedurePrograms.program headCode before
    ⟨middle,.normal⟩ head (C99HeapOnly.fold_checked atoms checked_atoms))
  exact ⟨middle,head,he,tail⟩

end FT1536.Source3.CertificateGramPrefix
