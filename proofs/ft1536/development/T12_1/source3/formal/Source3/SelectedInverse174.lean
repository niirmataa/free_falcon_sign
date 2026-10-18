import Source3.PublicNormalizeStart174
import Source3.SelectedRoot174

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedInverse174
open C99ArrayReference (State)
open KeygenPublicExec (Exec)
open SelectedPublicBinding157 (h)

theorem exists_normalize : ∃ after,
    Exec KeygenPublicSource.program [] KeygenPublicNormalizeProgram.complete SelectedRoot174.after ⟨after,.normal⟩ ∧
      PublicNormalizeBody174.Fixed after h ∧ KeygenNttLoopSupport.USlot after "u" 1536 :=
  PublicNormalizeStart174.source SelectedRoot174.after h SelectedRoot174.data SelectedRoot174.binding
    SelectedRoot174.n_cell SelectedRoot174.profile SelectedRoot174.ni_type ⟨_,SelectedRoot174.u_cell⟩

noncomputable def normalized : State := Classical.choose exists_normalize

theorem normalize_source : Exec KeygenPublicSource.program [] KeygenPublicRootInverseProgram.remaining
    SelectedRoot174.after ⟨normalized,.normal⟩ := by
  rw [KeygenPublicNormalizeProgram.source_remaining]
  exact (Classical.choose_spec exists_normalize).1

noncomputable def body : State := PublicInverseBody172.bodyState
  (PublicForwardEntry159.entryT SelectedQuotient171.after h) 33 34 normalized

theorem body_source : Exec KeygenPublicSource.program [] (KeygenPublicSource.code .inverseT)
    (PublicForwardEntry159.entryT SelectedQuotient171.after h) ⟨body,.normal⟩ :=
  SelectedRoot174.continue_inverse normalized normalize_source

noncomputable def after : State := {SelectedQuotient171.after with heap:=body.heap}

theorem source : Exec KeygenPublicSource.program KeygenPublicInputProgram.signed
    KeygenPublicSuffixProgram.inverse SelectedQuotient171.after ⟨after,.normal⟩ :=
  PublicInverseEntry172.selected body body_source

end FT1536.Source3.SelectedInverse174
